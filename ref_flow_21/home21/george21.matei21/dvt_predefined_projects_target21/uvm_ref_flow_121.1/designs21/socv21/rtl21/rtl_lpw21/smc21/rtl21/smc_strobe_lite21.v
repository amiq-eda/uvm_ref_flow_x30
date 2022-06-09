//File21 name   : smc_strobe_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`include "smc_defs_lite21.v"

module smc_strobe_lite21  (

                    //inputs21

                    sys_clk21,
                    n_sys_reset21,
                    valid_access21,
                    n_read21,
                    cs,
                    r_smc_currentstate21,
                    smc_nextstate21,
                    n_be21,
                    r_wele_count21,
                    r_wele_store21,
                    r_wete_store21,
                    r_oete_store21,
                    r_ws_count21,
                    r_ws_store21,
                    smc_done21,
                    mac_done21,

                    //outputs21

                    smc_n_rd21,
                    smc_n_ext_oe21,
                    smc_busy21,
                    n_r_read21,
                    r_cs21,
                    r_full21,
                    n_r_we21,
                    n_r_wr21);



//Parameters21  -  Values21 in smc_defs21.v

 


// I21/O21

   input                   sys_clk21;      //System21 clock21
   input                   n_sys_reset21;  //System21 reset (Active21 LOW21)
   input                   valid_access21; //load21 values are valid if high21
   input                   n_read21;       //Active21 low21 read signal21
   input              cs;           //registered chip21 select21
   input [4:0]             r_smc_currentstate21;//current state
   input [4:0]             smc_nextstate21;//next state  
   input [3:0]             n_be21;         //Unregistered21 Byte21 strobes21
   input [1:0]             r_wele_count21; //Write counter
   input [1:0]             r_wete_store21; //write strobe21 trailing21 edge store21
   input [1:0]             r_oete_store21; //read strobe21
   input [1:0]             r_wele_store21; //write strobe21 leading21 edge store21
   input [7:0]             r_ws_count21;   //wait state count
   input [7:0]             r_ws_store21;   //wait state store21
   input                   smc_done21;  //one access completed
   input                   mac_done21;  //All cycles21 in a multiple access
   
   
   output                  smc_n_rd21;     // EMI21 read stobe21 (Active21 LOW21)
   output                  smc_n_ext_oe21; // Enable21 External21 bus drivers21.
                                                          //  (CS21 & ~RD21)
   output                  smc_busy21;  // smc21 busy
   output                  n_r_read21;  // Store21 RW strobe21 for multiple
                                                         //  accesses
   output                  r_full21;    // Full cycle write strobe21
   output [3:0]            n_r_we21;    // write enable strobe21(active low21)
   output                  n_r_wr21;    // write strobe21(active low21)
   output             r_cs21;      // registered chip21 select21.   


// Output21 register declarations21

   reg                     smc_n_rd21;
   reg                     smc_n_ext_oe21;
   reg                r_cs21;
   reg                     smc_busy21;
   reg                     n_r_read21;
   reg                     r_full21;
   reg   [3:0]             n_r_we21;
   reg                     n_r_wr21;

   //wire declarations21
   
   wire             smc_mac_done21;       //smc_done21 and  mac_done21 anded21
   wire [2:0]       wait_vaccess_smdone21;//concatenated21 signals21 for case
   reg              half_cycle21;         //used for generating21 half21 cycle
                                                //strobes21
   


//----------------------------------------------------------------------
// Strobe21 Generation21
//
// Individual Write Strobes21
// Write Strobe21 = Byte21 Enable21 & Write Enable21
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal21 concatenation21 for use in case statement21
//----------------------------------------------------------------------

   assign smc_mac_done21 = {smc_done21 & mac_done21};

   assign wait_vaccess_smdone21 = {1'b0,valid_access21,smc_mac_done21};
   
   
//----------------------------------------------------------------------
// Store21 read/write signal21 for duration21 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk21 or negedge n_sys_reset21)
  
     begin
  
        if (~n_sys_reset21)
  
           n_r_read21 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone21)
               
               3'b1xx:
                 
                  n_r_read21 <= n_r_read21;
               
               3'b01x:
                 
                  n_r_read21 <= n_read21;
               
               3'b001:
                 
                  n_r_read21 <= 0;
               
               default:
                 
                  n_r_read21 <= n_r_read21;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store21 chip21 selects21 for duration21 of cycle(s)--turnaround21 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store21 read/write signal21 for duration21 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk21 or negedge n_sys_reset21)
     
      begin
           
         if (~n_sys_reset21)
           
           r_cs21 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone21)
                
                 3'b1xx:
                  
                    r_cs21 <= r_cs21 ;
                
                 3'b01x:
                  
                    r_cs21 <= cs ;
                
                 3'b001:
                  
                    r_cs21 <= 1'b0;
                
                 default:
                  
                    r_cs21 <= r_cs21 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive21 busy output whenever21 smc21 active
