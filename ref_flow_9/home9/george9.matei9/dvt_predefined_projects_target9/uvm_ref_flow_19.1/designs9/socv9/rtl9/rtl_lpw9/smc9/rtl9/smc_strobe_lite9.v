//File9 name   : smc_strobe_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`include "smc_defs_lite9.v"

module smc_strobe_lite9  (

                    //inputs9

                    sys_clk9,
                    n_sys_reset9,
                    valid_access9,
                    n_read9,
                    cs,
                    r_smc_currentstate9,
                    smc_nextstate9,
                    n_be9,
                    r_wele_count9,
                    r_wele_store9,
                    r_wete_store9,
                    r_oete_store9,
                    r_ws_count9,
                    r_ws_store9,
                    smc_done9,
                    mac_done9,

                    //outputs9

                    smc_n_rd9,
                    smc_n_ext_oe9,
                    smc_busy9,
                    n_r_read9,
                    r_cs9,
                    r_full9,
                    n_r_we9,
                    n_r_wr9);



//Parameters9  -  Values9 in smc_defs9.v

 


// I9/O9

   input                   sys_clk9;      //System9 clock9
   input                   n_sys_reset9;  //System9 reset (Active9 LOW9)
   input                   valid_access9; //load9 values are valid if high9
   input                   n_read9;       //Active9 low9 read signal9
   input              cs;           //registered chip9 select9
   input [4:0]             r_smc_currentstate9;//current state
   input [4:0]             smc_nextstate9;//next state  
   input [3:0]             n_be9;         //Unregistered9 Byte9 strobes9
   input [1:0]             r_wele_count9; //Write counter
   input [1:0]             r_wete_store9; //write strobe9 trailing9 edge store9
   input [1:0]             r_oete_store9; //read strobe9
   input [1:0]             r_wele_store9; //write strobe9 leading9 edge store9
   input [7:0]             r_ws_count9;   //wait state count
   input [7:0]             r_ws_store9;   //wait state store9
   input                   smc_done9;  //one access completed
   input                   mac_done9;  //All cycles9 in a multiple access
   
   
   output                  smc_n_rd9;     // EMI9 read stobe9 (Active9 LOW9)
   output                  smc_n_ext_oe9; // Enable9 External9 bus drivers9.
                                                          //  (CS9 & ~RD9)
   output                  smc_busy9;  // smc9 busy
   output                  n_r_read9;  // Store9 RW strobe9 for multiple
                                                         //  accesses
   output                  r_full9;    // Full cycle write strobe9
   output [3:0]            n_r_we9;    // write enable strobe9(active low9)
   output                  n_r_wr9;    // write strobe9(active low9)
   output             r_cs9;      // registered chip9 select9.   


// Output9 register declarations9

   reg                     smc_n_rd9;
   reg                     smc_n_ext_oe9;
   reg                r_cs9;
   reg                     smc_busy9;
   reg                     n_r_read9;
   reg                     r_full9;
   reg   [3:0]             n_r_we9;
   reg                     n_r_wr9;

   //wire declarations9
   
   wire             smc_mac_done9;       //smc_done9 and  mac_done9 anded9
   wire [2:0]       wait_vaccess_smdone9;//concatenated9 signals9 for case
   reg              half_cycle9;         //used for generating9 half9 cycle
                                                //strobes9
   


//----------------------------------------------------------------------
// Strobe9 Generation9
//
// Individual Write Strobes9
// Write Strobe9 = Byte9 Enable9 & Write Enable9
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal9 concatenation9 for use in case statement9
//----------------------------------------------------------------------

   assign smc_mac_done9 = {smc_done9 & mac_done9};

   assign wait_vaccess_smdone9 = {1'b0,valid_access9,smc_mac_done9};
   
   
//----------------------------------------------------------------------
// Store9 read/write signal9 for duration9 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk9 or negedge n_sys_reset9)
  
     begin
  
        if (~n_sys_reset9)
  
           n_r_read9 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone9)
               
               3'b1xx:
                 
                  n_r_read9 <= n_r_read9;
               
               3'b01x:
                 
                  n_r_read9 <= n_read9;
               
               3'b001:
                 
                  n_r_read9 <= 0;
               
               default:
                 
                  n_r_read9 <= n_r_read9;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store9 chip9 selects9 for duration9 of cycle(s)--turnaround9 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store9 read/write signal9 for duration9 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk9 or negedge n_sys_reset9)
     
      begin
           
         if (~n_sys_reset9)
           
           r_cs9 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone9)
                
                 3'b1xx:
                  
                    r_cs9 <= r_cs9 ;
                
                 3'b01x:
                  
                    r_cs9 <= cs ;
                
                 3'b001:
                  
                    r_cs9 <= 1'b0;
                
                 default:
                  
                    r_cs9 <= r_cs9 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive9 busy output whenever9 smc9 active
