
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

