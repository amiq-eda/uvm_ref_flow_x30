//File27 name   : smc_state_lite27.v
//Title27       : 
//Created27     : 1999
//
//Description27 : SMC27 State27 Machine27
//            : Static27 Memory Controller27
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

`include "smc_defs_lite27.v"

//state machine27 for smc27
  module smc_state_lite27  (
                     //inputs27
  
                     sys_clk27,
                     n_sys_reset27,
                     new_access27,
                     r_cste_count27,
                     r_csle_count27,
                     r_ws_count27,
                     mac_done27,
                     n_read27,
                     n_r_read27,
                     r_csle_store27,
                     r_oete_store27,
                     cs,
                     r_cs27,
             
                     //outputs27
  
                     r_smc_currentstate27,
                     smc_nextstate27,
                     cste_enable27,
                     ws_enable27,
                     smc_done27,
                     valid_access27,
                     le_enable27,
                     latch_data27,
                     smc_idle27);
   
   
   
//Parameters27  -  Values27 in smc_defs27.v



// I27/O27

  input            sys_clk27;           // AHB27 System27 clock27
  input            n_sys_reset27;       // AHB27 System27 reset (Active27 LOW27)
  input            new_access27;        // New27 AHB27 valid access to smc27 
                                          // detected
  input [1:0]      r_cste_count27;      // Chip27 select27 TE27 counter
  input [1:0]      r_csle_count27;      // chip27 select27 leading27 edge count
  input [7:0]      r_ws_count27; // wait state count
  input            mac_done27;          // All cycles27 in a multiple access
  input            n_read27;            // Active27 low27 read signal27
  input            n_r_read27;          // Store27 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store27;      // Chip27 select27 LE27 store27
  input [1:0]      r_oete_store27;      // Read strobe27 TE27 end time before CS27
  input       cs;        // chip27 selects27
  input       r_cs27;      // registered chip27 selects27

  output [4:0]      r_smc_currentstate27;// Synchronised27 SMC27 state machine27
  output [4:0]      smc_nextstate27;     // State27 Machine27 
  output            cste_enable27;       // Enable27 CS27 Trailing27 Edge27 counter
  output            ws_enable27;         // Wait27 state counter enable
  output            smc_done27;          // one access completed
  output            valid_access27;      // load27 values are valid if high27
  output            le_enable27;         // Enable27 all Leading27 Edge27 
                                           // counters27
  output            latch_data27;        // latch_data27 is used by the 
                                           // MAC27 block
                                     //  to store27 read data if CSTE27 > 0
  output            smc_idle27;          // idle27 state



// Output27 register declarations27

  reg [4:0]    smc_nextstate27;     // SMC27 state machine27 (async27 encoding27)
  reg [4:0]    r_smc_currentstate27;// Synchronised27 SMC27 state machine27
  reg          ws_enable27;         // Wait27 state counter enable
  reg          cste_enable27;       // Chip27 select27 counter enable
  reg          smc_done27;         // Asserted27 during last cycle of access
  reg          valid_access27;      // load27 values are valid if high27
  reg          le_enable27;         // Enable27 all Leading27 Edge27 counters27
  reg          latch_data27;        // latch_data27 is used by the MAC27 block
  reg          smc_idle27;          // idle27 state
  


//----------------------------------------------------------------------
// Main27 code27
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC27 state machine27
//----------------------------------------------------------------------
// Generates27 the required27 timings27 for the External27 Memory Interface27.
// If27 back-to-back accesses are required27 the state machine27 will bypass27
// the idle27 state, thus27 maintaining27 the chip27 select27 ouput27.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate27 internal idle27 signal27 used by AHB27 IF
//----------------------------------------------------------------------

  always @(smc_nextstate27)
  
  begin
   
     if (smc_nextstate27 == `SMC_IDLE27)
     
        smc_idle27 = 1'b1;
   
     else
       
        smc_idle27 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate27 internal done signal27
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate27 or r_cste_count27 or r_ws_count27)
  
  begin
   
     if ( ( (r_smc_currentstate27 == `SMC_RW27) &
            (r_ws_count27 == 8'd0) &
            (r_cste_count27 == 2'd0)
          ) |
          ( (r_smc_currentstate27 == `SMC_FLOAT27)  &
            (r_cste_count27 == 2'd0)
          )
        )
       
        smc_done27 = 1'b1;
   
   else
     
      smc_done27 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data27 is used by the MAC27 block to store27 read data if CSTE27 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate27 or r_ws_count27 or r_oete_store27)
  
  begin
   
     if ( (r_smc_currentstate27 == `SMC_RW27) &
          (r_ws_count27[1:0] >= r_oete_store27) &
          (r_ws_count27[7:2] == 6'd0)
        )
     
       latch_data27 = 1'b1;
   
     else
       
       latch_data27 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter27 enable signals27
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate27 or r_csle_count27 or
       smc_nextstate27 or valid_access27)
  begin
     if(valid_access27)
     begin
        if ((smc_nextstate27 == `SMC_RW27)         &
            (r_smc_currentstate27 != `SMC_STORE27) &
            (r_smc_currentstate27 != `SMC_LE27))
  
          ws_enable27 = 1'b1;
  
        else
  
          ws_enable27 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate27 == `SMC_RW27) & 
            (r_csle_count27 == 2'd0) & 
            (r_smc_currentstate27 != `SMC_STORE27) &
            (r_smc_currentstate27 != `SMC_LE27))

           ws_enable27 = 1'b1;
   
        else
  
           ws_enable27 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable27
//----------------------------------------------------------------------

  always @(r_smc_currentstate27 or smc_nextstate27)
  
  begin
  
     if (((smc_nextstate27 == `SMC_LE27) | (smc_nextstate27 == `SMC_RW27) ) &
         (r_smc_currentstate27 != `SMC_STORE27) )
  
        le_enable27 = 1'b1;
  
     else
  
        le_enable27 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable27
