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
    
    vDESCRICAO               varchar2(500) := null;
    vUnidadePD               varchar2(500) := null;
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
    vDIMENSAODAUNIDADE       varchar2(500) := null;
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
    vUnidadeMC                  varchar2(500) := null;
    vDescUnidadeMC               varchar2(500) := null;
    vDimensaoMC                         varchar2(500) := null;
    vQuantidadeMC              varchar2(500) := null;
    vPesoLiquidoMC               varchar2(500) := null;
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
         
  -- select ALIQUOTA PIS E COMFINS 
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
           (select * from Dgevg_Fichatecnica)
   loop
     
    vDESCRICAO           := i.descproduto;
    vUnidadePD           := i.unidade;
    vQUANTIDADEFARDO     := i.quantidade;
    vEAN                 := i.ean;
    vDUM                 := i.dum;
    vNCM                 := i.ncm;
    vCEST                := i.cest;
    vVALIDADE            := i.validade;
    --vPESOLIQUIDOUNIDADE  := TO_CHAR(i.liquidounidade);
    --vPESOLIQUIDOUNIDADE  := TO_Char(i.liquidounidade, 'FM999G999G990D000', 'nls_numeric_characters='',.''');
    vPESOBRUTODAUNIDADE  := TO_Char(i.brutounidade, 'FM999G999G990D000', 'nls_numeric_characters='',.''');
    vPESOLIQUIDOFARDO    := TO_Char(i.liquidocaixa, 'FM999G999G990D000', 'nls_numeric_characters='',.''');
    vPESOBRUTOFARDO      := TO_Char(i.brutocaixa, 'FM999G999G990D000', 'nls_numeric_characters='',.''');
   -- vPESOLIQUIDOFARDO    := i.liquidocaixa;
    --vPESOBRUTOFARDO      := i.brutocaixa;
    vDIMENSAODAUNIDADE   := i.dimensaounidade;
    vDIMENSAODOFARDO     := i.dimensaocaixa;
    vINGREDIENTES        := i.ingredientes;
    vMODOCONSERVACAO     := i.conservacao;
    vMODOPREPARO         := i.modopreparo;
    vPALETIZACAO         := i.cadastrogenerico;    
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
          and pe.seqproduto  = 8)
          
     loop
       vUnidadeMC  := i.unidade;   
       vDescUnidadeMC := i.descricao; 
       vDimensaoMC  := i.dimensao;  
       vQuantidadeMC := i.quantidade; 
       vPesoLiquidoMC:= TO_Char(i.pesomedio, 'FM999G999G990D000', 'nls_numeric_characters='',.''');      
     
     end loop;   
    
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

    <div id="Page1" class="A4">
        
            '||DGEF_CabecalhoFichaTecnica('Ficha Técnica',2,nSeqProduto,nEmpresa)||'
            
          <div class="row text-center fw-bold distaca mb-2 py-3 mx-0">
            <div class="col-2 my-auto">produto</div>
            <div class="col-10 text-center my-auto fs-4 border-start border-secondary"> 
            '||to_char(nSeqproduto)||' - '||vDESCRICAO||'
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
                                            <p>ALIQUOTA DE PIS COFINS:</p>
                                        </th>
                                        <td>
                                            <p>'||vPis||'/'||vCofins||'</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">
                                            <p>ALIQUETA DE ICMS:</p>
                                        </th>
                                        <td>
                                            <p>'||vIcms||'</p>
                                        </td>
                                    </tr>                                   
                                    <tr>
                                        <th scope="row">
                                            <p>ALIQUETA ST/MVA:</p>
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
            <div class="col distaca text-center fw-bold border border-white fs-5">MENOR UNIDADE DE CONTROLE ('||vUnidadeMC||')</div>
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
                <div class="col distaca text-center fw-bold border border-white fs-5">UNIDADE DE VENDA('||vUnidadePD||')</div>
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
       
       <div class="row mx-0"> <!-- row descrições do produto -->
            <div class="col-12 zebra">
                <div class="row border-dark mt-1">
                    <div class="col-2  fw-bold ">
                        <p class="my-auto">INGREDIENTES</p>
                    </div>
                    <div class="col-10  ">
                        <p>'||vINGREDIENTES||'</p>
                    </div>
                    
                </div>
                <div class="row border-dark  mt-1">
                    <div class="col-2  fw-bold ">
                        <p class="my-auto">INFORMAÇÃO NUTRICIONAL</p>
                    </div>                    
                    <div class="col-8  ">
                        <p>'||vInfoNutricionais||'</p>
                    </div>
                </div>
                <div class="row border-dark mt-1">
                    <div class="col-2 fw-bold ">
                        <p class="my-auto">MODO DE CONSERVAÇÃO</p>
                    </div>
                    <div class="col-2 ">
                        <p>'||vMODOCONSERVACAO||'</p>
                    </div>
                    
                </div>
                <div class="row border-dark  mt-1">
                    <div class="col-2  fw-bold ">
                        <p class="my-auto">PALETIZAÇÃO</p>
                    </div>
                    <div class="col-2 ">
                        <p>'||vPALETIZACAO ||'</p>
                    </div>
                    
                </div>
            </div>
        </div> <!-- fim row descrições do produto -->

        <div class="row">
            <div class="col-2">
                ingrediente  
            </div>
            <div class="col-10">
                ingrediente  
            </div>

        </div>
    
