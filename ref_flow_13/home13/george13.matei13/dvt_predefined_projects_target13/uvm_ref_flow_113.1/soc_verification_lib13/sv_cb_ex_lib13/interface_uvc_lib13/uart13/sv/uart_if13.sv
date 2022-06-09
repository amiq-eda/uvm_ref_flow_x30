/*-------------------------------------------------------------------------
File13 name   : uart_if13.sv
Title13       : Interface13 file for uart13 uvc13
Project13     :
Created13     :
Description13 : Defines13 UART13 Interface13
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

  
interface uart_if13(input clock13, reset);

  logic txd13;    // Transmit13 Data
  logic rxd13;    // Receive13 Data
  
  logic intrpt13;  // Interrupt13

  logic ri_n13;    // ring13 indicator13
  logic cts_n13;   // clear to send
  logic dsr_n13;   // data set ready
  logic rts_n13;   // request to send
  logic dtr_n13;   // data terminal13 ready
  logic dcd_n13;   // data carrier13 detect13

  logic baud_clk13;  // Baud13 Rate13 Clock13
  
  // Control13 flags13
  bit                has_checks13 = 1;
  bit                has_coverage = 1;

/*  FIX13 TO USE13 CONCURRENT13 ASSERTIONS13
  always @(posedge clock13)
  begin
    // rxd13 must not be X or Z13
    assertRxdUnknown13:assert property (
                       disable iff(!has_checks13 || !reset)(!$isunknown(rxd13)))
                       else
                         $error("ERR_UART001_Rxd_XZ13\n Rxd13 went13 to X or Z13");
  end
*/

endinterface : uart_if13
