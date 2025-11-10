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
	CPF CHAR(11) NOT NULL UNIQUE,
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
	Numero NVARCHAR(20) NOT NULL
);

CREATE TABLE ClientesRestritos(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idCliente INT NOT NULL UNIQUE
);

CREATE TABLE Fornecedores(
	idFornecedor INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	CNPJ CHAR(14) NOT NULL UNIQUE,
	RazaoSocial VARCHAR(50) NOT NULL,
	Pais VARCHAR(20) NOT NULL,
	DataAbertura DATE NOT NULL,
	Situacao INT NOT NULL,
	UltimoFornecimento DATE,
	DataCadastro DATE NOT NULL
);

CREATE TABLE FornecedoresRestritos(
	id INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	idFornecedor INT NOT NULL UNIQUE
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
	TotalItem AS (CAST(Quantidade * ValorUnitario AS DECIMAL(7,2))) PERSISTED  -- atributo derivado | CAST=converter_Tipo e PERSISTED=armazenar
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
ADD CONSTRAINT Chk_venda_positivo CHECK (ValorVenda > 0)  -- Uma restrição em que a venda deve ser positivo
GO

ALTER TABLE ItensCompras
ADD CONSTRAINT Chk_compra_positivo CHECK (ValorUnitario > 0)  -- Uma restrição em que a compra deve ser positivo
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
ALTER TABLE FornecedoresRestritos
ADD FOREIGN KEY (idFornecedor) REFERENCES Fornecedores(idFornecedor)
GO

--         >>   Criação de Triggers para Impedir o DELETE   <<<
CREATE TRIGGER Trg_ImpedirDelete_SituacaoClientes
ON SituacaoClientes
INSTEAD OF DELETE   -- INSTEAD OF = aciona a trigger antes da operação DELETE 
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_SituacaoMed
ON SituacaoMed
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_SituacaoPrincipiosAtivo
ON SituacaoPrincipiosAtivo
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_SituacaoFornecedores
ON SituacaoFornecedores
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_CategoriasMed
ON CategoriasMed
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Clientes
ON Clientes
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Telefones
ON Telefones
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Fornecedores
ON Fornecedores
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Vendas
ON Vendas
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Medicamentos
ON Medicamentos
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_ItensVendas
ON ItensVendas
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Producoes
ON Producoes
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_PrincipiosAtivo
ON PrincipiosAtivo
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_ItensProducoes
ON ItensProducoes
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_Compras
ON Compras
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

CREATE TRIGGER Trg_ImpedirDelete_ItensCompras
ON ItensCompras
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE não é permitida nesta tabela.', 1;
END;
GO

--         >>   Criação de Triggers para outras funcionalidades   <<< 
CREATE TRIGGER Trg_PreencherValorUnitario
ON ItensVendas
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;
    UPDATE iv
    SET iv.ValorUnitario = m.ValorVenda    -- Aqui ele faz a cópia do valor e atrbui a ValorUnitario
    FROM ItensVendas iv
    JOIN inserted i 
	ON iv.id = i.id
    JOIN Medicamentos m
	ON i.CDB = m.CDB
    WHERE iv.ValorUnitario IS NULL;
END;
GO

CREATE TRIGGER Trg_Limita_ItensPorVenda
ON ItensVendas
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
        FROM ItensVendas iv
        JOIN inserted i ON iv.idVenda = i.idVenda
        GROUP BY iv.idVenda
        HAVING COUNT(iv.idVenda) > 3
    )
    BEGIN
	    ROLLBACK TRANSACTION;
        THROW 51001, 'Uma venda não pode conter mais de 3 itens.', 1;
    END;
END;
GO

CREATE TRIGGER Trg_PreencherValorTotaldaVenda
ON ItensVendas
AFTER INSERT, UPDATE
AS BEGIN
    SET NOCOUNT ON;
    UPDATE v
    SET v.ValorTotal = (SELECT SUM(iv.TotalItem)
        FROM ItensVendas iv
        WHERE iv.idVenda = v.idVenda
    )
    FROM Vendas v
    JOIN (SELECT DISTINCT idVenda
	FROM inserted
    ) 
	AS i ON v.idVenda = i.idVenda;