//----------------------------------------------------------------------

   always @(posedge sys_clk21 or negedge n_sys_reset21)
     
      begin
          
         if (~n_sys_reset21)
           
            smc_busy21 <= 0;
           
           
         else if (smc_nextstate21 != `SMC_IDLE21)
           
            smc_busy21 <= 1;
           
         else
           
            smc_busy21 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive21 OE21 signal21 to I21/O21 pins21 on ASIC21
//
// Generate21 internal, registered Write strobes21
// The write strobes21 are gated21 with the clock21 later21 to generate half21 
// cycle strobes21
//----------------------------------------------------------------------

  always @(posedge sys_clk21 or negedge n_sys_reset21)
    
     begin
       
        if (~n_sys_reset21)
         
           begin
            
              n_r_we21 <= 4'hF;
              n_r_wr21 <= 1'h1;
            
           end
       

        else if ((n_read21 & valid_access21 & 
                  (smc_nextstate21 != `SMC_STORE21)) |
                 (n_r_read21 & ~valid_access21 & 
                  (smc_nextstate21 != `SMC_STORE21)))      
         
           begin
            
              n_r_we21 <= n_be21;
              n_r_wr21 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we21 <= 4'hF;
              n_r_wr21 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive21 OE21 signal21 to I21/O21 pins21 on ASIC21 -----added by gulbir21
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk21 or negedge n_sys_reset21)
     
     begin
        
        if (~n_sys_reset21)
          
          smc_n_ext_oe21 <= 1;
        
        
        else if ((n_read21 & valid_access21 & 
                  (smc_nextstate21 != `SMC_STORE21)) |
                (n_r_read21 & ~valid_access21 & 
              (smc_nextstate21 != `SMC_STORE21) & 
                 (smc_nextstate21 != `SMC_IDLE21)))      

           smc_n_ext_oe21 <= 0;
        
        else
          
           smc_n_ext_oe21 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate21 half21 and full signals21 for write strobes21
// A full cycle is required21 if wait states21 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate21 half21 cycle signals21 for write strobes21
//----------------------------------------------------------------------

