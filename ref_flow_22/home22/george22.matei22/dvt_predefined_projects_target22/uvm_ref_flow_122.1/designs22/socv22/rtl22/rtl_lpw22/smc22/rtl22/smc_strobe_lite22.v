//File22 name   : smc_strobe_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`include "smc_defs_lite22.v"

module smc_strobe_lite22  (

                    //inputs22

                    sys_clk22,
                    n_sys_reset22,
                    valid_access22,
                    n_read22,
                    cs,
                    r_smc_currentstate22,
                    smc_nextstate22,
                    n_be22,
                    r_wele_count22,
                    r_wele_store22,
                    r_wete_store22,
                    r_oete_store22,
                    r_ws_count22,
                    r_ws_store22,
                    smc_done22,
                    mac_done22,

                    //outputs22

                    smc_n_rd22,
                    smc_n_ext_oe22,
                    smc_busy22,
                    n_r_read22,
                    r_cs22,
                    r_full22,
                    n_r_we22,
                    n_r_wr22);



//Parameters22  -  Values22 in smc_defs22.v

 


// I22/O22

   input                   sys_clk22;      //System22 clock22
   input                   n_sys_reset22;  //System22 reset (Active22 LOW22)
   input                   valid_access22; //load22 values are valid if high22
   input                   n_read22;       //Active22 low22 read signal22
   input              cs;           //registered chip22 select22
   input [4:0]             r_smc_currentstate22;//current state
   input [4:0]             smc_nextstate22;//next state  
   input [3:0]             n_be22;         //Unregistered22 Byte22 strobes22
   input [1:0]             r_wele_count22; //Write counter
   input [1:0]             r_wete_store22; //write strobe22 trailing22 edge store22
   input [1:0]             r_oete_store22; //read strobe22
   input [1:0]             r_wele_store22; //write strobe22 leading22 edge store22
   input [7:0]             r_ws_count22;   //wait state count
   input [7:0]             r_ws_store22;   //wait state store22
   input                   smc_done22;  //one access completed
   input                   mac_done22;  //All cycles22 in a multiple access
   
   
   output                  smc_n_rd22;     // EMI22 read stobe22 (Active22 LOW22)
   output                  smc_n_ext_oe22; // Enable22 External22 bus drivers22.
                                                          //  (CS22 & ~RD22)
   output                  smc_busy22;  // smc22 busy
   output                  n_r_read22;  // Store22 RW strobe22 for multiple
                                                         //  accesses
   output                  r_full22;    // Full cycle write strobe22
   output [3:0]            n_r_we22;    // write enable strobe22(active low22)
   output                  n_r_wr22;    // write strobe22(active low22)
   output             r_cs22;      // registered chip22 select22.   


// Output22 register declarations22

   reg                     smc_n_rd22;
   reg                     smc_n_ext_oe22;
   reg                r_cs22;
   reg                     smc_busy22;
   reg                     n_r_read22;
   reg                     r_full22;
   reg   [3:0]             n_r_we22;
   reg                     n_r_wr22;

   //wire declarations22
   
   wire             smc_mac_done22;       //smc_done22 and  mac_done22 anded22
   wire [2:0]       wait_vaccess_smdone22;//concatenated22 signals22 for case
   reg              half_cycle22;         //used for generating22 half22 cycle
                                                //strobes22
   


//----------------------------------------------------------------------
// Strobe22 Generation22
//
// Individual Write Strobes22
// Write Strobe22 = Byte22 Enable22 & Write Enable22
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal22 concatenation22 for use in case statement22
//----------------------------------------------------------------------

   assign smc_mac_done22 = {smc_done22 & mac_done22};

   assign wait_vaccess_smdone22 = {1'b0,valid_access22,smc_mac_done22};
   
   
//----------------------------------------------------------------------
// Store22 read/write signal22 for duration22 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk22 or negedge n_sys_reset22)
  
     begin
  
        if (~n_sys_reset22)
  
           n_r_read22 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone22)
               
               3'b1xx:
                 
                  n_r_read22 <= n_r_read22;
               
               3'b01x:
                 
                  n_r_read22 <= n_read22;
               
               3'b001:
                 
                  n_r_read22 <= 0;
               
               default:
                 
                  n_r_read22 <= n_r_read22;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store22 chip22 selects22 for duration22 of cycle(s)--turnaround22 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store22 read/write signal22 for duration22 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk22 or negedge n_sys_reset22)
     
      begin
           
         if (~n_sys_reset22)
           
           r_cs22 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone22)
                
                 3'b1xx:
                  
                    r_cs22 <= r_cs22 ;
                
                 3'b01x:
                  
                    r_cs22 <= cs ;
                
                 3'b001:
                  
                    r_cs22 <= 1'b0;
                
                 default:
                  
                    r_cs22 <= r_cs22 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive22 busy output whenever22 smc22 active
