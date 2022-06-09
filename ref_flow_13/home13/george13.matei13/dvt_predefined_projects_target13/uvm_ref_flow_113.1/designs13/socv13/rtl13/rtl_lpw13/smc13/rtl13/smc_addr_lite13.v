//File13 name   : smc_addr_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : This13 block registers the address and chip13 select13
//              lines13 for the current access. The address may only
//              driven13 for one cycle by the AHB13. If13 multiple
//              accesses are required13 the bottom13 two13 address bits
//              are modified between cycles13 depending13 on the current
//              transfer13 and bus size.
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

//


`include "smc_defs_lite13.v"

// address decoder13

module smc_addr_lite13    (
                    //inputs13

                    sys_clk13,
                    n_sys_reset13,
                    valid_access13,
                    r_num_access13,
                    v_bus_size13,
                    v_xfer_size13,
                    cs,
                    addr,
                    smc_done13,
                    smc_nextstate13,


                    //outputs13

                    smc_addr13,
                    smc_n_be13,
                    smc_n_cs13,
                    n_be13);



// I13/O13

   input                    sys_clk13;      //AHB13 System13 clock13
   input                    n_sys_reset13;  //AHB13 System13 reset 
   input                    valid_access13; //Start13 of new cycle
   input [1:0]              r_num_access13; //MAC13 counter
   input [1:0]              v_bus_size13;   //bus width for current access
   input [1:0]              v_xfer_size13;  //Transfer13 size for current 
                                              // access
   input               cs;           //Chip13 (Bank13) select13(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done13;     //Transfer13 complete (state 
                                              // machine13)
   input [4:0]              smc_nextstate13;//Next13 state 

   
   output [31:0]            smc_addr13;     //External13 Memory Interface13 
                                              //  address
   output [3:0]             smc_n_be13;     //EMI13 byte enables13 
   output              smc_n_cs13;     //EMI13 Chip13 Selects13 
   output [3:0]             n_be13;         //Unregistered13 Byte13 strobes13
                                             // used to genetate13 
                                             // individual13 write strobes13

// Output13 register declarations13
   
   reg [31:0]                  smc_addr13;
   reg [3:0]                   smc_n_be13;
   reg                    smc_n_cs13;
   reg [3:0]                   n_be13;
   
   
   // Internal register declarations13
   
   reg [1:0]                  r_addr13;           // Stored13 Address bits 
   reg                   r_cs13;             // Stored13 CS13
   reg [1:0]                  v_addr13;           // Validated13 Address
                                                     //  bits
   reg [7:0]                  v_cs13;             // Validated13 CS13
   
   wire                       ored_v_cs13;        //oring13 of v_sc13
   wire [4:0]                 cs_xfer_bus_size13; //concatenated13 bus and 
                                                  // xfer13 size
   wire [2:0]                 wait_access_smdone13;//concatenated13 signal13
   

// Main13 Code13
//----------------------------------------------------------------------
// Address Store13, CS13 Store13 & BE13 Store13
//----------------------------------------------------------------------

   always @(posedge sys_clk13 or negedge n_sys_reset13)
     
     begin
        
        if (~n_sys_reset13)
          
           r_cs13 <= 1'b0;
        
        
        else if (valid_access13)
          
           r_cs13 <= cs ;
        
        else
          
           r_cs13 <= r_cs13 ;
        
     end

//----------------------------------------------------------------------
//v_cs13 generation13   
//----------------------------------------------------------------------
   
   always @(cs or r_cs13 or valid_access13 )
     
     begin
        
        if (valid_access13)
          
           v_cs13 = cs ;
        
        else
          
           v_cs13 = r_cs13;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone13 = {1'b0,valid_access13,smc_done13};

//----------------------------------------------------------------------
//smc_addr13 generation13
//----------------------------------------------------------------------

  always @(posedge sys_clk13 or negedge n_sys_reset13)
    
    begin
      
      if (~n_sys_reset13)
        
         smc_addr13 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone13)
             3'b1xx :

               smc_addr13 <= smc_addr13;
                        //valid_access13 
             3'b01x : begin
               // Set up address for first access
               // little13-endian from max address downto13 0
               // big-endian from 0 upto13 max_address13
               smc_addr13 [31:2] <= addr [31:2];

               casez( { v_xfer_size13, v_bus_size13, 1'b0 } )

               { `XSIZ_3213, `BSIZ_3213, 1'b? } : smc_addr13[1:0] <= 2'b00;
               { `XSIZ_3213, `BSIZ_1613, 1'b0 } : smc_addr13[1:0] <= 2'b10;
               { `XSIZ_3213, `BSIZ_1613, 1'b1 } : smc_addr13[1:0] <= 2'b00;
               { `XSIZ_3213, `BSIZ_813, 1'b0 } :  smc_addr13[1:0] <= 2'b11;
               { `XSIZ_3213, `BSIZ_813, 1'b1 } :  smc_addr13[1:0] <= 2'b00;
               { `XSIZ_1613, `BSIZ_3213, 1'b? } : smc_addr13[1:0] <= {addr[1],1'b0};
               { `XSIZ_1613, `BSIZ_1613, 1'b? } : smc_addr13[1:0] <= {addr[1],1'b0};
               { `XSIZ_1613, `BSIZ_813, 1'b0 } :  smc_addr13[1:0] <= {addr[1],1'b1};
               { `XSIZ_1613, `BSIZ_813, 1'b1 } :  smc_addr13[1:0] <= {addr[1],1'b0};
               { `XSIZ_813, 2'b??, 1'b? } :     smc_addr13[1:0] <= addr[1:0];
               default:                       smc_addr13[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses13 fro13 subsequent13 accesses
                // little13 endian decrements13 according13 to access no.
                // bigendian13 increments13 as access no decrements13

                  smc_addr13[31:2] <= smc_addr13[31:2];
                  
               casez( { v_xfer_size13, v_bus_size13, 1'b0 } )

               { `XSIZ_3213, `BSIZ_3213, 1'b? } : smc_addr13[1:0] <= 2'b00;
               { `XSIZ_3213, `BSIZ_1613, 1'b0 } : smc_addr13[1:0] <= 2'b00;
               { `XSIZ_3213, `BSIZ_1613, 1'b1 } : smc_addr13[1:0] <= 2'b10;
               { `XSIZ_3213, `BSIZ_813,  1'b0 } : 
                  case( r_num_access13 ) 
                  2'b11:   smc_addr13[1:0] <= 2'b10;
                  2'b10:   smc_addr13[1:0] <= 2'b01;
                  2'b01:   smc_addr13[1:0] <= 2'b00;
                  default: smc_addr13[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3213, `BSIZ_813, 1'b1 } :  
                  case( r_num_access13 ) 
                  2'b11:   smc_addr13[1:0] <= 2'b01;
                  2'b10:   smc_addr13[1:0] <= 2'b10;
                  2'b01:   smc_addr13[1:0] <= 2'b11;
                  default: smc_addr13[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1613, `BSIZ_3213, 1'b? } : smc_addr13[1:0] <= {r_addr13[1],1'b0};
               { `XSIZ_1613, `BSIZ_1613, 1'b? } : smc_addr13[1:0] <= {r_addr13[1],1'b0};
               { `XSIZ_1613, `BSIZ_813, 1'b0 } :  smc_addr13[1:0] <= {r_addr13[1],1'b0};
               { `XSIZ_1613, `BSIZ_813, 1'b1 } :  smc_addr13[1:0] <= {r_addr13[1],1'b1};
               { `XSIZ_813, 2'b??, 1'b? } :     smc_addr13[1:0] <= r_addr13[1:0];
               default:                       smc_addr13[1:0] <= r_addr13[1:0];

               endcase
                 
            end
            
            default :

               smc_addr13 <= smc_addr13;
            
          endcase // casex(wait_access_smdone13)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate13 Chip13 Select13 Output13 
//----------------------------------------------------------------------

   always @(posedge sys_clk13 or negedge n_sys_reset13)
     
     begin
        
        if (~n_sys_reset13)
          
          begin
             
             smc_n_cs13 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate13 == `SMC_RW13)
          
           begin
             
              if (valid_access13)
               
                 smc_n_cs13 <= ~cs ;
             
              else
               
                 smc_n_cs13 <= ~r_cs13 ;

           end
        
        else
          
           smc_n_cs13 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch13 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk13 or negedge n_sys_reset13)
     
     begin
        
        if (~n_sys_reset13)
          
           r_addr13 <= 2'd0;
        
        
        else if (valid_access13)
          
           r_addr13 <= addr[1:0];
        
        else
          
           r_addr13 <= r_addr13;
        
     end
   


//----------------------------------------------------------------------
// Validate13 LSB of addr with valid_access13
//----------------------------------------------------------------------

   always @(r_addr13 or valid_access13 or addr)
     
      begin
        
         if (valid_access13)
           
            v_addr13 = addr[1:0];
         
         else
           
            v_addr13 = r_addr13;
         
      end
//----------------------------------------------------------------------
//cancatenation13 of signals13
//----------------------------------------------------------------------
                               //check for v_cs13 = 0
   assign ored_v_cs13 = |v_cs13;   //signal13 concatenation13 to be used in case
   
//----------------------------------------------------------------------
// Generate13 (internal) Byte13 Enables13.
//----------------------------------------------------------------------

   always @(v_cs13 or v_xfer_size13 or v_bus_size13 or v_addr13 )
     
     begin

       if ( |v_cs13 == 1'b1 ) 
        
         casez( {v_xfer_size13, v_bus_size13, 1'b0, v_addr13[1:0] } )
          
         {`XSIZ_813, `BSIZ_813, 1'b?, 2'b??} : n_be13 = 4'b1110; // Any13 on RAM13 B013
         {`XSIZ_813, `BSIZ_1613,1'b0, 2'b?0} : n_be13 = 4'b1110; // B213 or B013 = RAM13 B013
         {`XSIZ_813, `BSIZ_1613,1'b0, 2'b?1} : n_be13 = 4'b1101; // B313 or B113 = RAM13 B113
         {`XSIZ_813, `BSIZ_1613,1'b1, 2'b?0} : n_be13 = 4'b1101; // B213 or B013 = RAM13 B113
         {`XSIZ_813, `BSIZ_1613,1'b1, 2'b?1} : n_be13 = 4'b1110; // B313 or B113 = RAM13 B013
         {`XSIZ_813, `BSIZ_3213,1'b0, 2'b00} : n_be13 = 4'b1110; // B013 = RAM13 B013
         {`XSIZ_813, `BSIZ_3213,1'b0, 2'b01} : n_be13 = 4'b1101; // B113 = RAM13 B113
         {`XSIZ_813, `BSIZ_3213,1'b0, 2'b10} : n_be13 = 4'b1011; // B213 = RAM13 B213
         {`XSIZ_813, `BSIZ_3213,1'b0, 2'b11} : n_be13 = 4'b0111; // B313 = RAM13 B313
         {`XSIZ_813, `BSIZ_3213,1'b1, 2'b00} : n_be13 = 4'b0111; // B013 = RAM13 B313
         {`XSIZ_813, `BSIZ_3213,1'b1, 2'b01} : n_be13 = 4'b1011; // B113 = RAM13 B213
         {`XSIZ_813, `BSIZ_3213,1'b1, 2'b10} : n_be13 = 4'b1101; // B213 = RAM13 B113
         {`XSIZ_813, `BSIZ_3213,1'b1, 2'b11} : n_be13 = 4'b1110; // B313 = RAM13 B013
         {`XSIZ_1613,`BSIZ_813, 1'b?, 2'b??} : n_be13 = 4'b1110; // Any13 on RAM13 B013
         {`XSIZ_1613,`BSIZ_1613,1'b?, 2'b??} : n_be13 = 4'b1100; // Any13 on RAMB1013
         {`XSIZ_1613,`BSIZ_3213,1'b0, 2'b0?} : n_be13 = 4'b1100; // B1013 = RAM13 B1013
         {`XSIZ_1613,`BSIZ_3213,1'b0, 2'b1?} : n_be13 = 4'b0011; // B2313 = RAM13 B2313
         {`XSIZ_1613,`BSIZ_3213,1'b1, 2'b0?} : n_be13 = 4'b0011; // B1013 = RAM13 B2313
         {`XSIZ_1613,`BSIZ_3213,1'b1, 2'b1?} : n_be13 = 4'b1100; // B2313 = RAM13 B1013
         {`XSIZ_3213,`BSIZ_813, 1'b?, 2'b??} : n_be13 = 4'b1110; // Any13 on RAM13 B013
         {`XSIZ_3213,`BSIZ_1613,1'b?, 2'b??} : n_be13 = 4'b1100; // Any13 on RAM13 B1013
         {`XSIZ_3213,`BSIZ_3213,1'b?, 2'b??} : n_be13 = 4'b0000; // Any13 on RAM13 B321013
         default                         : n_be13 = 4'b1111; // Invalid13 decode
        
         
         endcase // casex(xfer_bus_size13)
        
       else

         n_be13 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate13 (enternal13) Byte13 Enables13.
//----------------------------------------------------------------------

   always @(posedge sys_clk13 or negedge n_sys_reset13)
     
     begin
        
        if (~n_sys_reset13)
          
           smc_n_be13 <= 4'hF;
        
        
        else if (smc_nextstate13 == `SMC_RW13)
          
           smc_n_be13 <= n_be13;
        
        else
          
           smc_n_be13 <= 4'hF;
        
     end
   
   
endmodule

