//File19 name   : ttc_veneer19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
module ttc_veneer19 (
           
           //inputs19
           n_p_reset19,
           pclk19,
           psel19,
           penable19,
           pwrite19,
           pwdata19,
           paddr19,
           scan_in19,
           scan_en19,

           //outputs19
           prdata19,
           interrupt19,
           scan_out19           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS19
//-----------------------------------------------------------------------------

   input         n_p_reset19;            //System19 Reset19
   input         pclk19;                 //System19 clock19
   input         psel19;                 //Select19 line
   input         penable19;              //Enable19
   input         pwrite19;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata19;               //Write data
   input [7:0]   paddr19;                //Address Bus19 register
   input         scan_in19;              //Scan19 chain19 input port
   input         scan_en19;              //Scan19 chain19 enable port
   
   output [31:0] prdata19;               //Read Data from the APB19 Interface19
   output [3:1]  interrupt19;            //Interrupt19 from PCI19 
   output        scan_out19;             //Scan19 chain19 output port

//##############################################################################
// if the TTC19 is NOT19 black19 boxed19 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC19 

ttc_lite19 i_ttc19(

   //inputs19
   .n_p_reset19(n_p_reset19),
   .pclk19(pclk19),
   .psel19(psel19),
   .penable19(penable19),
   .pwrite19(pwrite19),
   .pwdata19(pwdata19),
   .paddr19(paddr19),
   .scan_in19(),
   .scan_en19(scan_en19),

   //outputs19
   .prdata19(prdata19),
   .interrupt19(interrupt19),
   .scan_out19()
);

`else 
//##############################################################################
// if the TTC19 is black19 boxed19 
//##############################################################################

   wire          n_p_reset19;            //System19 Reset19
   wire          pclk19;                 //System19 clock19
   wire          psel19;                 //Select19 line
   wire          penable19;              //Enable19
   wire          pwrite19;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata19;               //Write data
   wire  [7:0]   paddr19;                //Address Bus19 register
   wire          scan_in19;              //Scan19 chain19 wire  port
   wire          scan_en19;              //Scan19 chain19 enable port
   
   reg    [31:0] prdata19;               //Read Data from the APB19 Interface19
   reg    [3:1]  interrupt19;            //Interrupt19 from PCI19 
   reg           scan_out19;             //Scan19 chain19 reg    port

`endif
//##############################################################################
// black19 boxed19 defines19 
//##############################################################################

endmodule
