//File20 name   : smc_strobe_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
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

module smc_strobe_lite20  (

                    //inputs20

                    sys_clk20,
                    n_sys_reset20,
                    valid_access20,
                    n_read20,
                    cs,
                    r_smc_currentstate20,
                    smc_nextstate20,
                    n_be20,
                    r_wele_count20,
                    r_wele_store20,
                    r_wete_store20,
                    r_oete_store20,
                    r_ws_count20,
                    r_ws_store20,
                    smc_done20,
                    mac_done20,

                    //outputs20

                    smc_n_rd20,
                    smc_n_ext_oe20,
                    smc_busy20,
                    n_r_read20,
                    r_cs20,
                    r_full20,
                    n_r_we20,
                    n_r_wr20);



//Parameters20  -  Values20 in smc_defs20.v

 


// I20/O20

   input                   sys_clk20;      //System20 clock20
   input                   n_sys_reset20;  //System20 reset (Active20 LOW20)
   input                   valid_access20; //load20 values are valid if high20
   input                   n_read20;       //Active20 low20 read signal20
   input              cs;           //registered chip20 select20
   input [4:0]             r_smc_currentstate20;//current state
   input [4:0]             smc_nextstate20;//next state  
   input [3:0]             n_be20;         //Unregistered20 Byte20 strobes20
   input [1:0]             r_wele_count20; //Write counter
   input [1:0]             r_wete_store20; //write strobe20 trailing20 edge store20
   input [1:0]             r_oete_store20; //read strobe20
   input [1:0]             r_wele_store20; //write strobe20 leading20 edge store20
   input [7:0]             r_ws_count20;   //wait state count
   input [7:0]             r_ws_store20;   //wait state store20
   input                   smc_done20;  //one access completed
   input                   mac_done20;  //All cycles20 in a multiple access
   
   
   output                  smc_n_rd20;     // EMI20 read stobe20 (Active20 LOW20)
   output                  smc_n_ext_oe20; // Enable20 External20 bus drivers20.
                                                          //  (CS20 & ~RD20)
   output                  smc_busy20;  // smc20 busy
   output                  n_r_read20;  // Store20 RW strobe20 for multiple
                                                         //  accesses
   output                  r_full20;    // Full cycle write strobe20
   output [3:0]            n_r_we20;    // write enable strobe20(active low20)
   output                  n_r_wr20;    // write strobe20(active low20)
   output             r_cs20;      // registered chip20 select20.   


// Output20 register declarations20

   reg                     smc_n_rd20;
   reg                     smc_n_ext_oe20;
   reg                r_cs20;
   reg                     smc_busy20;
   reg                     n_r_read20;
   reg                     r_full20;
   reg   [3:0]             n_r_we20;
   reg                     n_r_wr20;

   //wire declarations20
   
   wire             smc_mac_done20;       //smc_done20 and  mac_done20 anded20
   wire [2:0]       wait_vaccess_smdone20;//concatenated20 signals20 for case
   reg              half_cycle20;         //used for generating20 half20 cycle
                                                //strobes20
   


//----------------------------------------------------------------------
// Strobe20 Generation20
//
// Individual Write Strobes20
// Write Strobe20 = Byte20 Enable20 & Write Enable20
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal20 concatenation20 for use in case statement20
//----------------------------------------------------------------------

   assign smc_mac_done20 = {smc_done20 & mac_done20};

   assign wait_vaccess_smdone20 = {1'b0,valid_access20,smc_mac_done20};
   
   
//----------------------------------------------------------------------
// Store20 read/write signal20 for duration20 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk20 or negedge n_sys_reset20)
  
     begin
  
        if (~n_sys_reset20)
  
           n_r_read20 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone20)
               
               3'b1xx:
                 
                  n_r_read20 <= n_r_read20;
               
               3'b01x:
                 
                  n_r_read20 <= n_read20;
               
               3'b001:
                 
                  n_r_read20 <= 0;
               
               default:
                 
                  n_r_read20 <= n_r_read20;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store20 chip20 selects20 for duration20 of cycle(s)--turnaround20 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store20 read/write signal20 for duration20 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk20 or negedge n_sys_reset20)
     
      begin
           
         if (~n_sys_reset20)
           
           r_cs20 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone20)
                
                 3'b1xx:
                  
                    r_cs20 <= r_cs20 ;
                
                 3'b01x:
                  
                    r_cs20 <= cs ;
                
                 3'b001:
                  
                    r_cs20 <= 1'b0;
                
                 default:
                  
                    r_cs20 <= r_cs20 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive20 busy output whenever20 smc20 active
