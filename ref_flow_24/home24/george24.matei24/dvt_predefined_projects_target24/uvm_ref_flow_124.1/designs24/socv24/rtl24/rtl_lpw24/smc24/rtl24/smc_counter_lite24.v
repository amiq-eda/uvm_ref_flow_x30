//File24 name   : smc_counter_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : Counter24 block.
//            : Static24 Memory Controller24.
//            : The counter block provides24 generates24 all cycle timings24
//            : The leading24 edge counts24 are individual24 2bit, loadable24,
//            : counters24. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing24
//            : edge counts24 are registered for comparison24 with the
//            : wait state counter. The bus float24 (CSTE24) is a
//            : separate24 2bit counter. The initial count values are
//            : stored24 and reloaded24 into the counters24 if multiple
//            : accesses are required24.
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


module smc_counter_lite24  (
                     //inputs24

                     sys_clk24,
                     n_sys_reset24,
                     valid_access24,
                     mac_done24, 
                     smc_done24, 
                     cste_enable24, 
                     ws_enable24,
                     le_enable24, 

                     //outputs24

                     r_csle_count24,
                     r_wele_count24,
                     r_ws_count24,
                     r_ws_store24,
                     r_oete_store24,
                     r_wete_store24,
                     r_wele_store24,
                     r_cste_count24,
                     r_csle_store24);
   

//----------------------------------------------------------------------
// the Wait24 State24 Counter24
//----------------------------------------------------------------------
   
   
   // I24/O24
   
   input     sys_clk24;                  // AHB24 System24 clock24
   input     n_sys_reset24;              // AHB24 System24 reset (Active24 LOW24)
   
   input     valid_access24;             // load24 values are valid if high24
   input     mac_done24;                 // All cycles24 in a multiple access

   //  completed
   
   input                 smc_done24;   // one access completed
   input                 cste_enable24;// Enable24 CS24 Trailing24 Edge24 counter
   input                 ws_enable24;  // Enable24 Wait24 State24 counter
   input                 le_enable24;  // Enable24 all Leading24 Edge24 counters24
   
   // Counter24 outputs24
   
   output [1:0]             r_csle_count24;  //chip24 select24 leading24
                                             //  edge count
   output [1:0]             r_wele_count24;  //write strobe24 leading24 
                                             // edge count
   output [7:0] r_ws_count24;    //wait state count
   output [1:0]             r_cste_count24;  //chip24 select24 trailing24 
                                             // edge count
   
   // Stored24 counts24 for MAC24
   
   output [1:0]             r_oete_store24;  //read strobe24
   output [1:0]             r_wete_store24;  //write strobe24 trailing24 
                                              // edge store24
   output [7:0] r_ws_store24;    //wait state store24
   output [1:0]             r_wele_store24;  //write strobe24 leading24
                                             //  edge store24
   output [1:0]             r_csle_store24;  //chip24 select24  leading24
                                             //  edge store24
   
   
   // Counters24
   
   reg [1:0]             r_csle_count24;  // Chip24 select24 LE24 counter
   reg [1:0]             r_wele_count24;  // Write counter
   reg [7:0] r_ws_count24;    // Wait24 state select24 counter
   reg [1:0]             r_cste_count24;  // Chip24 select24 TE24 counter
   
   
   // These24 strobes24 finish early24 so no counter is required24. 
   // The stored24 value is compared with WS24 counter to determine24 
   // when the strobe24 should end.

   reg [1:0]    r_wete_store24;    // Write strobe24 TE24 end time before CS24
   reg [1:0]    r_oete_store24;    // Read strobe24 TE24 end time before CS24
   
   
   // The following24 four24 regisrers24 are used to store24 the configuration
   // during mulitple24 accesses. The counters24 are reloaded24 from these24
   // registers before each cycle.
   
   reg [1:0]             r_csle_store24;    // Chip24 select24 LE24 store24
   reg [1:0]             r_wele_store24;    // Write strobe24 LE24 store24
   reg [7:0] r_ws_store24;      // Wait24 state store24
   reg [1:0]             r_cste_store24;    // Chip24 Select24 TE24 delay
                                          //  (Bus24 float24 time)

   // wires24 used for meeting24 coding24 standards24
   
   wire         ws_count24;      //ORed24 r_ws_count24
   wire         wele_count24;    //ORed24 r_wele_count24
   wire         cste_count24;    //ORed24 r_cste_count24
   wire         mac_smc_done24;  //ANDed24 smc_done24 and not(mac_done24)
   wire [4:0]   case_cste24;     //concatenated24 signals24 for case statement24
   wire [4:0]   case_wele24;     //concatenated24 signals24 for case statement24
   wire [4:0]   case_ws24;       //concatenated24 signals24 for case statement24
   
   
   
   // Main24 Code24
   
//----------------------------------------------------------------------
// Counters24 (& Count24 Store24 for MAC24)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE24 Store24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)

begin   

   if (~(n_sys_reset24))
     
      r_wete_store24 <= 2'b00;
   
   
   else if (valid_access24)
     
      r_wete_store24 <= 2'b0;
   
   else
     
      r_wete_store24 <= r_wete_store24;

end
   
//----------------------------------------------------------------------
// OETE24 Store24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)

begin   

   if (~(n_sys_reset24))
     
      r_oete_store24 <= 2'b00;
   
   
   else if (valid_access24)
     
      r_oete_store24 <= 2'b0;
   
   else

      r_oete_store24 <= r_oete_store24;

