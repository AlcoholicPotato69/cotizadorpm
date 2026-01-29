// =========================================================================
// ---------------------------
// CLIENTES (Perfiles)
// ---------------------------
let orderClientProfiles = [];
let orderClientProfilesById = {};

async function loadClientProfilesForOrderModal() {
    const sel = document.getElementById('oed-client-profile');
    const hid = document.getElementById('oed-client-id');
    if (!sel || !window.finSupabase) return;

    try {
        const { data, error } = await window.finSupabase
            .from('clientes')
            .select('id,nombre_completo,telefono,correo,rfc')
            .order('nombre_completo', { ascending: true });

        if (error) throw error;

        orderClientProfiles = data || [];
        orderClientProfilesById = {};
        orderClientProfiles.forEach(c => orderClientProfilesById[c.id] = c);

        const current = sel.value;
        sel.innerHTML = '<option value="">— Sin perfil —</option>' + orderClientProfiles
            .map(c => `<option value="${c.id}">${(c.nombre_completo || '').toUpperCase()}</option>`)
            .join('');
        if (current) sel.value = current;

        sel.onchange = () => {
            const id = sel.value;
            if (!id) {
                if (hid) hid.value = '';
                return;
            }
            const c = orderClientProfilesById[id];
            if (!c) return;
            if (hid) hid.value = id;

            const n = document.getElementById('oed-client');
            const p = document.getElementById('oed-phone');
            const e = document.getElementById('oed-email');
            const r = document.getElementById('fiscal-rfc-re');

            if (n) n.value = c.nombre_completo || '';
            if (p) p.value = (c.telefono || '');
            if (e) e.value = (c.correo || '');
            if (r) r.value = (c.rfc || '');
        };

        const clearAssoc = () => {
            if (sel.value) sel.value = '';
            if (hid) hid.value = '';
        };
        ['oed-client','oed-phone','oed-email','fiscal-rfc-re'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.addEventListener('input', clearAssoc);
        });
    } catch (e) {
        console.warn("No se pudo cargar clientes (¿SQL pendiente?)", e);
    }
}

// MÓDULO DE COTIZACIONES - REFACTORIZADO (SNAPSHOT & DATA INTEGRITY)
// =========================================================================

// -------------------------------------------------------------------------
// 1. CONFIGURACIÓN
// -------------------------------------------------------------------------

const COMPANY_LOGO_URL = (window.HUB_CONFIG && window.HUB_CONFIG.companyLogoUrl)
  || ((window.HUB_CONFIG && window.HUB_CONFIG.supabaseUrl)
      ? (window.HUB_CONFIG.supabaseUrl + '/storage/v1/object/public/espacios/logo.png')
      : './assets/logo.png');
/* -------------------------------------------------------------------------
 * 0. CONEXIÓN A BASE DE DATOS (ÚNICO LUGAR A CAMBIAR)
 * ------------------------------------------------------------------------- */
const SB_URL = (window.HUB_CONFIG && window.HUB_CONFIG.supabaseUrl) || 'http://127.0.0.1:54321';
const SB_KEY = (window.HUB_CONFIG && window.HUB_CONFIG.supabaseAnonKey) || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0';

// (Opcional) Esquema finanzas configurable
const FIN_SCHEMA = (window.HUB_CONFIG && window.HUB_CONFIG.finanzasSchema) || 'finanzas';
const STATUS_LEVEL = { 'pendiente': 0, 'rechazada': 0, 'aprobada': 1, 'finalizada': 2 };

let allOrders = [], allSpaces = [], catalogConcepts = [], dbTaxes = [], currentPreviewOrder = null;
let currentConcepts = []; 
let myPermissions = { access: false, orders_edit: false };

// -------------------------------------------------------------------------
// 2. UTILIDADES GLOBALES
// -------------------------------------------------------------------------

window.safeFormatDate = function(dateStr) { 
    if (!dateStr) return '--'; 
    const parts = dateStr.split('-'); 
    if (parts.length !== 3) return dateStr; 
    return `${parts[2]}/${parts[1]}/${parts[0]}`; 
};

window.parseIds = function(v){ 
    if(!v) return []; 
    if(Array.isArray(v)) return v; 
    if(typeof v === 'string'){ 
        try { const parsed = JSON.parse(v); return Array.isArray(parsed) ? parsed : []; } 
        catch(e){ return v.split(',').map(x=>x.trim()).filter(Boolean); } 
    } 
    return []; 
};

window.openModal = (id) => { document.getElementById(id).classList.remove('hidden'); document.getElementById(id).classList.add('flex'); };
window.closeModal = (id) => { document.getElementById(id).classList.add('hidden'); document.getElementById(id).classList.remove('flex'); };

window.showToast = (msg, type='success') => { 
    const c = document.getElementById('toast-container'); 
    const e = document.createElement('div'); 
    e.className = `p-4 rounded-lg shadow-lg text-white text-xs font-bold uppercase tracking-wider mb-2 animate-bounce ${type==='error'?'bg-red-500':'bg-green-500'}`; 
    e.innerText = msg; c.appendChild(e); setTimeout(() => e.remove(), 3000); 
};

window.openStoredDocument = async function(path) {
    if(!path) return window.showToast("Documento no disponible", "error");
    window.showToast("Abriendo documento...", "info");
    const { data, error } = await window.globalSupabase.storage.from('documentos').createSignedUrl(path, 3600);
    if (error || !data) return window.showToast("Error de acceso al archivo", "error");
    window.open(data.signedUrl, '_blank');
};

let confirmCallback = null;
window.openConfirm = function(msg, callback, isWarning = false) { 
    const titleEl = document.getElementById('confirm-title');
    titleEl.innerHTML = isWarning ? `<i class="fa-solid fa-triangle-exclamation text-red-600 mb-2 text-2xl block"></i> ${msg}` : msg;
    confirmCallback = callback; 
    window.openModal('generic-confirm-modal'); 
};

