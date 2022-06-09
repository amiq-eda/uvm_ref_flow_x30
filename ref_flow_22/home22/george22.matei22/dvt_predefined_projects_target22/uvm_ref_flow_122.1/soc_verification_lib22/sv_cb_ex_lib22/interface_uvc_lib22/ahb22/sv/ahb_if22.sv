// IVB22 checksum22: 876316374
/*-----------------------------------------------------------------
File22 name     : ahb_if22.sv
Created22       : Wed22 May22 19 15:42:20 2010
Description22   :
Notes22         :
-----------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


interface ahb_if22 (input ahb_clock22, input ahb_resetn22 );

  // Import22 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB22-NOTE22 : REQUIRED22 : OVC22 signal22 definitions22 : signals22 definitions22
   -------------------------------------------------------------------------
   Adjust22 the signal22 names and add any necessary22 signals22.
   Note22 that if you change a signal22 name, you must change it in all of your22
   OVC22 files.
   ***************************************************************************/


   // Clock22 source22 (in)
   logic AHB_HCLK22;
   // Transfer22 kind (out)
   logic [1:0] AHB_HTRANS22;
   // Burst kind (out)
   logic [2:0] AHB_HBURST22;
   // Transfer22 size (out)
   logic [2:0] AHB_HSIZE22;
   // Transfer22 direction22 (out)
   logic AHB_HWRITE22;
   // Protection22 control22 (out)
   logic [3:0] AHB_HPROT22;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH22-1:0] AHB_HADDR22;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH22-1:0] AHB_HWDATA22;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH22-1:0] AHB_HRDATA22;
   // Bus22 grant (in)
   logic AHB_HGRANT22;
   // Slave22 is ready (in)
   logic AHB_HREADY22;
   // Locked22 transfer22 request (out)
   logic AHB_HLOCK22;
   // Bus22 request	(out)
   logic AHB_HBUSREQ22;
   // Reset22 (in)
   logic AHB_HRESET22;
   // Transfer22 response (in)
   logic [1:0] AHB_HRESP22;

  
  // Control22 flags22
  bit has_checks22 = 1;
  bit has_coverage = 1;

  // Coverage22 and assertions22 to be implemented here22
  /***************************************************************************
   IVB22-NOTE22 : REQUIRED22 : Assertion22 checks22 : Interface22
   -------------------------------------------------------------------------
   Add assertion22 checks22 as required22.
   ***************************************************************************/

  // SVA22 default clocking
  wire uvm_assert_clk22 = ahb_clock22 && has_checks22;
  default clocking master_clk22 @(negedge uvm_assert_clk22);
  endclocking

  // SVA22 Default reset
  default disable iff (ahb_resetn22);


endinterface : ahb_if22

