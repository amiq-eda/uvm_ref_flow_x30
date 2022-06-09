/******************************************************************************

  FILE : apb_slave_if29.sv

 ******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


interface apb_slave_if29(input pclock29, preset29);
  // Actual29 Signals29
   parameter         PADDR_WIDTH29  = 32;
   parameter         PWDATA_WIDTH29 = 32;
   parameter         PRDATA_WIDTH29 = 32;

  // Control29 flags29
  bit                has_checks29 = 1;
  bit                has_coverage = 1;

  // Actual29 Signals29
  //wire logic              pclock29;
  //wire logic              preset29;
  wire logic       [PADDR_WIDTH29-1:0] paddr29;
  wire logic              prwd29;
  wire logic       [PWDATA_WIDTH29-1:0] pwdata29;
  wire logic              psel29;
  wire logic              penable29;

  logic        [PRDATA_WIDTH29-1:0] prdata29;
  logic              pslverr29;
  logic              pready29;

  // Coverage29 and assertions29 to be implegmented29 here29.

/*  fix29 to make concurrent29 assertions29
always @(posedge pclock29)
begin

// Pready29 must not be X or Z29
assertPreadyUnknown29:assert property (
                  disable iff(!has_checks29) 
                  (!($isunknown(pready29))))
                  else
                    $error("ERR_APB100_PREADY_XZ29\n Pready29 went29 to X or Z29");


// Pslverr29 must not be X or Z29
assertPslverrUnknown29:assert property (
                  disable iff(!has_checks29) 
                  ((psel29 == 1'b0 or pready29 == 1'b0 or !($isunknown(pslverr29)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ29\n Pslverr29 went29 to X or Z29 when responding29");


// Prdata29 must not be X or Z29
assertPrdataUnknown29:assert property (
                  disable iff(!has_checks29) 
                  ((psel29 == 1'b0 or pready29 == 0 or prwd29 == 0 or !($isunknown(prdata29)))))
                  else
                  $error("ERR_APB102_XZ29\n Prdata29 went29 to X or Z29 when responding29 to a read transfer29");



end

   // EACH29 SLAVE29 HAS29 ITS29 OWN29 PSEL29 LINES29 FOR29 WHICH29 THE29 APB29 ABV29 VIP29 Checker29 can be run on.
`include "apb_checker29.sv"
*/

endinterface : apb_slave_if29

