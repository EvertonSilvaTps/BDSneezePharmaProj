-------------------------   >>>   Criar Banco de Dados   <<<   -------------------------
CREATE DATABASE SneezePharma;
GO

USE SneezePharma
GO

-------------------------   >>>   Criar Tabelas   <<<   -------------------------
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
	DataVenda DATE NOT NULL DEFAULT (GETDATE()),
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
	DataCompra DATE NOT NULL DEFAULT (GETDATE()),
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

-------------------------   >>>   Alterando Tabelas (Adicionado Constraints)   <<<   -------------------------     ADICIONADO CONSTRAINTs
ALTER TABLE Medicamentos
ADD CONSTRAINT Chk_venda_positivo CHECK (ValorVenda > 0)  -- Restrição em que a venda deve ser positivo
GO

ALTER TABLE ItensCompras
ADD CONSTRAINT Chk_compra_positivo CHECK (ValorUnitario > 0),  -- Restrição em que a compra deve ser positivo
CONSTRAINT Chk_ItensCompras_qtd_positivo CHECK (Quantidade > 0)  -- Restrição em que a qtdd deve ser positivo
GO

ALTER TABLE ItensVendas
ADD CONSTRAINT Chk_ItensVendas_qtd_positivo CHECK (Quantidade > 0)  -- Restrição em que a qtdd deve ser positivo
GO

ALTER TABLE ItensProducoes
ADD CONSTRAINT Chk_ItensProducoes_qtd_positivo CHECK (Quantidade > 0)  -- Restrição em que a qtdd deve ser positivo
GO

-------------------------   >>>   Relacionamento entre tabelas   <<<   -------------------------
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

-------------------------   >>>   PROCEDURES   <<<   -------------------------

--------   >>>   Procedure ItensVendas  <<<   --------     *Verifica se existe o idVenda e CDB
CREATE OR ALTER PROCEDURE sp_ItensVendas
@idVenda INT,
@CDB NUMERIC(13,0),
@Quantidade INT
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRY   -- (estrutura: TRY/CATCH)   | TRY > faz a tentativa de inserção
        BEGIN TRAN;   -- (estrutura: BEGIN TRAN / COMMIT TRAN / ROLLBACK TRAN)    | BEGIN TRAN > o bloco precisa funcionar todas juntas ou nenhuma.

                -- Valida se a venda existe
        IF NOT EXISTS (SELECT 1 FROM Vendas WHERE idVenda = @idVenda)
            THROW 50001, 'Venda nao encontrada.', 1;

                -- Valida se o CDB existe
        IF NOT EXISTS (SELECT 1 FROM Medicamentos WHERE CDB = @CDB)
            THROW 50001, 'CDB nao encontrada.', 1;

        INSERT INTO ItensVendas (idVenda, CDB, Quantidade)   -- faz a inserção
        VALUES (@idVenda, @CDB, @Quantidade);

        COMMIT TRAN;   -- se ela não caiu dentro do if então ela confirma o commit
    END TRY

    BEGIN CATCH   -- CATCH > o que fazer se der erro
        ROLLBACK TRAN;   -- TRAN = Abreviação de TRANSACTIONfaz
        THROW;
    END CATCH
END;
GO

--------   >>>   Procedure Vendas  <<<   --------
CREATE OR ALTER PROCEDURE sp_CadastrarVenda
@idCliente INT,
@CDB NUMERIC(13,0),
@Quantidade INT,
@CDB2 NUMERIC(13,0) = NULL,
@Quantidade2 INT = NULL,
@CDB3 NUMERIC(13,0) = NULL,
@Quantidade3 INT = NULL
AS BEGIN
    SET NOCOUNT ON;
    DECLARE @idVenda INT;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Clientes WHERE idCliente = @idCliente)
            THROW 50001, 'Cliente inexistente.', 1;

        INSERT INTO Vendas (DataVenda, idCliente)
        VALUES (GETDATE(), @idCliente);

        SET @idVenda = SCOPE_IDENTITY();

        EXEC sp_ItensVendas @idVenda, @CDB, @Quantidade;

        -- opcionais
        IF @CDB2 IS NOT NULL AND @Quantidade2 IS NOT NULL
            EXEC sp_ItensVendas @idVenda, @CDB2, @Quantidade2;

        IF @CDB3 IS NOT NULL AND @Quantidade3 IS NOT NULL
            EXEC sp_ItensVendas @idVenda, @CDB3, @Quantidade3;

        COMMIT TRAN;

        SELECT @idVenda AS idVenda;   --  retorna o id da venda que foi gerado para quem chamou a procedure
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

