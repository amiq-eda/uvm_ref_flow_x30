//File3 name   : smc_counter_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : Counter3 block.
//            : Static3 Memory Controller3.
//            : The counter block provides3 generates3 all cycle timings3
//            : The leading3 edge counts3 are individual3 2bit, loadable3,
//            : counters3. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing3
//            : edge counts3 are registered for comparison3 with the
//            : wait state counter. The bus float3 (CSTE3) is a
//            : separate3 2bit counter. The initial count values are
//            : stored3 and reloaded3 into the counters3 if multiple
//            : accesses are required3.
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


module smc_counter_lite3  (
                     //inputs3

                     sys_clk3,
                     n_sys_reset3,
                     valid_access3,
                     mac_done3, 
                     smc_done3, 
                     cste_enable3, 
                     ws_enable3,
                     le_enable3, 

                     //outputs3

                     r_csle_count3,
                     r_wele_count3,
                     r_ws_count3,
                     r_ws_store3,
                     r_oete_store3,
                     r_wete_store3,
                     r_wele_store3,
                     r_cste_count3,
                     r_csle_store3);
   

//----------------------------------------------------------------------
// the Wait3 State3 Counter3
//----------------------------------------------------------------------
   
   
   // I3/O3
   
   input     sys_clk3;                  // AHB3 System3 clock3
   input     n_sys_reset3;              // AHB3 System3 reset (Active3 LOW3)
   
   input     valid_access3;             // load3 values are valid if high3
   input     mac_done3;                 // All cycles3 in a multiple access

   //  completed
   
   input                 smc_done3;   // one access completed
   input                 cste_enable3;// Enable3 CS3 Trailing3 Edge3 counter
   input                 ws_enable3;  // Enable3 Wait3 State3 counter
   input                 le_enable3;  // Enable3 all Leading3 Edge3 counters3
   
   // Counter3 outputs3
   
   output [1:0]             r_csle_count3;  //chip3 select3 leading3
                                             //  edge count
   output [1:0]             r_wele_count3;  //write strobe3 leading3 
                                             // edge count
   output [7:0] r_ws_count3;    //wait state count
   output [1:0]             r_cste_count3;  //chip3 select3 trailing3 
                                             // edge count
   
   // Stored3 counts3 for MAC3
   
   output [1:0]             r_oete_store3;  //read strobe3
   output [1:0]             r_wete_store3;  //write strobe3 trailing3 
                                              // edge store3
   output [7:0] r_ws_store3;    //wait state store3
   output [1:0]             r_wele_store3;  //write strobe3 leading3
                                             //  edge store3
   output [1:0]             r_csle_store3;  //chip3 select3  leading3
                                             //  edge store3
   
   
   // Counters3
   
   reg [1:0]             r_csle_count3;  // Chip3 select3 LE3 counter
   reg [1:0]             r_wele_count3;  // Write counter
   reg [7:0] r_ws_count3;    // Wait3 state select3 counter
   reg [1:0]             r_cste_count3;  // Chip3 select3 TE3 counter
   
   
   // These3 strobes3 finish early3 so no counter is required3. 
   // The stored3 value is compared with WS3 counter to determine3 
   // when the strobe3 should end.

   reg [1:0]    r_wete_store3;    // Write strobe3 TE3 end time before CS3
   reg [1:0]    r_oete_store3;    // Read strobe3 TE3 end time before CS3
   
   
   // The following3 four3 regisrers3 are used to store3 the configuration
   // during mulitple3 accesses. The counters3 are reloaded3 from these3
   // registers before each cycle.
   
   reg [1:0]             r_csle_store3;    // Chip3 select3 LE3 store3
   reg [1:0]             r_wele_store3;    // Write strobe3 LE3 store3
   reg [7:0] r_ws_store3;      // Wait3 state store3
   reg [1:0]             r_cste_store3;    // Chip3 Select3 TE3 delay
                                          //  (Bus3 float3 time)

   // wires3 used for meeting3 coding3 standards3
   
   wire         ws_count3;      //ORed3 r_ws_count3
   wire         wele_count3;    //ORed3 r_wele_count3
   wire         cste_count3;    //ORed3 r_cste_count3
   wire         mac_smc_done3;  //ANDed3 smc_done3 and not(mac_done3)
   wire [4:0]   case_cste3;     //concatenated3 signals3 for case statement3
   wire [4:0]   case_wele3;     //concatenated3 signals3 for case statement3
   wire [4:0]   case_ws3;       //concatenated3 signals3 for case statement3
   
   
   
   // Main3 Code3
   
//----------------------------------------------------------------------
// Counters3 (& Count3 Store3 for MAC3)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE3 Store3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)

begin   

   if (~(n_sys_reset3))
     
      r_wete_store3 <= 2'b00;
   
   
   else if (valid_access3)
     
      r_wete_store3 <= 2'b0;
   
   else
     
      r_wete_store3 <= r_wete_store3;

end
   
//----------------------------------------------------------------------
// OETE3 Store3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)

begin   

   if (~(n_sys_reset3))
     
      r_oete_store3 <= 2'b00;
   
   
   else if (valid_access3)
     
      r_oete_store3 <= 2'b0;
   
   else

      r_oete_store3 <= r_oete_store3;

