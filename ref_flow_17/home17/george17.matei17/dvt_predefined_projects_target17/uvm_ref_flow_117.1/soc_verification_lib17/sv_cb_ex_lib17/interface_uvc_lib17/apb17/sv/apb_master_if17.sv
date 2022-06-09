/******************************************************************************
  FILE : apb_master_if17.sv
 ******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

interface apb_master_if17 (input pclock17,
                         input preset17);

  parameter         PADDR_WIDTH17  = 32;
  parameter         PWDATA_WIDTH17 = 32;
  parameter         PRDATA_WIDTH17 = 32;

  // Actual17 Signals17
  logic [PADDR_WIDTH17-1:0]  paddr17;
  logic                    prwd17;
  logic [PWDATA_WIDTH17-1:0] pwdata17;
  logic                    penable17;
  logic                    pready17;
  logic [15:0]             psel17;
  logic [PRDATA_WIDTH17-1:0] prdata17;
  wire logic               pslverr17;

  // UART17 Interrupt17 signal17
  logic       ua_int17;

  logic [31:0] gp_int17;

  // Control17 flags17
  bit                has_checks17 = 1;
  bit                has_coverage = 1;

// Coverage17 and assertions17 to be implemented here17.

/* NEEDS17 TO BE17 UPDATED17 TO CONCURRENT17 ASSERTIONS17
always @(posedge pclock17)
begin

// PADDR17 must not be X or Z17 when PSEL17 is asserted17
assertPAddrUnknown17:assert property (
                  disable iff(!has_checks17 || !preset17)
                  (psel17 == 0 or !$isunknown(paddr17)))
                  else
                    $error("ERR_APB001_PADDR_XZ17\n PADDR17 went17 to X or Z17 \
                            when PSEL17 is asserted17");

// PRWD17 must not be X or Z17 when PSEL17 is asserted17
assertPRwdUnknown17:assert property ( 
                  disable iff(!has_checks17 || !preset17)
                  (psel17 == 0 or !$isunknown(prwd17)))
                  else
                    $error("ERR_APB002_PRWD_XZ17\n PRWD17 went17 to X or Z17 \
                            when PSEL17 is asserted17");

// PWDATA17 must not be X or Z17 during a data transfer17
assertPWdataUnknown17:assert property ( 
                   disable iff(!has_checks17 || !preset17)
                   (psel17 == 0 or prwd17 == 0 or !$isunknown(pwdata17)))
                   else
                     $error("ERR_APB003_PWDATA_XZ17\n PWDATA17 went17 to X or Z17 \
                             during a write transfer17");

// PENABLE17 must not be X or Z17
assertPEnableUnknown17:assert property ( 
                  disable iff(!has_checks17 || !preset17)
                  (!$isunknown(penable17)))
                  else
                    $error("ERR_APB004_PENABLE_XZ17\n PENABLE17 went17 to X or Z17");

// PSEL17 must not be X or Z17
assertPSelUnknown17:assert property ( 
                  disable iff(!has_checks17 || !preset17)
                  (!$isunknown(psel17)))
                  else
                    $error("ERR_APB005_PSEL_XZ17\n PSEL17 went17 to X or Z17");

end // always @ (posedge pclock17)
*/
      
endinterface : apb_master_if17
