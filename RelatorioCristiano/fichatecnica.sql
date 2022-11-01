FUNCTION DGEFR_FichaTecnicaProduto(nSeqProduto in DGE_PRODUTO.SeqProduto%Type, 
                                   nEmpresa ge_empresa.nroempresa%Type, 
                                   nAssinatura_1 string,
                                   nAssinatura_2 string,
                                   nAssinatura_3 string) RETURN CLob IS
                                   
    vSeqProduto         numeric;
    vErro               clob := null;
    cHTML               CLob := Null;
    vEmpresa            ge_empresa.nroempresa%TYPE := nEmpresa;
    sRazaoSocial        GE_Empresa.RazaoSocial%Type;
    vLogo               BLOB := NULL;
    vDataAtual          varchar2(10) := TO_CHAR(SYSDATE, 'DD/MM/YYYY'); 
-- Variaveis cidade inicio
    vRazaosocial        GE_Empresa.RAZAOSOCIAL%Type := null;
    vNomeFantasia       GE_Empresa.FANTASIA%Type := null;
    vCNPJ1              GE_Empresa.CNPJENTIDADE%Type := null;
    vCNPJ               varchar2(50):= null;  
    vDDD                GE_Empresa.TELEVENDASDDD%Type := null;
    vTelefone           GE_Empresa.TELEVENDASNRO%Type := null; 
    vLogradouro         GE_Empresa.endereco%Type := null; 
    vNumero             GE_Empresa.endereconro%Type := null; 
    vCep                GE_Empresa.cep%Type := null; 
    vCidade             GE_Empresa.cidade%Type := null; 
    vIE                 GE_Empresa.inscrestadual%Type := null;

-- FICHA TECNICA do produto
   vCodSif                       varchar2(500):= NULL;
   vGtinUnidadePadrao            varchar2(500):= NULL;
   vGtinMenorControle            varchar2(500):= NULL;
   vPdescricao                   varchar2(500):= NULL;
   vDesEmbalagemPrimaria         varchar2(500):= NULL;
   vDesEmbalagemSecundaria       varchar2(500):= NULL;
   vDipoa                        varchar2(500):= NULL;
   vValidade                     varchar2(500):= NULL;
   vConservacao                  varchar2(500):= NULL;
   vTempMinima                   varchar2(500):= NULL;
   vTempMaxima                   varchar2(500):= NULL;
   vSeqUnidadePatrao             varchar2(500):= NULL;    
   vUnidadePatrao                varchar2(500):= NULL;
   vPesoPadrao                   varchar2(500):= NULL;
   vPesoMedio                    varchar2(500):= NULL;
   vPesoMinimo                   varchar2(500):= NULL;
   vPesoMaximo                   varchar2(500):= NULL;
   vCodNcm                       varchar2(500):= NULL;
   vDescNcm                      varchar2(500):= NULL;
   vCodCest                      varchar2(500):= NULL;
   vDescCest                     varchar2(500):= NULL;
   vMaturado                     varchar2(500):= NULL;
   vCodClassFiscal               varchar2(500):= NULL;
   vTipoCalculoValidade          varchar2(50) := NULL;
   vFormulaProduto               varchar2(2000):= NULL;
  
-- DESCRIÇÃO DO PRODUTO
  vIdiomaTipoInd        varchar2(500);
  vDesTipoInd           varchar2(500);
  vIdiomaInd            varchar2(500);
  vDesInd               varchar2(500);
  
-- Especificação e caracteristicas do corte 
  vEspecificacaoProduto     varchar2(500);
  vCaracteristicaQualidade  varchar2(500);
  vCaracteristicaProcesso   varchar2(500);
  
-- IMAGEMSDO PRODUTO
   vCorteFrente             BLOB := NULL;
   vCorteVerso              BLOB := NULL;
   
   vProEmbPriFrente         BLOB := NULL;   
   vProEmbPriVerso          BLOB := NULL; 
   
   vProEmbSecFrente         BLOB := NULL; 
   vProEmbSecVerso          BLOB := NULL;
   
-- IMAGEM ETIQUETA 
   vEtiquetaPrimaria        BLOB := NULL; 
   vEtiquetaSecundaria      BLOB := NULL;
   
-- ESTILO DA CONDIÇÃO 
   vStyle                   CLOB:= NULL;
   
-- DESCRISAO DE PORSÃO MEDIA PA TABELA NUTRICIONAL
   vDescPorcaoMedia         varchar2(200);
   
-- VERSAO DO RELATORIO 
   vCodVersao               varchar(6):= NULL;
   vDataVersao              varchar(10):= NULL;
    
-- VARIAVEL DE DETALHES DA VERSAO DA TABELA VERSAO  
   vDetalhes                varchar2(5000):= NULL;
   vPossuidados             boolean;
