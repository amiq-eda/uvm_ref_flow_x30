//File15 name   : smc_strobe_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`include "smc_defs_lite15.v"

module smc_strobe_lite15  (

                    //inputs15

                    sys_clk15,
                    n_sys_reset15,
                    valid_access15,
                    n_read15,
                    cs,
                    r_smc_currentstate15,
                    smc_nextstate15,
                    n_be15,
                    r_wele_count15,
                    r_wele_store15,
                    r_wete_store15,
                    r_oete_store15,
                    r_ws_count15,
                    r_ws_store15,
                    smc_done15,
                    mac_done15,

                    //outputs15

                    smc_n_rd15,
                    smc_n_ext_oe15,
                    smc_busy15,
                    n_r_read15,
                    r_cs15,
                    r_full15,
                    n_r_we15,
                    n_r_wr15);



//Parameters15  -  Values15 in smc_defs15.v

 


// I15/O15

   input                   sys_clk15;      //System15 clock15
   input                   n_sys_reset15;  //System15 reset (Active15 LOW15)
   input                   valid_access15; //load15 values are valid if high15
   input                   n_read15;       //Active15 low15 read signal15
   input              cs;           //registered chip15 select15
   input [4:0]             r_smc_currentstate15;//current state
   input [4:0]             smc_nextstate15;//next state  
   input [3:0]             n_be15;         //Unregistered15 Byte15 strobes15
   input [1:0]             r_wele_count15; //Write counter
   input [1:0]             r_wete_store15; //write strobe15 trailing15 edge store15
   input [1:0]             r_oete_store15; //read strobe15
   input [1:0]             r_wele_store15; //write strobe15 leading15 edge store15
   input [7:0]             r_ws_count15;   //wait state count
   input [7:0]             r_ws_store15;   //wait state store15
   input                   smc_done15;  //one access completed
   input                   mac_done15;  //All cycles15 in a multiple access
   
   
   output                  smc_n_rd15;     // EMI15 read stobe15 (Active15 LOW15)
   output                  smc_n_ext_oe15; // Enable15 External15 bus drivers15.
                                                          //  (CS15 & ~RD15)
   output                  smc_busy15;  // smc15 busy
   output                  n_r_read15;  // Store15 RW strobe15 for multiple
                                                         //  accesses
   output                  r_full15;    // Full cycle write strobe15
   output [3:0]            n_r_we15;    // write enable strobe15(active low15)
   output                  n_r_wr15;    // write strobe15(active low15)
   output             r_cs15;      // registered chip15 select15.   


// Output15 register declarations15

   reg                     smc_n_rd15;
   reg                     smc_n_ext_oe15;
   reg                r_cs15;
   reg                     smc_busy15;
   reg                     n_r_read15;
   reg                     r_full15;
   reg   [3:0]             n_r_we15;
   reg                     n_r_wr15;

   //wire declarations15
   
   wire             smc_mac_done15;       //smc_done15 and  mac_done15 anded15
   wire [2:0]       wait_vaccess_smdone15;//concatenated15 signals15 for case
   reg              half_cycle15;         //used for generating15 half15 cycle
                                                //strobes15
   


//----------------------------------------------------------------------
// Strobe15 Generation15
//
// Individual Write Strobes15
// Write Strobe15 = Byte15 Enable15 & Write Enable15
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal15 concatenation15 for use in case statement15
//----------------------------------------------------------------------

   assign smc_mac_done15 = {smc_done15 & mac_done15};

   assign wait_vaccess_smdone15 = {1'b0,valid_access15,smc_mac_done15};
   
   
//----------------------------------------------------------------------
// Store15 read/write signal15 for duration15 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk15 or negedge n_sys_reset15)
  
     begin
  
        if (~n_sys_reset15)
  
           n_r_read15 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone15)
               
               3'b1xx:
                 
                  n_r_read15 <= n_r_read15;
               
               3'b01x:
                 
                  n_r_read15 <= n_read15;
               
               3'b001:
                 
                  n_r_read15 <= 0;
               
               default:
                 
                  n_r_read15 <= n_r_read15;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store15 chip15 selects15 for duration15 of cycle(s)--turnaround15 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store15 read/write signal15 for duration15 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk15 or negedge n_sys_reset15)
     
      begin
           
         if (~n_sys_reset15)
           
           r_cs15 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone15)
                
                 3'b1xx:
                  
                    r_cs15 <= r_cs15 ;
                
                 3'b01x:
                  
                    r_cs15 <= cs ;
                
                 3'b001:
                  
                    r_cs15 <= 1'b0;
                
                 default:
                  
                    r_cs15 <= r_cs15 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive15 busy output whenever15 smc15 active