//----------------------------------------------------------------------

   always @(posedge sys_clk9 or negedge n_sys_reset9)
     
      begin
          
         if (~n_sys_reset9)
           
            smc_busy9 <= 0;
           
           
         else if (smc_nextstate9 != `SMC_IDLE9)
           
            smc_busy9 <= 1;
           
         else
           
            smc_busy9 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive9 OE9 signal9 to I9/O9 pins9 on ASIC9
//
// Generate9 internal, registered Write strobes9
// The write strobes9 are gated9 with the clock9 later9 to generate half9 
// cycle strobes9
//----------------------------------------------------------------------

  always @(posedge sys_clk9 or negedge n_sys_reset9)
    
     begin
       
        if (~n_sys_reset9)
         
           begin
            
              n_r_we9 <= 4'hF;
              n_r_wr9 <= 1'h1;
            
           end
       

        else if ((n_read9 & valid_access9 & 
                  (smc_nextstate9 != `SMC_STORE9)) |
                 (n_r_read9 & ~valid_access9 & 
                  (smc_nextstate9 != `SMC_STORE9)))      
         
           begin
            
              n_r_we9 <= n_be9;
              n_r_wr9 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we9 <= 4'hF;
              n_r_wr9 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive9 OE9 signal9 to I9/O9 pins9 on ASIC9 -----added by gulbir9
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk9 or negedge n_sys_reset9)
     
     begin
        
        if (~n_sys_reset9)
          
          smc_n_ext_oe9 <= 1;
        
        
        else if ((n_read9 & valid_access9 & 
                  (smc_nextstate9 != `SMC_STORE9)) |
                (n_r_read9 & ~valid_access9 & 
              (smc_nextstate9 != `SMC_STORE9) & 
                 (smc_nextstate9 != `SMC_IDLE9)))      

           smc_n_ext_oe9 <= 0;
        
        else
          
           smc_n_ext_oe9 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate9 half9 and full signals9 for write strobes9
// A full cycle is required9 if wait states9 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate9 half9 cycle signals9 for write strobes9
//----------------------------------------------------------------------

