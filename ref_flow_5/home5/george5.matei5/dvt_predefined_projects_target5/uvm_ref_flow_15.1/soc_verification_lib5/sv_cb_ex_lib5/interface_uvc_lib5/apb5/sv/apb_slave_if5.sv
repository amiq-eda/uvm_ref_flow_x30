/******************************************************************************

  FILE : apb_slave_if5.sv

 ******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


interface apb_slave_if5(input pclock5, preset5);
  // Actual5 Signals5
   parameter         PADDR_WIDTH5  = 32;
   parameter         PWDATA_WIDTH5 = 32;
   parameter         PRDATA_WIDTH5 = 32;

  // Control5 flags5
  bit                has_checks5 = 1;
  bit                has_coverage = 1;

  // Actual5 Signals5
  //wire logic              pclock5;
  //wire logic              preset5;
  wire logic       [PADDR_WIDTH5-1:0] paddr5;
  wire logic              prwd5;
  wire logic       [PWDATA_WIDTH5-1:0] pwdata5;
  wire logic              psel5;
  wire logic              penable5;

  logic        [PRDATA_WIDTH5-1:0] prdata5;
  logic              pslverr5;
  logic              pready5;

  // Coverage5 and assertions5 to be implegmented5 here5.

/*  fix5 to make concurrent5 assertions5
always @(posedge pclock5)
begin

// Pready5 must not be X or Z5
assertPreadyUnknown5:assert property (
                  disable iff(!has_checks5) 
                  (!($isunknown(pready5))))
                  else
                    $error("ERR_APB100_PREADY_XZ5\n Pready5 went5 to X or Z5");


// Pslverr5 must not be X or Z5
assertPslverrUnknown5:assert property (
                  disable iff(!has_checks5) 
                  ((psel5 == 1'b0 or pready5 == 1'b0 or !($isunknown(pslverr5)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ5\n Pslverr5 went5 to X or Z5 when responding5");


// Prdata5 must not be X or Z5
assertPrdataUnknown5:assert property (
                  disable iff(!has_checks5) 
                  ((psel5 == 1'b0 or pready5 == 0 or prwd5 == 0 or !($isunknown(prdata5)))))
                  else
                  $error("ERR_APB102_XZ5\n Prdata5 went5 to X or Z5 when responding5 to a read transfer5");



end

   // EACH5 SLAVE5 HAS5 ITS5 OWN5 PSEL5 LINES5 FOR5 WHICH5 THE5 APB5 ABV5 VIP5 Checker5 can be run on.
`include "apb_checker5.sv"
*/

endinterface : apb_slave_if5

