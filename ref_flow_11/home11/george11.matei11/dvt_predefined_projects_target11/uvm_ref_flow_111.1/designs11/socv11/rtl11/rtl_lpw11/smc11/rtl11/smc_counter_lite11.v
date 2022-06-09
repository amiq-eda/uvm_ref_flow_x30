//File11 name   : smc_counter_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : Counter11 block.
//            : Static11 Memory Controller11.
//            : The counter block provides11 generates11 all cycle timings11
//            : The leading11 edge counts11 are individual11 2bit, loadable11,
//            : counters11. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing11
//            : edge counts11 are registered for comparison11 with the
//            : wait state counter. The bus float11 (CSTE11) is a
//            : separate11 2bit counter. The initial count values are
//            : stored11 and reloaded11 into the counters11 if multiple
//            : accesses are required11.
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


module smc_counter_lite11  (
                     //inputs11

                     sys_clk11,
                     n_sys_reset11,
                     valid_access11,
                     mac_done11, 
                     smc_done11, 
                     cste_enable11, 
                     ws_enable11,
                     le_enable11, 

                     //outputs11

                     r_csle_count11,
                     r_wele_count11,
                     r_ws_count11,
                     r_ws_store11,
                     r_oete_store11,
                     r_wete_store11,
                     r_wele_store11,
                     r_cste_count11,
                     r_csle_store11);
   

//----------------------------------------------------------------------
// the Wait11 State11 Counter11
//----------------------------------------------------------------------
   
   
   // I11/O11
   
   input     sys_clk11;                  // AHB11 System11 clock11
   input     n_sys_reset11;              // AHB11 System11 reset (Active11 LOW11)
   
   input     valid_access11;             // load11 values are valid if high11
   input     mac_done11;                 // All cycles11 in a multiple access

   //  completed
   
   input                 smc_done11;   // one access completed
   input                 cste_enable11;// Enable11 CS11 Trailing11 Edge11 counter
   input                 ws_enable11;  // Enable11 Wait11 State11 counter
   input                 le_enable11;  // Enable11 all Leading11 Edge11 counters11
   
   // Counter11 outputs11
   
   output [1:0]             r_csle_count11;  //chip11 select11 leading11
                                             //  edge count
   output [1:0]             r_wele_count11;  //write strobe11 leading11 
                                             // edge count
   output [7:0] r_ws_count11;    //wait state count
   output [1:0]             r_cste_count11;  //chip11 select11 trailing11 
                                             // edge count
   
   // Stored11 counts11 for MAC11
   
   output [1:0]             r_oete_store11;  //read strobe11
   output [1:0]             r_wete_store11;  //write strobe11 trailing11 
                                              // edge store11
   output [7:0] r_ws_store11;    //wait state store11
   output [1:0]             r_wele_store11;  //write strobe11 leading11
                                             //  edge store11
   output [1:0]             r_csle_store11;  //chip11 select11  leading11
                                             //  edge store11
   
   
   // Counters11
   
   reg [1:0]             r_csle_count11;  // Chip11 select11 LE11 counter
   reg [1:0]             r_wele_count11;  // Write counter
   reg [7:0] r_ws_count11;    // Wait11 state select11 counter
   reg [1:0]             r_cste_count11;  // Chip11 select11 TE11 counter
   
   
   // These11 strobes11 finish early11 so no counter is required11. 
   // The stored11 value is compared with WS11 counter to determine11 
   // when the strobe11 should end.

   reg [1:0]    r_wete_store11;    // Write strobe11 TE11 end time before CS11
   reg [1:0]    r_oete_store11;    // Read strobe11 TE11 end time before CS11
   
   
   // The following11 four11 regisrers11 are used to store11 the configuration
   // during mulitple11 accesses. The counters11 are reloaded11 from these11
   // registers before each cycle.
   
   reg [1:0]             r_csle_store11;    // Chip11 select11 LE11 store11
   reg [1:0]             r_wele_store11;    // Write strobe11 LE11 store11
   reg [7:0] r_ws_store11;      // Wait11 state store11
   reg [1:0]             r_cste_store11;    // Chip11 Select11 TE11 delay
                                          //  (Bus11 float11 time)

   // wires11 used for meeting11 coding11 standards11
   
   wire         ws_count11;      //ORed11 r_ws_count11
   wire         wele_count11;    //ORed11 r_wele_count11
   wire         cste_count11;    //ORed11 r_cste_count11
   wire         mac_smc_done11;  //ANDed11 smc_done11 and not(mac_done11)
   wire [4:0]   case_cste11;     //concatenated11 signals11 for case statement11
   wire [4:0]   case_wele11;     //concatenated11 signals11 for case statement11
   wire [4:0]   case_ws11;       //concatenated11 signals11 for case statement11
   
   
   
   // Main11 Code11
   
//----------------------------------------------------------------------
// Counters11 (& Count11 Store11 for MAC11)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE11 Store11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)

begin   

   if (~(n_sys_reset11))
     
      r_wete_store11 <= 2'b00;
   
   
   else if (valid_access11)
     
      r_wete_store11 <= 2'b0;
   
   else
     
      r_wete_store11 <= r_wete_store11;

end
   
//----------------------------------------------------------------------
// OETE11 Store11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)

