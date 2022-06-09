// IVB10 checksum10: 876316374
/*-----------------------------------------------------------------
File10 name     : ahb_if10.sv
Created10       : Wed10 May10 19 15:42:20 2010
Description10   :
Notes10         :
-----------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


interface ahb_if10 (input ahb_clock10, input ahb_resetn10 );

  // Import10 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB10-NOTE10 : REQUIRED10 : OVC10 signal10 definitions10 : signals10 definitions10
   -------------------------------------------------------------------------
   Adjust10 the signal10 names and add any necessary10 signals10.
   Note10 that if you change a signal10 name, you must change it in all of your10
   OVC10 files.
   ***************************************************************************/


   // Clock10 source10 (in)
   logic AHB_HCLK10;
   // Transfer10 kind (out)
   logic [1:0] AHB_HTRANS10;
   // Burst kind (out)
   logic [2:0] AHB_HBURST10;
   // Transfer10 size (out)
   logic [2:0] AHB_HSIZE10;
   // Transfer10 direction10 (out)
   logic AHB_HWRITE10;
   // Protection10 control10 (out)
   logic [3:0] AHB_HPROT10;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH10-1:0] AHB_HADDR10;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH10-1:0] AHB_HWDATA10;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH10-1:0] AHB_HRDATA10;
   // Bus10 grant (in)
   logic AHB_HGRANT10;
   // Slave10 is ready (in)
   logic AHB_HREADY10;
   // Locked10 transfer10 request (out)
   logic AHB_HLOCK10;
   // Bus10 request	(out)
   logic AHB_HBUSREQ10;
   // Reset10 (in)
   logic AHB_HRESET10;
   // Transfer10 response (in)
   logic [1:0] AHB_HRESP10;

  
  // Control10 flags10
  bit has_checks10 = 1;
  bit has_coverage = 1;

  // Coverage10 and assertions10 to be implemented here10
  /***************************************************************************
   IVB10-NOTE10 : REQUIRED10 : Assertion10 checks10 : Interface10
   -------------------------------------------------------------------------
   Add assertion10 checks10 as required10.
   ***************************************************************************/

  // SVA10 default clocking
  wire uvm_assert_clk10 = ahb_clock10 && has_checks10;
  default clocking master_clk10 @(negedge uvm_assert_clk10);
  endclocking

  // SVA10 Default reset
  default disable iff (ahb_resetn10);


endinterface : ahb_if10

