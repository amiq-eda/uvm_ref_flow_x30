/******************************************************************************

  FILE : apb_slave_if2.sv

 ******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


interface apb_slave_if2(input pclock2, preset2);
  // Actual2 Signals2
   parameter         PADDR_WIDTH2  = 32;
   parameter         PWDATA_WIDTH2 = 32;
   parameter         PRDATA_WIDTH2 = 32;

  // Control2 flags2
  bit                has_checks2 = 1;
  bit                has_coverage = 1;

  // Actual2 Signals2
  //wire logic              pclock2;
  //wire logic              preset2;
  wire logic       [PADDR_WIDTH2-1:0] paddr2;
  wire logic              prwd2;
  wire logic       [PWDATA_WIDTH2-1:0] pwdata2;
  wire logic              psel2;
  wire logic              penable2;

  logic        [PRDATA_WIDTH2-1:0] prdata2;
  logic              pslverr2;
  logic              pready2;

  // Coverage2 and assertions2 to be implegmented2 here2.

/*  fix2 to make concurrent2 assertions2
always @(posedge pclock2)
begin

// Pready2 must not be X or Z2
assertPreadyUnknown2:assert property (
                  disable iff(!has_checks2) 
                  (!($isunknown(pready2))))
                  else
                    $error("ERR_APB100_PREADY_XZ2\n Pready2 went2 to X or Z2");


// Pslverr2 must not be X or Z2
assertPslverrUnknown2:assert property (
                  disable iff(!has_checks2) 
                  ((psel2 == 1'b0 or pready2 == 1'b0 or !($isunknown(pslverr2)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ2\n Pslverr2 went2 to X or Z2 when responding2");


// Prdata2 must not be X or Z2
assertPrdataUnknown2:assert property (
                  disable iff(!has_checks2) 
                  ((psel2 == 1'b0 or pready2 == 0 or prwd2 == 0 or !($isunknown(prdata2)))))
                  else
                  $error("ERR_APB102_XZ2\n Prdata2 went2 to X or Z2 when responding2 to a read transfer2");



end

   // EACH2 SLAVE2 HAS2 ITS2 OWN2 PSEL2 LINES2 FOR2 WHICH2 THE2 APB2 ABV2 VIP2 Checker2 can be run on.
`include "apb_checker2.sv"
*/

endinterface : apb_slave_if2

