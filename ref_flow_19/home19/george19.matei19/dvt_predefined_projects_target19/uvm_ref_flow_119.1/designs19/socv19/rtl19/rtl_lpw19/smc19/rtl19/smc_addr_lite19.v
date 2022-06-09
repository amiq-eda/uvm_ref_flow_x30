//File19 name   : smc_addr_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : This19 block registers the address and chip19 select19
//              lines19 for the current access. The address may only
//              driven19 for one cycle by the AHB19. If19 multiple
//              accesses are required19 the bottom19 two19 address bits
//              are modified between cycles19 depending19 on the current
//              transfer19 and bus size.
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

//


`include "smc_defs_lite19.v"

// address decoder19

module smc_addr_lite19    (
                    //inputs19

                    sys_clk19,
                    n_sys_reset19,
                    valid_access19,
                    r_num_access19,
                    v_bus_size19,
                    v_xfer_size19,
                    cs,
                    addr,
                    smc_done19,
                    smc_nextstate19,


                    //outputs19

                    smc_addr19,
                    smc_n_be19,
                    smc_n_cs19,
                    n_be19);



// I19/O19

   input                    sys_clk19;      //AHB19 System19 clock19
   input                    n_sys_reset19;  //AHB19 System19 reset 
   input                    valid_access19; //Start19 of new cycle
   input [1:0]              r_num_access19; //MAC19 counter
   input [1:0]              v_bus_size19;   //bus width for current access
   input [1:0]              v_xfer_size19;  //Transfer19 size for current 
                                              // access
   input               cs;           //Chip19 (Bank19) select19(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done19;     //Transfer19 complete (state 
                                              // machine19)
   input [4:0]              smc_nextstate19;//Next19 state 

   
   output [31:0]            smc_addr19;     //External19 Memory Interface19 
                                              //  address
   output [3:0]             smc_n_be19;     //EMI19 byte enables19 
   output              smc_n_cs19;     //EMI19 Chip19 Selects19 
   output [3:0]             n_be19;         //Unregistered19 Byte19 strobes19
                                             // used to genetate19 
                                             // individual19 write strobes19

// Output19 register declarations19
   
   reg [31:0]                  smc_addr19;
   reg [3:0]                   smc_n_be19;
   reg                    smc_n_cs19;
   reg [3:0]                   n_be19;
   
   
   // Internal register declarations19
   
   reg [1:0]                  r_addr19;           // Stored19 Address bits 
   reg                   r_cs19;             // Stored19 CS19
   reg [1:0]                  v_addr19;           // Validated19 Address
                                                     //  bits
   reg [7:0]                  v_cs19;             // Validated19 CS19
   
   wire                       ored_v_cs19;        //oring19 of v_sc19
   wire [4:0]                 cs_xfer_bus_size19; //concatenated19 bus and 
                                                  // xfer19 size
   wire [2:0]                 wait_access_smdone19;//concatenated19 signal19
   

// Main19 Code19
//----------------------------------------------------------------------
// Address Store19, CS19 Store19 & BE19 Store19
//----------------------------------------------------------------------

   always @(posedge sys_clk19 or negedge n_sys_reset19)
     
     begin
        
        if (~n_sys_reset19)
          
           r_cs19 <= 1'b0;
        
        
        else if (valid_access19)
          
           r_cs19 <= cs ;
        
        else
          
           r_cs19 <= r_cs19 ;
        
     end

//----------------------------------------------------------------------
//v_cs19 generation19   
//----------------------------------------------------------------------
   
   always @(cs or r_cs19 or valid_access19 )
     
     begin
        
        if (valid_access19)
          
           v_cs19 = cs ;
        
        else
          
           v_cs19 = r_cs19;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone19 = {1'b0,valid_access19,smc_done19};

//----------------------------------------------------------------------
//smc_addr19 generation19
//----------------------------------------------------------------------

  always @(posedge sys_clk19 or negedge n_sys_reset19)
    
    begin
      
      if (~n_sys_reset19)
        
         smc_addr19 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone19)
             3'b1xx :

               smc_addr19 <= smc_addr19;
                        //valid_access19 
             3'b01x : begin
               // Set up address for first access
               // little19-endian from max address downto19 0
               // big-endian from 0 upto19 max_address19
               smc_addr19 [31:2] <= addr [31:2];

               casez( { v_xfer_size19, v_bus_size19, 1'b0 } )

               { `XSIZ_3219, `BSIZ_3219, 1'b? } : smc_addr19[1:0] <= 2'b00;
               { `XSIZ_3219, `BSIZ_1619, 1'b0 } : smc_addr19[1:0] <= 2'b10;
               { `XSIZ_3219, `BSIZ_1619, 1'b1 } : smc_addr19[1:0] <= 2'b00;
               { `XSIZ_3219, `BSIZ_819, 1'b0 } :  smc_addr19[1:0] <= 2'b11;
               { `XSIZ_3219, `BSIZ_819, 1'b1 } :  smc_addr19[1:0] <= 2'b00;
               { `XSIZ_1619, `BSIZ_3219, 1'b? } : smc_addr19[1:0] <= {addr[1],1'b0};
               { `XSIZ_1619, `BSIZ_1619, 1'b? } : smc_addr19[1:0] <= {addr[1],1'b0};
               { `XSIZ_1619, `BSIZ_819, 1'b0 } :  smc_addr19[1:0] <= {addr[1],1'b1};
               { `XSIZ_1619, `BSIZ_819, 1'b1 } :  smc_addr19[1:0] <= {addr[1],1'b0};
               { `XSIZ_819, 2'b??, 1'b? } :     smc_addr19[1:0] <= addr[1:0];
               default:                       smc_addr19[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses19 fro19 subsequent19 accesses
                // little19 endian decrements19 according19 to access no.
                // bigendian19 increments19 as access no decrements19

                  smc_addr19[31:2] <= smc_addr19[31:2];
                  
               casez( { v_xfer_size19, v_bus_size19, 1'b0 } )

               { `XSIZ_3219, `BSIZ_3219, 1'b? } : smc_addr19[1:0] <= 2'b00;
               { `XSIZ_3219, `BSIZ_1619, 1'b0 } : smc_addr19[1:0] <= 2'b00;
               { `XSIZ_3219, `BSIZ_1619, 1'b1 } : smc_addr19[1:0] <= 2'b10;
               { `XSIZ_3219, `BSIZ_819,  1'b0 } : 
                  case( r_num_access19 ) 
                  2'b11:   smc_addr19[1:0] <= 2'b10;
                  2'b10:   smc_addr19[1:0] <= 2'b01;
                  2'b01:   smc_addr19[1:0] <= 2'b00;
                  default: smc_addr19[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3219, `BSIZ_819, 1'b1 } :  
                  case( r_num_access19 ) 
                  2'b11:   smc_addr19[1:0] <= 2'b01;
                  2'b10:   smc_addr19[1:0] <= 2'b10;
                  2'b01:   smc_addr19[1:0] <= 2'b11;
                  default: smc_addr19[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1619, `BSIZ_3219, 1'b? } : smc_addr19[1:0] <= {r_addr19[1],1'b0};
               { `XSIZ_1619, `BSIZ_1619, 1'b? } : smc_addr19[1:0] <= {r_addr19[1],1'b0};
               { `XSIZ_1619, `BSIZ_819, 1'b0 } :  smc_addr19[1:0] <= {r_addr19[1],1'b0};
               { `XSIZ_1619, `BSIZ_819, 1'b1 } :  smc_addr19[1:0] <= {r_addr19[1],1'b1};
               { `XSIZ_819, 2'b??, 1'b? } :     smc_addr19[1:0] <= r_addr19[1:0];
               default:                       smc_addr19[1:0] <= r_addr19[1:0];

               endcase
                 
            end
            
            default :

               smc_addr19 <= smc_addr19;
            
          endcase // casex(wait_access_smdone19)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate19 Chip19 Select19 Output19 
//----------------------------------------------------------------------

   always @(posedge sys_clk19 or negedge n_sys_reset19)
     
     begin
        
        if (~n_sys_reset19)
          
          begin
             
             smc_n_cs19 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate19 == `SMC_RW19)
          
           begin
             
              if (valid_access19)
               
                 smc_n_cs19 <= ~cs ;
             
              else
               
                 smc_n_cs19 <= ~r_cs19 ;

           end
        
        else
          
           smc_n_cs19 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch19 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk19 or negedge n_sys_reset19)
     
     begin
        
        if (~n_sys_reset19)
          
           r_addr19 <= 2'd0;
        
        
        else if (valid_access19)
          
           r_addr19 <= addr[1:0];
        
        else
          
           r_addr19 <= r_addr19;
        
     end
   


//----------------------------------------------------------------------
// Validate19 LSB of addr with valid_access19
//----------------------------------------------------------------------

   always @(r_addr19 or valid_access19 or addr)
     
      begin
        
         if (valid_access19)
           
            v_addr19 = addr[1:0];
         
         else
           
            v_addr19 = r_addr19;
         
      end
//----------------------------------------------------------------------
//cancatenation19 of signals19
//----------------------------------------------------------------------
                               //check for v_cs19 = 0
   assign ored_v_cs19 = |v_cs19;   //signal19 concatenation19 to be used in case
   
//----------------------------------------------------------------------
// Generate19 (internal) Byte19 Enables19.
//----------------------------------------------------------------------

   always @(v_cs19 or v_xfer_size19 or v_bus_size19 or v_addr19 )
     
     begin

       if ( |v_cs19 == 1'b1 ) 
        
         casez( {v_xfer_size19, v_bus_size19, 1'b0, v_addr19[1:0] } )
          
         {`XSIZ_819, `BSIZ_819, 1'b?, 2'b??} : n_be19 = 4'b1110; // Any19 on RAM19 B019
         {`XSIZ_819, `BSIZ_1619,1'b0, 2'b?0} : n_be19 = 4'b1110; // B219 or B019 = RAM19 B019
         {`XSIZ_819, `BSIZ_1619,1'b0, 2'b?1} : n_be19 = 4'b1101; // B319 or B119 = RAM19 B119
         {`XSIZ_819, `BSIZ_1619,1'b1, 2'b?0} : n_be19 = 4'b1101; // B219 or B019 = RAM19 B119
         {`XSIZ_819, `BSIZ_1619,1'b1, 2'b?1} : n_be19 = 4'b1110; // B319 or B119 = RAM19 B019
         {`XSIZ_819, `BSIZ_3219,1'b0, 2'b00} : n_be19 = 4'b1110; // B019 = RAM19 B019
         {`XSIZ_819, `BSIZ_3219,1'b0, 2'b01} : n_be19 = 4'b1101; // B119 = RAM19 B119
         {`XSIZ_819, `BSIZ_3219,1'b0, 2'b10} : n_be19 = 4'b1011; // B219 = RAM19 B219
         {`XSIZ_819, `BSIZ_3219,1'b0, 2'b11} : n_be19 = 4'b0111; // B319 = RAM19 B319
         {`XSIZ_819, `BSIZ_3219,1'b1, 2'b00} : n_be19 = 4'b0111; // B019 = RAM19 B319
         {`XSIZ_819, `BSIZ_3219,1'b1, 2'b01} : n_be19 = 4'b1011; // B119 = RAM19 B219
         {`XSIZ_819, `BSIZ_3219,1'b1, 2'b10} : n_be19 = 4'b1101; // B219 = RAM19 B119
         {`XSIZ_819, `BSIZ_3219,1'b1, 2'b11} : n_be19 = 4'b1110; // B319 = RAM19 B019
         {`XSIZ_1619,`BSIZ_819, 1'b?, 2'b??} : n_be19 = 4'b1110; // Any19 on RAM19 B019
         {`XSIZ_1619,`BSIZ_1619,1'b?, 2'b??} : n_be19 = 4'b1100; // Any19 on RAMB1019
         {`XSIZ_1619,`BSIZ_3219,1'b0, 2'b0?} : n_be19 = 4'b1100; // B1019 = RAM19 B1019
         {`XSIZ_1619,`BSIZ_3219,1'b0, 2'b1?} : n_be19 = 4'b0011; // B2319 = RAM19 B2319
         {`XSIZ_1619,`BSIZ_3219,1'b1, 2'b0?} : n_be19 = 4'b0011; // B1019 = RAM19 B2319
         {`XSIZ_1619,`BSIZ_3219,1'b1, 2'b1?} : n_be19 = 4'b1100; // B2319 = RAM19 B1019
         {`XSIZ_3219,`BSIZ_819, 1'b?, 2'b??} : n_be19 = 4'b1110; // Any19 on RAM19 B019
         {`XSIZ_3219,`BSIZ_1619,1'b?, 2'b??} : n_be19 = 4'b1100; // Any19 on RAM19 B1019
         {`XSIZ_3219,`BSIZ_3219,1'b?, 2'b??} : n_be19 = 4'b0000; // Any19 on RAM19 B321019
         default                         : n_be19 = 4'b1111; // Invalid19 decode
        
         
         endcase // casex(xfer_bus_size19)
        
       else

         n_be19 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate19 (enternal19) Byte19 Enables19.
//----------------------------------------------------------------------

   always @(posedge sys_clk19 or negedge n_sys_reset19)
     
     begin
        
        if (~n_sys_reset19)
          
           smc_n_be19 <= 4'hF;
        
        
        else if (smc_nextstate19 == `SMC_RW19)
          
           smc_n_be19 <= n_be19;
        
        else
          
           smc_n_be19 <= 4'hF;
        
     end
   
   
endmodule

