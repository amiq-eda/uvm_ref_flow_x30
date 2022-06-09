//File25 name   : smc_state_lite25.v
//Title25       : 
//Created25     : 1999
//
//Description25 : SMC25 State25 Machine25
//            : Static25 Memory Controller25
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

`include "smc_defs_lite25.v"

//state machine25 for smc25
  module smc_state_lite25  (
                     //inputs25
  
                     sys_clk25,
                     n_sys_reset25,
                     new_access25,
                     r_cste_count25,
                     r_csle_count25,
                     r_ws_count25,
                     mac_done25,
                     n_read25,
                     n_r_read25,
                     r_csle_store25,
                     r_oete_store25,
                     cs,
                     r_cs25,
             
                     //outputs25
  
                     r_smc_currentstate25,
                     smc_nextstate25,
                     cste_enable25,
                     ws_enable25,
                     smc_done25,
                     valid_access25,
                     le_enable25,
                     latch_data25,
                     smc_idle25);
   
   
   
//Parameters25  -  Values25 in smc_defs25.v



// I25/O25

  input            sys_clk25;           // AHB25 System25 clock25
  input            n_sys_reset25;       // AHB25 System25 reset (Active25 LOW25)
  input            new_access25;        // New25 AHB25 valid access to smc25 
                                          // detected
  input [1:0]      r_cste_count25;      // Chip25 select25 TE25 counter
  input [1:0]      r_csle_count25;      // chip25 select25 leading25 edge count
  input [7:0]      r_ws_count25; // wait state count
  input            mac_done25;          // All cycles25 in a multiple access
  input            n_read25;            // Active25 low25 read signal25
  input            n_r_read25;          // Store25 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store25;      // Chip25 select25 LE25 store25
  input [1:0]      r_oete_store25;      // Read strobe25 TE25 end time before CS25
  input       cs;        // chip25 selects25
  input       r_cs25;      // registered chip25 selects25

  output [4:0]      r_smc_currentstate25;// Synchronised25 SMC25 state machine25
  output [4:0]      smc_nextstate25;     // State25 Machine25 
  output            cste_enable25;       // Enable25 CS25 Trailing25 Edge25 counter
  output            ws_enable25;         // Wait25 state counter enable
  output            smc_done25;          // one access completed
  output            valid_access25;      // load25 values are valid if high25
  output            le_enable25;         // Enable25 all Leading25 Edge25 
                                           // counters25
  output            latch_data25;        // latch_data25 is used by the 
                                           // MAC25 block
                                     //  to store25 read data if CSTE25 > 0
  output            smc_idle25;          // idle25 state



// Output25 register declarations25

  reg [4:0]    smc_nextstate25;     // SMC25 state machine25 (async25 encoding25)
  reg [4:0]    r_smc_currentstate25;// Synchronised25 SMC25 state machine25
  reg          ws_enable25;         // Wait25 state counter enable
  reg          cste_enable25;       // Chip25 select25 counter enable
  reg          smc_done25;         // Asserted25 during last cycle of access
  reg          valid_access25;      // load25 values are valid if high25
  reg          le_enable25;         // Enable25 all Leading25 Edge25 counters25
  reg          latch_data25;        // latch_data25 is used by the MAC25 block
  reg          smc_idle25;          // idle25 state
  


//----------------------------------------------------------------------
// Main25 code25
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC25 state machine25
//----------------------------------------------------------------------
// Generates25 the required25 timings25 for the External25 Memory Interface25.
// If25 back-to-back accesses are required25 the state machine25 will bypass25
// the idle25 state, thus25 maintaining25 the chip25 select25 ouput25.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate25 internal idle25 signal25 used by AHB25 IF
//----------------------------------------------------------------------

  always @(smc_nextstate25)
  
  begin
   
     if (smc_nextstate25 == `SMC_IDLE25)
     
        smc_idle25 = 1'b1;
   
     else
       
        smc_idle25 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate25 internal done signal25
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate25 or r_cste_count25 or r_ws_count25)
  
  begin
   
     if ( ( (r_smc_currentstate25 == `SMC_RW25) &
            (r_ws_count25 == 8'd0) &
            (r_cste_count25 == 2'd0)
          ) |
          ( (r_smc_currentstate25 == `SMC_FLOAT25)  &
            (r_cste_count25 == 2'd0)
          )
        )
       
        smc_done25 = 1'b1;
   
   else
     
      smc_done25 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data25 is used by the MAC25 block to store25 read data if CSTE25 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate25 or r_ws_count25 or r_oete_store25)
  
  begin
   
     if ( (r_smc_currentstate25 == `SMC_RW25) &
          (r_ws_count25[1:0] >= r_oete_store25) &
          (r_ws_count25[7:2] == 6'd0)
        )
     
       latch_data25 = 1'b1;
   
     else
       
       latch_data25 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter25 enable signals25
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate25 or r_csle_count25 or
       smc_nextstate25 or valid_access25)
  begin
     if(valid_access25)
     begin
        if ((smc_nextstate25 == `SMC_RW25)         &
            (r_smc_currentstate25 != `SMC_STORE25) &
            (r_smc_currentstate25 != `SMC_LE25))
  
          ws_enable25 = 1'b1;
  
        else
  
          ws_enable25 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate25 == `SMC_RW25) & 
            (r_csle_count25 == 2'd0) & 
            (r_smc_currentstate25 != `SMC_STORE25) &
            (r_smc_currentstate25 != `SMC_LE25))

           ws_enable25 = 1'b1;
   
        else
  
           ws_enable25 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable25
//----------------------------------------------------------------------

  always @(r_smc_currentstate25 or smc_nextstate25)
  
  begin
  
     if (((smc_nextstate25 == `SMC_LE25) | (smc_nextstate25 == `SMC_RW25) ) &
         (r_smc_currentstate25 != `SMC_STORE25) )
  
        le_enable25 = 1'b1;
  
     else
  
        le_enable25 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable25
