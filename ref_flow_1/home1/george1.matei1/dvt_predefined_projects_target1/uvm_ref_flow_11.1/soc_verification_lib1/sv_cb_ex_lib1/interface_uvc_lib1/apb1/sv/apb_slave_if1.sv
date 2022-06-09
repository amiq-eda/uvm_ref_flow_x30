/******************************************************************************

  FILE : apb_slave_if1.sv

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


interface apb_slave_if1(input pclock1, preset1);
  // Actual1 Signals1
   parameter         PADDR_WIDTH1  = 32;
   parameter         PWDATA_WIDTH1 = 32;
   parameter         PRDATA_WIDTH1 = 32;

  // Control1 flags1
  bit                has_checks1 = 1;
  bit                has_coverage = 1;

  // Actual1 Signals1
  //wire logic              pclock1;
  //wire logic              preset1;
  wire logic       [PADDR_WIDTH1-1:0] paddr1;
  wire logic              prwd1;
  wire logic       [PWDATA_WIDTH1-1:0] pwdata1;
  wire logic              psel1;
  wire logic              penable1;

  logic        [PRDATA_WIDTH1-1:0] prdata1;
  logic              pslverr1;
  logic              pready1;

  // Coverage1 and assertions1 to be implegmented1 here1.

/*  fix1 to make concurrent1 assertions1
always @(posedge pclock1)
begin

// Pready1 must not be X or Z1
assertPreadyUnknown1:assert property (
                  disable iff(!has_checks1) 
                  (!($isunknown(pready1))))
                  else
                    $error("ERR_APB100_PREADY_XZ1\n Pready1 went1 to X or Z1");


// Pslverr1 must not be X or Z1
assertPslverrUnknown1:assert property (
                  disable iff(!has_checks1) 
                  ((psel1 == 1'b0 or pready1 == 1'b0 or !($isunknown(pslverr1)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ1\n Pslverr1 went1 to X or Z1 when responding1");


// Prdata1 must not be X or Z1
assertPrdataUnknown1:assert property (
                  disable iff(!has_checks1) 
                  ((psel1 == 1'b0 or pready1 == 0 or prwd1 == 0 or !($isunknown(prdata1)))))
                  else
                  $error("ERR_APB102_XZ1\n Prdata1 went1 to X or Z1 when responding1 to a read transfer1");



end

   // EACH1 SLAVE1 HAS1 ITS1 OWN1 PSEL1 LINES1 FOR1 WHICH1 THE1 APB1 ABV1 VIP1 Checker1 can be run on.
`include "apb_checker1.sv"
*/

endinterface : apb_slave_if1

