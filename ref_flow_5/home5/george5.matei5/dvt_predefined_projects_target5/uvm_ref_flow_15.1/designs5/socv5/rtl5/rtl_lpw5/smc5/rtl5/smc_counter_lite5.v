//File5 name   : smc_counter_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : Counter5 block.
//            : Static5 Memory Controller5.
//            : The counter block provides5 generates5 all cycle timings5
//            : The leading5 edge counts5 are individual5 2bit, loadable5,
//            : counters5. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing5
//            : edge counts5 are registered for comparison5 with the
//            : wait state counter. The bus float5 (CSTE5) is a
//            : separate5 2bit counter. The initial count values are
//            : stored5 and reloaded5 into the counters5 if multiple
//            : accesses are required5.
//Notes5       : 
//----------------------------------------------------------------------
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


module smc_counter_lite5  (
                     //inputs5

                     sys_clk5,
                     n_sys_reset5,
                     valid_access5,
                     mac_done5, 
                     smc_done5, 
                     cste_enable5, 
                     ws_enable5,
                     le_enable5, 

                     //outputs5

                     r_csle_count5,
                     r_wele_count5,
                     r_ws_count5,
                     r_ws_store5,
                     r_oete_store5,
                     r_wete_store5,
                     r_wele_store5,
                     r_cste_count5,
                     r_csle_store5);
   

//----------------------------------------------------------------------
// the Wait5 State5 Counter5
//----------------------------------------------------------------------
   
   
   // I5/O5
   
   input     sys_clk5;                  // AHB5 System5 clock5
   input     n_sys_reset5;              // AHB5 System5 reset (Active5 LOW5)
   
   input     valid_access5;             // load5 values are valid if high5
   input     mac_done5;                 // All cycles5 in a multiple access

   //  completed
   
   input                 smc_done5;   // one access completed
   input                 cste_enable5;// Enable5 CS5 Trailing5 Edge5 counter
   input                 ws_enable5;  // Enable5 Wait5 State5 counter
   input                 le_enable5;  // Enable5 all Leading5 Edge5 counters5
   
   // Counter5 outputs5
   
   output [1:0]             r_csle_count5;  //chip5 select5 leading5
                                             //  edge count
   output [1:0]             r_wele_count5;  //write strobe5 leading5 
                                             // edge count
   output [7:0] r_ws_count5;    //wait state count
   output [1:0]             r_cste_count5;  //chip5 select5 trailing5 
                                             // edge count
   
   // Stored5 counts5 for MAC5
   
   output [1:0]             r_oete_store5;  //read strobe5
   output [1:0]             r_wete_store5;  //write strobe5 trailing5 
                                              // edge store5
   output [7:0] r_ws_store5;    //wait state store5
   output [1:0]             r_wele_store5;  //write strobe5 leading5
                                             //  edge store5
   output [1:0]             r_csle_store5;  //chip5 select5  leading5
                                             //  edge store5
   
   
   // Counters5
   
   reg [1:0]             r_csle_count5;  // Chip5 select5 LE5 counter
   reg [1:0]             r_wele_count5;  // Write counter
   reg [7:0] r_ws_count5;    // Wait5 state select5 counter
   reg [1:0]             r_cste_count5;  // Chip5 select5 TE5 counter
   
   
   // These5 strobes5 finish early5 so no counter is required5. 
   // The stored5 value is compared with WS5 counter to determine5 
   // when the strobe5 should end.

   reg [1:0]    r_wete_store5;    // Write strobe5 TE5 end time before CS5
   reg [1:0]    r_oete_store5;    // Read strobe5 TE5 end time before CS5
   
   
   // The following5 four5 regisrers5 are used to store5 the configuration
   // during mulitple5 accesses. The counters5 are reloaded5 from these5
   // registers before each cycle.
   
   reg [1:0]             r_csle_store5;    // Chip5 select5 LE5 store5
   reg [1:0]             r_wele_store5;    // Write strobe5 LE5 store5
   reg [7:0] r_ws_store5;      // Wait5 state store5
   reg [1:0]             r_cste_store5;    // Chip5 Select5 TE5 delay
                                          //  (Bus5 float5 time)

   // wires5 used for meeting5 coding5 standards5
   
   wire         ws_count5;      //ORed5 r_ws_count5
   wire         wele_count5;    //ORed5 r_wele_count5
   wire         cste_count5;    //ORed5 r_cste_count5
   wire         mac_smc_done5;  //ANDed5 smc_done5 and not(mac_done5)
   wire [4:0]   case_cste5;     //concatenated5 signals5 for case statement5
   wire [4:0]   case_wele5;     //concatenated5 signals5 for case statement5
   wire [4:0]   case_ws5;       //concatenated5 signals5 for case statement5
   
   
   
   // Main5 Code5
   
//----------------------------------------------------------------------
// Counters5 (& Count5 Store5 for MAC5)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE5 Store5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)

begin   

   if (~(n_sys_reset5))
     
      r_wete_store5 <= 2'b00;
   
   
   else if (valid_access5)
     
      r_wete_store5 <= 2'b0;
   
   else
     
      r_wete_store5 <= r_wete_store5;

end
   
//----------------------------------------------------------------------
// OETE5 Store5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)

begin   

   if (~(n_sys_reset5))
     
      r_oete_store5 <= 2'b00;
   
   
   else if (valid_access5)
     
      r_oete_store5 <= 2'b0;
   
   else

      r_oete_store5 <= r_oete_store5;

