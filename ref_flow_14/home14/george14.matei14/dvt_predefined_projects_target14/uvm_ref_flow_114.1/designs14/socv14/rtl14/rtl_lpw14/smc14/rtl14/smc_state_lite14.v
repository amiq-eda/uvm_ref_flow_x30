//File14 name   : smc_state_lite14.v
//Title14       : 
//Created14     : 1999
//
//Description14 : SMC14 State14 Machine14
//            : Static14 Memory Controller14
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

`include "smc_defs_lite14.v"

//state machine14 for smc14
  module smc_state_lite14  (
                     //inputs14
  
                     sys_clk14,
                     n_sys_reset14,
                     new_access14,
                     r_cste_count14,
                     r_csle_count14,
                     r_ws_count14,
                     mac_done14,
                     n_read14,
                     n_r_read14,
                     r_csle_store14,
                     r_oete_store14,
                     cs,
                     r_cs14,
             
                     //outputs14
  
                     r_smc_currentstate14,
                     smc_nextstate14,
                     cste_enable14,
                     ws_enable14,
                     smc_done14,
                     valid_access14,
                     le_enable14,
                     latch_data14,
                     smc_idle14);
   
   
   
//Parameters14  -  Values14 in smc_defs14.v



// I14/O14

  input            sys_clk14;           // AHB14 System14 clock14
  input            n_sys_reset14;       // AHB14 System14 reset (Active14 LOW14)
  input            new_access14;        // New14 AHB14 valid access to smc14 
                                          // detected
  input [1:0]      r_cste_count14;      // Chip14 select14 TE14 counter
  input [1:0]      r_csle_count14;      // chip14 select14 leading14 edge count
  input [7:0]      r_ws_count14; // wait state count
  input            mac_done14;          // All cycles14 in a multiple access
  input            n_read14;            // Active14 low14 read signal14
  input            n_r_read14;          // Store14 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store14;      // Chip14 select14 LE14 store14
  input [1:0]      r_oete_store14;      // Read strobe14 TE14 end time before CS14
  input       cs;        // chip14 selects14
  input       r_cs14;      // registered chip14 selects14

  output [4:0]      r_smc_currentstate14;// Synchronised14 SMC14 state machine14
  output [4:0]      smc_nextstate14;     // State14 Machine14 
  output            cste_enable14;       // Enable14 CS14 Trailing14 Edge14 counter
  output            ws_enable14;         // Wait14 state counter enable
  output            smc_done14;          // one access completed
  output            valid_access14;      // load14 values are valid if high14
  output            le_enable14;         // Enable14 all Leading14 Edge14 
                                           // counters14
  output            latch_data14;        // latch_data14 is used by the 
                                           // MAC14 block
                                     //  to store14 read data if CSTE14 > 0
  output            smc_idle14;          // idle14 state



// Output14 register declarations14

  reg [4:0]    smc_nextstate14;     // SMC14 state machine14 (async14 encoding14)
  reg [4:0]    r_smc_currentstate14;// Synchronised14 SMC14 state machine14
  reg          ws_enable14;         // Wait14 state counter enable
  reg          cste_enable14;       // Chip14 select14 counter enable
  reg          smc_done14;         // Asserted14 during last cycle of access
  reg          valid_access14;      // load14 values are valid if high14
  reg          le_enable14;         // Enable14 all Leading14 Edge14 counters14
  reg          latch_data14;        // latch_data14 is used by the MAC14 block
  reg          smc_idle14;          // idle14 state
  


//----------------------------------------------------------------------
// Main14 code14
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC14 state machine14
//----------------------------------------------------------------------
// Generates14 the required14 timings14 for the External14 Memory Interface14.
// If14 back-to-back accesses are required14 the state machine14 will bypass14
// the idle14 state, thus14 maintaining14 the chip14 select14 ouput14.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate14 internal idle14 signal14 used by AHB14 IF
//----------------------------------------------------------------------

  always @(smc_nextstate14)
  
  begin
   
     if (smc_nextstate14 == `SMC_IDLE14)
     
        smc_idle14 = 1'b1;
   
     else
       
        smc_idle14 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate14 internal done signal14
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate14 or r_cste_count14 or r_ws_count14)
  
  begin
   
     if ( ( (r_smc_currentstate14 == `SMC_RW14) &
            (r_ws_count14 == 8'd0) &
            (r_cste_count14 == 2'd0)
          ) |
          ( (r_smc_currentstate14 == `SMC_FLOAT14)  &
            (r_cste_count14 == 2'd0)
          )
        )
       
        smc_done14 = 1'b1;
   
   else
     
      smc_done14 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data14 is used by the MAC14 block to store14 read data if CSTE14 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate14 or r_ws_count14 or r_oete_store14)
  
  begin
   
     if ( (r_smc_currentstate14 == `SMC_RW14) &
          (r_ws_count14[1:0] >= r_oete_store14) &
          (r_ws_count14[7:2] == 6'd0)
        )
     
       latch_data14 = 1'b1;
   
     else
       
       latch_data14 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter14 enable signals14
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate14 or r_csle_count14 or
       smc_nextstate14 or valid_access14)
  begin
     if(valid_access14)
     begin
        if ((smc_nextstate14 == `SMC_RW14)         &
            (r_smc_currentstate14 != `SMC_STORE14) &
            (r_smc_currentstate14 != `SMC_LE14))
  
          ws_enable14 = 1'b1;
  
        else
  
          ws_enable14 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate14 == `SMC_RW14) & 
            (r_csle_count14 == 2'd0) & 
            (r_smc_currentstate14 != `SMC_STORE14) &
            (r_smc_currentstate14 != `SMC_LE14))

           ws_enable14 = 1'b1;
   
        else
  
           ws_enable14 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable14
//----------------------------------------------------------------------

  always @(r_smc_currentstate14 or smc_nextstate14)
  
  begin
  
     if (((smc_nextstate14 == `SMC_LE14) | (smc_nextstate14 == `SMC_RW14) ) &
         (r_smc_currentstate14 != `SMC_STORE14) )
  
        le_enable14 = 1'b1;
  
     else
  
        le_enable14 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable14
