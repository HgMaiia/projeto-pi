create database colmeias;
use colmeias; 

-- 01 apicultor
CREATE TABLE apicultor (
id INT PRIMARY KEY AUTO_INCREMENT, 
nome VARCHAR(100) NOT NULL, 
cpf CHAR(11), 
telefone VARCHAR(20),
email VARCHAR(120),
dataCadastro DATE, -- datetime
ativo TINYINT DEFAULT 1
);

INSERT INTO apicultor (nome, cpf, telefone, email, dataCadastro, ativo) VALUES
('Joao Ferreira', '11122233344', '11988887777', 'joao@apiario.com', '2024-03-10', 1), 
('Maria Souza', '22233344455', NULL, 'maria@apiario.com', '2024-06-01', 0);

INSERT INTO apicultor (nome, cpf, telefone, email, dataCadastro) VALUES 
('Pedro Lima', '33344455566', '11977776666', 'pedro@apiario.com', '2025-01-15');

ALTER TABLE apicultor ADD CONSTRAINT chk_apicultor_ativo CHECK (ativo IN (0,1));

SELECT    
nome,    
CONCAT(nome, ' - ', email) AS contato,    
CASE ativo
 WHEN 1 THEN 'Ativo'        
 WHEN 0 THEN 'Inativo'        
 ELSE 'Inválido'    
 END AS situacao FROM apicultor;
 
 -- 02 apiário
 CREATE TABLE apiario (    
 id INT PRIMARY KEY AUTO_INCREMENT,    
 nome VARCHAR(100) NOT NULL,    
 endereco VARCHAR(150),  
 quantidadeColmeias INT,    
 dataCriacao DATE, -- datetime    
 ativo TINYINT DEFAULT 1 
 );
 
 INSERT INTO apiario (nome, endereco, quantidadeColmeias, dataCriacao, ativo) VALUES 
 ('Apiario Vale Verde', 'Zona Rural - MG', 12, '2023-09-01', 1), 
 ('Apiario Serra Alta', 'Zona Rural - SP', 8, '2024-02-20', 1), 
 ('Apiario Rio Claro', 'Zona Rural - RJ', NULL, '2024-11-05', 0);
 
 ALTER TABLE apiario DROP COLUMN localizacao, 
 ADD COLUMN responsavel VARCHAR(100);
 
 SELECT    
 nome,    
 IFNULL(quantidadeColmeias, 0) AS colmeias,    
 CASE        
 WHEN quantidadeColmeias IS NULL THEN 'Sem colmeias cadastradas'        
 WHEN quantidadeColmeias < 10 THEN 'Pequeno'        
 ELSE 'Grande'    
 END AS porte 
 FROM apiario;
 
 -- 03 colmeias
 CREATE TABLE colmeia (    
id INT PRIMARY KEY AUTO_INCREMENT,    
identificacao VARCHAR(50) NOT NULL,
especie VARCHAR(80),  
dataInstalacao DATE,    
status_ VARCHAR(30),    
ativa TINYINT DEFAULT 1 
);

INSERT INTO colmeia (identificacao, especie, dataInstalacao, status_, ativa) VALUES 
('Colmeia-01', 'Apis mellifera', '2023-09-05', 'Normal', 1), 
('Colmeia-02', 'Apis mellifera', '2023-10-12', 'Pré-enxameação', 1), 
('Colmeia-03', 'Melipona', '2024-01-20', 'Normal', 0);

ALTER TABLE colmeia ADD CONSTRAINT chk_colmeia_status CHECK (status_ IN ('Normal', 'Pré-enxameação', 'Pós-enxameação'));

SELECT    
identificacao,    
dataInstalacao,    
TIMESTAMPDIFF(MONTH, dataInstalacao, CURDATE()) AS mesesInstalada FROM colmeia;

-- 04 sensor
CREATE TABLE sensor (    
id INT PRIMARY KEY AUTO_INCREMENT,    
modelo VARCHAR(50), 
tipo VARCHAR(20),    
dataInstalacao DATE,    
ultimaManutencao DATE,    
funcionando TINYINT DEFAULT 1 
);

INSERT INTO sensor (modelo, tipo, dataInstalacao, ultimaManutencao, funcionando) VALUES 
('LM35', 'Interno', '2023-09-05', '2025-01-10', 1), 
('LM35', 'Externo', '2023-09-05', NULL, 1), 
('LM35', 'Externo', '2024-02-15', '2025-03-01', 0);

