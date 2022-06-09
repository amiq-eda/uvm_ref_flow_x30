//File23 name   : smc_strobe_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`include "smc_defs_lite23.v"

module smc_strobe_lite23  (

                    //inputs23

                    sys_clk23,
                    n_sys_reset23,
                    valid_access23,
                    n_read23,
                    cs,
                    r_smc_currentstate23,
                    smc_nextstate23,
                    n_be23,
                    r_wele_count23,
                    r_wele_store23,
                    r_wete_store23,
                    r_oete_store23,
                    r_ws_count23,
                    r_ws_store23,
                    smc_done23,
                    mac_done23,

                    //outputs23

                    smc_n_rd23,
                    smc_n_ext_oe23,
                    smc_busy23,
                    n_r_read23,
                    r_cs23,
                    r_full23,
                    n_r_we23,
                    n_r_wr23);



//Parameters23  -  Values23 in smc_defs23.v

 


// I23/O23

   input                   sys_clk23;      //System23 clock23
   input                   n_sys_reset23;  //System23 reset (Active23 LOW23)
   input                   valid_access23; //load23 values are valid if high23
   input                   n_read23;       //Active23 low23 read signal23
   input              cs;           //registered chip23 select23
   input [4:0]             r_smc_currentstate23;//current state
   input [4:0]             smc_nextstate23;//next state  
   input [3:0]             n_be23;         //Unregistered23 Byte23 strobes23
   input [1:0]             r_wele_count23; //Write counter
   input [1:0]             r_wete_store23; //write strobe23 trailing23 edge store23
   input [1:0]             r_oete_store23; //read strobe23
   input [1:0]             r_wele_store23; //write strobe23 leading23 edge store23
   input [7:0]             r_ws_count23;   //wait state count
   input [7:0]             r_ws_store23;   //wait state store23
   input                   smc_done23;  //one access completed
   input                   mac_done23;  //All cycles23 in a multiple access
   
   
   output                  smc_n_rd23;     // EMI23 read stobe23 (Active23 LOW23)
   output                  smc_n_ext_oe23; // Enable23 External23 bus drivers23.
                                                          //  (CS23 & ~RD23)
   output                  smc_busy23;  // smc23 busy
   output                  n_r_read23;  // Store23 RW strobe23 for multiple
                                                         //  accesses
   output                  r_full23;    // Full cycle write strobe23
   output [3:0]            n_r_we23;    // write enable strobe23(active low23)
   output                  n_r_wr23;    // write strobe23(active low23)
   output             r_cs23;      // registered chip23 select23.   


// Output23 register declarations23

   reg                     smc_n_rd23;
   reg                     smc_n_ext_oe23;
   reg                r_cs23;
   reg                     smc_busy23;
   reg                     n_r_read23;
   reg                     r_full23;
   reg   [3:0]             n_r_we23;
   reg                     n_r_wr23;

   //wire declarations23
   
   wire             smc_mac_done23;       //smc_done23 and  mac_done23 anded23
   wire [2:0]       wait_vaccess_smdone23;//concatenated23 signals23 for case
   reg              half_cycle23;         //used for generating23 half23 cycle
                                                //strobes23
   


//----------------------------------------------------------------------
// Strobe23 Generation23
//
// Individual Write Strobes23
// Write Strobe23 = Byte23 Enable23 & Write Enable23
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal23 concatenation23 for use in case statement23
//----------------------------------------------------------------------

   assign smc_mac_done23 = {smc_done23 & mac_done23};

   assign wait_vaccess_smdone23 = {1'b0,valid_access23,smc_mac_done23};
   
   
//----------------------------------------------------------------------
// Store23 read/write signal23 for duration23 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk23 or negedge n_sys_reset23)
  
     begin
  
        if (~n_sys_reset23)
  
           n_r_read23 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone23)
               
               3'b1xx:
                 
                  n_r_read23 <= n_r_read23;
               
               3'b01x:
                 
                  n_r_read23 <= n_read23;
               
               3'b001:
                 
                  n_r_read23 <= 0;
               
               default:
                 
                  n_r_read23 <= n_r_read23;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store23 chip23 selects23 for duration23 of cycle(s)--turnaround23 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store23 read/write signal23 for duration23 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk23 or negedge n_sys_reset23)
     
      begin
           
         if (~n_sys_reset23)
           
           r_cs23 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone23)
                
                 3'b1xx:
                  
                    r_cs23 <= r_cs23 ;
                
                 3'b01x:
                  
                    r_cs23 <= cs ;
                
                 3'b001:
                  
                    r_cs23 <= 1'b0;
                
                 default:
                  
                    r_cs23 <= r_cs23 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive23 busy output whenever23 smc23 active
