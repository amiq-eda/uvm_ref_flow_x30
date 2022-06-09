/*-------------------------------------------------------------------------
File5 name   : uart_internal_if5.sv
Title5       : Interface5 File5
Project5     : UART5 Block Level5
Created5     :
Description5 : Interface5 for collecting5 white5 box5 coverage5
Notes5       :
----------------------------------------------------------------------
Copyright5 2007 (c) Cadence5 Design5 Systems5, Inc5. All Rights5 Reserved5.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if5(input clock5);
 
  int tx_fifo_ptr5 ;
  int rx_fifo_ptr5 ;

endinterface  
