//File10 name   : smc_strobe_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`include "smc_defs_lite10.v"

module smc_strobe_lite10  (

                    //inputs10

                    sys_clk10,
                    n_sys_reset10,
                    valid_access10,
                    n_read10,
                    cs,
                    r_smc_currentstate10,
                    smc_nextstate10,
                    n_be10,
                    r_wele_count10,
                    r_wele_store10,
                    r_wete_store10,
                    r_oete_store10,
                    r_ws_count10,
                    r_ws_store10,
                    smc_done10,
                    mac_done10,

                    //outputs10

                    smc_n_rd10,
                    smc_n_ext_oe10,
                    smc_busy10,
                    n_r_read10,
                    r_cs10,
                    r_full10,
                    n_r_we10,
                    n_r_wr10);



//Parameters10  -  Values10 in smc_defs10.v

 


// I10/O10

   input                   sys_clk10;      //System10 clock10
   input                   n_sys_reset10;  //System10 reset (Active10 LOW10)
   input                   valid_access10; //load10 values are valid if high10
   input                   n_read10;       //Active10 low10 read signal10
   input              cs;           //registered chip10 select10
   input [4:0]             r_smc_currentstate10;//current state
   input [4:0]             smc_nextstate10;//next state  
   input [3:0]             n_be10;         //Unregistered10 Byte10 strobes10
   input [1:0]             r_wele_count10; //Write counter
   input [1:0]             r_wete_store10; //write strobe10 trailing10 edge store10
   input [1:0]             r_oete_store10; //read strobe10
   input [1:0]             r_wele_store10; //write strobe10 leading10 edge store10
   input [7:0]             r_ws_count10;   //wait state count
   input [7:0]             r_ws_store10;   //wait state store10
   input                   smc_done10;  //one access completed
   input                   mac_done10;  //All cycles10 in a multiple access
   
   
   output                  smc_n_rd10;     // EMI10 read stobe10 (Active10 LOW10)
   output                  smc_n_ext_oe10; // Enable10 External10 bus drivers10.
                                                          //  (CS10 & ~RD10)
   output                  smc_busy10;  // smc10 busy
   output                  n_r_read10;  // Store10 RW strobe10 for multiple
                                                         //  accesses
   output                  r_full10;    // Full cycle write strobe10
   output [3:0]            n_r_we10;    // write enable strobe10(active low10)
   output                  n_r_wr10;    // write strobe10(active low10)
   output             r_cs10;      // registered chip10 select10.   


// Output10 register declarations10

   reg                     smc_n_rd10;
   reg                     smc_n_ext_oe10;
   reg                r_cs10;
   reg                     smc_busy10;
   reg                     n_r_read10;
   reg                     r_full10;
   reg   [3:0]             n_r_we10;
   reg                     n_r_wr10;

   //wire declarations10
   
   wire             smc_mac_done10;       //smc_done10 and  mac_done10 anded10
   wire [2:0]       wait_vaccess_smdone10;//concatenated10 signals10 for case
   reg              half_cycle10;         //used for generating10 half10 cycle
                                                //strobes10
   


//----------------------------------------------------------------------
// Strobe10 Generation10
//
// Individual Write Strobes10
// Write Strobe10 = Byte10 Enable10 & Write Enable10
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal10 concatenation10 for use in case statement10
//----------------------------------------------------------------------

   assign smc_mac_done10 = {smc_done10 & mac_done10};

   assign wait_vaccess_smdone10 = {1'b0,valid_access10,smc_mac_done10};
   
   
//----------------------------------------------------------------------
// Store10 read/write signal10 for duration10 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk10 or negedge n_sys_reset10)
  
     begin
  
        if (~n_sys_reset10)
  
           n_r_read10 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone10)
               
               3'b1xx:
                 
                  n_r_read10 <= n_r_read10;
               
               3'b01x:
                 
                  n_r_read10 <= n_read10;
               
               3'b001:
                 
                  n_r_read10 <= 0;
               
               default:
                 
                  n_r_read10 <= n_r_read10;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store10 chip10 selects10 for duration10 of cycle(s)--turnaround10 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store10 read/write signal10 for duration10 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk10 or negedge n_sys_reset10)
     
      begin
           
         if (~n_sys_reset10)
           
           r_cs10 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone10)
                
                 3'b1xx:
                  
                    r_cs10 <= r_cs10 ;
                
                 3'b01x:
                  
                    r_cs10 <= cs ;
                
                 3'b001:
                  
                    r_cs10 <= 1'b0;
                
                 default:
                  
                    r_cs10 <= r_cs10 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive10 busy output whenever10 smc10 active
