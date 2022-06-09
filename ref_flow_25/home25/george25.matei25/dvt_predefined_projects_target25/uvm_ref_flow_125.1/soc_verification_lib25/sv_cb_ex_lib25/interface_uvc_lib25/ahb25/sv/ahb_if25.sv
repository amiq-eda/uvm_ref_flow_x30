// IVB25 checksum25: 876316374
/*-----------------------------------------------------------------
File25 name     : ahb_if25.sv
Created25       : Wed25 May25 19 15:42:20 2010
Description25   :
Notes25         :
-----------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


interface ahb_if25 (input ahb_clock25, input ahb_resetn25 );

  // Import25 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB25-NOTE25 : REQUIRED25 : OVC25 signal25 definitions25 : signals25 definitions25
   -------------------------------------------------------------------------
   Adjust25 the signal25 names and add any necessary25 signals25.
   Note25 that if you change a signal25 name, you must change it in all of your25
   OVC25 files.
   ***************************************************************************/


   // Clock25 source25 (in)
   logic AHB_HCLK25;
   // Transfer25 kind (out)
   logic [1:0] AHB_HTRANS25;
   // Burst kind (out)
   logic [2:0] AHB_HBURST25;
   // Transfer25 size (out)
   logic [2:0] AHB_HSIZE25;
   // Transfer25 direction25 (out)
   logic AHB_HWRITE25;
   // Protection25 control25 (out)
   logic [3:0] AHB_HPROT25;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH25-1:0] AHB_HADDR25;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH25-1:0] AHB_HWDATA25;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH25-1:0] AHB_HRDATA25;
   // Bus25 grant (in)
   logic AHB_HGRANT25;
   // Slave25 is ready (in)
   logic AHB_HREADY25;
   // Locked25 transfer25 request (out)
   logic AHB_HLOCK25;
   // Bus25 request	(out)
   logic AHB_HBUSREQ25;
   // Reset25 (in)
   logic AHB_HRESET25;
   // Transfer25 response (in)
   logic [1:0] AHB_HRESP25;

  
  // Control25 flags25
  bit has_checks25 = 1;
  bit has_coverage = 1;

  // Coverage25 and assertions25 to be implemented here25
  /***************************************************************************
   IVB25-NOTE25 : REQUIRED25 : Assertion25 checks25 : Interface25
   -------------------------------------------------------------------------
   Add assertion25 checks25 as required25.
   ***************************************************************************/

  // SVA25 default clocking
  wire uvm_assert_clk25 = ahb_clock25 && has_checks25;
  default clocking master_clk25 @(negedge uvm_assert_clk25);
  endclocking

  // SVA25 Default reset
  default disable iff (ahb_resetn25);


endinterface : ahb_if25

