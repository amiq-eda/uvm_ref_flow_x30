/******************************************************************************

  FILE : apb_slave_if22.sv

 ******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


interface apb_slave_if22(input pclock22, preset22);
  // Actual22 Signals22
   parameter         PADDR_WIDTH22  = 32;
   parameter         PWDATA_WIDTH22 = 32;
   parameter         PRDATA_WIDTH22 = 32;

  // Control22 flags22
  bit                has_checks22 = 1;
  bit                has_coverage = 1;

  // Actual22 Signals22
  //wire logic              pclock22;
  //wire logic              preset22;
  wire logic       [PADDR_WIDTH22-1:0] paddr22;
  wire logic              prwd22;
  wire logic       [PWDATA_WIDTH22-1:0] pwdata22;
  wire logic              psel22;
  wire logic              penable22;

  logic        [PRDATA_WIDTH22-1:0] prdata22;
  logic              pslverr22;
  logic              pready22;

  // Coverage22 and assertions22 to be implegmented22 here22.

/*  fix22 to make concurrent22 assertions22
always @(posedge pclock22)
begin

// Pready22 must not be X or Z22
assertPreadyUnknown22:assert property (
                  disable iff(!has_checks22) 
                  (!($isunknown(pready22))))
                  else
                    $error("ERR_APB100_PREADY_XZ22\n Pready22 went22 to X or Z22");


// Pslverr22 must not be X or Z22
assertPslverrUnknown22:assert property (
                  disable iff(!has_checks22) 
                  ((psel22 == 1'b0 or pready22 == 1'b0 or !($isunknown(pslverr22)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ22\n Pslverr22 went22 to X or Z22 when responding22");


// Prdata22 must not be X or Z22
assertPrdataUnknown22:assert property (
                  disable iff(!has_checks22) 
                  ((psel22 == 1'b0 or pready22 == 0 or prwd22 == 0 or !($isunknown(prdata22)))))
                  else
                  $error("ERR_APB102_XZ22\n Prdata22 went22 to X or Z22 when responding22 to a read transfer22");



end

   // EACH22 SLAVE22 HAS22 ITS22 OWN22 PSEL22 LINES22 FOR22 WHICH22 THE22 APB22 ABV22 VIP22 Checker22 can be run on.
`include "apb_checker22.sv"
*/

endinterface : apb_slave_if22

