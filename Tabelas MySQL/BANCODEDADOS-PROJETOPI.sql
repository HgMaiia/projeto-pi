-- ========================================================
--                       TABELAS 
-- ========================================================
create database colmeias;
use colmeias;
-- ========================================================
CREATE TABLE apicultor (
id INT PRIMARY KEY AUTO_INCREMENT, 
nome VARCHAR(100) NOT NULL, 
cpf CHAR(11) NOT NULL UNIQUE, 
telefone VARCHAR(20) NOT NULL UNIQUE,
email VARCHAR(120) NOT NULL UNIQUE,
dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
ativo BOOLEAN
);
-- ========================================================
 CREATE TABLE apiario (    
 id INT PRIMARY KEY AUTO_INCREMENT,    
 nome VARCHAR(100) NOT NULL,    
 endereco VARCHAR(150) NOT NULL, 
 dataCriacao DATETIME   
 );
-- ========================================================
CREATE TABLE colmeia (    
id INT PRIMARY KEY AUTO_INCREMENT,    
identificacao VARCHAR(20) NOT NULL,
dataInstalacao DATETIME
);
-- ========================================================
CREATE TABLE sensor (    
id INT PRIMARY KEY AUTO_INCREMENT,    
modelo CHAR(4) NOT NULL DEFAULT 'LM35',       
dataInstalacao DATETIME,    
ultimaManutencao DATETIME,    
funcionando BOOLEAN
);
-- ========================================================
CREATE TABLE leitura_temperatura (    
id INT PRIMARY KEY AUTO_INCREMENT,    
temperatura DECIMAL(5,2) NOT NULL,    
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,    
sensorReferencia VARCHAR(50) 
);
-- ========================================================
CREATE TABLE alerta (    
id INT PRIMARY KEY AUTO_INCREMENT,    
tipoAlerta VARCHAR(50) NOT NULL,    
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,    
status_alerta VARCHAR(20) DEFAULT 'Pendente', 
resolvido TINYINT DEFAULT 0
);
-- ========================================================
CREATE TABLE inspecao (    
id INT PRIMARY KEY AUTO_INCREMENT,    
dataInspecao DATE,    
observacao VARCHAR(200),    
apicultorResponsavel VARCHAR(100) 
); 
-- ========================================================
CREATE TABLE producao_mel (    
id INT PRIMARY KEY AUTO_INCREMENT,   
quantidadeKg DECIMAL(6,2) NOT NULL,    
dataColeta DATETIME DEFAULT CURRENT_TIMESTAMP,    
qualidade VARCHAR(30),    
precoVenda DECIMAL(10,2) NOT NULL
); 
-- ========================================================
CREATE TABLE historico (
id_historico INT PRIMARY KEY AUTO_INCREMENT,
ativo_apiario BOOLEAN,
ativo_colmeia BOOLEAN,
qntColmeias INT NOT NULL
);
-- ======================================================================================
--                                  INSERTS DE CADA TABELA
-- ======================================================================================
INSERT INTO apicultor (nome, cpf, telefone, email, dataCadastro, ativo) VALUES
('Joao Ferreira', '78787878787', '11988887777', 'joao@apiario.com', '2024-03-10', 1), 
('Maria Souza', '90909090909', '1198989898', 'maria@apiario.com', '2024-06-01', 0),
('Pedro Lima', '90909090876', '11977776666', 'pedro@apiario.com', '2025-01-15', 1);
-- ======================================================================================
 INSERT INTO apiario (nome, endereco, dataCriacao) VALUES 
 ('Apiario Vale Verde', 'Zona Rural - MG', '2023-09-01'), 
 ('Apiario Serra Alta', 'Zona Rural - SP', '2024-02-20'), 
 ('Apiario Rio Claro', 'Zona Rural - RJ','2024-11-05');
 -- ======================================================================================
 INSERT INTO colmeia (identificacao, dataInstalacao) VALUES 
('Colmeia-01', '2023-09-05'), 
('Colmeia-02', '2023-10-12'), 
('Colmeia-03', '2024-01-20');
 -- ======================================================================================
 INSERT INTO sensor (dataInstalacao, ultimaManutencao, funcionando) VALUES 
('2023-09-05', '2025-01-10', 1), 
('2023-09-05', NULL, 1), 
('2024-02-15', '2025-03-01', 0);
 -- ======================================================================================
 INSERT INTO leitura_temperatura (temperatura, dataHora, sensorReferencia) VALUES 
