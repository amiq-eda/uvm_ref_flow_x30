//File2 name   : smc_counter_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : Counter2 block.
//            : Static2 Memory Controller2.
//            : The counter block provides2 generates2 all cycle timings2
//            : The leading2 edge counts2 are individual2 2bit, loadable2,
//            : counters2. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing2
//            : edge counts2 are registered for comparison2 with the
//            : wait state counter. The bus float2 (CSTE2) is a
//            : separate2 2bit counter. The initial count values are
//            : stored2 and reloaded2 into the counters2 if multiple
//            : accesses are required2.
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


module smc_counter_lite2  (
                     //inputs2

                     sys_clk2,
                     n_sys_reset2,
                     valid_access2,
                     mac_done2, 
                     smc_done2, 
                     cste_enable2, 
                     ws_enable2,
                     le_enable2, 

                     //outputs2

                     r_csle_count2,
                     r_wele_count2,
                     r_ws_count2,
                     r_ws_store2,
                     r_oete_store2,
                     r_wete_store2,
                     r_wele_store2,
                     r_cste_count2,
                     r_csle_store2);
   

//----------------------------------------------------------------------
// the Wait2 State2 Counter2
//----------------------------------------------------------------------
   
   
   // I2/O2
   
   input     sys_clk2;                  // AHB2 System2 clock2
   input     n_sys_reset2;              // AHB2 System2 reset (Active2 LOW2)
   
   input     valid_access2;             // load2 values are valid if high2
   input     mac_done2;                 // All cycles2 in a multiple access

   //  completed
   
   input                 smc_done2;   // one access completed
   input                 cste_enable2;// Enable2 CS2 Trailing2 Edge2 counter
   input                 ws_enable2;  // Enable2 Wait2 State2 counter
   input                 le_enable2;  // Enable2 all Leading2 Edge2 counters2
   
   // Counter2 outputs2
   
   output [1:0]             r_csle_count2;  //chip2 select2 leading2
                                             //  edge count
   output [1:0]             r_wele_count2;  //write strobe2 leading2 
                                             // edge count
   output [7:0] r_ws_count2;    //wait state count
   output [1:0]             r_cste_count2;  //chip2 select2 trailing2 
                                             // edge count
   
   // Stored2 counts2 for MAC2
   
   output [1:0]             r_oete_store2;  //read strobe2
   output [1:0]             r_wete_store2;  //write strobe2 trailing2 
                                              // edge store2
   output [7:0] r_ws_store2;    //wait state store2
   output [1:0]             r_wele_store2;  //write strobe2 leading2
                                             //  edge store2
   output [1:0]             r_csle_store2;  //chip2 select2  leading2
                                             //  edge store2
   
   
   // Counters2
   
   reg [1:0]             r_csle_count2;  // Chip2 select2 LE2 counter
   reg [1:0]             r_wele_count2;  // Write counter
   reg [7:0] r_ws_count2;    // Wait2 state select2 counter
   reg [1:0]             r_cste_count2;  // Chip2 select2 TE2 counter
   
   
   // These2 strobes2 finish early2 so no counter is required2. 
   // The stored2 value is compared with WS2 counter to determine2 
   // when the strobe2 should end.

   reg [1:0]    r_wete_store2;    // Write strobe2 TE2 end time before CS2
   reg [1:0]    r_oete_store2;    // Read strobe2 TE2 end time before CS2
   
   
   // The following2 four2 regisrers2 are used to store2 the configuration
   // during mulitple2 accesses. The counters2 are reloaded2 from these2
   // registers before each cycle.
   
   reg [1:0]             r_csle_store2;    // Chip2 select2 LE2 store2
   reg [1:0]             r_wele_store2;    // Write strobe2 LE2 store2
   reg [7:0] r_ws_store2;      // Wait2 state store2
   reg [1:0]             r_cste_store2;    // Chip2 Select2 TE2 delay
                                          //  (Bus2 float2 time)

   // wires2 used for meeting2 coding2 standards2
   
   wire         ws_count2;      //ORed2 r_ws_count2
   wire         wele_count2;    //ORed2 r_wele_count2
   wire         cste_count2;    //ORed2 r_cste_count2
   wire         mac_smc_done2;  //ANDed2 smc_done2 and not(mac_done2)
   wire [4:0]   case_cste2;     //concatenated2 signals2 for case statement2
   wire [4:0]   case_wele2;     //concatenated2 signals2 for case statement2
   wire [4:0]   case_ws2;       //concatenated2 signals2 for case statement2
   
   
   
   // Main2 Code2
   
//----------------------------------------------------------------------
// Counters2 (& Count2 Store2 for MAC2)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE2 Store2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)

begin   

   if (~(n_sys_reset2))
     
      r_wete_store2 <= 2'b00;
   
   
   else if (valid_access2)
     
      r_wete_store2 <= 2'b0;
   
   else
     
      r_wete_store2 <= r_wete_store2;

end
   
//----------------------------------------------------------------------
// OETE2 Store2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)

begin   

   if (~(n_sys_reset2))
     
      r_oete_store2 <= 2'b00;
   
   
   else if (valid_access2)
     
      r_oete_store2 <= 2'b0;
   
   else

      r_oete_store2 <= r_oete_store2;

