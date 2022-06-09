//File4 name   : smc_strobe_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`include "smc_defs_lite4.v"

module smc_strobe_lite4  (

                    //inputs4

                    sys_clk4,
                    n_sys_reset4,
                    valid_access4,
                    n_read4,
                    cs,
                    r_smc_currentstate4,
                    smc_nextstate4,
                    n_be4,
                    r_wele_count4,
                    r_wele_store4,
                    r_wete_store4,
                    r_oete_store4,
                    r_ws_count4,
                    r_ws_store4,
                    smc_done4,
                    mac_done4,

                    //outputs4

                    smc_n_rd4,
                    smc_n_ext_oe4,
                    smc_busy4,
                    n_r_read4,
                    r_cs4,
                    r_full4,
                    n_r_we4,
                    n_r_wr4);



//Parameters4  -  Values4 in smc_defs4.v

 


// I4/O4

   input                   sys_clk4;      //System4 clock4
   input                   n_sys_reset4;  //System4 reset (Active4 LOW4)
   input                   valid_access4; //load4 values are valid if high4
   input                   n_read4;       //Active4 low4 read signal4
   input              cs;           //registered chip4 select4
   input [4:0]             r_smc_currentstate4;//current state
   input [4:0]             smc_nextstate4;//next state  
   input [3:0]             n_be4;         //Unregistered4 Byte4 strobes4
   input [1:0]             r_wele_count4; //Write counter
   input [1:0]             r_wete_store4; //write strobe4 trailing4 edge store4
   input [1:0]             r_oete_store4; //read strobe4
   input [1:0]             r_wele_store4; //write strobe4 leading4 edge store4
   input [7:0]             r_ws_count4;   //wait state count
   input [7:0]             r_ws_store4;   //wait state store4
   input                   smc_done4;  //one access completed
   input                   mac_done4;  //All cycles4 in a multiple access
   
   
   output                  smc_n_rd4;     // EMI4 read stobe4 (Active4 LOW4)
   output                  smc_n_ext_oe4; // Enable4 External4 bus drivers4.
                                                          //  (CS4 & ~RD4)
   output                  smc_busy4;  // smc4 busy
   output                  n_r_read4;  // Store4 RW strobe4 for multiple
                                                         //  accesses
   output                  r_full4;    // Full cycle write strobe4
   output [3:0]            n_r_we4;    // write enable strobe4(active low4)
   output                  n_r_wr4;    // write strobe4(active low4)
   output             r_cs4;      // registered chip4 select4.   


// Output4 register declarations4

   reg                     smc_n_rd4;
   reg                     smc_n_ext_oe4;
   reg                r_cs4;
   reg                     smc_busy4;
   reg                     n_r_read4;
   reg                     r_full4;
   reg   [3:0]             n_r_we4;
   reg                     n_r_wr4;

   //wire declarations4
   
   wire             smc_mac_done4;       //smc_done4 and  mac_done4 anded4
   wire [2:0]       wait_vaccess_smdone4;//concatenated4 signals4 for case
   reg              half_cycle4;         //used for generating4 half4 cycle
                                                //strobes4
   


//----------------------------------------------------------------------
// Strobe4 Generation4
//
// Individual Write Strobes4
// Write Strobe4 = Byte4 Enable4 & Write Enable4
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal4 concatenation4 for use in case statement4
//----------------------------------------------------------------------

   assign smc_mac_done4 = {smc_done4 & mac_done4};

   assign wait_vaccess_smdone4 = {1'b0,valid_access4,smc_mac_done4};
   
   
//----------------------------------------------------------------------
// Store4 read/write signal4 for duration4 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk4 or negedge n_sys_reset4)
  
     begin
  
        if (~n_sys_reset4)
  
           n_r_read4 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone4)
               
               3'b1xx:
                 
                  n_r_read4 <= n_r_read4;
               
               3'b01x:
                 
                  n_r_read4 <= n_read4;
               
               3'b001:
                 
                  n_r_read4 <= 0;
               
               default:
                 
                  n_r_read4 <= n_r_read4;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store4 chip4 selects4 for duration4 of cycle(s)--turnaround4 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store4 read/write signal4 for duration4 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk4 or negedge n_sys_reset4)
     
      begin
           
         if (~n_sys_reset4)
           
           r_cs4 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone4)
                
                 3'b1xx:
                  
                    r_cs4 <= r_cs4 ;
                
                 3'b01x:
                  
                    r_cs4 <= cs ;
                
                 3'b001:
                  
                    r_cs4 <= 1'b0;
                
                 default:
                  
                    r_cs4 <= r_cs4 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive4 busy output whenever4 smc4 active
