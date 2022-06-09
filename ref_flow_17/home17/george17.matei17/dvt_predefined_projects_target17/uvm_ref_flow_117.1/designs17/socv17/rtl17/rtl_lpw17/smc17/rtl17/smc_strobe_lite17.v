//File17 name   : smc_strobe_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`include "smc_defs_lite17.v"

module smc_strobe_lite17  (

                    //inputs17

                    sys_clk17,
                    n_sys_reset17,
                    valid_access17,
                    n_read17,
                    cs,
                    r_smc_currentstate17,
                    smc_nextstate17,
                    n_be17,
                    r_wele_count17,
                    r_wele_store17,
                    r_wete_store17,
                    r_oete_store17,
                    r_ws_count17,
                    r_ws_store17,
                    smc_done17,
                    mac_done17,

                    //outputs17

                    smc_n_rd17,
                    smc_n_ext_oe17,
                    smc_busy17,
                    n_r_read17,
                    r_cs17,
                    r_full17,
                    n_r_we17,
                    n_r_wr17);



//Parameters17  -  Values17 in smc_defs17.v

 


// I17/O17

   input                   sys_clk17;      //System17 clock17
   input                   n_sys_reset17;  //System17 reset (Active17 LOW17)
   input                   valid_access17; //load17 values are valid if high17
   input                   n_read17;       //Active17 low17 read signal17
   input              cs;           //registered chip17 select17
   input [4:0]             r_smc_currentstate17;//current state
   input [4:0]             smc_nextstate17;//next state  
   input [3:0]             n_be17;         //Unregistered17 Byte17 strobes17
   input [1:0]             r_wele_count17; //Write counter
   input [1:0]             r_wete_store17; //write strobe17 trailing17 edge store17
   input [1:0]             r_oete_store17; //read strobe17
   input [1:0]             r_wele_store17; //write strobe17 leading17 edge store17
   input [7:0]             r_ws_count17;   //wait state count
   input [7:0]             r_ws_store17;   //wait state store17
   input                   smc_done17;  //one access completed
   input                   mac_done17;  //All cycles17 in a multiple access
   
   
   output                  smc_n_rd17;     // EMI17 read stobe17 (Active17 LOW17)
   output                  smc_n_ext_oe17; // Enable17 External17 bus drivers17.
                                                          //  (CS17 & ~RD17)
   output                  smc_busy17;  // smc17 busy
   output                  n_r_read17;  // Store17 RW strobe17 for multiple
                                                         //  accesses
   output                  r_full17;    // Full cycle write strobe17
   output [3:0]            n_r_we17;    // write enable strobe17(active low17)
   output                  n_r_wr17;    // write strobe17(active low17)
   output             r_cs17;      // registered chip17 select17.   


// Output17 register declarations17

   reg                     smc_n_rd17;
   reg                     smc_n_ext_oe17;
   reg                r_cs17;
   reg                     smc_busy17;
   reg                     n_r_read17;
   reg                     r_full17;
   reg   [3:0]             n_r_we17;
   reg                     n_r_wr17;

   //wire declarations17
   
   wire             smc_mac_done17;       //smc_done17 and  mac_done17 anded17
   wire [2:0]       wait_vaccess_smdone17;//concatenated17 signals17 for case
   reg              half_cycle17;         //used for generating17 half17 cycle
                                                //strobes17
   


//----------------------------------------------------------------------
// Strobe17 Generation17
//
// Individual Write Strobes17
// Write Strobe17 = Byte17 Enable17 & Write Enable17
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal17 concatenation17 for use in case statement17
//----------------------------------------------------------------------

   assign smc_mac_done17 = {smc_done17 & mac_done17};

   assign wait_vaccess_smdone17 = {1'b0,valid_access17,smc_mac_done17};
   
   
//----------------------------------------------------------------------
// Store17 read/write signal17 for duration17 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk17 or negedge n_sys_reset17)
  
     begin
  
        if (~n_sys_reset17)
  
           n_r_read17 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone17)
               
               3'b1xx:
                 
                  n_r_read17 <= n_r_read17;
               
               3'b01x:
                 
                  n_r_read17 <= n_read17;
               
               3'b001:
                 
                  n_r_read17 <= 0;
               
               default:
                 
                  n_r_read17 <= n_r_read17;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store17 chip17 selects17 for duration17 of cycle(s)--turnaround17 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store17 read/write signal17 for duration17 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk17 or negedge n_sys_reset17)
     
      begin
           
         if (~n_sys_reset17)
           
           r_cs17 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone17)
                
                 3'b1xx:
                  
                    r_cs17 <= r_cs17 ;
                
                 3'b01x:
                  
                    r_cs17 <= cs ;
                
                 3'b001:
                  
                    r_cs17 <= 1'b0;
                
                 default:
                  
                    r_cs17 <= r_cs17 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive17 busy output whenever17 smc17 active
