/*-------------------------------------------------------------------------
File21 name   : uart_if21.sv
Title21       : Interface21 file for uart21 uvc21
Project21     :
Created21     :
Description21 : Defines21 UART21 Interface21
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

  
interface uart_if21(input clock21, reset);

  logic txd21;    // Transmit21 Data
  logic rxd21;    // Receive21 Data
  
  logic intrpt21;  // Interrupt21

  logic ri_n21;    // ring21 indicator21
  logic cts_n21;   // clear to send
  logic dsr_n21;   // data set ready
  logic rts_n21;   // request to send
  logic dtr_n21;   // data terminal21 ready
  logic dcd_n21;   // data carrier21 detect21

  logic baud_clk21;  // Baud21 Rate21 Clock21
  
  // Control21 flags21
  bit                has_checks21 = 1;
  bit                has_coverage = 1;

/*  FIX21 TO USE21 CONCURRENT21 ASSERTIONS21
  always @(posedge clock21)
  begin
    // rxd21 must not be X or Z21
    assertRxdUnknown21:assert property (
                       disable iff(!has_checks21 || !reset)(!$isunknown(rxd21)))
                       else
                         $error("ERR_UART001_Rxd_XZ21\n Rxd21 went21 to X or Z21");
  end
*/

endinterface : uart_if21
