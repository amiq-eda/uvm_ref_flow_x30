/******************************************************************************
  FILE : apb_if27.sv
 ******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


interface apb_if27 (input pclock27, input preset27);

  parameter         PADDR_WIDTH27  = 32;
  parameter         PWDATA_WIDTH27 = 32;
  parameter         PRDATA_WIDTH27 = 32;

  // Actual27 Signals27
  logic [PADDR_WIDTH27-1:0]  paddr27;
  logic                    prwd27;
  logic [PWDATA_WIDTH27-1:0] pwdata27;
  logic                    penable27;
  logic [15:0]             psel27;
  logic [PRDATA_WIDTH27-1:0] prdata27;
  logic               pslverr27;
  logic               pready27;

  // UART27 Interrupt27 signal27
  //logic       ua_int27;

  // Control27 flags27
  bit                has_checks27 = 1;
  bit                has_coverage = 1;

// Coverage27 and assertions27 to be implemented here27.

/*  KAM27: needs27 update to concurrent27 assertions27 syntax27
always @(posedge pclock27)
begin

// PADDR27 must not be X or Z27 when PSEL27 is asserted27
assertPAddrUnknown27:assert property (
                  disable iff(!has_checks27) 
                  (psel27 == 0 or !$isunknown(paddr27)))
                  else
                    $error("ERR_APB001_PADDR_XZ27\n PADDR27 went27 to X or Z27 \
                            when PSEL27 is asserted27");

// PRWD27 must not be X or Z27 when PSEL27 is asserted27
assertPRwdUnknown27:assert property ( 
                  disable iff(!has_checks27) 
                  (psel27 == 0 or !$isunknown(prwd27)))
                  else
                    $error("ERR_APB002_PRWD_XZ27\n PRWD27 went27 to X or Z27 \
                            when PSEL27 is asserted27");

// PWDATA27 must not be X or Z27 during a data transfer27
assertPWdataUnknown27:assert property ( 
                   disable iff(!has_checks27) 
                   (psel27 == 0 or prwd27 == 0 or !$isunknown(pwdata27)))
                   else
                     $error("ERR_APB003_PWDATA_XZ27\n PWDATA27 went27 to X or Z27 \
                             during a write transfer27");

// PENABLE27 must not be X or Z27
assertPEnableUnknown27:assert property ( 
                  disable iff(!has_checks27) 
                  (!$isunknown(penable27)))
                  else
                    $error("ERR_APB004_PENABLE_XZ27\n PENABLE27 went27 to X or Z27");

// PSEL27 must not be X or Z27
assertPSelUnknown27:assert property ( 
                  disable iff(!has_checks27) 
                  (!$isunknown(psel27)))
                  else
                    $error("ERR_APB005_PSEL_XZ27\n PSEL27 went27 to X or Z27");

// Pslverr27 must not be X or Z27
assertPslverrUnknown27:assert property (
                  disable iff(!has_checks27) 
                  ((psel27[0] == 1'b0 or pready27 == 1'b0 or !($isunknown(pslverr27)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ27\n Pslverr27 went27 to X or Z27 when responding27");


// Prdata27 must not be X or Z27
assertPrdataUnknown27:assert property (
                  disable iff(!has_checks27) 
                  ((psel27[0] == 1'b0 or pready27 == 0 or prwd27 == 0 or !($isunknown(prdata27)))))
                  else
                  $error("ERR_APB102_XZ27\n Prdata27 went27 to X or Z27 when responding27 to a read transfer27");

end // always @ (posedge pclock27)
      
*/

endinterface : apb_if27

