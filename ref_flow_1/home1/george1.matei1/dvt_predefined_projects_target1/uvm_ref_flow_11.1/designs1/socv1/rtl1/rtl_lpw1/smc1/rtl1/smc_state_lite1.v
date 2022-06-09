//File1 name   : smc_state_lite1.v
//Title1       : 
//Created1     : 1999
//
//Description1 : SMC1 State1 Machine1
//            : Static1 Memory Controller1
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

`include "smc_defs_lite1.v"

//state machine1 for smc1
  module smc_state_lite1  (
                     //inputs1
  
                     sys_clk1,
                     n_sys_reset1,
                     new_access1,
                     r_cste_count1,
                     r_csle_count1,
                     r_ws_count1,
                     mac_done1,
                     n_read1,
                     n_r_read1,
                     r_csle_store1,
                     r_oete_store1,
                     cs,
                     r_cs1,
             
                     //outputs1
  
                     r_smc_currentstate1,
                     smc_nextstate1,
                     cste_enable1,
                     ws_enable1,
                     smc_done1,
                     valid_access1,
                     le_enable1,
                     latch_data1,
                     smc_idle1);
   
   
   
//Parameters1  -  Values1 in smc_defs1.v



// I1/O1

  input            sys_clk1;           // AHB1 System1 clock1
  input            n_sys_reset1;       // AHB1 System1 reset (Active1 LOW1)
  input            new_access1;        // New1 AHB1 valid access to smc1 
                                          // detected
  input [1:0]      r_cste_count1;      // Chip1 select1 TE1 counter
  input [1:0]      r_csle_count1;      // chip1 select1 leading1 edge count
  input [7:0]      r_ws_count1; // wait state count
  input            mac_done1;          // All cycles1 in a multiple access
  input            n_read1;            // Active1 low1 read signal1
  input            n_r_read1;          // Store1 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store1;      // Chip1 select1 LE1 store1
  input [1:0]      r_oete_store1;      // Read strobe1 TE1 end time before CS1
  input       cs;        // chip1 selects1
  input       r_cs1;      // registered chip1 selects1

  output [4:0]      r_smc_currentstate1;// Synchronised1 SMC1 state machine1
  output [4:0]      smc_nextstate1;     // State1 Machine1 
  output            cste_enable1;       // Enable1 CS1 Trailing1 Edge1 counter
  output            ws_enable1;         // Wait1 state counter enable
  output            smc_done1;          // one access completed
  output            valid_access1;      // load1 values are valid if high1
  output            le_enable1;         // Enable1 all Leading1 Edge1 
                                           // counters1
  output            latch_data1;        // latch_data1 is used by the 
                                           // MAC1 block
                                     //  to store1 read data if CSTE1 > 0
  output            smc_idle1;          // idle1 state



// Output1 register declarations1

  reg [4:0]    smc_nextstate1;     // SMC1 state machine1 (async1 encoding1)
  reg [4:0]    r_smc_currentstate1;// Synchronised1 SMC1 state machine1
  reg          ws_enable1;         // Wait1 state counter enable
  reg          cste_enable1;       // Chip1 select1 counter enable
  reg          smc_done1;         // Asserted1 during last cycle of access
  reg          valid_access1;      // load1 values are valid if high1
  reg          le_enable1;         // Enable1 all Leading1 Edge1 counters1
  reg          latch_data1;        // latch_data1 is used by the MAC1 block
  reg          smc_idle1;          // idle1 state
  


//----------------------------------------------------------------------
// Main1 code1
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC1 state machine1
//----------------------------------------------------------------------
// Generates1 the required1 timings1 for the External1 Memory Interface1.
// If1 back-to-back accesses are required1 the state machine1 will bypass1
// the idle1 state, thus1 maintaining1 the chip1 select1 ouput1.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate1 internal idle1 signal1 used by AHB1 IF
//----------------------------------------------------------------------

  always @(smc_nextstate1)
  
  begin
   
     if (smc_nextstate1 == `SMC_IDLE1)
     
        smc_idle1 = 1'b1;
   
     else
       
        smc_idle1 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate1 internal done signal1
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate1 or r_cste_count1 or r_ws_count1)
  
  begin
   
     if ( ( (r_smc_currentstate1 == `SMC_RW1) &
            (r_ws_count1 == 8'd0) &
            (r_cste_count1 == 2'd0)
          ) |
          ( (r_smc_currentstate1 == `SMC_FLOAT1)  &
            (r_cste_count1 == 2'd0)
          )
        )
       
        smc_done1 = 1'b1;
   
   else
     
      smc_done1 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data1 is used by the MAC1 block to store1 read data if CSTE1 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate1 or r_ws_count1 or r_oete_store1)
  
  begin
   
     if ( (r_smc_currentstate1 == `SMC_RW1) &
          (r_ws_count1[1:0] >= r_oete_store1) &
          (r_ws_count1[7:2] == 6'd0)
        )
     
       latch_data1 = 1'b1;
   
     else
       
       latch_data1 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter1 enable signals1
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate1 or r_csle_count1 or
       smc_nextstate1 or valid_access1)
  begin
     if(valid_access1)
     begin
        if ((smc_nextstate1 == `SMC_RW1)         &
            (r_smc_currentstate1 != `SMC_STORE1) &
            (r_smc_currentstate1 != `SMC_LE1))
  
          ws_enable1 = 1'b1;
  
        else
  
          ws_enable1 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate1 == `SMC_RW1) & 
            (r_csle_count1 == 2'd0) & 
            (r_smc_currentstate1 != `SMC_STORE1) &
            (r_smc_currentstate1 != `SMC_LE1))

           ws_enable1 = 1'b1;
   
        else
  
           ws_enable1 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable1
//----------------------------------------------------------------------

  always @(r_smc_currentstate1 or smc_nextstate1)
  
  begin
  
     if (((smc_nextstate1 == `SMC_LE1) | (smc_nextstate1 == `SMC_RW1) ) &
         (r_smc_currentstate1 != `SMC_STORE1) )
  
        le_enable1 = 1'b1;
  
     else
  
        le_enable1 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable1
