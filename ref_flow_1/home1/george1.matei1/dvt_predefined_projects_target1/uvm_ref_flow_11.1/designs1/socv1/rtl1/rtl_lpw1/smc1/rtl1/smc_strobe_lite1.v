//File1 name   : smc_strobe_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`include "smc_defs_lite1.v"

module smc_strobe_lite1  (

                    //inputs1

                    sys_clk1,
                    n_sys_reset1,
                    valid_access1,
                    n_read1,
                    cs,
                    r_smc_currentstate1,
                    smc_nextstate1,
                    n_be1,
                    r_wele_count1,
                    r_wele_store1,
                    r_wete_store1,
                    r_oete_store1,
                    r_ws_count1,
                    r_ws_store1,
                    smc_done1,
                    mac_done1,

                    //outputs1

                    smc_n_rd1,
                    smc_n_ext_oe1,
                    smc_busy1,
                    n_r_read1,
                    r_cs1,
                    r_full1,
                    n_r_we1,
                    n_r_wr1);



//Parameters1  -  Values1 in smc_defs1.v

 


// I1/O1

   input                   sys_clk1;      //System1 clock1
   input                   n_sys_reset1;  //System1 reset (Active1 LOW1)
   input                   valid_access1; //load1 values are valid if high1
   input                   n_read1;       //Active1 low1 read signal1
   input              cs;           //registered chip1 select1
   input [4:0]             r_smc_currentstate1;//current state
   input [4:0]             smc_nextstate1;//next state  
   input [3:0]             n_be1;         //Unregistered1 Byte1 strobes1
   input [1:0]             r_wele_count1; //Write counter
   input [1:0]             r_wete_store1; //write strobe1 trailing1 edge store1
   input [1:0]             r_oete_store1; //read strobe1
   input [1:0]             r_wele_store1; //write strobe1 leading1 edge store1
   input [7:0]             r_ws_count1;   //wait state count
   input [7:0]             r_ws_store1;   //wait state store1
   input                   smc_done1;  //one access completed
   input                   mac_done1;  //All cycles1 in a multiple access
   
   
   output                  smc_n_rd1;     // EMI1 read stobe1 (Active1 LOW1)
   output                  smc_n_ext_oe1; // Enable1 External1 bus drivers1.
                                                          //  (CS1 & ~RD1)
   output                  smc_busy1;  // smc1 busy
   output                  n_r_read1;  // Store1 RW strobe1 for multiple
                                                         //  accesses
   output                  r_full1;    // Full cycle write strobe1
   output [3:0]            n_r_we1;    // write enable strobe1(active low1)
   output                  n_r_wr1;    // write strobe1(active low1)
   output             r_cs1;      // registered chip1 select1.   


// Output1 register declarations1

   reg                     smc_n_rd1;
   reg                     smc_n_ext_oe1;
   reg                r_cs1;
   reg                     smc_busy1;
   reg                     n_r_read1;
   reg                     r_full1;
   reg   [3:0]             n_r_we1;
   reg                     n_r_wr1;

   //wire declarations1
   
   wire             smc_mac_done1;       //smc_done1 and  mac_done1 anded1
   wire [2:0]       wait_vaccess_smdone1;//concatenated1 signals1 for case
   reg              half_cycle1;         //used for generating1 half1 cycle
                                                //strobes1
   


