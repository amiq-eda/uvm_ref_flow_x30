//File8 name   : smc_state_lite8.v
//Title8       : 
//Created8     : 1999
//
//Description8 : SMC8 State8 Machine8
//            : Static8 Memory Controller8
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

`include "smc_defs_lite8.v"

//state machine8 for smc8
  module smc_state_lite8  (
                     //inputs8
  
                     sys_clk8,
                     n_sys_reset8,
                     new_access8,
                     r_cste_count8,
                     r_csle_count8,
                     r_ws_count8,
                     mac_done8,
                     n_read8,
                     n_r_read8,
                     r_csle_store8,
                     r_oete_store8,
                     cs,
                     r_cs8,
             
                     //outputs8
  
                     r_smc_currentstate8,
                     smc_nextstate8,
                     cste_enable8,
                     ws_enable8,
                     smc_done8,
                     valid_access8,
                     le_enable8,
                     latch_data8,
                     smc_idle8);
   
   
   
//Parameters8  -  Values8 in smc_defs8.v



// I8/O8

  input            sys_clk8;           // AHB8 System8 clock8
  input            n_sys_reset8;       // AHB8 System8 reset (Active8 LOW8)
  input            new_access8;        // New8 AHB8 valid access to smc8 
                                          // detected
  input [1:0]      r_cste_count8;      // Chip8 select8 TE8 counter
  input [1:0]      r_csle_count8;      // chip8 select8 leading8 edge count
  input [7:0]      r_ws_count8; // wait state count
  input            mac_done8;          // All cycles8 in a multiple access
  input            n_read8;            // Active8 low8 read signal8
  input            n_r_read8;          // Store8 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store8;      // Chip8 select8 LE8 store8
  input [1:0]      r_oete_store8;      // Read strobe8 TE8 end time before CS8
  input       cs;        // chip8 selects8
  input       r_cs8;      // registered chip8 selects8

  output [4:0]      r_smc_currentstate8;// Synchronised8 SMC8 state machine8
  output [4:0]      smc_nextstate8;     // State8 Machine8 
  output            cste_enable8;       // Enable8 CS8 Trailing8 Edge8 counter
  output            ws_enable8;         // Wait8 state counter enable
  output            smc_done8;          // one access completed
  output            valid_access8;      // load8 values are valid if high8
  output            le_enable8;         // Enable8 all Leading8 Edge8 
                                           // counters8
  output            latch_data8;        // latch_data8 is used by the 
                                           // MAC8 block
                                     //  to store8 read data if CSTE8 > 0
  output            smc_idle8;          // idle8 state



// Output8 register declarations8

  reg [4:0]    smc_nextstate8;     // SMC8 state machine8 (async8 encoding8)
  reg [4:0]    r_smc_currentstate8;// Synchronised8 SMC8 state machine8
  reg          ws_enable8;         // Wait8 state counter enable
  reg          cste_enable8;       // Chip8 select8 counter enable
  reg          smc_done8;         // Asserted8 during last cycle of access
  reg          valid_access8;      // load8 values are valid if high8
  reg          le_enable8;         // Enable8 all Leading8 Edge8 counters8
  reg          latch_data8;        // latch_data8 is used by the MAC8 block
  reg          smc_idle8;          // idle8 state
  


//----------------------------------------------------------------------
// Main8 code8
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC8 state machine8
//----------------------------------------------------------------------
// Generates8 the required8 timings8 for the External8 Memory Interface8.
// If8 back-to-back accesses are required8 the state machine8 will bypass8
// the idle8 state, thus8 maintaining8 the chip8 select8 ouput8.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate8 internal idle8 signal8 used by AHB8 IF
//----------------------------------------------------------------------

  always @(smc_nextstate8)
  
  begin
   
     if (smc_nextstate8 == `SMC_IDLE8)
     
        smc_idle8 = 1'b1;
   
     else
       
        smc_idle8 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate8 internal done signal8
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate8 or r_cste_count8 or r_ws_count8)
  
  begin
   
     if ( ( (r_smc_currentstate8 == `SMC_RW8) &
            (r_ws_count8 == 8'd0) &
            (r_cste_count8 == 2'd0)
          ) |
          ( (r_smc_currentstate8 == `SMC_FLOAT8)  &
            (r_cste_count8 == 2'd0)
          )
        )
       
        smc_done8 = 1'b1;
   
   else
     
      smc_done8 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data8 is used by the MAC8 block to store8 read data if CSTE8 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate8 or r_ws_count8 or r_oete_store8)
  
  begin
   
     if ( (r_smc_currentstate8 == `SMC_RW8) &
          (r_ws_count8[1:0] >= r_oete_store8) &
          (r_ws_count8[7:2] == 6'd0)
        )
     
       latch_data8 = 1'b1;
   
     else
       
       latch_data8 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter8 enable signals8
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate8 or r_csle_count8 or
       smc_nextstate8 or valid_access8)
  begin
     if(valid_access8)
     begin
        if ((smc_nextstate8 == `SMC_RW8)         &
            (r_smc_currentstate8 != `SMC_STORE8) &
            (r_smc_currentstate8 != `SMC_LE8))
  
          ws_enable8 = 1'b1;
  
        else
  
          ws_enable8 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate8 == `SMC_RW8) & 
            (r_csle_count8 == 2'd0) & 
            (r_smc_currentstate8 != `SMC_STORE8) &
            (r_smc_currentstate8 != `SMC_LE8))

           ws_enable8 = 1'b1;
   
        else
  
           ws_enable8 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable8
//----------------------------------------------------------------------

  always @(r_smc_currentstate8 or smc_nextstate8)
  
  begin
  
     if (((smc_nextstate8 == `SMC_LE8) | (smc_nextstate8 == `SMC_RW8) ) &
         (r_smc_currentstate8 != `SMC_STORE8) )
  
        le_enable8 = 1'b1;
  
     else
  
        le_enable8 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable8
