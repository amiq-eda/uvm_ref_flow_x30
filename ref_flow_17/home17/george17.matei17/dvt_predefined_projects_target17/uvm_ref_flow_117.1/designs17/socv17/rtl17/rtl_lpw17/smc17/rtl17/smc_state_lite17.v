//File17 name   : smc_state_lite17.v
//Title17       : 
//Created17     : 1999
//
//Description17 : SMC17 State17 Machine17
//            : Static17 Memory Controller17
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

`include "smc_defs_lite17.v"

//state machine17 for smc17
  module smc_state_lite17  (
                     //inputs17
  
                     sys_clk17,
                     n_sys_reset17,
                     new_access17,
                     r_cste_count17,
                     r_csle_count17,
                     r_ws_count17,
                     mac_done17,
                     n_read17,
                     n_r_read17,
                     r_csle_store17,
                     r_oete_store17,
                     cs,
                     r_cs17,
             
                     //outputs17
  
                     r_smc_currentstate17,
                     smc_nextstate17,
                     cste_enable17,
                     ws_enable17,
                     smc_done17,
                     valid_access17,
                     le_enable17,
                     latch_data17,
                     smc_idle17);
   
   
   
//Parameters17  -  Values17 in smc_defs17.v



// I17/O17

  input            sys_clk17;           // AHB17 System17 clock17
  input            n_sys_reset17;       // AHB17 System17 reset (Active17 LOW17)
  input            new_access17;        // New17 AHB17 valid access to smc17 
                                          // detected
  input [1:0]      r_cste_count17;      // Chip17 select17 TE17 counter
  input [1:0]      r_csle_count17;      // chip17 select17 leading17 edge count
  input [7:0]      r_ws_count17; // wait state count
  input            mac_done17;          // All cycles17 in a multiple access
  input            n_read17;            // Active17 low17 read signal17
  input            n_r_read17;          // Store17 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store17;      // Chip17 select17 LE17 store17
  input [1:0]      r_oete_store17;      // Read strobe17 TE17 end time before CS17
  input       cs;        // chip17 selects17
  input       r_cs17;      // registered chip17 selects17

  output [4:0]      r_smc_currentstate17;// Synchronised17 SMC17 state machine17
  output [4:0]      smc_nextstate17;     // State17 Machine17 
  output            cste_enable17;       // Enable17 CS17 Trailing17 Edge17 counter
  output            ws_enable17;         // Wait17 state counter enable
  output            smc_done17;          // one access completed
  output            valid_access17;      // load17 values are valid if high17
  output            le_enable17;         // Enable17 all Leading17 Edge17 
                                           // counters17
  output            latch_data17;        // latch_data17 is used by the 
                                           // MAC17 block
                                     //  to store17 read data if CSTE17 > 0
  output            smc_idle17;          // idle17 state



// Output17 register declarations17

  reg [4:0]    smc_nextstate17;     // SMC17 state machine17 (async17 encoding17)
  reg [4:0]    r_smc_currentstate17;// Synchronised17 SMC17 state machine17
  reg          ws_enable17;         // Wait17 state counter enable
  reg          cste_enable17;       // Chip17 select17 counter enable
  reg          smc_done17;         // Asserted17 during last cycle of access
  reg          valid_access17;      // load17 values are valid if high17
  reg          le_enable17;         // Enable17 all Leading17 Edge17 counters17
  reg          latch_data17;        // latch_data17 is used by the MAC17 block
  reg          smc_idle17;          // idle17 state
  


//----------------------------------------------------------------------
// Main17 code17
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC17 state machine17
//----------------------------------------------------------------------
// Generates17 the required17 timings17 for the External17 Memory Interface17.
// If17 back-to-back accesses are required17 the state machine17 will bypass17
// the idle17 state, thus17 maintaining17 the chip17 select17 ouput17.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate17 internal idle17 signal17 used by AHB17 IF
//----------------------------------------------------------------------

  always @(smc_nextstate17)
  
  begin
   
     if (smc_nextstate17 == `SMC_IDLE17)
     
        smc_idle17 = 1'b1;
   
     else
       
        smc_idle17 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate17 internal done signal17
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate17 or r_cste_count17 or r_ws_count17)
  
  begin
   
     if ( ( (r_smc_currentstate17 == `SMC_RW17) &
            (r_ws_count17 == 8'd0) &
            (r_cste_count17 == 2'd0)
          ) |
          ( (r_smc_currentstate17 == `SMC_FLOAT17)  &
            (r_cste_count17 == 2'd0)
          )
        )
       
        smc_done17 = 1'b1;
   
   else
     
      smc_done17 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data17 is used by the MAC17 block to store17 read data if CSTE17 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate17 or r_ws_count17 or r_oete_store17)
  
  begin
   
     if ( (r_smc_currentstate17 == `SMC_RW17) &
          (r_ws_count17[1:0] >= r_oete_store17) &
          (r_ws_count17[7:2] == 6'd0)
        )
     
       latch_data17 = 1'b1;
   
     else
       
       latch_data17 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter17 enable signals17
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate17 or r_csle_count17 or
       smc_nextstate17 or valid_access17)
  begin
     if(valid_access17)
     begin
        if ((smc_nextstate17 == `SMC_RW17)         &
            (r_smc_currentstate17 != `SMC_STORE17) &
            (r_smc_currentstate17 != `SMC_LE17))
  
          ws_enable17 = 1'b1;
  
        else
  
          ws_enable17 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate17 == `SMC_RW17) & 
            (r_csle_count17 == 2'd0) & 
            (r_smc_currentstate17 != `SMC_STORE17) &
            (r_smc_currentstate17 != `SMC_LE17))

           ws_enable17 = 1'b1;
   
        else
  
           ws_enable17 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable17
//----------------------------------------------------------------------

  always @(r_smc_currentstate17 or smc_nextstate17)
  
  begin
  
     if (((smc_nextstate17 == `SMC_LE17) | (smc_nextstate17 == `SMC_RW17) ) &
         (r_smc_currentstate17 != `SMC_STORE17) )
  
        le_enable17 = 1'b1;
  
     else
  
        le_enable17 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable17
