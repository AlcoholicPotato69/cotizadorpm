// =========================================================================
// MÓDULO DE CLIENTES (PERFILES REUTILIZABLES)
// =========================================================================

/* -------------------------------------------------------------------------
 * 0. CONEXIÓN A BASE DE DATOS (ÚNICO LUGAR A CAMBIAR)
 * ------------------------------------------------------------------------- */
const SB_URL = (window.HUB_CONFIG && window.HUB_CONFIG.supabaseUrl) || 'http://127.0.0.1:54321';
const SB_KEY = (window.HUB_CONFIG && window.HUB_CONFIG.supabaseAnonKey) || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0';

// (Opcional) Esquema finanzas configurable
const __p = window.location.pathname || '';
const __isCP = /\/cotizadorcp(\/|$)/.test(__p) || (window.location.href || '').includes('cotizadorcp');
const FIN_SCHEMA = __isCP ? 'finanzas_casadepiedra' : ((window.HUB_CONFIG && window.HUB_CONFIG.finanzasSchema) || 'finanzas');

let allClients = [];
let canManage = false;

function escapeHTML(str='') {
  return String(str).replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
}

function normalize(str='') { return String(str).toLowerCase().trim(); }

function showEmptyIfNeeded() {
  const grid = document.getElementById('clients-grid');
  const empty = document.getElementById('clients-empty');
  if (!grid || !empty) return;
  const hasCards = grid.querySelectorAll('[data-client-card]').length > 0;
  empty.classList.toggle('hidden', hasCards);
}

function renderClients(list) {
  const grid = document.getElementById('clients-grid');
  if (!grid) return;
  grid.innerHTML = '';

  if (!Array.isArray(list) || !list.length) {
    showEmptyIfNeeded();
    return;
  }

  list.forEach(c => {
    const name = escapeHTML(c.nombre_completo || '');
    const phone = escapeHTML(c.telefono || '');
    const email = escapeHTML(c.correo || '');
    const rfc = escapeHTML(c.rfc || '');

    const actions = canManage ? `
      <div class="flex gap-2">
        <button class="btn-edit bg-white border border-gray-200 hover:bg-gray-100 text-gray-700 font-bold text-xs px-3 py-2 rounded-xl transition flex items-center gap-2">
          <i class="fa-solid fa-pen"></i> Editar
        </button>
        <button class="btn-del bg-brand-red/10 hover:bg-brand-red/20 text-brand-red font-black text-xs px-3 py-2 rounded-xl transition flex items-center gap-2">
          <i class="fa-solid fa-trash"></i> Eliminar
        </button>
      </div>
    ` : `
      <div class="text-[11px] text-gray-400 font-semibold uppercase">Solo lectura</div>
    `;

    const card = document.createElement('div');
    card.setAttribute('data-client-card', '1');
    card.className = "bg-white rounded-2xl shadow-md border border-gray-100 p-4 hover:shadow-lg transition";
    card.innerHTML = `
      <div class="flex items-start justify-between gap-3">
        <div class="min-w-0">
          <h3 class="font-black text-sm text-gray-800 truncate">${name || '—'}</h3>
          <p class="text-[11px] text-gray-500 mt-0.5 uppercase font-bold">Perfil de cliente</p>
        </div>
        <span class="w-9 h-9 rounded-2xl bg-brand-red text-white flex items-center justify-center shadow">
          <i class="fa-solid fa-user"></i>
        </span>
      </div>

      <div class="mt-4 space-y-2 text-sm">
        <div class="flex items-center gap-2 text-gray-700">
          <i class="fa-solid fa-phone text-gray-400 w-4"></i>
          <span class="text-xs font-semibold">${phone || '—'}</span>
        </div>
        <div class="flex items-center gap-2 text-gray-700">
          <i class="fa-solid fa-envelope text-gray-400 w-4"></i>
          <span class="text-xs font-semibold break-all">${email || '—'}</span>
        </div>
        <div class="flex items-center gap-2 text-gray-700">
          <i class="fa-solid fa-file-lines text-gray-400 w-4"></i>
          <span class="text-xs font-semibold">${rfc || '—'}</span>
        </div>
      </div>

      <div class="mt-4 flex items-center justify-between">
        ${actions}
      </div>
    `;

    // Bind actions
    if (canManage) {
      card.querySelector('.btn-edit')?.addEventListener('click', () => openClientModal(c));
      card.querySelector('.btn-del')?.addEventListener('click', () => confirmDeleteClient(c));
    }

    grid.appendChild(card);
  });

  showEmptyIfNeeded();
}

