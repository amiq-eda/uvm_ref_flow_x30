/*-------------------------------------------------------------------------
File8 name   : uart_if8.sv
Title8       : Interface8 file for uart8 uvc8
Project8     :
Created8     :
Description8 : Defines8 UART8 Interface8
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

  
interface uart_if8(input clock8, reset);

  logic txd8;    // Transmit8 Data
  logic rxd8;    // Receive8 Data
  
  logic intrpt8;  // Interrupt8

  logic ri_n8;    // ring8 indicator8
  logic cts_n8;   // clear to send
  logic dsr_n8;   // data set ready
  logic rts_n8;   // request to send
  logic dtr_n8;   // data terminal8 ready
  logic dcd_n8;   // data carrier8 detect8

  logic baud_clk8;  // Baud8 Rate8 Clock8
  
  // Control8 flags8
  bit                has_checks8 = 1;
  bit                has_coverage = 1;

/*  FIX8 TO USE8 CONCURRENT8 ASSERTIONS8
  always @(posedge clock8)
  begin
    // rxd8 must not be X or Z8
    assertRxdUnknown8:assert property (
                       disable iff(!has_checks8 || !reset)(!$isunknown(rxd8)))
                       else
                         $error("ERR_UART001_Rxd_XZ8\n Rxd8 went8 to X or Z8");
  end
*/

endinterface : uart_if8