//----------------------------------------------------------------------
  
  always @(smc_nextstate25)
  
  begin
     if (smc_nextstate25 == `SMC_FLOAT25)
    
        cste_enable25 = 1'b1;
   
     else
  
        cste_enable25 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH25 if new cycle is waiting25 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate25 or new_access25 or r_ws_count25 or
                                     smc_nextstate25 or mac_done25)
  
  begin
     
     if (new_access25 & mac_done25 &
         (((r_smc_currentstate25 == `SMC_RW25) & 
           (smc_nextstate25 == `SMC_RW25) & 
           (r_ws_count25 == 8'd0))                                |
          ((r_smc_currentstate25 == `SMC_FLOAT25) & 
           (smc_nextstate25 == `SMC_IDLE25) ) |
          ((r_smc_currentstate25 == `SMC_FLOAT25) & 
           (smc_nextstate25 == `SMC_LE25)   ) |
          ((r_smc_currentstate25 == `SMC_FLOAT25) & 
           (smc_nextstate25 == `SMC_RW25)   ) |
          ((r_smc_currentstate25 == `SMC_FLOAT25) & 
           (smc_nextstate25 == `SMC_STORE25)) |
          ((r_smc_currentstate25 == `SMC_RW25)    & 
           (smc_nextstate25 == `SMC_STORE25)) |
          ((r_smc_currentstate25 == `SMC_RW25)    & 
           (smc_nextstate25 == `SMC_IDLE25) ) |
          ((r_smc_currentstate25 == `SMC_RW25)    & 
           (smc_nextstate25 == `SMC_LE25)   ) |
          ((r_smc_currentstate25 == `SMC_IDLE25) ) )  )    
       
       valid_access25 = 1'b1;
     
     else
       
       valid_access25 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC25 State25 Machine25
