// IVB16 checksum16: 876316374
/*-----------------------------------------------------------------
File16 name     : ahb_if16.sv
Created16       : Wed16 May16 19 15:42:20 2010
Description16   :
Notes16         :
-----------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


interface ahb_if16 (input ahb_clock16, input ahb_resetn16 );

  // Import16 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB16-NOTE16 : REQUIRED16 : OVC16 signal16 definitions16 : signals16 definitions16
   -------------------------------------------------------------------------
   Adjust16 the signal16 names and add any necessary16 signals16.
   Note16 that if you change a signal16 name, you must change it in all of your16
   OVC16 files.
   ***************************************************************************/


   // Clock16 source16 (in)
   logic AHB_HCLK16;
   // Transfer16 kind (out)
   logic [1:0] AHB_HTRANS16;
   // Burst kind (out)
   logic [2:0] AHB_HBURST16;
   // Transfer16 size (out)
   logic [2:0] AHB_HSIZE16;
   // Transfer16 direction16 (out)
   logic AHB_HWRITE16;
   // Protection16 control16 (out)
   logic [3:0] AHB_HPROT16;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH16-1:0] AHB_HADDR16;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH16-1:0] AHB_HWDATA16;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH16-1:0] AHB_HRDATA16;
   // Bus16 grant (in)
   logic AHB_HGRANT16;
   // Slave16 is ready (in)
   logic AHB_HREADY16;
   // Locked16 transfer16 request (out)
   logic AHB_HLOCK16;
   // Bus16 request	(out)
   logic AHB_HBUSREQ16;
   // Reset16 (in)
   logic AHB_HRESET16;
   // Transfer16 response (in)
   logic [1:0] AHB_HRESP16;

  
  // Control16 flags16
  bit has_checks16 = 1;
  bit has_coverage = 1;

  // Coverage16 and assertions16 to be implemented here16
  /***************************************************************************
   IVB16-NOTE16 : REQUIRED16 : Assertion16 checks16 : Interface16
   -------------------------------------------------------------------------
   Add assertion16 checks16 as required16.
   ***************************************************************************/

  // SVA16 default clocking
  wire uvm_assert_clk16 = ahb_clock16 && has_checks16;
  default clocking master_clk16 @(negedge uvm_assert_clk16);
  endclocking

  // SVA16 Default reset
  default disable iff (ahb_resetn16);


endinterface : ahb_if16

