/******************************************************************************

  FILE : apb_slave_if7.sv

 ******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


interface apb_slave_if7(input pclock7, preset7);
  // Actual7 Signals7
   parameter         PADDR_WIDTH7  = 32;
   parameter         PWDATA_WIDTH7 = 32;
   parameter         PRDATA_WIDTH7 = 32;

  // Control7 flags7
  bit                has_checks7 = 1;
  bit                has_coverage = 1;

  // Actual7 Signals7
  //wire logic              pclock7;
  //wire logic              preset7;
  wire logic       [PADDR_WIDTH7-1:0] paddr7;
  wire logic              prwd7;
  wire logic       [PWDATA_WIDTH7-1:0] pwdata7;
  wire logic              psel7;
  wire logic              penable7;

  logic        [PRDATA_WIDTH7-1:0] prdata7;
  logic              pslverr7;
  logic              pready7;

  // Coverage7 and assertions7 to be implegmented7 here7.

/*  fix7 to make concurrent7 assertions7
always @(posedge pclock7)
begin

// Pready7 must not be X or Z7
assertPreadyUnknown7:assert property (
                  disable iff(!has_checks7) 
                  (!($isunknown(pready7))))
                  else
                    $error("ERR_APB100_PREADY_XZ7\n Pready7 went7 to X or Z7");


// Pslverr7 must not be X or Z7
assertPslverrUnknown7:assert property (
                  disable iff(!has_checks7) 
                  ((psel7 == 1'b0 or pready7 == 1'b0 or !($isunknown(pslverr7)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ7\n Pslverr7 went7 to X or Z7 when responding7");


// Prdata7 must not be X or Z7
assertPrdataUnknown7:assert property (
                  disable iff(!has_checks7) 
                  ((psel7 == 1'b0 or pready7 == 0 or prwd7 == 0 or !($isunknown(prdata7)))))
                  else
                  $error("ERR_APB102_XZ7\n Prdata7 went7 to X or Z7 when responding7 to a read transfer7");



end

   // EACH7 SLAVE7 HAS7 ITS7 OWN7 PSEL7 LINES7 FOR7 WHICH7 THE7 APB7 ABV7 VIP7 Checker7 can be run on.
`include "apb_checker7.sv"
*/

endinterface : apb_slave_if7

