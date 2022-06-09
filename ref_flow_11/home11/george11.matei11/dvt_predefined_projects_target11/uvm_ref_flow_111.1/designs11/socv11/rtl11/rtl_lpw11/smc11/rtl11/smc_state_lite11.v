//File11 name   : smc_state_lite11.v
//Title11       : 
//Created11     : 1999
//
//Description11 : SMC11 State11 Machine11
//            : Static11 Memory Controller11
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

`include "smc_defs_lite11.v"

//state machine11 for smc11
  module smc_state_lite11  (
                     //inputs11
  
                     sys_clk11,
                     n_sys_reset11,
                     new_access11,
                     r_cste_count11,
                     r_csle_count11,
                     r_ws_count11,
                     mac_done11,
                     n_read11,
                     n_r_read11,
                     r_csle_store11,
                     r_oete_store11,
                     cs,
                     r_cs11,
             
                     //outputs11
  
                     r_smc_currentstate11,
                     smc_nextstate11,
                     cste_enable11,
                     ws_enable11,
                     smc_done11,
                     valid_access11,
                     le_enable11,
                     latch_data11,
                     smc_idle11);
   
   
   
//Parameters11  -  Values11 in smc_defs11.v



// I11/O11

  input            sys_clk11;           // AHB11 System11 clock11
  input            n_sys_reset11;       // AHB11 System11 reset (Active11 LOW11)
  input            new_access11;        // New11 AHB11 valid access to smc11 
                                          // detected
  input [1:0]      r_cste_count11;      // Chip11 select11 TE11 counter
  input [1:0]      r_csle_count11;      // chip11 select11 leading11 edge count
  input [7:0]      r_ws_count11; // wait state count
  input            mac_done11;          // All cycles11 in a multiple access
  input            n_read11;            // Active11 low11 read signal11
  input            n_r_read11;          // Store11 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store11;      // Chip11 select11 LE11 store11
  input [1:0]      r_oete_store11;      // Read strobe11 TE11 end time before CS11
  input       cs;        // chip11 selects11
  input       r_cs11;      // registered chip11 selects11

  output [4:0]      r_smc_currentstate11;// Synchronised11 SMC11 state machine11
  output [4:0]      smc_nextstate11;     // State11 Machine11 
  output            cste_enable11;       // Enable11 CS11 Trailing11 Edge11 counter
  output            ws_enable11;         // Wait11 state counter enable
  output            smc_done11;          // one access completed
  output            valid_access11;      // load11 values are valid if high11
  output            le_enable11;         // Enable11 all Leading11 Edge11 
                                           // counters11
  output            latch_data11;        // latch_data11 is used by the 
                                           // MAC11 block
                                     //  to store11 read data if CSTE11 > 0
  output            smc_idle11;          // idle11 state



// Output11 register declarations11

  reg [4:0]    smc_nextstate11;     // SMC11 state machine11 (async11 encoding11)
  reg [4:0]    r_smc_currentstate11;// Synchronised11 SMC11 state machine11
  reg          ws_enable11;         // Wait11 state counter enable
  reg          cste_enable11;       // Chip11 select11 counter enable
  reg          smc_done11;         // Asserted11 during last cycle of access
  reg          valid_access11;      // load11 values are valid if high11
  reg          le_enable11;         // Enable11 all Leading11 Edge11 counters11
  reg          latch_data11;        // latch_data11 is used by the MAC11 block
  reg          smc_idle11;          // idle11 state
  


//----------------------------------------------------------------------
// Main11 code11
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC11 state machine11
//----------------------------------------------------------------------
// Generates11 the required11 timings11 for the External11 Memory Interface11.
// If11 back-to-back accesses are required11 the state machine11 will bypass11
// the idle11 state, thus11 maintaining11 the chip11 select11 ouput11.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate11 internal idle11 signal11 used by AHB11 IF
//----------------------------------------------------------------------

  always @(smc_nextstate11)
  
  begin
   
     if (smc_nextstate11 == `SMC_IDLE11)
     
        smc_idle11 = 1'b1;
   
     else
       
        smc_idle11 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate11 internal done signal11
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate11 or r_cste_count11 or r_ws_count11)
  
  begin
   
     if ( ( (r_smc_currentstate11 == `SMC_RW11) &
            (r_ws_count11 == 8'd0) &
            (r_cste_count11 == 2'd0)
          ) |
          ( (r_smc_currentstate11 == `SMC_FLOAT11)  &
            (r_cste_count11 == 2'd0)
          )
        )
       
        smc_done11 = 1'b1;
   
   else
     
      smc_done11 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data11 is used by the MAC11 block to store11 read data if CSTE11 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate11 or r_ws_count11 or r_oete_store11)
  
  begin
   
     if ( (r_smc_currentstate11 == `SMC_RW11) &
          (r_ws_count11[1:0] >= r_oete_store11) &
          (r_ws_count11[7:2] == 6'd0)
        )
     
       latch_data11 = 1'b1;
   
     else
       
       latch_data11 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter11 enable signals11
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate11 or r_csle_count11 or
       smc_nextstate11 or valid_access11)
  begin
     if(valid_access11)
     begin
        if ((smc_nextstate11 == `SMC_RW11)         &
            (r_smc_currentstate11 != `SMC_STORE11) &
            (r_smc_currentstate11 != `SMC_LE11))
  
          ws_enable11 = 1'b1;
  
        else
  
          ws_enable11 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate11 == `SMC_RW11) & 
            (r_csle_count11 == 2'd0) & 
            (r_smc_currentstate11 != `SMC_STORE11) &
            (r_smc_currentstate11 != `SMC_LE11))

           ws_enable11 = 1'b1;
   
        else
  
           ws_enable11 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable11
//----------------------------------------------------------------------

  always @(r_smc_currentstate11 or smc_nextstate11)
  
  begin
  
     if (((smc_nextstate11 == `SMC_LE11) | (smc_nextstate11 == `SMC_RW11) ) &
         (r_smc_currentstate11 != `SMC_STORE11) )
  
        le_enable11 = 1'b1;
  
     else
  
        le_enable11 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable11
