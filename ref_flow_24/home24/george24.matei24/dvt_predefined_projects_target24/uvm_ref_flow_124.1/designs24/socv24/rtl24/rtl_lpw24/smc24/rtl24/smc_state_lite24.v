//File24 name   : smc_state_lite24.v
//Title24       : 
//Created24     : 1999
//
//Description24 : SMC24 State24 Machine24
//            : Static24 Memory Controller24
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

`include "smc_defs_lite24.v"

//state machine24 for smc24
  module smc_state_lite24  (
                     //inputs24
  
                     sys_clk24,
                     n_sys_reset24,
                     new_access24,
                     r_cste_count24,
                     r_csle_count24,
                     r_ws_count24,
                     mac_done24,
                     n_read24,
                     n_r_read24,
                     r_csle_store24,
                     r_oete_store24,
                     cs,
                     r_cs24,
             
                     //outputs24
  
                     r_smc_currentstate24,
                     smc_nextstate24,
                     cste_enable24,
                     ws_enable24,
                     smc_done24,
                     valid_access24,
                     le_enable24,
                     latch_data24,
                     smc_idle24);
   
   
   
//Parameters24  -  Values24 in smc_defs24.v



// I24/O24

  input            sys_clk24;           // AHB24 System24 clock24
  input            n_sys_reset24;       // AHB24 System24 reset (Active24 LOW24)
  input            new_access24;        // New24 AHB24 valid access to smc24 
                                          // detected
  input [1:0]      r_cste_count24;      // Chip24 select24 TE24 counter
  input [1:0]      r_csle_count24;      // chip24 select24 leading24 edge count
  input [7:0]      r_ws_count24; // wait state count
  input            mac_done24;          // All cycles24 in a multiple access
  input            n_read24;            // Active24 low24 read signal24
  input            n_r_read24;          // Store24 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store24;      // Chip24 select24 LE24 store24
  input [1:0]      r_oete_store24;      // Read strobe24 TE24 end time before CS24
  input       cs;        // chip24 selects24
  input       r_cs24;      // registered chip24 selects24

  output [4:0]      r_smc_currentstate24;// Synchronised24 SMC24 state machine24
  output [4:0]      smc_nextstate24;     // State24 Machine24 
  output            cste_enable24;       // Enable24 CS24 Trailing24 Edge24 counter
  output            ws_enable24;         // Wait24 state counter enable
  output            smc_done24;          // one access completed
  output            valid_access24;      // load24 values are valid if high24
  output            le_enable24;         // Enable24 all Leading24 Edge24 
                                           // counters24
  output            latch_data24;        // latch_data24 is used by the 
                                           // MAC24 block
                                     //  to store24 read data if CSTE24 > 0
  output            smc_idle24;          // idle24 state



// Output24 register declarations24

  reg [4:0]    smc_nextstate24;     // SMC24 state machine24 (async24 encoding24)
  reg [4:0]    r_smc_currentstate24;// Synchronised24 SMC24 state machine24
  reg          ws_enable24;         // Wait24 state counter enable
  reg          cste_enable24;       // Chip24 select24 counter enable
  reg          smc_done24;         // Asserted24 during last cycle of access
  reg          valid_access24;      // load24 values are valid if high24
  reg          le_enable24;         // Enable24 all Leading24 Edge24 counters24
  reg          latch_data24;        // latch_data24 is used by the MAC24 block
  reg          smc_idle24;          // idle24 state
  


//----------------------------------------------------------------------
// Main24 code24
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC24 state machine24
//----------------------------------------------------------------------
// Generates24 the required24 timings24 for the External24 Memory Interface24.
// If24 back-to-back accesses are required24 the state machine24 will bypass24
// the idle24 state, thus24 maintaining24 the chip24 select24 ouput24.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate24 internal idle24 signal24 used by AHB24 IF
//----------------------------------------------------------------------

  always @(smc_nextstate24)
  
  begin
   
     if (smc_nextstate24 == `SMC_IDLE24)
     
        smc_idle24 = 1'b1;
   
     else
       
        smc_idle24 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate24 internal done signal24
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate24 or r_cste_count24 or r_ws_count24)
  
  begin
   
     if ( ( (r_smc_currentstate24 == `SMC_RW24) &
            (r_ws_count24 == 8'd0) &
            (r_cste_count24 == 2'd0)
          ) |
          ( (r_smc_currentstate24 == `SMC_FLOAT24)  &
            (r_cste_count24 == 2'd0)
          )
        )
       
        smc_done24 = 1'b1;
   
   else
     
      smc_done24 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data24 is used by the MAC24 block to store24 read data if CSTE24 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate24 or r_ws_count24 or r_oete_store24)
  
  begin
   
     if ( (r_smc_currentstate24 == `SMC_RW24) &
          (r_ws_count24[1:0] >= r_oete_store24) &
          (r_ws_count24[7:2] == 6'd0)
        )
     
       latch_data24 = 1'b1;
   
     else
       
       latch_data24 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter24 enable signals24
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate24 or r_csle_count24 or
       smc_nextstate24 or valid_access24)
  begin
     if(valid_access24)
     begin
        if ((smc_nextstate24 == `SMC_RW24)         &
            (r_smc_currentstate24 != `SMC_STORE24) &
            (r_smc_currentstate24 != `SMC_LE24))
  
          ws_enable24 = 1'b1;
  
        else
  
          ws_enable24 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate24 == `SMC_RW24) & 
            (r_csle_count24 == 2'd0) & 
            (r_smc_currentstate24 != `SMC_STORE24) &
            (r_smc_currentstate24 != `SMC_LE24))

           ws_enable24 = 1'b1;
   
        else
  
           ws_enable24 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable24
//----------------------------------------------------------------------

  always @(r_smc_currentstate24 or smc_nextstate24)
  
  begin
  
     if (((smc_nextstate24 == `SMC_LE24) | (smc_nextstate24 == `SMC_RW24) ) &
         (r_smc_currentstate24 != `SMC_STORE24) )
  
        le_enable24 = 1'b1;
  
     else
  
        le_enable24 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable24