//----------------------------------------------------------------------

   always @(posedge sys_clk20 or negedge n_sys_reset20)
     
      begin
          
         if (~n_sys_reset20)
           
            smc_busy20 <= 0;
           
           
         else if (smc_nextstate20 != `SMC_IDLE20)
           
            smc_busy20 <= 1;
           
         else
           
            smc_busy20 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive20 OE20 signal20 to I20/O20 pins20 on ASIC20
//
// Generate20 internal, registered Write strobes20
// The write strobes20 are gated20 with the clock20 later20 to generate half20 
// cycle strobes20
//----------------------------------------------------------------------

  always @(posedge sys_clk20 or negedge n_sys_reset20)
    
     begin
       
        if (~n_sys_reset20)
         
           begin
            
              n_r_we20 <= 4'hF;
              n_r_wr20 <= 1'h1;
            
           end
       

        else if ((n_read20 & valid_access20 & 
                  (smc_nextstate20 != `SMC_STORE20)) |
                 (n_r_read20 & ~valid_access20 & 
                  (smc_nextstate20 != `SMC_STORE20)))      
         
           begin
            
              n_r_we20 <= n_be20;
              n_r_wr20 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we20 <= 4'hF;
              n_r_wr20 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive20 OE20 signal20 to I20/O20 pins20 on ASIC20 -----added by gulbir20
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk20 or negedge n_sys_reset20)
     
     begin
        
        if (~n_sys_reset20)
          
          smc_n_ext_oe20 <= 1;
        
        
        else if ((n_read20 & valid_access20 & 
                  (smc_nextstate20 != `SMC_STORE20)) |
                (n_r_read20 & ~valid_access20 & 
              (smc_nextstate20 != `SMC_STORE20) & 
                 (smc_nextstate20 != `SMC_IDLE20)))      

           smc_n_ext_oe20 <= 0;
        
        else
          
           smc_n_ext_oe20 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate20 half20 and full signals20 for write strobes20
// A full cycle is required20 if wait states20 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate20 half20 cycle signals20 for write strobes20
//----------------------------------------------------------------------

