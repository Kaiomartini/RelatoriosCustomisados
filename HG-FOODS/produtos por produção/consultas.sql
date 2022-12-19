-- ### tras tododos os produtos de um brupo e a ultima data de cada um ###-----------------------------------------------------------
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

-- ### filtro de grupo para parametro da função, tipo lista simples ### --------------------------------------------------------------
select gp.grupoprod,gp.grupoprod||' - '||gp.descricao from din_grupoproduto gp where gp.status = 'A' -- filtro 

-- rastreio de embalegens -------------------------------------------------------------------------------------------------------------
 select
     --pek.seqembalagemkit,
     p.seqproduto,
     p.descricao,
     DECODE(p.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente','Não Informado')As Conservacao,
     tp.descricao as tipo,
     gp.descricao as grupo,
     sgp.descricao as subgrupo
     
 from 
     dge_embalagemkitinsumo eks,
     dge_produtoembalagemkit pek,
     dge_produtoembalagem pe,
     dge_produto p,
     dge_grupoproduto gp,
     dge_tipoproduto tp,
     dge_Subgrupoproduto sgp
 where 
     gp.grupoprod = sgp.grupoprod
     and sgp.subgrupoprod = p.subgrupoprod
     and gp.tipoproduto = tp.tipoproduto
     and gp.grupoprod = p.grupoprod 
     --and p.status = 'A'
     and p.seqproduto = pe.seqproduto 
     and pe.seqembalagem = pek.seqembalagem
     and pek.seqembalagemkit = eks.seqembalagemkit
     and eks.seqproduto = 10016 --/6611/
 group by             
     p.seqproduto,p.descricao, p.conservacao,
     tp.descricao,  gp.descricao, sgp.descricao  
     --pek.seqembalagemkit 

-- select produto/ tipo/ grupo/ sub_grupo  -----------------------------------------------------------
  select                                              
      p.seqproduto,
      p.descricao,                                               
      --DECODE(p.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente','Não Informado')As Conservacao,
      tp.descricao as tipo,                                                
      gp.descricao as grupo,
      sgp.descricao as subGrupo
  from                                                 
      din_produto p,
      din_grupoproduto gp,
      din_tipoproduto tp,
      Din_Subgrupoproduto sgp
  where 
      sgp.subgrupoprod = p.subgrupoprod
      and gp.tipoproduto = tp.tipoproduto
      and gp.grupoprod = p.grupoprod 
      and p.seqproduto = 6611