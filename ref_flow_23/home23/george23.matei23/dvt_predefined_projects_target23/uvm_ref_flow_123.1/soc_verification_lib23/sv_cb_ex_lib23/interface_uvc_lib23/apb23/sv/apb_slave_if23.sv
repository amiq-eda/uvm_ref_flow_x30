/******************************************************************************

  FILE : apb_slave_if23.sv

 ******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


interface apb_slave_if23(input pclock23, preset23);
  // Actual23 Signals23
   parameter         PADDR_WIDTH23  = 32;
   parameter         PWDATA_WIDTH23 = 32;
   parameter         PRDATA_WIDTH23 = 32;

  // Control23 flags23
  bit                has_checks23 = 1;
  bit                has_coverage = 1;

  // Actual23 Signals23
  //wire logic              pclock23;
  //wire logic              preset23;
  wire logic       [PADDR_WIDTH23-1:0] paddr23;
  wire logic              prwd23;
  wire logic       [PWDATA_WIDTH23-1:0] pwdata23;
  wire logic              psel23;
  wire logic              penable23;

  logic        [PRDATA_WIDTH23-1:0] prdata23;
  logic              pslverr23;
  logic              pready23;

  // Coverage23 and assertions23 to be implegmented23 here23.

/*  fix23 to make concurrent23 assertions23
always @(posedge pclock23)
begin

// Pready23 must not be X or Z23
assertPreadyUnknown23:assert property (
                  disable iff(!has_checks23) 
                  (!($isunknown(pready23))))
                  else
                    $error("ERR_APB100_PREADY_XZ23\n Pready23 went23 to X or Z23");


// Pslverr23 must not be X or Z23
assertPslverrUnknown23:assert property (
                  disable iff(!has_checks23) 
                  ((psel23 == 1'b0 or pready23 == 1'b0 or !($isunknown(pslverr23)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ23\n Pslverr23 went23 to X or Z23 when responding23");


// Prdata23 must not be X or Z23
assertPrdataUnknown23:assert property (
                  disable iff(!has_checks23) 
                  ((psel23 == 1'b0 or pready23 == 0 or prwd23 == 0 or !($isunknown(prdata23)))))
                  else
                  $error("ERR_APB102_XZ23\n Prdata23 went23 to X or Z23 when responding23 to a read transfer23");



end

   // EACH23 SLAVE23 HAS23 ITS23 OWN23 PSEL23 LINES23 FOR23 WHICH23 THE23 APB23 ABV23 VIP23 Checker23 can be run on.
`include "apb_checker23.sv"
*/

endinterface : apb_slave_if23

