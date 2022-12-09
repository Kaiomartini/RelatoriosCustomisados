CREATE OR REPLACE Package Body DPKG_RELHTML Is

/******************************************************/
/*Function que retorna o cabelaçalho HTML do relatório*/
/******************************************************/
   Function DGEF_CabecalhoHTML(psNomeRelatorio String,
                               pnNroEmpresa GE_Empresa.NroEmpresa%Type) Return CLob Is
  
      cHTML CLob := Null;
      bLogo BLob := Null;
      sRazaoSocial GE_Empresa.RazaoSocial%Type;

   Begin
      Select
         RazaoSocial, Logo
      Into
         sRazaoSocial, bLogo
      From
         GE_Empresa E
      Where
         E.NroEmpresa = pnNroEmpresa;
         
      -- Monta do Cabeçalho dos relatórios
      cHTML := cHTML||'<html>';
      cHTML := cHTML||'<head>';
      cHTML := cHTML||'<meta charset="utf-8">';
      cHTML := cHTML||'<style type="text/css">';
      -- Linha duplicada para que o relatório seja visualizado corretamente tanto na emissão em desktop quanto na emissão no webDatavale
      cHTML := cHTML||'html { width: 50%; background-color: #f2f4f8; margin: 0 auto; overflow-x: hidden; }';
      cHTML := cHTML||'#grpVisualizarRelatorio { width: 50%; background-color: #f2f4f8; margin: 0 auto; overflow-x: hidden; }';
      cHTML := cHTML||'@media (max-width: 900px) {html {width: 100%;}}';
      cHTML := cHTML||'@media (max-width: 900px) {#grpVisualizarRelatorio {width: 100%;}}';
      --
      cHTML := cHTML||'</style>';
      cHTML := cHTML||'</head>';
      cHTML := cHTML||'<body style="margin: 0;">';
      cHTML := cHTML||'<div style="background-color: #fff;">';
      cHTML := cHTML||'<table style="text-align: center; width: 100%; margin-bottom:10px;" cellpadding=1 cellspacing=0>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th style="border-right: 0px; width:200px;"><img height="83" src="data:image/png;base64, ';
      cHTML := cHTML||DPKG_Library.DGEF_ImagemBase64(bLogo);
      cHTML := cHTML||' "alt="'||sRazaoSocial||'" title="'||sRazaoSocial||'" vspace="0px" hspace="0px" border="0px" align="center"/>';
      cHTML := cHTML||'<th style="font-size: 26px; text-align: center; font-style: italic; text-decoration: underline;">'||psNomeRelatorio||'</th>';
      cHTML := cHTML||'<th style="font-size: 12px; width:100px;">';
      cHTML := cHTML||TO_CHAR(SYSDATE, 'DD/MM/YYYY')||'<br/>';
      cHTML := cHTML||TO_Char(SYSDATE, 'hh24:MI:ss');
      cHTML := cHTML||'</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'</table>';
     
      Return(cHTML);
        
   End DGEF_CabecalhoHTML;

/********************************************/
/*Function que retorna o rodape do Relatório*/
/********************************************/
   Function DGEF_RodapeHTML Return CLob Is

      cHTML CLob := Null;

    Begin
      cHTML := cHTML||'<table style="width: 100%; border-top: 1px solid; margin-top:10px;">';
      cHTML := cHTML||'<tr border=1>';
      cHTML := cHTML||'<td style="padding-left: 5px;"><i>Datavale Tecnologia & Sistemas</i></td>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'</table>';
      cHTML := cHTML||'</div>';
      cHTML := cHTML||'</body>';
      cHTML := cHTML||'</html>';

    Return(cHTML);

   End DGEF_RodapeHTML;
/*******************************************************/
/*       Téla de erros ficha técnica do produto      */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 17/11/2022 *************************/
/*******************************************************/
   
Function DGEF_ErroFichaTecnicaHTML(nErro string,
                                   nEmpresa ge_empresa.nroempresa%Type,
                                   nSeqProduto in DGE_PRODUTO.SeqProduto%Type
                                   ) Return CLob is
                                      

    cHTML               CLob := Null;
   
Begin    

  
cHTML := cHTML ||'
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Erro FichaTecnica</title>
    
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
        <!--<link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" /> -->
        <style>'||DGEF_FichaTecnicaCss()||'</style>
    
</head>

<body class="text-uppercase">

    <div id="Page1" class="A4">
       '||DGEF_CabecalhoFichaTecnica('',2,nSeqProduto,nEmpresa)||'
       
      <div class="alert alert-warning d-flex align-items-center" role="alert">
         <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2" viewBox="0 0 16 16" role="img" aria-label="Warning:">
            <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"></path>
         </svg>
         <div>
             <p class="fw-bold">'||nErro||'</P>                                   
         </div>
      </div>
    </div><!--fim A4 Page1-->
    
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
</body>

</html>';


  return (cHTML);
end DGEF_ErroFichaTecnicaHTML; 
                                       
