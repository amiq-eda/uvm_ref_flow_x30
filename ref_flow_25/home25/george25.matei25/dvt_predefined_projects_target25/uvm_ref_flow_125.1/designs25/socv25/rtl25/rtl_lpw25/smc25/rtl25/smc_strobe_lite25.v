//File25 name   : smc_strobe_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`include "smc_defs_lite25.v"

module smc_strobe_lite25  (

                    //inputs25

                    sys_clk25,
                    n_sys_reset25,
                    valid_access25,
                    n_read25,
                    cs,
                    r_smc_currentstate25,
                    smc_nextstate25,
                    n_be25,
                    r_wele_count25,
                    r_wele_store25,
                    r_wete_store25,
                    r_oete_store25,
                    r_ws_count25,
                    r_ws_store25,
                    smc_done25,
                    mac_done25,

                    //outputs25

                    smc_n_rd25,
                    smc_n_ext_oe25,
                    smc_busy25,
                    n_r_read25,
                    r_cs25,
                    r_full25,
                    n_r_we25,
                    n_r_wr25);



//Parameters25  -  Values25 in smc_defs25.v

 


// I25/O25

   input                   sys_clk25;      //System25 clock25
   input                   n_sys_reset25;  //System25 reset (Active25 LOW25)
   input                   valid_access25; //load25 values are valid if high25
   input                   n_read25;       //Active25 low25 read signal25
   input              cs;           //registered chip25 select25
   input [4:0]             r_smc_currentstate25;//current state
   input [4:0]             smc_nextstate25;//next state  
   input [3:0]             n_be25;         //Unregistered25 Byte25 strobes25
   input [1:0]             r_wele_count25; //Write counter
   input [1:0]             r_wete_store25; //write strobe25 trailing25 edge store25
   input [1:0]             r_oete_store25; //read strobe25
   input [1:0]             r_wele_store25; //write strobe25 leading25 edge store25
   input [7:0]             r_ws_count25;   //wait state count
   input [7:0]             r_ws_store25;   //wait state store25
   input                   smc_done25;  //one access completed
   input                   mac_done25;  //All cycles25 in a multiple access
   
   
   output                  smc_n_rd25;     // EMI25 read stobe25 (Active25 LOW25)
   output                  smc_n_ext_oe25; // Enable25 External25 bus drivers25.
                                                          //  (CS25 & ~RD25)
   output                  smc_busy25;  // smc25 busy
   output                  n_r_read25;  // Store25 RW strobe25 for multiple
                                                         //  accesses
   output                  r_full25;    // Full cycle write strobe25
   output [3:0]            n_r_we25;    // write enable strobe25(active low25)
   output                  n_r_wr25;    // write strobe25(active low25)
   output             r_cs25;      // registered chip25 select25.   


// Output25 register declarations25

   reg                     smc_n_rd25;
   reg                     smc_n_ext_oe25;
   reg                r_cs25;
   reg                     smc_busy25;
   reg                     n_r_read25;
   reg                     r_full25;
   reg   [3:0]             n_r_we25;
   reg                     n_r_wr25;

   //wire declarations25
   
   wire             smc_mac_done25;       //smc_done25 and  mac_done25 anded25
   wire [2:0]       wait_vaccess_smdone25;//concatenated25 signals25 for case
   reg              half_cycle25;         //used for generating25 half25 cycle
                                                //strobes25
   


//----------------------------------------------------------------------
// Strobe25 Generation25
//
// Individual Write Strobes25
// Write Strobe25 = Byte25 Enable25 & Write Enable25
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal25 concatenation25 for use in case statement25
//----------------------------------------------------------------------

   assign smc_mac_done25 = {smc_done25 & mac_done25};

   assign wait_vaccess_smdone25 = {1'b0,valid_access25,smc_mac_done25};
   
   
//----------------------------------------------------------------------
// Store25 read/write signal25 for duration25 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk25 or negedge n_sys_reset25)
  
     begin
  
        if (~n_sys_reset25)
  
           n_r_read25 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone25)
               
               3'b1xx:
                 
                  n_r_read25 <= n_r_read25;
               
               3'b01x:
                 
                  n_r_read25 <= n_read25;
               
               3'b001:
                 
                  n_r_read25 <= 0;
               
               default:
                 
                  n_r_read25 <= n_r_read25;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store25 chip25 selects25 for duration25 of cycle(s)--turnaround25 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store25 read/write signal25 for duration25 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk25 or negedge n_sys_reset25)
     
      begin
           
         if (~n_sys_reset25)
           
           r_cs25 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone25)
                
                 3'b1xx:
                  
                    r_cs25 <= r_cs25 ;
                
                 3'b01x:
                  
                    r_cs25 <= cs ;
                
                 3'b001:
                  
                    r_cs25 <= 1'b0;
                
                 default:
                  
                    r_cs25 <= r_cs25 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive25 busy output whenever25 smc25 active
