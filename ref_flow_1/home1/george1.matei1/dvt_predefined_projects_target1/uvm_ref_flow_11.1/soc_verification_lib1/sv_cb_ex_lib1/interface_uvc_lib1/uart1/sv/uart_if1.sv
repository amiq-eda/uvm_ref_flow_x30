/*-------------------------------------------------------------------------
File1 name   : uart_if1.sv
Title1       : Interface1 file for uart1 uvc1
Project1     :
Created1     :
Description1 : Defines1 UART1 Interface1
Notes1       :  
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

  
interface uart_if1(input clock1, reset);

  logic txd1;    // Transmit1 Data
  logic rxd1;    // Receive1 Data
  
  logic intrpt1;  // Interrupt1

  logic ri_n1;    // ring1 indicator1
  logic cts_n1;   // clear to send
  logic dsr_n1;   // data set ready
  logic rts_n1;   // request to send
  logic dtr_n1;   // data terminal1 ready
  logic dcd_n1;   // data carrier1 detect1

  logic baud_clk1;  // Baud1 Rate1 Clock1
  
  // Control1 flags1
  bit                has_checks1 = 1;
  bit                has_coverage = 1;

/*  FIX1 TO USE1 CONCURRENT1 ASSERTIONS1
  always @(posedge clock1)
  begin
    // rxd1 must not be X or Z1
    assertRxdUnknown1:assert property (
                       disable iff(!has_checks1 || !reset)(!$isunknown(rxd1)))
                       else
                         $error("ERR_UART001_Rxd_XZ1\n Rxd1 went1 to X or Z1");
  end
*/

endinterface : uart_if1
