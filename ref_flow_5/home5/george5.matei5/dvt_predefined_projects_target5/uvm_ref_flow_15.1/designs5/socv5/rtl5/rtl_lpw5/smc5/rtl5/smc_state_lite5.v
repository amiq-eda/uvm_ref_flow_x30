//File5 name   : smc_state_lite5.v
//Title5       : 
//Created5     : 1999
//
//Description5 : SMC5 State5 Machine5
//            : Static5 Memory Controller5
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

`include "smc_defs_lite5.v"

//state machine5 for smc5
  module smc_state_lite5  (
                     //inputs5
  
                     sys_clk5,
                     n_sys_reset5,
                     new_access5,
                     r_cste_count5,
                     r_csle_count5,
                     r_ws_count5,
                     mac_done5,
                     n_read5,
                     n_r_read5,
                     r_csle_store5,
                     r_oete_store5,
                     cs,
                     r_cs5,
             
                     //outputs5
  
                     r_smc_currentstate5,
                     smc_nextstate5,
                     cste_enable5,
                     ws_enable5,
                     smc_done5,
                     valid_access5,
                     le_enable5,
                     latch_data5,
                     smc_idle5);
   
   
   
//Parameters5  -  Values5 in smc_defs5.v



// I5/O5

  input            sys_clk5;           // AHB5 System5 clock5
  input            n_sys_reset5;       // AHB5 System5 reset (Active5 LOW5)
  input            new_access5;        // New5 AHB5 valid access to smc5 
                                          // detected
  input [1:0]      r_cste_count5;      // Chip5 select5 TE5 counter
  input [1:0]      r_csle_count5;      // chip5 select5 leading5 edge count
  input [7:0]      r_ws_count5; // wait state count
  input            mac_done5;          // All cycles5 in a multiple access
  input            n_read5;            // Active5 low5 read signal5
  input            n_r_read5;          // Store5 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store5;      // Chip5 select5 LE5 store5
  input [1:0]      r_oete_store5;      // Read strobe5 TE5 end time before CS5
  input       cs;        // chip5 selects5
  input       r_cs5;      // registered chip5 selects5

  output [4:0]      r_smc_currentstate5;// Synchronised5 SMC5 state machine5
  output [4:0]      smc_nextstate5;     // State5 Machine5 
  output            cste_enable5;       // Enable5 CS5 Trailing5 Edge5 counter
  output            ws_enable5;         // Wait5 state counter enable
  output            smc_done5;          // one access completed
  output            valid_access5;      // load5 values are valid if high5
  output            le_enable5;         // Enable5 all Leading5 Edge5 
                                           // counters5
  output            latch_data5;        // latch_data5 is used by the 
                                           // MAC5 block
                                     //  to store5 read data if CSTE5 > 0
  output            smc_idle5;          // idle5 state



// Output5 register declarations5

  reg [4:0]    smc_nextstate5;     // SMC5 state machine5 (async5 encoding5)
  reg [4:0]    r_smc_currentstate5;// Synchronised5 SMC5 state machine5
  reg          ws_enable5;         // Wait5 state counter enable
  reg          cste_enable5;       // Chip5 select5 counter enable
  reg          smc_done5;         // Asserted5 during last cycle of access
  reg          valid_access5;      // load5 values are valid if high5
  reg          le_enable5;         // Enable5 all Leading5 Edge5 counters5
  reg          latch_data5;        // latch_data5 is used by the MAC5 block
  reg          smc_idle5;          // idle5 state
  


//----------------------------------------------------------------------
// Main5 code5
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC5 state machine5
//----------------------------------------------------------------------
// Generates5 the required5 timings5 for the External5 Memory Interface5.
// If5 back-to-back accesses are required5 the state machine5 will bypass5
// the idle5 state, thus5 maintaining5 the chip5 select5 ouput5.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate5 internal idle5 signal5 used by AHB5 IF
//----------------------------------------------------------------------

  always @(smc_nextstate5)
  
  begin
   
     if (smc_nextstate5 == `SMC_IDLE5)
     
        smc_idle5 = 1'b1;
   
     else
       
        smc_idle5 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate5 internal done signal5
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate5 or r_cste_count5 or r_ws_count5)
  
  begin
   
     if ( ( (r_smc_currentstate5 == `SMC_RW5) &
            (r_ws_count5 == 8'd0) &
            (r_cste_count5 == 2'd0)
          ) |
          ( (r_smc_currentstate5 == `SMC_FLOAT5)  &
            (r_cste_count5 == 2'd0)
          )
        )
       
        smc_done5 = 1'b1;
   
   else
     
      smc_done5 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data5 is used by the MAC5 block to store5 read data if CSTE5 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate5 or r_ws_count5 or r_oete_store5)
  
  begin
   
     if ( (r_smc_currentstate5 == `SMC_RW5) &
          (r_ws_count5[1:0] >= r_oete_store5) &
          (r_ws_count5[7:2] == 6'd0)
        )
     
       latch_data5 = 1'b1;
   
     else
       
       latch_data5 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter5 enable signals5
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate5 or r_csle_count5 or
       smc_nextstate5 or valid_access5)
  begin
     if(valid_access5)
     begin
        if ((smc_nextstate5 == `SMC_RW5)         &
            (r_smc_currentstate5 != `SMC_STORE5) &
            (r_smc_currentstate5 != `SMC_LE5))
  
          ws_enable5 = 1'b1;
  
        else
  
          ws_enable5 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate5 == `SMC_RW5) & 
            (r_csle_count5 == 2'd0) & 
            (r_smc_currentstate5 != `SMC_STORE5) &
            (r_smc_currentstate5 != `SMC_LE5))

           ws_enable5 = 1'b1;
   
        else
  
           ws_enable5 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable5
//----------------------------------------------------------------------

  always @(r_smc_currentstate5 or smc_nextstate5)
  
  begin
  
     if (((smc_nextstate5 == `SMC_LE5) | (smc_nextstate5 == `SMC_RW5) ) &
         (r_smc_currentstate5 != `SMC_STORE5) )
  
        le_enable5 = 1'b1;
  
     else
  
        le_enable5 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable5
