/*-------------------------------------------------------------------------
File13 name   : uart_internal_if13.sv
Title13       : Interface13 File13
Project13     : UART13 Block Level13
Created13     :
Description13 : Interface13 for collecting13 white13 box13 coverage13
Notes13       :
----------------------------------------------------------------------
Copyright13 2007 (c) Cadence13 Design13 Systems13, Inc13. All Rights13 Reserved13.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if13(input clock13);
 
  int tx_fifo_ptr13 ;
  int rx_fifo_ptr13 ;

endinterface  
