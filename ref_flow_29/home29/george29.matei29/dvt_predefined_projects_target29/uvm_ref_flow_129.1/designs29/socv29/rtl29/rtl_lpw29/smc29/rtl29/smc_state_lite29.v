//File29 name   : smc_state_lite29.v
//Title29       : 
//Created29     : 1999
//
//Description29 : SMC29 State29 Machine29
//            : Static29 Memory Controller29
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

`include "smc_defs_lite29.v"

//state machine29 for smc29
  module smc_state_lite29  (
                     //inputs29
  
                     sys_clk29,
                     n_sys_reset29,
                     new_access29,
                     r_cste_count29,
                     r_csle_count29,
                     r_ws_count29,
                     mac_done29,
                     n_read29,
                     n_r_read29,
                     r_csle_store29,
                     r_oete_store29,
                     cs,
                     r_cs29,
             
                     //outputs29
  
                     r_smc_currentstate29,
                     smc_nextstate29,
                     cste_enable29,
                     ws_enable29,
                     smc_done29,
                     valid_access29,
                     le_enable29,
                     latch_data29,
                     smc_idle29);
   
   
   
//Parameters29  -  Values29 in smc_defs29.v



// I29/O29

  input            sys_clk29;           // AHB29 System29 clock29
  input            n_sys_reset29;       // AHB29 System29 reset (Active29 LOW29)
  input            new_access29;        // New29 AHB29 valid access to smc29 
                                          // detected
  input [1:0]      r_cste_count29;      // Chip29 select29 TE29 counter
  input [1:0]      r_csle_count29;      // chip29 select29 leading29 edge count
  input [7:0]      r_ws_count29; // wait state count
  input            mac_done29;          // All cycles29 in a multiple access
  input            n_read29;            // Active29 low29 read signal29
  input            n_r_read29;          // Store29 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store29;      // Chip29 select29 LE29 store29
  input [1:0]      r_oete_store29;      // Read strobe29 TE29 end time before CS29
  input       cs;        // chip29 selects29
  input       r_cs29;      // registered chip29 selects29

  output [4:0]      r_smc_currentstate29;// Synchronised29 SMC29 state machine29
  output [4:0]      smc_nextstate29;     // State29 Machine29 
  output            cste_enable29;       // Enable29 CS29 Trailing29 Edge29 counter
  output            ws_enable29;         // Wait29 state counter enable
  output            smc_done29;          // one access completed
  output            valid_access29;      // load29 values are valid if high29
  output            le_enable29;         // Enable29 all Leading29 Edge29 
                                           // counters29
  output            latch_data29;        // latch_data29 is used by the 
                                           // MAC29 block
                                     //  to store29 read data if CSTE29 > 0
  output            smc_idle29;          // idle29 state



// Output29 register declarations29

  reg [4:0]    smc_nextstate29;     // SMC29 state machine29 (async29 encoding29)
  reg [4:0]    r_smc_currentstate29;// Synchronised29 SMC29 state machine29
  reg          ws_enable29;         // Wait29 state counter enable
  reg          cste_enable29;       // Chip29 select29 counter enable
  reg          smc_done29;         // Asserted29 during last cycle of access
  reg          valid_access29;      // load29 values are valid if high29
  reg          le_enable29;         // Enable29 all Leading29 Edge29 counters29
  reg          latch_data29;        // latch_data29 is used by the MAC29 block
  reg          smc_idle29;          // idle29 state
  


//----------------------------------------------------------------------
// Main29 code29
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC29 state machine29
//----------------------------------------------------------------------
// Generates29 the required29 timings29 for the External29 Memory Interface29.
// If29 back-to-back accesses are required29 the state machine29 will bypass29
// the idle29 state, thus29 maintaining29 the chip29 select29 ouput29.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate29 internal idle29 signal29 used by AHB29 IF
//----------------------------------------------------------------------

  always @(smc_nextstate29)
  
  begin
   
     if (smc_nextstate29 == `SMC_IDLE29)
     
        smc_idle29 = 1'b1;
   
     else
       
        smc_idle29 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate29 internal done signal29
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate29 or r_cste_count29 or r_ws_count29)
  
  begin
   
     if ( ( (r_smc_currentstate29 == `SMC_RW29) &
            (r_ws_count29 == 8'd0) &
            (r_cste_count29 == 2'd0)
          ) |
          ( (r_smc_currentstate29 == `SMC_FLOAT29)  &
            (r_cste_count29 == 2'd0)
          )
        )
       
        smc_done29 = 1'b1;
   
   else
     
      smc_done29 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data29 is used by the MAC29 block to store29 read data if CSTE29 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate29 or r_ws_count29 or r_oete_store29)
  
  begin
   
     if ( (r_smc_currentstate29 == `SMC_RW29) &
          (r_ws_count29[1:0] >= r_oete_store29) &
          (r_ws_count29[7:2] == 6'd0)
        )
     
       latch_data29 = 1'b1;
   
     else
       
       latch_data29 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter29 enable signals29
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate29 or r_csle_count29 or
       smc_nextstate29 or valid_access29)
  begin
     if(valid_access29)
     begin
        if ((smc_nextstate29 == `SMC_RW29)         &
            (r_smc_currentstate29 != `SMC_STORE29) &
            (r_smc_currentstate29 != `SMC_LE29))
  
          ws_enable29 = 1'b1;
  
        else
  
          ws_enable29 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate29 == `SMC_RW29) & 
            (r_csle_count29 == 2'd0) & 
            (r_smc_currentstate29 != `SMC_STORE29) &
            (r_smc_currentstate29 != `SMC_LE29))

           ws_enable29 = 1'b1;
   
        else
  
           ws_enable29 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable29
//----------------------------------------------------------------------

  always @(r_smc_currentstate29 or smc_nextstate29)
  
  begin
  
     if (((smc_nextstate29 == `SMC_LE29) | (smc_nextstate29 == `SMC_RW29) ) &
         (r_smc_currentstate29 != `SMC_STORE29) )
  
        le_enable29 = 1'b1;
  
     else
  
        le_enable29 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable29