//----------------------------------------------------------------------
  
  always @(smc_nextstate14)
  
  begin
     if (smc_nextstate14 == `SMC_FLOAT14)
    
        cste_enable14 = 1'b1;
   
     else
  
        cste_enable14 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH14 if new cycle is waiting14 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate14 or new_access14 or r_ws_count14 or
                                     smc_nextstate14 or mac_done14)
  
  begin
     
     if (new_access14 & mac_done14 &
         (((r_smc_currentstate14 == `SMC_RW14) & 
           (smc_nextstate14 == `SMC_RW14) & 
           (r_ws_count14 == 8'd0))                                |
          ((r_smc_currentstate14 == `SMC_FLOAT14) & 
           (smc_nextstate14 == `SMC_IDLE14) ) |
          ((r_smc_currentstate14 == `SMC_FLOAT14) & 
           (smc_nextstate14 == `SMC_LE14)   ) |
          ((r_smc_currentstate14 == `SMC_FLOAT14) & 
           (smc_nextstate14 == `SMC_RW14)   ) |
          ((r_smc_currentstate14 == `SMC_FLOAT14) & 
           (smc_nextstate14 == `SMC_STORE14)) |
          ((r_smc_currentstate14 == `SMC_RW14)    & 
           (smc_nextstate14 == `SMC_STORE14)) |
          ((r_smc_currentstate14 == `SMC_RW14)    & 
           (smc_nextstate14 == `SMC_IDLE14) ) |
          ((r_smc_currentstate14 == `SMC_RW14)    & 
           (smc_nextstate14 == `SMC_LE14)   ) |
          ((r_smc_currentstate14 == `SMC_IDLE14) ) )  )    
       
       valid_access14 = 1'b1;
     
     else
       
       valid_access14 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC14 State14 Machine14