//----------------------------------------------------------------------

   always @(posedge sys_clk15 or negedge n_sys_reset15)
     
      begin
          
         if (~n_sys_reset15)
           
            smc_busy15 <= 0;
           
           
         else if (smc_nextstate15 != `SMC_IDLE15)
           
            smc_busy15 <= 1;
           
         else
           
            smc_busy15 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive15 OE15 signal15 to I15/O15 pins15 on ASIC15
//
// Generate15 internal, registered Write strobes15
// The write strobes15 are gated15 with the clock15 later15 to generate half15 
// cycle strobes15
//----------------------------------------------------------------------

  always @(posedge sys_clk15 or negedge n_sys_reset15)
    
     begin
       
        if (~n_sys_reset15)
         
           begin
            
              n_r_we15 <= 4'hF;
              n_r_wr15 <= 1'h1;
            
           end
       

        else if ((n_read15 & valid_access15 & 
                  (smc_nextstate15 != `SMC_STORE15)) |
                 (n_r_read15 & ~valid_access15 & 
                  (smc_nextstate15 != `SMC_STORE15)))      
         
           begin
            
              n_r_we15 <= n_be15;
              n_r_wr15 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we15 <= 4'hF;
              n_r_wr15 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive15 OE15 signal15 to I15/O15 pins15 on ASIC15 -----added by gulbir15
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk15 or negedge n_sys_reset15)
     
     begin
        
        if (~n_sys_reset15)
          
          smc_n_ext_oe15 <= 1;
        
        
        else if ((n_read15 & valid_access15 & 
                  (smc_nextstate15 != `SMC_STORE15)) |
                (n_r_read15 & ~valid_access15 & 
              (smc_nextstate15 != `SMC_STORE15) & 
                 (smc_nextstate15 != `SMC_IDLE15)))      

           smc_n_ext_oe15 <= 0;
        
        else
          
           smc_n_ext_oe15 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate15 half15 and full signals15 for write strobes15
// A full cycle is required15 if wait states15 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate15 half15 cycle signals15 for write strobes15
//----------------------------------------------------------------------

