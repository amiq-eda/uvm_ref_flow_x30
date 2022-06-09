//File14 name   : smc_counter_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : Counter14 block.
//            : Static14 Memory Controller14.
//            : The counter block provides14 generates14 all cycle timings14
//            : The leading14 edge counts14 are individual14 2bit, loadable14,
//            : counters14. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing14
//            : edge counts14 are registered for comparison14 with the
//            : wait state counter. The bus float14 (CSTE14) is a
//            : separate14 2bit counter. The initial count values are
//            : stored14 and reloaded14 into the counters14 if multiple
//            : accesses are required14.
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


module smc_counter_lite14  (
                     //inputs14

                     sys_clk14,
                     n_sys_reset14,
                     valid_access14,
                     mac_done14, 
                     smc_done14, 
                     cste_enable14, 
                     ws_enable14,
                     le_enable14, 

                     //outputs14

                     r_csle_count14,
                     r_wele_count14,
                     r_ws_count14,
                     r_ws_store14,
                     r_oete_store14,
                     r_wete_store14,
                     r_wele_store14,
                     r_cste_count14,
                     r_csle_store14);
   

//----------------------------------------------------------------------
// the Wait14 State14 Counter14
//----------------------------------------------------------------------
   
   
   // I14/O14
   
   input     sys_clk14;                  // AHB14 System14 clock14
   input     n_sys_reset14;              // AHB14 System14 reset (Active14 LOW14)
   
   input     valid_access14;             // load14 values are valid if high14
   input     mac_done14;                 // All cycles14 in a multiple access

   //  completed
   
   input                 smc_done14;   // one access completed
   input                 cste_enable14;// Enable14 CS14 Trailing14 Edge14 counter
   input                 ws_enable14;  // Enable14 Wait14 State14 counter
   input                 le_enable14;  // Enable14 all Leading14 Edge14 counters14
   
   // Counter14 outputs14
   
   output [1:0]             r_csle_count14;  //chip14 select14 leading14
                                             //  edge count
   output [1:0]             r_wele_count14;  //write strobe14 leading14 
                                             // edge count
   output [7:0] r_ws_count14;    //wait state count
   output [1:0]             r_cste_count14;  //chip14 select14 trailing14 
                                             // edge count
   
   // Stored14 counts14 for MAC14
   
   output [1:0]             r_oete_store14;  //read strobe14
   output [1:0]             r_wete_store14;  //write strobe14 trailing14 
                                              // edge store14
   output [7:0] r_ws_store14;    //wait state store14
   output [1:0]             r_wele_store14;  //write strobe14 leading14
                                             //  edge store14
   output [1:0]             r_csle_store14;  //chip14 select14  leading14
                                             //  edge store14
   
   
   // Counters14
   
   reg [1:0]             r_csle_count14;  // Chip14 select14 LE14 counter
   reg [1:0]             r_wele_count14;  // Write counter
   reg [7:0] r_ws_count14;    // Wait14 state select14 counter
   reg [1:0]             r_cste_count14;  // Chip14 select14 TE14 counter
   
   
   // These14 strobes14 finish early14 so no counter is required14. 
   // The stored14 value is compared with WS14 counter to determine14 
   // when the strobe14 should end.

   reg [1:0]    r_wete_store14;    // Write strobe14 TE14 end time before CS14
   reg [1:0]    r_oete_store14;    // Read strobe14 TE14 end time before CS14
   
   
   // The following14 four14 regisrers14 are used to store14 the configuration
   // during mulitple14 accesses. The counters14 are reloaded14 from these14
   // registers before each cycle.
   
   reg [1:0]             r_csle_store14;    // Chip14 select14 LE14 store14
   reg [1:0]             r_wele_store14;    // Write strobe14 LE14 store14
   reg [7:0] r_ws_store14;      // Wait14 state store14
   reg [1:0]             r_cste_store14;    // Chip14 Select14 TE14 delay
                                          //  (Bus14 float14 time)

   // wires14 used for meeting14 coding14 standards14
   
   wire         ws_count14;      //ORed14 r_ws_count14
   wire         wele_count14;    //ORed14 r_wele_count14
   wire         cste_count14;    //ORed14 r_cste_count14
   wire         mac_smc_done14;  //ANDed14 smc_done14 and not(mac_done14)
   wire [4:0]   case_cste14;     //concatenated14 signals14 for case statement14
   wire [4:0]   case_wele14;     //concatenated14 signals14 for case statement14
   wire [4:0]   case_ws14;       //concatenated14 signals14 for case statement14
   
   
   
   // Main14 Code14
   
//----------------------------------------------------------------------
// Counters14 (& Count14 Store14 for MAC14)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE14 Store14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)

begin   

   if (~(n_sys_reset14))
     
      r_wete_store14 <= 2'b00;
   
   
   else if (valid_access14)
     
      r_wete_store14 <= 2'b0;
   
   else
     
      r_wete_store14 <= r_wete_store14;

end
   
//----------------------------------------------------------------------
// OETE14 Store14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)

begin   

   if (~(n_sys_reset14))
     
      r_oete_store14 <= 2'b00;
   
   
   else if (valid_access14)
     
      r_oete_store14 <= 2'b0;
   
   else

      r_oete_store14 <= r_oete_store14;

