let clientProfiles = [];
let clientProfilesById = {};

window.finalMontajeDates = [];
window.tempMontajeDates = [];
window.currentMontajePrefix = 'q';

async function loadClientProfilesForQuoteModal() {
    const sel = document.getElementById('cli-select'); const hid = document.getElementById('cli-id'); if (!sel || !window.finSupabase) return;
    try {
        const { data, error } = await window.finSupabase.from('clientes').select('id,nombre_completo,telefono,correo,rfc').order('nombre_completo', { ascending: true });
        if (error) throw error; clientProfiles = data || []; clientProfilesById = {}; clientProfiles.forEach(c => clientProfilesById[c.id] = c);
        sel.innerHTML = '<option value="">— Capturar manualmente —</option>' + clientProfiles.map(c => `<option value="${c.id}">${(c.nombre_completo || '').toUpperCase()}</option>`).join('');
        sel.onchange = () => { const id = sel.value; if (!id) { if (hid) hid.value = ''; return; } const c = clientProfilesById[id]; if (!c) return; if (hid) hid.value = id; const n = document.getElementById('cli-name'); const p = document.getElementById('cli-phone'); const e = document.getElementById('cli-email'); const r = document.getElementById('cli-rfc'); if (n) n.value = c.nombre_completo || ''; if (p) p.value = (c.telefono || ''); if (e) e.value = (c.correo || ''); if (r) r.value = (c.rfc || ''); };
        const clearAssoc = () => { if (sel.value) sel.value = ''; if (hid) hid.value = ''; }; ['cli-name','cli-phone','cli-email','cli-rfc'].forEach(id => { const el = document.getElementById(id); if (el) el.addEventListener('input', clearAssoc); });
    } catch (e) { console.warn("No se pudo cargar clientes", e); }
}

const SB_URL = window.HUB_CONFIG?.supabaseUrl || window.ENV?.SUPABASE_URL || '';
const SB_KEY = window.HUB_CONFIG?.supabaseAnonKey || window.ENV?.SUPABASE_ANON_KEY || '';
const FIN_SCHEMA = window.HUB_CONFIG?.finanzasSchema || window.ENV?.SCHEMA_CASA_PIEDRA || 'finanzas_casadepiedra';

let allSpaces = [], catalogConcepts = [], dbTaxes = [], currentSpace = null, currentPricing = { base:0, final:0 };
let adminSelectedConcepts = []; let myPermissions = { access:false, catalog_manage:false };

function parseIds(v){ if(!v) return []; if(Array.isArray(v)) return v; if(typeof v === 'string'){ try { const parsed = JSON.parse(v); return Array.isArray(parsed) ? parsed : []; } catch(e){ return v.split(',').map(x=>x.trim()).filter(Boolean); } } return []; }
function formatMoney(v){ return new Intl.NumberFormat('es-MX', { style: 'currency', currency: 'MXN' }).format(v || 0); }
window.safeFormatDate = function(dateStr) { if (!dateStr) return '--'; const parts = dateStr.split('-'); if (parts.length !== 3) return dateStr; return `${parts[2]}/${parts[1]}/${parts[0]}`; };

function calculateDayByDayTotal(space, startStr, endStr, guests) {
    if (!startStr) return { total: 0 };
    const endS = endStr || startStr;
    let rules = [];
    try { rules = typeof space.precios_por_dia === 'string' ? JSON.parse(space.precios_por_dia) : (space.precios_por_dia || []); } catch(e){}
    if (!Array.isArray(rules) || rules.length === 0) rules = [{ min: 0, max: 999999, precios: {lunes: space.precio_base||0, martes:space.precio_base||0, miercoles:space.precio_base||0, jueves:space.precio_base||0, viernes:space.precio_base||0, sabado:space.precio_base||0, domingo:space.precio_base||0} }];
    
    const guestCount = parseInt(guests) || 1;
    let activeRule = rules.find(r => guestCount >= r.min && guestCount <= r.max);
    if (!activeRule) activeRule = rules[rules.length - 1];
    
    const prices = activeRule ? (activeRule.precios || {}) : {}; let total = 0;
    const start = new Date(startStr + 'T00:00:00'); const end = new Date(endS + 'T00:00:00'); const keys = ['domingo', 'lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado'];
    let blockedDays = []; try { blockedDays = typeof space.dias_bloqueados === 'string' ? JSON.parse(space.dias_bloqueados) : (space.dias_bloqueados || []); } catch(e){}
    
    for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
        const key = keys[d.getDay()]; let price = parseFloat(prices[key] || 0);
        if (blockedDays.includes(key)) price = 0;
        total += price;
    }
    return { total };
}

