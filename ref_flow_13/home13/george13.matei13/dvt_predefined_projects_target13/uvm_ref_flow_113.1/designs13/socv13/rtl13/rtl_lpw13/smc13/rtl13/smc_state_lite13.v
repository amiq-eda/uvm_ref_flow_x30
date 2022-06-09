//File13 name   : smc_state_lite13.v
//Title13       : 
//Created13     : 1999
//
//Description13 : SMC13 State13 Machine13
//            : Static13 Memory Controller13
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

`include "smc_defs_lite13.v"

//state machine13 for smc13
  module smc_state_lite13  (
                     //inputs13
  
                     sys_clk13,
                     n_sys_reset13,
                     new_access13,
                     r_cste_count13,
                     r_csle_count13,
                     r_ws_count13,
                     mac_done13,
                     n_read13,
                     n_r_read13,
                     r_csle_store13,
                     r_oete_store13,
                     cs,
                     r_cs13,
             
                     //outputs13
  
                     r_smc_currentstate13,
                     smc_nextstate13,
                     cste_enable13,
                     ws_enable13,
                     smc_done13,
                     valid_access13,
                     le_enable13,
                     latch_data13,
                     smc_idle13);
   
   
   
//Parameters13  -  Values13 in smc_defs13.v



// I13/O13

  input            sys_clk13;           // AHB13 System13 clock13
  input            n_sys_reset13;       // AHB13 System13 reset (Active13 LOW13)
  input            new_access13;        // New13 AHB13 valid access to smc13 
                                          // detected
  input [1:0]      r_cste_count13;      // Chip13 select13 TE13 counter
  input [1:0]      r_csle_count13;      // chip13 select13 leading13 edge count
  input [7:0]      r_ws_count13; // wait state count
  input            mac_done13;          // All cycles13 in a multiple access
  input            n_read13;            // Active13 low13 read signal13
  input            n_r_read13;          // Store13 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store13;      // Chip13 select13 LE13 store13
  input [1:0]      r_oete_store13;      // Read strobe13 TE13 end time before CS13
  input       cs;        // chip13 selects13
  input       r_cs13;      // registered chip13 selects13

  output [4:0]      r_smc_currentstate13;// Synchronised13 SMC13 state machine13
  output [4:0]      smc_nextstate13;     // State13 Machine13 
  output            cste_enable13;       // Enable13 CS13 Trailing13 Edge13 counter
  output            ws_enable13;         // Wait13 state counter enable
  output            smc_done13;          // one access completed
  output            valid_access13;      // load13 values are valid if high13
  output            le_enable13;         // Enable13 all Leading13 Edge13 
                                           // counters13
  output            latch_data13;        // latch_data13 is used by the 
                                           // MAC13 block
                                     //  to store13 read data if CSTE13 > 0
  output            smc_idle13;          // idle13 state



// Output13 register declarations13

  reg [4:0]    smc_nextstate13;     // SMC13 state machine13 (async13 encoding13)
  reg [4:0]    r_smc_currentstate13;// Synchronised13 SMC13 state machine13
  reg          ws_enable13;         // Wait13 state counter enable
  reg          cste_enable13;       // Chip13 select13 counter enable
  reg          smc_done13;         // Asserted13 during last cycle of access
  reg          valid_access13;      // load13 values are valid if high13
  reg          le_enable13;         // Enable13 all Leading13 Edge13 counters13
  reg          latch_data13;        // latch_data13 is used by the MAC13 block
  reg          smc_idle13;          // idle13 state
  


//----------------------------------------------------------------------
// Main13 code13
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC13 state machine13
//----------------------------------------------------------------------
// Generates13 the required13 timings13 for the External13 Memory Interface13.
// If13 back-to-back accesses are required13 the state machine13 will bypass13
// the idle13 state, thus13 maintaining13 the chip13 select13 ouput13.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate13 internal idle13 signal13 used by AHB13 IF
//----------------------------------------------------------------------

  always @(smc_nextstate13)
  
  begin
   
     if (smc_nextstate13 == `SMC_IDLE13)
     
        smc_idle13 = 1'b1;
   
     else
       
        smc_idle13 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate13 internal done signal13
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate13 or r_cste_count13 or r_ws_count13)
  
  begin
   
     if ( ( (r_smc_currentstate13 == `SMC_RW13) &
            (r_ws_count13 == 8'd0) &
            (r_cste_count13 == 2'd0)
          ) |
          ( (r_smc_currentstate13 == `SMC_FLOAT13)  &
            (r_cste_count13 == 2'd0)
          )
        )
       
        smc_done13 = 1'b1;
   
   else
     
      smc_done13 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data13 is used by the MAC13 block to store13 read data if CSTE13 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate13 or r_ws_count13 or r_oete_store13)
  
  begin
   
     if ( (r_smc_currentstate13 == `SMC_RW13) &
          (r_ws_count13[1:0] >= r_oete_store13) &
          (r_ws_count13[7:2] == 6'd0)
        )
     
       latch_data13 = 1'b1;
   
     else
       
       latch_data13 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter13 enable signals13
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate13 or r_csle_count13 or
       smc_nextstate13 or valid_access13)
  begin
     if(valid_access13)
     begin
        if ((smc_nextstate13 == `SMC_RW13)         &
            (r_smc_currentstate13 != `SMC_STORE13) &
            (r_smc_currentstate13 != `SMC_LE13))
  
          ws_enable13 = 1'b1;
  
        else
  
          ws_enable13 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate13 == `SMC_RW13) & 
            (r_csle_count13 == 2'd0) & 
            (r_smc_currentstate13 != `SMC_STORE13) &
            (r_smc_currentstate13 != `SMC_LE13))

           ws_enable13 = 1'b1;
   
        else
  
           ws_enable13 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable13
//----------------------------------------------------------------------

  always @(r_smc_currentstate13 or smc_nextstate13)
  
  begin
  
     if (((smc_nextstate13 == `SMC_LE13) | (smc_nextstate13 == `SMC_RW13) ) &
         (r_smc_currentstate13 != `SMC_STORE13) )
  
        le_enable13 = 1'b1;
  
     else
  
        le_enable13 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable13