//----------------------------------------------------------------------
  
  always @(smc_nextstate24)
  
  begin
     if (smc_nextstate24 == `SMC_FLOAT24)
    
        cste_enable24 = 1'b1;
   
     else
  
        cste_enable24 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH24 if new cycle is waiting24 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate24 or new_access24 or r_ws_count24 or
                                     smc_nextstate24 or mac_done24)
  
  begin
     
     if (new_access24 & mac_done24 &
         (((r_smc_currentstate24 == `SMC_RW24) & 
           (smc_nextstate24 == `SMC_RW24) & 
           (r_ws_count24 == 8'd0))                                |
          ((r_smc_currentstate24 == `SMC_FLOAT24) & 
           (smc_nextstate24 == `SMC_IDLE24) ) |
          ((r_smc_currentstate24 == `SMC_FLOAT24) & 
           (smc_nextstate24 == `SMC_LE24)   ) |
          ((r_smc_currentstate24 == `SMC_FLOAT24) & 
           (smc_nextstate24 == `SMC_RW24)   ) |
          ((r_smc_currentstate24 == `SMC_FLOAT24) & 
           (smc_nextstate24 == `SMC_STORE24)) |
          ((r_smc_currentstate24 == `SMC_RW24)    & 
           (smc_nextstate24 == `SMC_STORE24)) |
          ((r_smc_currentstate24 == `SMC_RW24)    & 
           (smc_nextstate24 == `SMC_IDLE24) ) |
          ((r_smc_currentstate24 == `SMC_RW24)    & 
           (smc_nextstate24 == `SMC_LE24)   ) |
          ((r_smc_currentstate24 == `SMC_IDLE24) ) )  )    
       
       valid_access24 = 1'b1;
     
     else
       
       valid_access24 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC24 State24 Machine24