//----------------------------------------------------------------------

 always @(r_smc_currentstate25 or new_access25 or 
          cs or r_csle_count25 or r_cste_count25 or r_ws_count25 or mac_done25 
          or r_cs25 or n_read25 or n_r_read25 or r_csle_store25)
  begin
   
   case (r_smc_currentstate25)
  
     `SMC_IDLE25 :
  
        if (new_access25 )
 
           smc_nextstate25 = `SMC_STORE25;
  
        else
  
        begin
  
  
           begin

              if (new_access25 )
  
                 smc_nextstate25 = `SMC_RW25;

              else
  
                 smc_nextstate25 = `SMC_IDLE25;

           end
          
        end

     `SMC_STORE25   :

        if ((r_csle_count25 != 2'd0))

           smc_nextstate25 = `SMC_LE25;

        else

        begin
           
           if ( (r_csle_count25 == 2'd0))

              smc_nextstate25 = `SMC_RW25;
           
           else
             
              smc_nextstate25 = `SMC_STORE25;

        end      

     `SMC_LE25   :
  
        if (r_csle_count25 < 2'd2)
  
           smc_nextstate25 = `SMC_RW25;
  
        else
  
           smc_nextstate25 = `SMC_LE25;
  
     `SMC_RW25   :
  
     begin
          
        if ((r_ws_count25 == 8'd0) & 
            (r_cste_count25 != 2'd0))
  
           smc_nextstate25 = `SMC_FLOAT25;
          
        else if ((r_ws_count25 == 8'd0) &
                 (r_cste_count25 == 2'h0) &
                 mac_done25 & ~new_access25)

           smc_nextstate25 = `SMC_IDLE25;
          
        else if ((~mac_done25 & (r_csle_store25 != 2'd0)) &
                 (r_ws_count25 == 8'd0))
 
           smc_nextstate25 = `SMC_LE25;

        
        else
          
        begin
  
           if  ( ((n_read25 != n_r_read25) | ((cs != r_cs25) & ~n_r_read25)) & 
                  new_access25 & mac_done25 &
                 (r_ws_count25 == 8'd0))   
             
              smc_nextstate25 = `SMC_STORE25;
           
           else
             
              smc_nextstate25 = `SMC_RW25;
           
        end
        
     end
  
     `SMC_FLOAT25   :
        if (~ mac_done25                               & 
            (( & new_access25) | 
             ((r_csle_store25 == 2'd0)            &
              ~new_access25)) &  (r_cste_count25 == 2'd0) )
  
           smc_nextstate25 = `SMC_RW25;
  
        else if (new_access25                              & 
                 (( new_access25) |
                  ((r_csle_store25 == 2'd0)            & 
                   ~new_access25)) & (r_cste_count25 == 2'd0) )

        begin
  
           if  (((n_read25 != n_r_read25) | ((cs != r_cs25) & ~n_r_read25)))   
  
              smc_nextstate25 = `SMC_STORE25;
  
           else
  
              smc_nextstate25 = `SMC_RW25;
  
        end
     
        else
          
        begin
  
           if ((~mac_done25 & (r_csle_store25 != 2'd0)) & 
               (r_cste_count25 < 2'd1))
  
              smc_nextstate25 = `SMC_LE25;

           
           else
             
           begin
           
              if (r_cste_count25 == 2'd0)
             
                 smc_nextstate25 = `SMC_IDLE25;
           
              else
  
                 smc_nextstate25 = `SMC_FLOAT25;
  
           end
           
        end
     
     default   :
       
       smc_nextstate25 = `SMC_IDLE25;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential25 process of state machine25
//----------------------------------------------------------------------

  always @(posedge sys_clk25 or negedge n_sys_reset25)
  
  begin
  
     if (~n_sys_reset25)
  
        r_smc_currentstate25 <= `SMC_IDLE25;
  
  
     else   
       
        r_smc_currentstate25 <= smc_nextstate25;
  
  
  end

   

   
endmodule


