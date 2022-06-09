//File28 name   : smc_state_lite28.v
//Title28       : 
//Created28     : 1999
//
//Description28 : SMC28 State28 Machine28
//            : Static28 Memory Controller28
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

`include "smc_defs_lite28.v"

//state machine28 for smc28
  module smc_state_lite28  (
                     //inputs28
  
                     sys_clk28,
                     n_sys_reset28,
                     new_access28,
                     r_cste_count28,
                     r_csle_count28,
                     r_ws_count28,
                     mac_done28,
                     n_read28,
                     n_r_read28,
                     r_csle_store28,
                     r_oete_store28,
                     cs,
                     r_cs28,
             
                     //outputs28
  
                     r_smc_currentstate28,
                     smc_nextstate28,
                     cste_enable28,
                     ws_enable28,
                     smc_done28,
                     valid_access28,
                     le_enable28,
                     latch_data28,
                     smc_idle28);
   
   
   
//Parameters28  -  Values28 in smc_defs28.v



// I28/O28

  input            sys_clk28;           // AHB28 System28 clock28
  input            n_sys_reset28;       // AHB28 System28 reset (Active28 LOW28)
  input            new_access28;        // New28 AHB28 valid access to smc28 
                                          // detected
  input [1:0]      r_cste_count28;      // Chip28 select28 TE28 counter
  input [1:0]      r_csle_count28;      // chip28 select28 leading28 edge count
  input [7:0]      r_ws_count28; // wait state count
  input            mac_done28;          // All cycles28 in a multiple access
  input            n_read28;            // Active28 low28 read signal28
  input            n_r_read28;          // Store28 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store28;      // Chip28 select28 LE28 store28
  input [1:0]      r_oete_store28;      // Read strobe28 TE28 end time before CS28
  input       cs;        // chip28 selects28
  input       r_cs28;      // registered chip28 selects28

  output [4:0]      r_smc_currentstate28;// Synchronised28 SMC28 state machine28
  output [4:0]      smc_nextstate28;     // State28 Machine28 
  output            cste_enable28;       // Enable28 CS28 Trailing28 Edge28 counter
  output            ws_enable28;         // Wait28 state counter enable
  output            smc_done28;          // one access completed
  output            valid_access28;      // load28 values are valid if high28
  output            le_enable28;         // Enable28 all Leading28 Edge28 
                                           // counters28
  output            latch_data28;        // latch_data28 is used by the 
                                           // MAC28 block
                                     //  to store28 read data if CSTE28 > 0
  output            smc_idle28;          // idle28 state



// Output28 register declarations28

  reg [4:0]    smc_nextstate28;     // SMC28 state machine28 (async28 encoding28)
  reg [4:0]    r_smc_currentstate28;// Synchronised28 SMC28 state machine28
  reg          ws_enable28;         // Wait28 state counter enable
  reg          cste_enable28;       // Chip28 select28 counter enable
  reg          smc_done28;         // Asserted28 during last cycle of access
  reg          valid_access28;      // load28 values are valid if high28
  reg          le_enable28;         // Enable28 all Leading28 Edge28 counters28
  reg          latch_data28;        // latch_data28 is used by the MAC28 block
  reg          smc_idle28;          // idle28 state
  


//----------------------------------------------------------------------
// Main28 code28
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC28 state machine28
//----------------------------------------------------------------------
// Generates28 the required28 timings28 for the External28 Memory Interface28.
// If28 back-to-back accesses are required28 the state machine28 will bypass28
// the idle28 state, thus28 maintaining28 the chip28 select28 ouput28.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate28 internal idle28 signal28 used by AHB28 IF
//----------------------------------------------------------------------

  always @(smc_nextstate28)
  
  begin
   
     if (smc_nextstate28 == `SMC_IDLE28)
     
        smc_idle28 = 1'b1;
   
     else
       
        smc_idle28 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate28 internal done signal28
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate28 or r_cste_count28 or r_ws_count28)
  
  begin
   
     if ( ( (r_smc_currentstate28 == `SMC_RW28) &
            (r_ws_count28 == 8'd0) &
            (r_cste_count28 == 2'd0)
          ) |
          ( (r_smc_currentstate28 == `SMC_FLOAT28)  &
            (r_cste_count28 == 2'd0)
          )
        )
       
        smc_done28 = 1'b1;
   
   else
     
      smc_done28 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data28 is used by the MAC28 block to store28 read data if CSTE28 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate28 or r_ws_count28 or r_oete_store28)
  
  begin
   
     if ( (r_smc_currentstate28 == `SMC_RW28) &
          (r_ws_count28[1:0] >= r_oete_store28) &
          (r_ws_count28[7:2] == 6'd0)
        )
     
       latch_data28 = 1'b1;
   
     else
       
       latch_data28 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter28 enable signals28
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate28 or r_csle_count28 or
       smc_nextstate28 or valid_access28)
  begin
     if(valid_access28)
     begin
        if ((smc_nextstate28 == `SMC_RW28)         &
            (r_smc_currentstate28 != `SMC_STORE28) &
            (r_smc_currentstate28 != `SMC_LE28))
  
          ws_enable28 = 1'b1;
  
        else
  
          ws_enable28 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate28 == `SMC_RW28) & 
            (r_csle_count28 == 2'd0) & 
            (r_smc_currentstate28 != `SMC_STORE28) &
            (r_smc_currentstate28 != `SMC_LE28))

           ws_enable28 = 1'b1;
   
        else
  
           ws_enable28 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable28
//----------------------------------------------------------------------

  always @(r_smc_currentstate28 or smc_nextstate28)
  
  begin
  
     if (((smc_nextstate28 == `SMC_LE28) | (smc_nextstate28 == `SMC_RW28) ) &
         (r_smc_currentstate28 != `SMC_STORE28) )
  
        le_enable28 = 1'b1;
  
     else
  
        le_enable28 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable28
