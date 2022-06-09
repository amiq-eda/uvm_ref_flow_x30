/*-------------------------------------------------------------------------
File16 name   : uart_internal_if16.sv
Title16       : Interface16 File16
Project16     : UART16 Block Level16
Created16     :
Description16 : Interface16 for collecting16 white16 box16 coverage16
Notes16       :
----------------------------------------------------------------------
Copyright16 2007 (c) Cadence16 Design16 Systems16, Inc16. All Rights16 Reserved16.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if16(input clock16);
 
  int tx_fifo_ptr16 ;
  int rx_fifo_ptr16 ;

endinterface  
