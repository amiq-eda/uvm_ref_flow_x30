//File18 name   : smc_state_lite18.v
//Title18       : 
//Created18     : 1999
//
//Description18 : SMC18 State18 Machine18
//            : Static18 Memory Controller18
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

`include "smc_defs_lite18.v"

//state machine18 for smc18
  module smc_state_lite18  (
                     //inputs18
  
                     sys_clk18,
                     n_sys_reset18,
                     new_access18,
                     r_cste_count18,
                     r_csle_count18,
                     r_ws_count18,
                     mac_done18,
                     n_read18,
                     n_r_read18,
                     r_csle_store18,
                     r_oete_store18,
                     cs,
                     r_cs18,
             
                     //outputs18
  
                     r_smc_currentstate18,
                     smc_nextstate18,
                     cste_enable18,
                     ws_enable18,
                     smc_done18,
                     valid_access18,
                     le_enable18,
                     latch_data18,
                     smc_idle18);
   
   
   
//Parameters18  -  Values18 in smc_defs18.v



// I18/O18

  input            sys_clk18;           // AHB18 System18 clock18
  input            n_sys_reset18;       // AHB18 System18 reset (Active18 LOW18)
  input            new_access18;        // New18 AHB18 valid access to smc18 
                                          // detected
  input [1:0]      r_cste_count18;      // Chip18 select18 TE18 counter
  input [1:0]      r_csle_count18;      // chip18 select18 leading18 edge count
  input [7:0]      r_ws_count18; // wait state count
  input            mac_done18;          // All cycles18 in a multiple access
  input            n_read18;            // Active18 low18 read signal18
  input            n_r_read18;          // Store18 RW state for multiple 
                                           // accesses
  input [1:0]      r_csle_store18;      // Chip18 select18 LE18 store18
  input [1:0]      r_oete_store18;      // Read strobe18 TE18 end time before CS18
  input       cs;        // chip18 selects18
  input       r_cs18;      // registered chip18 selects18

  output [4:0]      r_smc_currentstate18;// Synchronised18 SMC18 state machine18
  output [4:0]      smc_nextstate18;     // State18 Machine18 
  output            cste_enable18;       // Enable18 CS18 Trailing18 Edge18 counter
  output            ws_enable18;         // Wait18 state counter enable
  output            smc_done18;          // one access completed
  output            valid_access18;      // load18 values are valid if high18
  output            le_enable18;         // Enable18 all Leading18 Edge18 
                                           // counters18
  output            latch_data18;        // latch_data18 is used by the 
                                           // MAC18 block
                                     //  to store18 read data if CSTE18 > 0
  output            smc_idle18;          // idle18 state



// Output18 register declarations18

  reg [4:0]    smc_nextstate18;     // SMC18 state machine18 (async18 encoding18)
  reg [4:0]    r_smc_currentstate18;// Synchronised18 SMC18 state machine18
  reg          ws_enable18;         // Wait18 state counter enable
  reg          cste_enable18;       // Chip18 select18 counter enable
  reg          smc_done18;         // Asserted18 during last cycle of access
  reg          valid_access18;      // load18 values are valid if high18
  reg          le_enable18;         // Enable18 all Leading18 Edge18 counters18
  reg          latch_data18;        // latch_data18 is used by the MAC18 block
  reg          smc_idle18;          // idle18 state
  


//----------------------------------------------------------------------
// Main18 code18
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// SMC18 state machine18
//----------------------------------------------------------------------
// Generates18 the required18 timings18 for the External18 Memory Interface18.
// If18 back-to-back accesses are required18 the state machine18 will bypass18
// the idle18 state, thus18 maintaining18 the chip18 select18 ouput18.
//----------------------------------------------------------------------



//----------------------------------------------------------------------
// Generate18 internal idle18 signal18 used by AHB18 IF
//----------------------------------------------------------------------

  always @(smc_nextstate18)
  
  begin
   
     if (smc_nextstate18 == `SMC_IDLE18)
     
        smc_idle18 = 1'b1;
   
     else
       
        smc_idle18 = 1'b0;
   
  end
  