//----------------------------------------------------------------------

   always @(posedge sys_clk10 or negedge n_sys_reset10)
     
      begin
          
         if (~n_sys_reset10)
           
            smc_busy10 <= 0;
           
           
         else if (smc_nextstate10 != `SMC_IDLE10)
           
            smc_busy10 <= 1;
           
         else
           
            smc_busy10 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive10 OE10 signal10 to I10/O10 pins10 on ASIC10
//
// Generate10 internal, registered Write strobes10
// The write strobes10 are gated10 with the clock10 later10 to generate half10 
// cycle strobes10
//----------------------------------------------------------------------

  always @(posedge sys_clk10 or negedge n_sys_reset10)
    
     begin
       
        if (~n_sys_reset10)
         
           begin
            
              n_r_we10 <= 4'hF;
              n_r_wr10 <= 1'h1;
            
           end
       

        else if ((n_read10 & valid_access10 & 
                  (smc_nextstate10 != `SMC_STORE10)) |
                 (n_r_read10 & ~valid_access10 & 
                  (smc_nextstate10 != `SMC_STORE10)))      
         
           begin
            
              n_r_we10 <= n_be10;
              n_r_wr10 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we10 <= 4'hF;
              n_r_wr10 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive10 OE10 signal10 to I10/O10 pins10 on ASIC10 -----added by gulbir10
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk10 or negedge n_sys_reset10)
     
     begin
        
        if (~n_sys_reset10)
          
          smc_n_ext_oe10 <= 1;
        
        
        else if ((n_read10 & valid_access10 & 
                  (smc_nextstate10 != `SMC_STORE10)) |
                (n_r_read10 & ~valid_access10 & 
              (smc_nextstate10 != `SMC_STORE10) & 
                 (smc_nextstate10 != `SMC_IDLE10)))      

           smc_n_ext_oe10 <= 0;
        
        else
          
           smc_n_ext_oe10 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate10 half10 and full signals10 for write strobes10
// A full cycle is required10 if wait states10 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate10 half10 cycle signals10 for write strobes10
//----------------------------------------------------------------------

