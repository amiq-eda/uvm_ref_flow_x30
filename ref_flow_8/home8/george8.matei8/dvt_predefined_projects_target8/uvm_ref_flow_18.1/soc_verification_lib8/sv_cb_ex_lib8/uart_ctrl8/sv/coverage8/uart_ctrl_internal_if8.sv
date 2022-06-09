/*-------------------------------------------------------------------------
File8 name   : uart_internal_if8.sv
Title8       : Interface8 File8
Project8     : UART8 Block Level8
Created8     :
Description8 : Interface8 for collecting8 white8 box8 coverage8
Notes8       :
----------------------------------------------------------------------
Copyright8 2007 (c) Cadence8 Design8 Systems8, Inc8. All Rights8 Reserved8.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if8(input clock8);
 
  int tx_fifo_ptr8 ;
  int rx_fifo_ptr8 ;

endinterface  
