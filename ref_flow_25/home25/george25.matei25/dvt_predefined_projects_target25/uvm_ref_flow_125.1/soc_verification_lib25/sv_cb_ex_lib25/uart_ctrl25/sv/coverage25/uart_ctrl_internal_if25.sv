/*-------------------------------------------------------------------------
File25 name   : uart_internal_if25.sv
Title25       : Interface25 File25
Project25     : UART25 Block Level25
Created25     :
Description25 : Interface25 for collecting25 white25 box25 coverage25
Notes25       :
----------------------------------------------------------------------
Copyright25 2007 (c) Cadence25 Design25 Systems25, Inc25. All Rights25 Reserved25.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if25(input clock25);
 
  int tx_fifo_ptr25 ;
  int rx_fifo_ptr25 ;

endinterface  
