//File9 name   : smc_addr_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : This9 block registers the address and chip9 select9
//              lines9 for the current access. The address may only
//              driven9 for one cycle by the AHB9. If9 multiple
//              accesses are required9 the bottom9 two9 address bits
//              are modified between cycles9 depending9 on the current
//              transfer9 and bus size.
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

//


`include "smc_defs_lite9.v"

// address decoder9

module smc_addr_lite9    (
                    //inputs9

                    sys_clk9,
                    n_sys_reset9,
                    valid_access9,
                    r_num_access9,
                    v_bus_size9,
                    v_xfer_size9,
                    cs,
                    addr,
                    smc_done9,
                    smc_nextstate9,


                    //outputs9

                    smc_addr9,
                    smc_n_be9,
                    smc_n_cs9,
                    n_be9);



// I9/O9

   input                    sys_clk9;      //AHB9 System9 clock9
   input                    n_sys_reset9;  //AHB9 System9 reset 
   input                    valid_access9; //Start9 of new cycle
   input [1:0]              r_num_access9; //MAC9 counter
   input [1:0]              v_bus_size9;   //bus width for current access
   input [1:0]              v_xfer_size9;  //Transfer9 size for current 
                                              // access
   input               cs;           //Chip9 (Bank9) select9(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done9;     //Transfer9 complete (state 
                                              // machine9)
   input [4:0]              smc_nextstate9;//Next9 state 

   
   output [31:0]            smc_addr9;     //External9 Memory Interface9 
                                              //  address
   output [3:0]             smc_n_be9;     //EMI9 byte enables9 
   output              smc_n_cs9;     //EMI9 Chip9 Selects9 
   output [3:0]             n_be9;         //Unregistered9 Byte9 strobes9
                                             // used to genetate9 
                                             // individual9 write strobes9

// Output9 register declarations9
   
   reg [31:0]                  smc_addr9;
   reg [3:0]                   smc_n_be9;
   reg                    smc_n_cs9;
   reg [3:0]                   n_be9;
   
   
   // Internal register declarations9
   
   reg [1:0]                  r_addr9;           // Stored9 Address bits 
   reg                   r_cs9;             // Stored9 CS9
   reg [1:0]                  v_addr9;           // Validated9 Address
                                                     //  bits
   reg [7:0]                  v_cs9;             // Validated9 CS9
   
   wire                       ored_v_cs9;        //oring9 of v_sc9
   wire [4:0]                 cs_xfer_bus_size9; //concatenated9 bus and 
                                                  // xfer9 size
   wire [2:0]                 wait_access_smdone9;//concatenated9 signal9
   

// Main9 Code9
//----------------------------------------------------------------------
// Address Store9, CS9 Store9 & BE9 Store9
//----------------------------------------------------------------------

   always @(posedge sys_clk9 or negedge n_sys_reset9)
     
     begin
        
        if (~n_sys_reset9)
          
           r_cs9 <= 1'b0;
        
        
        else if (valid_access9)
          
           r_cs9 <= cs ;
        
        else
          
           r_cs9 <= r_cs9 ;
        
     end

//----------------------------------------------------------------------
//v_cs9 generation9   
//----------------------------------------------------------------------
   
   always @(cs or r_cs9 or valid_access9 )
     
     begin
        
        if (valid_access9)
          
           v_cs9 = cs ;
        
        else
          
           v_cs9 = r_cs9;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone9 = {1'b0,valid_access9,smc_done9};

//----------------------------------------------------------------------
//smc_addr9 generation9
//----------------------------------------------------------------------

  always @(posedge sys_clk9 or negedge n_sys_reset9)
    
    begin
      
      if (~n_sys_reset9)
        
         smc_addr9 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone9)
             3'b1xx :

               smc_addr9 <= smc_addr9;
                        //valid_access9 
             3'b01x : begin
               // Set up address for first access
               // little9-endian from max address downto9 0
               // big-endian from 0 upto9 max_address9
               smc_addr9 [31:2] <= addr [31:2];

               casez( { v_xfer_size9, v_bus_size9, 1'b0 } )

               { `XSIZ_329, `BSIZ_329, 1'b? } : smc_addr9[1:0] <= 2'b00;
               { `XSIZ_329, `BSIZ_169, 1'b0 } : smc_addr9[1:0] <= 2'b10;
               { `XSIZ_329, `BSIZ_169, 1'b1 } : smc_addr9[1:0] <= 2'b00;
               { `XSIZ_329, `BSIZ_89, 1'b0 } :  smc_addr9[1:0] <= 2'b11;
               { `XSIZ_329, `BSIZ_89, 1'b1 } :  smc_addr9[1:0] <= 2'b00;
               { `XSIZ_169, `BSIZ_329, 1'b? } : smc_addr9[1:0] <= {addr[1],1'b0};
               { `XSIZ_169, `BSIZ_169, 1'b? } : smc_addr9[1:0] <= {addr[1],1'b0};
               { `XSIZ_169, `BSIZ_89, 1'b0 } :  smc_addr9[1:0] <= {addr[1],1'b1};
               { `XSIZ_169, `BSIZ_89, 1'b1 } :  smc_addr9[1:0] <= {addr[1],1'b0};
               { `XSIZ_89, 2'b??, 1'b? } :     smc_addr9[1:0] <= addr[1:0];
               default:                       smc_addr9[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses9 fro9 subsequent9 accesses
                // little9 endian decrements9 according9 to access no.
                // bigendian9 increments9 as access no decrements9

                  smc_addr9[31:2] <= smc_addr9[31:2];
                  
               casez( { v_xfer_size9, v_bus_size9, 1'b0 } )

               { `XSIZ_329, `BSIZ_329, 1'b? } : smc_addr9[1:0] <= 2'b00;
               { `XSIZ_329, `BSIZ_169, 1'b0 } : smc_addr9[1:0] <= 2'b00;
               { `XSIZ_329, `BSIZ_169, 1'b1 } : smc_addr9[1:0] <= 2'b10;
               { `XSIZ_329, `BSIZ_89,  1'b0 } : 
                  case( r_num_access9 ) 
                  2'b11:   smc_addr9[1:0] <= 2'b10;
                  2'b10:   smc_addr9[1:0] <= 2'b01;
                  2'b01:   smc_addr9[1:0] <= 2'b00;
                  default: smc_addr9[1:0] <= 2'b11;
                  endcase
               { `XSIZ_329, `BSIZ_89, 1'b1 } :  
                  case( r_num_access9 ) 
                  2'b11:   smc_addr9[1:0] <= 2'b01;
                  2'b10:   smc_addr9[1:0] <= 2'b10;
                  2'b01:   smc_addr9[1:0] <= 2'b11;
                  default: smc_addr9[1:0] <= 2'b00;
                  endcase
               { `XSIZ_169, `BSIZ_329, 1'b? } : smc_addr9[1:0] <= {r_addr9[1],1'b0};
               { `XSIZ_169, `BSIZ_169, 1'b? } : smc_addr9[1:0] <= {r_addr9[1],1'b0};
               { `XSIZ_169, `BSIZ_89, 1'b0 } :  smc_addr9[1:0] <= {r_addr9[1],1'b0};
               { `XSIZ_169, `BSIZ_89, 1'b1 } :  smc_addr9[1:0] <= {r_addr9[1],1'b1};
               { `XSIZ_89, 2'b??, 1'b? } :     smc_addr9[1:0] <= r_addr9[1:0];
               default:                       smc_addr9[1:0] <= r_addr9[1:0];

               endcase
                 
            end
            
            default :

               smc_addr9 <= smc_addr9;
            
          endcase // casex(wait_access_smdone9)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate9 Chip9 Select9 Output9 
//----------------------------------------------------------------------

   always @(posedge sys_clk9 or negedge n_sys_reset9)
     
     begin
        
        if (~n_sys_reset9)
          
          begin
             
             smc_n_cs9 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate9 == `SMC_RW9)
          
           begin
             
              if (valid_access9)
               
                 smc_n_cs9 <= ~cs ;
             
              else
               
                 smc_n_cs9 <= ~r_cs9 ;

           end
        
        else
          
           smc_n_cs9 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch9 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk9 or negedge n_sys_reset9)
     
     begin
        
        if (~n_sys_reset9)
          
           r_addr9 <= 2'd0;
        
        
        else if (valid_access9)
          
           r_addr9 <= addr[1:0];
        
        else
          
           r_addr9 <= r_addr9;
        
     end
   


//----------------------------------------------------------------------
// Validate9 LSB of addr with valid_access9
//----------------------------------------------------------------------

   always @(r_addr9 or valid_access9 or addr)
     
      begin
        
         if (valid_access9)
           
            v_addr9 = addr[1:0];
         
         else
           
            v_addr9 = r_addr9;
         
      end
//----------------------------------------------------------------------
//cancatenation9 of signals9
//----------------------------------------------------------------------
                               //check for v_cs9 = 0
   assign ored_v_cs9 = |v_cs9;   //signal9 concatenation9 to be used in case
   
//----------------------------------------------------------------------
// Generate9 (internal) Byte9 Enables9.
//----------------------------------------------------------------------

   always @(v_cs9 or v_xfer_size9 or v_bus_size9 or v_addr9 )
     
     begin

       if ( |v_cs9 == 1'b1 ) 
        
         casez( {v_xfer_size9, v_bus_size9, 1'b0, v_addr9[1:0] } )
          
         {`XSIZ_89, `BSIZ_89, 1'b?, 2'b??} : n_be9 = 4'b1110; // Any9 on RAM9 B09
         {`XSIZ_89, `BSIZ_169,1'b0, 2'b?0} : n_be9 = 4'b1110; // B29 or B09 = RAM9 B09
         {`XSIZ_89, `BSIZ_169,1'b0, 2'b?1} : n_be9 = 4'b1101; // B39 or B19 = RAM9 B19
         {`XSIZ_89, `BSIZ_169,1'b1, 2'b?0} : n_be9 = 4'b1101; // B29 or B09 = RAM9 B19
         {`XSIZ_89, `BSIZ_169,1'b1, 2'b?1} : n_be9 = 4'b1110; // B39 or B19 = RAM9 B09
         {`XSIZ_89, `BSIZ_329,1'b0, 2'b00} : n_be9 = 4'b1110; // B09 = RAM9 B09
         {`XSIZ_89, `BSIZ_329,1'b0, 2'b01} : n_be9 = 4'b1101; // B19 = RAM9 B19
         {`XSIZ_89, `BSIZ_329,1'b0, 2'b10} : n_be9 = 4'b1011; // B29 = RAM9 B29
         {`XSIZ_89, `BSIZ_329,1'b0, 2'b11} : n_be9 = 4'b0111; // B39 = RAM9 B39
         {`XSIZ_89, `BSIZ_329,1'b1, 2'b00} : n_be9 = 4'b0111; // B09 = RAM9 B39
         {`XSIZ_89, `BSIZ_329,1'b1, 2'b01} : n_be9 = 4'b1011; // B19 = RAM9 B29
         {`XSIZ_89, `BSIZ_329,1'b1, 2'b10} : n_be9 = 4'b1101; // B29 = RAM9 B19
         {`XSIZ_89, `BSIZ_329,1'b1, 2'b11} : n_be9 = 4'b1110; // B39 = RAM9 B09
         {`XSIZ_169,`BSIZ_89, 1'b?, 2'b??} : n_be9 = 4'b1110; // Any9 on RAM9 B09
         {`XSIZ_169,`BSIZ_169,1'b?, 2'b??} : n_be9 = 4'b1100; // Any9 on RAMB109
         {`XSIZ_169,`BSIZ_329,1'b0, 2'b0?} : n_be9 = 4'b1100; // B109 = RAM9 B109
         {`XSIZ_169,`BSIZ_329,1'b0, 2'b1?} : n_be9 = 4'b0011; // B239 = RAM9 B239
         {`XSIZ_169,`BSIZ_329,1'b1, 2'b0?} : n_be9 = 4'b0011; // B109 = RAM9 B239
         {`XSIZ_169,`BSIZ_329,1'b1, 2'b1?} : n_be9 = 4'b1100; // B239 = RAM9 B109
         {`XSIZ_329,`BSIZ_89, 1'b?, 2'b??} : n_be9 = 4'b1110; // Any9 on RAM9 B09
         {`XSIZ_329,`BSIZ_169,1'b?, 2'b??} : n_be9 = 4'b1100; // Any9 on RAM9 B109
         {`XSIZ_329,`BSIZ_329,1'b?, 2'b??} : n_be9 = 4'b0000; // Any9 on RAM9 B32109
         default                         : n_be9 = 4'b1111; // Invalid9 decode
        
         
         endcase // casex(xfer_bus_size9)
        
       else

         n_be9 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate9 (enternal9) Byte9 Enables9.
//----------------------------------------------------------------------

   always @(posedge sys_clk9 or negedge n_sys_reset9)
     
     begin
        
        if (~n_sys_reset9)
          
           smc_n_be9 <= 4'hF;
        
        
        else if (smc_nextstate9 == `SMC_RW9)
          
           smc_n_be9 <= n_be9;
        
        else
          
           smc_n_be9 <= 4'hF;
        
     end
   
   
endmodule

