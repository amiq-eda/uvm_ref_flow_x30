//File22 name   : smc_state_lite22.v
//Title22       : 
//Created22     : 1999
//
//Description22 : SMC22 State22 Machine22
//            : Static22 Memory Controller22
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

`include "smc_defs_lite22.v"

//state machine22 for smc22
  module smc_state_lite22  (
                     //inputs22
  
                     sys_clk22,
                     n_sys_reset22,
                     new_access22,
                     r_cste_count22,
                     r_csle_count22,
                     r_ws_count22,
                     mac_done22,
                     n_read22,
                     n_r_read22,
                     r_csle_store22,
                     r_oete_store22,
                     cs,
                     r_cs22,
             
                     //outputs22
  
                     r_smc_currentstate22,
                     smc_nextstate22,
                     cste_enable22,
                     ws_enable22,
                     smc_done22,
                     valid_access22,
                     le_enable22,
                     latch_data22,
                     smc_idle22);
   
   
   
//Parameters22  -  Values22 in smc_defs22.v



// I22/O22

  input            sys_clk22;           // AHB22 System22 clock22
  input            n_sys_reset22;       // AHB22 System22 reset (Active22 LOW22)
  input            new_access22;        // New22 AHB22 valid access to smc22 
                                          // detected
  input [1:0]      r_cste_count22;      // Chip22 select22 TE22 counter
  input [1:0]      r_csle_count22;      // chip22 select22 leading22 edge count
  input [7:0]      r_ws_count22; // wait state count
  input            mac_done22;          // All cycles22 in a multiple access
  input            n_read22;            // Active22 low22 read signal22
  input            n_r_read22;          // Store22 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store22;      // Chip22 select22 LE22 store22
  input [1:0]      r_oete_store22;      // Read strobe22 TE22 end time before CS22
  input       cs;        // chip22 selects22
  input       r_cs22;      // registered chip22 selects22

  output [4:0]      r_smc_currentstate22;// Synchronised22 SMC22 state machine22
  output [4:0]      smc_nextstate22;     // State22 Machine22 
  output            cste_enable22;       // Enable22 CS22 Trailing22 Edge22 counter
  output            ws_enable22;         // Wait22 state counter enable
  output            smc_done22;          // one access completed
  output            valid_access22;      // load22 values are valid if high22
  output            le_enable22;         // Enable22 all Leading22 Edge22 
                                           // counters22
  output            latch_data22;        // latch_data22 is used by the 
                                           // MAC22 block
                                     //  to store22 read data if CSTE22 > 0
  output            smc_idle22;          // idle22 state



// Output22 register declarations22

  reg [4:0]    smc_nextstate22;     // SMC22 state machine22 (async22 encoding22)
  reg [4:0]    r_smc_currentstate22;// Synchronised22 SMC22 state machine22
  reg          ws_enable22;         // Wait22 state counter enable
  reg          cste_enable22;       // Chip22 select22 counter enable
  reg          smc_done22;         // Asserted22 during last cycle of access
  reg          valid_access22;      // load22 values are valid if high22
  reg          le_enable22;         // Enable22 all Leading22 Edge22 counters22
  reg          latch_data22;        // latch_data22 is used by the MAC22 block
  reg          smc_idle22;          // idle22 state
  


//----------------------------------------------------------------------
// Main22 code22
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC22 state machine22
//----------------------------------------------------------------------
// Generates22 the required22 timings22 for the External22 Memory Interface22.
// If22 back-to-back accesses are required22 the state machine22 will bypass22
// the idle22 state, thus22 maintaining22 the chip22 select22 ouput22.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate22 internal idle22 signal22 used by AHB22 IF
//----------------------------------------------------------------------

  always @(smc_nextstate22)
  
  begin
   
     if (smc_nextstate22 == `SMC_IDLE22)
     
        smc_idle22 = 1'b1;
   
     else
       
        smc_idle22 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate22 internal done signal22
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate22 or r_cste_count22 or r_ws_count22)
  
  begin
   
     if ( ( (r_smc_currentstate22 == `SMC_RW22) &
            (r_ws_count22 == 8'd0) &
            (r_cste_count22 == 2'd0)
          ) |
          ( (r_smc_currentstate22 == `SMC_FLOAT22)  &
            (r_cste_count22 == 2'd0)
          )
        )
       
        smc_done22 = 1'b1;
   
   else
     
      smc_done22 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data22 is used by the MAC22 block to store22 read data if CSTE22 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate22 or r_ws_count22 or r_oete_store22)
  
  begin
   
     if ( (r_smc_currentstate22 == `SMC_RW22) &
          (r_ws_count22[1:0] >= r_oete_store22) &
          (r_ws_count22[7:2] == 6'd0)
        )
     
       latch_data22 = 1'b1;
   
     else
       
       latch_data22 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter22 enable signals22
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate22 or r_csle_count22 or
       smc_nextstate22 or valid_access22)
  begin
     if(valid_access22)
     begin
        if ((smc_nextstate22 == `SMC_RW22)         &
            (r_smc_currentstate22 != `SMC_STORE22) &
            (r_smc_currentstate22 != `SMC_LE22))
  
          ws_enable22 = 1'b1;
  
        else
  
          ws_enable22 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate22 == `SMC_RW22) & 
            (r_csle_count22 == 2'd0) & 
            (r_smc_currentstate22 != `SMC_STORE22) &
            (r_smc_currentstate22 != `SMC_LE22))

           ws_enable22 = 1'b1;
   
        else
  
           ws_enable22 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable22
//----------------------------------------------------------------------

  always @(r_smc_currentstate22 or smc_nextstate22)
  
  begin
  
     if (((smc_nextstate22 == `SMC_LE22) | (smc_nextstate22 == `SMC_RW22) ) &
         (r_smc_currentstate22 != `SMC_STORE22) )
  
        le_enable22 = 1'b1;
  
     else
  
        le_enable22 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable22
