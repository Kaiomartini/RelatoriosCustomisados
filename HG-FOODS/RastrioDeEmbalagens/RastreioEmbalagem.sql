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
