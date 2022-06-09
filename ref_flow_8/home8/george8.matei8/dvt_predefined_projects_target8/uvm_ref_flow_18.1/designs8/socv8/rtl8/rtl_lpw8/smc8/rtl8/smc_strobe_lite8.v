//File8 name   : smc_strobe_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`include "smc_defs_lite8.v"

module smc_strobe_lite8  (

                    //inputs8

                    sys_clk8,
                    n_sys_reset8,
                    valid_access8,
                    n_read8,
                    cs,
                    r_smc_currentstate8,
                    smc_nextstate8,
                    n_be8,
                    r_wele_count8,
                    r_wele_store8,
                    r_wete_store8,
                    r_oete_store8,
                    r_ws_count8,
                    r_ws_store8,
                    smc_done8,
                    mac_done8,

                    //outputs8

                    smc_n_rd8,
                    smc_n_ext_oe8,
                    smc_busy8,
                    n_r_read8,
                    r_cs8,
                    r_full8,
                    n_r_we8,
                    n_r_wr8);



//Parameters8  -  Values8 in smc_defs8.v

 


// I8/O8

   input                   sys_clk8;      //System8 clock8
   input                   n_sys_reset8;  //System8 reset (Active8 LOW8)
   input                   valid_access8; //load8 values are valid if high8
   input                   n_read8;       //Active8 low8 read signal8
   input              cs;           //registered chip8 select8
   input [4:0]             r_smc_currentstate8;//current state
   input [4:0]             smc_nextstate8;//next state  
   input [3:0]             n_be8;         //Unregistered8 Byte8 strobes8
   input [1:0]             r_wele_count8; //Write counter
   input [1:0]             r_wete_store8; //write strobe8 trailing8 edge store8
   input [1:0]             r_oete_store8; //read strobe8
   input [1:0]             r_wele_store8; //write strobe8 leading8 edge store8
   input [7:0]             r_ws_count8;   //wait state count
   input [7:0]             r_ws_store8;   //wait state store8
   input                   smc_done8;  //one access completed
   input                   mac_done8;  //All cycles8 in a multiple access
   
   
   output                  smc_n_rd8;     // EMI8 read stobe8 (Active8 LOW8)
   output                  smc_n_ext_oe8; // Enable8 External8 bus drivers8.
                                                          //  (CS8 & ~RD8)
   output                  smc_busy8;  // smc8 busy
   output                  n_r_read8;  // Store8 RW strobe8 for multiple
                                                         //  accesses
   output                  r_full8;    // Full cycle write strobe8
   output [3:0]            n_r_we8;    // write enable strobe8(active low8)
   output                  n_r_wr8;    // write strobe8(active low8)
   output             r_cs8;      // registered chip8 select8.   


// Output8 register declarations8

   reg                     smc_n_rd8;
   reg                     smc_n_ext_oe8;
   reg                r_cs8;
   reg                     smc_busy8;
   reg                     n_r_read8;
   reg                     r_full8;
   reg   [3:0]             n_r_we8;
   reg                     n_r_wr8;

   //wire declarations8
   
   wire             smc_mac_done8;       //smc_done8 and  mac_done8 anded8
   wire [2:0]       wait_vaccess_smdone8;//concatenated8 signals8 for case
   reg              half_cycle8;         //used for generating8 half8 cycle
                                                //strobes8
   


//----------------------------------------------------------------------
// Strobe8 Generation8
//
// Individual Write Strobes8
// Write Strobe8 = Byte8 Enable8 & Write Enable8
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal8 concatenation8 for use in case statement8
//----------------------------------------------------------------------

   assign smc_mac_done8 = {smc_done8 & mac_done8};

   assign wait_vaccess_smdone8 = {1'b0,valid_access8,smc_mac_done8};
   
   
//----------------------------------------------------------------------
// Store8 read/write signal8 for duration8 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk8 or negedge n_sys_reset8)
  
     begin
  
        if (~n_sys_reset8)
  
           n_r_read8 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone8)
               
               3'b1xx:
                 
                  n_r_read8 <= n_r_read8;
               
               3'b01x:
                 
                  n_r_read8 <= n_read8;
               
               3'b001:
                 
                  n_r_read8 <= 0;
               
               default:
                 
                  n_r_read8 <= n_r_read8;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store8 chip8 selects8 for duration8 of cycle(s)--turnaround8 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store8 read/write signal8 for duration8 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk8 or negedge n_sys_reset8)
     
      begin
           
         if (~n_sys_reset8)
           
           r_cs8 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone8)
                
                 3'b1xx:
                  
                    r_cs8 <= r_cs8 ;
                
                 3'b01x:
                  
                    r_cs8 <= cs ;
                
                 3'b001:
                  
                    r_cs8 <= 1'b0;
                
                 default:
                  
                    r_cs8 <= r_cs8 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive8 busy output whenever8 smc8 active
