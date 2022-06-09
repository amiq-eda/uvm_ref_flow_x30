/*-------------------------------------------------------------------------
File19 name   : uart_if19.sv
Title19       : Interface19 file for uart19 uvc19
Project19     :
Created19     :
Description19 : Defines19 UART19 Interface19
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

  
interface uart_if19(input clock19, reset);

  logic txd19;    // Transmit19 Data
  logic rxd19;    // Receive19 Data
  
  logic intrpt19;  // Interrupt19

  logic ri_n19;    // ring19 indicator19
  logic cts_n19;   // clear to send
  logic dsr_n19;   // data set ready
  logic rts_n19;   // request to send
  logic dtr_n19;   // data terminal19 ready
  logic dcd_n19;   // data carrier19 detect19

  logic baud_clk19;  // Baud19 Rate19 Clock19
  
  // Control19 flags19
  bit                has_checks19 = 1;
  bit                has_coverage = 1;

/*  FIX19 TO USE19 CONCURRENT19 ASSERTIONS19
  always @(posedge clock19)
  begin
    // rxd19 must not be X or Z19
    assertRxdUnknown19:assert property (
                       disable iff(!has_checks19 || !reset)(!$isunknown(rxd19)))
                       else
                         $error("ERR_UART001_Rxd_XZ19\n Rxd19 went19 to X or Z19");
  end
*/

endinterface : uart_if19
