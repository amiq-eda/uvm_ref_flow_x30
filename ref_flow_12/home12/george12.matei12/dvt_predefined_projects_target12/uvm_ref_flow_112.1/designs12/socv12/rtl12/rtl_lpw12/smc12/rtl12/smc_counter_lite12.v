//File12 name   : smc_counter_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : Counter12 block.
//            : Static12 Memory Controller12.
//            : The counter block provides12 generates12 all cycle timings12
//            : The leading12 edge counts12 are individual12 2bit, loadable12,
//            : counters12. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing12
//            : edge counts12 are registered for comparison12 with the
//            : wait state counter. The bus float12 (CSTE12) is a
//            : separate12 2bit counter. The initial count values are
//            : stored12 and reloaded12 into the counters12 if multiple
//            : accesses are required12.
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


module smc_counter_lite12  (
                     //inputs12

                     sys_clk12,
                     n_sys_reset12,
                     valid_access12,
                     mac_done12, 
                     smc_done12, 
                     cste_enable12, 
                     ws_enable12,
                     le_enable12, 

                     //outputs12

                     r_csle_count12,
                     r_wele_count12,
                     r_ws_count12,
                     r_ws_store12,
                     r_oete_store12,
                     r_wete_store12,
                     r_wele_store12,
                     r_cste_count12,
                     r_csle_store12);
   

//----------------------------------------------------------------------
// the Wait12 State12 Counter12
//----------------------------------------------------------------------
   
   
   // I12/O12
   
   input     sys_clk12;                  // AHB12 System12 clock12
   input     n_sys_reset12;              // AHB12 System12 reset (Active12 LOW12)
   
   input     valid_access12;             // load12 values are valid if high12
   input     mac_done12;                 // All cycles12 in a multiple access

   //  completed
   
   input                 smc_done12;   // one access completed
   input                 cste_enable12;// Enable12 CS12 Trailing12 Edge12 counter
   input                 ws_enable12;  // Enable12 Wait12 State12 counter
   input                 le_enable12;  // Enable12 all Leading12 Edge12 counters12
   
   // Counter12 outputs12
   
   output [1:0]             r_csle_count12;  //chip12 select12 leading12
                                             //  edge count
   output [1:0]             r_wele_count12;  //write strobe12 leading12 
                                             // edge count
   output [7:0] r_ws_count12;    //wait state count
   output [1:0]             r_cste_count12;  //chip12 select12 trailing12 
                                             // edge count
   
   // Stored12 counts12 for MAC12
   
   output [1:0]             r_oete_store12;  //read strobe12
   output [1:0]             r_wete_store12;  //write strobe12 trailing12 
                                              // edge store12
   output [7:0] r_ws_store12;    //wait state store12
   output [1:0]             r_wele_store12;  //write strobe12 leading12
                                             //  edge store12
   output [1:0]             r_csle_store12;  //chip12 select12  leading12
                                             //  edge store12
   
   
   // Counters12
   
   reg [1:0]             r_csle_count12;  // Chip12 select12 LE12 counter
   reg [1:0]             r_wele_count12;  // Write counter
   reg [7:0] r_ws_count12;    // Wait12 state select12 counter
   reg [1:0]             r_cste_count12;  // Chip12 select12 TE12 counter
   
   
   // These12 strobes12 finish early12 so no counter is required12. 
   // The stored12 value is compared with WS12 counter to determine12 
   // when the strobe12 should end.

   reg [1:0]    r_wete_store12;    // Write strobe12 TE12 end time before CS12
   reg [1:0]    r_oete_store12;    // Read strobe12 TE12 end time before CS12
   
   
   // The following12 four12 regisrers12 are used to store12 the configuration
   // during mulitple12 accesses. The counters12 are reloaded12 from these12
   // registers before each cycle.
   
   reg [1:0]             r_csle_store12;    // Chip12 select12 LE12 store12
   reg [1:0]             r_wele_store12;    // Write strobe12 LE12 store12
   reg [7:0] r_ws_store12;      // Wait12 state store12
   reg [1:0]             r_cste_store12;    // Chip12 Select12 TE12 delay
                                          //  (Bus12 float12 time)

   // wires12 used for meeting12 coding12 standards12
   
   wire         ws_count12;      //ORed12 r_ws_count12
   wire         wele_count12;    //ORed12 r_wele_count12
   wire         cste_count12;    //ORed12 r_cste_count12
   wire         mac_smc_done12;  //ANDed12 smc_done12 and not(mac_done12)
   wire [4:0]   case_cste12;     //concatenated12 signals12 for case statement12
   wire [4:0]   case_wele12;     //concatenated12 signals12 for case statement12
   wire [4:0]   case_ws12;       //concatenated12 signals12 for case statement12
   
   
   
   // Main12 Code12
   
//----------------------------------------------------------------------
// Counters12 (& Count12 Store12 for MAC12)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE12 Store12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)

begin   

   if (~(n_sys_reset12))
     
      r_wete_store12 <= 2'b00;
   
   
   else if (valid_access12)
     
      r_wete_store12 <= 2'b0;
   
   else
     
      r_wete_store12 <= r_wete_store12;

end
   
//----------------------------------------------------------------------
// OETE12 Store12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)

begin   

   if (~(n_sys_reset12))
     
      r_oete_store12 <= 2'b00;
   
   
   else if (valid_access12)
     
      r_oete_store12 <= 2'b0;
   
   else

      r_oete_store12 <= r_oete_store12;

