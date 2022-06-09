//File10 name   : smc_counter_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : Counter10 block.
//            : Static10 Memory Controller10.
//            : The counter block provides10 generates10 all cycle timings10
//            : The leading10 edge counts10 are individual10 2bit, loadable10,
//            : counters10. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing10
//            : edge counts10 are registered for comparison10 with the
//            : wait state counter. The bus float10 (CSTE10) is a
//            : separate10 2bit counter. The initial count values are
//            : stored10 and reloaded10 into the counters10 if multiple
//            : accesses are required10.
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


module smc_counter_lite10  (
                     //inputs10

                     sys_clk10,
                     n_sys_reset10,
                     valid_access10,
                     mac_done10, 
                     smc_done10, 
                     cste_enable10, 
                     ws_enable10,
                     le_enable10, 

                     //outputs10

                     r_csle_count10,
                     r_wele_count10,
                     r_ws_count10,
                     r_ws_store10,
                     r_oete_store10,
                     r_wete_store10,
                     r_wele_store10,
                     r_cste_count10,
                     r_csle_store10);
   

//----------------------------------------------------------------------
// the Wait10 State10 Counter10
//----------------------------------------------------------------------
   
   
   // I10/O10
   
   input     sys_clk10;                  // AHB10 System10 clock10
   input     n_sys_reset10;              // AHB10 System10 reset (Active10 LOW10)
   
   input     valid_access10;             // load10 values are valid if high10
   input     mac_done10;                 // All cycles10 in a multiple access

   //  completed
   
   input                 smc_done10;   // one access completed
   input                 cste_enable10;// Enable10 CS10 Trailing10 Edge10 counter
   input                 ws_enable10;  // Enable10 Wait10 State10 counter
   input                 le_enable10;  // Enable10 all Leading10 Edge10 counters10
   
   // Counter10 outputs10
   
   output [1:0]             r_csle_count10;  //chip10 select10 leading10
                                             //  edge count
   output [1:0]             r_wele_count10;  //write strobe10 leading10 
                                             // edge count
   output [7:0] r_ws_count10;    //wait state count
   output [1:0]             r_cste_count10;  //chip10 select10 trailing10 
                                             // edge count
   
   // Stored10 counts10 for MAC10
   
   output [1:0]             r_oete_store10;  //read strobe10
   output [1:0]             r_wete_store10;  //write strobe10 trailing10 
                                              // edge store10
   output [7:0] r_ws_store10;    //wait state store10
   output [1:0]             r_wele_store10;  //write strobe10 leading10
                                             //  edge store10
   output [1:0]             r_csle_store10;  //chip10 select10  leading10
                                             //  edge store10
   
   
   // Counters10
   
   reg [1:0]             r_csle_count10;  // Chip10 select10 LE10 counter
   reg [1:0]             r_wele_count10;  // Write counter
   reg [7:0] r_ws_count10;    // Wait10 state select10 counter
   reg [1:0]             r_cste_count10;  // Chip10 select10 TE10 counter
   
   
   // These10 strobes10 finish early10 so no counter is required10. 
   // The stored10 value is compared with WS10 counter to determine10 
   // when the strobe10 should end.

   reg [1:0]    r_wete_store10;    // Write strobe10 TE10 end time before CS10
   reg [1:0]    r_oete_store10;    // Read strobe10 TE10 end time before CS10
   
   
   // The following10 four10 regisrers10 are used to store10 the configuration
   // during mulitple10 accesses. The counters10 are reloaded10 from these10
   // registers before each cycle.
   
   reg [1:0]             r_csle_store10;    // Chip10 select10 LE10 store10
   reg [1:0]             r_wele_store10;    // Write strobe10 LE10 store10
   reg [7:0] r_ws_store10;      // Wait10 state store10
   reg [1:0]             r_cste_store10;    // Chip10 Select10 TE10 delay
                                          //  (Bus10 float10 time)

   // wires10 used for meeting10 coding10 standards10
   
   wire         ws_count10;      //ORed10 r_ws_count10
   wire         wele_count10;    //ORed10 r_wele_count10
   wire         cste_count10;    //ORed10 r_cste_count10
   wire         mac_smc_done10;  //ANDed10 smc_done10 and not(mac_done10)
   wire [4:0]   case_cste10;     //concatenated10 signals10 for case statement10
   wire [4:0]   case_wele10;     //concatenated10 signals10 for case statement10
   wire [4:0]   case_ws10;       //concatenated10 signals10 for case statement10
   
   
   
   // Main10 Code10
   
//----------------------------------------------------------------------
// Counters10 (& Count10 Store10 for MAC10)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE10 Store10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)

begin   

   if (~(n_sys_reset10))
     
      r_wete_store10 <= 2'b00;
   
   
   else if (valid_access10)
     
      r_wete_store10 <= 2'b0;
   
   else
     
      r_wete_store10 <= r_wete_store10;

end
   
//----------------------------------------------------------------------
// OETE10 Store10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)

begin   

   if (~(n_sys_reset10))
     
      r_oete_store10 <= 2'b00;
   
   
   else if (valid_access10)
     
      r_oete_store10 <= 2'b0;
   
   else

      r_oete_store10 <= r_oete_store10;

end
   
