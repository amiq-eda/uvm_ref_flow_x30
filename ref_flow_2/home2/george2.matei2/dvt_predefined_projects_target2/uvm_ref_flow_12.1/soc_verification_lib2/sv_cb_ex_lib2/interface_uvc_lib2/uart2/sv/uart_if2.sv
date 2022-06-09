/*-------------------------------------------------------------------------
File2 name   : uart_if2.sv
Title2       : Interface2 file for uart2 uvc2
Project2     :
Created2     :
Description2 : Defines2 UART2 Interface2
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

  
interface uart_if2(input clock2, reset);

  logic txd2;    // Transmit2 Data
  logic rxd2;    // Receive2 Data
  
  logic intrpt2;  // Interrupt2

  logic ri_n2;    // ring2 indicator2
  logic cts_n2;   // clear to send
  logic dsr_n2;   // data set ready
  logic rts_n2;   // request to send
  logic dtr_n2;   // data terminal2 ready
  logic dcd_n2;   // data carrier2 detect2

  logic baud_clk2;  // Baud2 Rate2 Clock2
  
  // Control2 flags2
  bit                has_checks2 = 1;
  bit                has_coverage = 1;

/*  FIX2 TO USE2 CONCURRENT2 ASSERTIONS2
  always @(posedge clock2)
  begin
    // rxd2 must not be X or Z2
    assertRxdUnknown2:assert property (
                       disable iff(!has_checks2 || !reset)(!$isunknown(rxd2)))
                       else
                         $error("ERR_UART001_Rxd_XZ2\n Rxd2 went2 to X or Z2");
  end
*/

endinterface : uart_if2
