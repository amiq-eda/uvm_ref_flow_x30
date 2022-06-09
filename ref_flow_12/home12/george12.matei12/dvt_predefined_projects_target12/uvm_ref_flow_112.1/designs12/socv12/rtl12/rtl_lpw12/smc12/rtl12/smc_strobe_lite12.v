//File12 name   : smc_strobe_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`include "smc_defs_lite12.v"

module smc_strobe_lite12  (

                    //inputs12

                    sys_clk12,
                    n_sys_reset12,
                    valid_access12,
                    n_read12,
                    cs,
                    r_smc_currentstate12,
                    smc_nextstate12,
                    n_be12,
                    r_wele_count12,
                    r_wele_store12,
                    r_wete_store12,
                    r_oete_store12,
                    r_ws_count12,
                    r_ws_store12,
                    smc_done12,
                    mac_done12,

                    //outputs12

                    smc_n_rd12,
                    smc_n_ext_oe12,
                    smc_busy12,
                    n_r_read12,
                    r_cs12,
                    r_full12,
                    n_r_we12,
                    n_r_wr12);



//Parameters12  -  Values12 in smc_defs12.v

 


// I12/O12

   input                   sys_clk12;      //System12 clock12
   input                   n_sys_reset12;  //System12 reset (Active12 LOW12)
   input                   valid_access12; //load12 values are valid if high12
   input                   n_read12;       //Active12 low12 read signal12
   input              cs;           //registered chip12 select12
   input [4:0]             r_smc_currentstate12;//current state
   input [4:0]             smc_nextstate12;//next state  
   input [3:0]             n_be12;         //Unregistered12 Byte12 strobes12
   input [1:0]             r_wele_count12; //Write counter
   input [1:0]             r_wete_store12; //write strobe12 trailing12 edge store12
   input [1:0]             r_oete_store12; //read strobe12
   input [1:0]             r_wele_store12; //write strobe12 leading12 edge store12
   input [7:0]             r_ws_count12;   //wait state count
   input [7:0]             r_ws_store12;   //wait state store12
   input                   smc_done12;  //one access completed
   input                   mac_done12;  //All cycles12 in a multiple access
   
   
   output                  smc_n_rd12;     // EMI12 read stobe12 (Active12 LOW12)
   output                  smc_n_ext_oe12; // Enable12 External12 bus drivers12.
                                                          //  (CS12 & ~RD12)
   output                  smc_busy12;  // smc12 busy
   output                  n_r_read12;  // Store12 RW strobe12 for multiple
                                                         //  accesses
   output                  r_full12;    // Full cycle write strobe12
   output [3:0]            n_r_we12;    // write enable strobe12(active low12)
   output                  n_r_wr12;    // write strobe12(active low12)
   output             r_cs12;      // registered chip12 select12.   


// Output12 register declarations12

   reg                     smc_n_rd12;
   reg                     smc_n_ext_oe12;
   reg                r_cs12;
   reg                     smc_busy12;
   reg                     n_r_read12;
   reg                     r_full12;
   reg   [3:0]             n_r_we12;
   reg                     n_r_wr12;

   //wire declarations12
   
   wire             smc_mac_done12;       //smc_done12 and  mac_done12 anded12
   wire [2:0]       wait_vaccess_smdone12;//concatenated12 signals12 for case
   reg              half_cycle12;         //used for generating12 half12 cycle
                                                //strobes12
   


//----------------------------------------------------------------------
// Strobe12 Generation12
//
// Individual Write Strobes12
// Write Strobe12 = Byte12 Enable12 & Write Enable12
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal12 concatenation12 for use in case statement12
//----------------------------------------------------------------------

   assign smc_mac_done12 = {smc_done12 & mac_done12};

   assign wait_vaccess_smdone12 = {1'b0,valid_access12,smc_mac_done12};
   
   
//----------------------------------------------------------------------
// Store12 read/write signal12 for duration12 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk12 or negedge n_sys_reset12)
  
     begin
  
        if (~n_sys_reset12)
  
           n_r_read12 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone12)
               
               3'b1xx:
                 
                  n_r_read12 <= n_r_read12;
               
               3'b01x:
                 
                  n_r_read12 <= n_read12;
               
               3'b001:
                 
                  n_r_read12 <= 0;
               
               default:
                 
                  n_r_read12 <= n_r_read12;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store12 chip12 selects12 for duration12 of cycle(s)--turnaround12 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store12 read/write signal12 for duration12 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk12 or negedge n_sys_reset12)
     
      begin
           
         if (~n_sys_reset12)
           
           r_cs12 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone12)
                
                 3'b1xx:
                  
                    r_cs12 <= r_cs12 ;
                
                 3'b01x:
                  
                    r_cs12 <= cs ;
                
                 3'b001:
                  
                    r_cs12 <= 1'b0;
                
                 default:
                  
                    r_cs12 <= r_cs12 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive12 busy output whenever12 smc12 active
