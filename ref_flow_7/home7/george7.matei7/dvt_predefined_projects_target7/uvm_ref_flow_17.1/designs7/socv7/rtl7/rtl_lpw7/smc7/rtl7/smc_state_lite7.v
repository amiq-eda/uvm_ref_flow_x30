//File7 name   : smc_state_lite7.v
//Title7       : 
//Created7     : 1999
//
//Description7 : SMC7 State7 Machine7
//            : Static7 Memory Controller7
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

`include "smc_defs_lite7.v"

//state machine7 for smc7
  module smc_state_lite7  (
                     //inputs7
  
                     sys_clk7,
                     n_sys_reset7,
                     new_access7,
                     r_cste_count7,
                     r_csle_count7,
                     r_ws_count7,
                     mac_done7,
                     n_read7,
                     n_r_read7,
                     r_csle_store7,
                     r_oete_store7,
                     cs,
                     r_cs7,
             
                     //outputs7
  
                     r_smc_currentstate7,
                     smc_nextstate7,
                     cste_enable7,
                     ws_enable7,
                     smc_done7,
                     valid_access7,
                     le_enable7,
                     latch_data7,
                     smc_idle7);
   
   
   
//Parameters7  -  Values7 in smc_defs7.v



// I7/O7

  input            sys_clk7;           // AHB7 System7 clock7
  input            n_sys_reset7;       // AHB7 System7 reset (Active7 LOW7)
  input            new_access7;        // New7 AHB7 valid access to smc7 
                                          // detected
  input [1:0]      r_cste_count7;      // Chip7 select7 TE7 counter
  input [1:0]      r_csle_count7;      // chip7 select7 leading7 edge count
  input [7:0]      r_ws_count7; // wait state count
  input            mac_done7;          // All cycles7 in a multiple access
  input            n_read7;            // Active7 low7 read signal7
  input            n_r_read7;          // Store7 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store7;      // Chip7 select7 LE7 store7
  input [1:0]      r_oete_store7;      // Read strobe7 TE7 end time before CS7
  input       cs;        // chip7 selects7
  input       r_cs7;      // registered chip7 selects7

  output [4:0]      r_smc_currentstate7;// Synchronised7 SMC7 state machine7
  output [4:0]      smc_nextstate7;     // State7 Machine7 
  output            cste_enable7;       // Enable7 CS7 Trailing7 Edge7 counter
  output            ws_enable7;         // Wait7 state counter enable
  output            smc_done7;          // one access completed
  output            valid_access7;      // load7 values are valid if high7
  output            le_enable7;         // Enable7 all Leading7 Edge7 
                                           // counters7
  output            latch_data7;        // latch_data7 is used by the 
                                           // MAC7 block
                                     //  to store7 read data if CSTE7 > 0
  output            smc_idle7;          // idle7 state



// Output7 register declarations7

  reg [4:0]    smc_nextstate7;     // SMC7 state machine7 (async7 encoding7)
  reg [4:0]    r_smc_currentstate7;// Synchronised7 SMC7 state machine7
  reg          ws_enable7;         // Wait7 state counter enable
  reg          cste_enable7;       // Chip7 select7 counter enable
  reg          smc_done7;         // Asserted7 during last cycle of access
  reg          valid_access7;      // load7 values are valid if high7
  reg          le_enable7;         // Enable7 all Leading7 Edge7 counters7
  reg          latch_data7;        // latch_data7 is used by the MAC7 block
  reg          smc_idle7;          // idle7 state
  


//----------------------------------------------------------------------
// Main7 code7
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC7 state machine7
//----------------------------------------------------------------------
// Generates7 the required7 timings7 for the External7 Memory Interface7.
// If7 back-to-back accesses are required7 the state machine7 will bypass7
// the idle7 state, thus7 maintaining7 the chip7 select7 ouput7.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate7 internal idle7 signal7 used by AHB7 IF
//----------------------------------------------------------------------

  always @(smc_nextstate7)
  
  begin
   
     if (smc_nextstate7 == `SMC_IDLE7)
     
        smc_idle7 = 1'b1;
   
     else
       
        smc_idle7 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate7 internal done signal7
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate7 or r_cste_count7 or r_ws_count7)
  
  begin
   
     if ( ( (r_smc_currentstate7 == `SMC_RW7) &
            (r_ws_count7 == 8'd0) &
            (r_cste_count7 == 2'd0)
          ) |
          ( (r_smc_currentstate7 == `SMC_FLOAT7)  &
            (r_cste_count7 == 2'd0)
          )
        )
       
        smc_done7 = 1'b1;
   
   else
     
      smc_done7 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data7 is used by the MAC7 block to store7 read data if CSTE7 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate7 or r_ws_count7 or r_oete_store7)
  
  begin
   
     if ( (r_smc_currentstate7 == `SMC_RW7) &
          (r_ws_count7[1:0] >= r_oete_store7) &
          (r_ws_count7[7:2] == 6'd0)
        )
     
       latch_data7 = 1'b1;
   
     else
       
       latch_data7 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter7 enable signals7
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate7 or r_csle_count7 or
       smc_nextstate7 or valid_access7)
  begin
     if(valid_access7)
     begin
        if ((smc_nextstate7 == `SMC_RW7)         &
            (r_smc_currentstate7 != `SMC_STORE7) &
            (r_smc_currentstate7 != `SMC_LE7))
  
          ws_enable7 = 1'b1;
  
        else
  
          ws_enable7 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate7 == `SMC_RW7) & 
            (r_csle_count7 == 2'd0) & 
            (r_smc_currentstate7 != `SMC_STORE7) &
            (r_smc_currentstate7 != `SMC_LE7))

           ws_enable7 = 1'b1;
   
        else
  
           ws_enable7 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable7
//----------------------------------------------------------------------

  always @(r_smc_currentstate7 or smc_nextstate7)
  
  begin
  
     if (((smc_nextstate7 == `SMC_LE7) | (smc_nextstate7 == `SMC_RW7) ) &
         (r_smc_currentstate7 != `SMC_STORE7) )
  
        le_enable7 = 1'b1;
  
     else
  
        le_enable7 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable7