--------   >>>   Procedure ItensCompras  <<<   --------
CREATE OR ALTER PROCEDURE sp_ItensCompras
@idCompra INT,
@idPrincipioAt INT,
@Quantidade INT,
@ValorUnitario DECIMAL(5,2)
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

                -- Valida se a compra existe
        IF NOT EXISTS (SELECT 1 FROM Compras WHERE idCompra = @idCompra)
            THROW 50001, 'Compra nao encontrada.', 1;

                -- Valida se o Principio Ativo existe
        IF NOT EXISTS (SELECT 1 FROM PrincipiosAtivo WHERE idPrincipioAt = @idPrincipioAt)
            THROW 50001, 'Principio Ativo nao encontrado.', 1;

        INSERT INTO ItensCompras (idCompra, idPrincipioAt, Quantidade, ValorUnitario)
        VALUES (@idCompra, @idPrincipioAt, @Quantidade, @ValorUnitario);

        COMMIT TRAN;
    END TRY

    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

--------   >>>   Procedure Compras  <<<   --------
CREATE OR ALTER PROCEDURE sp_CadastrarCompra
@idFornecedor INT,
@idPrincipioAt INT,
@Quantidade INT,
@ValorUnitario DECIMAL(5,2),
@idPrincipioAt2 INT = NULL,
@Quantidade2 INT = NULL,
@ValorUnitario2 DECIMAL(5,2) = NULL,
@idPrincipioAt3 INT = NULL,
@Quantidade3 INT = NULL,
@ValorUnitario3 DECIMAL(5,2) = NULL
AS BEGIN
    SET NOCOUNT ON;
    DECLARE @idCompra INT;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Fornecedores WHERE idFornecedor = @idFornecedor)
            THROW 50001, 'Fornecedor inexistente.', 1;

        INSERT INTO Compras (DataCompra, idFornecedor)
        VALUES (GETDATE(), @idFornecedor);

        SET @idCompra = SCOPE_IDENTITY();

        EXEC sp_ItensCompras @idCompra, @idPrincipioAt, @Quantidade, @ValorUnitario;

        -- opcionais
        IF @idPrincipioAt2 IS NOT NULL AND @Quantidade2 IS NOT NULL AND @ValorUnitario2 IS NOT NULL
            EXEC sp_ItensCompras @idCompra, @idPrincipioAt2, @Quantidade2, @ValorUnitario2;

        IF @idPrincipioAt3 IS NOT NULL AND @Quantidade3 IS NOT NULL AND @ValorUnitario3 IS NOT NULL
            EXEC sp_ItensCompras @idCompra, @idPrincipioAt3, @Quantidade3, @ValorUnitario3;

        COMMIT TRAN;
    END TRY

    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

-------------------------   >>>   TRIGGGER   <<<   -------------------------

--------   >>>   Triggers Impedir o DELETE   <<<   --------

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_SituacaoClientes
ON SituacaoClientes
INSTEAD OF DELETE   -- INSTEAD OF = aciona a trigger antes da operação DELETE 
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_SituacaoMed
ON SituacaoMed
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_SituacaoPrincipiosAtivo
ON SituacaoPrincipiosAtivo
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_SituacaoFornecedores
ON SituacaoFornecedores
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_CategoriasMed
ON CategoriasMed
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_Clientes
ON Clientes
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_Telefones
ON Telefones
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_Fornecedores
ON Fornecedores
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_Vendas
ON Vendas
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_Medicamentos
ON Medicamentos
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_ItensVendas
ON ItensVendas
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_Producoes
ON Producoes
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_PrincipiosAtivo
ON PrincipiosAtivo
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_ItensProducoes
ON ItensProducoes
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_Compras
ON Compras
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

