//File6 name   : smc_counter_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : Counter6 block.
//            : Static6 Memory Controller6.
//            : The counter block provides6 generates6 all cycle timings6
//            : The leading6 edge counts6 are individual6 2bit, loadable6,
//            : counters6. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing6
//            : edge counts6 are registered for comparison6 with the
//            : wait state counter. The bus float6 (CSTE6) is a
//            : separate6 2bit counter. The initial count values are
//            : stored6 and reloaded6 into the counters6 if multiple
//            : accesses are required6.
//Notes6       : 
//----------------------------------------------------------------------
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


module smc_counter_lite6  (
                     //inputs6

                     sys_clk6,
                     n_sys_reset6,
                     valid_access6,
                     mac_done6, 
                     smc_done6, 
                     cste_enable6, 
                     ws_enable6,
                     le_enable6, 

                     //outputs6

                     r_csle_count6,
                     r_wele_count6,
                     r_ws_count6,
                     r_ws_store6,
                     r_oete_store6,
                     r_wete_store6,
                     r_wele_store6,
                     r_cste_count6,
                     r_csle_store6);
   

//----------------------------------------------------------------------
// the Wait6 State6 Counter6
//----------------------------------------------------------------------
   
   
   // I6/O6
   
   input     sys_clk6;                  // AHB6 System6 clock6
   input     n_sys_reset6;              // AHB6 System6 reset (Active6 LOW6)
   
   input     valid_access6;             // load6 values are valid if high6
   input     mac_done6;                 // All cycles6 in a multiple access

   //  completed
   
   input                 smc_done6;   // one access completed
   input                 cste_enable6;// Enable6 CS6 Trailing6 Edge6 counter
   input                 ws_enable6;  // Enable6 Wait6 State6 counter
   input                 le_enable6;  // Enable6 all Leading6 Edge6 counters6
   
   // Counter6 outputs6
   
   output [1:0]             r_csle_count6;  //chip6 select6 leading6
                                             //  edge count
   output [1:0]             r_wele_count6;  //write strobe6 leading6 
                                             // edge count
   output [7:0] r_ws_count6;    //wait state count
   output [1:0]             r_cste_count6;  //chip6 select6 trailing6 
                                             // edge count
   
   // Stored6 counts6 for MAC6
   
   output [1:0]             r_oete_store6;  //read strobe6
   output [1:0]             r_wete_store6;  //write strobe6 trailing6 
                                              // edge store6
   output [7:0] r_ws_store6;    //wait state store6
   output [1:0]             r_wele_store6;  //write strobe6 leading6
                                             //  edge store6
   output [1:0]             r_csle_store6;  //chip6 select6  leading6
                                             //  edge store6
   
   
   // Counters6
   
   reg [1:0]             r_csle_count6;  // Chip6 select6 LE6 counter
   reg [1:0]             r_wele_count6;  // Write counter
   reg [7:0] r_ws_count6;    // Wait6 state select6 counter
   reg [1:0]             r_cste_count6;  // Chip6 select6 TE6 counter
   
   
   // These6 strobes6 finish early6 so no counter is required6. 
   // The stored6 value is compared with WS6 counter to determine6 
   // when the strobe6 should end.

   reg [1:0]    r_wete_store6;    // Write strobe6 TE6 end time before CS6
   reg [1:0]    r_oete_store6;    // Read strobe6 TE6 end time before CS6
   
   
   // The following6 four6 regisrers6 are used to store6 the configuration
   // during mulitple6 accesses. The counters6 are reloaded6 from these6
   // registers before each cycle.
   
   reg [1:0]             r_csle_store6;    // Chip6 select6 LE6 store6
   reg [1:0]             r_wele_store6;    // Write strobe6 LE6 store6
   reg [7:0] r_ws_store6;      // Wait6 state store6
   reg [1:0]             r_cste_store6;    // Chip6 Select6 TE6 delay
                                          //  (Bus6 float6 time)

   // wires6 used for meeting6 coding6 standards6
   
   wire         ws_count6;      //ORed6 r_ws_count6
   wire         wele_count6;    //ORed6 r_wele_count6
   wire         cste_count6;    //ORed6 r_cste_count6
   wire         mac_smc_done6;  //ANDed6 smc_done6 and not(mac_done6)
   wire [4:0]   case_cste6;     //concatenated6 signals6 for case statement6
   wire [4:0]   case_wele6;     //concatenated6 signals6 for case statement6
   wire [4:0]   case_ws6;       //concatenated6 signals6 for case statement6
   
   
   
   // Main6 Code6
   
//----------------------------------------------------------------------
// Counters6 (& Count6 Store6 for MAC6)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE6 Store6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)

begin   

   if (~(n_sys_reset6))
     
      r_wete_store6 <= 2'b00;
   
   
   else if (valid_access6)
     
      r_wete_store6 <= 2'b0;
   
   else
     
      r_wete_store6 <= r_wete_store6;

end
   
//----------------------------------------------------------------------
// OETE6 Store6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)

begin   

   if (~(n_sys_reset6))
     
      r_oete_store6 <= 2'b00;
   
   
   else if (valid_access6)
     
      r_oete_store6 <= 2'b0;
   
   else

      r_oete_store6 <= r_oete_store6;