end
   
//----------------------------------------------------------------------
// CSLE12 Store12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)

begin   

   if (~(n_sys_reset12))
     
      r_csle_store12 <= 2'b00;
   
   
   else if (valid_access12)
     
      r_csle_store12 <= 2'b00;
   
   else
     
      r_csle_store12 <= r_csle_store12;

end
   
//----------------------------------------------------------------------
// CSLE12 Counter12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)

begin   

   if (~(n_sys_reset12))
     
      r_csle_count12 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access12)
        
         r_csle_count12 <= 2'b00;
      
      else if (~(mac_done12) & smc_done12)
        
         r_csle_count12 <= r_csle_store12;
      
      else if (r_csle_count12 == 2'b00)
        
         r_csle_count12 <= r_csle_count12;
      
      else if (le_enable12)               
        
         r_csle_count12 <= r_csle_count12 - 2'd1;
      
      else
        
          r_csle_count12 <= r_csle_count12;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE12 Store12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)

begin   

   if (~(n_sys_reset12))

      r_cste_store12 <= 2'b00;

   else if (valid_access12)

      r_cste_store12 <= 2'b0;

   else

      r_cste_store12 <= r_cste_store12;

end
   
   
   
//----------------------------------------------------------------------
//concatenation12 of signals12 to avoid using nested12 ifs12
//----------------------------------------------------------------------

 assign mac_smc_done12 = (~(mac_done12) & smc_done12);
 assign cste_count12   = (|r_cste_count12);           //checks12 for count = 0
 assign case_cste12   = {1'b0,valid_access12,mac_smc_done12,cste_count12,
                       cste_enable12};
   
//----------------------------------------------------------------------
//CSTE12 COUNTER12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)

begin   

   if (~(n_sys_reset12))

      r_cste_count12 <= 2'b00;

   else 
   begin
      casex(case_cste12)
           
        5'b1xxxx:        r_cste_count12 <= r_cste_count12;

        5'b01xxx:        r_cste_count12 <= 2'b0;

        5'b001xx:        r_cste_count12 <= r_cste_store12;

        5'b0000x:        r_cste_count12 <= r_cste_count12;

        5'b00011:        r_cste_count12 <= r_cste_count12 - 2'd1;

        default :        r_cste_count12 <= r_cste_count12;

      endcase // casex(w_cste_case12)
      
   end
   
end

//----------------------------------------------------------------------
// WELE12 Store12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)

begin   

   if (~(n_sys_reset12))

      r_wele_store12 <= 2'b00;


   else if (valid_access12)

      r_wele_store12 <= 2'b00;

   else

      r_wele_store12 <= r_wele_store12;

end
   
   
   
//----------------------------------------------------------------------
//concatenation12 of signals12 to avoid using nested12 ifs12
//----------------------------------------------------------------------
   
   assign wele_count12   = (|r_wele_count12);         //checks12 for count = 0
   assign case_wele12   = {1'b0,valid_access12,mac_smc_done12,wele_count12,
                         le_enable12};
   
//----------------------------------------------------------------------
// WELE12 Counter12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)

begin   
   if (~(n_sys_reset12))

      r_wele_count12 <= 2'b00;

   else
   begin

      casex(case_wele12)

        5'b1xxxx :  r_wele_count12 <= r_wele_count12;

        5'b01xxx :  r_wele_count12 <= 2'b00;

        5'b001xx :  r_wele_count12 <= r_wele_store12;

        5'b0000x :  r_wele_count12 <= r_wele_count12;

        5'b00011 :  r_wele_count12 <= r_wele_count12 - (2'd1);

        default  :  r_wele_count12 <= r_wele_count12;

      endcase // casex(case_wele12)

   end

end
   
//----------------------------------------------------------------------
// WS12 Store12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)
  
begin   

   if (~(n_sys_reset12))

      r_ws_store12 <= 8'd0;


   else if (valid_access12)

      r_ws_store12 <= 8'h01;

   else

      r_ws_store12 <= r_ws_store12;

end
   
   
   
//----------------------------------------------------------------------
//concatenation12 of signals12 to avoid using nested12 ifs12
//----------------------------------------------------------------------
   
   assign ws_count12   = (|r_ws_count12); //checks12 for count = 0
   assign case_ws12   = {1'b0,valid_access12,mac_smc_done12,ws_count12,
                       ws_enable12};
   
//----------------------------------------------------------------------
// WS12 Counter12
//----------------------------------------------------------------------

always @(posedge sys_clk12 or negedge n_sys_reset12)

begin   

   if (~(n_sys_reset12))

      r_ws_count12 <= 8'd0;

   else  
   begin
   
      casex(case_ws12)
 
         5'b1xxxx :  
            r_ws_count12 <= r_ws_count12;
        
         5'b01xxx :
            r_ws_count12 <= 8'h01;
        
         5'b001xx :  
            r_ws_count12 <= r_ws_store12;
        
         5'b0000x :  
            r_ws_count12 <= r_ws_count12;
        
         5'b00011 :  
            r_ws_count12 <= r_ws_count12 - 8'd1;
        
         default  :  
            r_ws_count12 <= r_ws_count12;

      endcase // casex(case_ws12)
      
   end
   
end  
   
   
endmodule
