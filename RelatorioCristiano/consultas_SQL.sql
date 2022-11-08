SELECT * FROM DGE_PRODUTOANEXO WHERE SEQPRODUTO = 2040 
-- select empresa 
    SELECT 
            E.RAZAOSOCIAL,
            E.FANTASIA,
            E.CNPJENTIDADE,
            E.TELEVENDASDDD as DDD,
            E.TELEVENDASNRO as telefone,
            e.endereco as rua,
            e.endereconro as numero,
            e.cep,
            e.cidade,
            e.inscrestadual as ie
            FROM GE_EMPRESA E  where e.nroempresa = 1 
-- SELECT FICHA TECNICA 
 SELECT
 (select E.codservico from DGE_EMPRESACOMPL E WHERE E.NROEMPRESA = 1) AS SIF,
 (select lpad(pe.gtin,14,0) from DGE_PRODUTOEMBALAGEM pe where pe.seqproduto  = 1002 and pe.menorunidcontrole = 'S') as gtinMenorControle, 
 lpad(pe.gtin,14,0) as gtinUnidadePadrao,
 p.descricao as descProduto,                                             
 p.embprimaria, p.embsecundaria,
 pp.coddipoa AS DIPOA,
 pp.prazovalidade||' '||DECODE(pp.Tipovalidade, 1,'Dias', 2,'Meses')as validade,                                               
 DECODE(p.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente')As Conservacao,
 p.TempMinima||'°C' As TempMinima,
 p.TempMaxima||'°C' As TempMaxima,
 pe.seqembalagem as seqUniPadrao,
 DECODE(pe.UNIDADE, 'CX', 'CAIXA', '') As Unidade,
 DECODE(pe.pesopadrao,'S','SIM','N','NÃO') AS pesopadrao,
 pe.PesoMedio, pe.pesominimo, pe.pesomaximo,
 Replace(Trim(To_char(c.CODNCM, '0999,90,00')), '.', ',')as NCM, C.DESCRICAO as desNCM,
 Replace(Trim(To_char(c.cest, '099,990,00')), '.', ',') as CEST, C.DESCRICAOCEST,
 DECODE(p.maturado,'S','SIM','N','NÃO') AS MATURADO, 
 C.CODCLASSFISCAL
 into
    vCodSif,
    vGtinUnidadePadrao, vGtinMenorControle,
    vPdescricao,
    vDesEmbalagemPrimaria, vDesEmbalagemSecundaria,
    vDipoa,
    vValidade,
    vConservacao,
    vTempMinima,
    vTempMaxima,
    vSeqUnidadePatrao,
    vUnidadePatrao,
    vPesoPadrao, vPesoMedio, vPesoMinimo, vPesomaximo,
    vCodNcm, vDescNcm,
    vCodCest, vDescCest,
    vMaturado,
    vCodClassFiscal
    
 FROM 
    DGE_PRODUTO P,
    Dge_Produtoplanta  pp,
    DGE_PRODUTOEMBALAGEM Pe,
    DGE_CLASSFISCAL C                          
 WHERE 
    P.SEQPRODUTO = Pe.Seqproduto
    AND P.SEQCLASSFISCAL = C.SEQCLASSFISCAL 
    AND  P.SEQPRODUTO = PP.Seqproduto 
    AND PE.EMBALAGEMINDUSTRIAPADRAO = 'S'                        
    AND P.SEQPRODUTO = nSeqProduto;

--- select descrição descricao 
SELECT 
                      PD.SEQDESCRICAO,
                      I.DESCRICAO, 
                      PD.TIPODESCRICAO,
                      DP.DESCRICAO 
                      FROM                       
                      DGE_PRODUTODESCRICAO PD,
                      DGE_IDIOMA I,
                      DGE_DESCRICAOPRODUTO DP
                      WHERE 
                      PD.SEQIDIOMA = I.SEQIDIOMA
                      AND DP.SEQDESCRICAO = PD.SEQDESCRICAO
                      AND PD.SEQPRODUTO = 1002
                      AND PD.TIPODESCRICAO = 4; 
--- select ncm cest
select P.SEQPRODUTO, 
                      C.CODCLASSFISCAL,
                      C.DESCRICAOCEST,
                      C.CODNCM,
                      C.DESCRICAO as desNCM,
                      C.CEST                      
                       from DGE_PRODUTO P, DGE_CLASSFISCAL C 
                       WHERE P.SEQCLASSFISCAL = C.SEQCLASSFISCAL 
                       AND P.SEQPRODUTO = 1002 
                       
                      SELECT 
                      Replace(Trim(To_char(c.CODNCM, '0999,90,00')), '.', ','),
                      Replace(Trim(To_char(c.cest, '099,990,00')), '.', ',') 
                      FROM DGE_CLASSFISCAL C GROUP BY  C.CEST, C.CODNCM

-- select para buscar paremetros nas tabelas
SELECT * FROM DBA_ALL_TABLES WHERE TABLE_NAME IN (
SELECT TABLE_NAME FROM DBA_TAB_COLUMNS WHERE OWNER = 'TSTDATAVALE' AND COLUMN_NAME = 'SEQGRUPOCOMPRA')
--consulta informações nuricionais 
select p.ordem, p.descricao,p.referencia as quantidade, p.vlrpercdiario as diario  
from Dge_Produtocomposicao p where p.seqproduto = 1002 order by p.ordem 

-- Variaveis cidade inicio
  
  vRazaosocial GE_Empresa.RAZAOSOCIAL%Type := null;
  vNomeFantasia GE_Empresa.FANTASIA%Type := null;
  vCNPJ GE_Empresa.CNPJENTIDADE%Type := null; 
  vDDD GE_Empresa.TELEVENDASDDD%Type := null;
  vTelefone GE_Empresa.TELEVENDASNRO%Type := null; 
  vLogradouro GE_Empresa.endereco%Type := null; 
  vNumero GE_Empresa.endereconro%Type := null; 
  vCep GE_Empresa.cep%Type := null; 
  vCidade GE_Empresa.cidade%Type := null; 
  vIE GE_Empresa.inscrestadual%Type := null;

     
-- Variaveis cidade fim
  
  BEGIN
      SELECT 
      E.RAZAOSOCIAL,
      E.FANTASIA,
      E.CNPJENTIDADE,
      E.TELEVENDASDDD ,
      E.TELEVENDASNRO ,
      e.endereco ,
      e.endereconro,
      e.cep,
      e.cidade,
      e.inscrestadual as ie
      into( 
        vRazaosocial,  
        vNomeFantasia,    
        vCNPJ,         
        vDDD,
        vTelefone,      
        vLogradouro,
        vNumero ,        
        vCep, 
        vCidade,
        vIE  
         )


-- SELECT IMAGEN DE MODELO DA ETIQUETA ETIQUETAS 
 Select me.imagem, PM.TIPO
 From  DIN_ProdutoModeloEtiqueta@DTVIND01 Pm, DIN_ModeloEtiqueta@DTVIND01 Me
 Where Me.SeqModeloEtiqueta = Pm.SeqModeloEtiqueta and Pm.SeqProduto = 1002


--- SELECT MERCADO DESTICO
SELECT 
    E.RAZAOSOCIAL,
    E.FANTASIA,
    regexp_replace(LPAD(To_char(e.cnpjentidade), 14),'([0-9]{2})([0-9]{3})([0-9]{3})([0-9]{4})','\1.\2.\3/\4-') as CNPJ,
    E.TELEVENDASDDD ,
    E.TELEVENDASNRO ,
    e.endereco ,
    e.endereconro,
    Replace(Trim(To_char(e.CEP/1000,'00000.000')), '.', '-')as cep,
    e.cidade,
    e.inscrestadual as ie
into 
    vRazaosocial,  
    vNomeFantasia,    
    vCNPJ,         
    vDDD,
    vTelefone,      
    vLogradouro,
    vNumero ,        
    vCep, 
    vCidade,
    vIE
    vlogo            
FROM 
    GE_EMPRESA E  
where e.nroempresa = vEmpresa; 

-- comando criar tabela de versao 

create table DTVIND_PRODUTOVERSAO (
       seqproduto number,
       dataVersao date,
       nroVersao number      
)

-- relatorio de versao, comando para cravar as tabelas   dtvind_produtoversao 

begin
  for i in( select 
                                            
               p.seqproduto
                                                             
            from 
               DGE_produto p, 
               dge_grupoproduto gp, 
               dge_tipoproduto tp 
                                                            
            where
               p.grupoprod = gp.grupoprod
               
               and tp.tipoproduto = gp.tipoproduto
               and gp.tipoproduto = 2
               and gp.grupoprod in (3,4))
   loop
     insert into dtvind_produtoversao(seqproduto,dataversao,nroversao)values(i.seqproduto, trunc(sysdate), 2);
     commit;
  end loop;
end;
 
-- trigger para gerar relatorio de versão
CREATE OR REPLACE TRIGGER DTVIND_PRODUTOVERSAO
BEFORE INSERT ON DGE_OCORRENCIA
FOR EACH ROW

DECLARE
vDataVersao date;
BEGIN


   IF :NEW.MOTIVO = 'ALTERAÇÃO FICHA TECNICA' AND :NEW.TABLINK = 'DGE_PRODUTO' THEN
     SELECT
        dataversao
     into
        vDataversao
     FROM
        dtvind_produtoversao
     where
        seqproduto = to_number(:new.codlink);

     if vDataVersao <> :new.data then
       update dtvind_produtoversao set nroVersao = nroVersao +1, DataVersao = :new.data where seqproduto = to_number(:new.codlink);
     end if;
   END IF;
END;


<div id="Page1" class="A4">
        
            <div class="row b1"><!-- Row  cabesalho-->
                <div class="col-2">
                    <img class="logo img-fluid"
                        src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vLogo)||'" />
                </div>
                <div class="col-6 quebra">
                    <div class="row text-center ">
                        <p class="fs-5 fw-bold">'||TO_CHAR(vNomeFantasia)||'</p>
                        <p class="fs-6">'||'Local: '||TO_CHAR(vCidade)||' - '||TO_CHAR(vLogradouro)||' - '||TO_CHAR(vNumero)||'</p>
                        <p class="fs-6">'||'CNPJ: '||TO_CHAR(vCNPJ)||'IE:'||TO_CHAR(vIE)||'</p>
                        <p class="fs-6 d-inline"> Telefone:('||TO_CHAR(vDDD)||')'||TO_CHAR(vTelefone)||'</p>
                        <p class="fs-6 d-inline">'||'CEP: '||TO_CHAR(vCep)||'</p>
                    </div>
                </div>
                <div class="col-4 text-center">
                    <div class="row">
                        <div class="col-6 text-start">
                            <div>Data de Emissão:</div>
                            <div>Data de Revisão:</div>
                            <div>Nº de Revisão:</div>
                        </div>
                        <div class="col-6">
                            <div>'||vDataAtual ||'</div>
                            <div>'||vDataVersao||'</div>
                            <div>'||vCodVersao ||'</div>
                        </div>
                    </div>
                </div>

                <div class="row "> <!-- TITULO FORMULARIO -->
                    <div class="col fs-5 text-center border-top fw-bold">
                        <p>Ficha tecnica do produto</p>
                    </div>
                </div><!-- fim row-->

            </div><!-- fim cabesalho-->
        
        
        
            <div id="Page4"class="A4">
         <div id="embalagem" class="row">  <!-- #################### --- inicio tabela VERSAO --- ################################  -->
            <div class="col-12">
                <div class="caixa">
                    <div class="distaca fs-4 fw-bold text-center">
                        Relatorio de Versão da Ficha Técnica 
                    </div>
                    <div class="row">
                        <div class="mx-auto col-12">

                            <table class="table align-middle table-bordered border table-striped">
                                <thead>
                                    <tr class="text-center">
                                        <th width="50px">Versão</th>                                        
                                        <th width="50">Data</th>
                                        <th width="200px">Descrição</th>
                                        
                                    </tr>
                                </thead>
                                <tbody class="text-break">
                                    ';
                                    FOR i IN
                                          (select         
                                               pv.nroversao,
                                               pv.dataversao                                           
                                            FROM 
                                               DTVIND_PRODUTOVERSAO pv
                                            WHERE
                                               pv.seqproduto = nSeqProduto)                                                                              
                                    LOOP
                                      -- FOR JUNTO DETALHES DA VERSAO EM UMA VARIVEL 
                                        for x in(   
                                              select        
                                                 o.detalhe 
                                              FROM 
                                                 DGE_OCORRENCIA o,
                                                 DTVIND_PRODUTOVERSAO pv
                                              WHERE
                                                 O.CODLINK = PV.SEQPRODUTO
                                                 AND PV.NROVERSAO = i.nroversao
                                                 AND pv.dataversao = o.data 
                                                 AND o.motivo = 'ALTERAÇÃO FICHA TECNICA'
                                                 AND O.CODLINK = nSeqProduto)
                                        loop
                                           vDetalhes:= vDetalhes||'<p>'||x.detalhe||'</p>'; 
                                        end loop;
                                                                            
                                        cHTML := cHTML||'
                                            <tr>
                                                <th scope="row" class="text-center fw-bold fs-5">'||TO_CHAR(i.nroversao,'000')||'</th>
                                                <td class="text-center fw-bold fs-5">'||TO_CHAR(i.dataversao, 'DD/MM/YYYY')||'</td>
                                                <td>
                                                    <p>'||TO_CHAR(vDetalhes)||'</p>
                                                </td>                                                
                                            </tr>
                                        ';
                                                                                    
                                    END LOOP;

                                    cHTML := cHTML||'
                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
        </div><!-- #################### --- FIM tabela  VERSAO -- ################################  -->

    </div><!--fim A4 Page1-->

