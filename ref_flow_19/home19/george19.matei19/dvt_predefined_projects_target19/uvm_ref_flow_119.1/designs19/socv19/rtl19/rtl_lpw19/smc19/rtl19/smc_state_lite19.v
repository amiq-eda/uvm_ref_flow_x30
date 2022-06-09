//File19 name   : smc_state_lite19.v
//Title19       : 
//Created19     : 1999
//
//Description19 : SMC19 State19 Machine19
//            : Static19 Memory Controller19
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

`include "smc_defs_lite19.v"

//state machine19 for smc19
  module smc_state_lite19  (
                     //inputs19
  
                     sys_clk19,
                     n_sys_reset19,
                     new_access19,
                     r_cste_count19,
                     r_csle_count19,
                     r_ws_count19,
                     mac_done19,
                     n_read19,
                     n_r_read19,
                     r_csle_store19,
                     r_oete_store19,
                     cs,
                     r_cs19,
             
                     //outputs19
  
                     r_smc_currentstate19,
                     smc_nextstate19,
                     cste_enable19,
                     ws_enable19,
                     smc_done19,
                     valid_access19,
                     le_enable19,
                     latch_data19,
                     smc_idle19);
   
   
   
//Parameters19  -  Values19 in smc_defs19.v



// I19/O19

  input            sys_clk19;           // AHB19 System19 clock19
  input            n_sys_reset19;       // AHB19 System19 reset (Active19 LOW19)
  input            new_access19;        // New19 AHB19 valid access to smc19 
                                          // detected
  input [1:0]      r_cste_count19;      // Chip19 select19 TE19 counter
  input [1:0]      r_csle_count19;      // chip19 select19 leading19 edge count
  input [7:0]      r_ws_count19; // wait state count
  input            mac_done19;          // All cycles19 in a multiple access
  input            n_read19;            // Active19 low19 read signal19
  input            n_r_read19;          // Store19 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store19;      // Chip19 select19 LE19 store19
  input [1:0]      r_oete_store19;      // Read strobe19 TE19 end time before CS19
  input       cs;        // chip19 selects19
  input       r_cs19;      // registered chip19 selects19

  output [4:0]      r_smc_currentstate19;// Synchronised19 SMC19 state machine19
  output [4:0]      smc_nextstate19;     // State19 Machine19 
  output            cste_enable19;       // Enable19 CS19 Trailing19 Edge19 counter
  output            ws_enable19;         // Wait19 state counter enable
  output            smc_done19;          // one access completed
  output            valid_access19;      // load19 values are valid if high19
  output            le_enable19;         // Enable19 all Leading19 Edge19 
                                           // counters19
  output            latch_data19;        // latch_data19 is used by the 
                                           // MAC19 block
                                     //  to store19 read data if CSTE19 > 0
  output            smc_idle19;          // idle19 state



// Output19 register declarations19

  reg [4:0]    smc_nextstate19;     // SMC19 state machine19 (async19 encoding19)
  reg [4:0]    r_smc_currentstate19;// Synchronised19 SMC19 state machine19
  reg          ws_enable19;         // Wait19 state counter enable
  reg          cste_enable19;       // Chip19 select19 counter enable
  reg          smc_done19;         // Asserted19 during last cycle of access
  reg          valid_access19;      // load19 values are valid if high19
  reg          le_enable19;         // Enable19 all Leading19 Edge19 counters19
  reg          latch_data19;        // latch_data19 is used by the MAC19 block
  reg          smc_idle19;          // idle19 state
  


//----------------------------------------------------------------------
// Main19 code19
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC19 state machine19
//----------------------------------------------------------------------
// Generates19 the required19 timings19 for the External19 Memory Interface19.
// If19 back-to-back accesses are required19 the state machine19 will bypass19
// the idle19 state, thus19 maintaining19 the chip19 select19 ouput19.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate19 internal idle19 signal19 used by AHB19 IF
//----------------------------------------------------------------------

  always @(smc_nextstate19)
  
  begin
   
     if (smc_nextstate19 == `SMC_IDLE19)
     
        smc_idle19 = 1'b1;
   
     else
       
        smc_idle19 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate19 internal done signal19
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate19 or r_cste_count19 or r_ws_count19)
  
  begin
   
     if ( ( (r_smc_currentstate19 == `SMC_RW19) &
            (r_ws_count19 == 8'd0) &
            (r_cste_count19 == 2'd0)
          ) |
          ( (r_smc_currentstate19 == `SMC_FLOAT19)  &
            (r_cste_count19 == 2'd0)
          )
        )
       
        smc_done19 = 1'b1;
   
   else
     
      smc_done19 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data19 is used by the MAC19 block to store19 read data if CSTE19 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate19 or r_ws_count19 or r_oete_store19)
  
  begin
   
     if ( (r_smc_currentstate19 == `SMC_RW19) &
          (r_ws_count19[1:0] >= r_oete_store19) &
          (r_ws_count19[7:2] == 6'd0)
        )
     
       latch_data19 = 1'b1;
   
     else
       
       latch_data19 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter19 enable signals19
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate19 or r_csle_count19 or
       smc_nextstate19 or valid_access19)
  begin
     if(valid_access19)
     begin
        if ((smc_nextstate19 == `SMC_RW19)         &
            (r_smc_currentstate19 != `SMC_STORE19) &
            (r_smc_currentstate19 != `SMC_LE19))
  
          ws_enable19 = 1'b1;
  
        else
  
          ws_enable19 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate19 == `SMC_RW19) & 
            (r_csle_count19 == 2'd0) & 
            (r_smc_currentstate19 != `SMC_STORE19) &
            (r_smc_currentstate19 != `SMC_LE19))

           ws_enable19 = 1'b1;
   
        else
  
           ws_enable19 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable19
//----------------------------------------------------------------------

  always @(r_smc_currentstate19 or smc_nextstate19)
  
  begin
  
     if (((smc_nextstate19 == `SMC_LE19) | (smc_nextstate19 == `SMC_RW19) ) &
         (r_smc_currentstate19 != `SMC_STORE19) )
  
        le_enable19 = 1'b1;
  
     else
  
        le_enable19 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable19
