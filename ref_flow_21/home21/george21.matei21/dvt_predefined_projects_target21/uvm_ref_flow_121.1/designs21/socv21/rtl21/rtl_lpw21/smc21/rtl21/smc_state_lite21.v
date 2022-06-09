//File21 name   : smc_state_lite21.v
//Title21       : 
//Created21     : 1999
//
//Description21 : SMC21 State21 Machine21
//            : Static21 Memory Controller21
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

`include "smc_defs_lite21.v"

//state machine21 for smc21
  module smc_state_lite21  (
                     //inputs21
  
                     sys_clk21,
                     n_sys_reset21,
                     new_access21,
                     r_cste_count21,
                     r_csle_count21,
                     r_ws_count21,
                     mac_done21,
                     n_read21,
                     n_r_read21,
                     r_csle_store21,
                     r_oete_store21,
                     cs,
                     r_cs21,
             
                     //outputs21
  
                     r_smc_currentstate21,
                     smc_nextstate21,
                     cste_enable21,
                     ws_enable21,
                     smc_done21,
                     valid_access21,
                     le_enable21,
                     latch_data21,
                     smc_idle21);
   
   
   
//Parameters21  -  Values21 in smc_defs21.v



// I21/O21

  input            sys_clk21;           // AHB21 System21 clock21
  input            n_sys_reset21;       // AHB21 System21 reset (Active21 LOW21)
  input            new_access21;        // New21 AHB21 valid access to smc21 
                                          // detected
  input [1:0]      r_cste_count21;      // Chip21 select21 TE21 counter
  input [1:0]      r_csle_count21;      // chip21 select21 leading21 edge count
  input [7:0]      r_ws_count21; // wait state count
  input            mac_done21;          // All cycles21 in a multiple access
  input            n_read21;            // Active21 low21 read signal21
  input            n_r_read21;          // Store21 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store21;      // Chip21 select21 LE21 store21
  input [1:0]      r_oete_store21;      // Read strobe21 TE21 end time before CS21
  input       cs;        // chip21 selects21
  input       r_cs21;      // registered chip21 selects21

  output [4:0]      r_smc_currentstate21;// Synchronised21 SMC21 state machine21
  output [4:0]      smc_nextstate21;     // State21 Machine21 
  output            cste_enable21;       // Enable21 CS21 Trailing21 Edge21 counter
  output            ws_enable21;         // Wait21 state counter enable
  output            smc_done21;          // one access completed
  output            valid_access21;      // load21 values are valid if high21
  output            le_enable21;         // Enable21 all Leading21 Edge21 
                                           // counters21
  output            latch_data21;        // latch_data21 is used by the 
                                           // MAC21 block
                                     //  to store21 read data if CSTE21 > 0
  output            smc_idle21;          // idle21 state



// Output21 register declarations21

  reg [4:0]    smc_nextstate21;     // SMC21 state machine21 (async21 encoding21)
  reg [4:0]    r_smc_currentstate21;// Synchronised21 SMC21 state machine21
  reg          ws_enable21;         // Wait21 state counter enable
  reg          cste_enable21;       // Chip21 select21 counter enable
  reg          smc_done21;         // Asserted21 during last cycle of access
  reg          valid_access21;      // load21 values are valid if high21
  reg          le_enable21;         // Enable21 all Leading21 Edge21 counters21
  reg          latch_data21;        // latch_data21 is used by the MAC21 block
  reg          smc_idle21;          // idle21 state
  


//----------------------------------------------------------------------
// Main21 code21
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC21 state machine21
//----------------------------------------------------------------------
// Generates21 the required21 timings21 for the External21 Memory Interface21.
// If21 back-to-back accesses are required21 the state machine21 will bypass21
// the idle21 state, thus21 maintaining21 the chip21 select21 ouput21.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate21 internal idle21 signal21 used by AHB21 IF
//----------------------------------------------------------------------

  always @(smc_nextstate21)
  
  begin
   
     if (smc_nextstate21 == `SMC_IDLE21)
     
        smc_idle21 = 1'b1;
   
     else
       
        smc_idle21 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate21 internal done signal21
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate21 or r_cste_count21 or r_ws_count21)
  
  begin
   
     if ( ( (r_smc_currentstate21 == `SMC_RW21) &
            (r_ws_count21 == 8'd0) &
            (r_cste_count21 == 2'd0)
          ) |
          ( (r_smc_currentstate21 == `SMC_FLOAT21)  &
            (r_cste_count21 == 2'd0)
          )
        )
       
        smc_done21 = 1'b1;
   
   else
     
      smc_done21 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data21 is used by the MAC21 block to store21 read data if CSTE21 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate21 or r_ws_count21 or r_oete_store21)
  
  begin
   
     if ( (r_smc_currentstate21 == `SMC_RW21) &
          (r_ws_count21[1:0] >= r_oete_store21) &
          (r_ws_count21[7:2] == 6'd0)
        )
     
       latch_data21 = 1'b1;
   
     else
       
       latch_data21 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter21 enable signals21
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate21 or r_csle_count21 or
       smc_nextstate21 or valid_access21)
  begin
     if(valid_access21)
     begin
        if ((smc_nextstate21 == `SMC_RW21)         &
            (r_smc_currentstate21 != `SMC_STORE21) &
            (r_smc_currentstate21 != `SMC_LE21))
  
          ws_enable21 = 1'b1;
  
        else
  
          ws_enable21 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate21 == `SMC_RW21) & 
            (r_csle_count21 == 2'd0) & 
            (r_smc_currentstate21 != `SMC_STORE21) &
            (r_smc_currentstate21 != `SMC_LE21))

           ws_enable21 = 1'b1;
   
        else
  
           ws_enable21 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable21
//----------------------------------------------------------------------

  always @(r_smc_currentstate21 or smc_nextstate21)
  
  begin
  
     if (((smc_nextstate21 == `SMC_LE21) | (smc_nextstate21 == `SMC_RW21) ) &
         (r_smc_currentstate21 != `SMC_STORE21) )
  
        le_enable21 = 1'b1;
  
     else
  
        le_enable21 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable21
