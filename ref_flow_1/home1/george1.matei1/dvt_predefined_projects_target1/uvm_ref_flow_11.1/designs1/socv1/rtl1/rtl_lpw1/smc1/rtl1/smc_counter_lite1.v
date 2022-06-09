//File1 name   : smc_counter_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : Counter1 block.
//            : Static1 Memory Controller1.
//            : The counter block provides1 generates1 all cycle timings1
//            : The leading1 edge counts1 are individual1 2bit, loadable1,
//            : counters1. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing1
//            : edge counts1 are registered for comparison1 with the
//            : wait state counter. The bus float1 (CSTE1) is a
//            : separate1 2bit counter. The initial count values are
//            : stored1 and reloaded1 into the counters1 if multiple
//            : accesses are required1.
//Notes1       : 
//----------------------------------------------------------------------
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


module smc_counter_lite1  (
                     //inputs1

                     sys_clk1,
                     n_sys_reset1,
                     valid_access1,
                     mac_done1, 
                     smc_done1, 
                     cste_enable1, 
                     ws_enable1,
                     le_enable1, 

                     //outputs1

                     r_csle_count1,
                     r_wele_count1,
                     r_ws_count1,
                     r_ws_store1,
                     r_oete_store1,
                     r_wete_store1,
                     r_wele_store1,
                     r_cste_count1,
                     r_csle_store1);
   

//----------------------------------------------------------------------
// the Wait1 State1 Counter1
//----------------------------------------------------------------------
   
   
   // I1/O1
   
   input     sys_clk1;                  // AHB1 System1 clock1
   input     n_sys_reset1;              // AHB1 System1 reset (Active1 LOW1)
   
   input     valid_access1;             // load1 values are valid if high1
   input     mac_done1;                 // All cycles1 in a multiple access

   //  completed
   
   input                 smc_done1;   // one access completed
   input                 cste_enable1;// Enable1 CS1 Trailing1 Edge1 counter
   input                 ws_enable1;  // Enable1 Wait1 State1 counter
   input                 le_enable1;  // Enable1 all Leading1 Edge1 counters1
   
   // Counter1 outputs1
   
   output [1:0]             r_csle_count1;  //chip1 select1 leading1
                                             //  edge count
   output [1:0]             r_wele_count1;  //write strobe1 leading1 
                                             // edge count
   output [7:0] r_ws_count1;    //wait state count
   output [1:0]             r_cste_count1;  //chip1 select1 trailing1 
                                             // edge count
   
   // Stored1 counts1 for MAC1
   
   output [1:0]             r_oete_store1;  //read strobe1
   output [1:0]             r_wete_store1;  //write strobe1 trailing1 
                                              // edge store1
   output [7:0] r_ws_store1;    //wait state store1
   output [1:0]             r_wele_store1;  //write strobe1 leading1
                                             //  edge store1
   output [1:0]             r_csle_store1;  //chip1 select1  leading1
                                             //  edge store1
   
   
   // Counters1
   
   reg [1:0]             r_csle_count1;  // Chip1 select1 LE1 counter
   reg [1:0]             r_wele_count1;  // Write counter
   reg [7:0] r_ws_count1;    // Wait1 state select1 counter
   reg [1:0]             r_cste_count1;  // Chip1 select1 TE1 counter
   
   
   // These1 strobes1 finish early1 so no counter is required1. 
   // The stored1 value is compared with WS1 counter to determine1 
   // when the strobe1 should end.

   reg [1:0]    r_wete_store1;    // Write strobe1 TE1 end time before CS1
   reg [1:0]    r_oete_store1;    // Read strobe1 TE1 end time before CS1
   
   
   // The following1 four1 regisrers1 are used to store1 the configuration
   // during mulitple1 accesses. The counters1 are reloaded1 from these1
   // registers before each cycle.
   
   reg [1:0]             r_csle_store1;    // Chip1 select1 LE1 store1
   reg [1:0]             r_wele_store1;    // Write strobe1 LE1 store1
   reg [7:0] r_ws_store1;      // Wait1 state store1
   reg [1:0]             r_cste_store1;    // Chip1 Select1 TE1 delay
                                          //  (Bus1 float1 time)

   // wires1 used for meeting1 coding1 standards1
   
   wire         ws_count1;      //ORed1 r_ws_count1
   wire         wele_count1;    //ORed1 r_wele_count1
   wire         cste_count1;    //ORed1 r_cste_count1
   wire         mac_smc_done1;  //ANDed1 smc_done1 and not(mac_done1)
   wire [4:0]   case_cste1;     //concatenated1 signals1 for case statement1
   wire [4:0]   case_wele1;     //concatenated1 signals1 for case statement1
   wire [4:0]   case_ws1;       //concatenated1 signals1 for case statement1
   
   
   
   // Main1 Code1
   
//----------------------------------------------------------------------
// Counters1 (& Count1 Store1 for MAC1)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE1 Store1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)

begin   

   if (~(n_sys_reset1))
     
      r_wete_store1 <= 2'b00;
   
   
   else if (valid_access1)
     
      r_wete_store1 <= 2'b0;
   
   else
     
      r_wete_store1 <= r_wete_store1;

end
   
//----------------------------------------------------------------------
// OETE1 Store1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)