BEGIN
  if nSeqProduto = 0 then 
    vSeqProduto := null;
   else
     vSeqProduto:= nSeqProduto;
  end if;
  
   --SELECT EMPRESA
BEGIN
              
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
      e.inscrestadual as ie,
      e.logo
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
      vIE,
      vLogo            
  FROM 
      GE_EMPRESA E  
  where 
      e.nroempresa = vEmpresa;
      
Exception 
  When others then
         
         vErro := sqlerrm;
END;

BEGIN
if vSeqProduto is not null then 
   --SELECT PORSAO MEDIA I 
   vPossuidados := false;
FOR I IN (
    select 
         p.descricao
    from 
         Dge_Produtocomposicao p
    where 
         p.seqproduto = nSeqProduto 
    and p.ordem = 1 )
LOOP
  vPossuidados := true;
vDescPorcaoMedia := i.descricao;
END LOOP;
if not vPossuidados then 
  vErro := 'sem porção média';
end if;

   --SELECT IMAGEM DAS ETIQUETAS
fOR I IN
          (Select
              me.imagem as img, PM.TIPO as tipo
           From
              DIN_ProdutoModeloEtiqueta@DTVIND01 Pm, DIN_ModeloEtiqueta@DTVIND01 Me
           Where 
              Me.SeqModeloEtiqueta = Pm.SeqModeloEtiqueta and Pm.SeqProduto = nSeqProduto)
      
      LOOP
       if I.TIPO = 1 THEN
        vEtiquetaPrimaria := i.img;
       else
        vEtiquetaSecundaria := i.img;
       end if;
      END LOOP;
      
   --SELECT IMAGENS DO PRODUTO 
begin

FOR I IN
    (SELECT 
       pa.seqproduto,               
       pa.seqprodutoanexo,
       AA.CODLINK,
       pa.codigo as ordem,
       pa.titulo,
       aa.descricao as descImg,
       aa.conteudo as img
    FROM dge_arquivoanexo aa, DGE_ProdutoAnexo pa
    WHERE aa.CodLink = pa.SeqProdutoAnexo
       AND aa.TabLink = 'DGE_PRODUTOANEXO'
       AND pa.SeqProduto = nSeqProduto                    
    ORDER BY pa.codigo)
               
    LOOP
         if i.ordem = 1 and i.descimg  = 'FRENTE' then
               vCorteFrente := i.img;
         elsif i.ordem = 1 and i.descimg  = 'VERSO' then
               vCorteVerso := i.img;
         
         elsif i.ordem = 2 and i.descimg  = 'FRENTE' then
               vProEmbPriFrente := i.img;
         elsif i.ordem = 2 and i.descimg  = 'VERSO' then
               vProEmbPriVerso := i.img;
         
         elsif i.ordem = 3 and i.descimg  = 'FRENTE' then
               vProEmbSecFrente := i.img;
         elsif i.ordem = 3 and i.descimg  = 'VERSO' then
               vProEmbSecVerso := i.img;         
         END if;  
           
    END LOOP;
    

end;
    
   --SELECT FICHA TECNICA
for z in(
SELECT
     (select E.codservico from DGE_EMPRESACOMPL E WHERE E.NROEMPRESA = 1) AS SIF,
     lpad(pe.gtin,14,0) as gtinUnidadePadrao,
     (select lpad(pe.gtin,14,0) from DGE_PRODUTOEMBALAGEM pe where pe.seqproduto  = nSeqProduto and pe.menorunidcontrole = 'S') as gtinMenorControle, 
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
     C.CODCLASSFISCAL,
     NVL(FORMULA,0) as formula
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
    AND P.SEQPRODUTO = nSeqProduto
    )
loop
    vCodSif := z.sif;
    vGtinUnidadePadrao := z.gtinunidadepadrao; 
    vGtinMenorControle := z.gtinmenorcontrole;
    vPdescricao := z.descproduto;
    vDesEmbalagemPrimaria := z.embprimaria; 
    vDesEmbalagemSecundaria := z.embsecundaria;
    vDipoa := z.dipoa;
    vValidade := z.validade;
    vConservacao := z.conservacao;
    vTempMinima := z.tempminima;
    vTempMaxima := z.tempmaxima;
    vSeqUnidadePatrao := z.sequnipadrao;
    vUnidadePatrao := z.unidade;
    vPesoPadrao := z.pesopadrao; 
    vPesoMedio := z.pesomedio; 
    vPesoMinimo := z.pesominimo; 
    vPesoMaximo := z.pesomaximo;
    vCodNcm := z.ncm; 
    vDescNcm := z.desncm;
    vCodCest := z.cest; 
    vDescCest := z.descricaocest;
    vMaturado:= z.maturado;
    vCodClassFiscal:= z.codclassfiscal;
    vFormulaProduto := z.formula;
