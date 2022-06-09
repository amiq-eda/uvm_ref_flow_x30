// IVB30 checksum30: 876316374
/*-----------------------------------------------------------------
File30 name     : ahb_if30.sv
Created30       : Wed30 May30 19 15:42:20 2010
Description30   :
Notes30         :
-----------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


interface ahb_if30 (input ahb_clock30, input ahb_resetn30 );

  // Import30 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB30-NOTE30 : REQUIRED30 : OVC30 signal30 definitions30 : signals30 definitions30
   -------------------------------------------------------------------------
   Adjust30 the signal30 names and add any necessary30 signals30.
   Note30 that if you change a signal30 name, you must change it in all of your30
   OVC30 files.
   ***************************************************************************/


   // Clock30 source30 (in)
   logic AHB_HCLK30;
   // Transfer30 kind (out)
   logic [1:0] AHB_HTRANS30;
   // Burst kind (out)
   logic [2:0] AHB_HBURST30;
   // Transfer30 size (out)
   logic [2:0] AHB_HSIZE30;
   // Transfer30 direction30 (out)
   logic AHB_HWRITE30;
   // Protection30 control30 (out)
   logic [3:0] AHB_HPROT30;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH30-1:0] AHB_HADDR30;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH30-1:0] AHB_HWDATA30;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH30-1:0] AHB_HRDATA30;
   // Bus30 grant (in)
   logic AHB_HGRANT30;
   // Slave30 is ready (in)
   logic AHB_HREADY30;
   // Locked30 transfer30 request (out)
   logic AHB_HLOCK30;
   // Bus30 request	(out)
   logic AHB_HBUSREQ30;
   // Reset30 (in)
   logic AHB_HRESET30;
   // Transfer30 response (in)
   logic [1:0] AHB_HRESP30;

  
  // Control30 flags30
  bit has_checks30 = 1;
  bit has_coverage = 1;

  // Coverage30 and assertions30 to be implemented here30
  /***************************************************************************
   IVB30-NOTE30 : REQUIRED30 : Assertion30 checks30 : Interface30
   -------------------------------------------------------------------------
   Add assertion30 checks30 as required30.
   ***************************************************************************/

  // SVA30 default clocking
  wire uvm_assert_clk30 = ahb_clock30 && has_checks30;
  default clocking master_clk30 @(negedge uvm_assert_clk30);
  endclocking

  // SVA30 Default reset
  default disable iff (ahb_resetn30);


endinterface : ahb_if30