end
   
//----------------------------------------------------------------------
// CSLE3 Store3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)

begin   

   if (~(n_sys_reset3))
     
      r_csle_store3 <= 2'b00;
   
   
   else if (valid_access3)
     
      r_csle_store3 <= 2'b00;
   
   else
     
      r_csle_store3 <= r_csle_store3;

end
   
//----------------------------------------------------------------------
// CSLE3 Counter3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)

begin   

   if (~(n_sys_reset3))
     
      r_csle_count3 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access3)
        
         r_csle_count3 <= 2'b00;
      
      else if (~(mac_done3) & smc_done3)
        
         r_csle_count3 <= r_csle_store3;
      
      else if (r_csle_count3 == 2'b00)
        
         r_csle_count3 <= r_csle_count3;
      
      else if (le_enable3)               
        
         r_csle_count3 <= r_csle_count3 - 2'd1;
      
      else
        
          r_csle_count3 <= r_csle_count3;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE3 Store3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)

begin   

   if (~(n_sys_reset3))

      r_cste_store3 <= 2'b00;

   else if (valid_access3)

      r_cste_store3 <= 2'b0;

   else

      r_cste_store3 <= r_cste_store3;

end
   
   
   
//----------------------------------------------------------------------
//concatenation3 of signals3 to avoid using nested3 ifs3
//----------------------------------------------------------------------

 assign mac_smc_done3 = (~(mac_done3) & smc_done3);
 assign cste_count3   = (|r_cste_count3);           //checks3 for count = 0
 assign case_cste3   = {1'b0,valid_access3,mac_smc_done3,cste_count3,
                       cste_enable3};
   
//----------------------------------------------------------------------
//CSTE3 COUNTER3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)

begin   

   if (~(n_sys_reset3))

      r_cste_count3 <= 2'b00;

   else 
   begin
      casex(case_cste3)
           
        5'b1xxxx:        r_cste_count3 <= r_cste_count3;

        5'b01xxx:        r_cste_count3 <= 2'b0;

        5'b001xx:        r_cste_count3 <= r_cste_store3;

        5'b0000x:        r_cste_count3 <= r_cste_count3;

        5'b00011:        r_cste_count3 <= r_cste_count3 - 2'd1;

        default :        r_cste_count3 <= r_cste_count3;

      endcase // casex(w_cste_case3)
      
   end
   
end

//----------------------------------------------------------------------
// WELE3 Store3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)

begin   

   if (~(n_sys_reset3))

      r_wele_store3 <= 2'b00;


   else if (valid_access3)

      r_wele_store3 <= 2'b00;

   else

      r_wele_store3 <= r_wele_store3;

end
   
   
   
//----------------------------------------------------------------------
//concatenation3 of signals3 to avoid using nested3 ifs3
//----------------------------------------------------------------------
   
   assign wele_count3   = (|r_wele_count3);         //checks3 for count = 0
   assign case_wele3   = {1'b0,valid_access3,mac_smc_done3,wele_count3,
                         le_enable3};
   
//----------------------------------------------------------------------
// WELE3 Counter3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)

begin   
   if (~(n_sys_reset3))

      r_wele_count3 <= 2'b00;

   else
   begin

      casex(case_wele3)

        5'b1xxxx :  r_wele_count3 <= r_wele_count3;

        5'b01xxx :  r_wele_count3 <= 2'b00;

        5'b001xx :  r_wele_count3 <= r_wele_store3;

        5'b0000x :  r_wele_count3 <= r_wele_count3;

        5'b00011 :  r_wele_count3 <= r_wele_count3 - (2'd1);

        default  :  r_wele_count3 <= r_wele_count3;

      endcase // casex(case_wele3)

   end

end
   
//----------------------------------------------------------------------
// WS3 Store3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)
  
begin   

   if (~(n_sys_reset3))

      r_ws_store3 <= 8'd0;


   else if (valid_access3)

      r_ws_store3 <= 8'h01;

   else

      r_ws_store3 <= r_ws_store3;

end
   
   
   
//----------------------------------------------------------------------
//concatenation3 of signals3 to avoid using nested3 ifs3
//----------------------------------------------------------------------
   
   assign ws_count3   = (|r_ws_count3); //checks3 for count = 0
   assign case_ws3   = {1'b0,valid_access3,mac_smc_done3,ws_count3,
                       ws_enable3};
   
//----------------------------------------------------------------------
// WS3 Counter3
//----------------------------------------------------------------------

always @(posedge sys_clk3 or negedge n_sys_reset3)

begin   

   if (~(n_sys_reset3))

      r_ws_count3 <= 8'd0;

   else  
   begin
   
      casex(case_ws3)
 
         5'b1xxxx :  
            r_ws_count3 <= r_ws_count3;
        
         5'b01xxx :
            r_ws_count3 <= 8'h01;
        
         5'b001xx :  
            r_ws_count3 <= r_ws_store3;
        
         5'b0000x :  
            r_ws_count3 <= r_ws_count3;
        
         5'b00011 :  
            r_ws_count3 <= r_ws_count3 - 8'd1;
        
         default  :  
            r_ws_count3 <= r_ws_count3;

      endcase // casex(case_ws3)
      
   end
   
end  
   
   
endmodule