begin   

   if (~(n_sys_reset11))
     
      r_oete_store11 <= 2'b00;
   
   
   else if (valid_access11)
     
      r_oete_store11 <= 2'b0;
   
   else

      r_oete_store11 <= r_oete_store11;

end
   
//----------------------------------------------------------------------
// CSLE11 Store11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)

begin   

   if (~(n_sys_reset11))
     
      r_csle_store11 <= 2'b00;
   
   
   else if (valid_access11)
     
      r_csle_store11 <= 2'b00;
   
   else
     
      r_csle_store11 <= r_csle_store11;

end
   
//----------------------------------------------------------------------
// CSLE11 Counter11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)

begin   

   if (~(n_sys_reset11))
     
      r_csle_count11 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access11)
        
         r_csle_count11 <= 2'b00;
      
      else if (~(mac_done11) & smc_done11)
        
         r_csle_count11 <= r_csle_store11;
      
      else if (r_csle_count11 == 2'b00)
        
         r_csle_count11 <= r_csle_count11;
      
      else if (le_enable11)               
        
         r_csle_count11 <= r_csle_count11 - 2'd1;
      
      else
        
          r_csle_count11 <= r_csle_count11;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE11 Store11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)

begin   

   if (~(n_sys_reset11))

      r_cste_store11 <= 2'b00;

   else if (valid_access11)

      r_cste_store11 <= 2'b0;

   else

      r_cste_store11 <= r_cste_store11;

end
   
   
   
//----------------------------------------------------------------------
//concatenation11 of signals11 to avoid using nested11 ifs11
//----------------------------------------------------------------------

 assign mac_smc_done11 = (~(mac_done11) & smc_done11);
 assign cste_count11   = (|r_cste_count11);           //checks11 for count = 0
 assign case_cste11   = {1'b0,valid_access11,mac_smc_done11,cste_count11,
                       cste_enable11};
   
//----------------------------------------------------------------------
//CSTE11 COUNTER11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)

begin   

   if (~(n_sys_reset11))

      r_cste_count11 <= 2'b00;

   else 
   begin
      casex(case_cste11)
           
        5'b1xxxx:        r_cste_count11 <= r_cste_count11;

        5'b01xxx:        r_cste_count11 <= 2'b0;

        5'b001xx:        r_cste_count11 <= r_cste_store11;

        5'b0000x:        r_cste_count11 <= r_cste_count11;

        5'b00011:        r_cste_count11 <= r_cste_count11 - 2'd1;

        default :        r_cste_count11 <= r_cste_count11;

      endcase // casex(w_cste_case11)
      
   end
   
end

//----------------------------------------------------------------------
// WELE11 Store11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)

begin   

   if (~(n_sys_reset11))

      r_wele_store11 <= 2'b00;


   else if (valid_access11)

      r_wele_store11 <= 2'b00;

   else

      r_wele_store11 <= r_wele_store11;

end
   
   
   
//----------------------------------------------------------------------
//concatenation11 of signals11 to avoid using nested11 ifs11
//----------------------------------------------------------------------
   
   assign wele_count11   = (|r_wele_count11);         //checks11 for count = 0
   assign case_wele11   = {1'b0,valid_access11,mac_smc_done11,wele_count11,
                         le_enable11};
   
//----------------------------------------------------------------------
// WELE11 Counter11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)

begin   
   if (~(n_sys_reset11))

      r_wele_count11 <= 2'b00;

   else
   begin

      casex(case_wele11)

        5'b1xxxx :  r_wele_count11 <= r_wele_count11;

        5'b01xxx :  r_wele_count11 <= 2'b00;

        5'b001xx :  r_wele_count11 <= r_wele_store11;

        5'b0000x :  r_wele_count11 <= r_wele_count11;

        5'b00011 :  r_wele_count11 <= r_wele_count11 - (2'd1);

        default  :  r_wele_count11 <= r_wele_count11;

      endcase // casex(case_wele11)

   end

end
   
//----------------------------------------------------------------------
// WS11 Store11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)
  
begin   

   if (~(n_sys_reset11))

      r_ws_store11 <= 8'd0;


   else if (valid_access11)

      r_ws_store11 <= 8'h01;

   else

      r_ws_store11 <= r_ws_store11;

end
   
   
   
//----------------------------------------------------------------------
//concatenation11 of signals11 to avoid using nested11 ifs11
//----------------------------------------------------------------------
   
   assign ws_count11   = (|r_ws_count11); //checks11 for count = 0
   assign case_ws11   = {1'b0,valid_access11,mac_smc_done11,ws_count11,
                       ws_enable11};
   
//----------------------------------------------------------------------
// WS11 Counter11
//----------------------------------------------------------------------

always @(posedge sys_clk11 or negedge n_sys_reset11)

begin   

   if (~(n_sys_reset11))

      r_ws_count11 <= 8'd0;

   else  
   begin
   
      casex(case_ws11)
 
         5'b1xxxx :  
            r_ws_count11 <= r_ws_count11;
        
         5'b01xxx :
            r_ws_count11 <= 8'h01;
        
         5'b001xx :  
            r_ws_count11 <= r_ws_store11;
        
         5'b0000x :  
            r_ws_count11 <= r_ws_count11;
        
         5'b00011 :  
            r_ws_count11 <= r_ws_count11 - 8'd1;
        
         default  :  
            r_ws_count11 <= r_ws_count11;

      endcase // casex(case_ws11)
      
   end
   
end  
   
   
endmodule
