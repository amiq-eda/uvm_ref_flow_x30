/******************************************************************************
  FILE : apb_master_if9.sv
 ******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

interface apb_master_if9 (input pclock9,
                         input preset9);

  parameter         PADDR_WIDTH9  = 32;
  parameter         PWDATA_WIDTH9 = 32;
  parameter         PRDATA_WIDTH9 = 32;

  // Actual9 Signals9
  logic [PADDR_WIDTH9-1:0]  paddr9;
  logic                    prwd9;
  logic [PWDATA_WIDTH9-1:0] pwdata9;
  logic                    penable9;
  logic                    pready9;
  logic [15:0]             psel9;
  logic [PRDATA_WIDTH9-1:0] prdata9;
  wire logic               pslverr9;

  // UART9 Interrupt9 signal9
  logic       ua_int9;

  logic [31:0] gp_int9;

  // Control9 flags9
  bit                has_checks9 = 1;
  bit                has_coverage = 1;

// Coverage9 and assertions9 to be implemented here9.

/* NEEDS9 TO BE9 UPDATED9 TO CONCURRENT9 ASSERTIONS9
always @(posedge pclock9)
begin

// PADDR9 must not be X or Z9 when PSEL9 is asserted9
assertPAddrUnknown9:assert property (
                  disable iff(!has_checks9 || !preset9)
                  (psel9 == 0 or !$isunknown(paddr9)))
                  else
                    $error("ERR_APB001_PADDR_XZ9\n PADDR9 went9 to X or Z9 \
                            when PSEL9 is asserted9");

// PRWD9 must not be X or Z9 when PSEL9 is asserted9
assertPRwdUnknown9:assert property ( 
                  disable iff(!has_checks9 || !preset9)
                  (psel9 == 0 or !$isunknown(prwd9)))
                  else
                    $error("ERR_APB002_PRWD_XZ9\n PRWD9 went9 to X or Z9 \
                            when PSEL9 is asserted9");

// PWDATA9 must not be X or Z9 during a data transfer9
assertPWdataUnknown9:assert property ( 
                   disable iff(!has_checks9 || !preset9)
                   (psel9 == 0 or prwd9 == 0 or !$isunknown(pwdata9)))
                   else
                     $error("ERR_APB003_PWDATA_XZ9\n PWDATA9 went9 to X or Z9 \
                             during a write transfer9");

// PENABLE9 must not be X or Z9
assertPEnableUnknown9:assert property ( 
                  disable iff(!has_checks9 || !preset9)
                  (!$isunknown(penable9)))
                  else
                    $error("ERR_APB004_PENABLE_XZ9\n PENABLE9 went9 to X or Z9");

// PSEL9 must not be X or Z9
assertPSelUnknown9:assert property ( 
                  disable iff(!has_checks9 || !preset9)
                  (!$isunknown(psel9)))
                  else
                    $error("ERR_APB005_PSEL_XZ9\n PSEL9 went9 to X or Z9");

end // always @ (posedge pclock9)
*/
      
endinterface : apb_master_if9
