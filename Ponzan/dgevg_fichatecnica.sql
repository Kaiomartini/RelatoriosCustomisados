CREATE OR REPLACE VIEW DGEVG_FICHATECNICA AS
SELECT

     P.SEQPRODUTO,
     p.descricao as descProduto,
     pe.UNIDADE,
     pe.quantidade,
     (select lpad(xpe.gtin,14,0) from DGE_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = P.SEQPRODUTO and xpe.menorunidcontrole = 'S') as EAN,
     lpad(pe.gtin,14,0) as DUM,
     Replace(Trim(To_char(c.CODNCM, '0999,90,00')), '.', ',') as NCM,
     Replace(Trim(To_char(c.cest, '099,990,00')), '.', ',') as CEST,
      --peso liquido menor controle
     (select xpe.pesomedio from DGE_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = P.SEQPRODUTO and xpe.menorunidcontrole = 'S')as LiquidoUnidade,
     --peso bruto menor controle
     ((select
          sum(xE.peso)
       from
          dge_produto xP,
          dge_embalagemkitinsumo xE,
          dge_PRODUTOEMBALAGEM xEM
       where
          (xE.Seqprodutodestino = P.Seqproduto or xE.seqprodutodestino is null)
          and xE.tipo in(1) and xP.Seqproduto = xE.Seqproduto and xEm.Seqproduto = P.Seqproduto
          and xEm.embalagemindustriapadrao = 'S'
          and xe.seqembalagemkititemsubst is  null
          and xE.seqembalagemkit  = (select
                                         ykt.seqembalagemkit
                                      from
                                         dge_PRODUTOEMBALAGEM yPO,
                                         dge_produtoembalagemkit yKT
                                      where
                                         yPO.Seqproduto = P.SEQPRODUTO
                                         and yPO.embalagemindustriapadrao = 'S'
                                         and yKT.seqembalagem = pe.seqembalagem)
                                         )  +  (select xpe.pesomedio
                                                 from DGE_PRODUTOEMBALAGEM xpe
                                                 where xpe.seqproduto  = P.SEQPRODUTO
                                                 and xpe.menorunidcontrole = 'S')) as brutoUnidade,
     --peso liquido da unidade padrão caixa
     (select xpe.pesomedio * pe.quantidade as pesoLiquido from DGE_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = P.SEQPRODUTO and xpe.menorunidcontrole = 'S') as LiquidoCaixa,
     -- peso bruto da unidade padrao caixa
     (((select --tara enbanalagem primaria /brutoCaixa
          sum(xE.peso)
       from
          dge_produto xP,
          dge_embalagemkitinsumo xE,
          dge_PRODUTOEMBALAGEM xEM
       where
          (xE.Seqprodutodestino = P.Seqproduto or xE.seqprodutodestino is null)
          and xE.tipo in(1) and xP.Seqproduto = xE.Seqproduto and xEm.Seqproduto = P.Seqproduto
          and xEm.embalagemindustriapadrao = 'S'
          and xe.seqembalagemkititemsubst is  null
          and xE.seqembalagemkit  = (select
                                         ykt.seqembalagemkit
                                      from
                                         dge_PRODUTOEMBALAGEM yPO,
                                         dge_produtoembalagemkit yKT
                                      where
                                         yPO.Seqproduto = P.SEQPRODUTO
                                         and yPO.embalagemindustriapadrao = 'S'
                                         and yKT.seqembalagem = pe.seqembalagem)
                                         )   +    (select xpe.pesomedio
                                                      from DGE_PRODUTOEMBALAGEM xpe
                                                      where xpe.seqproduto  = P.SEQPRODUTO
                                                      and xpe.menorunidcontrole = 'S') ) * pe.quantidade ) + -- peso liquido tara primaria

                                                                                    (select
                                                                                             sum(xE.peso)
                                                                                          from
                                                                                             dge_produto xP,
                                                                                             dge_embalagemkitinsumo xE,
                                                                                             dge_PRODUTOEMBALAGEM xEM
                                                                                          where
                                                                                             (xE.Seqprodutodestino = P.Seqproduto or xE.seqprodutodestino is null)
                                                                                             and xE.tipo in(2) and xP.Seqproduto = xE.Seqproduto and xEm.Seqproduto = P.Seqproduto
                                                                                             and xEm.embalagemindustriapadrao = 'S'
                                                                                             and xe.seqembalagemkititemsubst is  null
                                                                                             and xE.seqembalagemkit  = (select
                                                                                                                              ykt.seqembalagemkit
                                                                                                                           from
                                                                                                                              dge_PRODUTOEMBALAGEM yPO,
                                                                                                                              dge_produtoembalagemkit yKT
                                                                                                                           where
                                                                                                                              yPO.Seqproduto = P.SEQPRODUTO
                                                                                                                              and yPO.embalagemindustriapadrao = 'S'
                                                                                                                              and yKT.seqembalagem = pe.seqembalagem))as brutoCaixa,


     (SELECT ek.altura||'cm'|| ' x '||ek.largura||'cm' FROM DGE_EMBALAGEMKIT ek, Dge_Produtoembalagemkit xpe  where ek.seqembalagemkit = xpe.seqembalagemkit    and xpe.seqembalagem = pe.seqembalagem)as dimensaoCaixa,
    -- p.embprimaria, p.embsecundaria,
     --pp.coddipoa AS DIPOA,
     pp.prazovalidade||' '||DECODE(pp.Tipovalidade, 1,'Dias', 2,'Meses')as validade,
     --DECODE(p.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente')As Conservacao,
     p.conservacao,
     --p.TempMinima||'°C' As TempMinima,
     --p.TempMaxima||'°C' As TempMaxima,
     --pe.seqembalagem as seqUniPadrao,

     --DECODE(pe.pesopadrao,'S','SIM','N','NÃO') AS pesopadrao,

     --DECODE(p.maturado,'S','SIM','N','NÃO') AS MATURADO,
     (select svalor from dgevg_produto  where codlink = p.SEQPRODUTO) as cadastrogenerico,
     --C.CODCLASSFISCAL,
     p.ingredientes,
     NVL(p.formula,null) as modoPreparo,
     u.descricao as descUnidade,
     Pp.NroPlanta
     --(SELECT tuf.seqsittributariaicms  FROM   DGE_TRIBUTACAOUF tuf WHERE   TipoTributacao = 4 AND SeqTributacao = (SELECT SeqTributacao FROM DGE_PRODUTO WHERE SeqProduto = 8))as icms
     /*(select xE.codservico from DGE_EMPRESACOMPL xE WHERE xE.NROEMPRESA = 1) AS SIF,*/
 FROM
    DGE_PRODUTO P,
    Dge_Produtoplanta  pp,
    DGE_PRODUTOEMBALAGEM Pe,
    DGE_CLASSFISCAL C,
    dge_unidade u
    --DGEVR_TributacaoUfIcms Tui
 WHERE
    P.SEQPRODUTO = Pe.Seqproduto
    AND P.SEQCLASSFISCAL = C.SEQCLASSFISCAL
    AND  P.SEQPRODUTO = PP.Seqproduto
    DUM
    and u.unidade =pe.unidade
    --AND P.SeqProduto = Tui.SeqProduto
    --AND P.SEQPRODUTO =  8
    --AND Pp.NroPlanta = 1;

    --select * from DGEVG_FICHATECNICA;
