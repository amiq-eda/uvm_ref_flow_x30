/*-------------------------------------------------------------------------
File10 name   : uart_if10.sv
Title10       : Interface10 file for uart10 uvc10
Project10     :
Created10     :
Description10 : Defines10 UART10 Interface10
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

  
interface uart_if10(input clock10, reset);

  logic txd10;    // Transmit10 Data
  logic rxd10;    // Receive10 Data
  
  logic intrpt10;  // Interrupt10

  logic ri_n10;    // ring10 indicator10
  logic cts_n10;   // clear to send
  logic dsr_n10;   // data set ready
  logic rts_n10;   // request to send
  logic dtr_n10;   // data terminal10 ready
  logic dcd_n10;   // data carrier10 detect10

  logic baud_clk10;  // Baud10 Rate10 Clock10
  
  // Control10 flags10
  bit                has_checks10 = 1;
  bit                has_coverage = 1;

/*  FIX10 TO USE10 CONCURRENT10 ASSERTIONS10
  always @(posedge clock10)
  begin
    // rxd10 must not be X or Z10
    assertRxdUnknown10:assert property (
                       disable iff(!has_checks10 || !reset)(!$isunknown(rxd10)))
                       else
                         $error("ERR_UART001_Rxd_XZ10\n Rxd10 went10 to X or Z10");
  end
*/

endinterface : uart_if10