// CLICK AFUERA CIERRA MODALES (EXCEPTO CUANDO SE REQUIERE CONFIRMACIÓN O EDICIÓN)
window.addEventListener('click', function(e) {
    const qModal = document.getElementById('quote-modal');
    const mgrModal = document.getElementById('manager-modal');
    const montajeModal = document.getElementById('montaje-modal');

    if (e.target === mgrModal) window.closeModal('manager-modal');
    if (e.target === qModal) window.closeModal('quote-modal');
    if (e.target === montajeModal) montajeModal.classList.add('hidden');
});

document.addEventListener('DOMContentLoaded', async () => {
    if (window.supabase) { if(!window.finSupabase) window.finSupabase = window.supabase.createClient(SB_URL, SB_KEY, { db: { schema: FIN_SCHEMA } }); if(!window.globalSupabase) window.globalSupabase = window.supabase.createClient(SB_URL, SB_KEY); }
    const { data: { session } } = await window.globalSupabase.auth.getSession(); if (!session) return;
    const { data: profile } = await window.globalSupabase.from('profiles').select('*').eq('id', session.user.id).single();
    const userRole = String(profile?.role || '').toLowerCase().trim(); const roleHasAccess = (userRole === 'admin') || (userRole === 'casa_de_piedra') || (userRole === 'ambos');
    if (userRole === 'admin') myPermissions = { access: true, catalog_manage: true }; else if (roleHasAccess) myPermissions = { access: true, catalog_manage: false }; else myPermissions = profile.app_metadata?.finanzas?.permissions || { access: false };
    if (!myPermissions.access) return window.showToast?.('No tienes permisos.', 'error');
    if (myPermissions.catalog_manage) { const btn = document.getElementById('btn-new-space'); if(btn) btn.classList.remove('hidden'); }
	await loadTaxes(); await loadClientProfilesForQuoteModal(); loadCatalog();
    const { data } = await window.finSupabase.from('conceptos_catalogo').select('*').eq('activo', true); catalogConcepts = data || [];
});

async function loadTaxes() { const { data } = await window.finSupabase.from('impuestos').select('*'); dbTaxes = data || []; }
async function loadCatalog() { const { data } = await window.finSupabase.from('espacios').select('*').order('id'); allSpaces = data||[]; renderSpaces(allSpaces); }

function renderSpaces(list) { 
    const g = document.getElementById('spaces-grid'); g.innerHTML=''; if(list.length === 0) { g.innerHTML = '<div class="col-span-full text-center py-10 text-gray-400 font-bold">No se encontraron espacios.</div>'; return; }
    list.forEach(s => { 
        let displayImg = '../../assets/img/placeholder_cp.png'; if (s.imagen_url) { if (s.imagen_url.trim().startsWith('[')) { try { const parsed = JSON.parse(s.imagen_url); if (parsed.length > 0) displayImg = parsed[0]; } catch (e) { displayImg = s.imagen_url; } } else { displayImg = s.imagen_url; } }
        let eTags = []; try { eTags = typeof s.etiquetas === 'string' ? JSON.parse(s.etiquetas) : (s.etiquetas || []); } catch(e){}
        let tagsHtml = ''; if(eTags.length > 0) { tagsHtml = `<div class="flex gap-1 mb-2 flex-wrap">` + eTags.map(t => `<span class="bg-gray-100 text-gray-500 border border-gray-200 px-1.5 py-0.5 rounded text-[9px] font-bold uppercase">${t}</span>`).join('') + `</div>`; }
        const editBtn = myPermissions.catalog_manage ? `<button onclick="window.openManagerModal(${s.id})" class="absolute top-3 right-3 bg-white/90 text-gray-700 p-2 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition-all z-10"><i class="fa-solid fa-pen"></i></button>` : '';
        g.innerHTML += `<div class="bg-white rounded-xl shadow-md relative group hover:shadow-2xl transition-all duration-300 hover:-translate-y-1 overflow-hidden border border-gray-100"><div class="h-48 bg-gray-200 relative overflow-hidden">${editBtn}<img src="${displayImg}" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"><div class="absolute bottom-3 left-4 text-white z-10"><p class="text-[10px] font-bold uppercase tracking-wider bg-brand-red px-2 py-0.5 rounded inline-block mb-1">${s.tipo}</p><h3 class="font-bold text-lg leading-tight shadow-black drop-shadow-md">${s.nombre}</h3></div></div><div class="p-5">${tagsHtml}<div class="flex justify-between items-center mb-4"><p class="text-xs text-gray-400 font-mono"><i class="fa-solid fa-tag mr-1"></i>${s.clave}</p></div><p class="text-xs text-gray-500 line-clamp-2 mb-4 h-8">${s.descripcion || ''}</p><div class="border-t pt-3"><button onclick="window.openQuoteModal(${s.id})" class="bg-gray-900 text-white w-full py-2.5 rounded-lg text-xs font-bold uppercase tracking-wide hover:bg-brand-red transition-colors duration-300 shadow-lg"><i class="fa-solid fa-calculator mr-2"></i> Cotizar Evento</button></div></div></div>`;
    }); 
}

