//File26 name   : smc_strobe_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`include "smc_defs_lite26.v"

module smc_strobe_lite26  (

                    //inputs26

                    sys_clk26,
                    n_sys_reset26,
                    valid_access26,
                    n_read26,
                    cs,
                    r_smc_currentstate26,
                    smc_nextstate26,
                    n_be26,
                    r_wele_count26,
                    r_wele_store26,
                    r_wete_store26,
                    r_oete_store26,
                    r_ws_count26,
                    r_ws_store26,
                    smc_done26,
                    mac_done26,

                    //outputs26

                    smc_n_rd26,
                    smc_n_ext_oe26,
                    smc_busy26,
                    n_r_read26,
                    r_cs26,
                    r_full26,
                    n_r_we26,
                    n_r_wr26);



//Parameters26  -  Values26 in smc_defs26.v

 


// I26/O26

   input                   sys_clk26;      //System26 clock26
   input                   n_sys_reset26;  //System26 reset (Active26 LOW26)
   input                   valid_access26; //load26 values are valid if high26
   input                   n_read26;       //Active26 low26 read signal26
   input              cs;           //registered chip26 select26
   input [4:0]             r_smc_currentstate26;//current state
   input [4:0]             smc_nextstate26;//next state  
   input [3:0]             n_be26;         //Unregistered26 Byte26 strobes26
   input [1:0]             r_wele_count26; //Write counter
   input [1:0]             r_wete_store26; //write strobe26 trailing26 edge store26
   input [1:0]             r_oete_store26; //read strobe26
   input [1:0]             r_wele_store26; //write strobe26 leading26 edge store26
   input [7:0]             r_ws_count26;   //wait state count
   input [7:0]             r_ws_store26;   //wait state store26
   input                   smc_done26;  //one access completed
   input                   mac_done26;  //All cycles26 in a multiple access
   
   
   output                  smc_n_rd26;     // EMI26 read stobe26 (Active26 LOW26)
   output                  smc_n_ext_oe26; // Enable26 External26 bus drivers26.
                                                          //  (CS26 & ~RD26)
   output                  smc_busy26;  // smc26 busy
   output                  n_r_read26;  // Store26 RW strobe26 for multiple
                                                         //  accesses
   output                  r_full26;    // Full cycle write strobe26
   output [3:0]            n_r_we26;    // write enable strobe26(active low26)
   output                  n_r_wr26;    // write strobe26(active low26)
   output             r_cs26;      // registered chip26 select26.   


// Output26 register declarations26

   reg                     smc_n_rd26;
   reg                     smc_n_ext_oe26;
   reg                r_cs26;
   reg                     smc_busy26;
   reg                     n_r_read26;
   reg                     r_full26;
   reg   [3:0]             n_r_we26;
   reg                     n_r_wr26;

   //wire declarations26
   
   wire             smc_mac_done26;       //smc_done26 and  mac_done26 anded26
   wire [2:0]       wait_vaccess_smdone26;//concatenated26 signals26 for case
   reg              half_cycle26;         //used for generating26 half26 cycle
                                                //strobes26
   


//----------------------------------------------------------------------
// Strobe26 Generation26
//
// Individual Write Strobes26
// Write Strobe26 = Byte26 Enable26 & Write Enable26
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal26 concatenation26 for use in case statement26
//----------------------------------------------------------------------

   assign smc_mac_done26 = {smc_done26 & mac_done26};

   assign wait_vaccess_smdone26 = {1'b0,valid_access26,smc_mac_done26};
   
   
//----------------------------------------------------------------------
// Store26 read/write signal26 for duration26 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk26 or negedge n_sys_reset26)
  
     begin
  
        if (~n_sys_reset26)
  
           n_r_read26 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone26)
               
               3'b1xx:
                 
                  n_r_read26 <= n_r_read26;
               
               3'b01x:
                 
                  n_r_read26 <= n_read26;
               
               3'b001:
                 
                  n_r_read26 <= 0;
               
               default:
                 
                  n_r_read26 <= n_r_read26;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store26 chip26 selects26 for duration26 of cycle(s)--turnaround26 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store26 read/write signal26 for duration26 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk26 or negedge n_sys_reset26)
     
      begin
           
         if (~n_sys_reset26)
           
           r_cs26 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone26)
                
                 3'b1xx:
                  
                    r_cs26 <= r_cs26 ;
                
                 3'b01x:
                  
                    r_cs26 <= cs ;
                
                 3'b001:
                  
                    r_cs26 <= 1'b0;
                
                 default:
                  
                    r_cs26 <= r_cs26 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive26 busy output whenever26 smc26 active