//----------------------------------------------------------------------
  
  always @(smc_nextstate29)
  
  begin
     if (smc_nextstate29 == `SMC_FLOAT29)
    
        cste_enable29 = 1'b1;
   
     else
  
        cste_enable29 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH29 if new cycle is waiting29 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate29 or new_access29 or r_ws_count29 or
                                     smc_nextstate29 or mac_done29)
  
  begin
     
     if (new_access29 & mac_done29 &
         (((r_smc_currentstate29 == `SMC_RW29) & 
           (smc_nextstate29 == `SMC_RW29) & 
           (r_ws_count29 == 8'd0))                                |
          ((r_smc_currentstate29 == `SMC_FLOAT29) & 
           (smc_nextstate29 == `SMC_IDLE29) ) |
          ((r_smc_currentstate29 == `SMC_FLOAT29) & 
           (smc_nextstate29 == `SMC_LE29)   ) |
          ((r_smc_currentstate29 == `SMC_FLOAT29) & 
           (smc_nextstate29 == `SMC_RW29)   ) |
          ((r_smc_currentstate29 == `SMC_FLOAT29) & 
           (smc_nextstate29 == `SMC_STORE29)) |
          ((r_smc_currentstate29 == `SMC_RW29)    & 
           (smc_nextstate29 == `SMC_STORE29)) |
          ((r_smc_currentstate29 == `SMC_RW29)    & 
           (smc_nextstate29 == `SMC_IDLE29) ) |
          ((r_smc_currentstate29 == `SMC_RW29)    & 
           (smc_nextstate29 == `SMC_LE29)   ) |
          ((r_smc_currentstate29 == `SMC_IDLE29) ) )  )    
       
       valid_access29 = 1'b1;
     
     else
       
       valid_access29 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC29 State29 Machine29