CREATE OR ALTER TRIGGER Trg_ImpedirDelete_ItensCompras
ON ItensCompras
INSTEAD OF DELETE
AS BEGIN
	SET NOCOUNT ON;
	THROW 51000, 'DELETE nao e permitida nesta tabela.', 1;
END;
GO

--------   >>>   Trigger Preencher ValorUnitario   <<<   --------
CREATE OR ALTER TRIGGER Trg_PreencherValorUnitario
ON ItensVendas
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;
    UPDATE iv
    SET iv.ValorUnitario = m.ValorVenda    -- faz a cópia do valor e atrbui a ValorUnitario
    FROM ItensVendas iv
    JOIN inserted i 
	ON iv.id = i.id
    JOIN Medicamentos m
	ON i.CDB = m.CDB
    WHERE iv.ValorUnitario IS NULL;
END;
GO

--------   >>>   Trigger Limita ItensPorVenda   <<<   --------
CREATE OR ALTER TRIGGER Trg_Limita_ItensPorVenda
ON ItensVendas
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
        FROM ItensVendas iv
        JOIN inserted i ON iv.idVenda = i.idVenda
        GROUP BY iv.idVenda
        HAVING COUNT(*) > 3
    )
    BEGIN
	    ROLLBACK TRANSACTION;
        THROW 51001, 'Uma venda nao pode conter mais de 3 itens.', 1;
    END;
END;
GO

--------   >>>   Trigger Preencher ValorTotaldaVenda   <<<   --------
CREATE OR ALTER TRIGGER Trg_PreencherValorTotaldaVenda
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

--------   >>>   Trigger Limita ItensPorCompra   <<<   --------
CREATE OR ALTER TRIGGER Trg_Limita_ItensPorCompra
ON ItensCompras
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
        FROM ItensCompras ic
        JOIN inserted i ON ic.idCompra = i.idCompra
        GROUP BY ic.idCompra
        HAVING COUNT(*) > 3
    )
    BEGIN
	    ROLLBACK TRANSACTION;
        THROW 51001, 'Uma compra nao pode conter mais de 3 itens.', 1;
    END;
END;
GO

--------   >>>   Trigger Preencher ValorTotaldaCompra   <<<   --------
CREATE OR ALTER TRIGGER Trg_PreencherValorTotaldaCompra
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

--------   >>>   Trigger VERIFICAÇÕES PARA O CLIENTE   <<<   --------          ALTERADO PARA >  AFTER INSERT, para que o Procedure funcione corretamente

CREATE OR ALTER TRIGGER Trg_Cliente_RestritoInativoMaiorIdade
ON Vendas
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;

--Verifica se está na lista de restritos
    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN ClientesRestritos r ON r.idCliente = i.idCliente
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50020, 'Cliente restrito — venda nao permitida.', 1;
    END;

--Verifica se está inativo
    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Clientes c ON c.idCliente = i.idCliente
        JOIN SituacaoClientes s ON c.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50021, 'Cliente inativo — nao e possível registrar venda.', 1;
    END;

--Verifica se é menor de idade
    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Clientes c ON i.idCliente = c.idCliente
        WHERE DATEDIFF(YEAR, c.DataNasc, GETDATE()) -        -- subtrai por 1 caso não tenha feito aniversário ainda
            CASE 
                WHEN MONTH(c.DataNasc) > MONTH(GETDATE())    -- se o mês de nascimento for maior que o mês atual
                     OR (MONTH(c.DataNasc) = MONTH(GETDATE()) AND DAY(c.DataNasc) > DAY(GETDATE()))  -- ou serem iguais, mas o dia for maior
                THEN 1    -- não fez aniversário > subtrai 1
                ELSE 0    -- senão, subtrai por 0
            END < 18
    )
    BEGIN  
        ROLLBACK TRANSACTION;  -- por ser menor de idade, ele faz a operação de cancelar saí da trigger
        THROW 51002, 'A venda nao pode ser feita para cliente de menor de idade.', 1;
    END
