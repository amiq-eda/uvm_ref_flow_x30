/******************************************************************************
  FILE : apb_if4.sv
 ******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


interface apb_if4 (input pclock4, input preset4);

  parameter         PADDR_WIDTH4  = 32;
  parameter         PWDATA_WIDTH4 = 32;
  parameter         PRDATA_WIDTH4 = 32;

  // Actual4 Signals4
  logic [PADDR_WIDTH4-1:0]  paddr4;
  logic                    prwd4;
  logic [PWDATA_WIDTH4-1:0] pwdata4;
  logic                    penable4;
  logic [15:0]             psel4;
  logic [PRDATA_WIDTH4-1:0] prdata4;
  logic               pslverr4;
  logic               pready4;

  // UART4 Interrupt4 signal4
  //logic       ua_int4;

  // Control4 flags4
  bit                has_checks4 = 1;
  bit                has_coverage = 1;

// Coverage4 and assertions4 to be implemented here4.

/*  KAM4: needs4 update to concurrent4 assertions4 syntax4
always @(posedge pclock4)
begin

// PADDR4 must not be X or Z4 when PSEL4 is asserted4
assertPAddrUnknown4:assert property (
                  disable iff(!has_checks4) 
                  (psel4 == 0 or !$isunknown(paddr4)))
                  else
                    $error("ERR_APB001_PADDR_XZ4\n PADDR4 went4 to X or Z4 \
                            when PSEL4 is asserted4");

// PRWD4 must not be X or Z4 when PSEL4 is asserted4
assertPRwdUnknown4:assert property ( 
                  disable iff(!has_checks4) 
                  (psel4 == 0 or !$isunknown(prwd4)))
                  else
                    $error("ERR_APB002_PRWD_XZ4\n PRWD4 went4 to X or Z4 \
                            when PSEL4 is asserted4");

// PWDATA4 must not be X or Z4 during a data transfer4
assertPWdataUnknown4:assert property ( 
                   disable iff(!has_checks4) 
                   (psel4 == 0 or prwd4 == 0 or !$isunknown(pwdata4)))
                   else
                     $error("ERR_APB003_PWDATA_XZ4\n PWDATA4 went4 to X or Z4 \
                             during a write transfer4");

// PENABLE4 must not be X or Z4
assertPEnableUnknown4:assert property ( 
                  disable iff(!has_checks4) 
                  (!$isunknown(penable4)))
                  else
                    $error("ERR_APB004_PENABLE_XZ4\n PENABLE4 went4 to X or Z4");

// PSEL4 must not be X or Z4
assertPSelUnknown4:assert property ( 
                  disable iff(!has_checks4) 
                  (!$isunknown(psel4)))
                  else
                    $error("ERR_APB005_PSEL_XZ4\n PSEL4 went4 to X or Z4");

// Pslverr4 must not be X or Z4
assertPslverrUnknown4:assert property (
                  disable iff(!has_checks4) 
                  ((psel4[0] == 1'b0 or pready4 == 1'b0 or !($isunknown(pslverr4)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ4\n Pslverr4 went4 to X or Z4 when responding4");


// Prdata4 must not be X or Z4
assertPrdataUnknown4:assert property (
                  disable iff(!has_checks4) 
                  ((psel4[0] == 1'b0 or pready4 == 0 or prwd4 == 0 or !($isunknown(prdata4)))))
                  else
                  $error("ERR_APB102_XZ4\n Prdata4 went4 to X or Z4 when responding4 to a read transfer4");

end // always @ (posedge pclock4)
      
*/

endinterface : apb_if4