// --- MODIFICADO: ELIMINACIÓN RECURSIVA (BD + STORAGE) ---
window.askDeleteOrder = function(id, e) { 
    if(e) e.stopPropagation(); 
    
    window.openConfirm("¿Eliminar cotización y TODOS sus archivos? Esta acción es irreversible.", async () => { 
        try {
            // 1. Feedback visual
            window.showToast("Eliminando archivos asociados...", "info");

            // 2. Limpieza de Storage: Listar archivos en la carpeta del ID
            const { data: files, error: listError } = await window.globalSupabase
                .storage
                .from('documentos')
                .list(`${id}`, { limit: 100, offset: 0, sortBy: { column: 'name', order: 'asc' } });

            if (files && files.length > 0) {
                // Borrar archivos raíz (PDF cotización, OC, Contrato)
                const filesToRemove = files.map(x => `${id}/${x.name}`);
                const { error: removeError } = await window.globalSupabase
                    .storage
                    .from('documentos')
                    .remove(filesToRemove);
                
                if (removeError) console.error("Error borrando archivos raíz:", removeError);
            }

            // 3. Limpieza de Subcarpeta 'recibos' (si existe)
            const { data: receiptFiles } = await window.globalSupabase.storage.from('documentos').list(`${id}/recibos`);
            if (receiptFiles && receiptFiles.length > 0) {
                const receiptsToRemove = receiptFiles.map(x => `${id}/recibos/${x.name}`);
                await window.globalSupabase.storage.from('documentos').remove(receiptsToRemove);
            }

            // 4. Eliminar el registro de la Base de Datos
            const { error: dbError } = await window.finSupabase.from('cotizaciones').delete().eq('id', id);
            
            if (dbError) throw dbError;

            window.showToast("Cotización y archivos eliminados", "success"); 
            window.loadOrders(); 

        } catch (err) {
            console.error(err);
            window.showToast("Error al eliminar: " + err.message, "error");
        }
    }, true); 
};

// -------------------------------------------------------------------------
// 3. INICIALIZACIÓN
// -------------------------------------------------------------------------

document.addEventListener('DOMContentLoaded', async () => {
    if (window.supabase) {
        if(!window.finSupabase) window.finSupabase = window.supabase.createClient(SB_URL, SB_KEY, { db: { schema: FIN_SCHEMA } });
        if(!window.globalSupabase) window.globalSupabase = window.supabase.createClient(SB_URL, SB_KEY);
    }
    
    const { data: { session } } = await window.globalSupabase.auth.getSession();
    if (!session) return;
    
    // Listeners
    document.getElementById('btn-confirm-action')?.addEventListener('click', () => { if(confirmCallback) confirmCallback(); window.closeModal('generic-confirm-modal'); });
    document.getElementById('search-orders')?.addEventListener('input', (e) => filterOrders(e.target.value));

    // Listeners Modal Edición
    document.getElementById('oed-start')?.addEventListener('change', function() { document.getElementById('oed-end').min = this.value; window.recalcTotal(); }); 
    document.getElementById('oed-end')?.addEventListener('change', () => window.recalcTotal()); 
    document.getElementById('oed-space')?.addEventListener('change', () => { window.recalcTotal(); const s = allSpaces.find(x => x.id == document.getElementById('oed-space').value); if(s) window.renderTaxesForSpace(s); });
    
    document.getElementById('new-concept-select')?.addEventListener('change', function() { 
        const c = catalogConcepts.find(x => x.id == this.value); 
        if(c) document.getElementById('new-concept-amount').value = c.precio_sugerido; 
    });
    
    // Carga de Datos
    await Promise.all([loadTaxes(), loadSpaces(), loadConcepts()]);
    await window.loadOrders();
});

async function loadTaxes() { const { data } = await window.finSupabase.from('impuestos').select('*'); dbTaxes = data || []; }
async function loadSpaces() { const { data } = await window.finSupabase.from('espacios').select('*'); allSpaces = data || []; }
async function loadConcepts() { const { data } = await window.finSupabase.from('conceptos_catalogo').select('*').eq('activo', true); catalogConcepts = data || []; }

window.loadOrders = async function() { 
    const { data } = await window.finSupabase.from('cotizaciones').select('*').order('created_at', {ascending:false}); 
    allOrders = data || []; 
    renderOrdersTable(allOrders); 
};

// -------------------------------------------------------------------------
// 4. RENDERIZADO DE TABLA (CON LÓGICA DE FALTANTES)
// -------------------------------------------------------------------------

function renderOrdersTable(data) {
    const t = document.getElementById('orders-table'); 
    if(!t) return;
    t.innerHTML = ''; 
    
    if(!data.length) { t.innerHTML = '<tr><td colspan="7" class="p-8 text-center text-gray-400">Sin registros.</td></tr>'; return; }
    
    data.forEach(o => {
        let sColor = 'bg-gray-100 text-gray-600', sText = 'Pendiente';
        let missingIcons = []; // Array para iconos de faltantes

        if(o.status === 'aprobada') { 
            sColor = 'bg-blue-100 text-blue-700'; 
            sText = 'Aprobada'; 
            
            // Lógica visual de faltantes
            if (!o.contrato_url && !o.numero_contrato) missingIcons.push('<i class="fa-solid fa-file-signature" title="Falta Contrato"></i>');
            if (!o.factura_xml_url) missingIcons.push('<i class="fa-solid fa-file-invoice" title="Falta Factura"></i>');
            if (!o.historial_pagos || o.historial_pagos.length === 0) missingIcons.push('<i class="fa-solid fa-money-bill-wave" title="Falta Pago"></i>');
        }
        
        if(o.status === 'finalizada') { sColor = 'bg-green-100 text-green-700 border border-green-200'; sText = 'Finalizada'; }
        if(o.status === 'rechazada') { sColor = 'bg-red-50 text-red-600'; sText = 'Rechazada'; }
        
        // Construimos el HTML de alertas si hay faltantes
        let alertsHTML = '';
        if (missingIcons.length > 0 && o.status === 'aprobada') {
            alertsHTML = `<div class="flex gap-2 justify-center mt-1.5 text-[10px] text-red-400">${missingIcons.join('')}</div>`;
        }

        const tr = document.createElement('tr');
        tr.className = "border-b hover:bg-gray-50 transition group cursor-pointer";
        tr.onclick = (e) => { if(!e.target.closest('button')) window.openOrderEditModal(o.id); };

        tr.innerHTML = `
            <td class="p-4">${o.numero_orden || '--'}<p class="text-[9px] text-gray-400">ID: ${o.id.slice(0,6)}</p></td>
            <td class="p-4 font-bold text-xs text-gray-700">${o.cliente_nombre}</td>
            <td class="p-4 text-xs"><span class="font-bold block">${o.espacio_nombre}</span><span class="text-gray-500 font-mono">${window.safeFormatDate(o.fecha_inicio)}</span></td>
            <td class="p-4 text-right font-mono font-bold text-xs">${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(o.precio_final)}</td>
            <td class="p-4 text-center">
                <span class="${sColor} px-2 py-1 rounded text-[9px] font-black uppercase tracking-wider">${sText}</span>
                ${alertsHTML}
            </td>
            <td class="p-4 text-center">
                <button onclick="event.stopPropagation(); window.openDocsModal('${o.id}')" class="bg-white border border-gray-300 text-gray-600 hover:bg-gray-50 hover:text-brand-dark px-3 py-1.5 rounded-lg text-xs font-bold transition shadow-sm flex items-center gap-2 mx-auto">
                    <i class="fa-solid fa-folder-open text-brand-red"></i> Expediente
                </button>
            </td>
            <td class="p-4 text-center"><button onclick="window.askDeleteOrder('${o.id}', event)" class="text-gray-400 hover:text-red-600"><i class="fa-solid fa-trash"></i></button></td>
        `;
        t.appendChild(tr);
    });
}