begin   

   if (~(n_sys_reset1))
     
      r_oete_store1 <= 2'b00;
   
   
   else if (valid_access1)
     
      r_oete_store1 <= 2'b0;
   
   else

      r_oete_store1 <= r_oete_store1;

end
   
//----------------------------------------------------------------------
// CSLE1 Store1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)

begin   

   if (~(n_sys_reset1))
     
      r_csle_store1 <= 2'b00;
   
   
   else if (valid_access1)
     
      r_csle_store1 <= 2'b00;
   
   else
     
      r_csle_store1 <= r_csle_store1;

end
   
//----------------------------------------------------------------------
// CSLE1 Counter1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)

begin   

   if (~(n_sys_reset1))
     
      r_csle_count1 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access1)
        
         r_csle_count1 <= 2'b00;
      
      else if (~(mac_done1) & smc_done1)
        
         r_csle_count1 <= r_csle_store1;
      
      else if (r_csle_count1 == 2'b00)
        
         r_csle_count1 <= r_csle_count1;
      
      else if (le_enable1)               
        
         r_csle_count1 <= r_csle_count1 - 2'd1;
      
      else
        
          r_csle_count1 <= r_csle_count1;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE1 Store1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)

begin   

   if (~(n_sys_reset1))

      r_cste_store1 <= 2'b00;

   else if (valid_access1)

      r_cste_store1 <= 2'b0;

   else

      r_cste_store1 <= r_cste_store1;

end
   
   
   
//----------------------------------------------------------------------
//concatenation1 of signals1 to avoid using nested1 ifs1
//----------------------------------------------------------------------

 assign mac_smc_done1 = (~(mac_done1) & smc_done1);
 assign cste_count1   = (|r_cste_count1);           //checks1 for count = 0
 assign case_cste1   = {1'b0,valid_access1,mac_smc_done1,cste_count1,
                       cste_enable1};
   
//----------------------------------------------------------------------
//CSTE1 COUNTER1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)

begin   

   if (~(n_sys_reset1))

      r_cste_count1 <= 2'b00;

   else 
   begin
      casex(case_cste1)
           
        5'b1xxxx:        r_cste_count1 <= r_cste_count1;

        5'b01xxx:        r_cste_count1 <= 2'b0;

        5'b001xx:        r_cste_count1 <= r_cste_store1;

        5'b0000x:        r_cste_count1 <= r_cste_count1;

        5'b00011:        r_cste_count1 <= r_cste_count1 - 2'd1;

        default :        r_cste_count1 <= r_cste_count1;

      endcase // casex(w_cste_case1)
      
   end
   
end

//----------------------------------------------------------------------
// WELE1 Store1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)

begin   

   if (~(n_sys_reset1))

      r_wele_store1 <= 2'b00;


   else if (valid_access1)

      r_wele_store1 <= 2'b00;

   else

      r_wele_store1 <= r_wele_store1;

end
   
   
   
//----------------------------------------------------------------------
//concatenation1 of signals1 to avoid using nested1 ifs1
//----------------------------------------------------------------------
   
   assign wele_count1   = (|r_wele_count1);         //checks1 for count = 0
   assign case_wele1   = {1'b0,valid_access1,mac_smc_done1,wele_count1,
                         le_enable1};
   
//----------------------------------------------------------------------
// WELE1 Counter1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)

begin   
   if (~(n_sys_reset1))

      r_wele_count1 <= 2'b00;

   else
   begin

      casex(case_wele1)

        5'b1xxxx :  r_wele_count1 <= r_wele_count1;

        5'b01xxx :  r_wele_count1 <= 2'b00;

        5'b001xx :  r_wele_count1 <= r_wele_store1;

        5'b0000x :  r_wele_count1 <= r_wele_count1;

        5'b00011 :  r_wele_count1 <= r_wele_count1 - (2'd1);

        default  :  r_wele_count1 <= r_wele_count1;

      endcase // casex(case_wele1)

   end

end
   
//----------------------------------------------------------------------
// WS1 Store1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)
  
begin   

   if (~(n_sys_reset1))

      r_ws_store1 <= 8'd0;


   else if (valid_access1)

      r_ws_store1 <= 8'h01;

   else

      r_ws_store1 <= r_ws_store1;

end
   
   
   
//----------------------------------------------------------------------
//concatenation1 of signals1 to avoid using nested1 ifs1
//----------------------------------------------------------------------
   
   assign ws_count1   = (|r_ws_count1); //checks1 for count = 0
   assign case_ws1   = {1'b0,valid_access1,mac_smc_done1,ws_count1,
                       ws_enable1};
   
//----------------------------------------------------------------------
// WS1 Counter1
//----------------------------------------------------------------------

always @(posedge sys_clk1 or negedge n_sys_reset1)

begin   

   if (~(n_sys_reset1))

      r_ws_count1 <= 8'd0;

   else  
   begin
   
      casex(case_ws1)
 
         5'b1xxxx :  
            r_ws_count1 <= r_ws_count1;
        
         5'b01xxx :
            r_ws_count1 <= 8'h01;
        
         5'b001xx :  
            r_ws_count1 <= r_ws_store1;
        
         5'b0000x :  
            r_ws_count1 <= r_ws_count1;
        
         5'b00011 :  
            r_ws_count1 <= r_ws_count1 - 8'd1;
        
         default  :  
            r_ws_count1 <= r_ws_count1;

      endcase // casex(case_ws1)
      
   end
   
end  
   
   
endmodule
