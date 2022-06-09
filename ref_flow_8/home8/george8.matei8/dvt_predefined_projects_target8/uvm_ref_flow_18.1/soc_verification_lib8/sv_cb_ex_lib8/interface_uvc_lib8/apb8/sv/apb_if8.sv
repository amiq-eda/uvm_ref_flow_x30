/******************************************************************************
  FILE : apb_if8.sv
 ******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


interface apb_if8 (input pclock8, input preset8);

  parameter         PADDR_WIDTH8  = 32;
  parameter         PWDATA_WIDTH8 = 32;
  parameter         PRDATA_WIDTH8 = 32;

  // Actual8 Signals8
  logic [PADDR_WIDTH8-1:0]  paddr8;
  logic                    prwd8;
  logic [PWDATA_WIDTH8-1:0] pwdata8;
  logic                    penable8;
  logic [15:0]             psel8;
  logic [PRDATA_WIDTH8-1:0] prdata8;
  logic               pslverr8;
  logic               pready8;

  // UART8 Interrupt8 signal8
  //logic       ua_int8;

  // Control8 flags8
  bit                has_checks8 = 1;
  bit                has_coverage = 1;

// Coverage8 and assertions8 to be implemented here8.

/*  KAM8: needs8 update to concurrent8 assertions8 syntax8
always @(posedge pclock8)
begin

// PADDR8 must not be X or Z8 when PSEL8 is asserted8
assertPAddrUnknown8:assert property (
                  disable iff(!has_checks8) 
                  (psel8 == 0 or !$isunknown(paddr8)))
                  else
                    $error("ERR_APB001_PADDR_XZ8\n PADDR8 went8 to X or Z8 \
                            when PSEL8 is asserted8");

// PRWD8 must not be X or Z8 when PSEL8 is asserted8
assertPRwdUnknown8:assert property ( 
                  disable iff(!has_checks8) 
                  (psel8 == 0 or !$isunknown(prwd8)))
                  else
                    $error("ERR_APB002_PRWD_XZ8\n PRWD8 went8 to X or Z8 \
                            when PSEL8 is asserted8");

// PWDATA8 must not be X or Z8 during a data transfer8
assertPWdataUnknown8:assert property ( 
                   disable iff(!has_checks8) 
                   (psel8 == 0 or prwd8 == 0 or !$isunknown(pwdata8)))
                   else
                     $error("ERR_APB003_PWDATA_XZ8\n PWDATA8 went8 to X or Z8 \
                             during a write transfer8");

// PENABLE8 must not be X or Z8
assertPEnableUnknown8:assert property ( 
                  disable iff(!has_checks8) 
                  (!$isunknown(penable8)))
                  else
                    $error("ERR_APB004_PENABLE_XZ8\n PENABLE8 went8 to X or Z8");

// PSEL8 must not be X or Z8
assertPSelUnknown8:assert property ( 
                  disable iff(!has_checks8) 
                  (!$isunknown(psel8)))
                  else
                    $error("ERR_APB005_PSEL_XZ8\n PSEL8 went8 to X or Z8");

// Pslverr8 must not be X or Z8
assertPslverrUnknown8:assert property (
                  disable iff(!has_checks8) 
                  ((psel8[0] == 1'b0 or pready8 == 1'b0 or !($isunknown(pslverr8)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ8\n Pslverr8 went8 to X or Z8 when responding8");


// Prdata8 must not be X or Z8
assertPrdataUnknown8:assert property (
                  disable iff(!has_checks8) 
                  ((psel8[0] == 1'b0 or pready8 == 0 or prwd8 == 0 or !($isunknown(prdata8)))))
                  else
                  $error("ERR_APB102_XZ8\n Prdata8 went8 to X or Z8 when responding8 to a read transfer8");

end // always @ (posedge pclock8)
      
*/

endinterface : apb_if8

