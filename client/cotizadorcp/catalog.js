// =========================================================================
// ---------------------------
// CLIENTES (Perfiles)
// ---------------------------
let clientProfiles = [];
let clientProfilesById = {};

async function loadClientProfilesForQuoteModal() {
    const sel = document.getElementById('cli-select');
    const hid = document.getElementById('cli-id');
    if (!sel || !window.finSupabase) return;

    try {
        const { data, error } = await window.finSupabase
            .from('clientes')
            .select('id,nombre_completo,telefono,correo,rfc')
            .order('nombre_completo', { ascending: true });

        if (error) throw error;

        clientProfiles = data || [];
        clientProfilesById = {};
        clientProfiles.forEach(c => clientProfilesById[c.id] = c);

        sel.innerHTML = '<option value="">— Capturar manualmente —</option>' + clientProfiles
            .map(c => `<option value="${c.id}">${(c.nombre_completo || '').toUpperCase()}</option>`)
            .join('');

        sel.onchange = () => {
            const id = sel.value;
            if (!id) {
                if (hid) hid.value = '';
                return;
            }
            const c = clientProfilesById[id];
            if (!c) return;
            if (hid) hid.value = id;
            const n = document.getElementById('cli-name');
            const p = document.getElementById('cli-phone');
            const e = document.getElementById('cli-email');
            const r = document.getElementById('cli-rfc');
            if (n) n.value = c.nombre_completo || '';
            if (p) p.value = (c.telefono || '');
            if (e) e.value = (c.correo || '');
            if (r) r.value = (c.rfc || '');
        };

        const clearAssoc = () => {
            if (sel.value) sel.value = '';
            if (hid) hid.value = '';
        };
        ['cli-name','cli-phone','cli-email','cli-rfc'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.addEventListener('input', clearAssoc);
        });
    } catch (e) {
        console.warn("No se pudo cargar clientes", e);
    }
}

// MÓDULO DE CATÁLOGO
// =========================================================================
const SB_URL = (window.HUB_CONFIG && window.HUB_CONFIG.supabaseUrl) || 'http://127.0.0.1:54321';
const SB_KEY = (window.HUB_CONFIG && window.HUB_CONFIG.supabaseAnonKey) || 'TU_ANON_KEY';
const __p = window.location.pathname || '';
const __isCP = /\/cotizadorcp(\/|$)/.test(__p) || (window.location.href || '').includes('cotizadorcp');
const FIN_SCHEMA = __isCP ? 'finanzas_casadepiedra' : ((window.HUB_CONFIG && window.HUB_CONFIG.finanzasSchema) || 'finanzas');
let allSpaces = [], catalogConcepts = [], dbTaxes = [], currentSpace = null, currentConcepts = [], currentPricing = { base:0, final:0 };
let myPermissions = { access:false, catalog_manage:false };

function parseIds(v){ if(!v) return []; if(Array.isArray(v)) return v; if(typeof v === 'string'){ try { const parsed = JSON.parse(v); return Array.isArray(parsed) ? parsed : []; } catch(e){ return v.split(',').map(x=>x.trim()).filter(Boolean); } } return []; }
function formatMoney(v){ return new Intl.NumberFormat('es-MX', { style: 'currency', currency: 'MXN' }).format(v || 0); }

