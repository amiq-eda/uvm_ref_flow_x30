//File14 name   : smc_strobe_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`include "smc_defs_lite14.v"

module smc_strobe_lite14  (

                    //inputs14

                    sys_clk14,
                    n_sys_reset14,
                    valid_access14,
                    n_read14,
                    cs,
                    r_smc_currentstate14,
                    smc_nextstate14,
                    n_be14,
                    r_wele_count14,
                    r_wele_store14,
                    r_wete_store14,
                    r_oete_store14,
                    r_ws_count14,
                    r_ws_store14,
                    smc_done14,
                    mac_done14,

                    //outputs14

                    smc_n_rd14,
                    smc_n_ext_oe14,
                    smc_busy14,
                    n_r_read14,
                    r_cs14,
                    r_full14,
                    n_r_we14,
                    n_r_wr14);



//Parameters14  -  Values14 in smc_defs14.v

 


// I14/O14

   input                   sys_clk14;      //System14 clock14
   input                   n_sys_reset14;  //System14 reset (Active14 LOW14)
   input                   valid_access14; //load14 values are valid if high14
   input                   n_read14;       //Active14 low14 read signal14
   input              cs;           //registered chip14 select14
   input [4:0]             r_smc_currentstate14;//current state
   input [4:0]             smc_nextstate14;//next state  
   input [3:0]             n_be14;         //Unregistered14 Byte14 strobes14
   input [1:0]             r_wele_count14; //Write counter
   input [1:0]             r_wete_store14; //write strobe14 trailing14 edge store14
   input [1:0]             r_oete_store14; //read strobe14
   input [1:0]             r_wele_store14; //write strobe14 leading14 edge store14
   input [7:0]             r_ws_count14;   //wait state count
   input [7:0]             r_ws_store14;   //wait state store14
   input                   smc_done14;  //one access completed
   input                   mac_done14;  //All cycles14 in a multiple access
   
   
   output                  smc_n_rd14;     // EMI14 read stobe14 (Active14 LOW14)
   output                  smc_n_ext_oe14; // Enable14 External14 bus drivers14.
                                                          //  (CS14 & ~RD14)
   output                  smc_busy14;  // smc14 busy
   output                  n_r_read14;  // Store14 RW strobe14 for multiple
                                                         //  accesses
   output                  r_full14;    // Full cycle write strobe14
   output [3:0]            n_r_we14;    // write enable strobe14(active low14)
   output                  n_r_wr14;    // write strobe14(active low14)
   output             r_cs14;      // registered chip14 select14.   


// Output14 register declarations14

   reg                     smc_n_rd14;
   reg                     smc_n_ext_oe14;
   reg                r_cs14;
   reg                     smc_busy14;
   reg                     n_r_read14;
   reg                     r_full14;
   reg   [3:0]             n_r_we14;
   reg                     n_r_wr14;

   //wire declarations14
   
   wire             smc_mac_done14;       //smc_done14 and  mac_done14 anded14
   wire [2:0]       wait_vaccess_smdone14;//concatenated14 signals14 for case
   reg              half_cycle14;         //used for generating14 half14 cycle
                                                //strobes14
   


//----------------------------------------------------------------------
// Strobe14 Generation14
//
// Individual Write Strobes14
// Write Strobe14 = Byte14 Enable14 & Write Enable14
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal14 concatenation14 for use in case statement14
//----------------------------------------------------------------------

   assign smc_mac_done14 = {smc_done14 & mac_done14};

   assign wait_vaccess_smdone14 = {1'b0,valid_access14,smc_mac_done14};
   
   
//----------------------------------------------------------------------
// Store14 read/write signal14 for duration14 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk14 or negedge n_sys_reset14)
  
     begin
  
        if (~n_sys_reset14)
  
           n_r_read14 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone14)
               
               3'b1xx:
                 
                  n_r_read14 <= n_r_read14;
               
               3'b01x:
                 
                  n_r_read14 <= n_read14;
               
               3'b001:
                 
                  n_r_read14 <= 0;
               
               default:
                 
                  n_r_read14 <= n_r_read14;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store14 chip14 selects14 for duration14 of cycle(s)--turnaround14 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store14 read/write signal14 for duration14 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk14 or negedge n_sys_reset14)
     
      begin
           
         if (~n_sys_reset14)
           
           r_cs14 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone14)
                
                 3'b1xx:
                  
                    r_cs14 <= r_cs14 ;
                
                 3'b01x:
                  
                    r_cs14 <= cs ;
                
                 3'b001:
                  
                    r_cs14 <= 1'b0;
                
                 default:
                  
                    r_cs14 <= r_cs14 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive14 busy output whenever14 smc14 active
