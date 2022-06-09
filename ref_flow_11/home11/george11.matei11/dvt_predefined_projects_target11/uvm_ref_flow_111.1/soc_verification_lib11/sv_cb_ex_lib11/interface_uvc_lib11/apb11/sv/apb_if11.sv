/******************************************************************************
  FILE : apb_if11.sv
 ******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


interface apb_if11 (input pclock11, input preset11);

  parameter         PADDR_WIDTH11  = 32;
  parameter         PWDATA_WIDTH11 = 32;
  parameter         PRDATA_WIDTH11 = 32;

  // Actual11 Signals11
  logic [PADDR_WIDTH11-1:0]  paddr11;
  logic                    prwd11;
  logic [PWDATA_WIDTH11-1:0] pwdata11;
  logic                    penable11;
  logic [15:0]             psel11;
  logic [PRDATA_WIDTH11-1:0] prdata11;
  logic               pslverr11;
  logic               pready11;

  // UART11 Interrupt11 signal11
  //logic       ua_int11;

  // Control11 flags11
  bit                has_checks11 = 1;
  bit                has_coverage = 1;

// Coverage11 and assertions11 to be implemented here11.

/*  KAM11: needs11 update to concurrent11 assertions11 syntax11
always @(posedge pclock11)
begin

// PADDR11 must not be X or Z11 when PSEL11 is asserted11
assertPAddrUnknown11:assert property (
                  disable iff(!has_checks11) 
                  (psel11 == 0 or !$isunknown(paddr11)))
                  else
                    $error("ERR_APB001_PADDR_XZ11\n PADDR11 went11 to X or Z11 \
                            when PSEL11 is asserted11");

// PRWD11 must not be X or Z11 when PSEL11 is asserted11
assertPRwdUnknown11:assert property ( 
                  disable iff(!has_checks11) 
                  (psel11 == 0 or !$isunknown(prwd11)))
                  else
                    $error("ERR_APB002_PRWD_XZ11\n PRWD11 went11 to X or Z11 \
                            when PSEL11 is asserted11");

// PWDATA11 must not be X or Z11 during a data transfer11
assertPWdataUnknown11:assert property ( 
                   disable iff(!has_checks11) 
                   (psel11 == 0 or prwd11 == 0 or !$isunknown(pwdata11)))
                   else
                     $error("ERR_APB003_PWDATA_XZ11\n PWDATA11 went11 to X or Z11 \
                             during a write transfer11");

// PENABLE11 must not be X or Z11
assertPEnableUnknown11:assert property ( 
                  disable iff(!has_checks11) 
                  (!$isunknown(penable11)))
                  else
                    $error("ERR_APB004_PENABLE_XZ11\n PENABLE11 went11 to X or Z11");

// PSEL11 must not be X or Z11
assertPSelUnknown11:assert property ( 
                  disable iff(!has_checks11) 
                  (!$isunknown(psel11)))
                  else
                    $error("ERR_APB005_PSEL_XZ11\n PSEL11 went11 to X or Z11");

// Pslverr11 must not be X or Z11
assertPslverrUnknown11:assert property (
                  disable iff(!has_checks11) 
                  ((psel11[0] == 1'b0 or pready11 == 1'b0 or !($isunknown(pslverr11)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ11\n Pslverr11 went11 to X or Z11 when responding11");


// Prdata11 must not be X or Z11
assertPrdataUnknown11:assert property (
                  disable iff(!has_checks11) 
                  ((psel11[0] == 1'b0 or pready11 == 0 or prwd11 == 0 or !($isunknown(prdata11)))))
                  else
                  $error("ERR_APB102_XZ11\n Prdata11 went11 to X or Z11 when responding11 to a read transfer11");

end // always @ (posedge pclock11)
      
*/

endinterface : apb_if11