end
   
//----------------------------------------------------------------------
// CSLE6 Store6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)

begin   

   if (~(n_sys_reset6))
     
      r_csle_store6 <= 2'b00;
   
   
   else if (valid_access6)
     
      r_csle_store6 <= 2'b00;
   
   else
     
      r_csle_store6 <= r_csle_store6;

end
   
//----------------------------------------------------------------------
// CSLE6 Counter6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)

begin   

   if (~(n_sys_reset6))
     
      r_csle_count6 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access6)
        
         r_csle_count6 <= 2'b00;
      
      else if (~(mac_done6) & smc_done6)
        
         r_csle_count6 <= r_csle_store6;
      
      else if (r_csle_count6 == 2'b00)
        
         r_csle_count6 <= r_csle_count6;
      
      else if (le_enable6)               
        
         r_csle_count6 <= r_csle_count6 - 2'd1;
      
      else
        
          r_csle_count6 <= r_csle_count6;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE6 Store6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)

begin   

   if (~(n_sys_reset6))

      r_cste_store6 <= 2'b00;

   else if (valid_access6)

      r_cste_store6 <= 2'b0;

   else

      r_cste_store6 <= r_cste_store6;

end
   
   
   
//----------------------------------------------------------------------
//concatenation6 of signals6 to avoid using nested6 ifs6
//----------------------------------------------------------------------

 assign mac_smc_done6 = (~(mac_done6) & smc_done6);
 assign cste_count6   = (|r_cste_count6);           //checks6 for count = 0
 assign case_cste6   = {1'b0,valid_access6,mac_smc_done6,cste_count6,
                       cste_enable6};
   
//----------------------------------------------------------------------
//CSTE6 COUNTER6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)

begin   

   if (~(n_sys_reset6))

      r_cste_count6 <= 2'b00;

   else 
   begin
      casex(case_cste6)
           
        5'b1xxxx:        r_cste_count6 <= r_cste_count6;

        5'b01xxx:        r_cste_count6 <= 2'b0;

        5'b001xx:        r_cste_count6 <= r_cste_store6;

        5'b0000x:        r_cste_count6 <= r_cste_count6;

        5'b00011:        r_cste_count6 <= r_cste_count6 - 2'd1;

        default :        r_cste_count6 <= r_cste_count6;

      endcase // casex(w_cste_case6)
      
   end
   
end

//----------------------------------------------------------------------
// WELE6 Store6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)

begin   

   if (~(n_sys_reset6))

      r_wele_store6 <= 2'b00;


   else if (valid_access6)

      r_wele_store6 <= 2'b00;

   else

      r_wele_store6 <= r_wele_store6;

end
   
   
   
//----------------------------------------------------------------------
//concatenation6 of signals6 to avoid using nested6 ifs6
//----------------------------------------------------------------------
   
   assign wele_count6   = (|r_wele_count6);         //checks6 for count = 0
   assign case_wele6   = {1'b0,valid_access6,mac_smc_done6,wele_count6,
                         le_enable6};
   
//----------------------------------------------------------------------
// WELE6 Counter6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)

begin   
   if (~(n_sys_reset6))

      r_wele_count6 <= 2'b00;

   else
   begin

      casex(case_wele6)

        5'b1xxxx :  r_wele_count6 <= r_wele_count6;

        5'b01xxx :  r_wele_count6 <= 2'b00;

        5'b001xx :  r_wele_count6 <= r_wele_store6;

        5'b0000x :  r_wele_count6 <= r_wele_count6;

        5'b00011 :  r_wele_count6 <= r_wele_count6 - (2'd1);

        default  :  r_wele_count6 <= r_wele_count6;

      endcase // casex(case_wele6)

   end

end
   
//----------------------------------------------------------------------
// WS6 Store6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)
  
begin   

   if (~(n_sys_reset6))

      r_ws_store6 <= 8'd0;


   else if (valid_access6)

      r_ws_store6 <= 8'h01;

   else

      r_ws_store6 <= r_ws_store6;

end
   
   
   
//----------------------------------------------------------------------
//concatenation6 of signals6 to avoid using nested6 ifs6
//----------------------------------------------------------------------
   
   assign ws_count6   = (|r_ws_count6); //checks6 for count = 0
   assign case_ws6   = {1'b0,valid_access6,mac_smc_done6,ws_count6,
                       ws_enable6};
   
//----------------------------------------------------------------------
// WS6 Counter6
//----------------------------------------------------------------------

always @(posedge sys_clk6 or negedge n_sys_reset6)

begin   

   if (~(n_sys_reset6))

      r_ws_count6 <= 8'd0;

   else  
   begin
   
      casex(case_ws6)
 
         5'b1xxxx :  
            r_ws_count6 <= r_ws_count6;
        
         5'b01xxx :
            r_ws_count6 <= 8'h01;
        
         5'b001xx :  
            r_ws_count6 <= r_ws_store6;
        
         5'b0000x :  
            r_ws_count6 <= r_ws_count6;
        
         5'b00011 :  
            r_ws_count6 <= r_ws_count6 - 8'd1;
        
         default  :  
            r_ws_count6 <= r_ws_count6;

      endcase // casex(case_ws6)
      
   end
   
end  
   
   
endmodule