//----------------------------------------------------------------------
  
  always @(smc_nextstate13)
  
  begin
     if (smc_nextstate13 == `SMC_FLOAT13)
    
        cste_enable13 = 1'b1;
   
     else
  
        cste_enable13 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH13 if new cycle is waiting13 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate13 or new_access13 or r_ws_count13 or
                                     smc_nextstate13 or mac_done13)
  
  begin
     
     if (new_access13 & mac_done13 &
         (((r_smc_currentstate13 == `SMC_RW13) & 
           (smc_nextstate13 == `SMC_RW13) & 
           (r_ws_count13 == 8'd0))                                |
          ((r_smc_currentstate13 == `SMC_FLOAT13) & 
           (smc_nextstate13 == `SMC_IDLE13) ) |
          ((r_smc_currentstate13 == `SMC_FLOAT13) & 
           (smc_nextstate13 == `SMC_LE13)   ) |
          ((r_smc_currentstate13 == `SMC_FLOAT13) & 
           (smc_nextstate13 == `SMC_RW13)   ) |
          ((r_smc_currentstate13 == `SMC_FLOAT13) & 
           (smc_nextstate13 == `SMC_STORE13)) |
          ((r_smc_currentstate13 == `SMC_RW13)    & 
           (smc_nextstate13 == `SMC_STORE13)) |
          ((r_smc_currentstate13 == `SMC_RW13)    & 
           (smc_nextstate13 == `SMC_IDLE13) ) |
          ((r_smc_currentstate13 == `SMC_RW13)    & 
           (smc_nextstate13 == `SMC_LE13)   ) |
          ((r_smc_currentstate13 == `SMC_IDLE13) ) )  )    
       
       valid_access13 = 1'b1;
     
     else
       
       valid_access13 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC13 State13 Machine13
