//File23 name   : smc_state_lite23.v
//Title23       : 
//Created23     : 1999
//
//Description23 : SMC23 State23 Machine23
//            : Static23 Memory Controller23
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

`include "smc_defs_lite23.v"

//state machine23 for smc23
  module smc_state_lite23  (
                     //inputs23
  
                     sys_clk23,
                     n_sys_reset23,
                     new_access23,
                     r_cste_count23,
                     r_csle_count23,
                     r_ws_count23,
                     mac_done23,
                     n_read23,
                     n_r_read23,
                     r_csle_store23,
                     r_oete_store23,
                     cs,
                     r_cs23,
             
                     //outputs23
  
                     r_smc_currentstate23,
                     smc_nextstate23,
                     cste_enable23,
                     ws_enable23,
                     smc_done23,
                     valid_access23,
                     le_enable23,
                     latch_data23,
                     smc_idle23);
   
   
   
//Parameters23  -  Values23 in smc_defs23.v



// I23/O23

  input            sys_clk23;           // AHB23 System23 clock23
  input            n_sys_reset23;       // AHB23 System23 reset (Active23 LOW23)
  input            new_access23;        // New23 AHB23 valid access to smc23 
                                          // detected
  input [1:0]      r_cste_count23;      // Chip23 select23 TE23 counter
  input [1:0]      r_csle_count23;      // chip23 select23 leading23 edge count
  input [7:0]      r_ws_count23; // wait state count
  input            mac_done23;          // All cycles23 in a multiple access
  input            n_read23;            // Active23 low23 read signal23
  input            n_r_read23;          // Store23 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store23;      // Chip23 select23 LE23 store23
  input [1:0]      r_oete_store23;      // Read strobe23 TE23 end time before CS23
  input       cs;        // chip23 selects23
  input       r_cs23;      // registered chip23 selects23

  output [4:0]      r_smc_currentstate23;// Synchronised23 SMC23 state machine23
  output [4:0]      smc_nextstate23;     // State23 Machine23 
  output            cste_enable23;       // Enable23 CS23 Trailing23 Edge23 counter
  output            ws_enable23;         // Wait23 state counter enable
  output            smc_done23;          // one access completed
  output            valid_access23;      // load23 values are valid if high23
  output            le_enable23;         // Enable23 all Leading23 Edge23 
                                           // counters23
  output            latch_data23;        // latch_data23 is used by the 
                                           // MAC23 block
                                     //  to store23 read data if CSTE23 > 0
  output            smc_idle23;          // idle23 state



// Output23 register declarations23

  reg [4:0]    smc_nextstate23;     // SMC23 state machine23 (async23 encoding23)
  reg [4:0]    r_smc_currentstate23;// Synchronised23 SMC23 state machine23
  reg          ws_enable23;         // Wait23 state counter enable
  reg          cste_enable23;       // Chip23 select23 counter enable
  reg          smc_done23;         // Asserted23 during last cycle of access
  reg          valid_access23;      // load23 values are valid if high23
  reg          le_enable23;         // Enable23 all Leading23 Edge23 counters23
  reg          latch_data23;        // latch_data23 is used by the MAC23 block
  reg          smc_idle23;          // idle23 state
  


//----------------------------------------------------------------------
// Main23 code23
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC23 state machine23
//----------------------------------------------------------------------
// Generates23 the required23 timings23 for the External23 Memory Interface23.
// If23 back-to-back accesses are required23 the state machine23 will bypass23
// the idle23 state, thus23 maintaining23 the chip23 select23 ouput23.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate23 internal idle23 signal23 used by AHB23 IF
//----------------------------------------------------------------------

  always @(smc_nextstate23)
  
  begin
   
     if (smc_nextstate23 == `SMC_IDLE23)
     
        smc_idle23 = 1'b1;
   
     else
       
        smc_idle23 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate23 internal done signal23
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate23 or r_cste_count23 or r_ws_count23)
  
  begin
   
     if ( ( (r_smc_currentstate23 == `SMC_RW23) &
            (r_ws_count23 == 8'd0) &
            (r_cste_count23 == 2'd0)
          ) |
          ( (r_smc_currentstate23 == `SMC_FLOAT23)  &
            (r_cste_count23 == 2'd0)
          )
        )
       
        smc_done23 = 1'b1;
   
   else
     
      smc_done23 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data23 is used by the MAC23 block to store23 read data if CSTE23 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate23 or r_ws_count23 or r_oete_store23)
  
  begin
   
     if ( (r_smc_currentstate23 == `SMC_RW23) &
          (r_ws_count23[1:0] >= r_oete_store23) &
          (r_ws_count23[7:2] == 6'd0)
        )
     
       latch_data23 = 1'b1;
   
     else
       
       latch_data23 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter23 enable signals23
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate23 or r_csle_count23 or
       smc_nextstate23 or valid_access23)
  begin
     if(valid_access23)
     begin
        if ((smc_nextstate23 == `SMC_RW23)         &
            (r_smc_currentstate23 != `SMC_STORE23) &
            (r_smc_currentstate23 != `SMC_LE23))
  
          ws_enable23 = 1'b1;
  
        else
  
          ws_enable23 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate23 == `SMC_RW23) & 
            (r_csle_count23 == 2'd0) & 
            (r_smc_currentstate23 != `SMC_STORE23) &
            (r_smc_currentstate23 != `SMC_LE23))

           ws_enable23 = 1'b1;
   
        else
  
           ws_enable23 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable23
//----------------------------------------------------------------------

  always @(r_smc_currentstate23 or smc_nextstate23)
  
  begin
  
     if (((smc_nextstate23 == `SMC_LE23) | (smc_nextstate23 == `SMC_RW23) ) &
         (r_smc_currentstate23 != `SMC_STORE23) )
  
        le_enable23 = 1'b1;
  
     else
  
        le_enable23 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable23
