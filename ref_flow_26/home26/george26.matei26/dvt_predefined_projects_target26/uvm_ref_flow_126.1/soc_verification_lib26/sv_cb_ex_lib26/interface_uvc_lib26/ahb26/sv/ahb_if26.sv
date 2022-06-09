// IVB26 checksum26: 876316374
/*-----------------------------------------------------------------
File26 name     : ahb_if26.sv
Created26       : Wed26 May26 19 15:42:20 2010
Description26   :
Notes26         :
-----------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


interface ahb_if26 (input ahb_clock26, input ahb_resetn26 );

  // Import26 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB26-NOTE26 : REQUIRED26 : OVC26 signal26 definitions26 : signals26 definitions26
   -------------------------------------------------------------------------
   Adjust26 the signal26 names and add any necessary26 signals26.
   Note26 that if you change a signal26 name, you must change it in all of your26
   OVC26 files.
   ***************************************************************************/


   // Clock26 source26 (in)
   logic AHB_HCLK26;
   // Transfer26 kind (out)
   logic [1:0] AHB_HTRANS26;
   // Burst kind (out)
   logic [2:0] AHB_HBURST26;
   // Transfer26 size (out)
   logic [2:0] AHB_HSIZE26;
   // Transfer26 direction26 (out)
   logic AHB_HWRITE26;
   // Protection26 control26 (out)
   logic [3:0] AHB_HPROT26;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH26-1:0] AHB_HADDR26;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH26-1:0] AHB_HWDATA26;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH26-1:0] AHB_HRDATA26;
   // Bus26 grant (in)
   logic AHB_HGRANT26;
   // Slave26 is ready (in)
   logic AHB_HREADY26;
   // Locked26 transfer26 request (out)
   logic AHB_HLOCK26;
   // Bus26 request	(out)
   logic AHB_HBUSREQ26;
   // Reset26 (in)
   logic AHB_HRESET26;
   // Transfer26 response (in)
   logic [1:0] AHB_HRESP26;

  
  // Control26 flags26
  bit has_checks26 = 1;
  bit has_coverage = 1;

  // Coverage26 and assertions26 to be implemented here26
  /***************************************************************************
   IVB26-NOTE26 : REQUIRED26 : Assertion26 checks26 : Interface26
   -------------------------------------------------------------------------
   Add assertion26 checks26 as required26.
   ***************************************************************************/

  // SVA26 default clocking
  wire uvm_assert_clk26 = ahb_clock26 && has_checks26;
  default clocking master_clk26 @(negedge uvm_assert_clk26);
  endclocking

  // SVA26 Default reset
  default disable iff (ahb_resetn26);


endinterface : ahb_if26