/*Tabela auxiliar para sequencial*/
create table DTVIND_PRODUTOSEQUENCIAL
(
  seqproduto NUMBER,
  sequencial  NUMBER
) 
-------------------------------- 
/**VIEW QUE TRAZ O SEQUENCIAL**/
CREATE OR REPLACE VIEW DGEVG_FICHATECPRODUTO AS
SELECT
   SeqCodLink, SeqTabLink as SeqTabLinkFK, Nvl(NValor, 0) as NValor, SValor, CodLink, DescrCodLink
FROM (

SELECT 
   Cl.SeqCodLink, Cl.SeqTabLink, Cl.NValor, Cl.SValor, P.SeqProduto As CodLink, P.SeqProduto  ' - '  P.Descricao As DescrCodLink
FROM 
   DGE_Produto P, DGE_GrupoProduto Gp, DGE_TipoProduto Tp, DGE_TabLink Tl, DGE_CodLink Cl
WHERE
   P.GrupoProd = Gp.GrupoProd
   AND Tp.TipoProduto = Gp.TipoProduto
   AND Gp.tipoproduto = 2
   AND Gp.grupoprod in (3,4)
   AND P.SeqProduto = Cl.CodLink
   AND Cl.SeqTabLink = Tl.SeqTabLink
   AND Tl.Origem = 'DGEVG_FICHATECPRODUTO'

UNION

SELECT 
   Null As SeqCodLink, Tl.SeqTabLink, Null As NValor, '' As SValor, P.SeqProduto As CodLink, P.SeqProduto  ' - '  P.Descricao As DescrCodLink
FROM 
   DGE_Produto P, DGE_GrupoProduto Gp, DGE_TipoProduto Tp, DGE_TabLink Tl
WHERE
   P.GrupoProd = Gp.GrupoProd
   AND Tp.TipoProduto = Gp.TipoProduto
   AND Gp.tipoproduto = 2
   AND Gp.grupoprod in (3,4)
   AND Tl.Origem = 'DGEVG_FICHATECPRODUTO'
   And Not Exists(Select xC.SeqCodLink From DGE_CodLink xC Where xC.CodLink = P.SeqProduto And xC.SeqTabLink = Tl.SeqTabLink)
)
ORDER BY
   CodLink;
--------------------------------
/** COMANDO QUE INSERE O SEQUENCIAL**/
BEGIN

   FOR i IN (
      SELECT
         *
      FROM
         DTVIND_ProdutoSequencial Ps, DGEVG_FichaTecProduto Ft
      WHERE
         Ps.SeqProduto = Ft.CodLink
   )
   LOOP

      IF i.nValor = 0 THEN

         INSERT INTO DGE_CodLink(SeqCodLink, SeqTabLink, CodLink, nValor)
            VALUES ( S_DGE_CODLINK.NEXTVAL, i.Seqtablinkfk, i.CodLink, i.sequecial);
         COMMIT;

      END IF;

   END LOOP;
END;