function calculateDayByDayTotal(space, startStr, endStr, guests) {
    if (!startStr || !endStr) return { total: 0, details: [] };
    
    let rules = [];
    if (space.precios_por_dia) {
        if (Array.isArray(space.precios_por_dia)) rules = space.precios_por_dia;
        else rules = [{ min: 0, max: 999999, precios: space.precios_por_dia }];
    } else {
        rules = [{ min: 0, max: 999999, precios: {lunes: space.precio_base||0, martes:space.precio_base||0, miercoles:space.precio_base||0, jueves:space.precio_base||0, viernes:space.precio_base||0, sabado:space.precio_base||0, domingo:space.precio_base||0} }];
    }

    const guestCount = parseInt(guests) || 1;
    let activeRule = rules.find(r => guestCount >= r.min && guestCount <= r.max);
    if (!activeRule) {
        if (guestCount > 0) activeRule = rules.reduce((prev, current) => (prev.max > current.max) ? prev : current);
        else activeRule = rules[0];
    }
    
    const prices = activeRule ? (activeRule.precios || {}) : {};
    let total = 0;
    let details = [];
    const start = new Date(startStr + 'T00:00:00'); 
    const end = new Date(endStr + 'T00:00:00');
    
    const keys = ['domingo', 'lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado'];
    const names = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];

    // LECTURA DE DÍAS BLOQUEADOS
    let blockedDays = [];
    try { blockedDays = typeof space.dias_bloqueados === 'string' ? JSON.parse(space.dias_bloqueados) : (space.dias_bloqueados || []); } catch(e){}

    for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
        const dayIdx = d.getDay();
        const key = keys[dayIdx];
        
        // Si el día está explícitamente bloqueado, o su precio es 0, no suma (o lanza error logico en front)
        let price = parseFloat(prices[key] || 0);
        if (blockedDays.includes(key)) price = 0;

        total += price;
        details.push({ date: d.toLocaleDateString('es-MX'), dayName: names[dayIdx], price: price, ruleMin: activeRule?.min, ruleMax: activeRule?.max });
    }
    return { total, details };
}

document.addEventListener('DOMContentLoaded', async () => {
    if (window.supabase) {
        if(!window.finSupabase) window.finSupabase = window.supabase.createClient(SB_URL, SB_KEY, { db: { schema: FIN_SCHEMA } });
        if(!window.globalSupabase) window.globalSupabase = window.supabase.createClient(SB_URL, SB_KEY);
    }
    const { data: { session } } = await window.globalSupabase.auth.getSession();
    if (!session) return;
    const { data: profile } = await window.globalSupabase.from('profiles').select('*').eq('id', session.user.id).single();

    const userRole = String(profile?.role || '').toLowerCase().trim();
    const roleHasAccess = (userRole === 'admin') || (userRole === 'casa_de_piedra') || (userRole === 'ambos');
    const roleDefaultPerms = { access: true, orders_view: true, reports_view: true, clients_view: true, clients_manage: true };

    if (userRole === 'admin') myPermissions = { ...roleDefaultPerms, catalog_manage: true };
    else if (roleHasAccess) myPermissions = { ...roleDefaultPerms, catalog_manage: false };
    else myPermissions = profile.app_metadata?.finanzas?.permissions || { access: false };

    if (!myPermissions.access) return window.showToast?.('No tienes permisos para acceder.', 'error');
    if (userRole !== 'admin') {
        const navRules = { 'orders.html': ('orders_view' in myPermissions) ? !!myPermissions.orders_view : true, 'reports.html': ('reports_view' in myPermissions) ? !!myPermissions.reports_view : true, 'clientes.html': (('clients_view' in myPermissions) || ('clients_manage' in myPermissions)) ? (!!myPermissions.clients_view || !!myPermissions.clients_manage) : true };
        Object.keys(navRules).forEach(page => { if (!navRules[page]) { const link = document.querySelector(`a[href="${page}"]`); if (link) link.classList.add('hidden'); } });
    }

    if (myPermissions.catalog_manage) { const btn = document.getElementById('btn-new-space'); if(btn) btn.classList.remove('hidden'); }

	await loadTaxes();
	await loadClientProfilesForQuoteModal();
    loadCatalog();
    const { data } = await window.finSupabase.from('conceptos_catalogo').select('*').eq('activo', true);
    catalogConcepts = data || [];

    document.getElementById('mgr-type')?.addEventListener('change', function() { const f=document.getElementById('mgr-file'); if(this.value==='espacio') f.setAttribute('multiple',''); else f.removeAttribute('multiple'); });

    const dStart = document.getElementById('date-start'); const dEnd = document.getElementById('date-end');
    if(dStart && dEnd) {
        dStart.addEventListener('change', function() { dEnd.min = this.value; if (dEnd.value && dEnd.value < this.value) { dEnd.value = this.value; } window.updateQuoteCalculation(); window.checkAvailability(); });
        dEnd.addEventListener('change', function() { window.updateQuoteCalculation(); window.checkAvailability(); });
    }
});

