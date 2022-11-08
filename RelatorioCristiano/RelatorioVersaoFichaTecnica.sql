FUNCTION DGEFR_VersaoFichaTecnica (nSeqProduto in DGE_PRODUTO.SeqProduto%Type, 
                                   nEmpresa ge_empresa.nroempresa%Type,
                                   nDataVercao dtvind_produtoversao.dataversao%type,
                                   nCondicao string, 
                                   nNroVersao dtvind_produtoversao.nroversao%type
                                   ) RETURN CLob Is
    
    cHTML               CLob := Null;
    vErro               CLob := Null;
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
   
-- ESTILO DA CONDIÇÃO 
   vStyle                   CLOB:= NULL;

-- VERSAO DO RELATORIO 
   vCodVersao               varchar(6);
   vDataVersao              varchar(10); 

 --inico bloco funsao 
BEGIN
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
      e.nroempresa = 1;
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

 --============ INICIO HTML ====================
if nCondicao = ' Inserir Versão' then
  
vErro := '<p>mersap cadastrada com susesso </P>
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
            '||DGEF_CabecalhoHTML(nSeqProduto,1)||'
            
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
  
elsif nCondicao = 'Visualizar Relatório' then

cHTML := cHTML ||'
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>FichaTecnica</title>
    
        <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/bootstrap.css" />
        <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" />     
    
</head>

<body class="text-uppercase">

    <div id="Page1" class="A4">
        
            '||DGEF_CabecalhoHTML(nSeqProduto,1)||'
            
        
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
                                        <th width="50">seqproduto</th>                                        
                                        <th width="150px">desc produto</th>
                                        <th width="50">Data</th>
                                        <th width="50">Versão</th>
                                        
                                    </tr>
                                </thead>
                                <tbody class="text-break">
                                    ';
                                    FOR i IN
                                         (select   
                                            
                                              pv.seqproduto,
                                              p.descricao,
                                              Max(pv.dataversao)as utmaData,
                                              To_char(Max(pv.nroversao),'000')as maiorVersao                                                
                                          from 
                                              DGE_produto p, 
                                              dge_grupoproduto gp, 
                                              dge_tipoproduto tp, 
                                              dtvind_produtoversao pv                                              
                                          where
                                              p.grupoprod = gp.grupoprod
                                              and p.seqproduto = pv.seqproduto 
                                              and tp.tipoproduto = gp.tipoproduto
                                              and gp.tipoproduto = 2
                                              and gp.grupoprod in (3,4)
                                              and (P.SeqProduto = nSeqProduto OR nSeqProduto = 0)
                                          group by 
                                            pv.seqproduto, p.descricao
                                           ORDER BY
                                              P.SeqProduto)                                                                             
                                    LOOP
                                                                  
                                        cHTML := cHTML||'
                                            <tr>
                                                <td class="text-center ">'||TO_CHAR(i.seqproduto)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.descricao)||'</td>                                                
                                                <td class="text-center ">'||TO_CHAR(i.utmadata, 'DD/MM/YYYY')||'</td>
                                                <td class="text-center fw-bold ">'||TO_CHAR(i.maiorversao)||'</td>
                                                                                            
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
    
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
</body>

</html>';

elsif nCondicao = 'Deletar Versão' then

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
            '||DGEF_CabecalhoHTML(nSeqProduto,1)||'
            
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
            '||DGEF_CabecalhoHTML(nSeqProduto,1)||'
            
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
end if;


    RETURN(cHTML);     
      
Exception

    When Others Then
       Return (cHTML);
                           
END DGEFR_VersaoFichaTecnica;
