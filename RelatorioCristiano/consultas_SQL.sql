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
  for i in(
select 
        
        p.seqproduto
        
from 
       DGE_produto p, dge_grupoproduto gp, dge_tipoproduto tp 
where
  p.grupoprod = gp.grupoprod 
 and tp.tipoproduto = gp.tipoproduto
 and gp.tipoproduto = 2)
 loop
   insert into dtvind_produtoversao(seqproduto,dataversao,nroversao)values(i.seqproduto, trunc(sysdate), 0);
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