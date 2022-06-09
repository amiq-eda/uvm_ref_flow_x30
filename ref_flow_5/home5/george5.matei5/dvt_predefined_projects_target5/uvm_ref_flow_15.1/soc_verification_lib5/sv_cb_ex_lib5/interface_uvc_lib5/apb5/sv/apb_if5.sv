/******************************************************************************
  FILE : apb_if5.sv
 ******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


interface apb_if5 (input pclock5, input preset5);

  parameter         PADDR_WIDTH5  = 32;
  parameter         PWDATA_WIDTH5 = 32;
  parameter         PRDATA_WIDTH5 = 32;

  // Actual5 Signals5
  logic [PADDR_WIDTH5-1:0]  paddr5;
  logic                    prwd5;
  logic [PWDATA_WIDTH5-1:0] pwdata5;
  logic                    penable5;
  logic [15:0]             psel5;
  logic [PRDATA_WIDTH5-1:0] prdata5;
  logic               pslverr5;
  logic               pready5;

  // UART5 Interrupt5 signal5
  //logic       ua_int5;

  // Control5 flags5
  bit                has_checks5 = 1;
  bit                has_coverage = 1;

// Coverage5 and assertions5 to be implemented here5.

/*  KAM5: needs5 update to concurrent5 assertions5 syntax5
always @(posedge pclock5)
begin

// PADDR5 must not be X or Z5 when PSEL5 is asserted5
assertPAddrUnknown5:assert property (
                  disable iff(!has_checks5) 
                  (psel5 == 0 or !$isunknown(paddr5)))
                  else
                    $error("ERR_APB001_PADDR_XZ5\n PADDR5 went5 to X or Z5 \
                            when PSEL5 is asserted5");

// PRWD5 must not be X or Z5 when PSEL5 is asserted5
assertPRwdUnknown5:assert property ( 
                  disable iff(!has_checks5) 
                  (psel5 == 0 or !$isunknown(prwd5)))
                  else
                    $error("ERR_APB002_PRWD_XZ5\n PRWD5 went5 to X or Z5 \
                            when PSEL5 is asserted5");

// PWDATA5 must not be X or Z5 during a data transfer5
assertPWdataUnknown5:assert property ( 
                   disable iff(!has_checks5) 
                   (psel5 == 0 or prwd5 == 0 or !$isunknown(pwdata5)))
                   else
                     $error("ERR_APB003_PWDATA_XZ5\n PWDATA5 went5 to X or Z5 \
                             during a write transfer5");

// PENABLE5 must not be X or Z5
assertPEnableUnknown5:assert property ( 
                  disable iff(!has_checks5) 
                  (!$isunknown(penable5)))
                  else
                    $error("ERR_APB004_PENABLE_XZ5\n PENABLE5 went5 to X or Z5");

// PSEL5 must not be X or Z5
assertPSelUnknown5:assert property ( 
                  disable iff(!has_checks5) 
                  (!$isunknown(psel5)))
                  else
                    $error("ERR_APB005_PSEL_XZ5\n PSEL5 went5 to X or Z5");

// Pslverr5 must not be X or Z5
assertPslverrUnknown5:assert property (
                  disable iff(!has_checks5) 
                  ((psel5[0] == 1'b0 or pready5 == 1'b0 or !($isunknown(pslverr5)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ5\n Pslverr5 went5 to X or Z5 when responding5");


// Prdata5 must not be X or Z5
assertPrdataUnknown5:assert property (
                  disable iff(!has_checks5) 
                  ((psel5[0] == 1'b0 or pready5 == 0 or prwd5 == 0 or !($isunknown(prdata5)))))
                  else
                  $error("ERR_APB102_XZ5\n Prdata5 went5 to X or Z5 when responding5 to a read transfer5");

end // always @ (posedge pclock5)
      
*/

endinterface : apb_if5