//----------------------------------------------------------------------

 always @(r_smc_currentstate29 or new_access29 or 
          cs or r_csle_count29 or r_cste_count29 or r_ws_count29 or mac_done29 
          or r_cs29 or n_read29 or n_r_read29 or r_csle_store29)
  begin
   
   case (r_smc_currentstate29)
  
     `SMC_IDLE29 :
  
        if (new_access29 )
 
           smc_nextstate29 = `SMC_STORE29;
  
        else
  
        begin
  
  
           begin

              if (new_access29 )
  
                 smc_nextstate29 = `SMC_RW29;

              else
  
                 smc_nextstate29 = `SMC_IDLE29;

           end
          
        end

     `SMC_STORE29   :

        if ((r_csle_count29 != 2'd0))

           smc_nextstate29 = `SMC_LE29;

        else

        begin
           
           if ( (r_csle_count29 == 2'd0))

              smc_nextstate29 = `SMC_RW29;
           
           else
             
              smc_nextstate29 = `SMC_STORE29;

        end      

     `SMC_LE29   :
  
        if (r_csle_count29 < 2'd2)
  
           smc_nextstate29 = `SMC_RW29;
  
        else
  
           smc_nextstate29 = `SMC_LE29;
  
     `SMC_RW29   :
  
     begin
          
        if ((r_ws_count29 == 8'd0) & 
            (r_cste_count29 != 2'd0))
  
           smc_nextstate29 = `SMC_FLOAT29;
          
        else if ((r_ws_count29 == 8'd0) &
                 (r_cste_count29 == 2'h0) &
                 mac_done29 & ~new_access29)

           smc_nextstate29 = `SMC_IDLE29;
          
        else if ((~mac_done29 & (r_csle_store29 != 2'd0)) &
                 (r_ws_count29 == 8'd0))
 
           smc_nextstate29 = `SMC_LE29;

        
        else
          
        begin
  
           if  ( ((n_read29 != n_r_read29) | ((cs != r_cs29) & ~n_r_read29)) & 
                  new_access29 & mac_done29 &
                 (r_ws_count29 == 8'd0))   
             
              smc_nextstate29 = `SMC_STORE29;
           
           else
             
              smc_nextstate29 = `SMC_RW29;
           
        end
        
     end
  
     `SMC_FLOAT29   :
        if (~ mac_done29                               & 
            (( & new_access29) | 
             ((r_csle_store29 == 2'd0)            &
              ~new_access29)) &  (r_cste_count29 == 2'd0) )
  
           smc_nextstate29 = `SMC_RW29;
  
        else if (new_access29                              & 
                 (( new_access29) |
                  ((r_csle_store29 == 2'd0)            & 
                   ~new_access29)) & (r_cste_count29 == 2'd0) )

        begin
  
           if  (((n_read29 != n_r_read29) | ((cs != r_cs29) & ~n_r_read29)))   
  
              smc_nextstate29 = `SMC_STORE29;
  
           else
  
              smc_nextstate29 = `SMC_RW29;
  
        end
     
        else
          
        begin
  
           if ((~mac_done29 & (r_csle_store29 != 2'd0)) & 
               (r_cste_count29 < 2'd1))
  
              smc_nextstate29 = `SMC_LE29;

           
           else
             
           begin
           
              if (r_cste_count29 == 2'd0)
             
                 smc_nextstate29 = `SMC_IDLE29;
           
              else
  
                 smc_nextstate29 = `SMC_FLOAT29;
  
           end
           
        end
     
     default   :
       
       smc_nextstate29 = `SMC_IDLE29;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential29 process of state machine29
//----------------------------------------------------------------------

  always @(posedge sys_clk29 or negedge n_sys_reset29)
  
  begin
  
     if (~n_sys_reset29)
  
        r_smc_currentstate29 <= `SMC_IDLE29;
  
  
     else   
       
        r_smc_currentstate29 <= smc_nextstate29;
  
  
  end

   

   
endmodule


