//File15 name   : smc_state_lite15.v
//Title15       : 
//Created15     : 1999
//
//Description15 : SMC15 State15 Machine15
//            : Static15 Memory Controller15
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

`include "smc_defs_lite15.v"

//state machine15 for smc15
  module smc_state_lite15  (
                     //inputs15
  
                     sys_clk15,
                     n_sys_reset15,
                     new_access15,
                     r_cste_count15,
                     r_csle_count15,
                     r_ws_count15,
                     mac_done15,
                     n_read15,
                     n_r_read15,
                     r_csle_store15,
                     r_oete_store15,
                     cs,
                     r_cs15,
             
                     //outputs15
  
                     r_smc_currentstate15,
                     smc_nextstate15,
                     cste_enable15,
                     ws_enable15,
                     smc_done15,
                     valid_access15,
                     le_enable15,
                     latch_data15,
                     smc_idle15);
   
   
   
//Parameters15  -  Values15 in smc_defs15.v



// I15/O15

  input            sys_clk15;           // AHB15 System15 clock15
  input            n_sys_reset15;       // AHB15 System15 reset (Active15 LOW15)
  input            new_access15;        // New15 AHB15 valid access to smc15 
                                          // detected
  input [1:0]      r_cste_count15;      // Chip15 select15 TE15 counter
  input [1:0]      r_csle_count15;      // chip15 select15 leading15 edge count
  input [7:0]      r_ws_count15; // wait state count
  input            mac_done15;          // All cycles15 in a multiple access
  input            n_read15;            // Active15 low15 read signal15
  input            n_r_read15;          // Store15 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store15;      // Chip15 select15 LE15 store15
  input [1:0]      r_oete_store15;      // Read strobe15 TE15 end time before CS15
  input       cs;        // chip15 selects15
  input       r_cs15;      // registered chip15 selects15

  output [4:0]      r_smc_currentstate15;// Synchronised15 SMC15 state machine15
  output [4:0]      smc_nextstate15;     // State15 Machine15 
  output            cste_enable15;       // Enable15 CS15 Trailing15 Edge15 counter
  output            ws_enable15;         // Wait15 state counter enable
  output            smc_done15;          // one access completed
  output            valid_access15;      // load15 values are valid if high15
  output            le_enable15;         // Enable15 all Leading15 Edge15 
                                           // counters15
  output            latch_data15;        // latch_data15 is used by the 
                                           // MAC15 block
                                     //  to store15 read data if CSTE15 > 0
  output            smc_idle15;          // idle15 state



// Output15 register declarations15

  reg [4:0]    smc_nextstate15;     // SMC15 state machine15 (async15 encoding15)
  reg [4:0]    r_smc_currentstate15;// Synchronised15 SMC15 state machine15
  reg          ws_enable15;         // Wait15 state counter enable
  reg          cste_enable15;       // Chip15 select15 counter enable
  reg          smc_done15;         // Asserted15 during last cycle of access
  reg          valid_access15;      // load15 values are valid if high15
  reg          le_enable15;         // Enable15 all Leading15 Edge15 counters15
  reg          latch_data15;        // latch_data15 is used by the MAC15 block
  reg          smc_idle15;          // idle15 state
  


//----------------------------------------------------------------------
// Main15 code15
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC15 state machine15
//----------------------------------------------------------------------
// Generates15 the required15 timings15 for the External15 Memory Interface15.
// If15 back-to-back accesses are required15 the state machine15 will bypass15
// the idle15 state, thus15 maintaining15 the chip15 select15 ouput15.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate15 internal idle15 signal15 used by AHB15 IF
//----------------------------------------------------------------------

  always @(smc_nextstate15)
  
  begin
   
     if (smc_nextstate15 == `SMC_IDLE15)
     
        smc_idle15 = 1'b1;
   
     else
       
        smc_idle15 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate15 internal done signal15
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate15 or r_cste_count15 or r_ws_count15)
  
  begin
   
     if ( ( (r_smc_currentstate15 == `SMC_RW15) &
            (r_ws_count15 == 8'd0) &
            (r_cste_count15 == 2'd0)
          ) |
          ( (r_smc_currentstate15 == `SMC_FLOAT15)  &
            (r_cste_count15 == 2'd0)
          )
        )
       
        smc_done15 = 1'b1;
   
   else
     
      smc_done15 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data15 is used by the MAC15 block to store15 read data if CSTE15 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate15 or r_ws_count15 or r_oete_store15)
  
  begin
   
     if ( (r_smc_currentstate15 == `SMC_RW15) &
          (r_ws_count15[1:0] >= r_oete_store15) &
          (r_ws_count15[7:2] == 6'd0)
        )
     
       latch_data15 = 1'b1;
   
     else
       
       latch_data15 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter15 enable signals15
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate15 or r_csle_count15 or
       smc_nextstate15 or valid_access15)
  begin
     if(valid_access15)
     begin
        if ((smc_nextstate15 == `SMC_RW15)         &
            (r_smc_currentstate15 != `SMC_STORE15) &
            (r_smc_currentstate15 != `SMC_LE15))
  
          ws_enable15 = 1'b1;
  
        else
  
          ws_enable15 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate15 == `SMC_RW15) & 
            (r_csle_count15 == 2'd0) & 
            (r_smc_currentstate15 != `SMC_STORE15) &
            (r_smc_currentstate15 != `SMC_LE15))

           ws_enable15 = 1'b1;
   
        else
  
           ws_enable15 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable15
//----------------------------------------------------------------------

  always @(r_smc_currentstate15 or smc_nextstate15)
  
  begin
  
     if (((smc_nextstate15 == `SMC_LE15) | (smc_nextstate15 == `SMC_RW15) ) &
         (r_smc_currentstate15 != `SMC_STORE15) )
  
        le_enable15 = 1'b1;
  
     else
  
        le_enable15 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable15
