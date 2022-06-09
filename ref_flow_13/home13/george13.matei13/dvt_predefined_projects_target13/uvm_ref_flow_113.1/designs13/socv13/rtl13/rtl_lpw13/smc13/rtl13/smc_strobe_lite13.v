//File13 name   : smc_strobe_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`include "smc_defs_lite13.v"

module smc_strobe_lite13  (

                    //inputs13

                    sys_clk13,
                    n_sys_reset13,
                    valid_access13,
                    n_read13,
                    cs,
                    r_smc_currentstate13,
                    smc_nextstate13,
                    n_be13,
                    r_wele_count13,
                    r_wele_store13,
                    r_wete_store13,
                    r_oete_store13,
                    r_ws_count13,
                    r_ws_store13,
                    smc_done13,
                    mac_done13,

                    //outputs13

                    smc_n_rd13,
                    smc_n_ext_oe13,
                    smc_busy13,
                    n_r_read13,
                    r_cs13,
                    r_full13,
                    n_r_we13,
                    n_r_wr13);



//Parameters13  -  Values13 in smc_defs13.v

 


// I13/O13

   input                   sys_clk13;      //System13 clock13
   input                   n_sys_reset13;  //System13 reset (Active13 LOW13)
   input                   valid_access13; //load13 values are valid if high13
   input                   n_read13;       //Active13 low13 read signal13
   input              cs;           //registered chip13 select13
   input [4:0]             r_smc_currentstate13;//current state
   input [4:0]             smc_nextstate13;//next state  
   input [3:0]             n_be13;         //Unregistered13 Byte13 strobes13
   input [1:0]             r_wele_count13; //Write counter
   input [1:0]             r_wete_store13; //write strobe13 trailing13 edge store13
   input [1:0]             r_oete_store13; //read strobe13
   input [1:0]             r_wele_store13; //write strobe13 leading13 edge store13
   input [7:0]             r_ws_count13;   //wait state count
   input [7:0]             r_ws_store13;   //wait state store13
   input                   smc_done13;  //one access completed
   input                   mac_done13;  //All cycles13 in a multiple access
   
   
   output                  smc_n_rd13;     // EMI13 read stobe13 (Active13 LOW13)
   output                  smc_n_ext_oe13; // Enable13 External13 bus drivers13.
                                                          //  (CS13 & ~RD13)
   output                  smc_busy13;  // smc13 busy
   output                  n_r_read13;  // Store13 RW strobe13 for multiple
                                                         //  accesses
   output                  r_full13;    // Full cycle write strobe13
   output [3:0]            n_r_we13;    // write enable strobe13(active low13)
   output                  n_r_wr13;    // write strobe13(active low13)
   output             r_cs13;      // registered chip13 select13.   


// Output13 register declarations13

   reg                     smc_n_rd13;
   reg                     smc_n_ext_oe13;
   reg                r_cs13;
   reg                     smc_busy13;
   reg                     n_r_read13;
   reg                     r_full13;
   reg   [3:0]             n_r_we13;
   reg                     n_r_wr13;

   //wire declarations13
   
   wire             smc_mac_done13;       //smc_done13 and  mac_done13 anded13
   wire [2:0]       wait_vaccess_smdone13;//concatenated13 signals13 for case
   reg              half_cycle13;         //used for generating13 half13 cycle
                                                //strobes13
   


//----------------------------------------------------------------------
// Strobe13 Generation13
//
// Individual Write Strobes13
// Write Strobe13 = Byte13 Enable13 & Write Enable13
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal13 concatenation13 for use in case statement13
//----------------------------------------------------------------------

   assign smc_mac_done13 = {smc_done13 & mac_done13};

   assign wait_vaccess_smdone13 = {1'b0,valid_access13,smc_mac_done13};
   
   
//----------------------------------------------------------------------
// Store13 read/write signal13 for duration13 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk13 or negedge n_sys_reset13)
  
     begin
  
        if (~n_sys_reset13)
  
           n_r_read13 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone13)
               
               3'b1xx:
                 
                  n_r_read13 <= n_r_read13;
               
               3'b01x:
                 
                  n_r_read13 <= n_read13;
               
               3'b001:
                 
                  n_r_read13 <= 0;
               
               default:
                 
                  n_r_read13 <= n_r_read13;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store13 chip13 selects13 for duration13 of cycle(s)--turnaround13 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store13 read/write signal13 for duration13 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk13 or negedge n_sys_reset13)
     
      begin
           
         if (~n_sys_reset13)
           
           r_cs13 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone13)
                
                 3'b1xx:
                  
                    r_cs13 <= r_cs13 ;
                
                 3'b01x:
                  
                    r_cs13 <= cs ;
                
                 3'b001:
                  
                    r_cs13 <= 1'b0;
                
                 default:
                  
                    r_cs13 <= r_cs13 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive13 busy output whenever13 smc13 active
