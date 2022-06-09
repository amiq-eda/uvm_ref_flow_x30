// IVB19 checksum19: 876316374
/*-----------------------------------------------------------------
File19 name     : ahb_if19.sv
Created19       : Wed19 May19 19 15:42:20 2010
Description19   :
Notes19         :
-----------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


interface ahb_if19 (input ahb_clock19, input ahb_resetn19 );

  // Import19 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB19-NOTE19 : REQUIRED19 : OVC19 signal19 definitions19 : signals19 definitions19
   -------------------------------------------------------------------------
   Adjust19 the signal19 names and add any necessary19 signals19.
   Note19 that if you change a signal19 name, you must change it in all of your19
   OVC19 files.
   ***************************************************************************/


   // Clock19 source19 (in)
   logic AHB_HCLK19;
   // Transfer19 kind (out)
   logic [1:0] AHB_HTRANS19;
   // Burst kind (out)
   logic [2:0] AHB_HBURST19;
   // Transfer19 size (out)
   logic [2:0] AHB_HSIZE19;
   // Transfer19 direction19 (out)
   logic AHB_HWRITE19;
   // Protection19 control19 (out)
   logic [3:0] AHB_HPROT19;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH19-1:0] AHB_HADDR19;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH19-1:0] AHB_HWDATA19;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH19-1:0] AHB_HRDATA19;
   // Bus19 grant (in)
   logic AHB_HGRANT19;
   // Slave19 is ready (in)
   logic AHB_HREADY19;
   // Locked19 transfer19 request (out)
   logic AHB_HLOCK19;
   // Bus19 request	(out)
   logic AHB_HBUSREQ19;
   // Reset19 (in)
   logic AHB_HRESET19;
   // Transfer19 response (in)
   logic [1:0] AHB_HRESP19;

  
  // Control19 flags19
  bit has_checks19 = 1;
  bit has_coverage = 1;

  // Coverage19 and assertions19 to be implemented here19
  /***************************************************************************
   IVB19-NOTE19 : REQUIRED19 : Assertion19 checks19 : Interface19
   -------------------------------------------------------------------------
   Add assertion19 checks19 as required19.
   ***************************************************************************/

  // SVA19 default clocking
  wire uvm_assert_clk19 = ahb_clock19 && has_checks19;
  default clocking master_clk19 @(negedge uvm_assert_clk19);
  endclocking

  // SVA19 Default reset
  default disable iff (ahb_resetn19);


endinterface : ahb_if19

