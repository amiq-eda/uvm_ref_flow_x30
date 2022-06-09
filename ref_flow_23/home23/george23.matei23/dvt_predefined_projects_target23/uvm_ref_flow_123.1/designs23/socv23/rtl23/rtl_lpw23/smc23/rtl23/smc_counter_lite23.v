//File23 name   : smc_counter_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : Counter23 block.
//            : Static23 Memory Controller23.
//            : The counter block provides23 generates23 all cycle timings23
//            : The leading23 edge counts23 are individual23 2bit, loadable23,
//            : counters23. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing23
//            : edge counts23 are registered for comparison23 with the
//            : wait state counter. The bus float23 (CSTE23) is a
//            : separate23 2bit counter. The initial count values are
//            : stored23 and reloaded23 into the counters23 if multiple
//            : accesses are required23.
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


module smc_counter_lite23  (
                     //inputs23

                     sys_clk23,
                     n_sys_reset23,
                     valid_access23,
                     mac_done23, 
                     smc_done23, 
                     cste_enable23, 
                     ws_enable23,
                     le_enable23, 

                     //outputs23

                     r_csle_count23,
                     r_wele_count23,
                     r_ws_count23,
                     r_ws_store23,
                     r_oete_store23,
                     r_wete_store23,
                     r_wele_store23,
                     r_cste_count23,
                     r_csle_store23);
   

//----------------------------------------------------------------------
// the Wait23 State23 Counter23
//----------------------------------------------------------------------
   
   
   // I23/O23
   
   input     sys_clk23;                  // AHB23 System23 clock23
   input     n_sys_reset23;              // AHB23 System23 reset (Active23 LOW23)
   
   input     valid_access23;             // load23 values are valid if high23
   input     mac_done23;                 // All cycles23 in a multiple access

   //  completed
   
   input                 smc_done23;   // one access completed
   input                 cste_enable23;// Enable23 CS23 Trailing23 Edge23 counter
   input                 ws_enable23;  // Enable23 Wait23 State23 counter
   input                 le_enable23;  // Enable23 all Leading23 Edge23 counters23
   
   // Counter23 outputs23
   
   output [1:0]             r_csle_count23;  //chip23 select23 leading23
                                             //  edge count
   output [1:0]             r_wele_count23;  //write strobe23 leading23 
                                             // edge count
   output [7:0] r_ws_count23;    //wait state count
   output [1:0]             r_cste_count23;  //chip23 select23 trailing23 
                                             // edge count
   
   // Stored23 counts23 for MAC23
   
   output [1:0]             r_oete_store23;  //read strobe23
   output [1:0]             r_wete_store23;  //write strobe23 trailing23 
                                              // edge store23
   output [7:0] r_ws_store23;    //wait state store23
   output [1:0]             r_wele_store23;  //write strobe23 leading23
                                             //  edge store23
   output [1:0]             r_csle_store23;  //chip23 select23  leading23
                                             //  edge store23
   
   
   // Counters23
   
   reg [1:0]             r_csle_count23;  // Chip23 select23 LE23 counter
   reg [1:0]             r_wele_count23;  // Write counter
   reg [7:0] r_ws_count23;    // Wait23 state select23 counter
   reg [1:0]             r_cste_count23;  // Chip23 select23 TE23 counter
   
   
   // These23 strobes23 finish early23 so no counter is required23. 
   // The stored23 value is compared with WS23 counter to determine23 
   // when the strobe23 should end.

   reg [1:0]    r_wete_store23;    // Write strobe23 TE23 end time before CS23
   reg [1:0]    r_oete_store23;    // Read strobe23 TE23 end time before CS23
   
   
   // The following23 four23 regisrers23 are used to store23 the configuration
   // during mulitple23 accesses. The counters23 are reloaded23 from these23
   // registers before each cycle.
   
   reg [1:0]             r_csle_store23;    // Chip23 select23 LE23 store23
   reg [1:0]             r_wele_store23;    // Write strobe23 LE23 store23
   reg [7:0] r_ws_store23;      // Wait23 state store23
   reg [1:0]             r_cste_store23;    // Chip23 Select23 TE23 delay
                                          //  (Bus23 float23 time)

   // wires23 used for meeting23 coding23 standards23
   
   wire         ws_count23;      //ORed23 r_ws_count23
   wire         wele_count23;    //ORed23 r_wele_count23
   wire         cste_count23;    //ORed23 r_cste_count23
   wire         mac_smc_done23;  //ANDed23 smc_done23 and not(mac_done23)
   wire [4:0]   case_cste23;     //concatenated23 signals23 for case statement23
   wire [4:0]   case_wele23;     //concatenated23 signals23 for case statement23
   wire [4:0]   case_ws23;       //concatenated23 signals23 for case statement23
   
   
   
   // Main23 Code23
   
//----------------------------------------------------------------------
// Counters23 (& Count23 Store23 for MAC23)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE23 Store23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)

begin   

   if (~(n_sys_reset23))
     
      r_wete_store23 <= 2'b00;
   
   
   else if (valid_access23)
     
      r_wete_store23 <= 2'b0;
   
   else
     
      r_wete_store23 <= r_wete_store23;

end
   
//----------------------------------------------------------------------
// OETE23 Store23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)