//----------------------------------------------------------------------

   always @(posedge sys_clk25 or negedge n_sys_reset25)
     
      begin
          
         if (~n_sys_reset25)
           
            smc_busy25 <= 0;
           
           
         else if (smc_nextstate25 != `SMC_IDLE25)
           
            smc_busy25 <= 1;
           
         else
           
            smc_busy25 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive25 OE25 signal25 to I25/O25 pins25 on ASIC25
//
// Generate25 internal, registered Write strobes25
// The write strobes25 are gated25 with the clock25 later25 to generate half25 
// cycle strobes25
//----------------------------------------------------------------------

  always @(posedge sys_clk25 or negedge n_sys_reset25)
    
     begin
       
        if (~n_sys_reset25)
         
           begin
            
              n_r_we25 <= 4'hF;
              n_r_wr25 <= 1'h1;
            
           end
       

        else if ((n_read25 & valid_access25 & 
                  (smc_nextstate25 != `SMC_STORE25)) |
                 (n_r_read25 & ~valid_access25 & 
                  (smc_nextstate25 != `SMC_STORE25)))      
         
           begin
            
              n_r_we25 <= n_be25;
              n_r_wr25 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we25 <= 4'hF;
              n_r_wr25 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive25 OE25 signal25 to I25/O25 pins25 on ASIC25 -----added by gulbir25
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk25 or negedge n_sys_reset25)
     
     begin
        
        if (~n_sys_reset25)
          
          smc_n_ext_oe25 <= 1;
        
        
        else if ((n_read25 & valid_access25 & 
                  (smc_nextstate25 != `SMC_STORE25)) |
                (n_r_read25 & ~valid_access25 & 
              (smc_nextstate25 != `SMC_STORE25) & 
                 (smc_nextstate25 != `SMC_IDLE25)))      

           smc_n_ext_oe25 <= 0;
        
        else
          
           smc_n_ext_oe25 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate25 half25 and full signals25 for write strobes25
// A full cycle is required25 if wait states25 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate25 half25 cycle signals25 for write strobes25
//----------------------------------------------------------------------