</div><!-- fim page 1 -->            
            
<div id="Page2" class="A4">   
            
        <button type="button" id="bt1" class="btn btn-primary">Exportar</button>
        <div id="embalagem" class="row"> <!-- #################### --- inicio tabela VERSAO-- ################################  -->
            <div class="col-12">
                <div class="caixa border-0">
                    
                    <div class="row">
                        <div id="tabelaFTP" class="mx-auto col-12 table-responsive">

                            <table class="table align-middle table-bordered border table-striped">
                                <thead>
                                    <tr class="text-center">
                                        <th width="50">CÓDIGO</th>
                                        <th width="50">DESCRIÇÃO</th>
                                        <th width="50">TIPO UNIDADE</th>
                                        <th width="50">QNT UNIDADE</th>
                                        <th width="50">EAN</th> 
                                        <th width="50">DUM</th>
                                        <th width="50">NCM</th>
                                        <th width="50">CEST</th>
                                        <th width="50">VALIDADE</th>
                                        <th width="50">PESO LIQUIDO UNIDADE</th>
                                        <th width="50">PESO BRUTO DA UNIDADE</th>
                                        <th width="50">PESO LIQUIDO FARDO/CAIXA</th>
                                        <th width="50">PESO BRUTO FARDO / CAIXA</th>
                                        <th width="50">DIMENSÃO DA UNIDADE</th>
                                        <th width="50">DIMENSÃO DO FARDO </th>
                                        <th width="50">ALIQUETA DE ICMS </th>
                                        <th width="50">ALIQUETA ST/MVA </th>
                                        <th width="50">INGREDIENTES</th>
                                        <th width="50">MODO DE CONSERVAÇÃO</th>
                                        <th width="50">MODO DE PREPARO</th>
                                        <th width="50">PALETIZAÇÃO</th>                                        
                                    </tr>
                                </thead>
                                <tbody class="text-break">
                                    ';
                               begin
                                    FOR i IN
                                         (select * from Dgevg_Fichatecnica )                                                                             
                                     LOOP
                                                                  
                                        cHTML := cHTML||'
                                            <tr>
                                                <td class="text-center ">'||TO_CHAR(i.seqproduto)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.descproduto)||'</td>                                                
                                                <td class="text-center ">'||TO_CHAR(i.unidade)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.quantidade)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.ean)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.dum)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.ncm)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.cest)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.cest)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.brutounidade)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.liquidocaixa)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.brutocaixa)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.dimensaounidade)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.dimensaocaixa)||'</td>
                                                
                                                <td class="text-center ">'||TO_CHAR(i.ingredientes)||'</td>
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
                    </div>
                </div>
            </div>
        </div><!-- #################### --- FIM tabela  VERSAO -- ################################  -->
       <!-- <p>'||vIcms||'</p>            
        <p>'||vSt||'</p>              
        <p>'||vMva ||'</p>          
        <p>'||vPis ||'</p>            
        <p>'||vCofins ||'</p>         
        <p>'||vInfoNutricionais||'</p>-->
    </div><!--fim A4 Page2-->
    
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
