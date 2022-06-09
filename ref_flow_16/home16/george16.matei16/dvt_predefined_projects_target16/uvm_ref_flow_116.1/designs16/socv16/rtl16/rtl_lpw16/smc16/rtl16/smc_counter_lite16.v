//File16 name   : smc_counter_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : Counter16 block.
//            : Static16 Memory Controller16.
//            : The counter block provides16 generates16 all cycle timings16
//            : The leading16 edge counts16 are individual16 2bit, loadable16,
//            : counters16. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing16
//            : edge counts16 are registered for comparison16 with the
//            : wait state counter. The bus float16 (CSTE16) is a
//            : separate16 2bit counter. The initial count values are
//            : stored16 and reloaded16 into the counters16 if multiple
//            : accesses are required16.
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


module smc_counter_lite16  (
                     //inputs16

                     sys_clk16,
                     n_sys_reset16,
                     valid_access16,
                     mac_done16, 
                     smc_done16, 
                     cste_enable16, 
                     ws_enable16,
                     le_enable16, 

                     //outputs16

                     r_csle_count16,
                     r_wele_count16,
                     r_ws_count16,
                     r_ws_store16,
                     r_oete_store16,
                     r_wete_store16,
                     r_wele_store16,
                     r_cste_count16,
                     r_csle_store16);
   

//----------------------------------------------------------------------
// the Wait16 State16 Counter16
//----------------------------------------------------------------------
   
   
   // I16/O16
   
   input     sys_clk16;                  // AHB16 System16 clock16
   input     n_sys_reset16;              // AHB16 System16 reset (Active16 LOW16)
   
   input     valid_access16;             // load16 values are valid if high16
   input     mac_done16;                 // All cycles16 in a multiple access

   //  completed
   
   input                 smc_done16;   // one access completed
   input                 cste_enable16;// Enable16 CS16 Trailing16 Edge16 counter
   input                 ws_enable16;  // Enable16 Wait16 State16 counter
   input                 le_enable16;  // Enable16 all Leading16 Edge16 counters16
   
   // Counter16 outputs16
   
   output [1:0]             r_csle_count16;  //chip16 select16 leading16
                                             //  edge count
   output [1:0]             r_wele_count16;  //write strobe16 leading16 
                                             // edge count
   output [7:0] r_ws_count16;    //wait state count
   output [1:0]             r_cste_count16;  //chip16 select16 trailing16 
                                             // edge count
   
   // Stored16 counts16 for MAC16
   
   output [1:0]             r_oete_store16;  //read strobe16
   output [1:0]             r_wete_store16;  //write strobe16 trailing16 
                                              // edge store16
   output [7:0] r_ws_store16;    //wait state store16
   output [1:0]             r_wele_store16;  //write strobe16 leading16
                                             //  edge store16
   output [1:0]             r_csle_store16;  //chip16 select16  leading16
                                             //  edge store16
   
   
   // Counters16
   
   reg [1:0]             r_csle_count16;  // Chip16 select16 LE16 counter
   reg [1:0]             r_wele_count16;  // Write counter
   reg [7:0] r_ws_count16;    // Wait16 state select16 counter
   reg [1:0]             r_cste_count16;  // Chip16 select16 TE16 counter
   
   
   // These16 strobes16 finish early16 so no counter is required16. 
   // The stored16 value is compared with WS16 counter to determine16 
   // when the strobe16 should end.

   reg [1:0]    r_wete_store16;    // Write strobe16 TE16 end time before CS16
   reg [1:0]    r_oete_store16;    // Read strobe16 TE16 end time before CS16
   
   
   // The following16 four16 regisrers16 are used to store16 the configuration
   // during mulitple16 accesses. The counters16 are reloaded16 from these16
   // registers before each cycle.
   
   reg [1:0]             r_csle_store16;    // Chip16 select16 LE16 store16
   reg [1:0]             r_wele_store16;    // Write strobe16 LE16 store16
   reg [7:0] r_ws_store16;      // Wait16 state store16
   reg [1:0]             r_cste_store16;    // Chip16 Select16 TE16 delay
                                          //  (Bus16 float16 time)

   // wires16 used for meeting16 coding16 standards16
   
   wire         ws_count16;      //ORed16 r_ws_count16
   wire         wele_count16;    //ORed16 r_wele_count16
   wire         cste_count16;    //ORed16 r_cste_count16
   wire         mac_smc_done16;  //ANDed16 smc_done16 and not(mac_done16)
   wire [4:0]   case_cste16;     //concatenated16 signals16 for case statement16
   wire [4:0]   case_wele16;     //concatenated16 signals16 for case statement16
   wire [4:0]   case_ws16;       //concatenated16 signals16 for case statement16
   
   
   
   // Main16 Code16
   
//----------------------------------------------------------------------
// Counters16 (& Count16 Store16 for MAC16)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE16 Store16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)

begin   

   if (~(n_sys_reset16))
     
      r_wete_store16 <= 2'b00;
   
   
   else if (valid_access16)
     
      r_wete_store16 <= 2'b0;
   
   else
     
      r_wete_store16 <= r_wete_store16;

end
   
//----------------------------------------------------------------------
// OETE16 Store16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)

begin   

   if (~(n_sys_reset16))
     
      r_oete_store16 <= 2'b00;
   
   
   else if (valid_access16)
     
      r_oete_store16 <= 2'b0;
   
   else

      r_oete_store16 <= r_oete_store16;

