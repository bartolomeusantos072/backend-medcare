-- ===============================
-- SCRIPT: MedCare Pessoal (MySQL)
-- Autor: ChatGPT
-- ===============================

CREATE DATABASE IF NOT EXISTS medcare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medcare;

-- ========== Tabela: usuarios ==========
CREATE TABLE usuarios (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    senha_hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ========== Tabela: pacientes ==========
CREATE TABLE pacientes (
    id_paciente BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    sexo VARCHAR(20) NOT NULL DEFAULT 'NAO_INFORMADO',
    endereco VARCHAR(255),
    telefone VARCHAR(20),
    email VARCHAR(100),
    tipo_sanguineo VARCHAR(10),
    historico_medico TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_paciente_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CHECK (sexo IN ('MASCULINO', 'FEMININO', 'NAO_INFORMADO'))
);

-- ========== Tabela: acompanhantes ==========
CREATE TABLE acompanhantes (
    id_acompanhante BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    relacao VARCHAR(50),
    telefone VARCHAR(20),
    email VARCHAR(100),
    data_nascimento DATE,
    observacoes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ========== Tabela: paciente_acompanhante ==========
CREATE TABLE paciente_acompanhante (
    id_paciente BIGINT,
    id_acompanhante BIGINT,
    PRIMARY KEY (id_paciente, id_acompanhante),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_acompanhante) REFERENCES acompanhantes(id_acompanhante) ON DELETE CASCADE
);

-- ========== Tabela: consultas ==========
CREATE TABLE consultas (
    id_consulta BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    data_consulta DATE NOT NULL,
    medico_nome VARCHAR(100),
    especialidade VARCHAR(50),
    diagnostico TEXT,
    tratamento_recomendado TEXT,
    observacoes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE
);

-- ========== Tabela: medicamentos ==========
CREATE TABLE medicamentos (
    id_medicamento BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    dosagem VARCHAR(50),
    forma_uso VARCHAR(50),
    frequencia VARCHAR(50),
    horario VARCHAR(50),
    duracao_tratamento VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE
);

-- ========== Tabela: internacoes ==========
CREATE TABLE internacoes (
    id_internacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    hospital_nome VARCHAR(100),
    motivo_internacao TEXT,
    data_entrada DATE NOT NULL,
    data_saida DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVA',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
    CHECK (status IN ('ATIVA', 'ALTA', 'OBITO'))
);

-- ========== Tabela: exames ==========
CREATE TABLE exames (
    id_exame BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    tipo_exame VARCHAR(100) NOT NULL,
    data_exame DATE NOT NULL,
    resultado TEXT,
    laudo_url VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
    CHECK (status IN ('PENDENTE', 'CONCLUIDO'))
);

-- ========== Tabela: cirurgias ==========
CREATE TABLE cirurgias (
    id_cirurgia BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    tipo_cirurgia VARCHAR(100) NOT NULL,
    data_cirurgia DATE NOT NULL,
    medico_nome VARCHAR(100),
    hospital_nome VARCHAR(100),
    complicacoes TEXT,
    resultado TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE
);

-- ========== Tabela: sinais_vitais ==========
CREATE TABLE sinais_vitais (
    id_sinal_vital BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    data_hora DATETIME NOT NULL,
    pressao_arterial VARCHAR(20),
    frequencia_cardiaca INT,
    peso DECIMAL(5,2),
    altura DECIMAL(5,2),
    temperatura DECIMAL(5,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE
);

-- ========== Tabela: controle_diabetes ==========
CREATE TABLE controle_diabetes (
    id_controle BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    data_hora DATETIME NOT NULL,
    glicemia DECIMAL(5,2) NOT NULL,
    tipo_diabetes VARCHAR(30) NOT NULL DEFAULT 'NAO_INFORMADO',
    medicao_tipo VARCHAR(30) NOT NULL DEFAULT 'OUTRO',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
    CHECK (tipo_diabetes IN ('TIPO1', 'TIPO2', 'GESTACIONAL', 'NAO_INFORMADO')),
    CHECK (medicao_tipo IN ('JEJUM', 'POS_PRANDIAL', 'ALEATORIA', 'OUTRO'))
);

-- ========== Tabela: alertas ==========
CREATE TABLE alertas (
    id_alerta BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    tipo_alerta VARCHAR(30) NOT NULL DEFAULT 'OUTRO',
    data_hora DATETIME NOT NULL,
    mensagem TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
    CHECK (tipo_alerta IN ('CONSULTA', 'MEDICAMENTO', 'EXAME', 'OUTRO'))
);

-- ========== Tabela: alerta_destinatarios ==========
CREATE TABLE alerta_destinatarios (
    id_alerta_destinatario BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_alerta BIGINT NOT NULL,
    id_paciente BIGINT,
    id_acompanhante BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_alerta) REFERENCES alertas(id_alerta) ON DELETE CASCADE,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_acompanhante) REFERENCES acompanhantes(id_acompanhante) ON DELETE CASCADE,
    CHECK (id_paciente IS NOT NULL OR id_acompanhante IS NOT NULL)
);

-- ========== Tabela: anexos ==========
CREATE TABLE anexos (
    id_anexo BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    referencia_tabela VARCHAR(100) NOT NULL,
    referencia_id BIGINT NOT NULL,
    arquivo_url VARCHAR(500) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE
);
