//File9 name   : smc_state_lite9.v
//Title9       : 
//Created9     : 1999
//
//Description9 : SMC9 State9 Machine9
//            : Static9 Memory Controller9
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

`include "smc_defs_lite9.v"

//state machine9 for smc9
  module smc_state_lite9  (
                     //inputs9
  
                     sys_clk9,
                     n_sys_reset9,
                     new_access9,
                     r_cste_count9,
                     r_csle_count9,
                     r_ws_count9,
                     mac_done9,
                     n_read9,
                     n_r_read9,
                     r_csle_store9,
                     r_oete_store9,
                     cs,
                     r_cs9,
             
                     //outputs9
  
                     r_smc_currentstate9,
                     smc_nextstate9,
                     cste_enable9,
                     ws_enable9,
                     smc_done9,
                     valid_access9,
                     le_enable9,
                     latch_data9,
                     smc_idle9);
   
   
   
//Parameters9  -  Values9 in smc_defs9.v



// I9/O9

  input            sys_clk9;           // AHB9 System9 clock9
  input            n_sys_reset9;       // AHB9 System9 reset (Active9 LOW9)
  input            new_access9;        // New9 AHB9 valid access to smc9 
                                          // detected
  input [1:0]      r_cste_count9;      // Chip9 select9 TE9 counter
  input [1:0]      r_csle_count9;      // chip9 select9 leading9 edge count
  input [7:0]      r_ws_count9; // wait state count
  input            mac_done9;          // All cycles9 in a multiple access
  input            n_read9;            // Active9 low9 read signal9
  input            n_r_read9;          // Store9 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store9;      // Chip9 select9 LE9 store9
  input [1:0]      r_oete_store9;      // Read strobe9 TE9 end time before CS9
  input       cs;        // chip9 selects9
  input       r_cs9;      // registered chip9 selects9

  output [4:0]      r_smc_currentstate9;// Synchronised9 SMC9 state machine9
  output [4:0]      smc_nextstate9;     // State9 Machine9 
  output            cste_enable9;       // Enable9 CS9 Trailing9 Edge9 counter
  output            ws_enable9;         // Wait9 state counter enable
  output            smc_done9;          // one access completed
  output            valid_access9;      // load9 values are valid if high9
  output            le_enable9;         // Enable9 all Leading9 Edge9 
                                           // counters9
  output            latch_data9;        // latch_data9 is used by the 
                                           // MAC9 block
                                     //  to store9 read data if CSTE9 > 0
  output            smc_idle9;          // idle9 state



// Output9 register declarations9

  reg [4:0]    smc_nextstate9;     // SMC9 state machine9 (async9 encoding9)
  reg [4:0]    r_smc_currentstate9;// Synchronised9 SMC9 state machine9
  reg          ws_enable9;         // Wait9 state counter enable
  reg          cste_enable9;       // Chip9 select9 counter enable
  reg          smc_done9;         // Asserted9 during last cycle of access
  reg          valid_access9;      // load9 values are valid if high9
  reg          le_enable9;         // Enable9 all Leading9 Edge9 counters9
  reg          latch_data9;        // latch_data9 is used by the MAC9 block
  reg          smc_idle9;          // idle9 state
  


//----------------------------------------------------------------------
// Main9 code9
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC9 state machine9
//----------------------------------------------------------------------
// Generates9 the required9 timings9 for the External9 Memory Interface9.
// If9 back-to-back accesses are required9 the state machine9 will bypass9
// the idle9 state, thus9 maintaining9 the chip9 select9 ouput9.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate9 internal idle9 signal9 used by AHB9 IF
//----------------------------------------------------------------------

  always @(smc_nextstate9)
  
  begin
   
     if (smc_nextstate9 == `SMC_IDLE9)
     
        smc_idle9 = 1'b1;
   
     else
       
        smc_idle9 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate9 internal done signal9
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate9 or r_cste_count9 or r_ws_count9)
  
  begin
   
     if ( ( (r_smc_currentstate9 == `SMC_RW9) &
            (r_ws_count9 == 8'd0) &
            (r_cste_count9 == 2'd0)
          ) |
          ( (r_smc_currentstate9 == `SMC_FLOAT9)  &
            (r_cste_count9 == 2'd0)
          )
        )
       
        smc_done9 = 1'b1;
   
   else
     
      smc_done9 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data9 is used by the MAC9 block to store9 read data if CSTE9 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate9 or r_ws_count9 or r_oete_store9)
  
  begin
   
     if ( (r_smc_currentstate9 == `SMC_RW9) &
          (r_ws_count9[1:0] >= r_oete_store9) &
          (r_ws_count9[7:2] == 6'd0)
        )
     
       latch_data9 = 1'b1;
   
     else
       
       latch_data9 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter9 enable signals9
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate9 or r_csle_count9 or
       smc_nextstate9 or valid_access9)
  begin
     if(valid_access9)
     begin
        if ((smc_nextstate9 == `SMC_RW9)         &
            (r_smc_currentstate9 != `SMC_STORE9) &
            (r_smc_currentstate9 != `SMC_LE9))
  
          ws_enable9 = 1'b1;
  
        else
  
          ws_enable9 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate9 == `SMC_RW9) & 
            (r_csle_count9 == 2'd0) & 
            (r_smc_currentstate9 != `SMC_STORE9) &
            (r_smc_currentstate9 != `SMC_LE9))

           ws_enable9 = 1'b1;
   
        else
  
           ws_enable9 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable9
//----------------------------------------------------------------------

  always @(r_smc_currentstate9 or smc_nextstate9)
  
  begin
  
     if (((smc_nextstate9 == `SMC_LE9) | (smc_nextstate9 == `SMC_RW9) ) &
         (r_smc_currentstate9 != `SMC_STORE9) )
  
        le_enable9 = 1'b1;
  
     else
  
        le_enable9 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable9
