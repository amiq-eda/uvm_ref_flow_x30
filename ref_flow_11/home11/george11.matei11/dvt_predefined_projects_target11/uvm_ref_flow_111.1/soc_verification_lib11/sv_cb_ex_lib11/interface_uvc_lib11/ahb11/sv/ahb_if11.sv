// IVB11 checksum11: 876316374
/*-----------------------------------------------------------------
File11 name     : ahb_if11.sv
Created11       : Wed11 May11 19 15:42:20 2010
Description11   :
Notes11         :
-----------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


interface ahb_if11 (input ahb_clock11, input ahb_resetn11 );

  // Import11 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB11-NOTE11 : REQUIRED11 : OVC11 signal11 definitions11 : signals11 definitions11
   -------------------------------------------------------------------------
   Adjust11 the signal11 names and add any necessary11 signals11.
   Note11 that if you change a signal11 name, you must change it in all of your11
   OVC11 files.
   ***************************************************************************/


   // Clock11 source11 (in)
   logic AHB_HCLK11;
   // Transfer11 kind (out)
   logic [1:0] AHB_HTRANS11;
   // Burst kind (out)
   logic [2:0] AHB_HBURST11;
   // Transfer11 size (out)
   logic [2:0] AHB_HSIZE11;
   // Transfer11 direction11 (out)
   logic AHB_HWRITE11;
   // Protection11 control11 (out)
   logic [3:0] AHB_HPROT11;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH11-1:0] AHB_HADDR11;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH11-1:0] AHB_HWDATA11;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH11-1:0] AHB_HRDATA11;
   // Bus11 grant (in)
   logic AHB_HGRANT11;
   // Slave11 is ready (in)
   logic AHB_HREADY11;
   // Locked11 transfer11 request (out)
   logic AHB_HLOCK11;
   // Bus11 request	(out)
   logic AHB_HBUSREQ11;
   // Reset11 (in)
   logic AHB_HRESET11;
   // Transfer11 response (in)
   logic [1:0] AHB_HRESP11;

  
  // Control11 flags11
  bit has_checks11 = 1;
  bit has_coverage = 1;

  // Coverage11 and assertions11 to be implemented here11
  /***************************************************************************
   IVB11-NOTE11 : REQUIRED11 : Assertion11 checks11 : Interface11
   -------------------------------------------------------------------------
   Add assertion11 checks11 as required11.
   ***************************************************************************/

  // SVA11 default clocking
  wire uvm_assert_clk11 = ahb_clock11 && has_checks11;
  default clocking master_clk11 @(negedge uvm_assert_clk11);
  endclocking

  // SVA11 Default reset
  default disable iff (ahb_resetn11);


endinterface : ahb_if11