//----------------------------------------------------------------------
// CSLE10 Store10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)

begin   

   if (~(n_sys_reset10))
     
      r_csle_store10 <= 2'b00;
   
   
   else if (valid_access10)
     
      r_csle_store10 <= 2'b00;
   
   else
     
      r_csle_store10 <= r_csle_store10;

end
   
//----------------------------------------------------------------------
// CSLE10 Counter10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)

begin   

   if (~(n_sys_reset10))
     
      r_csle_count10 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access10)
        
         r_csle_count10 <= 2'b00;
      
      else if (~(mac_done10) & smc_done10)
        
         r_csle_count10 <= r_csle_store10;
      
      else if (r_csle_count10 == 2'b00)
        
         r_csle_count10 <= r_csle_count10;
      
      else if (le_enable10)               
        
         r_csle_count10 <= r_csle_count10 - 2'd1;
      
      else
        
          r_csle_count10 <= r_csle_count10;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE10 Store10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)

begin   

   if (~(n_sys_reset10))

      r_cste_store10 <= 2'b00;

   else if (valid_access10)

      r_cste_store10 <= 2'b0;

   else

      r_cste_store10 <= r_cste_store10;

end
   
   
   
//----------------------------------------------------------------------
//concatenation10 of signals10 to avoid using nested10 ifs10
//----------------------------------------------------------------------

 assign mac_smc_done10 = (~(mac_done10) & smc_done10);
 assign cste_count10   = (|r_cste_count10);           //checks10 for count = 0
 assign case_cste10   = {1'b0,valid_access10,mac_smc_done10,cste_count10,
                       cste_enable10};
   
//----------------------------------------------------------------------
//CSTE10 COUNTER10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)

begin   

   if (~(n_sys_reset10))

      r_cste_count10 <= 2'b00;

   else 
   begin
      casex(case_cste10)
           
        5'b1xxxx:        r_cste_count10 <= r_cste_count10;

        5'b01xxx:        r_cste_count10 <= 2'b0;

        5'b001xx:        r_cste_count10 <= r_cste_store10;

        5'b0000x:        r_cste_count10 <= r_cste_count10;

        5'b00011:        r_cste_count10 <= r_cste_count10 - 2'd1;

        default :        r_cste_count10 <= r_cste_count10;

      endcase // casex(w_cste_case10)
      
   end
   
end

//----------------------------------------------------------------------
// WELE10 Store10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)

begin   

   if (~(n_sys_reset10))

      r_wele_store10 <= 2'b00;


   else if (valid_access10)

      r_wele_store10 <= 2'b00;

   else

      r_wele_store10 <= r_wele_store10;

end
   
   
   
//----------------------------------------------------------------------
//concatenation10 of signals10 to avoid using nested10 ifs10
//----------------------------------------------------------------------
   
   assign wele_count10   = (|r_wele_count10);         //checks10 for count = 0
   assign case_wele10   = {1'b0,valid_access10,mac_smc_done10,wele_count10,
                         le_enable10};
   
//----------------------------------------------------------------------
// WELE10 Counter10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)

begin   
   if (~(n_sys_reset10))

      r_wele_count10 <= 2'b00;

   else
   begin

      casex(case_wele10)

        5'b1xxxx :  r_wele_count10 <= r_wele_count10;

        5'b01xxx :  r_wele_count10 <= 2'b00;

        5'b001xx :  r_wele_count10 <= r_wele_store10;

        5'b0000x :  r_wele_count10 <= r_wele_count10;

        5'b00011 :  r_wele_count10 <= r_wele_count10 - (2'd1);

        default  :  r_wele_count10 <= r_wele_count10;

      endcase // casex(case_wele10)

   end

end
   
//----------------------------------------------------------------------
// WS10 Store10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)
  
begin   

   if (~(n_sys_reset10))

      r_ws_store10 <= 8'd0;


   else if (valid_access10)

      r_ws_store10 <= 8'h01;

   else

      r_ws_store10 <= r_ws_store10;

end
   
   
   
//----------------------------------------------------------------------
//concatenation10 of signals10 to avoid using nested10 ifs10
//----------------------------------------------------------------------
   
   assign ws_count10   = (|r_ws_count10); //checks10 for count = 0
   assign case_ws10   = {1'b0,valid_access10,mac_smc_done10,ws_count10,
                       ws_enable10};
   
//----------------------------------------------------------------------
// WS10 Counter10
//----------------------------------------------------------------------

always @(posedge sys_clk10 or negedge n_sys_reset10)

begin   

   if (~(n_sys_reset10))

      r_ws_count10 <= 8'd0;

   else  
   begin
   
      casex(case_ws10)
 
         5'b1xxxx :  
            r_ws_count10 <= r_ws_count10;
        
         5'b01xxx :
            r_ws_count10 <= 8'h01;
        
         5'b001xx :  
            r_ws_count10 <= r_ws_store10;
        
         5'b0000x :  
            r_ws_count10 <= r_ws_count10;
        
         5'b00011 :  
            r_ws_count10 <= r_ws_count10 - 8'd1;
        
         default  :  
            r_ws_count10 <= r_ws_count10;

      endcase // casex(case_ws10)
      
   end
   
end  
   
   
endmodule
