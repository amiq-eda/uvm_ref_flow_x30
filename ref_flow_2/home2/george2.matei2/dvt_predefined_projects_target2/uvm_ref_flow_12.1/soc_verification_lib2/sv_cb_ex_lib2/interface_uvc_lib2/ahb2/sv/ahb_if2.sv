// IVB2 checksum2: 876316374
/*-----------------------------------------------------------------
File2 name     : ahb_if2.sv
Created2       : Wed2 May2 19 15:42:20 2010
Description2   :
Notes2         :
-----------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


interface ahb_if2 (input ahb_clock2, input ahb_resetn2 );

  // Import2 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB2-NOTE2 : REQUIRED2 : OVC2 signal2 definitions2 : signals2 definitions2
   -------------------------------------------------------------------------
   Adjust2 the signal2 names and add any necessary2 signals2.
   Note2 that if you change a signal2 name, you must change it in all of your2
   OVC2 files.
   ***************************************************************************/


   // Clock2 source2 (in)
   logic AHB_HCLK2;
   // Transfer2 kind (out)
   logic [1:0] AHB_HTRANS2;
   // Burst kind (out)
   logic [2:0] AHB_HBURST2;
   // Transfer2 size (out)
   logic [2:0] AHB_HSIZE2;
   // Transfer2 direction2 (out)
   logic AHB_HWRITE2;
   // Protection2 control2 (out)
   logic [3:0] AHB_HPROT2;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH2-1:0] AHB_HADDR2;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH2-1:0] AHB_HWDATA2;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH2-1:0] AHB_HRDATA2;
   // Bus2 grant (in)
   logic AHB_HGRANT2;
   // Slave2 is ready (in)
   logic AHB_HREADY2;
   // Locked2 transfer2 request (out)
   logic AHB_HLOCK2;
   // Bus2 request	(out)
   logic AHB_HBUSREQ2;
   // Reset2 (in)
   logic AHB_HRESET2;
   // Transfer2 response (in)
   logic [1:0] AHB_HRESP2;

  
  // Control2 flags2
  bit has_checks2 = 1;
  bit has_coverage = 1;

  // Coverage2 and assertions2 to be implemented here2
  /***************************************************************************
   IVB2-NOTE2 : REQUIRED2 : Assertion2 checks2 : Interface2
   -------------------------------------------------------------------------
   Add assertion2 checks2 as required2.
   ***************************************************************************/

  // SVA2 default clocking
  wire uvm_assert_clk2 = ahb_clock2 && has_checks2;
  default clocking master_clk2 @(negedge uvm_assert_clk2);
  endclocking

  // SVA2 Default reset
  default disable iff (ahb_resetn2);


endinterface : ahb_if2

