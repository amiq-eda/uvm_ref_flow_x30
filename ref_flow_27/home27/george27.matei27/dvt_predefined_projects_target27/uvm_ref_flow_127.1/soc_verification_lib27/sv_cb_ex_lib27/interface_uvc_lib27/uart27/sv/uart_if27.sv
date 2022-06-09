/*-------------------------------------------------------------------------
File27 name   : uart_if27.sv
Title27       : Interface27 file for uart27 uvc27
Project27     :
Created27     :
Description27 : Defines27 UART27 Interface27
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

  
interface uart_if27(input clock27, reset);

  logic txd27;    // Transmit27 Data
  logic rxd27;    // Receive27 Data
  
  logic intrpt27;  // Interrupt27

  logic ri_n27;    // ring27 indicator27
  logic cts_n27;   // clear to send
  logic dsr_n27;   // data set ready
  logic rts_n27;   // request to send
  logic dtr_n27;   // data terminal27 ready
  logic dcd_n27;   // data carrier27 detect27

  logic baud_clk27;  // Baud27 Rate27 Clock27
  
  // Control27 flags27
  bit                has_checks27 = 1;
  bit                has_coverage = 1;

/*  FIX27 TO USE27 CONCURRENT27 ASSERTIONS27
  always @(posedge clock27)
  begin
    // rxd27 must not be X or Z27
    assertRxdUnknown27:assert property (
                       disable iff(!has_checks27 || !reset)(!$isunknown(rxd27)))
                       else
                         $error("ERR_UART001_Rxd_XZ27\n Rxd27 went27 to X or Z27");
  end
*/

endinterface : uart_if27
