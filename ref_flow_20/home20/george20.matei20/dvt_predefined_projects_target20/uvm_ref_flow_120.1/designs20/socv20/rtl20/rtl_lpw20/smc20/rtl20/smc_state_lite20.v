//File20 name   : smc_state_lite20.v
//Title20       : 
//Created20     : 1999
//
//Description20 : SMC20 State20 Machine20
//            : Static20 Memory Controller20
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

`include "smc_defs_lite20.v"

//state machine20 for smc20
  module smc_state_lite20  (
                     //inputs20
  
                     sys_clk20,
                     n_sys_reset20,
                     new_access20,
                     r_cste_count20,
                     r_csle_count20,
                     r_ws_count20,
                     mac_done20,
                     n_read20,
                     n_r_read20,
                     r_csle_store20,
                     r_oete_store20,
                     cs,
                     r_cs20,
             
                     //outputs20
  
                     r_smc_currentstate20,
                     smc_nextstate20,
                     cste_enable20,
                     ws_enable20,
                     smc_done20,
                     valid_access20,
                     le_enable20,
                     latch_data20,
                     smc_idle20);
   
   
   
//Parameters20  -  Values20 in smc_defs20.v



// I20/O20

  input            sys_clk20;           // AHB20 System20 clock20
  input            n_sys_reset20;       // AHB20 System20 reset (Active20 LOW20)
  input            new_access20;        // New20 AHB20 valid access to smc20 
                                          // detected
  input [1:0]      r_cste_count20;      // Chip20 select20 TE20 counter
  input [1:0]      r_csle_count20;      // chip20 select20 leading20 edge count
  input [7:0]      r_ws_count20; // wait state count
  input            mac_done20;          // All cycles20 in a multiple access
  input            n_read20;            // Active20 low20 read signal20
  input            n_r_read20;          // Store20 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store20;      // Chip20 select20 LE20 store20
  input [1:0]      r_oete_store20;      // Read strobe20 TE20 end time before CS20
  input       cs;        // chip20 selects20
  input       r_cs20;      // registered chip20 selects20

  output [4:0]      r_smc_currentstate20;// Synchronised20 SMC20 state machine20
  output [4:0]      smc_nextstate20;     // State20 Machine20 
  output            cste_enable20;       // Enable20 CS20 Trailing20 Edge20 counter
  output            ws_enable20;         // Wait20 state counter enable
  output            smc_done20;          // one access completed
  output            valid_access20;      // load20 values are valid if high20
  output            le_enable20;         // Enable20 all Leading20 Edge20 
                                           // counters20
  output            latch_data20;        // latch_data20 is used by the 
                                           // MAC20 block
                                     //  to store20 read data if CSTE20 > 0
  output            smc_idle20;          // idle20 state



// Output20 register declarations20

  reg [4:0]    smc_nextstate20;     // SMC20 state machine20 (async20 encoding20)
  reg [4:0]    r_smc_currentstate20;// Synchronised20 SMC20 state machine20
  reg          ws_enable20;         // Wait20 state counter enable
  reg          cste_enable20;       // Chip20 select20 counter enable
  reg          smc_done20;         // Asserted20 during last cycle of access
  reg          valid_access20;      // load20 values are valid if high20
  reg          le_enable20;         // Enable20 all Leading20 Edge20 counters20
  reg          latch_data20;        // latch_data20 is used by the MAC20 block
  reg          smc_idle20;          // idle20 state
  


//----------------------------------------------------------------------
// Main20 code20
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC20 state machine20
//----------------------------------------------------------------------
// Generates20 the required20 timings20 for the External20 Memory Interface20.
// If20 back-to-back accesses are required20 the state machine20 will bypass20
// the idle20 state, thus20 maintaining20 the chip20 select20 ouput20.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate20 internal idle20 signal20 used by AHB20 IF
//----------------------------------------------------------------------

  always @(smc_nextstate20)
  
  begin
   
     if (smc_nextstate20 == `SMC_IDLE20)
     
        smc_idle20 = 1'b1;
   
     else
       
        smc_idle20 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate20 internal done signal20
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate20 or r_cste_count20 or r_ws_count20)
  
  begin
   
     if ( ( (r_smc_currentstate20 == `SMC_RW20) &
            (r_ws_count20 == 8'd0) &
            (r_cste_count20 == 2'd0)
          ) |
          ( (r_smc_currentstate20 == `SMC_FLOAT20)  &
            (r_cste_count20 == 2'd0)
          )
        )
       
        smc_done20 = 1'b1;
   
   else
     
      smc_done20 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data20 is used by the MAC20 block to store20 read data if CSTE20 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate20 or r_ws_count20 or r_oete_store20)
  
  begin
   
     if ( (r_smc_currentstate20 == `SMC_RW20) &
          (r_ws_count20[1:0] >= r_oete_store20) &
          (r_ws_count20[7:2] == 6'd0)
        )
     
       latch_data20 = 1'b1;
   
     else
       
       latch_data20 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter20 enable signals20
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate20 or r_csle_count20 or
       smc_nextstate20 or valid_access20)
  begin
     if(valid_access20)
     begin
        if ((smc_nextstate20 == `SMC_RW20)         &
            (r_smc_currentstate20 != `SMC_STORE20) &
            (r_smc_currentstate20 != `SMC_LE20))
  
          ws_enable20 = 1'b1;
  
        else
  
          ws_enable20 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate20 == `SMC_RW20) & 
            (r_csle_count20 == 2'd0) & 
            (r_smc_currentstate20 != `SMC_STORE20) &
            (r_smc_currentstate20 != `SMC_LE20))

           ws_enable20 = 1'b1;
   
        else
  
           ws_enable20 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable20
//----------------------------------------------------------------------

  always @(r_smc_currentstate20 or smc_nextstate20)
  
  begin
  
     if (((smc_nextstate20 == `SMC_LE20) | (smc_nextstate20 == `SMC_RW20) ) &
         (r_smc_currentstate20 != `SMC_STORE20) )
  
        le_enable20 = 1'b1;
  
     else
  
        le_enable20 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable20
