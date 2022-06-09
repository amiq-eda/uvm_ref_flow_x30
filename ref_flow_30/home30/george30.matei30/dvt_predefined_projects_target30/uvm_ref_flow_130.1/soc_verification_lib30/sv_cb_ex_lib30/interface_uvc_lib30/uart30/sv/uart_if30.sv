/*-------------------------------------------------------------------------
File30 name   : uart_if30.sv
Title30       : Interface30 file for uart30 uvc30
Project30     :
Created30     :
Description30 : Defines30 UART30 Interface30
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

  
interface uart_if30(input clock30, reset);

  logic txd30;    // Transmit30 Data
  logic rxd30;    // Receive30 Data
  
  logic intrpt30;  // Interrupt30

  logic ri_n30;    // ring30 indicator30
  logic cts_n30;   // clear to send
  logic dsr_n30;   // data set ready
  logic rts_n30;   // request to send
  logic dtr_n30;   // data terminal30 ready
  logic dcd_n30;   // data carrier30 detect30

  logic baud_clk30;  // Baud30 Rate30 Clock30
  
  // Control30 flags30
  bit                has_checks30 = 1;
  bit                has_coverage = 1;

/*  FIX30 TO USE30 CONCURRENT30 ASSERTIONS30
  always @(posedge clock30)
  begin
    // rxd30 must not be X or Z30
    assertRxdUnknown30:assert property (
                       disable iff(!has_checks30 || !reset)(!$isunknown(rxd30)))
                       else
                         $error("ERR_UART001_Rxd_XZ30\n Rxd30 went30 to X or Z30");
  end
*/

endinterface : uart_if30
