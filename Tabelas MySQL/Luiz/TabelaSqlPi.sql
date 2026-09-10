CREATE DATABASE TabelaSqlPi;
USE TabelaSqlPi;

----------------------------------------------------------------------------------------


CREATE TABLE apicultor (
id INT PRIMARY KEY AUTO_INCREMENT, 
nome VARCHAR(100) NOT NULL, 
cpf CHAR(11) NOT NULL UNIQUE, 
telefone VARCHAR(20) NOT NULL UNIQUE,
email VARCHAR(120) NOT NULL UNIQUE,
dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
ativo TINYINT DEFAULT 1
);

CREATE TABLE sensor (    
id INT PRIMARY KEY AUTO_INCREMENT,    
modelo CHAR(4) NOT NULL DEFAULT 'LM35',       
dataInstalacao DATETIME,    
ultimaManutencao DATETIME,    
funcionando TINYINT
);

CREATE TABLE leitura_temperatura (    
id INT PRIMARY KEY AUTO_INCREMENT,    
temperatura DECIMAL(5,2) NOT NULL,    
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,    
sensorReferencia VARCHAR(50) 
);

CREATE TABLE alerta (    
id INT PRIMARY KEY AUTO_INCREMENT,    
tipoAlerta VARCHAR(50) NOT NULL,    
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,    
status_alerta VARCHAR(20) DEFAULT 'Pendente', 
resolvido TINYINT DEFAULT 0
);

CREATE TABLE producao_mel (    
id INT PRIMARY KEY AUTO_INCREMENT,   
quantidadeKg DECIMAL(6,2) NOT NULL,    
dataColeta DATETIME DEFAULT CURRENT_TIMESTAMP,    
qualidade VARCHAR(30),    
precoVenda DECIMAL(10,2) NOT NULL
); 

--------------------------------------------------------------------------------------

INSERT INTO apicultor (nome, cpf, telefone, email, dataCadastro, ativo) VALUES
('Ricardo Mendes', '12345678901', '11911112222', 'ricardo.mendes@apiario.com', '2025-01-10', 1), 
('Fernanda Rocha', '23456789012', '21933334444', 'fernanda.rocha@apiario.com', '2025-04-15', 1),
('Lucas Antunes', '34567890123', '31955556666', 'lucas.antunes@apiario.com', '2025-08-20', 0);

INSERT INTO sensor (dataInstalacao, ultimaManutencao, funcionando) VALUES 
('2025-01-12', '2026-05-10', 1), 
('2025-04-20', NULL, 1), 
('2025-08-22', '2026-02-14', 0);

INSERT INTO leitura_temperatura (temperatura, dataHora, sensorReferencia) VALUES 
(35.20, '2026-09-09 09:00:00', 'Sensor-Alfa'), 
(32.10, '2026-09-09 09:15:00', 'Sensor-Alfa'), 
(38.50, '2026-09-09 09:30:00', 'Sensor-Beta');

INSERT INTO alerta (tipoAlerta, dataHora, status_alerta, resolvido) VALUES 
('Temperatura Crítica', '2026-09-09 09:30:00', 'Em Andamento', 0), 
('Bateria Fraca', '2026-09-09 10:00:00', NULL, 0),
('Umidade Alta', '2026-09-08 14:20:00', 'Resolvido', 1);

INSERT INTO producao_mel (quantidadeKg, dataColeta, qualidade, precoVenda) VALUES 
(42.80, '2026-05-20', 'Silvestre', 12.50), 
(31.00, '2026-07-11', 'Eucalipto', 15.00), 
(15.50, '2026-08-30', 'Flor de Laranjeira', 18.00);

-----------------------------------------------------------------------------------------------

-- Consulta de Apicultores Clientes ativos ou não ativos
SELECT    
    nome,    
    CONCAT(nome, ' - ', email, ' - ', telefone) AS contato,    
    CASE ativo
        WHEN 1 THEN 'Ativo'        
        WHEN 0 THEN 'Inativo'        
        ELSE 'Inválido'    
    END AS situacao 
FROM apicultor;

-- Consulta de Sensores
SELECT    
    modelo,        
    CASE        
        WHEN ultimaManutencao IS NULL THEN 'Nunca teve manutenção'
        ELSE CONCAT(DATEDIFF(CURDATE(), ultimaManutencao), ' dias atrás')    
    END AS statusManutencao 
FROM sensor;

-- Consulta de temperatura Fora ou dentro do normal
SELECT    
    sensorReferencia,    
    CONCAT(temperatura, ' ºC ') AS TEMPERATURA,   
    DATE_FORMAT(dataHora, '%d/%m/%Y %H:%i:%s') AS dataHoraFormatada,    
    CASE        
        WHEN temperatura BETWEEN 33 AND 36 THEN 'Normal'        
        WHEN temperatura BETWEEN 37 AND 38 THEN 'Temperatura elevada, precisa de atenção'        
        WHEN temperatura < 32 THEN 'Temperatura abaixo do ideal, precisa de atenção'        
        ELSE 'Fora do padrão'    
    END AS classificacao 
FROM leitura_temperatura;

-- Consulta de calculo da produção
SELECT    
    dataColeta,    
    qualidade,    
    CONCAT(quantidadeKg, ' Kg ') AS quantidade_kg,     
    CONCAT(' R$ ', precoVenda * quantidadeKg) AS receitaEstimada 
FROM producao_mel;

-- Consulta dos alertas de acordo com a datahora
SELECT    
    tipoAlerta,    
    IFNULL(status_alerta, 'Sem status definido') AS status_ALERTA,    
    TIMESTAMPDIFF(HOUR, dataHora, NOW()) AS horasDesdeAlerta,
    TIMESTAMPDIFF(DAY, dataHora, NOW()) AS diasDesdeAlerta 
FROM alerta;