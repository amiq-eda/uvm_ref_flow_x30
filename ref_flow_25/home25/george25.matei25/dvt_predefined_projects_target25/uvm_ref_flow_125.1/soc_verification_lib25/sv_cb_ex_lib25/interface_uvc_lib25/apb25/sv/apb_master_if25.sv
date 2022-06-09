/******************************************************************************
  FILE : apb_master_if25.sv
 ******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

interface apb_master_if25 (input pclock25,
                         input preset25);

  parameter         PADDR_WIDTH25  = 32;
  parameter         PWDATA_WIDTH25 = 32;
  parameter         PRDATA_WIDTH25 = 32;

  // Actual25 Signals25
  logic [PADDR_WIDTH25-1:0]  paddr25;
  logic                    prwd25;
  logic [PWDATA_WIDTH25-1:0] pwdata25;
  logic                    penable25;
  logic                    pready25;
  logic [15:0]             psel25;
  logic [PRDATA_WIDTH25-1:0] prdata25;
  wire logic               pslverr25;

  // UART25 Interrupt25 signal25
  logic       ua_int25;

  logic [31:0] gp_int25;

  // Control25 flags25
  bit                has_checks25 = 1;
  bit                has_coverage = 1;

// Coverage25 and assertions25 to be implemented here25.

/* NEEDS25 TO BE25 UPDATED25 TO CONCURRENT25 ASSERTIONS25
always @(posedge pclock25)
begin

// PADDR25 must not be X or Z25 when PSEL25 is asserted25
assertPAddrUnknown25:assert property (
                  disable iff(!has_checks25 || !preset25)
                  (psel25 == 0 or !$isunknown(paddr25)))
                  else
                    $error("ERR_APB001_PADDR_XZ25\n PADDR25 went25 to X or Z25 \
                            when PSEL25 is asserted25");

// PRWD25 must not be X or Z25 when PSEL25 is asserted25
assertPRwdUnknown25:assert property ( 
                  disable iff(!has_checks25 || !preset25)
                  (psel25 == 0 or !$isunknown(prwd25)))
                  else
                    $error("ERR_APB002_PRWD_XZ25\n PRWD25 went25 to X or Z25 \
                            when PSEL25 is asserted25");

// PWDATA25 must not be X or Z25 during a data transfer25
assertPWdataUnknown25:assert property ( 
                   disable iff(!has_checks25 || !preset25)
                   (psel25 == 0 or prwd25 == 0 or !$isunknown(pwdata25)))
                   else
                     $error("ERR_APB003_PWDATA_XZ25\n PWDATA25 went25 to X or Z25 \
                             during a write transfer25");

// PENABLE25 must not be X or Z25
assertPEnableUnknown25:assert property ( 
                  disable iff(!has_checks25 || !preset25)
                  (!$isunknown(penable25)))
                  else
                    $error("ERR_APB004_PENABLE_XZ25\n PENABLE25 went25 to X or Z25");

// PSEL25 must not be X or Z25
assertPSelUnknown25:assert property ( 
                  disable iff(!has_checks25 || !preset25)
                  (!$isunknown(psel25)))
                  else
                    $error("ERR_APB005_PSEL_XZ25\n PSEL25 went25 to X or Z25");

end // always @ (posedge pclock25)
*/
      
endinterface : apb_master_if25
