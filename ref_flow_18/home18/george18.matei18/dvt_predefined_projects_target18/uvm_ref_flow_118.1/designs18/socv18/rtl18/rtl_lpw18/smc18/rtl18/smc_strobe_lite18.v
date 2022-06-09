//File18 name   : smc_strobe_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`include "smc_defs_lite18.v"

module smc_strobe_lite18  (

                    //inputs18

                    sys_clk18,
                    n_sys_reset18,
                    valid_access18,
                    n_read18,
                    cs,
                    r_smc_currentstate18,
                    smc_nextstate18,
                    n_be18,
                    r_wele_count18,
                    r_wele_store18,
                    r_wete_store18,
                    r_oete_store18,
                    r_ws_count18,
                    r_ws_store18,
                    smc_done18,
                    mac_done18,

                    //outputs18

                    smc_n_rd18,
                    smc_n_ext_oe18,
                    smc_busy18,
                    n_r_read18,
                    r_cs18,
                    r_full18,
                    n_r_we18,
                    n_r_wr18);



//Parameters18  -  Values18 in smc_defs18.v

 


// I18/O18

   input                   sys_clk18;      //System18 clock18
   input                   n_sys_reset18;  //System18 reset (Active18 LOW18)
   input                   valid_access18; //load18 values are valid if high18
   input                   n_read18;       //Active18 low18 read signal18
   input              cs;           //registered chip18 select18
   input [4:0]             r_smc_currentstate18;//current state
   input [4:0]             smc_nextstate18;//next state  
   input [3:0]             n_be18;         //Unregistered18 Byte18 strobes18
   input [1:0]             r_wele_count18; //Write counter
   input [1:0]             r_wete_store18; //write strobe18 trailing18 edge store18
   input [1:0]             r_oete_store18; //read strobe18
   input [1:0]             r_wele_store18; //write strobe18 leading18 edge store18
   input [7:0]             r_ws_count18;   //wait state count
   input [7:0]             r_ws_store18;   //wait state store18
   input                   smc_done18;  //one access completed
   input                   mac_done18;  //All cycles18 in a multiple access
   
   
   output                  smc_n_rd18;     // EMI18 read stobe18 (Active18 LOW18)
   output                  smc_n_ext_oe18; // Enable18 External18 bus drivers18.
                                                          //  (CS18 & ~RD18)
   output                  smc_busy18;  // smc18 busy
   output                  n_r_read18;  // Store18 RW strobe18 for multiple
                                                         //  accesses
   output                  r_full18;    // Full cycle write strobe18
   output [3:0]            n_r_we18;    // write enable strobe18(active low18)
   output                  n_r_wr18;    // write strobe18(active low18)
   output             r_cs18;      // registered chip18 select18.   


// Output18 register declarations18

   reg                     smc_n_rd18;
   reg                     smc_n_ext_oe18;
   reg                r_cs18;
   reg                     smc_busy18;
   reg                     n_r_read18;
   reg                     r_full18;
   reg   [3:0]             n_r_we18;
   reg                     n_r_wr18;

   //wire declarations18
   
   wire             smc_mac_done18;       //smc_done18 and  mac_done18 anded18
   wire [2:0]       wait_vaccess_smdone18;//concatenated18 signals18 for case
   reg              half_cycle18;         //used for generating18 half18 cycle
                                                //strobes18
   


//----------------------------------------------------------------------
// Strobe18 Generation18
//
// Individual Write Strobes18
// Write Strobe18 = Byte18 Enable18 & Write Enable18
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal18 concatenation18 for use in case statement18
//----------------------------------------------------------------------

   assign smc_mac_done18 = {smc_done18 & mac_done18};

   assign wait_vaccess_smdone18 = {1'b0,valid_access18,smc_mac_done18};
   
   
//----------------------------------------------------------------------
// Store18 read/write signal18 for duration18 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk18 or negedge n_sys_reset18)
  
     begin
  
        if (~n_sys_reset18)
  
           n_r_read18 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone18)
               
               3'b1xx:
                 
                  n_r_read18 <= n_r_read18;
               
               3'b01x:
                 
                  n_r_read18 <= n_read18;
               
               3'b001:
                 
                  n_r_read18 <= 0;
               
               default:
                 
                  n_r_read18 <= n_r_read18;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store18 chip18 selects18 for duration18 of cycle(s)--turnaround18 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store18 read/write signal18 for duration18 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk18 or negedge n_sys_reset18)
     
      begin
           
         if (~n_sys_reset18)
           
           r_cs18 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone18)
                
                 3'b1xx:
                  
                    r_cs18 <= r_cs18 ;
                
                 3'b01x:
                  
                    r_cs18 <= cs ;
                
                 3'b001:
                  
                    r_cs18 <= 1'b0;
                
                 default:
                  
                    r_cs18 <= r_cs18 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive18 busy output whenever18 smc18 active