window.addRangeRow = function(data = null) {
    const container = document.getElementById('mgr-ranges-container'); const id = Date.now() + Math.random().toString(36).substr(2, 5);
    const min = data ? data.min : 1; const max = data ? data.max : 100; const prices = data ? data.precios : {lunes:0, martes:0, miercoles:0, jueves:0, viernes:0, sabado:0, domingo:0};
    const row = document.createElement('div'); row.className = "range-row bg-gray-50 p-3 rounded-lg border border-gray-200 relative animate-enter"; row.id = `range-${id}`;
    row.innerHTML = `<div class="flex justify-between items-center mb-2"><div class="flex items-center gap-2"><span class="text-[10px] font-bold uppercase text-brand-red bg-yellow-50 px-2 py-0.5 rounded">Rango</span><input type="number" class="range-min w-16 border rounded text-xs p-1 text-center font-bold" value="${min}"><span class="text-xs text-gray-400">-</span><input type="number" class="range-max w-16 border rounded text-xs p-1 text-center font-bold" value="${max}"><span class="text-[10px] font-bold uppercase text-gray-400 ml-1">Personas</span></div><button onclick="document.getElementById('range-${id}').remove()" class="text-gray-400 hover:text-red-500 text-xs"><i class="fa-solid fa-trash"></i></button></div><div class="grid grid-cols-4 gap-2"><div><label class="text-[9px] uppercase font-bold text-gray-400">Lun</label><input type="number" value="${prices.lunes}" class="p-lun w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div><div><label class="text-[9px] uppercase font-bold text-gray-400">Mar</label><input type="number" value="${prices.martes}" class="p-mar w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div><div><label class="text-[9px] uppercase font-bold text-gray-400">Mié</label><input type="number" value="${prices.miercoles}" class="p-mie w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div><div><label class="text-[9px] uppercase font-bold text-gray-400">Jue</label><input type="number" value="${prices.jueves}" class="p-jue w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div><div><label class="text-[9px] uppercase font-bold text-gray-400">Vie</label><input type="number" value="${prices.viernes}" class="p-vie w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div><div><label class="text-[9px] uppercase font-bold text-gray-400">Sáb</label><input type="number" value="${prices.sabado}" class="p-sab w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div><div><label class="text-[9px] uppercase font-bold text-gray-400">Dom</label><input type="number" value="${prices.domingo}" class="p-dom w-full border p-1 rounded text-xs font-bold text-center outline-none focus:border-brand-red"></div></div>`;
    container.appendChild(row);
}

window.addHorarioRow = function(data = null) {
    const container = document.getElementById('mgr-horarios-container'); const nombre = data ? data.nombre : ''; const start = data ? data.start : ''; const end = data ? data.end : ''; const price = data ? data.price : 0;
    const row = document.createElement('div'); row.className = "horario-row flex flex-col sm:flex-row gap-2 items-center bg-gray-50 p-2 rounded border border-gray-200 animate-enter";
    row.innerHTML = `<input type="text" placeholder="Nombre (Ej. Turno Especial)" value="${nombre}" class="h-name w-full sm:w-1/3 border rounded p-1.5 text-xs outline-none focus:border-brand-red font-bold text-gray-700"><input type="time" value="${start}" class="h-start w-full sm:w-auto border rounded p-1.5 text-xs outline-none focus:border-brand-red"><span class="text-xs text-gray-400">a</span><input type="time" value="${end}" class="h-end w-full sm:w-auto border rounded p-1.5 text-xs outline-none focus:border-brand-red"><input type="number" placeholder="Precio $" value="${price}" class="h-price w-full sm:w-24 border rounded p-1.5 text-xs text-right outline-none focus:border-brand-red font-bold"><button onclick="this.parentElement.remove()" class="text-gray-400 hover:text-red-500 transition px-2"><i class="fa-solid fa-trash"></i></button>`;
    container.appendChild(row);
}

