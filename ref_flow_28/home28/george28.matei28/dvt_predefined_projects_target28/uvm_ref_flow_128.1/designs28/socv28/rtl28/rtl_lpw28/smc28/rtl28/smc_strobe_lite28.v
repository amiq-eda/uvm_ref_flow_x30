//File28 name   : smc_strobe_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`include "smc_defs_lite28.v"

module smc_strobe_lite28  (

                    //inputs28

                    sys_clk28,
                    n_sys_reset28,
                    valid_access28,
                    n_read28,
                    cs,
                    r_smc_currentstate28,
                    smc_nextstate28,
                    n_be28,
                    r_wele_count28,
                    r_wele_store28,
                    r_wete_store28,
                    r_oete_store28,
                    r_ws_count28,
                    r_ws_store28,
                    smc_done28,
                    mac_done28,

                    //outputs28

                    smc_n_rd28,
                    smc_n_ext_oe28,
                    smc_busy28,
                    n_r_read28,
                    r_cs28,
                    r_full28,
                    n_r_we28,
                    n_r_wr28);



//Parameters28  -  Values28 in smc_defs28.v

 


// I28/O28

   input                   sys_clk28;      //System28 clock28
   input                   n_sys_reset28;  //System28 reset (Active28 LOW28)
   input                   valid_access28; //load28 values are valid if high28
   input                   n_read28;       //Active28 low28 read signal28
   input              cs;           //registered chip28 select28
   input [4:0]             r_smc_currentstate28;//current state
   input [4:0]             smc_nextstate28;//next state  
   input [3:0]             n_be28;         //Unregistered28 Byte28 strobes28
   input [1:0]             r_wele_count28; //Write counter
   input [1:0]             r_wete_store28; //write strobe28 trailing28 edge store28
   input [1:0]             r_oete_store28; //read strobe28
   input [1:0]             r_wele_store28; //write strobe28 leading28 edge store28
   input [7:0]             r_ws_count28;   //wait state count
   input [7:0]             r_ws_store28;   //wait state store28
   input                   smc_done28;  //one access completed
   input                   mac_done28;  //All cycles28 in a multiple access
   
   
   output                  smc_n_rd28;     // EMI28 read stobe28 (Active28 LOW28)
   output                  smc_n_ext_oe28; // Enable28 External28 bus drivers28.
                                                          //  (CS28 & ~RD28)
   output                  smc_busy28;  // smc28 busy
   output                  n_r_read28;  // Store28 RW strobe28 for multiple
                                                         //  accesses
   output                  r_full28;    // Full cycle write strobe28
   output [3:0]            n_r_we28;    // write enable strobe28(active low28)
   output                  n_r_wr28;    // write strobe28(active low28)
   output             r_cs28;      // registered chip28 select28.   


// Output28 register declarations28

   reg                     smc_n_rd28;
   reg                     smc_n_ext_oe28;
   reg                r_cs28;
   reg                     smc_busy28;
   reg                     n_r_read28;
   reg                     r_full28;
   reg   [3:0]             n_r_we28;
   reg                     n_r_wr28;

   //wire declarations28
   
   wire             smc_mac_done28;       //smc_done28 and  mac_done28 anded28
   wire [2:0]       wait_vaccess_smdone28;//concatenated28 signals28 for case
   reg              half_cycle28;         //used for generating28 half28 cycle
                                                //strobes28
   


//----------------------------------------------------------------------
// Strobe28 Generation28
//
// Individual Write Strobes28
// Write Strobe28 = Byte28 Enable28 & Write Enable28
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal28 concatenation28 for use in case statement28
//----------------------------------------------------------------------

   assign smc_mac_done28 = {smc_done28 & mac_done28};

   assign wait_vaccess_smdone28 = {1'b0,valid_access28,smc_mac_done28};
   
   
//----------------------------------------------------------------------
// Store28 read/write signal28 for duration28 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk28 or negedge n_sys_reset28)
  
     begin
  
        if (~n_sys_reset28)
  
           n_r_read28 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone28)
               
               3'b1xx:
                 
                  n_r_read28 <= n_r_read28;
               
               3'b01x:
                 
                  n_r_read28 <= n_read28;
               
               3'b001:
                 
                  n_r_read28 <= 0;
               
               default:
                 
                  n_r_read28 <= n_r_read28;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store28 chip28 selects28 for duration28 of cycle(s)--turnaround28 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store28 read/write signal28 for duration28 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk28 or negedge n_sys_reset28)
     
      begin
           
         if (~n_sys_reset28)
           
           r_cs28 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone28)
                
                 3'b1xx:
                  
                    r_cs28 <= r_cs28 ;
                
                 3'b01x:
                  
                    r_cs28 <= cs ;
                
                 3'b001:
                  
                    r_cs28 <= 1'b0;
                
                 default:
                  
                    r_cs28 <= r_cs28 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive28 busy output whenever28 smc28 active