//----------------------------------------------------------------------

   always @(posedge sys_clk22 or negedge n_sys_reset22)
     
      begin
          
         if (~n_sys_reset22)
           
            smc_busy22 <= 0;
           
           
         else if (smc_nextstate22 != `SMC_IDLE22)
           
            smc_busy22 <= 1;
           
         else
           
            smc_busy22 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive22 OE22 signal22 to I22/O22 pins22 on ASIC22
//
// Generate22 internal, registered Write strobes22
// The write strobes22 are gated22 with the clock22 later22 to generate half22 
// cycle strobes22
//----------------------------------------------------------------------

  always @(posedge sys_clk22 or negedge n_sys_reset22)
    
     begin
       
        if (~n_sys_reset22)
         
           begin
            
              n_r_we22 <= 4'hF;
              n_r_wr22 <= 1'h1;
            
           end
       

        else if ((n_read22 & valid_access22 & 
                  (smc_nextstate22 != `SMC_STORE22)) |
                 (n_r_read22 & ~valid_access22 & 
                  (smc_nextstate22 != `SMC_STORE22)))      
         
           begin
            
              n_r_we22 <= n_be22;
              n_r_wr22 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we22 <= 4'hF;
              n_r_wr22 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive22 OE22 signal22 to I22/O22 pins22 on ASIC22 -----added by gulbir22
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk22 or negedge n_sys_reset22)
     
     begin
        
        if (~n_sys_reset22)
          
          smc_n_ext_oe22 <= 1;
        
        
        else if ((n_read22 & valid_access22 & 
                  (smc_nextstate22 != `SMC_STORE22)) |
                (n_r_read22 & ~valid_access22 & 
              (smc_nextstate22 != `SMC_STORE22) & 
                 (smc_nextstate22 != `SMC_IDLE22)))      

           smc_n_ext_oe22 <= 0;
        
        else
          
           smc_n_ext_oe22 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate22 half22 and full signals22 for write strobes22
// A full cycle is required22 if wait states22 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate22 half22 cycle signals22 for write strobes22
//----------------------------------------------------------------------