end
   
//----------------------------------------------------------------------
// CSLE16 Store16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)

begin   

   if (~(n_sys_reset16))
     
      r_csle_store16 <= 2'b00;
   
   
   else if (valid_access16)
     
      r_csle_store16 <= 2'b00;
   
   else
     
      r_csle_store16 <= r_csle_store16;

end
   
//----------------------------------------------------------------------
// CSLE16 Counter16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)

begin   

   if (~(n_sys_reset16))
     
      r_csle_count16 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access16)
        
         r_csle_count16 <= 2'b00;
      
      else if (~(mac_done16) & smc_done16)
        
         r_csle_count16 <= r_csle_store16;
      
      else if (r_csle_count16 == 2'b00)
        
         r_csle_count16 <= r_csle_count16;
      
      else if (le_enable16)               
        
         r_csle_count16 <= r_csle_count16 - 2'd1;
      
      else
        
          r_csle_count16 <= r_csle_count16;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE16 Store16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)

begin   

   if (~(n_sys_reset16))

      r_cste_store16 <= 2'b00;

   else if (valid_access16)

      r_cste_store16 <= 2'b0;

   else

      r_cste_store16 <= r_cste_store16;

end
   
   
   
//----------------------------------------------------------------------
//concatenation16 of signals16 to avoid using nested16 ifs16
//----------------------------------------------------------------------

 assign mac_smc_done16 = (~(mac_done16) & smc_done16);
 assign cste_count16   = (|r_cste_count16);           //checks16 for count = 0
 assign case_cste16   = {1'b0,valid_access16,mac_smc_done16,cste_count16,
                       cste_enable16};
   
//----------------------------------------------------------------------
//CSTE16 COUNTER16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)

begin   

   if (~(n_sys_reset16))

      r_cste_count16 <= 2'b00;

   else 
   begin
      casex(case_cste16)
           
        5'b1xxxx:        r_cste_count16 <= r_cste_count16;

        5'b01xxx:        r_cste_count16 <= 2'b0;

        5'b001xx:        r_cste_count16 <= r_cste_store16;

        5'b0000x:        r_cste_count16 <= r_cste_count16;

        5'b00011:        r_cste_count16 <= r_cste_count16 - 2'd1;

        default :        r_cste_count16 <= r_cste_count16;

      endcase // casex(w_cste_case16)
      
   end
   
end

//----------------------------------------------------------------------
// WELE16 Store16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)

begin   

   if (~(n_sys_reset16))

      r_wele_store16 <= 2'b00;


   else if (valid_access16)

      r_wele_store16 <= 2'b00;

   else

      r_wele_store16 <= r_wele_store16;

end
   
   
   
//----------------------------------------------------------------------
//concatenation16 of signals16 to avoid using nested16 ifs16
//----------------------------------------------------------------------
   
   assign wele_count16   = (|r_wele_count16);         //checks16 for count = 0
   assign case_wele16   = {1'b0,valid_access16,mac_smc_done16,wele_count16,
                         le_enable16};
   
//----------------------------------------------------------------------
// WELE16 Counter16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)

begin   
   if (~(n_sys_reset16))

      r_wele_count16 <= 2'b00;

   else
   begin

      casex(case_wele16)

        5'b1xxxx :  r_wele_count16 <= r_wele_count16;

        5'b01xxx :  r_wele_count16 <= 2'b00;

        5'b001xx :  r_wele_count16 <= r_wele_store16;

        5'b0000x :  r_wele_count16 <= r_wele_count16;

        5'b00011 :  r_wele_count16 <= r_wele_count16 - (2'd1);

        default  :  r_wele_count16 <= r_wele_count16;

      endcase // casex(case_wele16)

   end

end
   
//----------------------------------------------------------------------
// WS16 Store16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)
  
begin   

   if (~(n_sys_reset16))

      r_ws_store16 <= 8'd0;


   else if (valid_access16)

      r_ws_store16 <= 8'h01;

   else

      r_ws_store16 <= r_ws_store16;

end
   
   
   
//----------------------------------------------------------------------
//concatenation16 of signals16 to avoid using nested16 ifs16
//----------------------------------------------------------------------
   
   assign ws_count16   = (|r_ws_count16); //checks16 for count = 0
   assign case_ws16   = {1'b0,valid_access16,mac_smc_done16,ws_count16,
                       ws_enable16};
   
//----------------------------------------------------------------------
// WS16 Counter16
//----------------------------------------------------------------------

always @(posedge sys_clk16 or negedge n_sys_reset16)

begin   

   if (~(n_sys_reset16))

      r_ws_count16 <= 8'd0;

   else  
   begin
   
      casex(case_ws16)
 
         5'b1xxxx :  
            r_ws_count16 <= r_ws_count16;
        
         5'b01xxx :
            r_ws_count16 <= 8'h01;
        
         5'b001xx :  
            r_ws_count16 <= r_ws_store16;
        
         5'b0000x :  
            r_ws_count16 <= r_ws_count16;
        
         5'b00011 :  
            r_ws_count16 <= r_ws_count16 - 8'd1;
        
         default  :  
            r_ws_count16 <= r_ws_count16;

      endcase // casex(case_ws16)
      
   end
   
end  
   
   
endmodule
