/******************************************************************************

  FILE : apb_slave_if13.sv

 ******************************************************************************/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


interface apb_slave_if13(input pclock13, preset13);
  // Actual13 Signals13
   parameter         PADDR_WIDTH13  = 32;
   parameter         PWDATA_WIDTH13 = 32;
   parameter         PRDATA_WIDTH13 = 32;

  // Control13 flags13
  bit                has_checks13 = 1;
  bit                has_coverage = 1;

  // Actual13 Signals13
  //wire logic              pclock13;
  //wire logic              preset13;
  wire logic       [PADDR_WIDTH13-1:0] paddr13;
  wire logic              prwd13;
  wire logic       [PWDATA_WIDTH13-1:0] pwdata13;
  wire logic              psel13;
  wire logic              penable13;

  logic        [PRDATA_WIDTH13-1:0] prdata13;
  logic              pslverr13;
  logic              pready13;

  // Coverage13 and assertions13 to be implegmented13 here13.

/*  fix13 to make concurrent13 assertions13
always @(posedge pclock13)
begin

// Pready13 must not be X or Z13
assertPreadyUnknown13:assert property (
                  disable iff(!has_checks13) 
                  (!($isunknown(pready13))))
                  else
                    $error("ERR_APB100_PREADY_XZ13\n Pready13 went13 to X or Z13");


// Pslverr13 must not be X or Z13
assertPslverrUnknown13:assert property (
                  disable iff(!has_checks13) 
                  ((psel13 == 1'b0 or pready13 == 1'b0 or !($isunknown(pslverr13)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ13\n Pslverr13 went13 to X or Z13 when responding13");


// Prdata13 must not be X or Z13
assertPrdataUnknown13:assert property (
                  disable iff(!has_checks13) 
                  ((psel13 == 1'b0 or pready13 == 0 or prwd13 == 0 or !($isunknown(prdata13)))))
                  else
                  $error("ERR_APB102_XZ13\n Prdata13 went13 to X or Z13 when responding13 to a read transfer13");



end

   // EACH13 SLAVE13 HAS13 ITS13 OWN13 PSEL13 LINES13 FOR13 WHICH13 THE13 APB13 ABV13 VIP13 Checker13 can be run on.
`include "apb_checker13.sv"
*/

endinterface : apb_slave_if13

