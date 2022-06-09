// IVB21 checksum21: 876316374
/*-----------------------------------------------------------------
File21 name     : ahb_if21.sv
Created21       : Wed21 May21 19 15:42:20 2010
Description21   :
Notes21         :
-----------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


interface ahb_if21 (input ahb_clock21, input ahb_resetn21 );

  // Import21 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB21-NOTE21 : REQUIRED21 : OVC21 signal21 definitions21 : signals21 definitions21
   -------------------------------------------------------------------------
   Adjust21 the signal21 names and add any necessary21 signals21.
   Note21 that if you change a signal21 name, you must change it in all of your21
   OVC21 files.
   ***************************************************************************/


   // Clock21 source21 (in)
   logic AHB_HCLK21;
   // Transfer21 kind (out)
   logic [1:0] AHB_HTRANS21;
   // Burst kind (out)
   logic [2:0] AHB_HBURST21;
   // Transfer21 size (out)
   logic [2:0] AHB_HSIZE21;
   // Transfer21 direction21 (out)
   logic AHB_HWRITE21;
   // Protection21 control21 (out)
   logic [3:0] AHB_HPROT21;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH21-1:0] AHB_HADDR21;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH21-1:0] AHB_HWDATA21;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH21-1:0] AHB_HRDATA21;
   // Bus21 grant (in)
   logic AHB_HGRANT21;
   // Slave21 is ready (in)
   logic AHB_HREADY21;
   // Locked21 transfer21 request (out)
   logic AHB_HLOCK21;
   // Bus21 request	(out)
   logic AHB_HBUSREQ21;
   // Reset21 (in)
   logic AHB_HRESET21;
   // Transfer21 response (in)
   logic [1:0] AHB_HRESP21;

  
  // Control21 flags21
  bit has_checks21 = 1;
  bit has_coverage = 1;

  // Coverage21 and assertions21 to be implemented here21
  /***************************************************************************
   IVB21-NOTE21 : REQUIRED21 : Assertion21 checks21 : Interface21
   -------------------------------------------------------------------------
   Add assertion21 checks21 as required21.
   ***************************************************************************/

  // SVA21 default clocking
  wire uvm_assert_clk21 = ahb_clock21 && has_checks21;
  default clocking master_clk21 @(negedge uvm_assert_clk21);
  endclocking

  // SVA21 Default reset
  default disable iff (ahb_resetn21);


endinterface : ahb_if21

