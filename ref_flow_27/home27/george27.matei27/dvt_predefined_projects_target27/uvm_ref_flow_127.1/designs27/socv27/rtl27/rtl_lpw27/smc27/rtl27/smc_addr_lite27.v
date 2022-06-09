//File27 name   : smc_addr_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : This27 block registers the address and chip27 select27
//              lines27 for the current access. The address may only
//              driven27 for one cycle by the AHB27. If27 multiple
//              accesses are required27 the bottom27 two27 address bits
//              are modified between cycles27 depending27 on the current
//              transfer27 and bus size.
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

//


`include "smc_defs_lite27.v"

// address decoder27

module smc_addr_lite27    (
                    //inputs27

                    sys_clk27,
                    n_sys_reset27,
                    valid_access27,
                    r_num_access27,
                    v_bus_size27,
                    v_xfer_size27,
                    cs,
                    addr,
                    smc_done27,
                    smc_nextstate27,


                    //outputs27

                    smc_addr27,
                    smc_n_be27,
                    smc_n_cs27,
                    n_be27);



// I27/O27

   input                    sys_clk27;      //AHB27 System27 clock27
   input                    n_sys_reset27;  //AHB27 System27 reset 
   input                    valid_access27; //Start27 of new cycle
   input [1:0]              r_num_access27; //MAC27 counter
   input [1:0]              v_bus_size27;   //bus width for current access
   input [1:0]              v_xfer_size27;  //Transfer27 size for current 
                                              // access
   input               cs;           //Chip27 (Bank27) select27(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done27;     //Transfer27 complete (state 
                                              // machine27)
   input [4:0]              smc_nextstate27;//Next27 state 

   
   output [31:0]            smc_addr27;     //External27 Memory Interface27 
                                              //  address
   output [3:0]             smc_n_be27;     //EMI27 byte enables27 
   output              smc_n_cs27;     //EMI27 Chip27 Selects27 
   output [3:0]             n_be27;         //Unregistered27 Byte27 strobes27
                                             // used to genetate27 
                                             // individual27 write strobes27

// Output27 register declarations27
   
   reg [31:0]                  smc_addr27;
   reg [3:0]                   smc_n_be27;
   reg                    smc_n_cs27;
   reg [3:0]                   n_be27;
   
   
   // Internal register declarations27
   
   reg [1:0]                  r_addr27;           // Stored27 Address bits 
   reg                   r_cs27;             // Stored27 CS27
   reg [1:0]                  v_addr27;           // Validated27 Address
                                                     //  bits
   reg [7:0]                  v_cs27;             // Validated27 CS27
   
   wire                       ored_v_cs27;        //oring27 of v_sc27
   wire [4:0]                 cs_xfer_bus_size27; //concatenated27 bus and 
                                                  // xfer27 size
   wire [2:0]                 wait_access_smdone27;//concatenated27 signal27
   

// Main27 Code27
//----------------------------------------------------------------------
// Address Store27, CS27 Store27 & BE27 Store27
//----------------------------------------------------------------------

   always @(posedge sys_clk27 or negedge n_sys_reset27)
     
     begin
        
        if (~n_sys_reset27)
          
           r_cs27 <= 1'b0;
        
        
        else if (valid_access27)
          
           r_cs27 <= cs ;
        
        else
          
           r_cs27 <= r_cs27 ;
        
     end

//----------------------------------------------------------------------
//v_cs27 generation27   
//----------------------------------------------------------------------
   
   always @(cs or r_cs27 or valid_access27 )
     
     begin
        
        if (valid_access27)
          
           v_cs27 = cs ;
        
        else
          
           v_cs27 = r_cs27;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone27 = {1'b0,valid_access27,smc_done27};

//----------------------------------------------------------------------
//smc_addr27 generation27
//----------------------------------------------------------------------

  always @(posedge sys_clk27 or negedge n_sys_reset27)
    
    begin
      
      if (~n_sys_reset27)
        
         smc_addr27 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone27)
             3'b1xx :

               smc_addr27 <= smc_addr27;
                        //valid_access27 
             3'b01x : begin
               // Set up address for first access
               // little27-endian from max address downto27 0
               // big-endian from 0 upto27 max_address27
               smc_addr27 [31:2] <= addr [31:2];

               casez( { v_xfer_size27, v_bus_size27, 1'b0 } )

               { `XSIZ_3227, `BSIZ_3227, 1'b? } : smc_addr27[1:0] <= 2'b00;
               { `XSIZ_3227, `BSIZ_1627, 1'b0 } : smc_addr27[1:0] <= 2'b10;
               { `XSIZ_3227, `BSIZ_1627, 1'b1 } : smc_addr27[1:0] <= 2'b00;
               { `XSIZ_3227, `BSIZ_827, 1'b0 } :  smc_addr27[1:0] <= 2'b11;
               { `XSIZ_3227, `BSIZ_827, 1'b1 } :  smc_addr27[1:0] <= 2'b00;
               { `XSIZ_1627, `BSIZ_3227, 1'b? } : smc_addr27[1:0] <= {addr[1],1'b0};
               { `XSIZ_1627, `BSIZ_1627, 1'b? } : smc_addr27[1:0] <= {addr[1],1'b0};
               { `XSIZ_1627, `BSIZ_827, 1'b0 } :  smc_addr27[1:0] <= {addr[1],1'b1};
               { `XSIZ_1627, `BSIZ_827, 1'b1 } :  smc_addr27[1:0] <= {addr[1],1'b0};
               { `XSIZ_827, 2'b??, 1'b? } :     smc_addr27[1:0] <= addr[1:0];
               default:                       smc_addr27[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses27 fro27 subsequent27 accesses
                // little27 endian decrements27 according27 to access no.
                // bigendian27 increments27 as access no decrements27

                  smc_addr27[31:2] <= smc_addr27[31:2];
                  
               casez( { v_xfer_size27, v_bus_size27, 1'b0 } )

               { `XSIZ_3227, `BSIZ_3227, 1'b? } : smc_addr27[1:0] <= 2'b00;
               { `XSIZ_3227, `BSIZ_1627, 1'b0 } : smc_addr27[1:0] <= 2'b00;
               { `XSIZ_3227, `BSIZ_1627, 1'b1 } : smc_addr27[1:0] <= 2'b10;
               { `XSIZ_3227, `BSIZ_827,  1'b0 } : 
                  case( r_num_access27 ) 
                  2'b11:   smc_addr27[1:0] <= 2'b10;
                  2'b10:   smc_addr27[1:0] <= 2'b01;
                  2'b01:   smc_addr27[1:0] <= 2'b00;
                  default: smc_addr27[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3227, `BSIZ_827, 1'b1 } :  
                  case( r_num_access27 ) 
                  2'b11:   smc_addr27[1:0] <= 2'b01;
                  2'b10:   smc_addr27[1:0] <= 2'b10;
                  2'b01:   smc_addr27[1:0] <= 2'b11;
                  default: smc_addr27[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1627, `BSIZ_3227, 1'b? } : smc_addr27[1:0] <= {r_addr27[1],1'b0};
               { `XSIZ_1627, `BSIZ_1627, 1'b? } : smc_addr27[1:0] <= {r_addr27[1],1'b0};
               { `XSIZ_1627, `BSIZ_827, 1'b0 } :  smc_addr27[1:0] <= {r_addr27[1],1'b0};
               { `XSIZ_1627, `BSIZ_827, 1'b1 } :  smc_addr27[1:0] <= {r_addr27[1],1'b1};
               { `XSIZ_827, 2'b??, 1'b? } :     smc_addr27[1:0] <= r_addr27[1:0];
               default:                       smc_addr27[1:0] <= r_addr27[1:0];

               endcase
                 
            end
            
            default :

               smc_addr27 <= smc_addr27;
            
          endcase // casex(wait_access_smdone27)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate27 Chip27 Select27 Output27 
//----------------------------------------------------------------------

   always @(posedge sys_clk27 or negedge n_sys_reset27)
     
     begin
        
        if (~n_sys_reset27)
          
          begin
             
             smc_n_cs27 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate27 == `SMC_RW27)
          
           begin
             
              if (valid_access27)
               
                 smc_n_cs27 <= ~cs ;
             
              else
               
                 smc_n_cs27 <= ~r_cs27 ;

           end
        
        else
          
           smc_n_cs27 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch27 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk27 or negedge n_sys_reset27)
     
     begin
        
        if (~n_sys_reset27)
          
           r_addr27 <= 2'd0;
        
        
        else if (valid_access27)
          
           r_addr27 <= addr[1:0];
        
        else
          
           r_addr27 <= r_addr27;
        
     end
   


//----------------------------------------------------------------------
// Validate27 LSB of addr with valid_access27
//----------------------------------------------------------------------

   always @(r_addr27 or valid_access27 or addr)
     
      begin
        
         if (valid_access27)
           
            v_addr27 = addr[1:0];
         
         else
           
            v_addr27 = r_addr27;
         
      end
//----------------------------------------------------------------------
//cancatenation27 of signals27
//----------------------------------------------------------------------
                               //check for v_cs27 = 0
   assign ored_v_cs27 = |v_cs27;   //signal27 concatenation27 to be used in case
   
//----------------------------------------------------------------------
// Generate27 (internal) Byte27 Enables27.
//----------------------------------------------------------------------

   always @(v_cs27 or v_xfer_size27 or v_bus_size27 or v_addr27 )
     
     begin

       if ( |v_cs27 == 1'b1 ) 
        
         casez( {v_xfer_size27, v_bus_size27, 1'b0, v_addr27[1:0] } )
          
         {`XSIZ_827, `BSIZ_827, 1'b?, 2'b??} : n_be27 = 4'b1110; // Any27 on RAM27 B027
         {`XSIZ_827, `BSIZ_1627,1'b0, 2'b?0} : n_be27 = 4'b1110; // B227 or B027 = RAM27 B027
         {`XSIZ_827, `BSIZ_1627,1'b0, 2'b?1} : n_be27 = 4'b1101; // B327 or B127 = RAM27 B127
         {`XSIZ_827, `BSIZ_1627,1'b1, 2'b?0} : n_be27 = 4'b1101; // B227 or B027 = RAM27 B127
         {`XSIZ_827, `BSIZ_1627,1'b1, 2'b?1} : n_be27 = 4'b1110; // B327 or B127 = RAM27 B027
         {`XSIZ_827, `BSIZ_3227,1'b0, 2'b00} : n_be27 = 4'b1110; // B027 = RAM27 B027
         {`XSIZ_827, `BSIZ_3227,1'b0, 2'b01} : n_be27 = 4'b1101; // B127 = RAM27 B127
         {`XSIZ_827, `BSIZ_3227,1'b0, 2'b10} : n_be27 = 4'b1011; // B227 = RAM27 B227
         {`XSIZ_827, `BSIZ_3227,1'b0, 2'b11} : n_be27 = 4'b0111; // B327 = RAM27 B327
         {`XSIZ_827, `BSIZ_3227,1'b1, 2'b00} : n_be27 = 4'b0111; // B027 = RAM27 B327
         {`XSIZ_827, `BSIZ_3227,1'b1, 2'b01} : n_be27 = 4'b1011; // B127 = RAM27 B227
         {`XSIZ_827, `BSIZ_3227,1'b1, 2'b10} : n_be27 = 4'b1101; // B227 = RAM27 B127
         {`XSIZ_827, `BSIZ_3227,1'b1, 2'b11} : n_be27 = 4'b1110; // B327 = RAM27 B027
         {`XSIZ_1627,`BSIZ_827, 1'b?, 2'b??} : n_be27 = 4'b1110; // Any27 on RAM27 B027
         {`XSIZ_1627,`BSIZ_1627,1'b?, 2'b??} : n_be27 = 4'b1100; // Any27 on RAMB1027
         {`XSIZ_1627,`BSIZ_3227,1'b0, 2'b0?} : n_be27 = 4'b1100; // B1027 = RAM27 B1027
         {`XSIZ_1627,`BSIZ_3227,1'b0, 2'b1?} : n_be27 = 4'b0011; // B2327 = RAM27 B2327
         {`XSIZ_1627,`BSIZ_3227,1'b1, 2'b0?} : n_be27 = 4'b0011; // B1027 = RAM27 B2327
         {`XSIZ_1627,`BSIZ_3227,1'b1, 2'b1?} : n_be27 = 4'b1100; // B2327 = RAM27 B1027
         {`XSIZ_3227,`BSIZ_827, 1'b?, 2'b??} : n_be27 = 4'b1110; // Any27 on RAM27 B027
         {`XSIZ_3227,`BSIZ_1627,1'b?, 2'b??} : n_be27 = 4'b1100; // Any27 on RAM27 B1027
         {`XSIZ_3227,`BSIZ_3227,1'b?, 2'b??} : n_be27 = 4'b0000; // Any27 on RAM27 B321027
         default                         : n_be27 = 4'b1111; // Invalid27 decode
        
         
         endcase // casex(xfer_bus_size27)
        
       else

         n_be27 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate27 (enternal27) Byte27 Enables27.
//----------------------------------------------------------------------

   always @(posedge sys_clk27 or negedge n_sys_reset27)
     
     begin
        
        if (~n_sys_reset27)
          
           smc_n_be27 <= 4'hF;
        
        
        else if (smc_nextstate27 == `SMC_RW27)
          
           smc_n_be27 <= n_be27;
        
        else
          
           smc_n_be27 <= 4'hF;
        
     end
   
   
endmodule

