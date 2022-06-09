//File14 name   : smc_addr_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : This14 block registers the address and chip14 select14
//              lines14 for the current access. The address may only
//              driven14 for one cycle by the AHB14. If14 multiple
//              accesses are required14 the bottom14 two14 address bits
//              are modified between cycles14 depending14 on the current
//              transfer14 and bus size.
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

//


`include "smc_defs_lite14.v"

// address decoder14

module smc_addr_lite14    (
                    //inputs14

                    sys_clk14,
                    n_sys_reset14,
                    valid_access14,
                    r_num_access14,
                    v_bus_size14,
                    v_xfer_size14,
                    cs,
                    addr,
                    smc_done14,
                    smc_nextstate14,


                    //outputs14

                    smc_addr14,
                    smc_n_be14,
                    smc_n_cs14,
                    n_be14);



// I14/O14

   input                    sys_clk14;      //AHB14 System14 clock14
   input                    n_sys_reset14;  //AHB14 System14 reset 
   input                    valid_access14; //Start14 of new cycle
   input [1:0]              r_num_access14; //MAC14 counter
   input [1:0]              v_bus_size14;   //bus width for current access
   input [1:0]              v_xfer_size14;  //Transfer14 size for current 
                                              // access
   input               cs;           //Chip14 (Bank14) select14(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done14;     //Transfer14 complete (state 
                                              // machine14)
   input [4:0]              smc_nextstate14;//Next14 state 

   
   output [31:0]            smc_addr14;     //External14 Memory Interface14 
                                              //  address
   output [3:0]             smc_n_be14;     //EMI14 byte enables14 
   output              smc_n_cs14;     //EMI14 Chip14 Selects14 
   output [3:0]             n_be14;         //Unregistered14 Byte14 strobes14
                                             // used to genetate14 
                                             // individual14 write strobes14

// Output14 register declarations14
   
   reg [31:0]                  smc_addr14;
   reg [3:0]                   smc_n_be14;
   reg                    smc_n_cs14;
   reg [3:0]                   n_be14;
   
   
   // Internal register declarations14
   
   reg [1:0]                  r_addr14;           // Stored14 Address bits 
   reg                   r_cs14;             // Stored14 CS14
   reg [1:0]                  v_addr14;           // Validated14 Address
                                                     //  bits
   reg [7:0]                  v_cs14;             // Validated14 CS14
   
   wire                       ored_v_cs14;        //oring14 of v_sc14
   wire [4:0]                 cs_xfer_bus_size14; //concatenated14 bus and 
                                                  // xfer14 size
   wire [2:0]                 wait_access_smdone14;//concatenated14 signal14
   

// Main14 Code14
//----------------------------------------------------------------------
// Address Store14, CS14 Store14 & BE14 Store14
//----------------------------------------------------------------------

   always @(posedge sys_clk14 or negedge n_sys_reset14)
     
     begin
        
        if (~n_sys_reset14)
          
           r_cs14 <= 1'b0;
        
        
        else if (valid_access14)
          
           r_cs14 <= cs ;
        
        else
          
           r_cs14 <= r_cs14 ;
        
     end

//----------------------------------------------------------------------
//v_cs14 generation14   
//----------------------------------------------------------------------
   
   always @(cs or r_cs14 or valid_access14 )
     
     begin
        
        if (valid_access14)
          
           v_cs14 = cs ;
        
        else
          
           v_cs14 = r_cs14;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone14 = {1'b0,valid_access14,smc_done14};

//----------------------------------------------------------------------
//smc_addr14 generation14
//----------------------------------------------------------------------

  always @(posedge sys_clk14 or negedge n_sys_reset14)
    
    begin
      
      if (~n_sys_reset14)
        
         smc_addr14 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone14)
             3'b1xx :

               smc_addr14 <= smc_addr14;
                        //valid_access14 
             3'b01x : begin
               // Set up address for first access
               // little14-endian from max address downto14 0
               // big-endian from 0 upto14 max_address14
               smc_addr14 [31:2] <= addr [31:2];

               casez( { v_xfer_size14, v_bus_size14, 1'b0 } )

               { `XSIZ_3214, `BSIZ_3214, 1'b? } : smc_addr14[1:0] <= 2'b00;
               { `XSIZ_3214, `BSIZ_1614, 1'b0 } : smc_addr14[1:0] <= 2'b10;
               { `XSIZ_3214, `BSIZ_1614, 1'b1 } : smc_addr14[1:0] <= 2'b00;
               { `XSIZ_3214, `BSIZ_814, 1'b0 } :  smc_addr14[1:0] <= 2'b11;
               { `XSIZ_3214, `BSIZ_814, 1'b1 } :  smc_addr14[1:0] <= 2'b00;
               { `XSIZ_1614, `BSIZ_3214, 1'b? } : smc_addr14[1:0] <= {addr[1],1'b0};
               { `XSIZ_1614, `BSIZ_1614, 1'b? } : smc_addr14[1:0] <= {addr[1],1'b0};
               { `XSIZ_1614, `BSIZ_814, 1'b0 } :  smc_addr14[1:0] <= {addr[1],1'b1};
               { `XSIZ_1614, `BSIZ_814, 1'b1 } :  smc_addr14[1:0] <= {addr[1],1'b0};
               { `XSIZ_814, 2'b??, 1'b? } :     smc_addr14[1:0] <= addr[1:0];
               default:                       smc_addr14[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses14 fro14 subsequent14 accesses
                // little14 endian decrements14 according14 to access no.
                // bigendian14 increments14 as access no decrements14

                  smc_addr14[31:2] <= smc_addr14[31:2];
                  
               casez( { v_xfer_size14, v_bus_size14, 1'b0 } )

               { `XSIZ_3214, `BSIZ_3214, 1'b? } : smc_addr14[1:0] <= 2'b00;
               { `XSIZ_3214, `BSIZ_1614, 1'b0 } : smc_addr14[1:0] <= 2'b00;
               { `XSIZ_3214, `BSIZ_1614, 1'b1 } : smc_addr14[1:0] <= 2'b10;
               { `XSIZ_3214, `BSIZ_814,  1'b0 } : 
                  case( r_num_access14 ) 
                  2'b11:   smc_addr14[1:0] <= 2'b10;
                  2'b10:   smc_addr14[1:0] <= 2'b01;
                  2'b01:   smc_addr14[1:0] <= 2'b00;
                  default: smc_addr14[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3214, `BSIZ_814, 1'b1 } :  
                  case( r_num_access14 ) 
                  2'b11:   smc_addr14[1:0] <= 2'b01;
                  2'b10:   smc_addr14[1:0] <= 2'b10;
                  2'b01:   smc_addr14[1:0] <= 2'b11;
                  default: smc_addr14[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1614, `BSIZ_3214, 1'b? } : smc_addr14[1:0] <= {r_addr14[1],1'b0};
               { `XSIZ_1614, `BSIZ_1614, 1'b? } : smc_addr14[1:0] <= {r_addr14[1],1'b0};
               { `XSIZ_1614, `BSIZ_814, 1'b0 } :  smc_addr14[1:0] <= {r_addr14[1],1'b0};
               { `XSIZ_1614, `BSIZ_814, 1'b1 } :  smc_addr14[1:0] <= {r_addr14[1],1'b1};
               { `XSIZ_814, 2'b??, 1'b? } :     smc_addr14[1:0] <= r_addr14[1:0];
               default:                       smc_addr14[1:0] <= r_addr14[1:0];

               endcase
                 
            end
            
            default :

               smc_addr14 <= smc_addr14;
            
          endcase // casex(wait_access_smdone14)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate14 Chip14 Select14 Output14 
//----------------------------------------------------------------------

   always @(posedge sys_clk14 or negedge n_sys_reset14)
     
     begin
        
        if (~n_sys_reset14)
          
          begin
             
             smc_n_cs14 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate14 == `SMC_RW14)
          
           begin
             
              if (valid_access14)
               
                 smc_n_cs14 <= ~cs ;
             
              else
               
                 smc_n_cs14 <= ~r_cs14 ;

           end
        
        else
          
           smc_n_cs14 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch14 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk14 or negedge n_sys_reset14)
     
     begin
        
        if (~n_sys_reset14)
          
           r_addr14 <= 2'd0;
        
        
        else if (valid_access14)
          
           r_addr14 <= addr[1:0];
        
        else
          
           r_addr14 <= r_addr14;
        
     end
   


//----------------------------------------------------------------------
// Validate14 LSB of addr with valid_access14
//----------------------------------------------------------------------

   always @(r_addr14 or valid_access14 or addr)
     
      begin
        
         if (valid_access14)
           
            v_addr14 = addr[1:0];
         
         else
           
            v_addr14 = r_addr14;
         
      end
//----------------------------------------------------------------------
//cancatenation14 of signals14
//----------------------------------------------------------------------
                               //check for v_cs14 = 0
   assign ored_v_cs14 = |v_cs14;   //signal14 concatenation14 to be used in case
   
//----------------------------------------------------------------------
// Generate14 (internal) Byte14 Enables14.
//----------------------------------------------------------------------

   always @(v_cs14 or v_xfer_size14 or v_bus_size14 or v_addr14 )
     
     begin

       if ( |v_cs14 == 1'b1 ) 
        
         casez( {v_xfer_size14, v_bus_size14, 1'b0, v_addr14[1:0] } )
          
         {`XSIZ_814, `BSIZ_814, 1'b?, 2'b??} : n_be14 = 4'b1110; // Any14 on RAM14 B014
         {`XSIZ_814, `BSIZ_1614,1'b0, 2'b?0} : n_be14 = 4'b1110; // B214 or B014 = RAM14 B014
         {`XSIZ_814, `BSIZ_1614,1'b0, 2'b?1} : n_be14 = 4'b1101; // B314 or B114 = RAM14 B114
         {`XSIZ_814, `BSIZ_1614,1'b1, 2'b?0} : n_be14 = 4'b1101; // B214 or B014 = RAM14 B114
         {`XSIZ_814, `BSIZ_1614,1'b1, 2'b?1} : n_be14 = 4'b1110; // B314 or B114 = RAM14 B014
         {`XSIZ_814, `BSIZ_3214,1'b0, 2'b00} : n_be14 = 4'b1110; // B014 = RAM14 B014
         {`XSIZ_814, `BSIZ_3214,1'b0, 2'b01} : n_be14 = 4'b1101; // B114 = RAM14 B114
         {`XSIZ_814, `BSIZ_3214,1'b0, 2'b10} : n_be14 = 4'b1011; // B214 = RAM14 B214
         {`XSIZ_814, `BSIZ_3214,1'b0, 2'b11} : n_be14 = 4'b0111; // B314 = RAM14 B314
         {`XSIZ_814, `BSIZ_3214,1'b1, 2'b00} : n_be14 = 4'b0111; // B014 = RAM14 B314
         {`XSIZ_814, `BSIZ_3214,1'b1, 2'b01} : n_be14 = 4'b1011; // B114 = RAM14 B214
         {`XSIZ_814, `BSIZ_3214,1'b1, 2'b10} : n_be14 = 4'b1101; // B214 = RAM14 B114
         {`XSIZ_814, `BSIZ_3214,1'b1, 2'b11} : n_be14 = 4'b1110; // B314 = RAM14 B014
         {`XSIZ_1614,`BSIZ_814, 1'b?, 2'b??} : n_be14 = 4'b1110; // Any14 on RAM14 B014
         {`XSIZ_1614,`BSIZ_1614,1'b?, 2'b??} : n_be14 = 4'b1100; // Any14 on RAMB1014
         {`XSIZ_1614,`BSIZ_3214,1'b0, 2'b0?} : n_be14 = 4'b1100; // B1014 = RAM14 B1014
         {`XSIZ_1614,`BSIZ_3214,1'b0, 2'b1?} : n_be14 = 4'b0011; // B2314 = RAM14 B2314
         {`XSIZ_1614,`BSIZ_3214,1'b1, 2'b0?} : n_be14 = 4'b0011; // B1014 = RAM14 B2314
         {`XSIZ_1614,`BSIZ_3214,1'b1, 2'b1?} : n_be14 = 4'b1100; // B2314 = RAM14 B1014
         {`XSIZ_3214,`BSIZ_814, 1'b?, 2'b??} : n_be14 = 4'b1110; // Any14 on RAM14 B014
         {`XSIZ_3214,`BSIZ_1614,1'b?, 2'b??} : n_be14 = 4'b1100; // Any14 on RAM14 B1014
         {`XSIZ_3214,`BSIZ_3214,1'b?, 2'b??} : n_be14 = 4'b0000; // Any14 on RAM14 B321014
         default                         : n_be14 = 4'b1111; // Invalid14 decode
        
         
         endcase // casex(xfer_bus_size14)
        
       else

         n_be14 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate14 (enternal14) Byte14 Enables14.
//----------------------------------------------------------------------

   always @(posedge sys_clk14 or negedge n_sys_reset14)
     
     begin
        
        if (~n_sys_reset14)
          
           smc_n_be14 <= 4'hF;
        
        
        else if (smc_nextstate14 == `SMC_RW14)
          
           smc_n_be14 <= n_be14;
        
        else
          
           smc_n_be14 <= 4'hF;
        
     end
   
   
endmodule