async function loadClients() {
  try {
    const { data, error } = await window.finSupabase.from('clientes')
      .select('id,nombre_completo,telefono,correo,rfc,created_at,updated_at')
      .order('nombre_completo', { ascending: true });

    if (error) throw error;
    allClients = data || [];
    applySearch();
  } catch (e) {
    console.error(e);
    window.showToast?.("No se pudieron cargar los clientes. (¿Ya ejecutaste el SQL?)", "error");
    allClients = [];
    applySearch();
  }
}

function applySearch() {
  const q = normalize(document.getElementById('clients-search')?.value || '');
  if (!q) return renderClients(allClients);

  const filtered = allClients.filter(c => {
    const blob = [
      c.nombre_completo, c.telefono, c.correo, c.rfc
    ].map(v => normalize(v || '')).join(' ');
    return blob.includes(q);
  });

  renderClients(filtered);
}

function openClientModal(client=null) {
  if (!canManage) return window.showToast?.("No tienes permisos para administrar clientes.", "error");

  const idEl = document.getElementById('client-id');
  const nameEl = document.getElementById('client-name');
  const phoneEl = document.getElementById('client-phone');
  const emailEl = document.getElementById('client-email');
  const rfcEl = document.getElementById('client-rfc');
  const title = document.getElementById('client-modal-title');

  if (!idEl || !nameEl || !phoneEl || !emailEl || !rfcEl) return;

  idEl.value = client?.id || '';
  nameEl.value = client?.nombre_completo || '';
  phoneEl.value = client?.telefono || '';
  emailEl.value = client?.correo || '';
  rfcEl.value = client?.rfc || '';

  if (title) title.innerText = client?.id ? "Editar Cliente" : "Nuevo Cliente";

  window.openModal?.('client-modal');
}

function closeClientModal() { window.closeModal?.('client-modal'); }

function confirmModal(text) {
  return new Promise(resolve => {
    const modal = document.getElementById('confirm-modal');
    const txt = document.getElementById('confirm-text');
    const ok = document.getElementById('btn-confirm-ok');
    const cancel = document.getElementById('btn-confirm-cancel');

    if (!modal || !txt || !ok || !cancel) return resolve(false);

    txt.textContent = text || '¿Confirmar?';
    modal.classList.remove('hidden');
    modal.classList.add('flex');

    const cleanup = () => {
      modal.classList.add('hidden');
      modal.classList.remove('flex');
      ok.onclick = null;
      cancel.onclick = null;
    };

    ok.onclick = () => { cleanup(); resolve(true); };
    cancel.onclick = () => { cleanup(); resolve(false); };
  });
}

async function confirmDeleteClient(client) {
  const ok = await confirmModal(`¿Eliminar el cliente "${client?.nombre_completo || ''}"? Esta acción no se puede deshacer.`);
  if (!ok) return;

  try {
    const { error } = await window.finSupabase.from('clientes').delete().eq('id', client.id);
    if (error) throw error;
    window.showToast?.("Cliente eliminado", "success");
    await loadClients();
  } catch (e) {
    console.error(e);
    window.showToast?.("No se pudo eliminar el cliente.", "error");
  }
}

