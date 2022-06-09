// IVB17 checksum17: 876316374
/*-----------------------------------------------------------------
File17 name     : ahb_if17.sv
Created17       : Wed17 May17 19 15:42:20 2010
Description17   :
Notes17         :
-----------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


interface ahb_if17 (input ahb_clock17, input ahb_resetn17 );

  // Import17 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB17-NOTE17 : REQUIRED17 : OVC17 signal17 definitions17 : signals17 definitions17
   -------------------------------------------------------------------------
   Adjust17 the signal17 names and add any necessary17 signals17.
   Note17 that if you change a signal17 name, you must change it in all of your17
   OVC17 files.
   ***************************************************************************/


   // Clock17 source17 (in)
   logic AHB_HCLK17;
   // Transfer17 kind (out)
   logic [1:0] AHB_HTRANS17;
   // Burst kind (out)
   logic [2:0] AHB_HBURST17;
   // Transfer17 size (out)
   logic [2:0] AHB_HSIZE17;
   // Transfer17 direction17 (out)
   logic AHB_HWRITE17;
   // Protection17 control17 (out)
   logic [3:0] AHB_HPROT17;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH17-1:0] AHB_HADDR17;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH17-1:0] AHB_HWDATA17;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH17-1:0] AHB_HRDATA17;
   // Bus17 grant (in)
   logic AHB_HGRANT17;
   // Slave17 is ready (in)
   logic AHB_HREADY17;
   // Locked17 transfer17 request (out)
   logic AHB_HLOCK17;
   // Bus17 request	(out)
   logic AHB_HBUSREQ17;
   // Reset17 (in)
   logic AHB_HRESET17;
   // Transfer17 response (in)
   logic [1:0] AHB_HRESP17;

  
  // Control17 flags17
  bit has_checks17 = 1;
  bit has_coverage = 1;

  // Coverage17 and assertions17 to be implemented here17
  /***************************************************************************
   IVB17-NOTE17 : REQUIRED17 : Assertion17 checks17 : Interface17
   -------------------------------------------------------------------------
   Add assertion17 checks17 as required17.
   ***************************************************************************/

  // SVA17 default clocking
  wire uvm_assert_clk17 = ahb_clock17 && has_checks17;
  default clocking master_clk17 @(negedge uvm_assert_clk17);
  endclocking

  // SVA17 Default reset
  default disable iff (ahb_resetn17);


endinterface : ahb_if17

