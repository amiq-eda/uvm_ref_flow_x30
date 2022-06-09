//File12 name   : smc_state_lite12.v
//Title12       : 
//Created12     : 1999
//
//Description12 : SMC12 State12 Machine12
//            : Static12 Memory Controller12
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

`include "smc_defs_lite12.v"

//state machine12 for smc12
  module smc_state_lite12  (
                     //inputs12
  
                     sys_clk12,
                     n_sys_reset12,
                     new_access12,
                     r_cste_count12,
                     r_csle_count12,
                     r_ws_count12,
                     mac_done12,
                     n_read12,
                     n_r_read12,
                     r_csle_store12,
                     r_oete_store12,
                     cs,
                     r_cs12,
             
                     //outputs12
  
                     r_smc_currentstate12,
                     smc_nextstate12,
                     cste_enable12,
                     ws_enable12,
                     smc_done12,
                     valid_access12,
                     le_enable12,
                     latch_data12,
                     smc_idle12);
   
   
   
//Parameters12  -  Values12 in smc_defs12.v



// I12/O12

  input            sys_clk12;           // AHB12 System12 clock12
  input            n_sys_reset12;       // AHB12 System12 reset (Active12 LOW12)
  input            new_access12;        // New12 AHB12 valid access to smc12 
                                          // detected
  input [1:0]      r_cste_count12;      // Chip12 select12 TE12 counter
  input [1:0]      r_csle_count12;      // chip12 select12 leading12 edge count
  input [7:0]      r_ws_count12; // wait state count
  input            mac_done12;          // All cycles12 in a multiple access
  input            n_read12;            // Active12 low12 read signal12
  input            n_r_read12;          // Store12 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store12;      // Chip12 select12 LE12 store12
  input [1:0]      r_oete_store12;      // Read strobe12 TE12 end time before CS12
  input       cs;        // chip12 selects12
  input       r_cs12;      // registered chip12 selects12

  output [4:0]      r_smc_currentstate12;// Synchronised12 SMC12 state machine12
  output [4:0]      smc_nextstate12;     // State12 Machine12 
  output            cste_enable12;       // Enable12 CS12 Trailing12 Edge12 counter
  output            ws_enable12;         // Wait12 state counter enable
  output            smc_done12;          // one access completed
  output            valid_access12;      // load12 values are valid if high12
  output            le_enable12;         // Enable12 all Leading12 Edge12 
                                           // counters12
  output            latch_data12;        // latch_data12 is used by the 
                                           // MAC12 block
                                     //  to store12 read data if CSTE12 > 0
  output            smc_idle12;          // idle12 state



// Output12 register declarations12

  reg [4:0]    smc_nextstate12;     // SMC12 state machine12 (async12 encoding12)
  reg [4:0]    r_smc_currentstate12;// Synchronised12 SMC12 state machine12
  reg          ws_enable12;         // Wait12 state counter enable
  reg          cste_enable12;       // Chip12 select12 counter enable
  reg          smc_done12;         // Asserted12 during last cycle of access
  reg          valid_access12;      // load12 values are valid if high12
  reg          le_enable12;         // Enable12 all Leading12 Edge12 counters12
  reg          latch_data12;        // latch_data12 is used by the MAC12 block
  reg          smc_idle12;          // idle12 state
  


//----------------------------------------------------------------------
// Main12 code12
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC12 state machine12
//----------------------------------------------------------------------
// Generates12 the required12 timings12 for the External12 Memory Interface12.
// If12 back-to-back accesses are required12 the state machine12 will bypass12
// the idle12 state, thus12 maintaining12 the chip12 select12 ouput12.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate12 internal idle12 signal12 used by AHB12 IF
//----------------------------------------------------------------------

  always @(smc_nextstate12)
  
  begin
   
     if (smc_nextstate12 == `SMC_IDLE12)
     
        smc_idle12 = 1'b1;
   
     else
       
        smc_idle12 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate12 internal done signal12
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate12 or r_cste_count12 or r_ws_count12)
  
  begin
   
     if ( ( (r_smc_currentstate12 == `SMC_RW12) &
            (r_ws_count12 == 8'd0) &
            (r_cste_count12 == 2'd0)
          ) |
          ( (r_smc_currentstate12 == `SMC_FLOAT12)  &
            (r_cste_count12 == 2'd0)
          )
        )
       
        smc_done12 = 1'b1;
   
   else
     
      smc_done12 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data12 is used by the MAC12 block to store12 read data if CSTE12 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate12 or r_ws_count12 or r_oete_store12)
  
  begin
   
     if ( (r_smc_currentstate12 == `SMC_RW12) &
          (r_ws_count12[1:0] >= r_oete_store12) &
          (r_ws_count12[7:2] == 6'd0)
        )
     
       latch_data12 = 1'b1;
   
     else
       
       latch_data12 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter12 enable signals12
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate12 or r_csle_count12 or
       smc_nextstate12 or valid_access12)
  begin
     if(valid_access12)
     begin
        if ((smc_nextstate12 == `SMC_RW12)         &
            (r_smc_currentstate12 != `SMC_STORE12) &
            (r_smc_currentstate12 != `SMC_LE12))
  
          ws_enable12 = 1'b1;
  
        else
  
          ws_enable12 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate12 == `SMC_RW12) & 
            (r_csle_count12 == 2'd0) & 
            (r_smc_currentstate12 != `SMC_STORE12) &
            (r_smc_currentstate12 != `SMC_LE12))

           ws_enable12 = 1'b1;
   
        else
  
           ws_enable12 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable12
//----------------------------------------------------------------------

  always @(r_smc_currentstate12 or smc_nextstate12)
  
  begin
  
     if (((smc_nextstate12 == `SMC_LE12) | (smc_nextstate12 == `SMC_RW12) ) &
         (r_smc_currentstate12 != `SMC_STORE12) )
  
        le_enable12 = 1'b1;
  
     else
  
        le_enable12 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable12
