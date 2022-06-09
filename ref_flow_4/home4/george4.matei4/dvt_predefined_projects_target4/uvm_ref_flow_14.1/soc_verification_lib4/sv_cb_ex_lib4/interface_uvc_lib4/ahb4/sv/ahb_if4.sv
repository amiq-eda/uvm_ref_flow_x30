// IVB4 checksum4: 876316374
/*-----------------------------------------------------------------
File4 name     : ahb_if4.sv
Created4       : Wed4 May4 19 15:42:20 2010
Description4   :
Notes4         :
-----------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


interface ahb_if4 (input ahb_clock4, input ahb_resetn4 );

  // Import4 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB4-NOTE4 : REQUIRED4 : OVC4 signal4 definitions4 : signals4 definitions4
   -------------------------------------------------------------------------
   Adjust4 the signal4 names and add any necessary4 signals4.
   Note4 that if you change a signal4 name, you must change it in all of your4
   OVC4 files.
   ***************************************************************************/


   // Clock4 source4 (in)
   logic AHB_HCLK4;
   // Transfer4 kind (out)
   logic [1:0] AHB_HTRANS4;
   // Burst kind (out)
   logic [2:0] AHB_HBURST4;
   // Transfer4 size (out)
   logic [2:0] AHB_HSIZE4;
   // Transfer4 direction4 (out)
   logic AHB_HWRITE4;
   // Protection4 control4 (out)
   logic [3:0] AHB_HPROT4;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH4-1:0] AHB_HADDR4;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH4-1:0] AHB_HWDATA4;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH4-1:0] AHB_HRDATA4;
   // Bus4 grant (in)
   logic AHB_HGRANT4;
   // Slave4 is ready (in)
   logic AHB_HREADY4;
   // Locked4 transfer4 request (out)
   logic AHB_HLOCK4;
   // Bus4 request	(out)
   logic AHB_HBUSREQ4;
   // Reset4 (in)
   logic AHB_HRESET4;
   // Transfer4 response (in)
   logic [1:0] AHB_HRESP4;

  
  // Control4 flags4
  bit has_checks4 = 1;
  bit has_coverage = 1;

  // Coverage4 and assertions4 to be implemented here4
  /***************************************************************************
   IVB4-NOTE4 : REQUIRED4 : Assertion4 checks4 : Interface4
   -------------------------------------------------------------------------
   Add assertion4 checks4 as required4.
   ***************************************************************************/

  // SVA4 default clocking
  wire uvm_assert_clk4 = ahb_clock4 && has_checks4;
  default clocking master_clk4 @(negedge uvm_assert_clk4);
  endclocking

  // SVA4 Default reset
  default disable iff (ahb_resetn4);


endinterface : ahb_if4

