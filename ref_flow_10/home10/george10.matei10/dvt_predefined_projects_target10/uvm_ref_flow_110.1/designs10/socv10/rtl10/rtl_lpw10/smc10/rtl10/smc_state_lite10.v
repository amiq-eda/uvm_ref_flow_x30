//File10 name   : smc_state_lite10.v
//Title10       : 
//Created10     : 1999
//
//Description10 : SMC10 State10 Machine10
//            : Static10 Memory Controller10
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

`include "smc_defs_lite10.v"

//state machine10 for smc10
  module smc_state_lite10  (
                     //inputs10
  
                     sys_clk10,
                     n_sys_reset10,
                     new_access10,
                     r_cste_count10,
                     r_csle_count10,
                     r_ws_count10,
                     mac_done10,
                     n_read10,
                     n_r_read10,
                     r_csle_store10,
                     r_oete_store10,
                     cs,
                     r_cs10,
             
                     //outputs10
  
                     r_smc_currentstate10,
                     smc_nextstate10,
                     cste_enable10,
                     ws_enable10,
                     smc_done10,
                     valid_access10,
                     le_enable10,
                     latch_data10,
                     smc_idle10);
   
   
   
//Parameters10  -  Values10 in smc_defs10.v



// I10/O10

  input            sys_clk10;           // AHB10 System10 clock10
  input            n_sys_reset10;       // AHB10 System10 reset (Active10 LOW10)
  input            new_access10;        // New10 AHB10 valid access to smc10 
                                          // detected
  input [1:0]      r_cste_count10;      // Chip10 select10 TE10 counter
  input [1:0]      r_csle_count10;      // chip10 select10 leading10 edge count
  input [7:0]      r_ws_count10; // wait state count
  input            mac_done10;          // All cycles10 in a multiple access
  input            n_read10;            // Active10 low10 read signal10
  input            n_r_read10;          // Store10 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store10;      // Chip10 select10 LE10 store10
  input [1:0]      r_oete_store10;      // Read strobe10 TE10 end time before CS10
  input       cs;        // chip10 selects10
  input       r_cs10;      // registered chip10 selects10

  output [4:0]      r_smc_currentstate10;// Synchronised10 SMC10 state machine10
  output [4:0]      smc_nextstate10;     // State10 Machine10 
  output            cste_enable10;       // Enable10 CS10 Trailing10 Edge10 counter
  output            ws_enable10;         // Wait10 state counter enable
  output            smc_done10;          // one access completed
  output            valid_access10;      // load10 values are valid if high10
  output            le_enable10;         // Enable10 all Leading10 Edge10 
                                           // counters10
  output            latch_data10;        // latch_data10 is used by the 
                                           // MAC10 block
                                     //  to store10 read data if CSTE10 > 0
  output            smc_idle10;          // idle10 state



// Output10 register declarations10

  reg [4:0]    smc_nextstate10;     // SMC10 state machine10 (async10 encoding10)
  reg [4:0]    r_smc_currentstate10;// Synchronised10 SMC10 state machine10
  reg          ws_enable10;         // Wait10 state counter enable
  reg          cste_enable10;       // Chip10 select10 counter enable
  reg          smc_done10;         // Asserted10 during last cycle of access
  reg          valid_access10;      // load10 values are valid if high10
  reg          le_enable10;         // Enable10 all Leading10 Edge10 counters10
  reg          latch_data10;        // latch_data10 is used by the MAC10 block
  reg          smc_idle10;          // idle10 state
  


//----------------------------------------------------------------------
// Main10 code10
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC10 state machine10
//----------------------------------------------------------------------
// Generates10 the required10 timings10 for the External10 Memory Interface10.
// If10 back-to-back accesses are required10 the state machine10 will bypass10
// the idle10 state, thus10 maintaining10 the chip10 select10 ouput10.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate10 internal idle10 signal10 used by AHB10 IF
//----------------------------------------------------------------------

  always @(smc_nextstate10)
  
  begin
   
     if (smc_nextstate10 == `SMC_IDLE10)
     
        smc_idle10 = 1'b1;
   
     else
       
        smc_idle10 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate10 internal done signal10
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate10 or r_cste_count10 or r_ws_count10)
  
  begin
   
     if ( ( (r_smc_currentstate10 == `SMC_RW10) &
            (r_ws_count10 == 8'd0) &
            (r_cste_count10 == 2'd0)
          ) |
          ( (r_smc_currentstate10 == `SMC_FLOAT10)  &
            (r_cste_count10 == 2'd0)
          )
        )
       
        smc_done10 = 1'b1;
   
   else
     
      smc_done10 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data10 is used by the MAC10 block to store10 read data if CSTE10 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate10 or r_ws_count10 or r_oete_store10)
  
  begin
   
     if ( (r_smc_currentstate10 == `SMC_RW10) &
          (r_ws_count10[1:0] >= r_oete_store10) &
          (r_ws_count10[7:2] == 6'd0)
        )
     
       latch_data10 = 1'b1;
   
     else
       
       latch_data10 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter10 enable signals10
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate10 or r_csle_count10 or
       smc_nextstate10 or valid_access10)
  begin
     if(valid_access10)
     begin
        if ((smc_nextstate10 == `SMC_RW10)         &
            (r_smc_currentstate10 != `SMC_STORE10) &
            (r_smc_currentstate10 != `SMC_LE10))
  
          ws_enable10 = 1'b1;
  
        else
  
          ws_enable10 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate10 == `SMC_RW10) & 
            (r_csle_count10 == 2'd0) & 
            (r_smc_currentstate10 != `SMC_STORE10) &
            (r_smc_currentstate10 != `SMC_LE10))

           ws_enable10 = 1'b1;
   
        else
  
           ws_enable10 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable10
//----------------------------------------------------------------------

  always @(r_smc_currentstate10 or smc_nextstate10)
  
  begin
  
     if (((smc_nextstate10 == `SMC_LE10) | (smc_nextstate10 == `SMC_RW10) ) &
         (r_smc_currentstate10 != `SMC_STORE10) )
  
        le_enable10 = 1'b1;
  
     else
  
        le_enable10 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable10
