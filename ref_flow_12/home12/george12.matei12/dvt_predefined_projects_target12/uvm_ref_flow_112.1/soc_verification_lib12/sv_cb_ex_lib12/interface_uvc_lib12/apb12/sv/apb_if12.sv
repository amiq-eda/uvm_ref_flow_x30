/******************************************************************************
  FILE : apb_if12.sv
 ******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


interface apb_if12 (input pclock12, input preset12);

  parameter         PADDR_WIDTH12  = 32;
  parameter         PWDATA_WIDTH12 = 32;
  parameter         PRDATA_WIDTH12 = 32;

  // Actual12 Signals12
  logic [PADDR_WIDTH12-1:0]  paddr12;
  logic                    prwd12;
  logic [PWDATA_WIDTH12-1:0] pwdata12;
  logic                    penable12;
  logic [15:0]             psel12;
  logic [PRDATA_WIDTH12-1:0] prdata12;
  logic               pslverr12;
  logic               pready12;

  // UART12 Interrupt12 signal12
  //logic       ua_int12;

  // Control12 flags12
  bit                has_checks12 = 1;
  bit                has_coverage = 1;

// Coverage12 and assertions12 to be implemented here12.

/*  KAM12: needs12 update to concurrent12 assertions12 syntax12
always @(posedge pclock12)
begin

// PADDR12 must not be X or Z12 when PSEL12 is asserted12
assertPAddrUnknown12:assert property (
                  disable iff(!has_checks12) 
                  (psel12 == 0 or !$isunknown(paddr12)))
                  else
                    $error("ERR_APB001_PADDR_XZ12\n PADDR12 went12 to X or Z12 \
                            when PSEL12 is asserted12");

// PRWD12 must not be X or Z12 when PSEL12 is asserted12
assertPRwdUnknown12:assert property ( 
                  disable iff(!has_checks12) 
                  (psel12 == 0 or !$isunknown(prwd12)))
                  else
                    $error("ERR_APB002_PRWD_XZ12\n PRWD12 went12 to X or Z12 \
                            when PSEL12 is asserted12");

// PWDATA12 must not be X or Z12 during a data transfer12
assertPWdataUnknown12:assert property ( 
                   disable iff(!has_checks12) 
                   (psel12 == 0 or prwd12 == 0 or !$isunknown(pwdata12)))
                   else
                     $error("ERR_APB003_PWDATA_XZ12\n PWDATA12 went12 to X or Z12 \
                             during a write transfer12");

// PENABLE12 must not be X or Z12
assertPEnableUnknown12:assert property ( 
                  disable iff(!has_checks12) 
                  (!$isunknown(penable12)))
                  else
                    $error("ERR_APB004_PENABLE_XZ12\n PENABLE12 went12 to X or Z12");

// PSEL12 must not be X or Z12
assertPSelUnknown12:assert property ( 
                  disable iff(!has_checks12) 
                  (!$isunknown(psel12)))
                  else
                    $error("ERR_APB005_PSEL_XZ12\n PSEL12 went12 to X or Z12");

// Pslverr12 must not be X or Z12
assertPslverrUnknown12:assert property (
                  disable iff(!has_checks12) 
                  ((psel12[0] == 1'b0 or pready12 == 1'b0 or !($isunknown(pslverr12)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ12\n Pslverr12 went12 to X or Z12 when responding12");


// Prdata12 must not be X or Z12
assertPrdataUnknown12:assert property (
                  disable iff(!has_checks12) 
                  ((psel12[0] == 1'b0 or pready12 == 0 or prwd12 == 0 or !($isunknown(prdata12)))))
                  else
                  $error("ERR_APB102_XZ12\n Prdata12 went12 to X or Z12 when responding12 to a read transfer12");

end // always @ (posedge pclock12)
      
*/

endinterface : apb_if12

