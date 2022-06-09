/*-------------------------------------------------------------------------
File7 name   : uart_internal_if7.sv
Title7       : Interface7 File7
Project7     : UART7 Block Level7
Created7     :
Description7 : Interface7 for collecting7 white7 box7 coverage7
Notes7       :
----------------------------------------------------------------------
Copyright7 2007 (c) Cadence7 Design7 Systems7, Inc7. All Rights7 Reserved7.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if7(input clock7);
 
  int tx_fifo_ptr7 ;
  int rx_fifo_ptr7 ;

endinterface  
