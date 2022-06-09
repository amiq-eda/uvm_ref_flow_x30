//File2 name   : smc_state_lite2.v
//Title2       : 
//Created2     : 1999
//
//Description2 : SMC2 State2 Machine2
//            : Static2 Memory Controller2
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

`include "smc_defs_lite2.v"

//state machine2 for smc2
  module smc_state_lite2  (
                     //inputs2
  
                     sys_clk2,
                     n_sys_reset2,
                     new_access2,
                     r_cste_count2,
                     r_csle_count2,
                     r_ws_count2,
                     mac_done2,
                     n_read2,
                     n_r_read2,
                     r_csle_store2,
                     r_oete_store2,
                     cs,
                     r_cs2,
             
                     //outputs2
  
                     r_smc_currentstate2,
                     smc_nextstate2,
                     cste_enable2,
                     ws_enable2,
                     smc_done2,
                     valid_access2,
                     le_enable2,
                     latch_data2,
                     smc_idle2);
   
   
   
//Parameters2  -  Values2 in smc_defs2.v



// I2/O2

  input            sys_clk2;           // AHB2 System2 clock2
  input            n_sys_reset2;       // AHB2 System2 reset (Active2 LOW2)
  input            new_access2;        // New2 AHB2 valid access to smc2 
                                          // detected
  input [1:0]      r_cste_count2;      // Chip2 select2 TE2 counter
  input [1:0]      r_csle_count2;      // chip2 select2 leading2 edge count
  input [7:0]      r_ws_count2; // wait state count
  input            mac_done2;          // All cycles2 in a multiple access
  input            n_read2;            // Active2 low2 read signal2
  input            n_r_read2;          // Store2 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store2;      // Chip2 select2 LE2 store2
  input [1:0]      r_oete_store2;      // Read strobe2 TE2 end time before CS2
  input       cs;        // chip2 selects2
  input       r_cs2;      // registered chip2 selects2

  output [4:0]      r_smc_currentstate2;// Synchronised2 SMC2 state machine2
  output [4:0]      smc_nextstate2;     // State2 Machine2 
  output            cste_enable2;       // Enable2 CS2 Trailing2 Edge2 counter
  output            ws_enable2;         // Wait2 state counter enable
  output            smc_done2;          // one access completed
  output            valid_access2;      // load2 values are valid if high2
  output            le_enable2;         // Enable2 all Leading2 Edge2 
                                           // counters2
  output            latch_data2;        // latch_data2 is used by the 
                                           // MAC2 block
                                     //  to store2 read data if CSTE2 > 0
  output            smc_idle2;          // idle2 state



// Output2 register declarations2

  reg [4:0]    smc_nextstate2;     // SMC2 state machine2 (async2 encoding2)
  reg [4:0]    r_smc_currentstate2;// Synchronised2 SMC2 state machine2
  reg          ws_enable2;         // Wait2 state counter enable
  reg          cste_enable2;       // Chip2 select2 counter enable
  reg          smc_done2;         // Asserted2 during last cycle of access
  reg          valid_access2;      // load2 values are valid if high2
  reg          le_enable2;         // Enable2 all Leading2 Edge2 counters2
  reg          latch_data2;        // latch_data2 is used by the MAC2 block
  reg          smc_idle2;          // idle2 state
  


//----------------------------------------------------------------------
// Main2 code2
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC2 state machine2
//----------------------------------------------------------------------
// Generates2 the required2 timings2 for the External2 Memory Interface2.
// If2 back-to-back accesses are required2 the state machine2 will bypass2
// the idle2 state, thus2 maintaining2 the chip2 select2 ouput2.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate2 internal idle2 signal2 used by AHB2 IF
//----------------------------------------------------------------------

  always @(smc_nextstate2)
  
  begin
   
     if (smc_nextstate2 == `SMC_IDLE2)
     
        smc_idle2 = 1'b1;
   
     else
       
        smc_idle2 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate2 internal done signal2
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate2 or r_cste_count2 or r_ws_count2)
  
  begin
   
     if ( ( (r_smc_currentstate2 == `SMC_RW2) &
            (r_ws_count2 == 8'd0) &
            (r_cste_count2 == 2'd0)
          ) |
          ( (r_smc_currentstate2 == `SMC_FLOAT2)  &
            (r_cste_count2 == 2'd0)
          )
        )
       
        smc_done2 = 1'b1;
   
   else
     
      smc_done2 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data2 is used by the MAC2 block to store2 read data if CSTE2 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate2 or r_ws_count2 or r_oete_store2)
  
  begin
   
     if ( (r_smc_currentstate2 == `SMC_RW2) &
          (r_ws_count2[1:0] >= r_oete_store2) &
          (r_ws_count2[7:2] == 6'd0)
        )
     
       latch_data2 = 1'b1;
   
     else
       
       latch_data2 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter2 enable signals2
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate2 or r_csle_count2 or
       smc_nextstate2 or valid_access2)
  begin
     if(valid_access2)
     begin
        if ((smc_nextstate2 == `SMC_RW2)         &
            (r_smc_currentstate2 != `SMC_STORE2) &
            (r_smc_currentstate2 != `SMC_LE2))
  
          ws_enable2 = 1'b1;
  
        else
  
          ws_enable2 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate2 == `SMC_RW2) & 
            (r_csle_count2 == 2'd0) & 
            (r_smc_currentstate2 != `SMC_STORE2) &
            (r_smc_currentstate2 != `SMC_LE2))

           ws_enable2 = 1'b1;
   
        else
  
           ws_enable2 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable2
//----------------------------------------------------------------------

  always @(r_smc_currentstate2 or smc_nextstate2)
  
  begin
  
     if (((smc_nextstate2 == `SMC_LE2) | (smc_nextstate2 == `SMC_RW2) ) &
         (r_smc_currentstate2 != `SMC_STORE2) )
  
        le_enable2 = 1'b1;
  
     else
  
        le_enable2 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable2
