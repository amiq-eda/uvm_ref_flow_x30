/*-------------------------------------------------------------------------
File5 name   : uart_if5.sv
Title5       : Interface5 file for uart5 uvc5
Project5     :
Created5     :
Description5 : Defines5 UART5 Interface5
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

  
interface uart_if5(input clock5, reset);

  logic txd5;    // Transmit5 Data
  logic rxd5;    // Receive5 Data
  
  logic intrpt5;  // Interrupt5

  logic ri_n5;    // ring5 indicator5
  logic cts_n5;   // clear to send
  logic dsr_n5;   // data set ready
  logic rts_n5;   // request to send
  logic dtr_n5;   // data terminal5 ready
  logic dcd_n5;   // data carrier5 detect5

  logic baud_clk5;  // Baud5 Rate5 Clock5
  
  // Control5 flags5
  bit                has_checks5 = 1;
  bit                has_coverage = 1;

/*  FIX5 TO USE5 CONCURRENT5 ASSERTIONS5
  always @(posedge clock5)
  begin
    // rxd5 must not be X or Z5
    assertRxdUnknown5:assert property (
                       disable iff(!has_checks5 || !reset)(!$isunknown(rxd5)))
                       else
                         $error("ERR_UART001_Rxd_XZ5\n Rxd5 went5 to X or Z5");
  end
*/

endinterface : uart_if5