(34.50, '2026-09-01 08:00:00', 'Sensor-01'), 
(37.80, '2026-09-01 08:05:00', 'Sensor-01'), 
(33.90, '2026-09-01 08:10:00', 'Sensor-02');
-- ======================================================================================
INSERT INTO alerta (tipoAlerta, dataHora, status_alerta, resolvido) VALUES 
('Risco de enxameação', '2026-09-01 08:05:00', 'Pendente', 0), 
('Sensor sem resposta', '2026-09-01 09:00:00', NULL, 0),
('Risco de enxameação', '2026-09-02 07:40:00', 'Pendente', 1);
-- ======================================================================================
INSERT INTO inspecao (dataInspecao, observacao, apicultorResponsavel) VALUES 
('2026-08-15', 'Colmeia com boa produção, sem sinais de estresse', 'Joao Ferreira'), 
('2026-08-20', NULL, 'Maria Souza'), 
('2026-08-25', 'Necessário reforçar ventilação', 'Pedro Lima');
-- ======================================================================================
INSERT INTO producao_mel (quantidadeKg, dataColeta, qualidade, precoVenda) VALUES 
(25.50, '2026-06-10', 'Premium', 450.00), 
(18.00, '2026-07-15', 'Padrão', 300.00), 
(0.00, '2026-08-01', 'Perda por enxameação', 8000.00);
-- ======================================================================================
INSERT INTO historico (ativo_apiario, ativo_colmeia, qntColmeias) VALUES
(1, 1, 12),
(1, 1, 6),
(0, 0, 8);
-- ======================================================================================
--                            SELECTS PRINCIPAIS DE CADA TABELA 
-- ======================================================================================
SELECT    
nome,    
CONCAT(nome, ' - ', email, ' - ', telefone) AS contato,    
CASE ativo
 WHEN 1 THEN 'Ativo'        
 WHEN 0 THEN 'Inativo'        
 ELSE 'Inválido'    
 END AS situacao FROM apicultor;
 -- ======================================================================================
SELECT    
modelo,        
CASE        
WHEN ultimaManutencao IS NULL THEN 'Nunca teve manutenção'
ELSE CONCAT(DATEDIFF(CURDATE(), ultimaManutencao), ' dias atrás')    
END AS statusManutencao 
FROM sensor;
 -- ======================================================================================
 SELECT    
sensorReferencia,    
CONCAT(temperatura, ' ºC ') AS TEMPERATURA,   
DATE_FORMAT(dataHora, '%d/%m/%Y %H:%i:%s') AS dataHoraFormatada,    
CASE        
WHEN temperatura BETWEEN 33 AND 36 THEN 'Normal'        
WHEN temperatura BETWEEN 37 AND 38 THEN 'Temperatura elevada, precisa de atenção'        
WHEN temperatura < 32 THEN 'Temperatura abaixo do ideal, precisa de atenção'        
ELSE 'Fora do padrão'    
END AS classificacao FROM leitura_temperatura;
-- ======================================================================================
SELECT    
dataColeta,    
qualidade,    
CONCAT(quantidadeKg, ' Kg ') AS quantidade_kg,     
CONCAT(' R$ ', precoVenda * quantidadeKg) AS receitaEstimada 
FROM producao_mel;
-- ======================================================================================
--                            SELECTS RESERVAS DE CADA TABELA 
-- ======================================================================================
SELECT    
tipoAlerta,    
IFNULL(status_alerta, 'Sem status definido') AS status_ALERTA,    
TIMESTAMPDIFF(HOUR, dataHora, NOW()) AS horasDesdeAlerta,
TIMESTAMPDIFF(DAY, dataHora, NOW()) AS diasDesdeAlerta FROM alerta;
-- ======================================================================================
 SELECT    
 qntColmeias,      
 CASE        
 WHEN qntColmeias IS NULL THEN 'Sem colmeias cadastradas'        
 WHEN qntColmeias < 10 THEN 'Pequeno'
 WHEN qntColmeias BETWEEN 11 AND 24 THEN 'Padrão'
 ELSE 'Grande'    
 END AS porte 
 FROM historico;
 -- ======================================================================================
 SELECT    
identificacao,    
dataInstalacao,    
TIMESTAMPDIFF(MONTH, dataInstalacao, CURDATE()) AS mesesInstalada FROM colmeia;
 -- ======================================================================================
SELECT    
dataInspecao,    
apicultorResponsavel,    
IFNULL(observacao, 'Sem observações registradas') AS observacoes 
FROM inspecao;
 -- ======================================================================================
