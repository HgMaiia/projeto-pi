create database colmeias;
use colmeias;

 -- ===========================================================================================
create table apicultor(
id int primary key auto_increment,
nome varchar(80) not null,
cpf char(11),
telefone varchar(20),
email varchar(150),
dataCadastro datetime,
ativo tinyint default 1
);
insert into apicultor (nome, cpf, telefone, email, dataCadastro, ativo) values 
    ('João Silva', '12345678901', '11987654321', 'joao.silva@email.com', NOW(), 1),
    ('Maria Santos', '98765432100', '21976543210', 'maria.santos@email.com', NOW(), 1),
    ('Carlos Oliveira', '45678912304', '31965432109', 'carlos.oliveira@email.com', NOW(), 0);
-- =============================================================================================

create table apiario (    
id int primary key auto_increment,    
nome  varchar(100) not null,    
endereco  varchar(150) not null, 
dataCriacao datetime   
);
insert into apiario (nome, endereco, dataCriacao) values 
    ('Apiário Doce Mel', 'Rodovia BR-116, Km 45, Sítio Primavera, São Paulo - SP', NOW()),
    ('Apiário Sol Nascente', 'Estrada das Flores, nº 120, Bairro Rural, Curitiba - PR', NOW()),
    ('Apiário Vale das Abelhas', 'Avenida Central, nº 850, Fazenda Santa Rita, Belo Horizonte - MG', NOW());
-- ==============================================================================================

create table colmeia (    
id int primary key auto_increment,
identificacao varchar(100) not null, 
dataInstalacao datetime
);
insert into colmeia (identificacao, dataInstalacao) values 
    ('COL-001 - Caixilho Langstroth Alpha', NOW()),
    ('COL-002 - Caixilho Langstroth Beta', NOW()),
    ('COL-003 - Núcleo de Fecundação Gamma', NOW());
-- ===============================================================================================

create table sensor (    
id int primary key auto_increment,   
modelo char(4) not null default 'LM35',       
dataInstalacao datetime,    
ultimaManutencao datetime,    
funcionando tinyint default 1
);
insert into sensor (dataInstalacao, ultimaManutencao, funcionando) values 
    (NOW(), NOW(), 1),
    (NOW(), NOW(), 1),
    (NOW(), NOW(), 0);
-- ==============================================================================
create table leitura_temperatura (    
id int primary key auto_increment,  
temperatura decimal(5,2) not null,    
dataHora datetime default current_timestamp,    
sensorReferencia varchar(50) 
);
insert into leitura_temperatura (temperatura, sensorReferencia) values 
    (35.50, 'Sensor - Colmeia 01'),
    (34.80, 'Sensor - Colmeia 01'),
    (36.20, 'Sensor - Colmeia 02');
-- ================================================================================
create table alerta (    
id int primary key auto_increment,
tipoAlerta varchar(50) not null,    
dataHora datetime default current_timestamp,  
status_alerta varchar(20) default 'Pendente', 
resolvido tinyint default 0
);
insert into alerta (tipoAlerta, status_alerta, resolvido) values 
    ('Temperatura Elevada', 'Pendente', 0),
    ('Temperatura Baixa', 'Em Analise', 0),
    ('Queda de Sensor', 'Resolvido', 1);
-- ================================================================================
create table inspecao (
id int primary key auto_increment,
dataInspecao date,
observacao varchar(200),
apicultorResponsavel varchar(100)
); 
insert into inspecao (dataInspecao, observacao, apicultorResponsavel) values 
    ('2026-09-01', 'Revisão de rotina realizada, colmeia saudável', 'João Silva'),
    ('2026-09-05', 'Troca de cera e verificação da postura da rainha', 'Maria Santos'),
    ('2026-09-08', 'Identificado início de enxameação, necessária intervenção', 'Carlos Oliveira');
-- ===================================================================================
create table producao_mel (    
id int primary key auto_increment,
quantidadeKg decimal(6,2) not null,    
dataColeta datetime default current_timestamp,    
qualidade varchar(30),    
precoVenda decimal(10,2) not null
); 
insert into producao_mel (quantidadeKg, qualidade, precoVenda) values 
    (15.50, 'Extra Floração Silvestre', 450.00),
    (22.30, 'Premium Eucalipto', 620.50),
    (18.00, 'Padrão Silvestre', 480.00);
-- =====================================================================================
create table historico (
id_historico int primary key auto_increment,
ativo_apiario tinyint default 0,
ativo_colmeia tinyint default 0,
qntColmeias int not null
);
insert into historico (ativo_apiario, ativo_colmeia, qntColmeias) values 
    (1, 1, 12),
    (1, 0, 8),
    (0, 0, 0);
-- =====================================================================================
-- Principais selects: 
-- APICULTOR: Lista os apicultores ativos cadastrados no sistema
select id, nome, email, telefone, dataCadastro from apicultor where ativo = true;

-- APIÁRIO: Lista todos os apiários cadastrados e suas localizações
select id, nome, endereco, dataCriacao from apiario;

-- COLMEIA: Traz a identificação e a data de instalação das colmeias
select id, identificacao, dataInstalacao from colmeia;

-- SENSOR: Exibe os sensores e seu status de funcionamento
select id, modelo, dataInstalacao, ultimaManutencao, funcionando from sensor;

-- LEITURA_TEMPERATURA: Consulta as últimas leituras de temperatura registradas
select id, temperatura, dataHora, sensorReferencia from leitura_temperatura order by dataHora desc;

-- ALERTA: Filtra os alertas que ainda estão pendentes de solução
select id, tipoAlerta, dataHora, status_alerta from alerta where resolvido = 0;

-- INSPEÇÃO: Lista as inspeções mais recentes com observações e responsável
select id, dataInspecao, apicultorResponsavel, observacao from inspecao order by dataInspecao desc;

-- PRODUÇÃO_MEL: Exibe a quantidade produzida, qualidade e valor arrecadado
select id, quantidadeKg, qualidade, precoVenda, dataColeta from producao_mel;

-- HISTÓRICO: Exibe os registros de quantidade de colmeias e status do sistema
select id_historico, ativo_apiario, ativo_colmeia, qntColmeias from historico;
