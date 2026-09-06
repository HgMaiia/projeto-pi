create database projetoPi;
use projetoPi;

-- Tabela de registro pessoal do cliente.
CREATE TABLE apicultor (
id INT PRIMARY KEY AUTO_INCREMENT, 
nome VARCHAR(100) NOT NULL, 
cpf CHAR(11) NOT NULL UNIQUE, 
telefone VARCHAR(20) NOT NULL UNIQUE,
email VARCHAR(120) NOT NULL UNIQUE,
dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
ativo BOOLEAN
);

-- Tabela de registros dos apiários (conjunto)
 CREATE TABLE apiario (    
 id INT PRIMARY KEY AUTO_INCREMENT,    
 nome VARCHAR(100) NOT NULL,    
 endereco VARCHAR(150) NOT NULL, 
 dataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP   
 );
 
 -- Tabela de sensores
 CREATE TABLE sensor (    
id INT PRIMARY KEY AUTO_INCREMENT,    
modelo CHAR(4) NOT NULL DEFAULT 'LM35',       
dataInstalacao DATETIME DEFAULT CURRENT_TIMESTAMP,    
ultimaManutencao DATETIME,    
funcionando BOOLEAN
);
 
-- Tabela de colmeias (unidade no apiário)
CREATE TABLE colmeia (    
id INT PRIMARY KEY AUTO_INCREMENT,    
identificacao VARCHAR( letados
CREATE TABLE dadosColetados (    
id INT PRIMARY KEY AUTO_INCREMENT,    
temperatura DECIMAL(3,1) NOT NULL,    
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,    
sensorReferencia VARCHAR(10) 
);

-- Tabela para alertas e avisos
CREATE TABLE alerta (    
id INT PRIMARY KEY AUTO_INCREMENT,    
tipoAlerta VARCHAR(50) NOT NULL,    
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,    
msgAlerta VARCHAR(20) DEFAULT 'Pendente', 
resolvido TINYINT DEFAULT 0
);

-- Tabela de manutenção e cuidados do apiário/colmeia
CREATE TABLE manutencao (    
id INT PRIMARY KEY AUTO_INCREMENT,    
dataInspecao DATE,    
comentario VARCHAR(255) DEFAULT 'Sem Comentários.',    
apicultorResponsavel VARCHAR(100) 
); 

-- Tabela para dados do mel
CREATE TABLE producaoMel (    
id INT PRIMARY KEY AUTO_INCREMENT,   
quantidadeKg DECIMAL(6,2) NOT NULL,    
dataColeta DATETIME DEFAULT CURRENT_TIMESTAMP,    
precoVenda DECIMAL(6,2) NOT NULL
); 

-- Tabela de uso frequente
CREATE TABLE tabelaGlobal (
idGlobal INT PRIMARY KEY AUTO_INCREMENT,
ativoApiario BOOLEAN,
ativoColmeia BOOLEAN,
qtdColmeias INT NOT NULL
);

-- ======================================================================================
--                                         INSERTS
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
 INSERT INTO dadosColetados (temperatura, dataHora, sensorReferencia) VALUES 
(34.50, '2026-09-01 08:00:00', 'Sensor-01'), 
(37.80, '2026-09-01 08:05:00', 'Sensor-01'), 
(33.90, '2026-09-01 08:10:00', 'Sensor-02');
-- ======================================================================================
INSERT INTO alerta (tipoAlerta, dataHora, msgAlerta, resolvido) VALUES 
('Risco de enxameação', '2026-09-01 08:05:00', 'Pendente', 0), 
('Sensor sem resposta', '2026-09-01 09:00:00', NULL, 0),
('Risco de enxameação', '2026-09-02 07:40:00', 'Pendente', 1);
-- ======================================================================================
INSERT INTO manutencao (dataInspecao, comentario, apicultorResponsavel) VALUES 
('2026-08-15', 'Colmeia com boa produção, sem sinais de estresse', 'Joao Ferreira'), 
('2026-08-20', NULL, 'Maria Souza'), 
('2026-08-25', 'Necessário reforçar ventilação', 'Pedro Lima');
-- ======================================================================================
INSERT INTO producaoMel (quantidadeKg, dataColeta, precoVenda) VALUES 
(25.50, '2026-06-10', 450.00), 
(18.00, '2026-07-15', 300.00), 
(0.00, '2026-08-01', 8000.00);
-- ======================================================================================
INSERT INTO tabelaGlobal (ativoApiario, ativoColmeia, qtdColmeias) VALUES
(1, 1, 12),
(1, 1, 6),
(0, 0, 8);
-- ======================================================================================
--                                         SELECTS
-- ======================================================================================
-- vai calcular o risco de enxameação com base na temperatura
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
-- status legível + tempo (em dias) desde a última manutenção
SELECT
    id,
    CASE
        WHEN funcionando = 1 THEN 'Funcionando'
        ELSE 'Inativo'
    END AS statusSensor,
    ultimaManutencao,
    CASE
        WHEN ultimaManutencao IS NULL THEN 'Nunca revisado'
        ELSE CONCAT(DATEDIFF(CURDATE(), ultimaManutencao), ' dias desde a última manutenção')
    END AS tempoDesdeManutencao
FROM sensor;
 -- ======================================================================================
 -- preço por kg (tratando divisão por zero com round) e classificação da colheita
SELECT
    id,
    quantidadeKg,
    precoVenda,
    CASE
        WHEN quantidadeKg = 0 THEN 0
        ELSE ROUND(precoVenda / quantidadeKg, 2)
    END AS precoPorKg,
    CASE
        WHEN quantidadeKg = 0 THEN 'Sem produção nesta coleta'
        WHEN quantidadeKg < 20 THEN 'Colheita baixa'
        ELSE 'Colheita boa'
    END AS classificacaoColheita
FROM producaoMel;
-- ======================================================================================
-- Para consultar dados pessoais do apicultor
SELECT nome, telefone, email
FROM apicultor
WHERE ativo = 1;
-- ======================================================================================
-- Dados sobre o apiario, ordenados por sua data de criação (do mais velho ao mais novo)
SELECT nome, endereco, dataCriacao
FROM apiario
ORDER BY dataCriacao ASC;
-- ======================================================================================
-- Dados sobre as colmeias, ordenados por sua data de instalação no apiário (do mais novo ao mais velho)
SELECT identificacao, dataInstalacao
FROM colmeia
ORDER BY dataInstalacao DESC;
 -- ======================================================================================
 -- Linhas onde o apiário está ativo e quantas colmeias se encontram presentes
SELECT idGlobal, qtdColmeias
FROM tabelaGlobal
WHERE ativoApiario = 1;
 -- ======================================================================================
-- Analisando inspeções feitas por alguém específico
SELECT dataInspecao, comentario, apicultorResponsavel
FROM manutencao
WHERE apicultorResponsavel LIKE 'Joao%';
 -- ======================================================================================