//----------------------------------------------------------------------
  
  always @(smc_nextstate21)
  
  begin
     if (smc_nextstate21 == `SMC_FLOAT21)
    
        cste_enable21 = 1'b1;
   
     else
  
        cste_enable21 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH21 if new cycle is waiting21 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate21 or new_access21 or r_ws_count21 or
                                     smc_nextstate21 or mac_done21)
  
  begin
     
     if (new_access21 & mac_done21 &
         (((r_smc_currentstate21 == `SMC_RW21) & 
           (smc_nextstate21 == `SMC_RW21) & 
           (r_ws_count21 == 8'd0))                                |
          ((r_smc_currentstate21 == `SMC_FLOAT21) & 
           (smc_nextstate21 == `SMC_IDLE21) ) |
          ((r_smc_currentstate21 == `SMC_FLOAT21) & 
           (smc_nextstate21 == `SMC_LE21)   ) |
          ((r_smc_currentstate21 == `SMC_FLOAT21) & 
           (smc_nextstate21 == `SMC_RW21)   ) |
          ((r_smc_currentstate21 == `SMC_FLOAT21) & 
           (smc_nextstate21 == `SMC_STORE21)) |
          ((r_smc_currentstate21 == `SMC_RW21)    & 
           (smc_nextstate21 == `SMC_STORE21)) |
          ((r_smc_currentstate21 == `SMC_RW21)    & 
           (smc_nextstate21 == `SMC_IDLE21) ) |
          ((r_smc_currentstate21 == `SMC_RW21)    & 
           (smc_nextstate21 == `SMC_LE21)   ) |
          ((r_smc_currentstate21 == `SMC_IDLE21) ) )  )    
       
       valid_access21 = 1'b1;
     
     else
       
       valid_access21 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC21 State21 Machine21
