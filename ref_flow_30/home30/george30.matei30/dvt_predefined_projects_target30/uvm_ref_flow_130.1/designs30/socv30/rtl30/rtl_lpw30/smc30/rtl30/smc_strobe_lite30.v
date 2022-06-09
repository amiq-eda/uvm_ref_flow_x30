//File30 name   : smc_strobe_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`include "smc_defs_lite30.v"

module smc_strobe_lite30  (

                    //inputs30

                    sys_clk30,
                    n_sys_reset30,
                    valid_access30,
                    n_read30,
                    cs,
                    r_smc_currentstate30,
                    smc_nextstate30,
                    n_be30,
                    r_wele_count30,
                    r_wele_store30,
                    r_wete_store30,
                    r_oete_store30,
                    r_ws_count30,
                    r_ws_store30,
                    smc_done30,
                    mac_done30,

                    //outputs30

                    smc_n_rd30,
                    smc_n_ext_oe30,
                    smc_busy30,
                    n_r_read30,
                    r_cs30,
                    r_full30,
                    n_r_we30,
                    n_r_wr30);



//Parameters30  -  Values30 in smc_defs30.v

 


// I30/O30

   input                   sys_clk30;      //System30 clock30
   input                   n_sys_reset30;  //System30 reset (Active30 LOW30)
   input                   valid_access30; //load30 values are valid if high30
   input                   n_read30;       //Active30 low30 read signal30
   input              cs;           //registered chip30 select30
   input [4:0]             r_smc_currentstate30;//current state
   input [4:0]             smc_nextstate30;//next state  
   input [3:0]             n_be30;         //Unregistered30 Byte30 strobes30
   input [1:0]             r_wele_count30; //Write counter
   input [1:0]             r_wete_store30; //write strobe30 trailing30 edge store30
   input [1:0]             r_oete_store30; //read strobe30
   input [1:0]             r_wele_store30; //write strobe30 leading30 edge store30
   input [7:0]             r_ws_count30;   //wait state count
   input [7:0]             r_ws_store30;   //wait state store30
   input                   smc_done30;  //one access completed
   input                   mac_done30;  //All cycles30 in a multiple access
   
   
   output                  smc_n_rd30;     // EMI30 read stobe30 (Active30 LOW30)
   output                  smc_n_ext_oe30; // Enable30 External30 bus drivers30.
                                                          //  (CS30 & ~RD30)
   output                  smc_busy30;  // smc30 busy
   output                  n_r_read30;  // Store30 RW strobe30 for multiple
                                                         //  accesses
   output                  r_full30;    // Full cycle write strobe30
   output [3:0]            n_r_we30;    // write enable strobe30(active low30)
   output                  n_r_wr30;    // write strobe30(active low30)
   output             r_cs30;      // registered chip30 select30.   


// Output30 register declarations30

   reg                     smc_n_rd30;
   reg                     smc_n_ext_oe30;
   reg                r_cs30;
   reg                     smc_busy30;
   reg                     n_r_read30;
   reg                     r_full30;
   reg   [3:0]             n_r_we30;
   reg                     n_r_wr30;

   //wire declarations30
   
   wire             smc_mac_done30;       //smc_done30 and  mac_done30 anded30
   wire [2:0]       wait_vaccess_smdone30;//concatenated30 signals30 for case
   reg              half_cycle30;         //used for generating30 half30 cycle
                                                //strobes30
   


//----------------------------------------------------------------------
// Strobe30 Generation30
//
// Individual Write Strobes30
// Write Strobe30 = Byte30 Enable30 & Write Enable30
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal30 concatenation30 for use in case statement30
//----------------------------------------------------------------------

   assign smc_mac_done30 = {smc_done30 & mac_done30};

   assign wait_vaccess_smdone30 = {1'b0,valid_access30,smc_mac_done30};
   
   
//----------------------------------------------------------------------
// Store30 read/write signal30 for duration30 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk30 or negedge n_sys_reset30)
  
     begin
  
        if (~n_sys_reset30)
  
           n_r_read30 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone30)
               
               3'b1xx:
                 
                  n_r_read30 <= n_r_read30;
               
               3'b01x:
                 
                  n_r_read30 <= n_read30;
               
               3'b001:
                 
                  n_r_read30 <= 0;
               
               default:
                 
                  n_r_read30 <= n_r_read30;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store30 chip30 selects30 for duration30 of cycle(s)--turnaround30 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store30 read/write signal30 for duration30 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk30 or negedge n_sys_reset30)
     
      begin
           
         if (~n_sys_reset30)
           
           r_cs30 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone30)
                
                 3'b1xx:
                  
                    r_cs30 <= r_cs30 ;
                
                 3'b01x:
                  
                    r_cs30 <= cs ;
                
                 3'b001:
                  
                    r_cs30 <= 1'b0;
                
                 default:
                  
                    r_cs30 <= r_cs30 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive30 busy output whenever30 smc30 active