//----------------------------------------------------------------------
  
  always @(smc_nextstate20)
  
  begin
     if (smc_nextstate20 == `SMC_FLOAT20)
    
        cste_enable20 = 1'b1;
   
     else
  
        cste_enable20 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH20 if new cycle is waiting20 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate20 or new_access20 or r_ws_count20 or
                                     smc_nextstate20 or mac_done20)
  
  begin
     
     if (new_access20 & mac_done20 &
         (((r_smc_currentstate20 == `SMC_RW20) & 
           (smc_nextstate20 == `SMC_RW20) & 
           (r_ws_count20 == 8'd0))                                |
          ((r_smc_currentstate20 == `SMC_FLOAT20) & 
           (smc_nextstate20 == `SMC_IDLE20) ) |
          ((r_smc_currentstate20 == `SMC_FLOAT20) & 
           (smc_nextstate20 == `SMC_LE20)   ) |
          ((r_smc_currentstate20 == `SMC_FLOAT20) & 
           (smc_nextstate20 == `SMC_RW20)   ) |
          ((r_smc_currentstate20 == `SMC_FLOAT20) & 
           (smc_nextstate20 == `SMC_STORE20)) |
          ((r_smc_currentstate20 == `SMC_RW20)    & 
           (smc_nextstate20 == `SMC_STORE20)) |
          ((r_smc_currentstate20 == `SMC_RW20)    & 
           (smc_nextstate20 == `SMC_IDLE20) ) |
          ((r_smc_currentstate20 == `SMC_RW20)    & 
           (smc_nextstate20 == `SMC_LE20)   ) |
          ((r_smc_currentstate20 == `SMC_IDLE20) ) )  )    
       
       valid_access20 = 1'b1;
     
     else
       
       valid_access20 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC20 State20 Machine20
