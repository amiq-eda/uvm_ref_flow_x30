//File1 name   : smc_addr_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : This1 block registers the address and chip1 select1
//              lines1 for the current access. The address may only
//              driven1 for one cycle by the AHB1. If1 multiple
//              accesses are required1 the bottom1 two1 address bits
//              are modified between cycles1 depending1 on the current
//              transfer1 and bus size.
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

//


`include "smc_defs_lite1.v"

// address decoder1

module smc_addr_lite1    (
                    //inputs1

                    sys_clk1,
                    n_sys_reset1,
                    valid_access1,
                    r_num_access1,
                    v_bus_size1,
                    v_xfer_size1,
                    cs,
                    addr,
                    smc_done1,
                    smc_nextstate1,


                    //outputs1

                    smc_addr1,
                    smc_n_be1,
                    smc_n_cs1,
                    n_be1);



// I1/O1

   input                    sys_clk1;      //AHB1 System1 clock1
   input                    n_sys_reset1;  //AHB1 System1 reset 
   input                    valid_access1; //Start1 of new cycle
   input [1:0]              r_num_access1; //MAC1 counter
   input [1:0]              v_bus_size1;   //bus width for current access
   input [1:0]              v_xfer_size1;  //Transfer1 size for current 
                                              // access
   input               cs;           //Chip1 (Bank1) select1(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done1;     //Transfer1 complete (state 
                                              // machine1)
   input [4:0]              smc_nextstate1;//Next1 state 

   
   output [31:0]            smc_addr1;     //External1 Memory Interface1 
                                              //  address
   output [3:0]             smc_n_be1;     //EMI1 byte enables1 
   output              smc_n_cs1;     //EMI1 Chip1 Selects1 
   output [3:0]             n_be1;         //Unregistered1 Byte1 strobes1
                                             // used to genetate1 
                                             // individual1 write strobes1

// Output1 register declarations1
   
   reg [31:0]                  smc_addr1;
   reg [3:0]                   smc_n_be1;
   reg                    smc_n_cs1;
   reg [3:0]                   n_be1;
   
   
   // Internal register declarations1
   
   reg [1:0]                  r_addr1;           // Stored1 Address bits 
   reg                   r_cs1;             // Stored1 CS1
   reg [1:0]                  v_addr1;           // Validated1 Address
                                                     //  bits
   reg [7:0]                  v_cs1;             // Validated1 CS1
   
   wire                       ored_v_cs1;        //oring1 of v_sc1
   wire [4:0]                 cs_xfer_bus_size1; //concatenated1 bus and 
                                                  // xfer1 size
   wire [2:0]                 wait_access_smdone1;//concatenated1 signal1
   

// Main1 Code1
//----------------------------------------------------------------------
// Address Store1, CS1 Store1 & BE1 Store1
//----------------------------------------------------------------------

   always @(posedge sys_clk1 or negedge n_sys_reset1)
     
     begin
        
        if (~n_sys_reset1)
          
           r_cs1 <= 1'b0;
        
        
        else if (valid_access1)
          
           r_cs1 <= cs ;
        
        else
          
           r_cs1 <= r_cs1 ;
        
     end

//----------------------------------------------------------------------
//v_cs1 generation1   
//----------------------------------------------------------------------
   
   always @(cs or r_cs1 or valid_access1 )
     
     begin
        
        if (valid_access1)
          
           v_cs1 = cs ;
        
        else
          
           v_cs1 = r_cs1;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone1 = {1'b0,valid_access1,smc_done1};

//----------------------------------------------------------------------
//smc_addr1 generation1
//----------------------------------------------------------------------

  always @(posedge sys_clk1 or negedge n_sys_reset1)
    
    begin
      
      if (~n_sys_reset1)
        
         smc_addr1 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone1)
             3'b1xx :

               smc_addr1 <= smc_addr1;
                        //valid_access1 
             3'b01x : begin
               // Set up address for first access
               // little1-endian from max address downto1 0
               // big-endian from 0 upto1 max_address1
               smc_addr1 [31:2] <= addr [31:2];

               casez( { v_xfer_size1, v_bus_size1, 1'b0 } )

               { `XSIZ_321, `BSIZ_321, 1'b? } : smc_addr1[1:0] <= 2'b00;
               { `XSIZ_321, `BSIZ_161, 1'b0 } : smc_addr1[1:0] <= 2'b10;
               { `XSIZ_321, `BSIZ_161, 1'b1 } : smc_addr1[1:0] <= 2'b00;
               { `XSIZ_321, `BSIZ_81, 1'b0 } :  smc_addr1[1:0] <= 2'b11;
               { `XSIZ_321, `BSIZ_81, 1'b1 } :  smc_addr1[1:0] <= 2'b00;
               { `XSIZ_161, `BSIZ_321, 1'b? } : smc_addr1[1:0] <= {addr[1],1'b0};
               { `XSIZ_161, `BSIZ_161, 1'b? } : smc_addr1[1:0] <= {addr[1],1'b0};
               { `XSIZ_161, `BSIZ_81, 1'b0 } :  smc_addr1[1:0] <= {addr[1],1'b1};
               { `XSIZ_161, `BSIZ_81, 1'b1 } :  smc_addr1[1:0] <= {addr[1],1'b0};
               { `XSIZ_81, 2'b??, 1'b? } :     smc_addr1[1:0] <= addr[1:0];
               default:                       smc_addr1[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses1 fro1 subsequent1 accesses
                // little1 endian decrements1 according1 to access no.
                // bigendian1 increments1 as access no decrements1

                  smc_addr1[31:2] <= smc_addr1[31:2];
                  
               casez( { v_xfer_size1, v_bus_size1, 1'b0 } )

               { `XSIZ_321, `BSIZ_321, 1'b? } : smc_addr1[1:0] <= 2'b00;
               { `XSIZ_321, `BSIZ_161, 1'b0 } : smc_addr1[1:0] <= 2'b00;
               { `XSIZ_321, `BSIZ_161, 1'b1 } : smc_addr1[1:0] <= 2'b10;
               { `XSIZ_321, `BSIZ_81,  1'b0 } : 
                  case( r_num_access1 ) 
                  2'b11:   smc_addr1[1:0] <= 2'b10;
                  2'b10:   smc_addr1[1:0] <= 2'b01;
                  2'b01:   smc_addr1[1:0] <= 2'b00;
                  default: smc_addr1[1:0] <= 2'b11;
                  endcase
               { `XSIZ_321, `BSIZ_81, 1'b1 } :  
                  case( r_num_access1 ) 
                  2'b11:   smc_addr1[1:0] <= 2'b01;
                  2'b10:   smc_addr1[1:0] <= 2'b10;
                  2'b01:   smc_addr1[1:0] <= 2'b11;
                  default: smc_addr1[1:0] <= 2'b00;
                  endcase
               { `XSIZ_161, `BSIZ_321, 1'b? } : smc_addr1[1:0] <= {r_addr1[1],1'b0};
               { `XSIZ_161, `BSIZ_161, 1'b? } : smc_addr1[1:0] <= {r_addr1[1],1'b0};
               { `XSIZ_161, `BSIZ_81, 1'b0 } :  smc_addr1[1:0] <= {r_addr1[1],1'b0};
               { `XSIZ_161, `BSIZ_81, 1'b1 } :  smc_addr1[1:0] <= {r_addr1[1],1'b1};
               { `XSIZ_81, 2'b??, 1'b? } :     smc_addr1[1:0] <= r_addr1[1:0];
               default:                       smc_addr1[1:0] <= r_addr1[1:0];

               endcase
                 
            end
            
            default :

               smc_addr1 <= smc_addr1;
            
          endcase // casex(wait_access_smdone1)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate1 Chip1 Select1 Output1 
//----------------------------------------------------------------------

   always @(posedge sys_clk1 or negedge n_sys_reset1)
     
     begin
        
        if (~n_sys_reset1)
          
          begin
             
             smc_n_cs1 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate1 == `SMC_RW1)
          
           begin
             
              if (valid_access1)
               
                 smc_n_cs1 <= ~cs ;
             
              else
               
                 smc_n_cs1 <= ~r_cs1 ;

           end
        
        else
          
           smc_n_cs1 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch1 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk1 or negedge n_sys_reset1)
     
     begin
        
        if (~n_sys_reset1)
          
           r_addr1 <= 2'd0;
        
        
        else if (valid_access1)
          
           r_addr1 <= addr[1:0];
        
        else
          
           r_addr1 <= r_addr1;
        
     end
   


//----------------------------------------------------------------------
// Validate1 LSB of addr with valid_access1
//----------------------------------------------------------------------

   always @(r_addr1 or valid_access1 or addr)
     
      begin
        
         if (valid_access1)
           
            v_addr1 = addr[1:0];
         
         else
           
            v_addr1 = r_addr1;
         
      end
//----------------------------------------------------------------------
//cancatenation1 of signals1
//----------------------------------------------------------------------
                               //check for v_cs1 = 0
   assign ored_v_cs1 = |v_cs1;   //signal1 concatenation1 to be used in case
   
//----------------------------------------------------------------------
// Generate1 (internal) Byte1 Enables1.
//----------------------------------------------------------------------

   always @(v_cs1 or v_xfer_size1 or v_bus_size1 or v_addr1 )
     
     begin

       if ( |v_cs1 == 1'b1 ) 
        
         casez( {v_xfer_size1, v_bus_size1, 1'b0, v_addr1[1:0] } )
          
         {`XSIZ_81, `BSIZ_81, 1'b?, 2'b??} : n_be1 = 4'b1110; // Any1 on RAM1 B01
         {`XSIZ_81, `BSIZ_161,1'b0, 2'b?0} : n_be1 = 4'b1110; // B21 or B01 = RAM1 B01
         {`XSIZ_81, `BSIZ_161,1'b0, 2'b?1} : n_be1 = 4'b1101; // B31 or B11 = RAM1 B11
         {`XSIZ_81, `BSIZ_161,1'b1, 2'b?0} : n_be1 = 4'b1101; // B21 or B01 = RAM1 B11
         {`XSIZ_81, `BSIZ_161,1'b1, 2'b?1} : n_be1 = 4'b1110; // B31 or B11 = RAM1 B01
         {`XSIZ_81, `BSIZ_321,1'b0, 2'b00} : n_be1 = 4'b1110; // B01 = RAM1 B01
         {`XSIZ_81, `BSIZ_321,1'b0, 2'b01} : n_be1 = 4'b1101; // B11 = RAM1 B11
         {`XSIZ_81, `BSIZ_321,1'b0, 2'b10} : n_be1 = 4'b1011; // B21 = RAM1 B21
         {`XSIZ_81, `BSIZ_321,1'b0, 2'b11} : n_be1 = 4'b0111; // B31 = RAM1 B31
         {`XSIZ_81, `BSIZ_321,1'b1, 2'b00} : n_be1 = 4'b0111; // B01 = RAM1 B31
         {`XSIZ_81, `BSIZ_321,1'b1, 2'b01} : n_be1 = 4'b1011; // B11 = RAM1 B21
         {`XSIZ_81, `BSIZ_321,1'b1, 2'b10} : n_be1 = 4'b1101; // B21 = RAM1 B11
         {`XSIZ_81, `BSIZ_321,1'b1, 2'b11} : n_be1 = 4'b1110; // B31 = RAM1 B01
         {`XSIZ_161,`BSIZ_81, 1'b?, 2'b??} : n_be1 = 4'b1110; // Any1 on RAM1 B01
         {`XSIZ_161,`BSIZ_161,1'b?, 2'b??} : n_be1 = 4'b1100; // Any1 on RAMB101
         {`XSIZ_161,`BSIZ_321,1'b0, 2'b0?} : n_be1 = 4'b1100; // B101 = RAM1 B101
         {`XSIZ_161,`BSIZ_321,1'b0, 2'b1?} : n_be1 = 4'b0011; // B231 = RAM1 B231
         {`XSIZ_161,`BSIZ_321,1'b1, 2'b0?} : n_be1 = 4'b0011; // B101 = RAM1 B231
         {`XSIZ_161,`BSIZ_321,1'b1, 2'b1?} : n_be1 = 4'b1100; // B231 = RAM1 B101
         {`XSIZ_321,`BSIZ_81, 1'b?, 2'b??} : n_be1 = 4'b1110; // Any1 on RAM1 B01
         {`XSIZ_321,`BSIZ_161,1'b?, 2'b??} : n_be1 = 4'b1100; // Any1 on RAM1 B101
         {`XSIZ_321,`BSIZ_321,1'b?, 2'b??} : n_be1 = 4'b0000; // Any1 on RAM1 B32101
         default                         : n_be1 = 4'b1111; // Invalid1 decode
        
         
         endcase // casex(xfer_bus_size1)
        
       else

         n_be1 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate1 (enternal1) Byte1 Enables1.
//----------------------------------------------------------------------

   always @(posedge sys_clk1 or negedge n_sys_reset1)
     
     begin
        
        if (~n_sys_reset1)
          
           smc_n_be1 <= 4'hF;
        
        
        else if (smc_nextstate1 == `SMC_RW1)
          
           smc_n_be1 <= n_be1;
        
        else
          
           smc_n_be1 <= 4'hF;
        
     end
   
   
endmodule