//----------------------------------------------------------------------
  
  always @(smc_nextstate8)
  
  begin
     if (smc_nextstate8 == `SMC_FLOAT8)
    
        cste_enable8 = 1'b1;
   
     else
  
        cste_enable8 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH8 if new cycle is waiting8 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate8 or new_access8 or r_ws_count8 or
                                     smc_nextstate8 or mac_done8)
  
  begin
     
     if (new_access8 & mac_done8 &
         (((r_smc_currentstate8 == `SMC_RW8) & 
           (smc_nextstate8 == `SMC_RW8) & 
           (r_ws_count8 == 8'd0))                                |
          ((r_smc_currentstate8 == `SMC_FLOAT8) & 
           (smc_nextstate8 == `SMC_IDLE8) ) |
          ((r_smc_currentstate8 == `SMC_FLOAT8) & 
           (smc_nextstate8 == `SMC_LE8)   ) |
          ((r_smc_currentstate8 == `SMC_FLOAT8) & 
           (smc_nextstate8 == `SMC_RW8)   ) |
          ((r_smc_currentstate8 == `SMC_FLOAT8) & 
           (smc_nextstate8 == `SMC_STORE8)) |
          ((r_smc_currentstate8 == `SMC_RW8)    & 
           (smc_nextstate8 == `SMC_STORE8)) |
          ((r_smc_currentstate8 == `SMC_RW8)    & 
           (smc_nextstate8 == `SMC_IDLE8) ) |
          ((r_smc_currentstate8 == `SMC_RW8)    & 
           (smc_nextstate8 == `SMC_LE8)   ) |
          ((r_smc_currentstate8 == `SMC_IDLE8) ) )  )    
       
       valid_access8 = 1'b1;
     
     else
       
       valid_access8 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC8 State8 Machine8