//----------------------------------------------------------------------

   always @(posedge sys_clk8 or negedge n_sys_reset8)
     
      begin
          
         if (~n_sys_reset8)
           
            smc_busy8 <= 0;
           
           
         else if (smc_nextstate8 != `SMC_IDLE8)
           
            smc_busy8 <= 1;
           
         else
           
            smc_busy8 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive8 OE8 signal8 to I8/O8 pins8 on ASIC8
//
// Generate8 internal, registered Write strobes8
// The write strobes8 are gated8 with the clock8 later8 to generate half8 
// cycle strobes8
//----------------------------------------------------------------------

  always @(posedge sys_clk8 or negedge n_sys_reset8)
    
     begin
       
        if (~n_sys_reset8)
         
           begin
            
              n_r_we8 <= 4'hF;
              n_r_wr8 <= 1'h1;
            
           end
       

        else if ((n_read8 & valid_access8 & 
                  (smc_nextstate8 != `SMC_STORE8)) |
                 (n_r_read8 & ~valid_access8 & 
                  (smc_nextstate8 != `SMC_STORE8)))      
         
           begin
            
              n_r_we8 <= n_be8;
              n_r_wr8 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we8 <= 4'hF;
              n_r_wr8 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive8 OE8 signal8 to I8/O8 pins8 on ASIC8 -----added by gulbir8
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk8 or negedge n_sys_reset8)
     
     begin
        
        if (~n_sys_reset8)
          
          smc_n_ext_oe8 <= 1;
        
        
        else if ((n_read8 & valid_access8 & 
                  (smc_nextstate8 != `SMC_STORE8)) |
                (n_r_read8 & ~valid_access8 & 
              (smc_nextstate8 != `SMC_STORE8) & 
                 (smc_nextstate8 != `SMC_IDLE8)))      

           smc_n_ext_oe8 <= 0;
        
        else
          
           smc_n_ext_oe8 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate8 half8 and full signals8 for write strobes8
// A full cycle is required8 if wait states8 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate8 half8 cycle signals8 for write strobes8
//----------------------------------------------------------------------

