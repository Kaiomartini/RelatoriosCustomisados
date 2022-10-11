FUNCTION DINFR_FichaTecnicaProduto(nSeqProduto DIN_Produto.SeqProduto%Type) RETURN CLob IS
         
      cHTML              CLob := Null;
      rHTML              CLob := Null;
      cPrimaria          cLob := Null;
      cSecundaria        cLob := Null;
      cInfProd           cLob := Null;            
      vSeqIdioma         Number := 0;
          
                           
   BEGIN     
      
      
     /*Incíio do HTML e configuração de Head*/
      cHTML := cHTML||'<html>';
      cHTML := cHTML||'<head>';
      cHTML := cHTML||'<meta charset="utf-8">';
      cHTML := cHTML||'<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">';     
      
      cHTML := cHTML||'<style type="text/css">';/*
      cHTML := cHTML||'@page {margin: 0} @media (max-width: 900px) {html {width: 100%;}} body { margin: 0 }';
      cHTML := cHTML||'.sheet{ margin: 0; overflow: hidden; position: relative; box-sizing: border-box; page-break-after: always;}';
      cHTML := cHTML||'body.A4 .sheet { width: 210mm; } .sheet.padding { padding: 10mm 10mm }' ;
      cHTML := cHTML||'.g{width:80px} .gg{width:150px} ';
      cHTML := cHTML||'.destaque{background-color: #D3D3D3; margin: 0px;} ';
      cHTML := cHTML||'@media screen { body { background: #e0e0e0 } .sheet { background: white; box-shadow: 0 .5mm 2mm rgba(0,0,0,.3); margin: 5mm auto; }}';
      cHTML := cHTML||'@media print { body.A4 { width: 210mm } body {-webkit-print-color-adjust: exact;}}';
      cHTML := cHTML||'.TopDiv{float:left; width: 100%; border-top: 2px solid; border-bottom: 1px solid; border-left: 2px solid; border-right: 2px solid; height: 25px; text-align: center; font-size: 25px;}';
      cHTML := cHTML||'.PrimeiraDiv{float: left; margin-left: 0px; width: auto; height: 20px; border-top: 1px solid ; border-left: 2px solid; border-bottom: 1px Solid; padding: 5px; border-right: 1px solid;}';
      cHTML := cHTML||'.divIntervalo{font-size: 15px; text-align:center; padding:0px}';*/
      cHTML := cHTML||'img{margin: 8px 3px 3px 3px}';
      cHTML := cHTML||'.img-responsive{border:2px solid #0000; float:left;}
      
        p{
        font-size: 9px;        
        overflow-wrap: break-word;
            word-wrap: break-word;
            word-break: break-word;
         }
         .container{
         padding:0px;
         }
         th{font-size:12px}
         .table>:not(caption)>*>* {
                                  padding: 0px;
                                  background-color: var(--bs-table-bg);
                                  border-bottom-width: 1px;
                                  box-shadow: inset 0 0 0 9999px var(--bs-table-accent-bg);
         }
         
         
          </style>';
      
      cHTML := cHTML||'</head>';   
      /*Início do Corpo*/
      cHTML := cHTML||'<body class="A4">';
      cHTML := cHTML||'<section class="sheet padding">';
      cHTML := cHTML|| DGEF_CabecalhoTeste('Ficha Técnica do Produto', 1);
      --rHTML := rHTML|| DGEF_RodapeHTML;
      cHTML := cHTML||'<div class="divIntervalo">';
      --cHTML := cHTML||'<br/>Data Abate '|| vDtaProducao || '<br/>';
      cHTML := cHTML||'<table style="background-color: #fff; width: 20%; font-size:9px" align="left" cellspacing=0 border=0>';   
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" colspan = 12>Produto';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">Código Produto/Descrição</th>';
      cHTML := cHTML||'</tr>';
      
                               
      FOR i IN (   
              
                 SELECT p.SeqProduto||'-'||p.Descricao As Produto
                   FROM DIN_Produto p
                  WHERE p.SeqProduto = To_Char(nSeqProduto)
                    
                 
      )
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.Produto) ||'</td>';
         cHTML := cHTML||'</tr>';
       
      END LOOP;
      cHTML := cHTML||'</table>';
      
      

      cHTML := cHTML||'<table style="background-color: #fff; width: 30%; font-size:9px" align="left" cellspacing=0 border=0>';   
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" colspan = 12>Descrições do Produto</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">Descrições Industrial e Tipo Industrial</th>';
      cHTML := cHTML||'</tr>';
      
                               
      FOR i IN (         
                 SELECT pd.Descricao
                   FROM DIN_PRODUTODESCRICAO pd, DIN_IDIOMA i
                  WHERE pd.TipoDescricao IN (4,5)
                    AND pd.SeqProduto = TO_Char(nSeqProduto) 
                    AND pd.SeqIdioma = i.SeqIdioma
               ORDER BY pd.TipoDescricao Desc
                    
                 
      )
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.Descricao) ||'</td>';
         cHTML := cHTML||'</tr>';
       
      END LOOP;
      
      
      cHTML := cHTML||'</table>';
      cHTML := cHTML||'<table style="background-color: #fff; width: 50%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" colspan = 12>Informações do Produto</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">Tipo Produto</th>';
      cHTML := cHTML||'<th align = "left">Grupo Produto</th>';
      cHTML := cHTML||'<th align = "left">SubGrupo Produto</th>';
      cHTML := cHTML||'<th align = "left">Familia Produto</th>';
      cHTML := cHTML||'</tr>';
                         
      FOR n IN ( 
                  SELECT tp.Descricao As TipoProduto, gp.Descricao As GrupoProduto, sp.Descricao As SubGrupoProduto, fp.DescrFamilia As FamiliaProduto
                    FROM DIN_PRODUTO p, DIN_GrupoProduto gp,  DIN_TipoProduto tp, DIN_SubGrupoProduto sp, DIN_FamiliaProduto fp
                   WHERE p.GrupoProd = gp.GrupoProd
                     AND gp.TipoProduto = tp.TipoProduto
                     AND p.SubGrupoProd = sp.SubGrupoProd
                     AND p.FamiliaProd = fp.FamiliaProd
                     AND p.SeqProduto = To_Char(nSeqProduto)
                )           
      
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(n.TipoProduto) ||'</td>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(n.GrupoProduto) ||'</td>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(n.SubGrupoProduto) ||'</td>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(n.FamiliaProduto) ||'</td>';
         cHTML := cHTML||'</tr>';
       
      END LOOP;
      cHTML := cHTML||'</table><br/>';
      cHTML := cHTML||'</br></br></br></br>';
      --------------------------------------------------########
