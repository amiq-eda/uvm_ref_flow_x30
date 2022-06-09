//File26 name   : smc_counter_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : Counter26 block.
//            : Static26 Memory Controller26.
//            : The counter block provides26 generates26 all cycle timings26
//            : The leading26 edge counts26 are individual26 2bit, loadable26,
//            : counters26. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing26
//            : edge counts26 are registered for comparison26 with the
//            : wait state counter. The bus float26 (CSTE26) is a
//            : separate26 2bit counter. The initial count values are
//            : stored26 and reloaded26 into the counters26 if multiple
//            : accesses are required26.
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


module smc_counter_lite26  (
                     //inputs26

                     sys_clk26,
                     n_sys_reset26,
                     valid_access26,
                     mac_done26, 
                     smc_done26, 
                     cste_enable26, 
                     ws_enable26,
                     le_enable26, 

                     //outputs26

                     r_csle_count26,
                     r_wele_count26,
                     r_ws_count26,
                     r_ws_store26,
                     r_oete_store26,
                     r_wete_store26,
                     r_wele_store26,
                     r_cste_count26,
                     r_csle_store26);
   

//----------------------------------------------------------------------
// the Wait26 State26 Counter26
//----------------------------------------------------------------------
   
   
   // I26/O26
   
   input     sys_clk26;                  // AHB26 System26 clock26
   input     n_sys_reset26;              // AHB26 System26 reset (Active26 LOW26)
   
   input     valid_access26;             // load26 values are valid if high26
   input     mac_done26;                 // All cycles26 in a multiple access

   //  completed
   
   input                 smc_done26;   // one access completed
   input                 cste_enable26;// Enable26 CS26 Trailing26 Edge26 counter
   input                 ws_enable26;  // Enable26 Wait26 State26 counter
   input                 le_enable26;  // Enable26 all Leading26 Edge26 counters26
   
   // Counter26 outputs26
   
   output [1:0]             r_csle_count26;  //chip26 select26 leading26
                                             //  edge count
   output [1:0]             r_wele_count26;  //write strobe26 leading26 
                                             // edge count
   output [7:0] r_ws_count26;    //wait state count
   output [1:0]             r_cste_count26;  //chip26 select26 trailing26 
                                             // edge count
   
   // Stored26 counts26 for MAC26
   
   output [1:0]             r_oete_store26;  //read strobe26
   output [1:0]             r_wete_store26;  //write strobe26 trailing26 
                                              // edge store26
   output [7:0] r_ws_store26;    //wait state store26
   output [1:0]             r_wele_store26;  //write strobe26 leading26
                                             //  edge store26
   output [1:0]             r_csle_store26;  //chip26 select26  leading26
                                             //  edge store26
   
   
   // Counters26
   
   reg [1:0]             r_csle_count26;  // Chip26 select26 LE26 counter
   reg [1:0]             r_wele_count26;  // Write counter
   reg [7:0] r_ws_count26;    // Wait26 state select26 counter
   reg [1:0]             r_cste_count26;  // Chip26 select26 TE26 counter
   
   
   // These26 strobes26 finish early26 so no counter is required26. 
   // The stored26 value is compared with WS26 counter to determine26 
   // when the strobe26 should end.

   reg [1:0]    r_wete_store26;    // Write strobe26 TE26 end time before CS26
   reg [1:0]    r_oete_store26;    // Read strobe26 TE26 end time before CS26
   
   
   // The following26 four26 regisrers26 are used to store26 the configuration
   // during mulitple26 accesses. The counters26 are reloaded26 from these26
   // registers before each cycle.
   
   reg [1:0]             r_csle_store26;    // Chip26 select26 LE26 store26
   reg [1:0]             r_wele_store26;    // Write strobe26 LE26 store26
   reg [7:0] r_ws_store26;      // Wait26 state store26
   reg [1:0]             r_cste_store26;    // Chip26 Select26 TE26 delay
                                          //  (Bus26 float26 time)

   // wires26 used for meeting26 coding26 standards26
   
   wire         ws_count26;      //ORed26 r_ws_count26
   wire         wele_count26;    //ORed26 r_wele_count26
   wire         cste_count26;    //ORed26 r_cste_count26
   wire         mac_smc_done26;  //ANDed26 smc_done26 and not(mac_done26)
   wire [4:0]   case_cste26;     //concatenated26 signals26 for case statement26
   wire [4:0]   case_wele26;     //concatenated26 signals26 for case statement26
   wire [4:0]   case_ws26;       //concatenated26 signals26 for case statement26
   
   
   
   // Main26 Code26
   
//----------------------------------------------------------------------
// Counters26 (& Count26 Store26 for MAC26)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE26 Store26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)

begin   

   if (~(n_sys_reset26))
     
      r_wete_store26 <= 2'b00;
   
   
   else if (valid_access26)
     
      r_wete_store26 <= 2'b0;
   
   else
     
      r_wete_store26 <= r_wete_store26;

end
   
//----------------------------------------------------------------------
// OETE26 Store26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)

begin   

   if (~(n_sys_reset26))
     
      r_oete_store26 <= 2'b00;
   
   
   else if (valid_access26)
     
      r_oete_store26 <= 2'b0;
   
   else

      r_oete_store26 <= r_oete_store26;

