//File6 name   : smc_state_lite6.v
//Title6       : 
//Created6     : 1999
//
//Description6 : SMC6 State6 Machine6
//            : Static6 Memory Controller6
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

`include "smc_defs_lite6.v"

//state machine6 for smc6
  module smc_state_lite6  (
                     //inputs6
  
                     sys_clk6,
                     n_sys_reset6,
                     new_access6,
                     r_cste_count6,
                     r_csle_count6,
                     r_ws_count6,
                     mac_done6,
                     n_read6,
                     n_r_read6,
                     r_csle_store6,
                     r_oete_store6,
                     cs,
                     r_cs6,
             
                     //outputs6
  
                     r_smc_currentstate6,
                     smc_nextstate6,
                     cste_enable6,
                     ws_enable6,
                     smc_done6,
                     valid_access6,
                     le_enable6,
                     latch_data6,
                     smc_idle6);
   
   
   
//Parameters6  -  Values6 in smc_defs6.v



// I6/O6

  input            sys_clk6;           // AHB6 System6 clock6
  input            n_sys_reset6;       // AHB6 System6 reset (Active6 LOW6)
  input            new_access6;        // New6 AHB6 valid access to smc6 
                                          // detected
  input [1:0]      r_cste_count6;      // Chip6 select6 TE6 counter
  input [1:0]      r_csle_count6;      // chip6 select6 leading6 edge count
  input [7:0]      r_ws_count6; // wait state count
  input            mac_done6;          // All cycles6 in a multiple access
  input            n_read6;            // Active6 low6 read signal6
  input            n_r_read6;          // Store6 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store6;      // Chip6 select6 LE6 store6
  input [1:0]      r_oete_store6;      // Read strobe6 TE6 end time before CS6
  input       cs;        // chip6 selects6
  input       r_cs6;      // registered chip6 selects6

  output [4:0]      r_smc_currentstate6;// Synchronised6 SMC6 state machine6
  output [4:0]      smc_nextstate6;     // State6 Machine6 
  output            cste_enable6;       // Enable6 CS6 Trailing6 Edge6 counter
  output            ws_enable6;         // Wait6 state counter enable
  output            smc_done6;          // one access completed
  output            valid_access6;      // load6 values are valid if high6
  output            le_enable6;         // Enable6 all Leading6 Edge6 
                                           // counters6
  output            latch_data6;        // latch_data6 is used by the 
                                           // MAC6 block
                                     //  to store6 read data if CSTE6 > 0
  output            smc_idle6;          // idle6 state



// Output6 register declarations6

  reg [4:0]    smc_nextstate6;     // SMC6 state machine6 (async6 encoding6)
  reg [4:0]    r_smc_currentstate6;// Synchronised6 SMC6 state machine6
  reg          ws_enable6;         // Wait6 state counter enable
  reg          cste_enable6;       // Chip6 select6 counter enable
  reg          smc_done6;         // Asserted6 during last cycle of access
  reg          valid_access6;      // load6 values are valid if high6
  reg          le_enable6;         // Enable6 all Leading6 Edge6 counters6
  reg          latch_data6;        // latch_data6 is used by the MAC6 block
  reg          smc_idle6;          // idle6 state
  


//----------------------------------------------------------------------
// Main6 code6
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC6 state machine6
//----------------------------------------------------------------------
// Generates6 the required6 timings6 for the External6 Memory Interface6.
// If6 back-to-back accesses are required6 the state machine6 will bypass6
// the idle6 state, thus6 maintaining6 the chip6 select6 ouput6.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate6 internal idle6 signal6 used by AHB6 IF
//----------------------------------------------------------------------

  always @(smc_nextstate6)
  
  begin
   
     if (smc_nextstate6 == `SMC_IDLE6)
     
        smc_idle6 = 1'b1;
   
     else
       
        smc_idle6 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate6 internal done signal6
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate6 or r_cste_count6 or r_ws_count6)
  
  begin
   
     if ( ( (r_smc_currentstate6 == `SMC_RW6) &
            (r_ws_count6 == 8'd0) &
            (r_cste_count6 == 2'd0)
          ) |
          ( (r_smc_currentstate6 == `SMC_FLOAT6)  &
            (r_cste_count6 == 2'd0)
          )
        )
       
        smc_done6 = 1'b1;
   
   else
     
      smc_done6 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data6 is used by the MAC6 block to store6 read data if CSTE6 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate6 or r_ws_count6 or r_oete_store6)
  
  begin
   
     if ( (r_smc_currentstate6 == `SMC_RW6) &
          (r_ws_count6[1:0] >= r_oete_store6) &
          (r_ws_count6[7:2] == 6'd0)
        )
     
       latch_data6 = 1'b1;
   
     else
       
       latch_data6 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter6 enable signals6
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate6 or r_csle_count6 or
       smc_nextstate6 or valid_access6)
  begin
     if(valid_access6)
     begin
        if ((smc_nextstate6 == `SMC_RW6)         &
            (r_smc_currentstate6 != `SMC_STORE6) &
            (r_smc_currentstate6 != `SMC_LE6))
  
          ws_enable6 = 1'b1;
  
        else
  
          ws_enable6 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate6 == `SMC_RW6) & 
            (r_csle_count6 == 2'd0) & 
            (r_smc_currentstate6 != `SMC_STORE6) &
            (r_smc_currentstate6 != `SMC_LE6))

           ws_enable6 = 1'b1;
   
        else
  
           ws_enable6 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable6
//----------------------------------------------------------------------

  always @(r_smc_currentstate6 or smc_nextstate6)
  
  begin
  
     if (((smc_nextstate6 == `SMC_LE6) | (smc_nextstate6 == `SMC_RW6) ) &
         (r_smc_currentstate6 != `SMC_STORE6) )
  
        le_enable6 = 1'b1;
  
     else
  
        le_enable6 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable6
