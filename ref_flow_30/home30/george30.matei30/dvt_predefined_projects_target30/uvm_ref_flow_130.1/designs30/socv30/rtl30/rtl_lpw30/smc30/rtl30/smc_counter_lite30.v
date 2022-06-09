//File30 name   : smc_counter_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : Counter30 block.
//            : Static30 Memory Controller30.
//            : The counter block provides30 generates30 all cycle timings30
//            : The leading30 edge counts30 are individual30 2bit, loadable30,
//            : counters30. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing30
//            : edge counts30 are registered for comparison30 with the
//            : wait state counter. The bus float30 (CSTE30) is a
//            : separate30 2bit counter. The initial count values are
//            : stored30 and reloaded30 into the counters30 if multiple
//            : accesses are required30.
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


module smc_counter_lite30  (
                     //inputs30

                     sys_clk30,
                     n_sys_reset30,
                     valid_access30,
                     mac_done30, 
                     smc_done30, 
                     cste_enable30, 
                     ws_enable30,
                     le_enable30, 

                     //outputs30

                     r_csle_count30,
                     r_wele_count30,
                     r_ws_count30,
                     r_ws_store30,
                     r_oete_store30,
                     r_wete_store30,
                     r_wele_store30,
                     r_cste_count30,
                     r_csle_store30);
   

//----------------------------------------------------------------------
// the Wait30 State30 Counter30
//----------------------------------------------------------------------
   
   
   // I30/O30
   
   input     sys_clk30;                  // AHB30 System30 clock30
   input     n_sys_reset30;              // AHB30 System30 reset (Active30 LOW30)
   
   input     valid_access30;             // load30 values are valid if high30
   input     mac_done30;                 // All cycles30 in a multiple access

   //  completed
   
   input                 smc_done30;   // one access completed
   input                 cste_enable30;// Enable30 CS30 Trailing30 Edge30 counter
   input                 ws_enable30;  // Enable30 Wait30 State30 counter
   input                 le_enable30;  // Enable30 all Leading30 Edge30 counters30
   
   // Counter30 outputs30
   
   output [1:0]             r_csle_count30;  //chip30 select30 leading30
                                             //  edge count
   output [1:0]             r_wele_count30;  //write strobe30 leading30 
                                             // edge count
   output [7:0] r_ws_count30;    //wait state count
   output [1:0]             r_cste_count30;  //chip30 select30 trailing30 
                                             // edge count
   
   // Stored30 counts30 for MAC30
   
   output [1:0]             r_oete_store30;  //read strobe30
   output [1:0]             r_wete_store30;  //write strobe30 trailing30 
                                              // edge store30
   output [7:0] r_ws_store30;    //wait state store30
   output [1:0]             r_wele_store30;  //write strobe30 leading30
                                             //  edge store30
   output [1:0]             r_csle_store30;  //chip30 select30  leading30
                                             //  edge store30
   
   
   // Counters30
   
   reg [1:0]             r_csle_count30;  // Chip30 select30 LE30 counter
   reg [1:0]             r_wele_count30;  // Write counter
   reg [7:0] r_ws_count30;    // Wait30 state select30 counter
   reg [1:0]             r_cste_count30;  // Chip30 select30 TE30 counter
   
   
   // These30 strobes30 finish early30 so no counter is required30. 
   // The stored30 value is compared with WS30 counter to determine30 
   // when the strobe30 should end.

   reg [1:0]    r_wete_store30;    // Write strobe30 TE30 end time before CS30
   reg [1:0]    r_oete_store30;    // Read strobe30 TE30 end time before CS30
   
   
   // The following30 four30 regisrers30 are used to store30 the configuration
   // during mulitple30 accesses. The counters30 are reloaded30 from these30
   // registers before each cycle.
   
   reg [1:0]             r_csle_store30;    // Chip30 select30 LE30 store30
   reg [1:0]             r_wele_store30;    // Write strobe30 LE30 store30
   reg [7:0] r_ws_store30;      // Wait30 state store30
   reg [1:0]             r_cste_store30;    // Chip30 Select30 TE30 delay
                                          //  (Bus30 float30 time)

   // wires30 used for meeting30 coding30 standards30
   
   wire         ws_count30;      //ORed30 r_ws_count30
   wire         wele_count30;    //ORed30 r_wele_count30
   wire         cste_count30;    //ORed30 r_cste_count30
   wire         mac_smc_done30;  //ANDed30 smc_done30 and not(mac_done30)
   wire [4:0]   case_cste30;     //concatenated30 signals30 for case statement30
   wire [4:0]   case_wele30;     //concatenated30 signals30 for case statement30
   wire [4:0]   case_ws30;       //concatenated30 signals30 for case statement30
   
   
   
   // Main30 Code30
   
//----------------------------------------------------------------------
// Counters30 (& Count30 Store30 for MAC30)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE30 Store30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)

begin   

   if (~(n_sys_reset30))
     
      r_wete_store30 <= 2'b00;
   
   
   else if (valid_access30)
     
      r_wete_store30 <= 2'b0;
   
   else
     
      r_wete_store30 <= r_wete_store30;

end
   
//----------------------------------------------------------------------
// OETE30 Store30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)

begin   

   if (~(n_sys_reset30))
     
      r_oete_store30 <= 2'b00;
   
   
   else if (valid_access30)
     
      r_oete_store30 <= 2'b0;
   
   else

      r_oete_store30 <= r_oete_store30;

