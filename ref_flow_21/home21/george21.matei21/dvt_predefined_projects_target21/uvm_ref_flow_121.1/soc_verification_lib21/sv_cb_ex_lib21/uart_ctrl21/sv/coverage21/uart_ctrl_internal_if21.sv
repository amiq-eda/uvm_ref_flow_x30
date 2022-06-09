/*-------------------------------------------------------------------------
File21 name   : uart_internal_if21.sv
Title21       : Interface21 File21
Project21     : UART21 Block Level21
Created21     :
Description21 : Interface21 for collecting21 white21 box21 coverage21
Notes21       :
----------------------------------------------------------------------
Copyright21 2007 (c) Cadence21 Design21 Systems21, Inc21. All Rights21 Reserved21.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if21(input clock21);
 
  int tx_fifo_ptr21 ;
  int rx_fifo_ptr21 ;

endinterface  
