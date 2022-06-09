/******************************************************************************

  FILE : apb_slave_if10.sv

 ******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


interface apb_slave_if10(input pclock10, preset10);
  // Actual10 Signals10
   parameter         PADDR_WIDTH10  = 32;
   parameter         PWDATA_WIDTH10 = 32;
   parameter         PRDATA_WIDTH10 = 32;

  // Control10 flags10
  bit                has_checks10 = 1;
  bit                has_coverage = 1;

  // Actual10 Signals10
  //wire logic              pclock10;
  //wire logic              preset10;
  wire logic       [PADDR_WIDTH10-1:0] paddr10;
  wire logic              prwd10;
  wire logic       [PWDATA_WIDTH10-1:0] pwdata10;
  wire logic              psel10;
  wire logic              penable10;

  logic        [PRDATA_WIDTH10-1:0] prdata10;
  logic              pslverr10;
  logic              pready10;

  // Coverage10 and assertions10 to be implegmented10 here10.

/*  fix10 to make concurrent10 assertions10
always @(posedge pclock10)
begin

// Pready10 must not be X or Z10
assertPreadyUnknown10:assert property (
                  disable iff(!has_checks10) 
                  (!($isunknown(pready10))))
                  else
                    $error("ERR_APB100_PREADY_XZ10\n Pready10 went10 to X or Z10");


// Pslverr10 must not be X or Z10
assertPslverrUnknown10:assert property (
                  disable iff(!has_checks10) 
                  ((psel10 == 1'b0 or pready10 == 1'b0 or !($isunknown(pslverr10)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ10\n Pslverr10 went10 to X or Z10 when responding10");


// Prdata10 must not be X or Z10
assertPrdataUnknown10:assert property (
                  disable iff(!has_checks10) 
                  ((psel10 == 1'b0 or pready10 == 0 or prwd10 == 0 or !($isunknown(prdata10)))))
                  else
                  $error("ERR_APB102_XZ10\n Prdata10 went10 to X or Z10 when responding10 to a read transfer10");



end

   // EACH10 SLAVE10 HAS10 ITS10 OWN10 PSEL10 LINES10 FOR10 WHICH10 THE10 APB10 ABV10 VIP10 Checker10 can be run on.
`include "apb_checker10.sv"
*/

endinterface : apb_slave_if10

