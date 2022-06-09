//File16 name   : smc_strobe_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`include "smc_defs_lite16.v"

module smc_strobe_lite16  (

                    //inputs16

                    sys_clk16,
                    n_sys_reset16,
                    valid_access16,
                    n_read16,
                    cs,
                    r_smc_currentstate16,
                    smc_nextstate16,
                    n_be16,
                    r_wele_count16,
                    r_wele_store16,
                    r_wete_store16,
                    r_oete_store16,
                    r_ws_count16,
                    r_ws_store16,
                    smc_done16,
                    mac_done16,

                    //outputs16

                    smc_n_rd16,
                    smc_n_ext_oe16,
                    smc_busy16,
                    n_r_read16,
                    r_cs16,
                    r_full16,
                    n_r_we16,
                    n_r_wr16);



//Parameters16  -  Values16 in smc_defs16.v

 


// I16/O16

   input                   sys_clk16;      //System16 clock16
   input                   n_sys_reset16;  //System16 reset (Active16 LOW16)
   input                   valid_access16; //load16 values are valid if high16
   input                   n_read16;       //Active16 low16 read signal16
   input              cs;           //registered chip16 select16
   input [4:0]             r_smc_currentstate16;//current state
   input [4:0]             smc_nextstate16;//next state  
   input [3:0]             n_be16;         //Unregistered16 Byte16 strobes16
   input [1:0]             r_wele_count16; //Write counter
   input [1:0]             r_wete_store16; //write strobe16 trailing16 edge store16
   input [1:0]             r_oete_store16; //read strobe16
   input [1:0]             r_wele_store16; //write strobe16 leading16 edge store16
   input [7:0]             r_ws_count16;   //wait state count
   input [7:0]             r_ws_store16;   //wait state store16
   input                   smc_done16;  //one access completed
   input                   mac_done16;  //All cycles16 in a multiple access
   
   
   output                  smc_n_rd16;     // EMI16 read stobe16 (Active16 LOW16)
   output                  smc_n_ext_oe16; // Enable16 External16 bus drivers16.
                                                          //  (CS16 & ~RD16)
   output                  smc_busy16;  // smc16 busy
   output                  n_r_read16;  // Store16 RW strobe16 for multiple
                                                         //  accesses
   output                  r_full16;    // Full cycle write strobe16
   output [3:0]            n_r_we16;    // write enable strobe16(active low16)
   output                  n_r_wr16;    // write strobe16(active low16)
   output             r_cs16;      // registered chip16 select16.   


// Output16 register declarations16

   reg                     smc_n_rd16;
   reg                     smc_n_ext_oe16;
   reg                r_cs16;
   reg                     smc_busy16;
   reg                     n_r_read16;
   reg                     r_full16;
   reg   [3:0]             n_r_we16;
   reg                     n_r_wr16;

   //wire declarations16
   
   wire             smc_mac_done16;       //smc_done16 and  mac_done16 anded16
   wire [2:0]       wait_vaccess_smdone16;//concatenated16 signals16 for case
   reg              half_cycle16;         //used for generating16 half16 cycle
                                                //strobes16
   


//----------------------------------------------------------------------
// Strobe16 Generation16
//
// Individual Write Strobes16
// Write Strobe16 = Byte16 Enable16 & Write Enable16
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal16 concatenation16 for use in case statement16
//----------------------------------------------------------------------

   assign smc_mac_done16 = {smc_done16 & mac_done16};

   assign wait_vaccess_smdone16 = {1'b0,valid_access16,smc_mac_done16};
   
   
//----------------------------------------------------------------------
// Store16 read/write signal16 for duration16 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk16 or negedge n_sys_reset16)
  
     begin
  
        if (~n_sys_reset16)
  
           n_r_read16 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone16)
               
               3'b1xx:
                 
                  n_r_read16 <= n_r_read16;
               
               3'b01x:
                 
                  n_r_read16 <= n_read16;
               
               3'b001:
                 
                  n_r_read16 <= 0;
               
               default:
                 
                  n_r_read16 <= n_r_read16;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store16 chip16 selects16 for duration16 of cycle(s)--turnaround16 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store16 read/write signal16 for duration16 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk16 or negedge n_sys_reset16)
     
      begin
           
         if (~n_sys_reset16)
           
           r_cs16 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone16)
                
                 3'b1xx:
                  
                    r_cs16 <= r_cs16 ;
                
                 3'b01x:
                  
                    r_cs16 <= cs ;
                
                 3'b001:
                  
                    r_cs16 <= 1'b0;
                
                 default:
                  
                    r_cs16 <= r_cs16 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive16 busy output whenever16 smc16 active
