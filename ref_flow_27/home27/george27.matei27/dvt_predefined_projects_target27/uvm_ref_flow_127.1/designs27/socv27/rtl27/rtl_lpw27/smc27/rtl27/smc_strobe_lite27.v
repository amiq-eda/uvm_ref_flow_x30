//File27 name   : smc_strobe_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`include "smc_defs_lite27.v"

module smc_strobe_lite27  (

                    //inputs27

                    sys_clk27,
                    n_sys_reset27,
                    valid_access27,
                    n_read27,
                    cs,
                    r_smc_currentstate27,
                    smc_nextstate27,
                    n_be27,
                    r_wele_count27,
                    r_wele_store27,
                    r_wete_store27,
                    r_oete_store27,
                    r_ws_count27,
                    r_ws_store27,
                    smc_done27,
                    mac_done27,

                    //outputs27

                    smc_n_rd27,
                    smc_n_ext_oe27,
                    smc_busy27,
                    n_r_read27,
                    r_cs27,
                    r_full27,
                    n_r_we27,
                    n_r_wr27);



//Parameters27  -  Values27 in smc_defs27.v

 


// I27/O27

   input                   sys_clk27;      //System27 clock27
   input                   n_sys_reset27;  //System27 reset (Active27 LOW27)
   input                   valid_access27; //load27 values are valid if high27
   input                   n_read27;       //Active27 low27 read signal27
   input              cs;           //registered chip27 select27
   input [4:0]             r_smc_currentstate27;//current state
   input [4:0]             smc_nextstate27;//next state  
   input [3:0]             n_be27;         //Unregistered27 Byte27 strobes27
   input [1:0]             r_wele_count27; //Write counter
   input [1:0]             r_wete_store27; //write strobe27 trailing27 edge store27
   input [1:0]             r_oete_store27; //read strobe27
   input [1:0]             r_wele_store27; //write strobe27 leading27 edge store27
   input [7:0]             r_ws_count27;   //wait state count
   input [7:0]             r_ws_store27;   //wait state store27
   input                   smc_done27;  //one access completed
   input                   mac_done27;  //All cycles27 in a multiple access
   
   
   output                  smc_n_rd27;     // EMI27 read stobe27 (Active27 LOW27)
   output                  smc_n_ext_oe27; // Enable27 External27 bus drivers27.
                                                          //  (CS27 & ~RD27)
   output                  smc_busy27;  // smc27 busy
   output                  n_r_read27;  // Store27 RW strobe27 for multiple
                                                         //  accesses
   output                  r_full27;    // Full cycle write strobe27
   output [3:0]            n_r_we27;    // write enable strobe27(active low27)
   output                  n_r_wr27;    // write strobe27(active low27)
   output             r_cs27;      // registered chip27 select27.   


// Output27 register declarations27

   reg                     smc_n_rd27;
   reg                     smc_n_ext_oe27;
   reg                r_cs27;
   reg                     smc_busy27;
   reg                     n_r_read27;
   reg                     r_full27;
   reg   [3:0]             n_r_we27;
   reg                     n_r_wr27;

   //wire declarations27
   
   wire             smc_mac_done27;       //smc_done27 and  mac_done27 anded27
   wire [2:0]       wait_vaccess_smdone27;//concatenated27 signals27 for case
   reg              half_cycle27;         //used for generating27 half27 cycle
                                                //strobes27
   


//----------------------------------------------------------------------
// Strobe27 Generation27
//
// Individual Write Strobes27
// Write Strobe27 = Byte27 Enable27 & Write Enable27
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal27 concatenation27 for use in case statement27
//----------------------------------------------------------------------

   assign smc_mac_done27 = {smc_done27 & mac_done27};

   assign wait_vaccess_smdone27 = {1'b0,valid_access27,smc_mac_done27};
   
   
//----------------------------------------------------------------------
// Store27 read/write signal27 for duration27 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk27 or negedge n_sys_reset27)
  
     begin
  
        if (~n_sys_reset27)
  
           n_r_read27 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone27)
               
               3'b1xx:
                 
                  n_r_read27 <= n_r_read27;
               
               3'b01x:
                 
                  n_r_read27 <= n_read27;
               
               3'b001:
                 
                  n_r_read27 <= 0;
               
               default:
                 
                  n_r_read27 <= n_r_read27;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store27 chip27 selects27 for duration27 of cycle(s)--turnaround27 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store27 read/write signal27 for duration27 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk27 or negedge n_sys_reset27)
     
      begin
           
         if (~n_sys_reset27)
           
           r_cs27 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone27)
                
                 3'b1xx:
                  
                    r_cs27 <= r_cs27 ;
                
                 3'b01x:
                  
                    r_cs27 <= cs ;
                
                 3'b001:
                  
                    r_cs27 <= 1'b0;
                
                 default:
                  
                    r_cs27 <= r_cs27 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive27 busy output whenever27 smc27 active
