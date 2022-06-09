//File19 name   : smc_strobe_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
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

module smc_strobe_lite19  (

                    //inputs19

                    sys_clk19,
                    n_sys_reset19,
                    valid_access19,
                    n_read19,
                    cs,
                    r_smc_currentstate19,
                    smc_nextstate19,
                    n_be19,
                    r_wele_count19,
                    r_wele_store19,
                    r_wete_store19,
                    r_oete_store19,
                    r_ws_count19,
                    r_ws_store19,
                    smc_done19,
                    mac_done19,

                    //outputs19

                    smc_n_rd19,
                    smc_n_ext_oe19,
                    smc_busy19,
                    n_r_read19,
                    r_cs19,
                    r_full19,
                    n_r_we19,
                    n_r_wr19);



//Parameters19  -  Values19 in smc_defs19.v

 


// I19/O19

   input                   sys_clk19;      //System19 clock19
   input                   n_sys_reset19;  //System19 reset (Active19 LOW19)
   input                   valid_access19; //load19 values are valid if high19
   input                   n_read19;       //Active19 low19 read signal19
   input              cs;           //registered chip19 select19
   input [4:0]             r_smc_currentstate19;//current state
   input [4:0]             smc_nextstate19;//next state  
   input [3:0]             n_be19;         //Unregistered19 Byte19 strobes19
   input [1:0]             r_wele_count19; //Write counter
   input [1:0]             r_wete_store19; //write strobe19 trailing19 edge store19
   input [1:0]             r_oete_store19; //read strobe19
   input [1:0]             r_wele_store19; //write strobe19 leading19 edge store19
   input [7:0]             r_ws_count19;   //wait state count
   input [7:0]             r_ws_store19;   //wait state store19
   input                   smc_done19;  //one access completed
   input                   mac_done19;  //All cycles19 in a multiple access
   
   
   output                  smc_n_rd19;     // EMI19 read stobe19 (Active19 LOW19)
   output                  smc_n_ext_oe19; // Enable19 External19 bus drivers19.
                                                          //  (CS19 & ~RD19)
   output                  smc_busy19;  // smc19 busy
   output                  n_r_read19;  // Store19 RW strobe19 for multiple
                                                         //  accesses
   output                  r_full19;    // Full cycle write strobe19
   output [3:0]            n_r_we19;    // write enable strobe19(active low19)
   output                  n_r_wr19;    // write strobe19(active low19)
   output             r_cs19;      // registered chip19 select19.   


// Output19 register declarations19

   reg                     smc_n_rd19;
   reg                     smc_n_ext_oe19;
   reg                r_cs19;
   reg                     smc_busy19;
   reg                     n_r_read19;
   reg                     r_full19;
   reg   [3:0]             n_r_we19;
   reg                     n_r_wr19;

   //wire declarations19
   
   wire             smc_mac_done19;       //smc_done19 and  mac_done19 anded19
   wire [2:0]       wait_vaccess_smdone19;//concatenated19 signals19 for case
   reg              half_cycle19;         //used for generating19 half19 cycle
                                                //strobes19
   


//----------------------------------------------------------------------
// Strobe19 Generation19
//
// Individual Write Strobes19
// Write Strobe19 = Byte19 Enable19 & Write Enable19
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal19 concatenation19 for use in case statement19
//----------------------------------------------------------------------

   assign smc_mac_done19 = {smc_done19 & mac_done19};

   assign wait_vaccess_smdone19 = {1'b0,valid_access19,smc_mac_done19};
   
   
//----------------------------------------------------------------------
// Store19 read/write signal19 for duration19 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk19 or negedge n_sys_reset19)
  
     begin
  
        if (~n_sys_reset19)
  
           n_r_read19 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone19)
               
               3'b1xx:
                 
                  n_r_read19 <= n_r_read19;
               
               3'b01x:
                 
                  n_r_read19 <= n_read19;
               
               3'b001:
                 
                  n_r_read19 <= 0;
               
               default:
                 
                  n_r_read19 <= n_r_read19;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store19 chip19 selects19 for duration19 of cycle(s)--turnaround19 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store19 read/write signal19 for duration19 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk19 or negedge n_sys_reset19)
     
      begin
           
         if (~n_sys_reset19)
           
           r_cs19 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone19)
                
                 3'b1xx:
                  
                    r_cs19 <= r_cs19 ;
                
                 3'b01x:
                  
                    r_cs19 <= cs ;
                
                 3'b001:
                  
                    r_cs19 <= 1'b0;
                
                 default:
                  
                    r_cs19 <= r_cs19 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive19 busy output whenever19 smc19 active