window.openManagerModal = function(id){
    if (!myPermissions.catalog_manage) return window.showToast("No tienes permisos.", "error"); 
    document.getElementById('mgr-id').value = id || ''; const container = document.getElementById('mgr-taxes-list'); document.querySelectorAll('.day-block-check').forEach(cb => cb.checked = false);
    if(container) { container.innerHTML = ''; let currentTaxes = []; if(id) { const s = allSpaces.find(x => x.id === id); currentTaxes = parseIds(s.impuestos_ids); } dbTaxes.forEach(t => { const isChecked = currentTaxes.some(cid => String(cid) === String(t.id)) ? 'checked' : ''; container.innerHTML += `<label class="flex items-center gap-2 p-2 border rounded bg-white hover:bg-gray-50 cursor-pointer"><input type="checkbox" value="${t.id}" class="tax-check accent-brand-red cursor-pointer" ${isChecked}><span class="text-[10px] font-bold uppercase text-gray-600 cursor-pointer select-none">${t.nombre} (${t.porcentaje}%)</span></label>`; }); }

    const rangesContainer = document.getElementById('mgr-ranges-container'); rangesContainer.innerHTML = '';
    const horariosContainer = document.getElementById('mgr-horarios-container'); horariosContainer.innerHTML = '';

    if(id) { 
        const s = allSpaces.find(x => x.id === id); 
        document.getElementById('mgr-title').innerText = "Editar: " + s.nombre; document.getElementById('mgr-key').value = s.clave; document.getElementById('mgr-key').disabled = true; document.getElementById('mgr-name').value = s.nombre; document.getElementById('mgr-type').value = s.tipo; document.getElementById('mgr-desc').value = s.descripcion || ''; 
        let eTags = []; try { eTags = typeof s.etiquetas === 'string' ? JSON.parse(s.etiquetas) : (s.etiquetas || []); } catch(e){}
        if(!Array.isArray(eTags)) eTags = []; document.getElementById('mgr-tags').value = eTags.join(', ');

        let rules = []; try { rules = typeof s.precios_por_dia === 'string' ? JSON.parse(s.precios_por_dia) : (s.precios_por_dia || []); } catch(e){}
        if (!Array.isArray(rules) || rules.length === 0) rules = [{min: 1, max: 9999, precios: {lunes:0, martes:0, miercoles:0, jueves:0, viernes:0, sabado:0, domingo:0}}];
        rules.forEach(rule => window.addRangeRow(rule));

        let blockedDays = []; try { blockedDays = typeof s.dias_bloqueados === 'string' ? JSON.parse(s.dias_bloqueados) : (s.dias_bloqueados || []); } catch(e){}
        document.querySelectorAll('.day-block-check').forEach(cb => { if(blockedDays.includes(cb.value)) cb.checked = true; });

        let b2b = {}; try { b2b = typeof s.config_b2b === 'string' ? JSON.parse(s.config_b2b) : (s.config_b2b || {}); } catch(e){}
        document.getElementById('cfg-precio-montaje').value = b2b.precio_montaje || 0; document.getElementById('cfg-precio-hora').value = b2b.precio_hora_extra || 0;
        let h = b2b.horarios || []; if (!Array.isArray(h)) { const mapNames = { matutino: 'Matutino', vespertino: 'Vespertino', nocturno: 'Nocturno', todo_dia: 'Todo el día' }; h = Object.keys(h).map(k => ({ nombre: mapNames[k] || k, start: h[k].start, end: h[k].end, price: h[k].price })).filter(item => item.start && item.end); }
        if (h.length > 0) h.forEach(item => window.addHorarioRow(item)); else window.addHorarioRow();

        document.getElementById('mgr-adj-type').value = s.ajuste_tipo || 'ninguno'; document.getElementById('mgr-adj-pct').value = s.ajuste_porcentaje || 0; document.getElementById('mgr-active').checked = s.activa !== false; document.getElementById('btn-delete-mgr').classList.remove('hidden'); if(s.imagen_url) { document.getElementById('mgr-preview').src = s.imagen_url.startsWith('[') ? JSON.parse(s.imagen_url)[0] : s.imagen_url; document.getElementById('mgr-preview').classList.remove('hidden'); }
    } else { 
        document.getElementById('mgr-title').innerText = "Nuevo Espacio"; document.getElementById('mgr-key').value = ''; document.getElementById('mgr-key').disabled = false; document.getElementById('mgr-name').value = ''; document.getElementById('mgr-tags').value = ''; document.getElementById('mgr-desc').value = ''; window.addRangeRow(); window.addHorarioRow(); 
        document.getElementById('cfg-precio-montaje').value = 0; document.getElementById('cfg-precio-hora').value = 0; document.getElementById('mgr-active').checked = true; document.getElementById('btn-delete-mgr').classList.add('hidden'); document.getElementById('mgr-preview').src = ''; document.getElementById('mgr-preview').classList.add('hidden');
    } 
    window.openModal('manager-modal');
}

