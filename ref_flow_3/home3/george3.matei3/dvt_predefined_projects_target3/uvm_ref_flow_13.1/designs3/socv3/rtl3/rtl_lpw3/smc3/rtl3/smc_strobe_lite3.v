//File3 name   : smc_strobe_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`include "smc_defs_lite3.v"

module smc_strobe_lite3  (

                    //inputs3

                    sys_clk3,
                    n_sys_reset3,
                    valid_access3,
                    n_read3,
                    cs,
                    r_smc_currentstate3,
                    smc_nextstate3,
                    n_be3,
                    r_wele_count3,
                    r_wele_store3,
                    r_wete_store3,
                    r_oete_store3,
                    r_ws_count3,
                    r_ws_store3,
                    smc_done3,
                    mac_done3,

                    //outputs3

                    smc_n_rd3,
                    smc_n_ext_oe3,
                    smc_busy3,
                    n_r_read3,
                    r_cs3,
                    r_full3,
                    n_r_we3,
                    n_r_wr3);



//Parameters3  -  Values3 in smc_defs3.v

 


// I3/O3

   input                   sys_clk3;      //System3 clock3
   input                   n_sys_reset3;  //System3 reset (Active3 LOW3)
   input                   valid_access3; //load3 values are valid if high3
   input                   n_read3;       //Active3 low3 read signal3
   input              cs;           //registered chip3 select3
   input [4:0]             r_smc_currentstate3;//current state
   input [4:0]             smc_nextstate3;//next state  
   input [3:0]             n_be3;         //Unregistered3 Byte3 strobes3
   input [1:0]             r_wele_count3; //Write counter
   input [1:0]             r_wete_store3; //write strobe3 trailing3 edge store3
   input [1:0]             r_oete_store3; //read strobe3
   input [1:0]             r_wele_store3; //write strobe3 leading3 edge store3
   input [7:0]             r_ws_count3;   //wait state count
   input [7:0]             r_ws_store3;   //wait state store3
   input                   smc_done3;  //one access completed
   input                   mac_done3;  //All cycles3 in a multiple access
   
   
   output                  smc_n_rd3;     // EMI3 read stobe3 (Active3 LOW3)
   output                  smc_n_ext_oe3; // Enable3 External3 bus drivers3.
                                                          //  (CS3 & ~RD3)
   output                  smc_busy3;  // smc3 busy
   output                  n_r_read3;  // Store3 RW strobe3 for multiple
                                                         //  accesses
   output                  r_full3;    // Full cycle write strobe3
   output [3:0]            n_r_we3;    // write enable strobe3(active low3)
   output                  n_r_wr3;    // write strobe3(active low3)
   output             r_cs3;      // registered chip3 select3.   


// Output3 register declarations3

   reg                     smc_n_rd3;
   reg                     smc_n_ext_oe3;
   reg                r_cs3;
   reg                     smc_busy3;
   reg                     n_r_read3;
   reg                     r_full3;
   reg   [3:0]             n_r_we3;
   reg                     n_r_wr3;

   //wire declarations3
   
   wire             smc_mac_done3;       //smc_done3 and  mac_done3 anded3
   wire [2:0]       wait_vaccess_smdone3;//concatenated3 signals3 for case
   reg              half_cycle3;         //used for generating3 half3 cycle
                                                //strobes3
   


//----------------------------------------------------------------------
// Strobe3 Generation3
//
// Individual Write Strobes3
// Write Strobe3 = Byte3 Enable3 & Write Enable3
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal3 concatenation3 for use in case statement3
//----------------------------------------------------------------------

   assign smc_mac_done3 = {smc_done3 & mac_done3};

   assign wait_vaccess_smdone3 = {1'b0,valid_access3,smc_mac_done3};
   
   
//----------------------------------------------------------------------
// Store3 read/write signal3 for duration3 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk3 or negedge n_sys_reset3)
  
     begin
  
        if (~n_sys_reset3)
  
           n_r_read3 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone3)
               
               3'b1xx:
                 
                  n_r_read3 <= n_r_read3;
               
               3'b01x:
                 
                  n_r_read3 <= n_read3;
               
               3'b001:
                 
                  n_r_read3 <= 0;
               
               default:
                 
                  n_r_read3 <= n_r_read3;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store3 chip3 selects3 for duration3 of cycle(s)--turnaround3 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store3 read/write signal3 for duration3 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk3 or negedge n_sys_reset3)
     
      begin
           
         if (~n_sys_reset3)
           
           r_cs3 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone3)
                
                 3'b1xx:
                  
                    r_cs3 <= r_cs3 ;
                
                 3'b01x:
                  
                    r_cs3 <= cs ;
                
                 3'b001:
                  
                    r_cs3 <= 1'b0;
                
                 default:
                  
                    r_cs3 <= r_cs3 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive3 busy output whenever3 smc3 active
