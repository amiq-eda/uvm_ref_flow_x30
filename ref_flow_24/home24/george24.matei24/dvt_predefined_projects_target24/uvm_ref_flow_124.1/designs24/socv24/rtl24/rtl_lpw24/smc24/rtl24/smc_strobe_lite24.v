//File24 name   : smc_strobe_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
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

module smc_strobe_lite24  (

                    //inputs24

                    sys_clk24,
                    n_sys_reset24,
                    valid_access24,
                    n_read24,
                    cs,
                    r_smc_currentstate24,
                    smc_nextstate24,
                    n_be24,
                    r_wele_count24,
                    r_wele_store24,
                    r_wete_store24,
                    r_oete_store24,
                    r_ws_count24,
                    r_ws_store24,
                    smc_done24,
                    mac_done24,

                    //outputs24

                    smc_n_rd24,
                    smc_n_ext_oe24,
                    smc_busy24,
                    n_r_read24,
                    r_cs24,
                    r_full24,
                    n_r_we24,
                    n_r_wr24);



//Parameters24  -  Values24 in smc_defs24.v

 


// I24/O24

   input                   sys_clk24;      //System24 clock24
   input                   n_sys_reset24;  //System24 reset (Active24 LOW24)
   input                   valid_access24; //load24 values are valid if high24
   input                   n_read24;       //Active24 low24 read signal24
   input              cs;           //registered chip24 select24
   input [4:0]             r_smc_currentstate24;//current state
   input [4:0]             smc_nextstate24;//next state  
   input [3:0]             n_be24;         //Unregistered24 Byte24 strobes24
   input [1:0]             r_wele_count24; //Write counter
   input [1:0]             r_wete_store24; //write strobe24 trailing24 edge store24
   input [1:0]             r_oete_store24; //read strobe24
   input [1:0]             r_wele_store24; //write strobe24 leading24 edge store24
   input [7:0]             r_ws_count24;   //wait state count
   input [7:0]             r_ws_store24;   //wait state store24
   input                   smc_done24;  //one access completed
   input                   mac_done24;  //All cycles24 in a multiple access
   
   
   output                  smc_n_rd24;     // EMI24 read stobe24 (Active24 LOW24)
   output                  smc_n_ext_oe24; // Enable24 External24 bus drivers24.
                                                          //  (CS24 & ~RD24)
   output                  smc_busy24;  // smc24 busy
   output                  n_r_read24;  // Store24 RW strobe24 for multiple
                                                         //  accesses
   output                  r_full24;    // Full cycle write strobe24
   output [3:0]            n_r_we24;    // write enable strobe24(active low24)
   output                  n_r_wr24;    // write strobe24(active low24)
   output             r_cs24;      // registered chip24 select24.   


// Output24 register declarations24

   reg                     smc_n_rd24;
   reg                     smc_n_ext_oe24;
   reg                r_cs24;
   reg                     smc_busy24;
   reg                     n_r_read24;
   reg                     r_full24;
   reg   [3:0]             n_r_we24;
   reg                     n_r_wr24;

   //wire declarations24
   
   wire             smc_mac_done24;       //smc_done24 and  mac_done24 anded24
   wire [2:0]       wait_vaccess_smdone24;//concatenated24 signals24 for case
   reg              half_cycle24;         //used for generating24 half24 cycle
                                                //strobes24
   


//----------------------------------------------------------------------
// Strobe24 Generation24
//
// Individual Write Strobes24
// Write Strobe24 = Byte24 Enable24 & Write Enable24
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal24 concatenation24 for use in case statement24
//----------------------------------------------------------------------

   assign smc_mac_done24 = {smc_done24 & mac_done24};

   assign wait_vaccess_smdone24 = {1'b0,valid_access24,smc_mac_done24};
   
   
//----------------------------------------------------------------------
// Store24 read/write signal24 for duration24 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk24 or negedge n_sys_reset24)
  
     begin
  
        if (~n_sys_reset24)
  
           n_r_read24 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone24)
               
               3'b1xx:
                 
                  n_r_read24 <= n_r_read24;
               
               3'b01x:
                 
                  n_r_read24 <= n_read24;
               
               3'b001:
                 
                  n_r_read24 <= 0;
               
               default:
                 
                  n_r_read24 <= n_r_read24;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store24 chip24 selects24 for duration24 of cycle(s)--turnaround24 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store24 read/write signal24 for duration24 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk24 or negedge n_sys_reset24)
     
      begin
           
         if (~n_sys_reset24)
           
           r_cs24 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone24)
                
                 3'b1xx:
                  
                    r_cs24 <= r_cs24 ;
                
                 3'b01x:
                  
                    r_cs24 <= cs ;
                
                 3'b001:
                  
                    r_cs24 <= 1'b0;
                
                 default:
                  
                    r_cs24 <= r_cs24 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive24 busy output whenever24 smc24 active