//----------------------------------------------------------------------
  
  always @(smc_nextstate11)
  
  begin
     if (smc_nextstate11 == `SMC_FLOAT11)
    
        cste_enable11 = 1'b1;
   
     else
  
        cste_enable11 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH11 if new cycle is waiting11 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate11 or new_access11 or r_ws_count11 or
                                     smc_nextstate11 or mac_done11)
  
  begin
     
     if (new_access11 & mac_done11 &
         (((r_smc_currentstate11 == `SMC_RW11) & 
           (smc_nextstate11 == `SMC_RW11) & 
           (r_ws_count11 == 8'd0))                                |
          ((r_smc_currentstate11 == `SMC_FLOAT11) & 
           (smc_nextstate11 == `SMC_IDLE11) ) |
          ((r_smc_currentstate11 == `SMC_FLOAT11) & 
           (smc_nextstate11 == `SMC_LE11)   ) |
          ((r_smc_currentstate11 == `SMC_FLOAT11) & 
           (smc_nextstate11 == `SMC_RW11)   ) |
          ((r_smc_currentstate11 == `SMC_FLOAT11) & 
           (smc_nextstate11 == `SMC_STORE11)) |
          ((r_smc_currentstate11 == `SMC_RW11)    & 
           (smc_nextstate11 == `SMC_STORE11)) |
          ((r_smc_currentstate11 == `SMC_RW11)    & 
           (smc_nextstate11 == `SMC_IDLE11) ) |
          ((r_smc_currentstate11 == `SMC_RW11)    & 
           (smc_nextstate11 == `SMC_LE11)   ) |
          ((r_smc_currentstate11 == `SMC_IDLE11) ) )  )    
       
       valid_access11 = 1'b1;
     
     else
       
       valid_access11 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC11 State11 Machine11
