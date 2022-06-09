//File30 name   : smc_state_lite30.v
//Title30       : 
//Created30     : 1999
//
//Description30 : SMC30 State30 Machine30
//            : Static30 Memory Controller30
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

`include "smc_defs_lite30.v"

//state machine30 for smc30
  module smc_state_lite30  (
                     //inputs30
  
                     sys_clk30,
                     n_sys_reset30,
                     new_access30,
                     r_cste_count30,
                     r_csle_count30,
                     r_ws_count30,
                     mac_done30,
                     n_read30,
                     n_r_read30,
                     r_csle_store30,
                     r_oete_store30,
                     cs,
                     r_cs30,
             
                     //outputs30
  
                     r_smc_currentstate30,
                     smc_nextstate30,
                     cste_enable30,
                     ws_enable30,
                     smc_done30,
                     valid_access30,
                     le_enable30,
                     latch_data30,
                     smc_idle30);
   
   
   
//Parameters30  -  Values30 in smc_defs30.v



// I30/O30

  input            sys_clk30;           // AHB30 System30 clock30
  input            n_sys_reset30;       // AHB30 System30 reset (Active30 LOW30)
  input            new_access30;        // New30 AHB30 valid access to smc30 
                                          // detected
  input [1:0]      r_cste_count30;      // Chip30 select30 TE30 counter
  input [1:0]      r_csle_count30;      // chip30 select30 leading30 edge count
  input [7:0]      r_ws_count30; // wait state count
  input            mac_done30;          // All cycles30 in a multiple access
  input            n_read30;            // Active30 low30 read signal30
  input            n_r_read30;          // Store30 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store30;      // Chip30 select30 LE30 store30
  input [1:0]      r_oete_store30;      // Read strobe30 TE30 end time before CS30
  input       cs;        // chip30 selects30
  input       r_cs30;      // registered chip30 selects30

  output [4:0]      r_smc_currentstate30;// Synchronised30 SMC30 state machine30
  output [4:0]      smc_nextstate30;     // State30 Machine30 
  output            cste_enable30;       // Enable30 CS30 Trailing30 Edge30 counter
  output            ws_enable30;         // Wait30 state counter enable
  output            smc_done30;          // one access completed
  output            valid_access30;      // load30 values are valid if high30
  output            le_enable30;         // Enable30 all Leading30 Edge30 
                                           // counters30
  output            latch_data30;        // latch_data30 is used by the 
                                           // MAC30 block
                                     //  to store30 read data if CSTE30 > 0
  output            smc_idle30;          // idle30 state



// Output30 register declarations30

  reg [4:0]    smc_nextstate30;     // SMC30 state machine30 (async30 encoding30)
  reg [4:0]    r_smc_currentstate30;// Synchronised30 SMC30 state machine30
  reg          ws_enable30;         // Wait30 state counter enable
  reg          cste_enable30;       // Chip30 select30 counter enable
  reg          smc_done30;         // Asserted30 during last cycle of access
  reg          valid_access30;      // load30 values are valid if high30
  reg          le_enable30;         // Enable30 all Leading30 Edge30 counters30
  reg          latch_data30;        // latch_data30 is used by the MAC30 block
  reg          smc_idle30;          // idle30 state
  


//----------------------------------------------------------------------
// Main30 code30
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC30 state machine30
//----------------------------------------------------------------------
// Generates30 the required30 timings30 for the External30 Memory Interface30.
// If30 back-to-back accesses are required30 the state machine30 will bypass30
// the idle30 state, thus30 maintaining30 the chip30 select30 ouput30.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate30 internal idle30 signal30 used by AHB30 IF
//----------------------------------------------------------------------

  always @(smc_nextstate30)
  
  begin
   
     if (smc_nextstate30 == `SMC_IDLE30)
     
        smc_idle30 = 1'b1;
   
     else
       
        smc_idle30 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate30 internal done signal30
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate30 or r_cste_count30 or r_ws_count30)
  
  begin
   
     if ( ( (r_smc_currentstate30 == `SMC_RW30) &
            (r_ws_count30 == 8'd0) &
            (r_cste_count30 == 2'd0)
          ) |
          ( (r_smc_currentstate30 == `SMC_FLOAT30)  &
            (r_cste_count30 == 2'd0)
          )
        )
       
        smc_done30 = 1'b1;
   
   else
     
      smc_done30 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data30 is used by the MAC30 block to store30 read data if CSTE30 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate30 or r_ws_count30 or r_oete_store30)
  
  begin
   
     if ( (r_smc_currentstate30 == `SMC_RW30) &
          (r_ws_count30[1:0] >= r_oete_store30) &
          (r_ws_count30[7:2] == 6'd0)
        )
     
       latch_data30 = 1'b1;
   
     else
       
       latch_data30 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter30 enable signals30
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate30 or r_csle_count30 or
       smc_nextstate30 or valid_access30)
  begin
     if(valid_access30)
     begin
        if ((smc_nextstate30 == `SMC_RW30)         &
            (r_smc_currentstate30 != `SMC_STORE30) &
            (r_smc_currentstate30 != `SMC_LE30))
  
          ws_enable30 = 1'b1;
  
        else
  
          ws_enable30 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate30 == `SMC_RW30) & 
            (r_csle_count30 == 2'd0) & 
            (r_smc_currentstate30 != `SMC_STORE30) &
            (r_smc_currentstate30 != `SMC_LE30))

           ws_enable30 = 1'b1;
   
        else
  
           ws_enable30 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable30
//----------------------------------------------------------------------

  always @(r_smc_currentstate30 or smc_nextstate30)
  
  begin
  
     if (((smc_nextstate30 == `SMC_LE30) | (smc_nextstate30 == `SMC_RW30) ) &
         (r_smc_currentstate30 != `SMC_STORE30) )
  
        le_enable30 = 1'b1;
  
     else
  
        le_enable30 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable30
