// IVB14 checksum14: 876316374
/*-----------------------------------------------------------------
File14 name     : ahb_if14.sv
Created14       : Wed14 May14 19 15:42:20 2010
Description14   :
Notes14         :
-----------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


interface ahb_if14 (input ahb_clock14, input ahb_resetn14 );

  // Import14 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB14-NOTE14 : REQUIRED14 : OVC14 signal14 definitions14 : signals14 definitions14
   -------------------------------------------------------------------------
   Adjust14 the signal14 names and add any necessary14 signals14.
   Note14 that if you change a signal14 name, you must change it in all of your14
   OVC14 files.
   ***************************************************************************/


   // Clock14 source14 (in)
   logic AHB_HCLK14;
   // Transfer14 kind (out)
   logic [1:0] AHB_HTRANS14;
   // Burst kind (out)
   logic [2:0] AHB_HBURST14;
   // Transfer14 size (out)
   logic [2:0] AHB_HSIZE14;
   // Transfer14 direction14 (out)
   logic AHB_HWRITE14;
   // Protection14 control14 (out)
   logic [3:0] AHB_HPROT14;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH14-1:0] AHB_HADDR14;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH14-1:0] AHB_HWDATA14;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH14-1:0] AHB_HRDATA14;
   // Bus14 grant (in)
   logic AHB_HGRANT14;
   // Slave14 is ready (in)
   logic AHB_HREADY14;
   // Locked14 transfer14 request (out)
   logic AHB_HLOCK14;
   // Bus14 request	(out)
   logic AHB_HBUSREQ14;
   // Reset14 (in)
   logic AHB_HRESET14;
   // Transfer14 response (in)
   logic [1:0] AHB_HRESP14;

  
  // Control14 flags14
  bit has_checks14 = 1;
  bit has_coverage = 1;

  // Coverage14 and assertions14 to be implemented here14
  /***************************************************************************
   IVB14-NOTE14 : REQUIRED14 : Assertion14 checks14 : Interface14
   -------------------------------------------------------------------------
   Add assertion14 checks14 as required14.
   ***************************************************************************/

  // SVA14 default clocking
  wire uvm_assert_clk14 = ahb_clock14 && has_checks14;
  default clocking master_clk14 @(negedge uvm_assert_clk14);
  endclocking

  // SVA14 Default reset
  default disable iff (ahb_resetn14);


endinterface : ahb_if14