//----------------------------------------------------------------------

 always @(r_smc_currentstate8 or new_access8 or 
          cs or r_csle_count8 or r_cste_count8 or r_ws_count8 or mac_done8 
          or r_cs8 or n_read8 or n_r_read8 or r_csle_store8)
  begin
   
   case (r_smc_currentstate8)
  
     `SMC_IDLE8 :
  
        if (new_access8 )
 
           smc_nextstate8 = `SMC_STORE8;
  
        else
  
        begin
  
  
           begin

              if (new_access8 )
  
                 smc_nextstate8 = `SMC_RW8;

              else
  
                 smc_nextstate8 = `SMC_IDLE8;

           end
          
        end

     `SMC_STORE8   :

        if ((r_csle_count8 != 2'd0))

           smc_nextstate8 = `SMC_LE8;

        else

        begin
           
           if ( (r_csle_count8 == 2'd0))

              smc_nextstate8 = `SMC_RW8;
           
           else
             
              smc_nextstate8 = `SMC_STORE8;

        end      

     `SMC_LE8   :
  
        if (r_csle_count8 < 2'd2)
  
           smc_nextstate8 = `SMC_RW8;
  
        else
  
           smc_nextstate8 = `SMC_LE8;
  
     `SMC_RW8   :
  
     begin
          
        if ((r_ws_count8 == 8'd0) & 
            (r_cste_count8 != 2'd0))
  
           smc_nextstate8 = `SMC_FLOAT8;
          
        else if ((r_ws_count8 == 8'd0) &
                 (r_cste_count8 == 2'h0) &
                 mac_done8 & ~new_access8)

           smc_nextstate8 = `SMC_IDLE8;
          
        else if ((~mac_done8 & (r_csle_store8 != 2'd0)) &
                 (r_ws_count8 == 8'd0))
 
           smc_nextstate8 = `SMC_LE8;

        
        else
          
        begin
  
           if  ( ((n_read8 != n_r_read8) | ((cs != r_cs8) & ~n_r_read8)) & 
                  new_access8 & mac_done8 &
                 (r_ws_count8 == 8'd0))   
             
              smc_nextstate8 = `SMC_STORE8;
           
           else
             
              smc_nextstate8 = `SMC_RW8;
           
        end
        
     end
  
     `SMC_FLOAT8   :
        if (~ mac_done8                               & 
            (( & new_access8) | 
             ((r_csle_store8 == 2'd0)            &
              ~new_access8)) &  (r_cste_count8 == 2'd0) )
  
           smc_nextstate8 = `SMC_RW8;
  
        else if (new_access8                              & 
                 (( new_access8) |
                  ((r_csle_store8 == 2'd0)            & 
                   ~new_access8)) & (r_cste_count8 == 2'd0) )

        begin
  
           if  (((n_read8 != n_r_read8) | ((cs != r_cs8) & ~n_r_read8)))   
  
              smc_nextstate8 = `SMC_STORE8;
  
           else
  
              smc_nextstate8 = `SMC_RW8;
  
        end
     
        else
          
        begin
  
           if ((~mac_done8 & (r_csle_store8 != 2'd0)) & 
               (r_cste_count8 < 2'd1))
  
              smc_nextstate8 = `SMC_LE8;

           
           else
             
           begin
           
              if (r_cste_count8 == 2'd0)
             
                 smc_nextstate8 = `SMC_IDLE8;
           
              else
  
                 smc_nextstate8 = `SMC_FLOAT8;
  
           end
           
        end
     
     default   :
       
       smc_nextstate8 = `SMC_IDLE8;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential8 process of state machine8
//----------------------------------------------------------------------

  always @(posedge sys_clk8 or negedge n_sys_reset8)
  
  begin
  
     if (~n_sys_reset8)
  
        r_smc_currentstate8 <= `SMC_IDLE8;
  
  
     else   
       
        r_smc_currentstate8 <= smc_nextstate8;
  
  
  end

   

   
endmodule


