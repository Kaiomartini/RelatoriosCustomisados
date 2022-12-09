CREATE OR REPLACE Package DPKG_RELHTML Is

  -- Functions
   Function DGEF_CabecalhoHTML(psNomeRelatorio String,
                               pnNroEmpresa GE_EMPRESA.NroEmpresa%Type
                               ) Return CLob;

   Function DGEF_RodapeHTML Return CLob;
   
   -- lista produto por produção 
  
   
   Function DGEF_ErroListaProdProdutoHTML(nErro    string,
                                          nEmpresa numeric                                   
                                          ) Return CLob;
                                   
   Function DGEF_ListaProdProdutoCss Return CLob;
   
   Function DGEF_CabecalhoListaProdProduto(nNomeRelatorio string,                              
                                           nEmpresa       numeric                              
                                           ) Return CLob;
   

   FUNCTION DGEF_ExportarArquivoExcel(nId_button string,
                                      nid_tabela string) RETURN CLob;
                                      
   Function DGEFR_ListaProdProduto(nEmpresa      numeric, 
                                   nGrupProd     numeric,
                                   nSubGrupProd  numeric 
                                   ) Return CLob;
                                   
   Function DGEFR_RastreioEmbalagens( nEmpresa numeric, 
                                    nSeqEmbalagem numeric ) Return CLob;

End DPKG_RELHTML;