//----------------------------------------------------------------------

   always @(posedge sys_clk12 or negedge n_sys_reset12)
     
      begin
          
         if (~n_sys_reset12)
           
            smc_busy12 <= 0;
           
           
         else if (smc_nextstate12 != `SMC_IDLE12)
           
            smc_busy12 <= 1;
           
         else
           
            smc_busy12 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive12 OE12 signal12 to I12/O12 pins12 on ASIC12
//
// Generate12 internal, registered Write strobes12
// The write strobes12 are gated12 with the clock12 later12 to generate half12 
// cycle strobes12
//----------------------------------------------------------------------

  always @(posedge sys_clk12 or negedge n_sys_reset12)
    
     begin
       
        if (~n_sys_reset12)
         
           begin
            
              n_r_we12 <= 4'hF;
              n_r_wr12 <= 1'h1;
            
           end
       

        else if ((n_read12 & valid_access12 & 
                  (smc_nextstate12 != `SMC_STORE12)) |
                 (n_r_read12 & ~valid_access12 & 
                  (smc_nextstate12 != `SMC_STORE12)))      
         
           begin
            
              n_r_we12 <= n_be12;
              n_r_wr12 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we12 <= 4'hF;
              n_r_wr12 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive12 OE12 signal12 to I12/O12 pins12 on ASIC12 -----added by gulbir12
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk12 or negedge n_sys_reset12)
     
     begin
        
        if (~n_sys_reset12)
          
          smc_n_ext_oe12 <= 1;
        
        
        else if ((n_read12 & valid_access12 & 
                  (smc_nextstate12 != `SMC_STORE12)) |
                (n_r_read12 & ~valid_access12 & 
              (smc_nextstate12 != `SMC_STORE12) & 
                 (smc_nextstate12 != `SMC_IDLE12)))      

           smc_n_ext_oe12 <= 0;
        
        else
          
           smc_n_ext_oe12 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate12 half12 and full signals12 for write strobes12
// A full cycle is required12 if wait states12 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate12 half12 cycle signals12 for write strobes12
//----------------------------------------------------------------------

