dcv_pedidoinfadicional

dcv_pedidoitem

select * from din_pedido x where  x.seqpedido = 892264  

select * from din_pedidoitem x where  x.seqpedido = 892264  

select * from din_carga x where  x.dtaembarque = '14-dec-2022'  

select e.tablinksai from din_estoque e group by e.tablinksai

select * from din_estoque e
where 1=1
and e.tablinksai = 'DIN_PEDIDOITEM'
and e.seqpedido = 642
and e
where

and e.seqestoqueorigem is not null

e.seqpedido = 892264 and 

-------------------------------------------------------------------
select 
      p.seqpedido,
      
      p.nroplanta,
      p.nronotafiscal,
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
      e.horasai
      
from 
      din_pedido p, 
      din_pessoa ps,
      ge_empresa em, 
      din_carga c,   
      din_pedidoitem  pi, 
      din_estoque e 
where 1=1
      --and p.dtapedido = trunc(sysdate)
      and e.seqproduto = pi.seqproduto      
      and e.datasai = p.dtaembarque 
      and p.seqpedido = 642
      and c.tiponota = 'S'
      and c.nroplanta = p.nroplanta
      and c.dtaembarque = p.dtaembarque
      and c.nrocarga = p.nrocarga
      and pi.seqpedido = p.seqpedido
      and ps.seqpessoa = p.seqpessoa 
      and em.nroempresa = p.nroplanta;
      
      

/*select * from din_pedido x where  x.seqpedido = 892264  
select * from din_carga x where  x.dtaembarque = '14-dec-2022'  
select * from din_estoque e where */
/*
dcv_pedidoinfadicional

dcv_pedidoitem*/

------------------------------------------------------------------------

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
-----------------------------------------------------------------------------
Select * From dge_ocorrencia where codlink = '892691'
select * From din_estoque where status = 1 and seqproduto = 6040