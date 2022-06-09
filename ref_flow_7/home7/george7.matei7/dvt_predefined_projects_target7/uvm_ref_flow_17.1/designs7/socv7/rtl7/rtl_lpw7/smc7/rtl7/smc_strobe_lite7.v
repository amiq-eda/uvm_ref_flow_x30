//File7 name   : smc_strobe_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`include "smc_defs_lite7.v"

module smc_strobe_lite7  (

                    //inputs7

                    sys_clk7,
                    n_sys_reset7,
                    valid_access7,
                    n_read7,
                    cs,
                    r_smc_currentstate7,
                    smc_nextstate7,
                    n_be7,
                    r_wele_count7,
                    r_wele_store7,
                    r_wete_store7,
                    r_oete_store7,
                    r_ws_count7,
                    r_ws_store7,
                    smc_done7,
                    mac_done7,

                    //outputs7

                    smc_n_rd7,
                    smc_n_ext_oe7,
                    smc_busy7,
                    n_r_read7,
                    r_cs7,
                    r_full7,
                    n_r_we7,
                    n_r_wr7);



//Parameters7  -  Values7 in smc_defs7.v

 


// I7/O7

   input                   sys_clk7;      //System7 clock7
   input                   n_sys_reset7;  //System7 reset (Active7 LOW7)
   input                   valid_access7; //load7 values are valid if high7
   input                   n_read7;       //Active7 low7 read signal7
   input              cs;           //registered chip7 select7
   input [4:0]             r_smc_currentstate7;//current state
   input [4:0]             smc_nextstate7;//next state  
   input [3:0]             n_be7;         //Unregistered7 Byte7 strobes7
   input [1:0]             r_wele_count7; //Write counter
   input [1:0]             r_wete_store7; //write strobe7 trailing7 edge store7
   input [1:0]             r_oete_store7; //read strobe7
   input [1:0]             r_wele_store7; //write strobe7 leading7 edge store7
   input [7:0]             r_ws_count7;   //wait state count
   input [7:0]             r_ws_store7;   //wait state store7
   input                   smc_done7;  //one access completed
   input                   mac_done7;  //All cycles7 in a multiple access
   
   
   output                  smc_n_rd7;     // EMI7 read stobe7 (Active7 LOW7)
   output                  smc_n_ext_oe7; // Enable7 External7 bus drivers7.
                                                          //  (CS7 & ~RD7)
   output                  smc_busy7;  // smc7 busy
   output                  n_r_read7;  // Store7 RW strobe7 for multiple
                                                         //  accesses
   output                  r_full7;    // Full cycle write strobe7
   output [3:0]            n_r_we7;    // write enable strobe7(active low7)
   output                  n_r_wr7;    // write strobe7(active low7)
   output             r_cs7;      // registered chip7 select7.   


// Output7 register declarations7

   reg                     smc_n_rd7;
   reg                     smc_n_ext_oe7;
   reg                r_cs7;
   reg                     smc_busy7;
   reg                     n_r_read7;
   reg                     r_full7;
   reg   [3:0]             n_r_we7;
   reg                     n_r_wr7;

   //wire declarations7
   
   wire             smc_mac_done7;       //smc_done7 and  mac_done7 anded7
   wire [2:0]       wait_vaccess_smdone7;//concatenated7 signals7 for case
   reg              half_cycle7;         //used for generating7 half7 cycle
                                                //strobes7
   


//----------------------------------------------------------------------
// Strobe7 Generation7
//
// Individual Write Strobes7
// Write Strobe7 = Byte7 Enable7 & Write Enable7
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal7 concatenation7 for use in case statement7
//----------------------------------------------------------------------

   assign smc_mac_done7 = {smc_done7 & mac_done7};

   assign wait_vaccess_smdone7 = {1'b0,valid_access7,smc_mac_done7};
   
   
//----------------------------------------------------------------------
// Store7 read/write signal7 for duration7 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk7 or negedge n_sys_reset7)
  
     begin
  
        if (~n_sys_reset7)
  
           n_r_read7 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone7)
               
               3'b1xx:
                 
                  n_r_read7 <= n_r_read7;
               
               3'b01x:
                 
                  n_r_read7 <= n_read7;
               
               3'b001:
                 
                  n_r_read7 <= 0;
               
               default:
                 
                  n_r_read7 <= n_r_read7;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store7 chip7 selects7 for duration7 of cycle(s)--turnaround7 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store7 read/write signal7 for duration7 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk7 or negedge n_sys_reset7)
     
      begin
           
         if (~n_sys_reset7)
           
           r_cs7 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone7)
                
                 3'b1xx:
                  
                    r_cs7 <= r_cs7 ;
                
                 3'b01x:
                  
                    r_cs7 <= cs ;
                
                 3'b001:
                  
                    r_cs7 <= 1'b0;
                
                 default:
                  
                    r_cs7 <= r_cs7 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive7 busy output whenever7 smc7 active
