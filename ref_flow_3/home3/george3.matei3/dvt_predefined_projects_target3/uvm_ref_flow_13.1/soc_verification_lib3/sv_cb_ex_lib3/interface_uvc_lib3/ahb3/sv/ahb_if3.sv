// IVB3 checksum3: 876316374
/*-----------------------------------------------------------------
File3 name     : ahb_if3.sv
Created3       : Wed3 May3 19 15:42:20 2010
Description3   :
Notes3         :
-----------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


interface ahb_if3 (input ahb_clock3, input ahb_resetn3 );

  // Import3 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB3-NOTE3 : REQUIRED3 : OVC3 signal3 definitions3 : signals3 definitions3
   -------------------------------------------------------------------------
   Adjust3 the signal3 names and add any necessary3 signals3.
   Note3 that if you change a signal3 name, you must change it in all of your3
   OVC3 files.
   ***************************************************************************/


   // Clock3 source3 (in)
   logic AHB_HCLK3;
   // Transfer3 kind (out)
   logic [1:0] AHB_HTRANS3;
   // Burst kind (out)
   logic [2:0] AHB_HBURST3;
   // Transfer3 size (out)
   logic [2:0] AHB_HSIZE3;
   // Transfer3 direction3 (out)
   logic AHB_HWRITE3;
   // Protection3 control3 (out)
   logic [3:0] AHB_HPROT3;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH3-1:0] AHB_HADDR3;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH3-1:0] AHB_HWDATA3;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH3-1:0] AHB_HRDATA3;
   // Bus3 grant (in)
   logic AHB_HGRANT3;
   // Slave3 is ready (in)
   logic AHB_HREADY3;
   // Locked3 transfer3 request (out)
   logic AHB_HLOCK3;
   // Bus3 request	(out)
   logic AHB_HBUSREQ3;
   // Reset3 (in)
   logic AHB_HRESET3;
   // Transfer3 response (in)
   logic [1:0] AHB_HRESP3;

  
  // Control3 flags3
  bit has_checks3 = 1;
  bit has_coverage = 1;

  // Coverage3 and assertions3 to be implemented here3
  /***************************************************************************
   IVB3-NOTE3 : REQUIRED3 : Assertion3 checks3 : Interface3
   -------------------------------------------------------------------------
   Add assertion3 checks3 as required3.
   ***************************************************************************/

  // SVA3 default clocking
  wire uvm_assert_clk3 = ahb_clock3 && has_checks3;
  default clocking master_clk3 @(negedge uvm_assert_clk3);
  endclocking

  // SVA3 Default reset
  default disable iff (ahb_resetn3);


endinterface : ahb_if3