//----------------------------------------------------------------------

 always @(r_smc_currentstate24 or new_access24 or 
          cs or r_csle_count24 or r_cste_count24 or r_ws_count24 or mac_done24 
          or r_cs24 or n_read24 or n_r_read24 or r_csle_store24)
  begin
   
   case (r_smc_currentstate24)
  
     `SMC_IDLE24 :
  
        if (new_access24 )
 
           smc_nextstate24 = `SMC_STORE24;
  
        else
  
        begin
  
  
           begin

              if (new_access24 )
  
                 smc_nextstate24 = `SMC_RW24;

              else
  
                 smc_nextstate24 = `SMC_IDLE24;

           end
          
        end

     `SMC_STORE24   :

        if ((r_csle_count24 != 2'd0))

           smc_nextstate24 = `SMC_LE24;

        else

        begin
           
           if ( (r_csle_count24 == 2'd0))

              smc_nextstate24 = `SMC_RW24;
           
           else
             
              smc_nextstate24 = `SMC_STORE24;

        end      

     `SMC_LE24   :
  
        if (r_csle_count24 < 2'd2)
  
           smc_nextstate24 = `SMC_RW24;
  
        else
  
           smc_nextstate24 = `SMC_LE24;
  
     `SMC_RW24   :
  
     begin
          
        if ((r_ws_count24 == 8'd0) & 
            (r_cste_count24 != 2'd0))
  
           smc_nextstate24 = `SMC_FLOAT24;
          
        else if ((r_ws_count24 == 8'd0) &
                 (r_cste_count24 == 2'h0) &
                 mac_done24 & ~new_access24)

           smc_nextstate24 = `SMC_IDLE24;
          
        else if ((~mac_done24 & (r_csle_store24 != 2'd0)) &
                 (r_ws_count24 == 8'd0))
 
           smc_nextstate24 = `SMC_LE24;

        
        else
          
        begin
  
           if  ( ((n_read24 != n_r_read24) | ((cs != r_cs24) & ~n_r_read24)) & 
                  new_access24 & mac_done24 &
                 (r_ws_count24 == 8'd0))   
             
              smc_nextstate24 = `SMC_STORE24;
           
           else
             
              smc_nextstate24 = `SMC_RW24;
           
        end
        
     end
  
     `SMC_FLOAT24   :
        if (~ mac_done24                               & 
            (( & new_access24) | 
             ((r_csle_store24 == 2'd0)            &
              ~new_access24)) &  (r_cste_count24 == 2'd0) )
  
           smc_nextstate24 = `SMC_RW24;
  
        else if (new_access24                              & 
                 (( new_access24) |
                  ((r_csle_store24 == 2'd0)            & 
                   ~new_access24)) & (r_cste_count24 == 2'd0) )

        begin
  
           if  (((n_read24 != n_r_read24) | ((cs != r_cs24) & ~n_r_read24)))   
  
              smc_nextstate24 = `SMC_STORE24;
  
           else
  
              smc_nextstate24 = `SMC_RW24;
  
        end
     
        else
          
        begin
  
           if ((~mac_done24 & (r_csle_store24 != 2'd0)) & 
               (r_cste_count24 < 2'd1))
  
              smc_nextstate24 = `SMC_LE24;

           
           else
             
           begin
           
              if (r_cste_count24 == 2'd0)
             
                 smc_nextstate24 = `SMC_IDLE24;
           
              else
  
                 smc_nextstate24 = `SMC_FLOAT24;
  
           end
           
        end
     
     default   :
       
       smc_nextstate24 = `SMC_IDLE24;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential24 process of state machine24
//----------------------------------------------------------------------

  always @(posedge sys_clk24 or negedge n_sys_reset24)
  
  begin
  
     if (~n_sys_reset24)
  
        r_smc_currentstate24 <= `SMC_IDLE24;
  
  
     else   
       
        r_smc_currentstate24 <= smc_nextstate24;
  
  
  end

   

   
endmodule


