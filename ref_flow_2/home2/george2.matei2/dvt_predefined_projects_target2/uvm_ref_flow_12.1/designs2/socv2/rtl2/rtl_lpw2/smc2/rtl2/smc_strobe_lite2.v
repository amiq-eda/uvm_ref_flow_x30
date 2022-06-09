//File2 name   : smc_strobe_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`include "smc_defs_lite2.v"

module smc_strobe_lite2  (

                    //inputs2

                    sys_clk2,
                    n_sys_reset2,
                    valid_access2,
                    n_read2,
                    cs,
                    r_smc_currentstate2,
                    smc_nextstate2,
                    n_be2,
                    r_wele_count2,
                    r_wele_store2,
                    r_wete_store2,
                    r_oete_store2,
                    r_ws_count2,
                    r_ws_store2,
                    smc_done2,
                    mac_done2,

                    //outputs2

                    smc_n_rd2,
                    smc_n_ext_oe2,
                    smc_busy2,
                    n_r_read2,
                    r_cs2,
                    r_full2,
                    n_r_we2,
                    n_r_wr2);



//Parameters2  -  Values2 in smc_defs2.v

 


// I2/O2

   input                   sys_clk2;      //System2 clock2
   input                   n_sys_reset2;  //System2 reset (Active2 LOW2)
   input                   valid_access2; //load2 values are valid if high2
   input                   n_read2;       //Active2 low2 read signal2
   input              cs;           //registered chip2 select2
   input [4:0]             r_smc_currentstate2;//current state
   input [4:0]             smc_nextstate2;//next state  
   input [3:0]             n_be2;         //Unregistered2 Byte2 strobes2
   input [1:0]             r_wele_count2; //Write counter
   input [1:0]             r_wete_store2; //write strobe2 trailing2 edge store2
   input [1:0]             r_oete_store2; //read strobe2
   input [1:0]             r_wele_store2; //write strobe2 leading2 edge store2
   input [7:0]             r_ws_count2;   //wait state count
   input [7:0]             r_ws_store2;   //wait state store2
   input                   smc_done2;  //one access completed
   input                   mac_done2;  //All cycles2 in a multiple access
   
   
   output                  smc_n_rd2;     // EMI2 read stobe2 (Active2 LOW2)
   output                  smc_n_ext_oe2; // Enable2 External2 bus drivers2.
                                                          //  (CS2 & ~RD2)
   output                  smc_busy2;  // smc2 busy
   output                  n_r_read2;  // Store2 RW strobe2 for multiple
                                                         //  accesses
   output                  r_full2;    // Full cycle write strobe2
   output [3:0]            n_r_we2;    // write enable strobe2(active low2)
   output                  n_r_wr2;    // write strobe2(active low2)
   output             r_cs2;      // registered chip2 select2.   


// Output2 register declarations2

   reg                     smc_n_rd2;
   reg                     smc_n_ext_oe2;
   reg                r_cs2;
   reg                     smc_busy2;
   reg                     n_r_read2;
   reg                     r_full2;
   reg   [3:0]             n_r_we2;
   reg                     n_r_wr2;

   //wire declarations2
   
   wire             smc_mac_done2;       //smc_done2 and  mac_done2 anded2
   wire [2:0]       wait_vaccess_smdone2;//concatenated2 signals2 for case
   reg              half_cycle2;         //used for generating2 half2 cycle
                                                //strobes2
   


//----------------------------------------------------------------------
// Strobe2 Generation2
//
// Individual Write Strobes2
// Write Strobe2 = Byte2 Enable2 & Write Enable2
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal2 concatenation2 for use in case statement2
//----------------------------------------------------------------------

   assign smc_mac_done2 = {smc_done2 & mac_done2};

   assign wait_vaccess_smdone2 = {1'b0,valid_access2,smc_mac_done2};
   
   
//----------------------------------------------------------------------
// Store2 read/write signal2 for duration2 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk2 or negedge n_sys_reset2)
  
     begin
  
        if (~n_sys_reset2)
  
           n_r_read2 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone2)
               
               3'b1xx:
                 
                  n_r_read2 <= n_r_read2;
               
               3'b01x:
                 
                  n_r_read2 <= n_read2;
               
               3'b001:
                 
                  n_r_read2 <= 0;
               
               default:
                 
                  n_r_read2 <= n_r_read2;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store2 chip2 selects2 for duration2 of cycle(s)--turnaround2 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store2 read/write signal2 for duration2 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk2 or negedge n_sys_reset2)
     
      begin
           
         if (~n_sys_reset2)
           
           r_cs2 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone2)
                
                 3'b1xx:
                  
                    r_cs2 <= r_cs2 ;
                
                 3'b01x:
                  
                    r_cs2 <= cs ;
                
                 3'b001:
                  
                    r_cs2 <= 1'b0;
                
                 default:
                  
                    r_cs2 <= r_cs2 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive2 busy output whenever2 smc2 active