cHTML := cHTML||'
      <div class="">
        <table class="table">       
            <thead>
              <tr class="table-secondary">
                <th colspan="9" class="text-center">Ficha Tecnica</th>            
              </tr>
            </thead>
            <tbody>
                  <tr >
                    <td class="fw-bold"><p class="">Gtim</p></td>
                    <td class="fw-bold"><p class="">Dipoa</p></td>
                    <td class="fw-bold"><p class="">Sif</p></td>
                    <td class="fw-bold"><p class="">Conservação</p></td>
                    <td class="fw-bold"><p class="">Prazo de Validade</p></td>
                    <td class="fw-bold"><p class="">Temperatura Mínima</p></td>
                    <td class="fw-bold"><p class="">Temperatura Máxima</p></td>
                    <td class="fw-bold"><p class="">Embalagem Padrão</p></td>
                    <td class="fw-bold"><p class="">Peso Médio</p></td>
                  </tr>
   ';
                  FOR i IN ( 
                      SELECT 
                        lpad(pe.gtin,14,0) as gtin,
                        p.CodDipoa,
                        p.PrazoValidade||' '||DECODE(p.TipoValidade, 1, 'Dias', 2, 'Meses') As Validade,
                        DECODE(p.Conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente')As Conservacao,
                        p.TempMinima||' '||'°C' As TempMinima,
                        p.TempMaxima||' '||'°C' As TempMaxima,
                        DECODE(pe.UNIDADE, 'CX', 'CAIXA', '') As Unidade,
                        pe.PesoMedio ,
                       (SELECT codservico FROM Dge_Empresacompl) as sif
                      FROM DIN_PRODUTO P, DIN_PRODUTOEMBALAGEM Pe WHERE P.SEQPRODUTO = Pe.Seqproduto AND PE.EMBALAGEMINDUSTRIAPADRAO = 'S' AND P.SEQPRODUTO= To_Char(nSeqProduto)    
                    )              
          
                  LOOP
             
                      cHTML := cHTML||'<tr>';
                      cHTML := cHTML||'<td ><p class="">'|| TO_Char(i.gtin) ||'</p></td>';
                      cHTML := cHTML||'<td ><p class="">'|| TO_Char(i.coddipoa) ||'</p></td>';
                      cHTML := cHTML||'<td ><p class="">'|| TO_Char(i.sif) ||'</p></td>';
                      cHTML := cHTML||'<td ><p class="">'|| TO_Char(i.conservacao) ||'</p></td>';
                      cHTML := cHTML||'<td ><p class="">'|| TO_Char(i.validade) ||'</p></td>';
                      cHTML := cHTML||'<td ><p class="">'|| TO_Char(i.tempminima) ||'</p></td>';
                      cHTML := cHTML||'<td ><p class="">'|| TO_Char(i.tempmaxima) ||'</p></td>';
                      cHTML := cHTML||'<td ><p class="">'|| TO_Char(i.unidade) ||'</p></td>';
                      cHTML := cHTML||'<td ><p class="">'|| TO_Char(i.pesomedio) ||'</p></td>';                     
                       cHTML := cHTML||'</tr>';  

                  END LOOP;
                  
  cHTML := cHTML||'            
              </tbody>
          </table>
      </div>
';
      -----------------------------------------------#########
------------------------------------------------INFORMAÇÕES FICHA TÉCNICA-------------------------------------------------------


     /* cHTML := cHTML||'<table style="background-color: #fff; width: 15%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" align="left" colspan = 12>Ficha Técnica</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">EAN 13(GTIN)</th>';
      cHTML := cHTML||'</tr>';   
                         
      FOR i IN ( 
                  SELECT pe.Gtin
                    FROM Din_Produtoembalagem pe
                   WHERE pe.Unidade = 'PC'
                     AND pe.SeqProduto = (nSeqProduto)
                )                
      
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.Gtin) ||'</td>';
         cHTML := cHTML||'</tr>';    
      END LOOP;
      cHTML := cHTML||'</table>';
      
      
      cHTML := cHTML||'<table style="background-color: #fff; width: 10%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" align="left" colspan = 12>''</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">DIPOA</th>';      
      cHTML := cHTML||'</tr>';            
                         
      FOR i IN ( 
                  SELECT p.CodDipoa
                    FROM Din_Produto p
                   WHERE p.SeqProduto = (nSeqProduto)
                )     
      
      LOOP         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.CodDipoa) ||'</td>';
         cHTML := cHTML||'</tr>';       
      END LOOP;
      cHTML := cHTML||'</table>';
      
      
      
      cHTML := cHTML||'<table style="background-color: #fff; width: 10%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" align="left" colspan = 12>''</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">SIF</th>';
      cHTML := cHTML||'</tr>';               
                         
      FOR i IN ( 
                  SELECT DECODE(ROWNUM, 1,'2258', NULL) AS SIF
                    FROM Dual
                )                 
      
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.Sif) ||'</td>';
         cHTML := cHTML||'</tr>';       
      END LOOP;
      cHTML := cHTML||'</table>';
      
      
      
      
      cHTML := cHTML||'<table style="background-color: #fff; width: 10%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" align="left" colspan = 12>''</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">Prazo de Validade</th>';
      cHTML := cHTML||'</tr>';          
                         
      FOR i IN ( 
                  SELECT p.PrazoValidade||' '||DECODE(p.TipoValidade, 1, 'Dias', 2, 'Meses') As Validade
                    FROM DIN_Produto p
                   WHERE p.SeqProduto = To_Char(nSeqProduto) 
                )       
      
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.Validade) ||'</td>';
         cHTML := cHTML||'</tr>';       
      END LOOP;
      cHTML := cHTML||'</table>';

      
      
      cHTML := cHTML||'<table style="background-color: #fff; width: 10%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" align="left" colspan = 12>''</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">Conservação</th>';
      cHTML := cHTML||'</tr>';          
                         
      FOR i IN ( 
                  SELECT DECODE(p.Conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente')As Conservacao
                    FROM DIN_Produto p
                   WHERE p.SeqProduto = To_Char(nSeqProduto) 
                )       
      
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.Conservacao) ||'</td>';
         cHTML := cHTML||'</tr>';       
      END LOOP;
      cHTML := cHTML||'</table>';
      
      
      
      
      cHTML := cHTML||'<table style="background-color: #fff; width: 10%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" align="left" colspan = 12>''</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">Temperatura Mínima</th>';
      cHTML := cHTML||'</tr>';          
                         
      FOR i IN ( 
                  SELECT p.TempMinima||' '||'°C' As TempMinima
                    FROM DIN_Produto p
                   WHERE p.SeqProduto = To_Char(nSeqProduto) 
                )       
      
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.TempMinima) ||'</td>';
         cHTML := cHTML||'</tr>';       
      END LOOP;
      cHTML := cHTML||'</table>';
      
      
      
      
      cHTML := cHTML||'<table style="background-color: #fff; width: 10%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" align="left" colspan = 12>''</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">Temperatura Máxima</th>';
      cHTML := cHTML||'</tr>';          
                         
      FOR i IN ( 
                  SELECT p.TempMaxima||' '||'°C' As TempMaxima
                    FROM DIN_Produto p
                   WHERE p.SeqProduto = To_Char(nSeqProduto) 
                )       
      
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.TempMaxima) ||'</td>';
         cHTML := cHTML||'</tr>';       
      END LOOP;
      cHTML := cHTML||'</table>';


      
      
      cHTML := cHTML||'<table style="background-color: #fff; width: 10%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" align="left" colspan = 12>''</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">Embalagem Padrão</th>';
      cHTML := cHTML||'</tr>';          
                         
      FOR i IN ( 
                  SELECT DECODE(pe.UNIDADE, 'CX', 'CAIXA', '') As Unidade
                    FROM DIN_ProdutoEmbalagem pe
                   WHERE pe.EmbalagemIndustriaPadrao = 'S'
                     AND pe.SeqProduto = To_Char(nSeqProduto) 
                )       
      
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.Unidade) ||'</td>';
         cHTML := cHTML||'</tr>';       
      END LOOP;
      cHTML := cHTML||'</table>';
      
      
      
      
      
      
      cHTML := cHTML||'<table style="background-color: #fff; width: 15%; font-size:9px" align="left" cellspacing=0 border=0>';       
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th class="destaque" style="font-size:12px;" align="left" colspan = 12>''</th>';
      cHTML := cHTML||'</tr>';
      cHTML := cHTML||'<tr>';
      cHTML := cHTML||'<th align = "left">Peso Médio</th>';
      cHTML := cHTML||'</tr>';          
                         
      FOR i IN ( 
                  SELECT pe.PesoMedio
                    FROM DIN_ProdutoEmbalagem pe
                   WHERE pe.EmbalagemIndustriaPadrao = 'S'
                     AND pe.SeqProduto = To_Char(nSeqProduto) 
                )       
      
      LOOP
         
         cHTML := cHTML||'<tr>';
         cHTML := cHTML||'<td align="left">'|| TO_Char(i.PesoMedio) ||'</td>';
         cHTML := cHTML||'</tr>';       
      END LOOP;
      cHTML := cHTML||'</table></br></br>';*/
      


----------------------------------------------INCIO IMAGENS DOS PRODUTOS-------------------------------------------------------------      

      cHTML := cHTML||'</br><div class="img-responsive"; ">          
                       <div class="destaque text-center""><b>Imagens do Corte do Produto</b></div>';
     
                     
      FOR i IN(          
                 SELECT aa.Conteudo
                   FROM dge_arquivoanexo@DtvAdm aa, DGE_ProdutoAnexo@DtvAdm pa
                  WHERE aa.CodLink = pa.SeqProdutoAnexo
                    AND aa.TabLink = 'DGE_PRODUTOANEXO'
                    AND pa.SeqProduto = To_Char(nSeqProduto)
                    AND pa.Codigo = 1
               ORDER BY aa.Descricao   
      )
      LOOP
      
        
         cHTML := cHTML || '<img align="middle" src="data:image/jpg;base64,' || DPKG_Library.DGEF_ImagemBase64(i.Conteudo) || '" class="img-responsive"; height="200" width="230";>';
        
        /*  cHTML := cHTML || '<div align="middle" class="img-fluid" style="background-image: url(data:image/jpg;base64,' || DPKG_Library.DGEF_ImagemBase64(i.Conteudo) ||'); background-position: center ; background-repeat: no-repeat;background-size: cover; width: 50mm; height: 50mm;" alt="..." ></div>';
      */
      END LOOP;
      cHTML := cHTML||'</div>';
      
      

      
     cHTML := cHTML||'<div class="img-responsive"; style="border:2px solid #0000; float:left;">          
                       <div class="destaque text-center"><b>Imagens do Produto Embalado</b></div>';
     
                     
      FOR i IN(          
                 SELECT aa.Conteudo
                   FROM dge_arquivoanexo@DtvAdm aa, DGE_ProdutoAnexo@DtvAdm pa
                  WHERE aa.CodLink = pa.SeqProdutoAnexo
                    AND aa.TabLink = 'DGE_PRODUTOANEXO'
                    AND pa.SeqProduto = To_Char(nSeqProduto)
                    AND pa.Codigo = 2
               ORDER BY aa.Descricao   
      )
      LOOP
      
        
         cHTML := cHTML || '<img align="middle" src="data:image/jpg;base64,' || DPKG_Library.DGEF_ImagemBase64(i.Conteudo) || '" class="img-responsive"; height="200" width="230";>';
         
      END LOOP;
      cHTML := cHTML||'</div>';
      
      

       cHTML := cHTML||'</div>';
      cHTML := cHTML||'</section>';
      cHTML := cHTML||'</body>';
      cHTML := cHTML||'</html>';
------------------------------------------------OUTRA PAGINA - EMBALAGEM------------------------------------------------------------------------     

      
     /*Incíio do HTML e configuração de Head*/
      cHTML := cHTML||'<html>';
      cHTML := cHTML||'<head>';
      cHTML := cHTML||'<meta charset="utf-8">';
      cHTML := cHTML||'<style type="text/css">';
      cHTML := cHTML||'@page {margin: 0} @media (max-width: 900px) {html {width: 100%;}} body { margin: 0 }';
      cHTML := cHTML||'.sheet{ margin: 0; overflow: hidden; position: relative; box-sizing: border-box; page-break-after: always;}';
      cHTML := cHTML||'body.A4 .sheet { width: 210mm; } .sheet.padding { padding: 10mm 10mm }' ;
      cHTML := cHTML||'.g{width:80px} .gg{width:150px} ';
      cHTML := cHTML||'.destaque{background-color: #D3D3D3} ';
      cHTML := cHTML||'@media screen { body { background: #e0e0e0 } .sheet { background: white; box-shadow: 0 .5mm 2mm rgba(0,0,0,.3); margin: 5mm auto; }}';
      cHTML := cHTML||'@media print { body.A4 { width: 210mm } body {-webkit-print-color-adjust: exact;}}';
      cHTML := cHTML||'.TopDiv{float:left; width: 100%; border-top: 2px solid; border-bottom: 1px solid; border-left: 2px solid; border-right: 2px solid; height: 25px; text-align: center; font-size: 25px;}';
      cHTML := cHTML||'.PrimeiraDiv{float: left; margin-left: 0px; width: auto; height: 20px; border-top: 1px solid ; border-left: 2px solid; border-bottom: 1px Solid; padding: 5px; border-right: 1px solid;}';
      cHTML := cHTML||'.divIntervalo{font-size: 15px; text-align:center; padding:0px}';
      cHTML := cHTML||'</style>';
      cHTML := cHTML||'<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">'; 
      cHTML := cHTML||'</head>';   
      /*Início do Corpo*/
      cHTML := cHTML||'<body class="A4">';
      cHTML := cHTML||'<section class="sheet padding">';
      cHTML := cHTML|| DGEF_CabecalhoTeste('Ficha Técnica do Produto', 1);
      cHTML := cHTML||'<div class="divIntervalo">';
      --cHTML := cHTML||'<br/>Data Abate '|| vDtaProducao || '<br/>';
      cHTML := cHtml||'</div>';
      
   
    cPrimaria := '<table style="background-color: #fff; width: 30%; font-size:9px" align="left" cellspacing=0 border=0></br></br></br>';        
    cPrimaria := cPrimaria||'<tr>';
    cPrimaria := cPrimaria||'<th class="destaque" style="font-size:12px;" colspan = 12>Embalagem Produto</th>';
    cPrimaria := cPrimaria||'</tr>';
    cPrimaria := cPrimaria||'<tr>';
    cPrimaria := cPrimaria||'<th align = "left">Primaria</th>';
    cPrimaria := cPrimaria||'<th align = "right">Fechamento Primaria</th>';  
    cPrimaria := cPrimaria||'</tr>';
    
      declare cursor cDados IS
             SELECT p2.descricao As Primaria, DECODE(ROWNUM, 1,'Vácuo', NULL) As FechamentoEmb
               
               FROM DIN_Produto p, DIN_ProdutoEmbalagem pe, DIN_Produtoembalagemkit pek, DIN_EmbalagemKitInsumo eki, DIN_Produto p2
              WHERE p.SeqProduto = pe.SeqProduto
                AND pe.SeqEmbalagem = pek.SeqEmbalagem
                AND pe.EmbalagemIndustriaPadrao = 'S'
                AND pek.SeqEmbalagemKit = eki.SeqEmbalagemKit
                AND p2.SeqProduto = eki.SeqProduto
                AND eki.Tipo = 1
                AND p.SeqProduto = TO_Char(nSeqProduto);
      BEGIN
              for i in cDados
                LOOP
                  cPrimaria := cPrimaria||'<tr>';
                  cPrimaria := cPrimaria||'<td>'||i.Primaria||'</td>';
                  cPrimaria := cPrimaria||'<td>'||i.FechamentoEmb||'</td>';
                  cPrimaria := cPrimaria||'</tr>';
                END LOOP;  
      END;
      cPrimaria := cPrimaria||'</table>';
  
      
 


    cSecundaria := '<table style="background-color: #fff; width: 20%; font-size:9px" align="left" cellspacing=0 border=0>';
    cSecundaria := cSecundaria||'<tr>';
    cSecundaria := cSecundaria||'<th class="destaque" style="font-size:12px;" colspan = 12>''</th>';
    cSecundaria := cSecundaria||'</tr>';
    cSecundaria := cSecundaria||'<tr>';
    cSecundaria := cSecundaria||'<th align = "center">Secundária</th>';
    cSecundaria := cSecundaria||'</tr>';
      declare cursor sDados IS
                 SELECT  p2.Descricao As Secundaria
                   FROM DIN_Produto p, DIN_ProdutoEmbalagem pe, DIN_Produtoembalagemkit pek, DIN_EmbalagemKitInsumo eki, DIN_Produto p2
                  WHERE p.SeqProduto = pe.SeqProduto
                    AND pe.SeqEmbalagem = pek.SeqEmbalagem
                    AND pe.EmbalagemIndustriaPadrao = 'S'
                    AND pek.SeqEmbalagemKit = eki.SeqEmbalagemKit
                    AND p2.SeqProduto = eki.SeqProduto
                    AND eki.Tipo = 2
                    AND p.SeqProduto = TO_Char(nSeqProduto);
       BEGIN
              FOR s in sDados
              loop
                cSecundaria:= cSecundaria||'<tr>';
                cSecundaria:= cSecundaria||'<td>'||To_Char(s.Secundaria)||'</td>';
                cSecundaria:= cSecundaria||'<tr>';
              end loop;
       END;
       cSecundaria := cSecundaria||'</table>';
       
       
    cInfProd := '<table style="background-color: #fff; width: 50%; font-size:9px" align="left" cellspacing=0 border=0>';
    cInfProd := cInfProd||'<tr>';
    cInfProd := cInfProd||'<th class="destaque" style="font-size:12px;" colspan = 12>''</th>';
    cInfProd := cInfProd||'</tr>';
    cInfProd := cInfProd||'<tr>';
    cInfProd := cInfProd||'<th align = "center">EAN 14(GTIN)</th>';
    cInfProd := cInfProd||'<th align = "center">Quantidade Mínima</th>';
    cInfProd := cInfProd||'<th align = "center">Quantidade Máxima</th>';
    cInfProd := cInfProd||'</tr>';
    

      declare cursor pDados IS
                 Select Y.Gtin, y.Qtdminima, y.Qtdmaxima
                   From DIN_ProdutoEmbalagem Y 
                  Where Y.Unidade = 'CX'
                    And Y.SeqProduto = To_Char(nSeqProduto);
       BEGIN
              FOR p in pDados
              loop
                cInfProd:= cInfProd||'<tr>';
                cInfProd:= cInfProd||'<td>'||To_Char(p.Gtin)||'</td>';
                cInfProd:= cInfProd||'<td>'||To_Char(p.QtdMinima)||'</td>';
                cInfProd:= cInfProd||'<td>'||To_Char(p.QtdMaxima)||'</td>';
                cInfProd:= cInfProd||'<tr>';
              end loop;
       END;
       
       cInfProd:= cInfProd||'</table>';
                 cHTML := cHTML||'<tr>';
                 cHTML := cHTML||'<td colspan=4 align="center">'||cPrimaria||'</td>';
                 cHTML := cHTML||'<td align="center">'||cSecundaria||'</td>';
                 cHTML := cHTML||'<td align="center">'||cInfProd||'</td>';
                 cHTML := cHTML||'</tr>';
                 cHTML := cHTML||'</table><br/></br></br>';
                 
----------------------------------------------INCIO IMAGENS DOS PRODUTOS-------------------------------------------------------------      

      cHTML := cHTML||'</br><div class="img-responsive"; style="border:2px solid #0000; float:left;">          
                       <div class="destaque" style="text-align:center; margin-bottom: 0cm;"><b>Imagens das Embalagens</b></div>';
     
                     
      FOR i IN(          
                 SELECT aa.Conteudo
                   FROM dge_arquivoanexo@DtvAdm aa, DGE_ProdutoAnexo@DtvAdm pa
                  WHERE aa.CodLink = pa.SeqProdutoAnexo
                    AND aa.TabLink = 'DGE_PRODUTOANEXO'
                    AND pa.SeqProduto = To_Char(nSeqProduto)
                    AND pa.Codigo = 3
               ORDER BY aa.Descricao   
      )
      LOOP
      
        
         cHTML := cHTML || '<img align="middle" src="data:image/jpg;base64,' || DPKG_Library.DGEF_ImagemBase64(i.Conteudo) || '" class="img-responsive"; height="200" width="230";>';
         
      END LOOP;
      cHTML := cHTML||'</div>';
      
      

      
/*     cHTML := cHTML||'<div class="img-responsive"; style="border:2px solid black; float:left;">          
                       <p class="destaque" style="text-align:center;"><b>Imagens do Produto Embalado</b></p>';
     
                     
      FOR i IN(          
                 SELECT aa.Conteudo
                   FROM dge_arquivoanexo@DtvAdm aa, DGE_ProdutoAnexo@DtvAdm pa
                  WHERE aa.CodLink = pa.SeqProdutoAnexo
                    AND aa.TabLink = 'DGE_PRODUTOANEXO'
                    AND pa.SeqProduto = To_Char(nSeqProduto)
                    AND pa.Codigo = 2
               ORDER BY aa.Descricao   
      )
      LOOP
      
        
         cHTML := cHTML || '<img align="middle" src="data:image/jpg;base64,' || DPKG_Library.DGEF_ImagemBase64(i.Conteudo) || '" class="img-responsive"; " width="230";>';
         
      END LOOP;
      cHTML := cHTML||'</div>';*/
      
     
      
       
                    
                        
      cHTML := cHTML||'</div>';
      cHTML := cHTML||'</section>';
      cHTML := cHTML||'<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>';
      cHTML := cHTML||'</body>';
      cHTML := cHTML||'</html>';
----------------------------------------------FIM IMAGENS-------------------------------------------------------------      
      
      RETURN(cHTML);
      --RETURN(rHTML);
      
   Exception
    When Others Then
       Return (cHTML);
   
   END DINFR_FichaTecnicaProduto;