//----------------------------------------------------------------------

   always @(posedge sys_clk7 or negedge n_sys_reset7)
     
      begin
          
         if (~n_sys_reset7)
           
            smc_busy7 <= 0;
           
           
         else if (smc_nextstate7 != `SMC_IDLE7)
           
            smc_busy7 <= 1;
           
         else
           
            smc_busy7 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive7 OE7 signal7 to I7/O7 pins7 on ASIC7
//
// Generate7 internal, registered Write strobes7
// The write strobes7 are gated7 with the clock7 later7 to generate half7 
// cycle strobes7
//----------------------------------------------------------------------

  always @(posedge sys_clk7 or negedge n_sys_reset7)
    
     begin
       
        if (~n_sys_reset7)
         
           begin
            
              n_r_we7 <= 4'hF;
              n_r_wr7 <= 1'h1;
            
           end
       

        else if ((n_read7 & valid_access7 & 
                  (smc_nextstate7 != `SMC_STORE7)) |
                 (n_r_read7 & ~valid_access7 & 
                  (smc_nextstate7 != `SMC_STORE7)))      
         
           begin
            
              n_r_we7 <= n_be7;
              n_r_wr7 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we7 <= 4'hF;
              n_r_wr7 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive7 OE7 signal7 to I7/O7 pins7 on ASIC7 -----added by gulbir7
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk7 or negedge n_sys_reset7)
     
     begin
        
        if (~n_sys_reset7)
          
          smc_n_ext_oe7 <= 1;
        
        
        else if ((n_read7 & valid_access7 & 
                  (smc_nextstate7 != `SMC_STORE7)) |
                (n_r_read7 & ~valid_access7 & 
              (smc_nextstate7 != `SMC_STORE7) & 
                 (smc_nextstate7 != `SMC_IDLE7)))      

           smc_n_ext_oe7 <= 0;
        
        else
          
           smc_n_ext_oe7 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate7 half7 and full signals7 for write strobes7
// A full cycle is required7 if wait states7 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate7 half7 cycle signals7 for write strobes7
//----------------------------------------------------------------------

