/******************************************************************************
  FILE : apb_master_if22.sv
 ******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

interface apb_master_if22 (input pclock22,
                         input preset22);

  parameter         PADDR_WIDTH22  = 32;
  parameter         PWDATA_WIDTH22 = 32;
  parameter         PRDATA_WIDTH22 = 32;

  // Actual22 Signals22
  logic [PADDR_WIDTH22-1:0]  paddr22;
  logic                    prwd22;
  logic [PWDATA_WIDTH22-1:0] pwdata22;
  logic                    penable22;
  logic                    pready22;
  logic [15:0]             psel22;
  logic [PRDATA_WIDTH22-1:0] prdata22;
  wire logic               pslverr22;

  // UART22 Interrupt22 signal22
  logic       ua_int22;

  logic [31:0] gp_int22;

  // Control22 flags22
  bit                has_checks22 = 1;
  bit                has_coverage = 1;

// Coverage22 and assertions22 to be implemented here22.

/* NEEDS22 TO BE22 UPDATED22 TO CONCURRENT22 ASSERTIONS22
always @(posedge pclock22)
begin

// PADDR22 must not be X or Z22 when PSEL22 is asserted22
assertPAddrUnknown22:assert property (
                  disable iff(!has_checks22 || !preset22)
                  (psel22 == 0 or !$isunknown(paddr22)))
                  else
                    $error("ERR_APB001_PADDR_XZ22\n PADDR22 went22 to X or Z22 \
                            when PSEL22 is asserted22");

// PRWD22 must not be X or Z22 when PSEL22 is asserted22
assertPRwdUnknown22:assert property ( 
                  disable iff(!has_checks22 || !preset22)
                  (psel22 == 0 or !$isunknown(prwd22)))
                  else
                    $error("ERR_APB002_PRWD_XZ22\n PRWD22 went22 to X or Z22 \
                            when PSEL22 is asserted22");

// PWDATA22 must not be X or Z22 during a data transfer22
assertPWdataUnknown22:assert property ( 
                   disable iff(!has_checks22 || !preset22)
                   (psel22 == 0 or prwd22 == 0 or !$isunknown(pwdata22)))
                   else
                     $error("ERR_APB003_PWDATA_XZ22\n PWDATA22 went22 to X or Z22 \
                             during a write transfer22");

// PENABLE22 must not be X or Z22
assertPEnableUnknown22:assert property ( 
                  disable iff(!has_checks22 || !preset22)
                  (!$isunknown(penable22)))
                  else
                    $error("ERR_APB004_PENABLE_XZ22\n PENABLE22 went22 to X or Z22");

// PSEL22 must not be X or Z22
assertPSelUnknown22:assert property ( 
                  disable iff(!has_checks22 || !preset22)
                  (!$isunknown(psel22)))
                  else
                    $error("ERR_APB005_PSEL_XZ22\n PSEL22 went22 to X or Z22");

end // always @ (posedge pclock22)
*/
      
endinterface : apb_master_if22
