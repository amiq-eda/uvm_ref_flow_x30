/******************************************************************************

  FILE : apb_slave_if6.sv

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


interface apb_slave_if6(input pclock6, preset6);
  // Actual6 Signals6
   parameter         PADDR_WIDTH6  = 32;
   parameter         PWDATA_WIDTH6 = 32;
   parameter         PRDATA_WIDTH6 = 32;

  // Control6 flags6
  bit                has_checks6 = 1;
  bit                has_coverage = 1;

  // Actual6 Signals6
  //wire logic              pclock6;
  //wire logic              preset6;
  wire logic       [PADDR_WIDTH6-1:0] paddr6;
  wire logic              prwd6;
  wire logic       [PWDATA_WIDTH6-1:0] pwdata6;
  wire logic              psel6;
  wire logic              penable6;

  logic        [PRDATA_WIDTH6-1:0] prdata6;
  logic              pslverr6;
  logic              pready6;

  // Coverage6 and assertions6 to be implegmented6 here6.

/*  fix6 to make concurrent6 assertions6
always @(posedge pclock6)
begin

// Pready6 must not be X or Z6
assertPreadyUnknown6:assert property (
                  disable iff(!has_checks6) 
                  (!($isunknown(pready6))))
                  else
                    $error("ERR_APB100_PREADY_XZ6\n Pready6 went6 to X or Z6");


// Pslverr6 must not be X or Z6
assertPslverrUnknown6:assert property (
                  disable iff(!has_checks6) 
                  ((psel6 == 1'b0 or pready6 == 1'b0 or !($isunknown(pslverr6)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ6\n Pslverr6 went6 to X or Z6 when responding6");


// Prdata6 must not be X or Z6
assertPrdataUnknown6:assert property (
                  disable iff(!has_checks6) 
                  ((psel6 == 1'b0 or pready6 == 0 or prwd6 == 0 or !($isunknown(prdata6)))))
                  else
                  $error("ERR_APB102_XZ6\n Prdata6 went6 to X or Z6 when responding6 to a read transfer6");



end

   // EACH6 SLAVE6 HAS6 ITS6 OWN6 PSEL6 LINES6 FOR6 WHICH6 THE6 APB6 ABV6 VIP6 Checker6 can be run on.
`include "apb_checker6.sv"
*/

endinterface : apb_slave_if6