//----------------------------------------------------------------------
// Generate18 internal done signal18
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate18 or r_cste_count18 or r_ws_count18)
  
  begin
   
     if ( ( (r_smc_currentstate18 == `SMC_RW18) &
            (r_ws_count18 == 8'd0) &
            (r_cste_count18 == 2'd0)
          ) |
          ( (r_smc_currentstate18 == `SMC_FLOAT18)  &
            (r_cste_count18 == 2'd0)
          )
        )
       
        smc_done18 = 1'b1;
   
   else
     
      smc_done18 = 1'b0;
   
  end



//----------------------------------------------------------------------
// latch_data18 is used by the MAC18 block to store18 read data if CSTE18 > 0
//----------------------------------------------------------------------

  always @(r_smc_currentstate18 or r_ws_count18 or r_oete_store18)
  
  begin
   
     if ( (r_smc_currentstate18 == `SMC_RW18) &
          (r_ws_count18[1:0] >= r_oete_store18) &
          (r_ws_count18[7:2] == 6'd0)
        )
     
       latch_data18 = 1'b1;
   
     else
       
       latch_data18 = 1'b0;
   
    end
  


//----------------------------------------------------------------------
// Generatecounter18 enable signals18
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate18 or r_csle_count18 or
       smc_nextstate18 or valid_access18)
  begin
     if(valid_access18)
     begin
        if ((smc_nextstate18 == `SMC_RW18)         &
            (r_smc_currentstate18 != `SMC_STORE18) &
            (r_smc_currentstate18 != `SMC_LE18))
  
          ws_enable18 = 1'b1;
  
        else
  
          ws_enable18 = 1'b0;
  
     end
     
     else
       
     begin
  
        if ((smc_nextstate18 == `SMC_RW18) & 
            (r_csle_count18 == 2'd0) & 
            (r_smc_currentstate18 != `SMC_STORE18) &
            (r_smc_currentstate18 != `SMC_LE18))

           ws_enable18 = 1'b1;
   
        else
  
           ws_enable18 = 1'b0;
  
     end
     
  end
   
//----------------------------------------------------------------------
//le_enable18
//----------------------------------------------------------------------

  always @(r_smc_currentstate18 or smc_nextstate18)
  
  begin
  
     if (((smc_nextstate18 == `SMC_LE18) | (smc_nextstate18 == `SMC_RW18) ) &
         (r_smc_currentstate18 != `SMC_STORE18) )
  
        le_enable18 = 1'b1;
  
     else
  
        le_enable18 = 1'b0;  
  
    end
  
//----------------------------------------------------------------------
//cste_enable18
//----------------------------------------------------------------------
  
  always @(smc_nextstate18)
  
  begin
     if (smc_nextstate18 == `SMC_FLOAT18)
    
        cste_enable18 = 1'b1;
   
     else
  
        cste_enable18 = 1'b0;
  
  end
  


   


//----------------------------------------------------------------------
// valid access is HIGH18 if new cycle is waiting18 
// to start & the last is complete
//----------------------------------------------------------------------
  
  always @(r_smc_currentstate18 or new_access18 or r_ws_count18 or
                                     smc_nextstate18 or mac_done18)
  
  begin
     
     if (new_access18 & mac_done18 &
         (((r_smc_currentstate18 == `SMC_RW18) & 
           (smc_nextstate18 == `SMC_RW18) & 
           (r_ws_count18 == 8'd0))                                |
          ((r_smc_currentstate18 == `SMC_FLOAT18) & 
           (smc_nextstate18 == `SMC_IDLE18) ) |
          ((r_smc_currentstate18 == `SMC_FLOAT18) & 
           (smc_nextstate18 == `SMC_LE18)   ) |
          ((r_smc_currentstate18 == `SMC_FLOAT18) & 
           (smc_nextstate18 == `SMC_RW18)   ) |
          ((r_smc_currentstate18 == `SMC_FLOAT18) & 
           (smc_nextstate18 == `SMC_STORE18)) |
          ((r_smc_currentstate18 == `SMC_RW18)    & 
           (smc_nextstate18 == `SMC_STORE18)) |
          ((r_smc_currentstate18 == `SMC_RW18)    & 
           (smc_nextstate18 == `SMC_IDLE18) ) |
          ((r_smc_currentstate18 == `SMC_RW18)    & 
           (smc_nextstate18 == `SMC_LE18)   ) |
          ((r_smc_currentstate18 == `SMC_IDLE18) ) )  )    
       
       valid_access18 = 1'b1;
     
     else
       
       valid_access18 = 1'b0;
  
  end
  
  
  