//----------------------------------------------------------------------

   always @(posedge sys_clk17 or negedge n_sys_reset17)
     
      begin
          
         if (~n_sys_reset17)
           
            smc_busy17 <= 0;
           
           
         else if (smc_nextstate17 != `SMC_IDLE17)
           
            smc_busy17 <= 1;
           
         else
           
            smc_busy17 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive17 OE17 signal17 to I17/O17 pins17 on ASIC17
//
// Generate17 internal, registered Write strobes17
// The write strobes17 are gated17 with the clock17 later17 to generate half17 
// cycle strobes17
//----------------------------------------------------------------------

  always @(posedge sys_clk17 or negedge n_sys_reset17)
    
     begin
       
        if (~n_sys_reset17)
         
           begin
            
              n_r_we17 <= 4'hF;
              n_r_wr17 <= 1'h1;
            
           end
       

        else if ((n_read17 & valid_access17 & 
                  (smc_nextstate17 != `SMC_STORE17)) |
                 (n_r_read17 & ~valid_access17 & 
                  (smc_nextstate17 != `SMC_STORE17)))      
         
           begin
            
              n_r_we17 <= n_be17;
              n_r_wr17 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we17 <= 4'hF;
              n_r_wr17 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive17 OE17 signal17 to I17/O17 pins17 on ASIC17 -----added by gulbir17
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk17 or negedge n_sys_reset17)
     
     begin
        
        if (~n_sys_reset17)
          
          smc_n_ext_oe17 <= 1;
        
        
        else if ((n_read17 & valid_access17 & 
                  (smc_nextstate17 != `SMC_STORE17)) |
                (n_r_read17 & ~valid_access17 & 
              (smc_nextstate17 != `SMC_STORE17) & 
                 (smc_nextstate17 != `SMC_IDLE17)))      

           smc_n_ext_oe17 <= 0;
        
        else
          
           smc_n_ext_oe17 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate17 half17 and full signals17 for write strobes17
// A full cycle is required17 if wait states17 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate17 half17 cycle signals17 for write strobes17
//----------------------------------------------------------------------