end
   
//----------------------------------------------------------------------
// CSLE30 Store30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)

begin   

   if (~(n_sys_reset30))
     
      r_csle_store30 <= 2'b00;
   
   
   else if (valid_access30)
     
      r_csle_store30 <= 2'b00;
   
   else
     
      r_csle_store30 <= r_csle_store30;

end
   
//----------------------------------------------------------------------
// CSLE30 Counter30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)

begin   

   if (~(n_sys_reset30))
     
      r_csle_count30 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access30)
        
         r_csle_count30 <= 2'b00;
      
      else if (~(mac_done30) & smc_done30)
        
         r_csle_count30 <= r_csle_store30;
      
      else if (r_csle_count30 == 2'b00)
        
         r_csle_count30 <= r_csle_count30;
      
      else if (le_enable30)               
        
         r_csle_count30 <= r_csle_count30 - 2'd1;
      
      else
        
          r_csle_count30 <= r_csle_count30;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE30 Store30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)

begin   

   if (~(n_sys_reset30))

      r_cste_store30 <= 2'b00;

   else if (valid_access30)

      r_cste_store30 <= 2'b0;

   else

      r_cste_store30 <= r_cste_store30;

end
   
   
   
//----------------------------------------------------------------------
//concatenation30 of signals30 to avoid using nested30 ifs30
//----------------------------------------------------------------------

 assign mac_smc_done30 = (~(mac_done30) & smc_done30);
 assign cste_count30   = (|r_cste_count30);           //checks30 for count = 0
 assign case_cste30   = {1'b0,valid_access30,mac_smc_done30,cste_count30,
                       cste_enable30};
   
//----------------------------------------------------------------------
//CSTE30 COUNTER30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)

begin   

   if (~(n_sys_reset30))

      r_cste_count30 <= 2'b00;

   else 
   begin
      casex(case_cste30)
           
        5'b1xxxx:        r_cste_count30 <= r_cste_count30;

        5'b01xxx:        r_cste_count30 <= 2'b0;

        5'b001xx:        r_cste_count30 <= r_cste_store30;

        5'b0000x:        r_cste_count30 <= r_cste_count30;

        5'b00011:        r_cste_count30 <= r_cste_count30 - 2'd1;

        default :        r_cste_count30 <= r_cste_count30;

      endcase // casex(w_cste_case30)
      
   end
   
end

//----------------------------------------------------------------------
// WELE30 Store30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)

begin   

   if (~(n_sys_reset30))

      r_wele_store30 <= 2'b00;


   else if (valid_access30)

      r_wele_store30 <= 2'b00;

   else

      r_wele_store30 <= r_wele_store30;

end
   
   
   
//----------------------------------------------------------------------
//concatenation30 of signals30 to avoid using nested30 ifs30
//----------------------------------------------------------------------
   
   assign wele_count30   = (|r_wele_count30);         //checks30 for count = 0
   assign case_wele30   = {1'b0,valid_access30,mac_smc_done30,wele_count30,
                         le_enable30};
   
//----------------------------------------------------------------------
// WELE30 Counter30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)

begin   
   if (~(n_sys_reset30))

      r_wele_count30 <= 2'b00;

   else
   begin

      casex(case_wele30)

        5'b1xxxx :  r_wele_count30 <= r_wele_count30;

        5'b01xxx :  r_wele_count30 <= 2'b00;

        5'b001xx :  r_wele_count30 <= r_wele_store30;

        5'b0000x :  r_wele_count30 <= r_wele_count30;

        5'b00011 :  r_wele_count30 <= r_wele_count30 - (2'd1);

        default  :  r_wele_count30 <= r_wele_count30;

      endcase // casex(case_wele30)

   end

end
   
//----------------------------------------------------------------------
// WS30 Store30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)
  
begin   

   if (~(n_sys_reset30))

      r_ws_store30 <= 8'd0;


   else if (valid_access30)

      r_ws_store30 <= 8'h01;

   else

      r_ws_store30 <= r_ws_store30;

end
   
   
   
//----------------------------------------------------------------------
//concatenation30 of signals30 to avoid using nested30 ifs30
//----------------------------------------------------------------------
   
   assign ws_count30   = (|r_ws_count30); //checks30 for count = 0
   assign case_ws30   = {1'b0,valid_access30,mac_smc_done30,ws_count30,
                       ws_enable30};
   
//----------------------------------------------------------------------
// WS30 Counter30
//----------------------------------------------------------------------

always @(posedge sys_clk30 or negedge n_sys_reset30)

begin   

   if (~(n_sys_reset30))

      r_ws_count30 <= 8'd0;

   else  
   begin
   
      casex(case_ws30)
 
         5'b1xxxx :  
            r_ws_count30 <= r_ws_count30;
        
         5'b01xxx :
            r_ws_count30 <= 8'h01;
        
         5'b001xx :  
            r_ws_count30 <= r_ws_store30;
        
         5'b0000x :  
            r_ws_count30 <= r_ws_count30;
        
         5'b00011 :  
            r_ws_count30 <= r_ws_count30 - 8'd1;
        
         default  :  
            r_ws_count30 <= r_ws_count30;

      endcase // casex(case_ws30)
      
   end
   
end  
   
   
endmodule
