/******************************************************************************
  FILE : apb_master_if29.sv
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

interface apb_master_if29 (input pclock29,
                         input preset29);

  parameter         PADDR_WIDTH29  = 32;
  parameter         PWDATA_WIDTH29 = 32;
  parameter         PRDATA_WIDTH29 = 32;

  // Actual29 Signals29
  logic [PADDR_WIDTH29-1:0]  paddr29;
  logic                    prwd29;
  logic [PWDATA_WIDTH29-1:0] pwdata29;
  logic                    penable29;
  logic                    pready29;
  logic [15:0]             psel29;
  logic [PRDATA_WIDTH29-1:0] prdata29;
  wire logic               pslverr29;

  // UART29 Interrupt29 signal29
  logic       ua_int29;

  logic [31:0] gp_int29;

  // Control29 flags29
  bit                has_checks29 = 1;
  bit                has_coverage = 1;

// Coverage29 and assertions29 to be implemented here29.

/* NEEDS29 TO BE29 UPDATED29 TO CONCURRENT29 ASSERTIONS29
always @(posedge pclock29)
begin

// PADDR29 must not be X or Z29 when PSEL29 is asserted29
assertPAddrUnknown29:assert property (
                  disable iff(!has_checks29 || !preset29)
                  (psel29 == 0 or !$isunknown(paddr29)))
                  else
                    $error("ERR_APB001_PADDR_XZ29\n PADDR29 went29 to X or Z29 \
                            when PSEL29 is asserted29");

// PRWD29 must not be X or Z29 when PSEL29 is asserted29
assertPRwdUnknown29:assert property ( 
                  disable iff(!has_checks29 || !preset29)
                  (psel29 == 0 or !$isunknown(prwd29)))
                  else
                    $error("ERR_APB002_PRWD_XZ29\n PRWD29 went29 to X or Z29 \
                            when PSEL29 is asserted29");

// PWDATA29 must not be X or Z29 during a data transfer29
assertPWdataUnknown29:assert property ( 
                   disable iff(!has_checks29 || !preset29)
                   (psel29 == 0 or prwd29 == 0 or !$isunknown(pwdata29)))
                   else
                     $error("ERR_APB003_PWDATA_XZ29\n PWDATA29 went29 to X or Z29 \
                             during a write transfer29");

// PENABLE29 must not be X or Z29
assertPEnableUnknown29:assert property ( 
                  disable iff(!has_checks29 || !preset29)
                  (!$isunknown(penable29)))
                  else
                    $error("ERR_APB004_PENABLE_XZ29\n PENABLE29 went29 to X or Z29");

// PSEL29 must not be X or Z29
assertPSelUnknown29:assert property ( 
                  disable iff(!has_checks29 || !preset29)
                  (!$isunknown(psel29)))
                  else
                    $error("ERR_APB005_PSEL_XZ29\n PSEL29 went29 to X or Z29");

end // always @ (posedge pclock29)
*/
      
endinterface : apb_master_if29