end
   
//----------------------------------------------------------------------
// CSLE2 Store2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)

begin   

   if (~(n_sys_reset2))
     
      r_csle_store2 <= 2'b00;
   
   
   else if (valid_access2)
     
      r_csle_store2 <= 2'b00;
   
   else
     
      r_csle_store2 <= r_csle_store2;

end
   
//----------------------------------------------------------------------
// CSLE2 Counter2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)

begin   

   if (~(n_sys_reset2))
     
      r_csle_count2 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access2)
        
         r_csle_count2 <= 2'b00;
      
      else if (~(mac_done2) & smc_done2)
        
         r_csle_count2 <= r_csle_store2;
      
      else if (r_csle_count2 == 2'b00)
        
         r_csle_count2 <= r_csle_count2;
      
      else if (le_enable2)               
        
         r_csle_count2 <= r_csle_count2 - 2'd1;
      
      else
        
          r_csle_count2 <= r_csle_count2;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE2 Store2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)

begin   

   if (~(n_sys_reset2))

      r_cste_store2 <= 2'b00;

   else if (valid_access2)

      r_cste_store2 <= 2'b0;

   else

      r_cste_store2 <= r_cste_store2;

end
   
   
   
//----------------------------------------------------------------------
//concatenation2 of signals2 to avoid using nested2 ifs2
//----------------------------------------------------------------------

 assign mac_smc_done2 = (~(mac_done2) & smc_done2);
 assign cste_count2   = (|r_cste_count2);           //checks2 for count = 0
 assign case_cste2   = {1'b0,valid_access2,mac_smc_done2,cste_count2,
                       cste_enable2};
   
//----------------------------------------------------------------------
//CSTE2 COUNTER2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)

begin   

   if (~(n_sys_reset2))

      r_cste_count2 <= 2'b00;

   else 
   begin
      casex(case_cste2)
           
        5'b1xxxx:        r_cste_count2 <= r_cste_count2;

        5'b01xxx:        r_cste_count2 <= 2'b0;

        5'b001xx:        r_cste_count2 <= r_cste_store2;

        5'b0000x:        r_cste_count2 <= r_cste_count2;

        5'b00011:        r_cste_count2 <= r_cste_count2 - 2'd1;

        default :        r_cste_count2 <= r_cste_count2;

      endcase // casex(w_cste_case2)
      
   end
   
end

//----------------------------------------------------------------------
// WELE2 Store2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)

begin   

   if (~(n_sys_reset2))

      r_wele_store2 <= 2'b00;


   else if (valid_access2)

      r_wele_store2 <= 2'b00;

   else

      r_wele_store2 <= r_wele_store2;

end
   
   
   
//----------------------------------------------------------------------
//concatenation2 of signals2 to avoid using nested2 ifs2
//----------------------------------------------------------------------
   
   assign wele_count2   = (|r_wele_count2);         //checks2 for count = 0
   assign case_wele2   = {1'b0,valid_access2,mac_smc_done2,wele_count2,
                         le_enable2};
   
//----------------------------------------------------------------------
// WELE2 Counter2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)

begin   
   if (~(n_sys_reset2))

      r_wele_count2 <= 2'b00;

   else
   begin

      casex(case_wele2)

        5'b1xxxx :  r_wele_count2 <= r_wele_count2;

        5'b01xxx :  r_wele_count2 <= 2'b00;

        5'b001xx :  r_wele_count2 <= r_wele_store2;

        5'b0000x :  r_wele_count2 <= r_wele_count2;

        5'b00011 :  r_wele_count2 <= r_wele_count2 - (2'd1);

        default  :  r_wele_count2 <= r_wele_count2;

      endcase // casex(case_wele2)

   end

end
   
//----------------------------------------------------------------------
// WS2 Store2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)
  
begin   

   if (~(n_sys_reset2))

      r_ws_store2 <= 8'd0;


   else if (valid_access2)

      r_ws_store2 <= 8'h01;

   else

      r_ws_store2 <= r_ws_store2;

end
   
   
   
//----------------------------------------------------------------------
//concatenation2 of signals2 to avoid using nested2 ifs2
//----------------------------------------------------------------------
   
   assign ws_count2   = (|r_ws_count2); //checks2 for count = 0
   assign case_ws2   = {1'b0,valid_access2,mac_smc_done2,ws_count2,
                       ws_enable2};
   
//----------------------------------------------------------------------
// WS2 Counter2
//----------------------------------------------------------------------

always @(posedge sys_clk2 or negedge n_sys_reset2)

begin   

   if (~(n_sys_reset2))

      r_ws_count2 <= 8'd0;

   else  
   begin
   
      casex(case_ws2)
 
         5'b1xxxx :  
            r_ws_count2 <= r_ws_count2;
        
         5'b01xxx :
            r_ws_count2 <= 8'h01;
        
         5'b001xx :  
            r_ws_count2 <= r_ws_store2;
        
         5'b0000x :  
            r_ws_count2 <= r_ws_count2;
        
         5'b00011 :  
            r_ws_count2 <= r_ws_count2 - 8'd1;
        
         default  :  
            r_ws_count2 <= r_ws_count2;

      endcase // casex(case_ws2)
      
   end
   
end  
   
   
endmodule