//----------------------------------------------------------------------

   always @(posedge sys_clk23 or negedge n_sys_reset23)
     
      begin
          
         if (~n_sys_reset23)
           
            smc_busy23 <= 0;
           
           
         else if (smc_nextstate23 != `SMC_IDLE23)
           
            smc_busy23 <= 1;
           
         else
           
            smc_busy23 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive23 OE23 signal23 to I23/O23 pins23 on ASIC23
//
// Generate23 internal, registered Write strobes23
// The write strobes23 are gated23 with the clock23 later23 to generate half23 
// cycle strobes23
//----------------------------------------------------------------------

  always @(posedge sys_clk23 or negedge n_sys_reset23)
    
     begin
       
        if (~n_sys_reset23)
         
           begin
            
              n_r_we23 <= 4'hF;
              n_r_wr23 <= 1'h1;
            
           end
       

        else if ((n_read23 & valid_access23 & 
                  (smc_nextstate23 != `SMC_STORE23)) |
                 (n_r_read23 & ~valid_access23 & 
                  (smc_nextstate23 != `SMC_STORE23)))      
         
           begin
            
              n_r_we23 <= n_be23;
              n_r_wr23 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we23 <= 4'hF;
              n_r_wr23 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive23 OE23 signal23 to I23/O23 pins23 on ASIC23 -----added by gulbir23
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk23 or negedge n_sys_reset23)
     
     begin
        
        if (~n_sys_reset23)
          
          smc_n_ext_oe23 <= 1;
        
        
        else if ((n_read23 & valid_access23 & 
                  (smc_nextstate23 != `SMC_STORE23)) |
                (n_r_read23 & ~valid_access23 & 
              (smc_nextstate23 != `SMC_STORE23) & 
                 (smc_nextstate23 != `SMC_IDLE23)))      

           smc_n_ext_oe23 <= 0;
        
        else
          
           smc_n_ext_oe23 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate23 half23 and full signals23 for write strobes23
// A full cycle is required23 if wait states23 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate23 half23 cycle signals23 for write strobes23
//----------------------------------------------------------------------

