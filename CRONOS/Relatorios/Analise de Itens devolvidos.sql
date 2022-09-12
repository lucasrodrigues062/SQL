
-- Criar como Cubo Customizado
DECLARE @DATAINI DATE, @DATAFIM DATE, @CODFILIAL VARCHAR(2), @CODLOCAL VARCHAR(2), @IDPRODUTO INT

SET @DATAINI = :DATAINI_D
SET @DATAFIM = :DATAFIM_D
SET @IDPRODUTO = :IdProduto_I



SELECT IdItemMov, CODFILIAL=Mov.CODFILIAL, F.NOMEFILIAL, CODLOCAL=Mov.CODLOCAL, Loc.NomeLocal,  Entidade=(CASE WHEN TipoMov IN ('3.1','3.2') THEN FDest.NomeFilial + ' / '+ LDest.NomeLocal ELSE Cf.NomeCliFor + '  ('+Cf.CodCliFor+')' END), DataOperacao = Im.DataOperacao, DataEmissao=Mov.DtMov, IdExpedicao=Mov.IdExpedicao, Im.IdUsuario, Im.FatorConvUnid, STATUS = dbo.fn_DscStatusMov( Mov.Status, '2.8'),  Mov.NUMMOV,  ValorUnitario=im.ValorUnitario* (Im.FatorConvUnid),  ValorUnitario2=im.ValorUnitario2* (Im.FatorConvUnid),  CustoUnitarioItem=im.CustoUnitarioItem* (Im.FatorConvUnid),  CustoMedioItem=im.CustoMedioItem* (Im.FatorConvUnid),  ItemGrade = dbo.fn_DscItemGrade(im.IdItemMov), im.StatusItemMov , Mov.ChaveNFE,
P.Unid, Im.UnidItemMov, DCFPO= Nat.CFPO, Preco=dbo.fn_ValorItemMov1(Im.IdItemMov, Im.PrecoUnit, Im.PercDescontoItem, Mov.PercDesconto, Mov.TipoMov, 'L')* (Im.FatorConvUnid), PrecoUnitB=Im.PrecoUnit * (Im.FatorConvUnid), Im.PercDescontoItem, DscSerie=dbo.fn_DscItemLoteSerie(im.IdItemMov),
Qtd=CASE WHEN Mov.TIPOMOV IN ('2.1','2.2','1.4','2.4','2.6','2.9','3.1','3.2','4.2') THEN ABS(Im.QTD* (1/Im.FatorConvUnid) ) * -1 WHEN Mov.TIPOMOV IN ('6.1') THEN (Im.QTD* (1/Im.FatorConvUnid) ) ELSE ABS(Im.QTD* (1/Im.FatorConvUnid) ) END, ItemBalanco=(SELECT MAX(Ib.IdItemBalanco) FROM ItemBalanco IB WHERE Ib.IdItemMov = Im.IdItemMov),
ma.IdMovOrigem, Origem = (SELECT 'Filial: ' + CodFilial + ', Local: ' + CodLocal + ' Numero: ' + NumMov FROM Movimento Where IdMov = ma.IdMovOrigem)
FROM ITENSMOV Im LEFT JOIN NaturezaOperacao Nat ON Im.IdNaturezaOperacao = Nat.IdNaturezaOperacao
	INNER JOIN Movimento Mov ON Mov.IdMov = Im.IdMov
	LEFT JOIN Cli_For cf ON Mov.CodCliFor = Cf.CodCliFor 
	LEFT JOIN Filiais FDest ON Mov.CODFILIALDEST = FDest.CODFILIAL 
	LEFT JOIN MovAssociado ma ON ma.IdMovDestino = Mov.IdMov
	LEFT JOIN LocalEstoque LDest ON Mov.CODFILIALDEST = LDest.CODFILIAL AND Mov.CODLOCALDEST = LDest.CODLOCAL, Filiais F, LocalEstoque Loc (NOLOCK), dbo.PRODUTOS P
	
WHERE  (Im.IDEMPRESA = Mov.IDEMPRESA) 
   AND (Im.IDMOV = Mov.IDMOV)    
   AND (ISNULL(IM.StatusItemMov,'N') <> 'C')
   AND  (Im.IdProduto  = P.IdProduto)
   AND  (Mov.IDEMPRESA = Loc.IDEMPRESA) 
   AND (Mov.CODFILIAL = Loc.CODFILIAL) 
   AND (Mov.CODLOCAL = Loc.CODLOCAL) 
   AND (Loc.IDEMPRESA = F.IDEMPRESA)  
   AND (Loc.CODFILIAL = F.CODFILIAL)
   AND  (Mov.TIPOMOV IN ('2.8','2.3'))
   AND  (Im.IdProduto = @IDPRODUTO)
   AND (Im.DataOperacao >= @DATAINI )
   AND (Im.DataOperacao < @DATAFIM )
   	 
ORDER BY Im.DataOperacao DESC

