//File16 name   : smc_state_lite16.v
//Title16       : 
//Created16     : 1999
//
//Description16 : SMC16 State16 Machine16
//            : Static16 Memory Controller16
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

`include "smc_defs_lite16.v"

//state machine16 for smc16
  module smc_state_lite16  (
                     //inputs16
  
                     sys_clk16,
                     n_sys_reset16,
                     new_access16,
                     r_cste_count16,
                     r_csle_count16,
                     r_ws_count16,
                     mac_done16,
                     n_read16,
                     n_r_read16,
                     r_csle_store16,
                     r_oete_store16,
                     cs,
                     r_cs16,
             
                     //outputs16
  
                     r_smc_currentstate16,
                     smc_nextstate16,
                     cste_enable16,
                     ws_enable16,
                     smc_done16,
                     valid_access16,
                     le_enable16,
                     latch_data16,
                     smc_idle16);
   
   
   
//Parameters16  -  Values16 in smc_defs16.v



// I16/O16

  input            sys_clk16;           // AHB16 System16 clock16
  input            n_sys_reset16;       // AHB16 System16 reset (Active16 LOW16)
  input            new_access16;        // New16 AHB16 valid access to smc16 
                                          // detected
  input [1:0]      r_cste_count16;      // Chip16 select16 TE16 counter
  input [1:0]      r_csle_count16;      // chip16 select16 leading16 edge count
  input [7:0]      r_ws_count16; // wait state count
  input            mac_done16;          // All cycles16 in a multiple access
  input            n_read16;            // Active16 low16 read signal16
  input            n_r_read16;          // Store16 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store16;      // Chip16 select16 LE16 store16
  input [1:0]      r_oete_store16;      // Read strobe16 TE16 end time before CS16
  input       cs;        // chip16 selects16
  input       r_cs16;      // registered chip16 selects16

  output [4:0]      r_smc_currentstate16;// Synchronised16 SMC16 state machine16
  output [4:0]      smc_nextstate16;     // State16 Machine16 
  output            cste_enable16;       // Enable16 CS16 Trailing16 Edge16 counter
  output            ws_enable16;         // Wait16 state counter enable
  output            smc_done16;          // one access completed
  output            valid_access16;      // load16 values are valid if high16
  output            le_enable16;         // Enable16 all Leading16 Edge16 
                                           // counters16
  output            latch_data16;        // latch_data16 is used by the 
                                           // MAC16 block
                                     //  to store16 read data if CSTE16 > 0
  output            smc_idle16;          // idle16 state



// Output16 register declarations16

  reg [4:0]    smc_nextstate16;     // SMC16 state machine16 (async16 encoding16)
  reg [4:0]    r_smc_currentstate16;// Synchronised16 SMC16 state machine16
  reg          ws_enable16;         // Wait16 state counter enable
  reg          cste_enable16;       // Chip16 select16 counter enable
  reg          smc_done16;         // Asserted16 during last cycle of access
  reg          valid_access16;      // load16 values are valid if high16
  reg          le_enable16;         // Enable16 all Leading16 Edge16 counters16
  reg          latch_data16;        // latch_data16 is used by the MAC16 block
  reg          smc_idle16;          // idle16 state
  


//----------------------------------------------------------------------
// Main16 code16
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC16 state machine16
//----------------------------------------------------------------------
// Generates16 the required16 timings16 for the External16 Memory Interface16.
// If16 back-to-back accesses are required16 the state machine16 will bypass16
// the idle16 state, thus16 maintaining16 the chip16 select16 ouput16.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate16 internal idle16 signal16 used by AHB16 IF
//----------------------------------------------------------------------

  always @(smc_nextstate16)
  
  begin
   
     if (smc_nextstate16 == `SMC_IDLE16)
     
        smc_idle16 = 1'b1;
   
     else
       
        smc_idle16 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate16 internal done signal16
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate16 or r_cste_count16 or r_ws_count16)
  
  begin
   
     if ( ( (r_smc_currentstate16 == `SMC_RW16) &
            (r_ws_count16 == 8'd0) &
            (r_cste_count16 == 2'd0)
          ) |
          ( (r_smc_currentstate16 == `SMC_FLOAT16)  &
            (r_cste_count16 == 2'd0)
          )
        )
       
        smc_done16 = 1'b1;
   
   else
     
      smc_done16 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data16 is used by the MAC16 block to store16 read data if CSTE16 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate16 or r_ws_count16 or r_oete_store16)
  
  begin
   
     if ( (r_smc_currentstate16 == `SMC_RW16) &
          (r_ws_count16[1:0] >= r_oete_store16) &
          (r_ws_count16[7:2] == 6'd0)
        )
     
       latch_data16 = 1'b1;
   
     else
       
       latch_data16 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter16 enable signals16
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate16 or r_csle_count16 or
       smc_nextstate16 or valid_access16)
  begin
     if(valid_access16)
     begin
        if ((smc_nextstate16 == `SMC_RW16)         &
            (r_smc_currentstate16 != `SMC_STORE16) &
            (r_smc_currentstate16 != `SMC_LE16))
  
          ws_enable16 = 1'b1;
  
        else
  
          ws_enable16 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate16 == `SMC_RW16) & 
            (r_csle_count16 == 2'd0) & 
            (r_smc_currentstate16 != `SMC_STORE16) &
            (r_smc_currentstate16 != `SMC_LE16))

           ws_enable16 = 1'b1;
   
        else
  
           ws_enable16 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable16
//----------------------------------------------------------------------

  always @(r_smc_currentstate16 or smc_nextstate16)
  
  begin
  
     if (((smc_nextstate16 == `SMC_LE16) | (smc_nextstate16 == `SMC_RW16) ) &
         (r_smc_currentstate16 != `SMC_STORE16) )
  
        le_enable16 = 1'b1;
  
     else
  
        le_enable16 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable16
