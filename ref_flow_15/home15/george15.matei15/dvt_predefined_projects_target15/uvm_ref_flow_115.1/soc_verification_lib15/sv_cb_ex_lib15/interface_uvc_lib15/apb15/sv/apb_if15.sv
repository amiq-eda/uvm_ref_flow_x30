/******************************************************************************
  FILE : apb_if15.sv
 ******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


interface apb_if15 (input pclock15, input preset15);

  parameter         PADDR_WIDTH15  = 32;
  parameter         PWDATA_WIDTH15 = 32;
  parameter         PRDATA_WIDTH15 = 32;

  // Actual15 Signals15
  logic [PADDR_WIDTH15-1:0]  paddr15;
  logic                    prwd15;
  logic [PWDATA_WIDTH15-1:0] pwdata15;
  logic                    penable15;
  logic [15:0]             psel15;
  logic [PRDATA_WIDTH15-1:0] prdata15;
  logic               pslverr15;
  logic               pready15;

  // UART15 Interrupt15 signal15
  //logic       ua_int15;

  // Control15 flags15
  bit                has_checks15 = 1;
  bit                has_coverage = 1;

// Coverage15 and assertions15 to be implemented here15.

/*  KAM15: needs15 update to concurrent15 assertions15 syntax15
always @(posedge pclock15)
begin

// PADDR15 must not be X or Z15 when PSEL15 is asserted15
assertPAddrUnknown15:assert property (
                  disable iff(!has_checks15) 
                  (psel15 == 0 or !$isunknown(paddr15)))
                  else
                    $error("ERR_APB001_PADDR_XZ15\n PADDR15 went15 to X or Z15 \
                            when PSEL15 is asserted15");

// PRWD15 must not be X or Z15 when PSEL15 is asserted15
assertPRwdUnknown15:assert property ( 
                  disable iff(!has_checks15) 
                  (psel15 == 0 or !$isunknown(prwd15)))
                  else
                    $error("ERR_APB002_PRWD_XZ15\n PRWD15 went15 to X or Z15 \
                            when PSEL15 is asserted15");

// PWDATA15 must not be X or Z15 during a data transfer15
assertPWdataUnknown15:assert property ( 
                   disable iff(!has_checks15) 
                   (psel15 == 0 or prwd15 == 0 or !$isunknown(pwdata15)))
                   else
                     $error("ERR_APB003_PWDATA_XZ15\n PWDATA15 went15 to X or Z15 \
                             during a write transfer15");

// PENABLE15 must not be X or Z15
assertPEnableUnknown15:assert property ( 
                  disable iff(!has_checks15) 
                  (!$isunknown(penable15)))
                  else
                    $error("ERR_APB004_PENABLE_XZ15\n PENABLE15 went15 to X or Z15");

// PSEL15 must not be X or Z15
assertPSelUnknown15:assert property ( 
                  disable iff(!has_checks15) 
                  (!$isunknown(psel15)))
                  else
                    $error("ERR_APB005_PSEL_XZ15\n PSEL15 went15 to X or Z15");

// Pslverr15 must not be X or Z15
assertPslverrUnknown15:assert property (
                  disable iff(!has_checks15) 
                  ((psel15[0] == 1'b0 or pready15 == 1'b0 or !($isunknown(pslverr15)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ15\n Pslverr15 went15 to X or Z15 when responding15");


// Prdata15 must not be X or Z15
assertPrdataUnknown15:assert property (
                  disable iff(!has_checks15) 
                  ((psel15[0] == 1'b0 or pready15 == 0 or prwd15 == 0 or !($isunknown(prdata15)))))
                  else
                  $error("ERR_APB102_XZ15\n Prdata15 went15 to X or Z15 when responding15 to a read transfer15");

end // always @ (posedge pclock15)
      
*/

endinterface : apb_if15