END;
GO

CREATE TRIGGER Trg_Limita_ItensPorCompra
ON ItensCompras
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
        FROM ItensCompras ic
        JOIN inserted i ON ic.idCompra = i.idCompra
        GROUP BY ic.idCompra
        HAVING COUNT(ic.idCompra) > 3
    )
    BEGIN
	    ROLLBACK TRANSACTION;
        THROW 51001, 'Uma compra não pode conter mais de 3 itens.', 1;
    END;
END;
GO

CREATE TRIGGER Trg_PreencherValorTotaldaCompra
ON ItensCompras
AFTER INSERT, UPDATE
AS BEGIN
    SET NOCOUNT ON;
    UPDATE c
    SET c.ValorTotal = (SELECT SUM(ic.TotalItem)
        FROM ItensCompras ic
        WHERE ic.idCompra = c.idCompra
    )
    FROM Compras c
    JOIN (SELECT DISTINCT idCompra
	FROM inserted
    ) 
	AS i ON c.idCompra = i.idCompra;
END;
GO

/*================VERIFICAÇÕES PARA O CLIENTE===================*/
CREATE TRIGGER Trg_Cliente_RestritoInativoMaiorIdade
ON Vendas
INSTEAD OF INSERT
AS BEGIN
    SET NOCOUNT ON;

------------Verifica se o cliente está na lista de restritos

    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN ClientesRestritos r ON r.idCliente = i.idCliente
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50020, 'Cliente restrito — venda não permitida.', 1;
    END;

----------------------Verifica se o cliente está inativo

    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Clientes c ON c.idCliente = i.idCliente
        JOIN SituacaoClientes s ON c.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50021, 'Cliente inativo — não é possível registrar venda.', 1;
    END;

-----------------Verifica se o cliente tem menos de 18 anos

    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Clientes c ON i.idCliente = c.idCliente
        WHERE DATEDIFF(YEAR, c.DataNasc, GETDATE()) -           -- pega a diferença entre anos, e subtrai 1 caso não fez aniversário ainda
            CASE 
                WHEN MONTH(c.DataNasc) > MONTH(GETDATE())    -- se o mês de nascimento for maior que o mês atual
                     OR (MONTH(c.DataNasc) = MONTH(GETDATE()) AND DAY(c.DataNasc) > DAY(GETDATE()))  -- ou serem iguais, mas o dia for maior
                THEN 1    -- não fez aniversário ainda, portanto subtrai 1
                ELSE 0    -- senão, subtrai por 0
            END < 18
    )
    BEGIN  
        ROLLBACK TRANSACTION;  -- se entrar no if por ser menor de idade, ele faz a operação de cancelar saí da trigger
        THROW 51002, 'A venda não pode ser feita para cliente de menor de idade.', 1;
    END
    -- Se não cair dentro do if, então todos os clientes são maiores de idade, insere normalmente
    INSERT INTO Vendas (idCliente, DataVenda)
    SELECT idCliente, DataVenda
    FROM inserted;
END;
GO

/*=====================================VERIFICAÇÕES DO FORNECEDOR===============================*/
CREATE TRIGGER Trg_Fornecedor_RestritoInativo_LimiteAbertura
ON Compras
INSTEAD OF INSERT
AS BEGIN
---------------Verifica se o fornecedor está bloqueado

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN FornecedoresRestritos r ON r.idFornecedor = i.idFornecedor
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Fornecedor bloqueado — compra não permitida.', 1;
    END;
------------------Verifica se o fornecedor está inativo

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Fornecedores f ON f.idFornecedor = i.idFornecedor
        JOIN SituacaoFornecedores s ON f.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50023, 'Fornecedor inativo — compra não permitida.', 1;
    END;

---------------Verifica se o fornecedor tem menos de 2 anos de abertura

    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Fornecedores f ON i.idFornecedor = f.idFornecedor
        WHERE DATEDIFF(YEAR, f.DataAbertura, GETDATE()) -
            CASE 
                WHEN MONTH(f.DataAbertura) > MONTH(GETDATE())
                     OR (MONTH(f.DataAbertura) = MONTH(GETDATE()) AND DAY(f.DataAbertura) > DAY(GETDATE()))
                THEN 1
                ELSE 0
            END < 2
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51002, 'Fornecedor com menos de 2 anos de abertura — compra não permitida.', 1;
    END;

    INSERT INTO Compras (idFornecedor, DataCompra, ValorTotal)
    SELECT idFornecedor, DataCompra, ValorTotal
    FROM inserted;