always @(r_smc_currentstate12 or smc_nextstate12 or
            r_full12 or 
            r_wete_store12 or r_ws_store12 or r_wele_store12 or 
            r_ws_count12 or r_wele_count12 or 
            valid_access12 or smc_done12)
  
  begin     
     
       begin
          
          case (r_smc_currentstate12)
            
            `SMC_IDLE12:
              
              begin
                 
                     half_cycle12 = 1'b0;
                 
              end
            
            `SMC_LE12:
              
              begin
                 
                 if (smc_nextstate12 == `SMC_RW12)
                   
                   if( ( ( (r_wete_store12) == r_ws_count12[1:0]) &
                         (r_ws_count12[7:2] == 6'd0) &
                         (r_wele_count12 < 2'd2)
                       ) |
                       (r_ws_count12 == 8'd0)
                     )
                     
                     half_cycle12 = 1'b1 & ~r_full12;
                 
                   else
                     
                     half_cycle12 = 1'b0;
                 
                 else
                   
                   half_cycle12 = 1'b0;
                 
              end
            
            `SMC_RW12, `SMC_FLOAT12:
              
              begin
                 
                 if (smc_nextstate12 == `SMC_RW12)
                   
                   if (valid_access12)

                       
                       half_cycle12 = 1'b0;
                 
                   else if (smc_done12)
                     
                     if( ( (r_wete_store12 == r_ws_store12[1:0]) & 
                           (r_ws_store12[7:2] == 6'd0) & 
                           (r_wele_store12 == 2'd0)
                         ) | 
                         (r_ws_store12 == 8'd0)
                       )
                       
                       half_cycle12 = 1'b1 & ~r_full12;
                 
                     else
                       
                       half_cycle12 = 1'b0;
                 
                   else
                     
                     if (r_wete_store12 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count12[1:0]) & 
                            (r_ws_count12[7:2] == 6'd1) &
                            (r_wele_count12 < 2'd2)
                          )
                         
                         half_cycle12 = 1'b1 & ~r_full12;
                 
                       else
                         
                         half_cycle12 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store12+2'd1) == r_ws_count12[1:0]) & 
                              (r_ws_count12[7:2] == 6'd0) & 
                              (r_wele_count12 < 2'd2)
                            )
                          )
                         
                         half_cycle12 = 1'b1 & ~r_full12;
                 
                       else
                         
                         half_cycle12 = 1'b0;
                 
                 else
                   
                   half_cycle12 = 1'b0;
                 
              end
            
            `SMC_STORE12:
              
              begin
                 
                 if (smc_nextstate12 == `SMC_RW12)

                   if( ( ( (r_wete_store12) == r_ws_count12[1:0]) & 
                         (r_ws_count12[7:2] == 6'd0) & 
                         (r_wele_count12 < 2'd2)
                       ) | 
                       (r_ws_count12 == 8'd0)
                     )
                     
                     half_cycle12 = 1'b1 & ~r_full12;
                 
                   else
                     
                     half_cycle12 = 1'b0;
                 
                 else
                   
                   half_cycle12 = 1'b0;
                 
              end
            
            default:
              
              half_cycle12 = 1'b0;
            
          endcase // r_smc_currentstate12
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal12 generation12
//----------------------------------------------------------------------

 always @(posedge sys_clk12 or negedge n_sys_reset12)
             
   begin
      
      if (~n_sys_reset12)
        
        begin
           
           r_full12 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate12)
             
             `SMC_IDLE12:
               
               begin
                  
                  if (smc_nextstate12 == `SMC_RW12)
                    
                         
                         r_full12 <= 1'b0;
                       
                  else
                        
                       r_full12 <= 1'b0;
                       
               end
             
          `SMC_LE12:
            
          begin
             
             if (smc_nextstate12 == `SMC_RW12)
               
                  if( ( ( (r_wete_store12) < r_ws_count12[1:0]) | 
                        (r_ws_count12[7:2] != 6'd0)
                      ) & 
                      (r_wele_count12 < 2'd2)
                    )
                    
                    r_full12 <= 1'b1;
                  
                  else
                    
                    r_full12 <= 1'b0;
                  
             else
               
                  r_full12 <= 1'b0;
                  
          end
          
          `SMC_RW12, `SMC_FLOAT12:
            
            begin
               
               if (smc_nextstate12 == `SMC_RW12)
                 
                 begin
                    
                    if (valid_access12)
                      
                           
                           r_full12 <= 1'b0;
                         
                    else if (smc_done12)
                      
                         if( ( ( (r_wete_store12 < r_ws_store12[1:0]) | 
                                 (r_ws_store12[7:2] != 6'd0)
                               ) & 
                               (r_wele_store12 == 2'd0)
                             )
                           )
                           
                           r_full12 <= 1'b1;
                         
                         else
                           
                           r_full12 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store12 == 2'd3)
                           
                           if( ( (r_ws_count12[7:0] > 8'd4)
                               ) & 
                               (r_wele_count12 < 2'd2)
                             )
                             
                             r_full12 <= 1'b1;
                         
                           else
                             
                             r_full12 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store12 + 2'd1) < 
                                         r_ws_count12[1:0]
                                       )
                                     ) |
                                     (r_ws_count12[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count12 < 2'd2)
                                 )
                           
                           r_full12 <= 1'b1;
                         
                         else
                           
                           r_full12 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full12 <= 1'b0;
               
            end
             
             `SMC_STORE12:
               
               begin
                  
                  if (smc_nextstate12 == `SMC_RW12)

                     if ( ( ( (r_wete_store12) < r_ws_count12[1:0]) | 
                            (r_ws_count12[7:2] != 6'd0)
                          ) & 
                          (r_wele_count12 == 2'd0)
                        )
                         
                         r_full12 <= 1'b1;
                       
                       else
                         
                         r_full12 <= 1'b0;
                       
                  else
                    
                       r_full12 <= 1'b0;
                       
               end
             
             default:
               
                  r_full12 <= 1'b0;
                  
           endcase // r_smc_currentstate12
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate12 Read Strobe12
//----------------------------------------------------------------------
 
  always @(posedge sys_clk12 or negedge n_sys_reset12)
  
  begin
     
     if (~n_sys_reset12)
  
        smc_n_rd12 <= 1'h1;
      
      
     else if (smc_nextstate12 == `SMC_RW12)
  
     begin
  
        if (valid_access12)
  
        begin
  
  
              smc_n_rd12 <= n_read12;
  
  
        end
  
        else if ((r_smc_currentstate12 == `SMC_LE12) | 
                    (r_smc_currentstate12 == `SMC_STORE12))

        begin
           
           if( (r_oete_store12 < r_ws_store12[1:0]) | 
               (r_ws_store12[7:2] != 6'd0) |
               ( (r_oete_store12 == r_ws_store12[1:0]) & 
                 (r_ws_store12[7:2] == 6'd0)
               ) |
               (r_ws_store12 == 8'd0) 
             )
             
             smc_n_rd12 <= n_r_read12;
           
           else
             
             smc_n_rd12 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store12) < r_ws_count12[1:0]) | 
               (r_ws_count12[7:2] != 6'd0) |
               (r_ws_count12 == 8'd0) 
             )
             
              smc_n_rd12 <= n_r_read12;
           
           else

              smc_n_rd12 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd12 <= 1'b1;
     
  end
   
   
 
endmodule