//----------------------------------------------------------------------

   always @(posedge sys_clk14 or negedge n_sys_reset14)
     
      begin
          
         if (~n_sys_reset14)
           
            smc_busy14 <= 0;
           
           
         else if (smc_nextstate14 != `SMC_IDLE14)
           
            smc_busy14 <= 1;
           
         else
           
            smc_busy14 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive14 OE14 signal14 to I14/O14 pins14 on ASIC14
//
// Generate14 internal, registered Write strobes14
// The write strobes14 are gated14 with the clock14 later14 to generate half14 
// cycle strobes14
//----------------------------------------------------------------------

  always @(posedge sys_clk14 or negedge n_sys_reset14)
    
     begin
       
        if (~n_sys_reset14)
         
           begin
            
              n_r_we14 <= 4'hF;
              n_r_wr14 <= 1'h1;
            
           end
       

        else if ((n_read14 & valid_access14 & 
                  (smc_nextstate14 != `SMC_STORE14)) |
                 (n_r_read14 & ~valid_access14 & 
                  (smc_nextstate14 != `SMC_STORE14)))      
         
           begin
            
              n_r_we14 <= n_be14;
              n_r_wr14 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we14 <= 4'hF;
              n_r_wr14 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive14 OE14 signal14 to I14/O14 pins14 on ASIC14 -----added by gulbir14
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk14 or negedge n_sys_reset14)
     
     begin
        
        if (~n_sys_reset14)
          
          smc_n_ext_oe14 <= 1;
        
        
        else if ((n_read14 & valid_access14 & 
                  (smc_nextstate14 != `SMC_STORE14)) |
                (n_r_read14 & ~valid_access14 & 
              (smc_nextstate14 != `SMC_STORE14) & 
                 (smc_nextstate14 != `SMC_IDLE14)))      

           smc_n_ext_oe14 <= 0;
        
        else
          
           smc_n_ext_oe14 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate14 half14 and full signals14 for write strobes14
// A full cycle is required14 if wait states14 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate14 half14 cycle signals14 for write strobes14
//----------------------------------------------------------------------