//----------------------------------------------------------------------
  
  always @(smc_nextstate30)
  
  begin
     if (smc_nextstate30 == `SMC_FLOAT30)
    
        cste_enable30 = 1'b1;
   
     else
  
        cste_enable30 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH30 if new cycle is waiting30 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate30 or new_access30 or r_ws_count30 or
                                     smc_nextstate30 or mac_done30)
  
  begin
     
     if (new_access30 & mac_done30 &
         (((r_smc_currentstate30 == `SMC_RW30) & 
           (smc_nextstate30 == `SMC_RW30) & 
           (r_ws_count30 == 8'd0))                                |
          ((r_smc_currentstate30 == `SMC_FLOAT30) & 
           (smc_nextstate30 == `SMC_IDLE30) ) |
          ((r_smc_currentstate30 == `SMC_FLOAT30) & 
           (smc_nextstate30 == `SMC_LE30)   ) |
          ((r_smc_currentstate30 == `SMC_FLOAT30) & 
           (smc_nextstate30 == `SMC_RW30)   ) |
          ((r_smc_currentstate30 == `SMC_FLOAT30) & 
           (smc_nextstate30 == `SMC_STORE30)) |
          ((r_smc_currentstate30 == `SMC_RW30)    & 
           (smc_nextstate30 == `SMC_STORE30)) |
          ((r_smc_currentstate30 == `SMC_RW30)    & 
           (smc_nextstate30 == `SMC_IDLE30) ) |
          ((r_smc_currentstate30 == `SMC_RW30)    & 
           (smc_nextstate30 == `SMC_LE30)   ) |
          ((r_smc_currentstate30 == `SMC_IDLE30) ) )  )    
       
       valid_access30 = 1'b1;
     
     else
       
       valid_access30 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC30 State30 Machine30