//----------------------------------------------------------------------

   always @(posedge sys_clk16 or negedge n_sys_reset16)
     
      begin
          
         if (~n_sys_reset16)
           
            smc_busy16 <= 0;
           
           
         else if (smc_nextstate16 != `SMC_IDLE16)
           
            smc_busy16 <= 1;
           
         else
           
            smc_busy16 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive16 OE16 signal16 to I16/O16 pins16 on ASIC16
//
// Generate16 internal, registered Write strobes16
// The write strobes16 are gated16 with the clock16 later16 to generate half16 
// cycle strobes16
//----------------------------------------------------------------------

  always @(posedge sys_clk16 or negedge n_sys_reset16)
    
     begin
       
        if (~n_sys_reset16)
         
           begin
            
              n_r_we16 <= 4'hF;
              n_r_wr16 <= 1'h1;
            
           end
       

        else if ((n_read16 & valid_access16 & 
                  (smc_nextstate16 != `SMC_STORE16)) |
                 (n_r_read16 & ~valid_access16 & 
                  (smc_nextstate16 != `SMC_STORE16)))      
         
           begin
            
              n_r_we16 <= n_be16;
              n_r_wr16 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we16 <= 4'hF;
              n_r_wr16 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive16 OE16 signal16 to I16/O16 pins16 on ASIC16 -----added by gulbir16
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk16 or negedge n_sys_reset16)
     
     begin
        
        if (~n_sys_reset16)
          
          smc_n_ext_oe16 <= 1;
        
        
        else if ((n_read16 & valid_access16 & 
                  (smc_nextstate16 != `SMC_STORE16)) |
                (n_r_read16 & ~valid_access16 & 
              (smc_nextstate16 != `SMC_STORE16) & 
                 (smc_nextstate16 != `SMC_IDLE16)))      

           smc_n_ext_oe16 <= 0;
        
        else
          
           smc_n_ext_oe16 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate16 half16 and full signals16 for write strobes16
// A full cycle is required16 if wait states16 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate16 half16 cycle signals16 for write strobes16
//----------------------------------------------------------------------

