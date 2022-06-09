//File25 name   : smc_counter_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : Counter25 block.
//            : Static25 Memory Controller25.
//            : The counter block provides25 generates25 all cycle timings25
//            : The leading25 edge counts25 are individual25 2bit, loadable25,
//            : counters25. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing25
//            : edge counts25 are registered for comparison25 with the
//            : wait state counter. The bus float25 (CSTE25) is a
//            : separate25 2bit counter. The initial count values are
//            : stored25 and reloaded25 into the counters25 if multiple
//            : accesses are required25.
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


module smc_counter_lite25  (
                     //inputs25

                     sys_clk25,
                     n_sys_reset25,
                     valid_access25,
                     mac_done25, 
                     smc_done25, 
                     cste_enable25, 
                     ws_enable25,
                     le_enable25, 

                     //outputs25

                     r_csle_count25,
                     r_wele_count25,
                     r_ws_count25,
                     r_ws_store25,
                     r_oete_store25,
                     r_wete_store25,
                     r_wele_store25,
                     r_cste_count25,
                     r_csle_store25);
   

//----------------------------------------------------------------------
// the Wait25 State25 Counter25
//----------------------------------------------------------------------
   
   
   // I25/O25
   
   input     sys_clk25;                  // AHB25 System25 clock25
   input     n_sys_reset25;              // AHB25 System25 reset (Active25 LOW25)
   
   input     valid_access25;             // load25 values are valid if high25
   input     mac_done25;                 // All cycles25 in a multiple access

   //  completed
   
   input                 smc_done25;   // one access completed
   input                 cste_enable25;// Enable25 CS25 Trailing25 Edge25 counter
   input                 ws_enable25;  // Enable25 Wait25 State25 counter
   input                 le_enable25;  // Enable25 all Leading25 Edge25 counters25
   
   // Counter25 outputs25
   
   output [1:0]             r_csle_count25;  //chip25 select25 leading25
                                             //  edge count
   output [1:0]             r_wele_count25;  //write strobe25 leading25 
                                             // edge count
   output [7:0] r_ws_count25;    //wait state count
   output [1:0]             r_cste_count25;  //chip25 select25 trailing25 
                                             // edge count
   
   // Stored25 counts25 for MAC25
   
   output [1:0]             r_oete_store25;  //read strobe25
   output [1:0]             r_wete_store25;  //write strobe25 trailing25 
                                              // edge store25
   output [7:0] r_ws_store25;    //wait state store25
   output [1:0]             r_wele_store25;  //write strobe25 leading25
                                             //  edge store25
   output [1:0]             r_csle_store25;  //chip25 select25  leading25
                                             //  edge store25
   
   
   // Counters25
   
   reg [1:0]             r_csle_count25;  // Chip25 select25 LE25 counter
   reg [1:0]             r_wele_count25;  // Write counter
   reg [7:0] r_ws_count25;    // Wait25 state select25 counter
   reg [1:0]             r_cste_count25;  // Chip25 select25 TE25 counter
   
   
   // These25 strobes25 finish early25 so no counter is required25. 
   // The stored25 value is compared with WS25 counter to determine25 
   // when the strobe25 should end.

   reg [1:0]    r_wete_store25;    // Write strobe25 TE25 end time before CS25
   reg [1:0]    r_oete_store25;    // Read strobe25 TE25 end time before CS25
   
   
   // The following25 four25 regisrers25 are used to store25 the configuration
   // during mulitple25 accesses. The counters25 are reloaded25 from these25
   // registers before each cycle.
   
   reg [1:0]             r_csle_store25;    // Chip25 select25 LE25 store25
   reg [1:0]             r_wele_store25;    // Write strobe25 LE25 store25
   reg [7:0] r_ws_store25;      // Wait25 state store25
   reg [1:0]             r_cste_store25;    // Chip25 Select25 TE25 delay
                                          //  (Bus25 float25 time)

   // wires25 used for meeting25 coding25 standards25
   
   wire         ws_count25;      //ORed25 r_ws_count25
   wire         wele_count25;    //ORed25 r_wele_count25
   wire         cste_count25;    //ORed25 r_cste_count25
   wire         mac_smc_done25;  //ANDed25 smc_done25 and not(mac_done25)
   wire [4:0]   case_cste25;     //concatenated25 signals25 for case statement25
   wire [4:0]   case_wele25;     //concatenated25 signals25 for case statement25
   wire [4:0]   case_ws25;       //concatenated25 signals25 for case statement25
   
   
   
   // Main25 Code25
   
//----------------------------------------------------------------------
// Counters25 (& Count25 Store25 for MAC25)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE25 Store25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)

begin   

   if (~(n_sys_reset25))
     
      r_wete_store25 <= 2'b00;
   
   
   else if (valid_access25)
     
      r_wete_store25 <= 2'b0;
   
   else
     
      r_wete_store25 <= r_wete_store25;

end
   
//----------------------------------------------------------------------
// OETE25 Store25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)

begin   

   if (~(n_sys_reset25))
     
      r_oete_store25 <= 2'b00;
   
   
   else if (valid_access25)
     
      r_oete_store25 <= 2'b0;
   
   else

      r_oete_store25 <= r_oete_store25;

end
   
