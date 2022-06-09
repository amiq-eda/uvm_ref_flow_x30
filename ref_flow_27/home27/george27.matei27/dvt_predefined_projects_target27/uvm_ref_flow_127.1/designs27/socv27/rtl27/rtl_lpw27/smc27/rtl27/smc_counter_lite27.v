//File27 name   : smc_counter_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : Counter27 block.
//            : Static27 Memory Controller27.
//            : The counter block provides27 generates27 all cycle timings27
//            : The leading27 edge counts27 are individual27 2bit, loadable27,
//            : counters27. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing27
//            : edge counts27 are registered for comparison27 with the
//            : wait state counter. The bus float27 (CSTE27) is a
//            : separate27 2bit counter. The initial count values are
//            : stored27 and reloaded27 into the counters27 if multiple
//            : accesses are required27.
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


module smc_counter_lite27  (
                     //inputs27

                     sys_clk27,
                     n_sys_reset27,
                     valid_access27,
                     mac_done27, 
                     smc_done27, 
                     cste_enable27, 
                     ws_enable27,
                     le_enable27, 

                     //outputs27

                     r_csle_count27,
                     r_wele_count27,
                     r_ws_count27,
                     r_ws_store27,
                     r_oete_store27,
                     r_wete_store27,
                     r_wele_store27,
                     r_cste_count27,
                     r_csle_store27);
   

//----------------------------------------------------------------------
// the Wait27 State27 Counter27
//----------------------------------------------------------------------
   
   
   // I27/O27
   
   input     sys_clk27;                  // AHB27 System27 clock27
   input     n_sys_reset27;              // AHB27 System27 reset (Active27 LOW27)
   
   input     valid_access27;             // load27 values are valid if high27
   input     mac_done27;                 // All cycles27 in a multiple access

   //  completed
   
   input                 smc_done27;   // one access completed
   input                 cste_enable27;// Enable27 CS27 Trailing27 Edge27 counter
   input                 ws_enable27;  // Enable27 Wait27 State27 counter
   input                 le_enable27;  // Enable27 all Leading27 Edge27 counters27
   
   // Counter27 outputs27
   
   output [1:0]             r_csle_count27;  //chip27 select27 leading27
                                             //  edge count
   output [1:0]             r_wele_count27;  //write strobe27 leading27 
                                             // edge count
   output [7:0] r_ws_count27;    //wait state count
   output [1:0]             r_cste_count27;  //chip27 select27 trailing27 
                                             // edge count
   
   // Stored27 counts27 for MAC27
   
   output [1:0]             r_oete_store27;  //read strobe27
   output [1:0]             r_wete_store27;  //write strobe27 trailing27 
                                              // edge store27
   output [7:0] r_ws_store27;    //wait state store27
   output [1:0]             r_wele_store27;  //write strobe27 leading27
                                             //  edge store27
   output [1:0]             r_csle_store27;  //chip27 select27  leading27
                                             //  edge store27
   
   
   // Counters27
   
   reg [1:0]             r_csle_count27;  // Chip27 select27 LE27 counter
   reg [1:0]             r_wele_count27;  // Write counter
   reg [7:0] r_ws_count27;    // Wait27 state select27 counter
   reg [1:0]             r_cste_count27;  // Chip27 select27 TE27 counter
   
   
   // These27 strobes27 finish early27 so no counter is required27. 
   // The stored27 value is compared with WS27 counter to determine27 
   // when the strobe27 should end.

   reg [1:0]    r_wete_store27;    // Write strobe27 TE27 end time before CS27
   reg [1:0]    r_oete_store27;    // Read strobe27 TE27 end time before CS27
   
   
   // The following27 four27 regisrers27 are used to store27 the configuration
   // during mulitple27 accesses. The counters27 are reloaded27 from these27
   // registers before each cycle.
   
   reg [1:0]             r_csle_store27;    // Chip27 select27 LE27 store27
   reg [1:0]             r_wele_store27;    // Write strobe27 LE27 store27
   reg [7:0] r_ws_store27;      // Wait27 state store27
   reg [1:0]             r_cste_store27;    // Chip27 Select27 TE27 delay
                                          //  (Bus27 float27 time)

   // wires27 used for meeting27 coding27 standards27
   
   wire         ws_count27;      //ORed27 r_ws_count27
   wire         wele_count27;    //ORed27 r_wele_count27
   wire         cste_count27;    //ORed27 r_cste_count27
   wire         mac_smc_done27;  //ANDed27 smc_done27 and not(mac_done27)
   wire [4:0]   case_cste27;     //concatenated27 signals27 for case statement27
   wire [4:0]   case_wele27;     //concatenated27 signals27 for case statement27
   wire [4:0]   case_ws27;       //concatenated27 signals27 for case statement27
   
   
   
   // Main27 Code27
   
//----------------------------------------------------------------------
// Counters27 (& Count27 Store27 for MAC27)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE27 Store27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)

begin   

   if (~(n_sys_reset27))
     
      r_wete_store27 <= 2'b00;
   
   
   else if (valid_access27)
     
      r_wete_store27 <= 2'b0;
   
   else
     
      r_wete_store27 <= r_wete_store27;

end
   
//----------------------------------------------------------------------
// OETE27 Store27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)

