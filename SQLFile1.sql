USE SneezePharma
GO

------------------------------------------------------SITUAÇÃO CLIENTE------------------------------------------------------

INSERT INTO SituacaoClientes (Situacao) VALUES
('A'),
('I');															

SELECT * FROM SituacaoClientes

------------------------------------------------------SITUAÇÃO FORNECEDOR------------------------------------------------------

INSERT INTO SituacaoFornecedores (Situacao) VALUES
('A'),
('I');																					

SELECT * FROM SituacaoFornecedores

-------------------------------------------------SITUAÇÃO PRICIPIOS ATIVO------------------------------------------------------

INSERT INTO SituacaoPrincipiosAtivo (Situacao) VALUES
('A'),
('I');															

SELECT * FROM SituacaoPrincipiosAtivo

------------------------------------------------------SITUAÇÃO MEDICAMENTO------------------------------------------------------

INSERT INTO SituacaoMed (Situacao) VALUES
('A'),
('I');												

SELECT * FROM SituacaoMed

------------------------------------------------------CATEGORIA DO MEDICAMENTO------------------------------------------------

INSERT INTO CategoriasMed (Categoria) VALUES
('A'),
('B'),
('I'),											
('V');

SELECT * FROM CategoriasMed

------------------------------------------------------CLIENTES------------------------------------------------------
											
										/*DataUltimaCompra = DataVenda Venda*/
/*INSERT INTO Clientes (Nome, CPF, DataNasc, DataUltimaCompra, DataCadastro, Situacao) VALUES

('Christian Kevelyn', '53610828803', '2003-02-28', NULL, '2020-02-15', 2),
('Neymar Junior', '12345678901', '2009-08-20', NULL, '2021-03-16', 1),
('Lionel Messi', '98765432198', '1990-04-10', NULL, '2022-04-14', 1),				
('Cristiano Ronaldo', '14785236974', '1980-05-12', NULL, '2023-06-12', 1);		

INSERT INTO Clientes (Nome, CPF, DataNasc, DataUltimaCompra, DataCadastro, Situacao) VALUES
('Everton Tiru', '53610822694', '2001-07-22', NULL, '2025-11-09', 1);*/

SELECT * FROM Clientes;

EXEC sp_CadastrarCliente
'Christian Kevelyn',
'53610828803',
'2003-02-28',
1

EXEC sp_CadastrarCliente
'Neymar Junior',
'12345678901',
'2009-08-20',
1



------------------------------------------------------TELEFONE------------------------------------------------------

INSERT INTO Telefones (idCliente, CodPais, CodArea, Numero) VALUES
(2, 55, 16, '999929938'),
--(3, 55, 11, '997894561'),
--(4, 55, 19, '991234567'),									
(1, 55, 13, '991597538');

SELECT * FROM Telefones

------------------------------------------------------FORNECEDORES------------------------------------------------------
																/*UltimoFornecimento Recebe de UltimaCompra*/
/*INSERT INTO Fornecedores (CNPJ, RazaoSocial, Pais, DataAbertura, Situacao, UltimoFornecimento, DataCadastro) VALUES

('12345678000199', 'MedicinaSaude', 'Brasil', '2024-02-15', 1, NULL , '2018-04-02'),
('98765432000111', 'MaisSaude', 'Brasil', '2016-03-16', 2, NULL, '2019-05-14'),
('96385214000178', 'DrogariaMedicinal', 'Brasil', '2019-10-08', 1, NULL, '2020-06-27'),				
('74185296000133', 'RemediariaMais', 'Brasil', '2018-02-14', 1, NULL, '2020-06-27'),
('35795184200016', 'DrogariaSaude', 'Brasil', '2017-08-22', 1, NULL, '2020-06-27');*/

SELECT * FROM Fornecedores;

EXEC sp_CadastrarFornecedor 
'12345678000199',
'Novo Fornecedor',
'Brasil',
'2020-01-15',
1

EXEC sp_CadastrarFornecedor 
'74185296000133',
'RemediariaMais',
'Brasil',
'2017-08-22',
1

----------------------------------------------CLIENTES RESTRITOS-----------------------------------------------
/*
INSERT INTO ClientesRestritos (idCliente) VALUES

(5);							

SELECT * FROM ClientesRestritos;
*/

----------------------------------------------FORNECEDORES RESTRITOS-----------------------------------------------