async function loadTaxes() { const { data } = await window.finSupabase.from('impuestos').select('*'); dbTaxes = data || []; }
async function loadCatalog() { const { data } = await window.finSupabase.from('espacios').select('*').order('id'); allSpaces = data||[]; renderSpaces(allSpaces); }

function renderSpaces(list) { 
    const g = document.getElementById('spaces-grid'); g.innerHTML=''; 
    if(list.length === 0) { g.innerHTML = '<div class="col-span-full text-center py-10 text-gray-400 font-bold">No se encontraron espacios.</div>'; return; }
    
    list.forEach(s => { 
        let adjustedBase = parseFloat(s.precio_base);
        let badgeHTML = '';

        if(s.ajuste_tipo === 'aumento') { adjustedBase += s.precio_base * (s.ajuste_porcentaje/100); badgeHTML = `<div class="absolute top-2 left-2 bg-green-500 text-white text-[10px] font-bold px-2 py-1 rounded shadow-md z-10 flex items-center gap-1"><i class="fa-solid fa-arrow-trend-up"></i> +${s.ajuste_porcentaje}%</div>`; }
        if(s.ajuste_tipo === 'descuento') { adjustedBase -= s.precio_base * (s.ajuste_porcentaje/100); badgeHTML = `<div class="absolute top-2 left-2 bg-red-500 text-white text-[10px] font-bold px-2 py-1 rounded shadow-md z-10 flex items-center gap-1"><i class="fa-solid fa-tag"></i> -${s.ajuste_porcentaje}%</div>`; }

        let totalTax = 0; const sTaxes = parseIds(s.impuestos_ids);
        if(sTaxes.length > 0 && dbTaxes.length > 0) { sTaxes.forEach(taxId => { const t = dbTaxes.find(x => String(x.id) === String(taxId)); if(t) { const rate = t.porcentaje > 1 ? t.porcentaje / 100 : t.porcentaje; totalTax += adjustedBase * rate; } }); }
        const finalPrice = adjustedBase + totalTax; const taxOnlyAmount = finalPrice - adjustedBase;
        
        let priceDisplay = '';
        if(totalTax > 0) priceDisplay = `<div class="text-right leading-none"><p class="text-[10px] text-gray-400 font-bold mb-0.5 line-through decoration-gray-400">${formatMoney(adjustedBase)}</p><p class="text-[10px] text-red-500 font-bold mb-0.5">+ ${formatMoney(taxOnlyAmount)} (IVA)</p><p class="font-black text-lg text-gray-900">${formatMoney(finalPrice)}</p></div>`;
        else priceDisplay = `<p class="font-black text-gray-800 text-lg">${formatMoney(finalPrice)}</p>`;
        
        let displayImg = '../../assets/img/no-image.svg';
        if (s.imagen_url) { if (s.imagen_url.trim().startsWith('[')) { try { const parsed = JSON.parse(s.imagen_url); if (parsed.length > 0) displayImg = parsed[0]; } catch (e) { displayImg = s.imagen_url; } } else { displayImg = s.imagen_url; } }
        
        const editBtn = myPermissions.catalog_manage ? `<button onclick="window.openManagerModal(${s.id})" class="absolute top-3 right-3 bg-white/90 text-gray-700 p-2 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition-all z-10"><i class="fa-solid fa-pen"></i></button>` : '';
        g.innerHTML += `<div class="bg-white rounded-xl shadow-md relative group hover:shadow-2xl transition-all duration-300 hover:-translate-y-1 overflow-hidden border border-gray-100"><div class="h-48 bg-gray-200 relative overflow-hidden">${editBtn}${badgeHTML}<img src="${displayImg}" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"><div class="absolute bottom-3 left-4 text-white z-10"><p class="text-[10px] font-bold uppercase tracking-wider bg-brand-red px-2 py-0.5 rounded inline-block mb-1">${s.tipo}</p><h3 class="font-bold text-lg leading-tight shadow-black drop-shadow-md">${s.nombre}</h3></div></div><div class="p-5"><div class="flex justify-between items-center mb-4"><p class="text-xs text-gray-400 font-mono"><i class="fa-solid fa-tag mr-1"></i>${s.clave}</p>${priceDisplay}</div><p class="text-xs text-gray-500 line-clamp-2 mb-4 h-8">${s.descripcion || 'Sin descripción disponible.'}</p><div class="border-t pt-3"><button onclick="window.openQuoteModal(${s.id})" class="bg-gray-900 text-white w-full py-2.5 rounded-lg text-xs font-bold uppercase tracking-wide hover:bg-brand-red transition-colors duration-300 shadow-lg"><i class="fa-solid fa-calculator mr-2"></i> Cotizar Ahora</button></div></div></div>`;
    }); 
}

