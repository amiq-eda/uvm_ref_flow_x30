// IVB13 checksum13: 876316374
/*-----------------------------------------------------------------
File13 name     : ahb_if13.sv
Created13       : Wed13 May13 19 15:42:20 2010
Description13   :
Notes13         :
-----------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


interface ahb_if13 (input ahb_clock13, input ahb_resetn13 );

  // Import13 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB13-NOTE13 : REQUIRED13 : OVC13 signal13 definitions13 : signals13 definitions13
   -------------------------------------------------------------------------
   Adjust13 the signal13 names and add any necessary13 signals13.
   Note13 that if you change a signal13 name, you must change it in all of your13
   OVC13 files.
   ***************************************************************************/


   // Clock13 source13 (in)
   logic AHB_HCLK13;
   // Transfer13 kind (out)
   logic [1:0] AHB_HTRANS13;
   // Burst kind (out)
   logic [2:0] AHB_HBURST13;
   // Transfer13 size (out)
   logic [2:0] AHB_HSIZE13;
   // Transfer13 direction13 (out)
   logic AHB_HWRITE13;
   // Protection13 control13 (out)
   logic [3:0] AHB_HPROT13;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH13-1:0] AHB_HADDR13;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH13-1:0] AHB_HWDATA13;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH13-1:0] AHB_HRDATA13;
   // Bus13 grant (in)
   logic AHB_HGRANT13;
   // Slave13 is ready (in)
   logic AHB_HREADY13;
   // Locked13 transfer13 request (out)
   logic AHB_HLOCK13;
   // Bus13 request	(out)
   logic AHB_HBUSREQ13;
   // Reset13 (in)
   logic AHB_HRESET13;
   // Transfer13 response (in)
   logic [1:0] AHB_HRESP13;

  
  // Control13 flags13
  bit has_checks13 = 1;
  bit has_coverage = 1;

  // Coverage13 and assertions13 to be implemented here13
  /***************************************************************************
   IVB13-NOTE13 : REQUIRED13 : Assertion13 checks13 : Interface13
   -------------------------------------------------------------------------
   Add assertion13 checks13 as required13.
   ***************************************************************************/

  // SVA13 default clocking
  wire uvm_assert_clk13 = ahb_clock13 && has_checks13;
  default clocking master_clk13 @(negedge uvm_assert_clk13);
  endclocking

  // SVA13 Default reset
  default disable iff (ahb_resetn13);


endinterface : ahb_if13

