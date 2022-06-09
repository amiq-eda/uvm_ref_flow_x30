//File11 name   : smc_strobe_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`include "smc_defs_lite11.v"

module smc_strobe_lite11  (

                    //inputs11

                    sys_clk11,
                    n_sys_reset11,
                    valid_access11,
                    n_read11,
                    cs,
                    r_smc_currentstate11,
                    smc_nextstate11,
                    n_be11,
                    r_wele_count11,
                    r_wele_store11,
                    r_wete_store11,
                    r_oete_store11,
                    r_ws_count11,
                    r_ws_store11,
                    smc_done11,
                    mac_done11,

                    //outputs11

                    smc_n_rd11,
                    smc_n_ext_oe11,
                    smc_busy11,
                    n_r_read11,
                    r_cs11,
                    r_full11,
                    n_r_we11,
                    n_r_wr11);



//Parameters11  -  Values11 in smc_defs11.v

 


// I11/O11

   input                   sys_clk11;      //System11 clock11
   input                   n_sys_reset11;  //System11 reset (Active11 LOW11)
   input                   valid_access11; //load11 values are valid if high11
   input                   n_read11;       //Active11 low11 read signal11
   input              cs;           //registered chip11 select11
   input [4:0]             r_smc_currentstate11;//current state
   input [4:0]             smc_nextstate11;//next state  
   input [3:0]             n_be11;         //Unregistered11 Byte11 strobes11
   input [1:0]             r_wele_count11; //Write counter
   input [1:0]             r_wete_store11; //write strobe11 trailing11 edge store11
   input [1:0]             r_oete_store11; //read strobe11
   input [1:0]             r_wele_store11; //write strobe11 leading11 edge store11
   input [7:0]             r_ws_count11;   //wait state count
   input [7:0]             r_ws_store11;   //wait state store11
   input                   smc_done11;  //one access completed
   input                   mac_done11;  //All cycles11 in a multiple access
   
   
   output                  smc_n_rd11;     // EMI11 read stobe11 (Active11 LOW11)
   output                  smc_n_ext_oe11; // Enable11 External11 bus drivers11.
                                                          //  (CS11 & ~RD11)
   output                  smc_busy11;  // smc11 busy
   output                  n_r_read11;  // Store11 RW strobe11 for multiple
                                                         //  accesses
   output                  r_full11;    // Full cycle write strobe11
   output [3:0]            n_r_we11;    // write enable strobe11(active low11)
   output                  n_r_wr11;    // write strobe11(active low11)
   output             r_cs11;      // registered chip11 select11.   


// Output11 register declarations11

   reg                     smc_n_rd11;
   reg                     smc_n_ext_oe11;
   reg                r_cs11;
   reg                     smc_busy11;
   reg                     n_r_read11;
   reg                     r_full11;
   reg   [3:0]             n_r_we11;
   reg                     n_r_wr11;

   //wire declarations11
   
   wire             smc_mac_done11;       //smc_done11 and  mac_done11 anded11
   wire [2:0]       wait_vaccess_smdone11;//concatenated11 signals11 for case
   reg              half_cycle11;         //used for generating11 half11 cycle
                                                //strobes11
   


//----------------------------------------------------------------------
// Strobe11 Generation11
//
// Individual Write Strobes11
// Write Strobe11 = Byte11 Enable11 & Write Enable11
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal11 concatenation11 for use in case statement11
//----------------------------------------------------------------------

   assign smc_mac_done11 = {smc_done11 & mac_done11};

   assign wait_vaccess_smdone11 = {1'b0,valid_access11,smc_mac_done11};
   
   
//----------------------------------------------------------------------
// Store11 read/write signal11 for duration11 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk11 or negedge n_sys_reset11)
  
     begin
  
        if (~n_sys_reset11)
  
           n_r_read11 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone11)
               
               3'b1xx:
                 
                  n_r_read11 <= n_r_read11;
               
               3'b01x:
                 
                  n_r_read11 <= n_read11;
               
               3'b001:
                 
                  n_r_read11 <= 0;
               
               default:
                 
                  n_r_read11 <= n_r_read11;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store11 chip11 selects11 for duration11 of cycle(s)--turnaround11 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store11 read/write signal11 for duration11 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk11 or negedge n_sys_reset11)
     
      begin
           
         if (~n_sys_reset11)
           
           r_cs11 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone11)
                
                 3'b1xx:
                  
                    r_cs11 <= r_cs11 ;
                
                 3'b01x:
                  
                    r_cs11 <= cs ;
                
                 3'b001:
                  
                    r_cs11 <= 1'b0;
                
                 default:
                  
                    r_cs11 <= r_cs11 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive11 busy output whenever11 smc11 active
