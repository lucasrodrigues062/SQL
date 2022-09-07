-- Campo Complementar que armazena registros de quem imprimiu os espelhos

IF OBJECT_ID('ZMovimentoCompl', 'U') IS NULL 
	BEGIN   
		CREATE TABLE ZMovimentoCompl (IdMov INT NOT NULL  ) 
	END 
IF COL_LENGTH('ZMovimentoCompl', 'sym_audit_print') IS NULL 
	BEGIN 
		ALTER TABLE ZMovimentoCompl ADD sym_audit_print VARCHAR (500) NULL 
	END 

GO

exec sp_executesql N'INSERT INTO ConfigCompl
(Tabela, NomeColuna, Aplicacao, Descricao, 
  Tipo, Tamanho, ValorDef, Ordem, CodTabDinam, 
  Inativo, ExibirGrid, SoLeitura)
VALUES (@P1, @P2, @P3, @P4, 
  @P5, @P6, @P7, @P8, @P9, 
  @P10, @P11, @P12)
',N'@P1 varchar(30),@P2 varchar(20),@P3 varchar(100),@P4 varchar(40),@P5 varchar(1),@P6 smallint,@P7 varchar(250),@P8 smallint,@P9 varchar(10),@P10 varchar(1),@P11 varchar(1),@P12 varchar(1)','ZMovimentoCompl','sym_audit_print',NULL,'Auditoria Impressao','M',500,NULL,99,NULL,'N','N','S'