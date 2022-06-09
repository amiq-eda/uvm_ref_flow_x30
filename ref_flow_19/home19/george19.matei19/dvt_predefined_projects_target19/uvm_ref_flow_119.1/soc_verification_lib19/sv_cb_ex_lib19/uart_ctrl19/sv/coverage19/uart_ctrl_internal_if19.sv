/*-------------------------------------------------------------------------
File19 name   : uart_internal_if19.sv
Title19       : Interface19 File19
Project19     : UART19 Block Level19
Created19     :
Description19 : Interface19 for collecting19 white19 box19 coverage19
Notes19       :
----------------------------------------------------------------------
Copyright19 2007 (c) Cadence19 Design19 Systems19, Inc19. All Rights19 Reserved19.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if19(input clock19);
 
  int tx_fifo_ptr19 ;
  int rx_fifo_ptr19 ;

endinterface  