//----------------------------------------------------------------------
  
  always @(smc_nextstate27)
  
  begin
     if (smc_nextstate27 == `SMC_FLOAT27)
    
        cste_enable27 = 1'b1;
   
     else
  
        cste_enable27 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH27 if new cycle is waiting27 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate27 or new_access27 or r_ws_count27 or
                                     smc_nextstate27 or mac_done27)
  
  begin
     
     if (new_access27 & mac_done27 &
         (((r_smc_currentstate27 == `SMC_RW27) & 
           (smc_nextstate27 == `SMC_RW27) & 
           (r_ws_count27 == 8'd0))                                |
          ((r_smc_currentstate27 == `SMC_FLOAT27) & 
           (smc_nextstate27 == `SMC_IDLE27) ) |
          ((r_smc_currentstate27 == `SMC_FLOAT27) & 
           (smc_nextstate27 == `SMC_LE27)   ) |
          ((r_smc_currentstate27 == `SMC_FLOAT27) & 
           (smc_nextstate27 == `SMC_RW27)   ) |
          ((r_smc_currentstate27 == `SMC_FLOAT27) & 
           (smc_nextstate27 == `SMC_STORE27)) |
          ((r_smc_currentstate27 == `SMC_RW27)    & 
           (smc_nextstate27 == `SMC_STORE27)) |
          ((r_smc_currentstate27 == `SMC_RW27)    & 
           (smc_nextstate27 == `SMC_IDLE27) ) |
          ((r_smc_currentstate27 == `SMC_RW27)    & 
           (smc_nextstate27 == `SMC_LE27)   ) |
          ((r_smc_currentstate27 == `SMC_IDLE27) ) )  )    
       
       valid_access27 = 1'b1;
     
     else
       
       valid_access27 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC27 State27 Machine27
