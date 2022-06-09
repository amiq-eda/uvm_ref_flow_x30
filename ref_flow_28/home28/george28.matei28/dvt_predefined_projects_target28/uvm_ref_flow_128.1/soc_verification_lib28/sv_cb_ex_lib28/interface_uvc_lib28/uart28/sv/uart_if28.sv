/*-------------------------------------------------------------------------
File28 name   : uart_if28.sv
Title28       : Interface28 file for uart28 uvc28
Project28     :
Created28     :
Description28 : Defines28 UART28 Interface28
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

  
interface uart_if28(input clock28, reset);

  logic txd28;    // Transmit28 Data
  logic rxd28;    // Receive28 Data
  
  logic intrpt28;  // Interrupt28

  logic ri_n28;    // ring28 indicator28
  logic cts_n28;   // clear to send
  logic dsr_n28;   // data set ready
  logic rts_n28;   // request to send
  logic dtr_n28;   // data terminal28 ready
  logic dcd_n28;   // data carrier28 detect28

  logic baud_clk28;  // Baud28 Rate28 Clock28
  
  // Control28 flags28
  bit                has_checks28 = 1;
  bit                has_coverage = 1;

/*  FIX28 TO USE28 CONCURRENT28 ASSERTIONS28
  always @(posedge clock28)
  begin
    // rxd28 must not be X or Z28
    assertRxdUnknown28:assert property (
                       disable iff(!has_checks28 || !reset)(!$isunknown(rxd28)))
                       else
                         $error("ERR_UART001_Rxd_XZ28\n Rxd28 went28 to X or Z28");
  end
*/

endinterface : uart_if28