//----------------------------------------------------------------------

   always @(posedge sys_clk30 or negedge n_sys_reset30)
     
      begin
          
         if (~n_sys_reset30)
           
            smc_busy30 <= 0;
           
           
         else if (smc_nextstate30 != `SMC_IDLE30)
           
            smc_busy30 <= 1;
           
         else
           
            smc_busy30 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive30 OE30 signal30 to I30/O30 pins30 on ASIC30
//
// Generate30 internal, registered Write strobes30
// The write strobes30 are gated30 with the clock30 later30 to generate half30 
// cycle strobes30
//----------------------------------------------------------------------

  always @(posedge sys_clk30 or negedge n_sys_reset30)
    
     begin
       
        if (~n_sys_reset30)
         
           begin
            
              n_r_we30 <= 4'hF;
              n_r_wr30 <= 1'h1;
            
           end
       

        else if ((n_read30 & valid_access30 & 
                  (smc_nextstate30 != `SMC_STORE30)) |
                 (n_r_read30 & ~valid_access30 & 
                  (smc_nextstate30 != `SMC_STORE30)))      
         
           begin
            
              n_r_we30 <= n_be30;
              n_r_wr30 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we30 <= 4'hF;
              n_r_wr30 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive30 OE30 signal30 to I30/O30 pins30 on ASIC30 -----added by gulbir30
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk30 or negedge n_sys_reset30)
     
     begin
        
        if (~n_sys_reset30)
          
          smc_n_ext_oe30 <= 1;
        
        
        else if ((n_read30 & valid_access30 & 
                  (smc_nextstate30 != `SMC_STORE30)) |
                (n_r_read30 & ~valid_access30 & 
              (smc_nextstate30 != `SMC_STORE30) & 
                 (smc_nextstate30 != `SMC_IDLE30)))      

           smc_n_ext_oe30 <= 0;
        
        else
          
           smc_n_ext_oe30 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate30 half30 and full signals30 for write strobes30
// A full cycle is required30 if wait states30 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate30 half30 cycle signals30 for write strobes30
//----------------------------------------------------------------------