/*
INSERT INTO FornecedoresRestritos (idFornecedor) VALUES

(3);			

SELECT * FROM FornecedoresRestritos;
*/

------------------------------------------------------PRINCIPIOS ATIVOS------------------------------------------------------
										/*DataUltimaCompra = DataCompra Comora*/
/*INSERT INTO PrincipiosAtivo (Nome, Situacao, DataUltimaCompra, DataCadastro) VALUES

('Principio1', 2, NULL, '2015-02-20'),
('Principio2', 1, NULL, '2016-03-21'),
('Principio3', 1, NULL, '2017-04-22'),									
('Principio4', 1, NULL, '2018-05-23');*/

SELECT * FROM PrincipiosAtivo;

EXEC sp_CadastrarPrincipioAtivo
'Principio1',
1;

EXEC sp_CadastrarPrincipioAtivo
'Principio2',
1;

------------------------------------------------------MEDICAMENTOS------------------------------------------------------			

							/*ValorVenda = ValorUnitario*/	/*UltimaVenda = DataVenda Venda*/
/*INSERT INTO Medicamentos (CDB, ValorVenda, Nome, UltimaVenda, DataCadastro, Situacao, Categoria) VALUES

('1472583691598', '25.00', 'Nelsaldina', NULL, '2010-10-30', 1, 1),				
('1597536984562', '50.00', 'Paracetamol', NULL, '2011-09-29', 1, 2),	
('7896321475395', '100.00', 'Dorflex', NULL, '2011-08-28', 1, 3),
('3698741235795', '200.00', 'Dramim', NULL, '2011-07-27', 2, 4);*/

SELECT * FROM Medicamentos;

EXEC sp_CadastrarMedicamento
'1472583691598',
12.00,
'Nelsaldina',
1,
2;

EXEC sp_CadastrarMedicamento
'7896321475395',
100.00,
'Dorflex',
1,
3;

------------------------------------------------------VENDAS------------------------------------------------------

				/*ValorTotal = Soma de TotalItemVenda*/
/*INSERT INTO Vendas (idCliente, DataVenda, ValorTotal) VALUES	/*Atributo idCliente sendo informado*/
(3, '2025-03-11', NULL),
(4, '2025-04-12', NULL);					

INSERT INTO Vendas (idCliente, DataVenda, ValorTotal) VALUES    /*Cliente INATIVO*/
(1, '2025-05-13', NULL);

INSERT INTO Vendas (idCliente, DataVenda, ValorTotal) VALUES    /*Cliente menor de idade*/
(2, '2025-02-10', NULL);

INSERT INTO Vendas (idCliente, DataVenda, ValorTotal) VALUES    /*Cliente Restrito*/
(5, '2025-08-20', NULL);*/

SELECT * FROM Vendas;

EXEC sp_CadastrarVenda 
1,
'1472583691598',
2,
'7896321475395', 2


EXEC sp_CadastrarVenda 
1,
'7896321475395',
2,
1

----------------------------------------------------ITENS VENDA------------------------------------------------------	

/*/*ValorUnitario = ValorVenda Medicamento*/ /*TotalItem = Qntd * ValorUnitario*/
INSERT INTO ItensVendas (Quantidade, idVenda, CDB, ValorUnitario) VALUES
/*idVenda e CDB sendo trazidos*/

(2, 1, '1472583691598', NULL),	
(3, 2, '1597536984562', NULL),
(3, 2, '7896321475395', NULL);	/*TotalItem esta como NULL pois o valorUnitario precisa vim de valor venda*/

INSERT INTO ItensVendas (Quantidade, idVenda, CDB, ValorUnitario) VALUES
(5, 4, '3698741235795', NULL); */     /*Medicamento Inativo*/

SELECT * FROM ItensVendas

------------------------------------------------------COMPRAS------------------------------------------------------

						/*ValorTotal = Soma TotalItemCompra*/
/*INSERT INTO Compras (idFornecedor, DataCompra, ValorTotal) VALUES	/*Atributo IdFornecedor sendo atribuido aqui*/

(4, '2025-09-11', NULL),
(5, '2025-08-12', NULL),	
(4, '2025-09-15', NULL);

INSERT INTO Compras (idFornecedor, DataCompra, ValorTotal) VALUES
(3, '2025-06-20', NULL);    /*RESTRITO*/

INSERT INTO Compras (idFornecedor, DataCompra, ValorTotal) VALUES
(2, '2025-07-13', NULL);  /*INATIVO*/