//----------------------------------------------------------------------

   always @(posedge sys_clk27 or negedge n_sys_reset27)
     
      begin
          
         if (~n_sys_reset27)
           
            smc_busy27 <= 0;
           
           
         else if (smc_nextstate27 != `SMC_IDLE27)
           
            smc_busy27 <= 1;
           
         else
           
            smc_busy27 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive27 OE27 signal27 to I27/O27 pins27 on ASIC27
//
// Generate27 internal, registered Write strobes27
// The write strobes27 are gated27 with the clock27 later27 to generate half27 
// cycle strobes27
//----------------------------------------------------------------------

  always @(posedge sys_clk27 or negedge n_sys_reset27)
    
     begin
       
        if (~n_sys_reset27)
         
           begin
            
              n_r_we27 <= 4'hF;
              n_r_wr27 <= 1'h1;
            
           end
       

        else if ((n_read27 & valid_access27 & 
                  (smc_nextstate27 != `SMC_STORE27)) |
                 (n_r_read27 & ~valid_access27 & 
                  (smc_nextstate27 != `SMC_STORE27)))      
         
           begin
            
              n_r_we27 <= n_be27;
              n_r_wr27 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we27 <= 4'hF;
              n_r_wr27 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive27 OE27 signal27 to I27/O27 pins27 on ASIC27 -----added by gulbir27
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk27 or negedge n_sys_reset27)
     
     begin
        
        if (~n_sys_reset27)
          
          smc_n_ext_oe27 <= 1;
        
        
        else if ((n_read27 & valid_access27 & 
                  (smc_nextstate27 != `SMC_STORE27)) |
                (n_r_read27 & ~valid_access27 & 
              (smc_nextstate27 != `SMC_STORE27) & 
                 (smc_nextstate27 != `SMC_IDLE27)))      

           smc_n_ext_oe27 <= 0;
        
        else
          
           smc_n_ext_oe27 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate27 half27 and full signals27 for write strobes27
// A full cycle is required27 if wait states27 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate27 half27 cycle signals27 for write strobes27
//----------------------------------------------------------------------