//----------------------------------------------------------------------

   always @(posedge sys_clk3 or negedge n_sys_reset3)
     
      begin
          
         if (~n_sys_reset3)
           
            smc_busy3 <= 0;
           
           
         else if (smc_nextstate3 != `SMC_IDLE3)
           
            smc_busy3 <= 1;
           
         else
           
            smc_busy3 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive3 OE3 signal3 to I3/O3 pins3 on ASIC3
//
// Generate3 internal, registered Write strobes3
// The write strobes3 are gated3 with the clock3 later3 to generate half3 
// cycle strobes3
//----------------------------------------------------------------------

  always @(posedge sys_clk3 or negedge n_sys_reset3)
    
     begin
       
        if (~n_sys_reset3)
         
           begin
            
              n_r_we3 <= 4'hF;
              n_r_wr3 <= 1'h1;
            
           end
       

        else if ((n_read3 & valid_access3 & 
                  (smc_nextstate3 != `SMC_STORE3)) |
                 (n_r_read3 & ~valid_access3 & 
                  (smc_nextstate3 != `SMC_STORE3)))      
         
           begin
            
              n_r_we3 <= n_be3;
              n_r_wr3 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we3 <= 4'hF;
              n_r_wr3 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive3 OE3 signal3 to I3/O3 pins3 on ASIC3 -----added by gulbir3
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk3 or negedge n_sys_reset3)
     
     begin
        
        if (~n_sys_reset3)
          
          smc_n_ext_oe3 <= 1;
        
        
        else if ((n_read3 & valid_access3 & 
                  (smc_nextstate3 != `SMC_STORE3)) |
                (n_r_read3 & ~valid_access3 & 
              (smc_nextstate3 != `SMC_STORE3) & 
                 (smc_nextstate3 != `SMC_IDLE3)))      

           smc_n_ext_oe3 <= 0;
        
        else
          
           smc_n_ext_oe3 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate3 half3 and full signals3 for write strobes3
// A full cycle is required3 if wait states3 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate3 half3 cycle signals3 for write strobes3
//----------------------------------------------------------------------