//----------------------------------------------------------------------
  
  always @(smc_nextstate9)
  
  begin
     if (smc_nextstate9 == `SMC_FLOAT9)
    
        cste_enable9 = 1'b1;
   
     else
  
        cste_enable9 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH9 if new cycle is waiting9 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate9 or new_access9 or r_ws_count9 or
                                     smc_nextstate9 or mac_done9)
  
  begin
     
     if (new_access9 & mac_done9 &
         (((r_smc_currentstate9 == `SMC_RW9) & 
           (smc_nextstate9 == `SMC_RW9) & 
           (r_ws_count9 == 8'd0))                                |
          ((r_smc_currentstate9 == `SMC_FLOAT9) & 
           (smc_nextstate9 == `SMC_IDLE9) ) |
          ((r_smc_currentstate9 == `SMC_FLOAT9) & 
           (smc_nextstate9 == `SMC_LE9)   ) |
          ((r_smc_currentstate9 == `SMC_FLOAT9) & 
           (smc_nextstate9 == `SMC_RW9)   ) |
          ((r_smc_currentstate9 == `SMC_FLOAT9) & 
           (smc_nextstate9 == `SMC_STORE9)) |
          ((r_smc_currentstate9 == `SMC_RW9)    & 
           (smc_nextstate9 == `SMC_STORE9)) |
          ((r_smc_currentstate9 == `SMC_RW9)    & 
           (smc_nextstate9 == `SMC_IDLE9) ) |
          ((r_smc_currentstate9 == `SMC_RW9)    & 
           (smc_nextstate9 == `SMC_LE9)   ) |
          ((r_smc_currentstate9 == `SMC_IDLE9) ) )  )    
       
       valid_access9 = 1'b1;
     
     else
       
       valid_access9 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC9 State9 Machine9
