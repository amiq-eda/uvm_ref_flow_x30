//File3 name   : smc_addr_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : This3 block registers the address and chip3 select3
//              lines3 for the current access. The address may only
//              driven3 for one cycle by the AHB3. If3 multiple
//              accesses are required3 the bottom3 two3 address bits
//              are modified between cycles3 depending3 on the current
//              transfer3 and bus size.
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

//


`include "smc_defs_lite3.v"

// address decoder3

module smc_addr_lite3    (
                    //inputs3

                    sys_clk3,
                    n_sys_reset3,
                    valid_access3,
                    r_num_access3,
                    v_bus_size3,
                    v_xfer_size3,
                    cs,
                    addr,
                    smc_done3,
                    smc_nextstate3,


                    //outputs3

                    smc_addr3,
                    smc_n_be3,
                    smc_n_cs3,
                    n_be3);



// I3/O3

   input                    sys_clk3;      //AHB3 System3 clock3
   input                    n_sys_reset3;  //AHB3 System3 reset 
   input                    valid_access3; //Start3 of new cycle
   input [1:0]              r_num_access3; //MAC3 counter
   input [1:0]              v_bus_size3;   //bus width for current access
   input [1:0]              v_xfer_size3;  //Transfer3 size for current 
                                              // access
   input               cs;           //Chip3 (Bank3) select3(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done3;     //Transfer3 complete (state 
                                              // machine3)
   input [4:0]              smc_nextstate3;//Next3 state 

   
   output [31:0]            smc_addr3;     //External3 Memory Interface3 
                                              //  address
   output [3:0]             smc_n_be3;     //EMI3 byte enables3 
   output              smc_n_cs3;     //EMI3 Chip3 Selects3 
   output [3:0]             n_be3;         //Unregistered3 Byte3 strobes3
                                             // used to genetate3 
                                             // individual3 write strobes3

// Output3 register declarations3
   
   reg [31:0]                  smc_addr3;
   reg [3:0]                   smc_n_be3;
   reg                    smc_n_cs3;
   reg [3:0]                   n_be3;
   
   
   // Internal register declarations3
   
   reg [1:0]                  r_addr3;           // Stored3 Address bits 
   reg                   r_cs3;             // Stored3 CS3
   reg [1:0]                  v_addr3;           // Validated3 Address
                                                     //  bits
   reg [7:0]                  v_cs3;             // Validated3 CS3
   
   wire                       ored_v_cs3;        //oring3 of v_sc3
   wire [4:0]                 cs_xfer_bus_size3; //concatenated3 bus and 
                                                  // xfer3 size
   wire [2:0]                 wait_access_smdone3;//concatenated3 signal3
   

// Main3 Code3
//----------------------------------------------------------------------
// Address Store3, CS3 Store3 & BE3 Store3
//----------------------------------------------------------------------

   always @(posedge sys_clk3 or negedge n_sys_reset3)
     
     begin
        
        if (~n_sys_reset3)
          
           r_cs3 <= 1'b0;
        
        
        else if (valid_access3)
          
           r_cs3 <= cs ;
        
        else
          
           r_cs3 <= r_cs3 ;
        
     end

//----------------------------------------------------------------------
//v_cs3 generation3   
//----------------------------------------------------------------------
   
   always @(cs or r_cs3 or valid_access3 )
     
     begin
        
        if (valid_access3)
          
           v_cs3 = cs ;
        
        else
          
           v_cs3 = r_cs3;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone3 = {1'b0,valid_access3,smc_done3};

//----------------------------------------------------------------------
//smc_addr3 generation3
//----------------------------------------------------------------------

  always @(posedge sys_clk3 or negedge n_sys_reset3)
    
    begin
      
      if (~n_sys_reset3)
        
         smc_addr3 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone3)
             3'b1xx :

               smc_addr3 <= smc_addr3;
                        //valid_access3 
             3'b01x : begin
               // Set up address for first access
               // little3-endian from max address downto3 0
               // big-endian from 0 upto3 max_address3
               smc_addr3 [31:2] <= addr [31:2];

               casez( { v_xfer_size3, v_bus_size3, 1'b0 } )

               { `XSIZ_323, `BSIZ_323, 1'b? } : smc_addr3[1:0] <= 2'b00;
               { `XSIZ_323, `BSIZ_163, 1'b0 } : smc_addr3[1:0] <= 2'b10;
               { `XSIZ_323, `BSIZ_163, 1'b1 } : smc_addr3[1:0] <= 2'b00;
               { `XSIZ_323, `BSIZ_83, 1'b0 } :  smc_addr3[1:0] <= 2'b11;
               { `XSIZ_323, `BSIZ_83, 1'b1 } :  smc_addr3[1:0] <= 2'b00;
               { `XSIZ_163, `BSIZ_323, 1'b? } : smc_addr3[1:0] <= {addr[1],1'b0};
               { `XSIZ_163, `BSIZ_163, 1'b? } : smc_addr3[1:0] <= {addr[1],1'b0};
               { `XSIZ_163, `BSIZ_83, 1'b0 } :  smc_addr3[1:0] <= {addr[1],1'b1};
               { `XSIZ_163, `BSIZ_83, 1'b1 } :  smc_addr3[1:0] <= {addr[1],1'b0};
               { `XSIZ_83, 2'b??, 1'b? } :     smc_addr3[1:0] <= addr[1:0];
               default:                       smc_addr3[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses3 fro3 subsequent3 accesses
                // little3 endian decrements3 according3 to access no.
                // bigendian3 increments3 as access no decrements3

                  smc_addr3[31:2] <= smc_addr3[31:2];
                  
               casez( { v_xfer_size3, v_bus_size3, 1'b0 } )

               { `XSIZ_323, `BSIZ_323, 1'b? } : smc_addr3[1:0] <= 2'b00;
               { `XSIZ_323, `BSIZ_163, 1'b0 } : smc_addr3[1:0] <= 2'b00;
               { `XSIZ_323, `BSIZ_163, 1'b1 } : smc_addr3[1:0] <= 2'b10;
               { `XSIZ_323, `BSIZ_83,  1'b0 } : 
                  case( r_num_access3 ) 
                  2'b11:   smc_addr3[1:0] <= 2'b10;
                  2'b10:   smc_addr3[1:0] <= 2'b01;
                  2'b01:   smc_addr3[1:0] <= 2'b00;
                  default: smc_addr3[1:0] <= 2'b11;
                  endcase
               { `XSIZ_323, `BSIZ_83, 1'b1 } :  
                  case( r_num_access3 ) 
                  2'b11:   smc_addr3[1:0] <= 2'b01;
                  2'b10:   smc_addr3[1:0] <= 2'b10;
                  2'b01:   smc_addr3[1:0] <= 2'b11;
                  default: smc_addr3[1:0] <= 2'b00;
                  endcase
               { `XSIZ_163, `BSIZ_323, 1'b? } : smc_addr3[1:0] <= {r_addr3[1],1'b0};
               { `XSIZ_163, `BSIZ_163, 1'b? } : smc_addr3[1:0] <= {r_addr3[1],1'b0};
               { `XSIZ_163, `BSIZ_83, 1'b0 } :  smc_addr3[1:0] <= {r_addr3[1],1'b0};
               { `XSIZ_163, `BSIZ_83, 1'b1 } :  smc_addr3[1:0] <= {r_addr3[1],1'b1};
               { `XSIZ_83, 2'b??, 1'b? } :     smc_addr3[1:0] <= r_addr3[1:0];
               default:                       smc_addr3[1:0] <= r_addr3[1:0];

               endcase
                 
            end
            
            default :

               smc_addr3 <= smc_addr3;
            
          endcase // casex(wait_access_smdone3)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate3 Chip3 Select3 Output3 
//----------------------------------------------------------------------

   always @(posedge sys_clk3 or negedge n_sys_reset3)
     
     begin
        
        if (~n_sys_reset3)
          
          begin
             
             smc_n_cs3 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate3 == `SMC_RW3)
          
           begin
             
              if (valid_access3)
               
                 smc_n_cs3 <= ~cs ;
             
              else
               
                 smc_n_cs3 <= ~r_cs3 ;

           end
        
        else
          
           smc_n_cs3 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch3 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk3 or negedge n_sys_reset3)
     
     begin
        
        if (~n_sys_reset3)
          
           r_addr3 <= 2'd0;
        
        
        else if (valid_access3)
          
           r_addr3 <= addr[1:0];
        
        else
          
           r_addr3 <= r_addr3;
        
     end
   


//----------------------------------------------------------------------
// Validate3 LSB of addr with valid_access3
//----------------------------------------------------------------------

   always @(r_addr3 or valid_access3 or addr)
     
      begin
        
         if (valid_access3)
           
            v_addr3 = addr[1:0];
         
         else
           
            v_addr3 = r_addr3;
         
      end
//----------------------------------------------------------------------
//cancatenation3 of signals3
//----------------------------------------------------------------------
                               //check for v_cs3 = 0
   assign ored_v_cs3 = |v_cs3;   //signal3 concatenation3 to be used in case
   
//----------------------------------------------------------------------
// Generate3 (internal) Byte3 Enables3.
//----------------------------------------------------------------------

   always @(v_cs3 or v_xfer_size3 or v_bus_size3 or v_addr3 )
     
     begin

       if ( |v_cs3 == 1'b1 ) 
        
         casez( {v_xfer_size3, v_bus_size3, 1'b0, v_addr3[1:0] } )
          
         {`XSIZ_83, `BSIZ_83, 1'b?, 2'b??} : n_be3 = 4'b1110; // Any3 on RAM3 B03
         {`XSIZ_83, `BSIZ_163,1'b0, 2'b?0} : n_be3 = 4'b1110; // B23 or B03 = RAM3 B03
         {`XSIZ_83, `BSIZ_163,1'b0, 2'b?1} : n_be3 = 4'b1101; // B33 or B13 = RAM3 B13
         {`XSIZ_83, `BSIZ_163,1'b1, 2'b?0} : n_be3 = 4'b1101; // B23 or B03 = RAM3 B13
         {`XSIZ_83, `BSIZ_163,1'b1, 2'b?1} : n_be3 = 4'b1110; // B33 or B13 = RAM3 B03
         {`XSIZ_83, `BSIZ_323,1'b0, 2'b00} : n_be3 = 4'b1110; // B03 = RAM3 B03
         {`XSIZ_83, `BSIZ_323,1'b0, 2'b01} : n_be3 = 4'b1101; // B13 = RAM3 B13
         {`XSIZ_83, `BSIZ_323,1'b0, 2'b10} : n_be3 = 4'b1011; // B23 = RAM3 B23
         {`XSIZ_83, `BSIZ_323,1'b0, 2'b11} : n_be3 = 4'b0111; // B33 = RAM3 B33
         {`XSIZ_83, `BSIZ_323,1'b1, 2'b00} : n_be3 = 4'b0111; // B03 = RAM3 B33
         {`XSIZ_83, `BSIZ_323,1'b1, 2'b01} : n_be3 = 4'b1011; // B13 = RAM3 B23
         {`XSIZ_83, `BSIZ_323,1'b1, 2'b10} : n_be3 = 4'b1101; // B23 = RAM3 B13
         {`XSIZ_83, `BSIZ_323,1'b1, 2'b11} : n_be3 = 4'b1110; // B33 = RAM3 B03
         {`XSIZ_163,`BSIZ_83, 1'b?, 2'b??} : n_be3 = 4'b1110; // Any3 on RAM3 B03
         {`XSIZ_163,`BSIZ_163,1'b?, 2'b??} : n_be3 = 4'b1100; // Any3 on RAMB103
         {`XSIZ_163,`BSIZ_323,1'b0, 2'b0?} : n_be3 = 4'b1100; // B103 = RAM3 B103
         {`XSIZ_163,`BSIZ_323,1'b0, 2'b1?} : n_be3 = 4'b0011; // B233 = RAM3 B233
         {`XSIZ_163,`BSIZ_323,1'b1, 2'b0?} : n_be3 = 4'b0011; // B103 = RAM3 B233
         {`XSIZ_163,`BSIZ_323,1'b1, 2'b1?} : n_be3 = 4'b1100; // B233 = RAM3 B103
         {`XSIZ_323,`BSIZ_83, 1'b?, 2'b??} : n_be3 = 4'b1110; // Any3 on RAM3 B03
         {`XSIZ_323,`BSIZ_163,1'b?, 2'b??} : n_be3 = 4'b1100; // Any3 on RAM3 B103
         {`XSIZ_323,`BSIZ_323,1'b?, 2'b??} : n_be3 = 4'b0000; // Any3 on RAM3 B32103
         default                         : n_be3 = 4'b1111; // Invalid3 decode
        
         
         endcase // casex(xfer_bus_size3)
        
       else

         n_be3 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate3 (enternal3) Byte3 Enables3.
//----------------------------------------------------------------------

   always @(posedge sys_clk3 or negedge n_sys_reset3)
     
     begin
        
        if (~n_sys_reset3)
          
           smc_n_be3 <= 4'hF;
        
        
        else if (smc_nextstate3 == `SMC_RW3)
          
           smc_n_be3 <= n_be3;
        
        else
          
           smc_n_be3 <= 4'hF;
        
     end
   
   
endmodule