//----------------------------------------------------------------------

   always @(posedge sys_clk28 or negedge n_sys_reset28)
     
      begin
          
         if (~n_sys_reset28)
           
            smc_busy28 <= 0;
           
           
         else if (smc_nextstate28 != `SMC_IDLE28)
           
            smc_busy28 <= 1;
           
         else
           
            smc_busy28 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive28 OE28 signal28 to I28/O28 pins28 on ASIC28
//
// Generate28 internal, registered Write strobes28
// The write strobes28 are gated28 with the clock28 later28 to generate half28 
// cycle strobes28
//----------------------------------------------------------------------

  always @(posedge sys_clk28 or negedge n_sys_reset28)
    
     begin
       
        if (~n_sys_reset28)
         
           begin
            
              n_r_we28 <= 4'hF;
              n_r_wr28 <= 1'h1;
            
           end
       

        else if ((n_read28 & valid_access28 & 
                  (smc_nextstate28 != `SMC_STORE28)) |
                 (n_r_read28 & ~valid_access28 & 
                  (smc_nextstate28 != `SMC_STORE28)))      
         
           begin
            
              n_r_we28 <= n_be28;
              n_r_wr28 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we28 <= 4'hF;
              n_r_wr28 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive28 OE28 signal28 to I28/O28 pins28 on ASIC28 -----added by gulbir28
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk28 or negedge n_sys_reset28)
     
     begin
        
        if (~n_sys_reset28)
          
          smc_n_ext_oe28 <= 1;
        
        
        else if ((n_read28 & valid_access28 & 
                  (smc_nextstate28 != `SMC_STORE28)) |
                (n_r_read28 & ~valid_access28 & 
              (smc_nextstate28 != `SMC_STORE28) & 
                 (smc_nextstate28 != `SMC_IDLE28)))      

           smc_n_ext_oe28 <= 0;
        
        else
          
           smc_n_ext_oe28 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate28 half28 and full signals28 for write strobes28
// A full cycle is required28 if wait states28 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate28 half28 cycle signals28 for write strobes28
//----------------------------------------------------------------------

