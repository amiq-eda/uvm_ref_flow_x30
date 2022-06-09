//File26 name   : smc_addr_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : This26 block registers the address and chip26 select26
//              lines26 for the current access. The address may only
//              driven26 for one cycle by the AHB26. If26 multiple
//              accesses are required26 the bottom26 two26 address bits
//              are modified between cycles26 depending26 on the current
//              transfer26 and bus size.
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

//


`include "smc_defs_lite26.v"

// address decoder26

module smc_addr_lite26    (
                    //inputs26

                    sys_clk26,
                    n_sys_reset26,
                    valid_access26,
                    r_num_access26,
                    v_bus_size26,
                    v_xfer_size26,
                    cs,
                    addr,
                    smc_done26,
                    smc_nextstate26,


                    //outputs26

                    smc_addr26,
                    smc_n_be26,
                    smc_n_cs26,
                    n_be26);



// I26/O26

   input                    sys_clk26;      //AHB26 System26 clock26
   input                    n_sys_reset26;  //AHB26 System26 reset 
   input                    valid_access26; //Start26 of new cycle
   input [1:0]              r_num_access26; //MAC26 counter
   input [1:0]              v_bus_size26;   //bus width for current access
   input [1:0]              v_xfer_size26;  //Transfer26 size for current 
                                              // access
   input               cs;           //Chip26 (Bank26) select26(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done26;     //Transfer26 complete (state 
                                              // machine26)
   input [4:0]              smc_nextstate26;//Next26 state 

   
   output [31:0]            smc_addr26;     //External26 Memory Interface26 
                                              //  address
   output [3:0]             smc_n_be26;     //EMI26 byte enables26 
   output              smc_n_cs26;     //EMI26 Chip26 Selects26 
   output [3:0]             n_be26;         //Unregistered26 Byte26 strobes26
                                             // used to genetate26 
                                             // individual26 write strobes26

// Output26 register declarations26
   
   reg [31:0]                  smc_addr26;
   reg [3:0]                   smc_n_be26;
   reg                    smc_n_cs26;
   reg [3:0]                   n_be26;
   
   
   // Internal register declarations26
   
   reg [1:0]                  r_addr26;           // Stored26 Address bits 
   reg                   r_cs26;             // Stored26 CS26
   reg [1:0]                  v_addr26;           // Validated26 Address
                                                     //  bits
   reg [7:0]                  v_cs26;             // Validated26 CS26
   
   wire                       ored_v_cs26;        //oring26 of v_sc26
   wire [4:0]                 cs_xfer_bus_size26; //concatenated26 bus and 
                                                  // xfer26 size
   wire [2:0]                 wait_access_smdone26;//concatenated26 signal26
   

// Main26 Code26
//----------------------------------------------------------------------
// Address Store26, CS26 Store26 & BE26 Store26
//----------------------------------------------------------------------

   always @(posedge sys_clk26 or negedge n_sys_reset26)
     
     begin
        
        if (~n_sys_reset26)
          
           r_cs26 <= 1'b0;
        
        
        else if (valid_access26)
          
           r_cs26 <= cs ;
        
        else
          
           r_cs26 <= r_cs26 ;
        
     end

//----------------------------------------------------------------------
//v_cs26 generation26   
//----------------------------------------------------------------------
   
   always @(cs or r_cs26 or valid_access26 )
     
     begin
        
        if (valid_access26)
          
           v_cs26 = cs ;
        
        else
          
           v_cs26 = r_cs26;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone26 = {1'b0,valid_access26,smc_done26};

//----------------------------------------------------------------------
//smc_addr26 generation26
//----------------------------------------------------------------------

  always @(posedge sys_clk26 or negedge n_sys_reset26)
    
    begin
      
      if (~n_sys_reset26)
        
         smc_addr26 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone26)
             3'b1xx :

               smc_addr26 <= smc_addr26;
                        //valid_access26 
             3'b01x : begin
               // Set up address for first access
               // little26-endian from max address downto26 0
               // big-endian from 0 upto26 max_address26
               smc_addr26 [31:2] <= addr [31:2];

               casez( { v_xfer_size26, v_bus_size26, 1'b0 } )

               { `XSIZ_3226, `BSIZ_3226, 1'b? } : smc_addr26[1:0] <= 2'b00;
               { `XSIZ_3226, `BSIZ_1626, 1'b0 } : smc_addr26[1:0] <= 2'b10;
               { `XSIZ_3226, `BSIZ_1626, 1'b1 } : smc_addr26[1:0] <= 2'b00;
               { `XSIZ_3226, `BSIZ_826, 1'b0 } :  smc_addr26[1:0] <= 2'b11;
               { `XSIZ_3226, `BSIZ_826, 1'b1 } :  smc_addr26[1:0] <= 2'b00;
               { `XSIZ_1626, `BSIZ_3226, 1'b? } : smc_addr26[1:0] <= {addr[1],1'b0};
               { `XSIZ_1626, `BSIZ_1626, 1'b? } : smc_addr26[1:0] <= {addr[1],1'b0};
               { `XSIZ_1626, `BSIZ_826, 1'b0 } :  smc_addr26[1:0] <= {addr[1],1'b1};
               { `XSIZ_1626, `BSIZ_826, 1'b1 } :  smc_addr26[1:0] <= {addr[1],1'b0};
               { `XSIZ_826, 2'b??, 1'b? } :     smc_addr26[1:0] <= addr[1:0];
               default:                       smc_addr26[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses26 fro26 subsequent26 accesses
                // little26 endian decrements26 according26 to access no.
                // bigendian26 increments26 as access no decrements26

                  smc_addr26[31:2] <= smc_addr26[31:2];
                  
               casez( { v_xfer_size26, v_bus_size26, 1'b0 } )

               { `XSIZ_3226, `BSIZ_3226, 1'b? } : smc_addr26[1:0] <= 2'b00;
               { `XSIZ_3226, `BSIZ_1626, 1'b0 } : smc_addr26[1:0] <= 2'b00;
               { `XSIZ_3226, `BSIZ_1626, 1'b1 } : smc_addr26[1:0] <= 2'b10;
               { `XSIZ_3226, `BSIZ_826,  1'b0 } : 
                  case( r_num_access26 ) 
                  2'b11:   smc_addr26[1:0] <= 2'b10;
                  2'b10:   smc_addr26[1:0] <= 2'b01;
                  2'b01:   smc_addr26[1:0] <= 2'b00;
                  default: smc_addr26[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3226, `BSIZ_826, 1'b1 } :  
                  case( r_num_access26 ) 
                  2'b11:   smc_addr26[1:0] <= 2'b01;
                  2'b10:   smc_addr26[1:0] <= 2'b10;
                  2'b01:   smc_addr26[1:0] <= 2'b11;
                  default: smc_addr26[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1626, `BSIZ_3226, 1'b? } : smc_addr26[1:0] <= {r_addr26[1],1'b0};
               { `XSIZ_1626, `BSIZ_1626, 1'b? } : smc_addr26[1:0] <= {r_addr26[1],1'b0};
               { `XSIZ_1626, `BSIZ_826, 1'b0 } :  smc_addr26[1:0] <= {r_addr26[1],1'b0};
               { `XSIZ_1626, `BSIZ_826, 1'b1 } :  smc_addr26[1:0] <= {r_addr26[1],1'b1};
               { `XSIZ_826, 2'b??, 1'b? } :     smc_addr26[1:0] <= r_addr26[1:0];
               default:                       smc_addr26[1:0] <= r_addr26[1:0];

               endcase
                 
            end
            
            default :

               smc_addr26 <= smc_addr26;
            
          endcase // casex(wait_access_smdone26)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate26 Chip26 Select26 Output26 
//----------------------------------------------------------------------

   always @(posedge sys_clk26 or negedge n_sys_reset26)
     
     begin
        
        if (~n_sys_reset26)
          
          begin
             
             smc_n_cs26 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate26 == `SMC_RW26)
          
           begin
             
              if (valid_access26)
               
                 smc_n_cs26 <= ~cs ;
             
              else
               
                 smc_n_cs26 <= ~r_cs26 ;

           end
        
        else
          
           smc_n_cs26 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch26 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk26 or negedge n_sys_reset26)
     
     begin
        
        if (~n_sys_reset26)
          
           r_addr26 <= 2'd0;
        
        
        else if (valid_access26)
          
           r_addr26 <= addr[1:0];
        
        else
          
           r_addr26 <= r_addr26;
        
     end
   


//----------------------------------------------------------------------
// Validate26 LSB of addr with valid_access26
//----------------------------------------------------------------------

   always @(r_addr26 or valid_access26 or addr)
     
      begin
        
         if (valid_access26)
           
            v_addr26 = addr[1:0];
         
         else
           
            v_addr26 = r_addr26;
         
      end
//----------------------------------------------------------------------
//cancatenation26 of signals26
//----------------------------------------------------------------------
                               //check for v_cs26 = 0
   assign ored_v_cs26 = |v_cs26;   //signal26 concatenation26 to be used in case
   
//----------------------------------------------------------------------
// Generate26 (internal) Byte26 Enables26.
//----------------------------------------------------------------------

   always @(v_cs26 or v_xfer_size26 or v_bus_size26 or v_addr26 )
     
     begin

       if ( |v_cs26 == 1'b1 ) 
        
         casez( {v_xfer_size26, v_bus_size26, 1'b0, v_addr26[1:0] } )
          
         {`XSIZ_826, `BSIZ_826, 1'b?, 2'b??} : n_be26 = 4'b1110; // Any26 on RAM26 B026
         {`XSIZ_826, `BSIZ_1626,1'b0, 2'b?0} : n_be26 = 4'b1110; // B226 or B026 = RAM26 B026
         {`XSIZ_826, `BSIZ_1626,1'b0, 2'b?1} : n_be26 = 4'b1101; // B326 or B126 = RAM26 B126
         {`XSIZ_826, `BSIZ_1626,1'b1, 2'b?0} : n_be26 = 4'b1101; // B226 or B026 = RAM26 B126
         {`XSIZ_826, `BSIZ_1626,1'b1, 2'b?1} : n_be26 = 4'b1110; // B326 or B126 = RAM26 B026
         {`XSIZ_826, `BSIZ_3226,1'b0, 2'b00} : n_be26 = 4'b1110; // B026 = RAM26 B026
         {`XSIZ_826, `BSIZ_3226,1'b0, 2'b01} : n_be26 = 4'b1101; // B126 = RAM26 B126
         {`XSIZ_826, `BSIZ_3226,1'b0, 2'b10} : n_be26 = 4'b1011; // B226 = RAM26 B226
         {`XSIZ_826, `BSIZ_3226,1'b0, 2'b11} : n_be26 = 4'b0111; // B326 = RAM26 B326
         {`XSIZ_826, `BSIZ_3226,1'b1, 2'b00} : n_be26 = 4'b0111; // B026 = RAM26 B326
         {`XSIZ_826, `BSIZ_3226,1'b1, 2'b01} : n_be26 = 4'b1011; // B126 = RAM26 B226
         {`XSIZ_826, `BSIZ_3226,1'b1, 2'b10} : n_be26 = 4'b1101; // B226 = RAM26 B126
         {`XSIZ_826, `BSIZ_3226,1'b1, 2'b11} : n_be26 = 4'b1110; // B326 = RAM26 B026
         {`XSIZ_1626,`BSIZ_826, 1'b?, 2'b??} : n_be26 = 4'b1110; // Any26 on RAM26 B026
         {`XSIZ_1626,`BSIZ_1626,1'b?, 2'b??} : n_be26 = 4'b1100; // Any26 on RAMB1026
         {`XSIZ_1626,`BSIZ_3226,1'b0, 2'b0?} : n_be26 = 4'b1100; // B1026 = RAM26 B1026
         {`XSIZ_1626,`BSIZ_3226,1'b0, 2'b1?} : n_be26 = 4'b0011; // B2326 = RAM26 B2326
         {`XSIZ_1626,`BSIZ_3226,1'b1, 2'b0?} : n_be26 = 4'b0011; // B1026 = RAM26 B2326
         {`XSIZ_1626,`BSIZ_3226,1'b1, 2'b1?} : n_be26 = 4'b1100; // B2326 = RAM26 B1026
         {`XSIZ_3226,`BSIZ_826, 1'b?, 2'b??} : n_be26 = 4'b1110; // Any26 on RAM26 B026
         {`XSIZ_3226,`BSIZ_1626,1'b?, 2'b??} : n_be26 = 4'b1100; // Any26 on RAM26 B1026
         {`XSIZ_3226,`BSIZ_3226,1'b?, 2'b??} : n_be26 = 4'b0000; // Any26 on RAM26 B321026
         default                         : n_be26 = 4'b1111; // Invalid26 decode
        
         
         endcase // casex(xfer_bus_size26)
        
       else

         n_be26 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate26 (enternal26) Byte26 Enables26.
//----------------------------------------------------------------------

   always @(posedge sys_clk26 or negedge n_sys_reset26)
     
     begin
        
        if (~n_sys_reset26)
          
           smc_n_be26 <= 4'hF;
        
        
        else if (smc_nextstate26 == `SMC_RW26)
          
           smc_n_be26 <= n_be26;
        
        else
          
           smc_n_be26 <= 4'hF;
        
     end
   
   
endmodule

