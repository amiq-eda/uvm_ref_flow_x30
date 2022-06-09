/******************************************************************************

  FILE : apb_slave_if24.sv

 ******************************************************************************/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


interface apb_slave_if24(input pclock24, preset24);
  // Actual24 Signals24
   parameter         PADDR_WIDTH24  = 32;
   parameter         PWDATA_WIDTH24 = 32;
   parameter         PRDATA_WIDTH24 = 32;

  // Control24 flags24
  bit                has_checks24 = 1;
  bit                has_coverage = 1;

  // Actual24 Signals24
  //wire logic              pclock24;
  //wire logic              preset24;
  wire logic       [PADDR_WIDTH24-1:0] paddr24;
  wire logic              prwd24;
  wire logic       [PWDATA_WIDTH24-1:0] pwdata24;
  wire logic              psel24;
  wire logic              penable24;

  logic        [PRDATA_WIDTH24-1:0] prdata24;
  logic              pslverr24;
  logic              pready24;

  // Coverage24 and assertions24 to be implegmented24 here24.

/*  fix24 to make concurrent24 assertions24
always @(posedge pclock24)
begin

// Pready24 must not be X or Z24
assertPreadyUnknown24:assert property (
                  disable iff(!has_checks24) 
                  (!($isunknown(pready24))))
                  else
                    $error("ERR_APB100_PREADY_XZ24\n Pready24 went24 to X or Z24");


// Pslverr24 must not be X or Z24
assertPslverrUnknown24:assert property (
                  disable iff(!has_checks24) 
                  ((psel24 == 1'b0 or pready24 == 1'b0 or !($isunknown(pslverr24)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ24\n Pslverr24 went24 to X or Z24 when responding24");


// Prdata24 must not be X or Z24
assertPrdataUnknown24:assert property (
                  disable iff(!has_checks24) 
                  ((psel24 == 1'b0 or pready24 == 0 or prwd24 == 0 or !($isunknown(prdata24)))))
                  else
                  $error("ERR_APB102_XZ24\n Prdata24 went24 to X or Z24 when responding24 to a read transfer24");



end

   // EACH24 SLAVE24 HAS24 ITS24 OWN24 PSEL24 LINES24 FOR24 WHICH24 THE24 APB24 ABV24 VIP24 Checker24 can be run on.
`include "apb_checker24.sv"
*/

endinterface : apb_slave_if24