window.addRangeRow = function(data = null) {
    const container = document.getElementById('mgr-ranges-container');
    const id = Date.now() + Math.random().toString(36).substr(2, 5);
    const min = data ? data.min : 1; const max = data ? data.max : 100;
    const prices = data ? data.precios : {lunes:0, martes:0, miercoles:0, jueves:0, viernes:0, sabado:0, domingo:0};

    const row = document.createElement('div');
    row.className = "range-row bg-gray-50 p-3 rounded-lg border border-gray-200 relative animate-enter";
    row.id = `range-${id}`;
    
    row.innerHTML = `
        <div class="flex justify-between items-center mb-2">
            <div class="flex items-center gap-2">
                <span class="text-[10px] font-bold uppercase text-brand-red bg-red-50 px-2 py-0.5 rounded">Rango</span>
                <input type="number" class="range-min w-16 border rounded text-xs p-1 text-center font-bold" placeholder="Min" value="${min}">
                <span class="text-xs text-gray-400">-</span>
                <input type="number" class="range-max w-16 border rounded text-xs p-1 text-center font-bold" placeholder="Max" value="${max}">
                <span class="text-[10px] font-bold uppercase text-gray-400 ml-1">Personas</span>
            </div>
            <button onclick="document.getElementById('range-${id}').remove()" class="text-gray-400 hover:text-red-500 text-xs"><i class="fa-solid fa-trash"></i></button>
        </div>
        <div class="grid grid-cols-4 gap-2">
            <div><label class="text-[9px] uppercase font-bold text-gray-400">Lun</label><input type="number" value="${prices.lunes}" class="p-lun w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div>
            <div><label class="text-[9px] uppercase font-bold text-gray-400">Mar</label><input type="number" value="${prices.martes}" class="p-mar w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div>
            <div><label class="text-[9px] uppercase font-bold text-gray-400">Mié</label><input type="number" value="${prices.miercoles}" class="p-mie w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div>
            <div><label class="text-[9px] uppercase font-bold text-gray-400">Jue</label><input type="number" value="${prices.jueves}" class="p-jue w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div>
            <div><label class="text-[9px] uppercase font-bold text-gray-400">Vie</label><input type="number" value="${prices.viernes}" class="p-vie w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div>
            <div><label class="text-[9px] uppercase font-bold text-gray-400">Sáb</label><input type="number" value="${prices.sabado}" class="p-sab w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div>
            <div><label class="text-[9px] uppercase font-bold text-gray-400">Dom</label><input type="number" value="${prices.domingo}" class="p-dom w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div>
        </div>
    `;
    container.appendChild(row);
}

