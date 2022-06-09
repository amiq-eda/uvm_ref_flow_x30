/*-------------------------------------------------------------------------
File15 name   : uart_if15.sv
Title15       : Interface15 file for uart15 uvc15
Project15     :
Created15     :
Description15 : Defines15 UART15 Interface15
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

  
interface uart_if15(input clock15, reset);

  logic txd15;    // Transmit15 Data
  logic rxd15;    // Receive15 Data
  
  logic intrpt15;  // Interrupt15

  logic ri_n15;    // ring15 indicator15
  logic cts_n15;   // clear to send
  logic dsr_n15;   // data set ready
  logic rts_n15;   // request to send
  logic dtr_n15;   // data terminal15 ready
  logic dcd_n15;   // data carrier15 detect15

  logic baud_clk15;  // Baud15 Rate15 Clock15
  
  // Control15 flags15
  bit                has_checks15 = 1;
  bit                has_coverage = 1;

/*  FIX15 TO USE15 CONCURRENT15 ASSERTIONS15
  always @(posedge clock15)
  begin
    // rxd15 must not be X or Z15
    assertRxdUnknown15:assert property (
                       disable iff(!has_checks15 || !reset)(!$isunknown(rxd15)))
                       else
                         $error("ERR_UART001_Rxd_XZ15\n Rxd15 went15 to X or Z15");
  end
*/

endinterface : uart_if15