//----------------------------------------------------------------------

 always @(r_smc_currentstate9 or new_access9 or 
          cs or r_csle_count9 or r_cste_count9 or r_ws_count9 or mac_done9 
          or r_cs9 or n_read9 or n_r_read9 or r_csle_store9)
  begin
   
   case (r_smc_currentstate9)
  
     `SMC_IDLE9 :
  
        if (new_access9 )
 
           smc_nextstate9 = `SMC_STORE9;
  
        else
  
        begin
  
  
           begin

              if (new_access9 )
  
                 smc_nextstate9 = `SMC_RW9;

              else
  
                 smc_nextstate9 = `SMC_IDLE9;

           end
          
        end

     `SMC_STORE9   :

        if ((r_csle_count9 != 2'd0))

           smc_nextstate9 = `SMC_LE9;

        else

        begin
           
           if ( (r_csle_count9 == 2'd0))

              smc_nextstate9 = `SMC_RW9;
           
           else
             
              smc_nextstate9 = `SMC_STORE9;

        end      

     `SMC_LE9   :
  
        if (r_csle_count9 < 2'd2)
  
           smc_nextstate9 = `SMC_RW9;
  
        else
  
           smc_nextstate9 = `SMC_LE9;
  
     `SMC_RW9   :
  
     begin
          
        if ((r_ws_count9 == 8'd0) & 
            (r_cste_count9 != 2'd0))
  
           smc_nextstate9 = `SMC_FLOAT9;
          
        else if ((r_ws_count9 == 8'd0) &
                 (r_cste_count9 == 2'h0) &
                 mac_done9 & ~new_access9)

           smc_nextstate9 = `SMC_IDLE9;
          
        else if ((~mac_done9 & (r_csle_store9 != 2'd0)) &
                 (r_ws_count9 == 8'd0))
 
           smc_nextstate9 = `SMC_LE9;

        
        else
          
        begin
  
           if  ( ((n_read9 != n_r_read9) | ((cs != r_cs9) & ~n_r_read9)) & 
                  new_access9 & mac_done9 &
                 (r_ws_count9 == 8'd0))   
             
              smc_nextstate9 = `SMC_STORE9;
           
           else
             
              smc_nextstate9 = `SMC_RW9;
           
        end
        
     end
  
     `SMC_FLOAT9   :
        if (~ mac_done9                               & 
            (( & new_access9) | 
             ((r_csle_store9 == 2'd0)            &
              ~new_access9)) &  (r_cste_count9 == 2'd0) )
  
           smc_nextstate9 = `SMC_RW9;
  
        else if (new_access9                              & 
                 (( new_access9) |
                  ((r_csle_store9 == 2'd0)            & 
                   ~new_access9)) & (r_cste_count9 == 2'd0) )

        begin
  
           if  (((n_read9 != n_r_read9) | ((cs != r_cs9) & ~n_r_read9)))   
  
              smc_nextstate9 = `SMC_STORE9;
  
           else
  
              smc_nextstate9 = `SMC_RW9;
  
        end
     
        else
          
        begin
  
           if ((~mac_done9 & (r_csle_store9 != 2'd0)) & 
               (r_cste_count9 < 2'd1))
  
              smc_nextstate9 = `SMC_LE9;

           
           else
             
           begin
           
              if (r_cste_count9 == 2'd0)
             
                 smc_nextstate9 = `SMC_IDLE9;
           
              else
  
                 smc_nextstate9 = `SMC_FLOAT9;
  
           end
           
        end
     
     default   :
       
       smc_nextstate9 = `SMC_IDLE9;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential9 process of state machine9
//----------------------------------------------------------------------

  always @(posedge sys_clk9 or negedge n_sys_reset9)
  
  begin
  
     if (~n_sys_reset9)
  
        r_smc_currentstate9 <= `SMC_IDLE9;
  
  
     else   
       
        r_smc_currentstate9 <= smc_nextstate9;
  
  
  end

   

   
endmodule


