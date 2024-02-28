
-- Atualiza sdo pedido fornecedor
	UPDATE Estoque SET SdoPedidoFornecedor = 0

	UPDATE Estoque SET SdoPedidoFornecedor = J.QTD 
	FROM Estoque Est 
	INNER JOIN (
	select  CodFilial, CodLocal, IdProduto, SUM (Item.Qtd / Item.FatorConvUnid) AS QTD
	
	from Movimento Mov WITH(NOLOCK) INNER JOIN ItensMov Item WITH(NOLOCK)  on Mov.IdMov = Item.IdMov

	WHERE Mov.TipoMov = '1.3' AND Mov.Status = 'T'
	--AND Item.IdProduto = 1736

	GROUP BY CodFilial, CodLocal, IdProduto
	) J ON Est.IdProduto = J.IdProduto AND Est.CodFilial = J.CodFilial AND Est.CodLocal = Est.CodLocal
