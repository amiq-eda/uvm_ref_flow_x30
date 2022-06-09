//File17 name   : smc_counter_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : Counter17 block.
//            : Static17 Memory Controller17.
//            : The counter block provides17 generates17 all cycle timings17
//            : The leading17 edge counts17 are individual17 2bit, loadable17,
//            : counters17. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing17
//            : edge counts17 are registered for comparison17 with the
//            : wait state counter. The bus float17 (CSTE17) is a
//            : separate17 2bit counter. The initial count values are
//            : stored17 and reloaded17 into the counters17 if multiple
//            : accesses are required17.
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


module smc_counter_lite17  (
                     //inputs17

                     sys_clk17,
                     n_sys_reset17,
                     valid_access17,
                     mac_done17, 
                     smc_done17, 
                     cste_enable17, 
                     ws_enable17,
                     le_enable17, 

                     //outputs17

                     r_csle_count17,
                     r_wele_count17,
                     r_ws_count17,
                     r_ws_store17,
                     r_oete_store17,
                     r_wete_store17,
                     r_wele_store17,
                     r_cste_count17,
                     r_csle_store17);
   

//----------------------------------------------------------------------
// the Wait17 State17 Counter17
//----------------------------------------------------------------------
   
   
   // I17/O17
   
   input     sys_clk17;                  // AHB17 System17 clock17
   input     n_sys_reset17;              // AHB17 System17 reset (Active17 LOW17)
   
   input     valid_access17;             // load17 values are valid if high17
   input     mac_done17;                 // All cycles17 in a multiple access

   //  completed
   
   input                 smc_done17;   // one access completed
   input                 cste_enable17;// Enable17 CS17 Trailing17 Edge17 counter
   input                 ws_enable17;  // Enable17 Wait17 State17 counter
   input                 le_enable17;  // Enable17 all Leading17 Edge17 counters17
   
   // Counter17 outputs17
   
   output [1:0]             r_csle_count17;  //chip17 select17 leading17
                                             //  edge count
   output [1:0]             r_wele_count17;  //write strobe17 leading17 
                                             // edge count
   output [7:0] r_ws_count17;    //wait state count
   output [1:0]             r_cste_count17;  //chip17 select17 trailing17 
                                             // edge count
   
   // Stored17 counts17 for MAC17
   
   output [1:0]             r_oete_store17;  //read strobe17
   output [1:0]             r_wete_store17;  //write strobe17 trailing17 
                                              // edge store17
   output [7:0] r_ws_store17;    //wait state store17
   output [1:0]             r_wele_store17;  //write strobe17 leading17
                                             //  edge store17
   output [1:0]             r_csle_store17;  //chip17 select17  leading17
                                             //  edge store17
   
   
   // Counters17
   
   reg [1:0]             r_csle_count17;  // Chip17 select17 LE17 counter
   reg [1:0]             r_wele_count17;  // Write counter
   reg [7:0] r_ws_count17;    // Wait17 state select17 counter
   reg [1:0]             r_cste_count17;  // Chip17 select17 TE17 counter
   
   
   // These17 strobes17 finish early17 so no counter is required17. 
   // The stored17 value is compared with WS17 counter to determine17 
   // when the strobe17 should end.

   reg [1:0]    r_wete_store17;    // Write strobe17 TE17 end time before CS17
   reg [1:0]    r_oete_store17;    // Read strobe17 TE17 end time before CS17
   
   
   // The following17 four17 regisrers17 are used to store17 the configuration
   // during mulitple17 accesses. The counters17 are reloaded17 from these17
   // registers before each cycle.
   
   reg [1:0]             r_csle_store17;    // Chip17 select17 LE17 store17
   reg [1:0]             r_wele_store17;    // Write strobe17 LE17 store17
   reg [7:0] r_ws_store17;      // Wait17 state store17
   reg [1:0]             r_cste_store17;    // Chip17 Select17 TE17 delay
                                          //  (Bus17 float17 time)

   // wires17 used for meeting17 coding17 standards17
   
   wire         ws_count17;      //ORed17 r_ws_count17
   wire         wele_count17;    //ORed17 r_wele_count17
   wire         cste_count17;    //ORed17 r_cste_count17
   wire         mac_smc_done17;  //ANDed17 smc_done17 and not(mac_done17)
   wire [4:0]   case_cste17;     //concatenated17 signals17 for case statement17
   wire [4:0]   case_wele17;     //concatenated17 signals17 for case statement17
   wire [4:0]   case_ws17;       //concatenated17 signals17 for case statement17
   
   
   
   // Main17 Code17
   
//----------------------------------------------------------------------
// Counters17 (& Count17 Store17 for MAC17)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE17 Store17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)

begin   

   if (~(n_sys_reset17))
     
      r_wete_store17 <= 2'b00;
   
   
   else if (valid_access17)
     
      r_wete_store17 <= 2'b0;
   
   else
     
      r_wete_store17 <= r_wete_store17;

end
   
//----------------------------------------------------------------------
// OETE17 Store17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)

begin   

   if (~(n_sys_reset17))
     
      r_oete_store17 <= 2'b00;
   
   
   else if (valid_access17)
     
      r_oete_store17 <= 2'b0;
   
   else

      r_oete_store17 <= r_oete_store17;

