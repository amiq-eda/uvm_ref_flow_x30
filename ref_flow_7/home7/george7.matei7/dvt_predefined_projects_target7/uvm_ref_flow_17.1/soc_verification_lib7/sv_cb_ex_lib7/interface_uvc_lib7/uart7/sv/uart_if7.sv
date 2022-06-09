/*-------------------------------------------------------------------------
File7 name   : uart_if7.sv
Title7       : Interface7 file for uart7 uvc7
Project7     :
Created7     :
Description7 : Defines7 UART7 Interface7
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

  
interface uart_if7(input clock7, reset);

  logic txd7;    // Transmit7 Data
  logic rxd7;    // Receive7 Data
  
  logic intrpt7;  // Interrupt7

  logic ri_n7;    // ring7 indicator7
  logic cts_n7;   // clear to send
  logic dsr_n7;   // data set ready
  logic rts_n7;   // request to send
  logic dtr_n7;   // data terminal7 ready
  logic dcd_n7;   // data carrier7 detect7

  logic baud_clk7;  // Baud7 Rate7 Clock7
  
  // Control7 flags7
  bit                has_checks7 = 1;
  bit                has_coverage = 1;

/*  FIX7 TO USE7 CONCURRENT7 ASSERTIONS7
  always @(posedge clock7)
  begin
    // rxd7 must not be X or Z7
    assertRxdUnknown7:assert property (
                       disable iff(!has_checks7 || !reset)(!$isunknown(rxd7)))
                       else
                         $error("ERR_UART001_Rxd_XZ7\n Rxd7 went7 to X or Z7");
  end
*/

endinterface : uart_if7
