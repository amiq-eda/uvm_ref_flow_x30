// IVB7 checksum7: 876316374
/*-----------------------------------------------------------------
File7 name     : ahb_if7.sv
Created7       : Wed7 May7 19 15:42:20 2010
Description7   :
Notes7         :
-----------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


interface ahb_if7 (input ahb_clock7, input ahb_resetn7 );

  // Import7 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB7-NOTE7 : REQUIRED7 : OVC7 signal7 definitions7 : signals7 definitions7
   -------------------------------------------------------------------------
   Adjust7 the signal7 names and add any necessary7 signals7.
   Note7 that if you change a signal7 name, you must change it in all of your7
   OVC7 files.
   ***************************************************************************/


   // Clock7 source7 (in)
   logic AHB_HCLK7;
   // Transfer7 kind (out)
   logic [1:0] AHB_HTRANS7;
   // Burst kind (out)
   logic [2:0] AHB_HBURST7;
   // Transfer7 size (out)
   logic [2:0] AHB_HSIZE7;
   // Transfer7 direction7 (out)
   logic AHB_HWRITE7;
   // Protection7 control7 (out)
   logic [3:0] AHB_HPROT7;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH7-1:0] AHB_HADDR7;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH7-1:0] AHB_HWDATA7;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH7-1:0] AHB_HRDATA7;
   // Bus7 grant (in)
   logic AHB_HGRANT7;
   // Slave7 is ready (in)
   logic AHB_HREADY7;
   // Locked7 transfer7 request (out)
   logic AHB_HLOCK7;
   // Bus7 request	(out)
   logic AHB_HBUSREQ7;
   // Reset7 (in)
   logic AHB_HRESET7;
   // Transfer7 response (in)
   logic [1:0] AHB_HRESP7;

  
  // Control7 flags7
  bit has_checks7 = 1;
  bit has_coverage = 1;

  // Coverage7 and assertions7 to be implemented here7
  /***************************************************************************
   IVB7-NOTE7 : REQUIRED7 : Assertion7 checks7 : Interface7
   -------------------------------------------------------------------------
   Add assertion7 checks7 as required7.
   ***************************************************************************/

  // SVA7 default clocking
  wire uvm_assert_clk7 = ahb_clock7 && has_checks7;
  default clocking master_clk7 @(negedge uvm_assert_clk7);
  endclocking

  // SVA7 Default reset
  default disable iff (ahb_resetn7);


endinterface : ahb_if7

