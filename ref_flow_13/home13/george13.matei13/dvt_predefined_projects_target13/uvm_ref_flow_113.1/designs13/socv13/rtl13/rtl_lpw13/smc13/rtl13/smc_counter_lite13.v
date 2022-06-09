//File13 name   : smc_counter_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : Counter13 block.
//            : Static13 Memory Controller13.
//            : The counter block provides13 generates13 all cycle timings13
//            : The leading13 edge counts13 are individual13 2bit, loadable13,
//            : counters13. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing13
//            : edge counts13 are registered for comparison13 with the
//            : wait state counter. The bus float13 (CSTE13) is a
//            : separate13 2bit counter. The initial count values are
//            : stored13 and reloaded13 into the counters13 if multiple
//            : accesses are required13.
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


module smc_counter_lite13  (
                     //inputs13

                     sys_clk13,
                     n_sys_reset13,
                     valid_access13,
                     mac_done13, 
                     smc_done13, 
                     cste_enable13, 
                     ws_enable13,
                     le_enable13, 

                     //outputs13

                     r_csle_count13,
                     r_wele_count13,
                     r_ws_count13,
                     r_ws_store13,
                     r_oete_store13,
                     r_wete_store13,
                     r_wele_store13,
                     r_cste_count13,
                     r_csle_store13);
   

//----------------------------------------------------------------------
// the Wait13 State13 Counter13
//----------------------------------------------------------------------
   
   
   // I13/O13
   
   input     sys_clk13;                  // AHB13 System13 clock13
   input     n_sys_reset13;              // AHB13 System13 reset (Active13 LOW13)
   
   input     valid_access13;             // load13 values are valid if high13
   input     mac_done13;                 // All cycles13 in a multiple access

   //  completed
   
   input                 smc_done13;   // one access completed
   input                 cste_enable13;// Enable13 CS13 Trailing13 Edge13 counter
   input                 ws_enable13;  // Enable13 Wait13 State13 counter
   input                 le_enable13;  // Enable13 all Leading13 Edge13 counters13
   
   // Counter13 outputs13
   
   output [1:0]             r_csle_count13;  //chip13 select13 leading13
                                             //  edge count
   output [1:0]             r_wele_count13;  //write strobe13 leading13 
                                             // edge count
   output [7:0] r_ws_count13;    //wait state count
   output [1:0]             r_cste_count13;  //chip13 select13 trailing13 
                                             // edge count
   
   // Stored13 counts13 for MAC13
   
   output [1:0]             r_oete_store13;  //read strobe13
   output [1:0]             r_wete_store13;  //write strobe13 trailing13 
                                              // edge store13
   output [7:0] r_ws_store13;    //wait state store13
   output [1:0]             r_wele_store13;  //write strobe13 leading13
                                             //  edge store13
   output [1:0]             r_csle_store13;  //chip13 select13  leading13
                                             //  edge store13
   
   
   // Counters13
   
   reg [1:0]             r_csle_count13;  // Chip13 select13 LE13 counter
   reg [1:0]             r_wele_count13;  // Write counter
   reg [7:0] r_ws_count13;    // Wait13 state select13 counter
   reg [1:0]             r_cste_count13;  // Chip13 select13 TE13 counter
   
   
   // These13 strobes13 finish early13 so no counter is required13. 
   // The stored13 value is compared with WS13 counter to determine13 
   // when the strobe13 should end.

   reg [1:0]    r_wete_store13;    // Write strobe13 TE13 end time before CS13
   reg [1:0]    r_oete_store13;    // Read strobe13 TE13 end time before CS13
   
   
   // The following13 four13 regisrers13 are used to store13 the configuration
   // during mulitple13 accesses. The counters13 are reloaded13 from these13
   // registers before each cycle.
   
   reg [1:0]             r_csle_store13;    // Chip13 select13 LE13 store13
   reg [1:0]             r_wele_store13;    // Write strobe13 LE13 store13
   reg [7:0] r_ws_store13;      // Wait13 state store13
   reg [1:0]             r_cste_store13;    // Chip13 Select13 TE13 delay
                                          //  (Bus13 float13 time)

   // wires13 used for meeting13 coding13 standards13
   
   wire         ws_count13;      //ORed13 r_ws_count13
   wire         wele_count13;    //ORed13 r_wele_count13
   wire         cste_count13;    //ORed13 r_cste_count13
   wire         mac_smc_done13;  //ANDed13 smc_done13 and not(mac_done13)
   wire [4:0]   case_cste13;     //concatenated13 signals13 for case statement13
   wire [4:0]   case_wele13;     //concatenated13 signals13 for case statement13
   wire [4:0]   case_ws13;       //concatenated13 signals13 for case statement13
   
   
   
   // Main13 Code13
   
//----------------------------------------------------------------------
// Counters13 (& Count13 Store13 for MAC13)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE13 Store13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)

begin   

   if (~(n_sys_reset13))
     
      r_wete_store13 <= 2'b00;
   
   
   else if (valid_access13)
     
      r_wete_store13 <= 2'b0;
   
   else
     
      r_wete_store13 <= r_wete_store13;

end
   
//----------------------------------------------------------------------
// OETE13 Store13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)

begin   

   if (~(n_sys_reset13))
     
      r_oete_store13 <= 2'b00;
   
   
   else if (valid_access13)
     
      r_oete_store13 <= 2'b0;
   
   else

      r_oete_store13 <= r_oete_store13;

