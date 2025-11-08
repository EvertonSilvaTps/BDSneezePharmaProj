--         <<   Criar Banco de Dados   >>
CREATE DATABASE SneezePharma;
GO

USE SneezePharma
GO

--         <<   Criação das Tabelas   >>
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
	CPF CHAR(11) NOT NULL UNIQUE,  -- Alterado para char
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
	Numero NUMERIC(15,0) NOT NULL
);

CREATE TABLE ClientesRestritos(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idCliente INT NOT NULL UNIQUE     -- Adicionado o UNIQUE
);

CREATE TABLE Fornecedores(
	idFornecedor INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	CNPJ CHAR(14) NOT NULL UNIQUE,    -- Alterado para char
	RazaoSocial VARCHAR(50) NOT NULL,
	Pais VARCHAR(20) NOT NULL,
	DataAbertura DATE NOT NULL,
	Situacao INT NOT NULL,
	UltimoFornecimento DATE,
	DataCadastro DATE NOT NULL
);

CREATE TABLE FornecedoresRestritos(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idFornecedor INT NOT NULL UNIQUE     -- Adicionado o UNIQUE
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
	CDB NUMERIC(13,0) NOT NULL,
	ValorUnitario DECIMAL(6,2),
	TotalItem AS (CAST(Quantidade * ValorUnitario AS DECIMAL(7,2))) PERSISTED
);

CREATE TABLE Producoes(
	idProducao INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	DataProducao DATE NOT NULL,
	CDB NUMERIC(13,0) NOT NULL,
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
GO

--         >>   Alterando Tabelas (Adicionado Constraints)   <<
ALTER TABLE Medicamentos
ADD CONSTRAINT Chk_venda_positivo CHECK (ValorVenda > 0)
GO

ALTER TABLE ItensCompras
ADD CONSTRAINT Chk_compra_positivo CHECK (ValorUnitario > 0)
GO

--         >>   Criação dos Relacionamento entre tabelas   <<
ALTER TABLE Telefones
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)
GO
ALTER TABLE Clientes
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoClientes(id)
GO
ALTER TABLE ClientesRestritos
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)
GO
ALTER TABLE Vendas
ADD FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)
GO
ALTER TABLE ItensVendas
ADD FOREIGN KEY (idVenda) REFERENCES Vendas(idVenda),
FOREIGN KEY (CDB) REFERENCES Medicamentos(CDB)
GO
ALTER TABLE Medicamentos
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoMed(id),
FOREIGN KEY (Categoria) REFERENCES CategoriasMed(id)
GO
ALTER TABLE Producoes
ADD FOREIGN KEY (CDB) REFERENCES Medicamentos(CDB)
GO
ALTER TABLE ItensProducoes
ADD FOREIGN KEY (idProducao) REFERENCES Producoes(idProducao),
FOREIGN KEY (idPrincipioAt) REFERENCES PrincipiosAtivo(idPrincipioAt)
GO
ALTER TABLE PrincipiosAtivo
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoPrincipiosAtivo(id)
GO
ALTER TABLE ItensCompras
ADD FOREIGN KEY (idPrincipioAt) REFERENCES PrincipiosAtivo(idPrincipioAt),
FOREIGN KEY (idCompra) REFERENCES Compras(idCompra)
GO
ALTER TABLE Compras
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor)
GO
ALTER TABLE Fornecedores
ADD FOREIGN KEY (Situacao) REFERENCES SituacaoFornecedores(id)
GO

--         >>   Uso de Trigger para Impedir o DELETE   <<<
CREATE TRIGGER Trg_ImpedirDelete_SituacaoClientes
ON SituacaoClientes
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_SituacaoMed
ON SituacaoMed
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_SituacaoPrincipiosAtivo
ON SituacaoPrincipiosAtivo
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_SituacaoFornecedores
ON SituacaoFornecedores
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_CategoriasMed
ON CategoriasMed
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Clientes
ON Clientes
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Telefones
ON Telefones
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Fornecedores
ON Fornecedores
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Vendas
ON Vendas
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Medicamentos
ON Medicamentos
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_ItensVendas
ON ItensVendas
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Producoes
ON Producoes
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_PrincipiosAtivo
ON PrincipiosAtivo
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_ItensProducoes
ON ItensProducoes
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Compras
ON Compras
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_ItensCompras
ON ItensCompras
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO
