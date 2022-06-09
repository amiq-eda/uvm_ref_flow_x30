//File5 name   : smc_strobe_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`include "smc_defs_lite5.v"

module smc_strobe_lite5  (

                    //inputs5

                    sys_clk5,
                    n_sys_reset5,
                    valid_access5,
                    n_read5,
                    cs,
                    r_smc_currentstate5,
                    smc_nextstate5,
                    n_be5,
                    r_wele_count5,
                    r_wele_store5,
                    r_wete_store5,
                    r_oete_store5,
                    r_ws_count5,
                    r_ws_store5,
                    smc_done5,
                    mac_done5,

                    //outputs5

                    smc_n_rd5,
                    smc_n_ext_oe5,
                    smc_busy5,
                    n_r_read5,
                    r_cs5,
                    r_full5,
                    n_r_we5,
                    n_r_wr5);



//Parameters5  -  Values5 in smc_defs5.v

 


// I5/O5

   input                   sys_clk5;      //System5 clock5
   input                   n_sys_reset5;  //System5 reset (Active5 LOW5)
   input                   valid_access5; //load5 values are valid if high5
   input                   n_read5;       //Active5 low5 read signal5
   input              cs;           //registered chip5 select5
   input [4:0]             r_smc_currentstate5;//current state
   input [4:0]             smc_nextstate5;//next state  
   input [3:0]             n_be5;         //Unregistered5 Byte5 strobes5
   input [1:0]             r_wele_count5; //Write counter
   input [1:0]             r_wete_store5; //write strobe5 trailing5 edge store5
   input [1:0]             r_oete_store5; //read strobe5
   input [1:0]             r_wele_store5; //write strobe5 leading5 edge store5
   input [7:0]             r_ws_count5;   //wait state count
   input [7:0]             r_ws_store5;   //wait state store5
   input                   smc_done5;  //one access completed
   input                   mac_done5;  //All cycles5 in a multiple access
   
   
   output                  smc_n_rd5;     // EMI5 read stobe5 (Active5 LOW5)
   output                  smc_n_ext_oe5; // Enable5 External5 bus drivers5.
                                                          //  (CS5 & ~RD5)
   output                  smc_busy5;  // smc5 busy
   output                  n_r_read5;  // Store5 RW strobe5 for multiple
                                                         //  accesses
   output                  r_full5;    // Full cycle write strobe5
   output [3:0]            n_r_we5;    // write enable strobe5(active low5)
   output                  n_r_wr5;    // write strobe5(active low5)
   output             r_cs5;      // registered chip5 select5.   


// Output5 register declarations5

   reg                     smc_n_rd5;
   reg                     smc_n_ext_oe5;
   reg                r_cs5;
   reg                     smc_busy5;
   reg                     n_r_read5;
   reg                     r_full5;
   reg   [3:0]             n_r_we5;
   reg                     n_r_wr5;

   //wire declarations5
   
   wire             smc_mac_done5;       //smc_done5 and  mac_done5 anded5
   wire [2:0]       wait_vaccess_smdone5;//concatenated5 signals5 for case
   reg              half_cycle5;         //used for generating5 half5 cycle
                                                //strobes5
   


//----------------------------------------------------------------------
// Strobe5 Generation5
//
// Individual Write Strobes5
// Write Strobe5 = Byte5 Enable5 & Write Enable5
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal5 concatenation5 for use in case statement5
//----------------------------------------------------------------------

   assign smc_mac_done5 = {smc_done5 & mac_done5};

   assign wait_vaccess_smdone5 = {1'b0,valid_access5,smc_mac_done5};
   
   
//----------------------------------------------------------------------
// Store5 read/write signal5 for duration5 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk5 or negedge n_sys_reset5)
  
     begin
  
        if (~n_sys_reset5)
  
           n_r_read5 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone5)
               
               3'b1xx:
                 
                  n_r_read5 <= n_r_read5;
               
               3'b01x:
                 
                  n_r_read5 <= n_read5;
               
               3'b001:
                 
                  n_r_read5 <= 0;
               
               default:
                 
                  n_r_read5 <= n_r_read5;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store5 chip5 selects5 for duration5 of cycle(s)--turnaround5 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store5 read/write signal5 for duration5 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk5 or negedge n_sys_reset5)
     
      begin
           
         if (~n_sys_reset5)
           
           r_cs5 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone5)
                
                 3'b1xx:
                  
                    r_cs5 <= r_cs5 ;
                
                 3'b01x:
                  
                    r_cs5 <= cs ;
                
                 3'b001:
                  
                    r_cs5 <= 1'b0;
                
                 default:
                  
                    r_cs5 <= r_cs5 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive5 busy output whenever5 smc5 active
//----------------------------------------------------------------------

   always @(posedge sys_clk5 or negedge n_sys_reset5)
     
      begin
          
         if (~n_sys_reset5)
           
            smc_busy5 <= 0;
           
           
         else if (smc_nextstate5 != `SMC_IDLE5)
           
            smc_busy5 <= 1;
           
         else
           
            smc_busy5 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive5 OE5 signal5 to I5/O5 pins5 on ASIC5
//
// Generate5 internal, registered Write strobes5
// The write strobes5 are gated5 with the clock5 later5 to generate half5 
// cycle strobes5
//----------------------------------------------------------------------

  always @(posedge sys_clk5 or negedge n_sys_reset5)
    
     begin
       
        if (~n_sys_reset5)
         
           begin
            
              n_r_we5 <= 4'hF;
              n_r_wr5 <= 1'h1;
            
           end
       

        else if ((n_read5 & valid_access5 & 
                  (smc_nextstate5 != `SMC_STORE5)) |
                 (n_r_read5 & ~valid_access5 & 
                  (smc_nextstate5 != `SMC_STORE5)))      
         
           begin
            
              n_r_we5 <= n_be5;
              n_r_wr5 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we5 <= 4'hF;
              n_r_wr5 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive5 OE5 signal5 to I5/O5 pins5 on ASIC5 -----added by gulbir5
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk5 or negedge n_sys_reset5)
     
     begin
        
        if (~n_sys_reset5)
          
          smc_n_ext_oe5 <= 1;
        
        
        else if ((n_read5 & valid_access5 & 
                  (smc_nextstate5 != `SMC_STORE5)) |
                (n_r_read5 & ~valid_access5 & 
              (smc_nextstate5 != `SMC_STORE5) & 
                 (smc_nextstate5 != `SMC_IDLE5)))      

           smc_n_ext_oe5 <= 0;
        
        else
          
           smc_n_ext_oe5 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate5 half5 and full signals5 for write strobes5
// A full cycle is required5 if wait states5 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate5 half5 cycle signals5 for write strobes5
//----------------------------------------------------------------------

always @(r_smc_currentstate5 or smc_nextstate5 or
            r_full5 or 
            r_wete_store5 or r_ws_store5 or r_wele_store5 or 
            r_ws_count5 or r_wele_count5 or 
            valid_access5 or smc_done5)
  
  begin     
     
       begin
          
          case (r_smc_currentstate5)
            
            `SMC_IDLE5:
              
              begin
                 
                     half_cycle5 = 1'b0;
                 
              end
            
            `SMC_LE5:
              
              begin
                 
                 if (smc_nextstate5 == `SMC_RW5)
                   
                   if( ( ( (r_wete_store5) == r_ws_count5[1:0]) &
                         (r_ws_count5[7:2] == 6'd0) &
                         (r_wele_count5 < 2'd2)
                       ) |
                       (r_ws_count5 == 8'd0)
                     )
                     
                     half_cycle5 = 1'b1 & ~r_full5;
                 
                   else
                     
                     half_cycle5 = 1'b0;
                 
                 else
                   
                   half_cycle5 = 1'b0;
                 
              end
            
            `SMC_RW5, `SMC_FLOAT5:
              
              begin
                 
                 if (smc_nextstate5 == `SMC_RW5)
                   
                   if (valid_access5)

                       
                       half_cycle5 = 1'b0;
                 
                   else if (smc_done5)
                     
                     if( ( (r_wete_store5 == r_ws_store5[1:0]) & 
                           (r_ws_store5[7:2] == 6'd0) & 
                           (r_wele_store5 == 2'd0)
                         ) | 
                         (r_ws_store5 == 8'd0)
                       )
                       
                       half_cycle5 = 1'b1 & ~r_full5;
                 
                     else
                       
                       half_cycle5 = 1'b0;
                 
                   else
                     
                     if (r_wete_store5 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count5[1:0]) & 
                            (r_ws_count5[7:2] == 6'd1) &
                            (r_wele_count5 < 2'd2)
                          )
                         
                         half_cycle5 = 1'b1 & ~r_full5;
                 
                       else
                         
                         half_cycle5 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store5+2'd1) == r_ws_count5[1:0]) & 
                              (r_ws_count5[7:2] == 6'd0) & 
                              (r_wele_count5 < 2'd2)
                            )
                          )
                         
                         half_cycle5 = 1'b1 & ~r_full5;
                 
                       else
                         
                         half_cycle5 = 1'b0;
                 
                 else
                   
                   half_cycle5 = 1'b0;
                 
              end
            
            `SMC_STORE5:
              
              begin
                 
                 if (smc_nextstate5 == `SMC_RW5)

                   if( ( ( (r_wete_store5) == r_ws_count5[1:0]) & 
                         (r_ws_count5[7:2] == 6'd0) & 
                         (r_wele_count5 < 2'd2)
                       ) | 
                       (r_ws_count5 == 8'd0)
                     )
                     
                     half_cycle5 = 1'b1 & ~r_full5;
                 
                   else
                     
                     half_cycle5 = 1'b0;
                 
                 else
                   
                   half_cycle5 = 1'b0;
                 
              end
            
            default:
              
              half_cycle5 = 1'b0;
            
          endcase // r_smc_currentstate5
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal5 generation5
//----------------------------------------------------------------------

 always @(posedge sys_clk5 or negedge n_sys_reset5)
             
   begin
      
      if (~n_sys_reset5)
        
        begin
           
           r_full5 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate5)
             
             `SMC_IDLE5:
               
               begin
                  
                  if (smc_nextstate5 == `SMC_RW5)
                    
                         
                         r_full5 <= 1'b0;
                       
                  else
                        
                       r_full5 <= 1'b0;
                       
               end
             
          `SMC_LE5:
            
          begin
             
             if (smc_nextstate5 == `SMC_RW5)
               
                  if( ( ( (r_wete_store5) < r_ws_count5[1:0]) | 
                        (r_ws_count5[7:2] != 6'd0)
                      ) & 
                      (r_wele_count5 < 2'd2)
                    )
                    
                    r_full5 <= 1'b1;
                  
                  else
                    
                    r_full5 <= 1'b0;
                  
             else
               
                  r_full5 <= 1'b0;
                  
          end
          
          `SMC_RW5, `SMC_FLOAT5:
            
            begin
               
               if (smc_nextstate5 == `SMC_RW5)
                 
                 begin
                    
                    if (valid_access5)
                      
                           
                           r_full5 <= 1'b0;
                         
                    else if (smc_done5)
                      
                         if( ( ( (r_wete_store5 < r_ws_store5[1:0]) | 
                                 (r_ws_store5[7:2] != 6'd0)
                               ) & 
                               (r_wele_store5 == 2'd0)
                             )
                           )
                           
                           r_full5 <= 1'b1;
                         
                         else
                           
                           r_full5 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store5 == 2'd3)
                           
                           if( ( (r_ws_count5[7:0] > 8'd4)
                               ) & 
                               (r_wele_count5 < 2'd2)
                             )
                             
                             r_full5 <= 1'b1;
                         
                           else
                             
                             r_full5 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store5 + 2'd1) < 
                                         r_ws_count5[1:0]
                                       )
                                     ) |
                                     (r_ws_count5[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count5 < 2'd2)
                                 )
                           
                           r_full5 <= 1'b1;
                         
                         else
                           
                           r_full5 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full5 <= 1'b0;
               
            end
             
             `SMC_STORE5:
               
               begin
                  
                  if (smc_nextstate5 == `SMC_RW5)

                     if ( ( ( (r_wete_store5) < r_ws_count5[1:0]) | 
                            (r_ws_count5[7:2] != 6'd0)
                          ) & 
                          (r_wele_count5 == 2'd0)
                        )
                         
                         r_full5 <= 1'b1;
                       
                       else
                         
                         r_full5 <= 1'b0;
                       
                  else
                    
                       r_full5 <= 1'b0;
                       
               end
             
             default:
               
                  r_full5 <= 1'b0;
                  
           endcase // r_smc_currentstate5
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate5 Read Strobe5
//----------------------------------------------------------------------
 
  always @(posedge sys_clk5 or negedge n_sys_reset5)
  
  begin
     
     if (~n_sys_reset5)
  
        smc_n_rd5 <= 1'h1;
      
      
     else if (smc_nextstate5 == `SMC_RW5)
  
     begin
  
        if (valid_access5)
  
        begin
  
  
              smc_n_rd5 <= n_read5;
  
  
        end
  
        else if ((r_smc_currentstate5 == `SMC_LE5) | 
                    (r_smc_currentstate5 == `SMC_STORE5))

        begin
           
           if( (r_oete_store5 < r_ws_store5[1:0]) | 
               (r_ws_store5[7:2] != 6'd0) |
               ( (r_oete_store5 == r_ws_store5[1:0]) & 
                 (r_ws_store5[7:2] == 6'd0)
               ) |
               (r_ws_store5 == 8'd0) 
             )
             
             smc_n_rd5 <= n_r_read5;
           
           else
             
             smc_n_rd5 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store5) < r_ws_count5[1:0]) | 
               (r_ws_count5[7:2] != 6'd0) |
               (r_ws_count5 == 8'd0) 
             )
             
              smc_n_rd5 <= n_r_read5;
           
           else

              smc_n_rd5 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd5 <= 1'b1;
     
  end
   
   
 
endmodule