always @(r_smc_currentstate21 or smc_nextstate21 or
            r_full21 or 
            r_wete_store21 or r_ws_store21 or r_wele_store21 or 
            r_ws_count21 or r_wele_count21 or 
            valid_access21 or smc_done21)
  
  begin     
     
       begin
          
          case (r_smc_currentstate21)
            
            `SMC_IDLE21:
              
              begin
                 
                     half_cycle21 = 1'b0;
                 
              end
            
            `SMC_LE21:
              
              begin
                 
                 if (smc_nextstate21 == `SMC_RW21)
                   
                   if( ( ( (r_wete_store21) == r_ws_count21[1:0]) &
                         (r_ws_count21[7:2] == 6'd0) &
                         (r_wele_count21 < 2'd2)
                       ) |
                       (r_ws_count21 == 8'd0)
                     )
                     
                     half_cycle21 = 1'b1 & ~r_full21;
                 
                   else
                     
                     half_cycle21 = 1'b0;
                 
                 else
                   
                   half_cycle21 = 1'b0;
                 
              end
            
            `SMC_RW21, `SMC_FLOAT21:
              
              begin
                 
                 if (smc_nextstate21 == `SMC_RW21)
                   
                   if (valid_access21)

                       
                       half_cycle21 = 1'b0;
                 
                   else if (smc_done21)
                     
                     if( ( (r_wete_store21 == r_ws_store21[1:0]) & 
                           (r_ws_store21[7:2] == 6'd0) & 
                           (r_wele_store21 == 2'd0)
                         ) | 
                         (r_ws_store21 == 8'd0)
                       )
                       
                       half_cycle21 = 1'b1 & ~r_full21;
                 
                     else
                       
                       half_cycle21 = 1'b0;
                 
                   else
                     
                     if (r_wete_store21 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count21[1:0]) & 
                            (r_ws_count21[7:2] == 6'd1) &
                            (r_wele_count21 < 2'd2)
                          )
                         
                         half_cycle21 = 1'b1 & ~r_full21;
                 
                       else
                         
                         half_cycle21 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store21+2'd1) == r_ws_count21[1:0]) & 
                              (r_ws_count21[7:2] == 6'd0) & 
                              (r_wele_count21 < 2'd2)
                            )
                          )
                         
                         half_cycle21 = 1'b1 & ~r_full21;
                 
                       else
                         
                         half_cycle21 = 1'b0;
                 
                 else
                   
                   half_cycle21 = 1'b0;
                 
              end
            
            `SMC_STORE21:
              
              begin
                 
                 if (smc_nextstate21 == `SMC_RW21)

                   if( ( ( (r_wete_store21) == r_ws_count21[1:0]) & 
                         (r_ws_count21[7:2] == 6'd0) & 
                         (r_wele_count21 < 2'd2)
                       ) | 
                       (r_ws_count21 == 8'd0)
                     )
                     
                     half_cycle21 = 1'b1 & ~r_full21;
                 
                   else
                     
                     half_cycle21 = 1'b0;
                 
                 else
                   
                   half_cycle21 = 1'b0;
                 
              end
            
            default:
              
              half_cycle21 = 1'b0;
            
          endcase // r_smc_currentstate21
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal21 generation21
//----------------------------------------------------------------------

 always @(posedge sys_clk21 or negedge n_sys_reset21)
             
   begin
      
      if (~n_sys_reset21)
        
        begin
           
           r_full21 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate21)
             
             `SMC_IDLE21:
               
               begin
                  
                  if (smc_nextstate21 == `SMC_RW21)
                    
                         
                         r_full21 <= 1'b0;
                       
                  else
                        
                       r_full21 <= 1'b0;
                       
               end
             
          `SMC_LE21:
            
          begin
             
             if (smc_nextstate21 == `SMC_RW21)
               
                  if( ( ( (r_wete_store21) < r_ws_count21[1:0]) | 
                        (r_ws_count21[7:2] != 6'd0)
                      ) & 
                      (r_wele_count21 < 2'd2)
                    )
                    
                    r_full21 <= 1'b1;
                  
                  else
                    
                    r_full21 <= 1'b0;
                  
             else
               
                  r_full21 <= 1'b0;
                  
          end
          
          `SMC_RW21, `SMC_FLOAT21:
            
            begin
               
               if (smc_nextstate21 == `SMC_RW21)
                 
                 begin
                    
                    if (valid_access21)
                      
                           
                           r_full21 <= 1'b0;
                         
                    else if (smc_done21)
                      
                         if( ( ( (r_wete_store21 < r_ws_store21[1:0]) | 
                                 (r_ws_store21[7:2] != 6'd0)
                               ) & 
                               (r_wele_store21 == 2'd0)
                             )
                           )
                           
                           r_full21 <= 1'b1;
                         
                         else
                           
                           r_full21 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store21 == 2'd3)
                           
                           if( ( (r_ws_count21[7:0] > 8'd4)
                               ) & 
                               (r_wele_count21 < 2'd2)
                             )
                             
                             r_full21 <= 1'b1;
                         
                           else
                             
                             r_full21 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store21 + 2'd1) < 
                                         r_ws_count21[1:0]
                                       )
                                     ) |
                                     (r_ws_count21[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count21 < 2'd2)
                                 )
                           
                           r_full21 <= 1'b1;
                         
                         else
                           
                           r_full21 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full21 <= 1'b0;
               
            end
             
             `SMC_STORE21:
               
               begin
                  
                  if (smc_nextstate21 == `SMC_RW21)

                     if ( ( ( (r_wete_store21) < r_ws_count21[1:0]) | 
                            (r_ws_count21[7:2] != 6'd0)
                          ) & 
                          (r_wele_count21 == 2'd0)
                        )
                         
                         r_full21 <= 1'b1;
                       
                       else
                         
                         r_full21 <= 1'b0;
                       
                  else
                    
                       r_full21 <= 1'b0;
                       
               end
             
             default:
               
                  r_full21 <= 1'b0;
                  
           endcase // r_smc_currentstate21
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate21 Read Strobe21
//----------------------------------------------------------------------
 
  always @(posedge sys_clk21 or negedge n_sys_reset21)
  
  begin
     
     if (~n_sys_reset21)
  
        smc_n_rd21 <= 1'h1;
      
      
     else if (smc_nextstate21 == `SMC_RW21)
  
     begin
  
        if (valid_access21)
  
        begin
  
  
              smc_n_rd21 <= n_read21;
  
  
        end
  
        else if ((r_smc_currentstate21 == `SMC_LE21) | 
                    (r_smc_currentstate21 == `SMC_STORE21))

        begin
           
           if( (r_oete_store21 < r_ws_store21[1:0]) | 
               (r_ws_store21[7:2] != 6'd0) |
               ( (r_oete_store21 == r_ws_store21[1:0]) & 
                 (r_ws_store21[7:2] == 6'd0)
               ) |
               (r_ws_store21 == 8'd0) 
             )
             
             smc_n_rd21 <= n_r_read21;
           
           else
             
             smc_n_rd21 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store21) < r_ws_count21[1:0]) | 
               (r_ws_count21[7:2] != 6'd0) |
               (r_ws_count21 == 8'd0) 
             )
             
              smc_n_rd21 <= n_r_read21;
           
           else

              smc_n_rd21 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd21 <= 1'b1;
     
  end
   
   
 
endmodule


