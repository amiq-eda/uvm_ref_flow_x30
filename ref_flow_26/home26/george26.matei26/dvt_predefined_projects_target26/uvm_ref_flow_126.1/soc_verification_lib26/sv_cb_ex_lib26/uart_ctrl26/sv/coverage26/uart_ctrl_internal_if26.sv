/*-------------------------------------------------------------------------
File26 name   : uart_internal_if26.sv
Title26       : Interface26 File26
Project26     : UART26 Block Level26
Created26     :
Description26 : Interface26 for collecting26 white26 box26 coverage26
Notes26       :
----------------------------------------------------------------------
Copyright26 2007 (c) Cadence26 Design26 Systems26, Inc26. All Rights26 Reserved26.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if26(input clock26);
 
  int tx_fifo_ptr26 ;
  int rx_fifo_ptr26 ;

endinterface  