function filterOrders(term) { renderOrdersTable(allOrders.filter(o => o.cliente_nombre.toLowerCase().includes(term.toLowerCase()))); }

// -------------------------------------------------------------------------
// 5. MODAL EDICIÓN Y CÁLCULOS
// -------------------------------------------------------------------------

window.openOrderEditModal = async function(id) { 
    const order = allOrders.find(o => o.id === id); 
    if (!order) return;

    await loadClientProfilesForOrderModal();
    
    // =========================================================
    // FIX: CARGA ROBUSTA DE CONCEPTOS (Corrección Solicitada)
    // =========================================================
    currentConcepts = [];
    if (order.conceptos_adicionales) {
        if (typeof order.conceptos_adicionales === 'string') {
            try { currentConcepts = JSON.parse(order.conceptos_adicionales); } catch(e) { console.error("Error parsing JSON concepts", e); }
        } else if (Array.isArray(order.conceptos_adicionales)) {
            currentConcepts = order.conceptos_adicionales;
        }
    }
    // Aseguramos que sea un array válido
    if(!Array.isArray(currentConcepts)) currentConcepts = [];
    
    currentPreviewOrder = order;

    document.getElementById('oed-id').value = order.id; 
    document.getElementById('oed-client').value = order.cliente_nombre || ''; 
    document.getElementById('oed-status').value = order.status; 
    
    // Status Lock
    const statusSelect = document.getElementById('oed-status');
    const currentLevel = STATUS_LEVEL[order.status] || 0;
    Array.from(statusSelect.options).forEach(opt => opt.disabled = (STATUS_LEVEL[opt.value] || 0) < currentLevel);

    document.getElementById('oed-phone').value = order.cliente_contacto || '';
    document.getElementById('oed-email').value = order.cliente_email || '';
    document.getElementById('fiscal-rfc-re').value = order.cliente_rfc || '';
    // Perfil de cliente (si existe)
    const selCli = document.getElementById('oed-client-profile');
    const hidCli = document.getElementById('oed-client-id');
    if (selCli) selCli.value = '';
    if (hidCli) hidCli.value = '';

    if (order.cliente_id) {
        if (selCli) selCli.value = order.cliente_id;
        if (hidCli) hidCli.value = order.cliente_id;

        // Si no está en cache, intentamos recargar lista
        if (!orderClientProfilesById[order.cliente_id]) {
            await loadClientProfilesForOrderModal();
        }
        const c = orderClientProfilesById[order.cliente_id];
        if (c) {
            document.getElementById('oed-client').value = c.nombre_completo || (order.cliente_nombre || '');
            document.getElementById('oed-phone').value = (c.telefono || order.cliente_contacto || '');
            document.getElementById('oed-email').value = (c.correo || order.cliente_email || '');
            document.getElementById('fiscal-rfc-re').value = (c.rfc || order.cliente_rfc || '');
        }
    }

    document.getElementById('oed-start').value = order.fecha_inicio; 
    document.getElementById('oed-end').value = order.fecha_fin; 
    
    const sel = document.getElementById('oed-space'); sel.innerHTML = ''; 
    allSpaces.forEach(s => sel.innerHTML += `<option value="${s.id}" ${s.id === order.espacio_id ? 'selected' : ''}>${s.nombre}</option>`);
    
    if(document.getElementById('oed-adj-type')) { 
        document.getElementById('oed-adj-type').value = order.tipo_ajuste || 'ninguno'; 
        document.getElementById('oed-adj-val').value = order.valor_ajuste || 0; 
        document.getElementById('oed-adj-unit').value = order.ajuste_es_porcentaje ? 'percent' : 'fixed'; 
    }
    
    // Si está aprobada o finalizada, bloqueamos edición (Solo lectura)
    const isLocked = ['aprobada', 'finalizada'].includes(order.status);
    const inputs = document.querySelectorAll('#order-edit-modal input, #order-edit-modal select');
    inputs.forEach(i => { if(i.id !== 'btn-save-progress' && i.id !== 'oed-status') i.disabled = isLocked; });
    
    const spaceObj = allSpaces.find(s => s.id === order.espacio_id);
    if(spaceObj) window.renderTaxesForSpace(spaceObj, order.desglose_precios?.impuestos_detalle);
    
    // Populate dropdown de conceptos
    const conceptSel = document.getElementById('new-concept-select');
    conceptSel.innerHTML = '<option value="">-- Agregar --</option>';
    catalogConcepts.forEach(c => conceptSel.innerHTML += `<option value="${c.id}">${c.nombre}</option>`);

    // Renderizamos inmediatamente para que se vea la lista
    window.renderConceptsList(); 
    window.recalcTotal(); 
    window.openModal('order-edit-modal');
};

window.renderTaxesForSpace = function(spaceObj, activeTaxIds = null) {
    const container = document.getElementById('oed-taxes-list');
    if(!container) return;
    container.innerHTML = '';
    const defaultTaxIds = window.parseIds(spaceObj.impuestos_ids || spaceObj.impuestos);
    const isLocked = currentPreviewOrder && ['aprobada', 'finalizada'].includes(currentPreviewOrder.status);
    
    dbTaxes.forEach(t => {
        let isChecked = activeTaxIds ? activeTaxIds.includes(t.id) : defaultTaxIds.includes(t.id);
        const isDefault = defaultTaxIds.includes(t.id);
        container.innerHTML += `<label class="flex items-center gap-1.5 cursor-pointer ${isLocked ? 'opacity-70' : ''}"><input type="checkbox" value="${t.id}" class="oed-tax-check accent-brand-red w-3 h-3" ${isChecked ? 'checked' : ''} ${isLocked ? 'disabled' : ''} onchange="window.recalcTotal()"><span class="text-[10px] font-bold uppercase text-gray-700">${t.nombre}</span></label>`;
    });
};

window.renderConceptsList = function() { 
    const tbody = document.getElementById('concepts-list');
    if(!tbody) return;
    tbody.innerHTML = ''; 
    const isLocked = currentPreviewOrder && ['aprobada', 'finalizada'].includes(currentPreviewOrder.status);

    if (!currentConcepts || currentConcepts.length === 0) {
        tbody.innerHTML = '<tr><td colspan="3" class="p-3 text-center text-gray-400 italic text-[10px]">Sin conceptos adicionales.</td></tr>';
        return;
    }

    currentConcepts.forEach((c, idx) => {
        // Manejamos 'amount' o 'value' por compatibilidad con datos legacy
        const val = parseFloat(c.amount || c.value || 0);
        const desc = c.description || c.concepto || c.nombre || 'Concepto sin nombre';
        const btn = isLocked ? '' : `<button onclick="window.removeConceptRow(${idx})" class="text-gray-300 hover:text-red-500"><i class="fa-solid fa-xmark"></i></button>`;
        tbody.innerHTML += `<tr><td class="p-2 border-b text-slate-700">${desc}</td><td class="p-2 border-b text-right text-xs">$${val.toLocaleString()}</td><td class="p-2 border-b text-center">${btn}</td></tr>`;
    });
};

