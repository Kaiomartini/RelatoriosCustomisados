-- #############################################  folha de ponto ##############################

Function DGEF_FolhadePontoCss Return CLob is 


      cHTML CLob := Null;

    Begin
      cHTML := cHTML||'
      html {
    font-size: 11px;
}
.logo {
    width: 100%;
    height: 70px;
}
.icon-logo{
 width: auto;
 height: 15px;
}
@media print {
    .caixa {
        page-break-inside: avoid;
    }

    .naoquebra {
        page-break-inside: avoid;
    }

    .A4 {
        page-break-before: always;
        margin: 0px;
    }
    
}
@page {
    margin: 3mm ;
}
.A4 {
    /*box-shadow: 0 .5mm 2mm rgba(0, 0, 0);*/
    margin: 3mm auto;
    width: 297mm;
    padding: 0mm 0mm;
    background-color: #fff;

}
#cabecalho {
    /*box-shadow: 0 .5mm 2mm rgba(0, 0, 0);*/
    margin: 3mm auto;
    width: 297mm;
    padding: 0mm 0mm;
   
}

.pquebra {
    overflow-wrap: break-word;
    word-wrap: break-word;
    word-break: break-word;
}
.distaca {
    background-color: #f2f2f2;
    

}
.foto {
    margin: 5px auto 5px auto;
    max-height: 300px;
    min-height: 200px;
    width: auto;
    height: auto;

}
.caixa {border: 2px solid #ddd;}
.caixat {
    border: 1px solid #9b9999;
    margin-bottom: 20px;
    box-shadow: -5px 5px 0px #666;
    background-color: #ddd;
}
.caixa-etiqueta { height: 250px;}
p {
    margin: 0px;
    padding: 0px 5px 0px 5px;
}
.border {
    border-color: rgb(19, 19, 19);
    border: 2px solid #000;
}
.table>:not(caption)>*>* {padding: .0 0.5rem;}
.table {  margin: 0px;}
.text-alert{color:#ff2c2c}

/*.zebra>div:nth-child(even) {
background: rgba(0, 0, 0, 0.05);;
      }*/
      ';

    Return(cHTML);

   End DGEF_FolhadePontoCss;
       
Function DGEF_ErroFolhadePontoHTML(nErro string,
                                   nEmpresa ge_empresa.nroempresa%Type,
                                   nSeqProduto in DGE_PRODUTO.SeqProduto%Type
                                   ) Return CLob is
                                      

    cHTML               CLob := Null;
    
Begin    

  
cHTML := cHTML ||'
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Erro FichaTecnica</title>
    
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
        <!--<link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" /> -->
        <style>'||DGEF_FichaTecnicaCss()||'</style>  
</head>

<body class="text-uppercase">

    <div id="Page1" class="A4">
       '||DGEF_CabecalhoFichaTecnica('',2,nSeqProduto,nEmpresa)||'
       
      <div class="alert alert-warning d-flex align-items-center" role="alert">
         <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2" viewBox="0 0 16 16" role="img" aria-label="Warning:">
            <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"></path>
         </svg>
         <div>
             <p class="fw-bold">'||nErro||'</P>                                   
         </div>
      </div>
    </div><!--fim A4 Page1-->
    
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
</body>

</html>';


  return (cHTML);
end DGEF_ErroFolhadePontoHTML; 
                                     
Function DGEF_CabecalhoFolhadePonto(nNomeRelatorio string,                                     
                                    nEmpresa ge_empresa.nroempresa%Type,
                                    nDataInicio date,
                                    nDataFim date                               
                                     ) Return CLob Is
    
    
    cCabesalho          CLob := Null;
    bLogo               BLob := Null;
    sRazaoSocial        GE_Empresa.RazaoSocial%Type;
    vErro               varchar2(200);
    vSif                varchar2(10);
    cHTML               CLob := Null;
    vEmpresa            ge_empresa.nroempresa%TYPE := nEmpresa;
    sRazaoSocial        GE_Empresa.RazaoSocial%Type;
    vLogo               BLOB := NULL;
    vDataAtual          varchar2(10) := TO_CHAR(SYSDATE, 'DD/MM/YYYY'); 
    vRelatorio          varchar2(200);
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

 -- VERSAO DO RELATORIO 
   vCodVersao               varchar(6);
   vDataVersao              varchar(10);
    
-- VARIAVEL DE DETALHES DA VERSAO DA TABELA VERSAO  
   vDetalhes                varchar2(5000);
   vIdfichatecnica          varchar(50);
   
Begin    
   --SELECT EMPRESA
               
   SELECT 
      E.RAZAOSOCIAL,
      E.FANTASIA,
      regexp_replace(LPAD(To_char(e.nrocgc), 14),'([0-9]{2})([0-9]{3})([0-9]{3})([0-9]{4})','\1.\2.\3/\4-') as CNPJ,
      E.ddd ,
      E.FONENRO ,
      e.endereco ,
      e.endereconro,
      Replace(Trim(To_char(e.CEP/1000,'00000.000')), '.', '-')as cep,
      e.cidade,
      e.inscrestadual as ie,
      e.logo,
      (select E.codservico from DGE_EMPRESACOMPL E WHERE E.NROEMPRESA = 1) AS SIF 
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
      vLogo,
      vSIF            
  FROM 
      GE_EMPRESA E  
  where 
      e.nroempresa = nEmpresa;
      
      cCabesalho := '
              <section id="cabecalho" class="mb-0 mx-0">
                   <div class="row "><!-- Row  cabesalho-->
                      <div class="col-3 " style=" padding-left: 117px;"> 
                          <img class="logo img-fluid"
                              src="data:image/png;base64,'|| DPKG_Library.DGEF_ImagemBase64(vLogo)||'" style="max-width: 105px;" />
                      </div>
                      <div class="col-6 quebra">
                          <div class="row text-center ">
                              <p class="fs-5 fw-bold">'||TO_CHAR(vNomeFantasia)||'</p>
                              <p class="fs-6">'||'Local: '||TO_CHAR(vCidade)||' - '||TO_CHAR(vLogradouro)||' - '||TO_CHAR(vNumero)||'</p>
                              <p class="fs-6">'||'CNPJ: '||TO_CHAR(vCNPJ)||'IE:'||TO_CHAR(vIE)||'</p>
                              <p class="fs-6 d-inline"> Telefone:('||TO_CHAR(vDDD)||')'||TO_CHAR(vTelefone)||'</p>
                              <p class="fs-6 d-inline">'||'CEP: '||TO_CHAR(vCep)||'</p>
                          </div>
                      </div>
                      <div class="col-3 text-center">
                          <div class="row mb-1 ">
                              
                              <div class="col-5 text-start fw-boud">
                                  <div class="fw-bold">Data Emissão:</div>                                  
                              </div>
                              <div class="col text-start">
                                  <div>'||vDataAtual||'</div>                                  
                              </div>
                          </div>
                          <div class="row  text-start mt-5 pt-4">
                            <div class="col">
                               <p class="px-0"><b>Período: </b> '||TO_CHAR(nDataInicio,'DD/MM/YYYY')||' á '||TO_CHAR(nDataFim,'DD/MM/YYYY')||'</p>
                            </div>
                          </div>
                          
                     </div>

                      <div class="row mx-0 px-0"> <!-- TITULO FORMULARIO -->
                          <div class="col fs-5 text-center border-top fw-bold">
                              <p>'||nNomeRelatorio||'</p>
                          </div>
                      </div><!-- fim row-->

                 </div><!-- fim cabesalho-->
           </section>';            
   
      
     
      Return(cCabesalho);
Exception
When Others Then 
  vErro := vErro || sqlerrm;
  cHTML := 'vErro'; 
  Return (cHTML);
        
End DGEF_CabecalhoFolhadePonto;

Function DGEFR_FolhadePonto(nInicioPeriodo string,
                            nFimPeriodo  string,
                            nEmpresa string,
                            nSeqFuncionario string
                            ) Return CLob is
                                      

    cHTML               CLob := Null;
    nErro               CLob := Null;
    vLogo               CLob := Null;
    vRow                numeric := 0;
    vTotalHrMes         varchar2(30):= null;
    --cHTML               CLob := Null;
    
Begin  
   declare cursor cDados is  
      Select 
             E.RazaoSocial, E.Cidade as CidadeEmpresa, E.Estado as UFEmpresa, E.Endereco as EnderecoEmpresa, E.EnderecoNro as EnderecoNro, E.Bairro as BairroEmpresa,
             SubStr(Trim(To_Char(E.CEP, '00000000')), 1, 5) || '-' || SubStr(Trim(To_Char(E.CEP, '00000000')), 6, 3) as CEPEmpresa,
             DPKG_Pessoa.DGEF_CNPJCPFFormatado(E.NroCGC, E.DigCGC, 'J') as CNPJEmpresa,
             DPKG_Library.DTVF_RowToCol('Select xC.NroCartao From DFP_CartaoFuncionario xC Where xC.NroEmpresa = ' || F.NroEmpresa ||
                                        ' and xC.CodFuncionario = ' ||  F.CodFuncionario || ' and xC.Status = 1', ', ') as Cartoes,

             Trim(To_Char(Vd.CodDepartamento, '000')) || ' - ' || Vd.DescrDepartamento || ' / ' || Trim(To_Char(Vd.CodSetor, '000')) ||
             ' - ' || Vd.DescrSetor || ' / ' || Trim(To_Char(Vd.CodSecao, '000')) || ' - ' || Vd.DescrSecao as Ambiente,
             F.CodFuncionario, F.Nome as NomeFuncionario, Fu.DescrReduzida as DescrFuncao, F.NroCTPS, F.SerieCTPS, F.UFCTPS, F.Matricula,
             Substr(Trim(To_Char(F.NroPis, '00000000000')), 1, 3) || '.' || Substr(Trim(To_Char(F.NroPis, '00000000000')), 4, 5) || '.' ||
             Substr(Trim(To_Char(F.NroPis, '00000000000')), 9, 2) || '-' || Substr(Trim(To_Char(F.NroPis, '00000000000')), 11, 1) AS NroPis

             /*'10/10/2022' as Dia,
             'Segunda-Feira' as DiaSemana,
             'Seg' as DiaSemanaRed,
             '01:05:30' as HoraIndenizada,
             'texto texto' as Obiservacao*/

      From   GE_Empresa           E,
             DFPV_DeptoSetorSecao Vd,
             DFP_Funcao           Fu,
             DFP_Funcionario      F
      Where  E.NroEmpresa = F.NroEmpresa
             And Vd.NroPlantaDepto = F.NroPlantaDepto
             And Vd.CodDepartamento = F.CodDepartamento
             And Vd.CodSetor = F.CodSetor
             And Vd.CodSecao = F.CodSecao
             And Fu.NroPlanta(+) = F.NroPlanta
             And Fu.CodFuncao(+) = F.CodFuncao
             And F.CodCadastro in (5, 1, 4)
             And DPKG_FolhaPagto.DFPF_FuncStatus(F.NroEmpresa, '01-NOV-2022', '30-NOV-2022', F.CodFuncionario) in ('P', 'A', 'D', 'T', 'F', 'L')
             And Exists (Select xC.SeqCartaoFuncionario From DFP_CartaoFuncionario xC Where xC.CodFuncionario = F.CodFuncionario and xC.NroEmpresa = F.NroEmpresa and (xC.TipoTerminal = 2 or xC.TipoTerminal is Null))
             And F.CodFuncionario = 14;
 
  begin
      cHTML := cHTML ||'
      <!doctype html>
      <html lang="pt-BR">

      <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>Erro FichaTecnica</title>
          
              <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
              <!--<link rel="stylesheet" type="text/css" href="../../../../../../bootstrap-5.2.2-dist/css/Style.css" /> -->
              <style>'||DGEF_FolhadePontoCss()||'</style>  
      </head>

      <body class="text-uppercase">';

        for i in cDados
        loop
          cHTML := cHTML ||'                                                
          <div id="Page1" class="A4">
           '||DGEF_CabecalhoFolhadePonto( 'Relatório do Cartão de Ponto',1,'01-NOV-2022','30-NOV-2022') ||'<!-- ###############  INICIO CABECALHO ############### -->           
                          
            <div class="row mx-0 mb-1 ">
            
                <div class="col-1 mb-1 border distaca text-center">Enpregado:</div>
                <div class="col-4 mb-1 border "> '||To_char(i.CodFuncionario)||' - '||To_char(i.NomeFuncionario)||'</div>
                
                <div class="col-1 mb-1 border distaca text-center">Ambiente: </div>
                <div class="col-6 mb-1 border ">'||To_char(i.Ambiente)||'</div>
                
                <div class="col-1 mb-1 border distaca text-center">CTPS: </div>
                <div class="col-2 mb-1 border ">N°: '||To_char(i.NroCTPS)||' Série: '||To_char(i.SerieCTPS)||' UF: '||To_char(i.UFCTPS)||'</div>
                
                <div class="col-1 mb-1 border distaca text-center">Matricula:</div>
                <div class="col-1 mb-1 border "> '||To_char(i.Matricula)||' </div>
                
                <div class="col-1 mb-1 border distaca text-center">Nro PIS: </div>
                <div class="col-1 mb-1 border "> '||To_char(i.NroPis)||' </div>
                
                <div class="col-1 mb-1 border distaca text-center">Função:</div>
                <div class="col-2 mb-1 border ">'||To_char(i.DescrFuncao)||'</div>
                
                <div class="col-1 mb-1 border distaca text-center">Cartões: </div>
                <div class="col-1 mb-1 border ">'||To_char(i.Cartoes)||'</div>
            
            </div>
             
            <div id="rowTabelaVenda" class="row"> <!-- #################### --- inicio tabela 1 -- ################################  -->
                    <div class="col-12">
                        <div  class="caixa border-0">
                            <div class="distaca fs-4 fw-bold text-center">                          
                            </div>
                            <div class="row">
                                <div id="divVendaProdutoCliente" class="mx-auto col-12">

                                    <table id="TabelaVendaProdutoCliente" class="table align-middle table-bordered border table-striped sortable">
                                        <thead>
                                           <tr class="text-center">
                                           
                                                <th width="col">cod Funcionario</th>  
                                                <th width="col">Data</th>                                        
                                                <th width="col">Total dia</th>               
                                                <th width="col">Total Mes</th>
                                           
                                           
                                                <!--<th width="50">Dia</th>  
                                                <th width="50">Dia Semana</th>                                        
                                                <th width="50">Dia Semana Red.</th>               
                                                <th width="50">Hora Indenizada</th>                                        
                                                <th width="300px">Observação</th>--> 
                                                                                                                                                                   
                                            </tr>
                                        </thead>
                                        <tbody id="tabela-dados" class="text-break">
                                             ';
                                              for x in (
                                                     Select X.CodFuncionario,
                                                     X.Data,
                                                     TO_CHAR(TRUNC(X.SegundosDia / 3600), 'FM9900') || ':' || TO_CHAR(TRUNC((X.SegundosDia / 60)- Trunc(Trunc(X.SegundosDia / 3600) * 60)), 'FM9900') || ':' || TO_CHAR(TRUNC(MOD((X.SegundosDia * 60), 3600) / 60), 'FM00') as TempoD,
                                                     TO_CHAR(TRUNC(X.SegundosMes / 3600), 'FM9900') || ':' || TO_CHAR(TRUNC((X.SegundosMes / 60)- Trunc(Trunc(X.SegundosMes / 3600) * 60)), 'FM9900') || ':' || TO_CHAR(TRUNC(MOD((X.SegundosMes * 60), 3600) / 60), 'FM00') as TempoMes
                                                    
                                              From   (
                                              Select Distinct L.CodFuncionario, Trunc(L.DtaHora) as Data, 
                                                     Nvl(Sum((Substr(I.NValor, 1, 1) * 60) + Nvl(Substr(I.NValor, 2, 2), 0)) Over (Partition By L.CodFuncionario, Trunc(L.DtaHora)), 0) AS SegundosDia,
                                                     Nvl(Sum((Substr(I.NValor, 1, 1) * 60) + Nvl(Substr(I.NValor, 2, 2), 0)) Over (Partition By L.CodFuncionario), 0) as SegundosMes

                                              From   GE_Empresa           E,
                                                     DFP_Funcionario      F,
                                                     DPA_Leitura          L,
                                                     DGEVG_Terminal       I,
                                                     DPA_Terminal         T
                                              Where  E.NroEmpresa = F.NroEmpresa
                                                     And F.NroEmpresa = L.NroEmpresa
                                                     And F.NroPis = L.NroPis
                                                     And I.CodLink = L.SeqTerminal
                                                     And T.SeqTerminal = L.SeqTerminal
                                                     And F.CodCadastro in (5, 1, 4)
                                                     And Exists (Select xC.SeqCartaoFuncionario From DFP_CartaoFuncionario xC Where xC.CodFuncionario = F.CodFuncionario and xC.NroEmpresa = F.NroEmpresa and (xC.TipoTerminal = 2 or xC.TipoTerminal is Null))
                                                     And F.NroEmpresa = 1
                                                     And L.DtaHora Between '21-Oct-2022' and '20-Nov-2022'
                                                     And F.CodFuncionario in (14)
                                              Order By L.CodFuncionario, Trunc(L.DtaHora)) X)
                                              loop
                                                cHTML := cHTML ||' 
                                                  <tr>
                                                      <td class="text-center">'||To_char(x.codfuncionario)||'</td>
                                                      <td class="text-center">'||To_char(x.data,'DD/MM/YYYY')||'</td>
                                                      <td class="text-center">'||To_char(x.tempod)||'</td>
                                                      <td class="text-center">'||To_char(x.tempomes)||'</td>
                                                  </tr>    
                                                ';
                                                vRow := vRow + 1;
                                                vTotalHrMes := x.tempomes;
                                              end loop;

                                               
                                         cHTML := cHTML ||'        
                                        </tbody>
                                        <tfoot><!-- footer da tabela  -->
                                            <tr>
                                                <th colspan="7" class="text-center"> linhas: '||To_char(vRow)||' - 
                                                <img class="icon-logo" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACMUlEQVQ4jaWST0iTcRjHv8/vffdu5bZqhcRq2nLYTFsjSSJIPKwuhSRhlnSKiEG3MJCO3eoQdekQnqOjhRSJ/UFcDSEDg5wr5+twM0zX9i42eN1+Twc3McIO63t44AfP58fzfJ8vMTPhP6TWCl7u6+1yOBwlUQt80OM+tsPpHGtobHxa0wRSyvpXL18IVVHHVQCYbfG6qVw+A4IPDA2EAoAkiKblLte0/8MnEwBuDdw8l8lkgge83scLuh7QrFpMjTd7wsT8ACBtw01eLywhxerKcKzNd//uXs+VU7194XyxiFRywT6/uDQIrJs4QETa5hErfByK2t8c06eaGvb7yIhfb3/0ED/tTuhL379UewWAETD/uSRzmhVLV3NMn6quvVYqyblsDv3LaTxTZefM0SYVAARr2iATnjMzAIapqIgeP5kYOtvz5OKFnslgW0t4LrmYUITi77YooyCAGFeVonkPAIiZabb9iKB8Nrxs0e687Qy5DodCsNfVIRKJYPzNa5lKpX0jGlzEcoIINoDAQHbNvW+PCgCHPn6WAb9/iBjXOkzTtTOdhlWzwsjlUCgWxQ2Vu4lxGwQbmNZdIhpufReVGznI/8qdZ+Zg9H0E84k5KIqCleUfMDKrydPbLScAngTIZEE6g0bLu+vHqleoKgAAecNA3jAqXnJBCHGpNZ6MbhWqzVEeY+ZSBQSAmBAiNL+4tCW8YWL14fW4AyxlhyDxzbrNNjHzNVH6F/zXB7XoN0ir7I+9fhwlAAAAAElFTkSuQmCC"/>
                                                 Datavale - Tecnologia & Sistemas | http://.datavale.com.br/</th>
                                                
                                            </tr>
                                        </tfoot>
                                    </table>

                                </div>
                            </div>
                        </div>
                    </div>
                </div><!-- #################### --- FIM tabela  1 -- ################################  -->
                
                <div class="row justify-content-md-center mt-5"> <!--  # inicio compos de assinatura #  -->  
                    <div class="col-3 assinatura-1 border-top">
                        <p class="text-center">'||To_char(i.NomeFuncionario)||'</p> 
                    </div>
                    <div class="col-3 assinatura-2">
                        <p class=" text-center">Total de Horas á receber: <spam class="fw-bold">'||To_char(vTotalHrMes)||'<spam></p> 
                    </div>
                </div> <!--  # fim compos de assinatura #  --> 
                     
          </div><!--fim A4 Page1-->';
         end loop;
        cHTML := cHTML ||'  
          <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
      </body>

      </html>';
  end;-- fim begin cDados
  return (cHTML);
end DGEFR_FolhadePonto; 
  
