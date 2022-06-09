/******************************************************************************
  FILE : apb_if19.sv
 ******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


interface apb_if19 (input pclock19, input preset19);

  parameter         PADDR_WIDTH19  = 32;
  parameter         PWDATA_WIDTH19 = 32;
  parameter         PRDATA_WIDTH19 = 32;

  // Actual19 Signals19
  logic [PADDR_WIDTH19-1:0]  paddr19;
  logic                    prwd19;
  logic [PWDATA_WIDTH19-1:0] pwdata19;
  logic                    penable19;
  logic [15:0]             psel19;
  logic [PRDATA_WIDTH19-1:0] prdata19;
  logic               pslverr19;
  logic               pready19;

  // UART19 Interrupt19 signal19
  //logic       ua_int19;

  // Control19 flags19
  bit                has_checks19 = 1;
  bit                has_coverage = 1;

// Coverage19 and assertions19 to be implemented here19.

/*  KAM19: needs19 update to concurrent19 assertions19 syntax19
always @(posedge pclock19)
begin

// PADDR19 must not be X or Z19 when PSEL19 is asserted19
assertPAddrUnknown19:assert property (
                  disable iff(!has_checks19) 
                  (psel19 == 0 or !$isunknown(paddr19)))
                  else
                    $error("ERR_APB001_PADDR_XZ19\n PADDR19 went19 to X or Z19 \
                            when PSEL19 is asserted19");

// PRWD19 must not be X or Z19 when PSEL19 is asserted19
assertPRwdUnknown19:assert property ( 
                  disable iff(!has_checks19) 
                  (psel19 == 0 or !$isunknown(prwd19)))
                  else
                    $error("ERR_APB002_PRWD_XZ19\n PRWD19 went19 to X or Z19 \
                            when PSEL19 is asserted19");

// PWDATA19 must not be X or Z19 during a data transfer19
assertPWdataUnknown19:assert property ( 
                   disable iff(!has_checks19) 
                   (psel19 == 0 or prwd19 == 0 or !$isunknown(pwdata19)))
                   else
                     $error("ERR_APB003_PWDATA_XZ19\n PWDATA19 went19 to X or Z19 \
                             during a write transfer19");

// PENABLE19 must not be X or Z19
assertPEnableUnknown19:assert property ( 
                  disable iff(!has_checks19) 
                  (!$isunknown(penable19)))
                  else
                    $error("ERR_APB004_PENABLE_XZ19\n PENABLE19 went19 to X or Z19");

// PSEL19 must not be X or Z19
assertPSelUnknown19:assert property ( 
                  disable iff(!has_checks19) 
                  (!$isunknown(psel19)))
                  else
                    $error("ERR_APB005_PSEL_XZ19\n PSEL19 went19 to X or Z19");

// Pslverr19 must not be X or Z19
assertPslverrUnknown19:assert property (
                  disable iff(!has_checks19) 
                  ((psel19[0] == 1'b0 or pready19 == 1'b0 or !($isunknown(pslverr19)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ19\n Pslverr19 went19 to X or Z19 when responding19");


// Prdata19 must not be X or Z19
assertPrdataUnknown19:assert property (
                  disable iff(!has_checks19) 
                  ((psel19[0] == 1'b0 or pready19 == 0 or prwd19 == 0 or !($isunknown(prdata19)))))
                  else
                  $error("ERR_APB102_XZ19\n Prdata19 went19 to X or Z19 when responding19 to a read transfer19");

end // always @ (posedge pclock19)
      
*/

endinterface : apb_if19

