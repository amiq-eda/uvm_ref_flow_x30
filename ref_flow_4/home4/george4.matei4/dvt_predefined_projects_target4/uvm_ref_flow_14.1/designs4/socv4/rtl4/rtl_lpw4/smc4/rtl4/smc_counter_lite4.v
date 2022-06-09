//File4 name   : smc_counter_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : Counter4 block.
//            : Static4 Memory Controller4.
//            : The counter block provides4 generates4 all cycle timings4
//            : The leading4 edge counts4 are individual4 2bit, loadable4,
//            : counters4. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing4
//            : edge counts4 are registered for comparison4 with the
//            : wait state counter. The bus float4 (CSTE4) is a
//            : separate4 2bit counter. The initial count values are
//            : stored4 and reloaded4 into the counters4 if multiple
//            : accesses are required4.
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


module smc_counter_lite4  (
                     //inputs4

                     sys_clk4,
                     n_sys_reset4,
                     valid_access4,
                     mac_done4, 
                     smc_done4, 
                     cste_enable4, 
                     ws_enable4,
                     le_enable4, 

                     //outputs4

                     r_csle_count4,
                     r_wele_count4,
                     r_ws_count4,
                     r_ws_store4,
                     r_oete_store4,
                     r_wete_store4,
                     r_wele_store4,
                     r_cste_count4,
                     r_csle_store4);
   

//----------------------------------------------------------------------
// the Wait4 State4 Counter4
//----------------------------------------------------------------------
   
   
   // I4/O4
   
   input     sys_clk4;                  // AHB4 System4 clock4
   input     n_sys_reset4;              // AHB4 System4 reset (Active4 LOW4)
   
   input     valid_access4;             // load4 values are valid if high4
   input     mac_done4;                 // All cycles4 in a multiple access

   //  completed
   
   input                 smc_done4;   // one access completed
   input                 cste_enable4;// Enable4 CS4 Trailing4 Edge4 counter
   input                 ws_enable4;  // Enable4 Wait4 State4 counter
   input                 le_enable4;  // Enable4 all Leading4 Edge4 counters4
   
   // Counter4 outputs4
   
   output [1:0]             r_csle_count4;  //chip4 select4 leading4
                                             //  edge count
   output [1:0]             r_wele_count4;  //write strobe4 leading4 
                                             // edge count
   output [7:0] r_ws_count4;    //wait state count
   output [1:0]             r_cste_count4;  //chip4 select4 trailing4 
                                             // edge count
   
   // Stored4 counts4 for MAC4
   
   output [1:0]             r_oete_store4;  //read strobe4
   output [1:0]             r_wete_store4;  //write strobe4 trailing4 
                                              // edge store4
   output [7:0] r_ws_store4;    //wait state store4
   output [1:0]             r_wele_store4;  //write strobe4 leading4
                                             //  edge store4
   output [1:0]             r_csle_store4;  //chip4 select4  leading4
                                             //  edge store4
   
   
   // Counters4
   
   reg [1:0]             r_csle_count4;  // Chip4 select4 LE4 counter
   reg [1:0]             r_wele_count4;  // Write counter
   reg [7:0] r_ws_count4;    // Wait4 state select4 counter
   reg [1:0]             r_cste_count4;  // Chip4 select4 TE4 counter
   
   
   // These4 strobes4 finish early4 so no counter is required4. 
   // The stored4 value is compared with WS4 counter to determine4 
   // when the strobe4 should end.

   reg [1:0]    r_wete_store4;    // Write strobe4 TE4 end time before CS4
   reg [1:0]    r_oete_store4;    // Read strobe4 TE4 end time before CS4
   
   
   // The following4 four4 regisrers4 are used to store4 the configuration
   // during mulitple4 accesses. The counters4 are reloaded4 from these4
   // registers before each cycle.
   
   reg [1:0]             r_csle_store4;    // Chip4 select4 LE4 store4
   reg [1:0]             r_wele_store4;    // Write strobe4 LE4 store4
   reg [7:0] r_ws_store4;      // Wait4 state store4
   reg [1:0]             r_cste_store4;    // Chip4 Select4 TE4 delay
                                          //  (Bus4 float4 time)

   // wires4 used for meeting4 coding4 standards4
   
   wire         ws_count4;      //ORed4 r_ws_count4
   wire         wele_count4;    //ORed4 r_wele_count4
   wire         cste_count4;    //ORed4 r_cste_count4
   wire         mac_smc_done4;  //ANDed4 smc_done4 and not(mac_done4)
   wire [4:0]   case_cste4;     //concatenated4 signals4 for case statement4
   wire [4:0]   case_wele4;     //concatenated4 signals4 for case statement4
   wire [4:0]   case_ws4;       //concatenated4 signals4 for case statement4
   
   
   
   // Main4 Code4
   
//----------------------------------------------------------------------
// Counters4 (& Count4 Store4 for MAC4)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE4 Store4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)

begin   

   if (~(n_sys_reset4))
     
      r_wete_store4 <= 2'b00;
   
   
   else if (valid_access4)
     
      r_wete_store4 <= 2'b0;
   
   else
     
      r_wete_store4 <= r_wete_store4;

end
   
//----------------------------------------------------------------------
// OETE4 Store4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)