window.recalcTotal = function() { 
    const spaceId = document.getElementById('oed-space').value; 
    const spaceObj = allSpaces.find(s => s.id == spaceId); 
    let base = spaceObj ? parseFloat(spaceObj.precio_base) : 0; 
    
    let concepts = 0;
    (currentConcepts || []).forEach(c => { concepts += parseFloat(c.amount || c.value || 0); });
    
    let sub = base + concepts;
    
    const adjType = document.getElementById('oed-adj-type').value; 
    const adjVal = parseFloat(document.getElementById('oed-adj-val').value) || 0; 
    const isPercent = document.getElementById('oed-adj-unit').value === 'percent';
    
    let adjAmount = 0;
    if (adjType !== 'ninguno') {
        adjAmount = isPercent ? sub * (adjVal/100) : adjVal;
        if (adjType === 'descuento') sub -= adjAmount; else sub += adjAmount;
    }

    let taxTotal = 0;
    let taxHtml = '';
    document.querySelectorAll('.oed-tax-check:checked').forEach(cb => {
        const t = dbTaxes.find(x => x.id == cb.value);
        if(t) {
            const taxVal = sub * (t.porcentaje / 100);
            taxTotal += taxVal;
            taxHtml += `<div class="flex justify-between text-[10px] text-gray-500"><span>${t.nombre}</span><span>+${taxVal.toLocaleString('es-MX', {style:'currency',currency:'MXN'})}</span></div>`;
        }
    });

    document.getElementById('oed-tax-summary-display').innerHTML = taxHtml;
    document.getElementById('lbl-subtotal').innerText = (base + concepts).toLocaleString('es-MX', {style:'currency',currency:'MXN'});
    document.getElementById('lbl-adjustment').innerText = (adjType==='descuento'?'-':'+') + adjAmount.toLocaleString('es-MX', {style:'currency',currency:'MXN'});
    document.getElementById('oed-price').value = (sub + taxTotal).toFixed(2);
    
    window.updatePriceColor();
};

window.updatePriceColor = function() { 
    const spaceId = document.getElementById('oed-space').value; 
    const priceInput = document.getElementById('oed-price'); 
    const val = parseFloat(priceInput.value) || 0; 
    const space = allSpaces.find(s => s.id == spaceId); 
    if(!space) return; 
    const base = parseFloat(space.precio_base); 
    priceInput.classList.remove('text-green-600', 'text-red-600', 'text-gray-700'); 
    if (val < base) priceInput.classList.add('text-green-600'); 
    else if (val > base) priceInput.classList.add('text-red-600'); 
    else priceInput.classList.add('text-gray-700'); 
};

window.addConceptRow = function() { 
    const id = document.getElementById('new-concept-select').value;
    const amount = parseFloat(document.getElementById('new-concept-amount').value);
    if (!id || isNaN(amount) || amount === 0) return;
    const c = catalogConcepts.find(x => x.id == id);
    // Standardized structure: description & amount
    currentConcepts.push({ description: c.nombre, amount: amount, value: amount, unit: 'fixed', type: 'aumento' });
    document.getElementById('new-concept-select').value = "";
    document.getElementById('new-concept-amount').value = "";
    window.renderConceptsList();
    window.recalcTotal();
};

window.removeConceptRow = function(index) {
    currentConcepts.splice(index, 1);
    window.renderConceptsList();
    window.recalcTotal();
};

// -------------------------------------------------------------------------
// 6. GUARDADO, APROBACIÓN Y SNAPSHOTS (NUEVA LÓGICA)
// -------------------------------------------------------------------------

// Paso 1: Intentar Guardar - Detecta si es una aprobación
window.attemptSaveOrder = function() {
    const newStatus = document.getElementById('oed-status').value;
    const currentLevel = STATUS_LEVEL[currentPreviewOrder.status] || 0;
    const newLevel = STATUS_LEVEL[newStatus] || 0;

    if (newLevel < currentLevel) return window.showToast("No puedes regresar a un estado anterior.", "error");

    if (newStatus === 'aprobada' && currentPreviewOrder.status !== 'aprobada') {
        // Validaciones estrictas antes de aprobar
        const missing = [];
        if(!document.getElementById('oed-client').value) missing.push("Nombre Cliente");
        if(!document.getElementById('oed-email').value) missing.push("Email");
        if(!document.getElementById('fiscal-rfc-re').value) missing.push("RFC");
        if(!document.getElementById('oed-start').value) missing.push("Fechas");
        
        if (missing.length > 0) return window.openConfirm(`<p class="text-red-600 font-bold mb-2">Faltan datos para aprobar:</p><ul class="list-disc ml-4 text-xs text-left">${missing.map(m=>`<li>${m}</li>`).join('')}</ul>`, () => window.closeModal('generic-confirm-modal'), true);
        
        // INICIAMOS EL FLUJO DE SNAPSHOT
        window.initiateApprovalSnapshot();
    } else {
        // Guardado normal (borrador o rechazo)
        window.processSaveOrder();
    }
};

// Paso 2: Preparar la Vista Previa de Aprobación (Snapshot)
window.initiateApprovalSnapshot = async function() {
    // 1. Recopilar datos actuales del formulario (para que el PDF refleje lo editado, no solo lo guardado)
    const formData = window.getFormDataFromModal();
    
    // 2. Generar Folio Temporal si no existe
    if (!formData.numero_orden) {
        const date = new Date().toISOString().slice(0,10).replace(/-/g,''); 
        const rnd = Math.floor(1000 + Math.random() * 9000); 
        formData.numero_orden = `ORD-${date}-${rnd}`; 
    }

    // 3. Generar HTML
    const content = window.getOrderHTML({ ...currentPreviewOrder, ...formData }, 'quote'); // Usamos 'quote' porque es la cotización aprobada
    
    const pdfContainer = document.getElementById('pdf-content');
    const embedViewer = document.getElementById('doc-preview');
    const btnAction = document.getElementById('btn-download-preview');
    
    // 4. Mostrar en Modal de Preview
    pdfContainer.innerHTML = content;
    pdfContainer.classList.remove('hidden');
    embedViewer.classList.add('hidden');
    
    // Configuramos el botón para la ACCIÓN CRÍTICA
    btnAction.innerHTML = '<i class="fa-solid fa-check-circle"></i> Confirmar Aprobación';
    btnAction.className = "bg-green-600 hover:bg-green-700 text-white px-5 py-2 rounded-full text-xs font-bold uppercase shadow-lg transition flex items-center gap-2";
    
    // Mostramos advertencia visual
    document.getElementById('prev-order-num').innerText = "VISTA PREVIA DE APROBACIÓN";
    
    // Asignamos la función de cierre del trato
    btnAction.onclick = () => window.executeApprovalTransaction(formData);
    
    window.openModal('preview-modal');
};