always @(r_smc_currentstate30 or smc_nextstate30 or
            r_full30 or 
            r_wete_store30 or r_ws_store30 or r_wele_store30 or 
            r_ws_count30 or r_wele_count30 or 
            valid_access30 or smc_done30)
  
  begin     
     
       begin
          
          case (r_smc_currentstate30)
            
            `SMC_IDLE30:
              
              begin
                 
                     half_cycle30 = 1'b0;
                 
              end
            
            `SMC_LE30:
              
              begin
                 
                 if (smc_nextstate30 == `SMC_RW30)
                   
                   if( ( ( (r_wete_store30) == r_ws_count30[1:0]) &
                         (r_ws_count30[7:2] == 6'd0) &
                         (r_wele_count30 < 2'd2)
                       ) |
                       (r_ws_count30 == 8'd0)
                     )
                     
                     half_cycle30 = 1'b1 & ~r_full30;
                 
                   else
                     
                     half_cycle30 = 1'b0;
                 
                 else
                   
                   half_cycle30 = 1'b0;
                 
              end
            
            `SMC_RW30, `SMC_FLOAT30:
              
              begin
                 
                 if (smc_nextstate30 == `SMC_RW30)
                   
                   if (valid_access30)

                       
                       half_cycle30 = 1'b0;
                 
                   else if (smc_done30)
                     
                     if( ( (r_wete_store30 == r_ws_store30[1:0]) & 
                           (r_ws_store30[7:2] == 6'd0) & 
                           (r_wele_store30 == 2'd0)
                         ) | 
                         (r_ws_store30 == 8'd0)
                       )
                       
                       half_cycle30 = 1'b1 & ~r_full30;
                 
                     else
                       
                       half_cycle30 = 1'b0;
                 
                   else
                     
                     if (r_wete_store30 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count30[1:0]) & 
                            (r_ws_count30[7:2] == 6'd1) &
                            (r_wele_count30 < 2'd2)
                          )
                         
                         half_cycle30 = 1'b1 & ~r_full30;
                 
                       else
                         
                         half_cycle30 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store30+2'd1) == r_ws_count30[1:0]) & 
                              (r_ws_count30[7:2] == 6'd0) & 
                              (r_wele_count30 < 2'd2)
                            )
                          )
                         
                         half_cycle30 = 1'b1 & ~r_full30;
                 
                       else
                         
                         half_cycle30 = 1'b0;
                 
                 else
                   
                   half_cycle30 = 1'b0;
                 
              end
            
            `SMC_STORE30:
              
              begin
                 
                 if (smc_nextstate30 == `SMC_RW30)

                   if( ( ( (r_wete_store30) == r_ws_count30[1:0]) & 
                         (r_ws_count30[7:2] == 6'd0) & 
                         (r_wele_count30 < 2'd2)
                       ) | 
                       (r_ws_count30 == 8'd0)
                     )
                     
                     half_cycle30 = 1'b1 & ~r_full30;
                 
                   else
                     
                     half_cycle30 = 1'b0;
                 
                 else
                   
                   half_cycle30 = 1'b0;
                 
              end
            
            default:
              
              half_cycle30 = 1'b0;
            
          endcase // r_smc_currentstate30
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal30 generation30
//----------------------------------------------------------------------

 always @(posedge sys_clk30 or negedge n_sys_reset30)
             
   begin
      
      if (~n_sys_reset30)
        
        begin
           
           r_full30 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate30)
             
             `SMC_IDLE30:
               
               begin
                  
                  if (smc_nextstate30 == `SMC_RW30)
                    
                         
                         r_full30 <= 1'b0;
                       
                  else
                        
                       r_full30 <= 1'b0;
                       
               end
             
          `SMC_LE30:
            
          begin
             
             if (smc_nextstate30 == `SMC_RW30)
               
                  if( ( ( (r_wete_store30) < r_ws_count30[1:0]) | 
                        (r_ws_count30[7:2] != 6'd0)
                      ) & 
                      (r_wele_count30 < 2'd2)
                    )
                    
                    r_full30 <= 1'b1;
                  
                  else
                    
                    r_full30 <= 1'b0;
                  
             else
               
                  r_full30 <= 1'b0;
                  
          end
          
          `SMC_RW30, `SMC_FLOAT30:
            
            begin
               
               if (smc_nextstate30 == `SMC_RW30)
                 
                 begin
                    
                    if (valid_access30)
                      
                           
                           r_full30 <= 1'b0;
                         
                    else if (smc_done30)
                      
                         if( ( ( (r_wete_store30 < r_ws_store30[1:0]) | 
                                 (r_ws_store30[7:2] != 6'd0)
                               ) & 
                               (r_wele_store30 == 2'd0)
                             )
                           )
                           
                           r_full30 <= 1'b1;
                         
                         else
                           
                           r_full30 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store30 == 2'd3)
                           
                           if( ( (r_ws_count30[7:0] > 8'd4)
                               ) & 
                               (r_wele_count30 < 2'd2)
                             )
                             
                             r_full30 <= 1'b1;
                         
                           else
                             
                             r_full30 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store30 + 2'd1) < 
                                         r_ws_count30[1:0]
                                       )
                                     ) |
                                     (r_ws_count30[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count30 < 2'd2)
                                 )
                           
                           r_full30 <= 1'b1;
                         
                         else
                           
                           r_full30 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full30 <= 1'b0;
               
            end
             
             `SMC_STORE30:
               
               begin
                  
                  if (smc_nextstate30 == `SMC_RW30)

                     if ( ( ( (r_wete_store30) < r_ws_count30[1:0]) | 
                            (r_ws_count30[7:2] != 6'd0)
                          ) & 
                          (r_wele_count30 == 2'd0)
                        )
                         
                         r_full30 <= 1'b1;
                       
                       else
                         
                         r_full30 <= 1'b0;
                       
                  else
                    
                       r_full30 <= 1'b0;
                       
               end
             
             default:
               
                  r_full30 <= 1'b0;
                  
           endcase // r_smc_currentstate30
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate30 Read Strobe30
//----------------------------------------------------------------------
 
  always @(posedge sys_clk30 or negedge n_sys_reset30)
  
  begin
     
     if (~n_sys_reset30)
  
        smc_n_rd30 <= 1'h1;
      
      
     else if (smc_nextstate30 == `SMC_RW30)
  
     begin
  
        if (valid_access30)
  
        begin
  
  
              smc_n_rd30 <= n_read30;
  
  
        end
  
        else if ((r_smc_currentstate30 == `SMC_LE30) | 
                    (r_smc_currentstate30 == `SMC_STORE30))

        begin
           
           if( (r_oete_store30 < r_ws_store30[1:0]) | 
               (r_ws_store30[7:2] != 6'd0) |
               ( (r_oete_store30 == r_ws_store30[1:0]) & 
                 (r_ws_store30[7:2] == 6'd0)
               ) |
               (r_ws_store30 == 8'd0) 
             )
             
             smc_n_rd30 <= n_r_read30;
           
           else
             
             smc_n_rd30 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store30) < r_ws_count30[1:0]) | 
               (r_ws_count30[7:2] != 6'd0) |
               (r_ws_count30 == 8'd0) 
             )
             
              smc_n_rd30 <= n_r_read30;
           
           else

              smc_n_rd30 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd30 <= 1'b1;
     
  end
   
   
 
endmodule


