/******************************************************************************

  FILE : apb_slave_if17.sv

 ******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


interface apb_slave_if17(input pclock17, preset17);
  // Actual17 Signals17
   parameter         PADDR_WIDTH17  = 32;
   parameter         PWDATA_WIDTH17 = 32;
   parameter         PRDATA_WIDTH17 = 32;

  // Control17 flags17
  bit                has_checks17 = 1;
  bit                has_coverage = 1;

  // Actual17 Signals17
  //wire logic              pclock17;
  //wire logic              preset17;
  wire logic       [PADDR_WIDTH17-1:0] paddr17;
  wire logic              prwd17;
  wire logic       [PWDATA_WIDTH17-1:0] pwdata17;
  wire logic              psel17;
  wire logic              penable17;

  logic        [PRDATA_WIDTH17-1:0] prdata17;
  logic              pslverr17;
  logic              pready17;

  // Coverage17 and assertions17 to be implegmented17 here17.

/*  fix17 to make concurrent17 assertions17
always @(posedge pclock17)
begin

// Pready17 must not be X or Z17
assertPreadyUnknown17:assert property (
                  disable iff(!has_checks17) 
                  (!($isunknown(pready17))))
                  else
                    $error("ERR_APB100_PREADY_XZ17\n Pready17 went17 to X or Z17");


// Pslverr17 must not be X or Z17
assertPslverrUnknown17:assert property (
                  disable iff(!has_checks17) 
                  ((psel17 == 1'b0 or pready17 == 1'b0 or !($isunknown(pslverr17)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ17\n Pslverr17 went17 to X or Z17 when responding17");


// Prdata17 must not be X or Z17
assertPrdataUnknown17:assert property (
                  disable iff(!has_checks17) 
                  ((psel17 == 1'b0 or pready17 == 0 or prwd17 == 0 or !($isunknown(prdata17)))))
                  else
                  $error("ERR_APB102_XZ17\n Prdata17 went17 to X or Z17 when responding17 to a read transfer17");



end

   // EACH17 SLAVE17 HAS17 ITS17 OWN17 PSEL17 LINES17 FOR17 WHICH17 THE17 APB17 ABV17 VIP17 Checker17 can be run on.
`include "apb_checker17.sv"
*/

endinterface : apb_slave_if17