always @(r_smc_currentstate25 or smc_nextstate25 or
            r_full25 or 
            r_wete_store25 or r_ws_store25 or r_wele_store25 or 
            r_ws_count25 or r_wele_count25 or 
            valid_access25 or smc_done25)
  
  begin     
     
       begin
          
          case (r_smc_currentstate25)
            
            `SMC_IDLE25:
              
              begin
                 
                     half_cycle25 = 1'b0;
                 
              end
            
            `SMC_LE25:
              
              begin
                 
                 if (smc_nextstate25 == `SMC_RW25)
                   
                   if( ( ( (r_wete_store25) == r_ws_count25[1:0]) &
                         (r_ws_count25[7:2] == 6'd0) &
                         (r_wele_count25 < 2'd2)
                       ) |
                       (r_ws_count25 == 8'd0)
                     )
                     
                     half_cycle25 = 1'b1 & ~r_full25;
                 
                   else
                     
                     half_cycle25 = 1'b0;
                 
                 else
                   
                   half_cycle25 = 1'b0;
                 
              end
            
            `SMC_RW25, `SMC_FLOAT25:
              
              begin
                 
                 if (smc_nextstate25 == `SMC_RW25)
                   
                   if (valid_access25)

                       
                       half_cycle25 = 1'b0;
                 
                   else if (smc_done25)
                     
                     if( ( (r_wete_store25 == r_ws_store25[1:0]) & 
                           (r_ws_store25[7:2] == 6'd0) & 
                           (r_wele_store25 == 2'd0)
                         ) | 
                         (r_ws_store25 == 8'd0)
                       )
                       
                       half_cycle25 = 1'b1 & ~r_full25;
                 
                     else
                       
                       half_cycle25 = 1'b0;
                 
                   else
                     
                     if (r_wete_store25 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count25[1:0]) & 
                            (r_ws_count25[7:2] == 6'd1) &
                            (r_wele_count25 < 2'd2)
                          )
                         
                         half_cycle25 = 1'b1 & ~r_full25;
                 
                       else
                         
                         half_cycle25 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store25+2'd1) == r_ws_count25[1:0]) & 
                              (r_ws_count25[7:2] == 6'd0) & 
                              (r_wele_count25 < 2'd2)
                            )
                          )
                         
                         half_cycle25 = 1'b1 & ~r_full25;
                 
                       else
                         
                         half_cycle25 = 1'b0;
                 
                 else
                   
                   half_cycle25 = 1'b0;
                 
              end
            
            `SMC_STORE25:
              
              begin
                 
                 if (smc_nextstate25 == `SMC_RW25)

                   if( ( ( (r_wete_store25) == r_ws_count25[1:0]) & 
                         (r_ws_count25[7:2] == 6'd0) & 
                         (r_wele_count25 < 2'd2)
                       ) | 
                       (r_ws_count25 == 8'd0)
                     )
                     
                     half_cycle25 = 1'b1 & ~r_full25;
                 
                   else
                     
                     half_cycle25 = 1'b0;
                 
                 else
                   
                   half_cycle25 = 1'b0;
                 
              end
            
            default:
              
              half_cycle25 = 1'b0;
            
          endcase // r_smc_currentstate25
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal25 generation25
//----------------------------------------------------------------------

 always @(posedge sys_clk25 or negedge n_sys_reset25)
             
   begin
      
      if (~n_sys_reset25)
        
        begin
           
           r_full25 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate25)
             
             `SMC_IDLE25:
               
               begin
                  
                  if (smc_nextstate25 == `SMC_RW25)
                    
                         
                         r_full25 <= 1'b0;
                       
                  else
                        
                       r_full25 <= 1'b0;
                       
               end
             
          `SMC_LE25:
            
          begin
             
             if (smc_nextstate25 == `SMC_RW25)
               
                  if( ( ( (r_wete_store25) < r_ws_count25[1:0]) | 
                        (r_ws_count25[7:2] != 6'd0)
                      ) & 
                      (r_wele_count25 < 2'd2)
                    )
                    
                    r_full25 <= 1'b1;
                  
                  else
                    
                    r_full25 <= 1'b0;
                  
             else
               
                  r_full25 <= 1'b0;
                  
          end
          
          `SMC_RW25, `SMC_FLOAT25:
            
            begin
               
               if (smc_nextstate25 == `SMC_RW25)
                 
                 begin
                    
                    if (valid_access25)
                      
                           
                           r_full25 <= 1'b0;
                         
                    else if (smc_done25)
                      
                         if( ( ( (r_wete_store25 < r_ws_store25[1:0]) | 
                                 (r_ws_store25[7:2] != 6'd0)
                               ) & 
                               (r_wele_store25 == 2'd0)
                             )
                           )
                           
                           r_full25 <= 1'b1;
                         
                         else
                           
                           r_full25 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store25 == 2'd3)
                           
                           if( ( (r_ws_count25[7:0] > 8'd4)
                               ) & 
                               (r_wele_count25 < 2'd2)
                             )
                             
                             r_full25 <= 1'b1;
                         
                           else
                             
                             r_full25 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store25 + 2'd1) < 
                                         r_ws_count25[1:0]
                                       )
                                     ) |
                                     (r_ws_count25[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count25 < 2'd2)
                                 )
                           
                           r_full25 <= 1'b1;
                         
                         else
                           
                           r_full25 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full25 <= 1'b0;
               
            end
             
             `SMC_STORE25:
               
               begin
                  
                  if (smc_nextstate25 == `SMC_RW25)

                     if ( ( ( (r_wete_store25) < r_ws_count25[1:0]) | 
                            (r_ws_count25[7:2] != 6'd0)
                          ) & 
                          (r_wele_count25 == 2'd0)
                        )
                         
                         r_full25 <= 1'b1;
                       
                       else
                         
                         r_full25 <= 1'b0;
                       
                  else
                    
                       r_full25 <= 1'b0;
                       
               end
             
             default:
               
                  r_full25 <= 1'b0;
                  
           endcase // r_smc_currentstate25
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate25 Read Strobe25
//----------------------------------------------------------------------
 
  always @(posedge sys_clk25 or negedge n_sys_reset25)
  
  begin
     
     if (~n_sys_reset25)
  
        smc_n_rd25 <= 1'h1;
      
      
     else if (smc_nextstate25 == `SMC_RW25)
  
     begin
  
        if (valid_access25)
  
        begin
  
  
              smc_n_rd25 <= n_read25;
  
  
        end
  
        else if ((r_smc_currentstate25 == `SMC_LE25) | 
                    (r_smc_currentstate25 == `SMC_STORE25))

        begin
           
           if( (r_oete_store25 < r_ws_store25[1:0]) | 
               (r_ws_store25[7:2] != 6'd0) |
               ( (r_oete_store25 == r_ws_store25[1:0]) & 
                 (r_ws_store25[7:2] == 6'd0)
               ) |
               (r_ws_store25 == 8'd0) 
             )
             
             smc_n_rd25 <= n_r_read25;
           
           else
             
             smc_n_rd25 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store25) < r_ws_count25[1:0]) | 
               (r_ws_count25[7:2] != 6'd0) |
               (r_ws_count25 == 8'd0) 
             )
             
              smc_n_rd25 <= n_r_read25;
           
           else

              smc_n_rd25 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd25 <= 1'b1;
     
  end
   
   
 
endmodule


