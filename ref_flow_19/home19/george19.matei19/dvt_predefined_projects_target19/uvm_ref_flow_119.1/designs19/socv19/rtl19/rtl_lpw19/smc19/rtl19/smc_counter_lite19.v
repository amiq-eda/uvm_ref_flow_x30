//File19 name   : smc_counter_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : Counter19 block.
//            : Static19 Memory Controller19.
//            : The counter block provides19 generates19 all cycle timings19
//            : The leading19 edge counts19 are individual19 2bit, loadable19,
//            : counters19. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing19
//            : edge counts19 are registered for comparison19 with the
//            : wait state counter. The bus float19 (CSTE19) is a
//            : separate19 2bit counter. The initial count values are
//            : stored19 and reloaded19 into the counters19 if multiple
//            : accesses are required19.
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


module smc_counter_lite19  (
                     //inputs19

                     sys_clk19,
                     n_sys_reset19,
                     valid_access19,
                     mac_done19, 
                     smc_done19, 
                     cste_enable19, 
                     ws_enable19,
                     le_enable19, 

                     //outputs19

                     r_csle_count19,
                     r_wele_count19,
                     r_ws_count19,
                     r_ws_store19,
                     r_oete_store19,
                     r_wete_store19,
                     r_wele_store19,
                     r_cste_count19,
                     r_csle_store19);
   

//----------------------------------------------------------------------
// the Wait19 State19 Counter19
//----------------------------------------------------------------------
   
   
   // I19/O19
   
   input     sys_clk19;                  // AHB19 System19 clock19
   input     n_sys_reset19;              // AHB19 System19 reset (Active19 LOW19)
   
   input     valid_access19;             // load19 values are valid if high19
   input     mac_done19;                 // All cycles19 in a multiple access

   //  completed
   
   input                 smc_done19;   // one access completed
   input                 cste_enable19;// Enable19 CS19 Trailing19 Edge19 counter
   input                 ws_enable19;  // Enable19 Wait19 State19 counter
   input                 le_enable19;  // Enable19 all Leading19 Edge19 counters19
   
   // Counter19 outputs19
   
   output [1:0]             r_csle_count19;  //chip19 select19 leading19
                                             //  edge count
   output [1:0]             r_wele_count19;  //write strobe19 leading19 
                                             // edge count
   output [7:0] r_ws_count19;    //wait state count
   output [1:0]             r_cste_count19;  //chip19 select19 trailing19 
                                             // edge count
   
   // Stored19 counts19 for MAC19
   
   output [1:0]             r_oete_store19;  //read strobe19
   output [1:0]             r_wete_store19;  //write strobe19 trailing19 
                                              // edge store19
   output [7:0] r_ws_store19;    //wait state store19
   output [1:0]             r_wele_store19;  //write strobe19 leading19
                                             //  edge store19
   output [1:0]             r_csle_store19;  //chip19 select19  leading19
                                             //  edge store19
   
   
   // Counters19
   
   reg [1:0]             r_csle_count19;  // Chip19 select19 LE19 counter
   reg [1:0]             r_wele_count19;  // Write counter
   reg [7:0] r_ws_count19;    // Wait19 state select19 counter
   reg [1:0]             r_cste_count19;  // Chip19 select19 TE19 counter
   
   
   // These19 strobes19 finish early19 so no counter is required19. 
   // The stored19 value is compared with WS19 counter to determine19 
   // when the strobe19 should end.

   reg [1:0]    r_wete_store19;    // Write strobe19 TE19 end time before CS19
   reg [1:0]    r_oete_store19;    // Read strobe19 TE19 end time before CS19
   
   
   // The following19 four19 regisrers19 are used to store19 the configuration
   // during mulitple19 accesses. The counters19 are reloaded19 from these19
   // registers before each cycle.
   
   reg [1:0]             r_csle_store19;    // Chip19 select19 LE19 store19
   reg [1:0]             r_wele_store19;    // Write strobe19 LE19 store19
   reg [7:0] r_ws_store19;      // Wait19 state store19
   reg [1:0]             r_cste_store19;    // Chip19 Select19 TE19 delay
                                          //  (Bus19 float19 time)

   // wires19 used for meeting19 coding19 standards19
   
   wire         ws_count19;      //ORed19 r_ws_count19
   wire         wele_count19;    //ORed19 r_wele_count19
   wire         cste_count19;    //ORed19 r_cste_count19
   wire         mac_smc_done19;  //ANDed19 smc_done19 and not(mac_done19)
   wire [4:0]   case_cste19;     //concatenated19 signals19 for case statement19
   wire [4:0]   case_wele19;     //concatenated19 signals19 for case statement19
   wire [4:0]   case_ws19;       //concatenated19 signals19 for case statement19
   
   
   
   // Main19 Code19
   
//----------------------------------------------------------------------
// Counters19 (& Count19 Store19 for MAC19)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE19 Store19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)

begin   

   if (~(n_sys_reset19))
     
      r_wete_store19 <= 2'b00;
   
   
   else if (valid_access19)
     
      r_wete_store19 <= 2'b0;
   
   else
     
      r_wete_store19 <= r_wete_store19;

end
   
//----------------------------------------------------------------------
// OETE19 Store19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)

begin   

   if (~(n_sys_reset19))
     
      r_oete_store19 <= 2'b00;
   
   
   else if (valid_access19)
     
      r_oete_store19 <= 2'b0;
   
   else

      r_oete_store19 <= r_oete_store19;

