/*-------------------------------------------------------------------------
File12 name   : uart_if12.sv
Title12       : Interface12 file for uart12 uvc12
Project12     :
Created12     :
Description12 : Defines12 UART12 Interface12
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

  
interface uart_if12(input clock12, reset);

  logic txd12;    // Transmit12 Data
  logic rxd12;    // Receive12 Data
  
  logic intrpt12;  // Interrupt12

  logic ri_n12;    // ring12 indicator12
  logic cts_n12;   // clear to send
  logic dsr_n12;   // data set ready
  logic rts_n12;   // request to send
  logic dtr_n12;   // data terminal12 ready
  logic dcd_n12;   // data carrier12 detect12

  logic baud_clk12;  // Baud12 Rate12 Clock12
  
  // Control12 flags12
  bit                has_checks12 = 1;
  bit                has_coverage = 1;

/*  FIX12 TO USE12 CONCURRENT12 ASSERTIONS12
  always @(posedge clock12)
  begin
    // rxd12 must not be X or Z12
    assertRxdUnknown12:assert property (
                       disable iff(!has_checks12 || !reset)(!$isunknown(rxd12)))
                       else
                         $error("ERR_UART001_Rxd_XZ12\n Rxd12 went12 to X or Z12");
  end
*/

endinterface : uart_if12
