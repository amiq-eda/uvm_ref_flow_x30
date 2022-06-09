//File3 name   : smc_state_lite3.v
//Title3       : 
//Created3     : 1999
//
//Description3 : SMC3 State3 Machine3
//            : Static3 Memory Controller3
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

`include "smc_defs_lite3.v"

//state machine3 for smc3
  module smc_state_lite3  (
                     //inputs3
  
                     sys_clk3,
                     n_sys_reset3,
                     new_access3,
                     r_cste_count3,
                     r_csle_count3,
                     r_ws_count3,
                     mac_done3,
                     n_read3,
                     n_r_read3,
                     r_csle_store3,
                     r_oete_store3,
                     cs,
                     r_cs3,
             
                     //outputs3
  
                     r_smc_currentstate3,
                     smc_nextstate3,
                     cste_enable3,
                     ws_enable3,
                     smc_done3,
                     valid_access3,
                     le_enable3,
                     latch_data3,
                     smc_idle3);
   
   
   
//Parameters3  -  Values3 in smc_defs3.v



// I3/O3

  input            sys_clk3;           // AHB3 System3 clock3
  input            n_sys_reset3;       // AHB3 System3 reset (Active3 LOW3)
  input            new_access3;        // New3 AHB3 valid access to smc3 
                                          // detected
  input [1:0]      r_cste_count3;      // Chip3 select3 TE3 counter
  input [1:0]      r_csle_count3;      // chip3 select3 leading3 edge count
  input [7:0]      r_ws_count3; // wait state count
  input            mac_done3;          // All cycles3 in a multiple access
  input            n_read3;            // Active3 low3 read signal3
  input            n_r_read3;          // Store3 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store3;      // Chip3 select3 LE3 store3
  input [1:0]      r_oete_store3;      // Read strobe3 TE3 end time before CS3
  input       cs;        // chip3 selects3
  input       r_cs3;      // registered chip3 selects3

  output [4:0]      r_smc_currentstate3;// Synchronised3 SMC3 state machine3
  output [4:0]      smc_nextstate3;     // State3 Machine3 
  output            cste_enable3;       // Enable3 CS3 Trailing3 Edge3 counter
  output            ws_enable3;         // Wait3 state counter enable
  output            smc_done3;          // one access completed
  output            valid_access3;      // load3 values are valid if high3
  output            le_enable3;         // Enable3 all Leading3 Edge3 
                                           // counters3
  output            latch_data3;        // latch_data3 is used by the 
                                           // MAC3 block
                                     //  to store3 read data if CSTE3 > 0
  output            smc_idle3;          // idle3 state



// Output3 register declarations3

  reg [4:0]    smc_nextstate3;     // SMC3 state machine3 (async3 encoding3)
  reg [4:0]    r_smc_currentstate3;// Synchronised3 SMC3 state machine3
  reg          ws_enable3;         // Wait3 state counter enable
  reg          cste_enable3;       // Chip3 select3 counter enable
  reg          smc_done3;         // Asserted3 during last cycle of access
  reg          valid_access3;      // load3 values are valid if high3
  reg          le_enable3;         // Enable3 all Leading3 Edge3 counters3
  reg          latch_data3;        // latch_data3 is used by the MAC3 block
  reg          smc_idle3;          // idle3 state
  


//----------------------------------------------------------------------
// Main3 code3
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC3 state machine3
//----------------------------------------------------------------------
// Generates3 the required3 timings3 for the External3 Memory Interface3.
// If3 back-to-back accesses are required3 the state machine3 will bypass3
// the idle3 state, thus3 maintaining3 the chip3 select3 ouput3.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate3 internal idle3 signal3 used by AHB3 IF
//----------------------------------------------------------------------

  always @(smc_nextstate3)
  
  begin
   
     if (smc_nextstate3 == `SMC_IDLE3)
     
        smc_idle3 = 1'b1;
   
     else
       
        smc_idle3 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate3 internal done signal3
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate3 or r_cste_count3 or r_ws_count3)
  
  begin
   
     if ( ( (r_smc_currentstate3 == `SMC_RW3) &
            (r_ws_count3 == 8'd0) &
            (r_cste_count3 == 2'd0)
          ) |
          ( (r_smc_currentstate3 == `SMC_FLOAT3)  &
            (r_cste_count3 == 2'd0)
          )
        )
       
        smc_done3 = 1'b1;
   
   else
     
      smc_done3 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data3 is used by the MAC3 block to store3 read data if CSTE3 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate3 or r_ws_count3 or r_oete_store3)
  
  begin
   
     if ( (r_smc_currentstate3 == `SMC_RW3) &
          (r_ws_count3[1:0] >= r_oete_store3) &
          (r_ws_count3[7:2] == 6'd0)
        )
     
       latch_data3 = 1'b1;
   
     else
       
       latch_data3 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter3 enable signals3
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate3 or r_csle_count3 or
       smc_nextstate3 or valid_access3)
  begin
     if(valid_access3)
     begin
        if ((smc_nextstate3 == `SMC_RW3)         &
            (r_smc_currentstate3 != `SMC_STORE3) &
            (r_smc_currentstate3 != `SMC_LE3))
  
          ws_enable3 = 1'b1;
  
        else
  
          ws_enable3 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate3 == `SMC_RW3) & 
            (r_csle_count3 == 2'd0) & 
            (r_smc_currentstate3 != `SMC_STORE3) &
            (r_smc_currentstate3 != `SMC_LE3))

           ws_enable3 = 1'b1;
   
        else
  
           ws_enable3 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable3
//----------------------------------------------------------------------

  always @(r_smc_currentstate3 or smc_nextstate3)
  
  begin
  
     if (((smc_nextstate3 == `SMC_LE3) | (smc_nextstate3 == `SMC_RW3) ) &
         (r_smc_currentstate3 != `SMC_STORE3) )
  
        le_enable3 = 1'b1;
  
     else
  
        le_enable3 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable3