window.openManagerModal = function(id){
    if (!myPermissions.catalog_manage) return window.showToast("No tienes permisos.", "error"); 
    document.getElementById('mgr-id').value = id || ''; 
    const container = document.getElementById('mgr-taxes-list'); 
    
    // Reset dias bloqueados checkboxes
    document.querySelectorAll('.day-block-check').forEach(cb => cb.checked = false);

    if(container) {
        container.innerHTML = '';
        let currentTaxes = [];
        if(id) { const s = allSpaces.find(x => x.id === id); currentTaxes = parseIds(s.impuestos_ids); }
        dbTaxes.forEach(t => {
            const isChecked = currentTaxes.some(cid => String(cid) === String(t.id)) ? 'checked' : '';
            container.innerHTML += `<label class="flex items-center gap-2 p-2 border rounded bg-white hover:bg-gray-50 cursor-pointer"><input type="checkbox" value="${t.id}" class="tax-check accent-brand-red cursor-pointer" ${isChecked}><span class="text-[10px] font-bold uppercase text-gray-600 cursor-pointer select-none">${t.nombre} (${t.porcentaje}%)</span></label>`;
        });
    }

    const rangesContainer = document.getElementById('mgr-ranges-container');
    rangesContainer.innerHTML = '';

    if(id) { 
        const s = allSpaces.find(x => x.id === id); 
        document.getElementById('mgr-title').innerText = "Editar: " + s.nombre; 
        document.getElementById('mgr-key').value = s.clave; document.getElementById('mgr-key').disabled = true; 
        document.getElementById('mgr-name').value = s.nombre; document.getElementById('mgr-type').value = s.tipo; 
        document.getElementById('mgr-desc').value = s.descripcion || ''; 
        
        let rules = [];
        if (s.precios_por_dia) { if (Array.isArray(s.precios_por_dia)) rules = s.precios_por_dia; else rules = [{min: 1, max: 9999, precios: s.precios_por_dia}]; } 
        else { rules = [{min: 1, max: 100, precios: {lunes:0, martes:0, miercoles:0, jueves:0, viernes:0, sabado:0, domingo:0}}]; }
        rules.forEach(rule => window.addRangeRow(rule));

        // Cargar días bloqueados
        let blockedDays = [];
        try { blockedDays = typeof s.dias_bloqueados === 'string' ? JSON.parse(s.dias_bloqueados) : (s.dias_bloqueados || []); } catch(e){}
        document.querySelectorAll('.day-block-check').forEach(cb => {
            if(blockedDays.includes(cb.value)) cb.checked = true;
        });

        document.getElementById('mgr-adj-type').value = s.ajuste_tipo || 'ninguno'; 
        document.getElementById('mgr-adj-pct').value = s.ajuste_porcentaje || 0; 
        document.getElementById('mgr-active').checked = s.activa !== false; 
        document.getElementById('btn-delete-mgr').classList.remove('hidden');
        if(s.imagen_url) { document.getElementById('mgr-preview').src = s.imagen_url.startsWith('[') ? JSON.parse(s.imagen_url)[0] : s.imagen_url; document.getElementById('mgr-preview').classList.remove('hidden'); }
    } else { 
        document.getElementById('mgr-title').innerText = "Nuevo Espacio"; 
        document.getElementById('mgr-key').value = ''; document.getElementById('mgr-key').disabled = false; 
        document.getElementById('mgr-name').value = ''; 
        window.addRangeRow();
        document.getElementById('mgr-desc').value = ''; document.getElementById('mgr-active').checked = true; 
        document.getElementById('btn-delete-mgr').classList.add('hidden');
        document.getElementById('mgr-preview').src = ''; document.getElementById('mgr-preview').classList.add('hidden');
    } 
    window.openModal('manager-modal');
}

