-- ### tras tododos os produtos de um brupo e a ultima data de cada um ###
select  pr.seqproduto,
        pr.descricao,
   (SELECT  max(e.Dtaproducao)
    FROM DIN_Estoque e, DIN_Produto p, DIN_ProgProducaoItem ppi, DIN_ProgProducao pp
   WHERE e.SeqProduto = p.SeqProduto
     AND e.TabLinkEnt = 'DIN_PROGPRODUCAOITEM'  AND e.CodLinkEnt = ppi.SeqProgProducaoItem 
     AND pp.SeqProgProducao = ppi.SeqProgProducao --AND e.Dtaproducao BETWEEN '01-Aug-2011' AND '31-Oct-2011'
    and p.seqproduto = pr.seqproduto  
    --GROUP BY e.seqproduto
    ) as Utima data produzida 
  
from din_produto pr  --, din_grupoproduto
where pr.status = 'A' 
and pr.grupoprod = 4
--and pr.subgrupoprod = 40
--and pr.familiaprod = 5
--and pr.seqproduto = 403032

-- ### filtro de grupo para parametro da função, tipo lista simples ### 
select gp.grupoprod,gp.grupoprod||' - '||gp.descricao from din_grupoproduto gp where gp.status = 'A' -- filtro 