/*-------------------------------------------------------------------------
File24 name   : uart_internal_if24.sv
Title24       : Interface24 File24
Project24     : UART24 Block Level24
Created24     :
Description24 : Interface24 for collecting24 white24 box24 coverage24
Notes24       :
----------------------------------------------------------------------
Copyright24 2007 (c) Cadence24 Design24 Systems24, Inc24. All Rights24 Reserved24.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if24(input clock24);
 
  int tx_fifo_ptr24 ;
  int rx_fifo_ptr24 ;

endinterface  