END;
GO

/* ================================ATUALIZAR DATA DA ULTIMA COMPRA DO CLIENTE======================= */

CREATE TRIGGER Trg_AtualizaUltimaCompra
ON Vendas
AFTER INSERT
AS BEGIN
    UPDATE Clientes
    SET DataUltimaCompra = i.DataVenda
    FROM Clientes c
    JOIN inserted i ON c.idCliente = i.idCliente;
END;
GO

/* ================================ATUALIZAR ULTIMO FORNECIMENTO DO FORNECEDOR======================= */

CREATE TRIGGER Trg_AtualizaUltimoFornecimento
ON Compras
AFTER INSERT
AS BEGIN
    UPDATE Fornecedores
    SET UltimoFornecimento = i.DataCompra
    FROM Fornecedores f
    JOIN inserted i ON f.idFornecedor = i.idFornecedor;
END;
GO

/* ================================PRINCIPIO ATIVO "INATIVO" EM COMPRA======================= */

CREATE TRIGGER Trg_PrincipioInativo_Compra
ON ItensCompras
INSTEAD OF INSERT
AS BEGIN
    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN PrincipiosAtivo p ON p.idPrincipioAt = i.idPrincipioAt
        JOIN SituacaoPrincipiosAtivo s ON p.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50012, 'O Princípio ativo esta como inativo — não pode ser comprado.', 1;
    END;

    INSERT INTO ItensCompras (idCompra, idPrincipioAt, Quantidade, ValorUnitario)
    SELECT idCompra, idPrincipioAt, Quantidade, ValorUnitario
    FROM inserted;
END;
GO

/* ================================PRINCIPIO ATIVO "INATIVO" EM PRODUÇÃO======================= */

CREATE TRIGGER Trg_PrincipioInativo_Producao
ON ItensProducoes
INSTEAD OF INSERT
AS BEGIN
    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN PrincipiosAtivo p ON p.idPrincipioAt = i.idPrincipioAt
        JOIN SituacaoPrincipiosAtivo s ON p.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50013, 'Princípio ativo esta como inativo — não pode ser usado na produção.', 1;
    END;

    INSERT INTO ItensProducoes (idProducao, idPrincipioAt, Quantidade)
    SELECT idProducao, idPrincipioAt, Quantidade
    FROM inserted;
END;
GO

/* ================================MEDICAMENTO "INATIVO" EM VENDA======================= */

CREATE TRIGGER Trg_Medicamento_Inativo_Venda
ON ItensVendas
INSTEAD OF INSERT
AS BEGIN
    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Medicamentos m ON m.CDB = i.CDB
        JOIN SituacaoMed s ON m.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50014, 'Medicamento inativo — não pode ser vendido.', 1;
    END;

    INSERT INTO ItensVendas (Quantidade, idVenda, CDB, ValorUnitario)
    SELECT Quantidade, idVenda, CDB, ValorUnitario
    FROM inserted;
END;
GO

/* ================================MEDICAMENTO "INATIVO" EM PRODUÇÃO======================= */

CREATE TRIGGER Trg_Medicamento_Inativo_Producao
ON Producoes
INSTEAD OF INSERT
AS BEGIN
    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Medicamentos m ON m.CDB = i.CDB
        JOIN SituacaoMed s ON m.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50015, 'Medicamento inativo — não pode ser produzido.', 1;
    END;

    INSERT INTO Producoes (DataProducao, CDB, Quantidade)
    SELECT DataProducao, CDB, Quantidade
    FROM inserted;
END;
GO

/* ================================ATUALIZA ULTIMA VENDA DO MEDICAMENTO======================= */

CREATE OR ALTER TRIGGER Trg_Atualiza_UltimaVenda_Medicamento
ON ItensVendas
AFTER INSERT
AS BEGIN
    UPDATE m
    SET m.UltimaVenda = v.DataVenda
    FROM Medicamentos m
    JOIN inserted i ON m.CDB = i.CDB
    JOIN Vendas v ON v.idVenda = i.idVenda;
