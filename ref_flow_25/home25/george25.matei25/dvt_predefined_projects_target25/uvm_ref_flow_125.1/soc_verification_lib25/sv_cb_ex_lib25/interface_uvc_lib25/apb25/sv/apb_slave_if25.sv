/******************************************************************************

  FILE : apb_slave_if25.sv

 ******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


interface apb_slave_if25(input pclock25, preset25);
  // Actual25 Signals25
   parameter         PADDR_WIDTH25  = 32;
   parameter         PWDATA_WIDTH25 = 32;
   parameter         PRDATA_WIDTH25 = 32;

  // Control25 flags25
  bit                has_checks25 = 1;
  bit                has_coverage = 1;

  // Actual25 Signals25
  //wire logic              pclock25;
  //wire logic              preset25;
  wire logic       [PADDR_WIDTH25-1:0] paddr25;
  wire logic              prwd25;
  wire logic       [PWDATA_WIDTH25-1:0] pwdata25;
  wire logic              psel25;
  wire logic              penable25;

  logic        [PRDATA_WIDTH25-1:0] prdata25;
  logic              pslverr25;
  logic              pready25;

  // Coverage25 and assertions25 to be implegmented25 here25.

/*  fix25 to make concurrent25 assertions25
always @(posedge pclock25)
begin

// Pready25 must not be X or Z25
assertPreadyUnknown25:assert property (
                  disable iff(!has_checks25) 
                  (!($isunknown(pready25))))
                  else
                    $error("ERR_APB100_PREADY_XZ25\n Pready25 went25 to X or Z25");


// Pslverr25 must not be X or Z25
assertPslverrUnknown25:assert property (
                  disable iff(!has_checks25) 
                  ((psel25 == 1'b0 or pready25 == 1'b0 or !($isunknown(pslverr25)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ25\n Pslverr25 went25 to X or Z25 when responding25");


// Prdata25 must not be X or Z25
assertPrdataUnknown25:assert property (
                  disable iff(!has_checks25) 
                  ((psel25 == 1'b0 or pready25 == 0 or prwd25 == 0 or !($isunknown(prdata25)))))
                  else
                  $error("ERR_APB102_XZ25\n Prdata25 went25 to X or Z25 when responding25 to a read transfer25");



end

   // EACH25 SLAVE25 HAS25 ITS25 OWN25 PSEL25 LINES25 FOR25 WHICH25 THE25 APB25 ABV25 VIP25 Checker25 can be run on.
`include "apb_checker25.sv"
*/

endinterface : apb_slave_if25

