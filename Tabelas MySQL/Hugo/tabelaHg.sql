CREATE DATABASE tabelamel;
USE tabelamel;

CREATE TABLE colmeias (
idcol INT PRIMARY KEY AUTO_INCREMENT,
colmeia VARCHAR (40) NOT NULL,
 temperatura DECIMAL (3,1),
 status_ VARCHAR(15),
 CONSTRAINT chkstatus CHECK(status_ IN('operante', 'inoperante'))
);
drop table colmeias;
INSERT INTO colmeias (colmeia, temperatura, status_) VALUES
('colmeia01', 36, 'operante'),
('colmeia01', 35, 'operante'),
('colmeia01', 28, 'inoperante'),
('colmeia01', 34, 'operante'),
('colmeia01', 23, 'inoperante');

-- mostrar as tabelas que estão inoperantes
SELECT * FROM colmeias WHERE status_ = 'inoperante';

CREATE TABLE cadastro (
idcliente INT PRIMARY KEY AUTO_INCREMENT,
email VARCHAR(90) NOT NULL,
senha VARCHAR(20) NOT NULL,
cep CHAR(8) NOT NULL,
cpf CHAR(11) NOT NULL UNIQUE,
nome VARCHAR(20) NOT NULL,
sobrenome VARCHAR (90),
telefone CHAR(11)
);
INSERT INTO cadastro (email, senha, cep, cpf, nome, sobrenome, telefone) VALUES
('caiocastro@gmail.com', 'caio123456', '01245215','14515478541', 'Caio', 'Castro', '91452254565'),
('rodrigo@gmail.com', 'rod123456', '01245415','14574978541', 'Rodrigo', 'Silva', '91452254741'),
('guilhermes@gmail.com', 'gui123456', '01245789','14515478632', 'Guilherme', 'Ferreira', '91452254565'),
('caetano@gmail.com', 'caetano123456', '01245652','14515485441', 'Fabio', 'Caetano', '91452254333'),
('natalia@gmail.com', 'nart123456', '01245701','66515478501', 'Natalia', 'Santos', '91452254745'),
('natalia@gmail.com', 'nart123456', '01245701','66515478541', 'Natalia', 'Oliveira', '91452254818');

INSERT INTO cadastro (email, senha, cep, cpf, nome, sobrenome, telefone) VALUES
('erick@gmail.com', 'pul123456', '01245002','66515478896', 'Erick', 'Pulgar', '91452254745');