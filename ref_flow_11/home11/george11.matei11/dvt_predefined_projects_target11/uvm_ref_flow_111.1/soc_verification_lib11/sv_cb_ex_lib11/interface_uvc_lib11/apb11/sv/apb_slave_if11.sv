/******************************************************************************

  FILE : apb_slave_if11.sv

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


interface apb_slave_if11(input pclock11, preset11);
  // Actual11 Signals11
   parameter         PADDR_WIDTH11  = 32;
   parameter         PWDATA_WIDTH11 = 32;
   parameter         PRDATA_WIDTH11 = 32;

  // Control11 flags11
  bit                has_checks11 = 1;
  bit                has_coverage = 1;

  // Actual11 Signals11
  //wire logic              pclock11;
  //wire logic              preset11;
  wire logic       [PADDR_WIDTH11-1:0] paddr11;
  wire logic              prwd11;
  wire logic       [PWDATA_WIDTH11-1:0] pwdata11;
  wire logic              psel11;
  wire logic              penable11;

  logic        [PRDATA_WIDTH11-1:0] prdata11;
  logic              pslverr11;
  logic              pready11;

  // Coverage11 and assertions11 to be implegmented11 here11.

/*  fix11 to make concurrent11 assertions11
always @(posedge pclock11)
begin

// Pready11 must not be X or Z11
assertPreadyUnknown11:assert property (
                  disable iff(!has_checks11) 
                  (!($isunknown(pready11))))
                  else
                    $error("ERR_APB100_PREADY_XZ11\n Pready11 went11 to X or Z11");


// Pslverr11 must not be X or Z11
assertPslverrUnknown11:assert property (
                  disable iff(!has_checks11) 
                  ((psel11 == 1'b0 or pready11 == 1'b0 or !($isunknown(pslverr11)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ11\n Pslverr11 went11 to X or Z11 when responding11");


// Prdata11 must not be X or Z11
assertPrdataUnknown11:assert property (
                  disable iff(!has_checks11) 
                  ((psel11 == 1'b0 or pready11 == 0 or prwd11 == 0 or !($isunknown(prdata11)))))
                  else
                  $error("ERR_APB102_XZ11\n Prdata11 went11 to X or Z11 when responding11 to a read transfer11");



end

   // EACH11 SLAVE11 HAS11 ITS11 OWN11 PSEL11 LINES11 FOR11 WHICH11 THE11 APB11 ABV11 VIP11 Checker11 can be run on.
`include "apb_checker11.sv"
*/

endinterface : apb_slave_if11

