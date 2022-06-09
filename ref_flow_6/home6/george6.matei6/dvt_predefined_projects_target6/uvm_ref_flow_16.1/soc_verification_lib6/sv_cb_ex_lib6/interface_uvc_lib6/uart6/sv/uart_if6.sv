/*-------------------------------------------------------------------------
File6 name   : uart_if6.sv
Title6       : Interface6 file for uart6 uvc6
Project6     :
Created6     :
Description6 : Defines6 UART6 Interface6
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

  
interface uart_if6(input clock6, reset);

  logic txd6;    // Transmit6 Data
  logic rxd6;    // Receive6 Data
  
  logic intrpt6;  // Interrupt6

  logic ri_n6;    // ring6 indicator6
  logic cts_n6;   // clear to send
  logic dsr_n6;   // data set ready
  logic rts_n6;   // request to send
  logic dtr_n6;   // data terminal6 ready
  logic dcd_n6;   // data carrier6 detect6

  logic baud_clk6;  // Baud6 Rate6 Clock6
  
  // Control6 flags6
  bit                has_checks6 = 1;
  bit                has_coverage = 1;

/*  FIX6 TO USE6 CONCURRENT6 ASSERTIONS6
  always @(posedge clock6)
  begin
    // rxd6 must not be X or Z6
    assertRxdUnknown6:assert property (
                       disable iff(!has_checks6 || !reset)(!$isunknown(rxd6)))
                       else
                         $error("ERR_UART001_Rxd_XZ6\n Rxd6 went6 to X or Z6");
  end
*/

endinterface : uart_if6
