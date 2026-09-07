CREATE DATABASE abelhas;

USE abelhas;

CREATE TABLE usuario (
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR (120) NOT NULL,
email VARCHAR (80) NOT NULL UNIQUE,
senha VARCHAR (12) NOT NULL,
tipoUsuario VARCHAR (20) NOT NULL,
CONSTRAINT chktipoUsuario CHECK (tipoUsuario IN ('Produtor', 'Administrador'))
);

INSERT INTO usuario (nome, email, senha, tipoUsuario) VALUES
('Carlos Almeida', 'carlos@email.com', '123456', 'Produtor'),
('Ana Souza', 'ana@email.com', '654321', 'Produtor');

CREATE TABLE colmeia (
    idColmeia INT PRIMARY KEY AUTO_INCREMENT,
    nomeColmeia VARCHAR(50) NOT NULL,
    localizacao VARCHAR(150),
    especieAbelha VARCHAR(100),
    statusColmeia VARCHAR(40),
    dataCadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    idUsuario INT,
    CONSTRAINT chkStatusColmeia CHECK (statusColmeia IN ('Ativa', 'Inativa', 'Em observação'))
);

INSERT INTO colmeia (nomeColmeia, localizacao, especieAbelha, statusColmeia, idUsuario) VALUES
('Colmeia 01', 'Setor Norte', 'Apis mellifera scutellata', 'Ativa', 1),
('Colmeia 02', 'Setor Sul', 'Apis mellifera scutellata', 'Em observação', 2);


CREATE TABLE leitura_temperatura (
    idLeitura INT PRIMARY KEY AUTO_INCREMENT,
    temperaturaInterna DECIMAL(4,2) NOT NULL,
    temperaturaExterna DECIMAL(4,2),
    dataHoraLeitura DATETIME DEFAULT CURRENT_TIMESTAMP,
    idColmeia INT
);

INSERT INTO leitura_temperatura (temperaturaInterna, temperaturaExterna, idColmeia) VALUES
(34.60, 28.20, 1),
(37.40, 29.10, 2);

CREATE TABLE alerta (
    idAlerta INT PRIMARY KEY AUTO_INCREMENT,
    tipoAlerta VARCHAR(30),
    mensagem VARCHAR(255),
    temperaturaRegistrada DECIMAL(4,2),
    dataHoraAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    statusAlerta VARCHAR(20),
    idColmeia INT
);

INSERT INTO alerta (tipoAlerta, mensagem, temperaturaRegistrada, statusAlerta, idColmeia) VALUES
('Temperatura estável','A colmeia apresenta temperatura dentro do padrão.',34.60,'Verificado',1),
('Alteração térmica','Alteração térmica detectada. Recomenda-se realizar uma inspeção.',37.40,'Pendente',2);

SELECT 
    idColmeia AS colmeia,
    temperaturaInterna AS temperatura_interna,
    temperaturaExterna AS temperatura_externa,
    dataHoraLeitura AS momento_da_leitura
FROM leitura_temperatura
WHERE temperaturaInterna >= 37
ORDER BY temperaturaInterna DESC;

SELECT
    idColmeia AS colmeia,
    tipoAlerta AS tipo_do_alerta,
    mensagem,
    temperaturaRegistrada AS temperatura,
    dataHoraAlerta AS momento_do_alerta
FROM alerta
WHERE statusAlerta = 'Pendente'
ORDER BY dataHoraAlerta DESC;