//----------------------------------------------------------------------

   always @(posedge sys_clk19 or negedge n_sys_reset19)
     
      begin
          
         if (~n_sys_reset19)
           
            smc_busy19 <= 0;
           
           
         else if (smc_nextstate19 != `SMC_IDLE19)
           
            smc_busy19 <= 1;
           
         else
           
            smc_busy19 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive19 OE19 signal19 to I19/O19 pins19 on ASIC19
//
// Generate19 internal, registered Write strobes19
// The write strobes19 are gated19 with the clock19 later19 to generate half19 
// cycle strobes19
//----------------------------------------------------------------------

  always @(posedge sys_clk19 or negedge n_sys_reset19)
    
     begin
       
        if (~n_sys_reset19)
         
           begin
            
              n_r_we19 <= 4'hF;
              n_r_wr19 <= 1'h1;
            
           end
       

        else if ((n_read19 & valid_access19 & 
                  (smc_nextstate19 != `SMC_STORE19)) |
                 (n_r_read19 & ~valid_access19 & 
                  (smc_nextstate19 != `SMC_STORE19)))      
         
           begin
            
              n_r_we19 <= n_be19;
              n_r_wr19 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we19 <= 4'hF;
              n_r_wr19 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive19 OE19 signal19 to I19/O19 pins19 on ASIC19 -----added by gulbir19
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk19 or negedge n_sys_reset19)
     
     begin
        
        if (~n_sys_reset19)
          
          smc_n_ext_oe19 <= 1;
        
        
        else if ((n_read19 & valid_access19 & 
                  (smc_nextstate19 != `SMC_STORE19)) |
                (n_r_read19 & ~valid_access19 & 
              (smc_nextstate19 != `SMC_STORE19) & 
                 (smc_nextstate19 != `SMC_IDLE19)))      

           smc_n_ext_oe19 <= 0;
        
        else
          
           smc_n_ext_oe19 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate19 half19 and full signals19 for write strobes19
// A full cycle is required19 if wait states19 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate19 half19 cycle signals19 for write strobes19
//----------------------------------------------------------------------

