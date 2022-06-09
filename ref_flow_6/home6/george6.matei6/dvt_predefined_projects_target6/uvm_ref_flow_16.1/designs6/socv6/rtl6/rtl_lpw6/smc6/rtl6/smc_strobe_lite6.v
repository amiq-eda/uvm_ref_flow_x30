//File6 name   : smc_strobe_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`include "smc_defs_lite6.v"

module smc_strobe_lite6  (

                    //inputs6

                    sys_clk6,
                    n_sys_reset6,
                    valid_access6,
                    n_read6,
                    cs,
                    r_smc_currentstate6,
                    smc_nextstate6,
                    n_be6,
                    r_wele_count6,
                    r_wele_store6,
                    r_wete_store6,
                    r_oete_store6,
                    r_ws_count6,
                    r_ws_store6,
                    smc_done6,
                    mac_done6,

                    //outputs6

                    smc_n_rd6,
                    smc_n_ext_oe6,
                    smc_busy6,
                    n_r_read6,
                    r_cs6,
                    r_full6,
                    n_r_we6,
                    n_r_wr6);



//Parameters6  -  Values6 in smc_defs6.v

 


// I6/O6

   input                   sys_clk6;      //System6 clock6
   input                   n_sys_reset6;  //System6 reset (Active6 LOW6)
   input                   valid_access6; //load6 values are valid if high6
   input                   n_read6;       //Active6 low6 read signal6
   input              cs;           //registered chip6 select6
   input [4:0]             r_smc_currentstate6;//current state
   input [4:0]             smc_nextstate6;//next state  
   input [3:0]             n_be6;         //Unregistered6 Byte6 strobes6
   input [1:0]             r_wele_count6; //Write counter
   input [1:0]             r_wete_store6; //write strobe6 trailing6 edge store6
   input [1:0]             r_oete_store6; //read strobe6
   input [1:0]             r_wele_store6; //write strobe6 leading6 edge store6
   input [7:0]             r_ws_count6;   //wait state count
   input [7:0]             r_ws_store6;   //wait state store6
   input                   smc_done6;  //one access completed
   input                   mac_done6;  //All cycles6 in a multiple access
   
   
   output                  smc_n_rd6;     // EMI6 read stobe6 (Active6 LOW6)
   output                  smc_n_ext_oe6; // Enable6 External6 bus drivers6.
                                                          //  (CS6 & ~RD6)
   output                  smc_busy6;  // smc6 busy
   output                  n_r_read6;  // Store6 RW strobe6 for multiple
                                                         //  accesses
   output                  r_full6;    // Full cycle write strobe6
   output [3:0]            n_r_we6;    // write enable strobe6(active low6)
   output                  n_r_wr6;    // write strobe6(active low6)
   output             r_cs6;      // registered chip6 select6.   


// Output6 register declarations6

   reg                     smc_n_rd6;
   reg                     smc_n_ext_oe6;
   reg                r_cs6;
   reg                     smc_busy6;
   reg                     n_r_read6;
   reg                     r_full6;
   reg   [3:0]             n_r_we6;
   reg                     n_r_wr6;

   //wire declarations6
   
   wire             smc_mac_done6;       //smc_done6 and  mac_done6 anded6
   wire [2:0]       wait_vaccess_smdone6;//concatenated6 signals6 for case
   reg              half_cycle6;         //used for generating6 half6 cycle
                                                //strobes6
   


//----------------------------------------------------------------------
// Strobe6 Generation6
//
// Individual Write Strobes6
// Write Strobe6 = Byte6 Enable6 & Write Enable6
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal6 concatenation6 for use in case statement6
//----------------------------------------------------------------------

   assign smc_mac_done6 = {smc_done6 & mac_done6};

   assign wait_vaccess_smdone6 = {1'b0,valid_access6,smc_mac_done6};
   
   
//----------------------------------------------------------------------
// Store6 read/write signal6 for duration6 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk6 or negedge n_sys_reset6)
  
     begin
  
        if (~n_sys_reset6)
  
           n_r_read6 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone6)
               
               3'b1xx:
                 
                  n_r_read6 <= n_r_read6;
               
               3'b01x:
                 
                  n_r_read6 <= n_read6;
               
               3'b001:
                 
                  n_r_read6 <= 0;
               
               default:
                 
                  n_r_read6 <= n_r_read6;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store6 chip6 selects6 for duration6 of cycle(s)--turnaround6 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store6 read/write signal6 for duration6 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk6 or negedge n_sys_reset6)
     
      begin
           
         if (~n_sys_reset6)
           
           r_cs6 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone6)
                
                 3'b1xx:
                  
                    r_cs6 <= r_cs6 ;
                
                 3'b01x:
                  
                    r_cs6 <= cs ;
                
                 3'b001:
                  
                    r_cs6 <= 1'b0;
                
                 default:
                  
                    r_cs6 <= r_cs6 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive6 busy output whenever6 smc6 active
//----------------------------------------------------------------------

   always @(posedge sys_clk6 or negedge n_sys_reset6)
     
      begin
          
         if (~n_sys_reset6)
           
            smc_busy6 <= 0;
           
           
         else if (smc_nextstate6 != `SMC_IDLE6)
           
            smc_busy6 <= 1;
           
         else
           
            smc_busy6 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive6 OE6 signal6 to I6/O6 pins6 on ASIC6
//
// Generate6 internal, registered Write strobes6
// The write strobes6 are gated6 with the clock6 later6 to generate half6 
// cycle strobes6
//----------------------------------------------------------------------

  always @(posedge sys_clk6 or negedge n_sys_reset6)
    
     begin
       
        if (~n_sys_reset6)
         
           begin
            
              n_r_we6 <= 4'hF;
              n_r_wr6 <= 1'h1;
            
           end
       

        else if ((n_read6 & valid_access6 & 
                  (smc_nextstate6 != `SMC_STORE6)) |
                 (n_r_read6 & ~valid_access6 & 
                  (smc_nextstate6 != `SMC_STORE6)))      
         
           begin
            
              n_r_we6 <= n_be6;
              n_r_wr6 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we6 <= 4'hF;
              n_r_wr6 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive6 OE6 signal6 to I6/O6 pins6 on ASIC6 -----added by gulbir6
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk6 or negedge n_sys_reset6)
     
     begin
        
        if (~n_sys_reset6)
          
          smc_n_ext_oe6 <= 1;
        
        
        else if ((n_read6 & valid_access6 & 
                  (smc_nextstate6 != `SMC_STORE6)) |
                (n_r_read6 & ~valid_access6 & 
              (smc_nextstate6 != `SMC_STORE6) & 
                 (smc_nextstate6 != `SMC_IDLE6)))      

           smc_n_ext_oe6 <= 0;
        
        else
          
           smc_n_ext_oe6 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate6 half6 and full signals6 for write strobes6
// A full cycle is required6 if wait states6 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate6 half6 cycle signals6 for write strobes6
//----------------------------------------------------------------------

always @(r_smc_currentstate6 or smc_nextstate6 or
            r_full6 or 
            r_wete_store6 or r_ws_store6 or r_wele_store6 or 
            r_ws_count6 or r_wele_count6 or 
            valid_access6 or smc_done6)
  
  begin     
     
       begin
          
          case (r_smc_currentstate6)
            
            `SMC_IDLE6:
              
              begin
                 
                     half_cycle6 = 1'b0;
                 
              end
            
            `SMC_LE6:
              
              begin
                 
                 if (smc_nextstate6 == `SMC_RW6)
                   
                   if( ( ( (r_wete_store6) == r_ws_count6[1:0]) &
                         (r_ws_count6[7:2] == 6'd0) &
                         (r_wele_count6 < 2'd2)
                       ) |
                       (r_ws_count6 == 8'd0)
                     )
                     
                     half_cycle6 = 1'b1 & ~r_full6;
                 
                   else
                     
                     half_cycle6 = 1'b0;
                 
                 else
                   
                   half_cycle6 = 1'b0;
                 
              end
            
            `SMC_RW6, `SMC_FLOAT6:
              
              begin
                 
                 if (smc_nextstate6 == `SMC_RW6)
                   
                   if (valid_access6)

                       
                       half_cycle6 = 1'b0;
                 
                   else if (smc_done6)
                     
                     if( ( (r_wete_store6 == r_ws_store6[1:0]) & 
                           (r_ws_store6[7:2] == 6'd0) & 
                           (r_wele_store6 == 2'd0)
                         ) | 
                         (r_ws_store6 == 8'd0)
                       )
                       
                       half_cycle6 = 1'b1 & ~r_full6;
                 
                     else
                       
                       half_cycle6 = 1'b0;
                 
                   else
                     
                     if (r_wete_store6 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count6[1:0]) & 
                            (r_ws_count6[7:2] == 6'd1) &
                            (r_wele_count6 < 2'd2)
                          )
                         
                         half_cycle6 = 1'b1 & ~r_full6;
                 
                       else
                         
                         half_cycle6 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store6+2'd1) == r_ws_count6[1:0]) & 
                              (r_ws_count6[7:2] == 6'd0) & 
                              (r_wele_count6 < 2'd2)
                            )
                          )
                         
                         half_cycle6 = 1'b1 & ~r_full6;
                 
                       else
                         
                         half_cycle6 = 1'b0;
                 
                 else
                   
                   half_cycle6 = 1'b0;
                 
              end
            
            `SMC_STORE6:
              
              begin
                 
                 if (smc_nextstate6 == `SMC_RW6)

                   if( ( ( (r_wete_store6) == r_ws_count6[1:0]) & 
                         (r_ws_count6[7:2] == 6'd0) & 
                         (r_wele_count6 < 2'd2)
                       ) | 
                       (r_ws_count6 == 8'd0)
                     )
                     
                     half_cycle6 = 1'b1 & ~r_full6;
                 
                   else
                     
                     half_cycle6 = 1'b0;
                 
                 else
                   
                   half_cycle6 = 1'b0;
                 
              end
            
            default:
              
              half_cycle6 = 1'b0;
            
          endcase // r_smc_currentstate6
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal6 generation6
//----------------------------------------------------------------------

 always @(posedge sys_clk6 or negedge n_sys_reset6)
             
   begin
      
      if (~n_sys_reset6)
        
        begin
           
           r_full6 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate6)
             
             `SMC_IDLE6:
               
               begin
                  
                  if (smc_nextstate6 == `SMC_RW6)
                    
                         
                         r_full6 <= 1'b0;
                       
                  else
                        
                       r_full6 <= 1'b0;
                       
               end
             
          `SMC_LE6:
            
          begin
             
             if (smc_nextstate6 == `SMC_RW6)
               
                  if( ( ( (r_wete_store6) < r_ws_count6[1:0]) | 
                        (r_ws_count6[7:2] != 6'd0)
                      ) & 
                      (r_wele_count6 < 2'd2)
                    )
                    
                    r_full6 <= 1'b1;
                  
                  else
                    
                    r_full6 <= 1'b0;
                  
             else
               
                  r_full6 <= 1'b0;
                  
          end
          
          `SMC_RW6, `SMC_FLOAT6:
            
            begin
               
               if (smc_nextstate6 == `SMC_RW6)
                 
                 begin
                    
                    if (valid_access6)
                      
                           
                           r_full6 <= 1'b0;
                         
                    else if (smc_done6)
                      
                         if( ( ( (r_wete_store6 < r_ws_store6[1:0]) | 
                                 (r_ws_store6[7:2] != 6'd0)
                               ) & 
                               (r_wele_store6 == 2'd0)
                             )
                           )
                           
                           r_full6 <= 1'b1;
                         
                         else
                           
                           r_full6 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store6 == 2'd3)
                           
                           if( ( (r_ws_count6[7:0] > 8'd4)
                               ) & 
                               (r_wele_count6 < 2'd2)
                             )
                             
                             r_full6 <= 1'b1;
                         
                           else
                             
                             r_full6 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store6 + 2'd1) < 
                                         r_ws_count6[1:0]
                                       )
                                     ) |
                                     (r_ws_count6[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count6 < 2'd2)
                                 )
                           
                           r_full6 <= 1'b1;
                         
                         else
                           
                           r_full6 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full6 <= 1'b0;
               
            end
             
             `SMC_STORE6:
               
               begin
                  
                  if (smc_nextstate6 == `SMC_RW6)

                     if ( ( ( (r_wete_store6) < r_ws_count6[1:0]) | 
                            (r_ws_count6[7:2] != 6'd0)
                          ) & 
                          (r_wele_count6 == 2'd0)
                        )
                         
                         r_full6 <= 1'b1;
                       
                       else
                         
                         r_full6 <= 1'b0;
                       
                  else
                    
                       r_full6 <= 1'b0;
                       
               end
             
             default:
               
                  r_full6 <= 1'b0;
                  
           endcase // r_smc_currentstate6
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate6 Read Strobe6
//----------------------------------------------------------------------
 
  always @(posedge sys_clk6 or negedge n_sys_reset6)
  
  begin
     
     if (~n_sys_reset6)
  
        smc_n_rd6 <= 1'h1;
      
      
     else if (smc_nextstate6 == `SMC_RW6)
  
     begin
  
        if (valid_access6)
  
        begin
  
  
              smc_n_rd6 <= n_read6;
  
  
        end
  
        else if ((r_smc_currentstate6 == `SMC_LE6) | 
                    (r_smc_currentstate6 == `SMC_STORE6))

        begin
           
           if( (r_oete_store6 < r_ws_store6[1:0]) | 
               (r_ws_store6[7:2] != 6'd0) |
               ( (r_oete_store6 == r_ws_store6[1:0]) & 
                 (r_ws_store6[7:2] == 6'd0)
               ) |
               (r_ws_store6 == 8'd0) 
             )
             
             smc_n_rd6 <= n_r_read6;
           
           else
             
             smc_n_rd6 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store6) < r_ws_count6[1:0]) | 
               (r_ws_count6[7:2] != 6'd0) |
               (r_ws_count6 == 8'd0) 
             )
             
              smc_n_rd6 <= n_r_read6;
           
           else

              smc_n_rd6 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd6 <= 1'b1;
     
  end
   
   
 
endmodule


