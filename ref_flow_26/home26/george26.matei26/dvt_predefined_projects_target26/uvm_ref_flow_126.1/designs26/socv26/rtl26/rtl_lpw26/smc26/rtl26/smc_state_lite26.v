//File26 name   : smc_state_lite26.v
//Title26       : 
//Created26     : 1999
//
//Description26 : SMC26 State26 Machine26
//            : Static26 Memory Controller26
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

`include "smc_defs_lite26.v"

//state machine26 for smc26
  module smc_state_lite26  (
                     //inputs26
  
                     sys_clk26,
                     n_sys_reset26,
                     new_access26,
                     r_cste_count26,
                     r_csle_count26,
                     r_ws_count26,
                     mac_done26,
                     n_read26,
                     n_r_read26,
                     r_csle_store26,
                     r_oete_store26,
                     cs,
                     r_cs26,
             
                     //outputs26
  
                     r_smc_currentstate26,
                     smc_nextstate26,
                     cste_enable26,
                     ws_enable26,
                     smc_done26,
                     valid_access26,
                     le_enable26,
                     latch_data26,
                     smc_idle26);
   
   
   
//Parameters26  -  Values26 in smc_defs26.v



// I26/O26

  input            sys_clk26;           // AHB26 System26 clock26
  input            n_sys_reset26;       // AHB26 System26 reset (Active26 LOW26)
  input            new_access26;        // New26 AHB26 valid access to smc26 
                                          // detected
  input [1:0]      r_cste_count26;      // Chip26 select26 TE26 counter
  input [1:0]      r_csle_count26;      // chip26 select26 leading26 edge count
  input [7:0]      r_ws_count26; // wait state count
  input            mac_done26;          // All cycles26 in a multiple access
  input            n_read26;            // Active26 low26 read signal26
  input            n_r_read26;          // Store26 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store26;      // Chip26 select26 LE26 store26
  input [1:0]      r_oete_store26;      // Read strobe26 TE26 end time before CS26
  input       cs;        // chip26 selects26
  input       r_cs26;      // registered chip26 selects26

  output [4:0]      r_smc_currentstate26;// Synchronised26 SMC26 state machine26
  output [4:0]      smc_nextstate26;     // State26 Machine26 
  output            cste_enable26;       // Enable26 CS26 Trailing26 Edge26 counter
  output            ws_enable26;         // Wait26 state counter enable
  output            smc_done26;          // one access completed
  output            valid_access26;      // load26 values are valid if high26
  output            le_enable26;         // Enable26 all Leading26 Edge26 
                                           // counters26
  output            latch_data26;        // latch_data26 is used by the 
                                           // MAC26 block
                                     //  to store26 read data if CSTE26 > 0
  output            smc_idle26;          // idle26 state



// Output26 register declarations26

  reg [4:0]    smc_nextstate26;     // SMC26 state machine26 (async26 encoding26)
  reg [4:0]    r_smc_currentstate26;// Synchronised26 SMC26 state machine26
  reg          ws_enable26;         // Wait26 state counter enable
  reg          cste_enable26;       // Chip26 select26 counter enable
  reg          smc_done26;         // Asserted26 during last cycle of access
  reg          valid_access26;      // load26 values are valid if high26
  reg          le_enable26;         // Enable26 all Leading26 Edge26 counters26
  reg          latch_data26;        // latch_data26 is used by the MAC26 block
  reg          smc_idle26;          // idle26 state
  


//----------------------------------------------------------------------
// Main26 code26
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC26 state machine26
//----------------------------------------------------------------------
// Generates26 the required26 timings26 for the External26 Memory Interface26.
// If26 back-to-back accesses are required26 the state machine26 will bypass26
// the idle26 state, thus26 maintaining26 the chip26 select26 ouput26.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate26 internal idle26 signal26 used by AHB26 IF
//----------------------------------------------------------------------

  always @(smc_nextstate26)
  
  begin
   
     if (smc_nextstate26 == `SMC_IDLE26)
     
        smc_idle26 = 1'b1;
   
     else
       
        smc_idle26 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate26 internal done signal26
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate26 or r_cste_count26 or r_ws_count26)
  
  begin
   
     if ( ( (r_smc_currentstate26 == `SMC_RW26) &
            (r_ws_count26 == 8'd0) &
            (r_cste_count26 == 2'd0)
          ) |
          ( (r_smc_currentstate26 == `SMC_FLOAT26)  &
            (r_cste_count26 == 2'd0)
          )
        )
       
        smc_done26 = 1'b1;
   
   else
     
      smc_done26 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data26 is used by the MAC26 block to store26 read data if CSTE26 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate26 or r_ws_count26 or r_oete_store26)
  
  begin
   
     if ( (r_smc_currentstate26 == `SMC_RW26) &
          (r_ws_count26[1:0] >= r_oete_store26) &
          (r_ws_count26[7:2] == 6'd0)
        )
     
       latch_data26 = 1'b1;
   
     else
       
       latch_data26 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter26 enable signals26
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate26 or r_csle_count26 or
       smc_nextstate26 or valid_access26)
  begin
     if(valid_access26)
     begin
        if ((smc_nextstate26 == `SMC_RW26)         &
            (r_smc_currentstate26 != `SMC_STORE26) &
            (r_smc_currentstate26 != `SMC_LE26))
  
          ws_enable26 = 1'b1;
  
        else
  
          ws_enable26 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate26 == `SMC_RW26) & 
            (r_csle_count26 == 2'd0) & 
            (r_smc_currentstate26 != `SMC_STORE26) &
            (r_smc_currentstate26 != `SMC_LE26))

           ws_enable26 = 1'b1;
   
        else
  
           ws_enable26 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable26
//----------------------------------------------------------------------

  always @(r_smc_currentstate26 or smc_nextstate26)
  
  begin
  
     if (((smc_nextstate26 == `SMC_LE26) | (smc_nextstate26 == `SMC_RW26) ) &
         (r_smc_currentstate26 != `SMC_STORE26) )
  
        le_enable26 = 1'b1;
  
     else
  
        le_enable26 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable26
