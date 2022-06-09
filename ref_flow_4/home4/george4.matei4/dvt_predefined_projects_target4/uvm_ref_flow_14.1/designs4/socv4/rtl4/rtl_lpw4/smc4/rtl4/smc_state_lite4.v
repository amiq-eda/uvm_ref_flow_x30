//File4 name   : smc_state_lite4.v
//Title4       : 
//Created4     : 1999
//
//Description4 : SMC4 State4 Machine4
//            : Static4 Memory Controller4
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

`include "smc_defs_lite4.v"

//state machine4 for smc4
  module smc_state_lite4  (
                     //inputs4
  
                     sys_clk4,
                     n_sys_reset4,
                     new_access4,
                     r_cste_count4,
                     r_csle_count4,
                     r_ws_count4,
                     mac_done4,
                     n_read4,
                     n_r_read4,
                     r_csle_store4,
                     r_oete_store4,
                     cs,
                     r_cs4,
             
                     //outputs4
  
                     r_smc_currentstate4,
                     smc_nextstate4,
                     cste_enable4,
                     ws_enable4,
                     smc_done4,
                     valid_access4,
                     le_enable4,
                     latch_data4,
                     smc_idle4);
   
   
   
//Parameters4  -  Values4 in smc_defs4.v



// I4/O4

  input            sys_clk4;           // AHB4 System4 clock4
  input            n_sys_reset4;       // AHB4 System4 reset (Active4 LOW4)
  input            new_access4;        // New4 AHB4 valid access to smc4 
                                          // detected
  input [1:0]      r_cste_count4;      // Chip4 select4 TE4 counter
  input [1:0]      r_csle_count4;      // chip4 select4 leading4 edge count
  input [7:0]      r_ws_count4; // wait state count
  input            mac_done4;          // All cycles4 in a multiple access
  input            n_read4;            // Active4 low4 read signal4
  input            n_r_read4;          // Store4 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store4;      // Chip4 select4 LE4 store4
  input [1:0]      r_oete_store4;      // Read strobe4 TE4 end time before CS4
  input       cs;        // chip4 selects4
  input       r_cs4;      // registered chip4 selects4

  output [4:0]      r_smc_currentstate4;// Synchronised4 SMC4 state machine4
  output [4:0]      smc_nextstate4;     // State4 Machine4 
  output            cste_enable4;       // Enable4 CS4 Trailing4 Edge4 counter
  output            ws_enable4;         // Wait4 state counter enable
  output            smc_done4;          // one access completed
  output            valid_access4;      // load4 values are valid if high4
  output            le_enable4;         // Enable4 all Leading4 Edge4 
                                           // counters4
  output            latch_data4;        // latch_data4 is used by the 
                                           // MAC4 block
                                     //  to store4 read data if CSTE4 > 0
  output            smc_idle4;          // idle4 state



// Output4 register declarations4

  reg [4:0]    smc_nextstate4;     // SMC4 state machine4 (async4 encoding4)
  reg [4:0]    r_smc_currentstate4;// Synchronised4 SMC4 state machine4
  reg          ws_enable4;         // Wait4 state counter enable
  reg          cste_enable4;       // Chip4 select4 counter enable
  reg          smc_done4;         // Asserted4 during last cycle of access
  reg          valid_access4;      // load4 values are valid if high4
  reg          le_enable4;         // Enable4 all Leading4 Edge4 counters4
  reg          latch_data4;        // latch_data4 is used by the MAC4 block
  reg          smc_idle4;          // idle4 state
  


//----------------------------------------------------------------------
// Main4 code4
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC4 state machine4
//----------------------------------------------------------------------
// Generates4 the required4 timings4 for the External4 Memory Interface4.
// If4 back-to-back accesses are required4 the state machine4 will bypass4
// the idle4 state, thus4 maintaining4 the chip4 select4 ouput4.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate4 internal idle4 signal4 used by AHB4 IF
//----------------------------------------------------------------------

  always @(smc_nextstate4)
  
  begin
   
     if (smc_nextstate4 == `SMC_IDLE4)
     
        smc_idle4 = 1'b1;
   
     else
       
        smc_idle4 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate4 internal done signal4
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate4 or r_cste_count4 or r_ws_count4)
  
  begin
   
     if ( ( (r_smc_currentstate4 == `SMC_RW4) &
            (r_ws_count4 == 8'd0) &
            (r_cste_count4 == 2'd0)
          ) |
          ( (r_smc_currentstate4 == `SMC_FLOAT4)  &
            (r_cste_count4 == 2'd0)
          )
        )
       
        smc_done4 = 1'b1;
   
   else
     
      smc_done4 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data4 is used by the MAC4 block to store4 read data if CSTE4 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate4 or r_ws_count4 or r_oete_store4)
  
  begin
   
     if ( (r_smc_currentstate4 == `SMC_RW4) &
          (r_ws_count4[1:0] >= r_oete_store4) &
          (r_ws_count4[7:2] == 6'd0)
        )
     
       latch_data4 = 1'b1;
   
     else
       
       latch_data4 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter4 enable signals4
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate4 or r_csle_count4 or
       smc_nextstate4 or valid_access4)
  begin
     if(valid_access4)
     begin
        if ((smc_nextstate4 == `SMC_RW4)         &
            (r_smc_currentstate4 != `SMC_STORE4) &
            (r_smc_currentstate4 != `SMC_LE4))
  
          ws_enable4 = 1'b1;
  
        else
  
          ws_enable4 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate4 == `SMC_RW4) & 
            (r_csle_count4 == 2'd0) & 
            (r_smc_currentstate4 != `SMC_STORE4) &
            (r_smc_currentstate4 != `SMC_LE4))

           ws_enable4 = 1'b1;
   
        else
  
           ws_enable4 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable4
//----------------------------------------------------------------------

  always @(r_smc_currentstate4 or smc_nextstate4)
  
  begin
  
     if (((smc_nextstate4 == `SMC_LE4) | (smc_nextstate4 == `SMC_RW4) ) &
         (r_smc_currentstate4 != `SMC_STORE4) )
  
        le_enable4 = 1'b1;
  
     else
  
        le_enable4 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable4