END;
GO

/* ================================ATUALIZA ULTIMA COMPRA DO PRINCIPIO ATIVO======================= */

CREATE OR ALTER TRIGGER Trg_Atualiza_UltimaCompra_Principio
ON ItensCompras
AFTER INSERT
AS BEGIN
    UPDATE p
    SET p.DataUltimaCompra = c.DataCompra
    FROM PrincipiosAtivo p
    JOIN inserted i ON p.idPrincipioAt = i.idPrincipioAt
    JOIN Compras c ON c.idCompra = i.idCompra;
END;
GO

























































-------------------      <<<    Uso de JOINS para concatenar dados entre tabelas    <<<      -------------------

--        <<   Informações completas de Cliente   >>
SELECT c.idCliente, c.Nome AS "Nome do Cliente", c.CPF, c.DataNasc, c.DataCadastro, c.DataUltimaCompra,
		t.CodPais, t.CodArea, t.Numero, sc.Situacao
FROM Clientes c
JOIN SituacaoClientes sc
ON c.Situacao = sc.id
JOIN Telefones t
ON c.idCliente = t.idCliente

--        <<   Informações completas de Clientes Restritos   >>
SELECT cr.id, c.Nome, c.CPF
FROM ClientesRestritos cr
JOIN Clientes c
ON cr.idCliente = c.idCliente

--        <<   Informações completas de Fornecedores   >>
SELECT f.idFornecedor, f.RazaoSocial, f.CNPJ, f.Pais, f.DataCadastro, f.DataAbertura, f.UltimoFornecimento,
		sf.Situacao
FROM Fornecedores f
JOIN SituacaoFornecedores sf
ON f.Situacao = sf.id

--        <<   Informações completas de Fornecedores Restritos   >>
SELECT fr.id, f.RazaoSocial, f.CNPJ
FROM FornecedoresRestritos fr
JOIN Fornecedores f
ON fr.idFornecedor = f.idFornecedor

--        <<   Informações completas de Vendas   >>
SELECT v.idVenda, c.Nome AS "Nome do Cliente", c.CPF, iv.Quantidade, iv.ValorUnitario, iv.TotalItem, v.ValorTotal, v.DataVenda,
		m.Nome, m.Categoria
FROM Vendas v
JOIN Clientes c
ON v.idCliente = c.idCliente
JOIN ItensVendas iv
ON v.idVenda = iv.idVenda
JOIN Medicamentos m
ON iv.CDB = m.CDB

-------------------      <<<    Relatórios    <<<      -------------------

--        <<   Relatório de vendas por período    >>
SELECT v.idVenda, c.Nome AS "Nome do Cliente", c.CPF, iv.Quantidade, iv.ValorUnitario, iv.TotalItem, v.ValorTotal, v.DataVenda,
		m.Nome, m.Categoria
FROM Vendas v
JOIN Clientes c
ON v.idCliente = c.idCliente
JOIN ItensVendas iv
ON v.idVenda = iv.idVenda
JOIN Medicamentos m
ON iv.CDB = m.CDB
WHERE v.DataVenda BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY v.DataVenda, v.idVenda;

--        <<   Relatório de medicamentos mais vendidos    >>
SELECT m.CDB, m.Nome AS "Medicamento", SUM(iv.Quantidade) AS "Total Unidades Vendidas"
FROM ItensVendas iv
JOIN Medicamentos m 
ON iv.CDB = m.CDB
GROUP BY m.CDB, m.Nome
ORDER BY "Total Unidades Vendidas" DESC;   -- Ordenar do mais vendido para o menos vendido

--        <<   Relatório de compras por fornecedor   >>
SELECT f.idFornecedor, f.RazaoSocial, SUM(ic.Quantidade) AS "Total Unidades Compradas"
FROM ItensCompras ic
JOIN Compras c
ON ic.idCompra = c.idCompra
JOIN Fornecedores f
ON c.idFornecedor = f.idFornecedor
GROUP BY f.idFornecedor, f.RazaoSocial
ORDER BY "Total Unidades Compradas" DESC;