always @(r_smc_currentstate19 or smc_nextstate19 or
            r_full19 or 
            r_wete_store19 or r_ws_store19 or r_wele_store19 or 
            r_ws_count19 or r_wele_count19 or 
            valid_access19 or smc_done19)
  
  begin     
     
       begin
          
          case (r_smc_currentstate19)
            
            `SMC_IDLE19:
              
              begin
                 
                     half_cycle19 = 1'b0;
                 
              end
            
            `SMC_LE19:
              
              begin
                 
                 if (smc_nextstate19 == `SMC_RW19)
                   
                   if( ( ( (r_wete_store19) == r_ws_count19[1:0]) &
                         (r_ws_count19[7:2] == 6'd0) &
                         (r_wele_count19 < 2'd2)
                       ) |
                       (r_ws_count19 == 8'd0)
                     )
                     
                     half_cycle19 = 1'b1 & ~r_full19;
                 
                   else
                     
                     half_cycle19 = 1'b0;
                 
                 else
                   
                   half_cycle19 = 1'b0;
                 
              end
            
            `SMC_RW19, `SMC_FLOAT19:
              
              begin
                 
                 if (smc_nextstate19 == `SMC_RW19)
                   
                   if (valid_access19)

                       
                       half_cycle19 = 1'b0;
                 
                   else if (smc_done19)
                     
                     if( ( (r_wete_store19 == r_ws_store19[1:0]) & 
                           (r_ws_store19[7:2] == 6'd0) & 
                           (r_wele_store19 == 2'd0)
                         ) | 
                         (r_ws_store19 == 8'd0)
                       )
                       
                       half_cycle19 = 1'b1 & ~r_full19;
                 
                     else
                       
                       half_cycle19 = 1'b0;
                 
                   else
                     
                     if (r_wete_store19 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count19[1:0]) & 
                            (r_ws_count19[7:2] == 6'd1) &
                            (r_wele_count19 < 2'd2)
                          )
                         
                         half_cycle19 = 1'b1 & ~r_full19;
                 
                       else
                         
                         half_cycle19 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store19+2'd1) == r_ws_count19[1:0]) & 
                              (r_ws_count19[7:2] == 6'd0) & 
                              (r_wele_count19 < 2'd2)
                            )
                          )
                         
                         half_cycle19 = 1'b1 & ~r_full19;
                 
                       else
                         
                         half_cycle19 = 1'b0;
                 
                 else
                   
                   half_cycle19 = 1'b0;
                 
              end
            
            `SMC_STORE19:
              
              begin
                 
                 if (smc_nextstate19 == `SMC_RW19)

                   if( ( ( (r_wete_store19) == r_ws_count19[1:0]) & 
                         (r_ws_count19[7:2] == 6'd0) & 
                         (r_wele_count19 < 2'd2)
                       ) | 
                       (r_ws_count19 == 8'd0)
                     )
                     
                     half_cycle19 = 1'b1 & ~r_full19;
                 
                   else
                     
                     half_cycle19 = 1'b0;
                 
                 else
                   
                   half_cycle19 = 1'b0;
                 
              end
            
            default:
              
              half_cycle19 = 1'b0;
            
          endcase // r_smc_currentstate19
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal19 generation19
//----------------------------------------------------------------------

 always @(posedge sys_clk19 or negedge n_sys_reset19)
             
   begin
      
      if (~n_sys_reset19)
        
        begin
           
           r_full19 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate19)
             
             `SMC_IDLE19:
               
               begin
                  
                  if (smc_nextstate19 == `SMC_RW19)
                    
                         
                         r_full19 <= 1'b0;
                       
                  else
                        
                       r_full19 <= 1'b0;
                       
               end
             
          `SMC_LE19:
            
          begin
             
             if (smc_nextstate19 == `SMC_RW19)
               
                  if( ( ( (r_wete_store19) < r_ws_count19[1:0]) | 
                        (r_ws_count19[7:2] != 6'd0)
                      ) & 
                      (r_wele_count19 < 2'd2)
                    )
                    
                    r_full19 <= 1'b1;
                  
                  else
                    
                    r_full19 <= 1'b0;
                  
             else
               
                  r_full19 <= 1'b0;
                  
          end
          
          `SMC_RW19, `SMC_FLOAT19:
            
            begin
               
               if (smc_nextstate19 == `SMC_RW19)
                 
                 begin
                    
                    if (valid_access19)
                      
                           
                           r_full19 <= 1'b0;
                         
                    else if (smc_done19)
                      
                         if( ( ( (r_wete_store19 < r_ws_store19[1:0]) | 
                                 (r_ws_store19[7:2] != 6'd0)
                               ) & 
                               (r_wele_store19 == 2'd0)
                             )
                           )
                           
                           r_full19 <= 1'b1;
                         
                         else
                           
                           r_full19 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store19 == 2'd3)
                           
                           if( ( (r_ws_count19[7:0] > 8'd4)
                               ) & 
                               (r_wele_count19 < 2'd2)
                             )
                             
                             r_full19 <= 1'b1;
                         
                           else
                             
                             r_full19 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store19 + 2'd1) < 
                                         r_ws_count19[1:0]
                                       )
                                     ) |
                                     (r_ws_count19[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count19 < 2'd2)
                                 )
                           
                           r_full19 <= 1'b1;
                         
                         else
                           
                           r_full19 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full19 <= 1'b0;
               
            end
             
             `SMC_STORE19:
               
               begin
                  
                  if (smc_nextstate19 == `SMC_RW19)

                     if ( ( ( (r_wete_store19) < r_ws_count19[1:0]) | 
                            (r_ws_count19[7:2] != 6'd0)
                          ) & 
                          (r_wele_count19 == 2'd0)
                        )
                         
                         r_full19 <= 1'b1;
                       
                       else
                         
                         r_full19 <= 1'b0;
                       
                  else
                    
                       r_full19 <= 1'b0;
                       
               end
             
             default:
               
                  r_full19 <= 1'b0;
                  
           endcase // r_smc_currentstate19
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate19 Read Strobe19
//----------------------------------------------------------------------
 
  always @(posedge sys_clk19 or negedge n_sys_reset19)
  
  begin
     
     if (~n_sys_reset19)
  
        smc_n_rd19 <= 1'h1;
      
      
     else if (smc_nextstate19 == `SMC_RW19)
  
     begin
  
        if (valid_access19)
  
        begin
  
  
              smc_n_rd19 <= n_read19;
  
  
        end
  
        else if ((r_smc_currentstate19 == `SMC_LE19) | 
                    (r_smc_currentstate19 == `SMC_STORE19))

        begin
           
           if( (r_oete_store19 < r_ws_store19[1:0]) | 
               (r_ws_store19[7:2] != 6'd0) |
               ( (r_oete_store19 == r_ws_store19[1:0]) & 
                 (r_ws_store19[7:2] == 6'd0)
               ) |
               (r_ws_store19 == 8'd0) 
             )
             
             smc_n_rd19 <= n_r_read19;
           
           else
             
             smc_n_rd19 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store19) < r_ws_count19[1:0]) | 
               (r_ws_count19[7:2] != 6'd0) |
               (r_ws_count19 == 8'd0) 
             )
             
              smc_n_rd19 <= n_r_read19;
           
           else

              smc_n_rd19 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd19 <= 1'b1;
     
  end
   
   
 
endmodule


