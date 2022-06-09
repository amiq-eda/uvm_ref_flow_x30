//File8 name   : smc_addr_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : This8 block registers the address and chip8 select8
//              lines8 for the current access. The address may only
//              driven8 for one cycle by the AHB8. If8 multiple
//              accesses are required8 the bottom8 two8 address bits
//              are modified between cycles8 depending8 on the current
//              transfer8 and bus size.
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

//


`include "smc_defs_lite8.v"

// address decoder8

module smc_addr_lite8    (
                    //inputs8

                    sys_clk8,
                    n_sys_reset8,
                    valid_access8,
                    r_num_access8,
                    v_bus_size8,
                    v_xfer_size8,
                    cs,
                    addr,
                    smc_done8,
                    smc_nextstate8,


                    //outputs8

                    smc_addr8,
                    smc_n_be8,
                    smc_n_cs8,
                    n_be8);



// I8/O8

   input                    sys_clk8;      //AHB8 System8 clock8
   input                    n_sys_reset8;  //AHB8 System8 reset 
   input                    valid_access8; //Start8 of new cycle
   input [1:0]              r_num_access8; //MAC8 counter
   input [1:0]              v_bus_size8;   //bus width for current access
   input [1:0]              v_xfer_size8;  //Transfer8 size for current 
                                              // access
   input               cs;           //Chip8 (Bank8) select8(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done8;     //Transfer8 complete (state 
                                              // machine8)
   input [4:0]              smc_nextstate8;//Next8 state 

   
   output [31:0]            smc_addr8;     //External8 Memory Interface8 
                                              //  address
   output [3:0]             smc_n_be8;     //EMI8 byte enables8 
   output              smc_n_cs8;     //EMI8 Chip8 Selects8 
   output [3:0]             n_be8;         //Unregistered8 Byte8 strobes8
                                             // used to genetate8 
                                             // individual8 write strobes8

// Output8 register declarations8
   
   reg [31:0]                  smc_addr8;
   reg [3:0]                   smc_n_be8;
   reg                    smc_n_cs8;
   reg [3:0]                   n_be8;
   
   
   // Internal register declarations8
   
   reg [1:0]                  r_addr8;           // Stored8 Address bits 
   reg                   r_cs8;             // Stored8 CS8
   reg [1:0]                  v_addr8;           // Validated8 Address
                                                     //  bits
   reg [7:0]                  v_cs8;             // Validated8 CS8
   
   wire                       ored_v_cs8;        //oring8 of v_sc8
   wire [4:0]                 cs_xfer_bus_size8; //concatenated8 bus and 
                                                  // xfer8 size
   wire [2:0]                 wait_access_smdone8;//concatenated8 signal8
   

// Main8 Code8
//----------------------------------------------------------------------
// Address Store8, CS8 Store8 & BE8 Store8
//----------------------------------------------------------------------

   always @(posedge sys_clk8 or negedge n_sys_reset8)
     
     begin
        
        if (~n_sys_reset8)
          
           r_cs8 <= 1'b0;
        
        
        else if (valid_access8)
          
           r_cs8 <= cs ;
        
        else
          
           r_cs8 <= r_cs8 ;
        
     end

//----------------------------------------------------------------------
//v_cs8 generation8   
//----------------------------------------------------------------------
   
   always @(cs or r_cs8 or valid_access8 )
     
     begin
        
        if (valid_access8)
          
           v_cs8 = cs ;
        
        else
          
           v_cs8 = r_cs8;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone8 = {1'b0,valid_access8,smc_done8};

//----------------------------------------------------------------------
//smc_addr8 generation8
//----------------------------------------------------------------------

  always @(posedge sys_clk8 or negedge n_sys_reset8)
    
    begin
      
      if (~n_sys_reset8)
        
         smc_addr8 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone8)
             3'b1xx :

               smc_addr8 <= smc_addr8;
                        //valid_access8 
             3'b01x : begin
               // Set up address for first access
               // little8-endian from max address downto8 0
               // big-endian from 0 upto8 max_address8
               smc_addr8 [31:2] <= addr [31:2];

               casez( { v_xfer_size8, v_bus_size8, 1'b0 } )

               { `XSIZ_328, `BSIZ_328, 1'b? } : smc_addr8[1:0] <= 2'b00;
               { `XSIZ_328, `BSIZ_168, 1'b0 } : smc_addr8[1:0] <= 2'b10;
               { `XSIZ_328, `BSIZ_168, 1'b1 } : smc_addr8[1:0] <= 2'b00;
               { `XSIZ_328, `BSIZ_88, 1'b0 } :  smc_addr8[1:0] <= 2'b11;
               { `XSIZ_328, `BSIZ_88, 1'b1 } :  smc_addr8[1:0] <= 2'b00;
               { `XSIZ_168, `BSIZ_328, 1'b? } : smc_addr8[1:0] <= {addr[1],1'b0};
               { `XSIZ_168, `BSIZ_168, 1'b? } : smc_addr8[1:0] <= {addr[1],1'b0};
               { `XSIZ_168, `BSIZ_88, 1'b0 } :  smc_addr8[1:0] <= {addr[1],1'b1};
               { `XSIZ_168, `BSIZ_88, 1'b1 } :  smc_addr8[1:0] <= {addr[1],1'b0};
               { `XSIZ_88, 2'b??, 1'b? } :     smc_addr8[1:0] <= addr[1:0];
               default:                       smc_addr8[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses8 fro8 subsequent8 accesses
                // little8 endian decrements8 according8 to access no.
                // bigendian8 increments8 as access no decrements8

                  smc_addr8[31:2] <= smc_addr8[31:2];
                  
               casez( { v_xfer_size8, v_bus_size8, 1'b0 } )

               { `XSIZ_328, `BSIZ_328, 1'b? } : smc_addr8[1:0] <= 2'b00;
               { `XSIZ_328, `BSIZ_168, 1'b0 } : smc_addr8[1:0] <= 2'b00;
               { `XSIZ_328, `BSIZ_168, 1'b1 } : smc_addr8[1:0] <= 2'b10;
               { `XSIZ_328, `BSIZ_88,  1'b0 } : 
                  case( r_num_access8 ) 
                  2'b11:   smc_addr8[1:0] <= 2'b10;
                  2'b10:   smc_addr8[1:0] <= 2'b01;
                  2'b01:   smc_addr8[1:0] <= 2'b00;
                  default: smc_addr8[1:0] <= 2'b11;
                  endcase
               { `XSIZ_328, `BSIZ_88, 1'b1 } :  
                  case( r_num_access8 ) 
                  2'b11:   smc_addr8[1:0] <= 2'b01;
                  2'b10:   smc_addr8[1:0] <= 2'b10;
                  2'b01:   smc_addr8[1:0] <= 2'b11;
                  default: smc_addr8[1:0] <= 2'b00;
                  endcase
               { `XSIZ_168, `BSIZ_328, 1'b? } : smc_addr8[1:0] <= {r_addr8[1],1'b0};
               { `XSIZ_168, `BSIZ_168, 1'b? } : smc_addr8[1:0] <= {r_addr8[1],1'b0};
               { `XSIZ_168, `BSIZ_88, 1'b0 } :  smc_addr8[1:0] <= {r_addr8[1],1'b0};
               { `XSIZ_168, `BSIZ_88, 1'b1 } :  smc_addr8[1:0] <= {r_addr8[1],1'b1};
               { `XSIZ_88, 2'b??, 1'b? } :     smc_addr8[1:0] <= r_addr8[1:0];
               default:                       smc_addr8[1:0] <= r_addr8[1:0];

               endcase
                 
            end
            
            default :

               smc_addr8 <= smc_addr8;
            
          endcase // casex(wait_access_smdone8)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate8 Chip8 Select8 Output8 
//----------------------------------------------------------------------

   always @(posedge sys_clk8 or negedge n_sys_reset8)
     
     begin
        
        if (~n_sys_reset8)
          
          begin
             
             smc_n_cs8 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate8 == `SMC_RW8)
          
           begin
             
              if (valid_access8)
               
                 smc_n_cs8 <= ~cs ;
             
              else
               
                 smc_n_cs8 <= ~r_cs8 ;

           end
        
        else
          
           smc_n_cs8 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch8 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk8 or negedge n_sys_reset8)
     
     begin
        
        if (~n_sys_reset8)
          
           r_addr8 <= 2'd0;
        
        
        else if (valid_access8)
          
           r_addr8 <= addr[1:0];
        
        else
          
           r_addr8 <= r_addr8;
        
     end
   


//----------------------------------------------------------------------
// Validate8 LSB of addr with valid_access8
//----------------------------------------------------------------------

   always @(r_addr8 or valid_access8 or addr)
     
      begin
        
         if (valid_access8)
           
            v_addr8 = addr[1:0];
         
         else
           
            v_addr8 = r_addr8;
         
      end
//----------------------------------------------------------------------
//cancatenation8 of signals8
//----------------------------------------------------------------------
                               //check for v_cs8 = 0
   assign ored_v_cs8 = |v_cs8;   //signal8 concatenation8 to be used in case
   
//----------------------------------------------------------------------
// Generate8 (internal) Byte8 Enables8.
//----------------------------------------------------------------------

   always @(v_cs8 or v_xfer_size8 or v_bus_size8 or v_addr8 )
     
     begin

       if ( |v_cs8 == 1'b1 ) 
        
         casez( {v_xfer_size8, v_bus_size8, 1'b0, v_addr8[1:0] } )
          
         {`XSIZ_88, `BSIZ_88, 1'b?, 2'b??} : n_be8 = 4'b1110; // Any8 on RAM8 B08
         {`XSIZ_88, `BSIZ_168,1'b0, 2'b?0} : n_be8 = 4'b1110; // B28 or B08 = RAM8 B08
         {`XSIZ_88, `BSIZ_168,1'b0, 2'b?1} : n_be8 = 4'b1101; // B38 or B18 = RAM8 B18
         {`XSIZ_88, `BSIZ_168,1'b1, 2'b?0} : n_be8 = 4'b1101; // B28 or B08 = RAM8 B18
         {`XSIZ_88, `BSIZ_168,1'b1, 2'b?1} : n_be8 = 4'b1110; // B38 or B18 = RAM8 B08
         {`XSIZ_88, `BSIZ_328,1'b0, 2'b00} : n_be8 = 4'b1110; // B08 = RAM8 B08
         {`XSIZ_88, `BSIZ_328,1'b0, 2'b01} : n_be8 = 4'b1101; // B18 = RAM8 B18
         {`XSIZ_88, `BSIZ_328,1'b0, 2'b10} : n_be8 = 4'b1011; // B28 = RAM8 B28
         {`XSIZ_88, `BSIZ_328,1'b0, 2'b11} : n_be8 = 4'b0111; // B38 = RAM8 B38
         {`XSIZ_88, `BSIZ_328,1'b1, 2'b00} : n_be8 = 4'b0111; // B08 = RAM8 B38
         {`XSIZ_88, `BSIZ_328,1'b1, 2'b01} : n_be8 = 4'b1011; // B18 = RAM8 B28
         {`XSIZ_88, `BSIZ_328,1'b1, 2'b10} : n_be8 = 4'b1101; // B28 = RAM8 B18
         {`XSIZ_88, `BSIZ_328,1'b1, 2'b11} : n_be8 = 4'b1110; // B38 = RAM8 B08
         {`XSIZ_168,`BSIZ_88, 1'b?, 2'b??} : n_be8 = 4'b1110; // Any8 on RAM8 B08
         {`XSIZ_168,`BSIZ_168,1'b?, 2'b??} : n_be8 = 4'b1100; // Any8 on RAMB108
         {`XSIZ_168,`BSIZ_328,1'b0, 2'b0?} : n_be8 = 4'b1100; // B108 = RAM8 B108
         {`XSIZ_168,`BSIZ_328,1'b0, 2'b1?} : n_be8 = 4'b0011; // B238 = RAM8 B238
         {`XSIZ_168,`BSIZ_328,1'b1, 2'b0?} : n_be8 = 4'b0011; // B108 = RAM8 B238
         {`XSIZ_168,`BSIZ_328,1'b1, 2'b1?} : n_be8 = 4'b1100; // B238 = RAM8 B108
         {`XSIZ_328,`BSIZ_88, 1'b?, 2'b??} : n_be8 = 4'b1110; // Any8 on RAM8 B08
         {`XSIZ_328,`BSIZ_168,1'b?, 2'b??} : n_be8 = 4'b1100; // Any8 on RAM8 B108
         {`XSIZ_328,`BSIZ_328,1'b?, 2'b??} : n_be8 = 4'b0000; // Any8 on RAM8 B32108
         default                         : n_be8 = 4'b1111; // Invalid8 decode
        
         
         endcase // casex(xfer_bus_size8)
        
       else

         n_be8 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate8 (enternal8) Byte8 Enables8.
//----------------------------------------------------------------------

   always @(posedge sys_clk8 or negedge n_sys_reset8)
     
     begin
        
        if (~n_sys_reset8)
          
           smc_n_be8 <= 4'hF;
        
        
        else if (smc_nextstate8 == `SMC_RW8)
          
           smc_n_be8 <= n_be8;
        
        else
          
           smc_n_be8 <= 4'hF;
        
     end
   
   
endmodule

