/******************************************************************************
  FILE : apb_master_if14.sv
 ******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

interface apb_master_if14 (input pclock14,
                         input preset14);

  parameter         PADDR_WIDTH14  = 32;
  parameter         PWDATA_WIDTH14 = 32;
  parameter         PRDATA_WIDTH14 = 32;

  // Actual14 Signals14
  logic [PADDR_WIDTH14-1:0]  paddr14;
  logic                    prwd14;
  logic [PWDATA_WIDTH14-1:0] pwdata14;
  logic                    penable14;
  logic                    pready14;
  logic [15:0]             psel14;
  logic [PRDATA_WIDTH14-1:0] prdata14;
  wire logic               pslverr14;

  // UART14 Interrupt14 signal14
  logic       ua_int14;

  logic [31:0] gp_int14;

  // Control14 flags14
  bit                has_checks14 = 1;
  bit                has_coverage = 1;

// Coverage14 and assertions14 to be implemented here14.

/* NEEDS14 TO BE14 UPDATED14 TO CONCURRENT14 ASSERTIONS14
always @(posedge pclock14)
begin

// PADDR14 must not be X or Z14 when PSEL14 is asserted14
assertPAddrUnknown14:assert property (
                  disable iff(!has_checks14 || !preset14)
                  (psel14 == 0 or !$isunknown(paddr14)))
                  else
                    $error("ERR_APB001_PADDR_XZ14\n PADDR14 went14 to X or Z14 \
                            when PSEL14 is asserted14");

// PRWD14 must not be X or Z14 when PSEL14 is asserted14
assertPRwdUnknown14:assert property ( 
                  disable iff(!has_checks14 || !preset14)
                  (psel14 == 0 or !$isunknown(prwd14)))
                  else
                    $error("ERR_APB002_PRWD_XZ14\n PRWD14 went14 to X or Z14 \
                            when PSEL14 is asserted14");

// PWDATA14 must not be X or Z14 during a data transfer14
assertPWdataUnknown14:assert property ( 
                   disable iff(!has_checks14 || !preset14)
                   (psel14 == 0 or prwd14 == 0 or !$isunknown(pwdata14)))
                   else
                     $error("ERR_APB003_PWDATA_XZ14\n PWDATA14 went14 to X or Z14 \
                             during a write transfer14");

// PENABLE14 must not be X or Z14
assertPEnableUnknown14:assert property ( 
                  disable iff(!has_checks14 || !preset14)
                  (!$isunknown(penable14)))
                  else
                    $error("ERR_APB004_PENABLE_XZ14\n PENABLE14 went14 to X or Z14");

// PSEL14 must not be X or Z14
assertPSelUnknown14:assert property ( 
                  disable iff(!has_checks14 || !preset14)
                  (!$isunknown(psel14)))
                  else
                    $error("ERR_APB005_PSEL_XZ14\n PSEL14 went14 to X or Z14");

end // always @ (posedge pclock14)
*/
      
endinterface : apb_master_if14