end loop;
/*BEGIN
SELECT
     (select E.codservico from DGE_EMPRESACOMPL E WHERE E.NROEMPRESA = 1) AS SIF,
     lpad(pe.gtin,14,0) as gtinUnidadePadrao,
     (select lpad(pe.gtin,14,0) from DGE_PRODUTOEMBALAGEM pe where pe.seqproduto  = nSeqProduto and pe.menorunidcontrole = 'S') as gtinMenorControle, 
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
     C.CODCLASSFISCAL,
     NVL(FORMULA,0)
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
    vPesoPadrao, vPesoMedio, vPesoMinimo, vPesoMaximo,
    vCodNcm, vDescNcm,
    vCodCest, vDescCest,
    vMaturado,
    vCodClassFiscal,
    vFormulaProduto
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
    
    

Exception     
    When Others Then
      
      vErro  := '<div class="callout">Codigo do Produto é um campo de preenchimento obrigatório.</div>';
    
    
END;*/
                          
   -- DESCRIÇÃO DO PRODUTO                                            
for I in       
        (SELECT 
        x.DESCRICAO as idioma, 
        PD.TIPODESCRICAO,
        DP.DESCRICAO,
        x.SEQIDIOMA as seq                     
        FROM                       
        DGE_PRODUTODESCRICAO PD,
        DGE_IDIOMA x,
        DGE_DESCRICAOPRODUTO DP
        WHERE 
        PD.SEQIDIOMA = x.SEQIDIOMA
        AND DP.SEQDESCRICAO = PD.SEQDESCRICAO
        AND PD.TIPODESCRICAO IN (5,4) 
        AND PD.SEQPRODUTO = nSeqProduto) 
  loop
      if i.seq =  19336 then
        vEspecificacaoProduto := i.descricao;
        elsif i.seq =  19334 then
        vCaracteristicaQualidade := i.descricao;
        elsif i.seq =  19335 then
        vCaracteristicaProcesso := i.descricao;                       
      else 
        if i.TIPODESCRICAO = 4 THEN 
          vIdiomaInd := i.idioma;
          vDesInd:= i.descricao;
        else  
          vIdiomaTipoInd := i.idioma;
          vDesTipoInd:= i.descricao;
        end if;
      end if;
      
  end loop;                  

   --SELECT PADRAO DE VALIDADE 
BEGIN
select 
   DECODE(PP.TIPOVALIDADE,1,'ABATE',2,'DESOSSA') as calculoValiade 
   into 
   vTipoCalculoValidade
from DGE_PRODUTOPLANTA  PP 
WHERE PP.SEQPRODUTO = nSeqProduto;
END;   

   -- FOR PARA GRAVAR VERSAO E DATA NA FINHA TECNICA 
for i in
  (SELECT 
      TO_CHAR(p.dataversao, 'DD/MM/YYYY') as dataVersao,
      TO_CHAR(p.nroversao,'000') as nroversao
   FROM 
      DTVIND_PRODUTOVERSAO p 
   WHERE 
      p.seqproduto = nSeqProduto
      and p.nroversao = (select 
                            max(nroversao) 
                         from 
                            DTVIND_PRODUTOVERSAO))
loop
  vDataVersao := i.dataVersao;
  vCodVersao := i.nroversao;
end loop;    

--=========== CONDIÇÕES DE OCULTAMENTO DE INFORMAÇÃO =============== 

  --CONDIÇÃO INFORMAÇÃO NUTRICIONAL
for i in (
        select 
              count(p.ordem) as coluna 
        from  Dge_Produtocomposicao p
        where p.seqproduto = nSeqProduto 
              and p.ordem > 1  
        order by p.ordem
        )
      loop
        if i.coluna = 0 then
           vStyle:= '
             <style>
                    .oculta{display:none;}
                    @media print{.oculta{display:none;}}
             </style>
           ';
        end if; 
      end loop;

  --CONDIÇÃO FORMULA DO PRODUTO
for i in
  (select
        count(formula) AS x 
     from 
        dge_produto 
     where 
        seqproduto = nSeqProduto)
  loop
    if i.x = 0 then
     vStyle:= vStyle||'
               <style>
                      .oculta-formula{display:none;}
                      @media print{.oculta-formula{display:none;}}
               </style>
     ';
    end if; 
    
  end loop;     

 --CONDIÇÃO PARA ASSINATURA 
begin 
  --se campo assinatura for = nulo ele apagao compo 
  IF nAssinatura_1 is null then 
  
   vStyle:= vStyle||'
               <style>
                      .assinatura-1{display:none;}
                      @media print{.assinatura-1{display:none;}}
               </style>
     ';
   
  end if;
  IF nAssinatura_2 is null then 
   
   vStyle:= vStyle||'
               <style>
                      .assinatura-2{display:none;}
                      @media print{.assinatura-2{display:none;}}
               </style>
     ';
   
  end if;
  IF nAssinatura_3 is null then 
   
   vStyle:= vStyle||'
               <style>
                      .assinatura-3{display:none;}
                      @media print{.assinatura-3{display:none;}}
               </style>
     ';
   
  end if;
