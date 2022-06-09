//File29 name   : smc_counter_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : Counter29 block.
//            : Static29 Memory Controller29.
//            : The counter block provides29 generates29 all cycle timings29
//            : The leading29 edge counts29 are individual29 2bit, loadable29,
//            : counters29. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing29
//            : edge counts29 are registered for comparison29 with the
//            : wait state counter. The bus float29 (CSTE29) is a
//            : separate29 2bit counter. The initial count values are
//            : stored29 and reloaded29 into the counters29 if multiple
//            : accesses are required29.
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


module smc_counter_lite29  (
                     //inputs29

                     sys_clk29,
                     n_sys_reset29,
                     valid_access29,
                     mac_done29, 
                     smc_done29, 
                     cste_enable29, 
                     ws_enable29,
                     le_enable29, 

                     //outputs29

                     r_csle_count29,
                     r_wele_count29,
                     r_ws_count29,
                     r_ws_store29,
                     r_oete_store29,
                     r_wete_store29,
                     r_wele_store29,
                     r_cste_count29,
                     r_csle_store29);
   

//----------------------------------------------------------------------
// the Wait29 State29 Counter29
//----------------------------------------------------------------------
   
   
   // I29/O29
   
   input     sys_clk29;                  // AHB29 System29 clock29
   input     n_sys_reset29;              // AHB29 System29 reset (Active29 LOW29)
   
   input     valid_access29;             // load29 values are valid if high29
   input     mac_done29;                 // All cycles29 in a multiple access

   //  completed
   
   input                 smc_done29;   // one access completed
   input                 cste_enable29;// Enable29 CS29 Trailing29 Edge29 counter
   input                 ws_enable29;  // Enable29 Wait29 State29 counter
   input                 le_enable29;  // Enable29 all Leading29 Edge29 counters29
   
   // Counter29 outputs29
   
   output [1:0]             r_csle_count29;  //chip29 select29 leading29
                                             //  edge count
   output [1:0]             r_wele_count29;  //write strobe29 leading29 
                                             // edge count
   output [7:0] r_ws_count29;    //wait state count
   output [1:0]             r_cste_count29;  //chip29 select29 trailing29 
                                             // edge count
   
   // Stored29 counts29 for MAC29
   
   output [1:0]             r_oete_store29;  //read strobe29
   output [1:0]             r_wete_store29;  //write strobe29 trailing29 
                                              // edge store29
   output [7:0] r_ws_store29;    //wait state store29
   output [1:0]             r_wele_store29;  //write strobe29 leading29
                                             //  edge store29
   output [1:0]             r_csle_store29;  //chip29 select29  leading29
                                             //  edge store29
   
   
   // Counters29
   
   reg [1:0]             r_csle_count29;  // Chip29 select29 LE29 counter
   reg [1:0]             r_wele_count29;  // Write counter
   reg [7:0] r_ws_count29;    // Wait29 state select29 counter
   reg [1:0]             r_cste_count29;  // Chip29 select29 TE29 counter
   
   
   // These29 strobes29 finish early29 so no counter is required29. 
   // The stored29 value is compared with WS29 counter to determine29 
   // when the strobe29 should end.

   reg [1:0]    r_wete_store29;    // Write strobe29 TE29 end time before CS29
   reg [1:0]    r_oete_store29;    // Read strobe29 TE29 end time before CS29
   
   
   // The following29 four29 regisrers29 are used to store29 the configuration
   // during mulitple29 accesses. The counters29 are reloaded29 from these29
   // registers before each cycle.
   
   reg [1:0]             r_csle_store29;    // Chip29 select29 LE29 store29
   reg [1:0]             r_wele_store29;    // Write strobe29 LE29 store29
   reg [7:0] r_ws_store29;      // Wait29 state store29
   reg [1:0]             r_cste_store29;    // Chip29 Select29 TE29 delay
                                          //  (Bus29 float29 time)

   // wires29 used for meeting29 coding29 standards29
   
   wire         ws_count29;      //ORed29 r_ws_count29
   wire         wele_count29;    //ORed29 r_wele_count29
   wire         cste_count29;    //ORed29 r_cste_count29
   wire         mac_smc_done29;  //ANDed29 smc_done29 and not(mac_done29)
   wire [4:0]   case_cste29;     //concatenated29 signals29 for case statement29
   wire [4:0]   case_wele29;     //concatenated29 signals29 for case statement29
   wire [4:0]   case_ws29;       //concatenated29 signals29 for case statement29
   
   
   
   // Main29 Code29
   
//----------------------------------------------------------------------
// Counters29 (& Count29 Store29 for MAC29)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE29 Store29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)

begin   

   if (~(n_sys_reset29))
     
      r_wete_store29 <= 2'b00;
   
   
   else if (valid_access29)
     
      r_wete_store29 <= 2'b0;
   
   else
     
      r_wete_store29 <= r_wete_store29;

end
   
//----------------------------------------------------------------------
// OETE29 Store29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)

begin   

   if (~(n_sys_reset29))
     
      r_oete_store29 <= 2'b00;
   
   
   else if (valid_access29)
     
      r_oete_store29 <= 2'b0;
   
   else

      r_oete_store29 <= r_oete_store29;

end
   