//----------------------------------------------------------------------
  
  always @(smc_nextstate15)
  
  begin
     if (smc_nextstate15 == `SMC_FLOAT15)
    
        cste_enable15 = 1'b1;
   
     else
  
        cste_enable15 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH15 if new cycle is waiting15 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate15 or new_access15 or r_ws_count15 or
                                     smc_nextstate15 or mac_done15)
  
  begin
     
     if (new_access15 & mac_done15 &
         (((r_smc_currentstate15 == `SMC_RW15) & 
           (smc_nextstate15 == `SMC_RW15) & 
           (r_ws_count15 == 8'd0))                                |
          ((r_smc_currentstate15 == `SMC_FLOAT15) & 
           (smc_nextstate15 == `SMC_IDLE15) ) |
          ((r_smc_currentstate15 == `SMC_FLOAT15) & 
           (smc_nextstate15 == `SMC_LE15)   ) |
          ((r_smc_currentstate15 == `SMC_FLOAT15) & 
           (smc_nextstate15 == `SMC_RW15)   ) |
          ((r_smc_currentstate15 == `SMC_FLOAT15) & 
           (smc_nextstate15 == `SMC_STORE15)) |
          ((r_smc_currentstate15 == `SMC_RW15)    & 
           (smc_nextstate15 == `SMC_STORE15)) |
          ((r_smc_currentstate15 == `SMC_RW15)    & 
           (smc_nextstate15 == `SMC_IDLE15) ) |
          ((r_smc_currentstate15 == `SMC_RW15)    & 
           (smc_nextstate15 == `SMC_LE15)   ) |
          ((r_smc_currentstate15 == `SMC_IDLE15) ) )  )    
       
       valid_access15 = 1'b1;
     
     else
       
       valid_access15 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC15 State15 Machine15