// Paso 3: Transacción Final (Snapshot -> Upload -> Update DB)
window.executeApprovalTransaction = async function(formData) {
    const btn = document.getElementById('btn-download-preview');
    btn.disabled = true; btn.innerText = "Generando Snapshot...";
    
    try {
        // 1. Tomar Snapshot del HTML visible
        const element = document.getElementById('pdf-content');
        const pdfBlob = await html2pdf().set({ margin: 0, image: { type: 'jpeg', quality: 0.98 }, html2canvas: { scale: 2, useCORS: true }, jsPDF: { unit: 'in', format: 'letter' } }).from(element).output('blob');
        
        // 2. Subir a Supabase
        const path = `${currentPreviewOrder.id}/cotizacion_aprobada_${Date.now()}.pdf`;
        const { error: uploadError } = await window.globalSupabase.storage.from('documentos').upload(path, pdfBlob);
        if (uploadError) throw uploadError;

        // 3. Actualizar Base de Datos (Estado + URL + Datos Finales)
        const payload = {
            ...formData,
            status: 'aprobada',
            url_cotizacion_final: path // Guardamos la referencia a la evidencia
        };
        
        const { error: dbError } = await window.finSupabase.from('cotizaciones').update(payload).eq('id', currentPreviewOrder.id);
        if (dbError) throw dbError;

        // 4. Descargar copia local para el usuario (Feedback inmediato)
        const link = document.createElement('a');
        link.href = URL.createObjectURL(pdfBlob);
        link.download = `Cotizacion_Aprobada_${formData.numero_orden}.pdf`;
        link.click();

        window.showToast("¡Cotización Aprobada y Archivada!", "success");
        window.closeModal('preview-modal');
        window.closeModal('order-edit-modal');
        await window.loadOrders();

    } catch (e) {
        console.error(e);
        window.showToast("Error en la aprobación: " + e.message, "error");
        btn.disabled = false; btn.innerText = "Reintentar";
    }
};

// Helper: Extraer datos limpios del modal
window.getFormDataFromModal = function() {
    const spaceId = document.getElementById('oed-space').value; 
    const spaceObj = allSpaces.find(s => s.id == spaceId); 
    let base = spaceObj ? parseFloat(spaceObj.precio_base) : 0; 
    let concepts = 0;
    currentConcepts.forEach(c => { concepts += parseFloat(c.amount || c.value || 0); });
    let sub = base + concepts;

    const activeTaxIds = Array.from(document.querySelectorAll('.oed-tax-check:checked')).map(cb => parseInt(cb.value));
    const priceFinal = parseFloat(document.getElementById('oed-price').value);

    // Ajustes
    const adjType = document.getElementById('oed-adj-type').value; 
    const adjVal = parseFloat(document.getElementById('oed-adj-val').value) || 0; 
    const isPercent = document.getElementById('oed-adj-unit').value === 'percent';

    return {
        cliente_nombre: document.getElementById('oed-client').value,
        cliente_email: document.getElementById('oed-email').value,
        cliente_contacto: document.getElementById('oed-phone').value,
        cliente_rfc: document.getElementById('fiscal-rfc-re').value,
        cliente_id: (document.getElementById('oed-client-id') ? (document.getElementById('oed-client-id').value || null) : null),
        fecha_inicio: document.getElementById('oed-start').value,
        fecha_fin: document.getElementById('oed-end').value,
        precio_final: priceFinal,
        espacio_id: spaceId,
        espacio_nombre: spaceObj ? spaceObj.nombre : '',
        espacio_clave: spaceObj ? spaceObj.clave : '',
        tipo_ajuste: adjType,
        valor_ajuste: adjVal,
        ajuste_es_porcentaje: isPercent,
        conceptos_adicionales: currentConcepts, 
        desglose_precios: { 
            subtotal_antes_impuestos: sub, 
            impuestos_detalle: activeTaxIds 
        }
    };
};

// Guardado Simple (Sin cambio a Aprobada)
window.processSaveOrder = async function() {
    const btn = document.getElementById('btn-save-progress');
    btn.disabled = true; btn.innerText = "Guardando...";
    try {
        const formData = window.getFormDataFromModal();
        formData.status = document.getElementById('oed-status').value;
        
        const { error } = await window.finSupabase.from('cotizaciones').update(formData).eq('id', document.getElementById('oed-id').value);
        if (error) throw error;

        window.showToast("Cambios guardados", "success");
        window.closeModal('order-edit-modal');
        await window.loadOrders(); 
    } catch(e) {
        console.error(e);
        window.showToast("Error: " + e.message, "error");
    } finally {
        btn.disabled = false; btn.innerText = "Guardar";
    }
};

// -------------------------------------------------------------------------
// 7. ORDEN DE COMPRA (SNAPSHOT FLUJO)
// -------------------------------------------------------------------------

window.previewOrderForGeneration = function(id) {
    const order = allOrders.find(o => o.id === id);
    if(!order) return;
    currentPreviewOrder = { ...order, docType: 'order' }; // 'order' renderiza el formato de OC
    
    // Generar el HTML
    const content = window.getOrderHTML(order, 'order');
    
    const pdfContainer = document.getElementById('pdf-content');
    const embed = document.getElementById('doc-preview');
    
    pdfContainer.innerHTML = content;
    pdfContainer.classList.remove('hidden');
    embed.classList.add('hidden');
    
    const btn = document.getElementById('btn-download-preview');
    btn.innerHTML = '<i class="fa-solid fa-file-contract"></i> Confirmar y Generar OC';
    btn.className = "bg-purple-600 hover:bg-purple-700 text-white px-5 py-2 rounded-full text-xs font-bold uppercase shadow-lg transition flex items-center gap-2";
    
    // Asignar el flujo de confirmación + snapshot
    btn.onclick = window.confirmAndGeneratePurchaseOrder;
    
    window.openModal('preview-modal');
};

