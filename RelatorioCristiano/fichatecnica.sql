

FUNCTION DGEFR_FichaTecnicaProdutoCMACMA(nSeqProduto in DGE_PRODUTO.SeqProduto%Type, 
                                   nEmpresa ge_empresa.nroempresa%Type ) RETURN CLob IS
  
  cHTML CLob := Null;
  vEmpresa ge_empresa.nroempresa%TYPE := nEmpresa;
  sRazaoSocial GE_Empresa.RazaoSocial%Type;
  vLogo BLOB := NULL;
  vDataAtual varchar2(10) := TO_CHAR(SYSDATE, 'DD/MM/YYYY'); 
  -- Variaveis cidade inicio
  vRazaosocial        GE_Empresa.RAZAOSOCIAL%Type := null;
  vNomeFantasia       GE_Empresa.FANTASIA%Type := null;
  vCNPJ1               GE_Empresa.CNPJENTIDADE%Type := null;
  vCNPJ               varchar2(50):= null;  
  vDDD                GE_Empresa.TELEVENDASDDD%Type := null;
  vTelefone           GE_Empresa.TELEVENDASNRO%Type := null; 
  vLogradouro         GE_Empresa.endereco%Type := null; 
  vNumero             GE_Empresa.endereconro%Type := null; 
  vCep                GE_Empresa.cep%Type := null; 
  vCidade             GE_Empresa.cidade%Type := null; 
  vIE                 GE_Empresa.inscrestadual%Type := null;

-- FICHA TECNICA do produto
  vPdescricao varchar2(500);
  vGtin varchar2(500);
  vDipoa varchar2(500);
  vValidade varchar2(500);
  vConservacao varchar2(500);
  vTempMaxima varchar2(500);
  vTempMinima varchar2(500);
  vUnidadePatrao varchar2(500);
  vPesoMedio varchar2(500);
  vCodSif varchar2(500);
  vPesoMinimo varchar2(500);
  vPesoMax varchar2(500);
  vCodClassFiscal varchar2(500);
  vCodNcm varchar2(500);
  vDescNcm varchar2(500);
  vCodCest varchar2(500);
  vDescCest varchar2(500);
  vMaturado varchar(500);
  
-- DESCRIÇÃO DO PRODUTO
  vIdiomaTipoInd varchar2(500);
  vDesTipoInd varchar2(500);
  vIdiomaInd varchar2(500);
  vDesInd varchar2(500);
  
-- Especificação e caracteristicas do corte 
  vEspecificacaoProduto varchar2(500);
  vCaracteristicaQualidade varchar2(500);
  vCaracteristicaProcesso varchar2(500);
  
