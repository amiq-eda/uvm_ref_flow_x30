/******************************************************************************

  FILE : apb_slave_if4.sv

 ******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


interface apb_slave_if4(input pclock4, preset4);
  // Actual4 Signals4
   parameter         PADDR_WIDTH4  = 32;
   parameter         PWDATA_WIDTH4 = 32;
   parameter         PRDATA_WIDTH4 = 32;

  // Control4 flags4
  bit                has_checks4 = 1;
  bit                has_coverage = 1;

  // Actual4 Signals4
  //wire logic              pclock4;
  //wire logic              preset4;
  wire logic       [PADDR_WIDTH4-1:0] paddr4;
  wire logic              prwd4;
  wire logic       [PWDATA_WIDTH4-1:0] pwdata4;
  wire logic              psel4;
  wire logic              penable4;

  logic        [PRDATA_WIDTH4-1:0] prdata4;
  logic              pslverr4;
  logic              pready4;

  // Coverage4 and assertions4 to be implegmented4 here4.

/*  fix4 to make concurrent4 assertions4
always @(posedge pclock4)
begin

// Pready4 must not be X or Z4
assertPreadyUnknown4:assert property (
                  disable iff(!has_checks4) 
                  (!($isunknown(pready4))))
                  else
                    $error("ERR_APB100_PREADY_XZ4\n Pready4 went4 to X or Z4");


// Pslverr4 must not be X or Z4
assertPslverrUnknown4:assert property (
                  disable iff(!has_checks4) 
                  ((psel4 == 1'b0 or pready4 == 1'b0 or !($isunknown(pslverr4)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ4\n Pslverr4 went4 to X or Z4 when responding4");


// Prdata4 must not be X or Z4
assertPrdataUnknown4:assert property (
                  disable iff(!has_checks4) 
                  ((psel4 == 1'b0 or pready4 == 0 or prwd4 == 0 or !($isunknown(prdata4)))))
                  else
                  $error("ERR_APB102_XZ4\n Prdata4 went4 to X or Z4 when responding4 to a read transfer4");



end

   // EACH4 SLAVE4 HAS4 ITS4 OWN4 PSEL4 LINES4 FOR4 WHICH4 THE4 APB4 ABV4 VIP4 Checker4 can be run on.
`include "apb_checker4.sv"
*/

endinterface : apb_slave_if4