//----------------------------------------------------------------------
  
  always @(smc_nextstate4)
  
  begin
     if (smc_nextstate4 == `SMC_FLOAT4)
    
        cste_enable4 = 1'b1;
   
     else
  
        cste_enable4 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH4 if new cycle is waiting4 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate4 or new_access4 or r_ws_count4 or
                                     smc_nextstate4 or mac_done4)
  
  begin
     
     if (new_access4 & mac_done4 &
         (((r_smc_currentstate4 == `SMC_RW4) & 
           (smc_nextstate4 == `SMC_RW4) & 
           (r_ws_count4 == 8'd0))                                |
          ((r_smc_currentstate4 == `SMC_FLOAT4) & 
           (smc_nextstate4 == `SMC_IDLE4) ) |
          ((r_smc_currentstate4 == `SMC_FLOAT4) & 
           (smc_nextstate4 == `SMC_LE4)   ) |
          ((r_smc_currentstate4 == `SMC_FLOAT4) & 
           (smc_nextstate4 == `SMC_RW4)   ) |
          ((r_smc_currentstate4 == `SMC_FLOAT4) & 
           (smc_nextstate4 == `SMC_STORE4)) |
          ((r_smc_currentstate4 == `SMC_RW4)    & 
           (smc_nextstate4 == `SMC_STORE4)) |
          ((r_smc_currentstate4 == `SMC_RW4)    & 
           (smc_nextstate4 == `SMC_IDLE4) ) |
          ((r_smc_currentstate4 == `SMC_RW4)    & 
           (smc_nextstate4 == `SMC_LE4)   ) |
          ((r_smc_currentstate4 == `SMC_IDLE4) ) )  )    
       
       valid_access4 = 1'b1;
     
     else
       
       valid_access4 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC4 State4 Machine4
