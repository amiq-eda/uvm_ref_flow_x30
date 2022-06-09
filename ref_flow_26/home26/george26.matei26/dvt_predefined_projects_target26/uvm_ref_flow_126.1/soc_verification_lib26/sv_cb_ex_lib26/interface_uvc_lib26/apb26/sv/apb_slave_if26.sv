/******************************************************************************

  FILE : apb_slave_if26.sv

 ******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


interface apb_slave_if26(input pclock26, preset26);
  // Actual26 Signals26
   parameter         PADDR_WIDTH26  = 32;
   parameter         PWDATA_WIDTH26 = 32;
   parameter         PRDATA_WIDTH26 = 32;

  // Control26 flags26
  bit                has_checks26 = 1;
  bit                has_coverage = 1;

  // Actual26 Signals26
  //wire logic              pclock26;
  //wire logic              preset26;
  wire logic       [PADDR_WIDTH26-1:0] paddr26;
  wire logic              prwd26;
  wire logic       [PWDATA_WIDTH26-1:0] pwdata26;
  wire logic              psel26;
  wire logic              penable26;

  logic        [PRDATA_WIDTH26-1:0] prdata26;
  logic              pslverr26;
  logic              pready26;

  // Coverage26 and assertions26 to be implegmented26 here26.

/*  fix26 to make concurrent26 assertions26
always @(posedge pclock26)
begin

// Pready26 must not be X or Z26
assertPreadyUnknown26:assert property (
                  disable iff(!has_checks26) 
                  (!($isunknown(pready26))))
                  else
                    $error("ERR_APB100_PREADY_XZ26\n Pready26 went26 to X or Z26");


// Pslverr26 must not be X or Z26
assertPslverrUnknown26:assert property (
                  disable iff(!has_checks26) 
                  ((psel26 == 1'b0 or pready26 == 1'b0 or !($isunknown(pslverr26)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ26\n Pslverr26 went26 to X or Z26 when responding26");


// Prdata26 must not be X or Z26
assertPrdataUnknown26:assert property (
                  disable iff(!has_checks26) 
                  ((psel26 == 1'b0 or pready26 == 0 or prwd26 == 0 or !($isunknown(prdata26)))))
                  else
                  $error("ERR_APB102_XZ26\n Prdata26 went26 to X or Z26 when responding26 to a read transfer26");



end

   // EACH26 SLAVE26 HAS26 ITS26 OWN26 PSEL26 LINES26 FOR26 WHICH26 THE26 APB26 ABV26 VIP26 Checker26 can be run on.
`include "apb_checker26.sv"
*/

endinterface : apb_slave_if26

