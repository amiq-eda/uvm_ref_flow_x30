/******************************************************************************

  FILE : apb_slave_if12.sv

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


interface apb_slave_if12(input pclock12, preset12);
  // Actual12 Signals12
   parameter         PADDR_WIDTH12  = 32;
   parameter         PWDATA_WIDTH12 = 32;
   parameter         PRDATA_WIDTH12 = 32;

  // Control12 flags12
  bit                has_checks12 = 1;
  bit                has_coverage = 1;

  // Actual12 Signals12
  //wire logic              pclock12;
  //wire logic              preset12;
  wire logic       [PADDR_WIDTH12-1:0] paddr12;
  wire logic              prwd12;
  wire logic       [PWDATA_WIDTH12-1:0] pwdata12;
  wire logic              psel12;
  wire logic              penable12;

  logic        [PRDATA_WIDTH12-1:0] prdata12;
  logic              pslverr12;
  logic              pready12;

  // Coverage12 and assertions12 to be implegmented12 here12.

/*  fix12 to make concurrent12 assertions12
always @(posedge pclock12)
begin

// Pready12 must not be X or Z12
assertPreadyUnknown12:assert property (
                  disable iff(!has_checks12) 
                  (!($isunknown(pready12))))
                  else
                    $error("ERR_APB100_PREADY_XZ12\n Pready12 went12 to X or Z12");


// Pslverr12 must not be X or Z12
assertPslverrUnknown12:assert property (
                  disable iff(!has_checks12) 
                  ((psel12 == 1'b0 or pready12 == 1'b0 or !($isunknown(pslverr12)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ12\n Pslverr12 went12 to X or Z12 when responding12");


// Prdata12 must not be X or Z12
assertPrdataUnknown12:assert property (
                  disable iff(!has_checks12) 
                  ((psel12 == 1'b0 or pready12 == 0 or prwd12 == 0 or !($isunknown(prdata12)))))
                  else
                  $error("ERR_APB102_XZ12\n Prdata12 went12 to X or Z12 when responding12 to a read transfer12");



end

   // EACH12 SLAVE12 HAS12 ITS12 OWN12 PSEL12 LINES12 FOR12 WHICH12 THE12 APB12 ABV12 VIP12 Checker12 can be run on.
`include "apb_checker12.sv"
*/

endinterface : apb_slave_if12

