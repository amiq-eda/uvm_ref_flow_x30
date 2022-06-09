//File28 name   : smc_counter_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : Counter28 block.
//            : Static28 Memory Controller28.
//            : The counter block provides28 generates28 all cycle timings28
//            : The leading28 edge counts28 are individual28 2bit, loadable28,
//            : counters28. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing28
//            : edge counts28 are registered for comparison28 with the
//            : wait state counter. The bus float28 (CSTE28) is a
//            : separate28 2bit counter. The initial count values are
//            : stored28 and reloaded28 into the counters28 if multiple
//            : accesses are required28.
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


module smc_counter_lite28  (
                     //inputs28

                     sys_clk28,
                     n_sys_reset28,
                     valid_access28,
                     mac_done28, 
                     smc_done28, 
                     cste_enable28, 
                     ws_enable28,
                     le_enable28, 

                     //outputs28

                     r_csle_count28,
                     r_wele_count28,
                     r_ws_count28,
                     r_ws_store28,
                     r_oete_store28,
                     r_wete_store28,
                     r_wele_store28,
                     r_cste_count28,
                     r_csle_store28);
   

//----------------------------------------------------------------------
// the Wait28 State28 Counter28
//----------------------------------------------------------------------
   
   
   // I28/O28
   
   input     sys_clk28;                  // AHB28 System28 clock28
   input     n_sys_reset28;              // AHB28 System28 reset (Active28 LOW28)
   
   input     valid_access28;             // load28 values are valid if high28
   input     mac_done28;                 // All cycles28 in a multiple access

   //  completed
   
   input                 smc_done28;   // one access completed
   input                 cste_enable28;// Enable28 CS28 Trailing28 Edge28 counter
   input                 ws_enable28;  // Enable28 Wait28 State28 counter
   input                 le_enable28;  // Enable28 all Leading28 Edge28 counters28
   
   // Counter28 outputs28
   
   output [1:0]             r_csle_count28;  //chip28 select28 leading28
                                             //  edge count
   output [1:0]             r_wele_count28;  //write strobe28 leading28 
                                             // edge count
   output [7:0] r_ws_count28;    //wait state count
   output [1:0]             r_cste_count28;  //chip28 select28 trailing28 
                                             // edge count
   
   // Stored28 counts28 for MAC28
   
   output [1:0]             r_oete_store28;  //read strobe28
   output [1:0]             r_wete_store28;  //write strobe28 trailing28 
                                              // edge store28
   output [7:0] r_ws_store28;    //wait state store28
   output [1:0]             r_wele_store28;  //write strobe28 leading28
                                             //  edge store28
   output [1:0]             r_csle_store28;  //chip28 select28  leading28
                                             //  edge store28
   
   
   // Counters28
   
   reg [1:0]             r_csle_count28;  // Chip28 select28 LE28 counter
   reg [1:0]             r_wele_count28;  // Write counter
   reg [7:0] r_ws_count28;    // Wait28 state select28 counter
   reg [1:0]             r_cste_count28;  // Chip28 select28 TE28 counter
   
   
   // These28 strobes28 finish early28 so no counter is required28. 
   // The stored28 value is compared with WS28 counter to determine28 
   // when the strobe28 should end.

   reg [1:0]    r_wete_store28;    // Write strobe28 TE28 end time before CS28
   reg [1:0]    r_oete_store28;    // Read strobe28 TE28 end time before CS28
   
   
   // The following28 four28 regisrers28 are used to store28 the configuration
   // during mulitple28 accesses. The counters28 are reloaded28 from these28
   // registers before each cycle.
   
   reg [1:0]             r_csle_store28;    // Chip28 select28 LE28 store28
   reg [1:0]             r_wele_store28;    // Write strobe28 LE28 store28
   reg [7:0] r_ws_store28;      // Wait28 state store28
   reg [1:0]             r_cste_store28;    // Chip28 Select28 TE28 delay
                                          //  (Bus28 float28 time)

   // wires28 used for meeting28 coding28 standards28
   
   wire         ws_count28;      //ORed28 r_ws_count28
   wire         wele_count28;    //ORed28 r_wele_count28
   wire         cste_count28;    //ORed28 r_cste_count28
   wire         mac_smc_done28;  //ANDed28 smc_done28 and not(mac_done28)
   wire [4:0]   case_cste28;     //concatenated28 signals28 for case statement28
   wire [4:0]   case_wele28;     //concatenated28 signals28 for case statement28
   wire [4:0]   case_ws28;       //concatenated28 signals28 for case statement28
   
   
   
   // Main28 Code28
   
//----------------------------------------------------------------------
// Counters28 (& Count28 Store28 for MAC28)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE28 Store28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)

begin   

   if (~(n_sys_reset28))
     
      r_wete_store28 <= 2'b00;
   
   
   else if (valid_access28)
     
      r_wete_store28 <= 2'b0;
   
   else
     
      r_wete_store28 <= r_wete_store28;

end
   
//----------------------------------------------------------------------
// OETE28 Store28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)

begin   

   if (~(n_sys_reset28))
     
      r_oete_store28 <= 2'b00;
   
   
   else if (valid_access28)
     
      r_oete_store28 <= 2'b0;
   
   else

      r_oete_store28 <= r_oete_store28;

