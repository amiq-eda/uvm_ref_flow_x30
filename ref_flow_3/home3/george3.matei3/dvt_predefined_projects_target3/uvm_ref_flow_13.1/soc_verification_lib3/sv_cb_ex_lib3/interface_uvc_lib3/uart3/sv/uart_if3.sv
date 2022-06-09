/*-------------------------------------------------------------------------
File3 name   : uart_if3.sv
Title3       : Interface3 file for uart3 uvc3
Project3     :
Created3     :
Description3 : Defines3 UART3 Interface3
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

  
interface uart_if3(input clock3, reset);

  logic txd3;    // Transmit3 Data
  logic rxd3;    // Receive3 Data
  
  logic intrpt3;  // Interrupt3

  logic ri_n3;    // ring3 indicator3
  logic cts_n3;   // clear to send
  logic dsr_n3;   // data set ready
  logic rts_n3;   // request to send
  logic dtr_n3;   // data terminal3 ready
  logic dcd_n3;   // data carrier3 detect3

  logic baud_clk3;  // Baud3 Rate3 Clock3
  
  // Control3 flags3
  bit                has_checks3 = 1;
  bit                has_coverage = 1;

/*  FIX3 TO USE3 CONCURRENT3 ASSERTIONS3
  always @(posedge clock3)
  begin
    // rxd3 must not be X or Z3
    assertRxdUnknown3:assert property (
                       disable iff(!has_checks3 || !reset)(!$isunknown(rxd3)))
                       else
                         $error("ERR_UART001_Rxd_XZ3\n Rxd3 went3 to X or Z3");
  end
*/

endinterface : uart_if3