SELECT    
modelo,    
tipo,    
CASE        
WHEN ultimaManutencao IS NULL THEN 'Nunca teve manutenção'
ELSE CONCAT(DATEDIFF(CURDATE(), ultimaManutencao), ' dias atrás')    
END AS statusManutencao 
FROM sensor;

-- 05 leitura de temperatura
CREATE TABLE leitura_temperatura (    
id INT PRIMARY KEY AUTO_INCREMENT,    
temperatura DECIMAL(5,2) NOT NULL,    
dataHora DATETIME,    
sensorReferencia VARCHAR(50) 
);

INSERT INTO leitura_temperatura (temperatura, dataHora, sensorReferencia) VALUES 
(34.50, '2026-09-01 08:00:00', 'Sensor-01'), 
(37.80, '2026-09-01 08:05:00', 'Sensor-01'), 
(33.90, '2026-09-01 08:10:00', 'Sensor-02');

ALTER TABLE leitura_temperatura ADD CONSTRAINT chk_temperatura_valida CHECK (temperatura BETWEEN 0 AND 50);

SELECT    
sensorReferencia,    
temperatura,    
DATE_FORMAT(dataHora, '%d/%m/%Y %H:%i:%s') AS dataHoraFormatada,    
CASE        
WHEN temperatura BETWEEN 33 AND 36 THEN 'Normal'        
WHEN temperatura BETWEEN 37 AND 38 THEN 'Pré-enxameação'        
WHEN temperatura < 32 THEN 'Pós-enxameação'        
ELSE 'Fora do padrão'    
END AS classificacao FROM leitura_temperatura;

-- 06 alerta
CREATE TABLE alerta (    
id INT PRIMARY KEY AUTO_INCREMENT,    
tipoAlerta VARCHAR(50) NOT NULL,    
dataHora DATETIME,    
status_alerta VARCHAR(20) DEFAULT 'Pendente', 
resolvido TINYINT DEFAULT 0
);

INSERT INTO alerta (tipoAlerta, dataHora, status_alerta, resolvido) VALUES 
('Risco de enxameação', '2026-09-01 08:05:00', 'Pendente', 0), 
('Sensor sem resposta', '2026-09-01 09:00:00', NULL, 0); 

INSERT INTO alerta (tipoAlerta, dataHora) VALUES 
('Risco de enxameação', '2026-09-02 07:40:00');

SELECT    
tipoAlerta,    
IFNULL(status_, 'Sem status definido') AS status_,    
TIMESTAMPDIFF(MINUTE, dataHora, NOW()) AS minutosDesdeAlerta FROM alerta;

-- 07 inspeção
CREATE TABLE inspecao (    
id INT PRIMARY KEY AUTO_INCREMENT,    
dataInspecao DATE,    
observacao VARCHAR(200),    
apicultorResponsavel VARCHAR(100) ); 

INSERT INTO inspecao (dataInspecao, observacao, apicultorResponsavel) VALUES 
('2026-08-15', 'Colmeia com boa produção, sem sinais de estresse', 'Joao Ferreira'), 
('2026-08-20', NULL, 'Maria Souza'), 
('2026-08-25', 'Necessário reforçar ventilação', 'Pedro Lima');

ALTER TABLE inspecao RENAME COLUMN observacao TO observacoes, 
ADD COLUMN duracaoMinutos INT;

SELECT    
dataInspecao,    
apicultorResponsavel,    
IFNULL(observacoes, 'Sem observações registradas') AS observacoes 
FROM inspecao;

-- 08 produção de mel
CREATE TABLE producao_mel (    
id INT PRIMARY KEY AUTO_INCREMENT,   
quantidadeKg DECIMAL(6,2),    
dataColeta DATE,    
qualidade VARCHAR(30),    
precoVenda DECIMAL(10,2) 
); 

INSERT INTO producao_mel (quantidadeKg, dataColeta, qualidade, precoVenda) VALUES 
(25.50, '2026-06-10', 'Premium', 450.00), 
(18.00, '2026-07-15', 'Padrão', 300.00), 
(0.00, '2026-08-01', 'Perda por enxameação', NULL);

ALTER TABLE producao_mel ADD CONSTRAINT chk_producao_quantidade CHECK (quantidadeKg >= 0);

SELECT    
dataColeta,    
qualidade,    
quantidadeKg,    
IFNULL(precoVenda, 0) * quantidadeKg AS receitaEstimada 
FROM producao_mel;

