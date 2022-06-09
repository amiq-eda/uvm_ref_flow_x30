/*-------------------------------------------------------------------------
File9 name   : uart_internal_if9.sv
Title9       : Interface9 File9
Project9     : UART9 Block Level9
Created9     :
Description9 : Interface9 for collecting9 white9 box9 coverage9
Notes9       :
----------------------------------------------------------------------
Copyright9 2007 (c) Cadence9 Design9 Systems9, Inc9. All Rights9 Reserved9.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if9(input clock9);
 
  int tx_fifo_ptr9 ;
  int rx_fifo_ptr9 ;

endinterface  