end
   
//----------------------------------------------------------------------
// CSLE28 Store28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)

begin   

   if (~(n_sys_reset28))
     
      r_csle_store28 <= 2'b00;
   
   
   else if (valid_access28)
     
      r_csle_store28 <= 2'b00;
   
   else
     
      r_csle_store28 <= r_csle_store28;

end
   
//----------------------------------------------------------------------
// CSLE28 Counter28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)

begin   

   if (~(n_sys_reset28))
     
      r_csle_count28 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access28)
        
         r_csle_count28 <= 2'b00;
      
      else if (~(mac_done28) & smc_done28)
        
         r_csle_count28 <= r_csle_store28;
      
      else if (r_csle_count28 == 2'b00)
        
         r_csle_count28 <= r_csle_count28;
      
      else if (le_enable28)               
        
         r_csle_count28 <= r_csle_count28 - 2'd1;
      
      else
        
          r_csle_count28 <= r_csle_count28;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE28 Store28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)

begin   

   if (~(n_sys_reset28))

      r_cste_store28 <= 2'b00;

   else if (valid_access28)

      r_cste_store28 <= 2'b0;

   else

      r_cste_store28 <= r_cste_store28;

end
   
   
   
//----------------------------------------------------------------------
//concatenation28 of signals28 to avoid using nested28 ifs28
//----------------------------------------------------------------------

 assign mac_smc_done28 = (~(mac_done28) & smc_done28);
 assign cste_count28   = (|r_cste_count28);           //checks28 for count = 0
 assign case_cste28   = {1'b0,valid_access28,mac_smc_done28,cste_count28,
                       cste_enable28};
   
//----------------------------------------------------------------------
//CSTE28 COUNTER28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)

begin   

   if (~(n_sys_reset28))

      r_cste_count28 <= 2'b00;

   else 
   begin
      casex(case_cste28)
           
        5'b1xxxx:        r_cste_count28 <= r_cste_count28;

        5'b01xxx:        r_cste_count28 <= 2'b0;

        5'b001xx:        r_cste_count28 <= r_cste_store28;

        5'b0000x:        r_cste_count28 <= r_cste_count28;

        5'b00011:        r_cste_count28 <= r_cste_count28 - 2'd1;

        default :        r_cste_count28 <= r_cste_count28;

      endcase // casex(w_cste_case28)
      
   end
   
end

//----------------------------------------------------------------------
// WELE28 Store28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)

begin   

   if (~(n_sys_reset28))

      r_wele_store28 <= 2'b00;


   else if (valid_access28)

      r_wele_store28 <= 2'b00;

   else

      r_wele_store28 <= r_wele_store28;

end
   
   
   
//----------------------------------------------------------------------
//concatenation28 of signals28 to avoid using nested28 ifs28
//----------------------------------------------------------------------
   
   assign wele_count28   = (|r_wele_count28);         //checks28 for count = 0
   assign case_wele28   = {1'b0,valid_access28,mac_smc_done28,wele_count28,
                         le_enable28};
   
//----------------------------------------------------------------------
// WELE28 Counter28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)

begin   
   if (~(n_sys_reset28))

      r_wele_count28 <= 2'b00;

   else
   begin

      casex(case_wele28)

        5'b1xxxx :  r_wele_count28 <= r_wele_count28;

        5'b01xxx :  r_wele_count28 <= 2'b00;

        5'b001xx :  r_wele_count28 <= r_wele_store28;

        5'b0000x :  r_wele_count28 <= r_wele_count28;

        5'b00011 :  r_wele_count28 <= r_wele_count28 - (2'd1);

        default  :  r_wele_count28 <= r_wele_count28;

      endcase // casex(case_wele28)

   end

end
   
//----------------------------------------------------------------------
// WS28 Store28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)
  
begin   

   if (~(n_sys_reset28))

      r_ws_store28 <= 8'd0;


   else if (valid_access28)

      r_ws_store28 <= 8'h01;

   else

      r_ws_store28 <= r_ws_store28;

end
   
   
   
//----------------------------------------------------------------------
//concatenation28 of signals28 to avoid using nested28 ifs28
//----------------------------------------------------------------------
   
   assign ws_count28   = (|r_ws_count28); //checks28 for count = 0
   assign case_ws28   = {1'b0,valid_access28,mac_smc_done28,ws_count28,
                       ws_enable28};
   
//----------------------------------------------------------------------
// WS28 Counter28
//----------------------------------------------------------------------

always @(posedge sys_clk28 or negedge n_sys_reset28)

begin   

   if (~(n_sys_reset28))

      r_ws_count28 <= 8'd0;

   else  
   begin
   
      casex(case_ws28)
 
         5'b1xxxx :  
            r_ws_count28 <= r_ws_count28;
        
         5'b01xxx :
            r_ws_count28 <= 8'h01;
        
         5'b001xx :  
            r_ws_count28 <= r_ws_store28;
        
         5'b0000x :  
            r_ws_count28 <= r_ws_count28;
        
         5'b00011 :  
            r_ws_count28 <= r_ws_count28 - 8'd1;
        
         default  :  
            r_ws_count28 <= r_ws_count28;

      endcase // casex(case_ws28)
      
   end
   
end  
   
   
endmodule
