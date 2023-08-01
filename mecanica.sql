-- Criação do banco de dados
CREATE DATABASE mecanica;
USE mecanica;


-- Criação da tabela de clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(255)
);

-- Criação da tabela de veículos
CREATE TABLE veiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    placa VARCHAR(10) NOT NULL,
    cliente_id INT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Criação da tabela de serviços
CREATE TABLE servicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

-- Criação da tabela de ordens de serviço
CREATE TABLE ordens_servico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    veiculo_id INT,
    FOREIGN KEY (veiculo_id) REFERENCES veiculos(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Criação da tabela de itens de ordem de serviço
CREATE TABLE itens_ordem_servico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ordem_servico_id INT,
    servico_id INT,
    FOREIGN KEY (ordem_servico_id) REFERENCES ordens_servico(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (servico_id) REFERENCES servicos(id)
);

-- Criação da tabela de pagamentos
CREATE TABLE pagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    ordem_servico_id INT,
    FOREIGN KEY (ordem_servico_id) REFERENCES ordens_servico(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Inserção de dados na tabela de clientes
INSERT INTO clientes (nome, telefone, endereco) VALUES
('João Silva', '99999-9999', 'Rua das Flores, 123'),
('Maria Santos', '88888-8888', 'Avenida Brasil, 456'),
('Pedro Oliveira', '77777-7777', 'Praça da Liberdade, 789');

-- Inserção de dados na tabela de veículos
INSERT INTO veiculos (marca, modelo, ano, placa, cliente_id) VALUES
('Fiat', 'Uno', 2010, 'ABC-1234', 1),
('Volkswagen', 'Gol', 2012, 'DEF-5678', 2),
('Chevrolet', 'Onix', 2014, 'GHI-9012', 3);

-- Inserção de dados na tabela de serviços
INSERT INTO servicos (descricao, preco) VALUES
('Troca de óleo', 100.00),
('Alinhamento e balanceamento', 150.00),
('Revisão geral', 300.00);

-- Inserção de dados na tabela de ordens de serviço
INSERT INTO ordens_servico (data, veiculo_id) VALUES
('2023-08-01', 1),
('2023-08-02', 2),
('2023-08-03', 3);

-- Inserção de dados na tabela de itens de ordem de serviço
INSERT INTO itens_ordem_servico (ordem_servico_id, servico_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 1),
(3, 2),
(3, 3);

-- Inserção de dados na tabela de pagamentos
INSERT INTO pagamentos (data, valor, ordem_servico_id) VALUES
('2023-08-01', 250.00, 1),
('2023-08-02', 300.00, 2),
('2023-08-03', 550.00, 3);

-- Recuperações simples com SELECT Statement:
-- Seleciona todos os clientes
SELECT * FROM clientes;

-- Seleciona todos os veículos de uma determinada marca
SELECT * FROM veiculos WHERE marca = 'Fiat';

-- Filtros com WHERE Statement:
-- Seleciona todos os clientes com um determinado telefone
SELECT * FROM clientes WHERE telefone = '99999-9999';

-- Seleciona todos os veículos de um determinado ano
SELECT * FROM veiculos WHERE ano = 2010;

-- Expressões para gerar atributos derivados:
-- Seleciona o nome do cliente e o número de veículos que ele possui
SELECT c.nome, COUNT(v.id) AS num_veiculos
FROM clientes c
LEFT JOIN veiculos v ON c.id = v.cliente_id
GROUP BY c.id;

-- Erdenações dos dados com ORDER BY:
-- Seleciona todos os serviços ordenados pelo preço em ordem crescente
SELECT * FROM servicos ORDER BY preco ASC;

-- Seleciona todos os serviços ordenados pelo preço em ordem decrescente
SELECT * FROM servicos ORDER BY preco DESC;

-- Condições de filtros aos grupos – HAVING Statement:
-- Seleciona o nome do cliente e o número de veículos que ele possui, apenas para clientes com mais de um veículo
SELECT c.nome, COUNT(v.id) AS num_veiculos
FROM clientes c
LEFT JOIN veiculos v ON c.id = v.cliente_id
GROUP BY c.id
HAVING COUNT(v.id) > 1;

-- Junções entre tabelas para fornecer uma perspectiva mais complexa dos dados:
-- Seleciona o nome do cliente, a placa do veículo e a descrição do serviço realizado em cada ordem de serviço
SELECT c.nome, v.placa, s.descricao
FROM ordens_servico os
JOIN veiculos v ON os.veiculo_id = v.id
JOIN clientes c ON v.cliente_id = c.id
JOIN itens_ordem_servico ios ON os.id = ios.ordem_servico_id
JOIN servicos s ON ios.servico_id = s.id;