// IVB28 checksum28: 876316374
/*-----------------------------------------------------------------
File28 name     : ahb_if28.sv
Created28       : Wed28 May28 19 15:42:20 2010
Description28   :
Notes28         :
-----------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


interface ahb_if28 (input ahb_clock28, input ahb_resetn28 );

  // Import28 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB28-NOTE28 : REQUIRED28 : OVC28 signal28 definitions28 : signals28 definitions28
   -------------------------------------------------------------------------
   Adjust28 the signal28 names and add any necessary28 signals28.
   Note28 that if you change a signal28 name, you must change it in all of your28
   OVC28 files.
   ***************************************************************************/


   // Clock28 source28 (in)
   logic AHB_HCLK28;
   // Transfer28 kind (out)
   logic [1:0] AHB_HTRANS28;
   // Burst kind (out)
   logic [2:0] AHB_HBURST28;
   // Transfer28 size (out)
   logic [2:0] AHB_HSIZE28;
   // Transfer28 direction28 (out)
   logic AHB_HWRITE28;
   // Protection28 control28 (out)
   logic [3:0] AHB_HPROT28;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH28-1:0] AHB_HADDR28;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH28-1:0] AHB_HWDATA28;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH28-1:0] AHB_HRDATA28;
   // Bus28 grant (in)
   logic AHB_HGRANT28;
   // Slave28 is ready (in)
   logic AHB_HREADY28;
   // Locked28 transfer28 request (out)
   logic AHB_HLOCK28;
   // Bus28 request	(out)
   logic AHB_HBUSREQ28;
   // Reset28 (in)
   logic AHB_HRESET28;
   // Transfer28 response (in)
   logic [1:0] AHB_HRESP28;

  
  // Control28 flags28
  bit has_checks28 = 1;
  bit has_coverage = 1;

  // Coverage28 and assertions28 to be implemented here28
  /***************************************************************************
   IVB28-NOTE28 : REQUIRED28 : Assertion28 checks28 : Interface28
   -------------------------------------------------------------------------
   Add assertion28 checks28 as required28.
   ***************************************************************************/

  // SVA28 default clocking
  wire uvm_assert_clk28 = ahb_clock28 && has_checks28;
  default clocking master_clk28 @(negedge uvm_assert_clk28);
  endclocking

  // SVA28 Default reset
  default disable iff (ahb_resetn28);


endinterface : ahb_if28