end;   

end if; 
END; 
 --============ INICIO HTML ====================
begin
if vSeqProduto is null then 
  vErro := '<p>Código do produto não foi informado.</P>
            <p>Informe o código do produto e tente novamente.</p> ';
  cHTML := cHTML||'
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Erro FichaTecnica</title>
    
        <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/bootstrap.css" />
        <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" />    
        '||vStyle||' 
    
</head>

<body class="text-uppercase">

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
                            <div>Nº de Revisão: </div>
                        </div>
                        <div class="col-6">
                            <div>'||vDataAtual||'</div>
                            <div>'||vDataVersao||'</div>
                            <div>'||vCodVersao||'</div>
                        </div>
                    </div>
                </div>

                <div class="row "> <!-- TITULO FORMULARIO -->
                    <div class="col fs-5 text-center border-top fw-bold">
                        <p>Ficha técnica do produto</p>
                    </div>
                </div><!-- fim row-->

            </div><!-- fim cabesalho-->
            
            <div class="alert alert-warning d-flex align-items-center" role="alert">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2" viewBox="0 0 16 16" role="img" aria-label="Warning:">
                <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
              </svg>
              <div>
                  '||vErro||'             
              </div>
            </div>

    </div><!--fim A4 Page1-->
    
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
</body>

</html>';
  else
cHTML := cHTML ||'
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FichaTecnica</title>
    
        <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/bootstrap.css" />
        <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" />    
        '||vStyle||'
</head>

