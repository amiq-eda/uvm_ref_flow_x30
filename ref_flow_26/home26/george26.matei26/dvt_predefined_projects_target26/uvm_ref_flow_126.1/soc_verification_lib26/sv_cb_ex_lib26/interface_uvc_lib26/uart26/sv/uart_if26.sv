/*-------------------------------------------------------------------------
File26 name   : uart_if26.sv
Title26       : Interface26 file for uart26 uvc26
Project26     :
Created26     :
Description26 : Defines26 UART26 Interface26
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

  
interface uart_if26(input clock26, reset);

  logic txd26;    // Transmit26 Data
  logic rxd26;    // Receive26 Data
  
  logic intrpt26;  // Interrupt26

  logic ri_n26;    // ring26 indicator26
  logic cts_n26;   // clear to send
  logic dsr_n26;   // data set ready
  logic rts_n26;   // request to send
  logic dtr_n26;   // data terminal26 ready
  logic dcd_n26;   // data carrier26 detect26

  logic baud_clk26;  // Baud26 Rate26 Clock26
  
  // Control26 flags26
  bit                has_checks26 = 1;
  bit                has_coverage = 1;

/*  FIX26 TO USE26 CONCURRENT26 ASSERTIONS26
  always @(posedge clock26)
  begin
    // rxd26 must not be X or Z26
    assertRxdUnknown26:assert property (
                       disable iff(!has_checks26 || !reset)(!$isunknown(rxd26)))
                       else
                         $error("ERR_UART001_Rxd_XZ26\n Rxd26 went26 to X or Z26");
  end
*/

endinterface : uart_if26
