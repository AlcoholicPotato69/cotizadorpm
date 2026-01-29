-- ============================================================
-- 1) TABLA CLIENTES (finanzas)
-- ============================================================
CREATE TABLE IF NOT EXISTS finanzas.clientes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre_completo TEXT NOT NULL,
  telefono TEXT,
  correo TEXT,
  rfc TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Trigger updated_at (si no existe en tu DB)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_proc WHERE proname = 'set_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION public.set_updated_at()
    RETURNS TRIGGER AS $fn$
    BEGIN
      NEW.updated_at = now();
      RETURN NEW;
    END;
    $fn$ LANGUAGE plpgsql;
  END IF;
END $$;

DROP TRIGGER IF EXISTS trg_finanzas_clientes_updated_at ON finanzas.clientes;
CREATE TRIGGER trg_finanzas_clientes_updated_at
BEFORE UPDATE ON finanzas.clientes
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- Índices útiles
CREATE INDEX IF NOT EXISTS idx_finanzas_clientes_nombre ON finanzas.clientes (lower(nombre_completo));
CREATE INDEX IF NOT EXISTS idx_finanzas_clientes_correo ON finanzas.clientes (lower(correo));
CREATE INDEX IF NOT EXISTS idx_finanzas_clientes_rfc ON finanzas.clientes (rfc);

-- ============================================================
-- 2) ALTER cotizaciones para link con clientes
-- ============================================================
ALTER TABLE finanzas.cotizaciones
ADD COLUMN IF NOT EXISTS cliente_id UUID;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_schema='finanzas'
      AND table_name='cotizaciones'
      AND constraint_name='cotizaciones_cliente_id_fkey'
  ) THEN
    ALTER TABLE finanzas.cotizaciones
    ADD CONSTRAINT cotizaciones_cliente_id_fkey
    FOREIGN KEY (cliente_id)
    REFERENCES finanzas.clientes(id)
    ON DELETE SET NULL;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_finanzas_cotizaciones_cliente_id
ON finanzas.cotizaciones (cliente_id);

-- ============================================================
-- 3) Repetimos TODO para finanzas_casadepiedra
-- ============================================================
CREATE TABLE IF NOT EXISTS finanzas_casadepiedra.clientes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre_completo TEXT NOT NULL,
  telefono TEXT,
  correo TEXT,
  rfc TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

DROP TRIGGER IF EXISTS trg_fcdp_clientes_updated_at ON finanzas_casadepiedra.clientes;
CREATE TRIGGER trg_fcdp_clientes_updated_at
BEFORE UPDATE ON finanzas_casadepiedra.clientes
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX IF NOT EXISTS idx_fcdp_clientes_nombre ON finanzas_casadepiedra.clientes (lower(nombre_completo));
CREATE INDEX IF NOT EXISTS idx_fcdp_clientes_correo ON finanzas_casadepiedra.clientes (lower(correo));
CREATE INDEX IF NOT EXISTS idx_fcdp_clientes_rfc ON finanzas_casadepiedra.clientes (rfc);

ALTER TABLE finanzas_casadepiedra.cotizaciones
ADD COLUMN IF NOT EXISTS cliente_id UUID;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_schema='finanzas_casadepiedra'
      AND table_name='cotizaciones'
      AND constraint_name='cotizaciones_cliente_id_fkey'
  ) THEN
    ALTER TABLE finanzas_casadepiedra.cotizaciones
    ADD CONSTRAINT cotizaciones_cliente_id_fkey
    FOREIGN KEY (cliente_id)
    REFERENCES finanzas_casadepiedra.clientes(id)
    ON DELETE SET NULL;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_fcdp_cotizaciones_cliente_id
ON finanzas_casadepiedra.cotizaciones (cliente_id);

-- ============================================================
-- 4) (Opcional) RLS si lo necesitas
-- ============================================================
-- Si tus tablas usan RLS, esto es lo mínimo para que funcione.
-- Ajusta a tus políticas reales si ya tienes control por rol.
ALTER TABLE finanzas.clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE finanzas_casadepiedra.clientes ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='finanzas' AND tablename='clientes') THEN
    CREATE POLICY "allow authenticated full access"
      ON finanzas.clientes
      FOR ALL
      TO authenticated
      USING (true)
      WITH CHECK (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='finanzas_casadepiedra' AND tablename='clientes') THEN
    CREATE POLICY "allow authenticated full access"
      ON finanzas_casadepiedra.clientes
      FOR ALL
      TO authenticated
      USING (true)
      WITH CHECK (true);
  END IF;
END $$;