window.confirmAndGeneratePurchaseOrder = async function() {
    // 1. Confirmación de usuario
    window.openConfirm("¿Generar Orden de Compra Oficial? Se guardará una copia exacta.", async () => {
        const btn = document.getElementById('btn-download-preview');
        btn.disabled = true; btn.innerText = "Generando OC...";
        
        try {
            // 2. Tomar Snapshot del HTML visible en el modal PREVIO
            // Nota: El modal de confirmación se cierra, dejando el modal de preview visible
            const element = document.getElementById('pdf-content'); 
            
            const pdfBlob = await html2pdf().set({ margin: 0, image: { type: 'jpeg', quality: 0.98 }, html2canvas: { scale: 2, useCORS: true }, jsPDF: { unit: 'in', format: 'letter' } }).from(element).output('blob');
            
            const path = `${currentPreviewOrder.id}/orden_compra_${Date.now()}.pdf`;
            
            // 3. Subir Evidencia
            await window.globalSupabase.storage.from('documentos').upload(path, pdfBlob);
            
            // 4. Update BD
            await window.finSupabase.from('cotizaciones').update({ 
                url_orden_compra: path, 
                fecha_orden_compra: new Date().toISOString() 
            }).eq('id', currentPreviewOrder.id);
            
            // 5. Descargar localmente
            const link = document.createElement('a'); link.href = URL.createObjectURL(pdfBlob); link.download = `OC_${currentPreviewOrder.numero_orden}.pdf`; link.click();
    
            window.showToast("Orden de Compra Generada");
            await window.loadOrders(); 
            window.closeModal('preview-modal');
            window.closeModal('docs-modal');
            
        } catch(e) {
            console.error(e);
            window.showToast("Error al generar OC", "error");
        } finally {
            btn.disabled = false;
        }
    });
};

// -------------------------------------------------------------------------
// 8. VISTA PREVIA Y MODAL DOCUMENTOS
// -------------------------------------------------------------------------

window.openDocsModal = function(id) {
    const order = allOrders.find(o => o.id === id); if(!order) return;
    
    document.getElementById('doc-client').innerText = order.cliente_nombre;
    document.getElementById('doc-folio').innerText = order.numero_orden || 'PENDIENTE';
    document.getElementById('doc-space').innerText = order.espacio_nombre;
    document.getElementById('doc-dates').innerText = `${window.safeFormatDate(order.fecha_inicio)} - ${window.safeFormatDate(order.fecha_fin)}`;
    
    const list = document.getElementById('docs-list'); list.innerHTML = '';
    
    const createBtn = (label, icon, color, action) => {
        list.innerHTML += `<button onclick="${action}" class="w-full text-left px-4 py-3 rounded-xl border border-gray-200 hover:bg-gray-50 flex items-center gap-3 transition shadow-sm group bg-white mb-2"><div class="w-8 h-8 rounded-full bg-${color}-100 text-${color}-600 flex items-center justify-center shrink-0"><i class="${icon}"></i></div><div class="flex-grow"><p class="text-xs font-bold text-gray-700">${label}</p></div><i class="fa-solid fa-arrow-right text-xs text-gray-300"></i></button>`;
    };

    if (order.url_cotizacion_final) { 
        createBtn('Ver Cotización Aprobada', 'fa-solid fa-file-circle-check', 'blue', `window.openStoredDocument('${order.url_cotizacion_final}')`); 
    } else { 
        createBtn('Ver Borrador Cotización', 'fa-solid fa-file-pen', 'gray', `window.openPDFPreview('${order.id}', 'quote')`); 
    }

    if (order.url_orden_compra) { 
        createBtn('Ver Orden de Compra', 'fa-solid fa-file-contract', 'purple', `window.openStoredDocument('${order.url_orden_compra}')`); 
    } else if(['aprobada', 'finalizada'].includes(order.status)) { 
        createBtn('Generar Orden de Compra', 'fa-solid fa-plus', 'purple', `window.previewOrderForGeneration('${order.id}')`); 
    } else { 
        list.innerHTML += `<div class="w-full px-4 py-3 rounded-xl border border-gray-100 bg-gray-50 flex items-center gap-3 mb-2 opacity-60"><i class="fa-solid fa-lock text-gray-400"></i><span class="text-xs font-bold text-gray-400">Orden de Compra (Pendiente)</span></div>`; 
    }

    if (order.contrato_url) { createBtn('Ver Contrato Firmado', 'fa-solid fa-file-signature', 'indigo', `window.openStoredDocument('${order.contrato_url}')`); } 
    else { list.innerHTML += `<div class="w-full px-4 py-3 rounded-xl border border-gray-100 bg-gray-50 flex items-center gap-3 mb-2 opacity-60"><i class="fa-solid fa-signature text-gray-400"></i><span class="text-xs font-bold text-gray-400">Contrato (Pendiente Firma)</span></div>`; }

    if (order.factura_pdf_url) { 
        createBtn('Ver Factura (PDF)', 'fa-solid fa-file-pdf', 'red', `window.openStoredDocument('${order.factura_pdf_url}')`); 
        if(order.factura_xml_url) createBtn('Descargar XML', 'fa-solid fa-file-code', 'orange', `window.openStoredDocument('${order.factura_xml_url}')`); 
    } else { 
        list.innerHTML += `<div class="w-full px-4 py-3 rounded-xl border border-gray-100 bg-gray-50 flex items-center gap-3 mb-2 opacity-60"><i class="fa-solid fa-file-invoice-dollar text-gray-400"></i><span class="text-xs font-bold text-gray-400">Factura (Pendiente)</span></div>`; 
    }

    if (order.historial_pagos?.length > 0) { 
        const divider = document.createElement('div'); divider.className = 'border-t border-gray-100 my-2 pt-2 text-[10px] font-bold text-gray-400 uppercase text-center'; divider.innerText = 'Historial de Recibos'; list.appendChild(divider); 
        order.historial_pagos.forEach((p, i) => createBtn(`Recibo #${i+1}`, 'fa-solid fa-receipt', 'green', `window.openStoredDocument('${p.file_path}')`)); 
    }

    window.openModal('docs-modal');
};

window.openPDFPreview = function(id, type) { 
    const o = allOrders.find(x => x.id === id); if(!o) return; 
    currentPreviewOrder = { ...o, docType: type }; 
    const content = window.getOrderHTML(o, type); 
    const pdfContainer = document.getElementById('pdf-content'); 
    const embedViewer = document.getElementById('doc-preview'); 
    const btnDownload = document.getElementById('btn-download-preview'); 
    pdfContainer.classList.remove('hidden'); embedViewer.classList.add('hidden'); pdfContainer.innerHTML = content; 
    btnDownload.innerHTML = '<i class="fa-solid fa-download"></i> Descargar';
    btnDownload.className = "bg-brand-red hover:bg-red-600 text-white px-5 py-2 rounded-full text-xs font-bold uppercase shadow-lg transition flex items-center gap-2";
    btnDownload.onclick = window.downloadPDFFromPreview; 
    window.openModal('preview-modal'); 
};

