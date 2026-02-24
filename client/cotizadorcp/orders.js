// =========================================================================
// MÓDULO DE COTIZACIONES ADMIN (EDICIÓN LIBRE DE COSTOS)
// =========================================================================
let orderClientProfiles = []; let orderClientProfilesById = {};

window.finalMontajeDates = [];
window.tempMontajeDates = [];
window.currentMontajePrefix = 'oed';

async function loadClientProfilesForOrderModal() {
    const sel = document.getElementById('oed-client-profile');
    const hid = document.getElementById('oed-client-id');
    if (!sel || !window.finSupabase) return;

    try {
        const { data, error } = await window.finSupabase.from('clientes').select('id,nombre_completo,telefono,correo,rfc').order('nombre_completo', { ascending: true });
        if (error) throw error;
        orderClientProfiles = data || []; orderClientProfilesById = {}; orderClientProfiles.forEach(c => orderClientProfilesById[c.id] = c);
        const current = sel.value;
        sel.innerHTML = '<option value="">— Sin perfil —</option>' + orderClientProfiles.map(c => `<option value="${c.id}">${(c.nombre_completo || '').toUpperCase()}</option>`).join('');
        if (current) sel.value = current;

        sel.onchange = () => {
            const id = sel.value; if (!id) { if (hid) hid.value = ''; return; }
            const c = orderClientProfilesById[id]; if (!c) return;
            if (hid) hid.value = id;
            if(document.getElementById('oed-client')) document.getElementById('oed-client').value = c.nombre_completo || '';
            if(document.getElementById('oed-phone')) document.getElementById('oed-phone').value = (c.telefono || '');
            if(document.getElementById('oed-email')) document.getElementById('oed-email').value = (c.correo || '');
            if(document.getElementById('fiscal-rfc-re')) document.getElementById('fiscal-rfc-re').value = (c.rfc || '');
        };
        const clearAssoc = () => { if (sel.value) sel.value = ''; if (hid) hid.value = ''; };
        ['oed-client','oed-phone','oed-email','fiscal-rfc-re'].forEach(id => { const el = document.getElementById(id); if (el) el.addEventListener('input', clearAssoc); });
    } catch (e) { console.warn("No se pudo cargar clientes", e); }
}

const _p = (window.location.pathname || '') + ' ' + (window.location.href || '');
const _isCP = /\/cotizadorcp(\/|$)/.test(window.location.pathname || '') || _p.includes('cotizadorcp');
const COMPANY_LOGO_URL = _isCP ? ((window.HUB_CONFIG && (window.HUB_CONFIG.companyLogoUrlCP || window.HUB_CONFIG.cpLogoUrl)) || 'http://127.0.0.1:54321/storage/v1/object/public/Espacios/logocp.png') : ((window.HUB_CONFIG && window.HUB_CONFIG.companyLogoUrl) || 'http://127.0.0.1:54321/storage/v1/object/public/Espacios/logo.png');

const SB_URL = window.HUB_CONFIG?.supabaseUrl || window.ENV?.SUPABASE_URL || '';
const SB_KEY = window.HUB_CONFIG?.supabaseAnonKey || window.ENV?.SUPABASE_ANON_KEY || '';
const FIN_SCHEMA = window.HUB_CONFIG?.finanzasSchema || window.ENV?.SCHEMA_CASA_PIEDRA || 'finanzas_casadepiedra';
const STATUS_LEVEL = { 'pendiente': 0, 'rechazada': 0, 'aprobada': 1, 'finalizada': 2 };

let allOrders = [], allSpaces = [], catalogConcepts = [], dbTaxes = [], currentPreviewOrder = null;
let currentConcepts = []; 
let myPermissions = { access: false, orders_edit: false };
let currentUserProfile = null;

window.safeFormatDate = function(dateStr) { if (!dateStr) return '--'; const parts = dateStr.split('-'); if (parts.length !== 3) return dateStr; return `${parts[2]}/${parts[1]}/${parts[0]}`; };
window.parseIds = function(v){ if(!v) return []; if(Array.isArray(v)) return v; if(typeof v === 'string'){ try { const parsed = JSON.parse(v); return Array.isArray(parsed) ? parsed : []; } catch(e){ return v.split(',').map(x=>x.trim()).filter(Boolean); } } return []; };

window.toggleCustomHorario = function(prefix) {
    const sel = document.getElementById(`${prefix}-horario`);
    const container = document.getElementById(`${prefix}-horario-custom`);
    if(sel && container) {
        if(sel.value === 'personalizado') container.classList.remove('hidden');
        else container.classList.add('hidden');
    }
}

function calculateDayByDayTotal(space, startStr, endStr, guests) {
    if (!startStr) return { total: 0, details: [] };
    const endS = endStr || startStr;
    let rules = [];
    try { rules = typeof space.precios_por_dia === 'string' ? JSON.parse(space.precios_por_dia) : (space.precios_por_dia || []); } catch(e){}
    if (!Array.isArray(rules) || rules.length === 0) rules = [{ min: 0, max: 999999, precios: {lunes: space.precio_base||0, martes:space.precio_base||0, miercoles:space.precio_base||0, jueves:space.precio_base||0, viernes:space.precio_base||0, sabado:space.precio_base||0, domingo:space.precio_base||0} }];
    
    const guestCount = parseInt(guests) || 1;
    let activeRule = rules.find(r => guestCount >= r.min && guestCount <= r.max);
    if (!activeRule) activeRule = rules[rules.length - 1];
    
    const prices = activeRule ? (activeRule.precios || {}) : {};
    let total = 0; let details = [];
    const start = new Date(startStr + 'T00:00:00'); const end = new Date(endS + 'T00:00:00'); const keys = ['domingo', 'lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado']; const names = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
    let blockedDays = []; try { blockedDays = typeof space.dias_bloqueados === 'string' ? JSON.parse(space.dias_bloqueados) : (space.dias_bloqueados || []); } catch(e){}
    
    for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) { 
        const dayIdx = d.getDay(); const key = keys[dayIdx]; 
        let price = parseFloat(prices[key] || 0); 
        if (blockedDays.includes(key)) price = 0;
        total += price; 
        details.push({ date: d.toLocaleDateString('es-MX'), dayName: names[dayIdx], price: price }); 
    }
    return { total, details };
}

window.openModal = (id) => { document.getElementById(id).classList.remove('hidden'); document.getElementById(id).classList.add('flex'); };
window.closeModal = (id) => { document.getElementById(id).classList.add('hidden'); document.getElementById(id).classList.remove('flex'); };
window.showToast = (msg, type='success') => { const c = document.getElementById('toast-container'); const e = document.createElement('div'); e.className = `p-4 rounded-lg shadow-lg text-white text-xs font-bold uppercase tracking-wider mb-2 animate-bounce ${type==='error'?'bg-red-500':'bg-green-500'}`; e.innerText = msg; c.appendChild(e); setTimeout(() => e.remove(), 3000); };
window.openStoredDocument = async function(path) { if(!path) return window.showToast("Documento no disponible", "error"); window.showToast("Abriendo documento...", "info"); const { data, error } = await window.globalSupabase.storage.from('documentos-cp').createSignedUrl(path, 3600); if (error || !data) return window.showToast("Error de acceso al archivo", "error"); window.open(data.signedUrl, '_blank'); };

let confirmCallback = null;
let cancelCallback = null;
window.openConfirm = function(msg, confirmCb, isWarning = false, confirmTxt = "Confirmar", cancelTxt = "Cancelar", cancelCb = null) { 
    const titleEl = document.getElementById('confirm-title'); 
    titleEl.innerHTML = isWarning ? `<i class="fa-solid fa-triangle-exclamation text-red-600 mb-2 text-2xl block"></i> ${msg}` : msg; 
    confirmCallback = confirmCb; 
    cancelCallback = cancelCb;
    document.getElementById('btn-confirm-action').innerText = confirmTxt;
    document.getElementById('btn-cancel-action').innerText = cancelTxt;
    window.openModal('generic-confirm-modal'); 
};