always @(r_smc_currentstate7 or smc_nextstate7 or
            r_full7 or 
            r_wete_store7 or r_ws_store7 or r_wele_store7 or 
            r_ws_count7 or r_wele_count7 or 
            valid_access7 or smc_done7)
  
  begin     
     
       begin
          
          case (r_smc_currentstate7)
            
            `SMC_IDLE7:
              
              begin
                 
                     half_cycle7 = 1'b0;
                 
              end
            
            `SMC_LE7:
              
              begin
                 
                 if (smc_nextstate7 == `SMC_RW7)
                   
                   if( ( ( (r_wete_store7) == r_ws_count7[1:0]) &
                         (r_ws_count7[7:2] == 6'd0) &
                         (r_wele_count7 < 2'd2)
                       ) |
                       (r_ws_count7 == 8'd0)
                     )
                     
                     half_cycle7 = 1'b1 & ~r_full7;
                 
                   else
                     
                     half_cycle7 = 1'b0;
                 
                 else
                   
                   half_cycle7 = 1'b0;
                 
              end
            
            `SMC_RW7, `SMC_FLOAT7:
              
              begin
                 
                 if (smc_nextstate7 == `SMC_RW7)
                   
                   if (valid_access7)

                       
                       half_cycle7 = 1'b0;
                 
                   else if (smc_done7)
                     
                     if( ( (r_wete_store7 == r_ws_store7[1:0]) & 
                           (r_ws_store7[7:2] == 6'd0) & 
                           (r_wele_store7 == 2'd0)
                         ) | 
                         (r_ws_store7 == 8'd0)
                       )
                       
                       half_cycle7 = 1'b1 & ~r_full7;
                 
                     else
                       
                       half_cycle7 = 1'b0;
                 
                   else
                     
                     if (r_wete_store7 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count7[1:0]) & 
                            (r_ws_count7[7:2] == 6'd1) &
                            (r_wele_count7 < 2'd2)
                          )
                         
                         half_cycle7 = 1'b1 & ~r_full7;
                 
                       else
                         
                         half_cycle7 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store7+2'd1) == r_ws_count7[1:0]) & 
                              (r_ws_count7[7:2] == 6'd0) & 
                              (r_wele_count7 < 2'd2)
                            )
                          )
                         
                         half_cycle7 = 1'b1 & ~r_full7;
                 
                       else
                         
                         half_cycle7 = 1'b0;
                 
                 else
                   
                   half_cycle7 = 1'b0;
                 
              end
            
            `SMC_STORE7:
              
              begin
                 
                 if (smc_nextstate7 == `SMC_RW7)

                   if( ( ( (r_wete_store7) == r_ws_count7[1:0]) & 
                         (r_ws_count7[7:2] == 6'd0) & 
                         (r_wele_count7 < 2'd2)
                       ) | 
                       (r_ws_count7 == 8'd0)
                     )
                     
                     half_cycle7 = 1'b1 & ~r_full7;
                 
                   else
                     
                     half_cycle7 = 1'b0;
                 
                 else
                   
                   half_cycle7 = 1'b0;
                 
              end
            
            default:
              
              half_cycle7 = 1'b0;
            
          endcase // r_smc_currentstate7
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal7 generation7
//----------------------------------------------------------------------

 always @(posedge sys_clk7 or negedge n_sys_reset7)
             
   begin
      
      if (~n_sys_reset7)
        
        begin
           
           r_full7 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate7)
             
             `SMC_IDLE7:
               
               begin
                  
                  if (smc_nextstate7 == `SMC_RW7)
                    
                         
                         r_full7 <= 1'b0;
                       
                  else
                        
                       r_full7 <= 1'b0;
                       
               end
             
          `SMC_LE7:
            
          begin
             
             if (smc_nextstate7 == `SMC_RW7)
               
                  if( ( ( (r_wete_store7) < r_ws_count7[1:0]) | 
                        (r_ws_count7[7:2] != 6'd0)
                      ) & 
                      (r_wele_count7 < 2'd2)
                    )
                    
                    r_full7 <= 1'b1;
                  
                  else
                    
                    r_full7 <= 1'b0;
                  
             else
               
                  r_full7 <= 1'b0;
                  
          end
          
          `SMC_RW7, `SMC_FLOAT7:
            
            begin
               
               if (smc_nextstate7 == `SMC_RW7)
                 
                 begin
                    
                    if (valid_access7)
                      
                           
                           r_full7 <= 1'b0;
                         
                    else if (smc_done7)
                      
                         if( ( ( (r_wete_store7 < r_ws_store7[1:0]) | 
                                 (r_ws_store7[7:2] != 6'd0)
                               ) & 
                               (r_wele_store7 == 2'd0)
                             )
                           )
                           
                           r_full7 <= 1'b1;
                         
                         else
                           
                           r_full7 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store7 == 2'd3)
                           
                           if( ( (r_ws_count7[7:0] > 8'd4)
                               ) & 
                               (r_wele_count7 < 2'd2)
                             )
                             
                             r_full7 <= 1'b1;
                         
                           else
                             
                             r_full7 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store7 + 2'd1) < 
                                         r_ws_count7[1:0]
                                       )
                                     ) |
                                     (r_ws_count7[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count7 < 2'd2)
                                 )
                           
                           r_full7 <= 1'b1;
                         
                         else
                           
                           r_full7 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full7 <= 1'b0;
               
            end
             
             `SMC_STORE7:
               
               begin
                  
                  if (smc_nextstate7 == `SMC_RW7)

                     if ( ( ( (r_wete_store7) < r_ws_count7[1:0]) | 
                            (r_ws_count7[7:2] != 6'd0)
                          ) & 
                          (r_wele_count7 == 2'd0)
                        )
                         
                         r_full7 <= 1'b1;
                       
                       else
                         
                         r_full7 <= 1'b0;
                       
                  else
                    
                       r_full7 <= 1'b0;
                       
               end
             
             default:
               
                  r_full7 <= 1'b0;
                  
           endcase // r_smc_currentstate7
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate7 Read Strobe7
//----------------------------------------------------------------------
 
  always @(posedge sys_clk7 or negedge n_sys_reset7)
  
  begin
     
     if (~n_sys_reset7)
  
        smc_n_rd7 <= 1'h1;
      
      
     else if (smc_nextstate7 == `SMC_RW7)
  
     begin
  
        if (valid_access7)
  
        begin
  
  
              smc_n_rd7 <= n_read7;
  
  
        end
  
        else if ((r_smc_currentstate7 == `SMC_LE7) | 
                    (r_smc_currentstate7 == `SMC_STORE7))

        begin
           
           if( (r_oete_store7 < r_ws_store7[1:0]) | 
               (r_ws_store7[7:2] != 6'd0) |
               ( (r_oete_store7 == r_ws_store7[1:0]) & 
                 (r_ws_store7[7:2] == 6'd0)
               ) |
               (r_ws_store7 == 8'd0) 
             )
             
             smc_n_rd7 <= n_r_read7;
           
           else
             
             smc_n_rd7 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store7) < r_ws_count7[1:0]) | 
               (r_ws_count7[7:2] != 6'd0) |
               (r_ws_count7 == 8'd0) 
             )
             
              smc_n_rd7 <= n_r_read7;
           
           else

              smc_n_rd7 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd7 <= 1'b1;
     
  end
   
   
 
endmodule


