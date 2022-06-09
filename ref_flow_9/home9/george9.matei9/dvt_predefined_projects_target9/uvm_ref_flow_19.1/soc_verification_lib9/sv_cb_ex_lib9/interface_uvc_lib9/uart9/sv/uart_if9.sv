/*-------------------------------------------------------------------------
File9 name   : uart_if9.sv
Title9       : Interface9 file for uart9 uvc9
Project9     :
Created9     :
Description9 : Defines9 UART9 Interface9
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

  
interface uart_if9(input clock9, reset);

  logic txd9;    // Transmit9 Data
  logic rxd9;    // Receive9 Data
  
  logic intrpt9;  // Interrupt9

  logic ri_n9;    // ring9 indicator9
  logic cts_n9;   // clear to send
  logic dsr_n9;   // data set ready
  logic rts_n9;   // request to send
  logic dtr_n9;   // data terminal9 ready
  logic dcd_n9;   // data carrier9 detect9

  logic baud_clk9;  // Baud9 Rate9 Clock9
  
  // Control9 flags9
  bit                has_checks9 = 1;
  bit                has_coverage = 1;

/*  FIX9 TO USE9 CONCURRENT9 ASSERTIONS9
  always @(posedge clock9)
  begin
    // rxd9 must not be X or Z9
    assertRxdUnknown9:assert property (
                       disable iff(!has_checks9 || !reset)(!$isunknown(rxd9)))
                       else
                         $error("ERR_UART001_Rxd_XZ9\n Rxd9 went9 to X or Z9");
  end
*/

endinterface : uart_if9
