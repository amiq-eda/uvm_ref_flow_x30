// IVB6 checksum6: 876316374
/*-----------------------------------------------------------------
File6 name     : ahb_if6.sv
Created6       : Wed6 May6 19 15:42:20 2010
Description6   :
Notes6         :
-----------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


interface ahb_if6 (input ahb_clock6, input ahb_resetn6 );

  // Import6 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB6-NOTE6 : REQUIRED6 : OVC6 signal6 definitions6 : signals6 definitions6
   -------------------------------------------------------------------------
   Adjust6 the signal6 names and add any necessary6 signals6.
   Note6 that if you change a signal6 name, you must change it in all of your6
   OVC6 files.
   ***************************************************************************/


   // Clock6 source6 (in)
   logic AHB_HCLK6;
   // Transfer6 kind (out)
   logic [1:0] AHB_HTRANS6;
   // Burst kind (out)
   logic [2:0] AHB_HBURST6;
   // Transfer6 size (out)
   logic [2:0] AHB_HSIZE6;
   // Transfer6 direction6 (out)
   logic AHB_HWRITE6;
   // Protection6 control6 (out)
   logic [3:0] AHB_HPROT6;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH6-1:0] AHB_HADDR6;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH6-1:0] AHB_HWDATA6;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH6-1:0] AHB_HRDATA6;
   // Bus6 grant (in)
   logic AHB_HGRANT6;
   // Slave6 is ready (in)
   logic AHB_HREADY6;
   // Locked6 transfer6 request (out)
   logic AHB_HLOCK6;
   // Bus6 request	(out)
   logic AHB_HBUSREQ6;
   // Reset6 (in)
   logic AHB_HRESET6;
   // Transfer6 response (in)
   logic [1:0] AHB_HRESP6;

  
  // Control6 flags6
  bit has_checks6 = 1;
  bit has_coverage = 1;

  // Coverage6 and assertions6 to be implemented here6
  /***************************************************************************
   IVB6-NOTE6 : REQUIRED6 : Assertion6 checks6 : Interface6
   -------------------------------------------------------------------------
   Add assertion6 checks6 as required6.
   ***************************************************************************/

  // SVA6 default clocking
  wire uvm_assert_clk6 = ahb_clock6 && has_checks6;
  default clocking master_clk6 @(negedge uvm_assert_clk6);
  endclocking

  // SVA6 Default reset
  default disable iff (ahb_resetn6);


endinterface : ahb_if6