always @(r_smc_currentstate16 or smc_nextstate16 or
            r_full16 or 
            r_wete_store16 or r_ws_store16 or r_wele_store16 or 
            r_ws_count16 or r_wele_count16 or 
            valid_access16 or smc_done16)
  
  begin     
     
       begin
          
          case (r_smc_currentstate16)
            
            `SMC_IDLE16:
              
              begin
                 
                     half_cycle16 = 1'b0;
                 
              end
            
            `SMC_LE16:
              
              begin
                 
                 if (smc_nextstate16 == `SMC_RW16)
                   
                   if( ( ( (r_wete_store16) == r_ws_count16[1:0]) &
                         (r_ws_count16[7:2] == 6'd0) &
                         (r_wele_count16 < 2'd2)
                       ) |
                       (r_ws_count16 == 8'd0)
                     )
                     
                     half_cycle16 = 1'b1 & ~r_full16;
                 
                   else
                     
                     half_cycle16 = 1'b0;
                 
                 else
                   
                   half_cycle16 = 1'b0;
                 
              end
            
            `SMC_RW16, `SMC_FLOAT16:
              
              begin
                 
                 if (smc_nextstate16 == `SMC_RW16)
                   
                   if (valid_access16)

                       
                       half_cycle16 = 1'b0;
                 
                   else if (smc_done16)
                     
                     if( ( (r_wete_store16 == r_ws_store16[1:0]) & 
                           (r_ws_store16[7:2] == 6'd0) & 
                           (r_wele_store16 == 2'd0)
                         ) | 
                         (r_ws_store16 == 8'd0)
                       )
                       
                       half_cycle16 = 1'b1 & ~r_full16;
                 
                     else
                       
                       half_cycle16 = 1'b0;
                 
                   else
                     
                     if (r_wete_store16 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count16[1:0]) & 
                            (r_ws_count16[7:2] == 6'd1) &
                            (r_wele_count16 < 2'd2)
                          )
                         
                         half_cycle16 = 1'b1 & ~r_full16;
                 
                       else
                         
                         half_cycle16 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store16+2'd1) == r_ws_count16[1:0]) & 
                              (r_ws_count16[7:2] == 6'd0) & 
                              (r_wele_count16 < 2'd2)
                            )
                          )
                         
                         half_cycle16 = 1'b1 & ~r_full16;
                 
                       else
                         
                         half_cycle16 = 1'b0;
                 
                 else
                   
                   half_cycle16 = 1'b0;
                 
              end
            
            `SMC_STORE16:
              
              begin
                 
                 if (smc_nextstate16 == `SMC_RW16)

                   if( ( ( (r_wete_store16) == r_ws_count16[1:0]) & 
                         (r_ws_count16[7:2] == 6'd0) & 
                         (r_wele_count16 < 2'd2)
                       ) | 
                       (r_ws_count16 == 8'd0)
                     )
                     
                     half_cycle16 = 1'b1 & ~r_full16;
                 
                   else
                     
                     half_cycle16 = 1'b0;
                 
                 else
                   
                   half_cycle16 = 1'b0;
                 
              end
            
            default:
              
              half_cycle16 = 1'b0;
            
          endcase // r_smc_currentstate16
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal16 generation16
//----------------------------------------------------------------------

 always @(posedge sys_clk16 or negedge n_sys_reset16)
             
   begin
      
      if (~n_sys_reset16)
        
        begin
           
           r_full16 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate16)
             
             `SMC_IDLE16:
               
               begin
                  
                  if (smc_nextstate16 == `SMC_RW16)
                    
                         
                         r_full16 <= 1'b0;
                       
                  else
                        
                       r_full16 <= 1'b0;
                       
               end
             
          `SMC_LE16:
            
          begin
             
             if (smc_nextstate16 == `SMC_RW16)
               
                  if( ( ( (r_wete_store16) < r_ws_count16[1:0]) | 
                        (r_ws_count16[7:2] != 6'd0)
                      ) & 
                      (r_wele_count16 < 2'd2)
                    )
                    
                    r_full16 <= 1'b1;
                  
                  else
                    
                    r_full16 <= 1'b0;
                  
             else
               
                  r_full16 <= 1'b0;
                  
          end
          
          `SMC_RW16, `SMC_FLOAT16:
            
            begin
               
               if (smc_nextstate16 == `SMC_RW16)
                 
                 begin
                    
                    if (valid_access16)
                      
                           
                           r_full16 <= 1'b0;
                         
                    else if (smc_done16)
                      
                         if( ( ( (r_wete_store16 < r_ws_store16[1:0]) | 
                                 (r_ws_store16[7:2] != 6'd0)
                               ) & 
                               (r_wele_store16 == 2'd0)
                             )
                           )
                           
                           r_full16 <= 1'b1;
                         
                         else
                           
                           r_full16 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store16 == 2'd3)
                           
                           if( ( (r_ws_count16[7:0] > 8'd4)
                               ) & 
                               (r_wele_count16 < 2'd2)
                             )
                             
                             r_full16 <= 1'b1;
                         
                           else
                             
                             r_full16 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store16 + 2'd1) < 
                                         r_ws_count16[1:0]
                                       )
                                     ) |
                                     (r_ws_count16[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count16 < 2'd2)
                                 )
                           
                           r_full16 <= 1'b1;
                         
                         else
                           
                           r_full16 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full16 <= 1'b0;
               
            end
             
             `SMC_STORE16:
               
               begin
                  
                  if (smc_nextstate16 == `SMC_RW16)

                     if ( ( ( (r_wete_store16) < r_ws_count16[1:0]) | 
                            (r_ws_count16[7:2] != 6'd0)
                          ) & 
                          (r_wele_count16 == 2'd0)
                        )
                         
                         r_full16 <= 1'b1;
                       
                       else
                         
                         r_full16 <= 1'b0;
                       
                  else
                    
                       r_full16 <= 1'b0;
                       
               end
             
             default:
               
                  r_full16 <= 1'b0;
                  
           endcase // r_smc_currentstate16
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate16 Read Strobe16
//----------------------------------------------------------------------
 
  always @(posedge sys_clk16 or negedge n_sys_reset16)
  
  begin
     
     if (~n_sys_reset16)
  
        smc_n_rd16 <= 1'h1;
      
      
     else if (smc_nextstate16 == `SMC_RW16)
  
     begin
  
        if (valid_access16)
  
        begin
  
  
              smc_n_rd16 <= n_read16;
  
  
        end
  
        else if ((r_smc_currentstate16 == `SMC_LE16) | 
                    (r_smc_currentstate16 == `SMC_STORE16))

        begin
           
           if( (r_oete_store16 < r_ws_store16[1:0]) | 
               (r_ws_store16[7:2] != 6'd0) |
               ( (r_oete_store16 == r_ws_store16[1:0]) & 
                 (r_ws_store16[7:2] == 6'd0)
               ) |
               (r_ws_store16 == 8'd0) 
             )
             
             smc_n_rd16 <= n_r_read16;
           
           else
             
             smc_n_rd16 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store16) < r_ws_count16[1:0]) | 
               (r_ws_count16[7:2] != 6'd0) |
               (r_ws_count16 == 8'd0) 
             )
             
              smc_n_rd16 <= n_r_read16;
           
           else

              smc_n_rd16 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd16 <= 1'b1;
     
  end
   
   
 
endmodule