/*******************************************************/
/*       style css da ficha técnica do produto      */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 17/11/2022 *************************/
/*******************************************************/   
Function DGEF_FichaTecnicaCss Return CLob is 


      cHTML CLob := Null;

    Begin
      cHTML := cHTML||'
                  html {
                font-size: 11px;
            }
            .logo {
                width: 100%;
                height: 70px;
            }
            
            @page {
                margin: 3mm ;
            }
            .A4 {
                box-shadow: 0 .5mm 2mm rgba(0, 0, 0 / 22%);
                margin: 3mm auto;
                width: 220mm;
                padding: 5mm 5mm;
                background-color: #fff;

            }
            .th-x >th{
            min-width:100px;
            }
            #btModal{
            
            position: fixed;
            top: 20px;
            left: 20px;
            }
            #cabecalho {
                /*box-shadow: 0 .5mm 2mm rgba(0, 0, 0);*/
                margin: 0mm auto;
                width: 210mm;
                padding: 0mm 0mm;
               
            }

            .pquebra {
                overflow-wrap: break-word;
                word-wrap: break-word;
                word-break: break-word;
            }
            .distaca {
                background-color: #ddd;
                

            }
            .foto {
                   margin: 5px auto 5px auto;
                   max-height: 122px;
                   min-height: 0;
                   width: 100%;
                   height: auto;
            }

            }
            .caixa {border: 2px solid #ddd;}
            .caixat {
                border: 1px solid #9b9999;
                margin-bottom: 20px;
                box-shadow: -5px 5px 0px #666;
                background-color: #ddd;
            }
            .caixa-etiqueta { height: 250px;}
            p {
                margin: 0px;
                padding: 0px 5px 0px 5px;
            }
            .border {
                border-color: rgb(19, 19, 19);
                border: 2px solid #000;
            }
            .table>:not(caption)>*>* {padding: .0 0.5rem;}
            
            #Info.table>:not(caption)>*>* {padding: .5 0.5rem;}
            .table {  margin: 0px;}
            .text-alert{color:#ff2c2c}

            /*.zebra>div:nth-child(even) {
            background: rgba(0, 0, 0, 0.05);;
                  }*/
                  
           @media print {
                          .caixa {
                              page-break-inside: avoid;
                          }

                          .naoquebra {
                              page-break-inside: avoid;
                          }

                          .A4 {
                              page-break-before: always;
                              margin: 0px;
                              width: 210mm;
                              padding: 0mm 0mm;
                              box-shadow: none ;
                          }
                          
                          #btModal{
                          display: none;
                          }
                          
                          .apagar-print{
                             display: none;
                          }
                          
                        }
                        
                  ';

    Return(cHTML);

   End DGEF_FichaTecnicaCss;

/*******************************************************/
/*Function que retorna o cabelaçalho HTML do relatório */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 27/10/2022 *************************/
/*******************************************************/
Function DGEF_CabecalhoFichaTecnica(nNomeRelatorio string,
                               nTipo numeric,
                               nSeqProduto in DGE_PRODUTO.SeqProduto%Type, 
                               nEmpresa ge_empresa.nroempresa%Type                               
                               ) Return CLob Is
  
    cCabesalho          CLob := Null;
    bLogo               BLob := Null;
    sRazaoSocial        GE_Empresa.RazaoSocial%Type;
    vErro               varchar2(200);
    vSif                varchar2(10);
    cHTML               CLob := Null;
    vEmpresa            ge_empresa.nroempresa%TYPE := nEmpresa;
    sRazaoSocial        GE_Empresa.RazaoSocial%Type;
    vLogo               BLOB := NULL;
    vDataAtual          varchar2(10) := TO_CHAR(SYSDATE, 'DD/MM/YYYY'); 
    vRelatorio          varchar2(200);
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

 -- VERSAO DO RELATORIO 
   vCodVersao               varchar(6);
   vDataVersao              varchar(10);
    
-- VARIAVEL DE DETALHES DA VERSAO DA TABELA VERSAO  
   vDetalhes                varchar2(5000);
   vIdfichatecnica          varchar(50);
Begin    
   --SELECT EMPRESA
               
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
      e.logo,
      (select E.codservico from DGE_EMPRESACOMPL E WHERE E.NROEMPRESA = nEmpresa) AS SIF
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
      vLogo,
      vSIF            
  FROM 
      GE_EMPRESA E  
  where 
      e.nroempresa = nEmpresa;
      
   -- FOR PARA GRAVAR VERSAO E DATA NA FICHA TECNICA 

  
   if nTipo = 2 then               
   
  
      cCabesalho := '
              <section id="cabecalho">
                   <div class="row mx-0"><!-- Row  cabesalho-->
                      <div class="col-2">
                          <img class="logo img-fluid"
                              src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vLogo)||'" />
                      </div>
                      <div class="col-8 quebra">
                          <div class="row text-center ">
                              <p class="fs-5 fw-bold">'||TO_CHAR(vNomeFantasia)||'</p>
                              <p class="fs-6">'||'Local: '||TO_CHAR(vCidade)||' - '||TO_CHAR(vLogradouro)||' - '||TO_CHAR(vNumero)||'</p>
                              <p class="fs-6">'||'CNPJ: '||TO_CHAR(vCNPJ)||'IE:'||TO_CHAR(vIE)||'</p>
                              <p class="fs-6 d-inline"> Telefone:('||TO_CHAR(vDDD)||')'||TO_CHAR(vTelefone)||'</p>
                              <p class="fs-6 d-inline">'||'CEP: '||TO_CHAR(vCep)||'</p>
                          </div>
                      </div>
                      <div class="col-2 text-center">
                          <div class="row">
                              
                              <div class="col-4 text-start">
                                  <div>Data:</div>                                  
                              </div>
                              <div class="col text-start">
                                  <div>'||vDataAtual||'</div>                                  
                              </div>
                          </div>
                      </div>

                      <div class="row  border-top mx-0"> <!-- TITULO FORMULARIO -->
                          <div class="col fs-5 text-center fw-bold">
                              <p>'||nNomeRelatorio||'</p>
                          </div>
                      </div><!-- fim row-->

                 </div><!-- fim cabesalho-->
           </section>';             
      end if;
      
     
      Return(cCabesalho);
Exception
When Others Then 
  vErro := vErro || sqlerrm;
  cHTML := 'vErro'; 
  Return (cHTML);
        
