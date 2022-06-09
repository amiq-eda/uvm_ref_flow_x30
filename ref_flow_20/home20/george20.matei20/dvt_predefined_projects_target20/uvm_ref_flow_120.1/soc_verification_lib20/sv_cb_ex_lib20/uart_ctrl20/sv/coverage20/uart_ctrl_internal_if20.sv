/*-------------------------------------------------------------------------
File20 name   : uart_internal_if20.sv
Title20       : Interface20 File20
Project20     : UART20 Block Level20
Created20     :
Description20 : Interface20 for collecting20 white20 box20 coverage20
Notes20       :
----------------------------------------------------------------------
Copyright20 2007 (c) Cadence20 Design20 Systems20, Inc20. All Rights20 Reserved20.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if20(input clock20);
 
  int tx_fifo_ptr20 ;
  int rx_fifo_ptr20 ;

endinterface  