//----------------------------------------------------------------------
  
  always @(smc_nextstate23)
  
  begin
     if (smc_nextstate23 == `SMC_FLOAT23)
    
        cste_enable23 = 1'b1;
   
     else
  
        cste_enable23 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH23 if new cycle is waiting23 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate23 or new_access23 or r_ws_count23 or
                                     smc_nextstate23 or mac_done23)
  
  begin
     
     if (new_access23 & mac_done23 &
         (((r_smc_currentstate23 == `SMC_RW23) & 
           (smc_nextstate23 == `SMC_RW23) & 
           (r_ws_count23 == 8'd0))                                |
          ((r_smc_currentstate23 == `SMC_FLOAT23) & 
           (smc_nextstate23 == `SMC_IDLE23) ) |
          ((r_smc_currentstate23 == `SMC_FLOAT23) & 
           (smc_nextstate23 == `SMC_LE23)   ) |
          ((r_smc_currentstate23 == `SMC_FLOAT23) & 
           (smc_nextstate23 == `SMC_RW23)   ) |
          ((r_smc_currentstate23 == `SMC_FLOAT23) & 
           (smc_nextstate23 == `SMC_STORE23)) |
          ((r_smc_currentstate23 == `SMC_RW23)    & 
           (smc_nextstate23 == `SMC_STORE23)) |
          ((r_smc_currentstate23 == `SMC_RW23)    & 
           (smc_nextstate23 == `SMC_IDLE23) ) |
          ((r_smc_currentstate23 == `SMC_RW23)    & 
           (smc_nextstate23 == `SMC_LE23)   ) |
          ((r_smc_currentstate23 == `SMC_IDLE23) ) )  )    
       
       valid_access23 = 1'b1;
     
     else
       
       valid_access23 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC23 State23 Machine23