//----------------------------------------------------------------------
// CSLE29 Store29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)

begin   

   if (~(n_sys_reset29))
     
      r_csle_store29 <= 2'b00;
   
   
   else if (valid_access29)
     
      r_csle_store29 <= 2'b00;
   
   else
     
      r_csle_store29 <= r_csle_store29;

end
   
//----------------------------------------------------------------------
// CSLE29 Counter29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)

begin   

   if (~(n_sys_reset29))
     
      r_csle_count29 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access29)
        
         r_csle_count29 <= 2'b00;
      
      else if (~(mac_done29) & smc_done29)
        
         r_csle_count29 <= r_csle_store29;
      
      else if (r_csle_count29 == 2'b00)
        
         r_csle_count29 <= r_csle_count29;
      
      else if (le_enable29)               
        
         r_csle_count29 <= r_csle_count29 - 2'd1;
      
      else
        
          r_csle_count29 <= r_csle_count29;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE29 Store29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)

begin   

   if (~(n_sys_reset29))

      r_cste_store29 <= 2'b00;

   else if (valid_access29)

      r_cste_store29 <= 2'b0;

   else

      r_cste_store29 <= r_cste_store29;

end
   
   
   
//----------------------------------------------------------------------
//concatenation29 of signals29 to avoid using nested29 ifs29
//----------------------------------------------------------------------

 assign mac_smc_done29 = (~(mac_done29) & smc_done29);
 assign cste_count29   = (|r_cste_count29);           //checks29 for count = 0
 assign case_cste29   = {1'b0,valid_access29,mac_smc_done29,cste_count29,
                       cste_enable29};
   
//----------------------------------------------------------------------
//CSTE29 COUNTER29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)

begin   

   if (~(n_sys_reset29))

      r_cste_count29 <= 2'b00;

   else 
   begin
      casex(case_cste29)
           
        5'b1xxxx:        r_cste_count29 <= r_cste_count29;

        5'b01xxx:        r_cste_count29 <= 2'b0;

        5'b001xx:        r_cste_count29 <= r_cste_store29;

        5'b0000x:        r_cste_count29 <= r_cste_count29;

        5'b00011:        r_cste_count29 <= r_cste_count29 - 2'd1;

        default :        r_cste_count29 <= r_cste_count29;

      endcase // casex(w_cste_case29)
      
   end
   
end

//----------------------------------------------------------------------
// WELE29 Store29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)

begin   

   if (~(n_sys_reset29))

      r_wele_store29 <= 2'b00;


   else if (valid_access29)

      r_wele_store29 <= 2'b00;

   else

      r_wele_store29 <= r_wele_store29;

end
   
   
   
//----------------------------------------------------------------------
//concatenation29 of signals29 to avoid using nested29 ifs29
//----------------------------------------------------------------------
   
   assign wele_count29   = (|r_wele_count29);         //checks29 for count = 0
   assign case_wele29   = {1'b0,valid_access29,mac_smc_done29,wele_count29,
                         le_enable29};
   
//----------------------------------------------------------------------
// WELE29 Counter29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)

begin   
   if (~(n_sys_reset29))

      r_wele_count29 <= 2'b00;

   else
   begin

      casex(case_wele29)

        5'b1xxxx :  r_wele_count29 <= r_wele_count29;

        5'b01xxx :  r_wele_count29 <= 2'b00;

        5'b001xx :  r_wele_count29 <= r_wele_store29;

        5'b0000x :  r_wele_count29 <= r_wele_count29;

        5'b00011 :  r_wele_count29 <= r_wele_count29 - (2'd1);

        default  :  r_wele_count29 <= r_wele_count29;

      endcase // casex(case_wele29)

   end

end
   
//----------------------------------------------------------------------
// WS29 Store29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)
  
begin   

   if (~(n_sys_reset29))

      r_ws_store29 <= 8'd0;


   else if (valid_access29)

      r_ws_store29 <= 8'h01;

   else

      r_ws_store29 <= r_ws_store29;

end
   
   
   
//----------------------------------------------------------------------
//concatenation29 of signals29 to avoid using nested29 ifs29
//----------------------------------------------------------------------
   
   assign ws_count29   = (|r_ws_count29); //checks29 for count = 0
   assign case_ws29   = {1'b0,valid_access29,mac_smc_done29,ws_count29,
                       ws_enable29};
   
//----------------------------------------------------------------------
// WS29 Counter29
//----------------------------------------------------------------------

always @(posedge sys_clk29 or negedge n_sys_reset29)

begin   

   if (~(n_sys_reset29))

      r_ws_count29 <= 8'd0;

   else  
   begin
   
      casex(case_ws29)
 
         5'b1xxxx :  
            r_ws_count29 <= r_ws_count29;
        
         5'b01xxx :
            r_ws_count29 <= 8'h01;
        
         5'b001xx :  
            r_ws_count29 <= r_ws_store29;
        
         5'b0000x :  
            r_ws_count29 <= r_ws_count29;
        
         5'b00011 :  
            r_ws_count29 <= r_ws_count29 - 8'd1;
        
         default  :  
            r_ws_count29 <= r_ws_count29;

      endcase // casex(case_ws29)
      
   end
   
end  
   
   
endmodule
