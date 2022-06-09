/******************************************************************************
  FILE : apb_if26.sv
 ******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


interface apb_if26 (input pclock26, input preset26);

  parameter         PADDR_WIDTH26  = 32;
  parameter         PWDATA_WIDTH26 = 32;
  parameter         PRDATA_WIDTH26 = 32;

  // Actual26 Signals26
  logic [PADDR_WIDTH26-1:0]  paddr26;
  logic                    prwd26;
  logic [PWDATA_WIDTH26-1:0] pwdata26;
  logic                    penable26;
  logic [15:0]             psel26;
  logic [PRDATA_WIDTH26-1:0] prdata26;
  logic               pslverr26;
  logic               pready26;

  // UART26 Interrupt26 signal26
  //logic       ua_int26;

  // Control26 flags26
  bit                has_checks26 = 1;
  bit                has_coverage = 1;

// Coverage26 and assertions26 to be implemented here26.

/*  KAM26: needs26 update to concurrent26 assertions26 syntax26
always @(posedge pclock26)
begin

// PADDR26 must not be X or Z26 when PSEL26 is asserted26
assertPAddrUnknown26:assert property (
                  disable iff(!has_checks26) 
                  (psel26 == 0 or !$isunknown(paddr26)))
                  else
                    $error("ERR_APB001_PADDR_XZ26\n PADDR26 went26 to X or Z26 \
                            when PSEL26 is asserted26");

// PRWD26 must not be X or Z26 when PSEL26 is asserted26
assertPRwdUnknown26:assert property ( 
                  disable iff(!has_checks26) 
                  (psel26 == 0 or !$isunknown(prwd26)))
                  else
                    $error("ERR_APB002_PRWD_XZ26\n PRWD26 went26 to X or Z26 \
                            when PSEL26 is asserted26");

// PWDATA26 must not be X or Z26 during a data transfer26
assertPWdataUnknown26:assert property ( 
                   disable iff(!has_checks26) 
                   (psel26 == 0 or prwd26 == 0 or !$isunknown(pwdata26)))
                   else
                     $error("ERR_APB003_PWDATA_XZ26\n PWDATA26 went26 to X or Z26 \
                             during a write transfer26");

// PENABLE26 must not be X or Z26
assertPEnableUnknown26:assert property ( 
                  disable iff(!has_checks26) 
                  (!$isunknown(penable26)))
                  else
                    $error("ERR_APB004_PENABLE_XZ26\n PENABLE26 went26 to X or Z26");

// PSEL26 must not be X or Z26
assertPSelUnknown26:assert property ( 
                  disable iff(!has_checks26) 
                  (!$isunknown(psel26)))
                  else
                    $error("ERR_APB005_PSEL_XZ26\n PSEL26 went26 to X or Z26");

// Pslverr26 must not be X or Z26
assertPslverrUnknown26:assert property (
                  disable iff(!has_checks26) 
                  ((psel26[0] == 1'b0 or pready26 == 1'b0 or !($isunknown(pslverr26)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ26\n Pslverr26 went26 to X or Z26 when responding26");


// Prdata26 must not be X or Z26
assertPrdataUnknown26:assert property (
                  disable iff(!has_checks26) 
                  ((psel26[0] == 1'b0 or pready26 == 0 or prwd26 == 0 or !($isunknown(prdata26)))))
                  else
                  $error("ERR_APB102_XZ26\n Prdata26 went26 to X or Z26 when responding26 to a read transfer26");

end // always @ (posedge pclock26)
      
*/

endinterface : apb_if26