always @(r_smc_currentstate10 or smc_nextstate10 or
            r_full10 or 
            r_wete_store10 or r_ws_store10 or r_wele_store10 or 
            r_ws_count10 or r_wele_count10 or 
            valid_access10 or smc_done10)
  
  begin     
     
       begin
          
          case (r_smc_currentstate10)
            
            `SMC_IDLE10:
              
              begin
                 
                     half_cycle10 = 1'b0;
                 
              end
            
            `SMC_LE10:
              
              begin
                 
                 if (smc_nextstate10 == `SMC_RW10)
                   
                   if( ( ( (r_wete_store10) == r_ws_count10[1:0]) &
                         (r_ws_count10[7:2] == 6'd0) &
                         (r_wele_count10 < 2'd2)
                       ) |
                       (r_ws_count10 == 8'd0)
                     )
                     
                     half_cycle10 = 1'b1 & ~r_full10;
                 
                   else
                     
                     half_cycle10 = 1'b0;
                 
                 else
                   
                   half_cycle10 = 1'b0;
                 
              end
            
            `SMC_RW10, `SMC_FLOAT10:
              
              begin
                 
                 if (smc_nextstate10 == `SMC_RW10)
                   
                   if (valid_access10)

                       
                       half_cycle10 = 1'b0;
                 
                   else if (smc_done10)
                     
                     if( ( (r_wete_store10 == r_ws_store10[1:0]) & 
                           (r_ws_store10[7:2] == 6'd0) & 
                           (r_wele_store10 == 2'd0)
                         ) | 
                         (r_ws_store10 == 8'd0)
                       )
                       
                       half_cycle10 = 1'b1 & ~r_full10;
                 
                     else
                       
                       half_cycle10 = 1'b0;
                 
                   else
                     
                     if (r_wete_store10 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count10[1:0]) & 
                            (r_ws_count10[7:2] == 6'd1) &
                            (r_wele_count10 < 2'd2)
                          )
                         
                         half_cycle10 = 1'b1 & ~r_full10;
                 
                       else
                         
                         half_cycle10 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store10+2'd1) == r_ws_count10[1:0]) & 
                              (r_ws_count10[7:2] == 6'd0) & 
                              (r_wele_count10 < 2'd2)
                            )
                          )
                         
                         half_cycle10 = 1'b1 & ~r_full10;
                 
                       else
                         
                         half_cycle10 = 1'b0;
                 
                 else
                   
                   half_cycle10 = 1'b0;
                 
              end
            
            `SMC_STORE10:
              
              begin
                 
                 if (smc_nextstate10 == `SMC_RW10)

                   if( ( ( (r_wete_store10) == r_ws_count10[1:0]) & 
                         (r_ws_count10[7:2] == 6'd0) & 
                         (r_wele_count10 < 2'd2)
                       ) | 
                       (r_ws_count10 == 8'd0)
                     )
                     
                     half_cycle10 = 1'b1 & ~r_full10;
                 
                   else
                     
                     half_cycle10 = 1'b0;
                 
                 else
                   
                   half_cycle10 = 1'b0;
                 
              end
            
            default:
              
              half_cycle10 = 1'b0;
            
          endcase // r_smc_currentstate10
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal10 generation10
//----------------------------------------------------------------------

 always @(posedge sys_clk10 or negedge n_sys_reset10)
             
   begin
      
      if (~n_sys_reset10)
        
        begin
           
           r_full10 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate10)
             
             `SMC_IDLE10:
               
               begin
                  
                  if (smc_nextstate10 == `SMC_RW10)
                    
                         
                         r_full10 <= 1'b0;
                       
                  else
                        
                       r_full10 <= 1'b0;
                       
               end
             
          `SMC_LE10:
            
          begin
             
             if (smc_nextstate10 == `SMC_RW10)
               
                  if( ( ( (r_wete_store10) < r_ws_count10[1:0]) | 
                        (r_ws_count10[7:2] != 6'd0)
                      ) & 
                      (r_wele_count10 < 2'd2)
                    )
                    
                    r_full10 <= 1'b1;
                  
                  else
                    
                    r_full10 <= 1'b0;
                  
             else
               
                  r_full10 <= 1'b0;
                  
          end
          
          `SMC_RW10, `SMC_FLOAT10:
            
            begin
               
               if (smc_nextstate10 == `SMC_RW10)
                 
                 begin
                    
                    if (valid_access10)
                      
                           
                           r_full10 <= 1'b0;
                         
                    else if (smc_done10)
                      
                         if( ( ( (r_wete_store10 < r_ws_store10[1:0]) | 
                                 (r_ws_store10[7:2] != 6'd0)
                               ) & 
                               (r_wele_store10 == 2'd0)
                             )
                           )
                           
                           r_full10 <= 1'b1;
                         
                         else
                           
                           r_full10 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store10 == 2'd3)
                           
                           if( ( (r_ws_count10[7:0] > 8'd4)
                               ) & 
                               (r_wele_count10 < 2'd2)
                             )
                             
                             r_full10 <= 1'b1;
                         
                           else
                             
                             r_full10 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store10 + 2'd1) < 
                                         r_ws_count10[1:0]
                                       )
                                     ) |
                                     (r_ws_count10[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count10 < 2'd2)
                                 )
                           
                           r_full10 <= 1'b1;
                         
                         else
                           
                           r_full10 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full10 <= 1'b0;
               
            end
             
             `SMC_STORE10:
               
               begin
                  
                  if (smc_nextstate10 == `SMC_RW10)

                     if ( ( ( (r_wete_store10) < r_ws_count10[1:0]) | 
                            (r_ws_count10[7:2] != 6'd0)
                          ) & 
                          (r_wele_count10 == 2'd0)
                        )
                         
                         r_full10 <= 1'b1;
                       
                       else
                         
                         r_full10 <= 1'b0;
                       
                  else
                    
                       r_full10 <= 1'b0;
                       
               end
             
             default:
               
                  r_full10 <= 1'b0;
                  
           endcase // r_smc_currentstate10
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate10 Read Strobe10
//----------------------------------------------------------------------
 
  always @(posedge sys_clk10 or negedge n_sys_reset10)
  
  begin
     
     if (~n_sys_reset10)
  
        smc_n_rd10 <= 1'h1;
      
      
     else if (smc_nextstate10 == `SMC_RW10)
  
     begin
  
        if (valid_access10)
  
        begin
  
  
              smc_n_rd10 <= n_read10;
  
  
        end
  
        else if ((r_smc_currentstate10 == `SMC_LE10) | 
                    (r_smc_currentstate10 == `SMC_STORE10))

        begin
           
           if( (r_oete_store10 < r_ws_store10[1:0]) | 
               (r_ws_store10[7:2] != 6'd0) |
               ( (r_oete_store10 == r_ws_store10[1:0]) & 
                 (r_ws_store10[7:2] == 6'd0)
               ) |
               (r_ws_store10 == 8'd0) 
             )
             
             smc_n_rd10 <= n_r_read10;
           
           else
             
             smc_n_rd10 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store10) < r_ws_count10[1:0]) | 
               (r_ws_count10[7:2] != 6'd0) |
               (r_ws_count10 == 8'd0) 
             )
             
              smc_n_rd10 <= n_r_read10;
           
           else

              smc_n_rd10 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd10 <= 1'b1;
     
  end
   
   
 
endmodule


