// IVB8 checksum8: 876316374
/*-----------------------------------------------------------------
File8 name     : ahb_if8.sv
Created8       : Wed8 May8 19 15:42:20 2010
Description8   :
Notes8         :
-----------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


interface ahb_if8 (input ahb_clock8, input ahb_resetn8 );

  // Import8 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB8-NOTE8 : REQUIRED8 : OVC8 signal8 definitions8 : signals8 definitions8
   -------------------------------------------------------------------------
   Adjust8 the signal8 names and add any necessary8 signals8.
   Note8 that if you change a signal8 name, you must change it in all of your8
   OVC8 files.
   ***************************************************************************/


   // Clock8 source8 (in)
   logic AHB_HCLK8;
   // Transfer8 kind (out)
   logic [1:0] AHB_HTRANS8;
   // Burst kind (out)
   logic [2:0] AHB_HBURST8;
   // Transfer8 size (out)
   logic [2:0] AHB_HSIZE8;
   // Transfer8 direction8 (out)
   logic AHB_HWRITE8;
   // Protection8 control8 (out)
   logic [3:0] AHB_HPROT8;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH8-1:0] AHB_HADDR8;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH8-1:0] AHB_HWDATA8;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH8-1:0] AHB_HRDATA8;
   // Bus8 grant (in)
   logic AHB_HGRANT8;
   // Slave8 is ready (in)
   logic AHB_HREADY8;
   // Locked8 transfer8 request (out)
   logic AHB_HLOCK8;
   // Bus8 request	(out)
   logic AHB_HBUSREQ8;
   // Reset8 (in)
   logic AHB_HRESET8;
   // Transfer8 response (in)
   logic [1:0] AHB_HRESP8;

  
  // Control8 flags8
  bit has_checks8 = 1;
  bit has_coverage = 1;

  // Coverage8 and assertions8 to be implemented here8
  /***************************************************************************
   IVB8-NOTE8 : REQUIRED8 : Assertion8 checks8 : Interface8
   -------------------------------------------------------------------------
   Add assertion8 checks8 as required8.
   ***************************************************************************/

  // SVA8 default clocking
  wire uvm_assert_clk8 = ahb_clock8 && has_checks8;
  default clocking master_clk8 @(negedge uvm_assert_clk8);
  endclocking

  // SVA8 Default reset
  default disable iff (ahb_resetn8);


endinterface : ahb_if8