window.saveSpace = async function(){ 
    if (!myPermissions.catalog_manage) return; const btn = document.getElementById('btn-save-mgr'); btn.disabled = true; btn.innerText = "Guardando...";
    try {
        const id = document.getElementById('mgr-id').value; 
        const selectedTaxes = Array.from(document.querySelectorAll('.tax-check:checked')).map(cb => parseInt(cb.value));
        const blockedDays = Array.from(document.querySelectorAll('.day-block-check:checked')).map(cb => cb.value);

        const rows = document.querySelectorAll('.range-row'); let ranges = []; let maxPriceFound = 0;
        rows.forEach(row => {
            const min = parseInt(row.querySelector('.range-min').value) || 0; const max = parseInt(row.querySelector('.range-max').value) || 999999;
            const precios = { lunes: parseFloat(row.querySelector('.p-lun').value) || 0, martes: parseFloat(row.querySelector('.p-mar').value) || 0, miercoles: parseFloat(row.querySelector('.p-mie').value) || 0, jueves: parseFloat(row.querySelector('.p-jue').value) || 0, viernes: parseFloat(row.querySelector('.p-vie').value) || 0, sabado: parseFloat(row.querySelector('.p-sab').value) || 0, domingo: parseFloat(row.querySelector('.p-dom').value) || 0 };
            const localMax = Math.max(...Object.values(precios)); if(localMax > maxPriceFound) maxPriceFound = localMax; ranges.push({ min, max, precios });
        });
        
        const tagsArray = (document.getElementById('mgr-tags').value || '').split(',').map(t => t.trim()).filter(Boolean); 

        let horariosArray = []; document.querySelectorAll('.horario-row').forEach(row => { const nombre = row.querySelector('.h-name').value.trim(); const start = row.querySelector('.h-start').value; const end = row.querySelector('.h-end').value; const price = parseFloat(row.querySelector('.h-price').value) || 0; if (nombre && start && end) horariosArray.push({ nombre, start, end, price }); });
        const b2bConfig = { precio_montaje: parseFloat(document.getElementById('cfg-precio-montaje').value) || 0, precio_hora_extra: parseFloat(document.getElementById('cfg-precio-hora').value) || 0, horarios: horariosArray };

        const fileInput = document.getElementById('mgr-file'); let imgUrl = null;
        if(id) { const existing = allSpaces.find(s => s.id == id); imgUrl = existing ? existing.imagen_url : null; }
        if(fileInput.files && fileInput.files.length > 0) { const file = fileInput.files[0]; const fileExt = file.name.split('.').pop(); const filePath = `espacios/${Date.now()}.${fileExt}`; const { error } = await window.globalSupabase.storage.from('Espacios').upload(filePath, file); if(error) throw error; imgUrl = window.globalSupabase.storage.from('Espacios').getPublicUrl(filePath).data.publicUrl; }

        const payload = { 
            clave: document.getElementById('mgr-key').value.toUpperCase().trim(), nombre: document.getElementById('mgr-name').value, tipo: document.getElementById('mgr-type').value, descripcion: document.getElementById('mgr-desc').value, precio_base: maxPriceFound, 
            precios_por_dia: ranges, dias_bloqueados: blockedDays, config_b2b: b2bConfig, etiquetas: tagsArray, 
            ajuste_tipo: document.getElementById('mgr-adj-type').value, ajuste_porcentaje: parseFloat(document.getElementById('mgr-adj-pct').value) || 0, activa: document.getElementById('mgr-active').checked, impuestos_ids: selectedTaxes, imagen_url: imgUrl 
        }; 

        if(id) { const { error: updErr } = await window.finSupabase.from('espacios').update(payload).eq('id', id); if(updErr) throw updErr; } else { const { error: insErr } = await window.finSupabase.from('espacios').insert(payload); if(insErr) throw insErr; } 
        window.showToast("Guardado", "success"); window.closeModal('manager-modal'); loadCatalog(); fileInput.value = '';

    } catch(e) { console.error("Error al guardar:", e); window.showToast("Error: Verifica la consola", "error"); } finally { btn.disabled = false; btn.innerText = "Guardar"; }
}

// LOGICA DE FECHAS DE MONTAJE PARA CATALOG (COTIZACIÓN RÁPIDA)
window.handleMontajeInput = function(prefix) {
    const val = parseInt(document.getElementById(prefix + '-premontaje').value) || 0;
    const btn = document.getElementById(prefix + '-btn-montaje');
    if (val > 0) btn.classList.remove('hidden'); else btn.classList.add('hidden');
    if (window.finalMontajeDates.length > val) window.finalMontajeDates = window.finalMontajeDates.slice(0, val);
    window.actualizarLabelMontaje(prefix);
    window.updateQuoteCalculation();
}

window.actualizarLabelMontaje = function(prefix) {
    const lbl = document.getElementById(prefix + '-lbl-fechas-montaje');
    if (window.finalMontajeDates.length > 0) {
        lbl.innerText = window.finalMontajeDates.map(d => window.safeFormatDate(d)).join(', ');
        lbl.classList.remove('hidden');
    } else {
        lbl.classList.add('hidden');
    }
}

