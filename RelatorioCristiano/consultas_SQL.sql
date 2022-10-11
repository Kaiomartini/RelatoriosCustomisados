SELECT * FROM DGE_PRODUTOANEXO WHERE SEQPRODUTO = 2040 
-- select empresa 
SELECT E.RAZAOSOCIAL,
E.FANTASIA,
E.CNPJENTIDADE,
E.TELEVENDASDDD as DDD,
E.TELEVENDASNRO as telefone,
e.endereco as rua,
e.endereconro as numero,
e.cep,
e.cidade,
e.inscrestadual as ie
 FROM GE_EMPRESA E  where e.nroempresa = 1 
-- SELECT FINHA TECNICA 
SELECT
        lpad(pe.gtin,14,0) as gtin,
        pp.coddipoa,
        pp.prazovalidade||' '||DECODE(pp.Tipovalidade, 1,'Dias', 2,'Meses')as validade,                                               
        DECODE(p.conservacao, 1,'Congelado', 2,'Resfriado', 3,'Ambiente')As Conservacao,
        p.TempMinima||' '||'°C' As TempMinima,
        p.TempMaxima||' '||'°C' As TempMaxima,
        DECODE(pe.UNIDADE, 'CX', 'CAIXA', '') As Unidade,
        pe.PesoMedio, 
        (select E.codservico from DGE_EMPRESACOMPL E WHERE E.NROEMPRESA = 1) AS SIF 
     FROM 
        DGE_PRODUTO P,
        Dge_Produtoplanta  pp,
        DGE_PRODUTOEMBALAGEM Pe   
     WHERE 
        P.SEQPRODUTO = Pe.Seqproduto 
        AND  P.SEQPRODUTO = PP.Seqproduto 
        AND PE.EMBALAGEMINDUSTRIAPADRAO = 'S'                        
        AND P.SEQPRODUTO = 1002

--- select descrição descricao 
SELECT 
                      PD.SEQDESCRICAO,
                      I.DESCRICAO, 
                      PD.TIPODESCRICAO,
                      DP.DESCRICAO 
                      FROM                       
                      DGE_PRODUTODESCRICAO PD,
                      DGE_IDIOMA I,
                      DGE_DESCRICAOPRODUTO DP
                      WHERE 
                      PD.SEQIDIOMA = I.SEQIDIOMA
                      AND DP.SEQDESCRICAO = PD.SEQDESCRICAO
                      AND PD.SEQPRODUTO = 1002
                      AND PD.TIPODESCRICAO = 4;








  cHTML CLob := Null;
  vEmpresa ge_empresa.nroempresa%TYPE;
  sRazaoSocial GE_Empresa.RazaoSocial%Type;
  vLogo BLOB := NULL; 
-- Variaveis cidade inicio
  
  vRazaosocial GE_Empresa.RAZAOSOCIAL%Type := null;
  vNomeFantasia GE_Empresa.FANTASIA%Type := null;
  vCNPJ GE_Empresa.CNPJENTIDADE%Type := null; 
  vDDD GE_Empresa.TELEVENDASDDD%Type := null;
  vTelefone GE_Empresa.TELEVENDASNRO%Type := null; 
  vLogradouro GE_Empresa.endereco%Type := null; 
  vNumero GE_Empresa.endereconro%Type := null; 
  vCep GE_Empresa.cep%Type := null; 
  vCidade GE_Empresa.cidade%Type := null; 
  vIE GE_Empresa.inscrestadual%Type := null;

       ,
-- Variaveis cidade fim
  
  BEGIN
      SELECT 
      E.RAZAOSOCIAL,
      E.FANTASIA,
      E.CNPJENTIDADE,
      E.TELEVENDASDDD ,
      E.TELEVENDASNRO ,
      e.endereco ,
      e.endereconro,
      e.cep,
      e.cidade,
      e.inscrestadual as ie
      into( 
        vRazaosocial,  
        vNomeFantasia,    
        vCNPJ,         
        vDDD,
        vTelefone,      
        vLogradouro,
        vNumero ,        
        vCep, 
        vCidade,
        vIE  
         )



         <div class="col-6 quebra">
                <div class="row">
                    <div class="col fs-3 ">titulo do formulario </div>
                </div>
                <div class="row">
                      
                    <p class="fs-5 fw-bold">'||vNomeFantasia||'</p>    
                    <p class="fs-6">'||vCNPJ||'</p>         
                    <p class="fs-6">'||vDDD||'</p>
                    <p class="fs-6">'||vTelefone ||'</p>    
                    <p class="fs-6">'||vLogradouro||'</p>
                    <p class="fs-6">'||vNumero ||'</p>       
                    <p class="fs-6">'||vCep||'</p>
                    <p class="fs-6">'||vCidade||'</p>
                    <p class="fs-6">'||vIE||'</p>
                    
                </div>
            </div>