always @(r_smc_currentstate14 or smc_nextstate14 or
            r_full14 or 
            r_wete_store14 or r_ws_store14 or r_wele_store14 or 
            r_ws_count14 or r_wele_count14 or 
            valid_access14 or smc_done14)
  
  begin     
     
       begin
          
          case (r_smc_currentstate14)
            
            `SMC_IDLE14:
              
              begin
                 
                     half_cycle14 = 1'b0;
                 
              end
            
            `SMC_LE14:
              
              begin
                 
                 if (smc_nextstate14 == `SMC_RW14)
                   
                   if( ( ( (r_wete_store14) == r_ws_count14[1:0]) &
                         (r_ws_count14[7:2] == 6'd0) &
                         (r_wele_count14 < 2'd2)
                       ) |
                       (r_ws_count14 == 8'd0)
                     )
                     
                     half_cycle14 = 1'b1 & ~r_full14;
                 
                   else
                     
                     half_cycle14 = 1'b0;
                 
                 else
                   
                   half_cycle14 = 1'b0;
                 
              end
            
            `SMC_RW14, `SMC_FLOAT14:
              
              begin
                 
                 if (smc_nextstate14 == `SMC_RW14)
                   
                   if (valid_access14)

                       
                       half_cycle14 = 1'b0;
                 
                   else if (smc_done14)
                     
                     if( ( (r_wete_store14 == r_ws_store14[1:0]) & 
                           (r_ws_store14[7:2] == 6'd0) & 
                           (r_wele_store14 == 2'd0)
                         ) | 
                         (r_ws_store14 == 8'd0)
                       )
                       
                       half_cycle14 = 1'b1 & ~r_full14;
                 
                     else
                       
                       half_cycle14 = 1'b0;
                 
                   else
                     
                     if (r_wete_store14 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count14[1:0]) & 
                            (r_ws_count14[7:2] == 6'd1) &
                            (r_wele_count14 < 2'd2)
                          )
                         
                         half_cycle14 = 1'b1 & ~r_full14;
                 
                       else
                         
                         half_cycle14 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store14+2'd1) == r_ws_count14[1:0]) & 
                              (r_ws_count14[7:2] == 6'd0) & 
                              (r_wele_count14 < 2'd2)
                            )
                          )
                         
                         half_cycle14 = 1'b1 & ~r_full14;
                 
                       else
                         
                         half_cycle14 = 1'b0;
                 
                 else
                   
                   half_cycle14 = 1'b0;
                 
              end
            
            `SMC_STORE14:
              
              begin
                 
                 if (smc_nextstate14 == `SMC_RW14)

                   if( ( ( (r_wete_store14) == r_ws_count14[1:0]) & 
                         (r_ws_count14[7:2] == 6'd0) & 
                         (r_wele_count14 < 2'd2)
                       ) | 
                       (r_ws_count14 == 8'd0)
                     )
                     
                     half_cycle14 = 1'b1 & ~r_full14;
                 
                   else
                     
                     half_cycle14 = 1'b0;
                 
                 else
                   
                   half_cycle14 = 1'b0;
                 
              end
            
            default:
              
              half_cycle14 = 1'b0;
            
          endcase // r_smc_currentstate14
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal14 generation14
//----------------------------------------------------------------------

 always @(posedge sys_clk14 or negedge n_sys_reset14)
             
   begin
      
      if (~n_sys_reset14)
        
        begin
           
           r_full14 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate14)
             
             `SMC_IDLE14:
               
               begin
                  
                  if (smc_nextstate14 == `SMC_RW14)
                    
                         
                         r_full14 <= 1'b0;
                       
                  else
                        
                       r_full14 <= 1'b0;
                       
               end
             
          `SMC_LE14:
            
          begin
             
             if (smc_nextstate14 == `SMC_RW14)
               
                  if( ( ( (r_wete_store14) < r_ws_count14[1:0]) | 
                        (r_ws_count14[7:2] != 6'd0)
                      ) & 
                      (r_wele_count14 < 2'd2)
                    )
                    
                    r_full14 <= 1'b1;
                  
                  else
                    
                    r_full14 <= 1'b0;
                  
             else
               
                  r_full14 <= 1'b0;
                  
          end
          
          `SMC_RW14, `SMC_FLOAT14:
            
            begin
               
               if (smc_nextstate14 == `SMC_RW14)
                 
                 begin
                    
                    if (valid_access14)
                      
                           
                           r_full14 <= 1'b0;
                         
                    else if (smc_done14)
                      
                         if( ( ( (r_wete_store14 < r_ws_store14[1:0]) | 
                                 (r_ws_store14[7:2] != 6'd0)
                               ) & 
                               (r_wele_store14 == 2'd0)
                             )
                           )
                           
                           r_full14 <= 1'b1;
                         
                         else
                           
                           r_full14 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store14 == 2'd3)
                           
                           if( ( (r_ws_count14[7:0] > 8'd4)
                               ) & 
                               (r_wele_count14 < 2'd2)
                             )
                             
                             r_full14 <= 1'b1;
                         
                           else
                             
                             r_full14 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store14 + 2'd1) < 
                                         r_ws_count14[1:0]
                                       )
                                     ) |
                                     (r_ws_count14[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count14 < 2'd2)
                                 )
                           
                           r_full14 <= 1'b1;
                         
                         else
                           
                           r_full14 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full14 <= 1'b0;
               
            end
             
             `SMC_STORE14:
               
               begin
                  
                  if (smc_nextstate14 == `SMC_RW14)

                     if ( ( ( (r_wete_store14) < r_ws_count14[1:0]) | 
                            (r_ws_count14[7:2] != 6'd0)
                          ) & 
                          (r_wele_count14 == 2'd0)
                        )
                         
                         r_full14 <= 1'b1;
                       
                       else
                         
                         r_full14 <= 1'b0;
                       
                  else
                    
                       r_full14 <= 1'b0;
                       
               end
             
             default:
               
                  r_full14 <= 1'b0;
                  
           endcase // r_smc_currentstate14
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate14 Read Strobe14
//----------------------------------------------------------------------
 
  always @(posedge sys_clk14 or negedge n_sys_reset14)
  
  begin
     
     if (~n_sys_reset14)
  
        smc_n_rd14 <= 1'h1;
      
      
     else if (smc_nextstate14 == `SMC_RW14)
  
     begin
  
        if (valid_access14)
  
        begin
  
  
              smc_n_rd14 <= n_read14;
  
  
        end
  
        else if ((r_smc_currentstate14 == `SMC_LE14) | 
                    (r_smc_currentstate14 == `SMC_STORE14))

        begin
           
           if( (r_oete_store14 < r_ws_store14[1:0]) | 
               (r_ws_store14[7:2] != 6'd0) |
               ( (r_oete_store14 == r_ws_store14[1:0]) & 
                 (r_ws_store14[7:2] == 6'd0)
               ) |
               (r_ws_store14 == 8'd0) 
             )
             
             smc_n_rd14 <= n_r_read14;
           
           else
             
             smc_n_rd14 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store14) < r_ws_count14[1:0]) | 
               (r_ws_count14[7:2] != 6'd0) |
               (r_ws_count14 == 8'd0) 
             )
             
              smc_n_rd14 <= n_r_read14;
           
           else

              smc_n_rd14 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd14 <= 1'b1;
     
  end
   
   
 
endmodule