//----------------------------------------------------------------------

 always @(r_smc_currentstate20 or new_access20 or 
          cs or r_csle_count20 or r_cste_count20 or r_ws_count20 or mac_done20 
          or r_cs20 or n_read20 or n_r_read20 or r_csle_store20)
  begin
   
   case (r_smc_currentstate20)
  
     `SMC_IDLE20 :
  
        if (new_access20 )
 
           smc_nextstate20 = `SMC_STORE20;
  
        else
  
        begin
  
  
           begin

              if (new_access20 )
  
                 smc_nextstate20 = `SMC_RW20;

              else
  
                 smc_nextstate20 = `SMC_IDLE20;

           end
          
        end

     `SMC_STORE20   :

        if ((r_csle_count20 != 2'd0))

           smc_nextstate20 = `SMC_LE20;

        else

        begin
           
           if ( (r_csle_count20 == 2'd0))

              smc_nextstate20 = `SMC_RW20;
           
           else
             
              smc_nextstate20 = `SMC_STORE20;

        end      

     `SMC_LE20   :
  
        if (r_csle_count20 < 2'd2)
  
           smc_nextstate20 = `SMC_RW20;
  
        else
  
           smc_nextstate20 = `SMC_LE20;
  
     `SMC_RW20   :
  
     begin
          
        if ((r_ws_count20 == 8'd0) & 
            (r_cste_count20 != 2'd0))
  
           smc_nextstate20 = `SMC_FLOAT20;
          
        else if ((r_ws_count20 == 8'd0) &
                 (r_cste_count20 == 2'h0) &
                 mac_done20 & ~new_access20)

           smc_nextstate20 = `SMC_IDLE20;
          
        else if ((~mac_done20 & (r_csle_store20 != 2'd0)) &
                 (r_ws_count20 == 8'd0))
 
           smc_nextstate20 = `SMC_LE20;

        
        else
          
        begin
  
           if  ( ((n_read20 != n_r_read20) | ((cs != r_cs20) & ~n_r_read20)) & 
                  new_access20 & mac_done20 &
                 (r_ws_count20 == 8'd0))   
             
              smc_nextstate20 = `SMC_STORE20;
           
           else
             
              smc_nextstate20 = `SMC_RW20;
           
        end
        
     end
  
     `SMC_FLOAT20   :
        if (~ mac_done20                               & 
            (( & new_access20) | 
             ((r_csle_store20 == 2'd0)            &
              ~new_access20)) &  (r_cste_count20 == 2'd0) )
  
           smc_nextstate20 = `SMC_RW20;
  
        else if (new_access20                              & 
                 (( new_access20) |
                  ((r_csle_store20 == 2'd0)            & 
                   ~new_access20)) & (r_cste_count20 == 2'd0) )

        begin
  
           if  (((n_read20 != n_r_read20) | ((cs != r_cs20) & ~n_r_read20)))   
  
              smc_nextstate20 = `SMC_STORE20;
  
           else
  
              smc_nextstate20 = `SMC_RW20;
  
        end
     
        else
          
        begin
  
           if ((~mac_done20 & (r_csle_store20 != 2'd0)) & 
               (r_cste_count20 < 2'd1))
  
              smc_nextstate20 = `SMC_LE20;

           
           else
             
           begin
           
              if (r_cste_count20 == 2'd0)
             
                 smc_nextstate20 = `SMC_IDLE20;
           
              else
  
                 smc_nextstate20 = `SMC_FLOAT20;
  
           end
           
        end
     
     default   :
       
       smc_nextstate20 = `SMC_IDLE20;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential20 process of state machine20
//----------------------------------------------------------------------

  always @(posedge sys_clk20 or negedge n_sys_reset20)
  
  begin
  
     if (~n_sys_reset20)
  
        r_smc_currentstate20 <= `SMC_IDLE20;
  
  
     else   
       
        r_smc_currentstate20 <= smc_nextstate20;
  
  
  end

   

   
endmodule


