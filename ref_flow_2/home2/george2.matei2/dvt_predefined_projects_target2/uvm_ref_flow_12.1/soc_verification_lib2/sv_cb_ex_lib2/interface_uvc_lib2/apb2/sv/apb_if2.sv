/******************************************************************************
  FILE : apb_if2.sv
 ******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


interface apb_if2 (input pclock2, input preset2);

  parameter         PADDR_WIDTH2  = 32;
  parameter         PWDATA_WIDTH2 = 32;
  parameter         PRDATA_WIDTH2 = 32;

  // Actual2 Signals2
  logic [PADDR_WIDTH2-1:0]  paddr2;
  logic                    prwd2;
  logic [PWDATA_WIDTH2-1:0] pwdata2;
  logic                    penable2;
  logic [15:0]             psel2;
  logic [PRDATA_WIDTH2-1:0] prdata2;
  logic               pslverr2;
  logic               pready2;

  // UART2 Interrupt2 signal2
  //logic       ua_int2;

  // Control2 flags2
  bit                has_checks2 = 1;
  bit                has_coverage = 1;

// Coverage2 and assertions2 to be implemented here2.

/*  KAM2: needs2 update to concurrent2 assertions2 syntax2
always @(posedge pclock2)
begin

// PADDR2 must not be X or Z2 when PSEL2 is asserted2
assertPAddrUnknown2:assert property (
                  disable iff(!has_checks2) 
                  (psel2 == 0 or !$isunknown(paddr2)))
                  else
                    $error("ERR_APB001_PADDR_XZ2\n PADDR2 went2 to X or Z2 \
                            when PSEL2 is asserted2");

// PRWD2 must not be X or Z2 when PSEL2 is asserted2
assertPRwdUnknown2:assert property ( 
                  disable iff(!has_checks2) 
                  (psel2 == 0 or !$isunknown(prwd2)))
                  else
                    $error("ERR_APB002_PRWD_XZ2\n PRWD2 went2 to X or Z2 \
                            when PSEL2 is asserted2");

// PWDATA2 must not be X or Z2 during a data transfer2
assertPWdataUnknown2:assert property ( 
                   disable iff(!has_checks2) 
                   (psel2 == 0 or prwd2 == 0 or !$isunknown(pwdata2)))
                   else
                     $error("ERR_APB003_PWDATA_XZ2\n PWDATA2 went2 to X or Z2 \
                             during a write transfer2");

// PENABLE2 must not be X or Z2
assertPEnableUnknown2:assert property ( 
                  disable iff(!has_checks2) 
                  (!$isunknown(penable2)))
                  else
                    $error("ERR_APB004_PENABLE_XZ2\n PENABLE2 went2 to X or Z2");

// PSEL2 must not be X or Z2
assertPSelUnknown2:assert property ( 
                  disable iff(!has_checks2) 
                  (!$isunknown(psel2)))
                  else
                    $error("ERR_APB005_PSEL_XZ2\n PSEL2 went2 to X or Z2");

// Pslverr2 must not be X or Z2
assertPslverrUnknown2:assert property (
                  disable iff(!has_checks2) 
                  ((psel2[0] == 1'b0 or pready2 == 1'b0 or !($isunknown(pslverr2)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ2\n Pslverr2 went2 to X or Z2 when responding2");


// Prdata2 must not be X or Z2
assertPrdataUnknown2:assert property (
                  disable iff(!has_checks2) 
                  ((psel2[0] == 1'b0 or pready2 == 0 or prwd2 == 0 or !($isunknown(prdata2)))))
                  else
                  $error("ERR_APB102_XZ2\n Prdata2 went2 to X or Z2 when responding2 to a read transfer2");

end // always @ (posedge pclock2)
      
*/

endinterface : apb_if2

