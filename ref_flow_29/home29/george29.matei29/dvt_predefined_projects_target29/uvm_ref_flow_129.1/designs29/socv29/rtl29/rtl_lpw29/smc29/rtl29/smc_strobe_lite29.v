//File29 name   : smc_strobe_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`include "smc_defs_lite29.v"

module smc_strobe_lite29  (

                    //inputs29

                    sys_clk29,
                    n_sys_reset29,
                    valid_access29,
                    n_read29,
                    cs,
                    r_smc_currentstate29,
                    smc_nextstate29,
                    n_be29,
                    r_wele_count29,
                    r_wele_store29,
                    r_wete_store29,
                    r_oete_store29,
                    r_ws_count29,
                    r_ws_store29,
                    smc_done29,
                    mac_done29,

                    //outputs29

                    smc_n_rd29,
                    smc_n_ext_oe29,
                    smc_busy29,
                    n_r_read29,
                    r_cs29,
                    r_full29,
                    n_r_we29,
                    n_r_wr29);



//Parameters29  -  Values29 in smc_defs29.v

 


// I29/O29

   input                   sys_clk29;      //System29 clock29
   input                   n_sys_reset29;  //System29 reset (Active29 LOW29)
   input                   valid_access29; //load29 values are valid if high29
   input                   n_read29;       //Active29 low29 read signal29
   input              cs;           //registered chip29 select29
   input [4:0]             r_smc_currentstate29;//current state
   input [4:0]             smc_nextstate29;//next state  
   input [3:0]             n_be29;         //Unregistered29 Byte29 strobes29
   input [1:0]             r_wele_count29; //Write counter
   input [1:0]             r_wete_store29; //write strobe29 trailing29 edge store29
   input [1:0]             r_oete_store29; //read strobe29
   input [1:0]             r_wele_store29; //write strobe29 leading29 edge store29
   input [7:0]             r_ws_count29;   //wait state count
   input [7:0]             r_ws_store29;   //wait state store29
   input                   smc_done29;  //one access completed
   input                   mac_done29;  //All cycles29 in a multiple access
   
   
   output                  smc_n_rd29;     // EMI29 read stobe29 (Active29 LOW29)
   output                  smc_n_ext_oe29; // Enable29 External29 bus drivers29.
                                                          //  (CS29 & ~RD29)
   output                  smc_busy29;  // smc29 busy
   output                  n_r_read29;  // Store29 RW strobe29 for multiple
                                                         //  accesses
   output                  r_full29;    // Full cycle write strobe29
   output [3:0]            n_r_we29;    // write enable strobe29(active low29)
   output                  n_r_wr29;    // write strobe29(active low29)
   output             r_cs29;      // registered chip29 select29.   


// Output29 register declarations29

   reg                     smc_n_rd29;
   reg                     smc_n_ext_oe29;
   reg                r_cs29;
   reg                     smc_busy29;
   reg                     n_r_read29;
   reg                     r_full29;
   reg   [3:0]             n_r_we29;
   reg                     n_r_wr29;

   //wire declarations29
   
   wire             smc_mac_done29;       //smc_done29 and  mac_done29 anded29
   wire [2:0]       wait_vaccess_smdone29;//concatenated29 signals29 for case
   reg              half_cycle29;         //used for generating29 half29 cycle
                                                //strobes29
   


//----------------------------------------------------------------------
// Strobe29 Generation29
//
// Individual Write Strobes29
// Write Strobe29 = Byte29 Enable29 & Write Enable29
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal29 concatenation29 for use in case statement29
//----------------------------------------------------------------------

   assign smc_mac_done29 = {smc_done29 & mac_done29};

   assign wait_vaccess_smdone29 = {1'b0,valid_access29,smc_mac_done29};
   
   
//----------------------------------------------------------------------
// Store29 read/write signal29 for duration29 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk29 or negedge n_sys_reset29)
  
     begin
  
        if (~n_sys_reset29)
  
           n_r_read29 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone29)
               
               3'b1xx:
                 
                  n_r_read29 <= n_r_read29;
               
               3'b01x:
                 
                  n_r_read29 <= n_read29;
               
               3'b001:
                 
                  n_r_read29 <= 0;
               
               default:
                 
                  n_r_read29 <= n_r_read29;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store29 chip29 selects29 for duration29 of cycle(s)--turnaround29 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store29 read/write signal29 for duration29 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk29 or negedge n_sys_reset29)
     
      begin
           
         if (~n_sys_reset29)
           
           r_cs29 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone29)
                
                 3'b1xx:
                  
                    r_cs29 <= r_cs29 ;
                
                 3'b01x:
                  
                    r_cs29 <= cs ;
                
                 3'b001:
                  
                    r_cs29 <= 1'b0;
                
                 default:
                  
                    r_cs29 <= r_cs29 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive29 busy output whenever29 smc29 active