//----------------------------------------------------------------------

 always @(r_smc_currentstate4 or new_access4 or 
          cs or r_csle_count4 or r_cste_count4 or r_ws_count4 or mac_done4 
          or r_cs4 or n_read4 or n_r_read4 or r_csle_store4)
  begin
   
   case (r_smc_currentstate4)
  
     `SMC_IDLE4 :
  
        if (new_access4 )
 
           smc_nextstate4 = `SMC_STORE4;
  
        else
  
        begin
  
  
           begin

              if (new_access4 )
  
                 smc_nextstate4 = `SMC_RW4;

              else
  
                 smc_nextstate4 = `SMC_IDLE4;

           end
          
        end

     `SMC_STORE4   :

        if ((r_csle_count4 != 2'd0))

           smc_nextstate4 = `SMC_LE4;

        else

        begin
           
           if ( (r_csle_count4 == 2'd0))

              smc_nextstate4 = `SMC_RW4;
           
           else
             
              smc_nextstate4 = `SMC_STORE4;

        end      

     `SMC_LE4   :
  
        if (r_csle_count4 < 2'd2)
  
           smc_nextstate4 = `SMC_RW4;
  
        else
  
           smc_nextstate4 = `SMC_LE4;
  
     `SMC_RW4   :
  
     begin
          
        if ((r_ws_count4 == 8'd0) & 
            (r_cste_count4 != 2'd0))
  
           smc_nextstate4 = `SMC_FLOAT4;
          
        else if ((r_ws_count4 == 8'd0) &
                 (r_cste_count4 == 2'h0) &
                 mac_done4 & ~new_access4)

           smc_nextstate4 = `SMC_IDLE4;
          
        else if ((~mac_done4 & (r_csle_store4 != 2'd0)) &
                 (r_ws_count4 == 8'd0))
 
           smc_nextstate4 = `SMC_LE4;

        
        else
          
        begin
  
           if  ( ((n_read4 != n_r_read4) | ((cs != r_cs4) & ~n_r_read4)) & 
                  new_access4 & mac_done4 &
                 (r_ws_count4 == 8'd0))   
             
              smc_nextstate4 = `SMC_STORE4;
           
           else
             
              smc_nextstate4 = `SMC_RW4;
           
        end
        
     end
  
     `SMC_FLOAT4   :
        if (~ mac_done4                               & 
            (( & new_access4) | 
             ((r_csle_store4 == 2'd0)            &
              ~new_access4)) &  (r_cste_count4 == 2'd0) )
  
           smc_nextstate4 = `SMC_RW4;
  
        else if (new_access4                              & 
                 (( new_access4) |
                  ((r_csle_store4 == 2'd0)            & 
                   ~new_access4)) & (r_cste_count4 == 2'd0) )

        begin
  
           if  (((n_read4 != n_r_read4) | ((cs != r_cs4) & ~n_r_read4)))   
  
              smc_nextstate4 = `SMC_STORE4;
  
           else
  
              smc_nextstate4 = `SMC_RW4;
  
        end
     
        else
          
        begin
  
           if ((~mac_done4 & (r_csle_store4 != 2'd0)) & 
               (r_cste_count4 < 2'd1))
  
              smc_nextstate4 = `SMC_LE4;

           
           else
             
           begin
           
              if (r_cste_count4 == 2'd0)
             
                 smc_nextstate4 = `SMC_IDLE4;
           
              else
  
                 smc_nextstate4 = `SMC_FLOAT4;
  
           end
           
        end
     
     default   :
       
       smc_nextstate4 = `SMC_IDLE4;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential4 process of state machine4
//----------------------------------------------------------------------

  always @(posedge sys_clk4 or negedge n_sys_reset4)
  
  begin
  
     if (~n_sys_reset4)
  
        r_smc_currentstate4 <= `SMC_IDLE4;
  
  
     else   
       
        r_smc_currentstate4 <= smc_nextstate4;
  
  
  end

   

   
endmodule


