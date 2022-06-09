/******************************************************************************

  FILE : apb_slave_if16.sv

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


interface apb_slave_if16(input pclock16, preset16);
  // Actual16 Signals16
   parameter         PADDR_WIDTH16  = 32;
   parameter         PWDATA_WIDTH16 = 32;
   parameter         PRDATA_WIDTH16 = 32;

  // Control16 flags16
  bit                has_checks16 = 1;
  bit                has_coverage = 1;

  // Actual16 Signals16
  //wire logic              pclock16;
  //wire logic              preset16;
  wire logic       [PADDR_WIDTH16-1:0] paddr16;
  wire logic              prwd16;
  wire logic       [PWDATA_WIDTH16-1:0] pwdata16;
  wire logic              psel16;
  wire logic              penable16;

  logic        [PRDATA_WIDTH16-1:0] prdata16;
  logic              pslverr16;
  logic              pready16;

  // Coverage16 and assertions16 to be implegmented16 here16.

/*  fix16 to make concurrent16 assertions16
always @(posedge pclock16)
begin

// Pready16 must not be X or Z16
assertPreadyUnknown16:assert property (
                  disable iff(!has_checks16) 
                  (!($isunknown(pready16))))
                  else
                    $error("ERR_APB100_PREADY_XZ16\n Pready16 went16 to X or Z16");


// Pslverr16 must not be X or Z16
assertPslverrUnknown16:assert property (
                  disable iff(!has_checks16) 
                  ((psel16 == 1'b0 or pready16 == 1'b0 or !($isunknown(pslverr16)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ16\n Pslverr16 went16 to X or Z16 when responding16");


// Prdata16 must not be X or Z16
assertPrdataUnknown16:assert property (
                  disable iff(!has_checks16) 
                  ((psel16 == 1'b0 or pready16 == 0 or prwd16 == 0 or !($isunknown(prdata16)))))
                  else
                  $error("ERR_APB102_XZ16\n Prdata16 went16 to X or Z16 when responding16 to a read transfer16");



end

   // EACH16 SLAVE16 HAS16 ITS16 OWN16 PSEL16 LINES16 FOR16 WHICH16 THE16 APB16 ABV16 VIP16 Checker16 can be run on.
`include "apb_checker16.sv"
*/

endinterface : apb_slave_if16

