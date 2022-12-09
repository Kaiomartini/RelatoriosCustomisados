<div id="embalagem" class="row"> <!-- #################### --- inicio tabela VERSAO-- ################################  -->
                        <div class="mx-auto col-12">
                            <table class="table align-middle table-bordered border table-striped sortable">
                                <thead>
                                    <tr class="text-center">
                                        <th width="50">Produto</th>                                    
                                    </tr>
                                    <tr class="text-center">
                                        <th class="col-1">Produto</th>                                        
                                        <th class="col-2">Descrição</th>
                                        <th class="col-1">EAN</th>
                                        <th class="col-1">DUM</th>
                                        <th class="col-1">Data produção</th>
                                        <th class="col-1">Conservação</th>
                                                                              
                                    </tr>
                                </thead>
                                <tbody class="text-break">
                                    ';
                              
                                    FOR i IN
                                         (select  pr.seqproduto,
                                                  pr.descricao,
                                                  (select lpad(xpe.gtin,14,0) from DIN_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and xpe.menorunidcontrole = 'S') as EAN,
                                                  (select lpad(xpe.gtin,14,0) from DIN_PRODUTOEMBALAGEM xpe where xpe.seqproduto  = pr.seqproduto and XPE.EMBALAGEMINDUSTRIAPADRAO = 'S')AS DUM,
                                                  (SELECT  max(xe.Dtaproducao) FROM DIN_Estoque xe WHERE xe.SeqProduto = pr.seqproduto AND xe.TabLinkEnt = 'DIN_PROGPRODUCAOITEM'
                                                   AND xe.status not in (6,9) AND xe.seqestoqueorigem is not null ) as dataProducao,
                                                   DECODE(pr.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente')As Conservacao
                                          from din_produto pr  --, din_grupoproduto
                                          where pr.status = 'A' 
                                          and pr.grupoprod = 4)                                                                             
                                     LOOP
                                                                  
                                        cHTML := cHTML||'
                                            <tr>
                                            
                                                <td class="text-center ">'||TO_CHAR(i.seqproduto)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.descricao)||'</td> 
                                                <td class="text-center ">'||TO_CHAR(i.Ean)||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.Dum)||'</td>                                               
                                                <td class="text-center ">'||TO_CHAR(i.dataproducao, 'DD/MM/YYYY')||'</td>
                                                <td class="text-center ">'||TO_CHAR(i.conservacao)||'</td> 
                                                
                                                                                            
                                            </tr>
                                        ';
                                                                                    
                                    END LOOP;
                                    
                                    cHTML := cHTML||'
                                </tbody>
                                <tfoot><!-- footer da tabela -->
                                      <tr>
                                          <th colspan="7" class="text-center">Datavale - Tecnologia & Sistemas | http://.datavale.com.br/</th>
                                          
                                      </tr>
                                </tfoot>
                            </table>

                        </div>
        </div><!-- #################### --- FIM tabela  prod produção  -- ################################  -->