//----------------------------------------------------------------------
  
  always @(smc_nextstate22)
  
  begin
     if (smc_nextstate22 == `SMC_FLOAT22)
    
        cste_enable22 = 1'b1;
   
     else
  
        cste_enable22 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH22 if new cycle is waiting22 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate22 or new_access22 or r_ws_count22 or
                                     smc_nextstate22 or mac_done22)
  
  begin
     
     if (new_access22 & mac_done22 &
         (((r_smc_currentstate22 == `SMC_RW22) & 
           (smc_nextstate22 == `SMC_RW22) & 
           (r_ws_count22 == 8'd0))                                |
          ((r_smc_currentstate22 == `SMC_FLOAT22) & 
           (smc_nextstate22 == `SMC_IDLE22) ) |
          ((r_smc_currentstate22 == `SMC_FLOAT22) & 
           (smc_nextstate22 == `SMC_LE22)   ) |
          ((r_smc_currentstate22 == `SMC_FLOAT22) & 
           (smc_nextstate22 == `SMC_RW22)   ) |
          ((r_smc_currentstate22 == `SMC_FLOAT22) & 
           (smc_nextstate22 == `SMC_STORE22)) |
          ((r_smc_currentstate22 == `SMC_RW22)    & 
           (smc_nextstate22 == `SMC_STORE22)) |
          ((r_smc_currentstate22 == `SMC_RW22)    & 
           (smc_nextstate22 == `SMC_IDLE22) ) |
          ((r_smc_currentstate22 == `SMC_RW22)    & 
           (smc_nextstate22 == `SMC_LE22)   ) |
          ((r_smc_currentstate22 == `SMC_IDLE22) ) )  )    
       
       valid_access22 = 1'b1;
     
     else
       
       valid_access22 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC22 State22 Machine22
