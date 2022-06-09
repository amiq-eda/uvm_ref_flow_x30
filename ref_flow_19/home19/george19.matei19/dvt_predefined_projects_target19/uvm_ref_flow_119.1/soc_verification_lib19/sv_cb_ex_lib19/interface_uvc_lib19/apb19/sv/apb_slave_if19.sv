/******************************************************************************

  FILE : apb_slave_if19.sv

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


interface apb_slave_if19(input pclock19, preset19);
  // Actual19 Signals19
   parameter         PADDR_WIDTH19  = 32;
   parameter         PWDATA_WIDTH19 = 32;
   parameter         PRDATA_WIDTH19 = 32;

  // Control19 flags19
  bit                has_checks19 = 1;
  bit                has_coverage = 1;

  // Actual19 Signals19
  //wire logic              pclock19;
  //wire logic              preset19;
  wire logic       [PADDR_WIDTH19-1:0] paddr19;
  wire logic              prwd19;
  wire logic       [PWDATA_WIDTH19-1:0] pwdata19;
  wire logic              psel19;
  wire logic              penable19;

  logic        [PRDATA_WIDTH19-1:0] prdata19;
  logic              pslverr19;
  logic              pready19;

  // Coverage19 and assertions19 to be implegmented19 here19.

/*  fix19 to make concurrent19 assertions19
always @(posedge pclock19)
begin

// Pready19 must not be X or Z19
assertPreadyUnknown19:assert property (
                  disable iff(!has_checks19) 
                  (!($isunknown(pready19))))
                  else
                    $error("ERR_APB100_PREADY_XZ19\n Pready19 went19 to X or Z19");


// Pslverr19 must not be X or Z19
assertPslverrUnknown19:assert property (
                  disable iff(!has_checks19) 
                  ((psel19 == 1'b0 or pready19 == 1'b0 or !($isunknown(pslverr19)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ19\n Pslverr19 went19 to X or Z19 when responding19");


// Prdata19 must not be X or Z19
assertPrdataUnknown19:assert property (
                  disable iff(!has_checks19) 
                  ((psel19 == 1'b0 or pready19 == 0 or prwd19 == 0 or !($isunknown(prdata19)))))
                  else
                  $error("ERR_APB102_XZ19\n Prdata19 went19 to X or Z19 when responding19 to a read transfer19");



end

   // EACH19 SLAVE19 HAS19 ITS19 OWN19 PSEL19 LINES19 FOR19 WHICH19 THE19 APB19 ABV19 VIP19 Checker19 can be run on.
`include "apb_checker19.sv"
*/

endinterface : apb_slave_if19