always @(r_smc_currentstate8 or smc_nextstate8 or
            r_full8 or 
            r_wete_store8 or r_ws_store8 or r_wele_store8 or 
            r_ws_count8 or r_wele_count8 or 
            valid_access8 or smc_done8)
  
  begin     
     
       begin
          
          case (r_smc_currentstate8)
            
            `SMC_IDLE8:
              
              begin
                 
                     half_cycle8 = 1'b0;
                 
              end
            
            `SMC_LE8:
              
              begin
                 
                 if (smc_nextstate8 == `SMC_RW8)
                   
                   if( ( ( (r_wete_store8) == r_ws_count8[1:0]) &
                         (r_ws_count8[7:2] == 6'd0) &
                         (r_wele_count8 < 2'd2)
                       ) |
                       (r_ws_count8 == 8'd0)
                     )
                     
                     half_cycle8 = 1'b1 & ~r_full8;
                 
                   else
                     
                     half_cycle8 = 1'b0;
                 
                 else
                   
                   half_cycle8 = 1'b0;
                 
              end
            
            `SMC_RW8, `SMC_FLOAT8:
              
              begin
                 
                 if (smc_nextstate8 == `SMC_RW8)
                   
                   if (valid_access8)

                       
                       half_cycle8 = 1'b0;
                 
                   else if (smc_done8)
                     
                     if( ( (r_wete_store8 == r_ws_store8[1:0]) & 
                           (r_ws_store8[7:2] == 6'd0) & 
                           (r_wele_store8 == 2'd0)
                         ) | 
                         (r_ws_store8 == 8'd0)
                       )
                       
                       half_cycle8 = 1'b1 & ~r_full8;
                 
                     else
                       
                       half_cycle8 = 1'b0;
                 
                   else
                     
                     if (r_wete_store8 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count8[1:0]) & 
                            (r_ws_count8[7:2] == 6'd1) &
                            (r_wele_count8 < 2'd2)
                          )
                         
                         half_cycle8 = 1'b1 & ~r_full8;
                 
                       else
                         
                         half_cycle8 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store8+2'd1) == r_ws_count8[1:0]) & 
                              (r_ws_count8[7:2] == 6'd0) & 
                              (r_wele_count8 < 2'd2)
                            )
                          )
                         
                         half_cycle8 = 1'b1 & ~r_full8;
                 
                       else
                         
                         half_cycle8 = 1'b0;
                 
                 else
                   
                   half_cycle8 = 1'b0;
                 
              end
            
            `SMC_STORE8:
              
              begin
                 
                 if (smc_nextstate8 == `SMC_RW8)

                   if( ( ( (r_wete_store8) == r_ws_count8[1:0]) & 
                         (r_ws_count8[7:2] == 6'd0) & 
                         (r_wele_count8 < 2'd2)
                       ) | 
                       (r_ws_count8 == 8'd0)
                     )
                     
                     half_cycle8 = 1'b1 & ~r_full8;
                 
                   else
                     
                     half_cycle8 = 1'b0;
                 
                 else
                   
                   half_cycle8 = 1'b0;
                 
              end
            
            default:
              
              half_cycle8 = 1'b0;
            
          endcase // r_smc_currentstate8
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal8 generation8
//----------------------------------------------------------------------

 always @(posedge sys_clk8 or negedge n_sys_reset8)
             
   begin
      
      if (~n_sys_reset8)
        
        begin
           
           r_full8 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate8)
             
             `SMC_IDLE8:
               
               begin
                  
                  if (smc_nextstate8 == `SMC_RW8)
                    
                         
                         r_full8 <= 1'b0;
                       
                  else
                        
                       r_full8 <= 1'b0;
                       
               end
             
          `SMC_LE8:
            
          begin
             
             if (smc_nextstate8 == `SMC_RW8)
               
                  if( ( ( (r_wete_store8) < r_ws_count8[1:0]) | 
                        (r_ws_count8[7:2] != 6'd0)
                      ) & 
                      (r_wele_count8 < 2'd2)
                    )
                    
                    r_full8 <= 1'b1;
                  
                  else
                    
                    r_full8 <= 1'b0;
                  
             else
               
                  r_full8 <= 1'b0;
                  
          end
          
          `SMC_RW8, `SMC_FLOAT8:
            
            begin
               
               if (smc_nextstate8 == `SMC_RW8)
                 
                 begin
                    
                    if (valid_access8)
                      
                           
                           r_full8 <= 1'b0;
                         
                    else if (smc_done8)
                      
                         if( ( ( (r_wete_store8 < r_ws_store8[1:0]) | 
                                 (r_ws_store8[7:2] != 6'd0)
                               ) & 
                               (r_wele_store8 == 2'd0)
                             )
                           )
                           
                           r_full8 <= 1'b1;
                         
                         else
                           
                           r_full8 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store8 == 2'd3)
                           
                           if( ( (r_ws_count8[7:0] > 8'd4)
                               ) & 
                               (r_wele_count8 < 2'd2)
                             )
                             
                             r_full8 <= 1'b1;
                         
                           else
                             
                             r_full8 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store8 + 2'd1) < 
                                         r_ws_count8[1:0]
                                       )
                                     ) |
                                     (r_ws_count8[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count8 < 2'd2)
                                 )
                           
                           r_full8 <= 1'b1;
                         
                         else
                           
                           r_full8 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full8 <= 1'b0;
               
            end
             
             `SMC_STORE8:
               
               begin
                  
                  if (smc_nextstate8 == `SMC_RW8)

                     if ( ( ( (r_wete_store8) < r_ws_count8[1:0]) | 
                            (r_ws_count8[7:2] != 6'd0)
                          ) & 
                          (r_wele_count8 == 2'd0)
                        )
                         
                         r_full8 <= 1'b1;
                       
                       else
                         
                         r_full8 <= 1'b0;
                       
                  else
                    
                       r_full8 <= 1'b0;
                       
               end
             
             default:
               
                  r_full8 <= 1'b0;
                  
           endcase // r_smc_currentstate8
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate8 Read Strobe8
//----------------------------------------------------------------------
 
  always @(posedge sys_clk8 or negedge n_sys_reset8)
  
  begin
     
     if (~n_sys_reset8)
  
        smc_n_rd8 <= 1'h1;
      
      
     else if (smc_nextstate8 == `SMC_RW8)
  
     begin
  
        if (valid_access8)
  
        begin
  
  
              smc_n_rd8 <= n_read8;
  
  
        end
  
        else if ((r_smc_currentstate8 == `SMC_LE8) | 
                    (r_smc_currentstate8 == `SMC_STORE8))

        begin
           
           if( (r_oete_store8 < r_ws_store8[1:0]) | 
               (r_ws_store8[7:2] != 6'd0) |
               ( (r_oete_store8 == r_ws_store8[1:0]) & 
                 (r_ws_store8[7:2] == 6'd0)
               ) |
               (r_ws_store8 == 8'd0) 
             )
             
             smc_n_rd8 <= n_r_read8;
           
           else
             
             smc_n_rd8 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store8) < r_ws_count8[1:0]) | 
               (r_ws_count8[7:2] != 6'd0) |
               (r_ws_count8 == 8'd0) 
             )
             
              smc_n_rd8 <= n_r_read8;
           
           else

              smc_n_rd8 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd8 <= 1'b1;
     
  end
   
   
 
endmodule