//----------------------------------------------------------------------

   always @(posedge sys_clk2 or negedge n_sys_reset2)
     
      begin
          
         if (~n_sys_reset2)
           
            smc_busy2 <= 0;
           
           
         else if (smc_nextstate2 != `SMC_IDLE2)
           
            smc_busy2 <= 1;
           
         else
           
            smc_busy2 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive2 OE2 signal2 to I2/O2 pins2 on ASIC2
//
// Generate2 internal, registered Write strobes2
// The write strobes2 are gated2 with the clock2 later2 to generate half2 
// cycle strobes2
//----------------------------------------------------------------------

  always @(posedge sys_clk2 or negedge n_sys_reset2)
    
     begin
       
        if (~n_sys_reset2)
         
           begin
            
              n_r_we2 <= 4'hF;
              n_r_wr2 <= 1'h1;
            
           end
       

        else if ((n_read2 & valid_access2 & 
                  (smc_nextstate2 != `SMC_STORE2)) |
                 (n_r_read2 & ~valid_access2 & 
                  (smc_nextstate2 != `SMC_STORE2)))      
         
           begin
            
              n_r_we2 <= n_be2;
              n_r_wr2 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we2 <= 4'hF;
              n_r_wr2 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive2 OE2 signal2 to I2/O2 pins2 on ASIC2 -----added by gulbir2
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk2 or negedge n_sys_reset2)
     
     begin
        
        if (~n_sys_reset2)
          
          smc_n_ext_oe2 <= 1;
        
        
        else if ((n_read2 & valid_access2 & 
                  (smc_nextstate2 != `SMC_STORE2)) |
                (n_r_read2 & ~valid_access2 & 
              (smc_nextstate2 != `SMC_STORE2) & 
                 (smc_nextstate2 != `SMC_IDLE2)))      

           smc_n_ext_oe2 <= 0;
        
        else
          
           smc_n_ext_oe2 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate2 half2 and full signals2 for write strobes2
// A full cycle is required2 if wait states2 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate2 half2 cycle signals2 for write strobes2
//----------------------------------------------------------------------

