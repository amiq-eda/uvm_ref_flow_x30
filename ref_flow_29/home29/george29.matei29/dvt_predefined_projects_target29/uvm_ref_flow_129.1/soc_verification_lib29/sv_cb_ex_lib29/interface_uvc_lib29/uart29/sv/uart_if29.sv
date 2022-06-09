/*-------------------------------------------------------------------------
File29 name   : uart_if29.sv
Title29       : Interface29 file for uart29 uvc29
Project29     :
Created29     :
Description29 : Defines29 UART29 Interface29
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

  
interface uart_if29(input clock29, reset);

  logic txd29;    // Transmit29 Data
  logic rxd29;    // Receive29 Data
  
  logic intrpt29;  // Interrupt29

  logic ri_n29;    // ring29 indicator29
  logic cts_n29;   // clear to send
  logic dsr_n29;   // data set ready
  logic rts_n29;   // request to send
  logic dtr_n29;   // data terminal29 ready
  logic dcd_n29;   // data carrier29 detect29

  logic baud_clk29;  // Baud29 Rate29 Clock29
  
  // Control29 flags29
  bit                has_checks29 = 1;
  bit                has_coverage = 1;

/*  FIX29 TO USE29 CONCURRENT29 ASSERTIONS29
  always @(posedge clock29)
  begin
    // rxd29 must not be X or Z29
    assertRxdUnknown29:assert property (
                       disable iff(!has_checks29 || !reset)(!$isunknown(rxd29)))
                       else
                         $error("ERR_UART001_Rxd_XZ29\n Rxd29 went29 to X or Z29");
  end
*/

endinterface : uart_if29