always @(r_smc_currentstate22 or smc_nextstate22 or
            r_full22 or 
            r_wete_store22 or r_ws_store22 or r_wele_store22 or 
            r_ws_count22 or r_wele_count22 or 
            valid_access22 or smc_done22)
  
  begin     
     
       begin
          
          case (r_smc_currentstate22)
            
            `SMC_IDLE22:
              
              begin
                 
                     half_cycle22 = 1'b0;
                 
              end
            
            `SMC_LE22:
              
              begin
                 
                 if (smc_nextstate22 == `SMC_RW22)
                   
                   if( ( ( (r_wete_store22) == r_ws_count22[1:0]) &
                         (r_ws_count22[7:2] == 6'd0) &
                         (r_wele_count22 < 2'd2)
                       ) |
                       (r_ws_count22 == 8'd0)
                     )
                     
                     half_cycle22 = 1'b1 & ~r_full22;
                 
                   else
                     
                     half_cycle22 = 1'b0;
                 
                 else
                   
                   half_cycle22 = 1'b0;
                 
              end
            
            `SMC_RW22, `SMC_FLOAT22:
              
              begin
                 
                 if (smc_nextstate22 == `SMC_RW22)
                   
                   if (valid_access22)

                       
                       half_cycle22 = 1'b0;
                 
                   else if (smc_done22)
                     
                     if( ( (r_wete_store22 == r_ws_store22[1:0]) & 
                           (r_ws_store22[7:2] == 6'd0) & 
                           (r_wele_store22 == 2'd0)
                         ) | 
                         (r_ws_store22 == 8'd0)
                       )
                       
                       half_cycle22 = 1'b1 & ~r_full22;
                 
                     else
                       
                       half_cycle22 = 1'b0;
                 
                   else
                     
                     if (r_wete_store22 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count22[1:0]) & 
                            (r_ws_count22[7:2] == 6'd1) &
                            (r_wele_count22 < 2'd2)
                          )
                         
                         half_cycle22 = 1'b1 & ~r_full22;
                 
                       else
                         
                         half_cycle22 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store22+2'd1) == r_ws_count22[1:0]) & 
                              (r_ws_count22[7:2] == 6'd0) & 
                              (r_wele_count22 < 2'd2)
                            )
                          )
                         
                         half_cycle22 = 1'b1 & ~r_full22;
                 
                       else
                         
                         half_cycle22 = 1'b0;
                 
                 else
                   
                   half_cycle22 = 1'b0;
                 
              end
            
            `SMC_STORE22:
              
              begin
                 
                 if (smc_nextstate22 == `SMC_RW22)

                   if( ( ( (r_wete_store22) == r_ws_count22[1:0]) & 
                         (r_ws_count22[7:2] == 6'd0) & 
                         (r_wele_count22 < 2'd2)
                       ) | 
                       (r_ws_count22 == 8'd0)
                     )
                     
                     half_cycle22 = 1'b1 & ~r_full22;
                 
                   else
                     
                     half_cycle22 = 1'b0;
                 
                 else
                   
                   half_cycle22 = 1'b0;
                 
              end
            
            default:
              
              half_cycle22 = 1'b0;
            
          endcase // r_smc_currentstate22
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal22 generation22
//----------------------------------------------------------------------

 always @(posedge sys_clk22 or negedge n_sys_reset22)
             
   begin
      
      if (~n_sys_reset22)
        
        begin
           
           r_full22 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate22)
             
             `SMC_IDLE22:
               
               begin
                  
                  if (smc_nextstate22 == `SMC_RW22)
                    
                         
                         r_full22 <= 1'b0;
                       
                  else
                        
                       r_full22 <= 1'b0;
                       
               end
             
          `SMC_LE22:
            
          begin
             
             if (smc_nextstate22 == `SMC_RW22)
               
                  if( ( ( (r_wete_store22) < r_ws_count22[1:0]) | 
                        (r_ws_count22[7:2] != 6'd0)
                      ) & 
                      (r_wele_count22 < 2'd2)
                    )
                    
                    r_full22 <= 1'b1;
                  
                  else
                    
                    r_full22 <= 1'b0;
                  
             else
               
                  r_full22 <= 1'b0;
                  
          end
          
          `SMC_RW22, `SMC_FLOAT22:
            
            begin
               
               if (smc_nextstate22 == `SMC_RW22)
                 
                 begin
                    
                    if (valid_access22)
                      
                           
                           r_full22 <= 1'b0;
                         
                    else if (smc_done22)
                      
                         if( ( ( (r_wete_store22 < r_ws_store22[1:0]) | 
                                 (r_ws_store22[7:2] != 6'd0)
                               ) & 
                               (r_wele_store22 == 2'd0)
                             )
                           )
                           
                           r_full22 <= 1'b1;
                         
                         else
                           
                           r_full22 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store22 == 2'd3)
                           
                           if( ( (r_ws_count22[7:0] > 8'd4)
                               ) & 
                               (r_wele_count22 < 2'd2)
                             )
                             
                             r_full22 <= 1'b1;
                         
                           else
                             
                             r_full22 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store22 + 2'd1) < 
                                         r_ws_count22[1:0]
                                       )
                                     ) |
                                     (r_ws_count22[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count22 < 2'd2)
                                 )
                           
                           r_full22 <= 1'b1;
                         
                         else
                           
                           r_full22 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full22 <= 1'b0;
               
            end
             
             `SMC_STORE22:
               
               begin
                  
                  if (smc_nextstate22 == `SMC_RW22)

                     if ( ( ( (r_wete_store22) < r_ws_count22[1:0]) | 
                            (r_ws_count22[7:2] != 6'd0)
                          ) & 
                          (r_wele_count22 == 2'd0)
                        )
                         
                         r_full22 <= 1'b1;
                       
                       else
                         
                         r_full22 <= 1'b0;
                       
                  else
                    
                       r_full22 <= 1'b0;
                       
               end
             
             default:
               
                  r_full22 <= 1'b0;
                  
           endcase // r_smc_currentstate22
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate22 Read Strobe22
//----------------------------------------------------------------------
 
  always @(posedge sys_clk22 or negedge n_sys_reset22)
  
  begin
     
     if (~n_sys_reset22)
  
        smc_n_rd22 <= 1'h1;
      
      
     else if (smc_nextstate22 == `SMC_RW22)
  
     begin
  
        if (valid_access22)
  
        begin
  
  
              smc_n_rd22 <= n_read22;
  
  
        end
  
        else if ((r_smc_currentstate22 == `SMC_LE22) | 
                    (r_smc_currentstate22 == `SMC_STORE22))

        begin
           
           if( (r_oete_store22 < r_ws_store22[1:0]) | 
               (r_ws_store22[7:2] != 6'd0) |
               ( (r_oete_store22 == r_ws_store22[1:0]) & 
                 (r_ws_store22[7:2] == 6'd0)
               ) |
               (r_ws_store22 == 8'd0) 
             )
             
             smc_n_rd22 <= n_r_read22;
           
           else
             
             smc_n_rd22 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store22) < r_ws_count22[1:0]) | 
               (r_ws_count22[7:2] != 6'd0) |
               (r_ws_count22 == 8'd0) 
             )
             
              smc_n_rd22 <= n_r_read22;
           
           else

              smc_n_rd22 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd22 <= 1'b1;
     
  end
   
   
 
endmodule