always @(r_smc_currentstate2 or smc_nextstate2 or
            r_full2 or 
            r_wete_store2 or r_ws_store2 or r_wele_store2 or 
            r_ws_count2 or r_wele_count2 or 
            valid_access2 or smc_done2)
  
  begin     
     
       begin
          
          case (r_smc_currentstate2)
            
            `SMC_IDLE2:
              
              begin
                 
                     half_cycle2 = 1'b0;
                 
              end
            
            `SMC_LE2:
              
              begin
                 
                 if (smc_nextstate2 == `SMC_RW2)
                   
                   if( ( ( (r_wete_store2) == r_ws_count2[1:0]) &
                         (r_ws_count2[7:2] == 6'd0) &
                         (r_wele_count2 < 2'd2)
                       ) |
                       (r_ws_count2 == 8'd0)
                     )
                     
                     half_cycle2 = 1'b1 & ~r_full2;
                 
                   else
                     
                     half_cycle2 = 1'b0;
                 
                 else
                   
                   half_cycle2 = 1'b0;
                 
              end
            
            `SMC_RW2, `SMC_FLOAT2:
              
              begin
                 
                 if (smc_nextstate2 == `SMC_RW2)
                   
                   if (valid_access2)

                       
                       half_cycle2 = 1'b0;
                 
                   else if (smc_done2)
                     
                     if( ( (r_wete_store2 == r_ws_store2[1:0]) & 
                           (r_ws_store2[7:2] == 6'd0) & 
                           (r_wele_store2 == 2'd0)
                         ) | 
                         (r_ws_store2 == 8'd0)
                       )
                       
                       half_cycle2 = 1'b1 & ~r_full2;
                 
                     else
                       
                       half_cycle2 = 1'b0;
                 
                   else
                     
                     if (r_wete_store2 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count2[1:0]) & 
                            (r_ws_count2[7:2] == 6'd1) &
                            (r_wele_count2 < 2'd2)
                          )
                         
                         half_cycle2 = 1'b1 & ~r_full2;
                 
                       else
                         
                         half_cycle2 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store2+2'd1) == r_ws_count2[1:0]) & 
                              (r_ws_count2[7:2] == 6'd0) & 
                              (r_wele_count2 < 2'd2)
                            )
                          )
                         
                         half_cycle2 = 1'b1 & ~r_full2;
                 
                       else
                         
                         half_cycle2 = 1'b0;
                 
                 else
                   
                   half_cycle2 = 1'b0;
                 
              end
            
            `SMC_STORE2:
              
              begin
                 
                 if (smc_nextstate2 == `SMC_RW2)

                   if( ( ( (r_wete_store2) == r_ws_count2[1:0]) & 
                         (r_ws_count2[7:2] == 6'd0) & 
                         (r_wele_count2 < 2'd2)
                       ) | 
                       (r_ws_count2 == 8'd0)
                     )
                     
                     half_cycle2 = 1'b1 & ~r_full2;
                 
                   else
                     
                     half_cycle2 = 1'b0;
                 
                 else
                   
                   half_cycle2 = 1'b0;
                 
              end
            
            default:
              
              half_cycle2 = 1'b0;
            
          endcase // r_smc_currentstate2
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal2 generation2
//----------------------------------------------------------------------

 always @(posedge sys_clk2 or negedge n_sys_reset2)
             
   begin
      
      if (~n_sys_reset2)
        
        begin
           
           r_full2 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate2)
             
             `SMC_IDLE2:
               
               begin
                  
                  if (smc_nextstate2 == `SMC_RW2)
                    
                         
                         r_full2 <= 1'b0;
                       
                  else
                        
                       r_full2 <= 1'b0;
                       
               end
             
          `SMC_LE2:
            
          begin
             
             if (smc_nextstate2 == `SMC_RW2)
               
                  if( ( ( (r_wete_store2) < r_ws_count2[1:0]) | 
                        (r_ws_count2[7:2] != 6'd0)
                      ) & 
                      (r_wele_count2 < 2'd2)
                    )
                    
                    r_full2 <= 1'b1;
                  
                  else
                    
                    r_full2 <= 1'b0;
                  
             else
               
                  r_full2 <= 1'b0;
                  
          end
          
          `SMC_RW2, `SMC_FLOAT2:
            
            begin
               
               if (smc_nextstate2 == `SMC_RW2)
                 
                 begin
                    
                    if (valid_access2)
                      
                           
                           r_full2 <= 1'b0;
                         
                    else if (smc_done2)
                      
                         if( ( ( (r_wete_store2 < r_ws_store2[1:0]) | 
                                 (r_ws_store2[7:2] != 6'd0)
                               ) & 
                               (r_wele_store2 == 2'd0)
                             )
                           )
                           
                           r_full2 <= 1'b1;
                         
                         else
                           
                           r_full2 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store2 == 2'd3)
                           
                           if( ( (r_ws_count2[7:0] > 8'd4)
                               ) & 
                               (r_wele_count2 < 2'd2)
                             )
                             
                             r_full2 <= 1'b1;
                         
                           else
                             
                             r_full2 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store2 + 2'd1) < 
                                         r_ws_count2[1:0]
                                       )
                                     ) |
                                     (r_ws_count2[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count2 < 2'd2)
                                 )
                           
                           r_full2 <= 1'b1;
                         
                         else
                           
                           r_full2 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full2 <= 1'b0;
               
            end
             
             `SMC_STORE2:
               
               begin
                  
                  if (smc_nextstate2 == `SMC_RW2)

                     if ( ( ( (r_wete_store2) < r_ws_count2[1:0]) | 
                            (r_ws_count2[7:2] != 6'd0)
                          ) & 
                          (r_wele_count2 == 2'd0)
                        )
                         
                         r_full2 <= 1'b1;
                       
                       else
                         
                         r_full2 <= 1'b0;
                       
                  else
                    
                       r_full2 <= 1'b0;
                       
               end
             
             default:
               
                  r_full2 <= 1'b0;
                  
           endcase // r_smc_currentstate2
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate2 Read Strobe2
//----------------------------------------------------------------------
 
  always @(posedge sys_clk2 or negedge n_sys_reset2)
  
  begin
     
     if (~n_sys_reset2)
  
        smc_n_rd2 <= 1'h1;
      
      
     else if (smc_nextstate2 == `SMC_RW2)
  
     begin
  
        if (valid_access2)
  
        begin
  
  
              smc_n_rd2 <= n_read2;
  
  
        end
  
        else if ((r_smc_currentstate2 == `SMC_LE2) | 
                    (r_smc_currentstate2 == `SMC_STORE2))

        begin
           
           if( (r_oete_store2 < r_ws_store2[1:0]) | 
               (r_ws_store2[7:2] != 6'd0) |
               ( (r_oete_store2 == r_ws_store2[1:0]) & 
                 (r_ws_store2[7:2] == 6'd0)
               ) |
               (r_ws_store2 == 8'd0) 
             )
             
             smc_n_rd2 <= n_r_read2;
           
           else
             
             smc_n_rd2 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store2) < r_ws_count2[1:0]) | 
               (r_ws_count2[7:2] != 6'd0) |
               (r_ws_count2 == 8'd0) 
             )
             
              smc_n_rd2 <= n_r_read2;
           
           else

              smc_n_rd2 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd2 <= 1'b1;
     
  end
   
   
 
endmodule