//----------------------------------------------------------------------

 always @(r_smc_currentstate22 or new_access22 or 
          cs or r_csle_count22 or r_cste_count22 or r_ws_count22 or mac_done22 
          or r_cs22 or n_read22 or n_r_read22 or r_csle_store22)
  begin
   
   case (r_smc_currentstate22)
  
     `SMC_IDLE22 :
  
        if (new_access22 )
 
           smc_nextstate22 = `SMC_STORE22;
  
        else
  
        begin
  
  
           begin

              if (new_access22 )
  
                 smc_nextstate22 = `SMC_RW22;

              else
  
                 smc_nextstate22 = `SMC_IDLE22;

           end
          
        end

     `SMC_STORE22   :

        if ((r_csle_count22 != 2'd0))

           smc_nextstate22 = `SMC_LE22;

        else

        begin
           
           if ( (r_csle_count22 == 2'd0))

              smc_nextstate22 = `SMC_RW22;
           
           else
             
              smc_nextstate22 = `SMC_STORE22;

        end      

     `SMC_LE22   :
  
        if (r_csle_count22 < 2'd2)
  
           smc_nextstate22 = `SMC_RW22;
  
        else
  
           smc_nextstate22 = `SMC_LE22;
  
     `SMC_RW22   :
  
     begin
          
        if ((r_ws_count22 == 8'd0) & 
            (r_cste_count22 != 2'd0))
  
           smc_nextstate22 = `SMC_FLOAT22;
          
        else if ((r_ws_count22 == 8'd0) &
                 (r_cste_count22 == 2'h0) &
                 mac_done22 & ~new_access22)

           smc_nextstate22 = `SMC_IDLE22;
          
        else if ((~mac_done22 & (r_csle_store22 != 2'd0)) &
                 (r_ws_count22 == 8'd0))
 
           smc_nextstate22 = `SMC_LE22;

        
        else
          
        begin
  
           if  ( ((n_read22 != n_r_read22) | ((cs != r_cs22) & ~n_r_read22)) & 
                  new_access22 & mac_done22 &
                 (r_ws_count22 == 8'd0))   
             
              smc_nextstate22 = `SMC_STORE22;
           
           else
             
              smc_nextstate22 = `SMC_RW22;
           
        end
        
     end
  
     `SMC_FLOAT22   :
        if (~ mac_done22                               & 
            (( & new_access22) | 
             ((r_csle_store22 == 2'd0)            &
              ~new_access22)) &  (r_cste_count22 == 2'd0) )
  
           smc_nextstate22 = `SMC_RW22;
  
        else if (new_access22                              & 
                 (( new_access22) |
                  ((r_csle_store22 == 2'd0)            & 
                   ~new_access22)) & (r_cste_count22 == 2'd0) )

        begin
  
           if  (((n_read22 != n_r_read22) | ((cs != r_cs22) & ~n_r_read22)))   
  
              smc_nextstate22 = `SMC_STORE22;
  
           else
  
              smc_nextstate22 = `SMC_RW22;
  
        end
     
        else
          
        begin
  
           if ((~mac_done22 & (r_csle_store22 != 2'd0)) & 
               (r_cste_count22 < 2'd1))
  
              smc_nextstate22 = `SMC_LE22;

           
           else
             
           begin
           
              if (r_cste_count22 == 2'd0)
             
                 smc_nextstate22 = `SMC_IDLE22;
           
              else
  
                 smc_nextstate22 = `SMC_FLOAT22;
  
           end
           
        end
     
     default   :
       
       smc_nextstate22 = `SMC_IDLE22;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential22 process of state machine22
//----------------------------------------------------------------------

  always @(posedge sys_clk22 or negedge n_sys_reset22)
  
  begin
  
     if (~n_sys_reset22)
  
        r_smc_currentstate22 <= `SMC_IDLE22;
  
  
     else   
       
        r_smc_currentstate22 <= smc_nextstate22;
  
  
  end

   

   
endmodule