End DGEF_CabecalhoFichaTecnica;

   
/*******************************************************/
/*      Relatodio de ficha técnica do produto  */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 17/11/2022 *************************/
/*******************************************************/
   
   FUNCTION DGEFR_FichaTecnicaPonzan(nSeqproduto  in DGE_PRODUTO.SeqProduto%Type, 
                                  nEmpresa ge_empresa.nroempresa%Type,                                   
                                  nUf_Cliente string, 
                                  nRegimeTributacao string) RETURN CLob is
                                  
                                  
    cHTML               CLob := Null;
    vErro               CLob := Null;
    vMsg                CLob := Null;
    vEmpresa            ge_empresa.nroempresa%TYPE := nEmpresa;
    sRazaoSocial        GE_Empresa.RazaoSocial%Type;
    vLogo               BLOB := NULL;
    vDataAtual          varchar2(10) := TO_CHAR(SYSDATE, 'DD/MM/YYYY'); 
    -- tributos fiscais liquotas       
    vIcms               varchar2(20) := NULL;
    vSt                 varchar2(20) := NULL;
    vMva                varchar2(20) := NULL;
    vPis                varchar2(20) := NULL;
    vCofins             varchar2(20) := NULL;
    vInfoNutricionais   CLob := Null;
    
    vDescProduto             varchar2(500) := null;
    vUnidadePD               varchar2(500) := null;
    vDescUnidadePD           varchar2(500) := null;
    vQUANTIDADEFARDO         varchar2(500) := null;
    vEAN                     varchar2(500) := null;
    vDUM                     varchar2(500) := null;
    vNCM                     varchar2(500) := null;
    vCEST                    varchar2(500) := null;
    vVALIDADE                varchar2(500) := null;
    vPESOLIQUIDOUNIDADE      varchar2(500) := null;
    vPESOBRUTODAUNIDADE      varchar2(500) := null;
    vPESOLIQUIDOFARDO        varchar2(500) := null;
    vPESOBRUTOFARDO          varchar2(500) := null;
    vDIMENSAODOFARDO         varchar2(500) := null;
    vINGREDIENTES            varchar2(500) := null;
    vMODOCONSERVACAO         varchar2(500) := null;
    vMODOPREPARO             varchar2(500) := null;
    vPALETIZACAO             varchar2(500) := null;
    -- DESCRISAO DE PORSÃO MEDIA PA TABELA NUTRICIONAL
    vDescPorcaoMedia         varchar2(200);
    --imagem do produto 
    vImgProduto              Blob := null;
    -- menor contrlole
    vUnidadeMC               varchar2(500) := null;
    vDescUnidadeMC           varchar2(500) := null;
    vDimensaoMC              varchar2(500) := null;
    vQuantidadeMC            varchar2(500) := null;
    vPesoLiquidoMC           varchar2(500) := null;
    --empresa
    vUfEmpresa               varchar2(10):= null;
BEGIN
  -- SELECT ICMS ST/AMS
  FOR i IN
      (SELECT       
        NVL(T.PercAliquota, 0) AS ICMS, 
        T.PERCALIQUOTAST as ST, 
        T.PERCACRESCIMOST as st_mva
        /*INTO 
        vICMS,
        vst,
        vMva*/
      FROM   
        DGE_PRODUTO P, DGE_TRIBUTACAOUF T
      WHERE  
        T.SEQTRIBUTACAO = P.SEQTRIBUTACAO
        AND P.SEQPRODUTO = nSeqproduto
        AND T.TIPOTRIBUTACAO = 4
        AND T.SEQREGIME = nRegimeTributacao
        AND T.UFCLIENTEFORNECEDOR = 'SP'
        AND T.UFEMPRESA = 'SP')
    LOOP
     
    vICMS := i.ICMS;
    vSt := i.ST;
    vMva := i.st_mva;
      
    END LOOP;
         
  -- select ALÍQUOTA PIS E COMFINS 
  SELECT  
       E.PERCPIS AS PIS, 
       E.PERCCOFINS AS COFINS
   into 
       vPis,
       vCofins
   FROM   
       DCV_DISPFISCAL D, DGE_PARAMENCARGO E
  WHERE  
       E.CODENCARGO = D.CODENCARGO
       AND D.CODDISPFISCAL = 1
       AND D.NROEMPRESA = 1;
  
  -- select Produto
  for i in 
           (select 
              xp.ordem,
              xp.descricao,
              xp.referencia,
              xp.vlrpercdiario 
           from 
              Dge_Produtocomposicao xp 
           where 
              xp.seqproduto = nSeqproduto)
   loop
     vInfoNutricionais := i.ordem ||' - '||i.descricao||' - '||i.referencia||' - '||i.vlrpercdiario;
   end loop;
   
   
   -- ficha tecnica do produto 
   for i in 
           (select * from Dgevg_Fichatecnica tf where tf.SEQPRODUTO = nSeqproduto and tf.NroPlanta = nEmpresa)
   loop
     
    vDescProduto           := i.descproduto;
    vUnidadePD           := i.unidade;
    vQUANTIDADEFARDO     := i.quantidade;
    vEAN                 := i.ean;
    vDUM                 := i.dum;
    vNCM                 := i.ncm;
   if i.cest is not null then
    vCEST                := i.cest;
   else
    vCEST                := '00.000.00'; 
   end if;
    vVALIDADE            := i.validade;
    --vPESOLIQUIDOUNIDADE  := TO_CHAR(i.liquidounidade);
    --vPESOLIQUIDOUNIDADE  := TO_Char(i.liquidounidade, 'FM999G999G990D000', 'nls_numeric_characters='',.''');
    vPESOBRUTODAUNIDADE  := TO_Char(i.brutounidade, 'FM999G999G990D000', 'nls_numeric_characters='',.''');
    vPESOLIQUIDOFARDO    := TO_Char(i.liquidocaixa, 'FM999G999G990D000', 'nls_numeric_characters='',.''');
    vPESOBRUTOFARDO      := TO_Char(i.brutocaixa, 'FM999G999G990D000', 'nls_numeric_characters='',.''');
   -- vPESOLIQUIDOFARDO    := i.liquidocaixa;
    --vPESOBRUTOFARDO      := i.brutocaixa;
    --vDIMENSAODAUNIDADE   := i.dimensaounidade;
    vDIMENSAODOFARDO     := i.dimensaocaixa;
    vINGREDIENTES        := i.ingredientes;
    vMODOCONSERVACAO     := i.conservacao;
    vMODOPREPARO         := i.modopreparo;
    vPALETIZACAO         := i.cadastrogenerico; 
    vDescUnidadePD       := i.descunidade;  
   end loop;
      --SELECT PORSAO MEDIA I 
   
    FOR I IN (
        select 
             p.descricao
        from 
             Dge_Produtocomposicao p
        where 
             p.seqproduto = nSeqProduto 
        and p.ordem = 1 )
    LOOP
      
       vDescPorcaoMedia := i.descricao;
    END LOOP;
    --IMAGEM DO PRODUTO
    select 
    conteudo 
    into 
    vImgProduto
    from 
      dge_arquivoanexo where codlink = nSeqproduto and tablink = 'DGE_PRODUTO';
    
    --informasões menor controle
    for i in 
        (select 
          pe.pesomedio,
          pe.unidade,
          pe.quantidade,
          u.descricao,
          NVL(Ek.altura,0)||'cm'|| ' x '||NVL(Ek.largura,0)||'cm' as dimensao
         
        from 
          DGE_PRODUTOEMBALAGEM pe ,
          dge_unidade u,
          DGE_EMBALAGEMKIT ek, 
          Dge_Produtoembalagemkit pek
          --------------- tara 
         -- dge_produto P,  
          --dge_embalagemkitinsumo Eki
        where 
           pe.menorunidcontrole = 'S'
          and u.unidade = pe.unidade
          and ek.seqembalagemkit = pek.seqembalagemkit    
          and pek.seqembalagem = pe.seqembalagem
          and pe.seqproduto  = nSeqproduto)
          
     loop
       vUnidadeMC       := i.unidade;   
       vDescUnidadeMC   := i.descricao; 
       vDimensaoMC      := i.dimensao;  
       vQuantidadeMC    := i.quantidade; 
       vPesoLiquidoMC   := TO_Char(i.pesomedio, 'FM999G999G990D000', 'nls_numeric_characters='',.''');      
     
     end loop;   
    --empresa    
    select e.estado into vUfEmpresa from ge_empresa e where e.nroempresa = nEmpresa; 
     -- html inicio ----------------------------------------------------------------------------
         
  cHTML := cHTML ||'
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FichaTecnica</title>
    
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
        <!--<link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" /> -->
        <style>'||DGEF_FichaTecnicaCss()||'</style>     
    
