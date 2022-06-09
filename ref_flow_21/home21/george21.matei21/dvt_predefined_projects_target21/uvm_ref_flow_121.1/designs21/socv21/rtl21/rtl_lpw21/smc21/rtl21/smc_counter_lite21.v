//File21 name   : smc_counter_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : Counter21 block.
//            : Static21 Memory Controller21.
//            : The counter block provides21 generates21 all cycle timings21
//            : The leading21 edge counts21 are individual21 2bit, loadable21,
//            : counters21. The wait state counter is a count down
//            : counter with a maximum size of 5 bits. The trailing21
//            : edge counts21 are registered for comparison21 with the
//            : wait state counter. The bus float21 (CSTE21) is a
//            : separate21 2bit counter. The initial count values are
//            : stored21 and reloaded21 into the counters21 if multiple
//            : accesses are required21.
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


module smc_counter_lite21  (
                     //inputs21

                     sys_clk21,
                     n_sys_reset21,
                     valid_access21,
                     mac_done21, 
                     smc_done21, 
                     cste_enable21, 
                     ws_enable21,
                     le_enable21, 

                     //outputs21

                     r_csle_count21,
                     r_wele_count21,
                     r_ws_count21,
                     r_ws_store21,
                     r_oete_store21,
                     r_wete_store21,
                     r_wele_store21,
                     r_cste_count21,
                     r_csle_store21);
   

//----------------------------------------------------------------------
// the Wait21 State21 Counter21
//----------------------------------------------------------------------
   
   
   // I21/O21
   
   input     sys_clk21;                  // AHB21 System21 clock21
   input     n_sys_reset21;              // AHB21 System21 reset (Active21 LOW21)
   
   input     valid_access21;             // load21 values are valid if high21
   input     mac_done21;                 // All cycles21 in a multiple access

   //  completed
   
   input                 smc_done21;   // one access completed
   input                 cste_enable21;// Enable21 CS21 Trailing21 Edge21 counter
   input                 ws_enable21;  // Enable21 Wait21 State21 counter
   input                 le_enable21;  // Enable21 all Leading21 Edge21 counters21
   
   // Counter21 outputs21
   
   output [1:0]             r_csle_count21;  //chip21 select21 leading21
                                             //  edge count
   output [1:0]             r_wele_count21;  //write strobe21 leading21 
                                             // edge count
   output [7:0] r_ws_count21;    //wait state count
   output [1:0]             r_cste_count21;  //chip21 select21 trailing21 
                                             // edge count
   
   // Stored21 counts21 for MAC21
   
   output [1:0]             r_oete_store21;  //read strobe21
   output [1:0]             r_wete_store21;  //write strobe21 trailing21 
                                              // edge store21
   output [7:0] r_ws_store21;    //wait state store21
   output [1:0]             r_wele_store21;  //write strobe21 leading21
                                             //  edge store21
   output [1:0]             r_csle_store21;  //chip21 select21  leading21
                                             //  edge store21
   
   
   // Counters21
   
   reg [1:0]             r_csle_count21;  // Chip21 select21 LE21 counter
   reg [1:0]             r_wele_count21;  // Write counter
   reg [7:0] r_ws_count21;    // Wait21 state select21 counter
   reg [1:0]             r_cste_count21;  // Chip21 select21 TE21 counter
   
   
   // These21 strobes21 finish early21 so no counter is required21. 
   // The stored21 value is compared with WS21 counter to determine21 
   // when the strobe21 should end.

   reg [1:0]    r_wete_store21;    // Write strobe21 TE21 end time before CS21
   reg [1:0]    r_oete_store21;    // Read strobe21 TE21 end time before CS21
   
   
   // The following21 four21 regisrers21 are used to store21 the configuration
   // during mulitple21 accesses. The counters21 are reloaded21 from these21
   // registers before each cycle.
   
   reg [1:0]             r_csle_store21;    // Chip21 select21 LE21 store21
   reg [1:0]             r_wele_store21;    // Write strobe21 LE21 store21
   reg [7:0] r_ws_store21;      // Wait21 state store21
   reg [1:0]             r_cste_store21;    // Chip21 Select21 TE21 delay
                                          //  (Bus21 float21 time)

   // wires21 used for meeting21 coding21 standards21
   
   wire         ws_count21;      //ORed21 r_ws_count21
   wire         wele_count21;    //ORed21 r_wele_count21
   wire         cste_count21;    //ORed21 r_cste_count21
   wire         mac_smc_done21;  //ANDed21 smc_done21 and not(mac_done21)
   wire [4:0]   case_cste21;     //concatenated21 signals21 for case statement21
   wire [4:0]   case_wele21;     //concatenated21 signals21 for case statement21
   wire [4:0]   case_ws21;       //concatenated21 signals21 for case statement21
   
   
   
   // Main21 Code21
   
//----------------------------------------------------------------------
// Counters21 (& Count21 Store21 for MAC21)
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// WETE21 Store21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)

begin   

   if (~(n_sys_reset21))
     
      r_wete_store21 <= 2'b00;
   
   
   else if (valid_access21)
     
      r_wete_store21 <= 2'b0;
   
   else
     
      r_wete_store21 <= r_wete_store21;

end
   
//----------------------------------------------------------------------
// OETE21 Store21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)

begin   

   if (~(n_sys_reset21))
     
      r_oete_store21 <= 2'b00;
   
   
   else if (valid_access21)
     
      r_oete_store21 <= 2'b0;
   
   else

      r_oete_store21 <= r_oete_store21;