<body class="text-uppercase">

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
                            <div>'||vDataAtual||'</div>
                            <div>'||vDataVersao||'</div>
                            <div>'||vCodVersao||'</div>
                        </div>
                    </div>
                </div>

                <div class="row "> <!-- TITULO FORMULARIO -->
                    <div class="col fs-5 text-center border-top fw-bold">
                        <p>Ficha técnica do produto</p>
                    </div>
                </div><!-- fim row-->

            </div><!-- fim cabesalho-->
        <!-- #################### --- FIM bloco 1 -- ################################  -->

        <!-- #################### --- INICIO bloco 2 -- ################################  -->
        <div class="row text-center fw-bold border border-2"> <!--  DESCRISAO PRODUTO -->
            <div class="col-1 my-auto text-alert">
                Produto
            </div>
            <div class="col text-center my-auto fs-2 border-end border-start text-alert" >
                '||To_char(nSeqProduto)||'-'||vPdescricao||'
            </div>
            <div class="col-3 my-auto">
                <div class="row my-0 ">
                    <div class="fs-1" style="color:#084298">'||vConservacao||'</div>
                    <div class=""> Temperatura Mínima: '||vTempMinima||'</div>
                    <div class=""> Temperatura Máxima: '||vTempMaxima||'</div>                    
                </div>
            </div>
        </div>

        <div class="row"> <!-- row descrições do produto -->
            <div class="col-12 zebra">
                <div class="row border-dark mt-1">
                    <div class="col-2  fw-bold ">
                        <p class="my-auto">Industrial</p>
                    </div>
                    <div class="col-2  ">
                        <p>'||vIdiomaInd||'</p>
                    </div>
                    <div class="col-8  ">
                        <p>'||vDesInd||'</p>
                    </div>
                </div>
                <div class="row border-dark  mt-1">
                    <div class="col-2  fw-bold ">
                        <p class="my-auto">TipoIndustrial</p>
                    </div>
                    <div class="col-2  ">
                        <p>'||vIdiomaTipoInd||'</p>
                    </div>
                    <div class="col-8  ">
                        <p>'||vDesTipoInd||'</p>
                    </div>
                </div>
                <div class="row border-dark mt-1">
                    <div class="col-2 fw-bold ">
                        <p class="my-auto">NCM</p>
                    </div>
                    <div class="col-2 ">
                        <p>'||vCodNcm||'</p>
                    </div>
                    <div class="col-8 ">
                        <p>'||vDescNcm||'</p>
                    </div>
                </div>
                <div class="row border-dark  mt-1">
                    <div class="col-2  fw-bold ">
                        <p class="my-auto">CEST</p>
                    </div>
                    <div class="col-2 ">
                        <p>'||vCodCest||'</p>
                    </div>
                    <div class="col-8  ">
                        <p>'||vDescCest||'</p>
                    </div>
                </div>
            </div>
        </div> <!-- fim row descrições do produto -->

        <!-- #################### --- FIM bloco 2 -- ################################  -->
        <!-- #################### --- INICIO bloco TABELA INFORMAÇÃO -- ################################  -->

        <div class="row">
            <!-- #################### --- FIM tabela  Informações nutricional  -- ################################  -->
            <div class="col oculta">
                <div class="caixa">
                    <div class="distaca fs-5 fw-bold text-center">
                        Informações nutricionais
                    </div>
                    <div class="bg-alert fs-5 text-center">
                        '||vDescPorcaoMedia||'
                    </div>
                    <div class="row">
                        <div class="mx-auto col-12">
                            <table class="table align-middle table-bordered border table-striped">
                                <thead>                                    
                                    <tr class="text-center">                                        
                                        <th width="150px">descrição</th>
                                        <th width="50">quantidade</th>
                                        <th width="90">%Valor Diária</th>
                                    </tr>
                                </thead>
                                <tbody class="text-break">';
                                    FOR i IN
                                         (select 
                                            p.ordem,
                                            p.descricao,
                                            p.referencia as quantidade,
                                            p.vlrpercdiario as diario
                                          from 
                                            Dge_Produtocomposicao p
                                          where 
                                            p.seqproduto = nSeqProduto 
                                            and p.ordem > 1 
                                          order by p.ordem)
                                    LOOP
                                    cHTML := cHTML||'
                                    <tr>
                                        <td>
                                            <p>'||TO_CHAR(I.DESCRICAO)||'</p>
                                        </td>
                                        <td class="text-center">'||TO_CHAR(I.QUANTIDADE)||'</td>
                                        <td class="text-center">'||TO_CHAR(I.DIARIO)||'</td>

                                    </tr>
                                    ';
                                    END LOOP;
                                    cHTML := cHTML||'
                                </tbody>
                            </table>
                        </div>
                    </div> <!--fim Row --->
                </div> 
            </div> <!-- fim informação nutricional --->
            <!-- #################### --- FIM TABELA -- ################################  -->
            <!-- #################### --- INICIO TABELA INFORMASAO GERAL -- ################################  -->

            <div class="col">
                <div class="caixa">
                    <div class="distaca fs-5 fw-bold text-center">
                        Informações Gerais
                    </div>
                    <div class="row">
                        <div class="mx-auto col-12">

                            <table class="table align-middle table-bordered border table-striped">

                                <tbody class="text-break">

                                    <tr>
                                        <th scope="row">
                                            <p>Código GTIN:</p>
                                        </th>
                                        <td>
                                            <p>'||vGtinUnidadePadrao||'</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">
                                            <p>Código DIPOA:</p>
                                        </th>
                                        <td>
                                            <p>'||vDipoa||'</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">
                                            <p>Código SIF:</p>
                                        </th>
                                        <td>
                                            <p>'||vCodSif||'</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">
                                            <p>Validade:</p>
                                        </th>
                                        <td>
                                            <p>'||vValidade||'</p>
                                        </td>
                                    </tr>                                   
                                    <tr>
                                        <th scope="row">
                                            <p>Emb. Padrão:</p>
                                        </th>
                                        <td>
                                            <p>'||vUnidadePatrao||'</p>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th scope="row">
                                            <p>Maturado:</p>
                                        </th>
                                        <td>
                                            <p class="fw-bold text-alert">'||vMaturado||'</p>
                                        </td>
                                    </tr>
                                    <tr class="oculta-formula">
                                        <td colspan="2">
                                            <p>
                                             <b>Formula: </b>
                                             '||vFormulaProduto||'
                                            </p>
                                        </td>
                                    </tr>

                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
            <!-- #################### --- FIM TABELA INFORMASAO GERAL -- ################################  -->
        </div> <!--fim Row informações gerais --->


        <!-- #################### --- INICIO bloco 3 -- ################################  -->
        <!-- #################### --- INICIO bloco 3 -- ################################  -->

        
        <div class="row mx-0">
            <div class="col distaca text-center fw-bold border border-white fs-5">Embalagem</div>
        </div><!--fim row-->
             
        <div class="row row-cols-5 mb-0 mx-0"><!-- informações gerais padrao 2 com distaca -->
              
           <div class="col distaca text-center  px-1 border border-white">
               <div class="fw-bold ">cod gtin</div>
               <div class="bg-white mb-1 ">
                   '||vGtinMenorControle||'
               </div>
           </div>            
           <div class="col distaca text-center  px-1 border  border-white">
               <div class="fw-bold ">Peso Mínimo</div>
               <div class="bg-white mb-1 ">
                   '||vPesoMinimo||'
               </div>
           </div>
           <div class="col distaca text-center  px-1 border border-white">
               <div class="fw-bold ">Peso Máximo</div>
               <div class="bg-white mb-1 ">
                   '||vPesoMaximo||'
               </div>
           </div>
           <div class="col distaca text-center  px-1 border border-white">
               <div class="fw-bold ">Peso Medio</div>
               <div class="bg-white mb-1 ">
                   '||vPesoMedio||'
               </div>
           </div>
           <div class="col distaca text-center  px-1  border border-white">
               <div class="fw-bold ">Peso padrão</div>
               <div class="bg-white mb-1 fw-bold  text-alert">
                   '||vPesoPadrao||'
               </div>
           </div>
           
           
        </div><!--fim row-->

        <div id="embalagem" class="row">  <!-- #################### --- FIM tabela ENBALAGEM PRIMARIA -- ################################  -->
            <div class="col-12">
                <div class="caixa">
                    <div class="distaca fs-5 fw-bold text-center">
                        Insumos para cadastrar a tara da embalagem primária
                    </div>
                    <div class="row">
                        <div class="mx-auto col-12">

                            <table class="table align-middle table-bordered border">
                                <thead>
                                    <tr class="text-center">
                                        <th width="50px">Código</th>
                                        <th width="200px">Descrição</th>
                                        <th width="50">Insumo</th>
                                        <th width="50">Unidade</th>
                                    </tr>
                                </thead>
                                <tbody class="text-break">
                                    ';
                                    FOR i IN
                                          (select 
                                              p.seqproduto as CÓDIGO,p.descricao as descrição,
                                              decode(e.seqembalagemkititemsubst, null,'PRINCIPAL','SUBSTITUTO') as Insumo,
                                              EM.unidade||'('||EM.quantidade||')' as Unidade
                                          from dge_produto P,dge_embalagemkitinsumo E, dge_PRODUTOEMBALAGEM EM
                                          where 
                                              (E.Seqprodutodestino = nSeqProduto or E.seqprodutodestino is null)
                                              and E.tipo in(1) and P.Seqproduto = E.Seqproduto and Em.Seqproduto = P.Seqproduto
                                              and Em.embalagemindustriapadrao = 'S'
                                              and E.seqembalagemkit = (select 
                                                                         kt.seqembalagemkit 
                                                                       from 
                                                                         dge_PRODUTOEMBALAGEM
                                                                         PO,dge_produtoembalagemkit KT 
                                                                       where 
                                                                         PO.Seqproduto = nSeqProduto 
                                                                         and PO.embalagemindustriapadrao = 'S' 
                                                                         and KT.seqembalagem = vSeqUnidadePatrao)
                                          order by Insumo)
                                    
                                    LOOP
                                        if i.insumo = 'SUBSTITUTO' then
                                            cHTML := cHTML||'
                                            <tr class="text-danger">
                                                <th scope="row" class="text-end">'||TO_CHAR(i.código)||'</th>
                                                <td>
                                                    <p>'||TO_CHAR(i.descrição)||'</p>
                                                </td>
                                                <td class="text-center">'||TO_CHAR(i.insumo)||'</td>
                                                <td class="text-center">'||TO_CHAR(i.unidade)||'</td>
                                            </tr>
                                            ';
                                        else
                                            cHTML := cHTML||'
                                            <tr>
                                                <th scope="row" class="text-end">'||TO_CHAR(i.código)||'</th>
                                                <td>
                                                    <p>'||TO_CHAR(i.descrição)||'</p>
                                                </td>
                                                <td class="text-center">'||TO_CHAR(i.insumo)||'</td>
                                                <td class="text-center">'||TO_CHAR(i.unidade)||'</td>
                                            </tr>
                                            ';
                                        END IF;
                                    END LOOP;

                                    cHTML := cHTML||'
                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
        </div><!-- #################### --- FIM tabela  ENBALAGEM PRIMARIA -- ################################  -->
       
        <div id="embalagem" class="row">  <!-- #################### --- inicio tabela ENBALAGEM SECUNDARIA-- ################################  -->
            <div class="col-12">
                <div class="caixa">
                    <div class="distaca fs-5 fw-bold text-center">
                        Insumos para cadastrar a tara da embalagem secundaria
                    </div>
                    <div class="row">
                        <div class="mx-auto col-12">

                            <table class="table align-middle table-bordered border">
                                <thead>
                                    <tr class="text-center">
                                        <th width="50px">Código</th>
                                        <th width="200px">Descrição</th>
                                        <th width="50">Insumo</th>
                                        <th width="50">Unidade</th>
                                    </tr>
                                </thead>
                                <tbody class="text-break">
                                    ';
                                    FOR i IN
                                          (select 
                                              p.seqproduto as CÓDIGO,p.descricao as descrição,
                                              decode(e.seqembalagemkititemsubst, null,'PRINCIPAL','SUBSTITUTO') as Insumo,
                                              EM.unidade||'('||EM.quantidade||')' as Unidade
                                          from dge_produto P,dge_embalagemkitinsumo E, dge_PRODUTOEMBALAGEM EM
                                          where 
                                              (E.Seqprodutodestino = nSeqProduto or E.seqprodutodestino is null)
                                              and E.tipo in(2) and P.Seqproduto = E.Seqproduto and Em.Seqproduto = P.Seqproduto
                                              and Em.embalagemindustriapadrao = 'S'
                                              and E.seqembalagemkit = (select 
                                                                         kt.seqembalagemkit 
                                                                       from 
                                                                         dge_PRODUTOEMBALAGEM
                                                                         PO,dge_produtoembalagemkit KT 
                                                                       where 
                                                                         PO.Seqproduto = nSeqProduto 
                                                                         and PO.embalagemindustriapadrao = 'S' 
                                                                         and KT.seqembalagem = vSeqUnidadePatrao)
                                          order by Insumo)
                                    
                                    LOOP
                                        if i.insumo = 'SUBSTITUTO' then
                                            cHTML := cHTML||'
                                            <tr class="text-danger">
                                                <th scope="row" class="text-end">'||TO_CHAR(i.código)||'</th>
                                                <td>
                                                    <p>'||TO_CHAR(i.descrição)||'</p>
                                                </td>
                                                <td class="text-center">'||TO_CHAR(i.insumo)||'</td>
                                                <td class="text-center">'||TO_CHAR(i.unidade)||'</td>
                                            </tr>
                                            ';
                                        else
                                            cHTML := cHTML||'
                                            <tr>
                                                <th scope="row" class="text-end">'||TO_CHAR(i.código)||'</th>
                                                <td>
                                                    <p>'||TO_CHAR(i.descrição)||'</p>
                                                </td>
                                                <td class="text-center">'||TO_CHAR(i.insumo)||'</td>
                                                <td class="text-center">'||TO_CHAR(i.unidade)||'</td>
                                            </tr>
                                            ';
                                        END IF;
                                    END LOOP;

                                    cHTML := cHTML||'
                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
        </div><!-- #################### --- FIM tabela  ENBALAGEM SEGUNDARIA -- ################################  -->


    </div><!--fim A4 Page1-->
    <div id="Page2" class="A4">
        <!-- #################### --- INICIO bloco 5 -- ################################  -->
        <div class="row text-center  fs-4 caixa mx-0 mb-2">
            <div class="distaca fw-bold">Especificação do produto</div>
            <p>'||vEspecificacaoProduto||'</p>
            <div class="col-6">
                <div class="row">
                    <div class="distaca fw-bold ">Catacterística de qualidade</div>
                    <p>'||vCaracteristicaQualidade||'</p>
                </div>
            </div>
            <div class="col-6 border-start">
                <div class="row">
                    <div class="distaca fw-bold">Catacterística de processo</div>
                    <p>'||vCaracteristicaProcesso||'</p>

                </div>
            </div>
        </div>
        <div class="row text-center fw-bold fs-5 caixa mx-0 mb-2">
            <div class="distaca ">Foto corte do produto</div>
            <div class="col-6">
                <div class="row">
                    <div class="col">
                        <img class="img-fluid foto"
                            src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vCorteFrente)|| '" alt="" />
                    </div>
                </div>
            </div>
            <div class=" col-6 border-left">
                <div class="row">
                    <div class="col">
                        <img class="img-fluid foto"
                            src="data:image/png;base64,'||DPKG_Library.DGEF_ImagemBase64(vCorteVerso)||'" alt="" />
                    </div>
                </div>
            </div>
        </div>
        <div class="row caixa mx-0 mb-2">
            <div class=" distaca text-center fw-bold mb-2 fs-4">
                <p class="distaca">Descrição de embalagens</p>
            </div>
            <div class=" col-8 text-center fw-bold">
                <p class="distaca">Produto na embalagem primária</p>
            </div>
            <div class=" col-4 fw-bold text-center">
                <p class="distaca">Descrição</p>
            </div>


            <div class="col-8 ">

                <div class="row">
                    <div class="col-6">
                        <img class="img-fluid foto"
                            src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vProEmbPriFrente)|| '"
                            alt="" />
                    </div>
                    <div class="col-6">
                        <img class="img-fluid foto"
                            src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vProEmbPriVerso)|| '"
                            alt="" />
                    </div>
                </div>

            </div>

            <div class="col-4 my-auto text-center">

                <p>'||vDesEmbalagemPrimaria||'</p>

            </div>
            <div class=" col-8 text-center fw-bold">
                <p class="distaca">Produto embalagem secundária</p>
            </div>
            <div class=" col-4 fw-bold text-center">
                <p class="distaca">Descrição</p>
            </div>
            <div class="col-8 ">
                <div class="row">
                    <div class="col-6">
                        <img class="img-fluid foto"
                            src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vProEmbSecFrente)|| '"
                            alt="" />
                    </div>
                    <div class="col-6">
                        <img class="img-fluid foto"
                            src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vProEmbSecVerso)|| '"
                            alt="" />
                    </div>
                </div>
            </div>

            <div class="col-4 my-auto text-center">
                <p>'||vDesEmbalagemSecundaria||'</p>
            </div>

        </div>
        <!-- #################### --- FIM bloco 5 -- ################################  -->
    </div><!--fim A4 Page2-->
    <div id="Page3" class="A4">        
        <div class="row mb-1">
            <div class="col-12">

                <div class="caixa">
                    <div class="distaca fs-5 fw-bold text-center">
                        Modelo de Etiqueta Interna: imagem meramente ilustrativa
                    </div>
                    <div class="row">
                        <div class="mx-auto" style="width:auto">
                            <img class="foto img-fluid  "
                                src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vEtiquetaPrimaria)|| '" />
                        </div>                        
                    </div>
                </div>
            </div>
        </div>
        <div class="row mb-1">
            <div class="col-12">
                <div class="caixa">
                    <div class="distaca fs-5 fw-bold text-center">
                        Modelo da etiqueta testeira: imagem meramente ilustrativa
                    </div>
                    <div class="row">
                        <div class="mx-auto " style="width:auto">
                            <img class="  foto img-fluid mx-auto  "
                                src="data:image/png;base64,'||DPKG_Library.DGEF_ImagemBase64(vEtiquetaSecundaria)|| '" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <div class="row mb-1">
            <div class="col fs-5">
                <div class="caixa">
                    <p>
                        Data de Produção: Data de embalagem do produto ('||vTipoCalculoValidade||')
                    </p>
                    <p>
                        Data de Embalagem: Data de embalagem do produto ('||vTipoCalculoValidade||')
                    </p>
                    <p>
                        Data de Validade: Contar a partir da data de embalagem do produto ('||vTipoCalculoValidade||')
                    </p>
                    <P>
                        Código de Rastriabilidade: SIF ABATEDOURO + DATA DE ABATE + ØØØØ
                    </P>
                    <P>
                        Shipping Mark: Imformado pelo Cliente.
                    </P>
                </div>
            </div>
        </div>
        <!-- #################### --- FIM bloco 9 -- ################################  -->
    </div><!--fim A4 Page3-->
    <div id="Page4" class="A4"> 
         <div id="embalagem" class="row">  <!-- #################### --- inicio tabela VERSAO-- ################################  -->
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
                                        <th width="50">Usuario</th>
                                        <th width="50">Data</th>
                                        <th width="50">Hora</th>
                                        <th width="200px">Descrição</th>
                                    </tr>
                                </thead>
                                <tbody class="text-break">
                                    ';
                                FOR i IN
                                   (
                                    SELECT
                                       *
                                    FROM(
                                                                      
                                   select
                                       (select MAX(nroversao) from DTVIND_PRODUTOVERSAO xPv WHERE xPv.dataversao = o.data and  O.CODLINK = xPv.SEQPRODUTO ) as nroversao,
                                       o.usuarioos, o.codusuario, o.data, Replace(Trim(To_char(o.Hora, '00,00,00')), ',', ':') as hora, o.detalhe as descricao
                                    FROM 
                                       DGE_OCORRENCIA o                                             
                                    WHERE                                                                                        
                                       o.motivo = 'ALTERAÇÃO FICHA TECNICA'
                                       AND O.CODLINK = nSeqProduto)
                                     WHERE 
                                        Data >= '26-oct-2022'
                                     ORDER BY
                                        NroVersao
                                    )                                                                              
                                LOOP
                                                                   
                                   cHTML := cHTML||'
                                   <tr>
                                      <th class="text-center ">'||TO_CHAR(i.nroversao,'000')||'</th>
                                      <td class="text-center ">'||TO_CHAR(i.codusuario)||'</td>
                                      <td class="text-center ">'||TO_CHAR(i.data, 'DD/MM/YYYY')||'</td>
                                      <td class="text-center ">'||TO_CHAR(i.hora)||'</td>
                                      <td>
                                         <p>'||TO_CHAR(i.descricao)||'</p>
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
        
        <div class="row justify-content-md-center mt-5"> <!--  # inicio compos de assinatura #  -->  
                 
                <div class="col-3 assinatura-1">
                    <p class="border-top border-2 text-center">'||nAssinatura_1||'</p> 
                </div>

                <div class="col-3 assinatura-2">
                    <p class="border-top border-2 text-center">'||nAssinatura_2||'</p> 
                </div>

                <div class="col-3 assinatura-3">
                    <p class="border-top border-2 text-center">'||nAssinatura_3||'</p> 
                </div>                 
                        
        </div> <!--  # fim compos de assinatura #  --> 
        
    </div><!--fim A4 Page4-->    
    
    <script src="../../../../../../bootstrap-5.2.2-dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    
</body>

</html>';
end if;
RETURN(cHTML); 
end;
    RETURN(cHTML);     
      
Exception

  When Others Then
      
    Return (cHTML ||'errr caskdnckajsnd asdfasdfas');

END DGEFR_FichaTecnicaProduto;