end
   
//----------------------------------------------------------------------
// CSLE24 Store24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)

begin   

   if (~(n_sys_reset24))
     
      r_csle_store24 <= 2'b00;
   
   
   else if (valid_access24)
     
      r_csle_store24 <= 2'b00;
   
   else
     
      r_csle_store24 <= r_csle_store24;

end
   
//----------------------------------------------------------------------
// CSLE24 Counter24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)

begin   

   if (~(n_sys_reset24))
     
      r_csle_count24 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access24)
        
         r_csle_count24 <= 2'b00;
      
      else if (~(mac_done24) & smc_done24)
        
         r_csle_count24 <= r_csle_store24;
      
      else if (r_csle_count24 == 2'b00)
        
         r_csle_count24 <= r_csle_count24;
      
      else if (le_enable24)               
        
         r_csle_count24 <= r_csle_count24 - 2'd1;
      
      else
        
          r_csle_count24 <= r_csle_count24;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE24 Store24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)

begin   

   if (~(n_sys_reset24))

      r_cste_store24 <= 2'b00;

   else if (valid_access24)

      r_cste_store24 <= 2'b0;

   else

      r_cste_store24 <= r_cste_store24;

end
   
   
   
//----------------------------------------------------------------------
//concatenation24 of signals24 to avoid using nested24 ifs24
//----------------------------------------------------------------------

 assign mac_smc_done24 = (~(mac_done24) & smc_done24);
 assign cste_count24   = (|r_cste_count24);           //checks24 for count = 0
 assign case_cste24   = {1'b0,valid_access24,mac_smc_done24,cste_count24,
                       cste_enable24};
   
//----------------------------------------------------------------------
//CSTE24 COUNTER24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)

begin   

   if (~(n_sys_reset24))

      r_cste_count24 <= 2'b00;

   else 
   begin
      casex(case_cste24)
           
        5'b1xxxx:        r_cste_count24 <= r_cste_count24;

        5'b01xxx:        r_cste_count24 <= 2'b0;

        5'b001xx:        r_cste_count24 <= r_cste_store24;

        5'b0000x:        r_cste_count24 <= r_cste_count24;

        5'b00011:        r_cste_count24 <= r_cste_count24 - 2'd1;

        default :        r_cste_count24 <= r_cste_count24;

      endcase // casex(w_cste_case24)
      
   end
   
end

//----------------------------------------------------------------------
// WELE24 Store24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)

begin   

   if (~(n_sys_reset24))

      r_wele_store24 <= 2'b00;


   else if (valid_access24)

      r_wele_store24 <= 2'b00;

   else

      r_wele_store24 <= r_wele_store24;

end
   
   
   
//----------------------------------------------------------------------
//concatenation24 of signals24 to avoid using nested24 ifs24
//----------------------------------------------------------------------
   
   assign wele_count24   = (|r_wele_count24);         //checks24 for count = 0
   assign case_wele24   = {1'b0,valid_access24,mac_smc_done24,wele_count24,
                         le_enable24};
   
//----------------------------------------------------------------------
// WELE24 Counter24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)

begin   
   if (~(n_sys_reset24))

      r_wele_count24 <= 2'b00;

   else
   begin

      casex(case_wele24)

        5'b1xxxx :  r_wele_count24 <= r_wele_count24;

        5'b01xxx :  r_wele_count24 <= 2'b00;

        5'b001xx :  r_wele_count24 <= r_wele_store24;

        5'b0000x :  r_wele_count24 <= r_wele_count24;

        5'b00011 :  r_wele_count24 <= r_wele_count24 - (2'd1);

        default  :  r_wele_count24 <= r_wele_count24;

      endcase // casex(case_wele24)

   end

end
   
//----------------------------------------------------------------------
// WS24 Store24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)
  
begin   

   if (~(n_sys_reset24))

      r_ws_store24 <= 8'd0;


   else if (valid_access24)

      r_ws_store24 <= 8'h01;

   else

      r_ws_store24 <= r_ws_store24;

end
   
   
   
//----------------------------------------------------------------------
//concatenation24 of signals24 to avoid using nested24 ifs24
//----------------------------------------------------------------------
   
   assign ws_count24   = (|r_ws_count24); //checks24 for count = 0
   assign case_ws24   = {1'b0,valid_access24,mac_smc_done24,ws_count24,
                       ws_enable24};
   
//----------------------------------------------------------------------
// WS24 Counter24
//----------------------------------------------------------------------

always @(posedge sys_clk24 or negedge n_sys_reset24)

begin   

   if (~(n_sys_reset24))

      r_ws_count24 <= 8'd0;

   else  
   begin
   
      casex(case_ws24)
 
         5'b1xxxx :  
            r_ws_count24 <= r_ws_count24;
        
         5'b01xxx :
            r_ws_count24 <= 8'h01;
        
         5'b001xx :  
            r_ws_count24 <= r_ws_store24;
        
         5'b0000x :  
            r_ws_count24 <= r_ws_count24;
        
         5'b00011 :  
            r_ws_count24 <= r_ws_count24 - 8'd1;
        
         default  :  
            r_ws_count24 <= r_ws_count24;

      endcase // casex(case_ws24)
      
   end
   
end  
   
   
endmodule