window.abrirModalMontaje = function(prefix) {
    window.currentMontajePrefix = prefix;
    const diasM = parseInt(document.getElementById(prefix + '-premontaje').value) || 0;
    if (diasM <= 0) return window.showToast("Ingresa la cantidad de días primero.", "error");
    
    let sDate = document.getElementById('date-start').value;
    if (!sDate) return window.showToast("Primero selecciona la Fecha Inicio del evento.", "error");

    document.getElementById('montaje-limit-num').innerText = diasM;
    window.tempMontajeDates = [...window.finalMontajeDates].slice(0, diasM);
    
    const dp = document.getElementById('montaje-date-input');
    const maxD = new Date(sDate + 'T00:00:00'); 
    maxD.setDate(maxD.getDate() - 1);
    dp.max = maxD.toISOString().split('T')[0];
    dp.value = '';
    
    window.renderListaMontaje();
    document.getElementById('montaje-modal').classList.remove('hidden');
}

window.addMontajeDate = function() {
    const dp = document.getElementById('montaje-date-input');
    const dateVal = dp.value;
    if(!dateVal) return window.showToast("Selecciona una fecha.", "error");
    
    const limit = parseInt(document.getElementById(window.currentMontajePrefix + '-premontaje').value) || 0;
    if(window.tempMontajeDates.length >= limit) return window.showToast(`Solo puedes seleccionar ${limit} día(s).`, "error");
    
    if(window.tempMontajeDates.includes(dateVal)) return window.showToast("Esta fecha ya fue agregada.", "error");
    
    const maxD = new Date(dp.max + 'T00:00:00');
    const selD = new Date(dateVal + 'T00:00:00');
    if(selD > maxD) return window.showToast("La fecha debe ser antes del evento.", "error");
    
    window.tempMontajeDates.push(dateVal);
    window.tempMontajeDates.sort();
    window.renderListaMontaje();
}

window.removeMontajeDate = function(idx) {
    window.tempMontajeDates.splice(idx, 1);
    window.renderListaMontaje();
}

window.renderListaMontaje = function() {
    const list = document.getElementById('montaje-dates-list');
    list.innerHTML = '';
    window.tempMontajeDates.forEach((d, i) => {
        list.innerHTML += `<li class="flex justify-between items-center bg-gray-50 p-2 rounded-lg border border-gray-100 shadow-sm"><span class="text-xs font-bold text-gray-700">${window.safeFormatDate(d)}</span><button onclick="window.removeMontajeDate(${i})" class="text-red-500 hover:text-red-700 transition"><i class="fa-solid fa-trash"></i></button></li>`;
    });
}

window.confirmMontajeDates = function() {
    const limit = parseInt(document.getElementById(window.currentMontajePrefix + '-premontaje').value) || 0;
    if(window.tempMontajeDates.length !== limit) return window.showToast(`Debes seleccionar exactamente ${limit} día(s).`, "error");
    
    window.finalMontajeDates = [...window.tempMontajeDates];
    window.actualizarLabelMontaje(window.currentMontajePrefix);
    document.getElementById('montaje-modal').classList.add('hidden');
}


window.openQuoteModal = function(id) {
    currentSpace = allSpaces.find(s => s.id === id); if (!currentSpace) return;
    document.getElementById('q-name').innerText = currentSpace.nombre; document.getElementById('q-key').innerText = currentSpace.clave; document.getElementById('q-price').innerText = "$0.00";
    let modalImg = currentSpace.imagen_url || ''; if(modalImg.startsWith('[')) { try { modalImg = JSON.parse(modalImg)[0]; } catch(e){} } document.getElementById('q-img').src = modalImg; 
    
    let b2b = {}; try { b2b = typeof currentSpace.config_b2b === 'string' ? JSON.parse(currentSpace.config_b2b) : (currentSpace.config_b2b || {}); } catch(e){}
    let h = b2b.horarios || []; if (!Array.isArray(h)) { const mapNames = { matutino: 'Matutino', vespertino: 'Vespertino', nocturno: 'Nocturno', todo_dia: 'Todo el día' }; h = Object.keys(h).map(k => ({ nombre: mapNames[k] || k, start: h[k].start, end: h[k].end, price: h[k].price })).filter(item => item.start && item.end); }
    const selHorario = document.getElementById('q-horario'); selHorario.innerHTML = '';
    if (h.length > 0) h.forEach(item => { selHorario.innerHTML += `<option value="${item.nombre}" data-price="${item.price}">${item.nombre} (${item.start} a ${item.end})</option>`; }); else selHorario.innerHTML = '<option value="Sin horario" data-price="0">Sin horario configurado</option>';

    const selConcept = document.getElementById('admin-concept-select'); selConcept.innerHTML = '<option value="">Selecciona servicio...</option>';
    catalogConcepts.forEach(c => { selConcept.innerHTML += `<option value="${c.id}">${c.nombre} (+$${c.precio_sugerido})</option>`; });

    document.getElementById('date-start').value = ''; document.getElementById('date-end').value = ''; 
    document.getElementById('q-guests').value = 100; document.getElementById('q-premontaje').value = 0; document.getElementById('q-horas').value = 0;
    document.getElementById('cli-name').value = ''; document.getElementById('cli-rfc').value = ''; document.getElementById('cli-phone').value = ''; document.getElementById('cli-email').value = ''; 
    
    adminSelectedConcepts = []; window.finalMontajeDates = []; window.actualizarLabelMontaje('q'); document.getElementById('q-btn-montaje').classList.add('hidden');
    window.updateAdminConceptsSummary();

    const cliSel = document.getElementById('cli-select'); if(cliSel) cliSel.value=''; const cliId = document.getElementById('cli-id'); if(cliId) cliId.value='';
	loadClientProfilesForQuoteModal(); document.getElementById('avail-msg').classList.add('hidden'); document.getElementById('btn-generate').disabled = true; window.openModal('quote-modal');
}

