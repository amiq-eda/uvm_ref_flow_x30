/*-------------------------------------------------------------------------
File20 name   : uart_if20.sv
Title20       : Interface20 file for uart20 uvc20
Project20     :
Created20     :
Description20 : Defines20 UART20 Interface20
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

  
interface uart_if20(input clock20, reset);

  logic txd20;    // Transmit20 Data
  logic rxd20;    // Receive20 Data
  
  logic intrpt20;  // Interrupt20

  logic ri_n20;    // ring20 indicator20
  logic cts_n20;   // clear to send
  logic dsr_n20;   // data set ready
  logic rts_n20;   // request to send
  logic dtr_n20;   // data terminal20 ready
  logic dcd_n20;   // data carrier20 detect20

  logic baud_clk20;  // Baud20 Rate20 Clock20
  
  // Control20 flags20
  bit                has_checks20 = 1;
  bit                has_coverage = 1;

/*  FIX20 TO USE20 CONCURRENT20 ASSERTIONS20
  always @(posedge clock20)
  begin
    // rxd20 must not be X or Z20
    assertRxdUnknown20:assert property (
                       disable iff(!has_checks20 || !reset)(!$isunknown(rxd20)))
                       else
                         $error("ERR_UART001_Rxd_XZ20\n Rxd20 went20 to X or Z20");
  end
*/

endinterface : uart_if20
