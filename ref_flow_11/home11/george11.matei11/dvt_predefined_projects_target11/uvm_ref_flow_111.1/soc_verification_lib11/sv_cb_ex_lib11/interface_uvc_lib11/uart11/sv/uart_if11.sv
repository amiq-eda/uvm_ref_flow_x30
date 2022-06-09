/*-------------------------------------------------------------------------
File11 name   : uart_if11.sv
Title11       : Interface11 file for uart11 uvc11
Project11     :
Created11     :
Description11 : Defines11 UART11 Interface11
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

  
interface uart_if11(input clock11, reset);

  logic txd11;    // Transmit11 Data
  logic rxd11;    // Receive11 Data
  
  logic intrpt11;  // Interrupt11

  logic ri_n11;    // ring11 indicator11
  logic cts_n11;   // clear to send
  logic dsr_n11;   // data set ready
  logic rts_n11;   // request to send
  logic dtr_n11;   // data terminal11 ready
  logic dcd_n11;   // data carrier11 detect11

  logic baud_clk11;  // Baud11 Rate11 Clock11
  
  // Control11 flags11
  bit                has_checks11 = 1;
  bit                has_coverage = 1;

/*  FIX11 TO USE11 CONCURRENT11 ASSERTIONS11
  always @(posedge clock11)
  begin
    // rxd11 must not be X or Z11
    assertRxdUnknown11:assert property (
                       disable iff(!has_checks11 || !reset)(!$isunknown(rxd11)))
                       else
                         $error("ERR_UART001_Rxd_XZ11\n Rxd11 went11 to X or Z11");
  end
*/

endinterface : uart_if11