//----------------------------------------------------------------------
  
  always @(smc_nextstate19)
  
  begin
     if (smc_nextstate19 == `SMC_FLOAT19)
    
        cste_enable19 = 1'b1;
   
     else
  
        cste_enable19 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH19 if new cycle is waiting19 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate19 or new_access19 or r_ws_count19 or
                                     smc_nextstate19 or mac_done19)
  
  begin
     
     if (new_access19 & mac_done19 &
         (((r_smc_currentstate19 == `SMC_RW19) & 
           (smc_nextstate19 == `SMC_RW19) & 
           (r_ws_count19 == 8'd0))                                |
          ((r_smc_currentstate19 == `SMC_FLOAT19) & 
           (smc_nextstate19 == `SMC_IDLE19) ) |
          ((r_smc_currentstate19 == `SMC_FLOAT19) & 
           (smc_nextstate19 == `SMC_LE19)   ) |
          ((r_smc_currentstate19 == `SMC_FLOAT19) & 
           (smc_nextstate19 == `SMC_RW19)   ) |
          ((r_smc_currentstate19 == `SMC_FLOAT19) & 
           (smc_nextstate19 == `SMC_STORE19)) |
          ((r_smc_currentstate19 == `SMC_RW19)    & 
           (smc_nextstate19 == `SMC_STORE19)) |
          ((r_smc_currentstate19 == `SMC_RW19)    & 
           (smc_nextstate19 == `SMC_IDLE19) ) |
          ((r_smc_currentstate19 == `SMC_RW19)    & 
           (smc_nextstate19 == `SMC_LE19)   ) |
          ((r_smc_currentstate19 == `SMC_IDLE19) ) )  )    
       
       valid_access19 = 1'b1;
     
     else
       
       valid_access19 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC19 State19 Machine19