begin   

   if (~(n_sys_reset4))
     
      r_oete_store4 <= 2'b00;
   
   
   else if (valid_access4)
     
      r_oete_store4 <= 2'b0;
   
   else

      r_oete_store4 <= r_oete_store4;

end
   
//----------------------------------------------------------------------
// CSLE4 Store4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)

begin   

   if (~(n_sys_reset4))
     
      r_csle_store4 <= 2'b00;
   
   
   else if (valid_access4)
     
      r_csle_store4 <= 2'b00;
   
   else
     
      r_csle_store4 <= r_csle_store4;

end
   
//----------------------------------------------------------------------
// CSLE4 Counter4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)

begin   

   if (~(n_sys_reset4))
     
      r_csle_count4 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access4)
        
         r_csle_count4 <= 2'b00;
      
      else if (~(mac_done4) & smc_done4)
        
         r_csle_count4 <= r_csle_store4;
      
      else if (r_csle_count4 == 2'b00)
        
         r_csle_count4 <= r_csle_count4;
      
      else if (le_enable4)               
        
         r_csle_count4 <= r_csle_count4 - 2'd1;
      
      else
        
          r_csle_count4 <= r_csle_count4;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE4 Store4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)

begin   

   if (~(n_sys_reset4))

      r_cste_store4 <= 2'b00;

   else if (valid_access4)

      r_cste_store4 <= 2'b0;

   else

      r_cste_store4 <= r_cste_store4;

end
   
   
   
//----------------------------------------------------------------------
//concatenation4 of signals4 to avoid using nested4 ifs4
//----------------------------------------------------------------------

 assign mac_smc_done4 = (~(mac_done4) & smc_done4);
 assign cste_count4   = (|r_cste_count4);           //checks4 for count = 0
 assign case_cste4   = {1'b0,valid_access4,mac_smc_done4,cste_count4,
                       cste_enable4};
   
//----------------------------------------------------------------------
//CSTE4 COUNTER4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)

begin   

   if (~(n_sys_reset4))

      r_cste_count4 <= 2'b00;

   else 
   begin
      casex(case_cste4)
           
        5'b1xxxx:        r_cste_count4 <= r_cste_count4;

        5'b01xxx:        r_cste_count4 <= 2'b0;

        5'b001xx:        r_cste_count4 <= r_cste_store4;

        5'b0000x:        r_cste_count4 <= r_cste_count4;

        5'b00011:        r_cste_count4 <= r_cste_count4 - 2'd1;

        default :        r_cste_count4 <= r_cste_count4;

      endcase // casex(w_cste_case4)
      
   end
   
end

//----------------------------------------------------------------------
// WELE4 Store4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)

begin   

   if (~(n_sys_reset4))

      r_wele_store4 <= 2'b00;


   else if (valid_access4)

      r_wele_store4 <= 2'b00;

   else

      r_wele_store4 <= r_wele_store4;

end
   
   
   
//----------------------------------------------------------------------
//concatenation4 of signals4 to avoid using nested4 ifs4
//----------------------------------------------------------------------
   
   assign wele_count4   = (|r_wele_count4);         //checks4 for count = 0
   assign case_wele4   = {1'b0,valid_access4,mac_smc_done4,wele_count4,
                         le_enable4};
   
//----------------------------------------------------------------------
// WELE4 Counter4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)

begin   
   if (~(n_sys_reset4))

      r_wele_count4 <= 2'b00;

   else
   begin

      casex(case_wele4)

        5'b1xxxx :  r_wele_count4 <= r_wele_count4;

        5'b01xxx :  r_wele_count4 <= 2'b00;

        5'b001xx :  r_wele_count4 <= r_wele_store4;

        5'b0000x :  r_wele_count4 <= r_wele_count4;

        5'b00011 :  r_wele_count4 <= r_wele_count4 - (2'd1);

        default  :  r_wele_count4 <= r_wele_count4;

      endcase // casex(case_wele4)

   end

end
   
//----------------------------------------------------------------------
// WS4 Store4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)
  
begin   

   if (~(n_sys_reset4))

      r_ws_store4 <= 8'd0;


   else if (valid_access4)

      r_ws_store4 <= 8'h01;

   else

      r_ws_store4 <= r_ws_store4;

end
   
   
   
//----------------------------------------------------------------------
//concatenation4 of signals4 to avoid using nested4 ifs4
//----------------------------------------------------------------------
   
   assign ws_count4   = (|r_ws_count4); //checks4 for count = 0
   assign case_ws4   = {1'b0,valid_access4,mac_smc_done4,ws_count4,
                       ws_enable4};
   
//----------------------------------------------------------------------
// WS4 Counter4
//----------------------------------------------------------------------

always @(posedge sys_clk4 or negedge n_sys_reset4)

begin   

   if (~(n_sys_reset4))

      r_ws_count4 <= 8'd0;

   else  
   begin
   
      casex(case_ws4)
 
         5'b1xxxx :  
            r_ws_count4 <= r_ws_count4;
        
         5'b01xxx :
            r_ws_count4 <= 8'h01;
        
         5'b001xx :  
            r_ws_count4 <= r_ws_store4;
        
         5'b0000x :  
            r_ws_count4 <= r_ws_count4;
        
         5'b00011 :  
            r_ws_count4 <= r_ws_count4 - 8'd1;
        
         default  :  
            r_ws_count4 <= r_ws_count4;

      endcase // casex(case_ws4)
      
   end
   
end  
   
   
endmodule