//----------------------------------------------------------------------
  
  always @(smc_nextstate2)
  
  begin
     if (smc_nextstate2 == `SMC_FLOAT2)
    
        cste_enable2 = 1'b1;
   
     else
  
        cste_enable2 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH2 if new cycle is waiting2 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate2 or new_access2 or r_ws_count2 or
                                     smc_nextstate2 or mac_done2)
  
  begin
     
     if (new_access2 & mac_done2 &
         (((r_smc_currentstate2 == `SMC_RW2) & 
           (smc_nextstate2 == `SMC_RW2) & 
           (r_ws_count2 == 8'd0))                                |
          ((r_smc_currentstate2 == `SMC_FLOAT2) & 
           (smc_nextstate2 == `SMC_IDLE2) ) |
          ((r_smc_currentstate2 == `SMC_FLOAT2) & 
           (smc_nextstate2 == `SMC_LE2)   ) |
          ((r_smc_currentstate2 == `SMC_FLOAT2) & 
           (smc_nextstate2 == `SMC_RW2)   ) |
          ((r_smc_currentstate2 == `SMC_FLOAT2) & 
           (smc_nextstate2 == `SMC_STORE2)) |
          ((r_smc_currentstate2 == `SMC_RW2)    & 
           (smc_nextstate2 == `SMC_STORE2)) |
          ((r_smc_currentstate2 == `SMC_RW2)    & 
           (smc_nextstate2 == `SMC_IDLE2) ) |
          ((r_smc_currentstate2 == `SMC_RW2)    & 
           (smc_nextstate2 == `SMC_LE2)   ) |
          ((r_smc_currentstate2 == `SMC_IDLE2) ) )  )    
       
       valid_access2 = 1'b1;
     
     else
       
       valid_access2 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC2 State2 Machine2
