/*-------------------------------------------------------------------------
File25 name   : uart_if25.sv
Title25       : Interface25 file for uart25 uvc25
Project25     :
Created25     :
Description25 : Defines25 UART25 Interface25
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

  
interface uart_if25(input clock25, reset);

  logic txd25;    // Transmit25 Data
  logic rxd25;    // Receive25 Data
  
  logic intrpt25;  // Interrupt25

  logic ri_n25;    // ring25 indicator25
  logic cts_n25;   // clear to send
  logic dsr_n25;   // data set ready
  logic rts_n25;   // request to send
  logic dtr_n25;   // data terminal25 ready
  logic dcd_n25;   // data carrier25 detect25

  logic baud_clk25;  // Baud25 Rate25 Clock25
  
  // Control25 flags25
  bit                has_checks25 = 1;
  bit                has_coverage = 1;

/*  FIX25 TO USE25 CONCURRENT25 ASSERTIONS25
  always @(posedge clock25)
  begin
    // rxd25 must not be X or Z25
    assertRxdUnknown25:assert property (
                       disable iff(!has_checks25 || !reset)(!$isunknown(rxd25)))
                       else
                         $error("ERR_UART001_Rxd_XZ25\n Rxd25 went25 to X or Z25");
  end
*/

endinterface : uart_if25