//----------------------------------------------------------------------
  
  always @(smc_nextstate3)
  
  begin
     if (smc_nextstate3 == `SMC_FLOAT3)
    
        cste_enable3 = 1'b1;
   
     else
  
        cste_enable3 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH3 if new cycle is waiting3 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate3 or new_access3 or r_ws_count3 or
                                     smc_nextstate3 or mac_done3)
  
  begin
     
     if (new_access3 & mac_done3 &
         (((r_smc_currentstate3 == `SMC_RW3) & 
           (smc_nextstate3 == `SMC_RW3) & 
           (r_ws_count3 == 8'd0))                                |
          ((r_smc_currentstate3 == `SMC_FLOAT3) & 
           (smc_nextstate3 == `SMC_IDLE3) ) |
          ((r_smc_currentstate3 == `SMC_FLOAT3) & 
           (smc_nextstate3 == `SMC_LE3)   ) |
          ((r_smc_currentstate3 == `SMC_FLOAT3) & 
           (smc_nextstate3 == `SMC_RW3)   ) |
          ((r_smc_currentstate3 == `SMC_FLOAT3) & 
           (smc_nextstate3 == `SMC_STORE3)) |
          ((r_smc_currentstate3 == `SMC_RW3)    & 
           (smc_nextstate3 == `SMC_STORE3)) |
          ((r_smc_currentstate3 == `SMC_RW3)    & 
           (smc_nextstate3 == `SMC_IDLE3) ) |
          ((r_smc_currentstate3 == `SMC_RW3)    & 
           (smc_nextstate3 == `SMC_LE3)   ) |
          ((r_smc_currentstate3 == `SMC_IDLE3) ) )  )    
       
       valid_access3 = 1'b1;
     
     else
       
       valid_access3 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC3 State3 Machine3
