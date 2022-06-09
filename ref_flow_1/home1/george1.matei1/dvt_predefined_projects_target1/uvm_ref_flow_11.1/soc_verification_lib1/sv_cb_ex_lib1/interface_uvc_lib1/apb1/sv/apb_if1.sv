/******************************************************************************
  FILE : apb_if1.sv
 ******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


interface apb_if1 (input pclock1, input preset1);

  parameter         PADDR_WIDTH1  = 32;
  parameter         PWDATA_WIDTH1 = 32;
  parameter         PRDATA_WIDTH1 = 32;

  // Actual1 Signals1
  logic [PADDR_WIDTH1-1:0]  paddr1;
  logic                    prwd1;
  logic [PWDATA_WIDTH1-1:0] pwdata1;
  logic                    penable1;
  logic [15:0]             psel1;
  logic [PRDATA_WIDTH1-1:0] prdata1;
  logic               pslverr1;
  logic               pready1;

  // UART1 Interrupt1 signal1
  //logic       ua_int1;

  // Control1 flags1
  bit                has_checks1 = 1;
  bit                has_coverage = 1;

// Coverage1 and assertions1 to be implemented here1.

/*  KAM1: needs1 update to concurrent1 assertions1 syntax1
always @(posedge pclock1)
begin

// PADDR1 must not be X or Z1 when PSEL1 is asserted1
assertPAddrUnknown1:assert property (
                  disable iff(!has_checks1) 
                  (psel1 == 0 or !$isunknown(paddr1)))
                  else
                    $error("ERR_APB001_PADDR_XZ1\n PADDR1 went1 to X or Z1 \
                            when PSEL1 is asserted1");

// PRWD1 must not be X or Z1 when PSEL1 is asserted1
assertPRwdUnknown1:assert property ( 
                  disable iff(!has_checks1) 
                  (psel1 == 0 or !$isunknown(prwd1)))
                  else
                    $error("ERR_APB002_PRWD_XZ1\n PRWD1 went1 to X or Z1 \
                            when PSEL1 is asserted1");

// PWDATA1 must not be X or Z1 during a data transfer1
assertPWdataUnknown1:assert property ( 
                   disable iff(!has_checks1) 
                   (psel1 == 0 or prwd1 == 0 or !$isunknown(pwdata1)))
                   else
                     $error("ERR_APB003_PWDATA_XZ1\n PWDATA1 went1 to X or Z1 \
                             during a write transfer1");

// PENABLE1 must not be X or Z1
assertPEnableUnknown1:assert property ( 
                  disable iff(!has_checks1) 
                  (!$isunknown(penable1)))
                  else
                    $error("ERR_APB004_PENABLE_XZ1\n PENABLE1 went1 to X or Z1");

// PSEL1 must not be X or Z1
assertPSelUnknown1:assert property ( 
                  disable iff(!has_checks1) 
                  (!$isunknown(psel1)))
                  else
                    $error("ERR_APB005_PSEL_XZ1\n PSEL1 went1 to X or Z1");

// Pslverr1 must not be X or Z1
assertPslverrUnknown1:assert property (
                  disable iff(!has_checks1) 
                  ((psel1[0] == 1'b0 or pready1 == 1'b0 or !($isunknown(pslverr1)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ1\n Pslverr1 went1 to X or Z1 when responding1");


// Prdata1 must not be X or Z1
assertPrdataUnknown1:assert property (
                  disable iff(!has_checks1) 
                  ((psel1[0] == 1'b0 or pready1 == 0 or prwd1 == 0 or !($isunknown(prdata1)))))
                  else
                  $error("ERR_APB102_XZ1\n Prdata1 went1 to X or Z1 when responding1 to a read transfer1");

end // always @ (posedge pclock1)
      
*/

endinterface : apb_if1

