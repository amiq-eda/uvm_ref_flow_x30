/******************************************************************************
  FILE : apb_master_if23.sv
 ******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

interface apb_master_if23 (input pclock23,
                         input preset23);

  parameter         PADDR_WIDTH23  = 32;
  parameter         PWDATA_WIDTH23 = 32;
  parameter         PRDATA_WIDTH23 = 32;

  // Actual23 Signals23
  logic [PADDR_WIDTH23-1:0]  paddr23;
  logic                    prwd23;
  logic [PWDATA_WIDTH23-1:0] pwdata23;
  logic                    penable23;
  logic                    pready23;
  logic [15:0]             psel23;
  logic [PRDATA_WIDTH23-1:0] prdata23;
  wire logic               pslverr23;

  // UART23 Interrupt23 signal23
  logic       ua_int23;

  logic [31:0] gp_int23;

  // Control23 flags23
  bit                has_checks23 = 1;
  bit                has_coverage = 1;

// Coverage23 and assertions23 to be implemented here23.

/* NEEDS23 TO BE23 UPDATED23 TO CONCURRENT23 ASSERTIONS23
always @(posedge pclock23)
begin

// PADDR23 must not be X or Z23 when PSEL23 is asserted23
assertPAddrUnknown23:assert property (
                  disable iff(!has_checks23 || !preset23)
                  (psel23 == 0 or !$isunknown(paddr23)))
                  else
                    $error("ERR_APB001_PADDR_XZ23\n PADDR23 went23 to X or Z23 \
                            when PSEL23 is asserted23");

// PRWD23 must not be X or Z23 when PSEL23 is asserted23
assertPRwdUnknown23:assert property ( 
                  disable iff(!has_checks23 || !preset23)
                  (psel23 == 0 or !$isunknown(prwd23)))
                  else
                    $error("ERR_APB002_PRWD_XZ23\n PRWD23 went23 to X or Z23 \
                            when PSEL23 is asserted23");

// PWDATA23 must not be X or Z23 during a data transfer23
assertPWdataUnknown23:assert property ( 
                   disable iff(!has_checks23 || !preset23)
                   (psel23 == 0 or prwd23 == 0 or !$isunknown(pwdata23)))
                   else
                     $error("ERR_APB003_PWDATA_XZ23\n PWDATA23 went23 to X or Z23 \
                             during a write transfer23");

// PENABLE23 must not be X or Z23
assertPEnableUnknown23:assert property ( 
                  disable iff(!has_checks23 || !preset23)
                  (!$isunknown(penable23)))
                  else
                    $error("ERR_APB004_PENABLE_XZ23\n PENABLE23 went23 to X or Z23");

// PSEL23 must not be X or Z23
assertPSelUnknown23:assert property ( 
                  disable iff(!has_checks23 || !preset23)
                  (!$isunknown(psel23)))
                  else
                    $error("ERR_APB005_PSEL_XZ23\n PSEL23 went23 to X or Z23");

end // always @ (posedge pclock23)
*/
      
endinterface : apb_master_if23