//----------------------------------------------------------------------
  
  always @(smc_nextstate5)
  
  begin
     if (smc_nextstate5 == `SMC_FLOAT5)
    
        cste_enable5 = 1'b1;
   
     else
  
        cste_enable5 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH5 if new cycle is waiting5 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate5 or new_access5 or r_ws_count5 or
                                     smc_nextstate5 or mac_done5)
  
  begin
     
     if (new_access5 & mac_done5 &
         (((r_smc_currentstate5 == `SMC_RW5) & 
           (smc_nextstate5 == `SMC_RW5) & 
           (r_ws_count5 == 8'd0))                                |
          ((r_smc_currentstate5 == `SMC_FLOAT5) & 
           (smc_nextstate5 == `SMC_IDLE5) ) |
          ((r_smc_currentstate5 == `SMC_FLOAT5) & 
           (smc_nextstate5 == `SMC_LE5)   ) |
          ((r_smc_currentstate5 == `SMC_FLOAT5) & 
           (smc_nextstate5 == `SMC_RW5)   ) |
          ((r_smc_currentstate5 == `SMC_FLOAT5) & 
           (smc_nextstate5 == `SMC_STORE5)) |
          ((r_smc_currentstate5 == `SMC_RW5)    & 
           (smc_nextstate5 == `SMC_STORE5)) |
          ((r_smc_currentstate5 == `SMC_RW5)    & 
           (smc_nextstate5 == `SMC_IDLE5) ) |
          ((r_smc_currentstate5 == `SMC_RW5)    & 
           (smc_nextstate5 == `SMC_LE5)   ) |
          ((r_smc_currentstate5 == `SMC_IDLE5) ) )  )    
       
       valid_access5 = 1'b1;
     
     else
       
       valid_access5 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC5 State5 Machine5