-- IMAGEMSDO PRODUTO
   vCorteFrente BLOB := NULL;
   vCorteVerso BLOB := NULL;
   
   vProEmbPriFrente BLOB := NULL;   
   vProEmbPriVerso BLOB := NULL; 
   
   vProEmbSecFrente BLOB := NULL; 
   vProEmbSecVerso BLOB := NULL;
   
   

  BEGIN
   --SELECT IMAGENS DO PRODUTO 
   FOR I IN(
     SELECT 
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
                    AND pa.SeqProduto = 1002                    
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
    
   --SELECT FICHA TECNICA
                  SELECT
                        p.descricao,                                              
                        lpad(pe.gtin,14,0) as gtin,
                        pp.coddipoa AS DIPOA,
                        pp.prazovalidade||' '||DECODE(pp.Tipovalidade, 1,'Dias', 2,'Meses')as validade,                                               
                        DECODE(p.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente')As Conservacao,
                        p.TempMinima||'°C' As TempMinima,
                        p.TempMaxima||'°C' As TempMaxima,
                        DECODE(pe.UNIDADE, 'CX', 'CAIXA', '') As Unidade,
                        pe.PesoMedio, 
                        (select E.codservico from DGE_EMPRESACOMPL E WHERE E.NROEMPRESA = 1) AS SIF,
                        C.CODCLASSFISCAL,
                        Replace(Trim(To_char(c.CODNCM, '0999,90,00')), '.', ',')as NCM,
                        C.DESCRICAO as desNCM,
                        Replace(Trim(To_char(c.cest, '099,990,00')), '.', ',') as CEST,
                        C.DESCRICAOCEST,
                        DECODE(p.maturado,'S','SIM','N','NÃO') AS MATURADO
                     into
                        vPdescricao,
                        vGtin, 
                        vDipoa,
                        vValidade,
                        vConservacao,
                        vTempMaxima,
                        vTempMinima,
                        vUnidadePatrao,
                        vPesoMedio,
                        vCodSif,
                        --vPesoMinimo,
                        --vPesomax,
                        vCodClassFiscal,
                        vCodNcm,
                        vDescNcm,
                        vCodCest,
                        vDescCest,
                        vMaturado 
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
                      IF i.seq =  19336 then
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
                 
      FROM GE_EMPRESA E  where e.nroempresa = vEmpresa; 
   --select embalagem primari
  
 --============ INICIO HTML ====================
cHTML := cHTML ||'    
<!-- 
1.cabesalho
2.tipo produto
3.foto coterte, caracteristica
4.foto do cdo produto embalado
5.descrição da embalagens
6.tabelas 
7.Etiqueta 
8.modelo eriqueta testeira
9.caixa de modelo de etiquedo
10.tabelas insumos embalagem primaria 
11.tabelas insumos embalagem primaria 
-->


<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <style>
        html {
            font-size: 11px;
        }

        .logo {
        width: 100%;
        height: 70px;
        }

        .div {
            border: 0.001rem solid #000
        }
         .container {
            /*box-shadow: 0 .5mm 2mm rgba(0, 0, 0);*/ 
            margin: 3mm auto;
            width: 210mm;
            padding: 5mm 5mm;
            background-color: #fff;
            height: 300mm;
        }

       @ midia print .container {
            /* box-shadow: 0 .5mm 2mm rgba(0, 0, 0);*/ 
            margin: 3mm auto;
            width: 210mm;
            padding: 5mm 5mm;
            background-color: #fff;
            height: 300mm;
        }
        /* body{background-color: #dadada;} */

        .pquebra {
            overflow-wrap: break-word;
            word-wrap: break-word;
            word-break: break-word;
        }

        .distaca {
            background-color: #ddd;
            font-weight: bold;

        }

        .foto {
            margin: 5px auto 5px auto;
            max-height:250px;
            min-height: 200px;
            width: auto;
            height: auto;
            
        }
        .caixa{
            /* border: 1px solid #9b9999; */
            border: 2px solid #ddd;
            margin-bottom: 20px;
            /* box-shadow: -3px 3px 4px #777; */
        }
        .caixat{
            border: 1px solid #9b9999;
            margin-bottom: 20px;
            box-shadow: -5px 5px 0px #666;
            background-color: #ddd;
        }
        .caixa-etiqueta{
            height: 250px;
        }
        p{
            margin: 0px;
            padding: 0px 5px 0px 5px;
        }
        .border{
            border-color: rgb(19, 19, 19);
            border: 2px solid #000;
        }
        
    </style>
    
</head>';

Select
         RazaoSocial, Logo
      Into
         sRazaoSocial, vLogo
      From
         GE_Empresa E
      Where
         E.NroEmpresa = 1;
         
cHTML := cHTML||'
<body class="text-uppercase">

    <div class="container">
        <section id="cabesacho">
        <div class="row b1">

            <div class="col-2">';
            
cHTML := cHTML||'<img class="logo img-fluid" src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vLogo)|| '" />';
cHTML := cHTML||'</div>

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
                        <div>'||vDataAtual||'</div>
                        <div>01</div>
                        
                    </div>
                </div>
            </div>
            <div class="row ">
                  <div class="col fs-3 text-center border-top fw-bold"><p>Ficha tecnica do produto</p></div>
            </div>

        </div>
        </section>
        
        <!-- #################### --- FIM bloco 1 -- ################################  -->
        
        <!-- #################### --- INICIO bloco 2 -- ################################  -->
        <div class="row text-center fw-bold distaca">
            <div class="col-2 my-auto">Tipo produto</div>
            <div class="col-8 text-center my-auto fs-4 border-end border-start border-secondary"> '||To_char(nSeqProduto)||'-'||vPdescricao||'</div>
            <div class="col-2 my-auto">
                <div class="row my-3 ">
                  <div class="col-12">'||vConservacao||'</div>
                  <div class="col-6">min'||vTempMaxima||'</div>
                  <div class="col-6">max'||vTempMinima||'</div>
                </div>
            </div>
        </div>
        <div class="row">
        
            <div class="col-12">
                <div class="row border-dark mt-1">
                    <div class="col-2  fw-bold "><p class="my-auto">Industrial</p></div>
                    <div class="col-2  "><p>'||vIdiomaInd||'</p></div>
                    <div class="col-8  "><p>'||vDesInd||'</p></div>
                </div>
                <div class="row border-dark  mt-1">
                    <div class="col-2  fw-bold "><p class="my-auto">TipoIndustrial</p></div>
                    <div class="col-2  "><p>'||vIdiomaTipoInd||'</p></div>
                    <div class="col-8  "><p>'||vDesTipoInd||'</p></div>
                </div>
                <div class="row border-dark mt-1">
                    <div class="col-2 fw-bold "><p class="my-auto">NCM</p></div>
                    <div class="col-2 "><p>'||vCodNcm||'</p></div>
                    <div class="col-8 "><p>'||vDescNcm||'</p></div>
                </div>
                <div class="row border-dark  mt-1">
                    <div class="col-2  fw-bold "><p class="my-auto">CEST</p></div>
                    <div class="col-2 "><p>'||vCodCest||'</p></div>
                    <div class="col-8  "><p>'||vDescCest||'</p></div>
                </div>                 
                
            </div>
            
        </div>

        <!-- #################### --- FIM bloco 2 -- ################################  -->
        <!-- #################### --- INICIO bloco TABELA INFORMAÇÃO -- ################################  -->
        
        <div class="row">
                <!-- #################### --- FIM tabela  Informações nutricional  -- ################################  -->
                <div class="col-6">
                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            Informações nutricionais    
                        </div>
                        <div class="bg-alert fs-5 fw-bold text-center">
                            Porção de 100g-(1 bife medio)  
                        </div>
                        <div class="row">
                            <div  class="mx-auto col-12">
                                
                                <table class="table align-middle table-bordered border table-striped">
                                    
                                    <thead>
                                  <!--<tr>
                                        <th class="test-center" colspan="4" width="50px">Porção de 100g-(1 bife medio)</th>                                                                             
                                      </tr>-->
                                      <tr>
                                        <!--<th width="50px">ID</th>-->
                                        <th width="200px">descrisao</th>
                                        <th width="50">quantidade</th>
                                        <th width="50">Valor Diaria</th>                                        
                                      </tr>
                                    </thead>
                                    <tbody class="text-break">';
                                    FOR i IN(
                                      select p.ordem,
                                       p.descricao,
                                       p.referencia as quantidade,
                                       p.vlrpercdiario as diario  
                                      from Dge_Produtocomposicao p 
                                      where p.seqproduto = nSeqProduto and p.ordem > 1  order by p.ordem )
                                      LOOP
                                        cHTML := cHTML||' 
                                        <tr>
                                          <!--<th scope="row">'||TO_CHAR(I.ORDEM)||'</th>--->
                                          <td><p>'||TO_CHAR(I.DESCRICAO)||'</p></td>
                                          <td>'||TO_CHAR(I.QUANTIDADE)||'</td>
                                          <td>'||TO_CHAR(I.DIARIO)||'</td>
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
                 <!-- #################### --- FIM TABELA -- ################################  -->
                 <!-- #################### --- INICIO TABELA INFORMASAO GERAL -- ################################  -->
                
                <div class="col-6">                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            Informações Gerais    
                        </div>                        
                        <div class="row">
                            <div  class="mx-auto col-12">
                                
                                <table class="table align-middle table-bordered border table-striped">
                                    
                                                                  
                                    <tbody class="text-break">
                                        
                                        <tr>           
                                          <th scope="row"><p>Código GTIN:</p></th>
                                          <td><p>'||vGtin||'</p></td>
                                        </tr>
                                        <tr>           
                                          <th scope="row"><p>Código DIPOA:</p></th>
                                          <td><p>'||vDipoa||'</p></td>
                                        </tr>
                                        <tr>           
                                            <th scope="row"><p>Código SIF:</p></th>
                                            <td><p>'||vCodSif||'</p></td>
                                        </tr>
                                        <tr>           
                                          <th scope="row"><p>Validade:</p></th>
                                          <td><p>'||vValidade||'</p></td>
                                        </tr>
                                        <tr>           
                                          <th scope="row"><p>Peso Medio:</p></th>
                                          <td><p>'||vPesoMedio||'</p></td>
                                        </tr>
                                        <tr>           
                                          <th scope="row"><p>Emb. Padrao:</p></th>
                                          <td><p>'||vUnidadePatrao||'</p></td>
                                        </tr>
                                        
                                        <tr>           
                                          <th scope="row"><p>Maturado:</p></th>
                                          <td><p>'||vMaturado||'</p></td>
                                        </tr>
                                                                           
                                                                           
                                    </tbody>
                                  </table>
                               
                            </div>
                        </div>
                    </div>
                </div>
                 <!-- #################### --- FIM TABELA INFORMASAO GERAL -- ################################  -->
            </div>
        
        
        <!-- #################### --- INICIO bloco 3 -- ################################  -->
        
             <div class="row"> <!-- #################### --- FIM tabela ENBALAGEM PRIMARIA -- ################################  -->
                <div class="col-12">
                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            Insumos para cadastrar a tara da embalagem primária  
                        </div>
                        <div class="row">
                            <div  class="mx-auto col-12">
                                
                                <table class="table align-middle table-bordered border">
                                    <!-- <caption>List of users</caption> -->
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
                                      FOR i IN(
                                        select p.seqproduto as CÓDIGO,p.descricao as descrição,
                                        decode(e.seqembalagemkititemsubst, null,'PRINCIPAL','SUBSTITUTO') as Insumo,
                                         EM.unidade||'('||EM.quantidade||')' as Unidade
                                        from dge_produto P,dge_embalagemkitinsumo E, dge_PRODUTOEMBALAGEM EM
                                        where (E.Seqprodutodestino = 1002 or E.seqprodutodestino is null)
                                        and E.tipo in(1) and P.Seqproduto = E.Seqproduto and Em.Seqproduto = P.Seqproduto and Em.embalagemindustriapadrao = 'S'
                                        and E.seqembalagemkit  = (select kt.seqembalagemkit from dge_PRODUTOEMBALAGEM PO,dge_produtoembalagemkit KT where PO.Seqproduto = 1002 and PO.embalagemindustriapadrao = 'S'  and KT.seqembalagem = 227)
                                        order by Insumo)
                                        LOOP
                                          if i.insumo = 'SUBSTITUTO' then
                      cHTML := cHTML||' 
                                      <tr class="text-danger" >
                                        <th scope="row" class="text-end">'||TO_CHAR(i.código)||'</th>
                                        <td><p>'||TO_CHAR(i.descrição)||'</p></td>
                                        <td class="text-center">'||TO_CHAR(i.insumo)||'</td>
                                        <td class="text-center">'||TO_CHAR(i.unidade)||'</td>                                        
                                      </tr>
                                      ';
                                      else
                       cHTML := cHTML||' 
                                      <tr>
                                        <th scope="row" class="text-end">'||TO_CHAR(i.código)||'</th>
                                        <td><p>'||TO_CHAR(i.descrição)||'</p></td>
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
            
            <div class="row"> <!-- #################### --- INICIO tabela ENBALAGEM SECUNDARIA  -- ################################  -->
                <div class="col-12">
                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            Insumos para cadastrar a tara da embalagem secundaria  
                        </div>
                        <div class="row">
                            <div  class="mx-auto col-12">
                                
                                <table class="table align-middle table-bordered border">
                                    <!-- <caption>List of users</caption> -->
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
                                      FOR i IN(
                                        select p.seqproduto as CÓDIGO,p.descricao as descrição,
                                        decode(e.seqembalagemkititemsubst, null,'PRINCIPAL','SUBSTITUTO') as Insumo,
                                         EM.unidade||'('||EM.quantidade||')' as Unidade
                                        from dge_produto P,dge_embalagemkitinsumo E, dge_PRODUTOEMBALAGEM EM
                                        where (E.Seqprodutodestino = 1002 or E.seqprodutodestino is null)
                                        and E.tipo in(1) and P.Seqproduto = E.Seqproduto and Em.Seqproduto = P.Seqproduto and Em.embalagemindustriapadrao = 'S'
                                        and E.seqembalagemkit  = (select kt.seqembalagemkit from dge_PRODUTOEMBALAGEM PO,dge_produtoembalagemkit KT where PO.Seqproduto = 1002 and PO.embalagemindustriapadrao = 'S'  and KT.seqembalagem = 227)
                                        order by Insumo)
                                        LOOP
                                          if i.insumo = 'SUBSTITUTO' then
                      cHTML := cHTML||' 
                                      <tr class="text-danger" >
                                        <th scope="row" class="text-end">'||TO_CHAR(i.código)||'</th>
                                        <td><p>'||TO_CHAR(i.descrição)||'</p></td>
                                        <td class="text-center">'||TO_CHAR(i.insumo)||'</td>
                                        <td class="text-center">'||TO_CHAR(i.unidade)||'</td>                                        
                                      </tr>
                                      ';
                                      else
                       cHTML := cHTML||' 
                                      <tr>
                                        <th scope="row" class="text-end">'||TO_CHAR(i.código)||'</th>
                                        <td><p>'||TO_CHAR(i.descrição)||'</p></td>
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
            </div><!-- #################### --- FIM tabela  ENBALAGEM SECUNDARIA -- ################################  -->
        
        <!-- #################### --- FIM bloco 3 -- ################################  -->
        <!-- #################### --- INICIO bloco 4 IMA-- ################################  -->
        

            <!-- #################### --- FIM bloco 4 -- ################################  -->
            
            <!-- #################### --- FIM bloco 6 -- ################################  -->
            </div>
            <div class="container">
            <!-- #################### --- INICIO bloco 5 -- ################################  -->
            <div class="row text-center  fs-4 caixa">
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
            <div class="row text-center fw-bold fs-5 caixa">
                <div class="distaca ">Foto corte do produto</div>
                <div class="col-6">
                    <div class="row">
                        <div class="col">
                            <img class="img-fluid foto" src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vCorteFrente)|| '" alt="" />
                        </div>
                    </div>
                </div>
                <div class=" col-6 border-left">
                    <div class="row">
                        <div class="col">
                            <img class="img-fluid foto" src="data:image/png;base64,'||DPKG_Library.DGEF_ImagemBase64(vCorteVerso)||'" alt="" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="row caixa">
                <div class=" distaca text-center fw-bold mb-2 fs-4"><p class="">Descrição de embalagens</p></div>
                <div class=" col-8 text-center fw-bold"><p class="">Produto na embalagem primaria</p></div>
                <div class=" col-4 fw-bold text-center"><p class="">primaria</p></div>                

                
                    <div class="col-8 ">
                            
                            <div class="row">
                                <div class="col-6">
                                    <img class="img-fluid foto" src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vProEmbPriFrente)|| '" alt="" />
                                </div>
                                <div class="col-6">
                                    <img class="img-fluid foto" src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vProEmbPriVerso)|| '" alt="" />
                                </div>
                            </div>
                        
                    </div>
        
                    <div class="col-4 my-auto text-center">
                        
                                <p>
                                    texto texto texto texto texto texto
                                    texto texto texto texto texto texto
                                    texto texto texto texto texto texto
                                    texto texto texto texto texto texto
                                </p>
                            
                    </div>
                <div class=" col-8 text-center fw-bold"><p class="">Produto embalagem secundaria</p></div>
                <div class=" col-4 fw-bold text-center"><p class="">descrição</p></div> 
                    <div class="col-8 ">
                        <div class="row">
                            <div class="col-6">
                                <img class="img-fluid foto" src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vProEmbSecFrente)|| '" alt="" />
                            </div>
                            <div class="col-6">
                                <img class="img-fluid foto" src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vProEmbSecVerso)|| '" alt="" />
                            </div>
                        </div>
                    
                    </div>
    
                <div class="col-4 my-auto text-center">
                    
                            <p>
                                texto texto texto texto texto texto
                                texto texto texto texto texto texto
                                texto texto texto texto texto texto
                                texto texto texto texto texto texto
                            </p>
                </div>
                
            </div>
            <!-- #################### --- FIM bloco 5 -- ################################  -->
            </div>
            <!-- #################### --- Inicio bloco 6 -- ################################  -->
            <div class="container">
            
            <div class="row text-center fw-bold fs-5 caixa">
                <div class="distaca ">Foto do produto embalado</div>
                <div class="col-6">
                    <div class="row">
                        <div class="distaca ">Primária</div>
                        <div class="col">
                            <img class="img-fluid foto" src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vCorteVerso)|| '" alt="" />
                        </div>
                    </div>
                </div>
                <div class="col-6">
                    <div class="row">
                        <div class="distaca ">Secundária</div>
                        <div class="col">
                            <img class="img-fluid foto" src="data:image/png;base64,'||DPKG_Library.DGEF_ImagemBase64(vCorteVerso)||'" alt="" />
                        </div>
                    </div>
                </div>
            </div>
                <div class="row text-center  fs-5 caixa">
                    <div class="distaca ">Descrição das embalagens</div>
                    <div class="col-6">
                        <div class="row border">
                            <div class="distaca ">Primária</div>
                            <div class="col fs-6">
                                <p>texto texto texto texto.</p>
                                <p>texto texto texto texto.</p>
                                <p>texto texto texto texto.</p>
                                <p>texto texto texto texto.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="row border">
                            <div class="distaca ">Secundária</div>
                            <div class="col fs-6 ">
                                <p>texto texto texto texto.</p>
                                <p>texto texto texto texto.</p>
                                <p>texto texto texto texto.</p>
                                <p>texto texto texto texto.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container">
            <!-- #################### --- inicio bloco 7 -- ################################  -->
            
            
            <div class="row">
            
                <div class="col-6">
                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            informações adicionais
                        </div>
                        <div class="row">
                            <div class="col-6">
                                <p>validade:</p>
                                <p>validade:</p>
                                <p>validade:</p>
                                <p>validade:</p>
                                <p>validade:</p>
                            </div>
                    
                            <div class="col-6">
                                <p>90 dias:</p>
                                <p>535:</p>
                                <p>3254:</p>
                                <p>51:</p>
                                <p>nao:</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            informações adicionais
                        </div> 
                            <div class="row">
                                <div class="col-6">
                                    <p>validade:</p>
                                    <p>validade:</p>
                                    <p>validade:</p>
                                    <p>validade:</p>
                                    <p>validade:</p>
                                </div>           
                            
                                <div class="col-6">
                                    <p>90 dias:</p>
                                    <p>535:</p>
                                    <p>3254:</p>
                                    <p>51:</p>
                                    <p>nao:</p>
                                </div>
                            </div>
                    </div>
                        
                   
                </div> 

                <div class="col-6 ">
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            informações adicionais
                        </div> 
                            <div class="row">
                                <div class="col-6">
                                    <p>validade:</p>
                                    <p>validade:</p>
                                    <p>validade:</p>
                                    <p>validade:</p>
                                    <p>validade:</p>
                                </div>           
                            
                                <div class="col-6">
                                    <p>90 dias:</p>
                                    <p>535:</p>
                                    <p>3254:</p>
                                    <p>51:</p>
                                    <p>nao:</p>
                                </div>
                            </div>
                    </div>  
                </div>                
            </div>
            <div class="row ">
                
                    <div class="col caixat">
                        <p>
                        Texto Texto Texto
                        Texto Texto Texto Texto Texto Texto Texto Texto Texto.
                        Texto Texto TextoTexto Texto Texto Texto Texto.  
                        </p>
                        <p>
                            Texto Texto Texto
                            Texto Texto Texto Texto Texto Texto Texto Texto Texto.
                            Texto Texto TextoTexto Texto Texto Texto Texto.  
                        </p>
                        <p>
                            Texto Texto Texto
                            Texto Texto Texto Texto Texto Texto Texto Texto Texto.
                            Texto Texto TextoTexto Texto Texto Texto Texto.  
                        </p>
                    </div>
                
            </div>
            <!-- #################### --- FIM bloco 7 -- ################################  -->

            <!-- #################### --- FIM bloco 8 -- ################################  -->
            <div class="row">
                <div class="col-12">
                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            Etiquetas
                        </div>
                        <div class="row">
                            <div  class="mx-auto col-6">
                                <img class="foto img-fluid  " src="1.jpg"/>                                
                            </div>
                            <div class="row">
                                <div  class="mx-auto col-7 caixat">
                                    <p>isbdvkibsdkifyvbsoi aiuvisudfiuvs siudngfisundfu</p>                               
                                    <p>isbdvkibsdkifyvbsoi aiuvisudfiuvs siudngfisundfu</p>                               
                                    <p>isbdvkibsdkifyvbsoi aiuvisudfiuvs siudngfisundfu</p>                               
                                </div>
                            </div>           
                        </div>
                    </div>
                </div> 

                              
            </div>
            <!-- #################### --- FIM bloco 8 -- ################################  -->
            <!-- #################### --- inicio bloco 9 -- ################################  -->
            <div class="row">
                <div class="col-12">
                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            Modelo da etiqueta testeira: imagem meramente ilustrativa
                        </div>
                        <div class="row">
                            <div class="col-11 mx-auto ">
                                <img class="  foto img-fluid mx-auto  " src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vCorteVerso)|| '"/>                                
                            </div>                            
                                                                  
                        </div>
                    </div>
                </div>               
            </div>
            <div class="row ">
                
                <div class="col caixat">
                    <p>
                        Texto Texto Texto
                        Texto Texto Texto Texto Texto Texto Texto Texto Texto.
                        Texto Texto TextoTexto Texto Texto Texto Texto.  
                    </p>
                    <p>
                        Texto Texto Texto
                        Texto Texto Texto Texto Texto Texto Texto Texto Texto.
                        Texto Texto TextoTexto Texto Texto Texto Texto.  
                    </p>
                    <p>
                        Texto Texto Texto
                        Texto Texto Texto Texto Texto Texto Texto Texto Texto.
                        Texto Texto TextoTexto Texto Texto Texto Texto.  
                    </p>
                </div>
            
            </div>
            <!-- #################### --- FIM bloco 9 -- ################################  -->
            </div>
            <div class="container">
            <!-- #################### --- FIM bloco 10 -- ################################  -->
            <div class="row">
                <div class="col-12">
                    
                    <div class=" ">

                        <div class="row fs-5 fw-bold  ">                           

                                <div class=" col-3  rounded-top text-center distaca">
                                    Uso exclusivo de bataguassu
                                </div>

                                <div class=" col-5 fs-5 fw-bold ms-auto rounded-top distaca">
                                    COLAR A ETIQUETA COM O "SHIPPNG MARK" INFORMADO PELO CLIENTE
                                </div>                           
                        </div>

                        <div class="row ">
                            <div class="col-12 border border-5 ">
                                <!-- <img class="mx-auto  foto img-fluid  " src="1.jpg"/> -->
                                <div class="col caixa-etiqueta">
                                    
                                </div>
                            </div>                            
                                                                  
                        </div>

                        <div class="row fs-5 fw-bold  ">                           

                            <div class=" col-5  rounded-bottom  text-center distaca">
                                <p>Espaço Reservado para USDA.</p>
                                <p>As Etiquetas não podem sobrepor este espaço.</p>
                            </div>
                                                      
                        </div>

                    </div>
                    
                </div>               
            </div>    
            <br/>        
            <!-- #################### --- FIM bloco 10 -- ################################  -->
            
            <div class="row">
                <!-- #################### --- FIM tabela  Informações nutricional  -- ################################  -->
                <div class="col-6">
                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            Informações nutricionais    
                        </div>
                        <div class="bg-alert fs-5 fw-bold text-center">
                            Porçãode de 100g-(1 bife medio)  
                        </div>
                        <div class="row">
                            <div  class="mx-auto col-12">
                                
                                <table class="table text-center align-middle table-bordered border table-striped">
                                    
                                    <thead>
                                      <tr>
                                        <th width="50px">ID</th>
                                        <th width="200px">descrisao</th>
                                        <th width="50">quantidade</th>
                                        <th width="50">Valor Diaria</th>                                        
                                      </tr>
                                    </thead>
                                    <tbody class="text-break ">';
                                    FOR i IN(
                                      select p.ordem,
                                       p.descricao,
                                       p.referencia as quantidade,
                                       p.vlrpercdiario as diario  
                                      from Dge_Produtocomposicao p 
                                      where p.seqproduto = nSeqProduto and p.ordem > 1  order by p.ordem )
                                      LOOP
                                        cHTML := cHTML||' 
                                        <tr>
                                          <th scope="row">'||TO_CHAR(I.ORDEM)||'</th>
                                          <td><p>'||TO_CHAR(I.DESCRICAO)||'</p></td>
                                          <td>'||TO_CHAR(I.QUANTIDADE)||'</td>
                                          <td>'||TO_CHAR(I.DIARIO)||'</td>
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
                 <!-- #################### --- FIM TABELA -- ################################  -->
                 <!-- #################### --- INICIO TABELA INFORMASAO GERAL -- ################################  -->
                
                <div class="col-6">                    
                    <div class="caixa">
                        <div class="distaca fs-5 fw-bold text-center">
                            Informações Gerais    
                        </div>                        
                        <div class="row">
                            <div  class="mx-auto col-12">
                                
                                <table class="table align-middle table-bordered border table-striped">
                                    
                                                                  
                                    <tbody class="text-break">
                                        
                                        <tr>           
                                          <th scope="row"><p>Código GTIN:</p></th>
                                          <td><p>'||vGtin||'</p></td>
                                        </tr>
                                        <tr>           
                                          <th scope="row"><p>Código DIPOA:</p></th>
                                          <td><p>'||vDipoa||'</p></td>
                                        </tr>
                                        <tr>           
                                            <th scope="row"><p>Código SIF:</p></th>
                                            <td><p>'||vCodSif||'</p></td>
                                        </tr>
                                        <tr>           
                                          <th scope="row"><p>Validade:</p></th>
                                          <td><p>'||vValidade||'</p></td>
                                        </tr>
                                        <tr>           
                                          <th scope="row"><p>Peso Medio:</p></th>
                                          <td><p>'||vPesoMedio||'</p></td>
                                        </tr>
                                        <tr>           
                                          <th scope="row"><p>Emb. Padrao:</p></th>
                                          <td><p>'||vUnidadePatrao||'</p></td>
                                        </tr>
                                        
                                        <tr>           
                                          <th scope="row"><p>Maturado:</p></th>
                                          <td><p>'||vMaturado||'</p></td>
                                        </tr>
                                                                           
                                                                           
                                    </tbody>
                                  </table>
                               
                            </div>
                        </div>
                    </div>
                </div>
                 <!-- #################### --- FIM TABELA INFORMASAO GERAL -- ################################  -->
            </div>
            

        </div><!--fim container -->


        

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
            crossorigin="anonymous"></script>
</body>

</html>';
            RETURN(cHTML);
      
      
   Exception
    When Others Then
       Return (cHTML);
   
   END DGEFR_FichaTecnicaProdutoCMA;