//----------------------------------------------------------------------
  
  always @(smc_nextstate16)
  
  begin
     if (smc_nextstate16 == `SMC_FLOAT16)
    
        cste_enable16 = 1'b1;
   
     else
  
        cste_enable16 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH16 if new cycle is waiting16 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate16 or new_access16 or r_ws_count16 or
                                     smc_nextstate16 or mac_done16)
  
  begin
     
     if (new_access16 & mac_done16 &
         (((r_smc_currentstate16 == `SMC_RW16) & 
           (smc_nextstate16 == `SMC_RW16) & 
           (r_ws_count16 == 8'd0))                                |
          ((r_smc_currentstate16 == `SMC_FLOAT16) & 
           (smc_nextstate16 == `SMC_IDLE16) ) |
          ((r_smc_currentstate16 == `SMC_FLOAT16) & 
           (smc_nextstate16 == `SMC_LE16)   ) |
          ((r_smc_currentstate16 == `SMC_FLOAT16) & 
           (smc_nextstate16 == `SMC_RW16)   ) |
          ((r_smc_currentstate16 == `SMC_FLOAT16) & 
           (smc_nextstate16 == `SMC_STORE16)) |
          ((r_smc_currentstate16 == `SMC_RW16)    & 
           (smc_nextstate16 == `SMC_STORE16)) |
          ((r_smc_currentstate16 == `SMC_RW16)    & 
           (smc_nextstate16 == `SMC_IDLE16) ) |
          ((r_smc_currentstate16 == `SMC_RW16)    & 
           (smc_nextstate16 == `SMC_LE16)   ) |
          ((r_smc_currentstate16 == `SMC_IDLE16) ) )  )    
       
       valid_access16 = 1'b1;
     
     else
       
       valid_access16 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC16 State16 Machine16
