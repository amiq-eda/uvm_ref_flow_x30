/*-------------------------------------------------------------------------
File24 name   : uart_if24.sv
Title24       : Interface24 file for uart24 uvc24
Project24     :
Created24     :
Description24 : Defines24 UART24 Interface24
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

  
interface uart_if24(input clock24, reset);

  logic txd24;    // Transmit24 Data
  logic rxd24;    // Receive24 Data
  
  logic intrpt24;  // Interrupt24

  logic ri_n24;    // ring24 indicator24
  logic cts_n24;   // clear to send
  logic dsr_n24;   // data set ready
  logic rts_n24;   // request to send
  logic dtr_n24;   // data terminal24 ready
  logic dcd_n24;   // data carrier24 detect24

  logic baud_clk24;  // Baud24 Rate24 Clock24
  
  // Control24 flags24
  bit                has_checks24 = 1;
  bit                has_coverage = 1;

/*  FIX24 TO USE24 CONCURRENT24 ASSERTIONS24
  always @(posedge clock24)
  begin
    // rxd24 must not be X or Z24
    assertRxdUnknown24:assert property (
                       disable iff(!has_checks24 || !reset)(!$isunknown(rxd24)))
                       else
                         $error("ERR_UART001_Rxd_XZ24\n Rxd24 went24 to X or Z24");
  end
*/

endinterface : uart_if24
