/******************************************************************************

  FILE : apb_slave_if27.sv

 ******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


interface apb_slave_if27(input pclock27, preset27);
  // Actual27 Signals27
   parameter         PADDR_WIDTH27  = 32;
   parameter         PWDATA_WIDTH27 = 32;
   parameter         PRDATA_WIDTH27 = 32;

  // Control27 flags27
  bit                has_checks27 = 1;
  bit                has_coverage = 1;

  // Actual27 Signals27
  //wire logic              pclock27;
  //wire logic              preset27;
  wire logic       [PADDR_WIDTH27-1:0] paddr27;
  wire logic              prwd27;
  wire logic       [PWDATA_WIDTH27-1:0] pwdata27;
  wire logic              psel27;
  wire logic              penable27;

  logic        [PRDATA_WIDTH27-1:0] prdata27;
  logic              pslverr27;
  logic              pready27;

  // Coverage27 and assertions27 to be implegmented27 here27.

/*  fix27 to make concurrent27 assertions27
always @(posedge pclock27)
begin

// Pready27 must not be X or Z27
assertPreadyUnknown27:assert property (
                  disable iff(!has_checks27) 
                  (!($isunknown(pready27))))
                  else
                    $error("ERR_APB100_PREADY_XZ27\n Pready27 went27 to X or Z27");


// Pslverr27 must not be X or Z27
assertPslverrUnknown27:assert property (
                  disable iff(!has_checks27) 
                  ((psel27 == 1'b0 or pready27 == 1'b0 or !($isunknown(pslverr27)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ27\n Pslverr27 went27 to X or Z27 when responding27");


// Prdata27 must not be X or Z27
assertPrdataUnknown27:assert property (
                  disable iff(!has_checks27) 
                  ((psel27 == 1'b0 or pready27 == 0 or prwd27 == 0 or !($isunknown(prdata27)))))
                  else
                  $error("ERR_APB102_XZ27\n Prdata27 went27 to X or Z27 when responding27 to a read transfer27");



end

   // EACH27 SLAVE27 HAS27 ITS27 OWN27 PSEL27 LINES27 FOR27 WHICH27 THE27 APB27 ABV27 VIP27 Checker27 can be run on.
`include "apb_checker27.sv"
*/

endinterface : apb_slave_if27