end
   
//----------------------------------------------------------------------
// CSLE17 Store17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)

begin   

   if (~(n_sys_reset17))
     
      r_csle_store17 <= 2'b00;
   
   
   else if (valid_access17)
     
      r_csle_store17 <= 2'b00;
   
   else
     
      r_csle_store17 <= r_csle_store17;

end
   
//----------------------------------------------------------------------
// CSLE17 Counter17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)

begin   

   if (~(n_sys_reset17))
     
      r_csle_count17 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access17)
        
         r_csle_count17 <= 2'b00;
      
      else if (~(mac_done17) & smc_done17)
        
         r_csle_count17 <= r_csle_store17;
      
      else if (r_csle_count17 == 2'b00)
        
         r_csle_count17 <= r_csle_count17;
      
      else if (le_enable17)               
        
         r_csle_count17 <= r_csle_count17 - 2'd1;
      
      else
        
          r_csle_count17 <= r_csle_count17;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE17 Store17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)

begin   

   if (~(n_sys_reset17))

      r_cste_store17 <= 2'b00;

   else if (valid_access17)

      r_cste_store17 <= 2'b0;

   else

      r_cste_store17 <= r_cste_store17;

end
   
   
   
//----------------------------------------------------------------------
//concatenation17 of signals17 to avoid using nested17 ifs17
//----------------------------------------------------------------------

 assign mac_smc_done17 = (~(mac_done17) & smc_done17);
 assign cste_count17   = (|r_cste_count17);           //checks17 for count = 0
 assign case_cste17   = {1'b0,valid_access17,mac_smc_done17,cste_count17,
                       cste_enable17};
   
//----------------------------------------------------------------------
//CSTE17 COUNTER17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)

begin   

   if (~(n_sys_reset17))

      r_cste_count17 <= 2'b00;

   else 
   begin
      casex(case_cste17)
           
        5'b1xxxx:        r_cste_count17 <= r_cste_count17;

        5'b01xxx:        r_cste_count17 <= 2'b0;

        5'b001xx:        r_cste_count17 <= r_cste_store17;

        5'b0000x:        r_cste_count17 <= r_cste_count17;

        5'b00011:        r_cste_count17 <= r_cste_count17 - 2'd1;

        default :        r_cste_count17 <= r_cste_count17;

      endcase // casex(w_cste_case17)
      
   end
   
end

//----------------------------------------------------------------------
// WELE17 Store17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)

begin   

   if (~(n_sys_reset17))

      r_wele_store17 <= 2'b00;


   else if (valid_access17)

      r_wele_store17 <= 2'b00;

   else

      r_wele_store17 <= r_wele_store17;

end
   
   
   
//----------------------------------------------------------------------
//concatenation17 of signals17 to avoid using nested17 ifs17
//----------------------------------------------------------------------
   
   assign wele_count17   = (|r_wele_count17);         //checks17 for count = 0
   assign case_wele17   = {1'b0,valid_access17,mac_smc_done17,wele_count17,
                         le_enable17};
   
//----------------------------------------------------------------------
// WELE17 Counter17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)

begin   
   if (~(n_sys_reset17))

      r_wele_count17 <= 2'b00;

   else
   begin

      casex(case_wele17)

        5'b1xxxx :  r_wele_count17 <= r_wele_count17;

        5'b01xxx :  r_wele_count17 <= 2'b00;

        5'b001xx :  r_wele_count17 <= r_wele_store17;

        5'b0000x :  r_wele_count17 <= r_wele_count17;

        5'b00011 :  r_wele_count17 <= r_wele_count17 - (2'd1);

        default  :  r_wele_count17 <= r_wele_count17;

      endcase // casex(case_wele17)

   end

end
   
//----------------------------------------------------------------------
// WS17 Store17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)
  
begin   

   if (~(n_sys_reset17))

      r_ws_store17 <= 8'd0;


   else if (valid_access17)

      r_ws_store17 <= 8'h01;

   else

      r_ws_store17 <= r_ws_store17;

end
   
   
   
//----------------------------------------------------------------------
//concatenation17 of signals17 to avoid using nested17 ifs17
//----------------------------------------------------------------------
   
   assign ws_count17   = (|r_ws_count17); //checks17 for count = 0
   assign case_ws17   = {1'b0,valid_access17,mac_smc_done17,ws_count17,
                       ws_enable17};
   
//----------------------------------------------------------------------
// WS17 Counter17
//----------------------------------------------------------------------

always @(posedge sys_clk17 or negedge n_sys_reset17)

begin   

   if (~(n_sys_reset17))

      r_ws_count17 <= 8'd0;

   else  
   begin
   
      casex(case_ws17)
 
         5'b1xxxx :  
            r_ws_count17 <= r_ws_count17;
        
         5'b01xxx :
            r_ws_count17 <= 8'h01;
        
         5'b001xx :  
            r_ws_count17 <= r_ws_store17;
        
         5'b0000x :  
            r_ws_count17 <= r_ws_count17;
        
         5'b00011 :  
            r_ws_count17 <= r_ws_count17 - 8'd1;
        
         default  :  
            r_ws_count17 <= r_ws_count17;

      endcase // casex(case_ws17)
      
   end
   
end  
   
   
endmodule