//----------------------------------------------------------------------
// CSLE25 Store25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)

begin   

   if (~(n_sys_reset25))
     
      r_csle_store25 <= 2'b00;
   
   
   else if (valid_access25)
     
      r_csle_store25 <= 2'b00;
   
   else
     
      r_csle_store25 <= r_csle_store25;

end
   
//----------------------------------------------------------------------
// CSLE25 Counter25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)

begin   

   if (~(n_sys_reset25))
     
      r_csle_count25 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access25)
        
         r_csle_count25 <= 2'b00;
      
      else if (~(mac_done25) & smc_done25)
        
         r_csle_count25 <= r_csle_store25;
      
      else if (r_csle_count25 == 2'b00)
        
         r_csle_count25 <= r_csle_count25;
      
      else if (le_enable25)               
        
         r_csle_count25 <= r_csle_count25 - 2'd1;
      
      else
        
          r_csle_count25 <= r_csle_count25;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE25 Store25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)

begin   

   if (~(n_sys_reset25))

      r_cste_store25 <= 2'b00;

   else if (valid_access25)

      r_cste_store25 <= 2'b0;

   else

      r_cste_store25 <= r_cste_store25;

end
   
   
   
//----------------------------------------------------------------------
//concatenation25 of signals25 to avoid using nested25 ifs25
//----------------------------------------------------------------------

 assign mac_smc_done25 = (~(mac_done25) & smc_done25);
 assign cste_count25   = (|r_cste_count25);           //checks25 for count = 0
 assign case_cste25   = {1'b0,valid_access25,mac_smc_done25,cste_count25,
                       cste_enable25};
   
//----------------------------------------------------------------------
//CSTE25 COUNTER25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)

begin   

   if (~(n_sys_reset25))

      r_cste_count25 <= 2'b00;

   else 
   begin
      casex(case_cste25)
           
        5'b1xxxx:        r_cste_count25 <= r_cste_count25;

        5'b01xxx:        r_cste_count25 <= 2'b0;

        5'b001xx:        r_cste_count25 <= r_cste_store25;

        5'b0000x:        r_cste_count25 <= r_cste_count25;

        5'b00011:        r_cste_count25 <= r_cste_count25 - 2'd1;

        default :        r_cste_count25 <= r_cste_count25;

      endcase // casex(w_cste_case25)
      
   end
   
end

//----------------------------------------------------------------------
// WELE25 Store25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)

begin   

   if (~(n_sys_reset25))

      r_wele_store25 <= 2'b00;


   else if (valid_access25)

      r_wele_store25 <= 2'b00;

   else

      r_wele_store25 <= r_wele_store25;

end
   
   
   
//----------------------------------------------------------------------
//concatenation25 of signals25 to avoid using nested25 ifs25
//----------------------------------------------------------------------
   
   assign wele_count25   = (|r_wele_count25);         //checks25 for count = 0
   assign case_wele25   = {1'b0,valid_access25,mac_smc_done25,wele_count25,
                         le_enable25};
   
//----------------------------------------------------------------------
// WELE25 Counter25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)

begin   
   if (~(n_sys_reset25))

      r_wele_count25 <= 2'b00;

   else
   begin

      casex(case_wele25)

        5'b1xxxx :  r_wele_count25 <= r_wele_count25;

        5'b01xxx :  r_wele_count25 <= 2'b00;

        5'b001xx :  r_wele_count25 <= r_wele_store25;

        5'b0000x :  r_wele_count25 <= r_wele_count25;

        5'b00011 :  r_wele_count25 <= r_wele_count25 - (2'd1);

        default  :  r_wele_count25 <= r_wele_count25;

      endcase // casex(case_wele25)

   end

end
   
//----------------------------------------------------------------------
// WS25 Store25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)
  
begin   

   if (~(n_sys_reset25))

      r_ws_store25 <= 8'd0;


   else if (valid_access25)

      r_ws_store25 <= 8'h01;

   else

      r_ws_store25 <= r_ws_store25;

end
   
   
   
//----------------------------------------------------------------------
//concatenation25 of signals25 to avoid using nested25 ifs25
//----------------------------------------------------------------------
   
   assign ws_count25   = (|r_ws_count25); //checks25 for count = 0
   assign case_ws25   = {1'b0,valid_access25,mac_smc_done25,ws_count25,
                       ws_enable25};
   
//----------------------------------------------------------------------
// WS25 Counter25
//----------------------------------------------------------------------

always @(posedge sys_clk25 or negedge n_sys_reset25)

begin   

   if (~(n_sys_reset25))

      r_ws_count25 <= 8'd0;

   else  
   begin
   
      casex(case_ws25)
 
         5'b1xxxx :  
            r_ws_count25 <= r_ws_count25;
        
         5'b01xxx :
            r_ws_count25 <= 8'h01;
        
         5'b001xx :  
            r_ws_count25 <= r_ws_store25;
        
         5'b0000x :  
            r_ws_count25 <= r_ws_count25;
        
         5'b00011 :  
            r_ws_count25 <= r_ws_count25 - 8'd1;
        
         default  :  
            r_ws_count25 <= r_ws_count25;

      endcase // casex(case_ws25)
      
   end
   
end  
   
   
endmodule