end
   
//----------------------------------------------------------------------
// CSLE19 Store19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)

begin   

   if (~(n_sys_reset19))
     
      r_csle_store19 <= 2'b00;
   
   
   else if (valid_access19)
     
      r_csle_store19 <= 2'b00;
   
   else
     
      r_csle_store19 <= r_csle_store19;

end
   
//----------------------------------------------------------------------
// CSLE19 Counter19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)

begin   

   if (~(n_sys_reset19))
     
      r_csle_count19 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access19)
        
         r_csle_count19 <= 2'b00;
      
      else if (~(mac_done19) & smc_done19)
        
         r_csle_count19 <= r_csle_store19;
      
      else if (r_csle_count19 == 2'b00)
        
         r_csle_count19 <= r_csle_count19;
      
      else if (le_enable19)               
        
         r_csle_count19 <= r_csle_count19 - 2'd1;
      
      else
        
          r_csle_count19 <= r_csle_count19;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE19 Store19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)

begin   

   if (~(n_sys_reset19))

      r_cste_store19 <= 2'b00;

   else if (valid_access19)

      r_cste_store19 <= 2'b0;

   else

      r_cste_store19 <= r_cste_store19;

end
   
   
   
//----------------------------------------------------------------------
//concatenation19 of signals19 to avoid using nested19 ifs19
//----------------------------------------------------------------------

 assign mac_smc_done19 = (~(mac_done19) & smc_done19);
 assign cste_count19   = (|r_cste_count19);           //checks19 for count = 0
 assign case_cste19   = {1'b0,valid_access19,mac_smc_done19,cste_count19,
                       cste_enable19};
   
//----------------------------------------------------------------------
//CSTE19 COUNTER19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)

begin   

   if (~(n_sys_reset19))

      r_cste_count19 <= 2'b00;

   else 
   begin
      casex(case_cste19)
           
        5'b1xxxx:        r_cste_count19 <= r_cste_count19;

        5'b01xxx:        r_cste_count19 <= 2'b0;

        5'b001xx:        r_cste_count19 <= r_cste_store19;

        5'b0000x:        r_cste_count19 <= r_cste_count19;

        5'b00011:        r_cste_count19 <= r_cste_count19 - 2'd1;

        default :        r_cste_count19 <= r_cste_count19;

      endcase // casex(w_cste_case19)
      
   end
   
end

//----------------------------------------------------------------------
// WELE19 Store19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)

begin   

   if (~(n_sys_reset19))

      r_wele_store19 <= 2'b00;


   else if (valid_access19)

      r_wele_store19 <= 2'b00;

   else

      r_wele_store19 <= r_wele_store19;

end
   
   
   
//----------------------------------------------------------------------
//concatenation19 of signals19 to avoid using nested19 ifs19
//----------------------------------------------------------------------
   
   assign wele_count19   = (|r_wele_count19);         //checks19 for count = 0
   assign case_wele19   = {1'b0,valid_access19,mac_smc_done19,wele_count19,
                         le_enable19};
   
//----------------------------------------------------------------------
// WELE19 Counter19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)

begin   
   if (~(n_sys_reset19))

      r_wele_count19 <= 2'b00;

   else
   begin

      casex(case_wele19)

        5'b1xxxx :  r_wele_count19 <= r_wele_count19;

        5'b01xxx :  r_wele_count19 <= 2'b00;

        5'b001xx :  r_wele_count19 <= r_wele_store19;

        5'b0000x :  r_wele_count19 <= r_wele_count19;

        5'b00011 :  r_wele_count19 <= r_wele_count19 - (2'd1);

        default  :  r_wele_count19 <= r_wele_count19;

      endcase // casex(case_wele19)

   end

end
   
//----------------------------------------------------------------------
// WS19 Store19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)
  
begin   

   if (~(n_sys_reset19))

      r_ws_store19 <= 8'd0;


   else if (valid_access19)

      r_ws_store19 <= 8'h01;

   else

      r_ws_store19 <= r_ws_store19;

end
   
   
   
//----------------------------------------------------------------------
//concatenation19 of signals19 to avoid using nested19 ifs19
//----------------------------------------------------------------------
   
   assign ws_count19   = (|r_ws_count19); //checks19 for count = 0
   assign case_ws19   = {1'b0,valid_access19,mac_smc_done19,ws_count19,
                       ws_enable19};
   
//----------------------------------------------------------------------
// WS19 Counter19
//----------------------------------------------------------------------

always @(posedge sys_clk19 or negedge n_sys_reset19)

begin   

   if (~(n_sys_reset19))

      r_ws_count19 <= 8'd0;

   else  
   begin
   
      casex(case_ws19)
 
         5'b1xxxx :  
            r_ws_count19 <= r_ws_count19;
        
         5'b01xxx :
            r_ws_count19 <= 8'h01;
        
         5'b001xx :  
            r_ws_count19 <= r_ws_store19;
        
         5'b0000x :  
            r_ws_count19 <= r_ws_count19;
        
         5'b00011 :  
            r_ws_count19 <= r_ws_count19 - 8'd1;
        
         default  :  
            r_ws_count19 <= r_ws_count19;

      endcase // casex(case_ws19)
      
   end
   
end  
   
   
endmodule