//----------------------------------------------------------------------

 always @(r_smc_currentstate21 or new_access21 or 
          cs or r_csle_count21 or r_cste_count21 or r_ws_count21 or mac_done21 
          or r_cs21 or n_read21 or n_r_read21 or r_csle_store21)
  begin
   
   case (r_smc_currentstate21)
  
     `SMC_IDLE21 :
  
        if (new_access21 )
 
           smc_nextstate21 = `SMC_STORE21;
  
        else
  
        begin
  
  
           begin

              if (new_access21 )
  
                 smc_nextstate21 = `SMC_RW21;

              else
  
                 smc_nextstate21 = `SMC_IDLE21;

           end
          
        end

     `SMC_STORE21   :

        if ((r_csle_count21 != 2'd0))

           smc_nextstate21 = `SMC_LE21;

        else

        begin
           
           if ( (r_csle_count21 == 2'd0))

              smc_nextstate21 = `SMC_RW21;
           
           else
             
              smc_nextstate21 = `SMC_STORE21;

        end      

     `SMC_LE21   :
  
        if (r_csle_count21 < 2'd2)
  
           smc_nextstate21 = `SMC_RW21;
  
        else
  
           smc_nextstate21 = `SMC_LE21;
  
     `SMC_RW21   :
  
     begin
          
        if ((r_ws_count21 == 8'd0) & 
            (r_cste_count21 != 2'd0))
  
           smc_nextstate21 = `SMC_FLOAT21;
          
        else if ((r_ws_count21 == 8'd0) &
                 (r_cste_count21 == 2'h0) &
                 mac_done21 & ~new_access21)

           smc_nextstate21 = `SMC_IDLE21;
          
        else if ((~mac_done21 & (r_csle_store21 != 2'd0)) &
                 (r_ws_count21 == 8'd0))
 
           smc_nextstate21 = `SMC_LE21;

        
        else
          
        begin
  
           if  ( ((n_read21 != n_r_read21) | ((cs != r_cs21) & ~n_r_read21)) & 
                  new_access21 & mac_done21 &
                 (r_ws_count21 == 8'd0))   
             
              smc_nextstate21 = `SMC_STORE21;
           
           else
             
              smc_nextstate21 = `SMC_RW21;
           
        end
        
     end
  
     `SMC_FLOAT21   :
        if (~ mac_done21                               & 
            (( & new_access21) | 
             ((r_csle_store21 == 2'd0)            &
              ~new_access21)) &  (r_cste_count21 == 2'd0) )
  
           smc_nextstate21 = `SMC_RW21;
  
        else if (new_access21                              & 
                 (( new_access21) |
                  ((r_csle_store21 == 2'd0)            & 
                   ~new_access21)) & (r_cste_count21 == 2'd0) )

        begin
  
           if  (((n_read21 != n_r_read21) | ((cs != r_cs21) & ~n_r_read21)))   
  
              smc_nextstate21 = `SMC_STORE21;
  
           else
  
              smc_nextstate21 = `SMC_RW21;
  
        end
     
        else
          
        begin
  
           if ((~mac_done21 & (r_csle_store21 != 2'd0)) & 
               (r_cste_count21 < 2'd1))
  
              smc_nextstate21 = `SMC_LE21;

           
           else
             
           begin
           
              if (r_cste_count21 == 2'd0)
             
                 smc_nextstate21 = `SMC_IDLE21;
           
              else
  
                 smc_nextstate21 = `SMC_FLOAT21;
  
           end
           
        end
     
     default   :
       
       smc_nextstate21 = `SMC_IDLE21;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential21 process of state machine21
//----------------------------------------------------------------------

  always @(posedge sys_clk21 or negedge n_sys_reset21)
  
  begin
  
     if (~n_sys_reset21)
  
        r_smc_currentstate21 <= `SMC_IDLE21;
  
  
     else   
       
        r_smc_currentstate21 <= smc_nextstate21;
  
  
  end

   

   
endmodule