//----------------------------------------------------------------------

   always @(posedge sys_clk13 or negedge n_sys_reset13)
     
      begin
          
         if (~n_sys_reset13)
           
            smc_busy13 <= 0;
           
           
         else if (smc_nextstate13 != `SMC_IDLE13)
           
            smc_busy13 <= 1;
           
         else
           
            smc_busy13 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive13 OE13 signal13 to I13/O13 pins13 on ASIC13
//
// Generate13 internal, registered Write strobes13
// The write strobes13 are gated13 with the clock13 later13 to generate half13 
// cycle strobes13
//----------------------------------------------------------------------

  always @(posedge sys_clk13 or negedge n_sys_reset13)
    
     begin
       
        if (~n_sys_reset13)
         
           begin
            
              n_r_we13 <= 4'hF;
              n_r_wr13 <= 1'h1;
            
           end
       

        else if ((n_read13 & valid_access13 & 
                  (smc_nextstate13 != `SMC_STORE13)) |
                 (n_r_read13 & ~valid_access13 & 
                  (smc_nextstate13 != `SMC_STORE13)))      
         
           begin
            
              n_r_we13 <= n_be13;
              n_r_wr13 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we13 <= 4'hF;
              n_r_wr13 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive13 OE13 signal13 to I13/O13 pins13 on ASIC13 -----added by gulbir13
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk13 or negedge n_sys_reset13)
     
     begin
        
        if (~n_sys_reset13)
          
          smc_n_ext_oe13 <= 1;
        
        
        else if ((n_read13 & valid_access13 & 
                  (smc_nextstate13 != `SMC_STORE13)) |
                (n_r_read13 & ~valid_access13 & 
              (smc_nextstate13 != `SMC_STORE13) & 
                 (smc_nextstate13 != `SMC_IDLE13)))      

           smc_n_ext_oe13 <= 0;
        
        else
          
           smc_n_ext_oe13 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate13 half13 and full signals13 for write strobes13
// A full cycle is required13 if wait states13 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate13 half13 cycle signals13 for write strobes13
//----------------------------------------------------------------------