begin   

   if (~(n_sys_reset23))
     
      r_oete_store23 <= 2'b00;
   
   
   else if (valid_access23)
     
      r_oete_store23 <= 2'b0;
   
   else

      r_oete_store23 <= r_oete_store23;

end
   
//----------------------------------------------------------------------
// CSLE23 Store23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)

begin   

   if (~(n_sys_reset23))
     
      r_csle_store23 <= 2'b00;
   
   
   else if (valid_access23)
     
      r_csle_store23 <= 2'b00;
   
   else
     
      r_csle_store23 <= r_csle_store23;

end
   
//----------------------------------------------------------------------
// CSLE23 Counter23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)

begin   

   if (~(n_sys_reset23))
     
      r_csle_count23 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access23)
        
         r_csle_count23 <= 2'b00;
      
      else if (~(mac_done23) & smc_done23)
        
         r_csle_count23 <= r_csle_store23;
      
      else if (r_csle_count23 == 2'b00)
        
         r_csle_count23 <= r_csle_count23;
      
      else if (le_enable23)               
        
         r_csle_count23 <= r_csle_count23 - 2'd1;
      
      else
        
          r_csle_count23 <= r_csle_count23;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE23 Store23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)

begin   

   if (~(n_sys_reset23))

      r_cste_store23 <= 2'b00;

   else if (valid_access23)

      r_cste_store23 <= 2'b0;

   else

      r_cste_store23 <= r_cste_store23;

end
   
   
   
//----------------------------------------------------------------------
//concatenation23 of signals23 to avoid using nested23 ifs23
//----------------------------------------------------------------------

 assign mac_smc_done23 = (~(mac_done23) & smc_done23);
 assign cste_count23   = (|r_cste_count23);           //checks23 for count = 0
 assign case_cste23   = {1'b0,valid_access23,mac_smc_done23,cste_count23,
                       cste_enable23};
   
//----------------------------------------------------------------------
//CSTE23 COUNTER23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)

begin   

   if (~(n_sys_reset23))

      r_cste_count23 <= 2'b00;

   else 
   begin
      casex(case_cste23)
           
        5'b1xxxx:        r_cste_count23 <= r_cste_count23;

        5'b01xxx:        r_cste_count23 <= 2'b0;

        5'b001xx:        r_cste_count23 <= r_cste_store23;

        5'b0000x:        r_cste_count23 <= r_cste_count23;

        5'b00011:        r_cste_count23 <= r_cste_count23 - 2'd1;

        default :        r_cste_count23 <= r_cste_count23;

      endcase // casex(w_cste_case23)
      
   end
   
end

//----------------------------------------------------------------------
// WELE23 Store23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)

begin   

   if (~(n_sys_reset23))

      r_wele_store23 <= 2'b00;


   else if (valid_access23)

      r_wele_store23 <= 2'b00;

   else

      r_wele_store23 <= r_wele_store23;

end
   
   
   
//----------------------------------------------------------------------
//concatenation23 of signals23 to avoid using nested23 ifs23
//----------------------------------------------------------------------
   
   assign wele_count23   = (|r_wele_count23);         //checks23 for count = 0
   assign case_wele23   = {1'b0,valid_access23,mac_smc_done23,wele_count23,
                         le_enable23};
   
//----------------------------------------------------------------------
// WELE23 Counter23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)

begin   
   if (~(n_sys_reset23))

      r_wele_count23 <= 2'b00;

   else
   begin

      casex(case_wele23)

        5'b1xxxx :  r_wele_count23 <= r_wele_count23;

        5'b01xxx :  r_wele_count23 <= 2'b00;

        5'b001xx :  r_wele_count23 <= r_wele_store23;

        5'b0000x :  r_wele_count23 <= r_wele_count23;

        5'b00011 :  r_wele_count23 <= r_wele_count23 - (2'd1);

        default  :  r_wele_count23 <= r_wele_count23;

      endcase // casex(case_wele23)

   end

end
   
//----------------------------------------------------------------------
// WS23 Store23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)
  
begin   

   if (~(n_sys_reset23))

      r_ws_store23 <= 8'd0;


   else if (valid_access23)

      r_ws_store23 <= 8'h01;

   else

      r_ws_store23 <= r_ws_store23;

end
   
   
   
//----------------------------------------------------------------------
//concatenation23 of signals23 to avoid using nested23 ifs23
//----------------------------------------------------------------------
   
   assign ws_count23   = (|r_ws_count23); //checks23 for count = 0
   assign case_ws23   = {1'b0,valid_access23,mac_smc_done23,ws_count23,
                       ws_enable23};
   
//----------------------------------------------------------------------
// WS23 Counter23
//----------------------------------------------------------------------

always @(posedge sys_clk23 or negedge n_sys_reset23)

begin   

   if (~(n_sys_reset23))

      r_ws_count23 <= 8'd0;

   else  
   begin
   
      casex(case_ws23)
 
         5'b1xxxx :  
            r_ws_count23 <= r_ws_count23;
        
         5'b01xxx :
            r_ws_count23 <= 8'h01;
        
         5'b001xx :  
            r_ws_count23 <= r_ws_store23;
        
         5'b0000x :  
            r_ws_count23 <= r_ws_count23;
        
         5'b00011 :  
            r_ws_count23 <= r_ws_count23 - 8'd1;
        
         default  :  
            r_ws_count23 <= r_ws_count23;

      endcase // casex(case_ws23)
      
   end
   
end  
   
   
endmodule
