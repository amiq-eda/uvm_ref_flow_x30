/*-------------------------------------------------------------------------
File14 name   : uart_if14.sv
Title14       : Interface14 file for uart14 uvc14
Project14     :
Created14     :
Description14 : Defines14 UART14 Interface14
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

  
interface uart_if14(input clock14, reset);

  logic txd14;    // Transmit14 Data
  logic rxd14;    // Receive14 Data
  
  logic intrpt14;  // Interrupt14

  logic ri_n14;    // ring14 indicator14
  logic cts_n14;   // clear to send
  logic dsr_n14;   // data set ready
  logic rts_n14;   // request to send
  logic dtr_n14;   // data terminal14 ready
  logic dcd_n14;   // data carrier14 detect14

  logic baud_clk14;  // Baud14 Rate14 Clock14
  
  // Control14 flags14
  bit                has_checks14 = 1;
  bit                has_coverage = 1;

/*  FIX14 TO USE14 CONCURRENT14 ASSERTIONS14
  always @(posedge clock14)
  begin
    // rxd14 must not be X or Z14
    assertRxdUnknown14:assert property (
                       disable iff(!has_checks14 || !reset)(!$isunknown(rxd14)))
                       else
                         $error("ERR_UART001_Rxd_XZ14\n Rxd14 went14 to X or Z14");
  end
*/

endinterface : uart_if14