//----------------------------------------------------------------------

 always @(r_smc_currentstate19 or new_access19 or 
          cs or r_csle_count19 or r_cste_count19 or r_ws_count19 or mac_done19 
          or r_cs19 or n_read19 or n_r_read19 or r_csle_store19)
  begin
   
   case (r_smc_currentstate19)
  
     `SMC_IDLE19 :
  
        if (new_access19 )
 
           smc_nextstate19 = `SMC_STORE19;
  
        else
  
        begin
  
  
           begin

              if (new_access19 )
  
                 smc_nextstate19 = `SMC_RW19;

              else
  
                 smc_nextstate19 = `SMC_IDLE19;

           end
          
        end

     `SMC_STORE19   :

        if ((r_csle_count19 != 2'd0))

           smc_nextstate19 = `SMC_LE19;

        else

        begin
           
           if ( (r_csle_count19 == 2'd0))

              smc_nextstate19 = `SMC_RW19;
           
           else
             
              smc_nextstate19 = `SMC_STORE19;

        end      

     `SMC_LE19   :
  
        if (r_csle_count19 < 2'd2)
  
           smc_nextstate19 = `SMC_RW19;
  
        else
  
           smc_nextstate19 = `SMC_LE19;
  
     `SMC_RW19   :
  
     begin
          
        if ((r_ws_count19 == 8'd0) & 
            (r_cste_count19 != 2'd0))
  
           smc_nextstate19 = `SMC_FLOAT19;
          
        else if ((r_ws_count19 == 8'd0) &
                 (r_cste_count19 == 2'h0) &
                 mac_done19 & ~new_access19)

           smc_nextstate19 = `SMC_IDLE19;
          
        else if ((~mac_done19 & (r_csle_store19 != 2'd0)) &
                 (r_ws_count19 == 8'd0))
 
           smc_nextstate19 = `SMC_LE19;

        
        else
          
        begin
  
           if  ( ((n_read19 != n_r_read19) | ((cs != r_cs19) & ~n_r_read19)) & 
                  new_access19 & mac_done19 &
                 (r_ws_count19 == 8'd0))   
             
              smc_nextstate19 = `SMC_STORE19;
           
           else
             
              smc_nextstate19 = `SMC_RW19;
           
        end
        
     end
  
     `SMC_FLOAT19   :
        if (~ mac_done19                               & 
            (( & new_access19) | 
             ((r_csle_store19 == 2'd0)            &
              ~new_access19)) &  (r_cste_count19 == 2'd0) )
  
           smc_nextstate19 = `SMC_RW19;
  
        else if (new_access19                              & 
                 (( new_access19) |
                  ((r_csle_store19 == 2'd0)            & 
                   ~new_access19)) & (r_cste_count19 == 2'd0) )

        begin
  
           if  (((n_read19 != n_r_read19) | ((cs != r_cs19) & ~n_r_read19)))   
  
              smc_nextstate19 = `SMC_STORE19;
  
           else
  
              smc_nextstate19 = `SMC_RW19;
  
        end
     
        else
          
        begin
  
           if ((~mac_done19 & (r_csle_store19 != 2'd0)) & 
               (r_cste_count19 < 2'd1))
  
              smc_nextstate19 = `SMC_LE19;

           
           else
             
           begin
           
              if (r_cste_count19 == 2'd0)
             
                 smc_nextstate19 = `SMC_IDLE19;
           
              else
  
                 smc_nextstate19 = `SMC_FLOAT19;
  
           end
           
        end
     
     default   :
       
       smc_nextstate19 = `SMC_IDLE19;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential19 process of state machine19
//----------------------------------------------------------------------

  always @(posedge sys_clk19 or negedge n_sys_reset19)
  
  begin
  
     if (~n_sys_reset19)
  
        r_smc_currentstate19 <= `SMC_IDLE19;
  
  
     else   
       
        r_smc_currentstate19 <= smc_nextstate19;
  
  
  end

   

   
endmodule


