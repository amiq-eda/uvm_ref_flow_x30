/******************************************************************************
  FILE : apb_master_if13.sv
 ******************************************************************************/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

interface apb_master_if13 (input pclock13,
                         input preset13);

  parameter         PADDR_WIDTH13  = 32;
  parameter         PWDATA_WIDTH13 = 32;
  parameter         PRDATA_WIDTH13 = 32;

  // Actual13 Signals13
  logic [PADDR_WIDTH13-1:0]  paddr13;
  logic                    prwd13;
  logic [PWDATA_WIDTH13-1:0] pwdata13;
  logic                    penable13;
  logic                    pready13;
  logic [15:0]             psel13;
  logic [PRDATA_WIDTH13-1:0] prdata13;
  wire logic               pslverr13;

  // UART13 Interrupt13 signal13
  logic       ua_int13;

  logic [31:0] gp_int13;

  // Control13 flags13
  bit                has_checks13 = 1;
  bit                has_coverage = 1;

// Coverage13 and assertions13 to be implemented here13.

/* NEEDS13 TO BE13 UPDATED13 TO CONCURRENT13 ASSERTIONS13
always @(posedge pclock13)
begin

// PADDR13 must not be X or Z13 when PSEL13 is asserted13
assertPAddrUnknown13:assert property (
                  disable iff(!has_checks13 || !preset13)
                  (psel13 == 0 or !$isunknown(paddr13)))
                  else
                    $error("ERR_APB001_PADDR_XZ13\n PADDR13 went13 to X or Z13 \
                            when PSEL13 is asserted13");

// PRWD13 must not be X or Z13 when PSEL13 is asserted13
assertPRwdUnknown13:assert property ( 
                  disable iff(!has_checks13 || !preset13)
                  (psel13 == 0 or !$isunknown(prwd13)))
                  else
                    $error("ERR_APB002_PRWD_XZ13\n PRWD13 went13 to X or Z13 \
                            when PSEL13 is asserted13");

// PWDATA13 must not be X or Z13 during a data transfer13
assertPWdataUnknown13:assert property ( 
                   disable iff(!has_checks13 || !preset13)
                   (psel13 == 0 or prwd13 == 0 or !$isunknown(pwdata13)))
                   else
                     $error("ERR_APB003_PWDATA_XZ13\n PWDATA13 went13 to X or Z13 \
                             during a write transfer13");

// PENABLE13 must not be X or Z13
assertPEnableUnknown13:assert property ( 
                  disable iff(!has_checks13 || !preset13)
                  (!$isunknown(penable13)))
                  else
                    $error("ERR_APB004_PENABLE_XZ13\n PENABLE13 went13 to X or Z13");

// PSEL13 must not be X or Z13
assertPSelUnknown13:assert property ( 
                  disable iff(!has_checks13 || !preset13)
                  (!$isunknown(psel13)))
                  else
                    $error("ERR_APB005_PSEL_XZ13\n PSEL13 went13 to X or Z13");

end // always @ (posedge pclock13)
*/
      
endinterface : apb_master_if13
