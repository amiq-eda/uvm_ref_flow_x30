/*-------------------------------------------------------------------------
File23 name   : uart_if23.sv
Title23       : Interface23 file for uart23 uvc23
Project23     :
Created23     :
Description23 : Defines23 UART23 Interface23
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

  
interface uart_if23(input clock23, reset);

  logic txd23;    // Transmit23 Data
  logic rxd23;    // Receive23 Data
  
  logic intrpt23;  // Interrupt23

  logic ri_n23;    // ring23 indicator23
  logic cts_n23;   // clear to send
  logic dsr_n23;   // data set ready
  logic rts_n23;   // request to send
  logic dtr_n23;   // data terminal23 ready
  logic dcd_n23;   // data carrier23 detect23

  logic baud_clk23;  // Baud23 Rate23 Clock23
  
  // Control23 flags23
  bit                has_checks23 = 1;
  bit                has_coverage = 1;

/*  FIX23 TO USE23 CONCURRENT23 ASSERTIONS23
  always @(posedge clock23)
  begin
    // rxd23 must not be X or Z23
    assertRxdUnknown23:assert property (
                       disable iff(!has_checks23 || !reset)(!$isunknown(rxd23)))
                       else
                         $error("ERR_UART001_Rxd_XZ23\n Rxd23 went23 to X or Z23");
  end
*/

endinterface : uart_if23