//----------------------------------------------------------------------

   always @(posedge sys_clk11 or negedge n_sys_reset11)
     
      begin
          
         if (~n_sys_reset11)
           
            smc_busy11 <= 0;
           
           
         else if (smc_nextstate11 != `SMC_IDLE11)
           
            smc_busy11 <= 1;
           
         else
           
            smc_busy11 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive11 OE11 signal11 to I11/O11 pins11 on ASIC11
//
// Generate11 internal, registered Write strobes11
// The write strobes11 are gated11 with the clock11 later11 to generate half11 
// cycle strobes11
//----------------------------------------------------------------------

  always @(posedge sys_clk11 or negedge n_sys_reset11)
    
     begin
       
        if (~n_sys_reset11)
         
           begin
            
              n_r_we11 <= 4'hF;
              n_r_wr11 <= 1'h1;
            
           end
       

        else if ((n_read11 & valid_access11 & 
                  (smc_nextstate11 != `SMC_STORE11)) |
                 (n_r_read11 & ~valid_access11 & 
                  (smc_nextstate11 != `SMC_STORE11)))      
         
           begin
            
              n_r_we11 <= n_be11;
              n_r_wr11 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we11 <= 4'hF;
              n_r_wr11 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive11 OE11 signal11 to I11/O11 pins11 on ASIC11 -----added by gulbir11
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk11 or negedge n_sys_reset11)
     
     begin
        
        if (~n_sys_reset11)
          
          smc_n_ext_oe11 <= 1;
        
        
        else if ((n_read11 & valid_access11 & 
                  (smc_nextstate11 != `SMC_STORE11)) |
                (n_r_read11 & ~valid_access11 & 
              (smc_nextstate11 != `SMC_STORE11) & 
                 (smc_nextstate11 != `SMC_IDLE11)))      

           smc_n_ext_oe11 <= 0;
        
        else
          
           smc_n_ext_oe11 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate11 half11 and full signals11 for write strobes11
// A full cycle is required11 if wait states11 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate11 half11 cycle signals11 for write strobes11
//----------------------------------------------------------------------