</head>

<body class="text-uppercase">

  <!--
      <div id="bt-ferramentas" class="dropdown">
        <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gear" viewBox="0 0 16 16">
              <path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
              <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"/>
            </svg>
        </button>
        <ul class="dropdown-menu">
          <li><a class="dropdown-item" href="#">tabela </a></li>
          <li><a class="dropdown-item" href="#">datavale</a></li>
          <li><a class="dropdown-item" href="#">helpdesk</a></li>
        </ul>
      </div> -->

    <div id="Page1" class="A4">
        
            '||DGEF_CabecalhoFichaTecnica('Ficha Técnica',2,nSeqProduto,nEmpresa)||'
            
          <div class="row text-center fw-bold distaca mb-2 py-3 mx-0">
            <div class="col-2 my-auto">produto</div>
            <div class="col-10 text-center my-auto fs-4 border-start border-secondary"> 
            '||to_char(nSeqproduto)||' - '||vDescProduto||'
                </div>            
          </div>
          
          <div class="row mx-0">
          <div class="col ps-0">
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
                                            <p>Código ncm</p>
                                        </th>
                                        <td>
                                            <p>'||vNCM||'</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">
                                            <p>Código CEST:</p>
                                        </th>
                                        <td>
                                            <p>'||vCEST||'</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">
                                            <p>ALÍQUOTA DE PIS COFINS:</p>
                                        </th>
                                        <td>
                                            <p>'||vPis||'/'||vCofins||'</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">
                                            <p>ALÍQUOTA DE ICMS:</p>
                                        </th>
                                        <td>
                                            <p>'||vIcms||'</p>
                                        </td>
                                    </tr>                                   
                                    <tr>
                                        <th scope="row">
                                            <p>ALÍQUOTA ST/MVA:</p>
                                        </th>
                                        <td>
                                            <p>'||vSt||'/'||vMva||'</p>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th scope="row">
                                            <p>VALIDADE</p>
                                        </th>
                                        <td>
                                           <p><p>'||vVALIDADE||'</p></p>
                                        </td>
                                    </tr>
                                    

                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
           <!-- #################### --- FIM TABELA INFORMASAO GERAL -- ################################  -->       
            <div class="col-4"  /*style="background-color: #ccc;"*/><!-- imagem do produto 1 --->
               <img class="foto img-fluid"
                    src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vImgProduto)||'" />               
            </div>
        </div><!-- Row INFORMASAO GERAL/imagem do produto  --->
        
     <!-- #################### --- FIM tabela  Informações nutricional  -- ################################  -->
    <div class="row"><!-- Row 1 --->
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
    </div><!--fim Row 1--->  
        
        
        <div class="row mt-3 mx-0">
            <div class="col distaca text-center fw-bold border border-white fs-5">MENOR UNIDADE DE CONTROLE ('|| vUnidadeMC ||'-'|| vDescUnidadeMC||')</div>
        </div>
        <div class="row row-cols-5 mb-2 mx-0"> <!--informações gerais padrao 2 com distaca -->
                <div class="col distaca text-center  px-2 border border-white">
            <div class="fw-bold ">EAN:</div>
                <div class="bg-white mb-1 ">
                    '||vEan||'
                </div>
            </div>            
            <div class="col distaca text-center  px-2 border  border-white">
                <div class="fw-bold ">PESO LIQUIDO</div>
                <div class="bg-white mb-1 ">
                    '||
                    vPesoLiquidoMC
                    ||' kg
                </div>
            </div>
            <div class="col distaca text-center  px-2 border border-white">
                <div class="fw-bold ">PESO BRUTO </div>
                <div class="bg-white mb-1 ">
                    '||vPESOBRUTODAUNIDADE||' kg
                </div>
            </div>
            <div class="col distaca text-center  px-2 border border-white">
                <div class="fw-bold ">DIMENSÃO DA UNIDADE </div>
                <div class="bg-white mb-1 ">
                    '||vDimensaoMC||'
                </div>
            </div>
            <div class="col distaca text-center  px-2  border border-white">
                <div class="fw-bold ">Quantidade</div>
                <div class="bg-white mb-1 fw-bold ">
                    '||vQuantidadeMC||'
                </div>
            </div> 
       </div>
