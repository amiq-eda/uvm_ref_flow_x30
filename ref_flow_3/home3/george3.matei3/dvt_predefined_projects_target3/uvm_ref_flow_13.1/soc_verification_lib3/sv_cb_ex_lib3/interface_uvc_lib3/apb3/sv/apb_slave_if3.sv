/******************************************************************************

  FILE : apb_slave_if3.sv

 ******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


interface apb_slave_if3(input pclock3, preset3);
  // Actual3 Signals3
   parameter         PADDR_WIDTH3  = 32;
   parameter         PWDATA_WIDTH3 = 32;
   parameter         PRDATA_WIDTH3 = 32;

  // Control3 flags3
  bit                has_checks3 = 1;
  bit                has_coverage = 1;

  // Actual3 Signals3
  //wire logic              pclock3;
  //wire logic              preset3;
  wire logic       [PADDR_WIDTH3-1:0] paddr3;
  wire logic              prwd3;
  wire logic       [PWDATA_WIDTH3-1:0] pwdata3;
  wire logic              psel3;
  wire logic              penable3;

  logic        [PRDATA_WIDTH3-1:0] prdata3;
  logic              pslverr3;
  logic              pready3;

  // Coverage3 and assertions3 to be implegmented3 here3.

/*  fix3 to make concurrent3 assertions3
always @(posedge pclock3)
begin

// Pready3 must not be X or Z3
assertPreadyUnknown3:assert property (
                  disable iff(!has_checks3) 
                  (!($isunknown(pready3))))
                  else
                    $error("ERR_APB100_PREADY_XZ3\n Pready3 went3 to X or Z3");


// Pslverr3 must not be X or Z3
assertPslverrUnknown3:assert property (
                  disable iff(!has_checks3) 
                  ((psel3 == 1'b0 or pready3 == 1'b0 or !($isunknown(pslverr3)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ3\n Pslverr3 went3 to X or Z3 when responding3");


// Prdata3 must not be X or Z3
assertPrdataUnknown3:assert property (
                  disable iff(!has_checks3) 
                  ((psel3 == 1'b0 or pready3 == 0 or prwd3 == 0 or !($isunknown(prdata3)))))
                  else
                  $error("ERR_APB102_XZ3\n Prdata3 went3 to X or Z3 when responding3 to a read transfer3");



end

   // EACH3 SLAVE3 HAS3 ITS3 OWN3 PSEL3 LINES3 FOR3 WHICH3 THE3 APB3 ABV3 VIP3 Checker3 can be run on.
`include "apb_checker3.sv"
*/

endinterface : apb_slave_if3