//----------------------------------------------------------------------
  
  always @(smc_nextstate7)
  
  begin
     if (smc_nextstate7 == `SMC_FLOAT7)
    
        cste_enable7 = 1'b1;
   
     else
  
        cste_enable7 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH7 if new cycle is waiting7 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate7 or new_access7 or r_ws_count7 or
                                     smc_nextstate7 or mac_done7)
  
  begin
     
     if (new_access7 & mac_done7 &
         (((r_smc_currentstate7 == `SMC_RW7) & 
           (smc_nextstate7 == `SMC_RW7) & 
           (r_ws_count7 == 8'd0))                                |
          ((r_smc_currentstate7 == `SMC_FLOAT7) & 
           (smc_nextstate7 == `SMC_IDLE7) ) |
          ((r_smc_currentstate7 == `SMC_FLOAT7) & 
           (smc_nextstate7 == `SMC_LE7)   ) |
          ((r_smc_currentstate7 == `SMC_FLOAT7) & 
           (smc_nextstate7 == `SMC_RW7)   ) |
          ((r_smc_currentstate7 == `SMC_FLOAT7) & 
           (smc_nextstate7 == `SMC_STORE7)) |
          ((r_smc_currentstate7 == `SMC_RW7)    & 
           (smc_nextstate7 == `SMC_STORE7)) |
          ((r_smc_currentstate7 == `SMC_RW7)    & 
           (smc_nextstate7 == `SMC_IDLE7) ) |
          ((r_smc_currentstate7 == `SMC_RW7)    & 
           (smc_nextstate7 == `SMC_LE7)   ) |
          ((r_smc_currentstate7 == `SMC_IDLE7) ) )  )    
       
       valid_access7 = 1'b1;
     
     else
       
       valid_access7 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC7 State7 Machine7
