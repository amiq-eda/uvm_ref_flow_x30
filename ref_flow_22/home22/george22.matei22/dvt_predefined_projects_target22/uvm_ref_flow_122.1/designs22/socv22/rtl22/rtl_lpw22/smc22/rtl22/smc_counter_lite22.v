//File22 name   : smc_counter_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : Counter22 block.
//            : Static22 Memory Controller22.
//            : The counter block provides22 generates22 all cycle timings22
//            : The leading22 edge counts22 are individual22 2bit, loadable22,
//            : counters22. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing22
//            : edge counts22 are registered for comparison22 with the
//            : wait state counter. The bus float22 (CSTE22) is a
//            : separate22 2bit counter. The initial count values are
//            : stored22 and reloaded22 into the counters22 if multiple
//            : accesses are required22.
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


module smc_counter_lite22  (
                     //inputs22

                     sys_clk22,
                     n_sys_reset22,
                     valid_access22,
                     mac_done22, 
                     smc_done22, 
                     cste_enable22, 
                     ws_enable22,
                     le_enable22, 

                     //outputs22

                     r_csle_count22,
                     r_wele_count22,
                     r_ws_count22,
                     r_ws_store22,
                     r_oete_store22,
                     r_wete_store22,
                     r_wele_store22,
                     r_cste_count22,
                     r_csle_store22);
   

//----------------------------------------------------------------------
// the Wait22 State22 Counter22
//----------------------------------------------------------------------
   
   
   // I22/O22
   
   input     sys_clk22;                  // AHB22 System22 clock22
   input     n_sys_reset22;              // AHB22 System22 reset (Active22 LOW22)
   
   input     valid_access22;             // load22 values are valid if high22
   input     mac_done22;                 // All cycles22 in a multiple access

   //  completed
   
   input                 smc_done22;   // one access completed
   input                 cste_enable22;// Enable22 CS22 Trailing22 Edge22 counter
   input                 ws_enable22;  // Enable22 Wait22 State22 counter
   input                 le_enable22;  // Enable22 all Leading22 Edge22 counters22
   
   // Counter22 outputs22
   
   output [1:0]             r_csle_count22;  //chip22 select22 leading22
                                             //  edge count
   output [1:0]             r_wele_count22;  //write strobe22 leading22 
                                             // edge count
   output [7:0] r_ws_count22;    //wait state count
   output [1:0]             r_cste_count22;  //chip22 select22 trailing22 
                                             // edge count
   
   // Stored22 counts22 for MAC22
   
   output [1:0]             r_oete_store22;  //read strobe22
   output [1:0]             r_wete_store22;  //write strobe22 trailing22 
                                              // edge store22
   output [7:0] r_ws_store22;    //wait state store22
   output [1:0]             r_wele_store22;  //write strobe22 leading22
                                             //  edge store22
   output [1:0]             r_csle_store22;  //chip22 select22  leading22
                                             //  edge store22
   
   
   // Counters22
   
   reg [1:0]             r_csle_count22;  // Chip22 select22 LE22 counter
   reg [1:0]             r_wele_count22;  // Write counter
   reg [7:0] r_ws_count22;    // Wait22 state select22 counter
   reg [1:0]             r_cste_count22;  // Chip22 select22 TE22 counter
   
   
   // These22 strobes22 finish early22 so no counter is required22. 
   // The stored22 value is compared with WS22 counter to determine22 
   // when the strobe22 should end.

   reg [1:0]    r_wete_store22;    // Write strobe22 TE22 end time before CS22
   reg [1:0]    r_oete_store22;    // Read strobe22 TE22 end time before CS22
   
   
   // The following22 four22 regisrers22 are used to store22 the configuration
   // during mulitple22 accesses. The counters22 are reloaded22 from these22
   // registers before each cycle.
   
   reg [1:0]             r_csle_store22;    // Chip22 select22 LE22 store22
   reg [1:0]             r_wele_store22;    // Write strobe22 LE22 store22
   reg [7:0] r_ws_store22;      // Wait22 state store22
   reg [1:0]             r_cste_store22;    // Chip22 Select22 TE22 delay
                                          //  (Bus22 float22 time)

   // wires22 used for meeting22 coding22 standards22
   
   wire         ws_count22;      //ORed22 r_ws_count22
   wire         wele_count22;    //ORed22 r_wele_count22
   wire         cste_count22;    //ORed22 r_cste_count22
   wire         mac_smc_done22;  //ANDed22 smc_done22 and not(mac_done22)
   wire [4:0]   case_cste22;     //concatenated22 signals22 for case statement22
   wire [4:0]   case_wele22;     //concatenated22 signals22 for case statement22
   wire [4:0]   case_ws22;       //concatenated22 signals22 for case statement22
   
   
   
   // Main22 Code22
   
//----------------------------------------------------------------------
// Counters22 (& Count22 Store22 for MAC22)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE22 Store22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)

begin   

   if (~(n_sys_reset22))
     
      r_wete_store22 <= 2'b00;
   
   
   else if (valid_access22)
     
      r_wete_store22 <= 2'b0;
   
   else
     
      r_wete_store22 <= r_wete_store22;

end
   
//----------------------------------------------------------------------
// OETE22 Store22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)

begin   

   if (~(n_sys_reset22))
     
      r_oete_store22 <= 2'b00;
   
   
   else if (valid_access22)
     
      r_oete_store22 <= 2'b0;
   
   else

      r_oete_store22 <= r_oete_store22;

