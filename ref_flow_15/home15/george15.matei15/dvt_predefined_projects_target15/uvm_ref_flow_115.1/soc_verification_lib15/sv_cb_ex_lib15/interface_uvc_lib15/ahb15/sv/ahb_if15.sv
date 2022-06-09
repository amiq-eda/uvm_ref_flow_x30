// IVB15 checksum15: 876316374
/*-----------------------------------------------------------------
File15 name     : ahb_if15.sv
Created15       : Wed15 May15 19 15:42:20 2010
Description15   :
Notes15         :
-----------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


interface ahb_if15 (input ahb_clock15, input ahb_resetn15 );

  // Import15 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB15-NOTE15 : REQUIRED15 : OVC15 signal15 definitions15 : signals15 definitions15
   -------------------------------------------------------------------------
   Adjust15 the signal15 names and add any necessary15 signals15.
   Note15 that if you change a signal15 name, you must change it in all of your15
   OVC15 files.
   ***************************************************************************/


   // Clock15 source15 (in)
   logic AHB_HCLK15;
   // Transfer15 kind (out)
   logic [1:0] AHB_HTRANS15;
   // Burst kind (out)
   logic [2:0] AHB_HBURST15;
   // Transfer15 size (out)
   logic [2:0] AHB_HSIZE15;
   // Transfer15 direction15 (out)
   logic AHB_HWRITE15;
   // Protection15 control15 (out)
   logic [3:0] AHB_HPROT15;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH15-1:0] AHB_HADDR15;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH15-1:0] AHB_HWDATA15;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH15-1:0] AHB_HRDATA15;
   // Bus15 grant (in)
   logic AHB_HGRANT15;
   // Slave15 is ready (in)
   logic AHB_HREADY15;
   // Locked15 transfer15 request (out)
   logic AHB_HLOCK15;
   // Bus15 request	(out)
   logic AHB_HBUSREQ15;
   // Reset15 (in)
   logic AHB_HRESET15;
   // Transfer15 response (in)
   logic [1:0] AHB_HRESP15;

  
  // Control15 flags15
  bit has_checks15 = 1;
  bit has_coverage = 1;

  // Coverage15 and assertions15 to be implemented here15
  /***************************************************************************
   IVB15-NOTE15 : REQUIRED15 : Assertion15 checks15 : Interface15
   -------------------------------------------------------------------------
   Add assertion15 checks15 as required15.
   ***************************************************************************/

  // SVA15 default clocking
  wire uvm_assert_clk15 = ahb_clock15 && has_checks15;
  default clocking master_clk15 @(negedge uvm_assert_clk15);
  endclocking

  // SVA15 Default reset
  default disable iff (ahb_resetn15);


endinterface : ahb_if15