window.askCloseEditModal = function() {
    window.openConfirm(
        "¿Deseas guardar los cambios en la cotización?",
        () => { window.processSaveOrder(); }, 
        false,
        "Guardar Cambios",
        "Cerrar sin guardar",
        () => { window.closeModal('order-edit-modal'); }
    );
};

window.askDeleteOrder = function(id, e) { if(e) e.stopPropagation(); window.openConfirm("¿Eliminar cotización y TODOS sus archivos? Esta acción es irreversible.", async () => { try { window.showToast("Eliminando archivos...", "info"); const { data: files } = await window.globalSupabase.storage.from('documentos').list(`${id}`, { limit: 100 }); if (files && files.length > 0) { await window.globalSupabase.storage.from('documentos').remove(files.map(x => `${id}/${x.name}`)); } const { data: receiptFiles } = await window.globalSupabase.storage.from('documentos-cp').list(`${id}/recibos`); if (receiptFiles && receiptFiles.length > 0) { await window.globalSupabase.storage.from('documentos-cp').remove(receiptFiles.map(x => `${id}/recibos/${x.name}`)); } await window.finSupabase.from('cotizaciones').delete().eq('id', id); window.showToast("Cotización eliminada", "success"); window.loadOrders(); } catch (err) { window.showToast("Error: " + err.message, "error"); } }, true); };

window.addEventListener('click', function(e) {
    const editModal = document.getElementById('order-edit-modal');
    const docsModal = document.getElementById('docs-modal');
    const previewModal = document.getElementById('preview-modal');
    const confirmModal = document.getElementById('generic-confirm-modal');
    const montajeModal = document.getElementById('montaje-modal');

    if (!confirmModal.classList.contains('hidden')) {
        if(e.target === confirmModal) window.closeModal('generic-confirm-modal');
        return; 
    }

    if (e.target === editModal) window.askCloseEditModal();
    if (e.target === docsModal) window.closeModal('docs-modal');
    if (e.target === previewModal) window.closeModal('preview-modal');
    if (montajeModal && e.target === montajeModal) montajeModal.classList.add('hidden');
});

document.addEventListener('DOMContentLoaded', async () => {
    if (window.supabase) {
        if(!window.finSupabase) window.finSupabase = window.supabase.createClient(SB_URL, SB_KEY, { db: { schema: FIN_SCHEMA } });
        if(!window.globalSupabase) window.globalSupabase = window.supabase.createClient(SB_URL, SB_KEY);
    }
    const { data: { session } } = await window.globalSupabase.auth.getSession(); if (!session) return;
    
    const { data: profile } = await window.globalSupabase.from('profiles').select('*').eq('id', session.user.id).single();
    window.currentUserProfile = profile;

    document.getElementById('btn-confirm-action')?.addEventListener('click', () => { if(confirmCallback) confirmCallback(); window.closeModal('generic-confirm-modal'); });
    document.getElementById('btn-cancel-action')?.addEventListener('click', () => { if(cancelCallback) cancelCallback(); window.closeModal('generic-confirm-modal'); });

    document.getElementById('search-orders')?.addEventListener('input', (e) => filterOrders(e.target.value));
    document.getElementById('oed-start')?.addEventListener('change', function() { document.getElementById('oed-end').min = this.value; window.recalcTotal(); }); 
    document.getElementById('oed-end')?.addEventListener('change', () => window.recalcTotal()); 
    document.getElementById('oed-space')?.addEventListener('change', () => { window.updateB2bSelects(); window.recalcTotal(); const s = allSpaces.find(x => x.id == document.getElementById('oed-space').value); if(s) window.renderTaxesForSpace(s); });
    document.getElementById('new-concept-select')?.addEventListener('change', function() { const c = catalogConcepts.find(x => x.id == this.value); if(c) document.getElementById('new-concept-amount').value = c.precio_sugerido; });
    await Promise.all([loadTaxes(), loadSpaces(), loadConcepts()]); await window.loadOrders();
});

async function loadTaxes() { const { data } = await window.finSupabase.from('impuestos').select('*'); dbTaxes = data || []; }
async function loadSpaces() { const { data } = await window.finSupabase.from('espacios').select('*'); allSpaces = data || []; }
async function loadConcepts() { const { data } = await window.finSupabase.from('conceptos_catalogo').select('*').eq('activo', true); catalogConcepts = data || []; }

window.loadOrders = async function() { const { data } = await window.finSupabase.from('cotizaciones').select('*').order('created_at', {ascending:false}); allOrders = data || []; renderOrdersTable(allOrders); };

function renderOrdersTable(data) {
    const t = document.getElementById('orders-table'); if(!t) return; t.innerHTML = ''; 
    if(!data.length) { t.innerHTML = '<tr><td colspan="7" class="p-8 text-center text-gray-400">Sin registros.</td></tr>'; return; }
    data.forEach(o => {
        let sColor = 'bg-gray-100 text-gray-600', sText = 'Pendiente', missingIcons = []; 
        if(o.status === 'aprobada') { sColor = 'bg-blue-100 text-blue-700'; sText = 'Aprobada'; if (!o.contrato_url && !o.numero_contrato) missingIcons.push('<i class="fa-solid fa-file-signature" title="Falta Contrato"></i>'); if (!o.factura_xml_url) missingIcons.push('<i class="fa-solid fa-file-invoice" title="Falta Factura"></i>'); if (!o.historial_pagos || o.historial_pagos.length === 0) missingIcons.push('<i class="fa-solid fa-money-bill-wave" title="Falta Pago"></i>'); }
        if(o.status === 'finalizada') { sColor = 'bg-green-100 text-green-700 border border-green-200'; sText = 'Finalizada'; }
        if(o.status === 'rechazada') { sColor = 'bg-red-50 text-red-600'; sText = 'Rechazada'; }
        let alertsHTML = ''; if (missingIcons.length > 0 && o.status === 'aprobada') alertsHTML = `<div class="flex gap-2 justify-center mt-1.5 text-[10px] text-red-400">${missingIcons.join('')}</div>`;

        const tr = document.createElement('tr'); tr.className = "border-b hover:bg-gray-50 transition group cursor-pointer";
        tr.onclick = (e) => { if(!e.target.closest('button')) window.openOrderEditModal(o.id); };
        
        const folioUnificado = o.numero_orden || o.id.split('-')[0].toUpperCase();
        
        tr.innerHTML = `<td class="p-4 font-black text-brand-dark">${folioUnificado}</td><td class="p-4 font-bold text-xs text-gray-700">${o.cliente_nombre}</td><td class="p-4 text-xs"><span class="font-bold block">${o.espacio_nombre}</span><span class="text-gray-500 font-mono">${window.safeFormatDate(o.fecha_inicio)}</span></td><td class="p-4 text-right font-mono font-bold text-xs">${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(o.precio_final)}</td><td class="p-4 text-center"><span class="${sColor} px-2 py-1 rounded text-[9px] font-black uppercase tracking-wider">${sText}</span>${alertsHTML}</td><td class="p-4 text-center"><button onclick="event.stopPropagation(); window.openDocsModal('${o.id}')" class="bg-white border border-gray-300 text-gray-600 hover:bg-gray-50 hover:text-brand-dark px-3 py-1.5 rounded-lg text-xs font-bold transition shadow-sm flex items-center gap-2 mx-auto"><i class="fa-solid fa-folder-open text-brand-red"></i> Expediente</button></td><td class="p-4 text-center"><button onclick="window.askDeleteOrder('${o.id}', event)" class="text-gray-400 hover:text-red-600"><i class="fa-solid fa-trash"></i></button></td>`;
        t.appendChild(tr);
    });
}

function filterOrders(term) { 
    const lower = term.toLowerCase();
    renderOrdersTable(allOrders.filter(o => {
        const folioUnificado = o.numero_orden || o.id.split('-')[0].toUpperCase();
        return (o.cliente_nombre || '').toLowerCase().includes(lower) || 
               folioUnificado.toLowerCase().includes(lower);
    })); 
}