//----------------------------------------------------------------------

   always @(posedge sys_clk4 or negedge n_sys_reset4)
     
      begin
          
         if (~n_sys_reset4)
           
            smc_busy4 <= 0;
           
           
         else if (smc_nextstate4 != `SMC_IDLE4)
           
            smc_busy4 <= 1;
           
         else
           
            smc_busy4 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive4 OE4 signal4 to I4/O4 pins4 on ASIC4
//
// Generate4 internal, registered Write strobes4
// The write strobes4 are gated4 with the clock4 later4 to generate half4 
// cycle strobes4
//----------------------------------------------------------------------

  always @(posedge sys_clk4 or negedge n_sys_reset4)
    
     begin
       
        if (~n_sys_reset4)
         
           begin
            
              n_r_we4 <= 4'hF;
              n_r_wr4 <= 1'h1;
            
           end
       

        else if ((n_read4 & valid_access4 & 
                  (smc_nextstate4 != `SMC_STORE4)) |
                 (n_r_read4 & ~valid_access4 & 
                  (smc_nextstate4 != `SMC_STORE4)))      
         
           begin
            
              n_r_we4 <= n_be4;
              n_r_wr4 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we4 <= 4'hF;
              n_r_wr4 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive4 OE4 signal4 to I4/O4 pins4 on ASIC4 -----added by gulbir4
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk4 or negedge n_sys_reset4)
     
     begin
        
        if (~n_sys_reset4)
          
          smc_n_ext_oe4 <= 1;
        
        
        else if ((n_read4 & valid_access4 & 
                  (smc_nextstate4 != `SMC_STORE4)) |
                (n_r_read4 & ~valid_access4 & 
              (smc_nextstate4 != `SMC_STORE4) & 
                 (smc_nextstate4 != `SMC_IDLE4)))      

           smc_n_ext_oe4 <= 0;
        
        else
          
           smc_n_ext_oe4 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate4 half4 and full signals4 for write strobes4
// A full cycle is required4 if wait states4 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate4 half4 cycle signals4 for write strobes4
//----------------------------------------------------------------------

