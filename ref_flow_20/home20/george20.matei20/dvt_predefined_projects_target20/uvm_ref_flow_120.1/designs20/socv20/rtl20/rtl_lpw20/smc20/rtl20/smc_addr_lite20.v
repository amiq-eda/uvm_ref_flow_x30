//File20 name   : smc_addr_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : This20 block registers the address and chip20 select20
//              lines20 for the current access. The address may only
//              driven20 for one cycle by the AHB20. If20 multiple
//              accesses are required20 the bottom20 two20 address bits
//              are modified between cycles20 depending20 on the current
//              transfer20 and bus size.
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

//


`include "smc_defs_lite20.v"

// address decoder20

module smc_addr_lite20    (
                    //inputs20

                    sys_clk20,
                    n_sys_reset20,
                    valid_access20,
                    r_num_access20,
                    v_bus_size20,
                    v_xfer_size20,
                    cs,
                    addr,
                    smc_done20,
                    smc_nextstate20,


                    //outputs20

                    smc_addr20,
                    smc_n_be20,
                    smc_n_cs20,
                    n_be20);



// I20/O20

   input                    sys_clk20;      //AHB20 System20 clock20
   input                    n_sys_reset20;  //AHB20 System20 reset 
   input                    valid_access20; //Start20 of new cycle
   input [1:0]              r_num_access20; //MAC20 counter
   input [1:0]              v_bus_size20;   //bus width for current access
   input [1:0]              v_xfer_size20;  //Transfer20 size for current 
                                              // access
   input               cs;           //Chip20 (Bank20) select20(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done20;     //Transfer20 complete (state 
                                              // machine20)
   input [4:0]              smc_nextstate20;//Next20 state 

   
   output [31:0]            smc_addr20;     //External20 Memory Interface20 
                                              //  address
   output [3:0]             smc_n_be20;     //EMI20 byte enables20 
   output              smc_n_cs20;     //EMI20 Chip20 Selects20 
   output [3:0]             n_be20;         //Unregistered20 Byte20 strobes20
                                             // used to genetate20 
                                             // individual20 write strobes20

// Output20 register declarations20
   
   reg [31:0]                  smc_addr20;
   reg [3:0]                   smc_n_be20;
   reg                    smc_n_cs20;
   reg [3:0]                   n_be20;
   
   
   // Internal register declarations20
   
   reg [1:0]                  r_addr20;           // Stored20 Address bits 
   reg                   r_cs20;             // Stored20 CS20
   reg [1:0]                  v_addr20;           // Validated20 Address
                                                     //  bits
   reg [7:0]                  v_cs20;             // Validated20 CS20
   
   wire                       ored_v_cs20;        //oring20 of v_sc20
   wire [4:0]                 cs_xfer_bus_size20; //concatenated20 bus and 
                                                  // xfer20 size
   wire [2:0]                 wait_access_smdone20;//concatenated20 signal20
   

// Main20 Code20
//----------------------------------------------------------------------
// Address Store20, CS20 Store20 & BE20 Store20
//----------------------------------------------------------------------

   always @(posedge sys_clk20 or negedge n_sys_reset20)
     
     begin
        
        if (~n_sys_reset20)
          
           r_cs20 <= 1'b0;
        
        
        else if (valid_access20)
          
           r_cs20 <= cs ;
        
        else
          
           r_cs20 <= r_cs20 ;
        
     end

//----------------------------------------------------------------------
//v_cs20 generation20   
//----------------------------------------------------------------------
   
   always @(cs or r_cs20 or valid_access20 )
     
     begin
        
        if (valid_access20)
          
           v_cs20 = cs ;
        
        else
          
           v_cs20 = r_cs20;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone20 = {1'b0,valid_access20,smc_done20};

//----------------------------------------------------------------------
//smc_addr20 generation20
//----------------------------------------------------------------------

  always @(posedge sys_clk20 or negedge n_sys_reset20)
    
    begin
      
      if (~n_sys_reset20)
        
         smc_addr20 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone20)
             3'b1xx :

               smc_addr20 <= smc_addr20;
                        //valid_access20 
             3'b01x : begin
               // Set up address for first access
               // little20-endian from max address downto20 0
               // big-endian from 0 upto20 max_address20
               smc_addr20 [31:2] <= addr [31:2];

               casez( { v_xfer_size20, v_bus_size20, 1'b0 } )

               { `XSIZ_3220, `BSIZ_3220, 1'b? } : smc_addr20[1:0] <= 2'b00;
               { `XSIZ_3220, `BSIZ_1620, 1'b0 } : smc_addr20[1:0] <= 2'b10;
               { `XSIZ_3220, `BSIZ_1620, 1'b1 } : smc_addr20[1:0] <= 2'b00;
               { `XSIZ_3220, `BSIZ_820, 1'b0 } :  smc_addr20[1:0] <= 2'b11;
               { `XSIZ_3220, `BSIZ_820, 1'b1 } :  smc_addr20[1:0] <= 2'b00;
               { `XSIZ_1620, `BSIZ_3220, 1'b? } : smc_addr20[1:0] <= {addr[1],1'b0};
               { `XSIZ_1620, `BSIZ_1620, 1'b? } : smc_addr20[1:0] <= {addr[1],1'b0};
               { `XSIZ_1620, `BSIZ_820, 1'b0 } :  smc_addr20[1:0] <= {addr[1],1'b1};
               { `XSIZ_1620, `BSIZ_820, 1'b1 } :  smc_addr20[1:0] <= {addr[1],1'b0};
               { `XSIZ_820, 2'b??, 1'b? } :     smc_addr20[1:0] <= addr[1:0];
               default:                       smc_addr20[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses20 fro20 subsequent20 accesses
                // little20 endian decrements20 according20 to access no.
                // bigendian20 increments20 as access no decrements20

                  smc_addr20[31:2] <= smc_addr20[31:2];
                  
               casez( { v_xfer_size20, v_bus_size20, 1'b0 } )

               { `XSIZ_3220, `BSIZ_3220, 1'b? } : smc_addr20[1:0] <= 2'b00;
               { `XSIZ_3220, `BSIZ_1620, 1'b0 } : smc_addr20[1:0] <= 2'b00;
               { `XSIZ_3220, `BSIZ_1620, 1'b1 } : smc_addr20[1:0] <= 2'b10;
               { `XSIZ_3220, `BSIZ_820,  1'b0 } : 
                  case( r_num_access20 ) 
                  2'b11:   smc_addr20[1:0] <= 2'b10;
                  2'b10:   smc_addr20[1:0] <= 2'b01;
                  2'b01:   smc_addr20[1:0] <= 2'b00;
                  default: smc_addr20[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3220, `BSIZ_820, 1'b1 } :  
                  case( r_num_access20 ) 
                  2'b11:   smc_addr20[1:0] <= 2'b01;
                  2'b10:   smc_addr20[1:0] <= 2'b10;
                  2'b01:   smc_addr20[1:0] <= 2'b11;
                  default: smc_addr20[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1620, `BSIZ_3220, 1'b? } : smc_addr20[1:0] <= {r_addr20[1],1'b0};
               { `XSIZ_1620, `BSIZ_1620, 1'b? } : smc_addr20[1:0] <= {r_addr20[1],1'b0};
               { `XSIZ_1620, `BSIZ_820, 1'b0 } :  smc_addr20[1:0] <= {r_addr20[1],1'b0};
               { `XSIZ_1620, `BSIZ_820, 1'b1 } :  smc_addr20[1:0] <= {r_addr20[1],1'b1};
               { `XSIZ_820, 2'b??, 1'b? } :     smc_addr20[1:0] <= r_addr20[1:0];
               default:                       smc_addr20[1:0] <= r_addr20[1:0];

               endcase
                 
            end
            
            default :

               smc_addr20 <= smc_addr20;
            
          endcase // casex(wait_access_smdone20)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate20 Chip20 Select20 Output20 
//----------------------------------------------------------------------

   always @(posedge sys_clk20 or negedge n_sys_reset20)
     
     begin
        
        if (~n_sys_reset20)
          
          begin
             
             smc_n_cs20 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate20 == `SMC_RW20)
          
           begin
             
              if (valid_access20)
               
                 smc_n_cs20 <= ~cs ;
             
              else
               
                 smc_n_cs20 <= ~r_cs20 ;

           end
        
        else
          
           smc_n_cs20 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch20 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk20 or negedge n_sys_reset20)
     
     begin
        
        if (~n_sys_reset20)
          
           r_addr20 <= 2'd0;
        
        
        else if (valid_access20)
          
           r_addr20 <= addr[1:0];
        
        else
          
           r_addr20 <= r_addr20;
        
     end
   


//----------------------------------------------------------------------
// Validate20 LSB of addr with valid_access20
//----------------------------------------------------------------------

   always @(r_addr20 or valid_access20 or addr)
     
      begin
        
         if (valid_access20)
           
            v_addr20 = addr[1:0];
         
         else
           
            v_addr20 = r_addr20;
         
      end
//----------------------------------------------------------------------
//cancatenation20 of signals20
//----------------------------------------------------------------------
                               //check for v_cs20 = 0
   assign ored_v_cs20 = |v_cs20;   //signal20 concatenation20 to be used in case
   
//----------------------------------------------------------------------
// Generate20 (internal) Byte20 Enables20.
//----------------------------------------------------------------------

   always @(v_cs20 or v_xfer_size20 or v_bus_size20 or v_addr20 )
     
     begin

       if ( |v_cs20 == 1'b1 ) 
        
         casez( {v_xfer_size20, v_bus_size20, 1'b0, v_addr20[1:0] } )
          
         {`XSIZ_820, `BSIZ_820, 1'b?, 2'b??} : n_be20 = 4'b1110; // Any20 on RAM20 B020
         {`XSIZ_820, `BSIZ_1620,1'b0, 2'b?0} : n_be20 = 4'b1110; // B220 or B020 = RAM20 B020
         {`XSIZ_820, `BSIZ_1620,1'b0, 2'b?1} : n_be20 = 4'b1101; // B320 or B120 = RAM20 B120
         {`XSIZ_820, `BSIZ_1620,1'b1, 2'b?0} : n_be20 = 4'b1101; // B220 or B020 = RAM20 B120
         {`XSIZ_820, `BSIZ_1620,1'b1, 2'b?1} : n_be20 = 4'b1110; // B320 or B120 = RAM20 B020
         {`XSIZ_820, `BSIZ_3220,1'b0, 2'b00} : n_be20 = 4'b1110; // B020 = RAM20 B020
         {`XSIZ_820, `BSIZ_3220,1'b0, 2'b01} : n_be20 = 4'b1101; // B120 = RAM20 B120
         {`XSIZ_820, `BSIZ_3220,1'b0, 2'b10} : n_be20 = 4'b1011; // B220 = RAM20 B220
         {`XSIZ_820, `BSIZ_3220,1'b0, 2'b11} : n_be20 = 4'b0111; // B320 = RAM20 B320
         {`XSIZ_820, `BSIZ_3220,1'b1, 2'b00} : n_be20 = 4'b0111; // B020 = RAM20 B320
         {`XSIZ_820, `BSIZ_3220,1'b1, 2'b01} : n_be20 = 4'b1011; // B120 = RAM20 B220
         {`XSIZ_820, `BSIZ_3220,1'b1, 2'b10} : n_be20 = 4'b1101; // B220 = RAM20 B120
         {`XSIZ_820, `BSIZ_3220,1'b1, 2'b11} : n_be20 = 4'b1110; // B320 = RAM20 B020
         {`XSIZ_1620,`BSIZ_820, 1'b?, 2'b??} : n_be20 = 4'b1110; // Any20 on RAM20 B020
         {`XSIZ_1620,`BSIZ_1620,1'b?, 2'b??} : n_be20 = 4'b1100; // Any20 on RAMB1020
         {`XSIZ_1620,`BSIZ_3220,1'b0, 2'b0?} : n_be20 = 4'b1100; // B1020 = RAM20 B1020
         {`XSIZ_1620,`BSIZ_3220,1'b0, 2'b1?} : n_be20 = 4'b0011; // B2320 = RAM20 B2320
         {`XSIZ_1620,`BSIZ_3220,1'b1, 2'b0?} : n_be20 = 4'b0011; // B1020 = RAM20 B2320
         {`XSIZ_1620,`BSIZ_3220,1'b1, 2'b1?} : n_be20 = 4'b1100; // B2320 = RAM20 B1020
         {`XSIZ_3220,`BSIZ_820, 1'b?, 2'b??} : n_be20 = 4'b1110; // Any20 on RAM20 B020
         {`XSIZ_3220,`BSIZ_1620,1'b?, 2'b??} : n_be20 = 4'b1100; // Any20 on RAM20 B1020
         {`XSIZ_3220,`BSIZ_3220,1'b?, 2'b??} : n_be20 = 4'b0000; // Any20 on RAM20 B321020
         default                         : n_be20 = 4'b1111; // Invalid20 decode
        
         
         endcase // casex(xfer_bus_size20)
        
       else

         n_be20 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate20 (enternal20) Byte20 Enables20.
//----------------------------------------------------------------------

   always @(posedge sys_clk20 or negedge n_sys_reset20)
     
     begin
        
        if (~n_sys_reset20)
          
           smc_n_be20 <= 4'hF;
        
        
        else if (smc_nextstate20 == `SMC_RW20)
          
           smc_n_be20 <= n_be20;
        
        else
          
           smc_n_be20 <= 4'hF;
        
     end
   
   
endmodule

