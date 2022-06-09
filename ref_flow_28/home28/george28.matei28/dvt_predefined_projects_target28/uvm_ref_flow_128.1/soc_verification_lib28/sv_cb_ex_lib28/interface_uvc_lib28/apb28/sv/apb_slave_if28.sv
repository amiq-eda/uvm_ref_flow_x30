/******************************************************************************

  FILE : apb_slave_if28.sv

 ******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


interface apb_slave_if28(input pclock28, preset28);
  // Actual28 Signals28
   parameter         PADDR_WIDTH28  = 32;
   parameter         PWDATA_WIDTH28 = 32;
   parameter         PRDATA_WIDTH28 = 32;

  // Control28 flags28
  bit                has_checks28 = 1;
  bit                has_coverage = 1;

  // Actual28 Signals28
  //wire logic              pclock28;
  //wire logic              preset28;
  wire logic       [PADDR_WIDTH28-1:0] paddr28;
  wire logic              prwd28;
  wire logic       [PWDATA_WIDTH28-1:0] pwdata28;
  wire logic              psel28;
  wire logic              penable28;

  logic        [PRDATA_WIDTH28-1:0] prdata28;
  logic              pslverr28;
  logic              pready28;

  // Coverage28 and assertions28 to be implegmented28 here28.

/*  fix28 to make concurrent28 assertions28
always @(posedge pclock28)
begin

// Pready28 must not be X or Z28
assertPreadyUnknown28:assert property (
                  disable iff(!has_checks28) 
                  (!($isunknown(pready28))))
                  else
                    $error("ERR_APB100_PREADY_XZ28\n Pready28 went28 to X or Z28");


// Pslverr28 must not be X or Z28
assertPslverrUnknown28:assert property (
                  disable iff(!has_checks28) 
                  ((psel28 == 1'b0 or pready28 == 1'b0 or !($isunknown(pslverr28)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ28\n Pslverr28 went28 to X or Z28 when responding28");


// Prdata28 must not be X or Z28
assertPrdataUnknown28:assert property (
                  disable iff(!has_checks28) 
                  ((psel28 == 1'b0 or pready28 == 0 or prwd28 == 0 or !($isunknown(prdata28)))))
                  else
                  $error("ERR_APB102_XZ28\n Prdata28 went28 to X or Z28 when responding28 to a read transfer28");



end

   // EACH28 SLAVE28 HAS28 ITS28 OWN28 PSEL28 LINES28 FOR28 WHICH28 THE28 APB28 ABV28 VIP28 Checker28 can be run on.
`include "apb_checker28.sv"
*/

endinterface : apb_slave_if28