//----------------------------------------------------------------------

 always @(r_smc_currentstate27 or new_access27 or 
          cs or r_csle_count27 or r_cste_count27 or r_ws_count27 or mac_done27 
          or r_cs27 or n_read27 or n_r_read27 or r_csle_store27)
  begin
   
   case (r_smc_currentstate27)
  
     `SMC_IDLE27 :
  
        if (new_access27 )
 
           smc_nextstate27 = `SMC_STORE27;
  
        else
  
        begin
  
  
           begin

              if (new_access27 )
  
                 smc_nextstate27 = `SMC_RW27;

              else
  
                 smc_nextstate27 = `SMC_IDLE27;

           end
          
        end

     `SMC_STORE27   :

        if ((r_csle_count27 != 2'd0))

           smc_nextstate27 = `SMC_LE27;

        else

        begin
           
           if ( (r_csle_count27 == 2'd0))

              smc_nextstate27 = `SMC_RW27;
           
           else
             
              smc_nextstate27 = `SMC_STORE27;

        end      

     `SMC_LE27   :
  
        if (r_csle_count27 < 2'd2)
  
           smc_nextstate27 = `SMC_RW27;
  
        else
  
           smc_nextstate27 = `SMC_LE27;
  
     `SMC_RW27   :
  
     begin
          
        if ((r_ws_count27 == 8'd0) & 
            (r_cste_count27 != 2'd0))
  
           smc_nextstate27 = `SMC_FLOAT27;
          
        else if ((r_ws_count27 == 8'd0) &
                 (r_cste_count27 == 2'h0) &
                 mac_done27 & ~new_access27)

           smc_nextstate27 = `SMC_IDLE27;
          
        else if ((~mac_done27 & (r_csle_store27 != 2'd0)) &
                 (r_ws_count27 == 8'd0))
 
           smc_nextstate27 = `SMC_LE27;

        
        else
          
        begin
  
           if  ( ((n_read27 != n_r_read27) | ((cs != r_cs27) & ~n_r_read27)) & 
                  new_access27 & mac_done27 &
                 (r_ws_count27 == 8'd0))   
             
              smc_nextstate27 = `SMC_STORE27;
           
           else
             
              smc_nextstate27 = `SMC_RW27;
           
        end
        
     end
  
     `SMC_FLOAT27   :
        if (~ mac_done27                               & 
            (( & new_access27) | 
             ((r_csle_store27 == 2'd0)            &
              ~new_access27)) &  (r_cste_count27 == 2'd0) )
  
           smc_nextstate27 = `SMC_RW27;
  
        else if (new_access27                              & 
                 (( new_access27) |
                  ((r_csle_store27 == 2'd0)            & 
                   ~new_access27)) & (r_cste_count27 == 2'd0) )

        begin
  
           if  (((n_read27 != n_r_read27) | ((cs != r_cs27) & ~n_r_read27)))   
  
              smc_nextstate27 = `SMC_STORE27;
  
           else
  
              smc_nextstate27 = `SMC_RW27;
  
        end
     
        else
          
        begin
  
           if ((~mac_done27 & (r_csle_store27 != 2'd0)) & 
               (r_cste_count27 < 2'd1))
  
              smc_nextstate27 = `SMC_LE27;

           
           else
             
           begin
           
              if (r_cste_count27 == 2'd0)
             
                 smc_nextstate27 = `SMC_IDLE27;
           
              else
  
                 smc_nextstate27 = `SMC_FLOAT27;
  
           end
           
        end
     
     default   :
       
       smc_nextstate27 = `SMC_IDLE27;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential27 process of state machine27
//----------------------------------------------------------------------

  always @(posedge sys_clk27 or negedge n_sys_reset27)
  
  begin
  
     if (~n_sys_reset27)
  
        r_smc_currentstate27 <= `SMC_IDLE27;
  
  
     else   
       
        r_smc_currentstate27 <= smc_nextstate27;
  
  
  end

   

   
endmodule