//----------------------------------------------------------------------
  
  always @(smc_nextstate10)
  
  begin
     if (smc_nextstate10 == `SMC_FLOAT10)
    
        cste_enable10 = 1'b1;
   
     else
  
        cste_enable10 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH10 if new cycle is waiting10 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate10 or new_access10 or r_ws_count10 or
                                     smc_nextstate10 or mac_done10)
  
  begin
     
     if (new_access10 & mac_done10 &
         (((r_smc_currentstate10 == `SMC_RW10) & 
           (smc_nextstate10 == `SMC_RW10) & 
           (r_ws_count10 == 8'd0))                                |
          ((r_smc_currentstate10 == `SMC_FLOAT10) & 
           (smc_nextstate10 == `SMC_IDLE10) ) |
          ((r_smc_currentstate10 == `SMC_FLOAT10) & 
           (smc_nextstate10 == `SMC_LE10)   ) |
          ((r_smc_currentstate10 == `SMC_FLOAT10) & 
           (smc_nextstate10 == `SMC_RW10)   ) |
          ((r_smc_currentstate10 == `SMC_FLOAT10) & 
           (smc_nextstate10 == `SMC_STORE10)) |
          ((r_smc_currentstate10 == `SMC_RW10)    & 
           (smc_nextstate10 == `SMC_STORE10)) |
          ((r_smc_currentstate10 == `SMC_RW10)    & 
           (smc_nextstate10 == `SMC_IDLE10) ) |
          ((r_smc_currentstate10 == `SMC_RW10)    & 
           (smc_nextstate10 == `SMC_LE10)   ) |
          ((r_smc_currentstate10 == `SMC_IDLE10) ) )  )    
       
       valid_access10 = 1'b1;
     
     else
       
       valid_access10 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC10 State10 Machine10