//----------------------------------------------------------------------

 always @(r_smc_currentstate23 or new_access23 or 
          cs or r_csle_count23 or r_cste_count23 or r_ws_count23 or mac_done23 
          or r_cs23 or n_read23 or n_r_read23 or r_csle_store23)
  begin
   
   case (r_smc_currentstate23)
  
     `SMC_IDLE23 :
  
        if (new_access23 )
 
           smc_nextstate23 = `SMC_STORE23;
  
        else
  
        begin
  
  
           begin

              if (new_access23 )
  
                 smc_nextstate23 = `SMC_RW23;

              else
  
                 smc_nextstate23 = `SMC_IDLE23;

           end
          
        end

     `SMC_STORE23   :

        if ((r_csle_count23 != 2'd0))

           smc_nextstate23 = `SMC_LE23;

        else

        begin
           
           if ( (r_csle_count23 == 2'd0))

              smc_nextstate23 = `SMC_RW23;
           
           else
             
              smc_nextstate23 = `SMC_STORE23;

        end      

     `SMC_LE23   :
  
        if (r_csle_count23 < 2'd2)
  
           smc_nextstate23 = `SMC_RW23;
  
        else
  
           smc_nextstate23 = `SMC_LE23;
  
     `SMC_RW23   :
  
     begin
          
        if ((r_ws_count23 == 8'd0) & 
            (r_cste_count23 != 2'd0))
  
           smc_nextstate23 = `SMC_FLOAT23;
          
        else if ((r_ws_count23 == 8'd0) &
                 (r_cste_count23 == 2'h0) &
                 mac_done23 & ~new_access23)

           smc_nextstate23 = `SMC_IDLE23;
          
        else if ((~mac_done23 & (r_csle_store23 != 2'd0)) &
                 (r_ws_count23 == 8'd0))
 
           smc_nextstate23 = `SMC_LE23;

        
        else
          
        begin
  
           if  ( ((n_read23 != n_r_read23) | ((cs != r_cs23) & ~n_r_read23)) & 
                  new_access23 & mac_done23 &
                 (r_ws_count23 == 8'd0))   
             
              smc_nextstate23 = `SMC_STORE23;
           
           else
             
              smc_nextstate23 = `SMC_RW23;
           
        end
        
     end
  
     `SMC_FLOAT23   :
        if (~ mac_done23                               & 
            (( & new_access23) | 
             ((r_csle_store23 == 2'd0)            &
              ~new_access23)) &  (r_cste_count23 == 2'd0) )
  
           smc_nextstate23 = `SMC_RW23;
  
        else if (new_access23                              & 
                 (( new_access23) |
                  ((r_csle_store23 == 2'd0)            & 
                   ~new_access23)) & (r_cste_count23 == 2'd0) )

        begin
  
           if  (((n_read23 != n_r_read23) | ((cs != r_cs23) & ~n_r_read23)))   
  
              smc_nextstate23 = `SMC_STORE23;
  
           else
  
              smc_nextstate23 = `SMC_RW23;
  
        end
     
        else
          
        begin
  
           if ((~mac_done23 & (r_csle_store23 != 2'd0)) & 
               (r_cste_count23 < 2'd1))
  
              smc_nextstate23 = `SMC_LE23;

           
           else
             
           begin
           
              if (r_cste_count23 == 2'd0)
             
                 smc_nextstate23 = `SMC_IDLE23;
           
              else
  
                 smc_nextstate23 = `SMC_FLOAT23;
  
           end
           
        end
     
     default   :
       
       smc_nextstate23 = `SMC_IDLE23;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential23 process of state machine23
//----------------------------------------------------------------------

  always @(posedge sys_clk23 or negedge n_sys_reset23)
  
  begin
  
     if (~n_sys_reset23)
  
        r_smc_currentstate23 <= `SMC_IDLE23;
  
  
     else   
       
        r_smc_currentstate23 <= smc_nextstate23;
  
  
  end

   

   
endmodule


