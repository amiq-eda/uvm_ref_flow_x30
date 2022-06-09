// IVB27 checksum27: 876316374
/*-----------------------------------------------------------------
File27 name     : ahb_if27.sv
Created27       : Wed27 May27 19 15:42:20 2010
Description27   :
Notes27         :
-----------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


interface ahb_if27 (input ahb_clock27, input ahb_resetn27 );

  // Import27 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB27-NOTE27 : REQUIRED27 : OVC27 signal27 definitions27 : signals27 definitions27
   -------------------------------------------------------------------------
   Adjust27 the signal27 names and add any necessary27 signals27.
   Note27 that if you change a signal27 name, you must change it in all of your27
   OVC27 files.
   ***************************************************************************/


   // Clock27 source27 (in)
   logic AHB_HCLK27;
   // Transfer27 kind (out)
   logic [1:0] AHB_HTRANS27;
   // Burst kind (out)
   logic [2:0] AHB_HBURST27;
   // Transfer27 size (out)
   logic [2:0] AHB_HSIZE27;
   // Transfer27 direction27 (out)
   logic AHB_HWRITE27;
   // Protection27 control27 (out)
   logic [3:0] AHB_HPROT27;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH27-1:0] AHB_HADDR27;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH27-1:0] AHB_HWDATA27;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH27-1:0] AHB_HRDATA27;
   // Bus27 grant (in)
   logic AHB_HGRANT27;
   // Slave27 is ready (in)
   logic AHB_HREADY27;
   // Locked27 transfer27 request (out)
   logic AHB_HLOCK27;
   // Bus27 request	(out)
   logic AHB_HBUSREQ27;
   // Reset27 (in)
   logic AHB_HRESET27;
   // Transfer27 response (in)
   logic [1:0] AHB_HRESP27;

  
  // Control27 flags27
  bit has_checks27 = 1;
  bit has_coverage = 1;

  // Coverage27 and assertions27 to be implemented here27
  /***************************************************************************
   IVB27-NOTE27 : REQUIRED27 : Assertion27 checks27 : Interface27
   -------------------------------------------------------------------------
   Add assertion27 checks27 as required27.
   ***************************************************************************/

  // SVA27 default clocking
  wire uvm_assert_clk27 = ahb_clock27 && has_checks27;
  default clocking master_clk27 @(negedge uvm_assert_clk27);
  endclocking

  // SVA27 Default reset
  default disable iff (ahb_resetn27);


endinterface : ahb_if27

