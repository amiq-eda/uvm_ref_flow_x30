/*-------------------------------------------------------------------------
File15 name   : uart_internal_if15.sv
Title15       : Interface15 File15
Project15     : UART15 Block Level15
Created15     :
Description15 : Interface15 for collecting15 white15 box15 coverage15
Notes15       :
----------------------------------------------------------------------
Copyright15 2007 (c) Cadence15 Design15 Systems15, Inc15. All Rights15 Reserved15.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if15(input clock15);
 
  int tx_fifo_ptr15 ;
  int rx_fifo_ptr15 ;

endinterface  
