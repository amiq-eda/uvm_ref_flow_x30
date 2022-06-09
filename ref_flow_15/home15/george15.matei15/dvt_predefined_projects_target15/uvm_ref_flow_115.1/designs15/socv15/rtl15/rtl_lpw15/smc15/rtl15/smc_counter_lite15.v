//File15 name   : smc_counter_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : Counter15 block.
//            : Static15 Memory Controller15.
//            : The counter block provides15 generates15 all cycle timings15
//            : The leading15 edge counts15 are individual15 2bit, loadable15,
//            : counters15. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing15
//            : edge counts15 are registered for comparison15 with the
//            : wait state counter. The bus float15 (CSTE15) is a
//            : separate15 2bit counter. The initial count values are
//            : stored15 and reloaded15 into the counters15 if multiple
//            : accesses are required15.
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


module smc_counter_lite15  (
                     //inputs15

                     sys_clk15,
                     n_sys_reset15,
                     valid_access15,
                     mac_done15, 
                     smc_done15, 
                     cste_enable15, 
                     ws_enable15,
                     le_enable15, 

                     //outputs15

                     r_csle_count15,
                     r_wele_count15,
                     r_ws_count15,
                     r_ws_store15,
                     r_oete_store15,
                     r_wete_store15,
                     r_wele_store15,
                     r_cste_count15,
                     r_csle_store15);
   

//----------------------------------------------------------------------
// the Wait15 State15 Counter15
//----------------------------------------------------------------------
   
   
   // I15/O15
   
   input     sys_clk15;                  // AHB15 System15 clock15
   input     n_sys_reset15;              // AHB15 System15 reset (Active15 LOW15)
   
   input     valid_access15;             // load15 values are valid if high15
   input     mac_done15;                 // All cycles15 in a multiple access

   //  completed
   
   input                 smc_done15;   // one access completed
   input                 cste_enable15;// Enable15 CS15 Trailing15 Edge15 counter
   input                 ws_enable15;  // Enable15 Wait15 State15 counter
   input                 le_enable15;  // Enable15 all Leading15 Edge15 counters15
   
   // Counter15 outputs15
   
   output [1:0]             r_csle_count15;  //chip15 select15 leading15
                                             //  edge count
   output [1:0]             r_wele_count15;  //write strobe15 leading15 
                                             // edge count
   output [7:0] r_ws_count15;    //wait state count
   output [1:0]             r_cste_count15;  //chip15 select15 trailing15 
                                             // edge count
   
   // Stored15 counts15 for MAC15
   
   output [1:0]             r_oete_store15;  //read strobe15
   output [1:0]             r_wete_store15;  //write strobe15 trailing15 
                                              // edge store15
   output [7:0] r_ws_store15;    //wait state store15
   output [1:0]             r_wele_store15;  //write strobe15 leading15
                                             //  edge store15
   output [1:0]             r_csle_store15;  //chip15 select15  leading15
                                             //  edge store15
   
   
   // Counters15
   
   reg [1:0]             r_csle_count15;  // Chip15 select15 LE15 counter
   reg [1:0]             r_wele_count15;  // Write counter
   reg [7:0] r_ws_count15;    // Wait15 state select15 counter
   reg [1:0]             r_cste_count15;  // Chip15 select15 TE15 counter
   
   
   // These15 strobes15 finish early15 so no counter is required15. 
   // The stored15 value is compared with WS15 counter to determine15 
   // when the strobe15 should end.

   reg [1:0]    r_wete_store15;    // Write strobe15 TE15 end time before CS15
   reg [1:0]    r_oete_store15;    // Read strobe15 TE15 end time before CS15
   
   
   // The following15 four15 regisrers15 are used to store15 the configuration
   // during mulitple15 accesses. The counters15 are reloaded15 from these15
   // registers before each cycle.
   
   reg [1:0]             r_csle_store15;    // Chip15 select15 LE15 store15
   reg [1:0]             r_wele_store15;    // Write strobe15 LE15 store15
   reg [7:0] r_ws_store15;      // Wait15 state store15
   reg [1:0]             r_cste_store15;    // Chip15 Select15 TE15 delay
                                          //  (Bus15 float15 time)

   // wires15 used for meeting15 coding15 standards15
   
   wire         ws_count15;      //ORed15 r_ws_count15
   wire         wele_count15;    //ORed15 r_wele_count15
   wire         cste_count15;    //ORed15 r_cste_count15
   wire         mac_smc_done15;  //ANDed15 smc_done15 and not(mac_done15)
   wire [4:0]   case_cste15;     //concatenated15 signals15 for case statement15
   wire [4:0]   case_wele15;     //concatenated15 signals15 for case statement15
   wire [4:0]   case_ws15;       //concatenated15 signals15 for case statement15
   
   
   
   // Main15 Code15
   
//----------------------------------------------------------------------
// Counters15 (& Count15 Store15 for MAC15)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE15 Store15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)

begin   

   if (~(n_sys_reset15))
     
      r_wete_store15 <= 2'b00;
   
   
   else if (valid_access15)
     
      r_wete_store15 <= 2'b0;
   
   else
     
      r_wete_store15 <= r_wete_store15;

end
   
//----------------------------------------------------------------------
// OETE15 Store15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)

