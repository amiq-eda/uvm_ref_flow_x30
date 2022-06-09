//File9 name   : smc_counter_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : Counter9 block.
//            : Static9 Memory Controller9.
//            : The counter block provides9 generates9 all cycle timings9
//            : The leading9 edge counts9 are individual9 2bit, loadable9,
//            : counters9. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing9
//            : edge counts9 are registered for comparison9 with the
//            : wait state counter. The bus float9 (CSTE9) is a
//            : separate9 2bit counter. The initial count values are
//            : stored9 and reloaded9 into the counters9 if multiple
//            : accesses are required9.
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


module smc_counter_lite9  (
                     //inputs9

                     sys_clk9,
                     n_sys_reset9,
                     valid_access9,
                     mac_done9, 
                     smc_done9, 
                     cste_enable9, 
                     ws_enable9,
                     le_enable9, 

                     //outputs9

                     r_csle_count9,
                     r_wele_count9,
                     r_ws_count9,
                     r_ws_store9,
                     r_oete_store9,
                     r_wete_store9,
                     r_wele_store9,
                     r_cste_count9,
                     r_csle_store9);
   

//----------------------------------------------------------------------
// the Wait9 State9 Counter9
//----------------------------------------------------------------------
   
   
   // I9/O9
   
   input     sys_clk9;                  // AHB9 System9 clock9
   input     n_sys_reset9;              // AHB9 System9 reset (Active9 LOW9)
   
   input     valid_access9;             // load9 values are valid if high9
   input     mac_done9;                 // All cycles9 in a multiple access

   //  completed
   
   input                 smc_done9;   // one access completed
   input                 cste_enable9;// Enable9 CS9 Trailing9 Edge9 counter
   input                 ws_enable9;  // Enable9 Wait9 State9 counter
   input                 le_enable9;  // Enable9 all Leading9 Edge9 counters9
   
   // Counter9 outputs9
   
   output [1:0]             r_csle_count9;  //chip9 select9 leading9
                                             //  edge count
   output [1:0]             r_wele_count9;  //write strobe9 leading9 
                                             // edge count
   output [7:0] r_ws_count9;    //wait state count
   output [1:0]             r_cste_count9;  //chip9 select9 trailing9 
                                             // edge count
   
   // Stored9 counts9 for MAC9
   
   output [1:0]             r_oete_store9;  //read strobe9
   output [1:0]             r_wete_store9;  //write strobe9 trailing9 
                                              // edge store9
   output [7:0] r_ws_store9;    //wait state store9
   output [1:0]             r_wele_store9;  //write strobe9 leading9
                                             //  edge store9
   output [1:0]             r_csle_store9;  //chip9 select9  leading9
                                             //  edge store9
   
   
   // Counters9
   
   reg [1:0]             r_csle_count9;  // Chip9 select9 LE9 counter
   reg [1:0]             r_wele_count9;  // Write counter
   reg [7:0] r_ws_count9;    // Wait9 state select9 counter
   reg [1:0]             r_cste_count9;  // Chip9 select9 TE9 counter
   
   
   // These9 strobes9 finish early9 so no counter is required9. 
   // The stored9 value is compared with WS9 counter to determine9 
   // when the strobe9 should end.

   reg [1:0]    r_wete_store9;    // Write strobe9 TE9 end time before CS9
   reg [1:0]    r_oete_store9;    // Read strobe9 TE9 end time before CS9
   
   
   // The following9 four9 regisrers9 are used to store9 the configuration
   // during mulitple9 accesses. The counters9 are reloaded9 from these9
   // registers before each cycle.
   
   reg [1:0]             r_csle_store9;    // Chip9 select9 LE9 store9
   reg [1:0]             r_wele_store9;    // Write strobe9 LE9 store9
   reg [7:0] r_ws_store9;      // Wait9 state store9
   reg [1:0]             r_cste_store9;    // Chip9 Select9 TE9 delay
                                          //  (Bus9 float9 time)

   // wires9 used for meeting9 coding9 standards9
   
   wire         ws_count9;      //ORed9 r_ws_count9
   wire         wele_count9;    //ORed9 r_wele_count9
   wire         cste_count9;    //ORed9 r_cste_count9
   wire         mac_smc_done9;  //ANDed9 smc_done9 and not(mac_done9)
   wire [4:0]   case_cste9;     //concatenated9 signals9 for case statement9
   wire [4:0]   case_wele9;     //concatenated9 signals9 for case statement9
   wire [4:0]   case_ws9;       //concatenated9 signals9 for case statement9
   
   
   
   // Main9 Code9
   
//----------------------------------------------------------------------
// Counters9 (& Count9 Store9 for MAC9)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE9 Store9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)

begin   

   if (~(n_sys_reset9))
     
      r_wete_store9 <= 2'b00;
   
   
   else if (valid_access9)
     
      r_wete_store9 <= 2'b0;
   
   else
     
      r_wete_store9 <= r_wete_store9;

end
   
//----------------------------------------------------------------------
// OETE9 Store9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)

begin   

   if (~(n_sys_reset9))
     
      r_oete_store9 <= 2'b00;
   
   
   else if (valid_access9)
     
      r_oete_store9 <= 2'b0;
   
   else

      r_oete_store9 <= r_oete_store9;