end
   
//----------------------------------------------------------------------
// CSLE21 Store21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)

begin   

   if (~(n_sys_reset21))
     
      r_csle_store21 <= 2'b00;
   
   
   else if (valid_access21)
     
      r_csle_store21 <= 2'b00;
   
   else
     
      r_csle_store21 <= r_csle_store21;

end
   
//----------------------------------------------------------------------
// CSLE21 Counter21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)

begin   

   if (~(n_sys_reset21))
     
      r_csle_count21 <= 2'b00;
   
   
   else
   begin
        
      if (valid_access21)
        
         r_csle_count21 <= 2'b00;
      
      else if (~(mac_done21) & smc_done21)
        
         r_csle_count21 <= r_csle_store21;
      
      else if (r_csle_count21 == 2'b00)
        
         r_csle_count21 <= r_csle_count21;
      
      else if (le_enable21)               
        
         r_csle_count21 <= r_csle_count21 - 2'd1;
      
      else
        
          r_csle_count21 <= r_csle_count21;
      
     end

end
   
   
//----------------------------------------------------------------------
// CSTE21 Store21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)

begin   

   if (~(n_sys_reset21))

      r_cste_store21 <= 2'b00;

   else if (valid_access21)

      r_cste_store21 <= 2'b0;

   else

      r_cste_store21 <= r_cste_store21;

end
   
   
   
//----------------------------------------------------------------------
//concatenation21 of signals21 to avoid using nested21 ifs21
//----------------------------------------------------------------------

 assign mac_smc_done21 = (~(mac_done21) & smc_done21);
 assign cste_count21   = (|r_cste_count21);           //checks21 for count = 0
 assign case_cste21   = {1'b0,valid_access21,mac_smc_done21,cste_count21,
                       cste_enable21};
   
//----------------------------------------------------------------------
//CSTE21 COUNTER21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)

begin   

   if (~(n_sys_reset21))

      r_cste_count21 <= 2'b00;

   else 
   begin
      casex(case_cste21)
           
        5'b1xxxx:        r_cste_count21 <= r_cste_count21;

        5'b01xxx:        r_cste_count21 <= 2'b0;

        5'b001xx:        r_cste_count21 <= r_cste_store21;

        5'b0000x:        r_cste_count21 <= r_cste_count21;

        5'b00011:        r_cste_count21 <= r_cste_count21 - 2'd1;

        default :        r_cste_count21 <= r_cste_count21;

      endcase // casex(w_cste_case21)
      
   end
   
end

//----------------------------------------------------------------------
// WELE21 Store21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)

begin   

   if (~(n_sys_reset21))

      r_wele_store21 <= 2'b00;


   else if (valid_access21)

      r_wele_store21 <= 2'b00;

   else

      r_wele_store21 <= r_wele_store21;

end
   
   
   
//----------------------------------------------------------------------
//concatenation21 of signals21 to avoid using nested21 ifs21
//----------------------------------------------------------------------
   
   assign wele_count21   = (|r_wele_count21);         //checks21 for count = 0
   assign case_wele21   = {1'b0,valid_access21,mac_smc_done21,wele_count21,
                         le_enable21};
   
//----------------------------------------------------------------------
// WELE21 Counter21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)

begin   
   if (~(n_sys_reset21))

      r_wele_count21 <= 2'b00;

   else
   begin

      casex(case_wele21)

        5'b1xxxx :  r_wele_count21 <= r_wele_count21;

        5'b01xxx :  r_wele_count21 <= 2'b00;

        5'b001xx :  r_wele_count21 <= r_wele_store21;

        5'b0000x :  r_wele_count21 <= r_wele_count21;

        5'b00011 :  r_wele_count21 <= r_wele_count21 - (2'd1);

        default  :  r_wele_count21 <= r_wele_count21;

      endcase // casex(case_wele21)

   end

end
   
//----------------------------------------------------------------------
// WS21 Store21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)
  
begin   

   if (~(n_sys_reset21))

      r_ws_store21 <= 8'd0;


   else if (valid_access21)

      r_ws_store21 <= 8'h01;

   else

      r_ws_store21 <= r_ws_store21;

end
   
   
   
//----------------------------------------------------------------------
//concatenation21 of signals21 to avoid using nested21 ifs21
//----------------------------------------------------------------------
   
   assign ws_count21   = (|r_ws_count21); //checks21 for count = 0
   assign case_ws21   = {1'b0,valid_access21,mac_smc_done21,ws_count21,
                       ws_enable21};
   
//----------------------------------------------------------------------
// WS21 Counter21
//----------------------------------------------------------------------

always @(posedge sys_clk21 or negedge n_sys_reset21)

begin   

   if (~(n_sys_reset21))

      r_ws_count21 <= 8'd0;

   else  
   begin
   
      casex(case_ws21)
 
         5'b1xxxx :  
            r_ws_count21 <= r_ws_count21;
        
         5'b01xxx :
            r_ws_count21 <= 8'h01;
        
         5'b001xx :  
            r_ws_count21 <= r_ws_store21;
        
         5'b0000x :  
            r_ws_count21 <= r_ws_count21;
        
         5'b00011 :  
            r_ws_count21 <= r_ws_count21 - 8'd1;
        
         default  :  
            r_ws_count21 <= r_ws_count21;

      endcase // casex(case_ws21)
      
   end
   
end  
   
   
endmodule