//----------------------------------------------------------------------
// Strobe1 Generation1
//
// Individual Write Strobes1
// Write Strobe1 = Byte1 Enable1 & Write Enable1
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// signal1 concatenation1 for use in case statement1
//----------------------------------------------------------------------

   assign smc_mac_done1 = {smc_done1 & mac_done1};

   assign wait_vaccess_smdone1 = {1'b0,valid_access1,smc_mac_done1};
   
   
//----------------------------------------------------------------------
// Store1 read/write signal1 for duration1 of cycle(s)
//----------------------------------------------------------------------

  always @(posedge sys_clk1 or negedge n_sys_reset1)
  
     begin
  
        if (~n_sys_reset1)
  
           n_r_read1 <= 0;
  
        else
          
          begin
             
             casex(wait_vaccess_smdone1)
               
               3'b1xx:
                 
                  n_r_read1 <= n_r_read1;
               
               3'b01x:
                 
                  n_r_read1 <= n_read1;
               
               3'b001:
                 
                  n_r_read1 <= 0;
               
               default:
                 
                  n_r_read1 <= n_r_read1;
               
             endcase        
             
          end
             
     end
   
//----------------------------------------------------------------------
// Store1 chip1 selects1 for duration1 of cycle(s)--turnaround1 cycle
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Store1 read/write signal1 for duration1 of cycle(s)
//----------------------------------------------------------------------

   always @(posedge sys_clk1 or negedge n_sys_reset1)
     
      begin
           
         if (~n_sys_reset1)
           
           r_cs1 <= 1'b0;
         
         else
           
           begin
              
              casex(wait_vaccess_smdone1)
                
                 3'b1xx:
                  
                    r_cs1 <= r_cs1 ;
                
                 3'b01x:
                  
                    r_cs1 <= cs ;
                
                 3'b001:
                  
                    r_cs1 <= 1'b0;
                
                 default:
                  
                    r_cs1 <= r_cs1 ;
                
              endcase        
              
           end
         
      end
  

//----------------------------------------------------------------------
// Drive1 busy output whenever1 smc1 active
//----------------------------------------------------------------------

   always @(posedge sys_clk1 or negedge n_sys_reset1)
     
      begin
          
         if (~n_sys_reset1)
           
            smc_busy1 <= 0;
           
           
         else if (smc_nextstate1 != `SMC_IDLE1)
           
            smc_busy1 <= 1;
           
         else
           
            smc_busy1 <= 0;
           
     end


//----------------------------------------------------------------------
// Drive1 OE1 signal1 to I1/O1 pins1 on ASIC1
//
// Generate1 internal, registered Write strobes1
// The write strobes1 are gated1 with the clock1 later1 to generate half1 
// cycle strobes1
//----------------------------------------------------------------------

  always @(posedge sys_clk1 or negedge n_sys_reset1)
    
     begin
       
        if (~n_sys_reset1)
         
           begin
            
              n_r_we1 <= 4'hF;
              n_r_wr1 <= 1'h1;
            
           end
       

        else if ((n_read1 & valid_access1 & 
                  (smc_nextstate1 != `SMC_STORE1)) |
                 (n_r_read1 & ~valid_access1 & 
                  (smc_nextstate1 != `SMC_STORE1)))      
         
           begin
            
              n_r_we1 <= n_be1;
              n_r_wr1 <= 1'h0;
            
           end
       
        else
         
           begin
            
              n_r_we1 <= 4'hF;
              n_r_wr1 <= 1'h1;
            
           end
       
    end
  
//----------------------------------------------------------------------
// Drive1 OE1 signal1 to I1/O1 pins1 on ASIC1 -----added by gulbir1
//
//----------------------------------------------------------------------
   
   always @(posedge sys_clk1 or negedge n_sys_reset1)
     
     begin
        
        if (~n_sys_reset1)
          
          smc_n_ext_oe1 <= 1;
        
        
        else if ((n_read1 & valid_access1 & 
                  (smc_nextstate1 != `SMC_STORE1)) |
                (n_r_read1 & ~valid_access1 & 
              (smc_nextstate1 != `SMC_STORE1) & 
                 (smc_nextstate1 != `SMC_IDLE1)))      

           smc_n_ext_oe1 <= 0;
        
        else
          
           smc_n_ext_oe1 <= 1;
        
     end
   

//----------------------------------------------------------------------
// Generate1 half1 and full signals1 for write strobes1
// A full cycle is required1 if wait states1 are added
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Generate1 half1 cycle signals1 for write strobes1
//----------------------------------------------------------------------