end
   
//----------------------------------------------------------------------
// CSLE26 Store26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)

begin   

   if (~(n_sys_reset26))
     
      r_csle_store26 <= 2'b00;
   
   
   else if (valid_access26)
     
      r_csle_store26 <= 2'b00;
   
   else
     
      r_csle_store26 <= r_csle_store26;

end
   
//----------------------------------------------------------------------
// CSLE26 Counter26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)

begin   

   if (~(n_sys_reset26))
     
      r_csle_count26 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access26)
        
         r_csle_count26 <= 2'b00;
      
      else if (~(mac_done26) & smc_done26)
        
         r_csle_count26 <= r_csle_store26;
      
      else if (r_csle_count26 == 2'b00)
        
         r_csle_count26 <= r_csle_count26;
      
      else if (le_enable26)               
        
         r_csle_count26 <= r_csle_count26 - 2'd1;
      
      else
        
          r_csle_count26 <= r_csle_count26;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE26 Store26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)

begin   

   if (~(n_sys_reset26))

      r_cste_store26 <= 2'b00;

   else if (valid_access26)

      r_cste_store26 <= 2'b0;

   else

      r_cste_store26 <= r_cste_store26;

end
   
   
   
//----------------------------------------------------------------------
//concatenation26 of signals26 to avoid using nested26 ifs26
//----------------------------------------------------------------------

 assign mac_smc_done26 = (~(mac_done26) & smc_done26);
 assign cste_count26   = (|r_cste_count26);           //checks26 for count = 0
 assign case_cste26   = {1'b0,valid_access26,mac_smc_done26,cste_count26,
                       cste_enable26};
   
//----------------------------------------------------------------------
//CSTE26 COUNTER26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)

begin   

   if (~(n_sys_reset26))

      r_cste_count26 <= 2'b00;

   else 
   begin
      casex(case_cste26)
           
        5'b1xxxx:        r_cste_count26 <= r_cste_count26;

        5'b01xxx:        r_cste_count26 <= 2'b0;

        5'b001xx:        r_cste_count26 <= r_cste_store26;

        5'b0000x:        r_cste_count26 <= r_cste_count26;

        5'b00011:        r_cste_count26 <= r_cste_count26 - 2'd1;

        default :        r_cste_count26 <= r_cste_count26;

      endcase // casex(w_cste_case26)
      
   end
   
end

//----------------------------------------------------------------------
// WELE26 Store26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)

begin   

   if (~(n_sys_reset26))

      r_wele_store26 <= 2'b00;


   else if (valid_access26)

      r_wele_store26 <= 2'b00;

   else

      r_wele_store26 <= r_wele_store26;

end
   
   
   
//----------------------------------------------------------------------
//concatenation26 of signals26 to avoid using nested26 ifs26
//----------------------------------------------------------------------
   
   assign wele_count26   = (|r_wele_count26);         //checks26 for count = 0
   assign case_wele26   = {1'b0,valid_access26,mac_smc_done26,wele_count26,
                         le_enable26};
   
//----------------------------------------------------------------------
// WELE26 Counter26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)

begin   
   if (~(n_sys_reset26))

      r_wele_count26 <= 2'b00;

   else
   begin

      casex(case_wele26)

        5'b1xxxx :  r_wele_count26 <= r_wele_count26;

        5'b01xxx :  r_wele_count26 <= 2'b00;

        5'b001xx :  r_wele_count26 <= r_wele_store26;

        5'b0000x :  r_wele_count26 <= r_wele_count26;

        5'b00011 :  r_wele_count26 <= r_wele_count26 - (2'd1);

        default  :  r_wele_count26 <= r_wele_count26;

      endcase // casex(case_wele26)

   end

end
   
//----------------------------------------------------------------------
// WS26 Store26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)
  
begin   

   if (~(n_sys_reset26))

      r_ws_store26 <= 8'd0;


   else if (valid_access26)

      r_ws_store26 <= 8'h01;

   else

      r_ws_store26 <= r_ws_store26;

end
   
   
   
//----------------------------------------------------------------------
//concatenation26 of signals26 to avoid using nested26 ifs26
//----------------------------------------------------------------------
   
   assign ws_count26   = (|r_ws_count26); //checks26 for count = 0
   assign case_ws26   = {1'b0,valid_access26,mac_smc_done26,ws_count26,
                       ws_enable26};
   
//----------------------------------------------------------------------
// WS26 Counter26
//----------------------------------------------------------------------

always @(posedge sys_clk26 or negedge n_sys_reset26)

begin   

   if (~(n_sys_reset26))

      r_ws_count26 <= 8'd0;

   else  
   begin
   
      casex(case_ws26)
 
         5'b1xxxx :  
            r_ws_count26 <= r_ws_count26;
        
         5'b01xxx :
            r_ws_count26 <= 8'h01;
        
         5'b001xx :  
            r_ws_count26 <= r_ws_store26;
        
         5'b0000x :  
            r_ws_count26 <= r_ws_count26;
        
         5'b00011 :  
            r_ws_count26 <= r_ws_count26 - 8'd1;
        
         default  :  
            r_ws_count26 <= r_ws_count26;

      endcase // casex(case_ws26)
      
   end
   
end  
   
   
endmodule
