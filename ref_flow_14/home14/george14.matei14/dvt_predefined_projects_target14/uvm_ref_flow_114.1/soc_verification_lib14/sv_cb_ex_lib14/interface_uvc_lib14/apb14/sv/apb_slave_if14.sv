/******************************************************************************

  FILE : apb_slave_if14.sv

 ******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


interface apb_slave_if14(input pclock14, preset14);
  // Actual14 Signals14
   parameter         PADDR_WIDTH14  = 32;
   parameter         PWDATA_WIDTH14 = 32;
   parameter         PRDATA_WIDTH14 = 32;

  // Control14 flags14
  bit                has_checks14 = 1;
  bit                has_coverage = 1;

  // Actual14 Signals14
  //wire logic              pclock14;
  //wire logic              preset14;
  wire logic       [PADDR_WIDTH14-1:0] paddr14;
  wire logic              prwd14;
  wire logic       [PWDATA_WIDTH14-1:0] pwdata14;
  wire logic              psel14;
  wire logic              penable14;

  logic        [PRDATA_WIDTH14-1:0] prdata14;
  logic              pslverr14;
  logic              pready14;

  // Coverage14 and assertions14 to be implegmented14 here14.

/*  fix14 to make concurrent14 assertions14
always @(posedge pclock14)
begin

// Pready14 must not be X or Z14
assertPreadyUnknown14:assert property (
                  disable iff(!has_checks14) 
                  (!($isunknown(pready14))))
                  else
                    $error("ERR_APB100_PREADY_XZ14\n Pready14 went14 to X or Z14");


// Pslverr14 must not be X or Z14
assertPslverrUnknown14:assert property (
                  disable iff(!has_checks14) 
                  ((psel14 == 1'b0 or pready14 == 1'b0 or !($isunknown(pslverr14)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ14\n Pslverr14 went14 to X or Z14 when responding14");


// Prdata14 must not be X or Z14
assertPrdataUnknown14:assert property (
                  disable iff(!has_checks14) 
                  ((psel14 == 1'b0 or pready14 == 0 or prwd14 == 0 or !($isunknown(prdata14)))))
                  else
                  $error("ERR_APB102_XZ14\n Prdata14 went14 to X or Z14 when responding14 to a read transfer14");



end

   // EACH14 SLAVE14 HAS14 ITS14 OWN14 PSEL14 LINES14 FOR14 WHICH14 THE14 APB14 ABV14 VIP14 Checker14 can be run on.
`include "apb_checker14.sv"
*/

endinterface : apb_slave_if14

