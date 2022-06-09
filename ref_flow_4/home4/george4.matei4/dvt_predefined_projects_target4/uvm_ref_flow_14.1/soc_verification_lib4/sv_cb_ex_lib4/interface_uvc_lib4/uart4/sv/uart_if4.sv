/*-------------------------------------------------------------------------
File4 name   : uart_if4.sv
Title4       : Interface4 file for uart4 uvc4
Project4     :
Created4     :
Description4 : Defines4 UART4 Interface4
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

  
interface uart_if4(input clock4, reset);

  logic txd4;    // Transmit4 Data
  logic rxd4;    // Receive4 Data
  
  logic intrpt4;  // Interrupt4

  logic ri_n4;    // ring4 indicator4
  logic cts_n4;   // clear to send
  logic dsr_n4;   // data set ready
  logic rts_n4;   // request to send
  logic dtr_n4;   // data terminal4 ready
  logic dcd_n4;   // data carrier4 detect4

  logic baud_clk4;  // Baud4 Rate4 Clock4
  
  // Control4 flags4
  bit                has_checks4 = 1;
  bit                has_coverage = 1;

/*  FIX4 TO USE4 CONCURRENT4 ASSERTIONS4
  always @(posedge clock4)
  begin
    // rxd4 must not be X or Z4
    assertRxdUnknown4:assert property (
                       disable iff(!has_checks4 || !reset)(!$isunknown(rxd4)))
                       else
                         $error("ERR_UART001_Rxd_XZ4\n Rxd4 went4 to X or Z4");
  end
*/

endinterface : uart_if4