always @(r_smc_currentstate27 or smc_nextstate27 or
            r_full27 or 
            r_wete_store27 or r_ws_store27 or r_wele_store27 or 
            r_ws_count27 or r_wele_count27 or 
            valid_access27 or smc_done27)
  
  begin     
     
       begin
          
          case (r_smc_currentstate27)
            
            `SMC_IDLE27:
              
              begin
                 
                     half_cycle27 = 1'b0;
                 
              end
            
            `SMC_LE27:
              
              begin
                 
                 if (smc_nextstate27 == `SMC_RW27)
                   
                   if( ( ( (r_wete_store27) == r_ws_count27[1:0]) &
                         (r_ws_count27[7:2] == 6'd0) &
                         (r_wele_count27 < 2'd2)
                       ) |
                       (r_ws_count27 == 8'd0)
                     )
                     
                     half_cycle27 = 1'b1 & ~r_full27;
                 
                   else
                     
                     half_cycle27 = 1'b0;
                 
                 else
                   
                   half_cycle27 = 1'b0;
                 
              end
            
            `SMC_RW27, `SMC_FLOAT27:
              
              begin
                 
                 if (smc_nextstate27 == `SMC_RW27)
                   
                   if (valid_access27)

                       
                       half_cycle27 = 1'b0;
                 
                   else if (smc_done27)
                     
                     if( ( (r_wete_store27 == r_ws_store27[1:0]) & 
                           (r_ws_store27[7:2] == 6'd0) & 
                           (r_wele_store27 == 2'd0)
                         ) | 
                         (r_ws_store27 == 8'd0)
                       )
                       
                       half_cycle27 = 1'b1 & ~r_full27;
                 
                     else
                       
                       half_cycle27 = 1'b0;
                 
                   else
                     
                     if (r_wete_store27 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count27[1:0]) & 
                            (r_ws_count27[7:2] == 6'd1) &
                            (r_wele_count27 < 2'd2)
                          )
                         
                         half_cycle27 = 1'b1 & ~r_full27;
                 
                       else
                         
                         half_cycle27 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store27+2'd1) == r_ws_count27[1:0]) & 
                              (r_ws_count27[7:2] == 6'd0) & 
                              (r_wele_count27 < 2'd2)
                            )
                          )
                         
                         half_cycle27 = 1'b1 & ~r_full27;
                 
                       else
                         
                         half_cycle27 = 1'b0;
                 
                 else
                   
                   half_cycle27 = 1'b0;
                 
              end
            
            `SMC_STORE27:
              
              begin
                 
                 if (smc_nextstate27 == `SMC_RW27)

                   if( ( ( (r_wete_store27) == r_ws_count27[1:0]) & 
                         (r_ws_count27[7:2] == 6'd0) & 
                         (r_wele_count27 < 2'd2)
                       ) | 
                       (r_ws_count27 == 8'd0)
                     )
                     
                     half_cycle27 = 1'b1 & ~r_full27;
                 
                   else
                     
                     half_cycle27 = 1'b0;
                 
                 else
                   
                   half_cycle27 = 1'b0;
                 
              end
            
            default:
              
              half_cycle27 = 1'b0;
            
          endcase // r_smc_currentstate27
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal27 generation27
//----------------------------------------------------------------------

 always @(posedge sys_clk27 or negedge n_sys_reset27)
             
   begin
      
      if (~n_sys_reset27)
        
        begin
           
           r_full27 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate27)
             
             `SMC_IDLE27:
               
               begin
                  
                  if (smc_nextstate27 == `SMC_RW27)
                    
                         
                         r_full27 <= 1'b0;
                       
                  else
                        
                       r_full27 <= 1'b0;
                       
               end
             
          `SMC_LE27:
            
          begin
             
             if (smc_nextstate27 == `SMC_RW27)
               
                  if( ( ( (r_wete_store27) < r_ws_count27[1:0]) | 
                        (r_ws_count27[7:2] != 6'd0)
                      ) & 
                      (r_wele_count27 < 2'd2)
                    )
                    
                    r_full27 <= 1'b1;
                  
                  else
                    
                    r_full27 <= 1'b0;
                  
             else
               
                  r_full27 <= 1'b0;
                  
          end
          
          `SMC_RW27, `SMC_FLOAT27:
            
            begin
               
               if (smc_nextstate27 == `SMC_RW27)
                 
                 begin
                    
                    if (valid_access27)
                      
                           
                           r_full27 <= 1'b0;
                         
                    else if (smc_done27)
                      
                         if( ( ( (r_wete_store27 < r_ws_store27[1:0]) | 
                                 (r_ws_store27[7:2] != 6'd0)
                               ) & 
                               (r_wele_store27 == 2'd0)
                             )
                           )
                           
                           r_full27 <= 1'b1;
                         
                         else
                           
                           r_full27 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store27 == 2'd3)
                           
                           if( ( (r_ws_count27[7:0] > 8'd4)
                               ) & 
                               (r_wele_count27 < 2'd2)
                             )
                             
                             r_full27 <= 1'b1;
                         
                           else
                             
                             r_full27 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store27 + 2'd1) < 
                                         r_ws_count27[1:0]
                                       )
                                     ) |
                                     (r_ws_count27[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count27 < 2'd2)
                                 )
                           
                           r_full27 <= 1'b1;
                         
                         else
                           
                           r_full27 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full27 <= 1'b0;
               
            end
             
             `SMC_STORE27:
               
               begin
                  
                  if (smc_nextstate27 == `SMC_RW27)

                     if ( ( ( (r_wete_store27) < r_ws_count27[1:0]) | 
                            (r_ws_count27[7:2] != 6'd0)
                          ) & 
                          (r_wele_count27 == 2'd0)
                        )
                         
                         r_full27 <= 1'b1;
                       
                       else
                         
                         r_full27 <= 1'b0;
                       
                  else
                    
                       r_full27 <= 1'b0;
                       
               end
             
             default:
               
                  r_full27 <= 1'b0;
                  
           endcase // r_smc_currentstate27
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate27 Read Strobe27
//----------------------------------------------------------------------
 
  always @(posedge sys_clk27 or negedge n_sys_reset27)
  
  begin
     
     if (~n_sys_reset27)
  
        smc_n_rd27 <= 1'h1;
      
      
     else if (smc_nextstate27 == `SMC_RW27)
  
     begin
  
        if (valid_access27)
  
        begin
  
  
              smc_n_rd27 <= n_read27;
  
  
        end
  
        else if ((r_smc_currentstate27 == `SMC_LE27) | 
                    (r_smc_currentstate27 == `SMC_STORE27))

        begin
           
           if( (r_oete_store27 < r_ws_store27[1:0]) | 
               (r_ws_store27[7:2] != 6'd0) |
               ( (r_oete_store27 == r_ws_store27[1:0]) & 
                 (r_ws_store27[7:2] == 6'd0)
               ) |
               (r_ws_store27 == 8'd0) 
             )
             
             smc_n_rd27 <= n_r_read27;
           
           else
             
             smc_n_rd27 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store27) < r_ws_count27[1:0]) | 
               (r_ws_count27[7:2] != 6'd0) |
               (r_ws_count27 == 8'd0) 
             )
             
              smc_n_rd27 <= n_r_read27;
           
           else

              smc_n_rd27 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd27 <= 1'b1;
     
  end
   
   
 
endmodule


