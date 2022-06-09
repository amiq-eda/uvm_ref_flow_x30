//File28 name   : smc_addr_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : This28 block registers the address and chip28 select28
//              lines28 for the current access. The address may only
//              driven28 for one cycle by the AHB28. If28 multiple
//              accesses are required28 the bottom28 two28 address bits
//              are modified between cycles28 depending28 on the current
//              transfer28 and bus size.
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

//


`include "smc_defs_lite28.v"

// address decoder28

module smc_addr_lite28    (
                    //inputs28

                    sys_clk28,
                    n_sys_reset28,
                    valid_access28,
                    r_num_access28,
                    v_bus_size28,
                    v_xfer_size28,
                    cs,
                    addr,
                    smc_done28,
                    smc_nextstate28,


                    //outputs28

                    smc_addr28,
                    smc_n_be28,
                    smc_n_cs28,
                    n_be28);



// I28/O28

   input                    sys_clk28;      //AHB28 System28 clock28
   input                    n_sys_reset28;  //AHB28 System28 reset 
   input                    valid_access28; //Start28 of new cycle
   input [1:0]              r_num_access28; //MAC28 counter
   input [1:0]              v_bus_size28;   //bus width for current access
   input [1:0]              v_xfer_size28;  //Transfer28 size for current 
                                              // access
   input               cs;           //Chip28 (Bank28) select28(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done28;     //Transfer28 complete (state 
                                              // machine28)
   input [4:0]              smc_nextstate28;//Next28 state 

   
   output [31:0]            smc_addr28;     //External28 Memory Interface28 
                                              //  address
   output [3:0]             smc_n_be28;     //EMI28 byte enables28 
   output              smc_n_cs28;     //EMI28 Chip28 Selects28 
   output [3:0]             n_be28;         //Unregistered28 Byte28 strobes28
                                             // used to genetate28 
                                             // individual28 write strobes28

// Output28 register declarations28
   
   reg [31:0]                  smc_addr28;
   reg [3:0]                   smc_n_be28;
   reg                    smc_n_cs28;
   reg [3:0]                   n_be28;
   
   
   // Internal register declarations28
   
   reg [1:0]                  r_addr28;           // Stored28 Address bits 
   reg                   r_cs28;             // Stored28 CS28
   reg [1:0]                  v_addr28;           // Validated28 Address
                                                     //  bits
   reg [7:0]                  v_cs28;             // Validated28 CS28
   
   wire                       ored_v_cs28;        //oring28 of v_sc28
   wire [4:0]                 cs_xfer_bus_size28; //concatenated28 bus and 
                                                  // xfer28 size
   wire [2:0]                 wait_access_smdone28;//concatenated28 signal28
   

// Main28 Code28
//----------------------------------------------------------------------
// Address Store28, CS28 Store28 & BE28 Store28
//----------------------------------------------------------------------

   always @(posedge sys_clk28 or negedge n_sys_reset28)
     
     begin
        
        if (~n_sys_reset28)
          
           r_cs28 <= 1'b0;
        
        
        else if (valid_access28)
          
           r_cs28 <= cs ;
        
        else
          
           r_cs28 <= r_cs28 ;
        
     end

//----------------------------------------------------------------------
//v_cs28 generation28   
//----------------------------------------------------------------------
   
   always @(cs or r_cs28 or valid_access28 )
     
     begin
        
        if (valid_access28)
          
           v_cs28 = cs ;
        
        else
          
           v_cs28 = r_cs28;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone28 = {1'b0,valid_access28,smc_done28};

//----------------------------------------------------------------------
//smc_addr28 generation28
//----------------------------------------------------------------------

  always @(posedge sys_clk28 or negedge n_sys_reset28)
    
    begin
      
      if (~n_sys_reset28)
        
         smc_addr28 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone28)
             3'b1xx :

               smc_addr28 <= smc_addr28;
                        //valid_access28 
             3'b01x : begin
               // Set up address for first access
               // little28-endian from max address downto28 0
               // big-endian from 0 upto28 max_address28
               smc_addr28 [31:2] <= addr [31:2];

               casez( { v_xfer_size28, v_bus_size28, 1'b0 } )

               { `XSIZ_3228, `BSIZ_3228, 1'b? } : smc_addr28[1:0] <= 2'b00;
               { `XSIZ_3228, `BSIZ_1628, 1'b0 } : smc_addr28[1:0] <= 2'b10;
               { `XSIZ_3228, `BSIZ_1628, 1'b1 } : smc_addr28[1:0] <= 2'b00;
               { `XSIZ_3228, `BSIZ_828, 1'b0 } :  smc_addr28[1:0] <= 2'b11;
               { `XSIZ_3228, `BSIZ_828, 1'b1 } :  smc_addr28[1:0] <= 2'b00;
               { `XSIZ_1628, `BSIZ_3228, 1'b? } : smc_addr28[1:0] <= {addr[1],1'b0};
               { `XSIZ_1628, `BSIZ_1628, 1'b? } : smc_addr28[1:0] <= {addr[1],1'b0};
               { `XSIZ_1628, `BSIZ_828, 1'b0 } :  smc_addr28[1:0] <= {addr[1],1'b1};
               { `XSIZ_1628, `BSIZ_828, 1'b1 } :  smc_addr28[1:0] <= {addr[1],1'b0};
               { `XSIZ_828, 2'b??, 1'b? } :     smc_addr28[1:0] <= addr[1:0];
               default:                       smc_addr28[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses28 fro28 subsequent28 accesses
                // little28 endian decrements28 according28 to access no.
                // bigendian28 increments28 as access no decrements28

                  smc_addr28[31:2] <= smc_addr28[31:2];
                  
               casez( { v_xfer_size28, v_bus_size28, 1'b0 } )

               { `XSIZ_3228, `BSIZ_3228, 1'b? } : smc_addr28[1:0] <= 2'b00;
               { `XSIZ_3228, `BSIZ_1628, 1'b0 } : smc_addr28[1:0] <= 2'b00;
               { `XSIZ_3228, `BSIZ_1628, 1'b1 } : smc_addr28[1:0] <= 2'b10;
               { `XSIZ_3228, `BSIZ_828,  1'b0 } : 
                  case( r_num_access28 ) 
                  2'b11:   smc_addr28[1:0] <= 2'b10;
                  2'b10:   smc_addr28[1:0] <= 2'b01;
                  2'b01:   smc_addr28[1:0] <= 2'b00;
                  default: smc_addr28[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3228, `BSIZ_828, 1'b1 } :  
                  case( r_num_access28 ) 
                  2'b11:   smc_addr28[1:0] <= 2'b01;
                  2'b10:   smc_addr28[1:0] <= 2'b10;
                  2'b01:   smc_addr28[1:0] <= 2'b11;
                  default: smc_addr28[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1628, `BSIZ_3228, 1'b? } : smc_addr28[1:0] <= {r_addr28[1],1'b0};
               { `XSIZ_1628, `BSIZ_1628, 1'b? } : smc_addr28[1:0] <= {r_addr28[1],1'b0};
               { `XSIZ_1628, `BSIZ_828, 1'b0 } :  smc_addr28[1:0] <= {r_addr28[1],1'b0};
               { `XSIZ_1628, `BSIZ_828, 1'b1 } :  smc_addr28[1:0] <= {r_addr28[1],1'b1};
               { `XSIZ_828, 2'b??, 1'b? } :     smc_addr28[1:0] <= r_addr28[1:0];
               default:                       smc_addr28[1:0] <= r_addr28[1:0];

               endcase
                 
            end
            
            default :

               smc_addr28 <= smc_addr28;
            
          endcase // casex(wait_access_smdone28)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate28 Chip28 Select28 Output28 
//----------------------------------------------------------------------

   always @(posedge sys_clk28 or negedge n_sys_reset28)
     
     begin
        
        if (~n_sys_reset28)
          
          begin
             
             smc_n_cs28 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate28 == `SMC_RW28)
          
           begin
             
              if (valid_access28)
               
                 smc_n_cs28 <= ~cs ;
             
              else
               
                 smc_n_cs28 <= ~r_cs28 ;

           end
        
        else
          
           smc_n_cs28 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch28 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk28 or negedge n_sys_reset28)
     
     begin
        
        if (~n_sys_reset28)
          
           r_addr28 <= 2'd0;
        
        
        else if (valid_access28)
          
           r_addr28 <= addr[1:0];
        
        else
          
           r_addr28 <= r_addr28;
        
     end
   


//----------------------------------------------------------------------
// Validate28 LSB of addr with valid_access28
//----------------------------------------------------------------------

   always @(r_addr28 or valid_access28 or addr)
     
      begin
        
         if (valid_access28)
           
            v_addr28 = addr[1:0];
         
         else
           
            v_addr28 = r_addr28;
         
      end
//----------------------------------------------------------------------
//cancatenation28 of signals28
//----------------------------------------------------------------------
                               //check for v_cs28 = 0
   assign ored_v_cs28 = |v_cs28;   //signal28 concatenation28 to be used in case
   
//----------------------------------------------------------------------
// Generate28 (internal) Byte28 Enables28.
//----------------------------------------------------------------------

   always @(v_cs28 or v_xfer_size28 or v_bus_size28 or v_addr28 )
     
     begin

       if ( |v_cs28 == 1'b1 ) 
        
         casez( {v_xfer_size28, v_bus_size28, 1'b0, v_addr28[1:0] } )
          
         {`XSIZ_828, `BSIZ_828, 1'b?, 2'b??} : n_be28 = 4'b1110; // Any28 on RAM28 B028
         {`XSIZ_828, `BSIZ_1628,1'b0, 2'b?0} : n_be28 = 4'b1110; // B228 or B028 = RAM28 B028
         {`XSIZ_828, `BSIZ_1628,1'b0, 2'b?1} : n_be28 = 4'b1101; // B328 or B128 = RAM28 B128
         {`XSIZ_828, `BSIZ_1628,1'b1, 2'b?0} : n_be28 = 4'b1101; // B228 or B028 = RAM28 B128
         {`XSIZ_828, `BSIZ_1628,1'b1, 2'b?1} : n_be28 = 4'b1110; // B328 or B128 = RAM28 B028
         {`XSIZ_828, `BSIZ_3228,1'b0, 2'b00} : n_be28 = 4'b1110; // B028 = RAM28 B028
         {`XSIZ_828, `BSIZ_3228,1'b0, 2'b01} : n_be28 = 4'b1101; // B128 = RAM28 B128
         {`XSIZ_828, `BSIZ_3228,1'b0, 2'b10} : n_be28 = 4'b1011; // B228 = RAM28 B228
         {`XSIZ_828, `BSIZ_3228,1'b0, 2'b11} : n_be28 = 4'b0111; // B328 = RAM28 B328
         {`XSIZ_828, `BSIZ_3228,1'b1, 2'b00} : n_be28 = 4'b0111; // B028 = RAM28 B328
         {`XSIZ_828, `BSIZ_3228,1'b1, 2'b01} : n_be28 = 4'b1011; // B128 = RAM28 B228
         {`XSIZ_828, `BSIZ_3228,1'b1, 2'b10} : n_be28 = 4'b1101; // B228 = RAM28 B128
         {`XSIZ_828, `BSIZ_3228,1'b1, 2'b11} : n_be28 = 4'b1110; // B328 = RAM28 B028
         {`XSIZ_1628,`BSIZ_828, 1'b?, 2'b??} : n_be28 = 4'b1110; // Any28 on RAM28 B028
         {`XSIZ_1628,`BSIZ_1628,1'b?, 2'b??} : n_be28 = 4'b1100; // Any28 on RAMB1028
         {`XSIZ_1628,`BSIZ_3228,1'b0, 2'b0?} : n_be28 = 4'b1100; // B1028 = RAM28 B1028
         {`XSIZ_1628,`BSIZ_3228,1'b0, 2'b1?} : n_be28 = 4'b0011; // B2328 = RAM28 B2328
         {`XSIZ_1628,`BSIZ_3228,1'b1, 2'b0?} : n_be28 = 4'b0011; // B1028 = RAM28 B2328
         {`XSIZ_1628,`BSIZ_3228,1'b1, 2'b1?} : n_be28 = 4'b1100; // B2328 = RAM28 B1028
         {`XSIZ_3228,`BSIZ_828, 1'b?, 2'b??} : n_be28 = 4'b1110; // Any28 on RAM28 B028
         {`XSIZ_3228,`BSIZ_1628,1'b?, 2'b??} : n_be28 = 4'b1100; // Any28 on RAM28 B1028
         {`XSIZ_3228,`BSIZ_3228,1'b?, 2'b??} : n_be28 = 4'b0000; // Any28 on RAM28 B321028
         default                         : n_be28 = 4'b1111; // Invalid28 decode
        
         
         endcase // casex(xfer_bus_size28)
        
       else

         n_be28 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate28 (enternal28) Byte28 Enables28.
//----------------------------------------------------------------------

   always @(posedge sys_clk28 or negedge n_sys_reset28)
     
     begin
        
        if (~n_sys_reset28)
          
           smc_n_be28 <= 4'hF;
        
        
        else if (smc_nextstate28 == `SMC_RW28)
          
           smc_n_be28 <= n_be28;
        
        else
          
           smc_n_be28 <= 4'hF;
        
     end
   
   
endmodule

