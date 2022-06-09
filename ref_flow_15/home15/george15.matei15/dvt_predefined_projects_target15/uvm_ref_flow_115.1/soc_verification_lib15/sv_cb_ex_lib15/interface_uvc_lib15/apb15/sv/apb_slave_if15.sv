/******************************************************************************

  FILE : apb_slave_if15.sv

 ******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


interface apb_slave_if15(input pclock15, preset15);
  // Actual15 Signals15
   parameter         PADDR_WIDTH15  = 32;
   parameter         PWDATA_WIDTH15 = 32;
   parameter         PRDATA_WIDTH15 = 32;

  // Control15 flags15
  bit                has_checks15 = 1;
  bit                has_coverage = 1;

  // Actual15 Signals15
  //wire logic              pclock15;
  //wire logic              preset15;
  wire logic       [PADDR_WIDTH15-1:0] paddr15;
  wire logic              prwd15;
  wire logic       [PWDATA_WIDTH15-1:0] pwdata15;
  wire logic              psel15;
  wire logic              penable15;

  logic        [PRDATA_WIDTH15-1:0] prdata15;
  logic              pslverr15;
  logic              pready15;

  // Coverage15 and assertions15 to be implegmented15 here15.

/*  fix15 to make concurrent15 assertions15
always @(posedge pclock15)
begin

// Pready15 must not be X or Z15
assertPreadyUnknown15:assert property (
                  disable iff(!has_checks15) 
                  (!($isunknown(pready15))))
                  else
                    $error("ERR_APB100_PREADY_XZ15\n Pready15 went15 to X or Z15");


// Pslverr15 must not be X or Z15
assertPslverrUnknown15:assert property (
                  disable iff(!has_checks15) 
                  ((psel15 == 1'b0 or pready15 == 1'b0 or !($isunknown(pslverr15)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ15\n Pslverr15 went15 to X or Z15 when responding15");


// Prdata15 must not be X or Z15
assertPrdataUnknown15:assert property (
                  disable iff(!has_checks15) 
                  ((psel15 == 1'b0 or pready15 == 0 or prwd15 == 0 or !($isunknown(prdata15)))))
                  else
                  $error("ERR_APB102_XZ15\n Prdata15 went15 to X or Z15 when responding15 to a read transfer15");



end

   // EACH15 SLAVE15 HAS15 ITS15 OWN15 PSEL15 LINES15 FOR15 WHICH15 THE15 APB15 ABV15 VIP15 Checker15 can be run on.
`include "apb_checker15.sv"
*/

endinterface : apb_slave_if15

