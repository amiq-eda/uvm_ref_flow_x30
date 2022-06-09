//File8 name   : smc_counter_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : Counter8 block.
//            : Static8 Memory Controller8.
//            : The counter block provides8 generates8 all cycle timings8
//            : The leading8 edge counts8 are individual8 2bit, loadable8,
//            : counters8. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing8
//            : edge counts8 are registered for comparison8 with the
//            : wait state counter. The bus float8 (CSTE8) is a
//            : separate8 2bit counter. The initial count values are
//            : stored8 and reloaded8 into the counters8 if multiple
//            : accesses are required8.
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


module smc_counter_lite8  (
                     //inputs8

                     sys_clk8,
                     n_sys_reset8,
                     valid_access8,
                     mac_done8, 
                     smc_done8, 
                     cste_enable8, 
                     ws_enable8,
                     le_enable8, 

                     //outputs8

                     r_csle_count8,
                     r_wele_count8,
                     r_ws_count8,
                     r_ws_store8,
                     r_oete_store8,
                     r_wete_store8,
                     r_wele_store8,
                     r_cste_count8,
                     r_csle_store8);
   

//----------------------------------------------------------------------
// the Wait8 State8 Counter8
//----------------------------------------------------------------------
   
   
   // I8/O8
   
   input     sys_clk8;                  // AHB8 System8 clock8
   input     n_sys_reset8;              // AHB8 System8 reset (Active8 LOW8)
   
   input     valid_access8;             // load8 values are valid if high8
   input     mac_done8;                 // All cycles8 in a multiple access

   //  completed
   
   input                 smc_done8;   // one access completed
   input                 cste_enable8;// Enable8 CS8 Trailing8 Edge8 counter
   input                 ws_enable8;  // Enable8 Wait8 State8 counter
   input                 le_enable8;  // Enable8 all Leading8 Edge8 counters8
   
   // Counter8 outputs8
   
   output [1:0]             r_csle_count8;  //chip8 select8 leading8
                                             //  edge count
   output [1:0]             r_wele_count8;  //write strobe8 leading8 
                                             // edge count
   output [7:0] r_ws_count8;    //wait state count
   output [1:0]             r_cste_count8;  //chip8 select8 trailing8 
                                             // edge count
   
   // Stored8 counts8 for MAC8
   
   output [1:0]             r_oete_store8;  //read strobe8
   output [1:0]             r_wete_store8;  //write strobe8 trailing8 
                                              // edge store8
   output [7:0] r_ws_store8;    //wait state store8
   output [1:0]             r_wele_store8;  //write strobe8 leading8
                                             //  edge store8
   output [1:0]             r_csle_store8;  //chip8 select8  leading8
                                             //  edge store8
   
   
   // Counters8
   
   reg [1:0]             r_csle_count8;  // Chip8 select8 LE8 counter
   reg [1:0]             r_wele_count8;  // Write counter
   reg [7:0] r_ws_count8;    // Wait8 state select8 counter
   reg [1:0]             r_cste_count8;  // Chip8 select8 TE8 counter
   
   
   // These8 strobes8 finish early8 so no counter is required8. 
   // The stored8 value is compared with WS8 counter to determine8 
   // when the strobe8 should end.

   reg [1:0]    r_wete_store8;    // Write strobe8 TE8 end time before CS8
   reg [1:0]    r_oete_store8;    // Read strobe8 TE8 end time before CS8
   
   
   // The following8 four8 regisrers8 are used to store8 the configuration
   // during mulitple8 accesses. The counters8 are reloaded8 from these8
   // registers before each cycle.
   
   reg [1:0]             r_csle_store8;    // Chip8 select8 LE8 store8
   reg [1:0]             r_wele_store8;    // Write strobe8 LE8 store8
   reg [7:0] r_ws_store8;      // Wait8 state store8
   reg [1:0]             r_cste_store8;    // Chip8 Select8 TE8 delay
                                          //  (Bus8 float8 time)

   // wires8 used for meeting8 coding8 standards8
   
   wire         ws_count8;      //ORed8 r_ws_count8
   wire         wele_count8;    //ORed8 r_wele_count8
   wire         cste_count8;    //ORed8 r_cste_count8
   wire         mac_smc_done8;  //ANDed8 smc_done8 and not(mac_done8)
   wire [4:0]   case_cste8;     //concatenated8 signals8 for case statement8
   wire [4:0]   case_wele8;     //concatenated8 signals8 for case statement8
   wire [4:0]   case_ws8;       //concatenated8 signals8 for case statement8
   
   
   
   // Main8 Code8
   
//----------------------------------------------------------------------
// Counters8 (& Count8 Store8 for MAC8)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE8 Store8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)

begin   

   if (~(n_sys_reset8))
     
      r_wete_store8 <= 2'b00;
   
   
   else if (valid_access8)
     
      r_wete_store8 <= 2'b0;
   
   else
     
      r_wete_store8 <= r_wete_store8;

end
   
//----------------------------------------------------------------------
// OETE8 Store8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)

begin   

   if (~(n_sys_reset8))
     
      r_oete_store8 <= 2'b00;
   
   
   else if (valid_access8)
     
      r_oete_store8 <= 2'b0;
   
   else

      r_oete_store8 <= r_oete_store8;

