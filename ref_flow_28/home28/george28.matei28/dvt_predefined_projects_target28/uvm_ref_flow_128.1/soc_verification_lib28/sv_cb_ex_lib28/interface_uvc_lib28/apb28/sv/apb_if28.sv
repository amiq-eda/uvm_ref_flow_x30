/******************************************************************************
  FILE : apb_if28.sv
 ******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


interface apb_if28 (input pclock28, input preset28);

  parameter         PADDR_WIDTH28  = 32;
  parameter         PWDATA_WIDTH28 = 32;
  parameter         PRDATA_WIDTH28 = 32;

  // Actual28 Signals28
  logic [PADDR_WIDTH28-1:0]  paddr28;
  logic                    prwd28;
  logic [PWDATA_WIDTH28-1:0] pwdata28;
  logic                    penable28;
  logic [15:0]             psel28;
  logic [PRDATA_WIDTH28-1:0] prdata28;
  logic               pslverr28;
  logic               pready28;

  // UART28 Interrupt28 signal28
  //logic       ua_int28;

  // Control28 flags28
  bit                has_checks28 = 1;
  bit                has_coverage = 1;

// Coverage28 and assertions28 to be implemented here28.

/*  KAM28: needs28 update to concurrent28 assertions28 syntax28
always @(posedge pclock28)
begin

// PADDR28 must not be X or Z28 when PSEL28 is asserted28
assertPAddrUnknown28:assert property (
                  disable iff(!has_checks28) 
                  (psel28 == 0 or !$isunknown(paddr28)))
                  else
                    $error("ERR_APB001_PADDR_XZ28\n PADDR28 went28 to X or Z28 \
                            when PSEL28 is asserted28");

// PRWD28 must not be X or Z28 when PSEL28 is asserted28
assertPRwdUnknown28:assert property ( 
                  disable iff(!has_checks28) 
                  (psel28 == 0 or !$isunknown(prwd28)))
                  else
                    $error("ERR_APB002_PRWD_XZ28\n PRWD28 went28 to X or Z28 \
                            when PSEL28 is asserted28");

// PWDATA28 must not be X or Z28 during a data transfer28
assertPWdataUnknown28:assert property ( 
                   disable iff(!has_checks28) 
                   (psel28 == 0 or prwd28 == 0 or !$isunknown(pwdata28)))
                   else
                     $error("ERR_APB003_PWDATA_XZ28\n PWDATA28 went28 to X or Z28 \
                             during a write transfer28");

// PENABLE28 must not be X or Z28
assertPEnableUnknown28:assert property ( 
                  disable iff(!has_checks28) 
                  (!$isunknown(penable28)))
                  else
                    $error("ERR_APB004_PENABLE_XZ28\n PENABLE28 went28 to X or Z28");

// PSEL28 must not be X or Z28
assertPSelUnknown28:assert property ( 
                  disable iff(!has_checks28) 
                  (!$isunknown(psel28)))
                  else
                    $error("ERR_APB005_PSEL_XZ28\n PSEL28 went28 to X or Z28");

// Pslverr28 must not be X or Z28
assertPslverrUnknown28:assert property (
                  disable iff(!has_checks28) 
                  ((psel28[0] == 1'b0 or pready28 == 1'b0 or !($isunknown(pslverr28)))))
                  else  
                    $error("ERR_APB101_PSLVERR_XZ28\n Pslverr28 went28 to X or Z28 when responding28");


// Prdata28 must not be X or Z28
assertPrdataUnknown28:assert property (
                  disable iff(!has_checks28) 
                  ((psel28[0] == 1'b0 or pready28 == 0 or prwd28 == 0 or !($isunknown(prdata28)))))
                  else
                  $error("ERR_APB102_XZ28\n Prdata28 went28 to X or Z28 when responding28 to a read transfer28");

end // always @ (posedge pclock28)
      
*/

endinterface : apb_if28

