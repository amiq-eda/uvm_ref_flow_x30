/*-------------------------------------------------------------------------
File3 name   : uart_internal_if3.sv
Title3       : Interface3 File3
Project3     : UART3 Block Level3
Created3     :
Description3 : Interface3 for collecting3 white3 box3 coverage3
Notes3       :
----------------------------------------------------------------------
Copyright3 2007 (c) Cadence3 Design3 Systems3, Inc3. All Rights3 Reserved3.
----------------------------------------------------------------------*/

interface uart_ctrl_internal_if3(input clock3);
 
  int tx_fifo_ptr3 ;
  int rx_fifo_ptr3 ;

endinterface  