//----------------------------------------------------------------------

   always @(posedge sys_clk26 or negedge n_sys_reset26)
     
      begin
          
         if (~n_sys_reset26)
           
            smc_busy26 <= 0;
           
           
         else if (smc_nextstate26 != `SMC_IDLE26)
           
            smc_busy26 <= 1;
           
         else
           
            smc_busy26 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive26 OE26 signal26 to I26/O26 pins26 on ASIC26
//
// Generate26 internal, registered Write strobes26
// The write strobes26 are gated26 with the clock26 later26 to generate half26 
// cycle strobes26
//----------------------------------------------------------------------

  always @(posedge sys_clk26 or negedge n_sys_reset26)
    
     begin
       
        if (~n_sys_reset26)
         
           begin
            
              n_r_we26 <= 4'hF;
              n_r_wr26 <= 1'h1;
            
           end
       

        else if ((n_read26 & valid_access26 & 
                  (smc_nextstate26 != `SMC_STORE26)) |
                 (n_r_read26 & ~valid_access26 & 
                  (smc_nextstate26 != `SMC_STORE26)))      
         
           begin
            
              n_r_we26 <= n_be26;
              n_r_wr26 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we26 <= 4'hF;
              n_r_wr26 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive26 OE26 signal26 to I26/O26 pins26 on ASIC26 -----added by gulbir26
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk26 or negedge n_sys_reset26)
     
     begin
        
        if (~n_sys_reset26)
          
          smc_n_ext_oe26 <= 1;
        
        
        else if ((n_read26 & valid_access26 & 
                  (smc_nextstate26 != `SMC_STORE26)) |
                (n_r_read26 & ~valid_access26 & 
              (smc_nextstate26 != `SMC_STORE26) & 
                 (smc_nextstate26 != `SMC_IDLE26)))      

           smc_n_ext_oe26 <= 0;
        
        else
          
           smc_n_ext_oe26 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate26 half26 and full signals26 for write strobes26
// A full cycle is required26 if wait states26 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate26 half26 cycle signals26 for write strobes26
//----------------------------------------------------------------------