window.handleMontajeInput = function(prefix) {
    const val = parseInt(document.getElementById(prefix + '-premontaje').value) || 0;
    const btn = document.getElementById(prefix + '-btn-montaje');
    if (val > 0) btn.classList.remove('hidden'); else btn.classList.add('hidden');
    if (window.finalMontajeDates.length > val) window.finalMontajeDates = window.finalMontajeDates.slice(0, val);
    window.actualizarLabelMontaje(prefix);
    window.recalcTotal();
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
    
    const sDate = document.getElementById('oed-start').value;
    if (!sDate) return window.showToast("Primero selecciona la Fecha Inicio del evento.", "error");

    document.getElementById('montaje-limit-num').innerText = diasM;
    window.tempMontajeDates = [...window.finalMontajeDates].slice(0, diasM);
    
    const dp = document.getElementById('montaje-date-input');
    const maxD = new Date(sDate + 'T00:00:00'); 
    maxD.setDate(maxD.getDate() - 1);
    dp.max = maxD.toISOString().split('T')[0];
    dp.value = '';
    
    window.renderListaMontaje();
    window.openModal('montaje-modal');
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
    window.closeModal('montaje-modal');
    window.recalcTotal();
}

window.updateB2bSelects = function(skipDefaults = false) {
    const spaceId = document.getElementById('oed-space').value;
    const spaceObj = allSpaces.find(s => s.id == spaceId); 
    const selHorario = document.getElementById('oed-horario');
    selHorario.innerHTML = '';
    
    let b2b = {}; try { b2b = typeof spaceObj?.config_b2b === 'string' ? JSON.parse(spaceObj.config_b2b) : (spaceObj?.config_b2b || {}); } catch(e){}
    let h = b2b.horarios || [];
    if (!Array.isArray(h)) { 
        const mapNames = { matutino: 'Matutino', vespertino: 'Vespertino', nocturno: 'Nocturno', todo_dia: 'Todo el día' }; 
        h = Object.keys(h).map(k => ({ nombre: mapNames[k] || k, start: h[k]?.start, end: h[k]?.end, price: h[k]?.price })).filter(item => item.start && item.end); 
    }
    
    if (h.length > 0) { 
        h.forEach(item => { 
            selHorario.innerHTML += `<option value="${item.nombre}" data-price="${item.price}">${item.nombre} (${item.start} a ${item.end})</option>`; 
        }); 
    }
    selHorario.innerHTML += '<option value="personalizado" data-price="0">Personalizado...</option>';

    if(!skipDefaults) {
        document.getElementById('oed-premontaje-price').value = parseFloat(b2b.precio_montaje) || 0;
        document.getElementById('oed-horas-price').value = parseFloat(b2b.precio_hora_extra) || 0;
        document.getElementById('oed-premontaje').value = 0;
        document.getElementById('oed-horas').value = 0;
        document.getElementById('oed-horario-start').value = '';
        document.getElementById('oed-horario-end').value = '';
        document.getElementById('oed-horario-price').value = 0;
        window.finalMontajeDates = [];
        window.actualizarLabelMontaje('oed');
        window.toggleCustomHorario('oed');
    }
}

window.openOrderEditModal = async function(id) { 
    const order = allOrders.find(o => o.id === id); if (!order) return;
    await loadClientProfilesForOrderModal();
    currentPreviewOrder = order;

    document.getElementById('oed-id').value = order.id; document.getElementById('oed-client').value = order.cliente_nombre || ''; document.getElementById('oed-status').value = order.status; 
    const statusSelect = document.getElementById('oed-status'); const currentLevel = STATUS_LEVEL[order.status] || 0; Array.from(statusSelect.options).forEach(opt => opt.disabled = (STATUS_LEVEL[opt.value] || 0) < currentLevel);
    document.getElementById('oed-phone').value = order.cliente_contacto || ''; document.getElementById('oed-email').value = order.cliente_email || ''; document.getElementById('fiscal-rfc-re').value = order.cliente_rfc || ''; document.getElementById('oed-guests').value = order.personas || 1;

    const selCli = document.getElementById('oed-client-profile'); const hidCli = document.getElementById('oed-client-id');
    if (selCli) selCli.value = ''; if (hidCli) hidCli.value = '';
    if (order.cliente_id) { if (selCli) selCli.value = order.cliente_id; if (hidCli) hidCli.value = order.cliente_id; if (!orderClientProfilesById[order.cliente_id]) await loadClientProfilesForOrderModal(); }

    document.getElementById('oed-start').value = order.fecha_inicio; document.getElementById('oed-end').value = order.fecha_fin; 
    
    const sel = document.getElementById('oed-space'); sel.innerHTML = ''; 
    allSpaces.forEach(s => sel.innerHTML += `<option value="${s.id}" ${s.id == order.espacio_id ? 'selected' : ''}>${s.nombre}</option>`);
    
    window.updateB2bSelects(true);
    
    let dbConcepts = [];
    if (order.conceptos_adicionales) {
        if (typeof order.conceptos_adicionales === 'string') try { dbConcepts = JSON.parse(order.conceptos_adicionales); } catch(e){}
        else if (Array.isArray(order.conceptos_adicionales)) dbConcepts = order.conceptos_adicionales;
    }

    let pureConcepts = []; let cHorarioText = null, cMontaje = 0, cHoras = 0;
    let isCustomHorario = false, customStart = '', customEnd = '', customHorarioPrice = 0;
    let cMontajePrice = 0, cHorasPrice = 0;

    window.finalMontajeDates = [];

    dbConcepts.forEach(c => {
        if(c.type === 'b2b_horario' || (c.description && c.description.startsWith('Horario:'))) {
            cHorarioText = c.meta?.selected || c.description.replace('Horario:', '').trim();
            if(c.meta?.selected === 'personalizado' || !c.meta?.selected) {
                isCustomHorario = true; 
                customHorarioPrice = parseFloat(c.amount) || 0;
                let savedName = c.meta?.custom_name || cHorarioText;
                let times = savedName.match(/\d{2}:\d{2}/g);
                if(times && times.length >= 2) { customStart = times[0]; customEnd = times[1]; }
            }
        }
        else if(c.type === 'b2b_montaje' || (c.description && c.description.startsWith('Montaje'))) {
            cMontaje = c.meta?.days || parseInt(c.description.match(/\d+/)?.[0] || 0);
            cMontajePrice = c.meta?.unit_price || (cMontaje > 0 ? parseFloat(c.amount)/cMontaje : 0);
            if(c.meta?.dates) window.finalMontajeDates = c.meta.dates;
        }
        else if(c.type === 'b2b_horas' || (c.description && c.description.startsWith('Horas Extras'))) {
            cHoras = c.meta?.hours || parseInt(c.description.match(/\d+/)?.[0] || 0);
            cHorasPrice = c.meta?.unit_price || (cHoras > 0 ? parseFloat(c.amount)/cHoras : 0);
        }
        else pureConcepts.push(c);
    });
    
    currentConcepts = pureConcepts;
    
    const selHorario = document.getElementById('oed-horario');
    let found = false;
    
    if(cHorarioText && !isCustomHorario) {
        Array.from(selHorario.options).forEach(opt => { 
            if(opt.text.includes(cHorarioText) || cHorarioText.includes(opt.value)) { opt.selected = true; found = true; } 
        });
    }
    
    if(isCustomHorario || (!found && cHorarioText && cHorarioText !== 'Sin horario configurado')) {
        selHorario.value = 'personalizado';
        document.getElementById('oed-horario-start').value = customStart;
        document.getElementById('oed-horario-end').value = customEnd;
        document.getElementById('oed-horario-price').value = customHorarioPrice || (dbConcepts.find(c => c.type === 'b2b_horario' || (c.description && c.description.startsWith('Horario:')))?.amount || 0);
    }
    
    window.toggleCustomHorario('oed');

    document.getElementById('oed-premontaje').value = cMontaje;
    document.getElementById('oed-premontaje-price').value = cMontajePrice;
    window.handleMontajeInput('oed');

    document.getElementById('oed-horas').value = cHoras;
    document.getElementById('oed-horas-price').value = cHorasPrice;
    
    if(document.getElementById('oed-adj-type')) { document.getElementById('oed-adj-type').value = order.tipo_ajuste || 'ninguno'; document.getElementById('oed-adj-val').value = order.valor_ajuste || 0; document.getElementById('oed-adj-unit').value = order.ajuste_es_porcentaje ? 'percent' : 'fixed'; }
    
    const isLocked = ['aprobada', 'finalizada'].includes(order.status);
    document.querySelectorAll('#order-edit-modal input, #order-edit-modal select').forEach(i => { if(i.id !== 'btn-save-progress' && i.id !== 'oed-status') i.disabled = isLocked; });
    document.getElementById('oed-btn-montaje').disabled = isLocked;

    const spaceObj = allSpaces.find(s => s.id == order.espacio_id);
    if(spaceObj) window.renderTaxesForSpace(spaceObj, order.desglose_precios?.impuestos_detalle);
    
    const conceptSel = document.getElementById('new-concept-select'); conceptSel.innerHTML = '<option value="">-- Agregar --</option>'; catalogConcepts.forEach(c => conceptSel.innerHTML += `<option value="${c.id}">${c.nombre}</option>`);

    window.renderConceptsList(); window.recalcTotal(); window.openModal('order-edit-modal');
};

