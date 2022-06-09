/*-------------------------------------------------------------------------
File4 name   : uart_internal_if4.sv
Title4       : Interface4 File4
Project4     : UART4 Block Level4
Created4     :
Description4 : Interface4 for collecting4 white4 box4 coverage4
Notes4       :
----------------------------------------------------------------------
Copyright4 2007 (c) Cadence4 Design4 Systems4, Inc4. All Rights4 Reserved4.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if4(input clock4);
 
  int tx_fifo_ptr4 ;
  int rx_fifo_ptr4 ;

endinterface  