always @(r_smc_currentstate17 or smc_nextstate17 or
            r_full17 or 
            r_wete_store17 or r_ws_store17 or r_wele_store17 or 
            r_ws_count17 or r_wele_count17 or 
            valid_access17 or smc_done17)
  
  begin     
     
       begin
          
          case (r_smc_currentstate17)
            
            `SMC_IDLE17:
              
              begin
                 
                     half_cycle17 = 1'b0;
                 
              end
            
            `SMC_LE17:
              
              begin
                 
                 if (smc_nextstate17 == `SMC_RW17)
                   
                   if( ( ( (r_wete_store17) == r_ws_count17[1:0]) &
                         (r_ws_count17[7:2] == 6'd0) &
                         (r_wele_count17 < 2'd2)
                       ) |
                       (r_ws_count17 == 8'd0)
                     )
                     
                     half_cycle17 = 1'b1 & ~r_full17;
                 
                   else
                     
                     half_cycle17 = 1'b0;
                 
                 else
                   
                   half_cycle17 = 1'b0;
                 
              end
            
            `SMC_RW17, `SMC_FLOAT17:
              
              begin
                 
                 if (smc_nextstate17 == `SMC_RW17)
                   
                   if (valid_access17)

                       
                       half_cycle17 = 1'b0;
                 
                   else if (smc_done17)
                     
                     if( ( (r_wete_store17 == r_ws_store17[1:0]) & 
                           (r_ws_store17[7:2] == 6'd0) & 
                           (r_wele_store17 == 2'd0)
                         ) | 
                         (r_ws_store17 == 8'd0)
                       )
                       
                       half_cycle17 = 1'b1 & ~r_full17;
                 
                     else
                       
                       half_cycle17 = 1'b0;
                 
                   else
                     
                     if (r_wete_store17 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count17[1:0]) & 
                            (r_ws_count17[7:2] == 6'd1) &
                            (r_wele_count17 < 2'd2)
                          )
                         
                         half_cycle17 = 1'b1 & ~r_full17;
                 
                       else
                         
                         half_cycle17 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store17+2'd1) == r_ws_count17[1:0]) & 
                              (r_ws_count17[7:2] == 6'd0) & 
                              (r_wele_count17 < 2'd2)
                            )
                          )
                         
                         half_cycle17 = 1'b1 & ~r_full17;
                 
                       else
                         
                         half_cycle17 = 1'b0;
                 
                 else
                   
                   half_cycle17 = 1'b0;
                 
              end
            
            `SMC_STORE17:
              
              begin
                 
                 if (smc_nextstate17 == `SMC_RW17)

                   if( ( ( (r_wete_store17) == r_ws_count17[1:0]) & 
                         (r_ws_count17[7:2] == 6'd0) & 
                         (r_wele_count17 < 2'd2)
                       ) | 
                       (r_ws_count17 == 8'd0)
                     )
                     
                     half_cycle17 = 1'b1 & ~r_full17;
                 
                   else
                     
                     half_cycle17 = 1'b0;
                 
                 else
                   
                   half_cycle17 = 1'b0;
                 
              end
            
            default:
              
              half_cycle17 = 1'b0;
            
          endcase // r_smc_currentstate17
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal17 generation17
//----------------------------------------------------------------------

 always @(posedge sys_clk17 or negedge n_sys_reset17)
             
   begin
      
      if (~n_sys_reset17)
        
        begin
           
           r_full17 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate17)
             
             `SMC_IDLE17:
               
               begin
                  
                  if (smc_nextstate17 == `SMC_RW17)
                    
                         
                         r_full17 <= 1'b0;
                       
                  else
                        
                       r_full17 <= 1'b0;
                       
               end
             
          `SMC_LE17:
            
          begin
             
             if (smc_nextstate17 == `SMC_RW17)
               
                  if( ( ( (r_wete_store17) < r_ws_count17[1:0]) | 
                        (r_ws_count17[7:2] != 6'd0)
                      ) & 
                      (r_wele_count17 < 2'd2)
                    )
                    
                    r_full17 <= 1'b1;
                  
                  else
                    
                    r_full17 <= 1'b0;
                  
             else
               
                  r_full17 <= 1'b0;
                  
          end
          
          `SMC_RW17, `SMC_FLOAT17:
            
            begin
               
               if (smc_nextstate17 == `SMC_RW17)
                 
                 begin
                    
                    if (valid_access17)
                      
                           
                           r_full17 <= 1'b0;
                         
                    else if (smc_done17)
                      
                         if( ( ( (r_wete_store17 < r_ws_store17[1:0]) | 
                                 (r_ws_store17[7:2] != 6'd0)
                               ) & 
                               (r_wele_store17 == 2'd0)
                             )
                           )
                           
                           r_full17 <= 1'b1;
                         
                         else
                           
                           r_full17 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store17 == 2'd3)
                           
                           if( ( (r_ws_count17[7:0] > 8'd4)
                               ) & 
                               (r_wele_count17 < 2'd2)
                             )
                             
                             r_full17 <= 1'b1;
                         
                           else
                             
                             r_full17 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store17 + 2'd1) < 
                                         r_ws_count17[1:0]
                                       )
                                     ) |
                                     (r_ws_count17[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count17 < 2'd2)
                                 )
                           
                           r_full17 <= 1'b1;
                         
                         else
                           
                           r_full17 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full17 <= 1'b0;
               
            end
             
             `SMC_STORE17:
               
               begin
                  
                  if (smc_nextstate17 == `SMC_RW17)

                     if ( ( ( (r_wete_store17) < r_ws_count17[1:0]) | 
                            (r_ws_count17[7:2] != 6'd0)
                          ) & 
                          (r_wele_count17 == 2'd0)
                        )
                         
                         r_full17 <= 1'b1;
                       
                       else
                         
                         r_full17 <= 1'b0;
                       
                  else
                    
                       r_full17 <= 1'b0;
                       
               end
             
             default:
               
                  r_full17 <= 1'b0;
                  
           endcase // r_smc_currentstate17
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate17 Read Strobe17
//----------------------------------------------------------------------
 
  always @(posedge sys_clk17 or negedge n_sys_reset17)
  
  begin
     
     if (~n_sys_reset17)
  
        smc_n_rd17 <= 1'h1;
      
      
     else if (smc_nextstate17 == `SMC_RW17)
  
     begin
  
        if (valid_access17)
  
        begin
  
  
              smc_n_rd17 <= n_read17;
  
  
        end
  
        else if ((r_smc_currentstate17 == `SMC_LE17) | 
                    (r_smc_currentstate17 == `SMC_STORE17))

        begin
           
           if( (r_oete_store17 < r_ws_store17[1:0]) | 
               (r_ws_store17[7:2] != 6'd0) |
               ( (r_oete_store17 == r_ws_store17[1:0]) & 
                 (r_ws_store17[7:2] == 6'd0)
               ) |
               (r_ws_store17 == 8'd0) 
             )
             
             smc_n_rd17 <= n_r_read17;
           
           else
             
             smc_n_rd17 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store17) < r_ws_count17[1:0]) | 
               (r_ws_count17[7:2] != 6'd0) |
               (r_ws_count17 == 8'd0) 
             )
             
              smc_n_rd17 <= n_r_read17;
           
           else

              smc_n_rd17 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd17 <= 1'b1;
     
  end
   
   
 
endmodule


