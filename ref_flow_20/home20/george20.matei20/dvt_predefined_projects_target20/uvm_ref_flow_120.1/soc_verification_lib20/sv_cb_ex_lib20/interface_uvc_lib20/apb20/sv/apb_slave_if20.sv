/******************************************************************************

  FILE : apb_slave_if20.sv

 ******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


interface apb_slave_if20(input pclock20, preset20);
  // Actual20 Signals20
   parameter         PADDR_WIDTH20  = 32;
   parameter         PWDATA_WIDTH20 = 32;
   parameter         PRDATA_WIDTH20 = 32;

  // Control20 flags20
  bit                has_checks20 = 1;
  bit                has_coverage = 1;

  // Actual20 Signals20
  //wire logic              pclock20;
  //wire logic              preset20;
  wire logic       [PADDR_WIDTH20-1:0] paddr20;
  wire logic              prwd20;
  wire logic       [PWDATA_WIDTH20-1:0] pwdata20;
  wire logic              psel20;
  wire logic              penable20;

  logic        [PRDATA_WIDTH20-1:0] prdata20;
  logic              pslverr20;
  logic              pready20;

  // Coverage20 and assertions20 to be implegmented20 here20.

/*  fix20 to make concurrent20 assertions20
always @(posedge pclock20)
begin

// Pready20 must not be X or Z20
assertPreadyUnknown20:assert property (
                  disable iff(!has_checks20) 
                  (!($isunknown(pready20))))
                  else
                    $error("ERR_APB100_PREADY_XZ20\n Pready20 went20 to X or Z20");


// Pslverr20 must not be X or Z20
assertPslverrUnknown20:assert property (
                  disable iff(!has_checks20) 
                  ((psel20 == 1'b0 or pready20 == 1'b0 or !($isunknown(pslverr20)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ20\n Pslverr20 went20 to X or Z20 when responding20");


// Prdata20 must not be X or Z20
assertPrdataUnknown20:assert property (
                  disable iff(!has_checks20) 
                  ((psel20 == 1'b0 or pready20 == 0 or prwd20 == 0 or !($isunknown(prdata20)))))
                  else
                  $error("ERR_APB102_XZ20\n Prdata20 went20 to X or Z20 when responding20 to a read transfer20");



end

   // EACH20 SLAVE20 HAS20 ITS20 OWN20 PSEL20 LINES20 FOR20 WHICH20 THE20 APB20 ABV20 VIP20 Checker20 can be run on.
`include "apb_checker20.sv"
*/

endinterface : apb_slave_if20

