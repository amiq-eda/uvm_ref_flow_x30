/******************************************************************************

  FILE : apb_slave_if9.sv

 ******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


interface apb_slave_if9(input pclock9, preset9);
  // Actual9 Signals9
   parameter         PADDR_WIDTH9  = 32;
   parameter         PWDATA_WIDTH9 = 32;
   parameter         PRDATA_WIDTH9 = 32;

  // Control9 flags9
  bit                has_checks9 = 1;
  bit                has_coverage = 1;

  // Actual9 Signals9
  //wire logic              pclock9;
  //wire logic              preset9;
  wire logic       [PADDR_WIDTH9-1:0] paddr9;
  wire logic              prwd9;
  wire logic       [PWDATA_WIDTH9-1:0] pwdata9;
  wire logic              psel9;
  wire logic              penable9;

  logic        [PRDATA_WIDTH9-1:0] prdata9;
  logic              pslverr9;
  logic              pready9;

  // Coverage9 and assertions9 to be implegmented9 here9.

/*  fix9 to make concurrent9 assertions9
always @(posedge pclock9)
begin

// Pready9 must not be X or Z9
assertPreadyUnknown9:assert property (
                  disable iff(!has_checks9) 
                  (!($isunknown(pready9))))
                  else
                    $error("ERR_APB100_PREADY_XZ9\n Pready9 went9 to X or Z9");


// Pslverr9 must not be X or Z9
assertPslverrUnknown9:assert property (
                  disable iff(!has_checks9) 
                  ((psel9 == 1'b0 or pready9 == 1'b0 or !($isunknown(pslverr9)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ9\n Pslverr9 went9 to X or Z9 when responding9");


// Prdata9 must not be X or Z9
assertPrdataUnknown9:assert property (
                  disable iff(!has_checks9) 
                  ((psel9 == 1'b0 or pready9 == 0 or prwd9 == 0 or !($isunknown(prdata9)))))
                  else
                  $error("ERR_APB102_XZ9\n Prdata9 went9 to X or Z9 when responding9 to a read transfer9");



end

   // EACH9 SLAVE9 HAS9 ITS9 OWN9 PSEL9 LINES9 FOR9 WHICH9 THE9 APB9 ABV9 VIP9 Checker9 can be run on.
`include "apb_checker9.sv"
*/

endinterface : apb_slave_if9

