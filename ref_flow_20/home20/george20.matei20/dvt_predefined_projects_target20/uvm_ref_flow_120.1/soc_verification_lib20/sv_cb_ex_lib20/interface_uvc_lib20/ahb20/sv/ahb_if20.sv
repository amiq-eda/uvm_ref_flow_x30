// IVB20 checksum20: 876316374
/*-----------------------------------------------------------------
File20 name     : ahb_if20.sv
Created20       : Wed20 May20 19 15:42:20 2010
Description20   :
Notes20         :
-----------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


interface ahb_if20 (input ahb_clock20, input ahb_resetn20 );

  // Import20 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB20-NOTE20 : REQUIRED20 : OVC20 signal20 definitions20 : signals20 definitions20
   -------------------------------------------------------------------------
   Adjust20 the signal20 names and add any necessary20 signals20.
   Note20 that if you change a signal20 name, you must change it in all of your20
   OVC20 files.
   ***************************************************************************/


   // Clock20 source20 (in)
   logic AHB_HCLK20;
   // Transfer20 kind (out)
   logic [1:0] AHB_HTRANS20;
   // Burst kind (out)
   logic [2:0] AHB_HBURST20;
   // Transfer20 size (out)
   logic [2:0] AHB_HSIZE20;
   // Transfer20 direction20 (out)
   logic AHB_HWRITE20;
   // Protection20 control20 (out)
   logic [3:0] AHB_HPROT20;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH20-1:0] AHB_HADDR20;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH20-1:0] AHB_HWDATA20;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH20-1:0] AHB_HRDATA20;
   // Bus20 grant (in)
   logic AHB_HGRANT20;
   // Slave20 is ready (in)
   logic AHB_HREADY20;
   // Locked20 transfer20 request (out)
   logic AHB_HLOCK20;
   // Bus20 request	(out)
   logic AHB_HBUSREQ20;
   // Reset20 (in)
   logic AHB_HRESET20;
   // Transfer20 response (in)
   logic [1:0] AHB_HRESP20;

  
  // Control20 flags20
  bit has_checks20 = 1;
  bit has_coverage = 1;

  // Coverage20 and assertions20 to be implemented here20
  /***************************************************************************
   IVB20-NOTE20 : REQUIRED20 : Assertion20 checks20 : Interface20
   -------------------------------------------------------------------------
   Add assertion20 checks20 as required20.
   ***************************************************************************/

  // SVA20 default clocking
  wire uvm_assert_clk20 = ahb_clock20 && has_checks20;
  default clocking master_clk20 @(negedge uvm_assert_clk20);
  endclocking

  // SVA20 Default reset
  default disable iff (ahb_resetn20);


endinterface : ahb_if20