//----------------------------------------------------------------------

   always @(posedge sys_clk24 or negedge n_sys_reset24)
     
      begin
          
         if (~n_sys_reset24)
           
            smc_busy24 <= 0;
           
           
         else if (smc_nextstate24 != `SMC_IDLE24)
           
            smc_busy24 <= 1;
           
         else
           
            smc_busy24 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive24 OE24 signal24 to I24/O24 pins24 on ASIC24
//
// Generate24 internal, registered Write strobes24
// The write strobes24 are gated24 with the clock24 later24 to generate half24 
// cycle strobes24
//----------------------------------------------------------------------

  always @(posedge sys_clk24 or negedge n_sys_reset24)
    
     begin
       
        if (~n_sys_reset24)
         
           begin
            
              n_r_we24 <= 4'hF;
              n_r_wr24 <= 1'h1;
            
           end
       

        else if ((n_read24 & valid_access24 & 
                  (smc_nextstate24 != `SMC_STORE24)) |
                 (n_r_read24 & ~valid_access24 & 
                  (smc_nextstate24 != `SMC_STORE24)))      
         
           begin
            
              n_r_we24 <= n_be24;
              n_r_wr24 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we24 <= 4'hF;
              n_r_wr24 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive24 OE24 signal24 to I24/O24 pins24 on ASIC24 -----added by gulbir24
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk24 or negedge n_sys_reset24)
     
     begin
        
        if (~n_sys_reset24)
          
          smc_n_ext_oe24 <= 1;
        
        
        else if ((n_read24 & valid_access24 & 
                  (smc_nextstate24 != `SMC_STORE24)) |
                (n_r_read24 & ~valid_access24 & 
              (smc_nextstate24 != `SMC_STORE24) & 
                 (smc_nextstate24 != `SMC_IDLE24)))      

           smc_n_ext_oe24 <= 0;
        
        else
          
           smc_n_ext_oe24 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate24 half24 and full signals24 for write strobes24
// A full cycle is required24 if wait states24 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate24 half24 cycle signals24 for write strobes24
//----------------------------------------------------------------------

