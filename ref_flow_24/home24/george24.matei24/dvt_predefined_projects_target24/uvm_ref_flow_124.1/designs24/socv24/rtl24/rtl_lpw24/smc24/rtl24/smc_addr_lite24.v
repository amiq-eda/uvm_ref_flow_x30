//File24 name   : smc_addr_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : This24 block registers the address and chip24 select24
//              lines24 for the current access. The address may only
//              driven24 for one cycle by the AHB24. If24 multiple
//              accesses are required24 the bottom24 two24 address bits
//              are modified between cycles24 depending24 on the current
//              transfer24 and bus size.
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

//


`include "smc_defs_lite24.v"

// address decoder24

module smc_addr_lite24    (
                    //inputs24

                    sys_clk24,
                    n_sys_reset24,
                    valid_access24,
                    r_num_access24,
                    v_bus_size24,
                    v_xfer_size24,
                    cs,
                    addr,
                    smc_done24,
                    smc_nextstate24,


                    //outputs24

                    smc_addr24,
                    smc_n_be24,
                    smc_n_cs24,
                    n_be24);



// I24/O24

   input                    sys_clk24;      //AHB24 System24 clock24
   input                    n_sys_reset24;  //AHB24 System24 reset 
   input                    valid_access24; //Start24 of new cycle
   input [1:0]              r_num_access24; //MAC24 counter
   input [1:0]              v_bus_size24;   //bus width for current access
   input [1:0]              v_xfer_size24;  //Transfer24 size for current 
                                              // access
   input               cs;           //Chip24 (Bank24) select24(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done24;     //Transfer24 complete (state 
                                              // machine24)
   input [4:0]              smc_nextstate24;//Next24 state 

   
   output [31:0]            smc_addr24;     //External24 Memory Interface24 
                                              //  address
   output [3:0]             smc_n_be24;     //EMI24 byte enables24 
   output              smc_n_cs24;     //EMI24 Chip24 Selects24 
   output [3:0]             n_be24;         //Unregistered24 Byte24 strobes24
                                             // used to genetate24 
                                             // individual24 write strobes24

// Output24 register declarations24
   
   reg [31:0]                  smc_addr24;
   reg [3:0]                   smc_n_be24;
   reg                    smc_n_cs24;
   reg [3:0]                   n_be24;
   
   
   // Internal register declarations24
   
   reg [1:0]                  r_addr24;           // Stored24 Address bits 
   reg                   r_cs24;             // Stored24 CS24
   reg [1:0]                  v_addr24;           // Validated24 Address
                                                     //  bits
   reg [7:0]                  v_cs24;             // Validated24 CS24
   
   wire                       ored_v_cs24;        //oring24 of v_sc24
   wire [4:0]                 cs_xfer_bus_size24; //concatenated24 bus and 
                                                  // xfer24 size
   wire [2:0]                 wait_access_smdone24;//concatenated24 signal24
   

// Main24 Code24
//----------------------------------------------------------------------
// Address Store24, CS24 Store24 & BE24 Store24
//----------------------------------------------------------------------

   always @(posedge sys_clk24 or negedge n_sys_reset24)
     
     begin
        
        if (~n_sys_reset24)
          
           r_cs24 <= 1'b0;
        
        
        else if (valid_access24)
          
           r_cs24 <= cs ;
        
        else
          
           r_cs24 <= r_cs24 ;
        
     end

//----------------------------------------------------------------------
//v_cs24 generation24   
//----------------------------------------------------------------------
   
   always @(cs or r_cs24 or valid_access24 )
     
     begin
        
        if (valid_access24)
          
           v_cs24 = cs ;
        
        else
          
           v_cs24 = r_cs24;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone24 = {1'b0,valid_access24,smc_done24};

//----------------------------------------------------------------------
//smc_addr24 generation24
//----------------------------------------------------------------------

  always @(posedge sys_clk24 or negedge n_sys_reset24)
    
    begin
      
      if (~n_sys_reset24)
        
         smc_addr24 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone24)
             3'b1xx :

               smc_addr24 <= smc_addr24;
                        //valid_access24 
             3'b01x : begin
               // Set up address for first access
               // little24-endian from max address downto24 0
               // big-endian from 0 upto24 max_address24
               smc_addr24 [31:2] <= addr [31:2];

               casez( { v_xfer_size24, v_bus_size24, 1'b0 } )

               { `XSIZ_3224, `BSIZ_3224, 1'b? } : smc_addr24[1:0] <= 2'b00;
               { `XSIZ_3224, `BSIZ_1624, 1'b0 } : smc_addr24[1:0] <= 2'b10;
               { `XSIZ_3224, `BSIZ_1624, 1'b1 } : smc_addr24[1:0] <= 2'b00;
               { `XSIZ_3224, `BSIZ_824, 1'b0 } :  smc_addr24[1:0] <= 2'b11;
               { `XSIZ_3224, `BSIZ_824, 1'b1 } :  smc_addr24[1:0] <= 2'b00;
               { `XSIZ_1624, `BSIZ_3224, 1'b? } : smc_addr24[1:0] <= {addr[1],1'b0};
               { `XSIZ_1624, `BSIZ_1624, 1'b? } : smc_addr24[1:0] <= {addr[1],1'b0};
               { `XSIZ_1624, `BSIZ_824, 1'b0 } :  smc_addr24[1:0] <= {addr[1],1'b1};
               { `XSIZ_1624, `BSIZ_824, 1'b1 } :  smc_addr24[1:0] <= {addr[1],1'b0};
               { `XSIZ_824, 2'b??, 1'b? } :     smc_addr24[1:0] <= addr[1:0];
               default:                       smc_addr24[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses24 fro24 subsequent24 accesses
                // little24 endian decrements24 according24 to access no.
                // bigendian24 increments24 as access no decrements24

                  smc_addr24[31:2] <= smc_addr24[31:2];
                  
               casez( { v_xfer_size24, v_bus_size24, 1'b0 } )

               { `XSIZ_3224, `BSIZ_3224, 1'b? } : smc_addr24[1:0] <= 2'b00;
               { `XSIZ_3224, `BSIZ_1624, 1'b0 } : smc_addr24[1:0] <= 2'b00;
               { `XSIZ_3224, `BSIZ_1624, 1'b1 } : smc_addr24[1:0] <= 2'b10;
               { `XSIZ_3224, `BSIZ_824,  1'b0 } : 
                  case( r_num_access24 ) 
                  2'b11:   smc_addr24[1:0] <= 2'b10;
                  2'b10:   smc_addr24[1:0] <= 2'b01;
                  2'b01:   smc_addr24[1:0] <= 2'b00;
                  default: smc_addr24[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3224, `BSIZ_824, 1'b1 } :  
                  case( r_num_access24 ) 
                  2'b11:   smc_addr24[1:0] <= 2'b01;
                  2'b10:   smc_addr24[1:0] <= 2'b10;
                  2'b01:   smc_addr24[1:0] <= 2'b11;
                  default: smc_addr24[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1624, `BSIZ_3224, 1'b? } : smc_addr24[1:0] <= {r_addr24[1],1'b0};
               { `XSIZ_1624, `BSIZ_1624, 1'b? } : smc_addr24[1:0] <= {r_addr24[1],1'b0};
               { `XSIZ_1624, `BSIZ_824, 1'b0 } :  smc_addr24[1:0] <= {r_addr24[1],1'b0};
               { `XSIZ_1624, `BSIZ_824, 1'b1 } :  smc_addr24[1:0] <= {r_addr24[1],1'b1};
               { `XSIZ_824, 2'b??, 1'b? } :     smc_addr24[1:0] <= r_addr24[1:0];
               default:                       smc_addr24[1:0] <= r_addr24[1:0];

               endcase
                 
            end
            
            default :

               smc_addr24 <= smc_addr24;
            
          endcase // casex(wait_access_smdone24)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate24 Chip24 Select24 Output24 
//----------------------------------------------------------------------

   always @(posedge sys_clk24 or negedge n_sys_reset24)
     
     begin
        
        if (~n_sys_reset24)
          
          begin
             
             smc_n_cs24 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate24 == `SMC_RW24)
          
           begin
             
              if (valid_access24)
               
                 smc_n_cs24 <= ~cs ;
             
              else
               
                 smc_n_cs24 <= ~r_cs24 ;

           end
        
        else
          
           smc_n_cs24 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch24 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk24 or negedge n_sys_reset24)
     
     begin
        
        if (~n_sys_reset24)
          
           r_addr24 <= 2'd0;
        
        
        else if (valid_access24)
          
           r_addr24 <= addr[1:0];
        
        else
          
           r_addr24 <= r_addr24;
        
     end
   


//----------------------------------------------------------------------
// Validate24 LSB of addr with valid_access24
//----------------------------------------------------------------------

   always @(r_addr24 or valid_access24 or addr)
     
      begin
        
         if (valid_access24)
           
            v_addr24 = addr[1:0];
         
         else
           
            v_addr24 = r_addr24;
         
      end
//----------------------------------------------------------------------
//cancatenation24 of signals24
//----------------------------------------------------------------------
                               //check for v_cs24 = 0
   assign ored_v_cs24 = |v_cs24;   //signal24 concatenation24 to be used in case
   
//----------------------------------------------------------------------
// Generate24 (internal) Byte24 Enables24.
//----------------------------------------------------------------------

   always @(v_cs24 or v_xfer_size24 or v_bus_size24 or v_addr24 )
     
     begin

       if ( |v_cs24 == 1'b1 ) 
        
         casez( {v_xfer_size24, v_bus_size24, 1'b0, v_addr24[1:0] } )
          
         {`XSIZ_824, `BSIZ_824, 1'b?, 2'b??} : n_be24 = 4'b1110; // Any24 on RAM24 B024
         {`XSIZ_824, `BSIZ_1624,1'b0, 2'b?0} : n_be24 = 4'b1110; // B224 or B024 = RAM24 B024
         {`XSIZ_824, `BSIZ_1624,1'b0, 2'b?1} : n_be24 = 4'b1101; // B324 or B124 = RAM24 B124
         {`XSIZ_824, `BSIZ_1624,1'b1, 2'b?0} : n_be24 = 4'b1101; // B224 or B024 = RAM24 B124
         {`XSIZ_824, `BSIZ_1624,1'b1, 2'b?1} : n_be24 = 4'b1110; // B324 or B124 = RAM24 B024
         {`XSIZ_824, `BSIZ_3224,1'b0, 2'b00} : n_be24 = 4'b1110; // B024 = RAM24 B024
         {`XSIZ_824, `BSIZ_3224,1'b0, 2'b01} : n_be24 = 4'b1101; // B124 = RAM24 B124
         {`XSIZ_824, `BSIZ_3224,1'b0, 2'b10} : n_be24 = 4'b1011; // B224 = RAM24 B224
         {`XSIZ_824, `BSIZ_3224,1'b0, 2'b11} : n_be24 = 4'b0111; // B324 = RAM24 B324
         {`XSIZ_824, `BSIZ_3224,1'b1, 2'b00} : n_be24 = 4'b0111; // B024 = RAM24 B324
         {`XSIZ_824, `BSIZ_3224,1'b1, 2'b01} : n_be24 = 4'b1011; // B124 = RAM24 B224
         {`XSIZ_824, `BSIZ_3224,1'b1, 2'b10} : n_be24 = 4'b1101; // B224 = RAM24 B124
         {`XSIZ_824, `BSIZ_3224,1'b1, 2'b11} : n_be24 = 4'b1110; // B324 = RAM24 B024
         {`XSIZ_1624,`BSIZ_824, 1'b?, 2'b??} : n_be24 = 4'b1110; // Any24 on RAM24 B024
         {`XSIZ_1624,`BSIZ_1624,1'b?, 2'b??} : n_be24 = 4'b1100; // Any24 on RAMB1024
         {`XSIZ_1624,`BSIZ_3224,1'b0, 2'b0?} : n_be24 = 4'b1100; // B1024 = RAM24 B1024
         {`XSIZ_1624,`BSIZ_3224,1'b0, 2'b1?} : n_be24 = 4'b0011; // B2324 = RAM24 B2324
         {`XSIZ_1624,`BSIZ_3224,1'b1, 2'b0?} : n_be24 = 4'b0011; // B1024 = RAM24 B2324
         {`XSIZ_1624,`BSIZ_3224,1'b1, 2'b1?} : n_be24 = 4'b1100; // B2324 = RAM24 B1024
         {`XSIZ_3224,`BSIZ_824, 1'b?, 2'b??} : n_be24 = 4'b1110; // Any24 on RAM24 B024
         {`XSIZ_3224,`BSIZ_1624,1'b?, 2'b??} : n_be24 = 4'b1100; // Any24 on RAM24 B1024
         {`XSIZ_3224,`BSIZ_3224,1'b?, 2'b??} : n_be24 = 4'b0000; // Any24 on RAM24 B321024
         default                         : n_be24 = 4'b1111; // Invalid24 decode
        
         
         endcase // casex(xfer_bus_size24)
        
       else

         n_be24 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate24 (enternal24) Byte24 Enables24.
//----------------------------------------------------------------------

   always @(posedge sys_clk24 or negedge n_sys_reset24)
     
     begin
        
        if (~n_sys_reset24)
          
           smc_n_be24 <= 4'hF;
        
        
        else if (smc_nextstate24 == `SMC_RW24)
          
           smc_n_be24 <= n_be24;
        
        else
          
           smc_n_be24 <= 4'hF;
        
     end
   
   
endmodule

