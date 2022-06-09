/*-------------------------------------------------------------------------
File23 name   : uart_internal_if23.sv
Title23       : Interface23 File23
Project23     : UART23 Block Level23
Created23     :
Description23 : Interface23 for collecting23 white23 box23 coverage23
Notes23       :
----------------------------------------------------------------------
Copyright23 2007 (c) Cadence23 Design23 Systems23, Inc23. All Rights23 Reserved23.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if23(input clock23);
 
  int tx_fifo_ptr23 ;
  int rx_fifo_ptr23 ;

endinterface  
