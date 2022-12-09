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
      cHTML := cHTML||'html { width: 50%; background-color: #f2f4f8; margin: 0 auto; overflow-x: hidden; }';
      cHTML := cHTML||'@media (max-width: 900px) {html {width: 100%;}}';
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
/****************************************************/
/*Function que retorna lista de produto por produção*/
/****************************************************/

------------------------------------------------------------------------------------------------------------------

/*******************************************************/
/*       Téla de erros Relatorios    */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 09/12/2022*************************/
/*******************************************************/
   
Function DGEF_ErroListaProdProdutoHTML(nErro string,
                                   nEmpresa NUMERIC
                                   
                                   ) Return CLob is
                                      

    cHTML               CLob := Null;
   
Begin    

cHTML := cHTML ||'xxx';

cHTML := cHTML ||'
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Erro ListaProdProduto</title>
    
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
        <!--<link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" /> -->
        <style>'||DGEF_ListaProdProdutoCss()||'</style>
    
</head>

<body class="text-uppercase">

    <div id="Page1" class="A4">
       '||DGEF_CabecalhoListaProdProduto('',10)||'
       
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
end DGEF_ErroListaProdProdutoHTML; 
                                       
/*******************************************************/
/*       style css da Lista produção      */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 09/12/2022 *************************/
/*******************************************************/   
Function DGEF_ListaProdProdutoCss Return CLob is 


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

   End DGEF_ListaProdProdutoCss;

