/******************************************************************************

  FILE : apb_slave_if21.sv

 ******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


interface apb_slave_if21(input pclock21, preset21);
  // Actual21 Signals21
   parameter         PADDR_WIDTH21  = 32;
   parameter         PWDATA_WIDTH21 = 32;
   parameter         PRDATA_WIDTH21 = 32;

  // Control21 flags21
  bit                has_checks21 = 1;
  bit                has_coverage = 1;

  // Actual21 Signals21
  //wire logic              pclock21;
  //wire logic              preset21;
  wire logic       [PADDR_WIDTH21-1:0] paddr21;
  wire logic              prwd21;
  wire logic       [PWDATA_WIDTH21-1:0] pwdata21;
  wire logic              psel21;
  wire logic              penable21;

  logic        [PRDATA_WIDTH21-1:0] prdata21;
  logic              pslverr21;
  logic              pready21;

  // Coverage21 and assertions21 to be implegmented21 here21.

/*  fix21 to make concurrent21 assertions21
always @(posedge pclock21)
begin

// Pready21 must not be X or Z21
assertPreadyUnknown21:assert property (
                  disable iff(!has_checks21) 
                  (!($isunknown(pready21))))
                  else
                    $error("ERR_APB100_PREADY_XZ21\n Pready21 went21 to X or Z21");


// Pslverr21 must not be X or Z21
assertPslverrUnknown21:assert property (
                  disable iff(!has_checks21) 
                  ((psel21 == 1'b0 or pready21 == 1'b0 or !($isunknown(pslverr21)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ21\n Pslverr21 went21 to X or Z21 when responding21");


// Prdata21 must not be X or Z21
assertPrdataUnknown21:assert property (
                  disable iff(!has_checks21) 
                  ((psel21 == 1'b0 or pready21 == 0 or prwd21 == 0 or !($isunknown(prdata21)))))
                  else
                  $error("ERR_APB102_XZ21\n Prdata21 went21 to X or Z21 when responding21 to a read transfer21");



end

   // EACH21 SLAVE21 HAS21 ITS21 OWN21 PSEL21 LINES21 FOR21 WHICH21 THE21 APB21 ABV21 VIP21 Checker21 can be run on.
`include "apb_checker21.sv"
*/

endinterface : apb_slave_if21

