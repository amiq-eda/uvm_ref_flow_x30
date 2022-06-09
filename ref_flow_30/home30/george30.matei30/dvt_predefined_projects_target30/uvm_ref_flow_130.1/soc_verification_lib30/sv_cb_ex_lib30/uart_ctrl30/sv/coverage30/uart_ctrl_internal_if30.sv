/*-------------------------------------------------------------------------
File30 name   : uart_internal_if30.sv
Title30       : Interface30 File30
Project30     : UART30 Block Level30
Created30     :
Description30 : Interface30 for collecting30 white30 box30 coverage30
Notes30       :
----------------------------------------------------------------------
Copyright30 2007 (c) Cadence30 Design30 Systems30, Inc30. All Rights30 Reserved30.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if30(input clock30);
 
  int tx_fifo_ptr30 ;
  int rx_fifo_ptr30 ;

endinterface  
