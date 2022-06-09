//File16 name   : smc_addr_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : This16 block registers the address and chip16 select16
//              lines16 for the current access. The address may only
//              driven16 for one cycle by the AHB16. If16 multiple
//              accesses are required16 the bottom16 two16 address bits
//              are modified between cycles16 depending16 on the current
//              transfer16 and bus size.
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

//


`include "smc_defs_lite16.v"

// address decoder16

module smc_addr_lite16    (
                    //inputs16

                    sys_clk16,
                    n_sys_reset16,
                    valid_access16,
                    r_num_access16,
                    v_bus_size16,
                    v_xfer_size16,
                    cs,
                    addr,
                    smc_done16,
                    smc_nextstate16,


                    //outputs16

                    smc_addr16,
                    smc_n_be16,
                    smc_n_cs16,
                    n_be16);



// I16/O16

   input                    sys_clk16;      //AHB16 System16 clock16
   input                    n_sys_reset16;  //AHB16 System16 reset 
   input                    valid_access16; //Start16 of new cycle
   input [1:0]              r_num_access16; //MAC16 counter
   input [1:0]              v_bus_size16;   //bus width for current access
   input [1:0]              v_xfer_size16;  //Transfer16 size for current 
                                              // access
   input               cs;           //Chip16 (Bank16) select16(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done16;     //Transfer16 complete (state 
                                              // machine16)
   input [4:0]              smc_nextstate16;//Next16 state 

   
   output [31:0]            smc_addr16;     //External16 Memory Interface16 
                                              //  address
   output [3:0]             smc_n_be16;     //EMI16 byte enables16 
   output              smc_n_cs16;     //EMI16 Chip16 Selects16 
   output [3:0]             n_be16;         //Unregistered16 Byte16 strobes16
                                             // used to genetate16 
                                             // individual16 write strobes16

// Output16 register declarations16
   
   reg [31:0]                  smc_addr16;
   reg [3:0]                   smc_n_be16;
   reg                    smc_n_cs16;
   reg [3:0]                   n_be16;
   
   
   // Internal register declarations16
   
   reg [1:0]                  r_addr16;           // Stored16 Address bits 
   reg                   r_cs16;             // Stored16 CS16
   reg [1:0]                  v_addr16;           // Validated16 Address
                                                     //  bits
   reg [7:0]                  v_cs16;             // Validated16 CS16
   
   wire                       ored_v_cs16;        //oring16 of v_sc16
   wire [4:0]                 cs_xfer_bus_size16; //concatenated16 bus and 
                                                  // xfer16 size
   wire [2:0]                 wait_access_smdone16;//concatenated16 signal16
   

// Main16 Code16
//----------------------------------------------------------------------
// Address Store16, CS16 Store16 & BE16 Store16
//----------------------------------------------------------------------

   always @(posedge sys_clk16 or negedge n_sys_reset16)
     
     begin
        
        if (~n_sys_reset16)
          
           r_cs16 <= 1'b0;
        
        
        else if (valid_access16)
          
           r_cs16 <= cs ;
        
        else
          
           r_cs16 <= r_cs16 ;
        
     end

//----------------------------------------------------------------------
//v_cs16 generation16   
//----------------------------------------------------------------------
   
   always @(cs or r_cs16 or valid_access16 )
     
     begin
        
        if (valid_access16)
          
           v_cs16 = cs ;
        
        else
          
           v_cs16 = r_cs16;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone16 = {1'b0,valid_access16,smc_done16};

//----------------------------------------------------------------------
//smc_addr16 generation16
//----------------------------------------------------------------------

  always @(posedge sys_clk16 or negedge n_sys_reset16)
    
    begin
      
      if (~n_sys_reset16)
        
         smc_addr16 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone16)
             3'b1xx :

               smc_addr16 <= smc_addr16;
                        //valid_access16 
             3'b01x : begin
               // Set up address for first access
               // little16-endian from max address downto16 0
               // big-endian from 0 upto16 max_address16
               smc_addr16 [31:2] <= addr [31:2];

               casez( { v_xfer_size16, v_bus_size16, 1'b0 } )

               { `XSIZ_3216, `BSIZ_3216, 1'b? } : smc_addr16[1:0] <= 2'b00;
               { `XSIZ_3216, `BSIZ_1616, 1'b0 } : smc_addr16[1:0] <= 2'b10;
               { `XSIZ_3216, `BSIZ_1616, 1'b1 } : smc_addr16[1:0] <= 2'b00;
               { `XSIZ_3216, `BSIZ_816, 1'b0 } :  smc_addr16[1:0] <= 2'b11;
               { `XSIZ_3216, `BSIZ_816, 1'b1 } :  smc_addr16[1:0] <= 2'b00;
               { `XSIZ_1616, `BSIZ_3216, 1'b? } : smc_addr16[1:0] <= {addr[1],1'b0};
               { `XSIZ_1616, `BSIZ_1616, 1'b? } : smc_addr16[1:0] <= {addr[1],1'b0};
               { `XSIZ_1616, `BSIZ_816, 1'b0 } :  smc_addr16[1:0] <= {addr[1],1'b1};
               { `XSIZ_1616, `BSIZ_816, 1'b1 } :  smc_addr16[1:0] <= {addr[1],1'b0};
               { `XSIZ_816, 2'b??, 1'b? } :     smc_addr16[1:0] <= addr[1:0];
               default:                       smc_addr16[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses16 fro16 subsequent16 accesses
                // little16 endian decrements16 according16 to access no.
                // bigendian16 increments16 as access no decrements16

                  smc_addr16[31:2] <= smc_addr16[31:2];
                  
               casez( { v_xfer_size16, v_bus_size16, 1'b0 } )

               { `XSIZ_3216, `BSIZ_3216, 1'b? } : smc_addr16[1:0] <= 2'b00;
               { `XSIZ_3216, `BSIZ_1616, 1'b0 } : smc_addr16[1:0] <= 2'b00;
               { `XSIZ_3216, `BSIZ_1616, 1'b1 } : smc_addr16[1:0] <= 2'b10;
               { `XSIZ_3216, `BSIZ_816,  1'b0 } : 
                  case( r_num_access16 ) 
                  2'b11:   smc_addr16[1:0] <= 2'b10;
                  2'b10:   smc_addr16[1:0] <= 2'b01;
                  2'b01:   smc_addr16[1:0] <= 2'b00;
                  default: smc_addr16[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3216, `BSIZ_816, 1'b1 } :  
                  case( r_num_access16 ) 
                  2'b11:   smc_addr16[1:0] <= 2'b01;
                  2'b10:   smc_addr16[1:0] <= 2'b10;
                  2'b01:   smc_addr16[1:0] <= 2'b11;
                  default: smc_addr16[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1616, `BSIZ_3216, 1'b? } : smc_addr16[1:0] <= {r_addr16[1],1'b0};
               { `XSIZ_1616, `BSIZ_1616, 1'b? } : smc_addr16[1:0] <= {r_addr16[1],1'b0};
               { `XSIZ_1616, `BSIZ_816, 1'b0 } :  smc_addr16[1:0] <= {r_addr16[1],1'b0};
               { `XSIZ_1616, `BSIZ_816, 1'b1 } :  smc_addr16[1:0] <= {r_addr16[1],1'b1};
               { `XSIZ_816, 2'b??, 1'b? } :     smc_addr16[1:0] <= r_addr16[1:0];
               default:                       smc_addr16[1:0] <= r_addr16[1:0];

               endcase
                 
            end
            
            default :

               smc_addr16 <= smc_addr16;
            
          endcase // casex(wait_access_smdone16)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate16 Chip16 Select16 Output16 
//----------------------------------------------------------------------

   always @(posedge sys_clk16 or negedge n_sys_reset16)
     
     begin
        
        if (~n_sys_reset16)
          
          begin
             
             smc_n_cs16 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate16 == `SMC_RW16)
          
           begin
             
              if (valid_access16)
               
                 smc_n_cs16 <= ~cs ;
             
              else
               
                 smc_n_cs16 <= ~r_cs16 ;

           end
        
        else
          
           smc_n_cs16 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch16 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk16 or negedge n_sys_reset16)
     
     begin
        
        if (~n_sys_reset16)
          
           r_addr16 <= 2'd0;
        
        
        else if (valid_access16)
          
           r_addr16 <= addr[1:0];
        
        else
          
           r_addr16 <= r_addr16;
        
     end
   


//----------------------------------------------------------------------
// Validate16 LSB of addr with valid_access16
//----------------------------------------------------------------------

   always @(r_addr16 or valid_access16 or addr)
     
      begin
        
         if (valid_access16)
           
            v_addr16 = addr[1:0];
         
         else
           
            v_addr16 = r_addr16;
         
      end
//----------------------------------------------------------------------
//cancatenation16 of signals16
//----------------------------------------------------------------------
                               //check for v_cs16 = 0
   assign ored_v_cs16 = |v_cs16;   //signal16 concatenation16 to be used in case
   
//----------------------------------------------------------------------
// Generate16 (internal) Byte16 Enables16.
//----------------------------------------------------------------------

   always @(v_cs16 or v_xfer_size16 or v_bus_size16 or v_addr16 )
     
     begin

       if ( |v_cs16 == 1'b1 ) 
        
         casez( {v_xfer_size16, v_bus_size16, 1'b0, v_addr16[1:0] } )
          
         {`XSIZ_816, `BSIZ_816, 1'b?, 2'b??} : n_be16 = 4'b1110; // Any16 on RAM16 B016
         {`XSIZ_816, `BSIZ_1616,1'b0, 2'b?0} : n_be16 = 4'b1110; // B216 or B016 = RAM16 B016
         {`XSIZ_816, `BSIZ_1616,1'b0, 2'b?1} : n_be16 = 4'b1101; // B316 or B116 = RAM16 B116
         {`XSIZ_816, `BSIZ_1616,1'b1, 2'b?0} : n_be16 = 4'b1101; // B216 or B016 = RAM16 B116
         {`XSIZ_816, `BSIZ_1616,1'b1, 2'b?1} : n_be16 = 4'b1110; // B316 or B116 = RAM16 B016
         {`XSIZ_816, `BSIZ_3216,1'b0, 2'b00} : n_be16 = 4'b1110; // B016 = RAM16 B016
         {`XSIZ_816, `BSIZ_3216,1'b0, 2'b01} : n_be16 = 4'b1101; // B116 = RAM16 B116
         {`XSIZ_816, `BSIZ_3216,1'b0, 2'b10} : n_be16 = 4'b1011; // B216 = RAM16 B216
         {`XSIZ_816, `BSIZ_3216,1'b0, 2'b11} : n_be16 = 4'b0111; // B316 = RAM16 B316
         {`XSIZ_816, `BSIZ_3216,1'b1, 2'b00} : n_be16 = 4'b0111; // B016 = RAM16 B316
         {`XSIZ_816, `BSIZ_3216,1'b1, 2'b01} : n_be16 = 4'b1011; // B116 = RAM16 B216
         {`XSIZ_816, `BSIZ_3216,1'b1, 2'b10} : n_be16 = 4'b1101; // B216 = RAM16 B116
         {`XSIZ_816, `BSIZ_3216,1'b1, 2'b11} : n_be16 = 4'b1110; // B316 = RAM16 B016
         {`XSIZ_1616,`BSIZ_816, 1'b?, 2'b??} : n_be16 = 4'b1110; // Any16 on RAM16 B016
         {`XSIZ_1616,`BSIZ_1616,1'b?, 2'b??} : n_be16 = 4'b1100; // Any16 on RAMB1016
         {`XSIZ_1616,`BSIZ_3216,1'b0, 2'b0?} : n_be16 = 4'b1100; // B1016 = RAM16 B1016
         {`XSIZ_1616,`BSIZ_3216,1'b0, 2'b1?} : n_be16 = 4'b0011; // B2316 = RAM16 B2316
         {`XSIZ_1616,`BSIZ_3216,1'b1, 2'b0?} : n_be16 = 4'b0011; // B1016 = RAM16 B2316
         {`XSIZ_1616,`BSIZ_3216,1'b1, 2'b1?} : n_be16 = 4'b1100; // B2316 = RAM16 B1016
         {`XSIZ_3216,`BSIZ_816, 1'b?, 2'b??} : n_be16 = 4'b1110; // Any16 on RAM16 B016
         {`XSIZ_3216,`BSIZ_1616,1'b?, 2'b??} : n_be16 = 4'b1100; // Any16 on RAM16 B1016
         {`XSIZ_3216,`BSIZ_3216,1'b?, 2'b??} : n_be16 = 4'b0000; // Any16 on RAM16 B321016
         default                         : n_be16 = 4'b1111; // Invalid16 decode
        
         
         endcase // casex(xfer_bus_size16)
        
       else

         n_be16 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate16 (enternal16) Byte16 Enables16.
//----------------------------------------------------------------------

   always @(posedge sys_clk16 or negedge n_sys_reset16)
     
     begin
        
        if (~n_sys_reset16)
          
           smc_n_be16 <= 4'hF;
        
        
        else if (smc_nextstate16 == `SMC_RW16)
          
           smc_n_be16 <= n_be16;
        
        else
          
           smc_n_be16 <= 4'hF;
        
     end
   
   
endmodule

