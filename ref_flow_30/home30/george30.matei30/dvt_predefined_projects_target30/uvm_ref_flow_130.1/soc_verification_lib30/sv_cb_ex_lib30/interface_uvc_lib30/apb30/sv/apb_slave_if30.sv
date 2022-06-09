/******************************************************************************

  FILE : apb_slave_if30.sv

 ******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


interface apb_slave_if30(input pclock30, preset30);
  // Actual30 Signals30
   parameter         PADDR_WIDTH30  = 32;
   parameter         PWDATA_WIDTH30 = 32;
   parameter         PRDATA_WIDTH30 = 32;

  // Control30 flags30
  bit                has_checks30 = 1;
  bit                has_coverage = 1;

  // Actual30 Signals30
  //wire logic              pclock30;
  //wire logic              preset30;
  wire logic       [PADDR_WIDTH30-1:0] paddr30;
  wire logic              prwd30;
  wire logic       [PWDATA_WIDTH30-1:0] pwdata30;
  wire logic              psel30;
  wire logic              penable30;

  logic        [PRDATA_WIDTH30-1:0] prdata30;
  logic              pslverr30;
  logic              pready30;

  // Coverage30 and assertions30 to be implegmented30 here30.

/*  fix30 to make concurrent30 assertions30
always @(posedge pclock30)
begin

// Pready30 must not be X or Z30
assertPreadyUnknown30:assert property (
                  disable iff(!has_checks30) 
                  (!($isunknown(pready30))))
                  else
                    $error("ERR_APB100_PREADY_XZ30\n Pready30 went30 to X or Z30");


// Pslverr30 must not be X or Z30
assertPslverrUnknown30:assert property (
                  disable iff(!has_checks30) 
                  ((psel30 == 1'b0 or pready30 == 1'b0 or !($isunknown(pslverr30)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ30\n Pslverr30 went30 to X or Z30 when responding30");


// Prdata30 must not be X or Z30
assertPrdataUnknown30:assert property (
                  disable iff(!has_checks30) 
                  ((psel30 == 1'b0 or pready30 == 0 or prwd30 == 0 or !($isunknown(prdata30)))))
                  else
                  $error("ERR_APB102_XZ30\n Prdata30 went30 to X or Z30 when responding30 to a read transfer30");



end

   // EACH30 SLAVE30 HAS30 ITS30 OWN30 PSEL30 LINES30 FOR30 WHICH30 THE30 APB30 ABV30 VIP30 Checker30 can be run on.
`include "apb_checker30.sv"
*/

endinterface : apb_slave_if30

