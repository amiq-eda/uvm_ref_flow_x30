//File18 name   : smc_counter_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : Counter18 block.
//            : Static18 Memory Controller18.
//            : The counter block provides18 generates18 all cycle timings18
//            : The leading18 edge counts18 are individual18 2bit, loadable18,
//            : counters18. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing18
//            : edge counts18 are registered for comparison18 with the
//            : wait state counter. The bus float18 (CSTE18) is a
//            : separate18 2bit counter. The initial count values are
//            : stored18 and reloaded18 into the counters18 if multiple
//            : accesses are required18.
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


module smc_counter_lite18  (
                     //inputs18

                     sys_clk18,
                     n_sys_reset18,
                     valid_access18,
                     mac_done18, 
                     smc_done18, 
                     cste_enable18, 
                     ws_enable18,
                     le_enable18, 

                     //outputs18

                     r_csle_count18,
                     r_wele_count18,
                     r_ws_count18,
                     r_ws_store18,
                     r_oete_store18,
                     r_wete_store18,
                     r_wele_store18,
                     r_cste_count18,
                     r_csle_store18);
   

//----------------------------------------------------------------------
// the Wait18 State18 Counter18
//----------------------------------------------------------------------
   
   
   // I18/O18
   
   input     sys_clk18;                  // AHB18 System18 clock18
   input     n_sys_reset18;              // AHB18 System18 reset (Active18 LOW18)
   
   input     valid_access18;             // load18 values are valid if high18
   input     mac_done18;                 // All cycles18 in a multiple access

   //  completed
   
   input                 smc_done18;   // one access completed
   input                 cste_enable18;// Enable18 CS18 Trailing18 Edge18 counter
   input                 ws_enable18;  // Enable18 Wait18 State18 counter
   input                 le_enable18;  // Enable18 all Leading18 Edge18 counters18
   
   // Counter18 outputs18
   
   output [1:0]             r_csle_count18;  //chip18 select18 leading18
                                             //  edge count
   output [1:0]             r_wele_count18;  //write strobe18 leading18 
                                             // edge count
   output [7:0] r_ws_count18;    //wait state count
   output [1:0]             r_cste_count18;  //chip18 select18 trailing18 
                                             // edge count
   
   // Stored18 counts18 for MAC18
   
   output [1:0]             r_oete_store18;  //read strobe18
   output [1:0]             r_wete_store18;  //write strobe18 trailing18 
                                              // edge store18
   output [7:0] r_ws_store18;    //wait state store18
   output [1:0]             r_wele_store18;  //write strobe18 leading18
                                             //  edge store18
   output [1:0]             r_csle_store18;  //chip18 select18  leading18
                                             //  edge store18
   
   
   // Counters18
   
   reg [1:0]             r_csle_count18;  // Chip18 select18 LE18 counter
   reg [1:0]             r_wele_count18;  // Write counter
   reg [7:0] r_ws_count18;    // Wait18 state select18 counter
   reg [1:0]             r_cste_count18;  // Chip18 select18 TE18 counter
   
   
   // These18 strobes18 finish early18 so no counter is required18. 
   // The stored18 value is compared with WS18 counter to determine18 
   // when the strobe18 should end.

   reg [1:0]    r_wete_store18;    // Write strobe18 TE18 end time before CS18
   reg [1:0]    r_oete_store18;    // Read strobe18 TE18 end time before CS18
   
   
   // The following18 four18 regisrers18 are used to store18 the configuration
   // during mulitple18 accesses. The counters18 are reloaded18 from these18
   // registers before each cycle.
   
   reg [1:0]             r_csle_store18;    // Chip18 select18 LE18 store18
   reg [1:0]             r_wele_store18;    // Write strobe18 LE18 store18
   reg [7:0] r_ws_store18;      // Wait18 state store18
   reg [1:0]             r_cste_store18;    // Chip18 Select18 TE18 delay
                                          //  (Bus18 float18 time)

   // wires18 used for meeting18 coding18 standards18
   
   wire         ws_count18;      //ORed18 r_ws_count18
   wire         wele_count18;    //ORed18 r_wele_count18
   wire         cste_count18;    //ORed18 r_cste_count18
   wire         mac_smc_done18;  //ANDed18 smc_done18 and not(mac_done18)
   wire [4:0]   case_cste18;     //concatenated18 signals18 for case statement18
   wire [4:0]   case_wele18;     //concatenated18 signals18 for case statement18
   wire [4:0]   case_ws18;       //concatenated18 signals18 for case statement18
   
   
   
   // Main18 Code18
   
//----------------------------------------------------------------------
// Counters18 (& Count18 Store18 for MAC18)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE18 Store18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)

begin   

   if (~(n_sys_reset18))
     
      r_wete_store18 <= 2'b00;
   
   
   else if (valid_access18)
     
      r_wete_store18 <= 2'b0;
   
   else
     
      r_wete_store18 <= r_wete_store18;

end
   
//----------------------------------------------------------------------
// OETE18 Store18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)

begin   

   if (~(n_sys_reset18))
     
      r_oete_store18 <= 2'b00;
   
   
   else if (valid_access18)
     
      r_oete_store18 <= 2'b0;
   
   else

      r_oete_store18 <= r_oete_store18;

