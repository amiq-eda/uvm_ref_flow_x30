/*-------------------------------------------------------------------------
File18 name   : uart_if18.sv
Title18       : Interface18 file for uart18 uvc18
Project18     :
Created18     :
Description18 : Defines18 UART18 Interface18
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

  
interface uart_if18(input clock18, reset);

  logic txd18;    // Transmit18 Data
  logic rxd18;    // Receive18 Data
  
  logic intrpt18;  // Interrupt18

  logic ri_n18;    // ring18 indicator18
  logic cts_n18;   // clear to send
  logic dsr_n18;   // data set ready
  logic rts_n18;   // request to send
  logic dtr_n18;   // data terminal18 ready
  logic dcd_n18;   // data carrier18 detect18

  logic baud_clk18;  // Baud18 Rate18 Clock18
  
  // Control18 flags18
  bit                has_checks18 = 1;
  bit                has_coverage = 1;

/*  FIX18 TO USE18 CONCURRENT18 ASSERTIONS18
  always @(posedge clock18)
  begin
    // rxd18 must not be X or Z18
    assertRxdUnknown18:assert property (
                       disable iff(!has_checks18 || !reset)(!$isunknown(rxd18)))
                       else
                         $error("ERR_UART001_Rxd_XZ18\n Rxd18 went18 to X or Z18");
  end
*/

endinterface : uart_if18
