// IVB1 checksum1: 876316374
/*-----------------------------------------------------------------
File1 name     : ahb_if1.sv
Created1       : Wed1 May1 19 15:42:20 2010
Description1   :
Notes1         :
-----------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


interface ahb_if1 (input ahb_clock1, input ahb_resetn1 );

  // Import1 UVM package
  import uvm_pkg::*;

  /***************************************************************************
   IVB1-NOTE1 : REQUIRED1 : OVC1 signal1 definitions1 : signals1 definitions1
   -------------------------------------------------------------------------
   Adjust1 the signal1 names and add any necessary1 signals1.
   Note1 that if you change a signal1 name, you must change it in all of your1
   OVC1 files.
   ***************************************************************************/


   // Clock1 source1 (in)
   logic AHB_HCLK1;
   // Transfer1 kind (out)
   logic [1:0] AHB_HTRANS1;
   // Burst kind (out)
   logic [2:0] AHB_HBURST1;
   // Transfer1 size (out)
   logic [2:0] AHB_HSIZE1;
   // Transfer1 direction1 (out)
   logic AHB_HWRITE1;
   // Protection1 control1 (out)
   logic [3:0] AHB_HPROT1;
   // Address bus (out)
   logic [`AHB_ADDR_WIDTH1-1:0] AHB_HADDR1;
   // Write data bus (out)
   logic [`AHB_DATA_WIDTH1-1:0] AHB_HWDATA1;
   // Read data bus (in)
   logic [`AHB_DATA_WIDTH1-1:0] AHB_HRDATA1;
   // Bus1 grant (in)
   logic AHB_HGRANT1;
   // Slave1 is ready (in)
   logic AHB_HREADY1;
   // Locked1 transfer1 request (out)
   logic AHB_HLOCK1;
   // Bus1 request	(out)
   logic AHB_HBUSREQ1;
   // Reset1 (in)
   logic AHB_HRESET1;
   // Transfer1 response (in)
   logic [1:0] AHB_HRESP1;

  
  // Control1 flags1
  bit has_checks1 = 1;
  bit has_coverage = 1;

  // Coverage1 and assertions1 to be implemented here1
  /***************************************************************************
   IVB1-NOTE1 : REQUIRED1 : Assertion1 checks1 : Interface1
   -------------------------------------------------------------------------
   Add assertion1 checks1 as required1.
   ***************************************************************************/

  // SVA1 default clocking
  wire uvm_assert_clk1 = ahb_clock1 && has_checks1;
  default clocking master_clk1 @(negedge uvm_assert_clk1);
  endclocking

  // SVA1 Default reset
  default disable iff (ahb_resetn1);


endinterface : ahb_if1