always @(r_smc_currentstate13 or smc_nextstate13 or
            r_full13 or 
            r_wete_store13 or r_ws_store13 or r_wele_store13 or 
            r_ws_count13 or r_wele_count13 or 
            valid_access13 or smc_done13)
  
  begin     
     
       begin
          
          case (r_smc_currentstate13)
            
            `SMC_IDLE13:
              
              begin
                 
                     half_cycle13 = 1'b0;
                 
              end
            
            `SMC_LE13:
              
              begin
                 
                 if (smc_nextstate13 == `SMC_RW13)
                   
                   if( ( ( (r_wete_store13) == r_ws_count13[1:0]) &
                         (r_ws_count13[7:2] == 6'd0) &
                         (r_wele_count13 < 2'd2)
                       ) |
                       (r_ws_count13 == 8'd0)
                     )
                     
                     half_cycle13 = 1'b1 & ~r_full13;
                 
                   else
                     
                     half_cycle13 = 1'b0;
                 
                 else
                   
                   half_cycle13 = 1'b0;
                 
              end
            
            `SMC_RW13, `SMC_FLOAT13:
              
              begin
                 
                 if (smc_nextstate13 == `SMC_RW13)
                   
                   if (valid_access13)

                       
                       half_cycle13 = 1'b0;
                 
                   else if (smc_done13)
                     
                     if( ( (r_wete_store13 == r_ws_store13[1:0]) & 
                           (r_ws_store13[7:2] == 6'd0) & 
                           (r_wele_store13 == 2'd0)
                         ) | 
                         (r_ws_store13 == 8'd0)
                       )
                       
                       half_cycle13 = 1'b1 & ~r_full13;
                 
                     else
                       
                       half_cycle13 = 1'b0;
                 
                   else
                     
                     if (r_wete_store13 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count13[1:0]) & 
                            (r_ws_count13[7:2] == 6'd1) &
                            (r_wele_count13 < 2'd2)
                          )
                         
                         half_cycle13 = 1'b1 & ~r_full13;
                 
                       else
                         
                         half_cycle13 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store13+2'd1) == r_ws_count13[1:0]) & 
                              (r_ws_count13[7:2] == 6'd0) & 
                              (r_wele_count13 < 2'd2)
                            )
                          )
                         
                         half_cycle13 = 1'b1 & ~r_full13;
                 
                       else
                         
                         half_cycle13 = 1'b0;
                 
                 else
                   
                   half_cycle13 = 1'b0;
                 
              end
            
            `SMC_STORE13:
              
              begin
                 
                 if (smc_nextstate13 == `SMC_RW13)

                   if( ( ( (r_wete_store13) == r_ws_count13[1:0]) & 
                         (r_ws_count13[7:2] == 6'd0) & 
                         (r_wele_count13 < 2'd2)
                       ) | 
                       (r_ws_count13 == 8'd0)
                     )
                     
                     half_cycle13 = 1'b1 & ~r_full13;
                 
                   else
                     
                     half_cycle13 = 1'b0;
                 
                 else
                   
                   half_cycle13 = 1'b0;
                 
              end
            
            default:
              
              half_cycle13 = 1'b0;
            
          endcase // r_smc_currentstate13
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal13 generation13
//----------------------------------------------------------------------

 always @(posedge sys_clk13 or negedge n_sys_reset13)
             
   begin
      
      if (~n_sys_reset13)
        
        begin
           
           r_full13 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate13)
             
             `SMC_IDLE13:
               
               begin
                  
                  if (smc_nextstate13 == `SMC_RW13)
                    
                         
                         r_full13 <= 1'b0;
                       
                  else
                        
                       r_full13 <= 1'b0;
                       
               end
             
          `SMC_LE13:
            
          begin
             
             if (smc_nextstate13 == `SMC_RW13)
               
                  if( ( ( (r_wete_store13) < r_ws_count13[1:0]) | 
                        (r_ws_count13[7:2] != 6'd0)
                      ) & 
                      (r_wele_count13 < 2'd2)
                    )
                    
                    r_full13 <= 1'b1;
                  
                  else
                    
                    r_full13 <= 1'b0;
                  
             else
               
                  r_full13 <= 1'b0;
                  
          end
          
          `SMC_RW13, `SMC_FLOAT13:
            
            begin
               
               if (smc_nextstate13 == `SMC_RW13)
                 
                 begin
                    
                    if (valid_access13)
                      
                           
                           r_full13 <= 1'b0;
                         
                    else if (smc_done13)
                      
                         if( ( ( (r_wete_store13 < r_ws_store13[1:0]) | 
                                 (r_ws_store13[7:2] != 6'd0)
                               ) & 
                               (r_wele_store13 == 2'd0)
                             )
                           )
                           
                           r_full13 <= 1'b1;
                         
                         else
                           
                           r_full13 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store13 == 2'd3)
                           
                           if( ( (r_ws_count13[7:0] > 8'd4)
                               ) & 
                               (r_wele_count13 < 2'd2)
                             )
                             
                             r_full13 <= 1'b1;
                         
                           else
                             
                             r_full13 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store13 + 2'd1) < 
                                         r_ws_count13[1:0]
                                       )
                                     ) |
                                     (r_ws_count13[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count13 < 2'd2)
                                 )
                           
                           r_full13 <= 1'b1;
                         
                         else
                           
                           r_full13 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full13 <= 1'b0;
               
            end
             
             `SMC_STORE13:
               
               begin
                  
                  if (smc_nextstate13 == `SMC_RW13)

                     if ( ( ( (r_wete_store13) < r_ws_count13[1:0]) | 
                            (r_ws_count13[7:2] != 6'd0)
                          ) & 
                          (r_wele_count13 == 2'd0)
                        )
                         
                         r_full13 <= 1'b1;
                       
                       else
                         
                         r_full13 <= 1'b0;
                       
                  else
                    
                       r_full13 <= 1'b0;
                       
               end
             
             default:
               
                  r_full13 <= 1'b0;
                  
           endcase // r_smc_currentstate13
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate13 Read Strobe13
//----------------------------------------------------------------------
 
  always @(posedge sys_clk13 or negedge n_sys_reset13)
  
  begin
     
     if (~n_sys_reset13)
  
        smc_n_rd13 <= 1'h1;
      
      
     else if (smc_nextstate13 == `SMC_RW13)
  
     begin
  
        if (valid_access13)
  
        begin
  
  
              smc_n_rd13 <= n_read13;
  
  
        end
  
        else if ((r_smc_currentstate13 == `SMC_LE13) | 
                    (r_smc_currentstate13 == `SMC_STORE13))

        begin
           
           if( (r_oete_store13 < r_ws_store13[1:0]) | 
               (r_ws_store13[7:2] != 6'd0) |
               ( (r_oete_store13 == r_ws_store13[1:0]) & 
                 (r_ws_store13[7:2] == 6'd0)
               ) |
               (r_ws_store13 == 8'd0) 
             )
             
             smc_n_rd13 <= n_r_read13;
           
           else
             
             smc_n_rd13 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store13) < r_ws_count13[1:0]) | 
               (r_ws_count13[7:2] != 6'd0) |
               (r_ws_count13 == 8'd0) 
             )
             
              smc_n_rd13 <= n_r_read13;
           
           else

              smc_n_rd13 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd13 <= 1'b1;
     
  end
   
   
 
endmodule