end
   
//----------------------------------------------------------------------
// CSLE22 Store22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)

begin   

   if (~(n_sys_reset22))
     
      r_csle_store22 <= 2'b00;
   
   
   else if (valid_access22)
     
      r_csle_store22 <= 2'b00;
   
   else
     
      r_csle_store22 <= r_csle_store22;

end
   
//----------------------------------------------------------------------
// CSLE22 Counter22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)

begin   

   if (~(n_sys_reset22))
     
      r_csle_count22 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access22)
        
         r_csle_count22 <= 2'b00;
      
      else if (~(mac_done22) & smc_done22)
        
         r_csle_count22 <= r_csle_store22;
      
      else if (r_csle_count22 == 2'b00)
        
         r_csle_count22 <= r_csle_count22;
      
      else if (le_enable22)               
        
         r_csle_count22 <= r_csle_count22 - 2'd1;
      
      else
        
          r_csle_count22 <= r_csle_count22;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE22 Store22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)

begin   

   if (~(n_sys_reset22))

      r_cste_store22 <= 2'b00;

   else if (valid_access22)

      r_cste_store22 <= 2'b0;

   else

      r_cste_store22 <= r_cste_store22;

end
   
   
   
//----------------------------------------------------------------------
//concatenation22 of signals22 to avoid using nested22 ifs22
//----------------------------------------------------------------------

 assign mac_smc_done22 = (~(mac_done22) & smc_done22);
 assign cste_count22   = (|r_cste_count22);           //checks22 for count = 0
 assign case_cste22   = {1'b0,valid_access22,mac_smc_done22,cste_count22,
                       cste_enable22};
   
//----------------------------------------------------------------------
//CSTE22 COUNTER22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)

begin   

   if (~(n_sys_reset22))

      r_cste_count22 <= 2'b00;

   else 
   begin
      casex(case_cste22)
           
        5'b1xxxx:        r_cste_count22 <= r_cste_count22;

        5'b01xxx:        r_cste_count22 <= 2'b0;

        5'b001xx:        r_cste_count22 <= r_cste_store22;

        5'b0000x:        r_cste_count22 <= r_cste_count22;

        5'b00011:        r_cste_count22 <= r_cste_count22 - 2'd1;

        default :        r_cste_count22 <= r_cste_count22;

      endcase // casex(w_cste_case22)
      
   end
   
end

//----------------------------------------------------------------------
// WELE22 Store22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)

begin   

   if (~(n_sys_reset22))

      r_wele_store22 <= 2'b00;


   else if (valid_access22)

      r_wele_store22 <= 2'b00;

   else

      r_wele_store22 <= r_wele_store22;

end
   
   
   
//----------------------------------------------------------------------
//concatenation22 of signals22 to avoid using nested22 ifs22
//----------------------------------------------------------------------
   
   assign wele_count22   = (|r_wele_count22);         //checks22 for count = 0
   assign case_wele22   = {1'b0,valid_access22,mac_smc_done22,wele_count22,
                         le_enable22};
   
//----------------------------------------------------------------------
// WELE22 Counter22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)

begin   
   if (~(n_sys_reset22))

      r_wele_count22 <= 2'b00;

   else
   begin

      casex(case_wele22)

        5'b1xxxx :  r_wele_count22 <= r_wele_count22;

        5'b01xxx :  r_wele_count22 <= 2'b00;

        5'b001xx :  r_wele_count22 <= r_wele_store22;

        5'b0000x :  r_wele_count22 <= r_wele_count22;

        5'b00011 :  r_wele_count22 <= r_wele_count22 - (2'd1);

        default  :  r_wele_count22 <= r_wele_count22;

      endcase // casex(case_wele22)

   end

end
   
//----------------------------------------------------------------------
// WS22 Store22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)
  
begin   

   if (~(n_sys_reset22))

      r_ws_store22 <= 8'd0;


   else if (valid_access22)

      r_ws_store22 <= 8'h01;

   else

      r_ws_store22 <= r_ws_store22;

end
   
   
   
//----------------------------------------------------------------------
//concatenation22 of signals22 to avoid using nested22 ifs22
//----------------------------------------------------------------------
   
   assign ws_count22   = (|r_ws_count22); //checks22 for count = 0
   assign case_ws22   = {1'b0,valid_access22,mac_smc_done22,ws_count22,
                       ws_enable22};
   
//----------------------------------------------------------------------
// WS22 Counter22
//----------------------------------------------------------------------

always @(posedge sys_clk22 or negedge n_sys_reset22)

begin   

   if (~(n_sys_reset22))

      r_ws_count22 <= 8'd0;

   else  
   begin
   
      casex(case_ws22)
 
         5'b1xxxx :  
            r_ws_count22 <= r_ws_count22;
        
         5'b01xxx :
            r_ws_count22 <= 8'h01;
        
         5'b001xx :  
            r_ws_count22 <= r_ws_store22;
        
         5'b0000x :  
            r_ws_count22 <= r_ws_count22;
        
         5'b00011 :  
            r_ws_count22 <= r_ws_count22 - 8'd1;
        
         default  :  
            r_ws_count22 <= r_ws_count22;

      endcase // casex(case_ws22)
      
   end
   
end  
   
   
endmodule