window.renderTaxesForSpace = function(spaceObj, activeTaxIds = null) {
    const container = document.getElementById('oed-taxes-list'); if(!container) return; container.innerHTML = '';
    const defaultTaxIds = window.parseIds(spaceObj.impuestos_ids || spaceObj.impuestos); const isLocked = currentPreviewOrder && ['aprobada', 'finalizada'].includes(currentPreviewOrder.status);
    dbTaxes.forEach(t => { let isChecked = activeTaxIds ? activeTaxIds.includes(t.id) : defaultTaxIds.includes(t.id); container.innerHTML += `<label class="flex items-center gap-1.5 cursor-pointer ${isLocked ? 'opacity-70' : ''}"><input type="checkbox" value="${t.id}" class="oed-tax-check accent-brand-red w-3 h-3" ${isChecked ? 'checked' : ''} ${isLocked ? 'disabled' : ''} onchange="window.recalcTotal()"><span class="text-[10px] font-bold uppercase text-gray-700">${t.nombre}</span></label>`; });
};

window.updateConceptAmount = function(index, newVal) { currentConcepts[index].amount = parseFloat(newVal) || 0; currentConcepts[index].value = parseFloat(newVal) || 0; window.recalcTotal(); };
window.updateConceptName = function(index, newName) { currentConcepts[index].description = newName; };

window.renderConceptsList = function() { 
    const tbody = document.getElementById('concepts-list'); if(!tbody) return; tbody.innerHTML = ''; 
    const isLocked = currentPreviewOrder && ['aprobada', 'finalizada'].includes(currentPreviewOrder.status);
    if (!currentConcepts || currentConcepts.length === 0) { tbody.innerHTML = '<tr><td colspan="3" class="p-3 text-center text-gray-400 italic text-[10px]">Sin conceptos adicionales extra.</td></tr>'; return; }

    currentConcepts.forEach((c, idx) => {
        const val = parseFloat(c.amount || c.value || 0);
        const desc = c.description || c.concepto || c.nombre || 'Concepto';
        const btn = isLocked ? '' : `<button onclick="window.removeConceptRow(${idx})" class="text-gray-300 hover:text-red-500"><i class="fa-solid fa-xmark"></i></button>`;
        const descCol = isLocked ? desc : `<input type="text" value="${desc}" class="w-full bg-transparent border-b border-transparent hover:border-gray-200 focus:border-brand-red outline-none transition" onchange="window.updateConceptName(${idx}, this.value)">`;
        const valCol = isLocked ? `$${val.toLocaleString()}` : `$<input type="number" value="${val}" min="0" class="w-20 bg-transparent border-b border-transparent hover:border-gray-200 focus:border-brand-red outline-none text-right font-bold transition" onchange="window.updateConceptAmount(${idx}, this.value)">`;
        tbody.innerHTML += `<tr><td class="p-2 border-b text-slate-700">${descCol}</td><td class="p-2 border-b text-right text-xs">${valCol}</td><td class="p-2 border-b text-center">${btn}</td></tr>`;
    });
};

window.updateSummaryUI = function() {
    const sDate = document.getElementById('oed-start').value;
    const eDate = document.getElementById('oed-end').value;
    document.getElementById('sum-dates').innerText = (sDate && eDate) ? (sDate === eDate ? window.safeFormatDate(sDate) : `${window.safeFormatDate(sDate)} al ${window.safeFormatDate(eDate)}`) : '--';
    document.getElementById('sum-guests').innerText = (document.getElementById('oed-guests').value || '0') + ' px';
    
    const selOpt = document.getElementById('oed-horario').options[document.getElementById('oed-horario').selectedIndex];
    let timeText = selOpt ? selOpt.text : '--';
    if(selOpt && selOpt.value === 'personalizado') {
        const tStart = document.getElementById('oed-horario-start').value;
        const tEnd = document.getElementById('oed-horario-end').value;
        timeText = (tStart && tEnd) ? `${tStart} a ${tEnd}` : 'Personalizado';
    }
    document.getElementById('sum-schedule').innerText = timeText;
    
    const diasM = parseInt(document.getElementById('oed-premontaje').value) || 0;
    let mtjTxt = diasM > 0 ? `${diasM} día(s)` : '--';
    if(diasM > 0 && window.finalMontajeDates.length) mtjTxt += `<br><span class="text-[9px] font-normal text-gray-400">(${window.finalMontajeDates.map(d=>window.safeFormatDate(d)).join(', ')})</span>`;
    document.getElementById('sum-montaje').innerHTML = mtjTxt;
    
    const hrsE = parseInt(document.getElementById('oed-horas').value) || 0;
    document.getElementById('sum-hextras').innerText = hrsE > 0 ? `${hrsE} hr(s)` : '--';
};