/*******************************************************/
/*Function que retorna o cabelaçalho HTML do relatório */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 09/12/2022 *************************/
/*******************************************************/
Function DGEF_CabecalhoListaProdProduto(nNomeRelatorio string,                              
                                         nEmpresa numeric                               
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


Begin    
   --SELECT EMPRESA
               
   SELECT 
      E.RAZAOSOCIAL,
      E.FANTASIA,
      regexp_replace(LPAD(To_char(e.nrocgc), 14),'([0-9]{2})([0-9]{3})([0-9]{3})([0-9]{4})','\1.\2.\3/\4-') as CNPJ,
      E.TELEVENDASDDD ,
      E.Fonenro ,
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

      
     
      Return(cCabesalho);
Exception
When Others Then 
  vErro := vErro || sqlerrm;
  cHTML := 'vErro'; 
  Return (cHTML);
        
End DGEF_CabecalhoListaProdProduto;

/*******************************************************/ 
/* funsão para converte tanela HTML em arquivo EXCEL   */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 09/12/2022 *************************/
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
  --cHTML := DGEF_ErroListaProdProdutoHTML(vErro,nEmpresa , nSeqProduto);   
  Return (vErro);
END DGEF_ExportarArquivoExcel;                                  


/*******************************************************/ 
/***************** Atendimento: 126218 *****************/
/*      Relatório de produtos e data de produção.      */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 09/12/2022 *************************/
/*******************************************************/
Function DGEFR_ListaProdProduto( nEmpresa numeric, 
                                  nGrupProd numeric, 
                               nSubGrupProd numeric) Return CLob Is

      cHTML                        CLob := Null;
      vErro                        varchar(4000) := null;
      vDescGrupo                   varchar(500) := null;
      vIndustria                  numeric;
      
    Begin
    if nEmpresa = 1 then 
      vIndustria:= 2;
    else
      vIndustria:= 10;
    end if;
    
    select gp.descricao||' / '||sg.descricao as grupos
    into vDescGrupo
     from dge_grupoproduto gp, dge_Subgrupoproduto sg
     where gp.grupoprod = nGrupProd
     and sg.subgrupoprod = nSubGrupProd;
    
     cHTML := cHTML ||'
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Produção de Produto</title>
     
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <style>'||DGEF_ListaProdProdutoCss()||'</style>
             
    <script src="https://www.codigofonte.com.br/wp-content/uploads/legado/codigos/880/sorttable.js"></script>     
    
</head>

<body class="text-uppercase">

    <div id="Page1" class="A4 p-0">
        
            '||DGEF_CabecalhoListaProdProduto('Relatorio lista de produto por produção ',nEmpresa)||'
            
  
        
        
        
        <div class="row apagar-print"> <!-- #################### --- barra de pesquisa -- ################################  -->
              <div class="col-5 mb-1">
                  
                  <div class="input-group flex-nowrap">
                      <span class="input-group-text" id="addon-wrapping">Pesquisar</span>
                      <input id="input-busca" type="text" class="form-control" placeholder="" aria-label="" aria-describedby="addon-wrapping">
                  </div>
                  
              </div>
          </div>
          <div class="row mx-0 mb-1 ">            
                <div class="col-3 mb-1 border distaca fw-bold text-center">Grupo / Sub Grupo Produto:</div>
                <div class="col mb-1 border "> '||To_char(vDescGrupo)||'</div>
        </div> 
          
          <div id="rowTabelaVenda" class="row"> <!-- #################### --- inicio tabela -- ################################  -->
              <div class="col-12">
                  <div  class=" border-0">
                      <div class="distaca fs-4 fw-bold text-center">                          
                      </div>
                      <div class="row">
                          <div id="divVendaProdutoCliente" class="mx-auto col-12">

                              <table id="TabelaVendaProdutoCliente" class="table align-middle table-bordered border table-striped sortable">
                                <thead>                                    
                                    <tr class="text-center">
                                        <th class="col-1">Produto</th>                                        
                                        <th class="col-2">Descrição</th>
                                        <th class="col-1">EAN</th>
                                        <th class="col-1">DUM</th>
                                        <th class="col-1">Data produção</th>
                                        <th class="col-1">Conservação</th>
                                                                              
                                    </tr>
                                </thead>
                                <tbody id="tabela-dados" class="text-break">
                                    ';
                              
                                    FOR i IN
                                      (Select * From 
                                            ( select  2 Empresa,  
                                                    pr.seqproduto,
                                                    pr.descricao,
                                                    (select lpad(xpe.gtin,13,0) from dge_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and xpe.menorunidcontrole = 'S') as EAN,
                                                    (select lpad(xpe.gtin,14,0) from dge_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and XPE.EMBALAGEMINDUSTRIAPADRAO = 'S')AS DUM,
                                                    (SELECT  max(xe.Dtaproducao) FROM DIN_Estoque@DTVIND02 xe WHERE xe.SeqProduto = pr.seqproduto AND xe.TabLinkEnt = 'DIN_PROGPRODUCAOITEM'
                                                     AND xe.status not in (6,9) AND xe.seqestoqueorigem is null ) as dataProducao,
                                                     DECODE(pr.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente','<p class="text-danger">Não Informado<p>')As Conservacao
                                            from dge_produto pr  --, dge_grupoproduto
                                            where --pr.status = 'A' 
                                             pr.grupoprod =  nGrupProd --4
                                            and pr.subgrupoprod = nGrupProd /*260*/

                                          Union all
                                          
                                           select  10 Empresa,
                                                    pr.seqproduto,
                                                    pr.descricao,
                                                    (select lpad(xpe.gtin,13,0) from dge_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and xpe.menorunidcontrole = 'S') as EAN,
                                                    (select lpad(xpe.gtin,14,0) from dge_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and XPE.EMBALAGEMINDUSTRIAPADRAO = 'S')AS DUM,
                                                    (SELECT  max(xe.Dtaproducao) FROM DIN_Estoque@DTVIND10 xe WHERE xe.SeqProduto = pr.seqproduto AND xe.TabLinkEnt = 'DIN_PROGPRODUCAOITEM'
                                                     AND xe.status not in (6,9) AND xe.seqestoqueorigem is null ) as dataProducao,
                                                     DECODE(pr.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente','<p class="text-danger">Não Informado<p>')As Conservacao
                                            from dge_produto pr  --, dge_grupoproduto
                                            where --pr.status = 'A' 
                                             pr.grupoprod =  nGrupProd --4
                                            and pr.subgrupoprod = nSubGrupProd /*260*/
                                          --order by dataProducao;
                                          ) Where empresa = vIndustria )
                                      
                                         /*(select  pr.seqproduto,
                                                  pr.descricao,
                                                  (select lpad(xpe.gtin,14,0) from dge_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and xpe.menorunidcontrole = 'S') as EAN,
                                                  (select lpad(xpe.gtin,14,0) from dge_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and XPE.EMBALAGEMINDUSTRIAPADRAO = 'S')AS DUM,
                                                  (SELECT  max(xe.Dtaproducao) FROM DIN_Estoque@DTVIND02 xe WHERE xe.SeqProduto = pr.seqproduto AND xe.TabLinkEnt = 'DIN_PROGPRODUCAOITEM'
                                                   AND xe.status not in (6,9) AND xe.seqestoqueorigem is null ) as dataProducao,
                                                   DECODE(pr.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente','<p class="text-danger">Não Informado<p>')As Conservacao
                                          from dge_produto pr  --, dge_grupoproduto
                                          where --pr.status = 'A' 
                                           pr.grupoprod =  nGrupProd --4
                                          and pr.subgrupoprod = nSubGrupProd \*260*\
                                          order by dataProducao;
                                          
                                    union all
                                    
                                          select  pr.seqproduto,
                                                  pr.descricao,
                                                  (select lpad(xpe.gtin,14,0) from dge_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and xpe.menorunidcontrole = 'S') as EAN,
                                                  (select lpad(xpe.gtin,14,0) from dge_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and XPE.EMBALAGEMINDUSTRIAPADRAO = 'S')AS DUM,
                                                  (SELECT  max(xe.Dtaproducao) FROM DIN_Estoque@DTVIND10 xe WHERE xe.SeqProduto = pr.seqproduto AND xe.TabLinkEnt = 'DIN_PROGPRODUCAOITEM'
                                                   AND xe.status not in (6,9) AND xe.seqestoqueorigem is null ) as dataProducao,
                                                   DECODE(pr.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente','<p class="text-danger">Não Informado<p>')As Conservacao
                                          from dge_produto pr  --, dge_grupoproduto
                                          where --pr.status = 'A' 
                                           pr.grupoprod =  nGrupProd --4
                                          and pr.subgrupoprod = nSubGrupProd \*260*\
                                          order by dataProducao;) */ 
                                                                                                                     
                                     LOOP
                                                                  
                                        cHTML := cHTML||'
                                            <tr>
                                            
                                                <td class="text-center ">'||TO_CHAR(i.seqproduto)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.descricao)||'</td> 
                                                <td class="text-center ">'||TO_CHAR(nvl(i.Ean,'<p class="text-danger">0000</p>'))||'</td>
                                                <td class="text-center ">'||TO_CHAR(nvl(i.Dum,'<p class="text-danger">0000</p>'))||'</td> ';  
                                                 if i.dataproducao is not null then                                           
                                                 cHTML := cHTML||'  <td class="text-center ">'||TO_CHAR(i.dataproducao, 'DD/MM/YYYY')||'</td>';
                                                 else 
                                                 cHTML := cHTML||'  <td class="text-center text-danger">0000</td>';
                                                 end if;
                                                  cHTML := cHTML||'  
                                                <td class="text-center ">'||TO_CHAR(i.conservacao)||'</td> 
                                                
                                                                                            
                                            </tr>
                                        ';
                                                                                    
                                    END LOOP;
                                    
                                    cHTML := cHTML||'
                                </tbody>
                                <tfoot><!-- footer da tabela -->
                                      <tr>
                                                <th colspan="6" class="text-center"> 
                                                <img class="icon-logo" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACMUlEQVQ4jaWST0iTcRjHv8/vffdu5bZqhcRq2nLYTFsjSSJIPKwuhSRhlnSKiEG3MJCO3eoQdekQnqOjhRSJ/UFcDSEDg5wr5+twM0zX9i42eN1+Twc3McIO63t44AfP58fzfJ8vMTPhP6TWCl7u6+1yOBwlUQt80OM+tsPpHGtobHxa0wRSyvpXL18IVVHHVQCYbfG6qVw+A4IPDA2EAoAkiKblLte0/8MnEwBuDdw8l8lkgge83scLuh7QrFpMjTd7wsT8ACBtw01eLywhxerKcKzNd//uXs+VU7194XyxiFRywT6/uDQIrJs4QETa5hErfByK2t8c06eaGvb7yIhfb3/0ED/tTuhL379UewWAETD/uSRzmhVLV3NMn6quvVYqyblsDv3LaTxTZefM0SYVAARr2iATnjMzAIapqIgeP5kYOtvz5OKFnslgW0t4LrmYUITi77YooyCAGFeVonkPAIiZabb9iKB8Nrxs0e687Qy5DodCsNfVIRKJYPzNa5lKpX0jGlzEcoIINoDAQHbNvW+PCgCHPn6WAb9/iBjXOkzTtTOdhlWzwsjlUCgWxQ2Vu4lxGwQbmNZdIhpufReVGznI/8qdZ+Zg9H0E84k5KIqCleUfMDKrydPbLScAngTIZEE6g0bLu+vHqleoKgAAecNA3jAqXnJBCHGpNZ6MbhWqzVEeY+ZSBQSAmBAiNL+4tCW8YWL14fW4AyxlhyDxzbrNNjHzNVH6F/zXB7XoN0ir7I+9fhwlAAAAAElFTkSuQmCC"/>
                                                 Datavale - Tecnologia & Sistemas | http://.datavale.com.br/</th>
                                                
                                     </tr>
                                </tfoot>
                              </table>

                          </div>
                      </div>
                  </div>
              </div>
          </div><!-- #################### --- FIM tabela   -- ################################  -->
          </div>
        
        
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
  
Return (cHTML);
  
Exception
      
  When Others Then 
  vErro := vErro || sqlerrm;
  --cHTML := DGEF_ErroListaProdProdutoHTML(vErro,nEmpresa , nSeqProduto);   
  Return (cHTML); 

End DGEFR_ListaProdProduto;

/*******************************************************/ 
/******************** Atendimento: 126218 **************/
/*        Relatório de rastreio de embalagens.         */
/*########### Desenvolvido por: CAIO MARTINI ##########*/
/************ DATA: 09/12/2022 *************************/
/*******************************************************/
Function DGEFR_RastreioEmbalagens( nEmpresa numeric, 
                                    nSeqEmbalagem numeric ) Return CLob Is

      cHTML                        CLob := Null;
      vErro                        varchar(4000) := null;
      vDescPesquisado              varchar(500) := null;
      vEmbalagem                   varchar(500) := null;
      vTipo                        varchar(500) := null;
      vGrup                        varchar(500) := null;
      vSubGrup                     varchar(500) := null;
      
      
    Begin
      
  select                                              
      p.seqproduto||' - '||
      p.descricao as embalagem,                                               
      --DECODE(p.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente','Não Informado')As Conservacao,
      tp.descricao as tipo,                                                
      gp.descricao as grupo,
      sgp.descricao as subGrupo
   into 
      vEmbalagem,
      vTipo,
      vGrup,
      vSubGrup      
  from                                                 
      dge_produto p,
      dge_grupoproduto gp,
      dge_tipoproduto tp,
      dge_Subgrupoproduto sgp
  where 
      sgp.subgrupoprod = p.subgrupoprod
      and gp.tipoproduto = tp.tipoproduto
      and gp.grupoprod = p.grupoprod 
      and p.seqproduto = nSeqEmbalagem;
    
     cHTML := cHTML ||'
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ListaProdProduto</title>
     
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <style>'||DGEF_ListaProdProdutoCss()||'</style>
             
    <script src="https://www.codigofonte.com.br/wp-content/uploads/legado/codigos/880/sorttable.js"></script>     
    
</head>

<body class="text-uppercase">

    <div id="Page1" class="A4 p-0">
        
            '||DGEF_CabecalhoListaProdProduto('Relatorio Rastreio de embalagens kit emsumos',nEmpresa)||'
            
  
        
        
        
        <div class="row apagar-print"> <!-- #################### --- barra de pesquisa -- ################################  -->
              <div class="col-5 mb-1">
                  
                  <div class="input-group flex-nowrap">
                      <span class="input-group-text" id="addon-wrapping">Pesquisar</span>
                      <input id="input-busca" type="text" class="form-control" placeholder="" aria-label="" aria-describedby="addon-wrapping">
                  </div>
                  
              </div>
        </div>
        
        <div class="row mx-0 mb-1 ">      
                <div class="col-2 mb-1 border distaca fw-bold text-center">Embalagem:</div>
                <div class="col mb-1 border "> '||To_char(vEmbalagem)||'</div>
        </div>  
                      
        <div class="row mx-0 mb-1 ">        
                <div class="col-1 mb-1 border distaca fw-bold text-center">Tipo:</div>
                <div class="col mb-1 border "> '||To_char(vTipo)||'</div>
                
                <div class="col-1 mb-1 border distaca fw-bold text-center">Grupo:</div>
                <div class="col mb-1 border "> '||To_char(vGrup)||'</div>
                
                <div class="col-sm-auto mb-1 border distaca fw-bold text-center">Sub Grupo:</div>
                <div class="col mb-1 border "> '||To_char(vSubGrup)||'</div>
        </div>
                    
          <div id="rowTabelaVenda" class="row"> <!-- #################### --- inicio tabela -- ################################  -->
              <div class="col-12">
                  <div  class=" border-0">
                      <div class="distaca fs-4 fw-bold text-center">                          
                      </div>
                      <div class="row">
                          <div id="divVendaProdutoCliente" class="mx-auto col-12">

                              <table id="TabelaVendaProdutoCliente" class="table align-middle table-bordered border table-striped sortable">
                                <thead class="distaca">                                    
                                    <tr class="text-center">
                                        <th class="col-1">kit Emb.</th>
                                        <th class="col-1">Produto</th> 
                                        <th class="col-3">Descrição</th>                                         
                                        <th class="col-2">Tipo</th>
                                        <th class="col-1">Grupo</th>
                                        <th class="col-2">Sub Grupo</th>
                                        <th class="col-1">Conservação</th>
                                    </tr>
                                </thead>
                                <tbody id="tabela-dados" class="text-break">
                                    ';
                              
                                    FOR i IN
                                         (
                                             -- rasreio de embalegens 
                                             select
                                                 pek.seqembalagemkit,
                                                 p.seqproduto,
                                                 p.descricao as descprod,
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
                                                 and eks.seqproduto = nSeqEmbalagem --/6611/
                                             group by             
                                                 p.seqproduto,p.descricao, p.conservacao,
                                                 tp.descricao,  gp.descricao, sgp.descricao,  
                                                 pek.seqembalagemkit 
                                                 )                                                                             
                                     LOOP
                                                                  
                                        cHTML := cHTML||'
                                            <tr>
                                                <td class="text-center ">'||TO_CHAR(i.seqembalagemkit)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.seqproduto)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.descprod)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.tipo)||'</td> 
                                                <td class="text-center ">'||TO_CHAR(i.grupo)||'</td> 
                                                <td class="text-center ">'||TO_CHAR(i.subgrupo)||'</td>';
                                               IF i.conservacao = 'Congelado' THEN                                                              
                                                  cHTML := cHTML||'<th class="text-center table-info">'||TO_CHAR(i.conservacao)||'</th>';
                                               
                                               ELSIF i.conservacao = 'Ambiente' THEN                                                              
                                                  cHTML := cHTML||'<th class="text-center table-warning">'||TO_CHAR(i.conservacao)||'</th>';
                                               
                                               ELSIF i.conservacao = 'Resfriado' THEN                                                              
                                                  cHTML := cHTML||'<th class="text-center table-primary">'||TO_CHAR(i.conservacao)||'</th>';
                                               
                                               ELSIF i.conservacao = 'Não Informado' THEN                                                              
                                                  cHTML := cHTML||'<th class="text-center table-danger">'||TO_CHAR(i.conservacao)||'</th>';
                                               END IF;
                                       cHTML := cHTML||'        
                                            </tr>
                                        ';
                                                                                    
                                    END LOOP;
                                    
                                    cHTML := cHTML||'
                                </tbody>
                                <tfoot class="distaca"><!-- footer da tabela -->
                                      <tr>
                                                <th colspan="7" class="text-center"> 
                                                <img class="icon-logo" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACMUlEQVQ4jaWST0iTcRjHv8/vffdu5bZqhcRq2nLYTFsjSSJIPKwuhSRhlnSKiEG3MJCO3eoQdekQnqOjhRSJ/UFcDSEDg5wr5+twM0zX9i42eN1+Twc3McIO63t44AfP58fzfJ8vMTPhP6TWCl7u6+1yOBwlUQt80OM+tsPpHGtobHxa0wRSyvpXL18IVVHHVQCYbfG6qVw+A4IPDA2EAoAkiKblLte0/8MnEwBuDdw8l8lkgge83scLuh7QrFpMjTd7wsT8ACBtw01eLywhxerKcKzNd//uXs+VU7194XyxiFRywT6/uDQIrJs4QETa5hErfByK2t8c06eaGvb7yIhfb3/0ED/tTuhL379UewWAETD/uSRzmhVLV3NMn6quvVYqyblsDv3LaTxTZefM0SYVAARr2iATnjMzAIapqIgeP5kYOtvz5OKFnslgW0t4LrmYUITi77YooyCAGFeVonkPAIiZabb9iKB8Nrxs0e687Qy5DodCsNfVIRKJYPzNa5lKpX0jGlzEcoIINoDAQHbNvW+PCgCHPn6WAb9/iBjXOkzTtTOdhlWzwsjlUCgWxQ2Vu4lxGwQbmNZdIhpufReVGznI/8qdZ+Zg9H0E84k5KIqCleUfMDKrydPbLScAngTIZEE6g0bLu+vHqleoKgAAecNA3jAqXnJBCHGpNZ6MbhWqzVEeY+ZSBQSAmBAiNL+4tCW8YWL14fW4AyxlhyDxzbrNNjHzNVH6F/zXB7XoN0ir7I+9fhwlAAAAAElFTkSuQmCC"/>
                                                 Datavale - Tecnologia & Sistemas | http://.datavale.com.br/</th>
                                                
                                     </tr>
                                </tfoot>
                              </table>

                          </div>
                      </div>
                  </div>
              </div>
          </div><!-- #################### --- FIM tabela   -- ################################  -->
          </div>
        
        
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
  
Return (cHTML);
  
Exception
      
  When Others Then 
  vErro := vErro || sqlerrm;
  --cHTML := DGEF_ErroListaProdProdutoHTML(vErro,nEmpresa , nSeqProduto);   
  Return (cHTML); 

End DGEFR_RastreioEmbalagens;

End DPKG_RELHTML;