//----------------------------------------------------------------------

 always @(r_smc_currentstate11 or new_access11 or 
          cs or r_csle_count11 or r_cste_count11 or r_ws_count11 or mac_done11 
          or r_cs11 or n_read11 or n_r_read11 or r_csle_store11)
  begin
   
   case (r_smc_currentstate11)
  
     `SMC_IDLE11 :
  
        if (new_access11 )
 
           smc_nextstate11 = `SMC_STORE11;
  
        else
  
        begin
  
  
           begin

              if (new_access11 )
  
                 smc_nextstate11 = `SMC_RW11;

              else
  
                 smc_nextstate11 = `SMC_IDLE11;

           end
          
        end

     `SMC_STORE11   :

        if ((r_csle_count11 != 2'd0))

           smc_nextstate11 = `SMC_LE11;

        else

        begin
           
           if ( (r_csle_count11 == 2'd0))

              smc_nextstate11 = `SMC_RW11;
           
           else
             
              smc_nextstate11 = `SMC_STORE11;

        end      

     `SMC_LE11   :
  
        if (r_csle_count11 < 2'd2)
  
           smc_nextstate11 = `SMC_RW11;
  
        else
  
           smc_nextstate11 = `SMC_LE11;
  
     `SMC_RW11   :
  
     begin
          
        if ((r_ws_count11 == 8'd0) & 
            (r_cste_count11 != 2'd0))
  
           smc_nextstate11 = `SMC_FLOAT11;
          
        else if ((r_ws_count11 == 8'd0) &
                 (r_cste_count11 == 2'h0) &
                 mac_done11 & ~new_access11)

           smc_nextstate11 = `SMC_IDLE11;
          
        else if ((~mac_done11 & (r_csle_store11 != 2'd0)) &
                 (r_ws_count11 == 8'd0))
 
           smc_nextstate11 = `SMC_LE11;

        
        else
          
        begin
  
           if  ( ((n_read11 != n_r_read11) | ((cs != r_cs11) & ~n_r_read11)) & 
                  new_access11 & mac_done11 &
                 (r_ws_count11 == 8'd0))   
             
              smc_nextstate11 = `SMC_STORE11;
           
           else
             
              smc_nextstate11 = `SMC_RW11;
           
        end
        
     end
  
     `SMC_FLOAT11   :
        if (~ mac_done11                               & 
            (( & new_access11) | 
             ((r_csle_store11 == 2'd0)            &
              ~new_access11)) &  (r_cste_count11 == 2'd0) )
  
           smc_nextstate11 = `SMC_RW11;
  
        else if (new_access11                              & 
                 (( new_access11) |
                  ((r_csle_store11 == 2'd0)            & 
                   ~new_access11)) & (r_cste_count11 == 2'd0) )

        begin
  
           if  (((n_read11 != n_r_read11) | ((cs != r_cs11) & ~n_r_read11)))   
  
              smc_nextstate11 = `SMC_STORE11;
  
           else
  
              smc_nextstate11 = `SMC_RW11;
  
        end
     
        else
          
        begin
  
           if ((~mac_done11 & (r_csle_store11 != 2'd0)) & 
               (r_cste_count11 < 2'd1))
  
              smc_nextstate11 = `SMC_LE11;

           
           else
             
           begin
           
              if (r_cste_count11 == 2'd0)
             
                 smc_nextstate11 = `SMC_IDLE11;
           
              else
  
                 smc_nextstate11 = `SMC_FLOAT11;
  
           end
           
        end
     
     default   :
       
       smc_nextstate11 = `SMC_IDLE11;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential11 process of state machine11
//----------------------------------------------------------------------

  always @(posedge sys_clk11 or negedge n_sys_reset11)
  
  begin
  
     if (~n_sys_reset11)
  
        r_smc_currentstate11 <= `SMC_IDLE11;
  
  
     else   
       
        r_smc_currentstate11 <= smc_nextstate11;
  
  
  end

   

   
endmodule