//----------------------------------------------------------------------
  
  always @(smc_nextstate26)
  
  begin
     if (smc_nextstate26 == `SMC_FLOAT26)
    
        cste_enable26 = 1'b1;
   
     else
  
        cste_enable26 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH26 if new cycle is waiting26 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate26 or new_access26 or r_ws_count26 or
                                     smc_nextstate26 or mac_done26)
  
  begin
     
     if (new_access26 & mac_done26 &
         (((r_smc_currentstate26 == `SMC_RW26) & 
           (smc_nextstate26 == `SMC_RW26) & 
           (r_ws_count26 == 8'd0))                                |
          ((r_smc_currentstate26 == `SMC_FLOAT26) & 
           (smc_nextstate26 == `SMC_IDLE26) ) |
          ((r_smc_currentstate26 == `SMC_FLOAT26) & 
           (smc_nextstate26 == `SMC_LE26)   ) |
          ((r_smc_currentstate26 == `SMC_FLOAT26) & 
           (smc_nextstate26 == `SMC_RW26)   ) |
          ((r_smc_currentstate26 == `SMC_FLOAT26) & 
           (smc_nextstate26 == `SMC_STORE26)) |
          ((r_smc_currentstate26 == `SMC_RW26)    & 
           (smc_nextstate26 == `SMC_STORE26)) |
          ((r_smc_currentstate26 == `SMC_RW26)    & 
           (smc_nextstate26 == `SMC_IDLE26) ) |
          ((r_smc_currentstate26 == `SMC_RW26)    & 
           (smc_nextstate26 == `SMC_LE26)   ) |
          ((r_smc_currentstate26 == `SMC_IDLE26) ) )  )    
       
       valid_access26 = 1'b1;
     
     else
       
       valid_access26 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC26 State26 Machine26
