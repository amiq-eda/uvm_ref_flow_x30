//File23 name   : smc_addr_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : This23 block registers the address and chip23 select23
//              lines23 for the current access. The address may only
//              driven23 for one cycle by the AHB23. If23 multiple
//              accesses are required23 the bottom23 two23 address bits
//              are modified between cycles23 depending23 on the current
//              transfer23 and bus size.
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

//


`include "smc_defs_lite23.v"

// address decoder23

module smc_addr_lite23    (
                    //inputs23

                    sys_clk23,
                    n_sys_reset23,
                    valid_access23,
                    r_num_access23,
                    v_bus_size23,
                    v_xfer_size23,
                    cs,
                    addr,
                    smc_done23,
                    smc_nextstate23,


                    //outputs23

                    smc_addr23,
                    smc_n_be23,
                    smc_n_cs23,
                    n_be23);



// I23/O23

   input                    sys_clk23;      //AHB23 System23 clock23
   input                    n_sys_reset23;  //AHB23 System23 reset 
   input                    valid_access23; //Start23 of new cycle
   input [1:0]              r_num_access23; //MAC23 counter
   input [1:0]              v_bus_size23;   //bus width for current access
   input [1:0]              v_xfer_size23;  //Transfer23 size for current 
                                              // access
   input               cs;           //Chip23 (Bank23) select23(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done23;     //Transfer23 complete (state 
                                              // machine23)
   input [4:0]              smc_nextstate23;//Next23 state 

   
   output [31:0]            smc_addr23;     //External23 Memory Interface23 
                                              //  address
   output [3:0]             smc_n_be23;     //EMI23 byte enables23 
   output              smc_n_cs23;     //EMI23 Chip23 Selects23 
   output [3:0]             n_be23;         //Unregistered23 Byte23 strobes23
                                             // used to genetate23 
                                             // individual23 write strobes23

// Output23 register declarations23
   
   reg [31:0]                  smc_addr23;
   reg [3:0]                   smc_n_be23;
   reg                    smc_n_cs23;
   reg [3:0]                   n_be23;
   
   
   // Internal register declarations23
   
   reg [1:0]                  r_addr23;           // Stored23 Address bits 
   reg                   r_cs23;             // Stored23 CS23
   reg [1:0]                  v_addr23;           // Validated23 Address
                                                     //  bits
   reg [7:0]                  v_cs23;             // Validated23 CS23
   
   wire                       ored_v_cs23;        //oring23 of v_sc23
   wire [4:0]                 cs_xfer_bus_size23; //concatenated23 bus and 
                                                  // xfer23 size
   wire [2:0]                 wait_access_smdone23;//concatenated23 signal23
   

// Main23 Code23
//----------------------------------------------------------------------
// Address Store23, CS23 Store23 & BE23 Store23
//----------------------------------------------------------------------

   always @(posedge sys_clk23 or negedge n_sys_reset23)
     
     begin
        
        if (~n_sys_reset23)
          
           r_cs23 <= 1'b0;
        
        
        else if (valid_access23)
          
           r_cs23 <= cs ;
        
        else
          
           r_cs23 <= r_cs23 ;
        
     end

//----------------------------------------------------------------------
//v_cs23 generation23   
//----------------------------------------------------------------------
   
   always @(cs or r_cs23 or valid_access23 )
     
     begin
        
        if (valid_access23)
          
           v_cs23 = cs ;
        
        else
          
           v_cs23 = r_cs23;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone23 = {1'b0,valid_access23,smc_done23};

//----------------------------------------------------------------------
//smc_addr23 generation23
//----------------------------------------------------------------------

  always @(posedge sys_clk23 or negedge n_sys_reset23)
    
    begin
      
      if (~n_sys_reset23)
        
         smc_addr23 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone23)
             3'b1xx :

               smc_addr23 <= smc_addr23;
                        //valid_access23 
             3'b01x : begin
               // Set up address for first access
               // little23-endian from max address downto23 0
               // big-endian from 0 upto23 max_address23
               smc_addr23 [31:2] <= addr [31:2];

               casez( { v_xfer_size23, v_bus_size23, 1'b0 } )

               { `XSIZ_3223, `BSIZ_3223, 1'b? } : smc_addr23[1:0] <= 2'b00;
               { `XSIZ_3223, `BSIZ_1623, 1'b0 } : smc_addr23[1:0] <= 2'b10;
               { `XSIZ_3223, `BSIZ_1623, 1'b1 } : smc_addr23[1:0] <= 2'b00;
               { `XSIZ_3223, `BSIZ_823, 1'b0 } :  smc_addr23[1:0] <= 2'b11;
               { `XSIZ_3223, `BSIZ_823, 1'b1 } :  smc_addr23[1:0] <= 2'b00;
               { `XSIZ_1623, `BSIZ_3223, 1'b? } : smc_addr23[1:0] <= {addr[1],1'b0};
               { `XSIZ_1623, `BSIZ_1623, 1'b? } : smc_addr23[1:0] <= {addr[1],1'b0};
               { `XSIZ_1623, `BSIZ_823, 1'b0 } :  smc_addr23[1:0] <= {addr[1],1'b1};
               { `XSIZ_1623, `BSIZ_823, 1'b1 } :  smc_addr23[1:0] <= {addr[1],1'b0};
               { `XSIZ_823, 2'b??, 1'b? } :     smc_addr23[1:0] <= addr[1:0];
               default:                       smc_addr23[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses23 fro23 subsequent23 accesses
                // little23 endian decrements23 according23 to access no.
                // bigendian23 increments23 as access no decrements23

                  smc_addr23[31:2] <= smc_addr23[31:2];
                  
               casez( { v_xfer_size23, v_bus_size23, 1'b0 } )

               { `XSIZ_3223, `BSIZ_3223, 1'b? } : smc_addr23[1:0] <= 2'b00;
               { `XSIZ_3223, `BSIZ_1623, 1'b0 } : smc_addr23[1:0] <= 2'b00;
               { `XSIZ_3223, `BSIZ_1623, 1'b1 } : smc_addr23[1:0] <= 2'b10;
               { `XSIZ_3223, `BSIZ_823,  1'b0 } : 
                  case( r_num_access23 ) 
                  2'b11:   smc_addr23[1:0] <= 2'b10;
                  2'b10:   smc_addr23[1:0] <= 2'b01;
                  2'b01:   smc_addr23[1:0] <= 2'b00;
                  default: smc_addr23[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3223, `BSIZ_823, 1'b1 } :  
                  case( r_num_access23 ) 
                  2'b11:   smc_addr23[1:0] <= 2'b01;
                  2'b10:   smc_addr23[1:0] <= 2'b10;
                  2'b01:   smc_addr23[1:0] <= 2'b11;
                  default: smc_addr23[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1623, `BSIZ_3223, 1'b? } : smc_addr23[1:0] <= {r_addr23[1],1'b0};
               { `XSIZ_1623, `BSIZ_1623, 1'b? } : smc_addr23[1:0] <= {r_addr23[1],1'b0};
               { `XSIZ_1623, `BSIZ_823, 1'b0 } :  smc_addr23[1:0] <= {r_addr23[1],1'b0};
               { `XSIZ_1623, `BSIZ_823, 1'b1 } :  smc_addr23[1:0] <= {r_addr23[1],1'b1};
               { `XSIZ_823, 2'b??, 1'b? } :     smc_addr23[1:0] <= r_addr23[1:0];
               default:                       smc_addr23[1:0] <= r_addr23[1:0];

               endcase
                 
            end
            
            default :

               smc_addr23 <= smc_addr23;
            
          endcase // casex(wait_access_smdone23)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate23 Chip23 Select23 Output23 
//----------------------------------------------------------------------

   always @(posedge sys_clk23 or negedge n_sys_reset23)
     
     begin
        
        if (~n_sys_reset23)
          
          begin
             
             smc_n_cs23 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate23 == `SMC_RW23)
          
           begin
             
              if (valid_access23)
               
                 smc_n_cs23 <= ~cs ;
             
              else
               
                 smc_n_cs23 <= ~r_cs23 ;

           end
        
        else
          
           smc_n_cs23 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch23 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk23 or negedge n_sys_reset23)
     
     begin
        
        if (~n_sys_reset23)
          
           r_addr23 <= 2'd0;
        
        
        else if (valid_access23)
          
           r_addr23 <= addr[1:0];
        
        else
          
           r_addr23 <= r_addr23;
        
     end
   


//----------------------------------------------------------------------
// Validate23 LSB of addr with valid_access23
//----------------------------------------------------------------------

   always @(r_addr23 or valid_access23 or addr)
     
      begin
        
         if (valid_access23)
           
            v_addr23 = addr[1:0];
         
         else
           
            v_addr23 = r_addr23;
         
      end
//----------------------------------------------------------------------
//cancatenation23 of signals23
//----------------------------------------------------------------------
                               //check for v_cs23 = 0
   assign ored_v_cs23 = |v_cs23;   //signal23 concatenation23 to be used in case
   
//----------------------------------------------------------------------
// Generate23 (internal) Byte23 Enables23.
//----------------------------------------------------------------------

   always @(v_cs23 or v_xfer_size23 or v_bus_size23 or v_addr23 )
     
     begin

       if ( |v_cs23 == 1'b1 ) 
        
         casez( {v_xfer_size23, v_bus_size23, 1'b0, v_addr23[1:0] } )
          
         {`XSIZ_823, `BSIZ_823, 1'b?, 2'b??} : n_be23 = 4'b1110; // Any23 on RAM23 B023
         {`XSIZ_823, `BSIZ_1623,1'b0, 2'b?0} : n_be23 = 4'b1110; // B223 or B023 = RAM23 B023
         {`XSIZ_823, `BSIZ_1623,1'b0, 2'b?1} : n_be23 = 4'b1101; // B323 or B123 = RAM23 B123
         {`XSIZ_823, `BSIZ_1623,1'b1, 2'b?0} : n_be23 = 4'b1101; // B223 or B023 = RAM23 B123
         {`XSIZ_823, `BSIZ_1623,1'b1, 2'b?1} : n_be23 = 4'b1110; // B323 or B123 = RAM23 B023
         {`XSIZ_823, `BSIZ_3223,1'b0, 2'b00} : n_be23 = 4'b1110; // B023 = RAM23 B023
         {`XSIZ_823, `BSIZ_3223,1'b0, 2'b01} : n_be23 = 4'b1101; // B123 = RAM23 B123
         {`XSIZ_823, `BSIZ_3223,1'b0, 2'b10} : n_be23 = 4'b1011; // B223 = RAM23 B223
         {`XSIZ_823, `BSIZ_3223,1'b0, 2'b11} : n_be23 = 4'b0111; // B323 = RAM23 B323
         {`XSIZ_823, `BSIZ_3223,1'b1, 2'b00} : n_be23 = 4'b0111; // B023 = RAM23 B323
         {`XSIZ_823, `BSIZ_3223,1'b1, 2'b01} : n_be23 = 4'b1011; // B123 = RAM23 B223
         {`XSIZ_823, `BSIZ_3223,1'b1, 2'b10} : n_be23 = 4'b1101; // B223 = RAM23 B123
         {`XSIZ_823, `BSIZ_3223,1'b1, 2'b11} : n_be23 = 4'b1110; // B323 = RAM23 B023
         {`XSIZ_1623,`BSIZ_823, 1'b?, 2'b??} : n_be23 = 4'b1110; // Any23 on RAM23 B023
         {`XSIZ_1623,`BSIZ_1623,1'b?, 2'b??} : n_be23 = 4'b1100; // Any23 on RAMB1023
         {`XSIZ_1623,`BSIZ_3223,1'b0, 2'b0?} : n_be23 = 4'b1100; // B1023 = RAM23 B1023
         {`XSIZ_1623,`BSIZ_3223,1'b0, 2'b1?} : n_be23 = 4'b0011; // B2323 = RAM23 B2323
         {`XSIZ_1623,`BSIZ_3223,1'b1, 2'b0?} : n_be23 = 4'b0011; // B1023 = RAM23 B2323
         {`XSIZ_1623,`BSIZ_3223,1'b1, 2'b1?} : n_be23 = 4'b1100; // B2323 = RAM23 B1023
         {`XSIZ_3223,`BSIZ_823, 1'b?, 2'b??} : n_be23 = 4'b1110; // Any23 on RAM23 B023
         {`XSIZ_3223,`BSIZ_1623,1'b?, 2'b??} : n_be23 = 4'b1100; // Any23 on RAM23 B1023
         {`XSIZ_3223,`BSIZ_3223,1'b?, 2'b??} : n_be23 = 4'b0000; // Any23 on RAM23 B321023
         default                         : n_be23 = 4'b1111; // Invalid23 decode
        
         
         endcase // casex(xfer_bus_size23)
        
       else

         n_be23 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate23 (enternal23) Byte23 Enables23.
//----------------------------------------------------------------------

   always @(posedge sys_clk23 or negedge n_sys_reset23)
     
     begin
        
        if (~n_sys_reset23)
          
           smc_n_be23 <= 4'hF;
        
        
        else if (smc_nextstate23 == `SMC_RW23)
          
           smc_n_be23 <= n_be23;
        
        else
          
           smc_n_be23 <= 4'hF;
        
     end
   
   
endmodule