window.recalcTotal = function() { 
    const spaceId = document.getElementById('oed-space').value; const spaceObj = allSpaces.find(s => s.id == spaceId); 
    const sDate = document.getElementById('oed-start').value; const eDate = document.getElementById('oed-end').value; const guests = document.getElementById('oed-guests').value; 

    let base = 0; if (spaceObj && sDate && eDate) { base = calculateDayByDayTotal(spaceObj, sDate, eDate, guests).total; } else if (spaceObj) { base = parseFloat(spaceObj.precio_base); }
    
    let pMontaje = parseFloat(document.getElementById('oed-premontaje-price').value) || 0; 
    let pHora = parseFloat(document.getElementById('oed-horas-price').value) || 0;
    
    const selOpt = document.getElementById('oed-horario').options[document.getElementById('oed-horario').selectedIndex];
    let costoHorario = 0;
    if(selOpt && selOpt.value === 'personalizado') costoHorario = parseFloat(document.getElementById('oed-horario-price').value) || 0;
    else if(selOpt) costoHorario = parseFloat(selOpt.getAttribute('data-price')) || 0;

    const diasM = parseInt(document.getElementById('oed-premontaje').value) || 0; const hrsE = parseInt(document.getElementById('oed-horas').value) || 0;
    
    let b2bCost = costoHorario + (diasM * pMontaje) + (hrsE * pHora);
    
    let conceptsHtml = '';
    let conceptsSum = 0;
    (currentConcepts || []).forEach(c => { 
        let amt = parseFloat(c.amount || c.value || 0);
        conceptsSum += amt; 
        conceptsHtml += `<div class="flex justify-between text-[10px] text-gray-500"><span><i class="fa-solid fa-plus text-gray-300 mr-1"></i> ${c.description}</span><span>+${amt.toLocaleString('es-MX', {style:'currency',currency:'MXN'})}</span></div>`;
    }); 
    document.getElementById('oed-summary-concepts').innerHTML = conceptsHtml;
    
    let sub = base + conceptsSum + b2bCost;
    
    const adjType = document.getElementById('oed-adj-type').value; const adjVal = parseFloat(document.getElementById('oed-adj-val').value) || 0; const isPercent = document.getElementById('oed-adj-unit').value === 'percent';
    let adjAmount = 0; if (adjType !== 'ninguno') { adjAmount = isPercent ? sub * (adjVal/100) : adjVal; if (adjType === 'descuento') sub -= adjAmount; else sub += adjAmount; }

    let taxTotal = 0; let taxHtml = '';
    document.querySelectorAll('.oed-tax-check:checked').forEach(cb => { const t = dbTaxes.find(x => x.id == cb.value); if(t) { const taxVal = sub * (t.porcentaje / 100); taxTotal += taxVal; taxHtml += `<div class="flex justify-between text-[10px] text-gray-500"><span>${t.nombre}</span><span>+${taxVal.toLocaleString('es-MX', {style:'currency',currency:'MXN'})}</span></div>`; } });

    document.getElementById('oed-tax-summary-display').innerHTML = taxHtml;
    document.getElementById('lbl-subtotal-base').innerText = (base + b2bCost).toLocaleString('es-MX', {style:'currency',currency:'MXN'});
    document.getElementById('lbl-adjustment').innerText = (adjType==='descuento'?'-':'+') + adjAmount.toLocaleString('es-MX', {style:'currency',currency:'MXN'});
    document.getElementById('oed-price').value = (sub + taxTotal).toFixed(2);
    window.updatePriceColor();

    if(window.updateSummaryUI) window.updateSummaryUI();
};

window.updatePriceColor = function() { const spaceId = document.getElementById('oed-space').value; const priceInput = document.getElementById('oed-price'); const val = parseFloat(priceInput.value) || 0; const space = allSpaces.find(s => s.id == spaceId); if(!space) return; const base = parseFloat(space.precio_base); priceInput.classList.remove('text-green-600', 'text-red-600', 'text-gray-700'); if (val < base) priceInput.classList.add('text-green-600'); else if (val > base) priceInput.classList.add('text-red-600'); else priceInput.classList.add('text-gray-700'); };

window.addConceptRow = function() { 
    const id = document.getElementById('new-concept-select').value; const amount = parseFloat(document.getElementById('new-concept-amount').value);
    if (!id && isNaN(amount)) return;
    if (id) { const c = catalogConcepts.find(x => x.id == id); currentConcepts.push({ description: c.nombre, amount: amount || c.precio_sugerido, value: amount || c.precio_sugerido, unit: 'fixed', type: 'aumento' }); } 
    else { currentConcepts.push({ description: 'Concepto libre', amount: amount, value: amount, unit: 'fixed', type: 'aumento' }); }
    document.getElementById('new-concept-select').value = ""; document.getElementById('new-concept-amount').value = "";
    window.renderConceptsList(); window.recalcTotal();
};

window.removeConceptRow = function(index) { currentConcepts.splice(index, 1); window.renderConceptsList(); window.recalcTotal(); };

window.attemptSaveOrder = function() {
    const newStatus = document.getElementById('oed-status').value; const currentLevel = STATUS_LEVEL[currentPreviewOrder.status] || 0; const newLevel = STATUS_LEVEL[newStatus] || 0;
    if (newLevel < currentLevel) return window.showToast("No puedes regresar a un estado anterior.", "error");
    
    const diasM = parseInt(document.getElementById('oed-premontaje').value) || 0;
    if(diasM > 0 && window.finalMontajeDates.length !== diasM) {
        return window.showToast("Debes seleccionar las fechas de montaje en el botón de calendario.", "error");
    }

    if (newStatus === 'aprobada' && currentPreviewOrder.status !== 'aprobada') {
        const missing = []; if(!document.getElementById('oed-client').value) missing.push("Nombre Cliente"); if(!document.getElementById('oed-email').value) missing.push("Email"); if(!document.getElementById('fiscal-rfc-re').value) missing.push("RFC"); if(!document.getElementById('oed-start').value) missing.push("Fechas");
        if (missing.length > 0) return window.openConfirm(`<p class="text-red-600 font-bold mb-2">Faltan datos para aprobar:</p><ul class="list-disc ml-4 text-xs text-left">${missing.map(m=>`<li>${m}</li>`).join('')}</ul>`, () => window.closeModal('generic-confirm-modal'), true);
        window.initiateApprovalSnapshot();
    } else { window.processSaveOrder(); }
};

window.initiateApprovalSnapshot = async function() {
    const formData = window.getFormDataFromModal();
    if (!formData.numero_orden) { formData.numero_orden = currentPreviewOrder.id.split('-')[0].toUpperCase(); }
    
    const content = window.getOrderHTML({ ...currentPreviewOrder, ...formData }, 'quote'); 
    const pdfContainer = document.getElementById('pdf-content'); const embedViewer = document.getElementById('doc-preview'); const btnAction = document.getElementById('btn-download-preview');
    pdfContainer.innerHTML = content; pdfContainer.classList.remove('hidden'); embedViewer.classList.add('hidden'); btnAction.innerHTML = '<i class="fa-solid fa-check-circle"></i> Confirmar Aprobación'; btnAction.className = "bg-green-600 hover:bg-green-700 text-white px-5 py-2 rounded-full text-xs font-bold uppercase shadow-lg transition flex items-center gap-2"; document.getElementById('prev-order-num').innerText = "VISTA PREVIA DE APROBACIÓN"; btnAction.onclick = () => window.executeApprovalTransaction(formData); window.openModal('preview-modal');
};

window.executeApprovalTransaction = async function(formData) {
    const btn = document.getElementById('btn-download-preview'); btn.disabled = true; btn.innerText = "Generando Snapshot...";
    try {
        const element = document.getElementById('pdf-content'); const pdfBlob = await html2pdf().set({ margin: 0, image: { type: 'jpeg', quality: 0.98 }, html2canvas: { scale: 2, useCORS: true }, jsPDF: { unit: 'in', format: 'letter' } }).from(element).output('blob');
        const folioUnificado = formData.numero_orden || currentPreviewOrder.id.split('-')[0].toUpperCase();
        const path = `${currentPreviewOrder.id}/cotizacion_aprobada_${folioUnificado}.pdf`; await window.globalSupabase.storage.from('documentos-cp').upload(path, pdfBlob);
        const payload = { ...formData, status: 'aprobada', url_cotizacion_final: path }; await window.finSupabase.from('cotizaciones').update(payload).eq('id', currentPreviewOrder.id);
        const link = document.createElement('a'); link.href = URL.createObjectURL(pdfBlob); link.download = `Cotizacion_Aprobada_${folioUnificado}.pdf`; link.click();
        window.showToast("¡Cotización Aprobada y Archivada!", "success"); window.closeModal('preview-modal'); window.closeModal('order-edit-modal'); await window.loadOrders();
    } catch (e) { console.error(e); window.showToast("Error: " + e.message, "error"); btn.disabled = false; btn.innerText = "Reintentar"; }
};