//----------------------------------------------------------------------

 always @(r_smc_currentstate26 or new_access26 or 
          cs or r_csle_count26 or r_cste_count26 or r_ws_count26 or mac_done26 
          or r_cs26 or n_read26 or n_r_read26 or r_csle_store26)
  begin
   
   case (r_smc_currentstate26)
  
     `SMC_IDLE26 :
  
        if (new_access26 )
 
           smc_nextstate26 = `SMC_STORE26;
  
        else
  
        begin
  
  
           begin

              if (new_access26 )
  
                 smc_nextstate26 = `SMC_RW26;

              else
  
                 smc_nextstate26 = `SMC_IDLE26;

           end
          
        end

     `SMC_STORE26   :

        if ((r_csle_count26 != 2'd0))

           smc_nextstate26 = `SMC_LE26;

        else

        begin
           
           if ( (r_csle_count26 == 2'd0))

              smc_nextstate26 = `SMC_RW26;
           
           else
             
              smc_nextstate26 = `SMC_STORE26;

        end      

     `SMC_LE26   :
  
        if (r_csle_count26 < 2'd2)
  
           smc_nextstate26 = `SMC_RW26;
  
        else
  
           smc_nextstate26 = `SMC_LE26;
  
     `SMC_RW26   :
  
     begin
          
        if ((r_ws_count26 == 8'd0) & 
            (r_cste_count26 != 2'd0))
  
           smc_nextstate26 = `SMC_FLOAT26;
          
        else if ((r_ws_count26 == 8'd0) &
                 (r_cste_count26 == 2'h0) &
                 mac_done26 & ~new_access26)

           smc_nextstate26 = `SMC_IDLE26;
          
        else if ((~mac_done26 & (r_csle_store26 != 2'd0)) &
                 (r_ws_count26 == 8'd0))
 
           smc_nextstate26 = `SMC_LE26;

        
        else
          
        begin
  
           if  ( ((n_read26 != n_r_read26) | ((cs != r_cs26) & ~n_r_read26)) & 
                  new_access26 & mac_done26 &
                 (r_ws_count26 == 8'd0))   
             
              smc_nextstate26 = `SMC_STORE26;
           
           else
             
              smc_nextstate26 = `SMC_RW26;
           
        end
        
     end
  
     `SMC_FLOAT26   :
        if (~ mac_done26                               & 
            (( & new_access26) | 
             ((r_csle_store26 == 2'd0)            &
              ~new_access26)) &  (r_cste_count26 == 2'd0) )
  
           smc_nextstate26 = `SMC_RW26;
  
        else if (new_access26                              & 
                 (( new_access26) |
                  ((r_csle_store26 == 2'd0)            & 
                   ~new_access26)) & (r_cste_count26 == 2'd0) )

        begin
  
           if  (((n_read26 != n_r_read26) | ((cs != r_cs26) & ~n_r_read26)))   
  
              smc_nextstate26 = `SMC_STORE26;
  
           else
  
              smc_nextstate26 = `SMC_RW26;
  
        end
     
        else
          
        begin
  
           if ((~mac_done26 & (r_csle_store26 != 2'd0)) & 
               (r_cste_count26 < 2'd1))
  
              smc_nextstate26 = `SMC_LE26;

           
           else
             
           begin
           
              if (r_cste_count26 == 2'd0)
             
                 smc_nextstate26 = `SMC_IDLE26;
           
              else
  
                 smc_nextstate26 = `SMC_FLOAT26;
  
           end
           
        end
     
     default   :
       
       smc_nextstate26 = `SMC_IDLE26;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential26 process of state machine26
//----------------------------------------------------------------------

  always @(posedge sys_clk26 or negedge n_sys_reset26)
  
  begin
  
     if (~n_sys_reset26)
  
        r_smc_currentstate26 <= `SMC_IDLE26;
  
  
     else   
       
        r_smc_currentstate26 <= smc_nextstate26;
  
  
  end

   

   
endmodule