//----------------------------------------------------------------------
  
  always @(smc_nextstate28)
  
  begin
     if (smc_nextstate28 == `SMC_FLOAT28)
    
        cste_enable28 = 1'b1;
   
     else
  
        cste_enable28 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH28 if new cycle is waiting28 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate28 or new_access28 or r_ws_count28 or
                                     smc_nextstate28 or mac_done28)
  
  begin
     
     if (new_access28 & mac_done28 &
         (((r_smc_currentstate28 == `SMC_RW28) & 
           (smc_nextstate28 == `SMC_RW28) & 
           (r_ws_count28 == 8'd0))                                |
          ((r_smc_currentstate28 == `SMC_FLOAT28) & 
           (smc_nextstate28 == `SMC_IDLE28) ) |
          ((r_smc_currentstate28 == `SMC_FLOAT28) & 
           (smc_nextstate28 == `SMC_LE28)   ) |
          ((r_smc_currentstate28 == `SMC_FLOAT28) & 
           (smc_nextstate28 == `SMC_RW28)   ) |
          ((r_smc_currentstate28 == `SMC_FLOAT28) & 
           (smc_nextstate28 == `SMC_STORE28)) |
          ((r_smc_currentstate28 == `SMC_RW28)    & 
           (smc_nextstate28 == `SMC_STORE28)) |
          ((r_smc_currentstate28 == `SMC_RW28)    & 
           (smc_nextstate28 == `SMC_IDLE28) ) |
          ((r_smc_currentstate28 == `SMC_RW28)    & 
           (smc_nextstate28 == `SMC_LE28)   ) |
          ((r_smc_currentstate28 == `SMC_IDLE28) ) )  )    
       
       valid_access28 = 1'b1;
     
     else
       
       valid_access28 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC28 State28 Machine28