//----------------------------------------------------------------------

 always @(r_smc_currentstate16 or new_access16 or 
          cs or r_csle_count16 or r_cste_count16 or r_ws_count16 or mac_done16 
          or r_cs16 or n_read16 or n_r_read16 or r_csle_store16)
  begin
   
   case (r_smc_currentstate16)
  
     `SMC_IDLE16 :
  
        if (new_access16 )
 
           smc_nextstate16 = `SMC_STORE16;
  
        else
  
        begin
  
  
           begin

              if (new_access16 )
  
                 smc_nextstate16 = `SMC_RW16;

              else
  
                 smc_nextstate16 = `SMC_IDLE16;

           end
          
        end

     `SMC_STORE16   :

        if ((r_csle_count16 != 2'd0))

           smc_nextstate16 = `SMC_LE16;

        else

        begin
           
           if ( (r_csle_count16 == 2'd0))

              smc_nextstate16 = `SMC_RW16;
           
           else
             
              smc_nextstate16 = `SMC_STORE16;

        end      

     `SMC_LE16   :
  
        if (r_csle_count16 < 2'd2)
  
           smc_nextstate16 = `SMC_RW16;
  
        else
  
           smc_nextstate16 = `SMC_LE16;
  
     `SMC_RW16   :
  
     begin
          
        if ((r_ws_count16 == 8'd0) & 
            (r_cste_count16 != 2'd0))
  
           smc_nextstate16 = `SMC_FLOAT16;
          
        else if ((r_ws_count16 == 8'd0) &
                 (r_cste_count16 == 2'h0) &
                 mac_done16 & ~new_access16)

           smc_nextstate16 = `SMC_IDLE16;
          
        else if ((~mac_done16 & (r_csle_store16 != 2'd0)) &
                 (r_ws_count16 == 8'd0))
 
           smc_nextstate16 = `SMC_LE16;

        
        else
          
        begin
  
           if  ( ((n_read16 != n_r_read16) | ((cs != r_cs16) & ~n_r_read16)) & 
                  new_access16 & mac_done16 &
                 (r_ws_count16 == 8'd0))   
             
              smc_nextstate16 = `SMC_STORE16;
           
           else
             
              smc_nextstate16 = `SMC_RW16;
           
        end
        
     end
  
     `SMC_FLOAT16   :
        if (~ mac_done16                               & 
            (( & new_access16) | 
             ((r_csle_store16 == 2'd0)            &
              ~new_access16)) &  (r_cste_count16 == 2'd0) )
  
           smc_nextstate16 = `SMC_RW16;
  
        else if (new_access16                              & 
                 (( new_access16) |
                  ((r_csle_store16 == 2'd0)            & 
                   ~new_access16)) & (r_cste_count16 == 2'd0) )

        begin
  
           if  (((n_read16 != n_r_read16) | ((cs != r_cs16) & ~n_r_read16)))   
  
              smc_nextstate16 = `SMC_STORE16;
  
           else
  
              smc_nextstate16 = `SMC_RW16;
  
        end
     
        else
          
        begin
  
           if ((~mac_done16 & (r_csle_store16 != 2'd0)) & 
               (r_cste_count16 < 2'd1))
  
              smc_nextstate16 = `SMC_LE16;

           
           else
             
           begin
           
              if (r_cste_count16 == 2'd0)
             
                 smc_nextstate16 = `SMC_IDLE16;
           
              else
  
                 smc_nextstate16 = `SMC_FLOAT16;
  
           end
           
        end
     
     default   :
       
       smc_nextstate16 = `SMC_IDLE16;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential16 process of state machine16
//----------------------------------------------------------------------

  always @(posedge sys_clk16 or negedge n_sys_reset16)
  
  begin
  
     if (~n_sys_reset16)
  
        r_smc_currentstate16 <= `SMC_IDLE16;
  
  
     else   
       
        r_smc_currentstate16 <= smc_nextstate16;
  
  
  end

   

   
endmodule