//----------------------------------------------------------------------
  
  always @(smc_nextstate12)
  
  begin
     if (smc_nextstate12 == `SMC_FLOAT12)
    
        cste_enable12 = 1'b1;
   
     else
  
        cste_enable12 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH12 if new cycle is waiting12 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate12 or new_access12 or r_ws_count12 or
                                     smc_nextstate12 or mac_done12)
  
  begin
     
     if (new_access12 & mac_done12 &
         (((r_smc_currentstate12 == `SMC_RW12) & 
           (smc_nextstate12 == `SMC_RW12) & 
           (r_ws_count12 == 8'd0))                                |
          ((r_smc_currentstate12 == `SMC_FLOAT12) & 
           (smc_nextstate12 == `SMC_IDLE12) ) |
          ((r_smc_currentstate12 == `SMC_FLOAT12) & 
           (smc_nextstate12 == `SMC_LE12)   ) |
          ((r_smc_currentstate12 == `SMC_FLOAT12) & 
           (smc_nextstate12 == `SMC_RW12)   ) |
          ((r_smc_currentstate12 == `SMC_FLOAT12) & 
           (smc_nextstate12 == `SMC_STORE12)) |
          ((r_smc_currentstate12 == `SMC_RW12)    & 
           (smc_nextstate12 == `SMC_STORE12)) |
          ((r_smc_currentstate12 == `SMC_RW12)    & 
           (smc_nextstate12 == `SMC_IDLE12) ) |
          ((r_smc_currentstate12 == `SMC_RW12)    & 
           (smc_nextstate12 == `SMC_LE12)   ) |
          ((r_smc_currentstate12 == `SMC_IDLE12) ) )  )    
       
       valid_access12 = 1'b1;
     
     else
       
       valid_access12 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC12 State12 Machine12