always @(r_smc_currentstate1 or smc_nextstate1 or
            r_full1 or 
            r_wete_store1 or r_ws_store1 or r_wele_store1 or 
            r_ws_count1 or r_wele_count1 or 
            valid_access1 or smc_done1)
  
  begin     
     
       begin
          
          case (r_smc_currentstate1)
            
            `SMC_IDLE1:
              
              begin
                 
                     half_cycle1 = 1'b0;
                 
              end
            
            `SMC_LE1:
              
              begin
                 
                 if (smc_nextstate1 == `SMC_RW1)
                   
                   if( ( ( (r_wete_store1) == r_ws_count1[1:0]) &
                         (r_ws_count1[7:2] == 6'd0) &
                         (r_wele_count1 < 2'd2)
                       ) |
                       (r_ws_count1 == 8'd0)
                     )
                     
                     half_cycle1 = 1'b1 & ~r_full1;
                 
                   else
                     
                     half_cycle1 = 1'b0;
                 
                 else
                   
                   half_cycle1 = 1'b0;
                 
              end
            
            `SMC_RW1, `SMC_FLOAT1:
              
              begin
                 
                 if (smc_nextstate1 == `SMC_RW1)
                   
                   if (valid_access1)

                       
                       half_cycle1 = 1'b0;
                 
                   else if (smc_done1)
                     
                     if( ( (r_wete_store1 == r_ws_store1[1:0]) & 
                           (r_ws_store1[7:2] == 6'd0) & 
                           (r_wele_store1 == 2'd0)
                         ) | 
                         (r_ws_store1 == 8'd0)
                       )
                       
                       half_cycle1 = 1'b1 & ~r_full1;
                 
                     else
                       
                       half_cycle1 = 1'b0;
                 
                   else
                     
                     if (r_wete_store1 == 2'd3)
                       
                       if ( (2'd0 == r_ws_count1[1:0]) & 
                            (r_ws_count1[7:2] == 6'd1) &
                            (r_wele_count1 < 2'd2)
                          )
                         
                         half_cycle1 = 1'b1 & ~r_full1;
                 
                       else
                         
                         half_cycle1 = 1'b0;
                 
                     else
                       
                       if ( ( ( (r_wete_store1+2'd1) == r_ws_count1[1:0]) & 
                              (r_ws_count1[7:2] == 6'd0) & 
                              (r_wele_count1 < 2'd2)
                            )
                          )
                         
                         half_cycle1 = 1'b1 & ~r_full1;
                 
                       else
                         
                         half_cycle1 = 1'b0;
                 
                 else
                   
                   half_cycle1 = 1'b0;
                 
              end
            
            `SMC_STORE1:
              
              begin
                 
                 if (smc_nextstate1 == `SMC_RW1)

                   if( ( ( (r_wete_store1) == r_ws_count1[1:0]) & 
                         (r_ws_count1[7:2] == 6'd0) & 
                         (r_wele_count1 < 2'd2)
                       ) | 
                       (r_ws_count1 == 8'd0)
                     )
                     
                     half_cycle1 = 1'b1 & ~r_full1;
                 
                   else
                     
                     half_cycle1 = 1'b0;
                 
                 else
                   
                   half_cycle1 = 1'b0;
                 
              end
            
            default:
              
              half_cycle1 = 1'b0;
            
          endcase // r_smc_currentstate1
          
       end
     
     end

//----------------------------------------------------------------------
//Full cycle signal1 generation1
//----------------------------------------------------------------------

 always @(posedge sys_clk1 or negedge n_sys_reset1)
             
   begin
      
      if (~n_sys_reset1)
        
        begin
           
           r_full1 <= 1'b0;
           
        end
      
      
           
      else
        
        begin
           
           case (r_smc_currentstate1)
             
             `SMC_IDLE1:
               
               begin
                  
                  if (smc_nextstate1 == `SMC_RW1)
                    
                         
                         r_full1 <= 1'b0;
                       
                  else
                        
                       r_full1 <= 1'b0;
                       
               end
             
          `SMC_LE1:
            
          begin
             
             if (smc_nextstate1 == `SMC_RW1)
               
                  if( ( ( (r_wete_store1) < r_ws_count1[1:0]) | 
                        (r_ws_count1[7:2] != 6'd0)
                      ) & 
                      (r_wele_count1 < 2'd2)
                    )
                    
                    r_full1 <= 1'b1;
                  
                  else
                    
                    r_full1 <= 1'b0;
                  
             else
               
                  r_full1 <= 1'b0;
                  
          end
          
          `SMC_RW1, `SMC_FLOAT1:
            
            begin
               
               if (smc_nextstate1 == `SMC_RW1)
                 
                 begin
                    
                    if (valid_access1)
                      
                           
                           r_full1 <= 1'b0;
                         
                    else if (smc_done1)
                      
                         if( ( ( (r_wete_store1 < r_ws_store1[1:0]) | 
                                 (r_ws_store1[7:2] != 6'd0)
                               ) & 
                               (r_wele_store1 == 2'd0)
                             )
                           )
                           
                           r_full1 <= 1'b1;
                         
                         else
                           
                           r_full1 <= 1'b0;
                         
                    else
                      
                      begin
                         
                         if(r_wete_store1 == 2'd3)
                           
                           if( ( (r_ws_count1[7:0] > 8'd4)
                               ) & 
                               (r_wele_count1 < 2'd2)
                             )
                             
                             r_full1 <= 1'b1;
                         
                           else
                             
                             r_full1 <= 1'b0;
                         
                         else if ( ( ( ( (r_wete_store1 + 2'd1) < 
                                         r_ws_count1[1:0]
                                       )
                                     ) |
                                     (r_ws_count1[7:2] != 6'd0)
                                   ) & 
                                   (r_wele_count1 < 2'd2)
                                 )
                           
                           r_full1 <= 1'b1;
                         
                         else
                           
                           r_full1 <= 1'b0;
                         
                         
                         
                      end
                    
                 end
               
               else
                 
                    r_full1 <= 1'b0;
               
            end
             
             `SMC_STORE1:
               
               begin
                  
                  if (smc_nextstate1 == `SMC_RW1)

                     if ( ( ( (r_wete_store1) < r_ws_count1[1:0]) | 
                            (r_ws_count1[7:2] != 6'd0)
                          ) & 
                          (r_wele_count1 == 2'd0)
                        )
                         
                         r_full1 <= 1'b1;
                       
                       else
                         
                         r_full1 <= 1'b0;
                       
                  else
                    
                       r_full1 <= 1'b0;
                       
               end
             
             default:
               
                  r_full1 <= 1'b0;
                  
           endcase // r_smc_currentstate1
           
             end
      
   end
 
//----------------------------------------------------------------------
// Generate1 Read Strobe1
//----------------------------------------------------------------------
 
  always @(posedge sys_clk1 or negedge n_sys_reset1)
  
  begin
     
     if (~n_sys_reset1)
  
        smc_n_rd1 <= 1'h1;
      
      
     else if (smc_nextstate1 == `SMC_RW1)
  
     begin
  
        if (valid_access1)
  
        begin
  
  
              smc_n_rd1 <= n_read1;
  
  
        end
  
        else if ((r_smc_currentstate1 == `SMC_LE1) | 
                    (r_smc_currentstate1 == `SMC_STORE1))

        begin
           
           if( (r_oete_store1 < r_ws_store1[1:0]) | 
               (r_ws_store1[7:2] != 6'd0) |
               ( (r_oete_store1 == r_ws_store1[1:0]) & 
                 (r_ws_store1[7:2] == 6'd0)
               ) |
               (r_ws_store1 == 8'd0) 
             )
             
             smc_n_rd1 <= n_r_read1;
           
           else
             
             smc_n_rd1 <= 1'b1;
           
        end
        
        else
  
        begin

           if( ( (r_oete_store1) < r_ws_count1[1:0]) | 
               (r_ws_count1[7:2] != 6'd0) |
               (r_ws_count1 == 8'd0) 
             )
             
              smc_n_rd1 <= n_r_read1;
           
           else

              smc_n_rd1 <= 1'b1;
         
        end
        
     end
     
     else
       
        smc_n_rd1 <= 1'b1;
     
  end
   
   
 
endmodule