//----------------------------------------------------------------------

   always @(posedge sys_clk29 or negedge n_sys_reset29)
     
      begin
          
         if (~n_sys_reset29)
           
            smc_busy29 <= 0;
           
           
         else if (smc_nextstate29 != `SMC_IDLE29)
           
            smc_busy29 <= 1;
           
         else
           
            smc_busy29 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive29 OE29 signal29 to I29/O29 pins29 on ASIC29
//
// Generate29 internal, registered Write strobes29
// The write strobes29 are gated29 with the clock29 later29 to generate half29 
// cycle strobes29
//----------------------------------------------------------------------

  always @(posedge sys_clk29 or negedge n_sys_reset29)
    
     begin
       
        if (~n_sys_reset29)
         
           begin
            
              n_r_we29 <= 4'hF;
              n_r_wr29 <= 1'h1;
            
           end
       

        else if ((n_read29 & valid_access29 & 
                  (smc_nextstate29 != `SMC_STORE29)) |
                 (n_r_read29 & ~valid_access29 & 
                  (smc_nextstate29 != `SMC_STORE29)))      
         
           begin
            
              n_r_we29 <= n_be29;
              n_r_wr29 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we29 <= 4'hF;
              n_r_wr29 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive29 OE29 signal29 to I29/O29 pins29 on ASIC29 -----added by gulbir29
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk29 or negedge n_sys_reset29)
     
     begin
        
        if (~n_sys_reset29)
          
          smc_n_ext_oe29 <= 1;
        
        
        else if ((n_read29 & valid_access29 & 
                  (smc_nextstate29 != `SMC_STORE29)) |
                (n_r_read29 & ~valid_access29 & 
              (smc_nextstate29 != `SMC_STORE29) & 
                 (smc_nextstate29 != `SMC_IDLE29)))      

           smc_n_ext_oe29 <= 0;
        
        else
          
           smc_n_ext_oe29 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate29 half29 and full signals29 for write strobes29
// A full cycle is required29 if wait states29 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate29 half29 cycle signals29 for write strobes29
//----------------------------------------------------------------------