always @(r_smc_currentstate23 or smc_nextstate23 or
            r_full23 or 
            r_wete_store23 or r_ws_store23 or r_wele_store23 or 
            r_ws_count23 or r_wele_count23 or 
            valid_access23 or smc_done23)
  
  begin     
     
       begin
          
          case (r_smc_currentstate23)
            
            `SMC_IDLE23:
              
              begin
                 
                     half_cycle23 = 1'b0;
                 
              end
            
            `SMC_LE23:
              
              begin
                 
                 if (smc_nextstate23 == `SMC_RW23)
                   
                   if( ( ( (r_wete_store23) == r_ws_count23[1:0]) &
                         (r_ws_count23[7:2] == 6'd0) &
                         (r_wele_count23 < 2'd2)
                       ) |
                       (r_ws_count23 == 8'd0)
                     )
                     
                     half_cycle23 = 1'b1 & ~r_full23;
                 
                   else
                     
                     half_cycle23 = 1'b0;
                 
                 else
                   
                   half_cycle23 = 1'b0;
                 
              end
            
            `SMC_RW23, `SMC_FLOAT23:
              
              begin
                 
                 if (smc_nextstate23 == `SMC_RW23)
                   
                   if (valid_access23)

                       
                       half_cycle23 = 1'b0;
                 
                   else if (smc_done23)
                     
                     if( ( (r_wete_store23 == r_ws_store23[1:0]) & 
                           (r_ws_store23[7:2] == 6'd0) & 
                           (r_wele_store23 == 2'd0)
                         ) | 
                         (r_ws_store23 == 8'd0)
                       )
                       
                       half_cycle23 = 1'b1 & ~r_full23;
                 
                     else
                       
                       half_cycle23 = 1'b0;
                 
                   else
                     
                     if (r_wete_store23 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count23[1:0]) & 
                            (r_ws_count23[7:2] == 6'd1) &
                            (r_wele_count23 < 2'd2)
                          )
                         
                         half_cycle23 = 1'b1 & ~r_full23;
                 
                       else
                         
                         half_cycle23 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store23+2'd1) == r_ws_count23[1:0]) & 
                              (r_ws_count23[7:2] == 6'd0) & 
                              (r_wele_count23 < 2'd2)
                            )
                          )
                         
                         half_cycle23 = 1'b1 & ~r_full23;
                 
                       else
                         
                         half_cycle23 = 1'b0;
                 
                 else
                   
                   half_cycle23 = 1'b0;
                 
              end
            
            `SMC_STORE23:
              
              begin
                 
                 if (smc_nextstate23 == `SMC_RW23)

                   if( ( ( (r_wete_store23) == r_ws_count23[1:0]) & 
                         (r_ws_count23[7:2] == 6'd0) & 
                         (r_wele_count23 < 2'd2)
                       ) | 
                       (r_ws_count23 == 8'd0)
                     )
                     
                     half_cycle23 = 1'b1 & ~r_full23;
                 
                   else
                     
                     half_cycle23 = 1'b0;
                 
                 else
                   
                   half_cycle23 = 1'b0;
                 
              end
            
            default:
              
              half_cycle23 = 1'b0;
            
          endcase // r_smc_currentstate23
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal23 generation23
//----------------------------------------------------------------------

 always @(posedge sys_clk23 or negedge n_sys_reset23)
             
   begin
      
      if (~n_sys_reset23)
        
        begin
           
           r_full23 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate23)
             
             `SMC_IDLE23:
               
               begin
                  
                  if (smc_nextstate23 == `SMC_RW23)
                    
                         
                         r_full23 <= 1'b0;
                       
                  else
                        
                       r_full23 <= 1'b0;
                       
               end
             
          `SMC_LE23:
            
          begin
             
             if (smc_nextstate23 == `SMC_RW23)
               
                  if( ( ( (r_wete_store23) < r_ws_count23[1:0]) | 
                        (r_ws_count23[7:2] != 6'd0)
                      ) & 
                      (r_wele_count23 < 2'd2)
                    )
                    
                    r_full23 <= 1'b1;
                  
                  else
                    
                    r_full23 <= 1'b0;
                  
             else
               
                  r_full23 <= 1'b0;
                  
          end
          
          `SMC_RW23, `SMC_FLOAT23:
            
            begin
               
               if (smc_nextstate23 == `SMC_RW23)
                 
                 begin
                    
                    if (valid_access23)
                      
                           
                           r_full23 <= 1'b0;
                         
                    else if (smc_done23)
                      
                         if( ( ( (r_wete_store23 < r_ws_store23[1:0]) | 
                                 (r_ws_store23[7:2] != 6'd0)
                               ) & 
                               (r_wele_store23 == 2'd0)
                             )
                           )
                           
                           r_full23 <= 1'b1;
                         
                         else
                           
                           r_full23 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store23 == 2'd3)
                           
                           if( ( (r_ws_count23[7:0] > 8'd4)
                               ) & 
                               (r_wele_count23 < 2'd2)
                             )
                             
                             r_full23 <= 1'b1;
                         
                           else
                             
                             r_full23 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store23 + 2'd1) < 
                                         r_ws_count23[1:0]
                                       )
                                     ) |
                                     (r_ws_count23[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count23 < 2'd2)
                                 )
                           
                           r_full23 <= 1'b1;
                         
                         else
                           
                           r_full23 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full23 <= 1'b0;
               
            end
             
             `SMC_STORE23:
               
               begin
                  
                  if (smc_nextstate23 == `SMC_RW23)

                     if ( ( ( (r_wete_store23) < r_ws_count23[1:0]) | 
                            (r_ws_count23[7:2] != 6'd0)
                          ) & 
                          (r_wele_count23 == 2'd0)
                        )
                         
                         r_full23 <= 1'b1;
                       
                       else
                         
                         r_full23 <= 1'b0;
                       
                  else
                    
                       r_full23 <= 1'b0;
                       
               end
             
             default:
               
                  r_full23 <= 1'b0;
                  
           endcase // r_smc_currentstate23
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate23 Read Strobe23
//----------------------------------------------------------------------
 
  always @(posedge sys_clk23 or negedge n_sys_reset23)
  
  begin
     
     if (~n_sys_reset23)
  
        smc_n_rd23 <= 1'h1;
      
      
     else if (smc_nextstate23 == `SMC_RW23)
  
     begin
  
        if (valid_access23)
  
        begin
  
  
              smc_n_rd23 <= n_read23;
  
  
        end
  
        else if ((r_smc_currentstate23 == `SMC_LE23) | 
                    (r_smc_currentstate23 == `SMC_STORE23))

        begin
           
           if( (r_oete_store23 < r_ws_store23[1:0]) | 
               (r_ws_store23[7:2] != 6'd0) |
               ( (r_oete_store23 == r_ws_store23[1:0]) & 
                 (r_ws_store23[7:2] == 6'd0)
               ) |
               (r_ws_store23 == 8'd0) 
             )
             
             smc_n_rd23 <= n_r_read23;
           
           else
             
             smc_n_rd23 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store23) < r_ws_count23[1:0]) | 
               (r_ws_count23[7:2] != 6'd0) |
               (r_ws_count23 == 8'd0) 
             )
             
              smc_n_rd23 <= n_r_read23;
           
           else

              smc_n_rd23 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd23 <= 1'b1;
     
  end
   
   
 
endmodule


