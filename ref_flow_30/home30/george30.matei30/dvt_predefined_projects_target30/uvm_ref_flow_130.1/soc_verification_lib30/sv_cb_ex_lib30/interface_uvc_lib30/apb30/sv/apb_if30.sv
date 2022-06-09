/******************************************************************************
  FILE : apb_if30.sv
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


interface apb_if30 (input pclock30, input preset30);

  parameter         PADDR_WIDTH30  = 32;
  parameter         PWDATA_WIDTH30 = 32;
  parameter         PRDATA_WIDTH30 = 32;

  // Actual30 Signals30
  logic [PADDR_WIDTH30-1:0]  paddr30;
  logic                    prwd30;
  logic [PWDATA_WIDTH30-1:0] pwdata30;
  logic                    penable30;
  logic [15:0]             psel30;
  logic [PRDATA_WIDTH30-1:0] prdata30;
  logic               pslverr30;
  logic               pready30;

  // UART30 Interrupt30 signal30
  //logic       ua_int30;

  // Control30 flags30
  bit                has_checks30 = 1;
  bit                has_coverage = 1;

// Coverage30 and assertions30 to be implemented here30.

/*  KAM30: needs30 update to concurrent30 assertions30 syntax30
always @(posedge pclock30)
begin

// PADDR30 must not be X or Z30 when PSEL30 is asserted30
assertPAddrUnknown30:assert property (
                  disable iff(!has_checks30) 
                  (psel30 == 0 or !$isunknown(paddr30)))
                  else
                    $error("ERR_APB001_PADDR_XZ30\n PADDR30 went30 to X or Z30 \
                            when PSEL30 is asserted30");

// PRWD30 must not be X or Z30 when PSEL30 is asserted30
assertPRwdUnknown30:assert property ( 
                  disable iff(!has_checks30) 
                  (psel30 == 0 or !$isunknown(prwd30)))
                  else
                    $error("ERR_APB002_PRWD_XZ30\n PRWD30 went30 to X or Z30 \
                            when PSEL30 is asserted30");

// PWDATA30 must not be X or Z30 during a data transfer30
assertPWdataUnknown30:assert property ( 
                   disable iff(!has_checks30) 
                   (psel30 == 0 or prwd30 == 0 or !$isunknown(pwdata30)))
                   else
                     $error("ERR_APB003_PWDATA_XZ30\n PWDATA30 went30 to X or Z30 \
                             during a write transfer30");

// PENABLE30 must not be X or Z30
assertPEnableUnknown30:assert property ( 
                  disable iff(!has_checks30) 
                  (!$isunknown(penable30)))
                  else
                    $error("ERR_APB004_PENABLE_XZ30\n PENABLE30 went30 to X or Z30");

// PSEL30 must not be X or Z30
assertPSelUnknown30:assert property ( 
                  disable iff(!has_checks30) 
                  (!$isunknown(psel30)))
                  else
                    $error("ERR_APB005_PSEL_XZ30\n PSEL30 went30 to X or Z30");

// Pslverr30 must not be X or Z30
assertPslverrUnknown30:assert property (
                  disable iff(!has_checks30) 
                  ((psel30[0] == 1'b0 or pready30 == 1'b0 or !($isunknown(pslverr30)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ30\n Pslverr30 went30 to X or Z30 when responding30");


// Prdata30 must not be X or Z30
assertPrdataUnknown30:assert property (
                  disable iff(!has_checks30) 
                  ((psel30[0] == 1'b0 or pready30 == 0 or prwd30 == 0 or !($isunknown(prdata30)))))
                  else
                  $error("ERR_APB102_XZ30\n Prdata30 went30 to X or Z30 when responding30 to a read transfer30");

end // always @ (posedge pclock30)
      
*/

endinterface : apb_if30

