FUNCTION DGEFR_VersaoFichaTecnica (nSeqProduto in DGE_PRODUTO.SeqProduto%Type, 
                                   nEmpresa ge_empresa.nroempresa%Type,
                                   nDataVercao dtvind_produtoversao.dataversao%type,
                                   nCondicao string, 
                                   nNroVersao dtvind_produtoversao.nroversao%type
                                   ) RETURN CLob Is
    
    cHTML               CLob := Null;
    vErro               CLob := Null;
    vMsg                CLob := Null;
    vEmpresa            ge_empresa.nroempresa%TYPE := nEmpresa;
    sRazaoSocial        GE_Empresa.RazaoSocial%Type;
    vLogo               BLOB := NULL;
    vDataAtual          varchar2(10) := TO_CHAR(SYSDATE, 'DD/MM/YYYY'); 


 --inico bloco funsao 
BEGIN
   -- if nSeqProduto is not null 

    if nCondicao = 'Inserir Versão' then
      
         cHTML := cHTML || DGEF_InserirVersaoFichaTecnica(nSeqProduto,nEmpresa ,nDataVercao ,nCondicao ,nNroVersao);
      
    elsif nCondicao = 'Visualizar Relatório' then

         cHTML := cHTML || DGEF_viewVersaoFichaTecnica(nSeqProduto,nEmpresa ,nDataVercao ,nCondicao ,nNroVersao);

    elsif nCondicao = 'Deletar Versão' then

         cHTML := cHTML || DGEF_DeletarVersaoFichaTecnica(nSeqProduto,nEmpresa ,nDataVercao ,nCondicao ,nNroVersao);

    else 
         vErro := '<p>O capo de <b>Ação Desejada</b> não foi informado.</p>
                   <p>Informe a <b>Ação Desejada</b> e tente novamente.</p> ';
              
         cHTML := cHTML||'
                      <!doctype html>
                      <html lang="en">

                      <head>
                          <meta charset="utf-8">
                          <meta name="viewport" content="width=device-width, initial-scale=1">
                          <title>Erro FichaTecnica</title>
                          
                              <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/bootstrap.css" />
                              <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" />    
                              
                          
                      </head>

                      <body class="text-uppercase">

                          <div id="Page1" class="A4">
                                  '||DGEF_CabecalhoHTML(' ',2,nSeqProduto,nEmpresa)||'
                                  
                             <div class="alert alert-warning d-flex align-items-center" role="alert">
                               <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2" viewBox="0 0 16 16" role="img" aria-label="Warning:">
                                 <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                               </svg>
                               <div>
                                   '||vErro||'             
                               </div>
                             </div>
                             <p>seqproduto:<b>'||To_char(nSeqProduto)||'</b></p>
                             <p>nroverssao:<b>'||To_char(nNroVersao)||'</b></p>
                             <p>dataversao:<b>'||To_char(nDataVercao)||'</b></p>
                             <p>acao:<b>'||To_char(nCondicao)||'</b></p>
                             <p>empresa:<b>'||To_char(nEmpresa)||'</b></p>
                             
                          </div><!--fim A4 Page1-->
                          
                          
                          <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
                      </body>

                      </html>';
    end if;

    RETURN(cHTML);     
      
Exception

    When Others Then
       Return (cHTML||vErro);
                           
END DGEFR_VersaoFichaTecnica;
FUNCTION DGEFR_VersaoFichaTecnica (nSeqProduto in DGE_PRODUTO.SeqProduto%Type, 
                                   nEmpresa ge_empresa.nroempresa%Type,
                                   nDataVercao dtvind_produtoversao.dataversao%type,
                                   nCondicao string, 
                                   nNroVersao dtvind_produtoversao.nroversao%type
                                   ) RETURN CLob Is
    
    cHTML               CLob := Null;
    vErro               CLob := Null;
    vMsg                CLob := Null;
    vEmpresa            ge_empresa.nroempresa%TYPE := nEmpresa;
    sRazaoSocial        GE_Empresa.RazaoSocial%Type;
    vLogo               BLOB := NULL;
    vDataAtual          varchar2(10) := TO_CHAR(SYSDATE, 'DD/MM/YYYY'); 


 --inico bloco funsao 
BEGIN
   -- if nSeqProduto is not null 

    if nCondicao = 'Inserir Versão' then
      
         cHTML := cHTML || DGEF_InserirVersaoFichaTecnica(nSeqProduto,nEmpresa ,nDataVercao ,nCondicao ,nNroVersao);
      
    elsif nCondicao = 'Visualizar Relatório' then

         cHTML := cHTML || DGEF_viewVersaoFichaTecnica(nSeqProduto,nEmpresa ,nDataVercao ,nCondicao ,nNroVersao);

    elsif nCondicao = 'Deletar Versão' then

         cHTML := cHTML || DGEF_DeletarVersaoFichaTecnica(nSeqProduto,nEmpresa ,nDataVercao ,nCondicao ,nNroVersao);

    else 
         vErro := '<p>O capo de <b>Ação Desejada</b> não foi informado.</p>
                   <p>Informe a <b>Ação Desejada</b> e tente novamente.</p> ';
              
         cHTML := cHTML||'
                      <!doctype html>
                      <html lang="en">

                      <head>
                          <meta charset="utf-8">
                          <meta name="viewport" content="width=device-width, initial-scale=1">
                          <title>Erro FichaTecnica</title>
                          
                              <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/bootstrap.css" />
                              <link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" />    
                              
                          
                      </head>

                      <body class="text-uppercase">

                          <div id="Page1" class="A4">
                                  '||DGEF_CabecalhoHTML(' ',2,nSeqProduto,nEmpresa)||'
                                  
                             <div class="alert alert-warning d-flex align-items-center" role="alert">
                               <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2" viewBox="0 0 16 16" role="img" aria-label="Warning:">
                                 <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                               </svg>
                               <div>
                                   '||vErro||'             
                               </div>
                             </div>
                             <p>seqproduto:<b>'||To_char(nSeqProduto)||'</b></p>
                             <p>nroverssao:<b>'||To_char(nNroVersao)||'</b></p>
                             <p>dataversao:<b>'||To_char(nDataVercao)||'</b></p>
                             <p>acao:<b>'||To_char(nCondicao)||'</b></p>
                             <p>empresa:<b>'||To_char(nEmpresa)||'</b></p>
                             
                          </div><!--fim A4 Page1-->
                          
                          
                          <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
                      </body>

                      </html>';
    end if;

    RETURN(cHTML);     
      
Exception

    When Others Then
       Return (cHTML||vErro);
                           
END DGEFR_VersaoFichaTecnica;