window.saveSpace = async function(){ 
    if (!myPermissions.catalog_manage) return; 
    const btn = document.getElementById('btn-save-mgr');
    btn.disabled = true; btn.innerText = "Guardando...";

    try {
        const id = document.getElementById('mgr-id').value; 
        const selectedTaxes = Array.from(document.querySelectorAll('.tax-check:checked')).map(cb => parseInt(cb.value));
        const blockedDays = Array.from(document.querySelectorAll('.day-block-check:checked')).map(cb => cb.value);

        const rows = document.querySelectorAll('.range-row');
        let ranges = [];
        let maxPriceFound = 0;

        rows.forEach(row => {
            const min = parseInt(row.querySelector('.range-min').value) || 0;
            const max = parseInt(row.querySelector('.range-max').value) || 999999;
            const precios = { lunes: parseFloat(row.querySelector('.p-lun').value) || 0, martes: parseFloat(row.querySelector('.p-mar').value) || 0, miercoles: parseFloat(row.querySelector('.p-mie').value) || 0, jueves: parseFloat(row.querySelector('.p-jue').value) || 0, viernes: parseFloat(row.querySelector('.p-vie').value) || 0, sabado: parseFloat(row.querySelector('.p-sab').value) || 0, domingo: parseFloat(row.querySelector('.p-dom').value) || 0 };
            const localMax = Math.max(...Object.values(precios));
            if(localMax > maxPriceFound) maxPriceFound = localMax;
            ranges.push({ min, max, precios });
        });
        
        const fileInput = document.getElementById('mgr-file');
        let imgUrl = null;
        if(id) { const existing = allSpaces.find(s => s.id == id); imgUrl = existing ? existing.imagen_url : null; }

        if(fileInput.files && fileInput.files.length > 0) {
            const file = fileInput.files[0];
            const fileExt = file.name.split('.').pop();
            const fileName = `${Date.now()}.${fileExt}`;
            const filePath = `espacios/${fileName}`;
            const { error: uploadError } = await window.globalSupabase.storage.from('Espacios').upload(filePath, file);
            if(uploadError) throw uploadError;
            const { data: { publicUrl } } = window.globalSupabase.storage.from('Espacios').getPublicUrl(filePath);
            imgUrl = publicUrl;
        }

        const payload = { 
            clave: document.getElementById('mgr-key').value.toUpperCase().trim(), 
            nombre: document.getElementById('mgr-name').value, 
            tipo: document.getElementById('mgr-type').value, 
            descripcion: document.getElementById('mgr-desc').value, 
            precio_base: maxPriceFound, 
            precios_por_dia: ranges, 
            dias_bloqueados: blockedDays, // NUEVO DATO A BD
            ajuste_tipo: document.getElementById('mgr-adj-type').value, 
            ajuste_porcentaje: parseFloat(document.getElementById('mgr-adj-pct').value) || 0, 
            activa: document.getElementById('mgr-active').checked,
            impuestos_ids: selectedTaxes,
            imagen_url: imgUrl 
        }; 
        
        if(id) { await window.finSupabase.from('espacios').update(payload).eq('id', id); } 
        else { await window.finSupabase.from('espacios').insert(payload); } 
        
        window.showToast("Guardado", "success"); 
        window.closeModal('manager-modal'); 
        loadCatalog(); 
        fileInput.value = '';

    } catch(e) { console.error(e); window.showToast("Error al guardar: " + e.message, "error"); } 
    finally { btn.disabled = false; btn.innerText = "Guardar"; }
}

window.openQuoteModal = function(id) {
    currentSpace = allSpaces.find(s => s.id === id); if (!currentSpace) return;
    document.getElementById('q-name').innerText = currentSpace.nombre; document.getElementById('q-key').innerText = currentSpace.clave; document.getElementById('q-price').innerText = "$0.00";
    let modalImg = currentSpace.imagen_url || ''; if(modalImg.startsWith('[')) { try { modalImg = JSON.parse(modalImg)[0]; } catch(e){} } document.getElementById('q-img').src = modalImg; 
    const dStart = document.getElementById('date-start'); const dEnd = document.getElementById('date-end');
    dStart.value = ''; dEnd.value = ''; dEnd.min = ''; document.getElementById('q-guests').value = 1;
    document.getElementById('cli-name').value = ''; document.getElementById('cli-rfc').value = ''; document.getElementById('cli-phone').value = ''; document.getElementById('cli-email').value = ''; 
    const cliSel = document.getElementById('cli-select'); if(cliSel) cliSel.value=''; const cliId = document.getElementById('cli-id'); if(cliId) cliId.value='';
	loadClientProfilesForQuoteModal();
	document.getElementById('avail-msg').classList.add('hidden'); document.getElementById('btn-generate').disabled = true; window.openModal('quote-modal');
}

window.updateQuoteCalculation = function() {
    if(!currentSpace) return;
    const s = document.getElementById('date-start').value;
    const e = document.getElementById('date-end').value;
    const g = document.getElementById('q-guests').value; 
    let calculatedBase = 0;
    
    if (s && e) { const res = calculateDayByDayTotal(currentSpace, s, e, g); calculatedBase = res.total; } 
    else { calculatedBase = parseFloat(currentSpace.precio_base); }

    let base = calculatedBase;
    if(currentSpace.ajuste_tipo === 'aumento') base += calculatedBase * (currentSpace.ajuste_porcentaje/100);
    if(currentSpace.ajuste_tipo === 'descuento') base -= calculatedBase * (currentSpace.ajuste_porcentaje/100);

    let taxAmt = 0; const sTaxes = parseIds(currentSpace.impuestos_ids);
    if(sTaxes.length && dbTaxes.length) { sTaxes.forEach(tid => { const t = dbTaxes.find(x=>String(x.id)===String(tid)); if(t) { const rate = t.porcentaje > 1 ? t.porcentaje/100 : t.porcentaje; taxAmt += base * rate; } }); }

    const final = base + taxAmt;
    currentPricing = { base: calculatedBase, subtotal: base, taxes: taxAmt, final: final };
    document.getElementById('q-price').innerText = formatMoney(final);
}