end
   
//----------------------------------------------------------------------
// CSLE8 Store8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)

begin   

   if (~(n_sys_reset8))
     
      r_csle_store8 <= 2'b00;
   
   
   else if (valid_access8)
     
      r_csle_store8 <= 2'b00;
   
   else
     
      r_csle_store8 <= r_csle_store8;

end
   
//----------------------------------------------------------------------
// CSLE8 Counter8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)

begin   

   if (~(n_sys_reset8))
     
      r_csle_count8 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access8)
        
         r_csle_count8 <= 2'b00;
      
      else if (~(mac_done8) & smc_done8)
        
         r_csle_count8 <= r_csle_store8;
      
      else if (r_csle_count8 == 2'b00)
        
         r_csle_count8 <= r_csle_count8;
      
      else if (le_enable8)               
        
         r_csle_count8 <= r_csle_count8 - 2'd1;
      
      else
        
          r_csle_count8 <= r_csle_count8;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE8 Store8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)

begin   

   if (~(n_sys_reset8))

      r_cste_store8 <= 2'b00;

   else if (valid_access8)

      r_cste_store8 <= 2'b0;

   else

      r_cste_store8 <= r_cste_store8;

end
   
   
   
//----------------------------------------------------------------------
//concatenation8 of signals8 to avoid using nested8 ifs8
//----------------------------------------------------------------------

 assign mac_smc_done8 = (~(mac_done8) & smc_done8);
 assign cste_count8   = (|r_cste_count8);           //checks8 for count = 0
 assign case_cste8   = {1'b0,valid_access8,mac_smc_done8,cste_count8,
                       cste_enable8};
   
//----------------------------------------------------------------------
//CSTE8 COUNTER8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)

begin   

   if (~(n_sys_reset8))

      r_cste_count8 <= 2'b00;

   else 
   begin
      casex(case_cste8)
           
        5'b1xxxx:        r_cste_count8 <= r_cste_count8;

        5'b01xxx:        r_cste_count8 <= 2'b0;

        5'b001xx:        r_cste_count8 <= r_cste_store8;

        5'b0000x:        r_cste_count8 <= r_cste_count8;

        5'b00011:        r_cste_count8 <= r_cste_count8 - 2'd1;

        default :        r_cste_count8 <= r_cste_count8;

      endcase // casex(w_cste_case8)
      
   end
   
end

//----------------------------------------------------------------------
// WELE8 Store8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)

begin   

   if (~(n_sys_reset8))

      r_wele_store8 <= 2'b00;


   else if (valid_access8)

      r_wele_store8 <= 2'b00;

   else

      r_wele_store8 <= r_wele_store8;

end
   
   
   
//----------------------------------------------------------------------
//concatenation8 of signals8 to avoid using nested8 ifs8
//----------------------------------------------------------------------
   
   assign wele_count8   = (|r_wele_count8);         //checks8 for count = 0
   assign case_wele8   = {1'b0,valid_access8,mac_smc_done8,wele_count8,
                         le_enable8};
   
//----------------------------------------------------------------------
// WELE8 Counter8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)

begin   
   if (~(n_sys_reset8))

      r_wele_count8 <= 2'b00;

   else
   begin

      casex(case_wele8)

        5'b1xxxx :  r_wele_count8 <= r_wele_count8;

        5'b01xxx :  r_wele_count8 <= 2'b00;

        5'b001xx :  r_wele_count8 <= r_wele_store8;

        5'b0000x :  r_wele_count8 <= r_wele_count8;

        5'b00011 :  r_wele_count8 <= r_wele_count8 - (2'd1);

        default  :  r_wele_count8 <= r_wele_count8;

      endcase // casex(case_wele8)

   end

end
   
//----------------------------------------------------------------------
// WS8 Store8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)
  
begin   

   if (~(n_sys_reset8))

      r_ws_store8 <= 8'd0;


   else if (valid_access8)

      r_ws_store8 <= 8'h01;

   else

      r_ws_store8 <= r_ws_store8;

end
   
   
   
//----------------------------------------------------------------------
//concatenation8 of signals8 to avoid using nested8 ifs8
//----------------------------------------------------------------------
   
   assign ws_count8   = (|r_ws_count8); //checks8 for count = 0
   assign case_ws8   = {1'b0,valid_access8,mac_smc_done8,ws_count8,
                       ws_enable8};
   
//----------------------------------------------------------------------
// WS8 Counter8
//----------------------------------------------------------------------

always @(posedge sys_clk8 or negedge n_sys_reset8)

begin   

   if (~(n_sys_reset8))

      r_ws_count8 <= 8'd0;

   else  
   begin
   
      casex(case_ws8)
 
         5'b1xxxx :  
            r_ws_count8 <= r_ws_count8;
        
         5'b01xxx :
            r_ws_count8 <= 8'h01;
        
         5'b001xx :  
            r_ws_count8 <= r_ws_store8;
        
         5'b0000x :  
            r_ws_count8 <= r_ws_count8;
        
         5'b00011 :  
            r_ws_count8 <= r_ws_count8 - 8'd1;
        
         default  :  
            r_ws_count8 <= r_ws_count8;

      endcase // casex(case_ws8)
      
   end
   
end  
   
   
endmodule