always @(r_smc_currentstate3 or smc_nextstate3 or
            r_full3 or 
            r_wete_store3 or r_ws_store3 or r_wele_store3 or 
            r_ws_count3 or r_wele_count3 or 
            valid_access3 or smc_done3)
  
  begin     
     
       begin
          
          case (r_smc_currentstate3)
            
            `SMC_IDLE3:
              
              begin
                 
                     half_cycle3 = 1'b0;
                 
              end
            
            `SMC_LE3:
              
              begin
                 
                 if (smc_nextstate3 == `SMC_RW3)
                   
                   if( ( ( (r_wete_store3) == r_ws_count3[1:0]) &
                         (r_ws_count3[7:2] == 6'd0) &
                         (r_wele_count3 < 2'd2)
                       ) |
                       (r_ws_count3 == 8'd0)
                     )
                     
                     half_cycle3 = 1'b1 & ~r_full3;
                 
                   else
                     
                     half_cycle3 = 1'b0;
                 
                 else
                   
                   half_cycle3 = 1'b0;
                 
              end
            
            `SMC_RW3, `SMC_FLOAT3:
              
              begin
                 
                 if (smc_nextstate3 == `SMC_RW3)
                   
                   if (valid_access3)

                       
                       half_cycle3 = 1'b0;
                 
                   else if (smc_done3)
                     
                     if( ( (r_wete_store3 == r_ws_store3[1:0]) & 
                           (r_ws_store3[7:2] == 6'd0) & 
                           (r_wele_store3 == 2'd0)
                         ) | 
                         (r_ws_store3 == 8'd0)
                       )
                       
                       half_cycle3 = 1'b1 & ~r_full3;
                 
                     else
                       
                       half_cycle3 = 1'b0;
                 
                   else
                     
                     if (r_wete_store3 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count3[1:0]) & 
                            (r_ws_count3[7:2] == 6'd1) &
                            (r_wele_count3 < 2'd2)
                          )
                         
                         half_cycle3 = 1'b1 & ~r_full3;
                 
                       else
                         
                         half_cycle3 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store3+2'd1) == r_ws_count3[1:0]) & 
                              (r_ws_count3[7:2] == 6'd0) & 
                              (r_wele_count3 < 2'd2)
                            )
                          )
                         
                         half_cycle3 = 1'b1 & ~r_full3;
                 
                       else
                         
                         half_cycle3 = 1'b0;
                 
                 else
                   
                   half_cycle3 = 1'b0;
                 
              end
            
            `SMC_STORE3:
              
              begin
                 
                 if (smc_nextstate3 == `SMC_RW3)

                   if( ( ( (r_wete_store3) == r_ws_count3[1:0]) & 
                         (r_ws_count3[7:2] == 6'd0) & 
                         (r_wele_count3 < 2'd2)
                       ) | 
                       (r_ws_count3 == 8'd0)
                     )
                     
                     half_cycle3 = 1'b1 & ~r_full3;
                 
                   else
                     
                     half_cycle3 = 1'b0;
                 
                 else
                   
                   half_cycle3 = 1'b0;
                 
              end
            
            default:
              
              half_cycle3 = 1'b0;
            
          endcase // r_smc_currentstate3
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal3 generation3
//----------------------------------------------------------------------

 always @(posedge sys_clk3 or negedge n_sys_reset3)
             
   begin
      
      if (~n_sys_reset3)
        
        begin
           
           r_full3 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate3)
             
             `SMC_IDLE3:
               
               begin
                  
                  if (smc_nextstate3 == `SMC_RW3)
                    
                         
                         r_full3 <= 1'b0;
                       
                  else
                        
                       r_full3 <= 1'b0;
                       
               end
             
          `SMC_LE3:
            
          begin
             
             if (smc_nextstate3 == `SMC_RW3)
               
                  if( ( ( (r_wete_store3) < r_ws_count3[1:0]) | 
                        (r_ws_count3[7:2] != 6'd0)
                      ) & 
                      (r_wele_count3 < 2'd2)
                    )
                    
                    r_full3 <= 1'b1;
                  
                  else
                    
                    r_full3 <= 1'b0;
                  
             else
               
                  r_full3 <= 1'b0;
                  
          end
          
          `SMC_RW3, `SMC_FLOAT3:
            
            begin
               
               if (smc_nextstate3 == `SMC_RW3)
                 
                 begin
                    
                    if (valid_access3)
                      
                           
                           r_full3 <= 1'b0;
                         
                    else if (smc_done3)
                      
                         if( ( ( (r_wete_store3 < r_ws_store3[1:0]) | 
                                 (r_ws_store3[7:2] != 6'd0)
                               ) & 
                               (r_wele_store3 == 2'd0)
                             )
                           )
                           
                           r_full3 <= 1'b1;
                         
                         else
                           
                           r_full3 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store3 == 2'd3)
                           
                           if( ( (r_ws_count3[7:0] > 8'd4)
                               ) & 
                               (r_wele_count3 < 2'd2)
                             )
                             
                             r_full3 <= 1'b1;
                         
                           else
                             
                             r_full3 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store3 + 2'd1) < 
                                         r_ws_count3[1:0]
                                       )
                                     ) |
                                     (r_ws_count3[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count3 < 2'd2)
                                 )
                           
                           r_full3 <= 1'b1;
                         
                         else
                           
                           r_full3 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full3 <= 1'b0;
               
            end
             
             `SMC_STORE3:
               
               begin
                  
                  if (smc_nextstate3 == `SMC_RW3)

                     if ( ( ( (r_wete_store3) < r_ws_count3[1:0]) | 
                            (r_ws_count3[7:2] != 6'd0)
                          ) & 
                          (r_wele_count3 == 2'd0)
                        )
                         
                         r_full3 <= 1'b1;
                       
                       else
                         
                         r_full3 <= 1'b0;
                       
                  else
                    
                       r_full3 <= 1'b0;
                       
               end
             
             default:
               
                  r_full3 <= 1'b0;
                  
           endcase // r_smc_currentstate3
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate3 Read Strobe3
//----------------------------------------------------------------------
 
  always @(posedge sys_clk3 or negedge n_sys_reset3)
  
  begin
     
     if (~n_sys_reset3)
  
        smc_n_rd3 <= 1'h1;
      
      
     else if (smc_nextstate3 == `SMC_RW3)
  
     begin
  
        if (valid_access3)
  
        begin
  
  
              smc_n_rd3 <= n_read3;
  
  
        end
  
        else if ((r_smc_currentstate3 == `SMC_LE3) | 
                    (r_smc_currentstate3 == `SMC_STORE3))

        begin
           
           if( (r_oete_store3 < r_ws_store3[1:0]) | 
               (r_ws_store3[7:2] != 6'd0) |
               ( (r_oete_store3 == r_ws_store3[1:0]) & 
                 (r_ws_store3[7:2] == 6'd0)
               ) |
               (r_ws_store3 == 8'd0) 
             )
             
             smc_n_rd3 <= n_r_read3;
           
           else
             
             smc_n_rd3 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store3) < r_ws_count3[1:0]) | 
               (r_ws_count3[7:2] != 6'd0) |
               (r_ws_count3 == 8'd0) 
             )
             
              smc_n_rd3 <= n_r_read3;
           
           else

              smc_n_rd3 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd3 <= 1'b1;
     
  end
   
   
 
endmodule