window.generatePDF = async function() {
    const cli = { name: document.getElementById('cli-name').value, rfc: document.getElementById('cli-rfc').value, phone: document.getElementById('cli-phone').value.trim(), email: document.getElementById('cli-email').value.trim() };
    if(!cli.name) return window.showToast("Falta nombre del cliente", "error");
    const phoneRegex = /^\d{10}$/; if (!phoneRegex.test(cli.phone)) return window.showToast("El teléfono debe tener 10 dígitos numéricos.", "error");
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; if (!emailRegex.test(cli.email)) return window.showToast("El correo electrónico no es válido.", "error");

    window.updateQuoteCalculation();
    const guests = parseInt(document.getElementById('q-guests').value) || 1;
    const extrasTotal = 0; let subtotalNeto = currentPricing.subtotal + extrasTotal;
    const taxIds = parseIds(currentSpace.impuestos_ids); const taxAmt = currentPricing.taxes; const finalPrice = currentPricing.final;
    const desglose = { subtotal_antes_impuestos: subtotalNeto, impuestos_detalle: taxIds, tax_total: taxAmt };

    const payload = { 
        cliente_id: (document.getElementById('cli-id') ? (document.getElementById('cli-id').value || null) : null), 
        espacio_id: currentSpace.id, espacio_nombre: currentSpace.nombre, espacio_clave: currentSpace.clave, 
        cliente_nombre: cli.name, cliente_rfc: cli.rfc, cliente_contacto: cli.phone, cliente_email: cli.email, 
        fecha_inicio: document.getElementById('date-start').value, fecha_fin: document.getElementById('date-end').value, 
        precio_final: finalPrice, desglose_precios: desglose, conceptos_adicionales: [], status: 'pendiente', 
        creado_por: (await window.globalSupabase.auth.getUser()).data.user.id, personas: guests 
    };
    
    await window.finSupabase.from('cotizaciones').insert(payload);
    window.showToast("Cotización Creada");
    setTimeout(()=>window.location.href='orders.html', 1000); 
}

window.filterCatalogLogic = function() { const term = document.getElementById('cat-search').value.toLowerCase(); const type = document.getElementById('cat-filter-type').value; const sort = document.getElementById('cat-sort').value; let filtered = allSpaces.filter(s => (s.nombre.toLowerCase().includes(term) || s.clave.toLowerCase().includes(term)) && (type === 'all' || s.tipo === type)); if (sort === 'price_asc') filtered.sort((a,b) => a.precio_base - b.precio_base); if (sort === 'price_desc') filtered.sort((a,b) => b.precio_base - a.precio_base); renderSpaces(filtered); }
window.previewImage = function(i){ const p = document.getElementById('mgr-preview'); if(i.files[0]){ const r=new FileReader(); r.onload=e=>{ p.src=e.target.result; p.classList.remove('hidden'); }; r.readAsDataURL(i.files[0]); } }
window.checkAvailability = async function() { const s=document.getElementById('date-start').value, e=document.getElementById('date-end').value; if(!s||!e)return; const {data} = await window.finSupabase.from('cotizaciones').select('id').eq('espacio_id',currentSpace.id).in('status',['aprobada','finalizada']).or(`and(fecha_inicio.lte.${e},fecha_fin.gte.${s})`); const msg=document.getElementById('avail-msg'); msg.classList.remove('hidden'); if(data.length){ msg.innerText='OCUPADO'; msg.className='text-red-500 font-bold text-center'; document.getElementById('btn-generate').disabled=true; }else{ msg.innerText='DISPONIBLE'; msg.className='text-green-600 font-bold text-center'; document.getElementById('btn-generate').disabled=false; } }
window.askDeleteSpace = async function(){ window.openConfirm("¿Eliminar espacio?", async () => { await window.finSupabase.from('espacios').delete().eq('id', document.getElementById('mgr-id').value); window.showToast("Eliminado"); window.closeModal('manager-modal'); loadCatalog(); }); }