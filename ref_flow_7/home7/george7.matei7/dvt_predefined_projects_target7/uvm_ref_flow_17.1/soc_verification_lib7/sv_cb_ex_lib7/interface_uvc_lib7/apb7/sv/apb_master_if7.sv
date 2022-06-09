/******************************************************************************
  FILE : apb_master_if7.sv
 ******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

interface apb_master_if7 (input pclock7,
                         input preset7);

  parameter         PADDR_WIDTH7  = 32;
  parameter         PWDATA_WIDTH7 = 32;
  parameter         PRDATA_WIDTH7 = 32;

  // Actual7 Signals7
  logic [PADDR_WIDTH7-1:0]  paddr7;
  logic                    prwd7;
  logic [PWDATA_WIDTH7-1:0] pwdata7;
  logic                    penable7;
  logic                    pready7;
  logic [15:0]             psel7;
  logic [PRDATA_WIDTH7-1:0] prdata7;
  wire logic               pslverr7;

  // UART7 Interrupt7 signal7
  logic       ua_int7;

  logic [31:0] gp_int7;

  // Control7 flags7
  bit                has_checks7 = 1;
  bit                has_coverage = 1;

// Coverage7 and assertions7 to be implemented here7.

/* NEEDS7 TO BE7 UPDATED7 TO CONCURRENT7 ASSERTIONS7
always @(posedge pclock7)
begin

// PADDR7 must not be X or Z7 when PSEL7 is asserted7
assertPAddrUnknown7:assert property (
                  disable iff(!has_checks7 || !preset7)
                  (psel7 == 0 or !$isunknown(paddr7)))
                  else
                    $error("ERR_APB001_PADDR_XZ7\n PADDR7 went7 to X or Z7 \
                            when PSEL7 is asserted7");

// PRWD7 must not be X or Z7 when PSEL7 is asserted7
assertPRwdUnknown7:assert property ( 
                  disable iff(!has_checks7 || !preset7)
                  (psel7 == 0 or !$isunknown(prwd7)))
                  else
                    $error("ERR_APB002_PRWD_XZ7\n PRWD7 went7 to X or Z7 \
                            when PSEL7 is asserted7");

// PWDATA7 must not be X or Z7 during a data transfer7
assertPWdataUnknown7:assert property ( 
                   disable iff(!has_checks7 || !preset7)
                   (psel7 == 0 or prwd7 == 0 or !$isunknown(pwdata7)))
                   else
                     $error("ERR_APB003_PWDATA_XZ7\n PWDATA7 went7 to X or Z7 \
                             during a write transfer7");

// PENABLE7 must not be X or Z7
assertPEnableUnknown7:assert property ( 
                  disable iff(!has_checks7 || !preset7)
                  (!$isunknown(penable7)))
                  else
                    $error("ERR_APB004_PENABLE_XZ7\n PENABLE7 went7 to X or Z7");

// PSEL7 must not be X or Z7
assertPSelUnknown7:assert property ( 
                  disable iff(!has_checks7 || !preset7)
                  (!$isunknown(psel7)))
                  else
                    $error("ERR_APB005_PSEL_XZ7\n PSEL7 went7 to X or Z7");

end // always @ (posedge pclock7)
*/
      
endinterface : apb_master_if7