//----------------------------------------------------------------------
  
  always @(smc_nextstate1)
  
  begin
     if (smc_nextstate1 == `SMC_FLOAT1)
    
        cste_enable1 = 1'b1;
   
     else
  
        cste_enable1 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH1 if new cycle is waiting1 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate1 or new_access1 or r_ws_count1 or
                                     smc_nextstate1 or mac_done1)
  
  begin
     
     if (new_access1 & mac_done1 &
         (((r_smc_currentstate1 == `SMC_RW1) & 
           (smc_nextstate1 == `SMC_RW1) & 
           (r_ws_count1 == 8'd0))                                |
          ((r_smc_currentstate1 == `SMC_FLOAT1) & 
           (smc_nextstate1 == `SMC_IDLE1) ) |
          ((r_smc_currentstate1 == `SMC_FLOAT1) & 
           (smc_nextstate1 == `SMC_LE1)   ) |
          ((r_smc_currentstate1 == `SMC_FLOAT1) & 
           (smc_nextstate1 == `SMC_RW1)   ) |
          ((r_smc_currentstate1 == `SMC_FLOAT1) & 
           (smc_nextstate1 == `SMC_STORE1)) |
          ((r_smc_currentstate1 == `SMC_RW1)    & 
           (smc_nextstate1 == `SMC_STORE1)) |
          ((r_smc_currentstate1 == `SMC_RW1)    & 
           (smc_nextstate1 == `SMC_IDLE1) ) |
          ((r_smc_currentstate1 == `SMC_RW1)    & 
           (smc_nextstate1 == `SMC_LE1)   ) |
          ((r_smc_currentstate1 == `SMC_IDLE1) ) )  )    
       
       valid_access1 = 1'b1;
     
     else
       
       valid_access1 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC1 State1 Machine1