begin   

   if (~(n_sys_reset27))
     
      r_oete_store27 <= 2'b00;
   
   
   else if (valid_access27)
     
      r_oete_store27 <= 2'b0;
   
   else

      r_oete_store27 <= r_oete_store27;

end
   
//----------------------------------------------------------------------
// CSLE27 Store27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)

begin   

   if (~(n_sys_reset27))
     
      r_csle_store27 <= 2'b00;
   
   
   else if (valid_access27)
     
      r_csle_store27 <= 2'b00;
   
   else
     
      r_csle_store27 <= r_csle_store27;

end
   
//----------------------------------------------------------------------
// CSLE27 Counter27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)

begin   

   if (~(n_sys_reset27))
     
      r_csle_count27 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access27)
        
         r_csle_count27 <= 2'b00;
      
      else if (~(mac_done27) & smc_done27)
        
         r_csle_count27 <= r_csle_store27;
      
      else if (r_csle_count27 == 2'b00)
        
         r_csle_count27 <= r_csle_count27;
      
      else if (le_enable27)               
        
         r_csle_count27 <= r_csle_count27 - 2'd1;
      
      else
        
          r_csle_count27 <= r_csle_count27;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE27 Store27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)

begin   

   if (~(n_sys_reset27))

      r_cste_store27 <= 2'b00;

   else if (valid_access27)

      r_cste_store27 <= 2'b0;

   else

      r_cste_store27 <= r_cste_store27;

end
   
   
   
//----------------------------------------------------------------------
//concatenation27 of signals27 to avoid using nested27 ifs27
//----------------------------------------------------------------------

 assign mac_smc_done27 = (~(mac_done27) & smc_done27);
 assign cste_count27   = (|r_cste_count27);           //checks27 for count = 0
 assign case_cste27   = {1'b0,valid_access27,mac_smc_done27,cste_count27,
                       cste_enable27};
   
//----------------------------------------------------------------------
//CSTE27 COUNTER27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)

begin   

   if (~(n_sys_reset27))

      r_cste_count27 <= 2'b00;

   else 
   begin
      casex(case_cste27)
           
        5'b1xxxx:        r_cste_count27 <= r_cste_count27;

        5'b01xxx:        r_cste_count27 <= 2'b0;

        5'b001xx:        r_cste_count27 <= r_cste_store27;

        5'b0000x:        r_cste_count27 <= r_cste_count27;

        5'b00011:        r_cste_count27 <= r_cste_count27 - 2'd1;

        default :        r_cste_count27 <= r_cste_count27;

      endcase // casex(w_cste_case27)
      
   end
   
end

//----------------------------------------------------------------------
// WELE27 Store27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)

begin   

   if (~(n_sys_reset27))

      r_wele_store27 <= 2'b00;


   else if (valid_access27)

      r_wele_store27 <= 2'b00;

   else

      r_wele_store27 <= r_wele_store27;

end
   
   
   
//----------------------------------------------------------------------
//concatenation27 of signals27 to avoid using nested27 ifs27
//----------------------------------------------------------------------
   
   assign wele_count27   = (|r_wele_count27);         //checks27 for count = 0
   assign case_wele27   = {1'b0,valid_access27,mac_smc_done27,wele_count27,
                         le_enable27};
   
//----------------------------------------------------------------------
// WELE27 Counter27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)

begin   
   if (~(n_sys_reset27))

      r_wele_count27 <= 2'b00;

   else
   begin

      casex(case_wele27)

        5'b1xxxx :  r_wele_count27 <= r_wele_count27;

        5'b01xxx :  r_wele_count27 <= 2'b00;

        5'b001xx :  r_wele_count27 <= r_wele_store27;

        5'b0000x :  r_wele_count27 <= r_wele_count27;

        5'b00011 :  r_wele_count27 <= r_wele_count27 - (2'd1);

        default  :  r_wele_count27 <= r_wele_count27;

      endcase // casex(case_wele27)

   end

end
   
//----------------------------------------------------------------------
// WS27 Store27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)
  
begin   

   if (~(n_sys_reset27))

      r_ws_store27 <= 8'd0;


   else if (valid_access27)

      r_ws_store27 <= 8'h01;

   else

      r_ws_store27 <= r_ws_store27;

end
   
   
   
//----------------------------------------------------------------------
//concatenation27 of signals27 to avoid using nested27 ifs27
//----------------------------------------------------------------------
   
   assign ws_count27   = (|r_ws_count27); //checks27 for count = 0
   assign case_ws27   = {1'b0,valid_access27,mac_smc_done27,ws_count27,
                       ws_enable27};
   
//----------------------------------------------------------------------
// WS27 Counter27
//----------------------------------------------------------------------

always @(posedge sys_clk27 or negedge n_sys_reset27)

begin   

   if (~(n_sys_reset27))

      r_ws_count27 <= 8'd0;

   else  
   begin
   
      casex(case_ws27)
 
         5'b1xxxx :  
            r_ws_count27 <= r_ws_count27;
        
         5'b01xxx :
            r_ws_count27 <= 8'h01;
        
         5'b001xx :  
            r_ws_count27 <= r_ws_store27;
        
         5'b0000x :  
            r_ws_count27 <= r_ws_count27;
        
         5'b00011 :  
            r_ws_count27 <= r_ws_count27 - 8'd1;
        
         default  :  
            r_ws_count27 <= r_ws_count27;

      endcase // casex(case_ws27)
      
   end
   
end  
   
   
endmodule
