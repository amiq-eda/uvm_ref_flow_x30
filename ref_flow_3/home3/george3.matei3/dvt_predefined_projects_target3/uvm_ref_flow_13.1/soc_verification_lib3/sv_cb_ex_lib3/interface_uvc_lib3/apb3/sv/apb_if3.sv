/******************************************************************************
  FILE : apb_if3.sv
 ******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


interface apb_if3 (input pclock3, input preset3);

  parameter         PADDR_WIDTH3  = 32;
  parameter         PWDATA_WIDTH3 = 32;
  parameter         PRDATA_WIDTH3 = 32;

  // Actual3 Signals3
  logic [PADDR_WIDTH3-1:0]  paddr3;
  logic                    prwd3;
  logic [PWDATA_WIDTH3-1:0] pwdata3;
  logic                    penable3;
  logic [15:0]             psel3;
  logic [PRDATA_WIDTH3-1:0] prdata3;
  logic               pslverr3;
  logic               pready3;

  // UART3 Interrupt3 signal3
  //logic       ua_int3;

  // Control3 flags3
  bit                has_checks3 = 1;
  bit                has_coverage = 1;

// Coverage3 and assertions3 to be implemented here3.

/*  KAM3: needs3 update to concurrent3 assertions3 syntax3
always @(posedge pclock3)
begin

// PADDR3 must not be X or Z3 when PSEL3 is asserted3
assertPAddrUnknown3:assert property (
                  disable iff(!has_checks3) 
                  (psel3 == 0 or !$isunknown(paddr3)))
                  else
                    $error("ERR_APB001_PADDR_XZ3\n PADDR3 went3 to X or Z3 \
                            when PSEL3 is asserted3");

// PRWD3 must not be X or Z3 when PSEL3 is asserted3
assertPRwdUnknown3:assert property ( 
                  disable iff(!has_checks3) 
                  (psel3 == 0 or !$isunknown(prwd3)))
                  else
                    $error("ERR_APB002_PRWD_XZ3\n PRWD3 went3 to X or Z3 \
                            when PSEL3 is asserted3");

// PWDATA3 must not be X or Z3 during a data transfer3
assertPWdataUnknown3:assert property ( 
                   disable iff(!has_checks3) 
                   (psel3 == 0 or prwd3 == 0 or !$isunknown(pwdata3)))
                   else
                     $error("ERR_APB003_PWDATA_XZ3\n PWDATA3 went3 to X or Z3 \
                             during a write transfer3");

// PENABLE3 must not be X or Z3
assertPEnableUnknown3:assert property ( 
                  disable iff(!has_checks3) 
                  (!$isunknown(penable3)))
                  else
                    $error("ERR_APB004_PENABLE_XZ3\n PENABLE3 went3 to X or Z3");

// PSEL3 must not be X or Z3
assertPSelUnknown3:assert property ( 
                  disable iff(!has_checks3) 
                  (!$isunknown(psel3)))
                  else
                    $error("ERR_APB005_PSEL_XZ3\n PSEL3 went3 to X or Z3");

// Pslverr3 must not be X or Z3
assertPslverrUnknown3:assert property (
                  disable iff(!has_checks3) 
                  ((psel3[0] == 1'b0 or pready3 == 1'b0 or !($isunknown(pslverr3)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ3\n Pslverr3 went3 to X or Z3 when responding3");


// Prdata3 must not be X or Z3
assertPrdataUnknown3:assert property (
                  disable iff(!has_checks3) 
                  ((psel3[0] == 1'b0 or pready3 == 0 or prwd3 == 0 or !($isunknown(prdata3)))))
                  else
                  $error("ERR_APB102_XZ3\n Prdata3 went3 to X or Z3 when responding3 to a read transfer3");

end // always @ (posedge pclock3)
      
*/

endinterface : apb_if3

