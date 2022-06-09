/*-------------------------------------------------------------------------
File2 name   : uart_internal_if2.sv
Title2       : Interface2 File2
Project2     : UART2 Block Level2
Created2     :
Description2 : Interface2 for collecting2 white2 box2 coverage2
Notes2       :
----------------------------------------------------------------------
Copyright2 2007 (c) Cadence2 Design2 Systems2, Inc2. All Rights2 Reserved2.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if2(input clock2);
 
  int tx_fifo_ptr2 ;
  int rx_fifo_ptr2 ;

endinterface  