//----------------------------------------------------------------------

   always @(posedge sys_clk18 or negedge n_sys_reset18)
     
      begin
          
         if (~n_sys_reset18)
           
            smc_busy18 <= 0;
           
           
         else if (smc_nextstate18 != `SMC_IDLE18)
           
            smc_busy18 <= 1;
           
         else
           
            smc_busy18 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive18 OE18 signal18 to I18/O18 pins18 on ASIC18
//
// Generate18 internal, registered Write strobes18
// The write strobes18 are gated18 with the clock18 later18 to generate half18 
// cycle strobes18
//----------------------------------------------------------------------

  always @(posedge sys_clk18 or negedge n_sys_reset18)
    
     begin
       
        if (~n_sys_reset18)
         
           begin
            
              n_r_we18 <= 4'hF;
              n_r_wr18 <= 1'h1;
            
           end
       

        else if ((n_read18 & valid_access18 & 
                  (smc_nextstate18 != `SMC_STORE18)) |
                 (n_r_read18 & ~valid_access18 & 
                  (smc_nextstate18 != `SMC_STORE18)))      
         
           begin
            
              n_r_we18 <= n_be18;
              n_r_wr18 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we18 <= 4'hF;
              n_r_wr18 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive18 OE18 signal18 to I18/O18 pins18 on ASIC18 -----added by gulbir18
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk18 or negedge n_sys_reset18)
     
     begin
        
        if (~n_sys_reset18)
          
          smc_n_ext_oe18 <= 1;
        
        
        else if ((n_read18 & valid_access18 & 
                  (smc_nextstate18 != `SMC_STORE18)) |
                (n_r_read18 & ~valid_access18 & 
              (smc_nextstate18 != `SMC_STORE18) & 
                 (smc_nextstate18 != `SMC_IDLE18)))      

           smc_n_ext_oe18 <= 0;
        
        else
          
           smc_n_ext_oe18 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate18 half18 and full signals18 for write strobes18
// A full cycle is required18 if wait states18 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate18 half18 cycle signals18 for write strobes18
//----------------------------------------------------------------------

