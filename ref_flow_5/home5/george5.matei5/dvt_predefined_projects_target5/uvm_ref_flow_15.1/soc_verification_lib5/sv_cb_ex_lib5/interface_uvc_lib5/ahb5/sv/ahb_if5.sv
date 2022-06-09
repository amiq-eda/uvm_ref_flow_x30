// IVB5 checksum5: 876316374
/*-----------------------------------------------------------------
File5 name     : ahb_if5.sv
Created5       : Wed5 May5 19 15:42:20 2010
Description5   :
Notes5         :
-----------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


interface ahb_if5 (input ahb_clock5, input ahb_resetn5 );

  // Import5 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB5-NOTE5 : REQUIRED5 : OVC5 signal5 definitions5 : signals5 definitions5
   -------------------------------------------------------------------------
   Adjust5 the signal5 names and add any necessary5 signals5.
   Note5 that if you change a signal5 name, you must change it in all of your5
   OVC5 files.
   ***************************************************************************/


   // Clock5 source5 (in)
   logic AHB_HCLK5;
   // Transfer5 kind (out)
   logic [1:0] AHB_HTRANS5;
   // Burst kind (out)
   logic [2:0] AHB_HBURST5;
   // Transfer5 size (out)
   logic [2:0] AHB_HSIZE5;
   // Transfer5 direction5 (out)
   logic AHB_HWRITE5;
   // Protection5 control5 (out)
   logic [3:0] AHB_HPROT5;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH5-1:0] AHB_HADDR5;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH5-1:0] AHB_HWDATA5;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH5-1:0] AHB_HRDATA5;
   // Bus5 grant (in)
   logic AHB_HGRANT5;
   // Slave5 is ready (in)
   logic AHB_HREADY5;
   // Locked5 transfer5 request (out)
   logic AHB_HLOCK5;
   // Bus5 request	(out)
   logic AHB_HBUSREQ5;
   // Reset5 (in)
   logic AHB_HRESET5;
   // Transfer5 response (in)
   logic [1:0] AHB_HRESP5;

  
  // Control5 flags5
  bit has_checks5 = 1;
  bit has_coverage = 1;

  // Coverage5 and assertions5 to be implemented here5
  /***************************************************************************
   IVB5-NOTE5 : REQUIRED5 : Assertion5 checks5 : Interface5
   -------------------------------------------------------------------------
   Add assertion5 checks5 as required5.
   ***************************************************************************/

  // SVA5 default clocking
  wire uvm_assert_clk5 = ahb_clock5 && has_checks5;
  default clocking master_clk5 @(negedge uvm_assert_clk5);
  endclocking

  // SVA5 Default reset
  default disable iff (ahb_resetn5);


endinterface : ahb_if5