//----------------------------------------------------------------------
  
  always @(smc_nextstate17)
  
  begin
     if (smc_nextstate17 == `SMC_FLOAT17)
    
        cste_enable17 = 1'b1;
   
     else
  
        cste_enable17 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH17 if new cycle is waiting17 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate17 or new_access17 or r_ws_count17 or
                                     smc_nextstate17 or mac_done17)
  
  begin
     
     if (new_access17 & mac_done17 &
         (((r_smc_currentstate17 == `SMC_RW17) & 
           (smc_nextstate17 == `SMC_RW17) & 
           (r_ws_count17 == 8'd0))                                |
          ((r_smc_currentstate17 == `SMC_FLOAT17) & 
           (smc_nextstate17 == `SMC_IDLE17) ) |
          ((r_smc_currentstate17 == `SMC_FLOAT17) & 
           (smc_nextstate17 == `SMC_LE17)   ) |
          ((r_smc_currentstate17 == `SMC_FLOAT17) & 
           (smc_nextstate17 == `SMC_RW17)   ) |
          ((r_smc_currentstate17 == `SMC_FLOAT17) & 
           (smc_nextstate17 == `SMC_STORE17)) |
          ((r_smc_currentstate17 == `SMC_RW17)    & 
           (smc_nextstate17 == `SMC_STORE17)) |
          ((r_smc_currentstate17 == `SMC_RW17)    & 
           (smc_nextstate17 == `SMC_IDLE17) ) |
          ((r_smc_currentstate17 == `SMC_RW17)    & 
           (smc_nextstate17 == `SMC_LE17)   ) |
          ((r_smc_currentstate17 == `SMC_IDLE17) ) )  )    
       
       valid_access17 = 1'b1;
     
     else
       
       valid_access17 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC17 State17 Machine17
