-- preimeriro select pessoa 1
Select  p.seqpedido,
      
      p.nroplanta,
     -- p.nronotafiscal,
      --------
      ps.nomerazao as nomeCliente,
      ps.uf as ufcliente,
      ps.cidade as cidadecliente,
      ps.bairro as bairroCliente,
      ps.logradouro as ruaCliente,
      ps.nrologradouro as nroCasaCliente,      
      ps.nrocnpjcpf as cnpjCliente,
      (select E.codservico from DGE_EMPRESACOMPL E WHERE E.NROEMPRESA = 1),
      -------
      c.dtaembarque,
      c.placaveiculo,
      e.horasai ,
      Min(Horasai),
      Max(Horasai) 
      
From Din_pedido p , 
Din_PedidoItem pi, Din_Carga c , Din_Estoque e, Din_Pessoa ps
where p.SeqPedido = pi.SeqPedido 
And p.Nrocarga = c.NroCarga
And p.DtaEmbarque = c.DtaEmbarque
And pi.SeqPEdidoItem = e.CodlinkSai 
And e.Tablinksai = 'DIN_PEDIDOITEM'
And p.SeqPessoa = ps.SeqPEssoa
And c.Tiponota = 'S'
And  p.seqpedido = 892691-- 642 
And p.tiponota = 'S'


--- segudo select balasao 



-- terceiro select din_ estoque dim pediso item 


--- 4
Select * From dge_ocorrencia where codlink = '892691'