end
   
//----------------------------------------------------------------------
// CSLE5 Store5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)

begin   

   if (~(n_sys_reset5))
     
      r_csle_store5 <= 2'b00;
   
   
   else if (valid_access5)
     
      r_csle_store5 <= 2'b00;
   
   else
     
      r_csle_store5 <= r_csle_store5;

end
   
//----------------------------------------------------------------------
// CSLE5 Counter5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)

begin   

   if (~(n_sys_reset5))
     
      r_csle_count5 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access5)
        
         r_csle_count5 <= 2'b00;
      
      else if (~(mac_done5) & smc_done5)
        
         r_csle_count5 <= r_csle_store5;
      
      else if (r_csle_count5 == 2'b00)
        
         r_csle_count5 <= r_csle_count5;
      
      else if (le_enable5)               
        
         r_csle_count5 <= r_csle_count5 - 2'd1;
      
      else
        
          r_csle_count5 <= r_csle_count5;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE5 Store5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)

begin   

   if (~(n_sys_reset5))

      r_cste_store5 <= 2'b00;

   else if (valid_access5)

      r_cste_store5 <= 2'b0;

   else

      r_cste_store5 <= r_cste_store5;

end
   
   
   
//----------------------------------------------------------------------
//concatenation5 of signals5 to avoid using nested5 ifs5
//----------------------------------------------------------------------

 assign mac_smc_done5 = (~(mac_done5) & smc_done5);
 assign cste_count5   = (|r_cste_count5);           //checks5 for count = 0
 assign case_cste5   = {1'b0,valid_access5,mac_smc_done5,cste_count5,
                       cste_enable5};
   
//----------------------------------------------------------------------
//CSTE5 COUNTER5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)

begin   

   if (~(n_sys_reset5))

      r_cste_count5 <= 2'b00;

   else 
   begin
      casex(case_cste5)
           
        5'b1xxxx:        r_cste_count5 <= r_cste_count5;

        5'b01xxx:        r_cste_count5 <= 2'b0;

        5'b001xx:        r_cste_count5 <= r_cste_store5;

        5'b0000x:        r_cste_count5 <= r_cste_count5;

        5'b00011:        r_cste_count5 <= r_cste_count5 - 2'd1;

        default :        r_cste_count5 <= r_cste_count5;

      endcase // casex(w_cste_case5)
      
   end
   
end

//----------------------------------------------------------------------
// WELE5 Store5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)

begin   

   if (~(n_sys_reset5))

      r_wele_store5 <= 2'b00;


   else if (valid_access5)

      r_wele_store5 <= 2'b00;

   else

      r_wele_store5 <= r_wele_store5;

end
   
   
   
//----------------------------------------------------------------------
//concatenation5 of signals5 to avoid using nested5 ifs5
//----------------------------------------------------------------------
   
   assign wele_count5   = (|r_wele_count5);         //checks5 for count = 0
   assign case_wele5   = {1'b0,valid_access5,mac_smc_done5,wele_count5,
                         le_enable5};
   
//----------------------------------------------------------------------
// WELE5 Counter5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)

begin   
   if (~(n_sys_reset5))

      r_wele_count5 <= 2'b00;

   else
   begin

      casex(case_wele5)

        5'b1xxxx :  r_wele_count5 <= r_wele_count5;

        5'b01xxx :  r_wele_count5 <= 2'b00;

        5'b001xx :  r_wele_count5 <= r_wele_store5;

        5'b0000x :  r_wele_count5 <= r_wele_count5;

        5'b00011 :  r_wele_count5 <= r_wele_count5 - (2'd1);

        default  :  r_wele_count5 <= r_wele_count5;

      endcase // casex(case_wele5)

   end

end
   
//----------------------------------------------------------------------
// WS5 Store5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)
  
begin   

   if (~(n_sys_reset5))

      r_ws_store5 <= 8'd0;


   else if (valid_access5)

      r_ws_store5 <= 8'h01;

   else

      r_ws_store5 <= r_ws_store5;

end
   
   
   
//----------------------------------------------------------------------
//concatenation5 of signals5 to avoid using nested5 ifs5
//----------------------------------------------------------------------
   
   assign ws_count5   = (|r_ws_count5); //checks5 for count = 0
   assign case_ws5   = {1'b0,valid_access5,mac_smc_done5,ws_count5,
                       ws_enable5};
   
//----------------------------------------------------------------------
// WS5 Counter5
//----------------------------------------------------------------------

always @(posedge sys_clk5 or negedge n_sys_reset5)

begin   

   if (~(n_sys_reset5))

      r_ws_count5 <= 8'd0;

   else  
   begin
   
      casex(case_ws5)
 
         5'b1xxxx :  
            r_ws_count5 <= r_ws_count5;
        
         5'b01xxx :
            r_ws_count5 <= 8'h01;
        
         5'b001xx :  
            r_ws_count5 <= r_ws_store5;
        
         5'b0000x :  
            r_ws_count5 <= r_ws_count5;
        
         5'b00011 :  
            r_ws_count5 <= r_ws_count5 - 8'd1;
        
         default  :  
            r_ws_count5 <= r_ws_count5;

      endcase // casex(case_ws5)
      
   end
   
end  
   
   
endmodule
