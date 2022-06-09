//File10 name   : smc_addr_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : This10 block registers the address and chip10 select10
//              lines10 for the current access. The address may only
//              driven10 for one cycle by the AHB10. If10 multiple
//              accesses are required10 the bottom10 two10 address bits
//              are modified between cycles10 depending10 on the current
//              transfer10 and bus size.
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

//


`include "smc_defs_lite10.v"

// address decoder10

module smc_addr_lite10    (
                    //inputs10

                    sys_clk10,
                    n_sys_reset10,
                    valid_access10,
                    r_num_access10,
                    v_bus_size10,
                    v_xfer_size10,
                    cs,
                    addr,
                    smc_done10,
                    smc_nextstate10,


                    //outputs10

                    smc_addr10,
                    smc_n_be10,
                    smc_n_cs10,
                    n_be10);



// I10/O10

   input                    sys_clk10;      //AHB10 System10 clock10
   input                    n_sys_reset10;  //AHB10 System10 reset 
   input                    valid_access10; //Start10 of new cycle
   input [1:0]              r_num_access10; //MAC10 counter
   input [1:0]              v_bus_size10;   //bus width for current access
   input [1:0]              v_xfer_size10;  //Transfer10 size for current 
                                              // access
   input               cs;           //Chip10 (Bank10) select10(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done10;     //Transfer10 complete (state 
                                              // machine10)
   input [4:0]              smc_nextstate10;//Next10 state 

   
   output [31:0]            smc_addr10;     //External10 Memory Interface10 
                                              //  address
   output [3:0]             smc_n_be10;     //EMI10 byte enables10 
   output              smc_n_cs10;     //EMI10 Chip10 Selects10 
   output [3:0]             n_be10;         //Unregistered10 Byte10 strobes10
                                             // used to genetate10 
                                             // individual10 write strobes10

// Output10 register declarations10
   
   reg [31:0]                  smc_addr10;
   reg [3:0]                   smc_n_be10;
   reg                    smc_n_cs10;
   reg [3:0]                   n_be10;
   
   
   // Internal register declarations10
   
   reg [1:0]                  r_addr10;           // Stored10 Address bits 
   reg                   r_cs10;             // Stored10 CS10
   reg [1:0]                  v_addr10;           // Validated10 Address
                                                     //  bits
   reg [7:0]                  v_cs10;             // Validated10 CS10
   
   wire                       ored_v_cs10;        //oring10 of v_sc10
   wire [4:0]                 cs_xfer_bus_size10; //concatenated10 bus and 
                                                  // xfer10 size
   wire [2:0]                 wait_access_smdone10;//concatenated10 signal10
   

// Main10 Code10
//----------------------------------------------------------------------
// Address Store10, CS10 Store10 & BE10 Store10
//----------------------------------------------------------------------

   always @(posedge sys_clk10 or negedge n_sys_reset10)
     
     begin
        
        if (~n_sys_reset10)
          
           r_cs10 <= 1'b0;
        
        
        else if (valid_access10)
          
           r_cs10 <= cs ;
        
        else
          
           r_cs10 <= r_cs10 ;
        
     end

//----------------------------------------------------------------------
//v_cs10 generation10   
//----------------------------------------------------------------------
   
   always @(cs or r_cs10 or valid_access10 )
     
     begin
        
        if (valid_access10)
          
           v_cs10 = cs ;
        
        else
          
           v_cs10 = r_cs10;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone10 = {1'b0,valid_access10,smc_done10};

//----------------------------------------------------------------------
//smc_addr10 generation10
//----------------------------------------------------------------------

  always @(posedge sys_clk10 or negedge n_sys_reset10)
    
    begin
      
      if (~n_sys_reset10)
        
         smc_addr10 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone10)
             3'b1xx :

               smc_addr10 <= smc_addr10;
                        //valid_access10 
             3'b01x : begin
               // Set up address for first access
               // little10-endian from max address downto10 0
               // big-endian from 0 upto10 max_address10
               smc_addr10 [31:2] <= addr [31:2];

               casez( { v_xfer_size10, v_bus_size10, 1'b0 } )

               { `XSIZ_3210, `BSIZ_3210, 1'b? } : smc_addr10[1:0] <= 2'b00;
               { `XSIZ_3210, `BSIZ_1610, 1'b0 } : smc_addr10[1:0] <= 2'b10;
               { `XSIZ_3210, `BSIZ_1610, 1'b1 } : smc_addr10[1:0] <= 2'b00;
               { `XSIZ_3210, `BSIZ_810, 1'b0 } :  smc_addr10[1:0] <= 2'b11;
               { `XSIZ_3210, `BSIZ_810, 1'b1 } :  smc_addr10[1:0] <= 2'b00;
               { `XSIZ_1610, `BSIZ_3210, 1'b? } : smc_addr10[1:0] <= {addr[1],1'b0};
               { `XSIZ_1610, `BSIZ_1610, 1'b? } : smc_addr10[1:0] <= {addr[1],1'b0};
               { `XSIZ_1610, `BSIZ_810, 1'b0 } :  smc_addr10[1:0] <= {addr[1],1'b1};
               { `XSIZ_1610, `BSIZ_810, 1'b1 } :  smc_addr10[1:0] <= {addr[1],1'b0};
               { `XSIZ_810, 2'b??, 1'b? } :     smc_addr10[1:0] <= addr[1:0];
               default:                       smc_addr10[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses10 fro10 subsequent10 accesses
                // little10 endian decrements10 according10 to access no.
                // bigendian10 increments10 as access no decrements10

                  smc_addr10[31:2] <= smc_addr10[31:2];
                  
               casez( { v_xfer_size10, v_bus_size10, 1'b0 } )

               { `XSIZ_3210, `BSIZ_3210, 1'b? } : smc_addr10[1:0] <= 2'b00;
               { `XSIZ_3210, `BSIZ_1610, 1'b0 } : smc_addr10[1:0] <= 2'b00;
               { `XSIZ_3210, `BSIZ_1610, 1'b1 } : smc_addr10[1:0] <= 2'b10;
               { `XSIZ_3210, `BSIZ_810,  1'b0 } : 
                  case( r_num_access10 ) 
                  2'b11:   smc_addr10[1:0] <= 2'b10;
                  2'b10:   smc_addr10[1:0] <= 2'b01;
                  2'b01:   smc_addr10[1:0] <= 2'b00;
                  default: smc_addr10[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3210, `BSIZ_810, 1'b1 } :  
                  case( r_num_access10 ) 
                  2'b11:   smc_addr10[1:0] <= 2'b01;
                  2'b10:   smc_addr10[1:0] <= 2'b10;
                  2'b01:   smc_addr10[1:0] <= 2'b11;
                  default: smc_addr10[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1610, `BSIZ_3210, 1'b? } : smc_addr10[1:0] <= {r_addr10[1],1'b0};
               { `XSIZ_1610, `BSIZ_1610, 1'b? } : smc_addr10[1:0] <= {r_addr10[1],1'b0};
               { `XSIZ_1610, `BSIZ_810, 1'b0 } :  smc_addr10[1:0] <= {r_addr10[1],1'b0};
               { `XSIZ_1610, `BSIZ_810, 1'b1 } :  smc_addr10[1:0] <= {r_addr10[1],1'b1};
               { `XSIZ_810, 2'b??, 1'b? } :     smc_addr10[1:0] <= r_addr10[1:0];
               default:                       smc_addr10[1:0] <= r_addr10[1:0];

               endcase
                 
            end
            
            default :

               smc_addr10 <= smc_addr10;
            
          endcase // casex(wait_access_smdone10)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate10 Chip10 Select10 Output10 
//----------------------------------------------------------------------

   always @(posedge sys_clk10 or negedge n_sys_reset10)
     
     begin
        
        if (~n_sys_reset10)
          
          begin
             
             smc_n_cs10 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate10 == `SMC_RW10)
          
           begin
             
              if (valid_access10)
               
                 smc_n_cs10 <= ~cs ;
             
              else
               
                 smc_n_cs10 <= ~r_cs10 ;

           end
        
        else
          
           smc_n_cs10 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch10 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk10 or negedge n_sys_reset10)
     
     begin
        
        if (~n_sys_reset10)
          
           r_addr10 <= 2'd0;
        
        
        else if (valid_access10)
          
           r_addr10 <= addr[1:0];
        
        else
          
           r_addr10 <= r_addr10;
        
     end
   


//----------------------------------------------------------------------
// Validate10 LSB of addr with valid_access10
//----------------------------------------------------------------------

   always @(r_addr10 or valid_access10 or addr)
     
      begin
        
         if (valid_access10)
           
            v_addr10 = addr[1:0];
         
         else
           
            v_addr10 = r_addr10;
         
      end
//----------------------------------------------------------------------
//cancatenation10 of signals10
//----------------------------------------------------------------------
                               //check for v_cs10 = 0
   assign ored_v_cs10 = |v_cs10;   //signal10 concatenation10 to be used in case
   
//----------------------------------------------------------------------
// Generate10 (internal) Byte10 Enables10.
//----------------------------------------------------------------------

   always @(v_cs10 or v_xfer_size10 or v_bus_size10 or v_addr10 )
     
     begin

       if ( |v_cs10 == 1'b1 ) 
        
         casez( {v_xfer_size10, v_bus_size10, 1'b0, v_addr10[1:0] } )
          
         {`XSIZ_810, `BSIZ_810, 1'b?, 2'b??} : n_be10 = 4'b1110; // Any10 on RAM10 B010
         {`XSIZ_810, `BSIZ_1610,1'b0, 2'b?0} : n_be10 = 4'b1110; // B210 or B010 = RAM10 B010
         {`XSIZ_810, `BSIZ_1610,1'b0, 2'b?1} : n_be10 = 4'b1101; // B310 or B110 = RAM10 B110
         {`XSIZ_810, `BSIZ_1610,1'b1, 2'b?0} : n_be10 = 4'b1101; // B210 or B010 = RAM10 B110
         {`XSIZ_810, `BSIZ_1610,1'b1, 2'b?1} : n_be10 = 4'b1110; // B310 or B110 = RAM10 B010
         {`XSIZ_810, `BSIZ_3210,1'b0, 2'b00} : n_be10 = 4'b1110; // B010 = RAM10 B010
         {`XSIZ_810, `BSIZ_3210,1'b0, 2'b01} : n_be10 = 4'b1101; // B110 = RAM10 B110
         {`XSIZ_810, `BSIZ_3210,1'b0, 2'b10} : n_be10 = 4'b1011; // B210 = RAM10 B210
         {`XSIZ_810, `BSIZ_3210,1'b0, 2'b11} : n_be10 = 4'b0111; // B310 = RAM10 B310
         {`XSIZ_810, `BSIZ_3210,1'b1, 2'b00} : n_be10 = 4'b0111; // B010 = RAM10 B310
         {`XSIZ_810, `BSIZ_3210,1'b1, 2'b01} : n_be10 = 4'b1011; // B110 = RAM10 B210
         {`XSIZ_810, `BSIZ_3210,1'b1, 2'b10} : n_be10 = 4'b1101; // B210 = RAM10 B110
         {`XSIZ_810, `BSIZ_3210,1'b1, 2'b11} : n_be10 = 4'b1110; // B310 = RAM10 B010
         {`XSIZ_1610,`BSIZ_810, 1'b?, 2'b??} : n_be10 = 4'b1110; // Any10 on RAM10 B010
         {`XSIZ_1610,`BSIZ_1610,1'b?, 2'b??} : n_be10 = 4'b1100; // Any10 on RAMB1010
         {`XSIZ_1610,`BSIZ_3210,1'b0, 2'b0?} : n_be10 = 4'b1100; // B1010 = RAM10 B1010
         {`XSIZ_1610,`BSIZ_3210,1'b0, 2'b1?} : n_be10 = 4'b0011; // B2310 = RAM10 B2310
         {`XSIZ_1610,`BSIZ_3210,1'b1, 2'b0?} : n_be10 = 4'b0011; // B1010 = RAM10 B2310
         {`XSIZ_1610,`BSIZ_3210,1'b1, 2'b1?} : n_be10 = 4'b1100; // B2310 = RAM10 B1010
         {`XSIZ_3210,`BSIZ_810, 1'b?, 2'b??} : n_be10 = 4'b1110; // Any10 on RAM10 B010
         {`XSIZ_3210,`BSIZ_1610,1'b?, 2'b??} : n_be10 = 4'b1100; // Any10 on RAM10 B1010
         {`XSIZ_3210,`BSIZ_3210,1'b?, 2'b??} : n_be10 = 4'b0000; // Any10 on RAM10 B321010
         default                         : n_be10 = 4'b1111; // Invalid10 decode
        
         
         endcase // casex(xfer_bus_size10)
        
       else

         n_be10 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate10 (enternal10) Byte10 Enables10.
//----------------------------------------------------------------------

   always @(posedge sys_clk10 or negedge n_sys_reset10)
     
     begin
        
        if (~n_sys_reset10)
          
           smc_n_be10 <= 4'hF;
        
        
        else if (smc_nextstate10 == `SMC_RW10)
          
           smc_n_be10 <= n_be10;
        
        else
          
           smc_n_be10 <= 4'hF;
        
     end
   
   
endmodule

