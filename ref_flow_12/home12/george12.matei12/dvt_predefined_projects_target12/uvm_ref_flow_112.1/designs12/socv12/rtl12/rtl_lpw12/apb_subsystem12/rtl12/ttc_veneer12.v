//File12 name   : ttc_veneer12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
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
module ttc_veneer12 (
           
           //inputs12
           n_p_reset12,
           pclk12,
           psel12,
           penable12,
           pwrite12,
           pwdata12,
           paddr12,
           scan_in12,
           scan_en12,

           //outputs12
           prdata12,
           interrupt12,
           scan_out12           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS12
//-----------------------------------------------------------------------------

   input         n_p_reset12;            //System12 Reset12
   input         pclk12;                 //System12 clock12
   input         psel12;                 //Select12 line
   input         penable12;              //Enable12
   input         pwrite12;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata12;               //Write data
   input [7:0]   paddr12;                //Address Bus12 register
   input         scan_in12;              //Scan12 chain12 input port
   input         scan_en12;              //Scan12 chain12 enable port
   
   output [31:0] prdata12;               //Read Data from the APB12 Interface12
   output [3:1]  interrupt12;            //Interrupt12 from PCI12 
   output        scan_out12;             //Scan12 chain12 output port

//##############################################################################
// if the TTC12 is NOT12 black12 boxed12 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC12 

ttc_lite12 i_ttc12(

   //inputs12
   .n_p_reset12(n_p_reset12),
   .pclk12(pclk12),
   .psel12(psel12),
   .penable12(penable12),
   .pwrite12(pwrite12),
   .pwdata12(pwdata12),
   .paddr12(paddr12),
   .scan_in12(),
   .scan_en12(scan_en12),

   //outputs12
   .prdata12(prdata12),
   .interrupt12(interrupt12),
   .scan_out12()
);

`else 
//##############################################################################
// if the TTC12 is black12 boxed12 
//##############################################################################

   wire          n_p_reset12;            //System12 Reset12
   wire          pclk12;                 //System12 clock12
   wire          psel12;                 //Select12 line
   wire          penable12;              //Enable12
   wire          pwrite12;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata12;               //Write data
   wire  [7:0]   paddr12;                //Address Bus12 register
   wire          scan_in12;              //Scan12 chain12 wire  port
   wire          scan_en12;              //Scan12 chain12 enable port
   
   reg    [31:0] prdata12;               //Read Data from the APB12 Interface12
   reg    [3:1]  interrupt12;            //Interrupt12 from PCI12 
   reg           scan_out12;             //Scan12 chain12 reg    port

`endif
//##############################################################################
// black12 boxed12 defines12 
//##############################################################################

endmodule
