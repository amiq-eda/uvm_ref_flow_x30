/******************************************************************************
  FILE : apb_if16.sv
 ******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


interface apb_if16 (input pclock16, input preset16);

  parameter         PADDR_WIDTH16  = 32;
  parameter         PWDATA_WIDTH16 = 32;
  parameter         PRDATA_WIDTH16 = 32;

  // Actual16 Signals16
  logic [PADDR_WIDTH16-1:0]  paddr16;
  logic                    prwd16;
  logic [PWDATA_WIDTH16-1:0] pwdata16;
  logic                    penable16;
  logic [15:0]             psel16;
  logic [PRDATA_WIDTH16-1:0] prdata16;
  logic               pslverr16;
  logic               pready16;

  // UART16 Interrupt16 signal16
  //logic       ua_int16;

  // Control16 flags16
  bit                has_checks16 = 1;
  bit                has_coverage = 1;

// Coverage16 and assertions16 to be implemented here16.

/*  KAM16: needs16 update to concurrent16 assertions16 syntax16
always @(posedge pclock16)
begin

// PADDR16 must not be X or Z16 when PSEL16 is asserted16
assertPAddrUnknown16:assert property (
                  disable iff(!has_checks16) 
                  (psel16 == 0 or !$isunknown(paddr16)))
                  else
                    $error("ERR_APB001_PADDR_XZ16\n PADDR16 went16 to X or Z16 \
                            when PSEL16 is asserted16");

// PRWD16 must not be X or Z16 when PSEL16 is asserted16
assertPRwdUnknown16:assert property ( 
                  disable iff(!has_checks16) 
                  (psel16 == 0 or !$isunknown(prwd16)))
                  else
                    $error("ERR_APB002_PRWD_XZ16\n PRWD16 went16 to X or Z16 \
                            when PSEL16 is asserted16");

// PWDATA16 must not be X or Z16 during a data transfer16
assertPWdataUnknown16:assert property ( 
                   disable iff(!has_checks16) 
                   (psel16 == 0 or prwd16 == 0 or !$isunknown(pwdata16)))
                   else
                     $error("ERR_APB003_PWDATA_XZ16\n PWDATA16 went16 to X or Z16 \
                             during a write transfer16");

// PENABLE16 must not be X or Z16
assertPEnableUnknown16:assert property ( 
                  disable iff(!has_checks16) 
                  (!$isunknown(penable16)))
                  else
                    $error("ERR_APB004_PENABLE_XZ16\n PENABLE16 went16 to X or Z16");

// PSEL16 must not be X or Z16
assertPSelUnknown16:assert property ( 
                  disable iff(!has_checks16) 
                  (!$isunknown(psel16)))
                  else
                    $error("ERR_APB005_PSEL_XZ16\n PSEL16 went16 to X or Z16");

// Pslverr16 must not be X or Z16
assertPslverrUnknown16:assert property (
                  disable iff(!has_checks16) 
                  ((psel16[0] == 1'b0 or pready16 == 1'b0 or !($isunknown(pslverr16)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ16\n Pslverr16 went16 to X or Z16 when responding16");


// Prdata16 must not be X or Z16
assertPrdataUnknown16:assert property (
                  disable iff(!has_checks16) 
                  ((psel16[0] == 1'b0 or pready16 == 0 or prwd16 == 0 or !($isunknown(prdata16)))))
                  else
                  $error("ERR_APB102_XZ16\n Prdata16 went16 to X or Z16 when responding16 to a read transfer16");

end // always @ (posedge pclock16)
      
*/

endinterface : apb_if16