//----------------------------------------------------------------------

 always @(r_smc_currentstate12 or new_access12 or 
          cs or r_csle_count12 or r_cste_count12 or r_ws_count12 or mac_done12 
          or r_cs12 or n_read12 or n_r_read12 or r_csle_store12)
  begin
   
   case (r_smc_currentstate12)
  
     `SMC_IDLE12 :
  
        if (new_access12 )
 
           smc_nextstate12 = `SMC_STORE12;
  
        else
  
        begin
  
  
           begin

              if (new_access12 )
  
                 smc_nextstate12 = `SMC_RW12;

              else
  
                 smc_nextstate12 = `SMC_IDLE12;

           end
          
        end

     `SMC_STORE12   :

        if ((r_csle_count12 != 2'd0))

           smc_nextstate12 = `SMC_LE12;

        else

        begin
           
           if ( (r_csle_count12 == 2'd0))

              smc_nextstate12 = `SMC_RW12;
           
           else
             
              smc_nextstate12 = `SMC_STORE12;

        end      

     `SMC_LE12   :
  
        if (r_csle_count12 < 2'd2)
  
           smc_nextstate12 = `SMC_RW12;
  
        else
  
           smc_nextstate12 = `SMC_LE12;
  
     `SMC_RW12   :
  
     begin
          
        if ((r_ws_count12 == 8'd0) & 
            (r_cste_count12 != 2'd0))
  
           smc_nextstate12 = `SMC_FLOAT12;
          
        else if ((r_ws_count12 == 8'd0) &
                 (r_cste_count12 == 2'h0) &
                 mac_done12 & ~new_access12)

           smc_nextstate12 = `SMC_IDLE12;
          
        else if ((~mac_done12 & (r_csle_store12 != 2'd0)) &
                 (r_ws_count12 == 8'd0))
 
           smc_nextstate12 = `SMC_LE12;

        
        else
          
        begin
  
           if  ( ((n_read12 != n_r_read12) | ((cs != r_cs12) & ~n_r_read12)) & 
                  new_access12 & mac_done12 &
                 (r_ws_count12 == 8'd0))   
             
              smc_nextstate12 = `SMC_STORE12;
           
           else
             
              smc_nextstate12 = `SMC_RW12;
           
        end
        
     end
  
     `SMC_FLOAT12   :
        if (~ mac_done12                               & 
            (( & new_access12) | 
             ((r_csle_store12 == 2'd0)            &
              ~new_access12)) &  (r_cste_count12 == 2'd0) )
  
           smc_nextstate12 = `SMC_RW12;
  
        else if (new_access12                              & 
                 (( new_access12) |
                  ((r_csle_store12 == 2'd0)            & 
                   ~new_access12)) & (r_cste_count12 == 2'd0) )

        begin
  
           if  (((n_read12 != n_r_read12) | ((cs != r_cs12) & ~n_r_read12)))   
  
              smc_nextstate12 = `SMC_STORE12;
  
           else
  
              smc_nextstate12 = `SMC_RW12;
  
        end
     
        else
          
        begin
  
           if ((~mac_done12 & (r_csle_store12 != 2'd0)) & 
               (r_cste_count12 < 2'd1))
  
              smc_nextstate12 = `SMC_LE12;

           
           else
             
           begin
           
              if (r_cste_count12 == 2'd0)
             
                 smc_nextstate12 = `SMC_IDLE12;
           
              else
  
                 smc_nextstate12 = `SMC_FLOAT12;
  
           end
           
        end
     
     default   :
       
       smc_nextstate12 = `SMC_IDLE12;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential12 process of state machine12
//----------------------------------------------------------------------

  always @(posedge sys_clk12 or negedge n_sys_reset12)
  
  begin
  
     if (~n_sys_reset12)
  
        r_smc_currentstate12 <= `SMC_IDLE12;
  
  
     else   
       
        r_smc_currentstate12 <= smc_nextstate12;
  
  
  end

   

   
endmodule