always @(r_smc_currentstate29 or smc_nextstate29 or
            r_full29 or 
            r_wete_store29 or r_ws_store29 or r_wele_store29 or 
            r_ws_count29 or r_wele_count29 or 
            valid_access29 or smc_done29)
  
  begin     
     
       begin
          
          case (r_smc_currentstate29)
            
            `SMC_IDLE29:
              
              begin
                 
                     half_cycle29 = 1'b0;
                 
              end
            
            `SMC_LE29:
              
              begin
                 
                 if (smc_nextstate29 == `SMC_RW29)
                   
                   if( ( ( (r_wete_store29) == r_ws_count29[1:0]) &
                         (r_ws_count29[7:2] == 6'd0) &
                         (r_wele_count29 < 2'd2)
                       ) |
                       (r_ws_count29 == 8'd0)
                     )
                     
                     half_cycle29 = 1'b1 & ~r_full29;
                 
                   else
                     
                     half_cycle29 = 1'b0;
                 
                 else
                   
                   half_cycle29 = 1'b0;
                 
              end
            
            `SMC_RW29, `SMC_FLOAT29:
              
              begin
                 
                 if (smc_nextstate29 == `SMC_RW29)
                   
                   if (valid_access29)

                       
                       half_cycle29 = 1'b0;
                 
                   else if (smc_done29)
                     
                     if( ( (r_wete_store29 == r_ws_store29[1:0]) & 
                           (r_ws_store29[7:2] == 6'd0) & 
                           (r_wele_store29 == 2'd0)
                         ) | 
                         (r_ws_store29 == 8'd0)
                       )
                       
                       half_cycle29 = 1'b1 & ~r_full29;
                 
                     else
                       
                       half_cycle29 = 1'b0;
                 
                   else
                     
                     if (r_wete_store29 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count29[1:0]) & 
                            (r_ws_count29[7:2] == 6'd1) &
                            (r_wele_count29 < 2'd2)
                          )
                         
                         half_cycle29 = 1'b1 & ~r_full29;
                 
                       else
                         
                         half_cycle29 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store29+2'd1) == r_ws_count29[1:0]) & 
                              (r_ws_count29[7:2] == 6'd0) & 
                              (r_wele_count29 < 2'd2)
                            )
                          )
                         
                         half_cycle29 = 1'b1 & ~r_full29;
                 
                       else
                         
                         half_cycle29 = 1'b0;
                 
                 else
                   
                   half_cycle29 = 1'b0;
                 
              end
            
            `SMC_STORE29:
              
              begin
                 
                 if (smc_nextstate29 == `SMC_RW29)

                   if( ( ( (r_wete_store29) == r_ws_count29[1:0]) & 
                         (r_ws_count29[7:2] == 6'd0) & 
                         (r_wele_count29 < 2'd2)
                       ) | 
                       (r_ws_count29 == 8'd0)
                     )
                     
                     half_cycle29 = 1'b1 & ~r_full29;
                 
                   else
                     
                     half_cycle29 = 1'b0;
                 
                 else
                   
                   half_cycle29 = 1'b0;
                 
              end
            
            default:
              
              half_cycle29 = 1'b0;
            
          endcase // r_smc_currentstate29
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal29 generation29
//----------------------------------------------------------------------

 always @(posedge sys_clk29 or negedge n_sys_reset29)
             
   begin
      
      if (~n_sys_reset29)
        
        begin
           
           r_full29 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate29)
             
             `SMC_IDLE29:
               
               begin
                  
                  if (smc_nextstate29 == `SMC_RW29)
                    
                         
                         r_full29 <= 1'b0;
                       
                  else
                        
                       r_full29 <= 1'b0;
                       
               end
             
          `SMC_LE29:
            
          begin
             
             if (smc_nextstate29 == `SMC_RW29)
               
                  if( ( ( (r_wete_store29) < r_ws_count29[1:0]) | 
                        (r_ws_count29[7:2] != 6'd0)
                      ) & 
                      (r_wele_count29 < 2'd2)
                    )
                    
                    r_full29 <= 1'b1;
                  
                  else
                    
                    r_full29 <= 1'b0;
                  
             else
               
                  r_full29 <= 1'b0;
                  
          end
          
          `SMC_RW29, `SMC_FLOAT29:
            
            begin
               
               if (smc_nextstate29 == `SMC_RW29)
                 
                 begin
                    
                    if (valid_access29)
                      
                           
                           r_full29 <= 1'b0;
                         
                    else if (smc_done29)
                      
                         if( ( ( (r_wete_store29 < r_ws_store29[1:0]) | 
                                 (r_ws_store29[7:2] != 6'd0)
                               ) & 
                               (r_wele_store29 == 2'd0)
                             )
                           )
                           
                           r_full29 <= 1'b1;
                         
                         else
                           
                           r_full29 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store29 == 2'd3)
                           
                           if( ( (r_ws_count29[7:0] > 8'd4)
                               ) & 
                               (r_wele_count29 < 2'd2)
                             )
                             
                             r_full29 <= 1'b1;
                         
                           else
                             
                             r_full29 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store29 + 2'd1) < 
                                         r_ws_count29[1:0]
                                       )
                                     ) |
                                     (r_ws_count29[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count29 < 2'd2)
                                 )
                           
                           r_full29 <= 1'b1;
                         
                         else
                           
                           r_full29 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full29 <= 1'b0;
               
            end
             
             `SMC_STORE29:
               
               begin
                  
                  if (smc_nextstate29 == `SMC_RW29)

                     if ( ( ( (r_wete_store29) < r_ws_count29[1:0]) | 
                            (r_ws_count29[7:2] != 6'd0)
                          ) & 
                          (r_wele_count29 == 2'd0)
                        )
                         
                         r_full29 <= 1'b1;
                       
                       else
                         
                         r_full29 <= 1'b0;
                       
                  else
                    
                       r_full29 <= 1'b0;
                       
               end
             
             default:
               
                  r_full29 <= 1'b0;
                  
           endcase // r_smc_currentstate29
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate29 Read Strobe29
//----------------------------------------------------------------------
 
  always @(posedge sys_clk29 or negedge n_sys_reset29)
  
  begin
     
     if (~n_sys_reset29)
  
        smc_n_rd29 <= 1'h1;
      
      
     else if (smc_nextstate29 == `SMC_RW29)
  
     begin
  
        if (valid_access29)
  
        begin
  
  
              smc_n_rd29 <= n_read29;
  
  
        end
  
        else if ((r_smc_currentstate29 == `SMC_LE29) | 
                    (r_smc_currentstate29 == `SMC_STORE29))

        begin
           
           if( (r_oete_store29 < r_ws_store29[1:0]) | 
               (r_ws_store29[7:2] != 6'd0) |
               ( (r_oete_store29 == r_ws_store29[1:0]) & 
                 (r_ws_store29[7:2] == 6'd0)
               ) |
               (r_ws_store29 == 8'd0) 
             )
             
             smc_n_rd29 <= n_r_read29;
           
           else
             
             smc_n_rd29 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store29) < r_ws_count29[1:0]) | 
               (r_ws_count29[7:2] != 6'd0) |
               (r_ws_count29 == 8'd0) 
             )
             
              smc_n_rd29 <= n_r_read29;
           
           else

              smc_n_rd29 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd29 <= 1'b1;
     
  end
   
   
 
endmodule