//----------------------------------------------------------------------

 always @(r_smc_currentstate7 or new_access7 or 
          cs or r_csle_count7 or r_cste_count7 or r_ws_count7 or mac_done7 
          or r_cs7 or n_read7 or n_r_read7 or r_csle_store7)
  begin
   
   case (r_smc_currentstate7)
  
     `SMC_IDLE7 :
  
        if (new_access7 )
 
           smc_nextstate7 = `SMC_STORE7;
  
        else
  
        begin
  
  
           begin

              if (new_access7 )
  
                 smc_nextstate7 = `SMC_RW7;

              else
  
                 smc_nextstate7 = `SMC_IDLE7;

           end
          
        end

     `SMC_STORE7   :

        if ((r_csle_count7 != 2'd0))

           smc_nextstate7 = `SMC_LE7;

        else

        begin
           
           if ( (r_csle_count7 == 2'd0))

              smc_nextstate7 = `SMC_RW7;
           
           else
             
              smc_nextstate7 = `SMC_STORE7;

        end      

     `SMC_LE7   :
  
        if (r_csle_count7 < 2'd2)
  
           smc_nextstate7 = `SMC_RW7;
  
        else
  
           smc_nextstate7 = `SMC_LE7;
  
     `SMC_RW7   :
  
     begin
          
        if ((r_ws_count7 == 8'd0) & 
            (r_cste_count7 != 2'd0))
  
           smc_nextstate7 = `SMC_FLOAT7;
          
        else if ((r_ws_count7 == 8'd0) &
                 (r_cste_count7 == 2'h0) &
                 mac_done7 & ~new_access7)

           smc_nextstate7 = `SMC_IDLE7;
          
        else if ((~mac_done7 & (r_csle_store7 != 2'd0)) &
                 (r_ws_count7 == 8'd0))
 
           smc_nextstate7 = `SMC_LE7;

        
        else
          
        begin
  
           if  ( ((n_read7 != n_r_read7) | ((cs != r_cs7) & ~n_r_read7)) & 
                  new_access7 & mac_done7 &
                 (r_ws_count7 == 8'd0))   
             
              smc_nextstate7 = `SMC_STORE7;
           
           else
             
              smc_nextstate7 = `SMC_RW7;
           
        end
        
     end
  
     `SMC_FLOAT7   :
        if (~ mac_done7                               & 
            (( & new_access7) | 
             ((r_csle_store7 == 2'd0)            &
              ~new_access7)) &  (r_cste_count7 == 2'd0) )
  
           smc_nextstate7 = `SMC_RW7;
  
        else if (new_access7                              & 
                 (( new_access7) |
                  ((r_csle_store7 == 2'd0)            & 
                   ~new_access7)) & (r_cste_count7 == 2'd0) )

        begin
  
           if  (((n_read7 != n_r_read7) | ((cs != r_cs7) & ~n_r_read7)))   
  
              smc_nextstate7 = `SMC_STORE7;
  
           else
  
              smc_nextstate7 = `SMC_RW7;
  
        end
     
        else
          
        begin
  
           if ((~mac_done7 & (r_csle_store7 != 2'd0)) & 
               (r_cste_count7 < 2'd1))
  
              smc_nextstate7 = `SMC_LE7;

           
           else
             
           begin
           
              if (r_cste_count7 == 2'd0)
             
                 smc_nextstate7 = `SMC_IDLE7;
           
              else
  
                 smc_nextstate7 = `SMC_FLOAT7;
  
           end
           
        end
     
     default   :
       
       smc_nextstate7 = `SMC_IDLE7;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential7 process of state machine7
//----------------------------------------------------------------------

  always @(posedge sys_clk7 or negedge n_sys_reset7)
  
  begin
  
     if (~n_sys_reset7)
  
        r_smc_currentstate7 <= `SMC_IDLE7;
  
  
     else   
       
        r_smc_currentstate7 <= smc_nextstate7;
  
  
  end

   

   
endmodule