window.addAdminConcept = function() { const sel = document.getElementById('admin-concept-select'); const id = sel.value; if(!id) return; const concept = catalogConcepts.find(c => c.id == id); if(concept) { adminSelectedConcepts.push({ description: concept.nombre, amount: concept.precio_sugerido, value: concept.precio_sugerido, unit: 'fixed', type: 'aumento' }); window.updateAdminConceptsSummary(); window.updateQuoteCalculation(); } sel.value = ''; }
window.removeAdminConcept = function(index) { adminSelectedConcepts.splice(index, 1); window.updateAdminConceptsSummary(); window.updateQuoteCalculation(); }
window.updateAdminConceptsSummary = function() { const container = document.getElementById('admin-concepts-summary'); container.innerHTML = ''; adminSelectedConcepts.forEach((c, idx) => { container.innerHTML += `<div class="flex justify-between items-center bg-gray-50 border border-gray-100 p-2 rounded text-xs"><span class="font-bold text-gray-700">${c.description}</span><div class="flex items-center gap-3"><span class="font-black text-brand-dark">$${parseFloat(c.amount).toLocaleString()}</span><button onclick="window.removeAdminConcept(${idx})" class="text-gray-400 hover:text-red-500"><i class="fas fa-times"></i></button></div></div>`; }); }

window.updateQuoteCalculation = function() {
    if(!currentSpace) return;
    const s = document.getElementById('date-start').value; const e = document.getElementById('date-end').value; const g = document.getElementById('q-guests').value; 
    let base = 0; if (s && e) { base = calculateDayByDayTotal(currentSpace, s, e, g).total; } 

    let b2b = {}; try { b2b = typeof currentSpace.config_b2b === 'string' ? JSON.parse(currentSpace.config_b2b) : (currentSpace.config_b2b || {}); } catch(ex){}
    const pMontaje = parseFloat(b2b.precio_montaje) || 0; const pHora = parseFloat(b2b.precio_hora_extra) || 0;
    const selOpt = document.getElementById('q-horario').options[document.getElementById('q-horario').selectedIndex];
    const costoHorario = selOpt ? parseFloat(selOpt.getAttribute('data-price')) || 0 : 0;
    const diasM = parseInt(document.getElementById('q-premontaje').value) || 0; const hrsE = parseInt(document.getElementById('q-horas').value) || 0;

    let subtotal = base + costoHorario + (diasM * pMontaje) + (hrsE * pHora);
    adminSelectedConcepts.forEach(c => { subtotal += parseFloat(c.amount); });

    if(currentSpace.ajuste_tipo === 'aumento') subtotal += subtotal * (currentSpace.ajuste_porcentaje/100);
    if(currentSpace.ajuste_tipo === 'descuento') subtotal -= subtotal * (currentSpace.ajuste_porcentaje/100);

    let taxAmt = 0; const sTaxes = parseIds(currentSpace.impuestos_ids);
    if(sTaxes.length && dbTaxes.length) { sTaxes.forEach(tid => { const t = dbTaxes.find(x=>String(x.id)===String(tid)); if(t) { const rate = t.porcentaje > 1 ? t.porcentaje/100 : t.porcentaje; taxAmt += subtotal * rate; } }); }

    currentPricing = { subtotal: subtotal, taxes: taxAmt, final: subtotal + taxAmt };
    document.getElementById('q-price').innerText = formatMoney(currentPricing.final);
}