//----------------------------------------------------------------------

 always @(r_smc_currentstate1 or new_access1 or 
          cs or r_csle_count1 or r_cste_count1 or r_ws_count1 or mac_done1 
          or r_cs1 or n_read1 or n_r_read1 or r_csle_store1)
  begin
   
   case (r_smc_currentstate1)
  
     `SMC_IDLE1 :
  
        if (new_access1 )
 
           smc_nextstate1 = `SMC_STORE1;
  
        else
  
        begin
  
  
           begin

              if (new_access1 )
  
                 smc_nextstate1 = `SMC_RW1;

              else
  
                 smc_nextstate1 = `SMC_IDLE1;

           end
          
        end

     `SMC_STORE1   :

        if ((r_csle_count1 != 2'd0))

           smc_nextstate1 = `SMC_LE1;

        else

        begin
           
           if ( (r_csle_count1 == 2'd0))

              smc_nextstate1 = `SMC_RW1;
           
           else
             
              smc_nextstate1 = `SMC_STORE1;

        end      

     `SMC_LE1   :
  
        if (r_csle_count1 < 2'd2)
  
           smc_nextstate1 = `SMC_RW1;
  
        else
  
           smc_nextstate1 = `SMC_LE1;
  
     `SMC_RW1   :
  
     begin
          
        if ((r_ws_count1 == 8'd0) & 
            (r_cste_count1 != 2'd0))
  
           smc_nextstate1 = `SMC_FLOAT1;
          
        else if ((r_ws_count1 == 8'd0) &
                 (r_cste_count1 == 2'h0) &
                 mac_done1 & ~new_access1)

           smc_nextstate1 = `SMC_IDLE1;
          
        else if ((~mac_done1 & (r_csle_store1 != 2'd0)) &
                 (r_ws_count1 == 8'd0))
 
           smc_nextstate1 = `SMC_LE1;

        
        else
          
        begin
  
           if  ( ((n_read1 != n_r_read1) | ((cs != r_cs1) & ~n_r_read1)) & 
                  new_access1 & mac_done1 &
                 (r_ws_count1 == 8'd0))   
             
              smc_nextstate1 = `SMC_STORE1;
           
           else
             
              smc_nextstate1 = `SMC_RW1;
           
        end
        
     end
  
     `SMC_FLOAT1   :
        if (~ mac_done1                               & 
            (( & new_access1) | 
             ((r_csle_store1 == 2'd0)            &
              ~new_access1)) &  (r_cste_count1 == 2'd0) )
  
           smc_nextstate1 = `SMC_RW1;
  
        else if (new_access1                              & 
                 (( new_access1) |
                  ((r_csle_store1 == 2'd0)            & 
                   ~new_access1)) & (r_cste_count1 == 2'd0) )

        begin
  
           if  (((n_read1 != n_r_read1) | ((cs != r_cs1) & ~n_r_read1)))   
  
              smc_nextstate1 = `SMC_STORE1;
  
           else
  
              smc_nextstate1 = `SMC_RW1;
  
        end
     
        else
          
        begin
  
           if ((~mac_done1 & (r_csle_store1 != 2'd0)) & 
               (r_cste_count1 < 2'd1))
  
              smc_nextstate1 = `SMC_LE1;

           
           else
             
           begin
           
              if (r_cste_count1 == 2'd0)
             
                 smc_nextstate1 = `SMC_IDLE1;
           
              else
  
                 smc_nextstate1 = `SMC_FLOAT1;
  
           end
           
        end
     
     default   :
       
       smc_nextstate1 = `SMC_IDLE1;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential1 process of state machine1
//----------------------------------------------------------------------

  always @(posedge sys_clk1 or negedge n_sys_reset1)
  
  begin
  
     if (~n_sys_reset1)
  
        r_smc_currentstate1 <= `SMC_IDLE1;
  
  
     else   
       
        r_smc_currentstate1 <= smc_nextstate1;
  
  
  end

   

   
endmodule