INSERT INTO Compras (idFornecedor, DataCompra, ValorTotal) VALUES
(1, '2025-10-10', NULL);*/    /*MENOS DE 2 ANOS DE ABERTURA*/

EXEC sp_CadastrarCompra
1,
1,
3,
15.00, 2, 1, 5.00

EXEC sp_CadastrarCompra
2,
1,
3,
20.00

SELECT * FROM Compras;

---------------------------------------------------ITENS DE COMPRA---------------------------------------------------	

/*/*TotalItem = Quantidade * ValorUnitario*/
INSERT INTO ItensCompras (idCompra, idPrincipioAt, Quantidade, ValorUnitario) VALUES
/*Atributo IdCompra sendo atribuido aqui, IdPrincipioAtivo Tambem*/

(2, 2, 3, '10.00'),				
(3, 3, 4, '20.00');		/*Aqui total item ja está calculando*/

INSERT INTO ItensCompras (idCompra, idPrincipioAt, Quantidade, ValorUnitario) VALUES
(1, 1, 2, '5.00');*/			/*Principio Inativo*/

SELECT * FROM ItensCompras;

------------------------------------------------------PRODUÇÃO------------------------------------------------------

/*INSERT INTO Producoes (DataProducao, CDB, Quantidade) VALUES	/*CDB sendo trazido*/

('2025-01-01', '1472583691598', 5),
('2025-02-02', '1597536984562', 10),
('2025-03-03', '7896321475395', 15);					

INSERT INTO Producoes (DataProducao, CDB, Quantidade) VALUES    /*Medicamento INATIVO*/
('2025-02-02', '3698741235795', 20);*/

EXEC sp_Producao 
'1472583691598',
1,
2,
10

EXEC sp_Producao 
'7896321475395',
2,
5,
20

SELECT * FROM Producoes;

------------------------------------------------------ITENS DA PRODUÇÃO-------------------------------------------------

/*INSERT INTO ItensProducoes (idProducao, idPrincipioAt, Quantidade) VALUES	/*Atribuindo IdProdução e IdPrincipioAtivo*/

(2, 2, 15),
(3, 3, 10);

INSERT INTO ItensProducoes (idProducao, idPrincipioAt, Quantidade) VALUES	/*Atribuindo IdProdução e IdPrincipioAtivo*/			
(1, 1, 20);*/	/*Principio Inativo*/

SELECT * FROM ItensProducoes;


/*===================================================FAZENDO AS JOINS==============================================================*/

/*==============MEDICAMENTOS: Categoria, Situação=================*/

SELECT 
    m.CDB, m.Nome AS Medicamento, m.ValorVenda, cat.Categoria, s.Situacao AS StatusMedicamento, m.DataCadastro
FROM Medicamentos m
JOIN CategoriasMed cat 
ON cat.id = m.Categoria
JOIN SituacaoMed s 
ON s.id = m.Situacao
ORDER BY m.Nome;

/*========PRODUÇÕES: Qntd, Nome do Med, Nome e Qntd do PAtivo=========*/
SELECT 
    p.idProducao, p.DataProducao, m.Nome AS Medicamento, p.Quantidade AS Qtd_Medicamento,
    pa.Nome AS PrincipioAtivo, itp.Quantidade AS Qtd_Principio

FROM Producoes p			
JOIN Medicamentos m		/*junta cada linha da tabela Producoes com a tabela Medicamentos quando o campo CDB for igual em ambas.*/
ON p.CDB = m.CDB		

JOIN ItensProducoes itp 
ON p.idProducao = itp.idProducao
JOIN PrincipiosAtivo pa 
ON pa.idPrincipioAt = itp.idPrincipioAt
ORDER BY p.DataProducao;

/*===========COMPRAS : Nome Fonrcedor, Itens (Qtd, ValorUnit, TotalItem), Nome PAtivo======*/

SELECT c.idCompra, f.RazaoSocial AS Fornecedor,
    c.DataCompra, pa.Nome AS PrincipioAtivo,
    ic.Quantidade, ic.ValorUnitario, c.ValorTotal
FROM Compras c
JOIN Fornecedores f 
ON f.idFornecedor = c.idFornecedor
JOIN ItensCompras ic 
ON ic.idCompra = c.idCompra
JOIN PrincipiosAtivo pa 
ON pa.idPrincipioAt = ic.idPrincipioAt
ORDER BY c.idCompra;

-- <<   Informações completas de Cliente   >>

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