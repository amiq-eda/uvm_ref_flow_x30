/*-------------------------------------------------------------------------
File17 name   : uart_if17.sv
Title17       : Interface17 file for uart17 uvc17
Project17     :
Created17     :
Description17 : Defines17 UART17 Interface17
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

  
interface uart_if17(input clock17, reset);

  logic txd17;    // Transmit17 Data
  logic rxd17;    // Receive17 Data
  
  logic intrpt17;  // Interrupt17

  logic ri_n17;    // ring17 indicator17
  logic cts_n17;   // clear to send
  logic dsr_n17;   // data set ready
  logic rts_n17;   // request to send
  logic dtr_n17;   // data terminal17 ready
  logic dcd_n17;   // data carrier17 detect17

  logic baud_clk17;  // Baud17 Rate17 Clock17
  
  // Control17 flags17
  bit                has_checks17 = 1;
  bit                has_coverage = 1;

/*  FIX17 TO USE17 CONCURRENT17 ASSERTIONS17
  always @(posedge clock17)
  begin
    // rxd17 must not be X or Z17
    assertRxdUnknown17:assert property (
                       disable iff(!has_checks17 || !reset)(!$isunknown(rxd17)))
                       else
                         $error("ERR_UART001_Rxd_XZ17\n Rxd17 went17 to X or Z17");
  end
*/

endinterface : uart_if17