window.downloadPDFFromPreview = function() { 
    const element = document.getElementById('pdf-content'); 
    const opt = { margin: 0, filename: `Documento.pdf`, image: { type: 'jpeg', quality: 0.98 }, html2canvas: { scale: 2, useCORS: true }, jsPDF: { unit: 'in', format: 'letter' } }; 
    html2pdf().set(opt).from(element).save(); 
};

// --- PDF RENDERER (DISEÑO RESTAURADO) ---
window.getOrderHTML = function(o, type) { 
    const isOrder = type === 'order'; 
    const logoImg = `<img src="${COMPANY_LOGO_URL}" class="h-16 object-contain" crossorigin="anonymous">`; 
    const now = new Date(); const dateStr = now.toLocaleDateString('es-MX', { day: '2-digit', month: '2-digit', year: 'numeric' }); 
    const genDateTime = now.toLocaleString('es-MX', { dateStyle: 'short', timeStyle: 'medium' }); 
    let docTitle = isOrder ? "ORDEN DE COMPRA" : "COTIZACIÓN"; 
    let folio = o.numero_orden || (isOrder ? 'PENDIENTE' : o.id.slice(0,8).toUpperCase()); 
    const space = allSpaces.find(s=>s.id==o.espacio_id); const basePrice = parseFloat(space ? space.precio_base : 0); 
    const descHTML = isOrder ? '' : `<p class="text-[9px] text-gray-500 italic mt-0.5 truncate max-w-xs">${space?.descripcion || ''}</p>`; 
    const footerHubHTML = `<div class="w-full text-center mt-10"><p class="text-[10px] text-gray-400 font-medium leading-tight">Generado el ${genDateTime}<br>a través de Marketing Hub - Plaza Mayor</p></div>`; 
    const renderHeader = (title) => `<div class="flex justify-between items-start border-b-4 border-brand-red pb-3 mb-2">${logoImg}<div class="text-right"><h1 class="text-2xl font-black text-gray-800 tracking-tighter uppercase">${title}</h1><p class="text-sm font-mono text-brand-red font-bold mt-1">${folio}</p><p class="text-[10px] text-gray-500 mt-1">${dateStr}</p></div></div>`; 
    let clientName = o.cliente_nombre; let clientRfc = o.cliente_rfc; let nameSizeClass = 'text-xl'; if (clientName.length > 35) nameSizeClass = 'text-xs'; else if (clientName.length > 25) nameSizeClass = 'text-sm'; 
    const clientComponent = `<div class="flex flex-row justify-between items-center mb-2 p-2 bg-gray-50 rounded border border-gray-100"><div class="w-1/2 border-r border-gray-200 pr-2"><p class="font-black text-[9px] text-gray-400 uppercase tracking-wider mb-0.5">Cliente / Empresa</p><p class="font-black ${nameSizeClass} text-gray-800 leading-tight">${clientName}</p></div><div class="w-1/2 pl-2"><p class="font-black text-[9px] text-gray-400 uppercase tracking-wider mb-0.5">Contacto / Fiscal</p><p class="font-mono text-xs text-gray-700 truncate">${o.cliente_email || 'Sin correo'}</p>${clientRfc ? `<p class="font-mono text-xs text-gray-700 mt-0.5">RFC: <strong>${clientRfc}</strong></p>` : ''}</div></div>`; 
    let runningSubtotal = basePrice; 
    let rowsHtml = `<tr><td class="py-2 px-3 align-top"><p class="font-bold text-gray-800 text-xs">${o.espacio_nombre}</p>${descHTML}<span class="bg-gray-100 text-gray-500 px-1 py-0.5 rounded text-[10px] font-mono mt-0.5 inline-block">${o.espacio_clave || ''}</span></td><td class="py-2 px-3 align-top text-center text-gray-500 text-xs">${window.safeFormatDate(o.fecha_inicio)}<br>${window.safeFormatDate(o.fecha_fin)}</td><td class="py-2 px-3 align-top text-right font-bold text-gray-700 text-xs">${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(basePrice)}</td></tr>`; 
    
    // FIX CONCEPTOS EN PDF
    let cArray = [];
    if(Array.isArray(o.conceptos_adicionales)) cArray = o.conceptos_adicionales;
    else if(typeof o.conceptos_adicionales === 'string') try{cArray=JSON.parse(o.conceptos_adicionales)}catch(e){}
    cArray.forEach(c => { 
        // Normalizamos lectura de 'amount' vs 'value'
        let val = parseFloat(c.amount !== undefined ? c.amount : (c.value || 0));
        let amount = val;
        // Si hay logica de porcentaje
        if(c.unit === 'percent') amount = basePrice * (val/100); 
        
        if(c.type === 'descuento') runningSubtotal -= amount; else runningSubtotal += amount; 
        const sign = (c.type === 'descuento') ? '-' : '+'; 
        // Usamos c.description o c.nombre
        rowsHtml += `<tr><td class="py-2 px-3 text-xs text-gray-600">${c.description || c.nombre || 'Adicional'}</td><td class="py-2 px-3"></td><td class="py-2 px-3 text-right text-xs text-gray-600">${sign} ${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(amount)}</td></tr>`; 
    }); 
    
    if(o.tipo_ajuste && o.tipo_ajuste !== 'ninguno') { let val = parseFloat(o.valor_ajuste); let displayAmount = val; if (o.ajuste_es_porcentaje) { displayAmount = runningSubtotal * (val / 100); } const sign = o.tipo_ajuste === 'descuento' ? '-' : '+'; if(o.tipo_ajuste==='descuento') runningSubtotal -= displayAmount; else runningSubtotal += displayAmount; rowsHtml += `<tr class="bg-gray-50"><td class="py-2 px-3 italic text-xs text-gray-500">Ajuste Global</td><td></td><td class="py-2 px-3 text-right font-bold text-xs text-gray-600">${sign} ${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(displayAmount)}</td></tr>`; } 
    let taxRows = ''; let taxIds = []; if (o.desglose_precios && o.desglose_precios.impuestos_detalle) taxIds = o.desglose_precios.impuestos_detalle; else { const s = allSpaces.find(sp => sp.id === o.espacio_id); taxIds = s ? parseIds(s.impuestos) : []; } taxRows += `<tr><td class="py-1 px-3 text-[10px] font-bold text-gray-500 text-right" colspan="2">Subtotal</td><td class="py-1 px-3 text-right text-xs font-bold text-gray-800">${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(runningSubtotal)}</td></tr>`; if (taxIds.length > 0 && dbTaxes.length > 0) { taxIds.forEach(tid => { const t = dbTaxes.find(x => x.id == tid); if(t) { const rate = t.porcentaje > 1 ? t.porcentaje/100 : t.porcentaje; const val = runningSubtotal * rate; taxRows += `<tr><td class="py-1 px-3 text-[10px] text-gray-400 text-right" colspan="2">${t.nombre} (${t.porcentaje}%)</td><td class="py-1 px-3 text-right text-xs text-red-500 font-bold">+ ${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(val)}</td></tr>`; } }); } const totalsBlock = `<div class="flex justify-end mb-2 pr-4"><div class="w-64"><table class="w-full border-collapse">${taxRows}<tr><td class="pt-2 border-t-2 border-gray-800 align-middle text-right" colspan="2"><span class="text-[10px] font-bold uppercase text-gray-500 mr-2">Total Neto</span></td><td class="pt-2 border-t-2 border-gray-800 align-middle text-right"><span class="text-xl font-black text-gray-900">${new Intl.NumberFormat('es-MX', {style:'currency',currency:'MXN'}).format(o.precio_final)}</span></td></tr></table></div></div>`; let signBlock = ''; if (isOrder) { signBlock = `<div class="flex justify-center w-full"><div class="text-center w-64"><div class="border-b border-black mb-1"></div><p class="font-bold text-xs text-brand-dark">Lic. Pedro Rodríguez G.</p><p class="text-[10px] text-gray-500 uppercase">Gerente de Mercadotecnia</p><p class="text-[10px] text-gray-500 uppercase">Plaza Mayor</p></div></div>`; } else { signBlock = `<div class="text-center w-56"><div class="border-b border-black mb-1"></div><p class="font-bold text-xs text-brand-dark">Lic. Pedro Rodríguez G.</p><p class="text-[10px] text-gray-500 uppercase">Gerente de Mercadotecnia</p><p class="text-[10px] text-gray-500 uppercase">Plaza Mayor</p></div><div class="text-center w-56"><div class="border-b border-black mb-1"></div><p class="font-bold text-xs text-brand-dark uppercase">${o.cliente_nombre.substring(0,25)}</p><p class="text-[10px] text-gray-500 uppercase">Cliente / Representante</p></div>`; } let page1Content = `<div style="height: 1054px; overflow: hidden; padding: 48px 64px; box-sizing: border-box; display: flex; flex-direction: column; justify-content: space-between;"><div>${renderHeader(docTitle)}${clientComponent}${isOrder ? `<div class="mb-2 bg-gray-100 p-2 rounded text-base flex justify-between"><span>Orden: <strong class="font-black text-lg">${o.numero_orden||'---'}</strong></span><span>Contrato: <strong class="font-black text-lg">${o.numero_contrato||'---'}</strong></span></div>` : ''}<table class="w-full text-left mb-1 mt-2"><thead class="bg-gray-100 text-xs font-black text-gray-500 uppercase"><tr><th class="py-1.5 px-3 rounded-l">Concepto</th><th class="py-1.5 px-3 text-center">Fecha</th><th class="py-1.5 px-3 text-right rounded-r">Importe</th></tr></thead><tbody class="divide-y divide-gray-50 text-xs">${rowsHtml}</tbody></table> ${totalsBlock}</div><div class="pb-2">${!isOrder ? `<div class="grid grid-cols-2 gap-4 mb-20 pt-4 border-t border-gray-100"><div><h4 class="font-bold text-xs uppercase text-brand-dark mb-0.5">Condiciones:</h4><ul class="list-none text-xs text-gray-600 space-y-0.5 leading-tight"><li>a) Pago anticipado.</li><li>b) Doc. completa 3 semanas antes.</li><li>c) Sujeto a disponibilidad.</li></ul></div><div><h4 class="font-bold text-xs uppercase text-brand-dark mb-0.5">Vigencia:</h4><p class="text-xs text-gray-600">7 días naturales a partir de la emisión.</p></div></div>` : ''}<div class="flex justify-between items-start px-2">${signBlock}</div>${footerHubHTML}</div></div>`; let page2Content = ''; if (!isOrder) { page2Content = `<div class="html2pdf__page-break"></div><div style="height: 1054px; overflow: hidden; padding: 48px 64px; box-sizing: border-box;">${renderHeader("CONDICIONES GENERALES")}<ol class="list-decimal list-outside ml-6 text-xs text-gray-800 space-y-4 text-justify leading-loose mt-8"><li><span class="font-bold">La instalación será responsabilidad exclusiva del cliente.</span> Esto incluye cualquier costo asociado con la instalación, como mano de obra, herramientas, y materiales necesarios. El cliente debe coordinar con el personal del centro comercial para asegurar que la instalación cumpla con las normativas y políticas de Plaza Mayor.</li><li><span class="font-bold">El diseño y contenido del material publicitario deben cumplir con las normativas establecidas por el centro comercial.</span> Antes de la instalación, el cliente deberá obtener la aprobación necesaria de Plaza Mayor para asegurar la conformidad con las políticas vigentes.</li><li><span class="font-bold">El cliente es completamente responsable del contenido del material publicitario.</span> Debe garantizar que el contenido no infrinja derechos de terceros, incluyendo derechos de autor, marcas registradas u otros derechos de propiedad intelectual. El centro comercial se reserva el derecho de rechazar la instalación de cualquier material que considere inapropiado o que viole las normativas establecidas.</li><li><span class="font-bold">Durante el proceso de instalación y desinstalación, el cliente será responsable de cualquier daño causado al espacio o propiedad del centro comercial.</span> Se recomienda que el cliente cuente con un seguro de responsabilidad civil para cubrir cualquier daño potencial.</li><li><span class="font-bold">Cualquier modificación en la duración, diseño o ubicación del material publicitario debe ser comunicada y aprobada por el centro comercial con anticipación.</span></li><li><span class="font-bold">No se permite volanteo fuera del espacio designado, ni equipo de audio (perifoneo, música, etc) salvo previa autorización por escrito de la Gerencia de Mercadotecnia.</span> Se prohíbe el uso de globos con helio.</li><li><span class="font-bold">Al finalizar la campaña publicitaria, el cliente deberá retirar el material publicitario a más tardar al día siguiente.</span> Cualquier demora en la retirada puede estar sujeta a cargos adicionales.</li><li><span class="font-bold">No se permite la venta ni promoción de artículos para adultos (como juguetes sexuales), bebidas alcohólicas, tabaco, CBD y/o cannabinoides.</span></li><li><span class="font-bold">El almacenamiento y/o recolección de basura correrá por cuenta del cliente.</span> En caso de no hacerlo, Plaza Mayor podrá generar un cargo adicional por este concepto.</li><li><span class="font-bold">El cliente deberá instalar la toma eléctrica necesaria.</span> Plaza Mayor podrá suministrar energía eléctrica de 110v para uso moderado de algunos equipos. Este tema deberá definirse previamente por escrito con la autorización de Gerencia de Operaciones.</li><li><span class="font-bold">Esta es una propuesta económica, las condiciones generales y específicas se presentarán en el contrato correspondiente, posterior a haberse autorizado este documento.</span></li></ol></div>`; } return page1Content + page2Content; };