//----------------------------------------------------------------------

 always @(r_smc_currentstate13 or new_access13 or 
          cs or r_csle_count13 or r_cste_count13 or r_ws_count13 or mac_done13 
          or r_cs13 or n_read13 or n_r_read13 or r_csle_store13)
  begin
   
   case (r_smc_currentstate13)
  
     `SMC_IDLE13 :
  
        if (new_access13 )
 
           smc_nextstate13 = `SMC_STORE13;
  
        else
  
        begin
  
  
           begin

              if (new_access13 )
  
                 smc_nextstate13 = `SMC_RW13;

              else
  
                 smc_nextstate13 = `SMC_IDLE13;

           end
          
        end

     `SMC_STORE13   :

        if ((r_csle_count13 != 2'd0))

           smc_nextstate13 = `SMC_LE13;

        else

        begin
           
           if ( (r_csle_count13 == 2'd0))

              smc_nextstate13 = `SMC_RW13;
           
           else
             
              smc_nextstate13 = `SMC_STORE13;

        end      

     `SMC_LE13   :
  
        if (r_csle_count13 < 2'd2)
  
           smc_nextstate13 = `SMC_RW13;
  
        else
  
           smc_nextstate13 = `SMC_LE13;
  
     `SMC_RW13   :
  
     begin
          
        if ((r_ws_count13 == 8'd0) & 
            (r_cste_count13 != 2'd0))
  
           smc_nextstate13 = `SMC_FLOAT13;
          
        else if ((r_ws_count13 == 8'd0) &
                 (r_cste_count13 == 2'h0) &
                 mac_done13 & ~new_access13)

           smc_nextstate13 = `SMC_IDLE13;
          
        else if ((~mac_done13 & (r_csle_store13 != 2'd0)) &
                 (r_ws_count13 == 8'd0))
 
           smc_nextstate13 = `SMC_LE13;

        
        else
          
        begin
  
           if  ( ((n_read13 != n_r_read13) | ((cs != r_cs13) & ~n_r_read13)) & 
                  new_access13 & mac_done13 &
                 (r_ws_count13 == 8'd0))   
             
              smc_nextstate13 = `SMC_STORE13;
           
           else
             
              smc_nextstate13 = `SMC_RW13;
           
        end
        
     end
  
     `SMC_FLOAT13   :
        if (~ mac_done13                               & 
            (( & new_access13) | 
             ((r_csle_store13 == 2'd0)            &
              ~new_access13)) &  (r_cste_count13 == 2'd0) )
  
           smc_nextstate13 = `SMC_RW13;
  
        else if (new_access13                              & 
                 (( new_access13) |
                  ((r_csle_store13 == 2'd0)            & 
                   ~new_access13)) & (r_cste_count13 == 2'd0) )

        begin
  
           if  (((n_read13 != n_r_read13) | ((cs != r_cs13) & ~n_r_read13)))   
  
              smc_nextstate13 = `SMC_STORE13;
  
           else
  
              smc_nextstate13 = `SMC_RW13;
  
        end
     
        else
          
        begin
  
           if ((~mac_done13 & (r_csle_store13 != 2'd0)) & 
               (r_cste_count13 < 2'd1))
  
              smc_nextstate13 = `SMC_LE13;

           
           else
             
           begin
           
              if (r_cste_count13 == 2'd0)
             
                 smc_nextstate13 = `SMC_IDLE13;
           
              else
  
                 smc_nextstate13 = `SMC_FLOAT13;
  
           end
           
        end
     
     default   :
       
       smc_nextstate13 = `SMC_IDLE13;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential13 process of state machine13
//----------------------------------------------------------------------

  always @(posedge sys_clk13 or negedge n_sys_reset13)
  
  begin
  
     if (~n_sys_reset13)
  
        r_smc_currentstate13 <= `SMC_IDLE13;
  
  
     else   
       
        r_smc_currentstate13 <= smc_nextstate13;
  
  
  end

   

   
endmodule


