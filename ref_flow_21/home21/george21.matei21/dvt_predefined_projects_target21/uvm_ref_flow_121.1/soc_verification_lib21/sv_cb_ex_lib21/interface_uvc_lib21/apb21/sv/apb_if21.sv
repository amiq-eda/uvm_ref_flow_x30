/******************************************************************************
  FILE : apb_if21.sv
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


interface apb_if21 (input pclock21, input preset21);

  parameter         PADDR_WIDTH21  = 32;
  parameter         PWDATA_WIDTH21 = 32;
  parameter         PRDATA_WIDTH21 = 32;

  // Actual21 Signals21
  logic [PADDR_WIDTH21-1:0]  paddr21;
  logic                    prwd21;
  logic [PWDATA_WIDTH21-1:0] pwdata21;
  logic                    penable21;
  logic [15:0]             psel21;
  logic [PRDATA_WIDTH21-1:0] prdata21;
  logic               pslverr21;
  logic               pready21;

  // UART21 Interrupt21 signal21
  //logic       ua_int21;

  // Control21 flags21
  bit                has_checks21 = 1;
  bit                has_coverage = 1;

// Coverage21 and assertions21 to be implemented here21.

/*  KAM21: needs21 update to concurrent21 assertions21 syntax21
always @(posedge pclock21)
begin

// PADDR21 must not be X or Z21 when PSEL21 is asserted21
assertPAddrUnknown21:assert property (
                  disable iff(!has_checks21) 
                  (psel21 == 0 or !$isunknown(paddr21)))
                  else
                    $error("ERR_APB001_PADDR_XZ21\n PADDR21 went21 to X or Z21 \
                            when PSEL21 is asserted21");

// PRWD21 must not be X or Z21 when PSEL21 is asserted21
assertPRwdUnknown21:assert property ( 
                  disable iff(!has_checks21) 
                  (psel21 == 0 or !$isunknown(prwd21)))
                  else
                    $error("ERR_APB002_PRWD_XZ21\n PRWD21 went21 to X or Z21 \
                            when PSEL21 is asserted21");

// PWDATA21 must not be X or Z21 during a data transfer21
assertPWdataUnknown21:assert property ( 
                   disable iff(!has_checks21) 
                   (psel21 == 0 or prwd21 == 0 or !$isunknown(pwdata21)))
                   else
                     $error("ERR_APB003_PWDATA_XZ21\n PWDATA21 went21 to X or Z21 \
                             during a write transfer21");

// PENABLE21 must not be X or Z21
assertPEnableUnknown21:assert property ( 
                  disable iff(!has_checks21) 
                  (!$isunknown(penable21)))
                  else
                    $error("ERR_APB004_PENABLE_XZ21\n PENABLE21 went21 to X or Z21");

// PSEL21 must not be X or Z21
assertPSelUnknown21:assert property ( 
                  disable iff(!has_checks21) 
                  (!$isunknown(psel21)))
                  else
                    $error("ERR_APB005_PSEL_XZ21\n PSEL21 went21 to X or Z21");

// Pslverr21 must not be X or Z21
assertPslverrUnknown21:assert property (
                  disable iff(!has_checks21) 
                  ((psel21[0] == 1'b0 or pready21 == 1'b0 or !($isunknown(pslverr21)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ21\n Pslverr21 went21 to X or Z21 when responding21");


// Prdata21 must not be X or Z21
assertPrdataUnknown21:assert property (
                  disable iff(!has_checks21) 
                  ((psel21[0] == 1'b0 or pready21 == 0 or prwd21 == 0 or !($isunknown(prdata21)))))
                  else
                  $error("ERR_APB102_XZ21\n Prdata21 went21 to X or Z21 when responding21 to a read transfer21");

end // always @ (posedge pclock21)
      
*/

endinterface : apb_if21