//----------------------------------------------------------------------

 always @(r_smc_currentstate17 or new_access17 or 
          cs or r_csle_count17 or r_cste_count17 or r_ws_count17 or mac_done17 
          or r_cs17 or n_read17 or n_r_read17 or r_csle_store17)
  begin
   
   case (r_smc_currentstate17)
  
     `SMC_IDLE17 :
  
        if (new_access17 )
 
           smc_nextstate17 = `SMC_STORE17;
  
        else
  
        begin
  
  
           begin

              if (new_access17 )
  
                 smc_nextstate17 = `SMC_RW17;

              else
  
                 smc_nextstate17 = `SMC_IDLE17;

           end
          
        end

     `SMC_STORE17   :

        if ((r_csle_count17 != 2'd0))

           smc_nextstate17 = `SMC_LE17;

        else

        begin
           
           if ( (r_csle_count17 == 2'd0))

              smc_nextstate17 = `SMC_RW17;
           
           else
             
              smc_nextstate17 = `SMC_STORE17;

        end      

     `SMC_LE17   :
  
        if (r_csle_count17 < 2'd2)
  
           smc_nextstate17 = `SMC_RW17;
  
        else
  
           smc_nextstate17 = `SMC_LE17;
  
     `SMC_RW17   :
  
     begin
          
        if ((r_ws_count17 == 8'd0) & 
            (r_cste_count17 != 2'd0))
  
           smc_nextstate17 = `SMC_FLOAT17;
          
        else if ((r_ws_count17 == 8'd0) &
                 (r_cste_count17 == 2'h0) &
                 mac_done17 & ~new_access17)

           smc_nextstate17 = `SMC_IDLE17;
          
        else if ((~mac_done17 & (r_csle_store17 != 2'd0)) &
                 (r_ws_count17 == 8'd0))
 
           smc_nextstate17 = `SMC_LE17;

        
        else
          
        begin
  
           if  ( ((n_read17 != n_r_read17) | ((cs != r_cs17) & ~n_r_read17)) & 
                  new_access17 & mac_done17 &
                 (r_ws_count17 == 8'd0))   
             
              smc_nextstate17 = `SMC_STORE17;
           
           else
             
              smc_nextstate17 = `SMC_RW17;
           
        end
        
     end
  
     `SMC_FLOAT17   :
        if (~ mac_done17                               & 
            (( & new_access17) | 
             ((r_csle_store17 == 2'd0)            &
              ~new_access17)) &  (r_cste_count17 == 2'd0) )
  
           smc_nextstate17 = `SMC_RW17;
  
        else if (new_access17                              & 
                 (( new_access17) |
                  ((r_csle_store17 == 2'd0)            & 
                   ~new_access17)) & (r_cste_count17 == 2'd0) )

        begin
  
           if  (((n_read17 != n_r_read17) | ((cs != r_cs17) & ~n_r_read17)))   
  
              smc_nextstate17 = `SMC_STORE17;
  
           else
  
              smc_nextstate17 = `SMC_RW17;
  
        end
     
        else
          
        begin
  
           if ((~mac_done17 & (r_csle_store17 != 2'd0)) & 
               (r_cste_count17 < 2'd1))
  
              smc_nextstate17 = `SMC_LE17;

           
           else
             
           begin
           
              if (r_cste_count17 == 2'd0)
             
                 smc_nextstate17 = `SMC_IDLE17;
           
              else
  
                 smc_nextstate17 = `SMC_FLOAT17;
  
           end
           
        end
     
     default   :
       
       smc_nextstate17 = `SMC_IDLE17;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential17 process of state machine17
//----------------------------------------------------------------------

  always @(posedge sys_clk17 or negedge n_sys_reset17)
  
  begin
  
     if (~n_sys_reset17)
  
        r_smc_currentstate17 <= `SMC_IDLE17;
  
  
     else   
       
        r_smc_currentstate17 <= smc_nextstate17;
  
  
  end

   

   
endmodule