//----------------------------------------------------------------------

 always @(r_smc_currentstate3 or new_access3 or 
          cs or r_csle_count3 or r_cste_count3 or r_ws_count3 or mac_done3 
          or r_cs3 or n_read3 or n_r_read3 or r_csle_store3)
  begin
   
   case (r_smc_currentstate3)
  
     `SMC_IDLE3 :
  
        if (new_access3 )
 
           smc_nextstate3 = `SMC_STORE3;
  
        else
  
        begin
  
  
           begin

              if (new_access3 )
  
                 smc_nextstate3 = `SMC_RW3;

              else
  
                 smc_nextstate3 = `SMC_IDLE3;

           end
          
        end

     `SMC_STORE3   :

        if ((r_csle_count3 != 2'd0))

           smc_nextstate3 = `SMC_LE3;

        else

        begin
           
           if ( (r_csle_count3 == 2'd0))

              smc_nextstate3 = `SMC_RW3;
           
           else
             
              smc_nextstate3 = `SMC_STORE3;

        end      

     `SMC_LE3   :
  
        if (r_csle_count3 < 2'd2)
  
           smc_nextstate3 = `SMC_RW3;
  
        else
  
           smc_nextstate3 = `SMC_LE3;
  
     `SMC_RW3   :
  
     begin
          
        if ((r_ws_count3 == 8'd0) & 
            (r_cste_count3 != 2'd0))
  
           smc_nextstate3 = `SMC_FLOAT3;
          
        else if ((r_ws_count3 == 8'd0) &
                 (r_cste_count3 == 2'h0) &
                 mac_done3 & ~new_access3)

           smc_nextstate3 = `SMC_IDLE3;
          
        else if ((~mac_done3 & (r_csle_store3 != 2'd0)) &
                 (r_ws_count3 == 8'd0))
 
           smc_nextstate3 = `SMC_LE3;

        
        else
          
        begin
  
           if  ( ((n_read3 != n_r_read3) | ((cs != r_cs3) & ~n_r_read3)) & 
                  new_access3 & mac_done3 &
                 (r_ws_count3 == 8'd0))   
             
              smc_nextstate3 = `SMC_STORE3;
           
           else
             
              smc_nextstate3 = `SMC_RW3;
           
        end
        
     end
  
     `SMC_FLOAT3   :
        if (~ mac_done3                               & 
            (( & new_access3) | 
             ((r_csle_store3 == 2'd0)            &
              ~new_access3)) &  (r_cste_count3 == 2'd0) )
  
           smc_nextstate3 = `SMC_RW3;
  
        else if (new_access3                              & 
                 (( new_access3) |
                  ((r_csle_store3 == 2'd0)            & 
                   ~new_access3)) & (r_cste_count3 == 2'd0) )

        begin
  
           if  (((n_read3 != n_r_read3) | ((cs != r_cs3) & ~n_r_read3)))   
  
              smc_nextstate3 = `SMC_STORE3;
  
           else
  
              smc_nextstate3 = `SMC_RW3;
  
        end
     
        else
          
        begin
  
           if ((~mac_done3 & (r_csle_store3 != 2'd0)) & 
               (r_cste_count3 < 2'd1))
  
              smc_nextstate3 = `SMC_LE3;

           
           else
             
           begin
           
              if (r_cste_count3 == 2'd0)
             
                 smc_nextstate3 = `SMC_IDLE3;
           
              else
  
                 smc_nextstate3 = `SMC_FLOAT3;
  
           end
           
        end
     
     default   :
       
       smc_nextstate3 = `SMC_IDLE3;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential3 process of state machine3
//----------------------------------------------------------------------

  always @(posedge sys_clk3 or negedge n_sys_reset3)
  
  begin
  
     if (~n_sys_reset3)
  
        r_smc_currentstate3 <= `SMC_IDLE3;
  
  
     else   
       
        r_smc_currentstate3 <= smc_nextstate3;
  
  
  end

   

   
endmodule


