SELECT  tp.SeqProduto, tp.SeqEmbalagem, tp.VlrPraticado,
        c.VlrMedio
FROM    DGEV_TABPRECO tp,
        (SELECT  nfi.SeqProduto, nfi.SeqEmbalagem, 
                ROUND(SUM(nfi.VlrProduto)/SUM(nfi.Quantidade), 2) VlrMedio
        FROM    DCV_NOTAFISCAL nf,
                DCV_PEDIDO pv,
                DCV_NFISCALITEM nfi
        WHERE   pv.SeqPedido = nf.SeqPedido 
                AND nfi.SeqNotaFiscal = nf.SeqNotaFiscal 
                AND nf.TipoNota = 'S'
                AND nf.SituacaoNF = 4
                AND nf.NroEmpresa = 1
                AND nf.DtaEmissao BETWEEN '01-Aug-2022' AND '31-Oct-2022' --filtro 
                AND pv.SeqCliente = 15367 --filtro 
        GROUP BY nfi.SeqProduto, nfi.SeqEmbalagem) c
WHERE   c.SeqProduto (+) = tp.SeqProduto
        AND c.SeqEmbalagem (+)= tp.SeqEmbalagem 
        AND tp.SeqTabPreco = 99983 --filtro

--########################################################
DECLARE 
  pnSeqRede GE_REDEPESSOA.SeqRede%TYPE := 52;
  pnSeqPessoa GE_PESSOA.SeqPessoa%TYPE := 0;--15367;
  pnFiltro INTEGER;
BEGIN
    --
    DECLARE CURSOR cDados IS
            SELECT  DISTINCT pv.SeqCliente 
                    --nfi.SeqProduto
                    -- nfi.SeqEmbalagem, pif.SeqTabPreco,
                    --SUM(nfi.VlrProduto)/SUM(nfi.Quantidade) VlrMedio
            FROM    DCV_NOTAFISCAL nf,
                    DCV_PEDIDO pv,
                    DCV_NFISCALITEM nfi,
                    DCV_PEDIDOINFADICIONAL pif,
                    GE_REDEPESSOA rp
            WHERE   pv.SeqPedido = nf.SeqPedido 
                    AND nfi.SeqNotaFiscal = nf.SeqNotaFiscal 
                    AND pif.SeqPedidoInfAdicional = nf.SeqPedidoInfAdicional
                    AND rp.SeqPessoa (+)= pv.SeqCliente
                    AND nf.TipoNota = 'S'
                    AND nf.SituacaoNF = 4
                    AND nf.NroEmpresa = 1
                    AND nf.DtaEmissao BETWEEN '01-Aug-2022' AND '31-Oct-2022'
                    AND (pv.SeqCliente = pnSeqPessoa OR pnSeqPessoa = 0)
                    AND (rp.SeqRede = pnSeqRede OR pnSeqRede = 0);
                    --AND nfi.SeqProduto = 87;
                    --GROUP BY nfi.SeqProduto, nfi.SeqEmbalagem, pif.SeqTabPreco;
    BEGIN
            FOR i IN cDados 
            LOOP
              DBMS_OUTPUT.put_line('Pessoa: '||i.SeqCliente);
              DBMS_OUTPUT.put_line('produto: '||i.SeqCliente);
            END LOOP;
    END;
--
END;
-- joao 2

--- caio 
cursor cdados is 
 SELECT  tp.SeqProduto,tp.DescrProduto,
         tp.Unidade ||' - '||(select xu.descricao from dge_unidade xu where xu.unidade = tp.Unidade) as descUnidade,
         tp.Descricao,
         tp.NroPlanta,
         tp.SeqEmbalagem, tp.VlrPraticado,
         c.VlrMedio      
  FROM   DGEV_TABPRECO tp,
         (SELECT nfi.SeqProduto, nfi.SeqEmbalagem, 
                  ROUND(SUM(nfi.VlrProduto)/SUM(nfi.Quantidade), 2) VlrMedio
          FROM    DCV_NOTAFISCAL nf,
                  DCV_PEDIDO pv,
                  DCV_NFISCALITEM nfi
          WHERE   pv.SeqPedido = nf.SeqPedido 
                  AND nfi.SeqNotaFiscal = nf.SeqNotaFiscal 
                  AND nf.TipoNota = 'S'
                  AND nf.SituacaoNF = 4
                  AND nf.NroEmpresa = 1
                  AND nf.DtaEmissao BETWEEN '01-Aug-2022' AND '31-Oct-2022' --filtro 
                  AND pv.SeqCliente = 15367 --filtro 
          GROUP BY nfi.SeqProduto, nfi.SeqEmbalagem) c
  WHERE   c.SeqProduto (+) = tp.SeqProduto
          AND c.SeqEmbalagem (+)= tp.SeqEmbalagem 
          AND tp.SeqTabPreco = 99983 --filtro
          order by c.VlrMedio;