window.generatePDF = async function() {
    const diasM = parseInt(document.getElementById('q-premontaje').value) || 0;
    if(diasM > 0 && window.finalMontajeDates.length !== diasM) {
        return window.showToast("Faltan asignar las fechas específicas del montaje.", "error");
    }

    const cli = { name: document.getElementById('cli-name').value, rfc: document.getElementById('cli-rfc').value, phone: document.getElementById('cli-phone').value.trim(), email: document.getElementById('cli-email').value.trim() };
    if(!cli.name) return window.showToast("Falta nombre del cliente", "error"); const phoneRegex = /^\d{10}$/; if (!phoneRegex.test(cli.phone)) return window.showToast("El teléfono debe tener 10 dígitos numéricos.", "error");

    window.updateQuoteCalculation(); const guests = parseInt(document.getElementById('q-guests').value) || 1;
    let b2b = {}; try { b2b = typeof currentSpace.config_b2b === 'string' ? JSON.parse(currentSpace.config_b2b) : (currentSpace.config_b2b || {}); } catch(ex){}
    const pMontaje = parseFloat(b2b.precio_montaje) || 0; const pHora = parseFloat(b2b.precio_hora_extra) || 0;
    const selOpt = document.getElementById('q-horario').options[document.getElementById('q-horario').selectedIndex];
    const costoHorario = selOpt ? parseFloat(selOpt.getAttribute('data-price')) || 0 : 0;
    const hrsE = parseInt(document.getElementById('q-horas').value) || 0;

    let conceptosB2B = [];
    if(selOpt) conceptosB2B.push({ description: `Horario: ${selOpt.text}`, amount: costoHorario, value: costoHorario, unit: 'fixed', type: 'b2b_horario', meta: { selected: selOpt.value, custom_name: selOpt.text } });
    if(diasM > 0) conceptosB2B.push({ description: `Montaje extra (${diasM} días)${window.finalMontajeDates.length ? ' - ' + window.finalMontajeDates.map(d=>window.safeFormatDate(d)).join(', ') : ''}`, amount: (diasM * pMontaje), value: (diasM * pMontaje), unit: 'fixed', type: 'b2b_montaje', meta: { days: diasM, unit_price: pMontaje, dates: window.finalMontajeDates } });
    if(hrsE > 0) conceptosB2B.push({ description: `Horas Extras (${hrsE} hrs)`, amount: (hrsE * pHora), value: (hrsE * pHora), unit: 'fixed', type: 'b2b_horas', meta: { hours: hrsE, unit_price: pHora } });
    adminSelectedConcepts.forEach(c => conceptosB2B.push(c));

    const payload = { cliente_id: (document.getElementById('cli-id') ? (document.getElementById('cli-id').value || null) : null), espacio_id: currentSpace.id, espacio_nombre: currentSpace.nombre, espacio_clave: currentSpace.clave, cliente_nombre: cli.name, cliente_rfc: cli.rfc, cliente_contacto: cli.phone, cliente_email: cli.email, fecha_inicio: document.getElementById('date-start').value, fecha_fin: document.getElementById('date-end').value, precio_final: currentPricing.final, desglose_precios: { subtotal_antes_impuestos: currentPricing.subtotal, impuestos_detalle: parseIds(currentSpace.impuestos_ids), tax_total: currentPricing.taxes }, conceptos_adicionales: conceptosB2B, status: 'pendiente', creado_por: (await window.globalSupabase.auth.getUser()).data.user.id, personas: guests };
    
    await window.finSupabase.from('cotizaciones').insert(payload);
    window.showToast("Cotización Creada"); setTimeout(()=>window.location.href='orders.html', 1000); 
}

window.filterCatalogLogic = function() { const term = document.getElementById('cat-search').value.toLowerCase(); const type = document.getElementById('cat-filter-type').value; const sort = document.getElementById('cat-sort').value; let filtered = allSpaces.filter(s => (s.nombre.toLowerCase().includes(term) || s.clave.toLowerCase().includes(term)) && (type === 'all' || s.tipo === type)); if (sort === 'price_asc') filtered.sort((a,b) => a.precio_base - b.precio_base); if (sort === 'price_desc') filtered.sort((a,b) => b.precio_base - a.precio_base); renderSpaces(filtered); }
window.previewImage = function(i){ const p = document.getElementById('mgr-preview'); if(i.files[0]){ const r=new FileReader(); r.onload=e=>{ p.src=e.target.result; p.classList.remove('hidden'); }; r.readAsDataURL(i.files[0]); } }
window.checkAvailability = async function() { const s=document.getElementById('date-start').value, e=document.getElementById('date-end').value; if(!s||!e)return; const {data} = await window.finSupabase.from('cotizaciones').select('id').eq('espacio_id',currentSpace.id).in('status',['aprobada','finalizada']).or(`and(fecha_inicio.lte.${e},fecha_fin.gte.${s})`); const msg=document.getElementById('avail-msg'); msg.classList.remove('hidden'); if(data.length){ msg.innerText='OCUPADO'; msg.className='text-red-500 font-bold text-center'; document.getElementById('btn-generate').disabled=true; }else{ msg.innerText='DISPONIBLE'; msg.className='text-green-600 font-bold text-center'; document.getElementById('btn-generate').disabled=false; } }
window.askDeleteSpace = async function(){ window.openConfirm("¿Eliminar espacio?", async () => { await window.finSupabase.from('espacios').delete().eq('id', document.getElementById('mgr-id').value); window.showToast("Eliminado"); window.closeModal('manager-modal'); loadCatalog(); }); }