//----------------------------------------------------------------------
  
  always @(smc_nextstate6)
  
  begin
     if (smc_nextstate6 == `SMC_FLOAT6)
    
        cste_enable6 = 1'b1;
   
     else
  
        cste_enable6 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH6 if new cycle is waiting6 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate6 or new_access6 or r_ws_count6 or
                                     smc_nextstate6 or mac_done6)
  
  begin
     
     if (new_access6 & mac_done6 &
         (((r_smc_currentstate6 == `SMC_RW6) & 
           (smc_nextstate6 == `SMC_RW6) & 
           (r_ws_count6 == 8'd0))                                |
          ((r_smc_currentstate6 == `SMC_FLOAT6) & 
           (smc_nextstate6 == `SMC_IDLE6) ) |
          ((r_smc_currentstate6 == `SMC_FLOAT6) & 
           (smc_nextstate6 == `SMC_LE6)   ) |
          ((r_smc_currentstate6 == `SMC_FLOAT6) & 
           (smc_nextstate6 == `SMC_RW6)   ) |
          ((r_smc_currentstate6 == `SMC_FLOAT6) & 
           (smc_nextstate6 == `SMC_STORE6)) |
          ((r_smc_currentstate6 == `SMC_RW6)    & 
           (smc_nextstate6 == `SMC_STORE6)) |
          ((r_smc_currentstate6 == `SMC_RW6)    & 
           (smc_nextstate6 == `SMC_IDLE6) ) |
          ((r_smc_currentstate6 == `SMC_RW6)    & 
           (smc_nextstate6 == `SMC_LE6)   ) |
          ((r_smc_currentstate6 == `SMC_IDLE6) ) )  )    
       
       valid_access6 = 1'b1;
     
     else
       
       valid_access6 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC6 State6 Machine6
