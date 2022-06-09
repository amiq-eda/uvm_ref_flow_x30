/*-------------------------------------------------------------------------
File22 name   : uart_internal_if22.sv
Title22       : Interface22 File22
Project22     : UART22 Block Level22
Created22     :
Description22 : Interface22 for collecting22 white22 box22 coverage22
Notes22       :
----------------------------------------------------------------------
Copyright22 2007 (c) Cadence22 Design22 Systems22, Inc22. All Rights22 Reserved22.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if22(input clock22);
 
  int tx_fifo_ptr22 ;
  int rx_fifo_ptr22 ;

endinterface  
