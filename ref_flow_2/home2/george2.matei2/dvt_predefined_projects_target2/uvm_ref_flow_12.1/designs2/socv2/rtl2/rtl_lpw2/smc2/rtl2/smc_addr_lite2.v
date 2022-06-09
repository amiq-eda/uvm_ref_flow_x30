//File2 name   : smc_addr_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : This2 block registers the address and chip2 select2
//              lines2 for the current access. The address may only
//              driven2 for one cycle by the AHB2. If2 multiple
//              accesses are required2 the bottom2 two2 address bits
//              are modified between cycles2 depending2 on the current
//              transfer2 and bus size.
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

//


`include "smc_defs_lite2.v"

// address decoder2

module smc_addr_lite2    (
                    //inputs2

                    sys_clk2,
                    n_sys_reset2,
                    valid_access2,
                    r_num_access2,
                    v_bus_size2,
                    v_xfer_size2,
                    cs,
                    addr,
                    smc_done2,
                    smc_nextstate2,


                    //outputs2

                    smc_addr2,
                    smc_n_be2,
                    smc_n_cs2,
                    n_be2);



// I2/O2

   input                    sys_clk2;      //AHB2 System2 clock2
   input                    n_sys_reset2;  //AHB2 System2 reset 
   input                    valid_access2; //Start2 of new cycle
   input [1:0]              r_num_access2; //MAC2 counter
   input [1:0]              v_bus_size2;   //bus width for current access
   input [1:0]              v_xfer_size2;  //Transfer2 size for current 
                                              // access
   input               cs;           //Chip2 (Bank2) select2(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done2;     //Transfer2 complete (state 
                                              // machine2)
   input [4:0]              smc_nextstate2;//Next2 state 

   
   output [31:0]            smc_addr2;     //External2 Memory Interface2 
                                              //  address
   output [3:0]             smc_n_be2;     //EMI2 byte enables2 
   output              smc_n_cs2;     //EMI2 Chip2 Selects2 
   output [3:0]             n_be2;         //Unregistered2 Byte2 strobes2
                                             // used to genetate2 
                                             // individual2 write strobes2

// Output2 register declarations2
   
   reg [31:0]                  smc_addr2;
   reg [3:0]                   smc_n_be2;
   reg                    smc_n_cs2;
   reg [3:0]                   n_be2;
   
   
   // Internal register declarations2
   
   reg [1:0]                  r_addr2;           // Stored2 Address bits 
   reg                   r_cs2;             // Stored2 CS2
   reg [1:0]                  v_addr2;           // Validated2 Address
                                                     //  bits
   reg [7:0]                  v_cs2;             // Validated2 CS2
   
   wire                       ored_v_cs2;        //oring2 of v_sc2
   wire [4:0]                 cs_xfer_bus_size2; //concatenated2 bus and 
                                                  // xfer2 size
   wire [2:0]                 wait_access_smdone2;//concatenated2 signal2
   

// Main2 Code2
//----------------------------------------------------------------------
// Address Store2, CS2 Store2 & BE2 Store2
//----------------------------------------------------------------------

   always @(posedge sys_clk2 or negedge n_sys_reset2)
     
     begin
        
        if (~n_sys_reset2)
          
           r_cs2 <= 1'b0;
        
        
        else if (valid_access2)
          
           r_cs2 <= cs ;
        
        else
          
           r_cs2 <= r_cs2 ;
        
     end

//----------------------------------------------------------------------
//v_cs2 generation2   
//----------------------------------------------------------------------
   
   always @(cs or r_cs2 or valid_access2 )
     
     begin
        
        if (valid_access2)
          
           v_cs2 = cs ;
        
        else
          
           v_cs2 = r_cs2;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone2 = {1'b0,valid_access2,smc_done2};

//----------------------------------------------------------------------
//smc_addr2 generation2
//----------------------------------------------------------------------

  always @(posedge sys_clk2 or negedge n_sys_reset2)
    
    begin
      
      if (~n_sys_reset2)
        
         smc_addr2 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone2)
             3'b1xx :

               smc_addr2 <= smc_addr2;
                        //valid_access2 
             3'b01x : begin
               // Set up address for first access
               // little2-endian from max address downto2 0
               // big-endian from 0 upto2 max_address2
               smc_addr2 [31:2] <= addr [31:2];

               casez( { v_xfer_size2, v_bus_size2, 1'b0 } )

               { `XSIZ_322, `BSIZ_322, 1'b? } : smc_addr2[1:0] <= 2'b00;
               { `XSIZ_322, `BSIZ_162, 1'b0 } : smc_addr2[1:0] <= 2'b10;
               { `XSIZ_322, `BSIZ_162, 1'b1 } : smc_addr2[1:0] <= 2'b00;
               { `XSIZ_322, `BSIZ_82, 1'b0 } :  smc_addr2[1:0] <= 2'b11;
               { `XSIZ_322, `BSIZ_82, 1'b1 } :  smc_addr2[1:0] <= 2'b00;
               { `XSIZ_162, `BSIZ_322, 1'b? } : smc_addr2[1:0] <= {addr[1],1'b0};
               { `XSIZ_162, `BSIZ_162, 1'b? } : smc_addr2[1:0] <= {addr[1],1'b0};
               { `XSIZ_162, `BSIZ_82, 1'b0 } :  smc_addr2[1:0] <= {addr[1],1'b1};
               { `XSIZ_162, `BSIZ_82, 1'b1 } :  smc_addr2[1:0] <= {addr[1],1'b0};
               { `XSIZ_82, 2'b??, 1'b? } :     smc_addr2[1:0] <= addr[1:0];
               default:                       smc_addr2[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses2 fro2 subsequent2 accesses
                // little2 endian decrements2 according2 to access no.
                // bigendian2 increments2 as access no decrements2

                  smc_addr2[31:2] <= smc_addr2[31:2];
                  
               casez( { v_xfer_size2, v_bus_size2, 1'b0 } )

               { `XSIZ_322, `BSIZ_322, 1'b? } : smc_addr2[1:0] <= 2'b00;
               { `XSIZ_322, `BSIZ_162, 1'b0 } : smc_addr2[1:0] <= 2'b00;
               { `XSIZ_322, `BSIZ_162, 1'b1 } : smc_addr2[1:0] <= 2'b10;
               { `XSIZ_322, `BSIZ_82,  1'b0 } : 
                  case( r_num_access2 ) 
                  2'b11:   smc_addr2[1:0] <= 2'b10;
                  2'b10:   smc_addr2[1:0] <= 2'b01;
                  2'b01:   smc_addr2[1:0] <= 2'b00;
                  default: smc_addr2[1:0] <= 2'b11;
                  endcase
               { `XSIZ_322, `BSIZ_82, 1'b1 } :  
                  case( r_num_access2 ) 
                  2'b11:   smc_addr2[1:0] <= 2'b01;
                  2'b10:   smc_addr2[1:0] <= 2'b10;
                  2'b01:   smc_addr2[1:0] <= 2'b11;
                  default: smc_addr2[1:0] <= 2'b00;
                  endcase
               { `XSIZ_162, `BSIZ_322, 1'b? } : smc_addr2[1:0] <= {r_addr2[1],1'b0};
               { `XSIZ_162, `BSIZ_162, 1'b? } : smc_addr2[1:0] <= {r_addr2[1],1'b0};
               { `XSIZ_162, `BSIZ_82, 1'b0 } :  smc_addr2[1:0] <= {r_addr2[1],1'b0};
               { `XSIZ_162, `BSIZ_82, 1'b1 } :  smc_addr2[1:0] <= {r_addr2[1],1'b1};
               { `XSIZ_82, 2'b??, 1'b? } :     smc_addr2[1:0] <= r_addr2[1:0];
               default:                       smc_addr2[1:0] <= r_addr2[1:0];

               endcase
                 
            end
            
            default :

               smc_addr2 <= smc_addr2;
            
          endcase // casex(wait_access_smdone2)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate2 Chip2 Select2 Output2 
//----------------------------------------------------------------------

   always @(posedge sys_clk2 or negedge n_sys_reset2)
     
     begin
        
        if (~n_sys_reset2)
          
          begin
             
             smc_n_cs2 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate2 == `SMC_RW2)
          
           begin
             
              if (valid_access2)
               
                 smc_n_cs2 <= ~cs ;
             
              else
               
                 smc_n_cs2 <= ~r_cs2 ;

           end
        
        else
          
           smc_n_cs2 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch2 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk2 or negedge n_sys_reset2)
     
     begin
        
        if (~n_sys_reset2)
          
           r_addr2 <= 2'd0;
        
        
        else if (valid_access2)
          
           r_addr2 <= addr[1:0];
        
        else
          
           r_addr2 <= r_addr2;
        
     end
   


//----------------------------------------------------------------------
// Validate2 LSB of addr with valid_access2
//----------------------------------------------------------------------

   always @(r_addr2 or valid_access2 or addr)
     
      begin
        
         if (valid_access2)
           
            v_addr2 = addr[1:0];
         
         else
           
            v_addr2 = r_addr2;
         
      end
//----------------------------------------------------------------------
//cancatenation2 of signals2
//----------------------------------------------------------------------
                               //check for v_cs2 = 0
   assign ored_v_cs2 = |v_cs2;   //signal2 concatenation2 to be used in case
   
//----------------------------------------------------------------------
// Generate2 (internal) Byte2 Enables2.
//----------------------------------------------------------------------

   always @(v_cs2 or v_xfer_size2 or v_bus_size2 or v_addr2 )
     
     begin

       if ( |v_cs2 == 1'b1 ) 
        
         casez( {v_xfer_size2, v_bus_size2, 1'b0, v_addr2[1:0] } )
          
         {`XSIZ_82, `BSIZ_82, 1'b?, 2'b??} : n_be2 = 4'b1110; // Any2 on RAM2 B02
         {`XSIZ_82, `BSIZ_162,1'b0, 2'b?0} : n_be2 = 4'b1110; // B22 or B02 = RAM2 B02
         {`XSIZ_82, `BSIZ_162,1'b0, 2'b?1} : n_be2 = 4'b1101; // B32 or B12 = RAM2 B12
         {`XSIZ_82, `BSIZ_162,1'b1, 2'b?0} : n_be2 = 4'b1101; // B22 or B02 = RAM2 B12
         {`XSIZ_82, `BSIZ_162,1'b1, 2'b?1} : n_be2 = 4'b1110; // B32 or B12 = RAM2 B02
         {`XSIZ_82, `BSIZ_322,1'b0, 2'b00} : n_be2 = 4'b1110; // B02 = RAM2 B02
         {`XSIZ_82, `BSIZ_322,1'b0, 2'b01} : n_be2 = 4'b1101; // B12 = RAM2 B12
         {`XSIZ_82, `BSIZ_322,1'b0, 2'b10} : n_be2 = 4'b1011; // B22 = RAM2 B22
         {`XSIZ_82, `BSIZ_322,1'b0, 2'b11} : n_be2 = 4'b0111; // B32 = RAM2 B32
         {`XSIZ_82, `BSIZ_322,1'b1, 2'b00} : n_be2 = 4'b0111; // B02 = RAM2 B32
         {`XSIZ_82, `BSIZ_322,1'b1, 2'b01} : n_be2 = 4'b1011; // B12 = RAM2 B22
         {`XSIZ_82, `BSIZ_322,1'b1, 2'b10} : n_be2 = 4'b1101; // B22 = RAM2 B12
         {`XSIZ_82, `BSIZ_322,1'b1, 2'b11} : n_be2 = 4'b1110; // B32 = RAM2 B02
         {`XSIZ_162,`BSIZ_82, 1'b?, 2'b??} : n_be2 = 4'b1110; // Any2 on RAM2 B02
         {`XSIZ_162,`BSIZ_162,1'b?, 2'b??} : n_be2 = 4'b1100; // Any2 on RAMB102
         {`XSIZ_162,`BSIZ_322,1'b0, 2'b0?} : n_be2 = 4'b1100; // B102 = RAM2 B102
         {`XSIZ_162,`BSIZ_322,1'b0, 2'b1?} : n_be2 = 4'b0011; // B232 = RAM2 B232
         {`XSIZ_162,`BSIZ_322,1'b1, 2'b0?} : n_be2 = 4'b0011; // B102 = RAM2 B232
         {`XSIZ_162,`BSIZ_322,1'b1, 2'b1?} : n_be2 = 4'b1100; // B232 = RAM2 B102
         {`XSIZ_322,`BSIZ_82, 1'b?, 2'b??} : n_be2 = 4'b1110; // Any2 on RAM2 B02
         {`XSIZ_322,`BSIZ_162,1'b?, 2'b??} : n_be2 = 4'b1100; // Any2 on RAM2 B102
         {`XSIZ_322,`BSIZ_322,1'b?, 2'b??} : n_be2 = 4'b0000; // Any2 on RAM2 B32102
         default                         : n_be2 = 4'b1111; // Invalid2 decode
        
         
         endcase // casex(xfer_bus_size2)
        
       else

         n_be2 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate2 (enternal2) Byte2 Enables2.
//----------------------------------------------------------------------

   always @(posedge sys_clk2 or negedge n_sys_reset2)
     
     begin
        
        if (~n_sys_reset2)
          
           smc_n_be2 <= 4'hF;
        
        
        else if (smc_nextstate2 == `SMC_RW2)
          
           smc_n_be2 <= n_be2;
        
        else
          
           smc_n_be2 <= 4'hF;
        
     end
   
   
endmodule