window.getFormDataFromModal = function() {
    const spaceId = document.getElementById('oed-space').value; const spaceObj = allSpaces.find(s => s.id == spaceId); 
    const sDate = document.getElementById('oed-start').value; const eDate = document.getElementById('oed-end').value; const guests = parseInt(document.getElementById('oed-guests').value) || 1;
    let base = 0; if (spaceObj && sDate && eDate) { base = calculateDayByDayTotal(spaceObj, sDate, eDate, guests).total; } else if (spaceObj) { base = parseFloat(spaceObj.precio_base); }

    let pMontaje = parseFloat(document.getElementById('oed-premontaje-price').value) || 0; 
    let pHora = parseFloat(document.getElementById('oed-horas-price').value) || 0;
    
    let b2bConceptsToSave = [];
    const selOpt = document.getElementById('oed-horario').options[document.getElementById('oed-horario').selectedIndex];
    
    let costoHorario = 0; let textoHorario = '';
    if(selOpt && selOpt.value === 'personalizado') { 
        costoHorario = parseFloat(document.getElementById('oed-horario-price').value) || 0; 
        const ts = document.getElementById('oed-horario-start').value;
        const te = document.getElementById('oed-horario-end').value;
        textoHorario = (ts && te) ? `${ts} a ${te}` : 'Horario Personalizado'; 
    }
    else if(selOpt) { costoHorario = parseFloat(selOpt.getAttribute('data-price')) || 0; textoHorario = selOpt.text; }

    if(selOpt) b2bConceptsToSave.push({ description: `Horario: ${textoHorario}`, amount: costoHorario, value: costoHorario, unit: 'fixed', type: 'b2b_horario', meta: { selected: selOpt.value, custom_name: textoHorario } });
    
    const diasM = parseInt(document.getElementById('oed-premontaje').value) || 0;
    if(diasM > 0) b2bConceptsToSave.push({ description: `Montaje extra (${diasM} días)${window.finalMontajeDates.length ? ' - ' + window.finalMontajeDates.map(d=>window.safeFormatDate(d)).join(', ') : ''}`, amount: diasM * pMontaje, value: diasM * pMontaje, unit: 'fixed', type: 'b2b_montaje', meta: { days: diasM, unit_price: pMontaje, dates: window.finalMontajeDates } });
    
    const hrsE = parseInt(document.getElementById('oed-horas').value) || 0;
    if(hrsE > 0) b2bConceptsToSave.push({ description: `Horas Extras (${hrsE} hrs)`, amount: hrsE * pHora, value: hrsE * pHora, unit: 'fixed', type: 'b2b_horas', meta: { hours: hrsE, unit_price: pHora } });

    const finalConcepts = [...b2bConceptsToSave, ...currentConcepts];

    let conceptsSum = 0; finalConcepts.forEach(c => { conceptsSum += parseFloat(c.amount || c.value || 0); }); let sub = base + conceptsSum;
    const activeTaxIds = Array.from(document.querySelectorAll('.oed-tax-check:checked')).map(cb => parseInt(cb.value)); const priceFinal = parseFloat(document.getElementById('oed-price').value);
    const adjType = document.getElementById('oed-adj-type').value; const adjVal = parseFloat(document.getElementById('oed-adj-val').value) || 0; const isPercent = document.getElementById('oed-adj-unit').value === 'percent';

    return {
        cliente_nombre: document.getElementById('oed-client').value, cliente_email: document.getElementById('oed-email').value, cliente_contacto: document.getElementById('oed-phone').value, cliente_rfc: document.getElementById('fiscal-rfc-re').value, cliente_id: (document.getElementById('oed-client-id') ? (document.getElementById('oed-client-id').value || null) : null), fecha_inicio: sDate, fecha_fin: eDate, precio_final: priceFinal, espacio_id: spaceId, espacio_nombre: spaceObj ? spaceObj.nombre : '', espacio_clave: spaceObj ? spaceObj.clave : '', tipo_ajuste: adjType, valor_ajuste: adjVal, ajuste_es_porcentaje: isPercent,
        conceptos_adicionales: finalConcepts, desglose_precios: { subtotal_antes_impuestos: sub, impuestos_detalle: activeTaxIds }, personas: guests 
    };
};

window.processSaveOrder = async function() {
    const btn = document.getElementById('btn-save-progress'); btn.disabled = true; btn.innerText = "Guardando...";
    try { 
        const formData = window.getFormDataFromModal(); 
        formData.status = document.getElementById('oed-status').value; 
        if(!formData.numero_orden) formData.numero_orden = currentPreviewOrder.id.split('-')[0].toUpperCase();
        
        const { error } = await window.finSupabase.from('cotizaciones').update(formData).eq('id', document.getElementById('oed-id').value); 
        if (error) throw error; 
        window.showToast("Cambios guardados", "success"); 
        window.closeModal('order-edit-modal'); 
        await window.loadOrders(); 
    } catch(e) { window.showToast("Error: " + e.message, "error"); } finally { btn.disabled = false; btn.innerText = "Guardar Directamente"; }
};

window.previewOrderForGeneration = function(id) {
    const order = allOrders.find(o => o.id === id); if(!order) return; currentPreviewOrder = { ...order, docType: 'order' }; const content = window.getOrderHTML(order, 'order'); const pdfContainer = document.getElementById('pdf-content'); const embed = document.getElementById('doc-preview'); pdfContainer.innerHTML = content; pdfContainer.classList.remove('hidden'); embed.classList.add('hidden'); const btn = document.getElementById('btn-download-preview'); btn.innerHTML = '<i class="fa-solid fa-file-contract"></i> Confirmar y Generar OC'; btn.className = "bg-purple-600 hover:bg-purple-700 text-white px-5 py-2 rounded-full text-xs font-bold uppercase shadow-lg transition flex items-center gap-2"; btn.onclick = window.confirmAndGeneratePurchaseOrder; window.openModal('preview-modal');
};

window.confirmAndGeneratePurchaseOrder = async function() {
    window.openConfirm("¿Generar Orden de Compra Oficial? Se guardará una copia exacta.", async () => { const btn = document.getElementById('btn-download-preview'); btn.disabled = true; btn.innerText = "Generando OC..."; try { const element = document.getElementById('pdf-content'); const pdfBlob = await html2pdf().set({ margin: 0, image: { type: 'jpeg', quality: 0.98 }, html2canvas: { scale: 2, useCORS: true }, jsPDF: { unit: 'in', format: 'letter' } }).from(element).output('blob'); const folioUnificado = currentPreviewOrder.numero_orden || currentPreviewOrder.id.split('-')[0].toUpperCase(); const path = `${currentPreviewOrder.id}/orden_compra_${folioUnificado}.pdf`; await window.globalSupabase.storage.from('documentos-cp').upload(path, pdfBlob); await window.finSupabase.from('cotizaciones').update({ url_orden_compra: path, fecha_orden_compra: new Date().toISOString() }).eq('id', currentPreviewOrder.id); const link = document.createElement('a'); link.href = URL.createObjectURL(pdfBlob); link.download = `OC_${folioUnificado}.pdf`; link.click(); window.showToast("Orden de Compra Generada"); await window.loadOrders(); window.closeModal('preview-modal'); window.closeModal('docs-modal'); } catch(e) { window.showToast("Error al generar OC", "error"); } finally { btn.disabled = false; } });
};

