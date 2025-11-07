CREATE DATABASE SneezePharma

USE SneezePharma
GO

CREATE TABLE SituacaoClientes(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Situacao CHAR(1) NOT NULL
);

CREATE TABLE SituacaoMed(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Situacao CHAR(1) NOT NULL
);

CREATE TABLE SituacaoPrincipiosAtivo(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Situacao CHAR(1) NOT NULL
);

CREATE TABLE SituacaoFornecedores(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Situacao CHAR(1) NOT NULL
);

CREATE TABLE CategoriasMed(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Categoria CHAR(1) NOT NULL
);

CREATE TABLE Clientes(
	idCliente INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Nome VARCHAR(50) NOT NULL,
	CPF NUMERIC(11,0) NOT NULL UNIQUE,
	DataNasc DATE NOT NULL,
	DataUltimaCompra DATE,
	DataCadastro DATE NOT NULL,
	Situacao INT NOT NULL
);

CREATE TABLE Telefones(
	idTelefone INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idCliente INT NOT NULL,
	CodPais INT NOT NULL,
	CodArea INT NOT NULL,
	Numero NUMERIC NOT NULL
);

CREATE TABLE ClientesRestritos(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idCliente INT NOT NULL
	--CPF NUMERIC NOT NULL UNIQUE,
);

CREATE TABLE Fornecedores(
	idFornecedor INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	CNPJ NUMERIC(14,0) NOT NULL UNIQUE,
	RazaoSocial VARCHAR(50) NOT NULL,
	Pais VARCHAR(20) NOT NULL,
	DataAbertura DATE NOT NULL,
	Situacao INT NOT NULL,
	UltimoFornecimento DATE,
	DataCadastro DATE NOT NULL
);

CREATE TABLE FornecedoresRestritos(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idFornecedor INT NOT NULL
	--CNPJ NUMERIC NOT NULL UNIQUE,
);

CREATE TABLE Vendas(
	idVenda INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idCliente INT NOT NULL,
	DataVenda DATE NOT NULL,
	ValorTotal DECIMAL(7,2)
);

CREATE TABLE Medicamentos(
	CDB NUMERIC(13,0) NOT NULL PRIMARY KEY,
	ValorVenda DECIMAL(6,2) NOT NULL,
	Nome VARCHAR(40) NOT NULL,
	UltimaVenda DATE,
	DataCadastro DATE NOT NULL,
	Situacao INT NOT NULL,
	Categoria INT NOT NULL
);

CREATE TABLE ItensVendas(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Quantidade INT NOT NULL,
	idVenda INT NOT NULL,
	CDB NUMERIC NOT NULL,
	ValorUnitario DECIMAL(6,2),
	TotalItem AS (CAST(Quantidade * ValorUnitario AS DECIMAL(7,2))) PERSISTED
);

CREATE TABLE Producoes(
	idProducao INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	DataProducao DATE NOT NULL,
	CDB NUMERIC NOT NULL,
	Quantidade INT NOT NULL
);

CREATE TABLE PrincipiosAtivo(
	idPrincipioAt INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	Nome VARCHAR(20) NOT NULL,
	Situacao INT NOT NULL,
	DataUltimaCompra DATE,
	DataCadastro DATE NOT NULL
);

CREATE TABLE ItensProducoes(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idProducao INT NOT NULL,
	idPrincipioAt INT NOT NULL,
	Quantidade INT NOT NULL
);

CREATE TABLE Compras(
	idCompra INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idFornecedor INT NOT NULL,
	DataCompra DATE NOT NULL,
	ValorTotal DECIMAL(7,2)
);

CREATE TABLE ItensCompras(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idCompra INT NOT NULL,
	idPrincipioAt INT NOT NULL,
	Quantidade INT NOT NULL,
	ValorUnitario DECIMAL(5,2) NOT NULL,
	TotalItem AS (CAST(Quantidade * ValorUnitario AS DECIMAL(7,2))) PERSISTED
);

-- Relacionamento entre tabelas
ALTER TABLE Telefones
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)

ALTER TABLE Clientes
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoClientes(id)

ALTER TABLE ClientesRestritos
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)

ALTER TABLE Vendas
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)

ALTER TABLE ItensVendas
ADD FOREIGN KEY (idVenda) REFERENCES Vendas(idVenda),
FOREIGN KEY (CDB) REFERENCES Medicamentos(CDB)

ALTER TABLE Medicamentos
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoMed(id),
FOREIGN KEY (Categoria) REFERENCES CategoriasMed(id)

ALTER TABLE Producoes
ADD FOREIGN KEY (CDB) REFERENCES Medicamentos(CDB)

ALTER TABLE ItensProducoes
ADD FOREIGN KEY (idProducao) REFERENCES Producoes(idProducao),
FOREIGN KEY (idPrincipioAt) REFERENCES PrincipiosAtivo(idPrincipioAt)

ALTER TABLE PrincipiosAtivo
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoPrincipiosAtivo(id)

ALTER TABLE ItensCompras
ADD FOREIGN KEY (idPrincipioAt) REFERENCES PrincipiosAtivo(idPrincipioAt),
FOREIGN KEY (idCompra) REFERENCES Compras(idCompra)

ALTER TABLE Compras
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor)

ALTER TABLE Fornecedores
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoFornecedores(id)