always @(r_smc_currentstate4 or smc_nextstate4 or
            r_full4 or 
            r_wete_store4 or r_ws_store4 or r_wele_store4 or 
            r_ws_count4 or r_wele_count4 or 
            valid_access4 or smc_done4)
  
  begin     
     
       begin
          
          case (r_smc_currentstate4)
            
            `SMC_IDLE4:
              
              begin
                 
                     half_cycle4 = 1'b0;
                 
              end
            
            `SMC_LE4:
              
              begin
                 
                 if (smc_nextstate4 == `SMC_RW4)
                   
                   if( ( ( (r_wete_store4) == r_ws_count4[1:0]) &
                         (r_ws_count4[7:2] == 6'd0) &
                         (r_wele_count4 < 2'd2)
                       ) |
                       (r_ws_count4 == 8'd0)
                     )
                     
                     half_cycle4 = 1'b1 & ~r_full4;
                 
                   else
                     
                     half_cycle4 = 1'b0;
                 
                 else
                   
                   half_cycle4 = 1'b0;
                 
              end
            
            `SMC_RW4, `SMC_FLOAT4:
              
              begin
                 
                 if (smc_nextstate4 == `SMC_RW4)
                   
                   if (valid_access4)

                       
                       half_cycle4 = 1'b0;
                 
                   else if (smc_done4)
                     
                     if( ( (r_wete_store4 == r_ws_store4[1:0]) & 
                           (r_ws_store4[7:2] == 6'd0) & 
                           (r_wele_store4 == 2'd0)
                         ) | 
                         (r_ws_store4 == 8'd0)
                       )
                       
                       half_cycle4 = 1'b1 & ~r_full4;
                 
                     else
                       
                       half_cycle4 = 1'b0;
                 
                   else
                     
                     if (r_wete_store4 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count4[1:0]) & 
                            (r_ws_count4[7:2] == 6'd1) &
                            (r_wele_count4 < 2'd2)
                          )
                         
                         half_cycle4 = 1'b1 & ~r_full4;
                 
                       else
                         
                         half_cycle4 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store4+2'd1) == r_ws_count4[1:0]) & 
                              (r_ws_count4[7:2] == 6'd0) & 
                              (r_wele_count4 < 2'd2)
                            )
                          )
                         
                         half_cycle4 = 1'b1 & ~r_full4;
                 
                       else
                         
                         half_cycle4 = 1'b0;
                 
                 else
                   
                   half_cycle4 = 1'b0;
                 
              end
            
            `SMC_STORE4:
              
              begin
                 
                 if (smc_nextstate4 == `SMC_RW4)

                   if( ( ( (r_wete_store4) == r_ws_count4[1:0]) & 
                         (r_ws_count4[7:2] == 6'd0) & 
                         (r_wele_count4 < 2'd2)
                       ) | 
                       (r_ws_count4 == 8'd0)
                     )
                     
                     half_cycle4 = 1'b1 & ~r_full4;
                 
                   else
                     
                     half_cycle4 = 1'b0;
                 
                 else
                   
                   half_cycle4 = 1'b0;
                 
              end
            
            default:
              
              half_cycle4 = 1'b0;
            
          endcase // r_smc_currentstate4
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal4 generation4
//----------------------------------------------------------------------

 always @(posedge sys_clk4 or negedge n_sys_reset4)
             
   begin
      
      if (~n_sys_reset4)
        
        begin
           
           r_full4 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate4)
             
             `SMC_IDLE4:
               
               begin
                  
                  if (smc_nextstate4 == `SMC_RW4)
                    
                         
                         r_full4 <= 1'b0;
                       
                  else
                        
                       r_full4 <= 1'b0;
                       
               end
             
          `SMC_LE4:
            
          begin
             
             if (smc_nextstate4 == `SMC_RW4)
               
                  if( ( ( (r_wete_store4) < r_ws_count4[1:0]) | 
                        (r_ws_count4[7:2] != 6'd0)
                      ) & 
                      (r_wele_count4 < 2'd2)
                    )
                    
                    r_full4 <= 1'b1;
                  
                  else
                    
                    r_full4 <= 1'b0;
                  
             else
               
                  r_full4 <= 1'b0;
                  
          end
          
          `SMC_RW4, `SMC_FLOAT4:
            
            begin
               
               if (smc_nextstate4 == `SMC_RW4)
                 
                 begin
                    
                    if (valid_access4)
                      
                           
                           r_full4 <= 1'b0;
                         
                    else if (smc_done4)
                      
                         if( ( ( (r_wete_store4 < r_ws_store4[1:0]) | 
                                 (r_ws_store4[7:2] != 6'd0)
                               ) & 
                               (r_wele_store4 == 2'd0)
                             )
                           )
                           
                           r_full4 <= 1'b1;
                         
                         else
                           
                           r_full4 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store4 == 2'd3)
                           
                           if( ( (r_ws_count4[7:0] > 8'd4)
                               ) & 
                               (r_wele_count4 < 2'd2)
                             )
                             
                             r_full4 <= 1'b1;
                         
                           else
                             
                             r_full4 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store4 + 2'd1) < 
                                         r_ws_count4[1:0]
                                       )
                                     ) |
                                     (r_ws_count4[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count4 < 2'd2)
                                 )
                           
                           r_full4 <= 1'b1;
                         
                         else
                           
                           r_full4 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full4 <= 1'b0;
               
            end
             
             `SMC_STORE4:
               
               begin
                  
                  if (smc_nextstate4 == `SMC_RW4)

                     if ( ( ( (r_wete_store4) < r_ws_count4[1:0]) | 
                            (r_ws_count4[7:2] != 6'd0)
                          ) & 
                          (r_wele_count4 == 2'd0)
                        )
                         
                         r_full4 <= 1'b1;
                       
                       else
                         
                         r_full4 <= 1'b0;
                       
                  else
                    
                       r_full4 <= 1'b0;
                       
               end
             
             default:
               
                  r_full4 <= 1'b0;
                  
           endcase // r_smc_currentstate4
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate4 Read Strobe4
//----------------------------------------------------------------------
 
  always @(posedge sys_clk4 or negedge n_sys_reset4)
  
  begin
     
     if (~n_sys_reset4)
  
        smc_n_rd4 <= 1'h1;
      
      
     else if (smc_nextstate4 == `SMC_RW4)
  
     begin
  
        if (valid_access4)
  
        begin
  
  
              smc_n_rd4 <= n_read4;
  
  
        end
  
        else if ((r_smc_currentstate4 == `SMC_LE4) | 
                    (r_smc_currentstate4 == `SMC_STORE4))

        begin
           
           if( (r_oete_store4 < r_ws_store4[1:0]) | 
               (r_ws_store4[7:2] != 6'd0) |
               ( (r_oete_store4 == r_ws_store4[1:0]) & 
                 (r_ws_store4[7:2] == 6'd0)
               ) |
               (r_ws_store4 == 8'd0) 
             )
             
             smc_n_rd4 <= n_r_read4;
           
           else
             
             smc_n_rd4 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store4) < r_ws_count4[1:0]) | 
               (r_ws_count4[7:2] != 6'd0) |
               (r_ws_count4 == 8'd0) 
             )
             
              smc_n_rd4 <= n_r_read4;
           
           else

              smc_n_rd4 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd4 <= 1'b1;
     
  end
   
   
 
endmodule