//----------------------------------------------------------------------

 always @(r_smc_currentstate5 or new_access5 or 
          cs or r_csle_count5 or r_cste_count5 or r_ws_count5 or mac_done5 
          or r_cs5 or n_read5 or n_r_read5 or r_csle_store5)
  begin
   
   case (r_smc_currentstate5)
  
     `SMC_IDLE5 :
  
        if (new_access5 )
 
           smc_nextstate5 = `SMC_STORE5;
  
        else
  
        begin
  
  
           begin

              if (new_access5 )
  
                 smc_nextstate5 = `SMC_RW5;

              else
  
                 smc_nextstate5 = `SMC_IDLE5;

           end
          
        end

     `SMC_STORE5   :

        if ((r_csle_count5 != 2'd0))

           smc_nextstate5 = `SMC_LE5;

        else

        begin
           
           if ( (r_csle_count5 == 2'd0))

              smc_nextstate5 = `SMC_RW5;
           
           else
             
              smc_nextstate5 = `SMC_STORE5;

        end      

     `SMC_LE5   :
  
        if (r_csle_count5 < 2'd2)
  
           smc_nextstate5 = `SMC_RW5;
  
        else
  
           smc_nextstate5 = `SMC_LE5;
  
     `SMC_RW5   :
  
     begin
          
        if ((r_ws_count5 == 8'd0) & 
            (r_cste_count5 != 2'd0))
  
           smc_nextstate5 = `SMC_FLOAT5;
          
        else if ((r_ws_count5 == 8'd0) &
                 (r_cste_count5 == 2'h0) &
                 mac_done5 & ~new_access5)

           smc_nextstate5 = `SMC_IDLE5;
          
        else if ((~mac_done5 & (r_csle_store5 != 2'd0)) &
                 (r_ws_count5 == 8'd0))
 
           smc_nextstate5 = `SMC_LE5;

        
        else
          
        begin
  
           if  ( ((n_read5 != n_r_read5) | ((cs != r_cs5) & ~n_r_read5)) & 
                  new_access5 & mac_done5 &
                 (r_ws_count5 == 8'd0))   
             
              smc_nextstate5 = `SMC_STORE5;
           
           else
             
              smc_nextstate5 = `SMC_RW5;
           
        end
        
     end
  
     `SMC_FLOAT5   :
        if (~ mac_done5                               & 
            (( & new_access5) | 
             ((r_csle_store5 == 2'd0)            &
              ~new_access5)) &  (r_cste_count5 == 2'd0) )
  
           smc_nextstate5 = `SMC_RW5;
  
        else if (new_access5                              & 
                 (( new_access5) |
                  ((r_csle_store5 == 2'd0)            & 
                   ~new_access5)) & (r_cste_count5 == 2'd0) )

        begin
  
           if  (((n_read5 != n_r_read5) | ((cs != r_cs5) & ~n_r_read5)))   
  
              smc_nextstate5 = `SMC_STORE5;
  
           else
  
              smc_nextstate5 = `SMC_RW5;
  
        end
     
        else
          
        begin
  
           if ((~mac_done5 & (r_csle_store5 != 2'd0)) & 
               (r_cste_count5 < 2'd1))
  
              smc_nextstate5 = `SMC_LE5;

           
           else
             
           begin
           
              if (r_cste_count5 == 2'd0)
             
                 smc_nextstate5 = `SMC_IDLE5;
           
              else
  
                 smc_nextstate5 = `SMC_FLOAT5;
  
           end
           
        end
     
     default   :
       
       smc_nextstate5 = `SMC_IDLE5;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential5 process of state machine5
//----------------------------------------------------------------------

  always @(posedge sys_clk5 or negedge n_sys_reset5)
  
  begin
  
     if (~n_sys_reset5)
  
        r_smc_currentstate5 <= `SMC_IDLE5;
  
  
     else   
       
        r_smc_currentstate5 <= smc_nextstate5;
  
  
  end

   

   
endmodule