<!-- *************************************************  -->
       
        <div class="row mt-3 mx-0">
                <div class="col distaca text-center fw-bold border border-white fs-5">UNIDADE DE VENDA('||vUnidadePD||'-'||vDescUnidadePD||')</div>
        </div>
        <div class="row row-cols-5 mb-2 mx-0"> <!--informações gerais padrao 2 com distaca -->
                <div class="col distaca text-center  px-2 border border-white">
            <div class="fw-bold ">DUM:</div>
                <div class="bg-white mb-1 ">
                    '||vDUM||'
                </div>
            </div>            
            <div class="col distaca text-center  px-2 border  border-white">
                <div class="fw-bold ">PESO LIQUIDO</div>
                <div class="bg-white mb-1 ">
                    '||vPESOLIQUIDOFARDO||' kg
                </div>
            </div>
            <div class="col distaca text-center  px-2 border border-white">
                <div class="fw-bold ">PESO BRUTO </div>
                <div class="bg-white mb-1 ">
                    '||vPESOBRUTOFARDO||' kg
                </div>
            </div>
            <div class="col distaca text-center  px-2 border border-white">
                <div class="fw-bold ">DIMENSÃO DA UNIDADE </div>
                <div class="bg-white mb-1 ">
                    '||vDimensaodofardo||'
                </div>
            </div>
            <div class="col distaca text-center  px-2  border border-white">
                <div class="fw-bold ">QUANTIDADE</div>
                <div class="bg-white mb-1 fw-bold ">
                    '||vQUANTIDADEFARDO||'
                </div>
            </div> 
       </div>
       
      <div class="row "> <!-- row descrições do produto -->
            <div class="col-12 ">
               <table id="info" class="table border">
                <thead>
                  <tr>
                    <th class="col-3"></th>
                    <th class="col-9"></th>                
                  </tr>
                </thead>
                <tbody>
                  <tr class="py-2">
                    <th scope="row" class=" table-active p-2" >INGREDIENTES</th>
                    <td>'||vINGREDIENTES||' </td>                    
                  </tr>
                  <tr>
                    <th scope="row" class=" table-active p-2" >INFORMAÇÃO NUTRICIONAL</th>
                    <td>'||vInfoNutricionais||'</td>                    
                  </tr>
                  <tr>
                    <th scope="row" class=" table-active p-2" >MODO DE CONSERVAÇÃO</th>
                    <td>'||vMODOCONSERVACAO||' </td>                    
                  </tr>                  
                  <tr>
                    <th scope="row" class=" table-active  p-2" >MODO DE PREPARO</th>
                    <td>'||vINGREDIENTES||' </td>                    
                  </tr>
                  <tr>
                    <th scope="row" class=" table-active  p-2" >PALETIZAÇÃO</th>
                    <td>'||vPALETIZACAO||' </td>                    
                  </tr>
                  
                </tbody>
              </table>
           </div>
      </div>
       
       
     
</div><!-- fim page 1 -->            
            

<!-- Button trigger modal -->
<button id="btModal" type="button" class="btn btn-success btn-sm"  data-bs-toggle="modal" data-bs-target="#exampleModal">
  <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-table" viewBox="0 0 16 16">
  <path d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm15 2h-4v3h4V4zm0 4h-4v3h4V8zm0 4h-4v3h3a1 1 0 0 0 1-1v-2zm-5 3v-3H6v3h4zm-5 0v-3H1v2a1 1 0 0 0 1 1h3zm-4-4h4V8H1v3zm0-4h4V4H1v3zm5-3v3h4V4H6zm4 4H6v3h4V8z"/>
</svg>
</button>