always @(r_smc_currentstate24 or smc_nextstate24 or
            r_full24 or 
            r_wete_store24 or r_ws_store24 or r_wele_store24 or 
            r_ws_count24 or r_wele_count24 or 
            valid_access24 or smc_done24)
  
  begin     
     
       begin
          
          case (r_smc_currentstate24)
            
            `SMC_IDLE24:
              
              begin
                 
                     half_cycle24 = 1'b0;
                 
              end
            
            `SMC_LE24:
              
              begin
                 
                 if (smc_nextstate24 == `SMC_RW24)
                   
                   if( ( ( (r_wete_store24) == r_ws_count24[1:0]) &
                         (r_ws_count24[7:2] == 6'd0) &
                         (r_wele_count24 < 2'd2)
                       ) |
                       (r_ws_count24 == 8'd0)
                     )
                     
                     half_cycle24 = 1'b1 & ~r_full24;
                 
                   else
                     
                     half_cycle24 = 1'b0;
                 
                 else
                   
                   half_cycle24 = 1'b0;
                 
              end
            
            `SMC_RW24, `SMC_FLOAT24:
              
              begin
                 
                 if (smc_nextstate24 == `SMC_RW24)
                   
                   if (valid_access24)

                       
                       half_cycle24 = 1'b0;
                 
                   else if (smc_done24)
                     
                     if( ( (r_wete_store24 == r_ws_store24[1:0]) & 
                           (r_ws_store24[7:2] == 6'd0) & 
                           (r_wele_store24 == 2'd0)
                         ) | 
                         (r_ws_store24 == 8'd0)
                       )
                       
                       half_cycle24 = 1'b1 & ~r_full24;
                 
                     else
                       
                       half_cycle24 = 1'b0;
                 
                   else
                     
                     if (r_wete_store24 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count24[1:0]) & 
                            (r_ws_count24[7:2] == 6'd1) &
                            (r_wele_count24 < 2'd2)
                          )
                         
                         half_cycle24 = 1'b1 & ~r_full24;
                 
                       else
                         
                         half_cycle24 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store24+2'd1) == r_ws_count24[1:0]) & 
                              (r_ws_count24[7:2] == 6'd0) & 
                              (r_wele_count24 < 2'd2)
                            )
                          )
                         
                         half_cycle24 = 1'b1 & ~r_full24;
                 
                       else
                         
                         half_cycle24 = 1'b0;
                 
                 else
                   
                   half_cycle24 = 1'b0;
                 
              end
            
            `SMC_STORE24:
              
              begin
                 
                 if (smc_nextstate24 == `SMC_RW24)

                   if( ( ( (r_wete_store24) == r_ws_count24[1:0]) & 
                         (r_ws_count24[7:2] == 6'd0) & 
                         (r_wele_count24 < 2'd2)
                       ) | 
                       (r_ws_count24 == 8'd0)
                     )
                     
                     half_cycle24 = 1'b1 & ~r_full24;
                 
                   else
                     
                     half_cycle24 = 1'b0;
                 
                 else
                   
                   half_cycle24 = 1'b0;
                 
              end
            
            default:
              
              half_cycle24 = 1'b0;
            
          endcase // r_smc_currentstate24
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal24 generation24
//----------------------------------------------------------------------

 always @(posedge sys_clk24 or negedge n_sys_reset24)
             
   begin
      
      if (~n_sys_reset24)
        
        begin
           
           r_full24 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate24)
             
             `SMC_IDLE24:
               
               begin
                  
                  if (smc_nextstate24 == `SMC_RW24)
                    
                         
                         r_full24 <= 1'b0;
                       
                  else
                        
                       r_full24 <= 1'b0;
                       
               end
             
          `SMC_LE24:
            
          begin
             
             if (smc_nextstate24 == `SMC_RW24)
               
                  if( ( ( (r_wete_store24) < r_ws_count24[1:0]) | 
                        (r_ws_count24[7:2] != 6'd0)
                      ) & 
                      (r_wele_count24 < 2'd2)
                    )
                    
                    r_full24 <= 1'b1;
                  
                  else
                    
                    r_full24 <= 1'b0;
                  
             else
               
                  r_full24 <= 1'b0;
                  
          end
          
          `SMC_RW24, `SMC_FLOAT24:
            
            begin
               
               if (smc_nextstate24 == `SMC_RW24)
                 
                 begin
                    
                    if (valid_access24)
                      
                           
                           r_full24 <= 1'b0;
                         
                    else if (smc_done24)
                      
                         if( ( ( (r_wete_store24 < r_ws_store24[1:0]) | 
                                 (r_ws_store24[7:2] != 6'd0)
                               ) & 
                               (r_wele_store24 == 2'd0)
                             )
                           )
                           
                           r_full24 <= 1'b1;
                         
                         else
                           
                           r_full24 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store24 == 2'd3)
                           
                           if( ( (r_ws_count24[7:0] > 8'd4)
                               ) & 
                               (r_wele_count24 < 2'd2)
                             )
                             
                             r_full24 <= 1'b1;
                         
                           else
                             
                             r_full24 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store24 + 2'd1) < 
                                         r_ws_count24[1:0]
                                       )
                                     ) |
                                     (r_ws_count24[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count24 < 2'd2)
                                 )
                           
                           r_full24 <= 1'b1;
                         
                         else
                           
                           r_full24 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full24 <= 1'b0;
               
            end
             
             `SMC_STORE24:
               
               begin
                  
                  if (smc_nextstate24 == `SMC_RW24)

                     if ( ( ( (r_wete_store24) < r_ws_count24[1:0]) | 
                            (r_ws_count24[7:2] != 6'd0)
                          ) & 
                          (r_wele_count24 == 2'd0)
                        )
                         
                         r_full24 <= 1'b1;
                       
                       else
                         
                         r_full24 <= 1'b0;
                       
                  else
                    
                       r_full24 <= 1'b0;
                       
               end
             
             default:
               
                  r_full24 <= 1'b0;
                  
           endcase // r_smc_currentstate24
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate24 Read Strobe24
//----------------------------------------------------------------------
 
  always @(posedge sys_clk24 or negedge n_sys_reset24)
  
  begin
     
     if (~n_sys_reset24)
  
        smc_n_rd24 <= 1'h1;
      
      
     else if (smc_nextstate24 == `SMC_RW24)
  
     begin
  
        if (valid_access24)
  
        begin
  
  
              smc_n_rd24 <= n_read24;
  
  
        end
  
        else if ((r_smc_currentstate24 == `SMC_LE24) | 
                    (r_smc_currentstate24 == `SMC_STORE24))

        begin
           
           if( (r_oete_store24 < r_ws_store24[1:0]) | 
               (r_ws_store24[7:2] != 6'd0) |
               ( (r_oete_store24 == r_ws_store24[1:0]) & 
                 (r_ws_store24[7:2] == 6'd0)
               ) |
               (r_ws_store24 == 8'd0) 
             )
             
             smc_n_rd24 <= n_r_read24;
           
           else
             
             smc_n_rd24 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store24) < r_ws_count24[1:0]) | 
               (r_ws_count24[7:2] != 6'd0) |
               (r_ws_count24 == 8'd0) 
             )
             
              smc_n_rd24 <= n_r_read24;
           
           else

              smc_n_rd24 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd24 <= 1'b1;
     
  end
   
   
 
endmodule


