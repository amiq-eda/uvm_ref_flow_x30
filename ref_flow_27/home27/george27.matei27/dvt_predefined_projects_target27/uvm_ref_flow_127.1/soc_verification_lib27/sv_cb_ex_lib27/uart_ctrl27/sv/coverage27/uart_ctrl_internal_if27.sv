/*-------------------------------------------------------------------------
File27 name   : uart_internal_if27.sv
Title27       : Interface27 File27
Project27     : UART27 Block Level27
Created27     :
Description27 : Interface27 for collecting27 white27 box27 coverage27
Notes27       :
----------------------------------------------------------------------
Copyright27 2007 (c) Cadence27 Design27 Systems27, Inc27. All Rights27 Reserved27.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if27(input clock27);
 
  int tx_fifo_ptr27 ;
  int rx_fifo_ptr27 ;

endinterface  