<!-- Modal -->
<div class="modal fade modal-xl" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5 fw-bold text-center" id="exampleModalLabel">Modelo Tabela horizontal </h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
       <div class="row mb-3">
             <div id="tabelaFTP" class="mx-auto col-12 table-responsive">

                            <table class=" tb-x table align-middle table-bordered border table-striped">
                                <thead>
                                    <tr class="text-center th-x">
                                        <th width="auto" >CÓDIGO PRODUTO</th>
                                        <th width="auto" >DESCRIÇÃO PRODUTO</th>
                                        <th width="auto" >TIPO UNIDADE/EAN</th>
                                        <th width="auto" >QNT UNIDADE/EAN</th>
                                        <th width="auto" >TIPO UNIDADE/DUM</th>
                                        <th width="auto" >QNT UNIDADE/DUM</th>
                                        <th width="auto" >EAN</th> 
                                        <th width="auto" >DUM</th>
                                        <th width="auto" >NCM</th>
                                        <th width="auto" >CEST</th>
                                        <th width="auto" >VALIDADE</th>
                                        <th width="auto" >Informação nutricional</th>
                                        <th width="auto" >PESO LIQUIDO UNIDADE</th>
                                        <th width="auto" >PESO BRUTO DA UNIDADE</th>
                                        <th width="auto" >PESO LIQUIDO FARDO</th>
                                        <th width="auto" >PESO BRUTO FARDO</th>
                                        <th width="auto" >DIMENSÃO DA UNIDADE</th>
                                        <th width="auto" >DIMENSÃO DO FARDO </th>
                                        <th width="auto" >ALÍQUOTA DE ICMS </th>
                                        <th width="auto" >ALÍQUOTA PIS/Cofins </th>
                                        <th width="auto" >ALÍQUOTA ST/MVA </th>
                                        
                                        <th width="auto" >INGREDIENTES</th>
                                        <th width="auto" >MODO DE CONSERVAÇÃO</th>
                                        <th width="auto" >MODO DE PREPARO</th>
                                        <th width="auto" >PALETIZAÇÃO</th>                                        
                                    </tr>
                                </thead>
                                <tbody class="text-break">
                                    ';
                               begin
                                    FOR i IN
                                         (select * from Dgevg_Fichatecnica tf where tf.SEQPRODUTO = nSeqproduto and tf.NroPlanta = nEmpresa )                                                                             
                                     LOOP
                                                                  
                                        cHTML := cHTML||'
                                            <tr>
                                                <td class="text-center ">'||TO_CHAR(i.seqproduto)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.descproduto)||'</td>                                                
                                                <td class="text-center ">'||TO_CHAR(i.unidade||'-'|| i.descunidade) ||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.quantidade)||'</td>
                                                 <td class="text-center ">('||TO_CHAR(vUnidadeMC ||')-'|| vDescUnidadeMC) ||'</td>
                                                <td class="text-center ">'||TO_CHAR(vQuantidadeMC)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.ean)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.dum)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.ncm)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.cest)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.validade)||'</td>
                                                <td class="text-center ">'||TO_CHAR(vInfoNutricionais)||'</td>
                                                <td class="text-center ">'||TO_CHAR(vPesoLiquidoMC)||'</td>
                                                <td class="text-center ">'||TO_CHAR(vPESOBRUTODAUNIDADE)||'</td>
                                                
                                                <td class="text-center ">'||TO_CHAR(i.liquidocaixa)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.brutocaixa)||'</td>
                                                <td class="text-center ">'||TO_CHAR(vDimensaoMC)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.dimensaocaixa)||'</td>
                                                <td class="text-center ">'||TO_CHAR(vIcms)||'</td>
                                                <td class="text-center ">'||TO_CHAR(vPis)||'/'||TO_CHAR(vCofins)||'</td>
                                                <td class="text-center ">'||vst||'/'||TO_CHAR(vMva)||'</td>
                                                
                                                <td class="text-center ">'||TO_CHAR(i.ingredientes)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.conservacao)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.modopreparo)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.cadastrogenerico)||'</td>                                                                                            
                                           </tr>
                                        ';
                                                                                    
                                    END LOOP;
                                    exception
                                      When others then         
                                      vErro := vErro||sqlerrm;                                      
                                    end;
                                    
                                    cHTML := cHTML||'
                                </tbody>
                            </table>

                        </div>
                    
        </div><!-- #################### --- FIM tabela  -- ################################  -->
      </div>
      <div class="modal-footer">       
        <button id="bt1" type="button" class="btn btn-success">Exportar Tabela</button>
      </div>
    </div>
  </div>
</div>
   '|| --converte tanela HTML para arquivo EXCEL  
       DGEF_ExportarArquivoExcel('#bt1','tabelaFTP')||'
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
</body>

</html>';
  
Return (cHTML);
  
Exception
      
  When Others Then 
  vErro := vErro || sqlerrm;
 
  vErro := vErro ||'<p>nSeqproduto'||nSeqproduto||'</p>
                    <p>nEmpresa ='||nEmpresa||'<p>
                    <p>nUf_Cliente ='||nUf_Cliente||' <p> 
                    <p>nRegimeTributacao='||nRegimeTributacao||'<p>';
  cHTML := DGEF_ErroFichaTecnicaHTML(vErro,nEmpresa , nSeqProduto);   
  Return (cHTML); 
                                  
END DGEFR_FichaTecnicaPonzan;

/*******************************************************/
/* funsão para converte tanela HTML em arquivo EXCEL   */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 17/11/2022 *************************/
/*******************************************************/
FUNCTION DGEF_ExportarArquivoExcel(nId_button string,
                                   nid_tabela string) RETURN CLob is
                                   
    cScript             CLob := Null;
    vErro               CLob := Null;
    
begin
  cScript := '
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js" ></script>
    <script>
        $(document).ready(function(){
            $("'||nId_button||'").click(function(e){ 
             e.preventDefault();
             var DivTabela = document.getElementById("'||nId_tabela||'");
             var Dados = new Blob(["\ufeff" + DivTabela.outerHTML],{type:"application/vnd.ms-excel"});
             var url =  window.URL.createObjectURL(Dados);
             var a = document.createElement("a");
             a.href = url;             
             a.download = "'||nId_tabela||'"
             a.click();
            });
        });
    </script>  
  ';
                                   
  Return (cScript);
  
Exception
      
  When Others Then 
  vErro := vErro || sqlerrm;
  --cHTML := DGEF_ErroFichaTecnicaHTML(vErro,nEmpresa , nSeqProduto);   
  Return (vErro);
END DGEF_ExportarArquivoExcel;  


/*******************************************************/
/* relatorio de vendas referente ao atendimento 125443  */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 24/11/2022 *************************/
/*******************************************************/                                

FUNCTION DGEFR_ListaProdutoVenda(    nEmpresa string,
                                     nInicioPeriudo string,
                                     nFimPeriudo string,                                     
                                     nTabelaPreso string,
                                     nSeqCliente string,
                                     nSeqRede string                                     
                                    ) RETURN CLob is 
      
 cHTML               CLob := Null;
 vErro               CLob := Null;
 vVenda              varchar2(500);
 pnSeqRede           GE_REDEPESSOA.SeqRede%TYPE := nSeqRede; --52; 
 pnSeqPessoa         GE_PESSOA.SeqPessoa%TYPE := nSeqCliente;--15367;
 pnFiltro            INTEGER;
 vRow                numeric(10) := 0;
 --vInicioPeriudo      date := nInicioPeriudo;
 --vFimPeriudo date := nFimPeriudo;
 vDescRede           varchar(500):= null;
 vDescCliente        varchar(500):= null;
 vTabeladePreco      varchar(500):= null;
 
    
 
