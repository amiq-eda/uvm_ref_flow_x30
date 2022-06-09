/******************************************************************************

  FILE : apb_slave_if8.sv

 ******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


interface apb_slave_if8(input pclock8, preset8);
  // Actual8 Signals8
   parameter         PADDR_WIDTH8  = 32;
   parameter         PWDATA_WIDTH8 = 32;
   parameter         PRDATA_WIDTH8 = 32;

  // Control8 flags8
  bit                has_checks8 = 1;
  bit                has_coverage = 1;

  // Actual8 Signals8
  //wire logic              pclock8;
  //wire logic              preset8;
  wire logic       [PADDR_WIDTH8-1:0] paddr8;
  wire logic              prwd8;
  wire logic       [PWDATA_WIDTH8-1:0] pwdata8;
  wire logic              psel8;
  wire logic              penable8;

  logic        [PRDATA_WIDTH8-1:0] prdata8;
  logic              pslverr8;
  logic              pready8;

  // Coverage8 and assertions8 to be implegmented8 here8.

/*  fix8 to make concurrent8 assertions8
always @(posedge pclock8)
begin

// Pready8 must not be X or Z8
assertPreadyUnknown8:assert property (
                  disable iff(!has_checks8) 
                  (!($isunknown(pready8))))
                  else
                    $error("ERR_APB100_PREADY_XZ8\n Pready8 went8 to X or Z8");


// Pslverr8 must not be X or Z8
assertPslverrUnknown8:assert property (
                  disable iff(!has_checks8) 
                  ((psel8 == 1'b0 or pready8 == 1'b0 or !($isunknown(pslverr8)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ8\n Pslverr8 went8 to X or Z8 when responding8");


// Prdata8 must not be X or Z8
assertPrdataUnknown8:assert property (
                  disable iff(!has_checks8) 
                  ((psel8 == 1'b0 or pready8 == 0 or prwd8 == 0 or !($isunknown(prdata8)))))
                  else
                  $error("ERR_APB102_XZ8\n Prdata8 went8 to X or Z8 when responding8 to a read transfer8");



end

   // EACH8 SLAVE8 HAS8 ITS8 OWN8 PSEL8 LINES8 FOR8 WHICH8 THE8 APB8 ABV8 VIP8 Checker8 can be run on.
`include "apb_checker8.sv"
*/

endinterface : apb_slave_if8

