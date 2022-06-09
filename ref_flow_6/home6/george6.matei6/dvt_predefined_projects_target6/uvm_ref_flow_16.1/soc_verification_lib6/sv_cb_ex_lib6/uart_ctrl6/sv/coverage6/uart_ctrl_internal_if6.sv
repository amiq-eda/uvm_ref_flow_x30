/*-------------------------------------------------------------------------
File6 name   : uart_internal_if6.sv
Title6       : Interface6 File6
Project6     : UART6 Block Level6
Created6     :
Description6 : Interface6 for collecting6 white6 box6 coverage6
Notes6       :
----------------------------------------------------------------------
Copyright6 2007 (c) Cadence6 Design6 Systems6, Inc6. All Rights6 Reserved6.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if6(input clock6);
 
  int tx_fifo_ptr6 ;
  int rx_fifo_ptr6 ;

endinterface  