end
   
//----------------------------------------------------------------------
// CSLE14 Store14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)

begin   

   if (~(n_sys_reset14))
     
      r_csle_store14 <= 2'b00;
   
   
   else if (valid_access14)
     
      r_csle_store14 <= 2'b00;
   
   else
     
      r_csle_store14 <= r_csle_store14;

end
   
//----------------------------------------------------------------------
// CSLE14 Counter14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)

begin   

   if (~(n_sys_reset14))
     
      r_csle_count14 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access14)
        
         r_csle_count14 <= 2'b00;
      
      else if (~(mac_done14) & smc_done14)
        
         r_csle_count14 <= r_csle_store14;
      
      else if (r_csle_count14 == 2'b00)
        
         r_csle_count14 <= r_csle_count14;
      
      else if (le_enable14)               
        
         r_csle_count14 <= r_csle_count14 - 2'd1;
      
      else
        
          r_csle_count14 <= r_csle_count14;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE14 Store14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)

begin   

   if (~(n_sys_reset14))

      r_cste_store14 <= 2'b00;

   else if (valid_access14)

      r_cste_store14 <= 2'b0;

   else

      r_cste_store14 <= r_cste_store14;

end
   
   
   
//----------------------------------------------------------------------
//concatenation14 of signals14 to avoid using nested14 ifs14
//----------------------------------------------------------------------

 assign mac_smc_done14 = (~(mac_done14) & smc_done14);
 assign cste_count14   = (|r_cste_count14);           //checks14 for count = 0
 assign case_cste14   = {1'b0,valid_access14,mac_smc_done14,cste_count14,
                       cste_enable14};
   
//----------------------------------------------------------------------
//CSTE14 COUNTER14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)

begin   

   if (~(n_sys_reset14))

      r_cste_count14 <= 2'b00;

   else 
   begin
      casex(case_cste14)
           
        5'b1xxxx:        r_cste_count14 <= r_cste_count14;

        5'b01xxx:        r_cste_count14 <= 2'b0;

        5'b001xx:        r_cste_count14 <= r_cste_store14;

        5'b0000x:        r_cste_count14 <= r_cste_count14;

        5'b00011:        r_cste_count14 <= r_cste_count14 - 2'd1;

        default :        r_cste_count14 <= r_cste_count14;

      endcase // casex(w_cste_case14)
      
   end
   
end

//----------------------------------------------------------------------
// WELE14 Store14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)

begin   

   if (~(n_sys_reset14))

      r_wele_store14 <= 2'b00;


   else if (valid_access14)

      r_wele_store14 <= 2'b00;

   else

      r_wele_store14 <= r_wele_store14;

end
   
   
   
//----------------------------------------------------------------------
//concatenation14 of signals14 to avoid using nested14 ifs14
//----------------------------------------------------------------------
   
   assign wele_count14   = (|r_wele_count14);         //checks14 for count = 0
   assign case_wele14   = {1'b0,valid_access14,mac_smc_done14,wele_count14,
                         le_enable14};
   
//----------------------------------------------------------------------
// WELE14 Counter14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)

begin   
   if (~(n_sys_reset14))

      r_wele_count14 <= 2'b00;

   else
   begin

      casex(case_wele14)

        5'b1xxxx :  r_wele_count14 <= r_wele_count14;

        5'b01xxx :  r_wele_count14 <= 2'b00;

        5'b001xx :  r_wele_count14 <= r_wele_store14;

        5'b0000x :  r_wele_count14 <= r_wele_count14;

        5'b00011 :  r_wele_count14 <= r_wele_count14 - (2'd1);

        default  :  r_wele_count14 <= r_wele_count14;

      endcase // casex(case_wele14)

   end

end
   
//----------------------------------------------------------------------
// WS14 Store14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)
  
begin   

   if (~(n_sys_reset14))

      r_ws_store14 <= 8'd0;


   else if (valid_access14)

      r_ws_store14 <= 8'h01;

   else

      r_ws_store14 <= r_ws_store14;

end
   
   
   
//----------------------------------------------------------------------
//concatenation14 of signals14 to avoid using nested14 ifs14
//----------------------------------------------------------------------
   
   assign ws_count14   = (|r_ws_count14); //checks14 for count = 0
   assign case_ws14   = {1'b0,valid_access14,mac_smc_done14,ws_count14,
                       ws_enable14};
   
//----------------------------------------------------------------------
// WS14 Counter14
//----------------------------------------------------------------------

always @(posedge sys_clk14 or negedge n_sys_reset14)

begin   

   if (~(n_sys_reset14))

      r_ws_count14 <= 8'd0;

   else  
   begin
   
      casex(case_ws14)
 
         5'b1xxxx :  
            r_ws_count14 <= r_ws_count14;
        
         5'b01xxx :
            r_ws_count14 <= 8'h01;
        
         5'b001xx :  
            r_ws_count14 <= r_ws_store14;
        
         5'b0000x :  
            r_ws_count14 <= r_ws_count14;
        
         5'b00011 :  
            r_ws_count14 <= r_ws_count14 - 8'd1;
        
         default  :  
            r_ws_count14 <= r_ws_count14;

      endcase // casex(case_ws14)
      
   end
   
end  
   
   
endmodule