//----------------------------------------------------------------------

 always @(r_smc_currentstate6 or new_access6 or 
          cs or r_csle_count6 or r_cste_count6 or r_ws_count6 or mac_done6 
          or r_cs6 or n_read6 or n_r_read6 or r_csle_store6)
  begin
   
   case (r_smc_currentstate6)
  
     `SMC_IDLE6 :
  
        if (new_access6 )
 
           smc_nextstate6 = `SMC_STORE6;
  
        else
  
        begin
  
  
           begin

              if (new_access6 )
  
                 smc_nextstate6 = `SMC_RW6;

              else
  
                 smc_nextstate6 = `SMC_IDLE6;

           end
          
        end

     `SMC_STORE6   :

        if ((r_csle_count6 != 2'd0))

           smc_nextstate6 = `SMC_LE6;

        else

        begin
           
           if ( (r_csle_count6 == 2'd0))

              smc_nextstate6 = `SMC_RW6;
           
           else
             
              smc_nextstate6 = `SMC_STORE6;

        end      

     `SMC_LE6   :
  
        if (r_csle_count6 < 2'd2)
  
           smc_nextstate6 = `SMC_RW6;
  
        else
  
           smc_nextstate6 = `SMC_LE6;
  
     `SMC_RW6   :
  
     begin
          
        if ((r_ws_count6 == 8'd0) & 
            (r_cste_count6 != 2'd0))
  
           smc_nextstate6 = `SMC_FLOAT6;
          
        else if ((r_ws_count6 == 8'd0) &
                 (r_cste_count6 == 2'h0) &
                 mac_done6 & ~new_access6)

           smc_nextstate6 = `SMC_IDLE6;
          
        else if ((~mac_done6 & (r_csle_store6 != 2'd0)) &
                 (r_ws_count6 == 8'd0))
 
           smc_nextstate6 = `SMC_LE6;

        
        else
          
        begin
  
           if  ( ((n_read6 != n_r_read6) | ((cs != r_cs6) & ~n_r_read6)) & 
                  new_access6 & mac_done6 &
                 (r_ws_count6 == 8'd0))   
             
              smc_nextstate6 = `SMC_STORE6;
           
           else
             
              smc_nextstate6 = `SMC_RW6;
           
        end
        
     end
  
     `SMC_FLOAT6   :
        if (~ mac_done6                               & 
            (( & new_access6) | 
             ((r_csle_store6 == 2'd0)            &
              ~new_access6)) &  (r_cste_count6 == 2'd0) )
  
           smc_nextstate6 = `SMC_RW6;
  
        else if (new_access6                              & 
                 (( new_access6) |
                  ((r_csle_store6 == 2'd0)            & 
                   ~new_access6)) & (r_cste_count6 == 2'd0) )

        begin
  
           if  (((n_read6 != n_r_read6) | ((cs != r_cs6) & ~n_r_read6)))   
  
              smc_nextstate6 = `SMC_STORE6;
  
           else
  
              smc_nextstate6 = `SMC_RW6;
  
        end
     
        else
          
        begin
  
           if ((~mac_done6 & (r_csle_store6 != 2'd0)) & 
               (r_cste_count6 < 2'd1))
  
              smc_nextstate6 = `SMC_LE6;

           
           else
             
           begin
           
              if (r_cste_count6 == 2'd0)
             
                 smc_nextstate6 = `SMC_IDLE6;
           
              else
  
                 smc_nextstate6 = `SMC_FLOAT6;
  
           end
           
        end
     
     default   :
       
       smc_nextstate6 = `SMC_IDLE6;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential6 process of state machine6
//----------------------------------------------------------------------

  always @(posedge sys_clk6 or negedge n_sys_reset6)
  
  begin
  
     if (~n_sys_reset6)
  
        r_smc_currentstate6 <= `SMC_IDLE6;
  
  
     else   
       
        r_smc_currentstate6 <= smc_nextstate6;
  
  
  end

   

   
endmodule


