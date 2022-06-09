//File17 name   : smc_addr_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : This17 block registers the address and chip17 select17
//              lines17 for the current access. The address may only
//              driven17 for one cycle by the AHB17. If17 multiple
//              accesses are required17 the bottom17 two17 address bits
//              are modified between cycles17 depending17 on the current
//              transfer17 and bus size.
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

//


`include "smc_defs_lite17.v"

// address decoder17

module smc_addr_lite17    (
                    //inputs17

                    sys_clk17,
                    n_sys_reset17,
                    valid_access17,
                    r_num_access17,
                    v_bus_size17,
                    v_xfer_size17,
                    cs,
                    addr,
                    smc_done17,
                    smc_nextstate17,


                    //outputs17

                    smc_addr17,
                    smc_n_be17,
                    smc_n_cs17,
                    n_be17);



// I17/O17

   input                    sys_clk17;      //AHB17 System17 clock17
   input                    n_sys_reset17;  //AHB17 System17 reset 
   input                    valid_access17; //Start17 of new cycle
   input [1:0]              r_num_access17; //MAC17 counter
   input [1:0]              v_bus_size17;   //bus width for current access
   input [1:0]              v_xfer_size17;  //Transfer17 size for current 
                                              // access
   input               cs;           //Chip17 (Bank17) select17(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done17;     //Transfer17 complete (state 
                                              // machine17)
   input [4:0]              smc_nextstate17;//Next17 state 

   
   output [31:0]            smc_addr17;     //External17 Memory Interface17 
                                              //  address
   output [3:0]             smc_n_be17;     //EMI17 byte enables17 
   output              smc_n_cs17;     //EMI17 Chip17 Selects17 
   output [3:0]             n_be17;         //Unregistered17 Byte17 strobes17
                                             // used to genetate17 
                                             // individual17 write strobes17

// Output17 register declarations17
   
   reg [31:0]                  smc_addr17;
   reg [3:0]                   smc_n_be17;
   reg                    smc_n_cs17;
   reg [3:0]                   n_be17;
   
   
   // Internal register declarations17
   
   reg [1:0]                  r_addr17;           // Stored17 Address bits 
   reg                   r_cs17;             // Stored17 CS17
   reg [1:0]                  v_addr17;           // Validated17 Address
                                                     //  bits
   reg [7:0]                  v_cs17;             // Validated17 CS17
   
   wire                       ored_v_cs17;        //oring17 of v_sc17
   wire [4:0]                 cs_xfer_bus_size17; //concatenated17 bus and 
                                                  // xfer17 size
   wire [2:0]                 wait_access_smdone17;//concatenated17 signal17
   

// Main17 Code17
//----------------------------------------------------------------------
// Address Store17, CS17 Store17 & BE17 Store17
//----------------------------------------------------------------------

   always @(posedge sys_clk17 or negedge n_sys_reset17)
     
     begin
        
        if (~n_sys_reset17)
          
           r_cs17 <= 1'b0;
        
        
        else if (valid_access17)
          
           r_cs17 <= cs ;
        
        else
          
           r_cs17 <= r_cs17 ;
        
     end

//----------------------------------------------------------------------
//v_cs17 generation17   
//----------------------------------------------------------------------
   
   always @(cs or r_cs17 or valid_access17 )
     
     begin
        
        if (valid_access17)
          
           v_cs17 = cs ;
        
        else
          
           v_cs17 = r_cs17;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone17 = {1'b0,valid_access17,smc_done17};

//----------------------------------------------------------------------
//smc_addr17 generation17
//----------------------------------------------------------------------

  always @(posedge sys_clk17 or negedge n_sys_reset17)
    
    begin
      
      if (~n_sys_reset17)
        
         smc_addr17 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone17)
             3'b1xx :

               smc_addr17 <= smc_addr17;
                        //valid_access17 
             3'b01x : begin
               // Set up address for first access
               // little17-endian from max address downto17 0
               // big-endian from 0 upto17 max_address17
               smc_addr17 [31:2] <= addr [31:2];

               casez( { v_xfer_size17, v_bus_size17, 1'b0 } )

               { `XSIZ_3217, `BSIZ_3217, 1'b? } : smc_addr17[1:0] <= 2'b00;
               { `XSIZ_3217, `BSIZ_1617, 1'b0 } : smc_addr17[1:0] <= 2'b10;
               { `XSIZ_3217, `BSIZ_1617, 1'b1 } : smc_addr17[1:0] <= 2'b00;
               { `XSIZ_3217, `BSIZ_817, 1'b0 } :  smc_addr17[1:0] <= 2'b11;
               { `XSIZ_3217, `BSIZ_817, 1'b1 } :  smc_addr17[1:0] <= 2'b00;
               { `XSIZ_1617, `BSIZ_3217, 1'b? } : smc_addr17[1:0] <= {addr[1],1'b0};
               { `XSIZ_1617, `BSIZ_1617, 1'b? } : smc_addr17[1:0] <= {addr[1],1'b0};
               { `XSIZ_1617, `BSIZ_817, 1'b0 } :  smc_addr17[1:0] <= {addr[1],1'b1};
               { `XSIZ_1617, `BSIZ_817, 1'b1 } :  smc_addr17[1:0] <= {addr[1],1'b0};
               { `XSIZ_817, 2'b??, 1'b? } :     smc_addr17[1:0] <= addr[1:0];
               default:                       smc_addr17[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses17 fro17 subsequent17 accesses
                // little17 endian decrements17 according17 to access no.
                // bigendian17 increments17 as access no decrements17

                  smc_addr17[31:2] <= smc_addr17[31:2];
                  
               casez( { v_xfer_size17, v_bus_size17, 1'b0 } )

               { `XSIZ_3217, `BSIZ_3217, 1'b? } : smc_addr17[1:0] <= 2'b00;
               { `XSIZ_3217, `BSIZ_1617, 1'b0 } : smc_addr17[1:0] <= 2'b00;
               { `XSIZ_3217, `BSIZ_1617, 1'b1 } : smc_addr17[1:0] <= 2'b10;
               { `XSIZ_3217, `BSIZ_817,  1'b0 } : 
                  case( r_num_access17 ) 
                  2'b11:   smc_addr17[1:0] <= 2'b10;
                  2'b10:   smc_addr17[1:0] <= 2'b01;
                  2'b01:   smc_addr17[1:0] <= 2'b00;
                  default: smc_addr17[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3217, `BSIZ_817, 1'b1 } :  
                  case( r_num_access17 ) 
                  2'b11:   smc_addr17[1:0] <= 2'b01;
                  2'b10:   smc_addr17[1:0] <= 2'b10;
                  2'b01:   smc_addr17[1:0] <= 2'b11;
                  default: smc_addr17[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1617, `BSIZ_3217, 1'b? } : smc_addr17[1:0] <= {r_addr17[1],1'b0};
               { `XSIZ_1617, `BSIZ_1617, 1'b? } : smc_addr17[1:0] <= {r_addr17[1],1'b0};
               { `XSIZ_1617, `BSIZ_817, 1'b0 } :  smc_addr17[1:0] <= {r_addr17[1],1'b0};
               { `XSIZ_1617, `BSIZ_817, 1'b1 } :  smc_addr17[1:0] <= {r_addr17[1],1'b1};
               { `XSIZ_817, 2'b??, 1'b? } :     smc_addr17[1:0] <= r_addr17[1:0];
               default:                       smc_addr17[1:0] <= r_addr17[1:0];

               endcase
                 
            end
            
            default :

               smc_addr17 <= smc_addr17;
            
          endcase // casex(wait_access_smdone17)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate17 Chip17 Select17 Output17 
//----------------------------------------------------------------------

   always @(posedge sys_clk17 or negedge n_sys_reset17)
     
     begin
        
        if (~n_sys_reset17)
          
          begin
             
             smc_n_cs17 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate17 == `SMC_RW17)
          
           begin
             
              if (valid_access17)
               
                 smc_n_cs17 <= ~cs ;
             
              else
               
                 smc_n_cs17 <= ~r_cs17 ;

           end
        
        else
          
           smc_n_cs17 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch17 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk17 or negedge n_sys_reset17)
     
     begin
        
        if (~n_sys_reset17)
          
           r_addr17 <= 2'd0;
        
        
        else if (valid_access17)
          
           r_addr17 <= addr[1:0];
        
        else
          
           r_addr17 <= r_addr17;
        
     end
   


//----------------------------------------------------------------------
// Validate17 LSB of addr with valid_access17
//----------------------------------------------------------------------

   always @(r_addr17 or valid_access17 or addr)
     
      begin
        
         if (valid_access17)
           
            v_addr17 = addr[1:0];
         
         else
           
            v_addr17 = r_addr17;
         
      end
//----------------------------------------------------------------------
//cancatenation17 of signals17
//----------------------------------------------------------------------
                               //check for v_cs17 = 0
   assign ored_v_cs17 = |v_cs17;   //signal17 concatenation17 to be used in case
   
//----------------------------------------------------------------------
// Generate17 (internal) Byte17 Enables17.
//----------------------------------------------------------------------

   always @(v_cs17 or v_xfer_size17 or v_bus_size17 or v_addr17 )
     
     begin

       if ( |v_cs17 == 1'b1 ) 
        
         casez( {v_xfer_size17, v_bus_size17, 1'b0, v_addr17[1:0] } )
          
         {`XSIZ_817, `BSIZ_817, 1'b?, 2'b??} : n_be17 = 4'b1110; // Any17 on RAM17 B017
         {`XSIZ_817, `BSIZ_1617,1'b0, 2'b?0} : n_be17 = 4'b1110; // B217 or B017 = RAM17 B017
         {`XSIZ_817, `BSIZ_1617,1'b0, 2'b?1} : n_be17 = 4'b1101; // B317 or B117 = RAM17 B117
         {`XSIZ_817, `BSIZ_1617,1'b1, 2'b?0} : n_be17 = 4'b1101; // B217 or B017 = RAM17 B117
         {`XSIZ_817, `BSIZ_1617,1'b1, 2'b?1} : n_be17 = 4'b1110; // B317 or B117 = RAM17 B017
         {`XSIZ_817, `BSIZ_3217,1'b0, 2'b00} : n_be17 = 4'b1110; // B017 = RAM17 B017
         {`XSIZ_817, `BSIZ_3217,1'b0, 2'b01} : n_be17 = 4'b1101; // B117 = RAM17 B117
         {`XSIZ_817, `BSIZ_3217,1'b0, 2'b10} : n_be17 = 4'b1011; // B217 = RAM17 B217
         {`XSIZ_817, `BSIZ_3217,1'b0, 2'b11} : n_be17 = 4'b0111; // B317 = RAM17 B317
         {`XSIZ_817, `BSIZ_3217,1'b1, 2'b00} : n_be17 = 4'b0111; // B017 = RAM17 B317
         {`XSIZ_817, `BSIZ_3217,1'b1, 2'b01} : n_be17 = 4'b1011; // B117 = RAM17 B217
         {`XSIZ_817, `BSIZ_3217,1'b1, 2'b10} : n_be17 = 4'b1101; // B217 = RAM17 B117
         {`XSIZ_817, `BSIZ_3217,1'b1, 2'b11} : n_be17 = 4'b1110; // B317 = RAM17 B017
         {`XSIZ_1617,`BSIZ_817, 1'b?, 2'b??} : n_be17 = 4'b1110; // Any17 on RAM17 B017
         {`XSIZ_1617,`BSIZ_1617,1'b?, 2'b??} : n_be17 = 4'b1100; // Any17 on RAMB1017
         {`XSIZ_1617,`BSIZ_3217,1'b0, 2'b0?} : n_be17 = 4'b1100; // B1017 = RAM17 B1017
         {`XSIZ_1617,`BSIZ_3217,1'b0, 2'b1?} : n_be17 = 4'b0011; // B2317 = RAM17 B2317
         {`XSIZ_1617,`BSIZ_3217,1'b1, 2'b0?} : n_be17 = 4'b0011; // B1017 = RAM17 B2317
         {`XSIZ_1617,`BSIZ_3217,1'b1, 2'b1?} : n_be17 = 4'b1100; // B2317 = RAM17 B1017
         {`XSIZ_3217,`BSIZ_817, 1'b?, 2'b??} : n_be17 = 4'b1110; // Any17 on RAM17 B017
         {`XSIZ_3217,`BSIZ_1617,1'b?, 2'b??} : n_be17 = 4'b1100; // Any17 on RAM17 B1017
         {`XSIZ_3217,`BSIZ_3217,1'b?, 2'b??} : n_be17 = 4'b0000; // Any17 on RAM17 B321017
         default                         : n_be17 = 4'b1111; // Invalid17 decode
        
         
         endcase // casex(xfer_bus_size17)
        
       else

         n_be17 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate17 (enternal17) Byte17 Enables17.
//----------------------------------------------------------------------

   always @(posedge sys_clk17 or negedge n_sys_reset17)
     
     begin
        
        if (~n_sys_reset17)
          
           smc_n_be17 <= 4'hF;
        
        
        else if (smc_nextstate17 == `SMC_RW17)
          
           smc_n_be17 <= n_be17;
        
        else
          
           smc_n_be17 <= 4'hF;
        
     end
   
   
endmodule

