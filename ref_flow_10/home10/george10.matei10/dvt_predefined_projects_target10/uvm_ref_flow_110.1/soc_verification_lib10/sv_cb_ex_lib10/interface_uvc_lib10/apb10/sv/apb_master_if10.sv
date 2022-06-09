/******************************************************************************
  FILE : apb_master_if10.sv
 ******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

interface apb_master_if10 (input pclock10,
                         input preset10);

  parameter         PADDR_WIDTH10  = 32;
  parameter         PWDATA_WIDTH10 = 32;
  parameter         PRDATA_WIDTH10 = 32;

  // Actual10 Signals10
  logic [PADDR_WIDTH10-1:0]  paddr10;
  logic                    prwd10;
  logic [PWDATA_WIDTH10-1:0] pwdata10;
  logic                    penable10;
  logic                    pready10;
  logic [15:0]             psel10;
  logic [PRDATA_WIDTH10-1:0] prdata10;
  wire logic               pslverr10;

  // UART10 Interrupt10 signal10
  logic       ua_int10;

  logic [31:0] gp_int10;

  // Control10 flags10
  bit                has_checks10 = 1;
  bit                has_coverage = 1;

// Coverage10 and assertions10 to be implemented here10.

/* NEEDS10 TO BE10 UPDATED10 TO CONCURRENT10 ASSERTIONS10
always @(posedge pclock10)
begin

// PADDR10 must not be X or Z10 when PSEL10 is asserted10
assertPAddrUnknown10:assert property (
                  disable iff(!has_checks10 || !preset10)
                  (psel10 == 0 or !$isunknown(paddr10)))
                  else
                    $error("ERR_APB001_PADDR_XZ10\n PADDR10 went10 to X or Z10 \
                            when PSEL10 is asserted10");

// PRWD10 must not be X or Z10 when PSEL10 is asserted10
assertPRwdUnknown10:assert property ( 
                  disable iff(!has_checks10 || !preset10)
                  (psel10 == 0 or !$isunknown(prwd10)))
                  else
                    $error("ERR_APB002_PRWD_XZ10\n PRWD10 went10 to X or Z10 \
                            when PSEL10 is asserted10");

// PWDATA10 must not be X or Z10 during a data transfer10
assertPWdataUnknown10:assert property ( 
                   disable iff(!has_checks10 || !preset10)
                   (psel10 == 0 or prwd10 == 0 or !$isunknown(pwdata10)))
                   else
                     $error("ERR_APB003_PWDATA_XZ10\n PWDATA10 went10 to X or Z10 \
                             during a write transfer10");

// PENABLE10 must not be X or Z10
assertPEnableUnknown10:assert property ( 
                  disable iff(!has_checks10 || !preset10)
                  (!$isunknown(penable10)))
                  else
                    $error("ERR_APB004_PENABLE_XZ10\n PENABLE10 went10 to X or Z10");

// PSEL10 must not be X or Z10
assertPSelUnknown10:assert property ( 
                  disable iff(!has_checks10 || !preset10)
                  (!$isunknown(psel10)))
                  else
                    $error("ERR_APB005_PSEL_XZ10\n PSEL10 went10 to X or Z10");

end // always @ (posedge pclock10)
*/
      
endinterface : apb_master_if10