window.openDocsModal = function(id) {
    const order = allOrders.find(o => o.id === id); if(!order) return; document.getElementById('doc-client').innerText = order.cliente_nombre; 
    const folioUnificado = order.numero_orden || order.id.split('-')[0].toUpperCase();
    document.getElementById('doc-folio').innerText = folioUnificado; 
    document.getElementById('doc-space').innerText = order.espacio_nombre; document.getElementById('doc-dates').innerText = `${window.safeFormatDate(order.fecha_inicio)} - ${window.safeFormatDate(order.fecha_fin)}`; const list = document.getElementById('docs-list'); list.innerHTML = '';
    const createBtn = (label, icon, color, action) => { list.innerHTML += `<button onclick="${action}" class="w-full text-left px-4 py-3 rounded-xl border border-gray-200 hover:bg-gray-50 flex items-center gap-3 transition shadow-sm group bg-white mb-2"><div class="w-8 h-8 rounded-full bg-${color}-100 text-${color}-600 flex items-center justify-center shrink-0"><i class="${icon}"></i></div><div class="flex-grow"><p class="text-xs font-bold text-gray-700">${label}</p></div><i class="fa-solid fa-arrow-right text-xs text-gray-300"></i></button>`; };
    if (order.url_cotizacion_final) createBtn('Ver Cotización Aprobada', 'fa-solid fa-file-circle-check', 'blue', `window.openStoredDocument('${order.url_cotizacion_final}')`); else createBtn('Ver Borrador Cotización', 'fa-solid fa-file-pen', 'gray', `window.openPDFPreview('${order.id}', 'quote')`); 
    if (order.url_orden_compra) createBtn('Ver Orden de Compra', 'fa-solid fa-file-contract', 'purple', `window.openStoredDocument('${order.url_orden_compra}')`); else if(['aprobada', 'finalizada'].includes(order.status)) createBtn('Generar Orden de Compra', 'fa-solid fa-plus', 'purple', `window.previewOrderForGeneration('${order.id}')`); else list.innerHTML += `<div class="w-full px-4 py-3 rounded-xl border border-gray-100 bg-gray-50 flex items-center gap-3 mb-2 opacity-60"><i class="fa-solid fa-lock text-gray-400"></i><span class="text-xs font-bold text-gray-400">Orden de Compra (Pendiente)</span></div>`; 
    if (order.contrato_url) createBtn('Ver Contrato Firmado', 'fa-solid fa-file-signature', 'indigo', `window.openStoredDocument('${order.contrato_url}')`); else list.innerHTML += `<div class="w-full px-4 py-3 rounded-xl border border-gray-100 bg-gray-50 flex items-center gap-3 mb-2 opacity-60"><i class="fa-solid fa-signature text-gray-400"></i><span class="text-xs font-bold text-gray-400">Contrato (Pendiente Firma)</span></div>`; 
    if (order.factura_pdf_url) { createBtn('Ver Factura (PDF)', 'fa-solid fa-file-pdf', 'red', `window.openStoredDocument('${order.factura_pdf_url}')`); if(order.factura_xml_url) createBtn('Descargar XML', 'fa-solid fa-file-code', 'orange', `window.openStoredDocument('${order.factura_xml_url}')`); } else list.innerHTML += `<div class="w-full px-4 py-3 rounded-xl border border-gray-100 bg-gray-50 flex items-center gap-3 mb-2 opacity-60"><i class="fa-solid fa-file-invoice-dollar text-gray-400"></i><span class="text-xs font-bold text-gray-400">Factura (Pendiente)</span></div>`; 
    if (order.historial_pagos?.length > 0) { const divider = document.createElement('div'); divider.className = 'border-t border-gray-100 my-2 pt-2 text-[10px] font-bold text-gray-400 uppercase text-center'; divider.innerText = 'Historial de Recibos'; list.appendChild(divider); order.historial_pagos.forEach((p, i) => createBtn(`Recibo #${i+1}`, 'fa-solid fa-receipt', 'green', `window.openStoredDocument('${p.file_path}')`)); } window.openModal('docs-modal');
};

window.openPDFPreview = function(id, type) { const o = allOrders.find(x => x.id === id); if(!o) return; currentPreviewOrder = { ...o, docType: type }; const content = window.getOrderHTML(o, type); const pdfContainer = document.getElementById('pdf-content'); const embedViewer = document.getElementById('doc-preview'); const btnDownload = document.getElementById('btn-download-preview'); pdfContainer.classList.remove('hidden'); embedViewer.classList.add('hidden'); pdfContainer.innerHTML = content; btnDownload.innerHTML = '<i class="fa-solid fa-download"></i> Descargar'; btnDownload.className = "bg-brand-red hover:bg-red-600 text-white px-5 py-2 rounded-full text-xs font-bold uppercase shadow-lg transition flex items-center gap-2"; btnDownload.onclick = window.downloadPDFFromPreview; window.openModal('preview-modal'); };
window.downloadPDFFromPreview = function() { const element = document.getElementById('pdf-content'); const folioUnificado = currentPreviewOrder.numero_orden || currentPreviewOrder.id.split('-')[0].toUpperCase(); const opt = { margin: 0, filename: `Documento_${folioUnificado}.pdf`, image: { type: 'jpeg', quality: 0.98 }, html2canvas: { scale: 2, useCORS: true }, jsPDF: { unit: 'in', format: 'letter' } }; html2pdf().set(opt).from(element).save(); };