//----------------------------------------------------------------------

 always @(r_smc_currentstate2 or new_access2 or 
          cs or r_csle_count2 or r_cste_count2 or r_ws_count2 or mac_done2 
          or r_cs2 or n_read2 or n_r_read2 or r_csle_store2)
  begin
   
   case (r_smc_currentstate2)
  
     `SMC_IDLE2 :
  
        if (new_access2 )
 
           smc_nextstate2 = `SMC_STORE2;
  
        else
  
        begin
  
  
           begin

              if (new_access2 )
  
                 smc_nextstate2 = `SMC_RW2;

              else
  
                 smc_nextstate2 = `SMC_IDLE2;

           end
          
        end

     `SMC_STORE2   :

        if ((r_csle_count2 != 2'd0))

           smc_nextstate2 = `SMC_LE2;

        else

        begin
           
           if ( (r_csle_count2 == 2'd0))

              smc_nextstate2 = `SMC_RW2;
           
           else
             
              smc_nextstate2 = `SMC_STORE2;

        end      

     `SMC_LE2   :
  
        if (r_csle_count2 < 2'd2)
  
           smc_nextstate2 = `SMC_RW2;
  
        else
  
           smc_nextstate2 = `SMC_LE2;
  
     `SMC_RW2   :
  
     begin
          
        if ((r_ws_count2 == 8'd0) & 
            (r_cste_count2 != 2'd0))
  
           smc_nextstate2 = `SMC_FLOAT2;
          
        else if ((r_ws_count2 == 8'd0) &
                 (r_cste_count2 == 2'h0) &
                 mac_done2 & ~new_access2)

           smc_nextstate2 = `SMC_IDLE2;
          
        else if ((~mac_done2 & (r_csle_store2 != 2'd0)) &
                 (r_ws_count2 == 8'd0))
 
           smc_nextstate2 = `SMC_LE2;

        
        else
          
        begin
  
           if  ( ((n_read2 != n_r_read2) | ((cs != r_cs2) & ~n_r_read2)) & 
                  new_access2 & mac_done2 &
                 (r_ws_count2 == 8'd0))   
             
              smc_nextstate2 = `SMC_STORE2;
           
           else
             
              smc_nextstate2 = `SMC_RW2;
           
        end
        
     end
  
     `SMC_FLOAT2   :
        if (~ mac_done2                               & 
            (( & new_access2) | 
             ((r_csle_store2 == 2'd0)            &
              ~new_access2)) &  (r_cste_count2 == 2'd0) )
  
           smc_nextstate2 = `SMC_RW2;
  
        else if (new_access2                              & 
                 (( new_access2) |
                  ((r_csle_store2 == 2'd0)            & 
                   ~new_access2)) & (r_cste_count2 == 2'd0) )

        begin
  
           if  (((n_read2 != n_r_read2) | ((cs != r_cs2) & ~n_r_read2)))   
  
              smc_nextstate2 = `SMC_STORE2;
  
           else
  
              smc_nextstate2 = `SMC_RW2;
  
        end
     
        else
          
        begin
  
           if ((~mac_done2 & (r_csle_store2 != 2'd0)) & 
               (r_cste_count2 < 2'd1))
  
              smc_nextstate2 = `SMC_LE2;

           
           else
             
           begin
           
              if (r_cste_count2 == 2'd0)
             
                 smc_nextstate2 = `SMC_IDLE2;
           
              else
  
                 smc_nextstate2 = `SMC_FLOAT2;
  
           end
           
        end
     
     default   :
       
       smc_nextstate2 = `SMC_IDLE2;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential2 process of state machine2
//----------------------------------------------------------------------

  always @(posedge sys_clk2 or negedge n_sys_reset2)
  
  begin
  
     if (~n_sys_reset2)
  
        r_smc_currentstate2 <= `SMC_IDLE2;
  
  
     else   
       
        r_smc_currentstate2 <= smc_nextstate2;
  
  
  end

   

   
endmodule