begin
  -- if valida se os campos de periodo foi informado. 
  if nInicioPeriudo is null or nFimPeriudo is null then 
      vErro := '<p> O campo empresa não foi informado.</p>
                <p> Informe-os e tente novamente.</p>';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa,'');
    return (cHTML);
    
  elsif nInicioPeriudo > nFimPeriudo then     
      vErro := '<p> O campo de Período Final deve ser maior que Período Inicial.</p>
                <p> Informe-os e tente novamente.</p>';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa, ''); 
    return (cHTML);
    
  end if; 
    
  -- if valida se o campo empresa foi informado. 
  if nEmpresa is null or  nEmpresa = 0 then    
      vErro := '<p> O campo empresa não foi informado, informe o campo e tente novamente.</p>';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa, ''); 
    return (cHTML);
  end if;  

  -- if valida e carrega tabela de preço 
  if nTabelaPreso is not null then 
      select tp.NroTabPreco ||'-'|| tp.Descricao as tabela 
      into vTabeladePreco
      FROM   DGEV_TABPRECO tp
      where  tp.SeqTabPreco = nTabelaPreso
      group by tp.NroTabPreco, tp.Descricao;
  else
      vErro := '<p> Tabela de Preço é um campo obrigatório. </p>
                <p> Informe-o e tente novamente.</p>';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa, ''); 
    return (cHTML);
  end if;
  
  -- if verifica se o campo rede ou Cliente possui dados.    
  if nSeqCliente <> 0 and nSeqCliente is not null or nSeqRede is not null then 
      --if se for passado cliente e rede ele anula a rede e busca por cliente 
       if nSeqCliente <> 0 and nSeqCliente is not null and  nSeqRede is not null then
         pnSeqRede := null;
       end if;
       
      -- if para carregar informações de rede 
      if nSeqRede is not null then 
          SELECT r.descricao
          into vDescRede 
          from  ge_rede r 
          where r.seqrede = nSeqRede;    
      end if; 
      
      -- if para carregar informações de cliente 
      if nSeqCliente <> 0 and nSeqCliente is not null then 
          SELECT p.nomerazao,r.descricao 
          into vDescCliente,vDescRede
          from ge_redepessoa rp, ge_rede r, ge_pessoa p 
          where 
               r.seqrede = rp.seqrede 
               and p.seqpessoa = rp.seqpessoa 
               and p.seqpessoa = nSeqCliente;       
      end if;
      
  else
      vErro := '
               <p>Campo rede e cliente não informados.</p>
               <p>Informe ao menos um campo e tente novamente.</p>
               ';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa, ''); 
    return (cHTML); 
  end if;

  IF NVL(pnSeqRede, 0) = 0 THEN 
      pnFiltro := pnSeqPessoa;
    ELSE 
      pnFiltro := pnSeqRede;
    END IF;

   declare cursor cDados is 
     SELECT  
             --DISTINCT pv.SeqCliente, 
             tp.SeqProduto,
             tp.DescrProduto,
             tp.Unidade as descUnidade,
             --tp.Unidade ||' - '||(select xu.descricao from dge_unidade xu where xu.unidade = tp.Unidade) as descUnidade,
             --tp.Descricao,
             --tp.NroPlanta,
             --tp.SeqEmbalagem, 
             tp.VlrPraticado,
             c.VlrMedio,
             c.vlricms as icms,
             c.vlroutroscofins as cofins,
             c.vlrisentospis as pis
                   
      FROM   DGEV_TABPRECO tp, --dge_produto pr,
             
             (SELECT  nfi.SeqProduto, nfi.SeqEmbalagem, 
                      ROUND(SUM(nfi.VlrProduto)/SUM(nfi.Quantidade), 2) VlrMedio,
                      nfi.vlricms ,
                      nfi.vlroutroscofins ,
                      nfi.vlrisentospis  
              FROM    DCV_NOTAFISCAL nf,
                      DCV_PEDIDO pv,
                      GE_REDEPESSOA rp,
                      DCV_NFISCALITEM nfi
              WHERE   pv.SeqPedido = nf.SeqPedido 
                      AND nfi.SeqNotaFiscal = nf.SeqNotaFiscal 
                      AND nf.TipoNota = 'S'
                      AND nf.SituacaoNF = 4
                      AND nf.NroEmpresa = 1
                      AND nf.DtaEmissao BETWEEN nInicioPeriudo AND nFimPeriudo --filtro                       
                      --AND pv.SeqCliente = pnSeqPessoa --filtro
                      AND (CASE WHEN NVL(pnSeqRede, 0) > 0 THEN
                                  rp.SeqRede
                             ELSE pv.SeqCliente END) = pnFiltro 
                               
              GROUP BY nfi.SeqProduto, nfi.SeqEmbalagem,
                       nfi.vlricms,nfi.vlroutroscofins,nfi.vlrisentospis) c
      WHERE   c.SeqProduto (+) = tp.SeqProduto
              AND c.SeqEmbalagem (+)= tp.SeqEmbalagem
              --and  pr.sitproduto(+) = tp.SeqProduto
             -- and  pr.sitproduto = 'A'
              AND tp.SeqTabPreco = nTabelaPreso -- nTabelaPreso  --99983 --filtro
              and tp.EmbalagemVendaPadrao = 'S'              
              --and  ROWNUM <= 1000
              order by c.VlrMedio;
  begin
  
  cHTML := cHTML ||'
  <!doctype html>
  <html lang="en">

  <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>ListaVendaProduto</title>
      
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
          <style>'||DGEF_FichaTecnicaCss()||'</style>
             
          <script src="https://www.codigofonte.com.br/wp-content/uploads/legado/codigos/880/sorttable.js"></script> 
  </head>

  <body class="text-uppercase">

      <div id="Page1" class="A4">
          
                                     <!-- <p>nEmpresa       '||To_char(nEmpresa)||'</p>
                                     <p>nInicioPeriudo '||To_char(nInicioPeriudo)||'</p>
                                     <p>nFimPeriudo    '||To_char(nFimPeriudo)||'</p>   
                                     <p>nTabelaPreso   '||To_char(nTabelaPreso)||'</p> 
                                     <p>nSeqCliente    '||To_char(nSeqCliente)||'</p> 
                                     <p>nSeqRede       '||To_char(nSeqRede)||'</p> --> 
                                     
                                     
            '||DGEF_CabecalhoFichaTecnica('Lista de vendas por Rede ou clinte',2,'',nEmpresa)||'
           
                           
            <div class="row mb-3"> <!-- row descrições do produto -->
                <div class="col-12 ">
                   <table id="info" class="table border text-center">
                    <thead>
                      <tr>
                        <th class="col-3"></th>
                        <th class="col-9"></th>                
                      </tr>
                    </thead>
                    <tbody class="text-center">
                      <tr class="py-2">
                        <th scope="row" class=" table-active p-2" >Rede</th>
                        <td class="p-2">'||vDescRede||' </td>                    
                      </tr>
                      <tr>
                        <th scope="row" class=" table-active p-2" >Clientes</th>
                        <td class="p-2">'||vDescCliente||'</td>                    
                      </tr>                 
                      <tr>
                        <th scope="row" class=" table-active p-2" >Tabela de Preço</th>
                        <td class="p-2">'||vTabeladePreco ||'</td>                    
                      </tr>
                      <tr>
                        <th scope="row" class=" table-active p-2" >Inico Periodo </th>
                        <td class="p-2">
                               <b>'||To_char(To_date(nInicioPeriudo),'DD/MM/YYYY')
                               ||' </b> á <b>                       
                               '||To_char(To_date(nFimPeriudo),'DD/MM/YYYY')||' </b>
                        </td>                    
                      </tr>
                      
                        
                    </tbody>
                  </table>
               </div>
          </div>
              
          <div class="row apagar-print"> <!-- #################### --- barra de pesquisa -- ################################  -->
              <div class="col-5 mb-1">
                  
                  <div class="input-group flex-nowrap">
                      <span class="input-group-text" id="addon-wrapping">Pesquisar</span>
                      <input id="input-busca" type="text" class="form-control" placeholder="Username" aria-label="Username" aria-describedby="addon-wrapping">
                  </div>
                  
              </div>
          </div>
          
          <div id="rowTabelaVenda" class="row"> <!-- #################### --- inicio tabela VERSAO-- ################################  -->
              <div class="col-12">
                  <div  class="caixa border-0">
                      <div class="distaca fs-4 fw-bold text-center">                          
                      </div>
                      <div class="row">
                          <div id="divVendaProdutoCliente" class="mx-auto col-12">

                              <table id="TabelaVendaProdutoCliente" class="table align-middle table-bordered border table-striped sortable">
                                  <thead>
                                      <tr class="text-center">
                                         <!--<th width="50">#</th> -->   
                                          <th width="50">código do produto</th>                                        
                                          <th width="150px">desc produto</th>               
                                          <th width="50">unidade</th>       
                                          <th width="50">vlr venda </th>   
                                          <!-- <th width="50">seqcliente</th> -->
                                          <th width="50">vlr Médio Venda</th>
                                          <th width="50">icms</th>
                                          <th width="50">Pis/Cofins</th>                                   
                                      </tr>
                                  </thead>
                                  <tbody id="tabela-dados" class="text-break">';
                                  for i in cDados
                                              loop
                                                
                                                cHTML := cHTML ||'
                                                     <tr>
                                                           <!-- <td></td> -->
                                                           
                                                           <td class="text-center">'||To_char(i.SeqProduto)||'</td>
                                                           <td>'||To_char(i.DescrProduto)||'</td>
                                                           <td class="text-center" >'||To_char(i.descUnidade)||'</td>
                                                                        
                                                           
                                                           <td class="text-center">'||To_char(i.VlrPraticado)||'</td>';
                                                      if i.VlrMedio is not null then
                                                        cHTML := cHTML ||'
                                                           <td class="text-center">'||To_char(i.VlrMedio)||'</td>
                                                           <td class="text-center">'||To_char(i.icms)||'</td>
                                                           <td class="text-center">'||To_char(i.pis)||'/'||To_char(i.cofins)||'</td>
                                                           ';
                                                      else     
                                                        cHTML := cHTML ||'   
                                                           <td class="text-center table-danger" colspan="3">
                                                                Produto Não Possui Venda
                                                           </td>
                                                           ';
                                                      end if;
                                              cHTML := cHTML ||'                                              
                                                     </tr>';
                                                     vRow := vRow + 1;
                                              end loop;
                                                                                 
                                  cHTML := cHTML ||'   
                                  </tbody>
                                  <tfoot><!-- footer da tabela -->
                                      <tr>
                                          <th colspan="7" class="text-center">Datavale - Tecnologia & Sistemas | http://.datavale.com.br/</th>
                                          
                                      </tr>
                                  </tfoot>
                              </table>

                          </div>
                      </div>
                  </div>
              </div>
          </div><!-- #################### --- FIM tabela  VERSAO -- ################################  -->
          
          <p>Row  '||To_char(vRow)||'</p>
          
          
      </div><!--fim A4 Page1-->
      <script>

        const INPUT_BUSCA = document.getElementById("input-busca");
        const TABELA_BEBIDAS = document.getElementById("tabela-dados");
    
        INPUT_BUSCA.addEventListener("keyup", () => {    
            let expressao = INPUT_BUSCA.value.toLowerCase();
    
            if (expressao.length === 1) {
                return;
            }
    
            let linhas = TABELA_BEBIDAS.getElementsByTagName("tr");
    
            console.log();
            for(let posicao in linhas){
                if (true === isNaN(posicao)){
                    continue;
                }
    
                let conteudoDaLinha = linhas[posicao].innerHTML.toLowerCase();
                
                if(true === conteudoDaLinha.includes(expressao)){
                    linhas[posicao].style.display = "";
                } else {
                    linhas[posicao].style.display = "none";
                }
            }
    
        });
    </script>
      
     
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
  </body>

  </html>';
  end;
  Return (cHTML);
Exception
      
  When Others Then 
  vErro := vErro || sqlerrm;
  --cHTML := DGEF_ErroFichaTecnicaHTML(vErro,nEmpresa , '');   
  Return (vErro);
END DGEFR_ListaProdutoVenda;

End DPKG_RELHTML;
