//File7 name   : smc_counter_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : Counter7 block.
//            : Static7 Memory Controller7.
//            : The counter block provides7 generates7 all cycle timings7
//            : The leading7 edge counts7 are individual7 2bit, loadable7,
//            : counters7. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing7
//            : edge counts7 are registered for comparison7 with the
//            : wait state counter. The bus float7 (CSTE7) is a
//            : separate7 2bit counter. The initial count values are
//            : stored7 and reloaded7 into the counters7 if multiple
//            : accesses are required7.
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


module smc_counter_lite7  (
                     //inputs7

                     sys_clk7,
                     n_sys_reset7,
                     valid_access7,
                     mac_done7, 
                     smc_done7, 
                     cste_enable7, 
                     ws_enable7,
                     le_enable7, 

                     //outputs7

                     r_csle_count7,
                     r_wele_count7,
                     r_ws_count7,
                     r_ws_store7,
                     r_oete_store7,
                     r_wete_store7,
                     r_wele_store7,
                     r_cste_count7,
                     r_csle_store7);
   

//----------------------------------------------------------------------
// the Wait7 State7 Counter7
//----------------------------------------------------------------------
   
   
   // I7/O7
   
   input     sys_clk7;                  // AHB7 System7 clock7
   input     n_sys_reset7;              // AHB7 System7 reset (Active7 LOW7)
   
   input     valid_access7;             // load7 values are valid if high7
   input     mac_done7;                 // All cycles7 in a multiple access

   //  completed
   
   input                 smc_done7;   // one access completed
   input                 cste_enable7;// Enable7 CS7 Trailing7 Edge7 counter
   input                 ws_enable7;  // Enable7 Wait7 State7 counter
   input                 le_enable7;  // Enable7 all Leading7 Edge7 counters7
   
   // Counter7 outputs7
   
   output [1:0]             r_csle_count7;  //chip7 select7 leading7
                                             //  edge count
   output [1:0]             r_wele_count7;  //write strobe7 leading7 
                                             // edge count
   output [7:0] r_ws_count7;    //wait state count
   output [1:0]             r_cste_count7;  //chip7 select7 trailing7 
                                             // edge count
   
   // Stored7 counts7 for MAC7
   
   output [1:0]             r_oete_store7;  //read strobe7
   output [1:0]             r_wete_store7;  //write strobe7 trailing7 
                                              // edge store7
   output [7:0] r_ws_store7;    //wait state store7
   output [1:0]             r_wele_store7;  //write strobe7 leading7
                                             //  edge store7
   output [1:0]             r_csle_store7;  //chip7 select7  leading7
                                             //  edge store7
   
   
   // Counters7
   
   reg [1:0]             r_csle_count7;  // Chip7 select7 LE7 counter
   reg [1:0]             r_wele_count7;  // Write counter
   reg [7:0] r_ws_count7;    // Wait7 state select7 counter
   reg [1:0]             r_cste_count7;  // Chip7 select7 TE7 counter
   
   
   // These7 strobes7 finish early7 so no counter is required7. 
   // The stored7 value is compared with WS7 counter to determine7 
   // when the strobe7 should end.

   reg [1:0]    r_wete_store7;    // Write strobe7 TE7 end time before CS7
   reg [1:0]    r_oete_store7;    // Read strobe7 TE7 end time before CS7
   
   
   // The following7 four7 regisrers7 are used to store7 the configuration
   // during mulitple7 accesses. The counters7 are reloaded7 from these7
   // registers before each cycle.
   
   reg [1:0]             r_csle_store7;    // Chip7 select7 LE7 store7
   reg [1:0]             r_wele_store7;    // Write strobe7 LE7 store7
   reg [7:0] r_ws_store7;      // Wait7 state store7
   reg [1:0]             r_cste_store7;    // Chip7 Select7 TE7 delay
                                          //  (Bus7 float7 time)

   // wires7 used for meeting7 coding7 standards7
   
   wire         ws_count7;      //ORed7 r_ws_count7
   wire         wele_count7;    //ORed7 r_wele_count7
   wire         cste_count7;    //ORed7 r_cste_count7
   wire         mac_smc_done7;  //ANDed7 smc_done7 and not(mac_done7)
   wire [4:0]   case_cste7;     //concatenated7 signals7 for case statement7
   wire [4:0]   case_wele7;     //concatenated7 signals7 for case statement7
   wire [4:0]   case_ws7;       //concatenated7 signals7 for case statement7
   
   
   
   // Main7 Code7
   
//----------------------------------------------------------------------
// Counters7 (& Count7 Store7 for MAC7)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE7 Store7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)

begin   

   if (~(n_sys_reset7))
     
      r_wete_store7 <= 2'b00;
   
   
   else if (valid_access7)
     
      r_wete_store7 <= 2'b0;
   
   else
     
      r_wete_store7 <= r_wete_store7;

end
   
//----------------------------------------------------------------------
// OETE7 Store7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)

begin   

   if (~(n_sys_reset7))
     
      r_oete_store7 <= 2'b00;
   
   
   else if (valid_access7)
     
      r_oete_store7 <= 2'b0;
   
   else

      r_oete_store7 <= r_oete_store7;

end
   
