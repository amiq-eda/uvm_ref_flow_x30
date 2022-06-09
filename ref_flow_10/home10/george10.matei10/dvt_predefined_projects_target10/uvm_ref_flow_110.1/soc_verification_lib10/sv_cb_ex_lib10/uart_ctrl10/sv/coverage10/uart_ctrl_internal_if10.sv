/*-------------------------------------------------------------------------
File10 name   : uart_internal_if10.sv
Title10       : Interface10 File10
Project10     : UART10 Block Level10
Created10     :
Description10 : Interface10 for collecting10 white10 box10 coverage10
Notes10       :
----------------------------------------------------------------------
Copyright10 2007 (c) Cadence10 Design10 Systems10, Inc10. All Rights10 Reserved10.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if10(input clock10);
 
  int tx_fifo_ptr10 ;
  int rx_fifo_ptr10 ;

endinterface  