//----------------------------------------------------------------------

 always @(r_smc_currentstate15 or new_access15 or 
          cs or r_csle_count15 or r_cste_count15 or r_ws_count15 or mac_done15 
          or r_cs15 or n_read15 or n_r_read15 or r_csle_store15)
  begin
   
   case (r_smc_currentstate15)
  
     `SMC_IDLE15 :
  
        if (new_access15 )
 
           smc_nextstate15 = `SMC_STORE15;
  
        else
  
        begin
  
  
           begin

              if (new_access15 )
  
                 smc_nextstate15 = `SMC_RW15;

              else
  
                 smc_nextstate15 = `SMC_IDLE15;

           end
          
        end

     `SMC_STORE15   :

        if ((r_csle_count15 != 2'd0))

           smc_nextstate15 = `SMC_LE15;

        else

        begin
           
           if ( (r_csle_count15 == 2'd0))

              smc_nextstate15 = `SMC_RW15;
           
           else
             
              smc_nextstate15 = `SMC_STORE15;

        end      

     `SMC_LE15   :
  
        if (r_csle_count15 < 2'd2)
  
           smc_nextstate15 = `SMC_RW15;
  
        else
  
           smc_nextstate15 = `SMC_LE15;
  
     `SMC_RW15   :
  
     begin
          
        if ((r_ws_count15 == 8'd0) & 
            (r_cste_count15 != 2'd0))
  
           smc_nextstate15 = `SMC_FLOAT15;
          
        else if ((r_ws_count15 == 8'd0) &
                 (r_cste_count15 == 2'h0) &
                 mac_done15 & ~new_access15)

           smc_nextstate15 = `SMC_IDLE15;
          
        else if ((~mac_done15 & (r_csle_store15 != 2'd0)) &
                 (r_ws_count15 == 8'd0))
 
           smc_nextstate15 = `SMC_LE15;

        
        else
          
        begin
  
           if  ( ((n_read15 != n_r_read15) | ((cs != r_cs15) & ~n_r_read15)) & 
                  new_access15 & mac_done15 &
                 (r_ws_count15 == 8'd0))   
             
              smc_nextstate15 = `SMC_STORE15;
           
           else
             
              smc_nextstate15 = `SMC_RW15;
           
        end
        
     end
  
     `SMC_FLOAT15   :
        if (~ mac_done15                               & 
            (( & new_access15) | 
             ((r_csle_store15 == 2'd0)            &
              ~new_access15)) &  (r_cste_count15 == 2'd0) )
  
           smc_nextstate15 = `SMC_RW15;
  
        else if (new_access15                              & 
                 (( new_access15) |
                  ((r_csle_store15 == 2'd0)            & 
                   ~new_access15)) & (r_cste_count15 == 2'd0) )

        begin
  
           if  (((n_read15 != n_r_read15) | ((cs != r_cs15) & ~n_r_read15)))   
  
              smc_nextstate15 = `SMC_STORE15;
  
           else
  
              smc_nextstate15 = `SMC_RW15;
  
        end
     
        else
          
        begin
  
           if ((~mac_done15 & (r_csle_store15 != 2'd0)) & 
               (r_cste_count15 < 2'd1))
  
              smc_nextstate15 = `SMC_LE15;

           
           else
             
           begin
           
              if (r_cste_count15 == 2'd0)
             
                 smc_nextstate15 = `SMC_IDLE15;
           
              else
  
                 smc_nextstate15 = `SMC_FLOAT15;
  
           end
           
        end
     
     default   :
       
       smc_nextstate15 = `SMC_IDLE15;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential15 process of state machine15
//----------------------------------------------------------------------

  always @(posedge sys_clk15 or negedge n_sys_reset15)
  
  begin
  
     if (~n_sys_reset15)
  
        r_smc_currentstate15 <= `SMC_IDLE15;
  
  
     else   
       
        r_smc_currentstate15 <= smc_nextstate15;
  
  
  end

   

   
endmodule


