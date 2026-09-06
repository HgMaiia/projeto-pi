-- Tabelas - Colmeia Tech --

CREATE DATABASE colmeias;
USE colmeias;

CREATE TABLE apicultor_PF(
id_apicultorPF INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,
cpf CHAR(11) UNIQUE NOT NULL,
email VARCHAR(30) NOT NULL UNIQUE,
telefone varchar(20),
data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
ativo TINYINT DEFAULT 1
);

CREATE TABLE apicultor_PJ (
id_apicultorPF INT PRIMARY KEY AUTO_INCREMENT,
nome_fantasia VARCHAR(50) NOT NULL,
cnpj CHAR(14) UNIQUE NOT NULL,
email VARCHAR(30) NOT NULL UNIQUE,
telefone varchar(20),
data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
ativo TINYINT DEFAULT 1
);

CREATE TABLE apiario (
id_apiario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(20),
endereco VARCHAR(150),
CEP CHAR(8)
);

CREATE TABLE colmeia(
id_colmeia INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(30),
especie VARCHAR(40),
status_enxame VARCHAR(20),
CONSTRAINT chkStatus CHECK (status_enxame IN('Normal', 'Pré-enxameação', 'Pós-enxameação'))
);

CREATE TABLE sensor(
id_sensor INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(30),
ativo boolean DEFAULT TRUE
);

CREATE TABLE temperatura(
id_temperatura INT PRIMARY KEY AUTO_INCREMENT,
temperatura DECIMAL(5,2),
data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE alerta(
id_alerta INT PRIMARY KEY AUTO_INCREMENT,
mensagem VARCHAR(30),
data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- INSERÇÕES DE DADOS
INSERT INTO apicultor_PF(nome, cpf, email, telefone, data_cadastro, ativo) VALUES
('Rodrigo Ferreira', 12312348910, 'Ferreira@gmail.com', 011989901524, '2025-10-31 18:29:10', 1),
('Carla Silva', 77788899912, 'SilvaC@gmail.com', 99876543223, DEFAULT, 1),
('João Caltabiano', 66577566212, 'CaltabianoJC@gmail.com', 11993004209, '2023-06-23 14:39:20', 0);

INSERT INTO apicultor_PJ(nome_fantasia, CNPJ, email, telefone, data_cadastro, ativo) VALUES
('Casa do Mel', '12345678901234', 'CasaMel09@gmail.com', 1234345668, '2024-08-08 13:12:08', 1),
('Apicultura Irmãos', '98765432101234', 'IrmaosMel@gmail.com', 1125020498, '2025-10-07 08:14:21', 0),
('Apiário Própolis', '12312312345617', 'propolisApiario@gmail.com', 91124245432, DEFAULT, 1);

INSERT INTO apiario(nome, endereco, CEP) VALUES
('Apiário Principal', 'Rua João Silva, 34', 12345222),
('Apiário Médio', 'Rua Maria, 22', 3434009),
('Apiário Pequeno', 'Rua Constelação, 125', 77977982),
('Apiário Abandonado', NULL, 78265982);

INSERT INTO colmeia(nome, especie, status_enxame) VALUES 
('Colmeia 1', 'Melífera', 'Pré-enxameação'),
('Colmeia 2', 'Meliponíneo', 'Pós-enxameação'),
('Colmeia 3', 'Melífera', 'Normal');

INSERT INTO sensor(nome, ativo) VALUES
('Sensor Temperatura 1', 1),
('Sensor Temperatura 2', 0),
('Sensor Temperatura 3', 1);

INSERT INTO temperatura(temperatura, data_hora) VALUES
(32.1, DEFAULT),
(38.2, '2026-02-02 12:21:10'),
(37.80, '2026-03-10 10:05:25'),
(33.90, '2026-08-24 16:20:34');

INSERT INTO alerta(mensagem, data_hora) VALUES
('Colmeia em pré-enxameação', DEFAULT),
('Colmeia em pré-enxameação', '2026-03-10 10:10:45'),
('Colmeia em pós-enxameação', '2026-08-24 16:20:34');

-- SELECTS PARA AS TABELAS:
DESC apicultor_PJ;

-- Apicultor (Pessoa física e Pessoa jurídica)
SELECT 
Nome,
CONCAT(email,' - ', telefone) AS Contato,
CASE ativo 
WHEN 1 THEN 'Ativo'
WHEN 0 THEN 'Inativo'
ELSE 'Em análise'
END as 'Status do Cadastro'
FROM apicultor_PF;

SELECT 
nome_fantasia AS 'Nome Fantasia',
CONCAT(email,' - ', telefone) AS Contato,
CASE ativo 
WHEN 1 THEN 'Ativo'
WHEN 0 THEN 'Inativo'
ELSE 'Em análise'
END as 'Status do Cadastro'
FROM apicultor_PJ;

-- Apiário e Colmeias
SELECT nome, CONCAT(IFNULL(endereco, 'Sem endereço'),' - ', CEP) AS Endereço FROM apiario;

SELECT nome, especie, 
status_enxame AS Status,
CASE status_enxame
WHEN 'Pré-enxameação' THEN 'Necessário manutenção preventiva urgente'
WHEN 'Pós-enxameação' THEN 'Necessário manutenção da colmeia após enxameação'
ELSE 'Não é necessário manutenção'
END AS Manutenção
FROM colmeia;

-- Sensores, dados de temperatura e mensagens de alerta
SELECT nome,
CASE ativo
WHEN 1 THEN 'Ativo'
WHEN 0 THEN 'Inativo'
ELSE 'Em manutenção'
END as 'Status do sensor'
FROM sensor;

SELECT  DATE_FORMAT(data_Hora, '%d/%m/%Y %H:%i:%s') AS Data, CONCAT(temperatura, ' ºC') AS Graus,
CASE          
WHEN temperatura BETWEEN 37 AND 38 THEN 'Temperatura elevada, chance de enxameação'        
WHEN temperatura < 32 THEN 'Temperatura abaixo do ideal, precisa de atenção'        
ELSE 'Temperatura Esperada'
END AS Classificação
FROM temperatura ORDER BY Classificação;

SELECT mensagem, DATE_FORMAT(data_Hora, '%d/%m/%Y %H:%i:%s') AS Data
FROM alerta WHERE data_hora BETWEEN '2026-08-01' AND '2026-09-01'; 