async function saveClient() {
  if (!canManage) return window.showToast?.("No tienes permisos para administrar clientes.", "error");

  const id = (document.getElementById('client-id')?.value || '').trim();
  const nombre = (document.getElementById('client-name')?.value || '').trim();
  const telefono = (document.getElementById('client-phone')?.value || '').replace(/\D/g,'').trim();
  const correo = (document.getElementById('client-email')?.value || '').trim();
  const rfc = (document.getElementById('client-rfc')?.value || '').trim().toUpperCase();

  if (!nombre) return window.showToast?.("Falta el nombre completo.", "error");

  if (telefono && telefono.length !== 10) {
    return window.showToast?.("El teléfono debe tener 10 dígitos.", "error");
  }

  if (correo) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(correo)) return window.showToast?.("Correo inválido.", "error");
  }

  const payload = {
    nombre_completo: nombre,
    telefono: telefono || null,
    correo: correo || null,
    rfc: rfc || null
  };

  try {
    const btn = document.getElementById('btn-save-client');
    if (btn) { btn.disabled = true; btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Guardando...'; }

    if (id) {
      const { error } = await window.finSupabase.from('clientes').update(payload).eq('id', id);
      if (error) throw error;
      window.showToast?.("Cliente actualizado", "success");
    } else {
      const { error } = await window.finSupabase.from('clientes').insert(payload);
      if (error) throw error;
      window.showToast?.("Cliente creado", "success");
    }

    closeClientModal();
    await loadClients();
  } catch (e) {
    console.error(e);
    window.showToast?.("No se pudo guardar el cliente. (¿Ya ejecutaste el SQL?)", "error");
  } finally {
    const btn = document.getElementById('btn-save-client');
    if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Guardar'; }
  }
}

document.addEventListener('DOMContentLoaded', async () => {
  if (!window.supabase) return;

  if (!window.finSupabase) window.finSupabase = window.supabase.createClient(SB_URL, SB_KEY, { db: { schema: FIN_SCHEMA } });
  if (!window.globalSupabase) window.globalSupabase = window.supabase.createClient(SB_URL, SB_KEY);

  const { data: { session } } = await window.globalSupabase.auth.getSession();
  if (!session) return;

  // Perfil + permisos (roles tenant o legacy app_metadata)
const { data: profile } = await window.globalSupabase
  .from('profiles')
  .select('role, app_metadata')
  .eq('id', session.user.id)
  .single();

const role = String(profile?.role || '').toLowerCase().trim();
const roleHasAccess = (role === 'admin') || (role === 'casa_de_piedra') || (role === 'ambos');

const roleDefaultPerms = {
  clients_view: true,
  clients_manage: true,
  orders_view: true,
  reports_view: true
};

const perms = (role === 'admin')
  ? roleDefaultPerms
  : (roleHasAccess ? roleDefaultPerms : (profile?.app_metadata?.finanzas?.permissions || {}));

// Access rules: roles tenant siempre pueden ver Clientes
const canView = (role === 'admin') || roleHasAccess
  || perms.clients_view === true
  || perms.clients_manage === true
  || perms.orders_view === true
  || perms.catalog_manage === true
  || perms.reports_view === true;

canManage = (role === 'admin') || roleHasAccess || perms.clients_manage === true;

if (!canView) { setTimeout(() => window.location.href = 'catalog.html', 800); return; }

// Nav hide (compat: si no existe key, NO escondemos)
  if (profile?.role !== 'admin') {
    const navRules = {
      'orders.html': ('orders_view' in perms) ? !!perms.orders_view : true,
      'reports.html': ('reports_view' in perms) ? !!perms.reports_view : true,
      'clientes.html': (('clients_view' in perms) || ('clients_manage' in perms)) ? (!!perms.clients_view || !!perms.clients_manage) : true
    };
    Object.keys(navRules).forEach(page => {
      if (!navRules[page]) {
        const link = document.querySelector(`a[href="${page}"]`);
        if (link) link.classList.add('hidden');
      }
    });
  }

  // UI permissions
  const btnNew = document.getElementById('btn-new-client');
  if (btnNew) {
    if (!canManage) btnNew.classList.add('hidden');
    btnNew.addEventListener('click', () => openClientModal(null));
  }

  document.getElementById('clients-search')?.addEventListener('input', applySearch);
  document.getElementById('btn-save-client')?.addEventListener('click', saveClient);

  await loadClients();
});