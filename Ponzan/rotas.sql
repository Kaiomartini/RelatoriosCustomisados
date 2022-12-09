CREATE OR REPLACE Package DPKG_RELHTML Is

  -- Functions
   Function DGEF_CabecalhoHTML(psNomeRelatorio String,
                               pnNroEmpresa GE_EMPRESA.NroEmpresa%Type) Return CLob;

   Function DGEF_RodapeHTML Return CLob;
   
   ------ ficha técnica 
   
   Function DGEF_ErroFichaTecnicaHTML(nErro string,
                                   nEmpresa ge_empresa.nroempresa%Type,
                                   nSeqProduto in DGE_PRODUTO.SeqProduto%Type
                                   ) Return CLob;
                                   
   Function DGEF_FichaTecnicaCss Return CLob;
   
   Function DGEF_CabecalhoFichaTecnica(nNomeRelatorio string,
                               nTipo numeric,
                               nSeqProduto in DGE_PRODUTO.SeqProduto%Type, 
                               nEmpresa ge_empresa.nroempresa%Type                               
                               ) Return CLob;
   
   Function DGEFR_FichaTecnicaPonzan(nSeqproduto  in DGE_PRODUTO.SeqProduto%Type, 
                                  nEmpresa ge_empresa.nroempresa%Type,
                                  nUf_Cliente string, 
                                  nRegimeTributacao string) RETURN CLob;
                                  
   FUNCTION DGEF_ExportarArquivoExcel(nId_button string,
                                      nid_tabela string) RETURN CLob;
                                      
  /* FUNCTION DGEFR_ListaProduto( nSeqproduto  in DGE_PRODUTO.SeqProduto%Type
      ) RETURN CLob;*/
      
    ---- relatorio de venda 
   FUNCTION DGEFR_ListaProdutoVenda( nEmpresa string,
                                     nInicioPeriudo string,
                                     nFimPeriudo string,                                     
                                     nTabelaPreso string,
                                     nSeqCliente string,
                                     nSeqRede string                                     
                                    ) RETURN CLob;
                                  

End DPKG_RELHTML;