//----------------------------------------------------------------------

 always @(r_smc_currentstate30 or new_access30 or 
          cs or r_csle_count30 or r_cste_count30 or r_ws_count30 or mac_done30 
          or r_cs30 or n_read30 or n_r_read30 or r_csle_store30)
  begin
   
   case (r_smc_currentstate30)
  
     `SMC_IDLE30 :
  
        if (new_access30 )
 
           smc_nextstate30 = `SMC_STORE30;
  
        else
  
        begin
  
  
           begin

              if (new_access30 )
  
                 smc_nextstate30 = `SMC_RW30;

              else
  
                 smc_nextstate30 = `SMC_IDLE30;

           end
          
        end

     `SMC_STORE30   :

        if ((r_csle_count30 != 2'd0))

           smc_nextstate30 = `SMC_LE30;

        else

        begin
           
           if ( (r_csle_count30 == 2'd0))

              smc_nextstate30 = `SMC_RW30;
           
           else
             
              smc_nextstate30 = `SMC_STORE30;

        end      

     `SMC_LE30   :
  
        if (r_csle_count30 < 2'd2)
  
           smc_nextstate30 = `SMC_RW30;
  
        else
  
           smc_nextstate30 = `SMC_LE30;
  
     `SMC_RW30   :
  
     begin
          
        if ((r_ws_count30 == 8'd0) & 
            (r_cste_count30 != 2'd0))
  
           smc_nextstate30 = `SMC_FLOAT30;
          
        else if ((r_ws_count30 == 8'd0) &
                 (r_cste_count30 == 2'h0) &
                 mac_done30 & ~new_access30)

           smc_nextstate30 = `SMC_IDLE30;
          
        else if ((~mac_done30 & (r_csle_store30 != 2'd0)) &
                 (r_ws_count30 == 8'd0))
 
           smc_nextstate30 = `SMC_LE30;

        
        else
          
        begin
  
           if  ( ((n_read30 != n_r_read30) | ((cs != r_cs30) & ~n_r_read30)) & 
                  new_access30 & mac_done30 &
                 (r_ws_count30 == 8'd0))   
             
              smc_nextstate30 = `SMC_STORE30;
           
           else
             
              smc_nextstate30 = `SMC_RW30;
           
        end
        
     end
  
     `SMC_FLOAT30   :
        if (~ mac_done30                               & 
            (( & new_access30) | 
             ((r_csle_store30 == 2'd0)            &
              ~new_access30)) &  (r_cste_count30 == 2'd0) )
  
           smc_nextstate30 = `SMC_RW30;
  
        else if (new_access30                              & 
                 (( new_access30) |
                  ((r_csle_store30 == 2'd0)            & 
                   ~new_access30)) & (r_cste_count30 == 2'd0) )

        begin
  
           if  (((n_read30 != n_r_read30) | ((cs != r_cs30) & ~n_r_read30)))   
  
              smc_nextstate30 = `SMC_STORE30;
  
           else
  
              smc_nextstate30 = `SMC_RW30;
  
        end
     
        else
          
        begin
  
           if ((~mac_done30 & (r_csle_store30 != 2'd0)) & 
               (r_cste_count30 < 2'd1))
  
              smc_nextstate30 = `SMC_LE30;

           
           else
             
           begin
           
              if (r_cste_count30 == 2'd0)
             
                 smc_nextstate30 = `SMC_IDLE30;
           
              else
  
                 smc_nextstate30 = `SMC_FLOAT30;
  
           end
           
        end
     
     default   :
       
       smc_nextstate30 = `SMC_IDLE30;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential30 process of state machine30
//----------------------------------------------------------------------

  always @(posedge sys_clk30 or negedge n_sys_reset30)
  
  begin
  
     if (~n_sys_reset30)
  
        r_smc_currentstate30 <= `SMC_IDLE30;
  
  
     else   
       
        r_smc_currentstate30 <= smc_nextstate30;
  
  
  end

   

   
endmodule