always @(r_smc_currentstate28 or smc_nextstate28 or
            r_full28 or 
            r_wete_store28 or r_ws_store28 or r_wele_store28 or 
            r_ws_count28 or r_wele_count28 or 
            valid_access28 or smc_done28)
  
  begin     
     
       begin
          
          case (r_smc_currentstate28)
            
            `SMC_IDLE28:
              
              begin
                 
                     half_cycle28 = 1'b0;
                 
              end
            
            `SMC_LE28:
              
              begin
                 
                 if (smc_nextstate28 == `SMC_RW28)
                   
                   if( ( ( (r_wete_store28) == r_ws_count28[1:0]) &
                         (r_ws_count28[7:2] == 6'd0) &
                         (r_wele_count28 < 2'd2)
                       ) |
                       (r_ws_count28 == 8'd0)
                     )
                     
                     half_cycle28 = 1'b1 & ~r_full28;
                 
                   else
                     
                     half_cycle28 = 1'b0;
                 
                 else
                   
                   half_cycle28 = 1'b0;
                 
              end
            
            `SMC_RW28, `SMC_FLOAT28:
              
              begin
                 
                 if (smc_nextstate28 == `SMC_RW28)
                   
                   if (valid_access28)

                       
                       half_cycle28 = 1'b0;
                 
                   else if (smc_done28)
                     
                     if( ( (r_wete_store28 == r_ws_store28[1:0]) & 
                           (r_ws_store28[7:2] == 6'd0) & 
                           (r_wele_store28 == 2'd0)
                         ) | 
                         (r_ws_store28 == 8'd0)
                       )
                       
                       half_cycle28 = 1'b1 & ~r_full28;
                 
                     else
                       
                       half_cycle28 = 1'b0;
                 
                   else
                     
                     if (r_wete_store28 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count28[1:0]) & 
                            (r_ws_count28[7:2] == 6'd1) &
                            (r_wele_count28 < 2'd2)
                          )
                         
                         half_cycle28 = 1'b1 & ~r_full28;
                 
                       else
                         
                         half_cycle28 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store28+2'd1) == r_ws_count28[1:0]) & 
                              (r_ws_count28[7:2] == 6'd0) & 
                              (r_wele_count28 < 2'd2)
                            )
                          )
                         
                         half_cycle28 = 1'b1 & ~r_full28;
                 
                       else
                         
                         half_cycle28 = 1'b0;
                 
                 else
                   
                   half_cycle28 = 1'b0;
                 
              end
            
            `SMC_STORE28:
              
              begin
                 
                 if (smc_nextstate28 == `SMC_RW28)

                   if( ( ( (r_wete_store28) == r_ws_count28[1:0]) & 
                         (r_ws_count28[7:2] == 6'd0) & 
                         (r_wele_count28 < 2'd2)
                       ) | 
                       (r_ws_count28 == 8'd0)
                     )
                     
                     half_cycle28 = 1'b1 & ~r_full28;
                 
                   else
                     
                     half_cycle28 = 1'b0;
                 
                 else
                   
                   half_cycle28 = 1'b0;
                 
              end
            
            default:
              
              half_cycle28 = 1'b0;
            
          endcase // r_smc_currentstate28
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal28 generation28
//----------------------------------------------------------------------

 always @(posedge sys_clk28 or negedge n_sys_reset28)
             
   begin
      
      if (~n_sys_reset28)
        
        begin
           
           r_full28 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate28)
             
             `SMC_IDLE28:
               
               begin
                  
                  if (smc_nextstate28 == `SMC_RW28)
                    
                         
                         r_full28 <= 1'b0;
                       
                  else
                        
                       r_full28 <= 1'b0;
                       
               end
             
          `SMC_LE28:
            
          begin
             
             if (smc_nextstate28 == `SMC_RW28)
               
                  if( ( ( (r_wete_store28) < r_ws_count28[1:0]) | 
                        (r_ws_count28[7:2] != 6'd0)
                      ) & 
                      (r_wele_count28 < 2'd2)
                    )
                    
                    r_full28 <= 1'b1;
                  
                  else
                    
                    r_full28 <= 1'b0;
                  
             else
               
                  r_full28 <= 1'b0;
                  
          end
          
          `SMC_RW28, `SMC_FLOAT28:
            
            begin
               
               if (smc_nextstate28 == `SMC_RW28)
                 
                 begin
                    
                    if (valid_access28)
                      
                           
                           r_full28 <= 1'b0;
                         
                    else if (smc_done28)
                      
                         if( ( ( (r_wete_store28 < r_ws_store28[1:0]) | 
                                 (r_ws_store28[7:2] != 6'd0)
                               ) & 
                               (r_wele_store28 == 2'd0)
                             )
                           )
                           
                           r_full28 <= 1'b1;
                         
                         else
                           
                           r_full28 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store28 == 2'd3)
                           
                           if( ( (r_ws_count28[7:0] > 8'd4)
                               ) & 
                               (r_wele_count28 < 2'd2)
                             )
                             
                             r_full28 <= 1'b1;
                         
                           else
                             
                             r_full28 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store28 + 2'd1) < 
                                         r_ws_count28[1:0]
                                       )
                                     ) |
                                     (r_ws_count28[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count28 < 2'd2)
                                 )
                           
                           r_full28 <= 1'b1;
                         
                         else
                           
                           r_full28 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full28 <= 1'b0;
               
            end
             
             `SMC_STORE28:
               
               begin
                  
                  if (smc_nextstate28 == `SMC_RW28)

                     if ( ( ( (r_wete_store28) < r_ws_count28[1:0]) | 
                            (r_ws_count28[7:2] != 6'd0)
                          ) & 
                          (r_wele_count28 == 2'd0)
                        )
                         
                         r_full28 <= 1'b1;
                       
                       else
                         
                         r_full28 <= 1'b0;
                       
                  else
                    
                       r_full28 <= 1'b0;
                       
               end
             
             default:
               
                  r_full28 <= 1'b0;
                  
           endcase // r_smc_currentstate28
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate28 Read Strobe28
//----------------------------------------------------------------------
 
  always @(posedge sys_clk28 or negedge n_sys_reset28)
  
  begin
     
     if (~n_sys_reset28)
  
        smc_n_rd28 <= 1'h1;
      
      
     else if (smc_nextstate28 == `SMC_RW28)
  
     begin
  
        if (valid_access28)
  
        begin
  
  
              smc_n_rd28 <= n_read28;
  
  
        end
  
        else if ((r_smc_currentstate28 == `SMC_LE28) | 
                    (r_smc_currentstate28 == `SMC_STORE28))

        begin
           
           if( (r_oete_store28 < r_ws_store28[1:0]) | 
               (r_ws_store28[7:2] != 6'd0) |
               ( (r_oete_store28 == r_ws_store28[1:0]) & 
                 (r_ws_store28[7:2] == 6'd0)
               ) |
               (r_ws_store28 == 8'd0) 
             )
             
             smc_n_rd28 <= n_r_read28;
           
           else
             
             smc_n_rd28 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store28) < r_ws_count28[1:0]) | 
               (r_ws_count28[7:2] != 6'd0) |
               (r_ws_count28 == 8'd0) 
             )
             
              smc_n_rd28 <= n_r_read28;
           
           else

              smc_n_rd28 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd28 <= 1'b1;
     
  end
   
   
 
endmodule


