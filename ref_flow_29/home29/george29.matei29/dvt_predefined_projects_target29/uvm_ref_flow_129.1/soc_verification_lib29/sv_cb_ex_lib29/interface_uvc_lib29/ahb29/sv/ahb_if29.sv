// IVB29 checksum29: 876316374
/*-----------------------------------------------------------------
File29 name     : ahb_if29.sv
Created29       : Wed29 May29 19 15:42:20 2010
Description29   :
Notes29         :
-----------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


interface ahb_if29 (input ahb_clock29, input ahb_resetn29 );

  // Import29 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB29-NOTE29 : REQUIRED29 : OVC29 signal29 definitions29 : signals29 definitions29
   -------------------------------------------------------------------------
   Adjust29 the signal29 names and add any necessary29 signals29.
   Note29 that if you change a signal29 name, you must change it in all of your29
   OVC29 files.
   ***************************************************************************/


   // Clock29 source29 (in)
   logic AHB_HCLK29;
   // Transfer29 kind (out)
   logic [1:0] AHB_HTRANS29;
   // Burst kind (out)
   logic [2:0] AHB_HBURST29;
   // Transfer29 size (out)
   logic [2:0] AHB_HSIZE29;
   // Transfer29 direction29 (out)
   logic AHB_HWRITE29;
   // Protection29 control29 (out)
   logic [3:0] AHB_HPROT29;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH29-1:0] AHB_HADDR29;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH29-1:0] AHB_HWDATA29;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH29-1:0] AHB_HRDATA29;
   // Bus29 grant (in)
   logic AHB_HGRANT29;
   // Slave29 is ready (in)
   logic AHB_HREADY29;
   // Locked29 transfer29 request (out)
   logic AHB_HLOCK29;
   // Bus29 request	(out)
   logic AHB_HBUSREQ29;
   // Reset29 (in)
   logic AHB_HRESET29;
   // Transfer29 response (in)
   logic [1:0] AHB_HRESP29;

  
  // Control29 flags29
  bit has_checks29 = 1;
  bit has_coverage = 1;

  // Coverage29 and assertions29 to be implemented here29
  /***************************************************************************
   IVB29-NOTE29 : REQUIRED29 : Assertion29 checks29 : Interface29
   -------------------------------------------------------------------------
   Add assertion29 checks29 as required29.
   ***************************************************************************/

  // SVA29 default clocking
  wire uvm_assert_clk29 = ahb_clock29 && has_checks29;
  default clocking master_clk29 @(negedge uvm_assert_clk29);
  endclocking

  // SVA29 Default reset
  default disable iff (ahb_resetn29);


endinterface : ahb_if29