end
   
//----------------------------------------------------------------------
// CSLE18 Store18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)

begin   

   if (~(n_sys_reset18))
     
      r_csle_store18 <= 2'b00;
   
   
   else if (valid_access18)
     
      r_csle_store18 <= 2'b00;
   
   else
     
      r_csle_store18 <= r_csle_store18;

end
   
//----------------------------------------------------------------------
// CSLE18 Counter18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)

begin   

   if (~(n_sys_reset18))
     
      r_csle_count18 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access18)
        
         r_csle_count18 <= 2'b00;
      
      else if (~(mac_done18) & smc_done18)
        
         r_csle_count18 <= r_csle_store18;
      
      else if (r_csle_count18 == 2'b00)
        
         r_csle_count18 <= r_csle_count18;
      
      else if (le_enable18)               
        
         r_csle_count18 <= r_csle_count18 - 2'd1;
      
      else
        
          r_csle_count18 <= r_csle_count18;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE18 Store18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)

begin   

   if (~(n_sys_reset18))

      r_cste_store18 <= 2'b00;

   else if (valid_access18)

      r_cste_store18 <= 2'b0;

   else

      r_cste_store18 <= r_cste_store18;

end
   
   
   
//----------------------------------------------------------------------
//concatenation18 of signals18 to avoid using nested18 ifs18
//----------------------------------------------------------------------

 assign mac_smc_done18 = (~(mac_done18) & smc_done18);
 assign cste_count18   = (|r_cste_count18);           //checks18 for count = 0
 assign case_cste18   = {1'b0,valid_access18,mac_smc_done18,cste_count18,
                       cste_enable18};
   
//----------------------------------------------------------------------
//CSTE18 COUNTER18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)

begin   

   if (~(n_sys_reset18))

      r_cste_count18 <= 2'b00;

   else 
   begin
      casex(case_cste18)
           
        5'b1xxxx:        r_cste_count18 <= r_cste_count18;

        5'b01xxx:        r_cste_count18 <= 2'b0;

        5'b001xx:        r_cste_count18 <= r_cste_store18;

        5'b0000x:        r_cste_count18 <= r_cste_count18;

        5'b00011:        r_cste_count18 <= r_cste_count18 - 2'd1;

        default :        r_cste_count18 <= r_cste_count18;

      endcase // casex(w_cste_case18)
      
   end
   
end

//----------------------------------------------------------------------
// WELE18 Store18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)

begin   

   if (~(n_sys_reset18))

      r_wele_store18 <= 2'b00;


   else if (valid_access18)

      r_wele_store18 <= 2'b00;

   else

      r_wele_store18 <= r_wele_store18;

end
   
   
   
//----------------------------------------------------------------------
//concatenation18 of signals18 to avoid using nested18 ifs18
//----------------------------------------------------------------------
   
   assign wele_count18   = (|r_wele_count18);         //checks18 for count = 0
   assign case_wele18   = {1'b0,valid_access18,mac_smc_done18,wele_count18,
                         le_enable18};
   
//----------------------------------------------------------------------
// WELE18 Counter18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)

begin   
   if (~(n_sys_reset18))

      r_wele_count18 <= 2'b00;

   else
   begin

      casex(case_wele18)

        5'b1xxxx :  r_wele_count18 <= r_wele_count18;

        5'b01xxx :  r_wele_count18 <= 2'b00;

        5'b001xx :  r_wele_count18 <= r_wele_store18;

        5'b0000x :  r_wele_count18 <= r_wele_count18;

        5'b00011 :  r_wele_count18 <= r_wele_count18 - (2'd1);

        default  :  r_wele_count18 <= r_wele_count18;

      endcase // casex(case_wele18)

   end

end
   
//----------------------------------------------------------------------
// WS18 Store18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)
  
begin   

   if (~(n_sys_reset18))

      r_ws_store18 <= 8'd0;


   else if (valid_access18)

      r_ws_store18 <= 8'h01;

   else

      r_ws_store18 <= r_ws_store18;

end
   
   
   
//----------------------------------------------------------------------
//concatenation18 of signals18 to avoid using nested18 ifs18
//----------------------------------------------------------------------
   
   assign ws_count18   = (|r_ws_count18); //checks18 for count = 0
   assign case_ws18   = {1'b0,valid_access18,mac_smc_done18,ws_count18,
                       ws_enable18};
   
//----------------------------------------------------------------------
// WS18 Counter18
//----------------------------------------------------------------------

always @(posedge sys_clk18 or negedge n_sys_reset18)

begin   

   if (~(n_sys_reset18))

      r_ws_count18 <= 8'd0;

   else  
   begin
   
      casex(case_ws18)
 
         5'b1xxxx :  
            r_ws_count18 <= r_ws_count18;
        
         5'b01xxx :
            r_ws_count18 <= 8'h01;
        
         5'b001xx :  
            r_ws_count18 <= r_ws_store18;
        
         5'b0000x :  
            r_ws_count18 <= r_ws_count18;
        
         5'b00011 :  
            r_ws_count18 <= r_ws_count18 - 8'd1;
        
         default  :  
            r_ws_count18 <= r_ws_count18;

      endcase // casex(case_ws18)
      
   end
   
end  
   
   
endmodule