always @(r_smc_currentstate11 or smc_nextstate11 or
            r_full11 or 
            r_wete_store11 or r_ws_store11 or r_wele_store11 or 
            r_ws_count11 or r_wele_count11 or 
            valid_access11 or smc_done11)
  
  begin     
     
       begin
          
          case (r_smc_currentstate11)
            
            `SMC_IDLE11:
              
              begin
                 
                     half_cycle11 = 1'b0;
                 
              end
            
            `SMC_LE11:
              
              begin
                 
                 if (smc_nextstate11 == `SMC_RW11)
                   
                   if( ( ( (r_wete_store11) == r_ws_count11[1:0]) &
                         (r_ws_count11[7:2] == 6'd0) &
                         (r_wele_count11 < 2'd2)
                       ) |
                       (r_ws_count11 == 8'd0)
                     )
                     
                     half_cycle11 = 1'b1 & ~r_full11;
                 
                   else
                     
                     half_cycle11 = 1'b0;
                 
                 else
                   
                   half_cycle11 = 1'b0;
                 
              end
            
            `SMC_RW11, `SMC_FLOAT11:
              
              begin
                 
                 if (smc_nextstate11 == `SMC_RW11)
                   
                   if (valid_access11)

                       
                       half_cycle11 = 1'b0;
                 
                   else if (smc_done11)
                     
                     if( ( (r_wete_store11 == r_ws_store11[1:0]) & 
                           (r_ws_store11[7:2] == 6'd0) & 
                           (r_wele_store11 == 2'd0)
                         ) | 
                         (r_ws_store11 == 8'd0)
                       )
                       
                       half_cycle11 = 1'b1 & ~r_full11;
                 
                     else
                       
                       half_cycle11 = 1'b0;
                 
                   else
                     
                     if (r_wete_store11 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count11[1:0]) & 
                            (r_ws_count11[7:2] == 6'd1) &
                            (r_wele_count11 < 2'd2)
                          )
                         
                         half_cycle11 = 1'b1 & ~r_full11;
                 
                       else
                         
                         half_cycle11 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store11+2'd1) == r_ws_count11[1:0]) & 
                              (r_ws_count11[7:2] == 6'd0) & 
                              (r_wele_count11 < 2'd2)
                            )
                          )
                         
                         half_cycle11 = 1'b1 & ~r_full11;
                 
                       else
                         
                         half_cycle11 = 1'b0;
                 
                 else
                   
                   half_cycle11 = 1'b0;
                 
              end
            
            `SMC_STORE11:
              
              begin
                 
                 if (smc_nextstate11 == `SMC_RW11)

                   if( ( ( (r_wete_store11) == r_ws_count11[1:0]) & 
                         (r_ws_count11[7:2] == 6'd0) & 
                         (r_wele_count11 < 2'd2)
                       ) | 
                       (r_ws_count11 == 8'd0)
                     )
                     
                     half_cycle11 = 1'b1 & ~r_full11;
                 
                   else
                     
                     half_cycle11 = 1'b0;
                 
                 else
                   
                   half_cycle11 = 1'b0;
                 
              end
            
            default:
              
              half_cycle11 = 1'b0;
            
          endcase // r_smc_currentstate11
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal11 generation11
//----------------------------------------------------------------------

 always @(posedge sys_clk11 or negedge n_sys_reset11)
             
   begin
      
      if (~n_sys_reset11)
        
        begin
           
           r_full11 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate11)
             
             `SMC_IDLE11:
               
               begin
                  
                  if (smc_nextstate11 == `SMC_RW11)
                    
                         
                         r_full11 <= 1'b0;
                       
                  else
                        
                       r_full11 <= 1'b0;
                       
               end
             
          `SMC_LE11:
            
          begin
             
             if (smc_nextstate11 == `SMC_RW11)
               
                  if( ( ( (r_wete_store11) < r_ws_count11[1:0]) | 
                        (r_ws_count11[7:2] != 6'd0)
                      ) & 
                      (r_wele_count11 < 2'd2)
                    )
                    
                    r_full11 <= 1'b1;
                  
                  else
                    
                    r_full11 <= 1'b0;
                  
             else
               
                  r_full11 <= 1'b0;
                  
          end
          
          `SMC_RW11, `SMC_FLOAT11:
            
            begin
               
               if (smc_nextstate11 == `SMC_RW11)
                 
                 begin
                    
                    if (valid_access11)
                      
                           
                           r_full11 <= 1'b0;
                         
                    else if (smc_done11)
                      
                         if( ( ( (r_wete_store11 < r_ws_store11[1:0]) | 
                                 (r_ws_store11[7:2] != 6'd0)
                               ) & 
                               (r_wele_store11 == 2'd0)
                             )
                           )
                           
                           r_full11 <= 1'b1;
                         
                         else
                           
                           r_full11 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store11 == 2'd3)
                           
                           if( ( (r_ws_count11[7:0] > 8'd4)
                               ) & 
                               (r_wele_count11 < 2'd2)
                             )
                             
                             r_full11 <= 1'b1;
                         
                           else
                             
                             r_full11 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store11 + 2'd1) < 
                                         r_ws_count11[1:0]
                                       )
                                     ) |
                                     (r_ws_count11[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count11 < 2'd2)
                                 )
                           
                           r_full11 <= 1'b1;
                         
                         else
                           
                           r_full11 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full11 <= 1'b0;
               
            end
             
             `SMC_STORE11:
               
               begin
                  
                  if (smc_nextstate11 == `SMC_RW11)

                     if ( ( ( (r_wete_store11) < r_ws_count11[1:0]) | 
                            (r_ws_count11[7:2] != 6'd0)
                          ) & 
                          (r_wele_count11 == 2'd0)
                        )
                         
                         r_full11 <= 1'b1;
                       
                       else
                         
                         r_full11 <= 1'b0;
                       
                  else
                    
                       r_full11 <= 1'b0;
                       
               end
             
             default:
               
                  r_full11 <= 1'b0;
                  
           endcase // r_smc_currentstate11
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate11 Read Strobe11
//----------------------------------------------------------------------
 
  always @(posedge sys_clk11 or negedge n_sys_reset11)
  
  begin
     
     if (~n_sys_reset11)
  
        smc_n_rd11 <= 1'h1;
      
      
     else if (smc_nextstate11 == `SMC_RW11)
  
     begin
  
        if (valid_access11)
  
        begin
  
  
              smc_n_rd11 <= n_read11;
  
  
        end
  
        else if ((r_smc_currentstate11 == `SMC_LE11) | 
                    (r_smc_currentstate11 == `SMC_STORE11))

        begin
           
           if( (r_oete_store11 < r_ws_store11[1:0]) | 
               (r_ws_store11[7:2] != 6'd0) |
               ( (r_oete_store11 == r_ws_store11[1:0]) & 
                 (r_ws_store11[7:2] == 6'd0)
               ) |
               (r_ws_store11 == 8'd0) 
             )
             
             smc_n_rd11 <= n_r_read11;
           
           else
             
             smc_n_rd11 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store11) < r_ws_count11[1:0]) | 
               (r_ws_count11[7:2] != 6'd0) |
               (r_ws_count11 == 8'd0) 
             )
             
              smc_n_rd11 <= n_r_read11;
           
           else

              smc_n_rd11 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd11 <= 1'b1;
     
  end
   
   
 
endmodule