end
   
//----------------------------------------------------------------------
// CSLE9 Store9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)

begin   

   if (~(n_sys_reset9))
     
      r_csle_store9 <= 2'b00;
   
   
   else if (valid_access9)
     
      r_csle_store9 <= 2'b00;
   
   else
     
      r_csle_store9 <= r_csle_store9;

end
   
//----------------------------------------------------------------------
// CSLE9 Counter9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)

begin   

   if (~(n_sys_reset9))
     
      r_csle_count9 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access9)
        
         r_csle_count9 <= 2'b00;
      
      else if (~(mac_done9) & smc_done9)
        
         r_csle_count9 <= r_csle_store9;
      
      else if (r_csle_count9 == 2'b00)
        
         r_csle_count9 <= r_csle_count9;
      
      else if (le_enable9)               
        
         r_csle_count9 <= r_csle_count9 - 2'd1;
      
      else
        
          r_csle_count9 <= r_csle_count9;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE9 Store9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)

begin   

   if (~(n_sys_reset9))

      r_cste_store9 <= 2'b00;

   else if (valid_access9)

      r_cste_store9 <= 2'b0;

   else

      r_cste_store9 <= r_cste_store9;

end
   
   
   
//----------------------------------------------------------------------
//concatenation9 of signals9 to avoid using nested9 ifs9
//----------------------------------------------------------------------

 assign mac_smc_done9 = (~(mac_done9) & smc_done9);
 assign cste_count9   = (|r_cste_count9);           //checks9 for count = 0
 assign case_cste9   = {1'b0,valid_access9,mac_smc_done9,cste_count9,
                       cste_enable9};
   
//----------------------------------------------------------------------
//CSTE9 COUNTER9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)

begin   

   if (~(n_sys_reset9))

      r_cste_count9 <= 2'b00;

   else 
   begin
      casex(case_cste9)
           
        5'b1xxxx:        r_cste_count9 <= r_cste_count9;

        5'b01xxx:        r_cste_count9 <= 2'b0;

        5'b001xx:        r_cste_count9 <= r_cste_store9;

        5'b0000x:        r_cste_count9 <= r_cste_count9;

        5'b00011:        r_cste_count9 <= r_cste_count9 - 2'd1;

        default :        r_cste_count9 <= r_cste_count9;

      endcase // casex(w_cste_case9)
      
   end
   
end

//----------------------------------------------------------------------
// WELE9 Store9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)

begin   

   if (~(n_sys_reset9))

      r_wele_store9 <= 2'b00;


   else if (valid_access9)

      r_wele_store9 <= 2'b00;

   else

      r_wele_store9 <= r_wele_store9;

end
   
   
   
//----------------------------------------------------------------------
//concatenation9 of signals9 to avoid using nested9 ifs9
//----------------------------------------------------------------------
   
   assign wele_count9   = (|r_wele_count9);         //checks9 for count = 0
   assign case_wele9   = {1'b0,valid_access9,mac_smc_done9,wele_count9,
                         le_enable9};
   
//----------------------------------------------------------------------
// WELE9 Counter9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)

begin   
   if (~(n_sys_reset9))

      r_wele_count9 <= 2'b00;

   else
   begin

      casex(case_wele9)

        5'b1xxxx :  r_wele_count9 <= r_wele_count9;

        5'b01xxx :  r_wele_count9 <= 2'b00;

        5'b001xx :  r_wele_count9 <= r_wele_store9;

        5'b0000x :  r_wele_count9 <= r_wele_count9;

        5'b00011 :  r_wele_count9 <= r_wele_count9 - (2'd1);

        default  :  r_wele_count9 <= r_wele_count9;

      endcase // casex(case_wele9)

   end

end
   
//----------------------------------------------------------------------
// WS9 Store9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)
  
begin   

   if (~(n_sys_reset9))

      r_ws_store9 <= 8'd0;


   else if (valid_access9)

      r_ws_store9 <= 8'h01;

   else

      r_ws_store9 <= r_ws_store9;

end
   
   
   
//----------------------------------------------------------------------
//concatenation9 of signals9 to avoid using nested9 ifs9
//----------------------------------------------------------------------
   
   assign ws_count9   = (|r_ws_count9); //checks9 for count = 0
   assign case_ws9   = {1'b0,valid_access9,mac_smc_done9,ws_count9,
                       ws_enable9};
   
//----------------------------------------------------------------------
// WS9 Counter9
//----------------------------------------------------------------------

always @(posedge sys_clk9 or negedge n_sys_reset9)

begin   

   if (~(n_sys_reset9))

      r_ws_count9 <= 8'd0;

   else  
   begin
   
      casex(case_ws9)
 
         5'b1xxxx :  
            r_ws_count9 <= r_ws_count9;
        
         5'b01xxx :
            r_ws_count9 <= 8'h01;
        
         5'b001xx :  
            r_ws_count9 <= r_ws_store9;
        
         5'b0000x :  
            r_ws_count9 <= r_ws_count9;
        
         5'b00011 :  
            r_ws_count9 <= r_ws_count9 - 8'd1;
        
         default  :  
            r_ws_count9 <= r_ws_count9;

      endcase // casex(case_ws9)
      
   end
   
end  
   
   
endmodule
