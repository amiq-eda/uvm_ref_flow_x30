/******************************************************************************
  FILE : apb_master_if20.sv
 ******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

interface apb_master_if20 (input pclock20,
                         input preset20);

  parameter         PADDR_WIDTH20  = 32;
  parameter         PWDATA_WIDTH20 = 32;
  parameter         PRDATA_WIDTH20 = 32;

  // Actual20 Signals20
  logic [PADDR_WIDTH20-1:0]  paddr20;
  logic                    prwd20;
  logic [PWDATA_WIDTH20-1:0] pwdata20;
  logic                    penable20;
  logic                    pready20;
  logic [15:0]             psel20;
  logic [PRDATA_WIDTH20-1:0] prdata20;
  wire logic               pslverr20;

  // UART20 Interrupt20 signal20
  logic       ua_int20;

  logic [31:0] gp_int20;

  // Control20 flags20
  bit                has_checks20 = 1;
  bit                has_coverage = 1;

// Coverage20 and assertions20 to be implemented here20.

/* NEEDS20 TO BE20 UPDATED20 TO CONCURRENT20 ASSERTIONS20
always @(posedge pclock20)
begin

// PADDR20 must not be X or Z20 when PSEL20 is asserted20
assertPAddrUnknown20:assert property (
                  disable iff(!has_checks20 || !preset20)
                  (psel20 == 0 or !$isunknown(paddr20)))
                  else
                    $error("ERR_APB001_PADDR_XZ20\n PADDR20 went20 to X or Z20 \
                            when PSEL20 is asserted20");

// PRWD20 must not be X or Z20 when PSEL20 is asserted20
assertPRwdUnknown20:assert property ( 
                  disable iff(!has_checks20 || !preset20)
                  (psel20 == 0 or !$isunknown(prwd20)))
                  else
                    $error("ERR_APB002_PRWD_XZ20\n PRWD20 went20 to X or Z20 \
                            when PSEL20 is asserted20");

// PWDATA20 must not be X or Z20 during a data transfer20
assertPWdataUnknown20:assert property ( 
                   disable iff(!has_checks20 || !preset20)
                   (psel20 == 0 or prwd20 == 0 or !$isunknown(pwdata20)))
                   else
                     $error("ERR_APB003_PWDATA_XZ20\n PWDATA20 went20 to X or Z20 \
                             during a write transfer20");

// PENABLE20 must not be X or Z20
assertPEnableUnknown20:assert property ( 
                  disable iff(!has_checks20 || !preset20)
                  (!$isunknown(penable20)))
                  else
                    $error("ERR_APB004_PENABLE_XZ20\n PENABLE20 went20 to X or Z20");

// PSEL20 must not be X or Z20
assertPSelUnknown20:assert property ( 
                  disable iff(!has_checks20 || !preset20)
                  (!$isunknown(psel20)))
                  else
                    $error("ERR_APB005_PSEL_XZ20\n PSEL20 went20 to X or Z20");

end // always @ (posedge pclock20)
*/
      
endinterface : apb_master_if20