always @(r_smc_currentstate15 or smc_nextstate15 or
            r_full15 or 
            r_wete_store15 or r_ws_store15 or r_wele_store15 or 
            r_ws_count15 or r_wele_count15 or 
            valid_access15 or smc_done15)
  
  begin     
     
       begin
          
          case (r_smc_currentstate15)
            
            `SMC_IDLE15:
              
              begin
                 
                     half_cycle15 = 1'b0;
                 
              end
            
            `SMC_LE15:
              
              begin
                 
                 if (smc_nextstate15 == `SMC_RW15)
                   
                   if( ( ( (r_wete_store15) == r_ws_count15[1:0]) &
                         (r_ws_count15[7:2] == 6'd0) &
                         (r_wele_count15 < 2'd2)
                       ) |
                       (r_ws_count15 == 8'd0)
                     )
                     
                     half_cycle15 = 1'b1 & ~r_full15;
                 
                   else
                     
                     half_cycle15 = 1'b0;
                 
                 else
                   
                   half_cycle15 = 1'b0;
                 
              end
            
            `SMC_RW15, `SMC_FLOAT15:
              
              begin
                 
                 if (smc_nextstate15 == `SMC_RW15)
                   
                   if (valid_access15)

                       
                       half_cycle15 = 1'b0;
                 
                   else if (smc_done15)
                     
                     if( ( (r_wete_store15 == r_ws_store15[1:0]) & 
                           (r_ws_store15[7:2] == 6'd0) & 
                           (r_wele_store15 == 2'd0)
                         ) | 
                         (r_ws_store15 == 8'd0)
                       )
                       
                       half_cycle15 = 1'b1 & ~r_full15;
                 
                     else
                       
                       half_cycle15 = 1'b0;
                 
                   else
                     
                     if (r_wete_store15 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count15[1:0]) & 
                            (r_ws_count15[7:2] == 6'd1) &
                            (r_wele_count15 < 2'd2)
                          )
                         
                         half_cycle15 = 1'b1 & ~r_full15;
                 
                       else
                         
                         half_cycle15 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store15+2'd1) == r_ws_count15[1:0]) & 
                              (r_ws_count15[7:2] == 6'd0) & 
                              (r_wele_count15 < 2'd2)
                            )
                          )
                         
                         half_cycle15 = 1'b1 & ~r_full15;
                 
                       else
                         
                         half_cycle15 = 1'b0;
                 
                 else
                   
                   half_cycle15 = 1'b0;
                 
              end
            
            `SMC_STORE15:
              
              begin
                 
                 if (smc_nextstate15 == `SMC_RW15)

                   if( ( ( (r_wete_store15) == r_ws_count15[1:0]) & 
                         (r_ws_count15[7:2] == 6'd0) & 
                         (r_wele_count15 < 2'd2)
                       ) | 
                       (r_ws_count15 == 8'd0)
                     )
                     
                     half_cycle15 = 1'b1 & ~r_full15;
                 
                   else
                     
                     half_cycle15 = 1'b0;
                 
                 else
                   
                   half_cycle15 = 1'b0;
                 
              end
            
            default:
              
              half_cycle15 = 1'b0;
            
          endcase // r_smc_currentstate15
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal15 generation15
//----------------------------------------------------------------------

 always @(posedge sys_clk15 or negedge n_sys_reset15)
             
   begin
      
      if (~n_sys_reset15)
        
        begin
           
           r_full15 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate15)
             
             `SMC_IDLE15:
               
               begin
                  
                  if (smc_nextstate15 == `SMC_RW15)
                    
                         
                         r_full15 <= 1'b0;
                       
                  else
                        
                       r_full15 <= 1'b0;
                       
               end
             
          `SMC_LE15:
            
          begin
             
             if (smc_nextstate15 == `SMC_RW15)
               
                  if( ( ( (r_wete_store15) < r_ws_count15[1:0]) | 
                        (r_ws_count15[7:2] != 6'd0)
                      ) & 
                      (r_wele_count15 < 2'd2)
                    )
                    
                    r_full15 <= 1'b1;
                  
                  else
                    
                    r_full15 <= 1'b0;
                  
             else
               
                  r_full15 <= 1'b0;
                  
          end
          
          `SMC_RW15, `SMC_FLOAT15:
            
            begin
               
               if (smc_nextstate15 == `SMC_RW15)
                 
                 begin
                    
                    if (valid_access15)
                      
                           
                           r_full15 <= 1'b0;
                         
                    else if (smc_done15)
                      
                         if( ( ( (r_wete_store15 < r_ws_store15[1:0]) | 
                                 (r_ws_store15[7:2] != 6'd0)
                               ) & 
                               (r_wele_store15 == 2'd0)
                             )
                           )
                           
                           r_full15 <= 1'b1;
                         
                         else
                           
                           r_full15 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store15 == 2'd3)
                           
                           if( ( (r_ws_count15[7:0] > 8'd4)
                               ) & 
                               (r_wele_count15 < 2'd2)
                             )
                             
                             r_full15 <= 1'b1;
                         
                           else
                             
                             r_full15 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store15 + 2'd1) < 
                                         r_ws_count15[1:0]
                                       )
                                     ) |
                                     (r_ws_count15[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count15 < 2'd2)
                                 )
                           
                           r_full15 <= 1'b1;
                         
                         else
                           
                           r_full15 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full15 <= 1'b0;
               
            end
             
             `SMC_STORE15:
               
               begin
                  
                  if (smc_nextstate15 == `SMC_RW15)

                     if ( ( ( (r_wete_store15) < r_ws_count15[1:0]) | 
                            (r_ws_count15[7:2] != 6'd0)
                          ) & 
                          (r_wele_count15 == 2'd0)
                        )
                         
                         r_full15 <= 1'b1;
                       
                       else
                         
                         r_full15 <= 1'b0;
                       
                  else
                    
                       r_full15 <= 1'b0;
                       
               end
             
             default:
               
                  r_full15 <= 1'b0;
                  
           endcase // r_smc_currentstate15
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate15 Read Strobe15
//----------------------------------------------------------------------
 
  always @(posedge sys_clk15 or negedge n_sys_reset15)
  
  begin
     
     if (~n_sys_reset15)
  
        smc_n_rd15 <= 1'h1;
      
      
     else if (smc_nextstate15 == `SMC_RW15)
  
     begin
  
        if (valid_access15)
  
        begin
  
  
              smc_n_rd15 <= n_read15;
  
  
        end
  
        else if ((r_smc_currentstate15 == `SMC_LE15) | 
                    (r_smc_currentstate15 == `SMC_STORE15))

        begin
           
           if( (r_oete_store15 < r_ws_store15[1:0]) | 
               (r_ws_store15[7:2] != 6'd0) |
               ( (r_oete_store15 == r_ws_store15[1:0]) & 
                 (r_ws_store15[7:2] == 6'd0)
               ) |
               (r_ws_store15 == 8'd0) 
             )
             
             smc_n_rd15 <= n_r_read15;
           
           else
             
             smc_n_rd15 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store15) < r_ws_count15[1:0]) | 
               (r_ws_count15[7:2] != 6'd0) |
               (r_ws_count15 == 8'd0) 
             )
             
              smc_n_rd15 <= n_r_read15;
           
           else

              smc_n_rd15 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd15 <= 1'b1;
     
  end
   
   
 
endmodule