END;
GO

--------   >>>   Trigger VERIFICAÇÕES DO FORNECEDOR   <<<   --------          ALTERADO PARA >  AFTER INSERT, para que o Procedure funcione corretamente

CREATE OR ALTER TRIGGER Trg_Fornecedor_RestritoInativo_LimiteAbertura
ON Compras
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;

--Verifica se está na lista de restritos
    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN FornecedoresRestritos r ON r.idFornecedor = i.idFornecedor
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Fornecedor bloqueado — compra nao permitida.', 1;
    END;

--Verifica se está inativo
    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Fornecedores f ON f.idFornecedor = i.idFornecedor
        JOIN SituacaoFornecedores s ON f.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50023, 'Fornecedor inativo — compra nao permitida.', 1;
    END;

--Verifica se tem menos de 2 anos de abertura
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
        THROW 51002, 'Fornecedor com menos de 2 anos de abertura — compra nao permitida.', 1;
    END;
END;
GO

--------   >>>   Trigger AtualizaUltimaCompra   <<<   --------
CREATE OR ALTER TRIGGER Trg_AtualizaUltimaCompra
ON Vendas
AFTER INSERT
AS BEGIN
    UPDATE c
    SET DataUltimaCompra = i.DataVenda
    FROM Clientes c
    JOIN inserted i ON c.idCliente = i.idCliente;
END;
GO

--------   >>>   Trigger Atualizar UltimoFornecimento   <<<   --------
CREATE OR ALTER TRIGGER Trg_AtualizaUltimoFornecimento
ON Compras
AFTER INSERT
AS BEGIN
    UPDATE f
    SET UltimoFornecimento = i.DataCompra
    FROM Fornecedores f
    JOIN inserted i ON f.idFornecedor = i.idFornecedor;
END;
GO

--------   >>>   Trigger PrincipioInativo_Compra   <<<   --------
CREATE OR ALTER TRIGGER Trg_PrincipioInativo_Compra
ON ItensCompras
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN PrincipiosAtivo p ON p.idPrincipioAt = i.idPrincipioAt
        JOIN SituacaoPrincipiosAtivo s ON p.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50012, 'O Principio ativo esta como inativo — nao pode ser comprado.', 1;
    END;
END;
GO

--------   >>>   Trigger PrincipioInativo_Producao   <<<   --------
CREATE OR ALTER TRIGGER Trg_PrincipioInativo_Producao
ON ItensProducoes
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN PrincipiosAtivo p ON p.idPrincipioAt = i.idPrincipioAt
        JOIN SituacaoPrincipiosAtivo s ON p.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50013, 'Principio ativo esta como inativo — nao pode ser usado na producao.', 1;
    END;
END;
GO

--------   >>>   Trigger Medicamento_Inativo_Venda   <<<   --------
CREATE OR ALTER TRIGGER Trg_Medicamento_Inativo_Venda
ON ItensVendas
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Medicamentos m ON m.CDB = i.CDB
        JOIN SituacaoMed s ON m.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50014, 'Medicamento inativo — nao pode ser vendido.', 1;
    END;
END;
GO

--------   >>>   Trigger Medicamento_Inativo_Producao   <<<   --------
CREATE OR ALTER TRIGGER Trg_Medicamento_Inativo_Producao
ON Producoes
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1
        FROM inserted i
        JOIN Medicamentos m ON m.CDB = i.CDB
        JOIN SituacaoMed s ON m.Situacao = s.id
        WHERE s.Situacao = 'I'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50015, 'Medicamento inativo — nao pode ser produzido.', 1;
    END;
END;
GO

--------   >>>   Trigger Atualiza_UltimaVenda_Medicamento   <<<   --------
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

--------   >>>   Trigger Atualiza_UltimaCompra_Principio   <<<   --------
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
