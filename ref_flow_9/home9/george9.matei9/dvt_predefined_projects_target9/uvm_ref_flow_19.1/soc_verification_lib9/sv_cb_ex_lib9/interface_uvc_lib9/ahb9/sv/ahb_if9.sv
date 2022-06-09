// IVB9 checksum9: 876316374
/*-----------------------------------------------------------------
File9 name     : ahb_if9.sv
Created9       : Wed9 May9 19 15:42:20 2010
Description9   :
Notes9         :
-----------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


interface ahb_if9 (input ahb_clock9, input ahb_resetn9 );

  // Import9 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB9-NOTE9 : REQUIRED9 : OVC9 signal9 definitions9 : signals9 definitions9
   -------------------------------------------------------------------------
   Adjust9 the signal9 names and add any necessary9 signals9.
   Note9 that if you change a signal9 name, you must change it in all of your9
   OVC9 files.
   ***************************************************************************/


   // Clock9 source9 (in)
   logic AHB_HCLK9;
   // Transfer9 kind (out)
   logic [1:0] AHB_HTRANS9;
   // Burst kind (out)
   logic [2:0] AHB_HBURST9;
   // Transfer9 size (out)
   logic [2:0] AHB_HSIZE9;
   // Transfer9 direction9 (out)
   logic AHB_HWRITE9;
   // Protection9 control9 (out)
   logic [3:0] AHB_HPROT9;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH9-1:0] AHB_HADDR9;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH9-1:0] AHB_HWDATA9;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH9-1:0] AHB_HRDATA9;
   // Bus9 grant (in)
   logic AHB_HGRANT9;
   // Slave9 is ready (in)
   logic AHB_HREADY9;
   // Locked9 transfer9 request (out)
   logic AHB_HLOCK9;
   // Bus9 request	(out)
   logic AHB_HBUSREQ9;
   // Reset9 (in)
   logic AHB_HRESET9;
   // Transfer9 response (in)
   logic [1:0] AHB_HRESP9;

  
  // Control9 flags9
  bit has_checks9 = 1;
  bit has_coverage = 1;

  // Coverage9 and assertions9 to be implemented here9
  /***************************************************************************
   IVB9-NOTE9 : REQUIRED9 : Assertion9 checks9 : Interface9
   -------------------------------------------------------------------------
   Add assertion9 checks9 as required9.
   ***************************************************************************/

  // SVA9 default clocking
  wire uvm_assert_clk9 = ahb_clock9 && has_checks9;
  default clocking master_clk9 @(negedge uvm_assert_clk9);
  endclocking

  // SVA9 Default reset
  default disable iff (ahb_resetn9);


endinterface : ahb_if9

