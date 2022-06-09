//File20 name   : smc_counter_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : Counter20 block.
//            : Static20 Memory Controller20.
//            : The counter block provides20 generates20 all cycle timings20
//            : The leading20 edge counts20 are individual20 2bit, loadable20,
//            : counters20. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing20
//            : edge counts20 are registered for comparison20 with the
//            : wait state counter. The bus float20 (CSTE20) is a
//            : separate20 2bit counter. The initial count values are
//            : stored20 and reloaded20 into the counters20 if multiple
//            : accesses are required20.
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


module smc_counter_lite20  (
                     //inputs20

                     sys_clk20,
                     n_sys_reset20,
                     valid_access20,
                     mac_done20, 
                     smc_done20, 
                     cste_enable20, 
                     ws_enable20,
                     le_enable20, 

                     //outputs20

                     r_csle_count20,
                     r_wele_count20,
                     r_ws_count20,
                     r_ws_store20,
                     r_oete_store20,
                     r_wete_store20,
                     r_wele_store20,
                     r_cste_count20,
                     r_csle_store20);
   

//----------------------------------------------------------------------
// the Wait20 State20 Counter20
//----------------------------------------------------------------------
   
   
   // I20/O20
   
   input     sys_clk20;                  // AHB20 System20 clock20
   input     n_sys_reset20;              // AHB20 System20 reset (Active20 LOW20)
   
   input     valid_access20;             // load20 values are valid if high20
   input     mac_done20;                 // All cycles20 in a multiple access

   //  completed
   
   input                 smc_done20;   // one access completed
   input                 cste_enable20;// Enable20 CS20 Trailing20 Edge20 counter
   input                 ws_enable20;  // Enable20 Wait20 State20 counter
   input                 le_enable20;  // Enable20 all Leading20 Edge20 counters20
   
   // Counter20 outputs20
   
   output [1:0]             r_csle_count20;  //chip20 select20 leading20
                                             //  edge count
   output [1:0]             r_wele_count20;  //write strobe20 leading20 
                                             // edge count
   output [7:0] r_ws_count20;    //wait state count
   output [1:0]             r_cste_count20;  //chip20 select20 trailing20 
                                             // edge count
   
   // Stored20 counts20 for MAC20
   
   output [1:0]             r_oete_store20;  //read strobe20
   output [1:0]             r_wete_store20;  //write strobe20 trailing20 
                                              // edge store20
   output [7:0] r_ws_store20;    //wait state store20
   output [1:0]             r_wele_store20;  //write strobe20 leading20
                                             //  edge store20
   output [1:0]             r_csle_store20;  //chip20 select20  leading20
                                             //  edge store20
   
   
   // Counters20
   
   reg [1:0]             r_csle_count20;  // Chip20 select20 LE20 counter
   reg [1:0]             r_wele_count20;  // Write counter
   reg [7:0] r_ws_count20;    // Wait20 state select20 counter
   reg [1:0]             r_cste_count20;  // Chip20 select20 TE20 counter
   
   
   // These20 strobes20 finish early20 so no counter is required20. 
   // The stored20 value is compared with WS20 counter to determine20 
   // when the strobe20 should end.

   reg [1:0]    r_wete_store20;    // Write strobe20 TE20 end time before CS20
   reg [1:0]    r_oete_store20;    // Read strobe20 TE20 end time before CS20
   
   
   // The following20 four20 regisrers20 are used to store20 the configuration
   // during mulitple20 accesses. The counters20 are reloaded20 from these20
   // registers before each cycle.
   
   reg [1:0]             r_csle_store20;    // Chip20 select20 LE20 store20
   reg [1:0]             r_wele_store20;    // Write strobe20 LE20 store20
   reg [7:0] r_ws_store20;      // Wait20 state store20
   reg [1:0]             r_cste_store20;    // Chip20 Select20 TE20 delay
                                          //  (Bus20 float20 time)

   // wires20 used for meeting20 coding20 standards20
   
   wire         ws_count20;      //ORed20 r_ws_count20
   wire         wele_count20;    //ORed20 r_wele_count20
   wire         cste_count20;    //ORed20 r_cste_count20
   wire         mac_smc_done20;  //ANDed20 smc_done20 and not(mac_done20)
   wire [4:0]   case_cste20;     //concatenated20 signals20 for case statement20
   wire [4:0]   case_wele20;     //concatenated20 signals20 for case statement20
   wire [4:0]   case_ws20;       //concatenated20 signals20 for case statement20
   
   
   
   // Main20 Code20
   
//----------------------------------------------------------------------
// Counters20 (& Count20 Store20 for MAC20)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE20 Store20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)

begin   

   if (~(n_sys_reset20))
     
      r_wete_store20 <= 2'b00;
   
   
   else if (valid_access20)
     
      r_wete_store20 <= 2'b0;
   
   else
     
      r_wete_store20 <= r_wete_store20;

end
   
//----------------------------------------------------------------------
// OETE20 Store20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)

begin   

   if (~(n_sys_reset20))
     
      r_oete_store20 <= 2'b00;
   
   
   else if (valid_access20)
     
      r_oete_store20 <= 2'b0;
   
   else

      r_oete_store20 <= r_oete_store20;

end
   
