// IVB23 checksum23: 876316374
/*-----------------------------------------------------------------
File23 name     : ahb_if23.sv
Created23       : Wed23 May23 19 15:42:20 2010
Description23   :
Notes23         :
-----------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


interface ahb_if23 (input ahb_clock23, input ahb_resetn23 );

  // Import23 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB23-NOTE23 : REQUIRED23 : OVC23 signal23 definitions23 : signals23 definitions23
   -------------------------------------------------------------------------
   Adjust23 the signal23 names and add any necessary23 signals23.
   Note23 that if you change a signal23 name, you must change it in all of your23
   OVC23 files.
   ***************************************************************************/


   // Clock23 source23 (in)
   logic AHB_HCLK23;
   // Transfer23 kind (out)
   logic [1:0] AHB_HTRANS23;
   // Burst kind (out)
   logic [2:0] AHB_HBURST23;
   // Transfer23 size (out)
   logic [2:0] AHB_HSIZE23;
   // Transfer23 direction23 (out)
   logic AHB_HWRITE23;
   // Protection23 control23 (out)
   logic [3:0] AHB_HPROT23;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH23-1:0] AHB_HADDR23;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH23-1:0] AHB_HWDATA23;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH23-1:0] AHB_HRDATA23;
   // Bus23 grant (in)
   logic AHB_HGRANT23;
   // Slave23 is ready (in)
   logic AHB_HREADY23;
   // Locked23 transfer23 request (out)
   logic AHB_HLOCK23;
   // Bus23 request	(out)
   logic AHB_HBUSREQ23;
   // Reset23 (in)
   logic AHB_HRESET23;
   // Transfer23 response (in)
   logic [1:0] AHB_HRESP23;

  
  // Control23 flags23
  bit has_checks23 = 1;
  bit has_coverage = 1;

  // Coverage23 and assertions23 to be implemented here23
  /***************************************************************************
   IVB23-NOTE23 : REQUIRED23 : Assertion23 checks23 : Interface23
   -------------------------------------------------------------------------
   Add assertion23 checks23 as required23.
   ***************************************************************************/

  // SVA23 default clocking
  wire uvm_assert_clk23 = ahb_clock23 && has_checks23;
  default clocking master_clk23 @(negedge uvm_assert_clk23);
  endclocking

  // SVA23 Default reset
  default disable iff (ahb_resetn23);


endinterface : ahb_if23

