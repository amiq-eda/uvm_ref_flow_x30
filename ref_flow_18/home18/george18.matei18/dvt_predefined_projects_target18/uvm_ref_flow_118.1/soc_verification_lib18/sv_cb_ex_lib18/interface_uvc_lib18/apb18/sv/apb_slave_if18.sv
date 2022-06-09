/******************************************************************************

  FILE : apb_slave_if18.sv

 ******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


interface apb_slave_if18(input pclock18, preset18);
  // Actual18 Signals18
   parameter         PADDR_WIDTH18  = 32;
   parameter         PWDATA_WIDTH18 = 32;
   parameter         PRDATA_WIDTH18 = 32;

  // Control18 flags18
  bit                has_checks18 = 1;
  bit                has_coverage = 1;

  // Actual18 Signals18
  //wire logic              pclock18;
  //wire logic              preset18;
  wire logic       [PADDR_WIDTH18-1:0] paddr18;
  wire logic              prwd18;
  wire logic       [PWDATA_WIDTH18-1:0] pwdata18;
  wire logic              psel18;
  wire logic              penable18;

  logic        [PRDATA_WIDTH18-1:0] prdata18;
  logic              pslverr18;
  logic              pready18;

  // Coverage18 and assertions18 to be implegmented18 here18.

/*  fix18 to make concurrent18 assertions18
always @(posedge pclock18)
begin

// Pready18 must not be X or Z18
assertPreadyUnknown18:assert property (
                  disable iff(!has_checks18) 
                  (!($isunknown(pready18))))
                  else
                    $error("ERR_APB100_PREADY_XZ18\n Pready18 went18 to X or Z18");


// Pslverr18 must not be X or Z18
assertPslverrUnknown18:assert property (
                  disable iff(!has_checks18) 
                  ((psel18 == 1'b0 or pready18 == 1'b0 or !($isunknown(pslverr18)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ18\n Pslverr18 went18 to X or Z18 when responding18");


// Prdata18 must not be X or Z18
assertPrdataUnknown18:assert property (
                  disable iff(!has_checks18) 
                  ((psel18 == 1'b0 or pready18 == 0 or prwd18 == 0 or !($isunknown(prdata18)))))
                  else
                  $error("ERR_APB102_XZ18\n Prdata18 went18 to X or Z18 when responding18 to a read transfer18");



end

   // EACH18 SLAVE18 HAS18 ITS18 OWN18 PSEL18 LINES18 FOR18 WHICH18 THE18 APB18 ABV18 VIP18 Checker18 can be run on.
`include "apb_checker18.sv"
*/

endinterface : apb_slave_if18

