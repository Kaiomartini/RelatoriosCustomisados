-- consulta de folhade de ponto pricipal

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
       Substr(Trim(To_Char(F.NroPis, '00000000000')), 9, 2) || '-' || Substr(Trim(To_Char(F.NroPis, '00000000000')), 11, 1) AS NroPis,

       '10/10/2022' as Dia,
       'Segunda-Feira' as DiaSemana,
       'Seg' as DiaSemanaRed,
       '01:05:30' as HoraIndenizada,
       'texto texto' as Obiservacao

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
       And F.CodFuncionario = 14



        E.RazaoSocial,
        CidadeEmpresa,
        UFEmpresa,
        E.Endereco as EnderecoEmpresa,
        E.EnderecoNro as EnderecoNro, 
        E.Bairro as BairroEmpresa,
        CEPEmpresa,
        CNPJEmpresa,

       Cartoes,      
       Ambiente,
       F.CodFuncionario,
       NomeFuncionario,
       DescrFuncao,
       F.NroCTPS,
       F.SerieCTPS, 
       F.UFCTPS, 
       F.Matricula,
       NroPis,