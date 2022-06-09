/******************************************************************************
  FILE : apb_if24.sv
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


interface apb_if24 (input pclock24, input preset24);

  parameter         PADDR_WIDTH24  = 32;
  parameter         PWDATA_WIDTH24 = 32;
  parameter         PRDATA_WIDTH24 = 32;

  // Actual24 Signals24
  logic [PADDR_WIDTH24-1:0]  paddr24;
  logic                    prwd24;
  logic [PWDATA_WIDTH24-1:0] pwdata24;
  logic                    penable24;
  logic [15:0]             psel24;
  logic [PRDATA_WIDTH24-1:0] prdata24;
  logic               pslverr24;
  logic               pready24;

  // UART24 Interrupt24 signal24
  //logic       ua_int24;

  // Control24 flags24
  bit                has_checks24 = 1;
  bit                has_coverage = 1;

// Coverage24 and assertions24 to be implemented here24.

/*  KAM24: needs24 update to concurrent24 assertions24 syntax24
always @(posedge pclock24)
begin

// PADDR24 must not be X or Z24 when PSEL24 is asserted24
assertPAddrUnknown24:assert property (
                  disable iff(!has_checks24) 
                  (psel24 == 0 or !$isunknown(paddr24)))
                  else
                    $error("ERR_APB001_PADDR_XZ24\n PADDR24 went24 to X or Z24 \
                            when PSEL24 is asserted24");

// PRWD24 must not be X or Z24 when PSEL24 is asserted24
assertPRwdUnknown24:assert property ( 
                  disable iff(!has_checks24) 
                  (psel24 == 0 or !$isunknown(prwd24)))
                  else
                    $error("ERR_APB002_PRWD_XZ24\n PRWD24 went24 to X or Z24 \
                            when PSEL24 is asserted24");

// PWDATA24 must not be X or Z24 during a data transfer24
assertPWdataUnknown24:assert property ( 
                   disable iff(!has_checks24) 
                   (psel24 == 0 or prwd24 == 0 or !$isunknown(pwdata24)))
                   else
                     $error("ERR_APB003_PWDATA_XZ24\n PWDATA24 went24 to X or Z24 \
                             during a write transfer24");

// PENABLE24 must not be X or Z24
assertPEnableUnknown24:assert property ( 
                  disable iff(!has_checks24) 
                  (!$isunknown(penable24)))
                  else
                    $error("ERR_APB004_PENABLE_XZ24\n PENABLE24 went24 to X or Z24");

// PSEL24 must not be X or Z24
assertPSelUnknown24:assert property ( 
                  disable iff(!has_checks24) 
                  (!$isunknown(psel24)))
                  else
                    $error("ERR_APB005_PSEL_XZ24\n PSEL24 went24 to X or Z24");

// Pslverr24 must not be X or Z24
assertPslverrUnknown24:assert property (
                  disable iff(!has_checks24) 
                  ((psel24[0] == 1'b0 or pready24 == 1'b0 or !($isunknown(pslverr24)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ24\n Pslverr24 went24 to X or Z24 when responding24");


// Prdata24 must not be X or Z24
assertPrdataUnknown24:assert property (
                  disable iff(!has_checks24) 
                  ((psel24[0] == 1'b0 or pready24 == 0 or prwd24 == 0 or !($isunknown(prdata24)))))
                  else
                  $error("ERR_APB102_XZ24\n Prdata24 went24 to X or Z24 when responding24 to a read transfer24");

end // always @ (posedge pclock24)
      
*/

endinterface : apb_if24

