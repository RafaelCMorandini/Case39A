-- Criação de tabelas para o Case 39A

-- 1. Tabela de Clientes
-- PK: id (serial) para auto-incremento
-- Campos: nome (obrigatório)
CREATE TABLE IF NOT EXISTS clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela de Contratos
-- PK: id (serial)
-- FK: cliente_id (referencia clientes)
-- Campos: data_inicio, ativo (boolean para facilitar filtros de status)
-- Index: cliente_id para agilizar joins
CREATE TABLE IF NOT EXISTS contratos (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(id) ON DELETE CASCADE,
    data_inicio DATE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE INDEX IF NOT EXISTS idx_contratos_cliente_id ON contratos(cliente_id);
CREATE INDEX IF NOT EXISTS idx_contratos_ativo ON contratos(ativo);

-- 3. Tabela de Leituras
-- PK: id (serial)
-- FK: contrato_id (referencia contratos)
-- Campos: data_leitura, valor_kwh (numeric para precisão)
-- Index: contrato_id e data_leitura para agilizar filtros por período
CREATE TABLE IF NOT EXISTS leituras (
    id SERIAL PRIMARY KEY,
    contrato_id INTEGER REFERENCES contratos(id) ON DELETE CASCADE,
    data_leitura DATE NOT NULL,
    valor_kwh NUMERIC(10, 2) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_leituras_contrato_id ON leituras(contrato_id);
CREATE INDEX IF NOT EXISTS idx_leituras_data ON leituras(data_leitura);