window.getOrderHTML = function(o, type) { 
    const isOrder = type === 'order'; 
    const logoImg = `<img src="${COMPANY_LOGO_URL}" class="h-16 object-contain" crossorigin="anonymous">`; 
    const now = new Date(); const dateStr = now.toLocaleDateString('es-MX', { day: '2-digit', month: '2-digit', year: 'numeric' }); const genDateTime = now.toLocaleString('es-MX', { dateStyle: 'short', timeStyle: 'medium' }); let docTitle = isOrder ? "ORDEN DE COMPRA" : "COTIZACIÓN"; 
    
    const folioUnificado = o.numero_orden || o.id.split('-')[0].toUpperCase();
    const space = allSpaces.find(s=>s.id==o.espacio_id); const descHTML = isOrder ? '' : `<p class="text-[9px] text-gray-500 italic mt-0.5 truncate max-w-xs">${space?.descripcion || ''}</p>`; const footerHubHTML = `<div class="w-full text-center mt-10"><p class="text-[10px] text-gray-400 font-medium leading-tight">Generado el ${genDateTime}<br>a través de Marketing Hub</p></div>`; 
    
    const renderHeader = (title) => `<div class="flex justify-between items-start border-b-4 border-brand-red pb-3 mb-2">${logoImg}<div class="text-right"><h1 class="text-2xl font-black text-gray-800 tracking-tighter uppercase">${title}</h1><p class="text-sm font-mono text-brand-red font-bold mt-1">FOLIO: ${folioUnificado}</p><p class="text-[10px] text-gray-500 mt-1">${dateStr}</p></div></div>`; 
    
    let clientName = o.cliente_nombre; let clientRfc = o.cliente_rfc; let nameSizeClass = 'text-xl'; if (clientName.length > 35) nameSizeClass = 'text-xs'; else if (clientName.length > 25) nameSizeClass = 'text-sm'; 
    const guests = o.personas || 1;
    const clientComponent = `<div class="flex flex-row justify-between items-center mb-2 p-2 bg-gray-50 rounded border border-gray-100"><div class="w-1/2 border-r border-gray-200 pr-2"><p class="font-black text-[9px] text-gray-400 uppercase tracking-wider mb-0.5">Cliente / Empresa</p><p class="font-black ${nameSizeClass} text-gray-800 leading-tight">${clientName}</p></div><div class="w-1/2 pl-2"><p class="font-black text-[9px] text-gray-400 uppercase tracking-wider mb-0.5">Contacto / Fiscal</p><p class="font-mono text-xs text-gray-700 truncate">${o.cliente_email || 'Sin correo'}</p>${clientRfc ? `<p class="font-mono text-xs text-gray-700 mt-0.5">RFC: <strong>${clientRfc}</strong></p>` : ''}<p class="font-mono text-xs text-brand-red font-bold mt-1">Personas: ${guests}</p></div></div>`; 
    
    let rentalRows = ''; let rentalTotal = 0;
    if (space && o.fecha_inicio && o.fecha_fin) {
        const dayBreakdown = calculateDayByDayTotal(space, o.fecha_inicio, o.fecha_fin, guests);
        rentalTotal = dayBreakdown.total;
        dayBreakdown.details.forEach((day, idx) => { rentalRows += `<tr><td class="py-2 px-3 text-xs text-gray-700"><span class="font-bold">${space.nombre}</span> - Renta ${day.dayName}${idx === 0 ? `<br><span class="text-[9px] text-gray-400 italic">${space.clave}</span>` : ''}</td><td class="py-2 px-3 text-center text-xs text-gray-500">${day.date}</td><td class="py-2 px-3 text-right font-bold text-xs text-gray-700">${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(day.price)}</td></tr>`; });
    } else {
        const basePrice = parseFloat(space ? space.precio_base : 0); rentalTotal = basePrice;
        rentalRows = `<tr><td class="py-2 px-3 align-top"><p class="font-bold text-gray-800 text-xs">${o.espacio_nombre}</p>${descHTML}<span class="bg-gray-100 text-gray-500 px-1 py-0.5 rounded text-[10px] font-mono mt-0.5 inline-block">${o.espacio_clave || ''}</span></td><td class="py-2 px-3 align-top text-center text-gray-500 text-xs">${window.safeFormatDate(o.fecha_inicio)}<br>${window.safeFormatDate(o.fecha_fin)}</td><td class="py-2 px-3 align-top text-right font-bold text-gray-700 text-xs">${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(basePrice)}</td></tr>`;
    }
    
    let runningSubtotal = rentalTotal; let rowsHtml = rentalRows; 
    let cArray = []; if(Array.isArray(o.conceptos_adicionales)) cArray = o.conceptos_adicionales; else if(typeof o.conceptos_adicionales === 'string') try{cArray=JSON.parse(o.conceptos_adicionales)}catch(e){}
    cArray.forEach(c => { 
        let val = parseFloat(c.amount !== undefined ? c.amount : (c.value || 0)); 
        let amount = val; 
        if(c.unit === 'percent') amount = rentalTotal * (val/100); 
        if(c.type === 'descuento') runningSubtotal -= amount; else runningSubtotal += amount; 
        const sign = (c.type === 'descuento') ? '-' : '+'; 
        
        let desc = c.description || c.nombre || 'Adicional';
        if(c.type === 'b2b_montaje' && c.meta?.dates && !desc.includes('-')) {
            desc += ' - ' + c.meta.dates.map(d=>window.safeFormatDate(d)).join(', ');
        }
        
        rowsHtml += `<tr><td class="py-2 px-3 text-xs text-gray-600">${desc}</td><td class="py-2 px-3"></td><td class="py-2 px-3 text-right text-xs text-gray-600">${sign} ${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(amount)}</td></tr>`; 
    }); 
    
    if(o.tipo_ajuste && o.tipo_ajuste !== 'ninguno') { let val = parseFloat(o.valor_ajuste); let displayAmount = val; if (o.ajuste_es_porcentaje) { displayAmount = runningSubtotal * (val / 100); } const sign = o.tipo_ajuste === 'descuento' ? '-' : '+'; if(o.tipo_ajuste==='descuento') runningSubtotal -= displayAmount; else runningSubtotal += displayAmount; rowsHtml += `<tr class="bg-gray-50"><td class="py-2 px-3 italic text-xs text-gray-500">Ajuste Global</td><td></td><td class="py-2 px-3 text-right font-bold text-xs text-gray-600">${sign} ${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(displayAmount)}</td></tr>`; } 
    let taxRows = ''; let taxIds = []; if (o.desglose_precios && o.desglose_precios.impuestos_detalle) taxIds = o.desglose_precios.impuestos_detalle; else { const s = allSpaces.find(sp => sp.id === o.espacio_id); taxIds = s ? parseIds(s.impuestos) : []; } taxRows += `<tr><td class="py-1 px-3 text-[10px] font-bold text-gray-500 text-right" colspan="2">Subtotal</td><td class="py-1 px-3 text-right text-xs font-bold text-gray-800">${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(runningSubtotal)}</td></tr>`; if (taxIds.length > 0 && dbTaxes.length > 0) { taxIds.forEach(tid => { const t = dbTaxes.find(x => x.id == tid); if(t) { const rate = t.porcentaje > 1 ? t.porcentaje/100 : t.porcentaje; const val = runningSubtotal * rate; taxRows += `<tr><td class="py-1 px-3 text-[10px] text-gray-400 text-right" colspan="2">${t.nombre} (${t.porcentaje}%)</td><td class="py-1 px-3 text-right text-xs text-red-500 font-bold">+ ${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(val)}</td></tr>`; } }); } const totalsBlock = `<div class="flex justify-end mb-2 pr-4"><div class="w-64"><table class="w-full border-collapse">${taxRows}<tr><td class="pt-2 border-t-2 border-gray-800 align-middle text-right" colspan="2"><span class="text-[10px] font-bold uppercase text-gray-500 mr-2">Total Neto</span></td><td class="pt-2 border-t-2 border-gray-800 align-middle text-right"><span class="text-xl font-black text-gray-900">${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(o.precio_final)}</span></td></tr></table></div></div>`; 
    
    let staffName = window.currentUserProfile?.Usernames || window.currentUserProfile?.username || window.currentUserProfile?.full_name || 'Staff';

    let signBlock = ''; 
    if (isOrder) { 
        signBlock = `<div class="flex justify-center w-full"><div class="text-center w-64"><div class="border-b border-black mb-1"></div><p class="font-bold text-xs text-brand-dark">${staffName}</p><p class="text-[10px] text-gray-500 uppercase">Staff Casa de Piedra</p></div></div>`; 
    } else { 
        signBlock = `<div class="text-center w-56"><div class="border-b border-black mb-1"></div><p class="font-bold text-xs text-brand-dark">${staffName}</p><p class="text-[10px] text-gray-500 uppercase">Staff Casa de Piedra</p></div><div class="text-center w-56"><div class="border-b border-black mb-1"></div><p class="font-bold text-xs text-brand-dark uppercase">${o.cliente_nombre.substring(0,25)}</p><p class="text-[10px] text-gray-500 uppercase">Cliente / Representante</p></div>`; 
    } 
    
    let page1Content = `<div style="height: 1054px; overflow: hidden; padding: 48px 64px; box-sizing: border-box; display: flex; flex-direction: column; justify-content: space-between;"><div>${renderHeader(docTitle)}${clientComponent}${isOrder ? `<div class="mb-2 bg-gray-100 p-2 rounded text-base flex justify-between"><span>Folio de Servicio: <strong class="font-black text-lg">${folioUnificado}</strong></span><span>Contrato: <strong class="font-black text-lg">${o.numero_contrato||'---'}</strong></span></div>` : ''}<table class="w-full text-left mb-1 mt-2"><thead class="bg-gray-100 text-xs font-black text-gray-500 uppercase"><tr><th class="py-1.5 px-3 rounded-l">Concepto</th><th class="py-1.5 px-3 text-center">Fecha</th><th class="py-1.5 px-3 text-right rounded-r">Importe</th></tr></thead><tbody class="divide-y divide-gray-50 text-xs">${rowsHtml}</tbody></table> ${totalsBlock}</div><div class="pb-2">${!isOrder ? `<div class="grid grid-cols-2 gap-4 mb-20 pt-4 border-t border-gray-100"><div><h4 class="font-bold text-xs uppercase text-brand-dark mb-0.5">Condiciones:</h4><ul class="list-none text-xs text-gray-600 space-y-0.5 leading-tight"><li>a) Pago anticipado.</li><li>b) Doc. completa 3 semanas antes.</li><li>c) Sujeto a disponibilidad.</li></ul></div><div><h4 class="font-bold text-xs uppercase text-brand-dark mb-0.5">Vigencia:</h4><p class="text-xs text-gray-600">7 días naturales a partir de la emisión.</p></div></div>` : ''}<div class="flex justify-between items-start px-2">${signBlock}</div>${footerHubHTML}</div></div>`; let page2Content = ''; if (!isOrder) { page2Content = `<div class="html2pdf__page-break"></div><div style="height: 1054px; overflow: hidden; padding: 48px 64px; box-sizing: border-box;">${renderHeader("CONDICIONES GENERALES")}<ol class="list-decimal list-outside ml-6 text-xs text-gray-800 space-y-4 text-justify leading-loose mt-8"><li><span class="font-bold">Esta es una propuesta económica, las condiciones generales y específicas se presentarán en el contrato correspondiente.</span></li></ol></div>`; } return page1Content + page2Content; 
};