begin   

   if (~(n_sys_reset15))
     
      r_oete_store15 <= 2'b00;
   
   
   else if (valid_access15)
     
      r_oete_store15 <= 2'b0;
   
   else

      r_oete_store15 <= r_oete_store15;

end
   
//----------------------------------------------------------------------
// CSLE15 Store15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)

begin   

   if (~(n_sys_reset15))
     
      r_csle_store15 <= 2'b00;
   
   
   else if (valid_access15)
     
      r_csle_store15 <= 2'b00;
   
   else
     
      r_csle_store15 <= r_csle_store15;

end
   
//----------------------------------------------------------------------
// CSLE15 Counter15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)

begin   

   if (~(n_sys_reset15))
     
      r_csle_count15 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access15)
        
         r_csle_count15 <= 2'b00;
      
      else if (~(mac_done15) & smc_done15)
        
         r_csle_count15 <= r_csle_store15;
      
      else if (r_csle_count15 == 2'b00)
        
         r_csle_count15 <= r_csle_count15;
      
      else if (le_enable15)               
        
         r_csle_count15 <= r_csle_count15 - 2'd1;
      
      else
        
          r_csle_count15 <= r_csle_count15;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE15 Store15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)

begin   

   if (~(n_sys_reset15))

      r_cste_store15 <= 2'b00;

   else if (valid_access15)

      r_cste_store15 <= 2'b0;

   else

      r_cste_store15 <= r_cste_store15;

end
   
   
   
//----------------------------------------------------------------------
//concatenation15 of signals15 to avoid using nested15 ifs15
//----------------------------------------------------------------------

 assign mac_smc_done15 = (~(mac_done15) & smc_done15);
 assign cste_count15   = (|r_cste_count15);           //checks15 for count = 0
 assign case_cste15   = {1'b0,valid_access15,mac_smc_done15,cste_count15,
                       cste_enable15};
   
//----------------------------------------------------------------------
//CSTE15 COUNTER15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)

begin   

   if (~(n_sys_reset15))

      r_cste_count15 <= 2'b00;

   else 
   begin
      casex(case_cste15)
           
        5'b1xxxx:        r_cste_count15 <= r_cste_count15;

        5'b01xxx:        r_cste_count15 <= 2'b0;

        5'b001xx:        r_cste_count15 <= r_cste_store15;

        5'b0000x:        r_cste_count15 <= r_cste_count15;

        5'b00011:        r_cste_count15 <= r_cste_count15 - 2'd1;

        default :        r_cste_count15 <= r_cste_count15;

      endcase // casex(w_cste_case15)
      
   end
   
end

//----------------------------------------------------------------------
// WELE15 Store15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)

begin   

   if (~(n_sys_reset15))

      r_wele_store15 <= 2'b00;


   else if (valid_access15)

      r_wele_store15 <= 2'b00;

   else

      r_wele_store15 <= r_wele_store15;

end
   
   
   
//----------------------------------------------------------------------
//concatenation15 of signals15 to avoid using nested15 ifs15
//----------------------------------------------------------------------
   
   assign wele_count15   = (|r_wele_count15);         //checks15 for count = 0
   assign case_wele15   = {1'b0,valid_access15,mac_smc_done15,wele_count15,
                         le_enable15};
   
//----------------------------------------------------------------------
// WELE15 Counter15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)

begin   
   if (~(n_sys_reset15))

      r_wele_count15 <= 2'b00;

   else
   begin

      casex(case_wele15)

        5'b1xxxx :  r_wele_count15 <= r_wele_count15;

        5'b01xxx :  r_wele_count15 <= 2'b00;

        5'b001xx :  r_wele_count15 <= r_wele_store15;

        5'b0000x :  r_wele_count15 <= r_wele_count15;

        5'b00011 :  r_wele_count15 <= r_wele_count15 - (2'd1);

        default  :  r_wele_count15 <= r_wele_count15;

      endcase // casex(case_wele15)

   end

end
   
//----------------------------------------------------------------------
// WS15 Store15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)
  
begin   

   if (~(n_sys_reset15))

      r_ws_store15 <= 8'd0;


   else if (valid_access15)

      r_ws_store15 <= 8'h01;

   else

      r_ws_store15 <= r_ws_store15;

end
   
   
   
//----------------------------------------------------------------------
//concatenation15 of signals15 to avoid using nested15 ifs15
//----------------------------------------------------------------------
   
   assign ws_count15   = (|r_ws_count15); //checks15 for count = 0
   assign case_ws15   = {1'b0,valid_access15,mac_smc_done15,ws_count15,
                       ws_enable15};
   
//----------------------------------------------------------------------
// WS15 Counter15
//----------------------------------------------------------------------

always @(posedge sys_clk15 or negedge n_sys_reset15)

begin   

   if (~(n_sys_reset15))

      r_ws_count15 <= 8'd0;

   else  
   begin
   
      casex(case_ws15)
 
         5'b1xxxx :  
            r_ws_count15 <= r_ws_count15;
        
         5'b01xxx :
            r_ws_count15 <= 8'h01;
        
         5'b001xx :  
            r_ws_count15 <= r_ws_store15;
        
         5'b0000x :  
            r_ws_count15 <= r_ws_count15;
        
         5'b00011 :  
            r_ws_count15 <= r_ws_count15 - 8'd1;
        
         default  :  
            r_ws_count15 <= r_ws_count15;

      endcase // casex(case_ws15)
      
   end
   
end  
   
   
endmodule
