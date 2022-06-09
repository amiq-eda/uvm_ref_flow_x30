/*-------------------------------------------------------------------------
File22 name   : uart_if22.sv
Title22       : Interface22 file for uart22 uvc22
Project22     :
Created22     :
Description22 : Defines22 UART22 Interface22
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

  
interface uart_if22(input clock22, reset);

  logic txd22;    // Transmit22 Data
  logic rxd22;    // Receive22 Data
  
  logic intrpt22;  // Interrupt22

  logic ri_n22;    // ring22 indicator22
  logic cts_n22;   // clear to send
  logic dsr_n22;   // data set ready
  logic rts_n22;   // request to send
  logic dtr_n22;   // data terminal22 ready
  logic dcd_n22;   // data carrier22 detect22

  logic baud_clk22;  // Baud22 Rate22 Clock22
  
  // Control22 flags22
  bit                has_checks22 = 1;
  bit                has_coverage = 1;

/*  FIX22 TO USE22 CONCURRENT22 ASSERTIONS22
  always @(posedge clock22)
  begin
    // rxd22 must not be X or Z22
    assertRxdUnknown22:assert property (
                       disable iff(!has_checks22 || !reset)(!$isunknown(rxd22)))
                       else
                         $error("ERR_UART001_Rxd_XZ22\n Rxd22 went22 to X or Z22");
  end
*/

endinterface : uart_if22