//----------------------------------------------------------------------
// CSLE7 Store7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)

begin   

   if (~(n_sys_reset7))
     
      r_csle_store7 <= 2'b00;
   
   
   else if (valid_access7)
     
      r_csle_store7 <= 2'b00;
   
   else
     
      r_csle_store7 <= r_csle_store7;

end
   
//----------------------------------------------------------------------
// CSLE7 Counter7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)

begin   

   if (~(n_sys_reset7))
     
      r_csle_count7 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access7)
        
         r_csle_count7 <= 2'b00;
      
      else if (~(mac_done7) & smc_done7)
        
         r_csle_count7 <= r_csle_store7;
      
      else if (r_csle_count7 == 2'b00)
        
         r_csle_count7 <= r_csle_count7;
      
      else if (le_enable7)               
        
         r_csle_count7 <= r_csle_count7 - 2'd1;
      
      else
        
          r_csle_count7 <= r_csle_count7;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE7 Store7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)

begin   

   if (~(n_sys_reset7))

      r_cste_store7 <= 2'b00;

   else if (valid_access7)

      r_cste_store7 <= 2'b0;

   else

      r_cste_store7 <= r_cste_store7;

end
   
   
   
//----------------------------------------------------------------------
//concatenation7 of signals7 to avoid using nested7 ifs7
//----------------------------------------------------------------------

 assign mac_smc_done7 = (~(mac_done7) & smc_done7);
 assign cste_count7   = (|r_cste_count7);           //checks7 for count = 0
 assign case_cste7   = {1'b0,valid_access7,mac_smc_done7,cste_count7,
                       cste_enable7};
   
//----------------------------------------------------------------------
//CSTE7 COUNTER7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)

begin   

   if (~(n_sys_reset7))

      r_cste_count7 <= 2'b00;

   else 
   begin
      casex(case_cste7)
           
        5'b1xxxx:        r_cste_count7 <= r_cste_count7;

        5'b01xxx:        r_cste_count7 <= 2'b0;

        5'b001xx:        r_cste_count7 <= r_cste_store7;

        5'b0000x:        r_cste_count7 <= r_cste_count7;

        5'b00011:        r_cste_count7 <= r_cste_count7 - 2'd1;

        default :        r_cste_count7 <= r_cste_count7;

      endcase // casex(w_cste_case7)
      
   end
   
end

//----------------------------------------------------------------------
// WELE7 Store7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)

begin   

   if (~(n_sys_reset7))

      r_wele_store7 <= 2'b00;


   else if (valid_access7)

      r_wele_store7 <= 2'b00;

   else

      r_wele_store7 <= r_wele_store7;

end
   
   
   
//----------------------------------------------------------------------
//concatenation7 of signals7 to avoid using nested7 ifs7
//----------------------------------------------------------------------
   
   assign wele_count7   = (|r_wele_count7);         //checks7 for count = 0
   assign case_wele7   = {1'b0,valid_access7,mac_smc_done7,wele_count7,
                         le_enable7};
   
//----------------------------------------------------------------------
// WELE7 Counter7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)

begin   
   if (~(n_sys_reset7))

      r_wele_count7 <= 2'b00;

   else
   begin

      casex(case_wele7)

        5'b1xxxx :  r_wele_count7 <= r_wele_count7;

        5'b01xxx :  r_wele_count7 <= 2'b00;

        5'b001xx :  r_wele_count7 <= r_wele_store7;

        5'b0000x :  r_wele_count7 <= r_wele_count7;

        5'b00011 :  r_wele_count7 <= r_wele_count7 - (2'd1);

        default  :  r_wele_count7 <= r_wele_count7;

      endcase // casex(case_wele7)

   end

end
   
//----------------------------------------------------------------------
// WS7 Store7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)
  
begin   

   if (~(n_sys_reset7))

      r_ws_store7 <= 8'd0;


   else if (valid_access7)

      r_ws_store7 <= 8'h01;

   else

      r_ws_store7 <= r_ws_store7;

end
   
   
   
//----------------------------------------------------------------------
//concatenation7 of signals7 to avoid using nested7 ifs7
//----------------------------------------------------------------------
   
   assign ws_count7   = (|r_ws_count7); //checks7 for count = 0
   assign case_ws7   = {1'b0,valid_access7,mac_smc_done7,ws_count7,
                       ws_enable7};
   
//----------------------------------------------------------------------
// WS7 Counter7
//----------------------------------------------------------------------

always @(posedge sys_clk7 or negedge n_sys_reset7)

begin   

   if (~(n_sys_reset7))

      r_ws_count7 <= 8'd0;

   else  
   begin
   
      casex(case_ws7)
 
         5'b1xxxx :  
            r_ws_count7 <= r_ws_count7;
        
         5'b01xxx :
            r_ws_count7 <= 8'h01;
        
         5'b001xx :  
            r_ws_count7 <= r_ws_store7;
        
         5'b0000x :  
            r_ws_count7 <= r_ws_count7;
        
         5'b00011 :  
            r_ws_count7 <= r_ws_count7 - 8'd1;
        
         default  :  
            r_ws_count7 <= r_ws_count7;

      endcase // casex(case_ws7)
      
   end
   
end  
   
   
endmodule
