// IVB12 checksum12: 876316374
/*-----------------------------------------------------------------
File12 name     : ahb_if12.sv
Created12       : Wed12 May12 19 15:42:20 2010
Description12   :
Notes12         :
-----------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


interface ahb_if12 (input ahb_clock12, input ahb_resetn12 );

  // Import12 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB12-NOTE12 : REQUIRED12 : OVC12 signal12 definitions12 : signals12 definitions12
   -------------------------------------------------------------------------
   Adjust12 the signal12 names and add any necessary12 signals12.
   Note12 that if you change a signal12 name, you must change it in all of your12
   OVC12 files.
   ***************************************************************************/


   // Clock12 source12 (in)
   logic AHB_HCLK12;
   // Transfer12 kind (out)
   logic [1:0] AHB_HTRANS12;
   // Burst kind (out)
   logic [2:0] AHB_HBURST12;
   // Transfer12 size (out)
   logic [2:0] AHB_HSIZE12;
   // Transfer12 direction12 (out)
   logic AHB_HWRITE12;
   // Protection12 control12 (out)
   logic [3:0] AHB_HPROT12;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH12-1:0] AHB_HADDR12;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH12-1:0] AHB_HWDATA12;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH12-1:0] AHB_HRDATA12;
   // Bus12 grant (in)
   logic AHB_HGRANT12;
   // Slave12 is ready (in)
   logic AHB_HREADY12;
   // Locked12 transfer12 request (out)
   logic AHB_HLOCK12;
   // Bus12 request	(out)
   logic AHB_HBUSREQ12;
   // Reset12 (in)
   logic AHB_HRESET12;
   // Transfer12 response (in)
   logic [1:0] AHB_HRESP12;

  
  // Control12 flags12
  bit has_checks12 = 1;
  bit has_coverage = 1;

  // Coverage12 and assertions12 to be implemented here12
  /***************************************************************************
   IVB12-NOTE12 : REQUIRED12 : Assertion12 checks12 : Interface12
   -------------------------------------------------------------------------
   Add assertion12 checks12 as required12.
   ***************************************************************************/

  // SVA12 default clocking
  wire uvm_assert_clk12 = ahb_clock12 && has_checks12;
  default clocking master_clk12 @(negedge uvm_assert_clk12);
  endclocking

  // SVA12 Default reset
  default disable iff (ahb_resetn12);


endinterface : ahb_if12