//----------------------------------------------------------------------

 always @(r_smc_currentstate28 or new_access28 or 
          cs or r_csle_count28 or r_cste_count28 or r_ws_count28 or mac_done28 
          or r_cs28 or n_read28 or n_r_read28 or r_csle_store28)
  begin
   
   case (r_smc_currentstate28)
  
     `SMC_IDLE28 :
  
        if (new_access28 )
 
           smc_nextstate28 = `SMC_STORE28;
  
        else
  
        begin
  
  
           begin

              if (new_access28 )
  
                 smc_nextstate28 = `SMC_RW28;

              else
  
                 smc_nextstate28 = `SMC_IDLE28;

           end
          
        end

     `SMC_STORE28   :

        if ((r_csle_count28 != 2'd0))

           smc_nextstate28 = `SMC_LE28;

        else

        begin
           
           if ( (r_csle_count28 == 2'd0))

              smc_nextstate28 = `SMC_RW28;
           
           else
             
              smc_nextstate28 = `SMC_STORE28;

        end      

     `SMC_LE28   :
  
        if (r_csle_count28 < 2'd2)
  
           smc_nextstate28 = `SMC_RW28;
  
        else
  
           smc_nextstate28 = `SMC_LE28;
  
     `SMC_RW28   :
  
     begin
          
        if ((r_ws_count28 == 8'd0) & 
            (r_cste_count28 != 2'd0))
  
           smc_nextstate28 = `SMC_FLOAT28;
          
        else if ((r_ws_count28 == 8'd0) &
                 (r_cste_count28 == 2'h0) &
                 mac_done28 & ~new_access28)

           smc_nextstate28 = `SMC_IDLE28;
          
        else if ((~mac_done28 & (r_csle_store28 != 2'd0)) &
                 (r_ws_count28 == 8'd0))
 
           smc_nextstate28 = `SMC_LE28;

        
        else
          
        begin
  
           if  ( ((n_read28 != n_r_read28) | ((cs != r_cs28) & ~n_r_read28)) & 
                  new_access28 & mac_done28 &
                 (r_ws_count28 == 8'd0))   
             
              smc_nextstate28 = `SMC_STORE28;
           
           else
             
              smc_nextstate28 = `SMC_RW28;
           
        end
        
     end
  
     `SMC_FLOAT28   :
        if (~ mac_done28                               & 
            (( & new_access28) | 
             ((r_csle_store28 == 2'd0)            &
              ~new_access28)) &  (r_cste_count28 == 2'd0) )
  
           smc_nextstate28 = `SMC_RW28;
  
        else if (new_access28                              & 
                 (( new_access28) |
                  ((r_csle_store28 == 2'd0)            & 
                   ~new_access28)) & (r_cste_count28 == 2'd0) )

        begin
  
           if  (((n_read28 != n_r_read28) | ((cs != r_cs28) & ~n_r_read28)))   
  
              smc_nextstate28 = `SMC_STORE28;
  
           else
  
              smc_nextstate28 = `SMC_RW28;
  
        end
     
        else
          
        begin
  
           if ((~mac_done28 & (r_csle_store28 != 2'd0)) & 
               (r_cste_count28 < 2'd1))
  
              smc_nextstate28 = `SMC_LE28;

           
           else
             
           begin
           
              if (r_cste_count28 == 2'd0)
             
                 smc_nextstate28 = `SMC_IDLE28;
           
              else
  
                 smc_nextstate28 = `SMC_FLOAT28;
  
           end
           
        end
     
     default   :
       
       smc_nextstate28 = `SMC_IDLE28;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential28 process of state machine28
//----------------------------------------------------------------------

  always @(posedge sys_clk28 or negedge n_sys_reset28)
  
  begin
  
     if (~n_sys_reset28)
  
        r_smc_currentstate28 <= `SMC_IDLE28;
  
  
     else   
       
        r_smc_currentstate28 <= smc_nextstate28;
  
  
  end

   

   
endmodule