//----------------------------------------------------------------------

 always @(r_smc_currentstate14 or new_access14 or 
          cs or r_csle_count14 or r_cste_count14 or r_ws_count14 or mac_done14 
          or r_cs14 or n_read14 or n_r_read14 or r_csle_store14)
  begin
   
   case (r_smc_currentstate14)
  
     `SMC_IDLE14 :
  
        if (new_access14 )
 
           smc_nextstate14 = `SMC_STORE14;
  
        else
  
        begin
  
  
           begin

              if (new_access14 )
  
                 smc_nextstate14 = `SMC_RW14;

              else
  
                 smc_nextstate14 = `SMC_IDLE14;

           end
          
        end

     `SMC_STORE14   :

        if ((r_csle_count14 != 2'd0))

           smc_nextstate14 = `SMC_LE14;

        else

        begin
           
           if ( (r_csle_count14 == 2'd0))

              smc_nextstate14 = `SMC_RW14;
           
           else
             
              smc_nextstate14 = `SMC_STORE14;

        end      

     `SMC_LE14   :
  
        if (r_csle_count14 < 2'd2)
  
           smc_nextstate14 = `SMC_RW14;
  
        else
  
           smc_nextstate14 = `SMC_LE14;
  
     `SMC_RW14   :
  
     begin
          
        if ((r_ws_count14 == 8'd0) & 
            (r_cste_count14 != 2'd0))
  
           smc_nextstate14 = `SMC_FLOAT14;
          
        else if ((r_ws_count14 == 8'd0) &
                 (r_cste_count14 == 2'h0) &
                 mac_done14 & ~new_access14)

           smc_nextstate14 = `SMC_IDLE14;
          
        else if ((~mac_done14 & (r_csle_store14 != 2'd0)) &
                 (r_ws_count14 == 8'd0))
 
           smc_nextstate14 = `SMC_LE14;

        
        else
          
        begin
  
           if  ( ((n_read14 != n_r_read14) | ((cs != r_cs14) & ~n_r_read14)) & 
                  new_access14 & mac_done14 &
                 (r_ws_count14 == 8'd0))   
             
              smc_nextstate14 = `SMC_STORE14;
           
           else
             
              smc_nextstate14 = `SMC_RW14;
           
        end
        
     end
  
     `SMC_FLOAT14   :
        if (~ mac_done14                               & 
            (( & new_access14) | 
             ((r_csle_store14 == 2'd0)            &
              ~new_access14)) &  (r_cste_count14 == 2'd0) )
  
           smc_nextstate14 = `SMC_RW14;
  
        else if (new_access14                              & 
                 (( new_access14) |
                  ((r_csle_store14 == 2'd0)            & 
                   ~new_access14)) & (r_cste_count14 == 2'd0) )

        begin
  
           if  (((n_read14 != n_r_read14) | ((cs != r_cs14) & ~n_r_read14)))   
  
              smc_nextstate14 = `SMC_STORE14;
  
           else
  
              smc_nextstate14 = `SMC_RW14;
  
        end
     
        else
          
        begin
  
           if ((~mac_done14 & (r_csle_store14 != 2'd0)) & 
               (r_cste_count14 < 2'd1))
  
              smc_nextstate14 = `SMC_LE14;

           
           else
             
           begin
           
              if (r_cste_count14 == 2'd0)
             
                 smc_nextstate14 = `SMC_IDLE14;
           
              else
  
                 smc_nextstate14 = `SMC_FLOAT14;
  
           end
           
        end
     
     default   :
       
       smc_nextstate14 = `SMC_IDLE14;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential14 process of state machine14
//----------------------------------------------------------------------

  always @(posedge sys_clk14 or negedge n_sys_reset14)
  
  begin
  
     if (~n_sys_reset14)
  
        r_smc_currentstate14 <= `SMC_IDLE14;
  
  
     else   
       
        r_smc_currentstate14 <= smc_nextstate14;
  
  
  end

   

   
endmodule