always @(r_smc_currentstate18 or smc_nextstate18 or
            r_full18 or 
            r_wete_store18 or r_ws_store18 or r_wele_store18 or 
            r_ws_count18 or r_wele_count18 or 
            valid_access18 or smc_done18)
  
  begin     
     
       begin
          
          case (r_smc_currentstate18)
            
            `SMC_IDLE18:
              
              begin
                 
                     half_cycle18 = 1'b0;
                 
              end
            
            `SMC_LE18:
              
              begin
                 
                 if (smc_nextstate18 == `SMC_RW18)
                   
                   if( ( ( (r_wete_store18) == r_ws_count18[1:0]) &
                         (r_ws_count18[7:2] == 6'd0) &
                         (r_wele_count18 < 2'd2)
                       ) |
                       (r_ws_count18 == 8'd0)
                     )
                     
                     half_cycle18 = 1'b1 & ~r_full18;
                 
                   else
                     
                     half_cycle18 = 1'b0;
                 
                 else
                   
                   half_cycle18 = 1'b0;
                 
              end
            
            `SMC_RW18, `SMC_FLOAT18:
              
              begin
                 
                 if (smc_nextstate18 == `SMC_RW18)
                   
                   if (valid_access18)

                       
                       half_cycle18 = 1'b0;
                 
                   else if (smc_done18)
                     
                     if( ( (r_wete_store18 == r_ws_store18[1:0]) & 
                           (r_ws_store18[7:2] == 6'd0) & 
                           (r_wele_store18 == 2'd0)
                         ) | 
                         (r_ws_store18 == 8'd0)
                       )
                       
                       half_cycle18 = 1'b1 & ~r_full18;
                 
                     else
                       
                       half_cycle18 = 1'b0;
                 
                   else
                     
                     if (r_wete_store18 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count18[1:0]) & 
                            (r_ws_count18[7:2] == 6'd1) &
                            (r_wele_count18 < 2'd2)
                          )
                         
                         half_cycle18 = 1'b1 & ~r_full18;
                 
                       else
                         
                         half_cycle18 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store18+2'd1) == r_ws_count18[1:0]) & 
                              (r_ws_count18[7:2] == 6'd0) & 
                              (r_wele_count18 < 2'd2)
                            )
                          )
                         
                         half_cycle18 = 1'b1 & ~r_full18;
                 
                       else
                         
                         half_cycle18 = 1'b0;
                 
                 else
                   
                   half_cycle18 = 1'b0;
                 
              end
            
            `SMC_STORE18:
              
              begin
                 
                 if (smc_nextstate18 == `SMC_RW18)

                   if( ( ( (r_wete_store18) == r_ws_count18[1:0]) & 
                         (r_ws_count18[7:2] == 6'd0) & 
                         (r_wele_count18 < 2'd2)
                       ) | 
                       (r_ws_count18 == 8'd0)
                     )
                     
                     half_cycle18 = 1'b1 & ~r_full18;
                 
                   else
                     
                     half_cycle18 = 1'b0;
                 
                 else
                   
                   half_cycle18 = 1'b0;
                 
              end
            
            default:
              
              half_cycle18 = 1'b0;
            
          endcase // r_smc_currentstate18
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal18 generation18
//----------------------------------------------------------------------

 always @(posedge sys_clk18 or negedge n_sys_reset18)
             
   begin
      
      if (~n_sys_reset18)
        
        begin
           
           r_full18 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate18)
             
             `SMC_IDLE18:
               
               begin
                  
                  if (smc_nextstate18 == `SMC_RW18)
                    
                         
                         r_full18 <= 1'b0;
                       
                  else
                        
                       r_full18 <= 1'b0;
                       
               end
             
          `SMC_LE18:
            
          begin
             
             if (smc_nextstate18 == `SMC_RW18)
               
                  if( ( ( (r_wete_store18) < r_ws_count18[1:0]) | 
                        (r_ws_count18[7:2] != 6'd0)
                      ) & 
                      (r_wele_count18 < 2'd2)
                    )
                    
                    r_full18 <= 1'b1;
                  
                  else
                    
                    r_full18 <= 1'b0;
                  
             else
               
                  r_full18 <= 1'b0;
                  
          end
          
          `SMC_RW18, `SMC_FLOAT18:
            
            begin
               
               if (smc_nextstate18 == `SMC_RW18)
                 
                 begin
                    
                    if (valid_access18)
                      
                           
                           r_full18 <= 1'b0;
                         
                    else if (smc_done18)
                      
                         if( ( ( (r_wete_store18 < r_ws_store18[1:0]) | 
                                 (r_ws_store18[7:2] != 6'd0)
                               ) & 
                               (r_wele_store18 == 2'd0)
                             )
                           )
                           
                           r_full18 <= 1'b1;
                         
                         else
                           
                           r_full18 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store18 == 2'd3)
                           
                           if( ( (r_ws_count18[7:0] > 8'd4)
                               ) & 
                               (r_wele_count18 < 2'd2)
                             )
                             
                             r_full18 <= 1'b1;
                         
                           else
                             
                             r_full18 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store18 + 2'd1) < 
                                         r_ws_count18[1:0]
                                       )
                                     ) |
                                     (r_ws_count18[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count18 < 2'd2)
                                 )
                           
                           r_full18 <= 1'b1;
                         
                         else
                           
                           r_full18 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full18 <= 1'b0;
               
            end
             
             `SMC_STORE18:
               
               begin
                  
                  if (smc_nextstate18 == `SMC_RW18)

                     if ( ( ( (r_wete_store18) < r_ws_count18[1:0]) | 
                            (r_ws_count18[7:2] != 6'd0)
                          ) & 
                          (r_wele_count18 == 2'd0)
                        )
                         
                         r_full18 <= 1'b1;
                       
                       else
                         
                         r_full18 <= 1'b0;
                       
                  else
                    
                       r_full18 <= 1'b0;
                       
               end
             
             default:
               
                  r_full18 <= 1'b0;
                  
           endcase // r_smc_currentstate18
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate18 Read Strobe18
//----------------------------------------------------------------------
 
  always @(posedge sys_clk18 or negedge n_sys_reset18)
  
  begin
     
     if (~n_sys_reset18)
  
        smc_n_rd18 <= 1'h1;
      
      
     else if (smc_nextstate18 == `SMC_RW18)
  
     begin
  
        if (valid_access18)
  
        begin
  
  
              smc_n_rd18 <= n_read18;
  
  
        end
  
        else if ((r_smc_currentstate18 == `SMC_LE18) | 
                    (r_smc_currentstate18 == `SMC_STORE18))

        begin
           
           if( (r_oete_store18 < r_ws_store18[1:0]) | 
               (r_ws_store18[7:2] != 6'd0) |
               ( (r_oete_store18 == r_ws_store18[1:0]) & 
                 (r_ws_store18[7:2] == 6'd0)
               ) |
               (r_ws_store18 == 8'd0) 
             )
             
             smc_n_rd18 <= n_r_read18;
           
           else
             
             smc_n_rd18 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store18) < r_ws_count18[1:0]) | 
               (r_ws_count18[7:2] != 6'd0) |
               (r_ws_count18 == 8'd0) 
             )
             
              smc_n_rd18 <= n_r_read18;
           
           else

              smc_n_rd18 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd18 <= 1'b1;
     
  end
   
   
 
endmodule