always @(r_smc_currentstate26 or smc_nextstate26 or
            r_full26 or 
            r_wete_store26 or r_ws_store26 or r_wele_store26 or 
            r_ws_count26 or r_wele_count26 or 
            valid_access26 or smc_done26)
  
  begin     
     
       begin
          
          case (r_smc_currentstate26)
            
            `SMC_IDLE26:
              
              begin
                 
                     half_cycle26 = 1'b0;
                 
              end
            
            `SMC_LE26:
              
              begin
                 
                 if (smc_nextstate26 == `SMC_RW26)
                   
                   if( ( ( (r_wete_store26) == r_ws_count26[1:0]) &
                         (r_ws_count26[7:2] == 6'd0) &
                         (r_wele_count26 < 2'd2)
                       ) |
                       (r_ws_count26 == 8'd0)
                     )
                     
                     half_cycle26 = 1'b1 & ~r_full26;
                 
                   else
                     
                     half_cycle26 = 1'b0;
                 
                 else
                   
                   half_cycle26 = 1'b0;
                 
              end
            
            `SMC_RW26, `SMC_FLOAT26:
              
              begin
                 
                 if (smc_nextstate26 == `SMC_RW26)
                   
                   if (valid_access26)

                       
                       half_cycle26 = 1'b0;
                 
                   else if (smc_done26)
                     
                     if( ( (r_wete_store26 == r_ws_store26[1:0]) & 
                           (r_ws_store26[7:2] == 6'd0) & 
                           (r_wele_store26 == 2'd0)
                         ) | 
                         (r_ws_store26 == 8'd0)
                       )
                       
                       half_cycle26 = 1'b1 & ~r_full26;
                 
                     else
                       
                       half_cycle26 = 1'b0;
                 
                   else
                     
                     if (r_wete_store26 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count26[1:0]) & 
                            (r_ws_count26[7:2] == 6'd1) &
                            (r_wele_count26 < 2'd2)
                          )
                         
                         half_cycle26 = 1'b1 & ~r_full26;
                 
                       else
                         
                         half_cycle26 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store26+2'd1) == r_ws_count26[1:0]) & 
                              (r_ws_count26[7:2] == 6'd0) & 
                              (r_wele_count26 < 2'd2)
                            )
                          )
                         
                         half_cycle26 = 1'b1 & ~r_full26;
                 
                       else
                         
                         half_cycle26 = 1'b0;
                 
                 else
                   
                   half_cycle26 = 1'b0;
                 
              end
            
            `SMC_STORE26:
              
              begin
                 
                 if (smc_nextstate26 == `SMC_RW26)

                   if( ( ( (r_wete_store26) == r_ws_count26[1:0]) & 
                         (r_ws_count26[7:2] == 6'd0) & 
                         (r_wele_count26 < 2'd2)
                       ) | 
                       (r_ws_count26 == 8'd0)
                     )
                     
                     half_cycle26 = 1'b1 & ~r_full26;
                 
                   else
                     
                     half_cycle26 = 1'b0;
                 
                 else
                   
                   half_cycle26 = 1'b0;
                 
              end
            
            default:
              
              half_cycle26 = 1'b0;
            
          endcase // r_smc_currentstate26
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal26 generation26
//----------------------------------------------------------------------

 always @(posedge sys_clk26 or negedge n_sys_reset26)
             
   begin
      
      if (~n_sys_reset26)
        
        begin
           
           r_full26 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate26)
             
             `SMC_IDLE26:
               
               begin
                  
                  if (smc_nextstate26 == `SMC_RW26)
                    
                         
                         r_full26 <= 1'b0;
                       
                  else
                        
                       r_full26 <= 1'b0;
                       
               end
             
          `SMC_LE26:
            
          begin
             
             if (smc_nextstate26 == `SMC_RW26)
               
                  if( ( ( (r_wete_store26) < r_ws_count26[1:0]) | 
                        (r_ws_count26[7:2] != 6'd0)
                      ) & 
                      (r_wele_count26 < 2'd2)
                    )
                    
                    r_full26 <= 1'b1;
                  
                  else
                    
                    r_full26 <= 1'b0;
                  
             else
               
                  r_full26 <= 1'b0;
                  
          end
          
          `SMC_RW26, `SMC_FLOAT26:
            
            begin
               
               if (smc_nextstate26 == `SMC_RW26)
                 
                 begin
                    
                    if (valid_access26)
                      
                           
                           r_full26 <= 1'b0;
                         
                    else if (smc_done26)
                      
                         if( ( ( (r_wete_store26 < r_ws_store26[1:0]) | 
                                 (r_ws_store26[7:2] != 6'd0)
                               ) & 
                               (r_wele_store26 == 2'd0)
                             )
                           )
                           
                           r_full26 <= 1'b1;
                         
                         else
                           
                           r_full26 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store26 == 2'd3)
                           
                           if( ( (r_ws_count26[7:0] > 8'd4)
                               ) & 
                               (r_wele_count26 < 2'd2)
                             )
                             
                             r_full26 <= 1'b1;
                         
                           else
                             
                             r_full26 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store26 + 2'd1) < 
                                         r_ws_count26[1:0]
                                       )
                                     ) |
                                     (r_ws_count26[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count26 < 2'd2)
                                 )
                           
                           r_full26 <= 1'b1;
                         
                         else
                           
                           r_full26 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full26 <= 1'b0;
               
            end
             
             `SMC_STORE26:
               
               begin
                  
                  if (smc_nextstate26 == `SMC_RW26)

                     if ( ( ( (r_wete_store26) < r_ws_count26[1:0]) | 
                            (r_ws_count26[7:2] != 6'd0)
                          ) & 
                          (r_wele_count26 == 2'd0)
                        )
                         
                         r_full26 <= 1'b1;
                       
                       else
                         
                         r_full26 <= 1'b0;
                       
                  else
                    
                       r_full26 <= 1'b0;
                       
               end
             
             default:
               
                  r_full26 <= 1'b0;
                  
           endcase // r_smc_currentstate26
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate26 Read Strobe26
//----------------------------------------------------------------------
 
  always @(posedge sys_clk26 or negedge n_sys_reset26)
  
  begin
     
     if (~n_sys_reset26)
  
        smc_n_rd26 <= 1'h1;
      
      
     else if (smc_nextstate26 == `SMC_RW26)
  
     begin
  
        if (valid_access26)
  
        begin
  
  
              smc_n_rd26 <= n_read26;
  
  
        end
  
        else if ((r_smc_currentstate26 == `SMC_LE26) | 
                    (r_smc_currentstate26 == `SMC_STORE26))

        begin
           
           if( (r_oete_store26 < r_ws_store26[1:0]) | 
               (r_ws_store26[7:2] != 6'd0) |
               ( (r_oete_store26 == r_ws_store26[1:0]) & 
                 (r_ws_store26[7:2] == 6'd0)
               ) |
               (r_ws_store26 == 8'd0) 
             )
             
             smc_n_rd26 <= n_r_read26;
           
           else
             
             smc_n_rd26 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store26) < r_ws_count26[1:0]) | 
               (r_ws_count26[7:2] != 6'd0) |
               (r_ws_count26 == 8'd0) 
             )
             
              smc_n_rd26 <= n_r_read26;
           
           else

              smc_n_rd26 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd26 <= 1'b1;
     
  end
   
   
 
endmodule