always @(r_smc_currentstate9 or smc_nextstate9 or
            r_full9 or 
            r_wete_store9 or r_ws_store9 or r_wele_store9 or 
            r_ws_count9 or r_wele_count9 or 
            valid_access9 or smc_done9)
  
  begin     
     
       begin
          
          case (r_smc_currentstate9)
            
            `SMC_IDLE9:
              
              begin
                 
                     half_cycle9 = 1'b0;
                 
              end
            
            `SMC_LE9:
              
              begin
                 
                 if (smc_nextstate9 == `SMC_RW9)
                   
                   if( ( ( (r_wete_store9) == r_ws_count9[1:0]) &
                         (r_ws_count9[7:2] == 6'd0) &
                         (r_wele_count9 < 2'd2)
                       ) |
                       (r_ws_count9 == 8'd0)
                     )
                     
                     half_cycle9 = 1'b1 & ~r_full9;
                 
                   else
                     
                     half_cycle9 = 1'b0;
                 
                 else
                   
                   half_cycle9 = 1'b0;
                 
              end
            
            `SMC_RW9, `SMC_FLOAT9:
              
              begin
                 
                 if (smc_nextstate9 == `SMC_RW9)
                   
                   if (valid_access9)

                       
                       half_cycle9 = 1'b0;
                 
                   else if (smc_done9)
                     
                     if( ( (r_wete_store9 == r_ws_store9[1:0]) & 
                           (r_ws_store9[7:2] == 6'd0) & 
                           (r_wele_store9 == 2'd0)
                         ) | 
                         (r_ws_store9 == 8'd0)
                       )
                       
                       half_cycle9 = 1'b1 & ~r_full9;
                 
                     else
                       
                       half_cycle9 = 1'b0;
                 
                   else
                     
                     if (r_wete_store9 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count9[1:0]) & 
                            (r_ws_count9[7:2] == 6'd1) &
                            (r_wele_count9 < 2'd2)
                          )
                         
                         half_cycle9 = 1'b1 & ~r_full9;
                 
                       else
                         
                         half_cycle9 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store9+2'd1) == r_ws_count9[1:0]) & 
                              (r_ws_count9[7:2] == 6'd0) & 
                              (r_wele_count9 < 2'd2)
                            )
                          )
                         
                         half_cycle9 = 1'b1 & ~r_full9;
                 
                       else
                         
                         half_cycle9 = 1'b0;
                 
                 else
                   
                   half_cycle9 = 1'b0;
                 
              end
            
            `SMC_STORE9:
              
              begin
                 
                 if (smc_nextstate9 == `SMC_RW9)

                   if( ( ( (r_wete_store9) == r_ws_count9[1:0]) & 
                         (r_ws_count9[7:2] == 6'd0) & 
                         (r_wele_count9 < 2'd2)
                       ) | 
                       (r_ws_count9 == 8'd0)
                     )
                     
                     half_cycle9 = 1'b1 & ~r_full9;
                 
                   else
                     
                     half_cycle9 = 1'b0;
                 
                 else
                   
                   half_cycle9 = 1'b0;
                 
              end
            
            default:
              
              half_cycle9 = 1'b0;
            
          endcase // r_smc_currentstate9
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal9 generation9
//----------------------------------------------------------------------

 always @(posedge sys_clk9 or negedge n_sys_reset9)
             
   begin
      
      if (~n_sys_reset9)
        
        begin
           
           r_full9 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate9)
             
             `SMC_IDLE9:
               
               begin
                  
                  if (smc_nextstate9 == `SMC_RW9)
                    
                         
                         r_full9 <= 1'b0;
                       
                  else
                        
                       r_full9 <= 1'b0;
                       
               end
             
          `SMC_LE9:
            
          begin
             
             if (smc_nextstate9 == `SMC_RW9)
               
                  if( ( ( (r_wete_store9) < r_ws_count9[1:0]) | 
                        (r_ws_count9[7:2] != 6'd0)
                      ) & 
                      (r_wele_count9 < 2'd2)
                    )
                    
                    r_full9 <= 1'b1;
                  
                  else
                    
                    r_full9 <= 1'b0;
                  
             else
               
                  r_full9 <= 1'b0;
                  
          end
          
          `SMC_RW9, `SMC_FLOAT9:
            
            begin
               
               if (smc_nextstate9 == `SMC_RW9)
                 
                 begin
                    
                    if (valid_access9)
                      
                           
                           r_full9 <= 1'b0;
                         
                    else if (smc_done9)
                      
                         if( ( ( (r_wete_store9 < r_ws_store9[1:0]) | 
                                 (r_ws_store9[7:2] != 6'd0)
                               ) & 
                               (r_wele_store9 == 2'd0)
                             )
                           )
                           
                           r_full9 <= 1'b1;
                         
                         else
                           
                           r_full9 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store9 == 2'd3)
                           
                           if( ( (r_ws_count9[7:0] > 8'd4)
                               ) & 
                               (r_wele_count9 < 2'd2)
                             )
                             
                             r_full9 <= 1'b1;
                         
                           else
                             
                             r_full9 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store9 + 2'd1) < 
                                         r_ws_count9[1:0]
                                       )
                                     ) |
                                     (r_ws_count9[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count9 < 2'd2)
                                 )
                           
                           r_full9 <= 1'b1;
                         
                         else
                           
                           r_full9 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full9 <= 1'b0;
               
            end
             
             `SMC_STORE9:
               
               begin
                  
                  if (smc_nextstate9 == `SMC_RW9)

                     if ( ( ( (r_wete_store9) < r_ws_count9[1:0]) | 
                            (r_ws_count9[7:2] != 6'd0)
                          ) & 
                          (r_wele_count9 == 2'd0)
                        )
                         
                         r_full9 <= 1'b1;
                       
                       else
                         
                         r_full9 <= 1'b0;
                       
                  else
                    
                       r_full9 <= 1'b0;
                       
               end
             
             default:
               
                  r_full9 <= 1'b0;
                  
           endcase // r_smc_currentstate9
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate9 Read Strobe9
//----------------------------------------------------------------------
 
  always @(posedge sys_clk9 or negedge n_sys_reset9)
  
  begin
     
     if (~n_sys_reset9)
  
        smc_n_rd9 <= 1'h1;
      
      
     else if (smc_nextstate9 == `SMC_RW9)
  
     begin
  
        if (valid_access9)
  
        begin
  
  
              smc_n_rd9 <= n_read9;
  
  
        end
  
        else if ((r_smc_currentstate9 == `SMC_LE9) | 
                    (r_smc_currentstate9 == `SMC_STORE9))

        begin
           
           if( (r_oete_store9 < r_ws_store9[1:0]) | 
               (r_ws_store9[7:2] != 6'd0) |
               ( (r_oete_store9 == r_ws_store9[1:0]) & 
                 (r_ws_store9[7:2] == 6'd0)
               ) |
               (r_ws_store9 == 8'd0) 
             )
             
             smc_n_rd9 <= n_r_read9;
           
           else
             
             smc_n_rd9 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store9) < r_ws_count9[1:0]) | 
               (r_ws_count9[7:2] != 6'd0) |
               (r_ws_count9 == 8'd0) 
             )
             
              smc_n_rd9 <= n_r_read9;
           
           else

              smc_n_rd9 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd9 <= 1'b1;
     
  end
   
   
 
endmodule


