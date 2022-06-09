/******************************************************************************
  FILE : apb_master_if18.sv
 ******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

interface apb_master_if18 (input pclock18,
                         input preset18);

  parameter         PADDR_WIDTH18  = 32;
  parameter         PWDATA_WIDTH18 = 32;
  parameter         PRDATA_WIDTH18 = 32;

  // Actual18 Signals18
  logic [PADDR_WIDTH18-1:0]  paddr18;
  logic                    prwd18;
  logic [PWDATA_WIDTH18-1:0] pwdata18;
  logic                    penable18;
  logic                    pready18;
  logic [15:0]             psel18;
  logic [PRDATA_WIDTH18-1:0] prdata18;
  wire logic               pslverr18;

  // UART18 Interrupt18 signal18
  logic       ua_int18;

  logic [31:0] gp_int18;

  // Control18 flags18
  bit                has_checks18 = 1;
  bit                has_coverage = 1;

// Coverage18 and assertions18 to be implemented here18.

/* NEEDS18 TO BE18 UPDATED18 TO CONCURRENT18 ASSERTIONS18
always @(posedge pclock18)
begin

// PADDR18 must not be X or Z18 when PSEL18 is asserted18
assertPAddrUnknown18:assert property (
                  disable iff(!has_checks18 || !preset18)
                  (psel18 == 0 or !$isunknown(paddr18)))
                  else
                    $error("ERR_APB001_PADDR_XZ18\n PADDR18 went18 to X or Z18 \
                            when PSEL18 is asserted18");

// PRWD18 must not be X or Z18 when PSEL18 is asserted18
assertPRwdUnknown18:assert property ( 
                  disable iff(!has_checks18 || !preset18)
                  (psel18 == 0 or !$isunknown(prwd18)))
                  else
                    $error("ERR_APB002_PRWD_XZ18\n PRWD18 went18 to X or Z18 \
                            when PSEL18 is asserted18");

// PWDATA18 must not be X or Z18 during a data transfer18
assertPWdataUnknown18:assert property ( 
                   disable iff(!has_checks18 || !preset18)
                   (psel18 == 0 or prwd18 == 0 or !$isunknown(pwdata18)))
                   else
                     $error("ERR_APB003_PWDATA_XZ18\n PWDATA18 went18 to X or Z18 \
                             during a write transfer18");

// PENABLE18 must not be X or Z18
assertPEnableUnknown18:assert property ( 
                  disable iff(!has_checks18 || !preset18)
                  (!$isunknown(penable18)))
                  else
                    $error("ERR_APB004_PENABLE_XZ18\n PENABLE18 went18 to X or Z18");

// PSEL18 must not be X or Z18
assertPSelUnknown18:assert property ( 
                  disable iff(!has_checks18 || !preset18)
                  (!$isunknown(psel18)))
                  else
                    $error("ERR_APB005_PSEL_XZ18\n PSEL18 went18 to X or Z18");

end // always @ (posedge pclock18)
*/
      
endinterface : apb_master_if18
