/*-------------------------------------------------------------------------
File11 name   : uart_internal_if11.sv
Title11       : Interface11 File11
Project11     : UART11 Block Level11
Created11     :
Description11 : Interface11 for collecting11 white11 box11 coverage11
Notes11       :
----------------------------------------------------------------------
Copyright11 2007 (c) Cadence11 Design11 Systems11, Inc11. All Rights11 Reserved11.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if11(input clock11);
 
  int tx_fifo_ptr11 ;
  int rx_fifo_ptr11 ;

endinterface  
