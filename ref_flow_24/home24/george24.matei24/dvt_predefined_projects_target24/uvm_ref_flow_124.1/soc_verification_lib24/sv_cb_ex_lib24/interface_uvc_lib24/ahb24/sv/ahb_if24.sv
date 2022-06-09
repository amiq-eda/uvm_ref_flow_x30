// IVB24 checksum24: 876316374
/*-----------------------------------------------------------------
File24 name     : ahb_if24.sv
Created24       : Wed24 May24 19 15:42:20 2010
Description24   :
Notes24         :
-----------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


interface ahb_if24 (input ahb_clock24, input ahb_resetn24 );

  // Import24 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB24-NOTE24 : REQUIRED24 : OVC24 signal24 definitions24 : signals24 definitions24
   -------------------------------------------------------------------------
   Adjust24 the signal24 names and add any necessary24 signals24.
   Note24 that if you change a signal24 name, you must change it in all of your24
   OVC24 files.
   ***************************************************************************/


   // Clock24 source24 (in)
   logic AHB_HCLK24;
   // Transfer24 kind (out)
   logic [1:0] AHB_HTRANS24;
   // Burst kind (out)
   logic [2:0] AHB_HBURST24;
   // Transfer24 size (out)
   logic [2:0] AHB_HSIZE24;
   // Transfer24 direction24 (out)
   logic AHB_HWRITE24;
   // Protection24 control24 (out)
   logic [3:0] AHB_HPROT24;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH24-1:0] AHB_HADDR24;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH24-1:0] AHB_HWDATA24;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH24-1:0] AHB_HRDATA24;
   // Bus24 grant (in)
   logic AHB_HGRANT24;
   // Slave24 is ready (in)
   logic AHB_HREADY24;
   // Locked24 transfer24 request (out)
   logic AHB_HLOCK24;
   // Bus24 request	(out)
   logic AHB_HBUSREQ24;
   // Reset24 (in)
   logic AHB_HRESET24;
   // Transfer24 response (in)
   logic [1:0] AHB_HRESP24;

  
  // Control24 flags24
  bit has_checks24 = 1;
  bit has_coverage = 1;

  // Coverage24 and assertions24 to be implemented here24
  /***************************************************************************
   IVB24-NOTE24 : REQUIRED24 : Assertion24 checks24 : Interface24
   -------------------------------------------------------------------------
   Add assertion24 checks24 as required24.
   ***************************************************************************/

  // SVA24 default clocking
  wire uvm_assert_clk24 = ahb_clock24 && has_checks24;
  default clocking master_clk24 @(negedge uvm_assert_clk24);
  endclocking

  // SVA24 Default reset
  default disable iff (ahb_resetn24);


endinterface : ahb_if24