//----------------------------------------------------------------------
// SMC18 State18 Machine18
//----------------------------------------------------------------------

 always @(r_smc_currentstate18 or new_access18 or 
          cs or r_csle_count18 or r_cste_count18 or r_ws_count18 or mac_done18 
          or r_cs18 or n_read18 or n_r_read18 or r_csle_store18)
  begin
   
   case (r_smc_currentstate18)
  
     `SMC_IDLE18 :
  
        if (new_access18 )
 
           smc_nextstate18 = `SMC_STORE18;
  
        else
  
        begin
  
  
           begin

              if (new_access18 )
  
                 smc_nextstate18 = `SMC_RW18;

              else
  
                 smc_nextstate18 = `SMC_IDLE18;

           end
          
        end

     `SMC_STORE18   :

        if ((r_csle_count18 != 2'd0))

           smc_nextstate18 = `SMC_LE18;

        else

        begin
           
           if ( (r_csle_count18 == 2'd0))

              smc_nextstate18 = `SMC_RW18;
           
           else
             
              smc_nextstate18 = `SMC_STORE18;

        end      

     `SMC_LE18   :
  
        if (r_csle_count18 < 2'd2)
  
           smc_nextstate18 = `SMC_RW18;
  
        else
  
           smc_nextstate18 = `SMC_LE18;
  
     `SMC_RW18   :
  
     begin
          
        if ((r_ws_count18 == 8'd0) & 
            (r_cste_count18 != 2'd0))
  
           smc_nextstate18 = `SMC_FLOAT18;
          
        else if ((r_ws_count18 == 8'd0) &
                 (r_cste_count18 == 2'h0) &
                 mac_done18 & ~new_access18)

           smc_nextstate18 = `SMC_IDLE18;
          
        else if ((~mac_done18 & (r_csle_store18 != 2'd0)) &
                 (r_ws_count18 == 8'd0))
 
           smc_nextstate18 = `SMC_LE18;

        
        else
          
        begin
  
           if  ( ((n_read18 != n_r_read18) | ((cs != r_cs18) & ~n_r_read18)) & 
                  new_access18 & mac_done18 &
                 (r_ws_count18 == 8'd0))   
             
              smc_nextstate18 = `SMC_STORE18;
           
           else
             
              smc_nextstate18 = `SMC_RW18;
           
        end
        
     end
  
     `SMC_FLOAT18   :
        if (~ mac_done18                               & 
            (( & new_access18) | 
             ((r_csle_store18 == 2'd0)            &
              ~new_access18)) &  (r_cste_count18 == 2'd0) )
  
           smc_nextstate18 = `SMC_RW18;
  
        else if (new_access18                              & 
                 (( new_access18) |
                  ((r_csle_store18 == 2'd0)            & 
                   ~new_access18)) & (r_cste_count18 == 2'd0) )

        begin
  
           if  (((n_read18 != n_r_read18) | ((cs != r_cs18) & ~n_r_read18)))   
  
              smc_nextstate18 = `SMC_STORE18;
  
           else
  
              smc_nextstate18 = `SMC_RW18;
  
        end
     
        else
          
        begin
  
           if ((~mac_done18 & (r_csle_store18 != 2'd0)) & 
               (r_cste_count18 < 2'd1))
  
              smc_nextstate18 = `SMC_LE18;

           
           else
             
           begin
           
              if (r_cste_count18 == 2'd0)
             
                 smc_nextstate18 = `SMC_IDLE18;
           
              else
  
                 smc_nextstate18 = `SMC_FLOAT18;
  
           end
           
        end
     
     default   :
       
       smc_nextstate18 = `SMC_IDLE18;
     
   endcase
     
  end
   
//----------------------------------------------------------------------
//sequential18 process of state machine18
//----------------------------------------------------------------------

  always @(posedge sys_clk18 or negedge n_sys_reset18)
  
  begin
  
     if (~n_sys_reset18)
  
        r_smc_currentstate18 <= `SMC_IDLE18;
  
  
     else   
       
        r_smc_currentstate18 <= smc_nextstate18;
  
  
  end

   

   
endmodule


