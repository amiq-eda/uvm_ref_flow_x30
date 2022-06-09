/*-------------------------------------------------------------------------
File16 name   : uart_if16.sv
Title16       : Interface16 file for uart16 uvc16
Project16     :
Created16     :
Description16 : Defines16 UART16 Interface16
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

  
interface uart_if16(input clock16, reset);

  logic txd16;    // Transmit16 Data
  logic rxd16;    // Receive16 Data
  
  logic intrpt16;  // Interrupt16

  logic ri_n16;    // ring16 indicator16
  logic cts_n16;   // clear to send
  logic dsr_n16;   // data set ready
  logic rts_n16;   // request to send
  logic dtr_n16;   // data terminal16 ready
  logic dcd_n16;   // data carrier16 detect16

  logic baud_clk16;  // Baud16 Rate16 Clock16
  
  // Control16 flags16
  bit                has_checks16 = 1;
  bit                has_coverage = 1;

/*  FIX16 TO USE16 CONCURRENT16 ASSERTIONS16
  always @(posedge clock16)
  begin
    // rxd16 must not be X or Z16
    assertRxdUnknown16:assert property (
                       disable iff(!has_checks16 || !reset)(!$isunknown(rxd16)))
                       else
                         $error("ERR_UART001_Rxd_XZ16\n Rxd16 went16 to X or Z16");
  end
*/

endinterface : uart_if16
