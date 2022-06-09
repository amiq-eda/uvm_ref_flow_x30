/*-------------------------------------------------------------------------
File12 name   : uart_internal_if12.sv
Title12       : Interface12 File12
Project12     : UART12 Block Level12
Created12     :
Description12 : Interface12 for collecting12 white12 box12 coverage12
Notes12       :
----------------------------------------------------------------------
Copyright12 2007 (c) Cadence12 Design12 Systems12, Inc12. All Rights12 Reserved12.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if12(input clock12);
 
  int tx_fifo_ptr12 ;
  int rx_fifo_ptr12 ;

endinterface  