//----------------------------------------------------------------------

 always @(r_smc_currentstate10 or new_access10 or 
          cs or r_csle_count10 or r_cste_count10 or r_ws_count10 or mac_done10 
          or r_cs10 or n_read10 or n_r_read10 or r_csle_store10)
  begin
   
   case (r_smc_currentstate10)
  
     `SMC_IDLE10 :
  
        if (new_access10 )
 
           smc_nextstate10 = `SMC_STORE10;
  
        else
  
        begin
  
  
           begin

              if (new_access10 )
  
                 smc_nextstate10 = `SMC_RW10;

              else
  
                 smc_nextstate10 = `SMC_IDLE10;

           end
          
        end

     `SMC_STORE10   :

        if ((r_csle_count10 != 2'd0))

           smc_nextstate10 = `SMC_LE10;

        else

        begin
           
           if ( (r_csle_count10 == 2'd0))

              smc_nextstate10 = `SMC_RW10;
           
           else
             
              smc_nextstate10 = `SMC_STORE10;

        end      

     `SMC_LE10   :
  
        if (r_csle_count10 < 2'd2)
  
           smc_nextstate10 = `SMC_RW10;
  
        else
  
           smc_nextstate10 = `SMC_LE10;
  
     `SMC_RW10   :
  
     begin
          
        if ((r_ws_count10 == 8'd0) & 
            (r_cste_count10 != 2'd0))
  
           smc_nextstate10 = `SMC_FLOAT10;
          
        else if ((r_ws_count10 == 8'd0) &
                 (r_cste_count10 == 2'h0) &
                 mac_done10 & ~new_access10)

           smc_nextstate10 = `SMC_IDLE10;
          
        else if ((~mac_done10 & (r_csle_store10 != 2'd0)) &
                 (r_ws_count10 == 8'd0))
 
           smc_nextstate10 = `SMC_LE10;

        
        else
          
        begin
  
           if  ( ((n_read10 != n_r_read10) | ((cs != r_cs10) & ~n_r_read10)) & 
                  new_access10 & mac_done10 &
                 (r_ws_count10 == 8'd0))   
             
              smc_nextstate10 = `SMC_STORE10;
           
           else
             
              smc_nextstate10 = `SMC_RW10;
           
        end
        
     end
  
     `SMC_FLOAT10   :
        if (~ mac_done10                               & 
            (( & new_access10) | 
             ((r_csle_store10 == 2'd0)            &
              ~new_access10)) &  (r_cste_count10 == 2'd0) )
  
           smc_nextstate10 = `SMC_RW10;
  
        else if (new_access10                              & 
                 (( new_access10) |
                  ((r_csle_store10 == 2'd0)            & 
                   ~new_access10)) & (r_cste_count10 == 2'd0) )

        begin
  
           if  (((n_read10 != n_r_read10) | ((cs != r_cs10) & ~n_r_read10)))   
  
              smc_nextstate10 = `SMC_STORE10;
  
           else
  
              smc_nextstate10 = `SMC_RW10;
  
        end
     
        else
          
        begin
  
           if ((~mac_done10 & (r_csle_store10 != 2'd0)) & 
               (r_cste_count10 < 2'd1))
  
              smc_nextstate10 = `SMC_LE10;

           
           else
             
           begin
           
              if (r_cste_count10 == 2'd0)
             
                 smc_nextstate10 = `SMC_IDLE10;
           
              else
  
                 smc_nextstate10 = `SMC_FLOAT10;
  
           end
           
        end
     
     default   :
       
       smc_nextstate10 = `SMC_IDLE10;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential10 process of state machine10
//----------------------------------------------------------------------

  always @(posedge sys_clk10 or negedge n_sys_reset10)
  
  begin
  
     if (~n_sys_reset10)
  
        r_smc_currentstate10 <= `SMC_IDLE10;
  
  
     else   
       
        r_smc_currentstate10 <= smc_nextstate10;
  
  
  end

   

   
endmodule


