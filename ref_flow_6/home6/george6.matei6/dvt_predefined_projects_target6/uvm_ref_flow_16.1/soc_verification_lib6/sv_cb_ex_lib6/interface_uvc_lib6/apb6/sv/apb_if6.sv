/******************************************************************************
  FILE : apb_if6.sv
 ******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


interface apb_if6 (input pclock6, input preset6);

  parameter         PADDR_WIDTH6  = 32;
  parameter         PWDATA_WIDTH6 = 32;
  parameter         PRDATA_WIDTH6 = 32;

  // Actual6 Signals6
  logic [PADDR_WIDTH6-1:0]  paddr6;
  logic                    prwd6;
  logic [PWDATA_WIDTH6-1:0] pwdata6;
  logic                    penable6;
  logic [15:0]             psel6;
  logic [PRDATA_WIDTH6-1:0] prdata6;
  logic               pslverr6;
  logic               pready6;

  // UART6 Interrupt6 signal6
  //logic       ua_int6;

  // Control6 flags6
  bit                has_checks6 = 1;
  bit                has_coverage = 1;

// Coverage6 and assertions6 to be implemented here6.

/*  KAM6: needs6 update to concurrent6 assertions6 syntax6
always @(posedge pclock6)
begin

// PADDR6 must not be X or Z6 when PSEL6 is asserted6
assertPAddrUnknown6:assert property (
                  disable iff(!has_checks6) 
                  (psel6 == 0 or !$isunknown(paddr6)))
                  else
                    $error("ERR_APB001_PADDR_XZ6\n PADDR6 went6 to X or Z6 \
                            when PSEL6 is asserted6");

// PRWD6 must not be X or Z6 when PSEL6 is asserted6
assertPRwdUnknown6:assert property ( 
                  disable iff(!has_checks6) 
                  (psel6 == 0 or !$isunknown(prwd6)))
                  else
                    $error("ERR_APB002_PRWD_XZ6\n PRWD6 went6 to X or Z6 \
                            when PSEL6 is asserted6");

// PWDATA6 must not be X or Z6 during a data transfer6
assertPWdataUnknown6:assert property ( 
                   disable iff(!has_checks6) 
                   (psel6 == 0 or prwd6 == 0 or !$isunknown(pwdata6)))
                   else
                     $error("ERR_APB003_PWDATA_XZ6\n PWDATA6 went6 to X or Z6 \
                             during a write transfer6");

// PENABLE6 must not be X or Z6
assertPEnableUnknown6:assert property ( 
                  disable iff(!has_checks6) 
                  (!$isunknown(penable6)))
                  else
                    $error("ERR_APB004_PENABLE_XZ6\n PENABLE6 went6 to X or Z6");

// PSEL6 must not be X or Z6
assertPSelUnknown6:assert property ( 
                  disable iff(!has_checks6) 
                  (!$isunknown(psel6)))
                  else
                    $error("ERR_APB005_PSEL_XZ6\n PSEL6 went6 to X or Z6");

// Pslverr6 must not be X or Z6
assertPslverrUnknown6:assert property (
                  disable iff(!has_checks6) 
                  ((psel6[0] == 1'b0 or pready6 == 1'b0 or !($isunknown(pslverr6)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ6\n Pslverr6 went6 to X or Z6 when responding6");


// Prdata6 must not be X or Z6
assertPrdataUnknown6:assert property (
                  disable iff(!has_checks6) 
                  ((psel6[0] == 1'b0 or pready6 == 0 or prwd6 == 0 or !($isunknown(prdata6)))))
                  else
                  $error("ERR_APB102_XZ6\n Prdata6 went6 to X or Z6 when responding6 to a read transfer6");

end // always @ (posedge pclock6)
      
*/

endinterface : apb_if6

