FUNCTION DGEFR_ListaProdutoVenda(    nEmpresa string,
                                     nInicioPeriudo string,
                                     nFimPeriudo string,                                     
                                     nTabelaPreso string,
                                     nSeqCliente string,
                                     nSeqRede string                                     
                                    ) RETURN CLob is 
      
 cHTML               CLob := Null;
 vErro               CLob := Null;
 vVenda              varchar2(500);
 pnSeqRede           GE_REDEPESSOA.SeqRede%TYPE := nSeqRede; --52; 
 pnSeqPessoa         GE_PESSOA.SeqPessoa%TYPE := nSeqCliente;--15367;
 pnFiltro            INTEGER;
 vRow                numeric(10) := 0;
 --vInicioPeriudo      date := nInicioPeriudo;
 --vFimPeriudo date := nFimPeriudo;
 vDescRede           varchar(500):= null;
 vDescCliente        varchar(500):= null;
 vTabeladePreco      varchar(500):= null;
 
    
 
begin
  -- if valida se os campos de periodo foi informado. 
  if nInicioPeriudo is null or nFimPeriudo is null then 
      vErro := '<p> O campo empresa não foi informado.</p>
                <p> Informe-os e tente novamente.</p>';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa,'');
    return (cHTML);
    
  elsif nInicioPeriudo > nFimPeriudo then     
      vErro := '<p> O campo de Período Final deve ser maior que Período Inicial.</p>
                <p> Informe-os e tente novamente.</p>';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa, ''); 
    return (cHTML);
    
  end if; 
    
  -- if valida se o campo empresa foi informado. 
  if nEmpresa is null or  nEmpresa = 0 then    
      vErro := '<p> O campo empresa não foi informado, informe o campo e tente novamente.</p>';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa, ''); 
    return (cHTML);
  end if;  

  -- if valida e carrega tabela de preço 
  if nTabelaPreso is not null then 
      select tp.NroTabPreco ||'-'|| tp.Descricao as tabela 
      into vTabeladePreco
      FROM   DGEV_TABPRECO tp
      where  tp.SeqTabPreco = nTabelaPreso
      group by tp.NroTabPreco, tp.Descricao;
  else
      vErro := '<p> Tabela de Preço é um campo obrigatório. </p>
                <p> Informe-o e tente novamente.</p>';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa, ''); 
    return (cHTML);
  end if;
  
  -- if verifica se o campo rede ou Cliente possui dados.    
  if nSeqCliente <> 0 and nSeqCliente is not null or nSeqRede is not null then 
      --if se for passado cliente e rede ele anula a rede e busca por cliente 
       if nSeqCliente <> 0 and nSeqCliente is not null and  nSeqRede is not null then
         pnSeqRede := null;
       end if;
       
      -- if para carregar informações de rede 
      if nSeqRede is not null then 
          SELECT r.descricao
          into vDescRede 
          from  ge_rede r 
          where r.seqrede = nSeqRede;    
      end if; 
      
      -- if para carregar informações de cliente 
      if nSeqCliente <> 0 and nSeqCliente is not null then 
          SELECT p.nomerazao,r.descricao 
          into vDescCliente,vDescRede
          from ge_redepessoa rp, ge_rede r, ge_pessoa p 
          where 
               r.seqrede = rp.seqrede 
               and p.seqpessoa = rp.seqpessoa 
               and p.seqpessoa = nSeqCliente;       
      end if;
      
  else
      vErro := '
               <p>Campo rede e cliente não informados.</p>
               <p>Informe ao menos um campo e tente novamente.</p>
               ';
      cHTML := DGEF_ErroFichaTecnicaHTML(vErro, nEmpresa, ''); 
    return (cHTML); 
  end if;

  IF NVL(pnSeqRede, 0) = 0 THEN 
      pnFiltro := pnSeqPessoa;
    ELSE 
      pnFiltro := pnSeqRede;
    END IF;

   declare cursor cDados is 
     SELECT  
             --DISTINCT pv.SeqCliente, 
             tp.SeqProduto,
             tp.DescrProduto,
             tp.Unidade as descUnidade,
             --tp.Unidade ||' - '||(select xu.descricao from dge_unidade xu where xu.unidade = tp.Unidade) as descUnidade,
             --tp.Descricao,
             --tp.NroPlanta,
             --tp.SeqEmbalagem, 
             tp.VlrPraticado,
             c.VlrMedio,
             c.vlricms as icms,
             c.vlroutroscofins as cofins,
             c.vlrisentospis as pis
                   
      FROM   DGEV_TABPRECO tp, --dge_produto pr,
             
             (SELECT  nfi.SeqProduto, nfi.SeqEmbalagem, 
                      ROUND(SUM(nfi.VlrProduto)/SUM(nfi.Quantidade), 2) VlrMedio,
                      nfi.vlricms ,
                      nfi.vlroutroscofins ,
                      nfi.vlrisentospis  
              FROM    DCV_NOTAFISCAL nf,
                      DCV_PEDIDO pv,
                      GE_REDEPESSOA rp,
                      DCV_NFISCALITEM nfi
              WHERE   pv.SeqPedido = nf.SeqPedido 
                      AND nfi.SeqNotaFiscal = nf.SeqNotaFiscal 
                      AND nf.TipoNota = 'S'
                      AND nf.SituacaoNF = 4
                      AND nf.NroEmpresa = 1
                      AND nf.DtaEmissao BETWEEN nInicioPeriudo AND nFimPeriudo --filtro                       
                      --AND pv.SeqCliente = pnSeqPessoa --filtro
                      AND (CASE WHEN NVL(pnSeqRede, 0) > 0 THEN
                                  rp.SeqRede
                             ELSE pv.SeqCliente END) = pnFiltro 
                               
              GROUP BY nfi.SeqProduto, nfi.SeqEmbalagem,
                       nfi.vlricms,nfi.vlroutroscofins,nfi.vlrisentospis) c
      WHERE   c.SeqProduto (+) = tp.SeqProduto
              AND c.SeqEmbalagem (+)= tp.SeqEmbalagem
              --and  pr.sitproduto(+) = tp.SeqProduto
             -- and  pr.sitproduto = 'A'
              AND tp.SeqTabPreco = nTabelaPreso -- nTabelaPreso  --99983 --filtro
              and tp.EmbalagemVendaPadrao = 'S'              
              --and  ROWNUM <= 1000
              order by c.VlrMedio;
  begin
  
  cHTML := cHTML ||'
  <!doctype html>
  <html lang="en">

  <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>ListaVendaProduto</title>
      
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
          <style>'||DGEF_FichaTecnicaCss()||'</style>
             
          <script src="https://www.codigofonte.com.br/wp-content/uploads/legado/codigos/880/sorttable.js"></script> 
  </head>

  <body class="text-uppercase">

      <div id="Page1" class="A4">
          
                                     <!-- <p>nEmpresa       '||To_char(nEmpresa)||'</p>
                                     <p>nInicioPeriudo '||To_char(nInicioPeriudo)||'</p>
                                     <p>nFimPeriudo    '||To_char(nFimPeriudo)||'</p>   
                                     <p>nTabelaPreso   '||To_char(nTabelaPreso)||'</p> 
                                     <p>nSeqCliente    '||To_char(nSeqCliente)||'</p> 
                                     <p>nSeqRede       '||To_char(nSeqRede)||'</p> --> 
                                     
                                     
            '||DGEF_CabecalhoFichaTecnica('Lista de vendas por Rede ou clinte',2,'',nEmpresa)||'
           
                           
            <div class="row mb-3"> <!-- row descrições do produto -->
                <div class="col-12 ">
                   <table id="info" class="table border text-center">
                    <thead>
                      <tr>
                        <th class="col-3"></th>
                        <th class="col-9"></th>                
                      </tr>
                    </thead>
                    <tbody class="text-center">
                      <tr class="py-2">
                        <th scope="row" class=" table-active p-2" >Rede</th>
                        <td class="p-2">'||vDescRede||' </td>                    
                      </tr>
                      <tr>
                        <th scope="row" class=" table-active p-2" >Clientes</th>
                        <td class="p-2">'||vDescCliente||'</td>                    
                      </tr>                 
                      <tr>
                        <th scope="row" class=" table-active p-2" >Tabela de Preço</th>
                        <td class="p-2">'||vTabeladePreco ||'</td>                    
                      </tr>
                      <tr>
                        <th scope="row" class=" table-active p-2" >Inico Periodo </th>
                        <td class="p-2">
                               <b>'||To_char(To_date(nInicioPeriudo),'DD/MM/YYYY')
                               ||' </b> á <b>                       
                               '||To_char(To_date(nFimPeriudo),'DD/MM/YYYY')||' </b>
                        </td>                    
                      </tr>
                      
                        
                    </tbody>
                  </table>
               </div>
          </div>
              
          <div class="row apagar-print"> <!-- #################### --- barra de pesquisa -- ################################  -->
              <div class="col-5 mb-1">
                  
                  <div class="input-group flex-nowrap">
                      <span class="input-group-text" id="addon-wrapping">Pesquisar</span>
                      <input id="input-busca" type="text" class="form-control" placeholder="Username" aria-label="Username" aria-describedby="addon-wrapping">
                  </div>
                  
              </div>
          </div>
          
          <div id="rowTabelaVenda" class="row"> <!-- #################### --- inicio tabela VERSAO-- ################################  -->
              <div class="col-12">
                  <div  class="caixa border-0">
                      <div class="distaca fs-4 fw-bold text-center">                          
                      </div>
                      <div class="row">
                          <div id="divVendaProdutoCliente" class="mx-auto col-12">

                              <table id="TabelaVendaProdutoCliente" class="table align-middle table-bordered border table-striped sortable">
                                  <thead>
                                      <tr class="text-center">
                                         <!--<th width="50">#</th> -->   
                                          <th width="50">código do produto</th>                                        
                                          <th width="150px">desc produto</th>               
                                          <th width="50">unidade</th>       
                                          <th width="50">vlr venda </th>   
                                          <!-- <th width="50">seqcliente</th> -->
                                          <th width="50">vlr Médio Venda</th>
                                          <th width="50">icms</th>
                                          <th width="50">Pis/Cofins</th>                                   
                                      </tr>
                                  </thead>
                                  <tbody id="tabela-dados" class="text-break">';
                                  for i in cDados
                                              loop
                                                
                                                cHTML := cHTML ||'
                                                     <tr>
                                                           <!-- <td></td> -->
                                                           
                                                           <td class="text-center">'||To_char(i.SeqProduto)||'</td>
                                                           <td>'||To_char(i.DescrProduto)||'</td>
                                                           <td class="text-center" >'||To_char(i.descUnidade)||'</td>
                                                                        
                                                           
                                                           <td class="text-center">'||To_char(i.VlrPraticado)||'</td>';
                                                      if i.VlrMedio is not null then
                                                        cHTML := cHTML ||'
                                                           <td class="text-center">'||To_char(i.VlrMedio)||'</td>
                                                           <td class="text-center">'||To_char(i.icms)||'</td>
                                                           <td class="text-center">'||To_char(i.pis)||'/'||To_char(i.cofins)||'</td>
                                                           ';
                                                      else     
                                                        cHTML := cHTML ||'   
                                                           <td class="text-center table-danger" colspan="3">
                                                                Produto Não Possui Venda
                                                           </td>
                                                           ';
                                                      end if;
                                              cHTML := cHTML ||'                                              
                                                     </tr>';
                                                     vRow := vRow + 1;
                                              end loop;
                                                                                 
                                  cHTML := cHTML ||'   
                                  </tbody>
                                  <tfoot><!-- footer da tabela -->
                                      <tr>
                                          <th colspan="7" class="text-center">Datavale - Tecnologia & Sistemas | http://.datavale.com.br/</th>
                                          
                                      </tr>
                                  </tfoot>
                              </table>

                          </div>
                      </div>
                  </div>
              </div>
          </div><!-- #################### --- FIM tabela  VERSAO -- ################################  -->
          
          <p>Row  '||To_char(vRow)||'</p>
          
          
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
  end;
  Return (cHTML);
Exception
      
  When Others Then 
  vErro := vErro || sqlerrm;
  --cHTML := DGEF_ErroFichaTecnicaHTML(vErro,nEmpresa , '');   
  Return (vErro);
END DGEFR_ListaProdutoVenda;