end
   
//----------------------------------------------------------------------
// CSLE13 Store13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)

begin   

   if (~(n_sys_reset13))
     
      r_csle_store13 <= 2'b00;
   
   
   else if (valid_access13)
     
      r_csle_store13 <= 2'b00;
   
   else
     
      r_csle_store13 <= r_csle_store13;

end
   
//----------------------------------------------------------------------
// CSLE13 Counter13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)

begin   

   if (~(n_sys_reset13))
     
      r_csle_count13 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access13)
        
         r_csle_count13 <= 2'b00;
      
      else if (~(mac_done13) & smc_done13)
        
         r_csle_count13 <= r_csle_store13;
      
      else if (r_csle_count13 == 2'b00)
        
         r_csle_count13 <= r_csle_count13;
      
      else if (le_enable13)               
        
         r_csle_count13 <= r_csle_count13 - 2'd1;
      
      else
        
          r_csle_count13 <= r_csle_count13;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE13 Store13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)

begin   

   if (~(n_sys_reset13))

      r_cste_store13 <= 2'b00;

   else if (valid_access13)

      r_cste_store13 <= 2'b0;

   else

      r_cste_store13 <= r_cste_store13;

end
   
   
   
//----------------------------------------------------------------------
//concatenation13 of signals13 to avoid using nested13 ifs13
//----------------------------------------------------------------------

 assign mac_smc_done13 = (~(mac_done13) & smc_done13);
 assign cste_count13   = (|r_cste_count13);           //checks13 for count = 0
 assign case_cste13   = {1'b0,valid_access13,mac_smc_done13,cste_count13,
                       cste_enable13};
   
//----------------------------------------------------------------------
//CSTE13 COUNTER13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)

begin   

   if (~(n_sys_reset13))

      r_cste_count13 <= 2'b00;

   else 
   begin
      casex(case_cste13)
           
        5'b1xxxx:        r_cste_count13 <= r_cste_count13;

        5'b01xxx:        r_cste_count13 <= 2'b0;

        5'b001xx:        r_cste_count13 <= r_cste_store13;

        5'b0000x:        r_cste_count13 <= r_cste_count13;

        5'b00011:        r_cste_count13 <= r_cste_count13 - 2'd1;

        default :        r_cste_count13 <= r_cste_count13;

      endcase // casex(w_cste_case13)
      
   end
   
end

//----------------------------------------------------------------------
// WELE13 Store13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)

begin   

   if (~(n_sys_reset13))

      r_wele_store13 <= 2'b00;


   else if (valid_access13)

      r_wele_store13 <= 2'b00;

   else

      r_wele_store13 <= r_wele_store13;

end
   
   
   
//----------------------------------------------------------------------
//concatenation13 of signals13 to avoid using nested13 ifs13
//----------------------------------------------------------------------
   
   assign wele_count13   = (|r_wele_count13);         //checks13 for count = 0
   assign case_wele13   = {1'b0,valid_access13,mac_smc_done13,wele_count13,
                         le_enable13};
   
//----------------------------------------------------------------------
// WELE13 Counter13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)

begin   
   if (~(n_sys_reset13))

      r_wele_count13 <= 2'b00;

   else
   begin

      casex(case_wele13)

        5'b1xxxx :  r_wele_count13 <= r_wele_count13;

        5'b01xxx :  r_wele_count13 <= 2'b00;

        5'b001xx :  r_wele_count13 <= r_wele_store13;

        5'b0000x :  r_wele_count13 <= r_wele_count13;

        5'b00011 :  r_wele_count13 <= r_wele_count13 - (2'd1);

        default  :  r_wele_count13 <= r_wele_count13;

      endcase // casex(case_wele13)

   end

end
   
//----------------------------------------------------------------------
// WS13 Store13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)
  
begin   

   if (~(n_sys_reset13))

      r_ws_store13 <= 8'd0;


   else if (valid_access13)

      r_ws_store13 <= 8'h01;

   else

      r_ws_store13 <= r_ws_store13;

end
   
   
   
//----------------------------------------------------------------------
//concatenation13 of signals13 to avoid using nested13 ifs13
//----------------------------------------------------------------------
   
   assign ws_count13   = (|r_ws_count13); //checks13 for count = 0
   assign case_ws13   = {1'b0,valid_access13,mac_smc_done13,ws_count13,
                       ws_enable13};
   
//----------------------------------------------------------------------
// WS13 Counter13
//----------------------------------------------------------------------

always @(posedge sys_clk13 or negedge n_sys_reset13)

begin   

   if (~(n_sys_reset13))

      r_ws_count13 <= 8'd0;

   else  
   begin
   
      casex(case_ws13)
 
         5'b1xxxx :  
            r_ws_count13 <= r_ws_count13;
        
         5'b01xxx :
            r_ws_count13 <= 8'h01;
        
         5'b001xx :  
            r_ws_count13 <= r_ws_store13;
        
         5'b0000x :  
            r_ws_count13 <= r_ws_count13;
        
         5'b00011 :  
            r_ws_count13 <= r_ws_count13 - 8'd1;
        
         default  :  
            r_ws_count13 <= r_ws_count13;

      endcase // casex(case_ws13)
      
   end
   
end  
   
   
endmodule