always @(r_smc_currentstate20 or smc_nextstate20 or
            r_full20 or 
            r_wete_store20 or r_ws_store20 or r_wele_store20 or 
            r_ws_count20 or r_wele_count20 or 
            valid_access20 or smc_done20)
  
  begin     
     
       begin
          
          case (r_smc_currentstate20)
            
            `SMC_IDLE20:
              
              begin
                 
                     half_cycle20 = 1'b0;
                 
              end
            
            `SMC_LE20:
              
              begin
                 
                 if (smc_nextstate20 == `SMC_RW20)
                   
                   if( ( ( (r_wete_store20) == r_ws_count20[1:0]) &
                         (r_ws_count20[7:2] == 6'd0) &
                         (r_wele_count20 < 2'd2)
                       ) |
                       (r_ws_count20 == 8'd0)
                     )
                     
                     half_cycle20 = 1'b1 & ~r_full20;
                 
                   else
                     
                     half_cycle20 = 1'b0;
                 
                 else
                   
                   half_cycle20 = 1'b0;
                 
              end
            
            `SMC_RW20, `SMC_FLOAT20:
              
              begin
                 
                 if (smc_nextstate20 == `SMC_RW20)
                   
                   if (valid_access20)

                       
                       half_cycle20 = 1'b0;
                 
                   else if (smc_done20)
                     
                     if( ( (r_wete_store20 == r_ws_store20[1:0]) & 
                           (r_ws_store20[7:2] == 6'd0) & 
                           (r_wele_store20 == 2'd0)
                         ) | 
                         (r_ws_store20 == 8'd0)
                       )
                       
                       half_cycle20 = 1'b1 & ~r_full20;
                 
                     else
                       
                       half_cycle20 = 1'b0;
                 
                   else
                     
                     if (r_wete_store20 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count20[1:0]) & 
                            (r_ws_count20[7:2] == 6'd1) &
                            (r_wele_count20 < 2'd2)
                          )
                         
                         half_cycle20 = 1'b1 & ~r_full20;
                 
                       else
                         
                         half_cycle20 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store20+2'd1) == r_ws_count20[1:0]) & 
                              (r_ws_count20[7:2] == 6'd0) & 
                              (r_wele_count20 < 2'd2)
                            )
                          )
                         
                         half_cycle20 = 1'b1 & ~r_full20;
                 
                       else
                         
                         half_cycle20 = 1'b0;
                 
                 else
                   
                   half_cycle20 = 1'b0;
                 
              end
            
            `SMC_STORE20:
              
              begin
                 
                 if (smc_nextstate20 == `SMC_RW20)

                   if( ( ( (r_wete_store20) == r_ws_count20[1:0]) & 
                         (r_ws_count20[7:2] == 6'd0) & 
                         (r_wele_count20 < 2'd2)
                       ) | 
                       (r_ws_count20 == 8'd0)
                     )
                     
                     half_cycle20 = 1'b1 & ~r_full20;
                 
                   else
                     
                     half_cycle20 = 1'b0;
                 
                 else
                   
                   half_cycle20 = 1'b0;
                 
              end
            
            default:
              
              half_cycle20 = 1'b0;
            
          endcase // r_smc_currentstate20
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal20 generation20
//----------------------------------------------------------------------

 always @(posedge sys_clk20 or negedge n_sys_reset20)
             
   begin
      
      if (~n_sys_reset20)
        
        begin
           
           r_full20 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate20)
             
             `SMC_IDLE20:
               
               begin
                  
                  if (smc_nextstate20 == `SMC_RW20)
                    
                         
                         r_full20 <= 1'b0;
                       
                  else
                        
                       r_full20 <= 1'b0;
                       
               end
             
          `SMC_LE20:
            
          begin
             
             if (smc_nextstate20 == `SMC_RW20)
               
                  if( ( ( (r_wete_store20) < r_ws_count20[1:0]) | 
                        (r_ws_count20[7:2] != 6'd0)
                      ) & 
                      (r_wele_count20 < 2'd2)
                    )
                    
                    r_full20 <= 1'b1;
                  
                  else
                    
                    r_full20 <= 1'b0;
                  
             else
               
                  r_full20 <= 1'b0;
                  
          end
          
          `SMC_RW20, `SMC_FLOAT20:
            
            begin
               
               if (smc_nextstate20 == `SMC_RW20)
                 
                 begin
                    
                    if (valid_access20)
                      
                           
                           r_full20 <= 1'b0;
                         
                    else if (smc_done20)
                      
                         if( ( ( (r_wete_store20 < r_ws_store20[1:0]) | 
                                 (r_ws_store20[7:2] != 6'd0)
                               ) & 
                               (r_wele_store20 == 2'd0)
                             )
                           )
                           
                           r_full20 <= 1'b1;
                         
                         else
                           
                           r_full20 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store20 == 2'd3)
                           
                           if( ( (r_ws_count20[7:0] > 8'd4)
                               ) & 
                               (r_wele_count20 < 2'd2)
                             )
                             
                             r_full20 <= 1'b1;
                         
                           else
                             
                             r_full20 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store20 + 2'd1) < 
                                         r_ws_count20[1:0]
                                       )
                                     ) |
                                     (r_ws_count20[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count20 < 2'd2)
                                 )
                           
                           r_full20 <= 1'b1;
                         
                         else
                           
                           r_full20 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full20 <= 1'b0;
               
            end
             
             `SMC_STORE20:
               
               begin
                  
                  if (smc_nextstate20 == `SMC_RW20)

                     if ( ( ( (r_wete_store20) < r_ws_count20[1:0]) | 
                            (r_ws_count20[7:2] != 6'd0)
                          ) & 
                          (r_wele_count20 == 2'd0)
                        )
                         
                         r_full20 <= 1'b1;
                       
                       else
                         
                         r_full20 <= 1'b0;
                       
                  else
                    
                       r_full20 <= 1'b0;
                       
               end
             
             default:
               
                  r_full20 <= 1'b0;
                  
           endcase // r_smc_currentstate20
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate20 Read Strobe20
//----------------------------------------------------------------------
 
  always @(posedge sys_clk20 or negedge n_sys_reset20)
  
  begin
     
     if (~n_sys_reset20)
  
        smc_n_rd20 <= 1'h1;
      
      
     else if (smc_nextstate20 == `SMC_RW20)
  
     begin
  
        if (valid_access20)
  
        begin
  
  
              smc_n_rd20 <= n_read20;
  
  
        end
  
        else if ((r_smc_currentstate20 == `SMC_LE20) | 
                    (r_smc_currentstate20 == `SMC_STORE20))

        begin
           
           if( (r_oete_store20 < r_ws_store20[1:0]) | 
               (r_ws_store20[7:2] != 6'd0) |
               ( (r_oete_store20 == r_ws_store20[1:0]) & 
                 (r_ws_store20[7:2] == 6'd0)
               ) |
               (r_ws_store20 == 8'd0) 
             )
             
             smc_n_rd20 <= n_r_read20;
           
           else
             
             smc_n_rd20 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store20) < r_ws_count20[1:0]) | 
               (r_ws_count20[7:2] != 6'd0) |
               (r_ws_count20 == 8'd0) 
             )
             
              smc_n_rd20 <= n_r_read20;
           
           else

              smc_n_rd20 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd20 <= 1'b1;
     
  end
   
   
 
endmodule