//----------------------------------------------------------------------
// CSLE20 Store20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)

begin   

   if (~(n_sys_reset20))
     
      r_csle_store20 <= 2'b00;
   
   
   else if (valid_access20)
     
      r_csle_store20 <= 2'b00;
   
   else
     
      r_csle_store20 <= r_csle_store20;

end
   
//----------------------------------------------------------------------
// CSLE20 Counter20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)

begin   

   if (~(n_sys_reset20))
     
      r_csle_count20 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access20)
        
         r_csle_count20 <= 2'b00;
      
      else if (~(mac_done20) & smc_done20)
        
         r_csle_count20 <= r_csle_store20;
      
      else if (r_csle_count20 == 2'b00)
        
         r_csle_count20 <= r_csle_count20;
      
      else if (le_enable20)               
        
         r_csle_count20 <= r_csle_count20 - 2'd1;
      
      else
        
          r_csle_count20 <= r_csle_count20;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE20 Store20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)

begin   

   if (~(n_sys_reset20))

      r_cste_store20 <= 2'b00;

   else if (valid_access20)

      r_cste_store20 <= 2'b0;

   else

      r_cste_store20 <= r_cste_store20;

end
   
   
   
//----------------------------------------------------------------------
//concatenation20 of signals20 to avoid using nested20 ifs20
//----------------------------------------------------------------------

 assign mac_smc_done20 = (~(mac_done20) & smc_done20);
 assign cste_count20   = (|r_cste_count20);           //checks20 for count = 0
 assign case_cste20   = {1'b0,valid_access20,mac_smc_done20,cste_count20,
                       cste_enable20};
   
//----------------------------------------------------------------------
//CSTE20 COUNTER20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)

begin   

   if (~(n_sys_reset20))

      r_cste_count20 <= 2'b00;

   else 
   begin
      casex(case_cste20)
           
        5'b1xxxx:        r_cste_count20 <= r_cste_count20;

        5'b01xxx:        r_cste_count20 <= 2'b0;

        5'b001xx:        r_cste_count20 <= r_cste_store20;

        5'b0000x:        r_cste_count20 <= r_cste_count20;

        5'b00011:        r_cste_count20 <= r_cste_count20 - 2'd1;

        default :        r_cste_count20 <= r_cste_count20;

      endcase // casex(w_cste_case20)
      
   end
   
end

//----------------------------------------------------------------------
// WELE20 Store20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)

begin   

   if (~(n_sys_reset20))

      r_wele_store20 <= 2'b00;


   else if (valid_access20)

      r_wele_store20 <= 2'b00;

   else

      r_wele_store20 <= r_wele_store20;

end
   
   
   
//----------------------------------------------------------------------
//concatenation20 of signals20 to avoid using nested20 ifs20
//----------------------------------------------------------------------
   
   assign wele_count20   = (|r_wele_count20);         //checks20 for count = 0
   assign case_wele20   = {1'b0,valid_access20,mac_smc_done20,wele_count20,
                         le_enable20};
   
//----------------------------------------------------------------------
// WELE20 Counter20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)

begin   
   if (~(n_sys_reset20))

      r_wele_count20 <= 2'b00;

   else
   begin

      casex(case_wele20)

        5'b1xxxx :  r_wele_count20 <= r_wele_count20;

        5'b01xxx :  r_wele_count20 <= 2'b00;

        5'b001xx :  r_wele_count20 <= r_wele_store20;

        5'b0000x :  r_wele_count20 <= r_wele_count20;

        5'b00011 :  r_wele_count20 <= r_wele_count20 - (2'd1);

        default  :  r_wele_count20 <= r_wele_count20;

      endcase // casex(case_wele20)

   end

end
   
//----------------------------------------------------------------------
// WS20 Store20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)
  
begin   

   if (~(n_sys_reset20))

      r_ws_store20 <= 8'd0;


   else if (valid_access20)

      r_ws_store20 <= 8'h01;

   else

      r_ws_store20 <= r_ws_store20;

end
   
   
   
//----------------------------------------------------------------------
//concatenation20 of signals20 to avoid using nested20 ifs20
//----------------------------------------------------------------------
   
   assign ws_count20   = (|r_ws_count20); //checks20 for count = 0
   assign case_ws20   = {1'b0,valid_access20,mac_smc_done20,ws_count20,
                       ws_enable20};
   
//----------------------------------------------------------------------
// WS20 Counter20
//----------------------------------------------------------------------

always @(posedge sys_clk20 or negedge n_sys_reset20)

begin   

   if (~(n_sys_reset20))

      r_ws_count20 <= 8'd0;

   else  
   begin
   
      casex(case_ws20)
 
         5'b1xxxx :  
            r_ws_count20 <= r_ws_count20;
        
         5'b01xxx :
            r_ws_count20 <= 8'h01;
        
         5'b001xx :  
            r_ws_count20 <= r_ws_store20;
        
         5'b0000x :  
            r_ws_count20 <= r_ws_count20;
        
         5'b00011 :  
            r_ws_count20 <= r_ws_count20 - 8'd1;
        
         default  :  
            r_ws_count20 <= r_ws_count20;

      endcase // casex(case_ws20)
      
   end
   
end  
   
   
endmodule
