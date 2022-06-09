// IVB18 checksum18: 876316374
/*-----------------------------------------------------------------
File18 name     : ahb_if18.sv
Created18       : Wed18 May18 19 15:42:20 2010
Description18   :
Notes18         :
-----------------------------------------------------------------*/
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


interface ahb_if18 (input ahb_clock18, input ahb_resetn18 );

  // Import18 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB18-NOTE18 : REQUIRED18 : OVC18 signal18 definitions18 : signals18 definitions18
   -------------------------------------------------------------------------
   Adjust18 the signal18 names and add any necessary18 signals18.
   Note18 that if you change a signal18 name, you must change it in all of your18
   OVC18 files.
   ***************************************************************************/


   // Clock18 source18 (in)
   logic AHB_HCLK18;
   // Transfer18 kind (out)
   logic [1:0] AHB_HTRANS18;
   // Burst kind (out)
   logic [2:0] AHB_HBURST18;
   // Transfer18 size (out)
   logic [2:0] AHB_HSIZE18;
   // Transfer18 direction18 (out)
   logic AHB_HWRITE18;
   // Protection18 control18 (out)
   logic [3:0] AHB_HPROT18;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH18-1:0] AHB_HADDR18;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH18-1:0] AHB_HWDATA18;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH18-1:0] AHB_HRDATA18;
   // Bus18 grant (in)
   logic AHB_HGRANT18;
   // Slave18 is ready (in)
   logic AHB_HREADY18;
   // Locked18 transfer18 request (out)
   logic AHB_HLOCK18;
   // Bus18 request	(out)
   logic AHB_HBUSREQ18;
   // Reset18 (in)
   logic AHB_HRESET18;
   // Transfer18 response (in)
   logic [1:0] AHB_HRESP18;

  
  // Control18 flags18
  bit has_checks18 = 1;
  bit has_coverage = 1;

  // Coverage18 and assertions18 to be implemented here18
  /***************************************************************************
   IVB18-NOTE18 : REQUIRED18 : Assertion18 checks18 : Interface18
   -------------------------------------------------------------------------
   Add assertion18 checks18 as required18.
   ***************************************************************************/

  // SVA18 default clocking
  wire uvm_assert_clk18 = ahb_clock18 && has_checks18;
  default clocking master_clk18 @(negedge uvm_assert_clk18);
  endclocking

  // SVA18 Default reset
  default disable iff (ahb_resetn18);


endinterface : ahb_if18

