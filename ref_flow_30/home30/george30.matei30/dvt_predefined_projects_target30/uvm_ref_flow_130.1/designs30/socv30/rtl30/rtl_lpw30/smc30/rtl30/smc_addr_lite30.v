//File30 name   : smc_addr_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : This30 block registers the address and chip30 select30
//              lines30 for the current access. The address may only
//              driven30 for one cycle by the AHB30. If30 multiple
//              accesses are required30 the bottom30 two30 address bits
//              are modified between cycles30 depending30 on the current
//              transfer30 and bus size.
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

//


`include "smc_defs_lite30.v"

// address decoder30

module smc_addr_lite30    (
                    //inputs30

                    sys_clk30,
                    n_sys_reset30,
                    valid_access30,
                    r_num_access30,
                    v_bus_size30,
                    v_xfer_size30,
                    cs,
                    addr,
                    smc_done30,
                    smc_nextstate30,


                    //outputs30

                    smc_addr30,
                    smc_n_be30,
                    smc_n_cs30,
                    n_be30);



// I30/O30

   input                    sys_clk30;      //AHB30 System30 clock30
   input                    n_sys_reset30;  //AHB30 System30 reset 
   input                    valid_access30; //Start30 of new cycle
   input [1:0]              r_num_access30; //MAC30 counter
   input [1:0]              v_bus_size30;   //bus width for current access
   input [1:0]              v_xfer_size30;  //Transfer30 size for current 
                                              // access
   input               cs;           //Chip30 (Bank30) select30(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done30;     //Transfer30 complete (state 
                                              // machine30)
   input [4:0]              smc_nextstate30;//Next30 state 

   
   output [31:0]            smc_addr30;     //External30 Memory Interface30 
                                              //  address
   output [3:0]             smc_n_be30;     //EMI30 byte enables30 
   output              smc_n_cs30;     //EMI30 Chip30 Selects30 
   output [3:0]             n_be30;         //Unregistered30 Byte30 strobes30
                                             // used to genetate30 
                                             // individual30 write strobes30

// Output30 register declarations30
   
   reg [31:0]                  smc_addr30;
   reg [3:0]                   smc_n_be30;
   reg                    smc_n_cs30;
   reg [3:0]                   n_be30;
   
   
   // Internal register declarations30
   
   reg [1:0]                  r_addr30;           // Stored30 Address bits 
   reg                   r_cs30;             // Stored30 CS30
   reg [1:0]                  v_addr30;           // Validated30 Address
                                                     //  bits
   reg [7:0]                  v_cs30;             // Validated30 CS30
   
   wire                       ored_v_cs30;        //oring30 of v_sc30
   wire [4:0]                 cs_xfer_bus_size30; //concatenated30 bus and 
                                                  // xfer30 size
   wire [2:0]                 wait_access_smdone30;//concatenated30 signal30
   

// Main30 Code30
//----------------------------------------------------------------------
// Address Store30, CS30 Store30 & BE30 Store30
//----------------------------------------------------------------------

   always @(posedge sys_clk30 or negedge n_sys_reset30)
     
     begin
        
        if (~n_sys_reset30)
          
           r_cs30 <= 1'b0;
        
        
        else if (valid_access30)
          
           r_cs30 <= cs ;
        
        else
          
           r_cs30 <= r_cs30 ;
        
     end

//----------------------------------------------------------------------
//v_cs30 generation30   
//----------------------------------------------------------------------
   
   always @(cs or r_cs30 or valid_access30 )
     
     begin
        
        if (valid_access30)
          
           v_cs30 = cs ;
        
        else
          
           v_cs30 = r_cs30;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone30 = {1'b0,valid_access30,smc_done30};

//----------------------------------------------------------------------
//smc_addr30 generation30
//----------------------------------------------------------------------

  always @(posedge sys_clk30 or negedge n_sys_reset30)
    
    begin
      
      if (~n_sys_reset30)
        
         smc_addr30 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone30)
             3'b1xx :

               smc_addr30 <= smc_addr30;
                        //valid_access30 
             3'b01x : begin
               // Set up address for first access
               // little30-endian from max address downto30 0
               // big-endian from 0 upto30 max_address30
               smc_addr30 [31:2] <= addr [31:2];

               casez( { v_xfer_size30, v_bus_size30, 1'b0 } )

               { `XSIZ_3230, `BSIZ_3230, 1'b? } : smc_addr30[1:0] <= 2'b00;
               { `XSIZ_3230, `BSIZ_1630, 1'b0 } : smc_addr30[1:0] <= 2'b10;
               { `XSIZ_3230, `BSIZ_1630, 1'b1 } : smc_addr30[1:0] <= 2'b00;
               { `XSIZ_3230, `BSIZ_830, 1'b0 } :  smc_addr30[1:0] <= 2'b11;
               { `XSIZ_3230, `BSIZ_830, 1'b1 } :  smc_addr30[1:0] <= 2'b00;
               { `XSIZ_1630, `BSIZ_3230, 1'b? } : smc_addr30[1:0] <= {addr[1],1'b0};
               { `XSIZ_1630, `BSIZ_1630, 1'b? } : smc_addr30[1:0] <= {addr[1],1'b0};
               { `XSIZ_1630, `BSIZ_830, 1'b0 } :  smc_addr30[1:0] <= {addr[1],1'b1};
               { `XSIZ_1630, `BSIZ_830, 1'b1 } :  smc_addr30[1:0] <= {addr[1],1'b0};
               { `XSIZ_830, 2'b??, 1'b? } :     smc_addr30[1:0] <= addr[1:0];
               default:                       smc_addr30[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses30 fro30 subsequent30 accesses
                // little30 endian decrements30 according30 to access no.
                // bigendian30 increments30 as access no decrements30

                  smc_addr30[31:2] <= smc_addr30[31:2];
                  
               casez( { v_xfer_size30, v_bus_size30, 1'b0 } )

               { `XSIZ_3230, `BSIZ_3230, 1'b? } : smc_addr30[1:0] <= 2'b00;
               { `XSIZ_3230, `BSIZ_1630, 1'b0 } : smc_addr30[1:0] <= 2'b00;
               { `XSIZ_3230, `BSIZ_1630, 1'b1 } : smc_addr30[1:0] <= 2'b10;
               { `XSIZ_3230, `BSIZ_830,  1'b0 } : 
                  case( r_num_access30 ) 
                  2'b11:   smc_addr30[1:0] <= 2'b10;
                  2'b10:   smc_addr30[1:0] <= 2'b01;
                  2'b01:   smc_addr30[1:0] <= 2'b00;
                  default: smc_addr30[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3230, `BSIZ_830, 1'b1 } :  
                  case( r_num_access30 ) 
                  2'b11:   smc_addr30[1:0] <= 2'b01;
                  2'b10:   smc_addr30[1:0] <= 2'b10;
                  2'b01:   smc_addr30[1:0] <= 2'b11;
                  default: smc_addr30[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1630, `BSIZ_3230, 1'b? } : smc_addr30[1:0] <= {r_addr30[1],1'b0};
               { `XSIZ_1630, `BSIZ_1630, 1'b? } : smc_addr30[1:0] <= {r_addr30[1],1'b0};
               { `XSIZ_1630, `BSIZ_830, 1'b0 } :  smc_addr30[1:0] <= {r_addr30[1],1'b0};
               { `XSIZ_1630, `BSIZ_830, 1'b1 } :  smc_addr30[1:0] <= {r_addr30[1],1'b1};
               { `XSIZ_830, 2'b??, 1'b? } :     smc_addr30[1:0] <= r_addr30[1:0];
               default:                       smc_addr30[1:0] <= r_addr30[1:0];

               endcase
                 
            end
            
            default :

               smc_addr30 <= smc_addr30;
            
          endcase // casex(wait_access_smdone30)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate30 Chip30 Select30 Output30 
//----------------------------------------------------------------------

   always @(posedge sys_clk30 or negedge n_sys_reset30)
     
     begin
        
        if (~n_sys_reset30)
          
          begin
             
             smc_n_cs30 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate30 == `SMC_RW30)
          
           begin
             
              if (valid_access30)
               
                 smc_n_cs30 <= ~cs ;
             
              else
               
                 smc_n_cs30 <= ~r_cs30 ;

           end
        
        else
          
           smc_n_cs30 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch30 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk30 or negedge n_sys_reset30)
     
     begin
        
        if (~n_sys_reset30)
          
           r_addr30 <= 2'd0;
        
        
        else if (valid_access30)
          
           r_addr30 <= addr[1:0];
        
        else
          
           r_addr30 <= r_addr30;
        
     end
   


//----------------------------------------------------------------------
// Validate30 LSB of addr with valid_access30
//----------------------------------------------------------------------

   always @(r_addr30 or valid_access30 or addr)
     
      begin
        
         if (valid_access30)
           
            v_addr30 = addr[1:0];
         
         else
           
            v_addr30 = r_addr30;
         
      end
//----------------------------------------------------------------------
//cancatenation30 of signals30
//----------------------------------------------------------------------
                               //check for v_cs30 = 0
   assign ored_v_cs30 = |v_cs30;   //signal30 concatenation30 to be used in case
   
//----------------------------------------------------------------------
// Generate30 (internal) Byte30 Enables30.
//----------------------------------------------------------------------

   always @(v_cs30 or v_xfer_size30 or v_bus_size30 or v_addr30 )
     
     begin

       if ( |v_cs30 == 1'b1 ) 
        
         casez( {v_xfer_size30, v_bus_size30, 1'b0, v_addr30[1:0] } )
          
         {`XSIZ_830, `BSIZ_830, 1'b?, 2'b??} : n_be30 = 4'b1110; // Any30 on RAM30 B030
         {`XSIZ_830, `BSIZ_1630,1'b0, 2'b?0} : n_be30 = 4'b1110; // B230 or B030 = RAM30 B030
         {`XSIZ_830, `BSIZ_1630,1'b0, 2'b?1} : n_be30 = 4'b1101; // B330 or B130 = RAM30 B130
         {`XSIZ_830, `BSIZ_1630,1'b1, 2'b?0} : n_be30 = 4'b1101; // B230 or B030 = RAM30 B130
         {`XSIZ_830, `BSIZ_1630,1'b1, 2'b?1} : n_be30 = 4'b1110; // B330 or B130 = RAM30 B030
         {`XSIZ_830, `BSIZ_3230,1'b0, 2'b00} : n_be30 = 4'b1110; // B030 = RAM30 B030
         {`XSIZ_830, `BSIZ_3230,1'b0, 2'b01} : n_be30 = 4'b1101; // B130 = RAM30 B130
         {`XSIZ_830, `BSIZ_3230,1'b0, 2'b10} : n_be30 = 4'b1011; // B230 = RAM30 B230
         {`XSIZ_830, `BSIZ_3230,1'b0, 2'b11} : n_be30 = 4'b0111; // B330 = RAM30 B330
         {`XSIZ_830, `BSIZ_3230,1'b1, 2'b00} : n_be30 = 4'b0111; // B030 = RAM30 B330
         {`XSIZ_830, `BSIZ_3230,1'b1, 2'b01} : n_be30 = 4'b1011; // B130 = RAM30 B230
         {`XSIZ_830, `BSIZ_3230,1'b1, 2'b10} : n_be30 = 4'b1101; // B230 = RAM30 B130
         {`XSIZ_830, `BSIZ_3230,1'b1, 2'b11} : n_be30 = 4'b1110; // B330 = RAM30 B030
         {`XSIZ_1630,`BSIZ_830, 1'b?, 2'b??} : n_be30 = 4'b1110; // Any30 on RAM30 B030
         {`XSIZ_1630,`BSIZ_1630,1'b?, 2'b??} : n_be30 = 4'b1100; // Any30 on RAMB1030
         {`XSIZ_1630,`BSIZ_3230,1'b0, 2'b0?} : n_be30 = 4'b1100; // B1030 = RAM30 B1030
         {`XSIZ_1630,`BSIZ_3230,1'b0, 2'b1?} : n_be30 = 4'b0011; // B2330 = RAM30 B2330
         {`XSIZ_1630,`BSIZ_3230,1'b1, 2'b0?} : n_be30 = 4'b0011; // B1030 = RAM30 B2330
         {`XSIZ_1630,`BSIZ_3230,1'b1, 2'b1?} : n_be30 = 4'b1100; // B2330 = RAM30 B1030
         {`XSIZ_3230,`BSIZ_830, 1'b?, 2'b??} : n_be30 = 4'b1110; // Any30 on RAM30 B030
         {`XSIZ_3230,`BSIZ_1630,1'b?, 2'b??} : n_be30 = 4'b1100; // Any30 on RAM30 B1030
         {`XSIZ_3230,`BSIZ_3230,1'b?, 2'b??} : n_be30 = 4'b0000; // Any30 on RAM30 B321030
         default                         : n_be30 = 4'b1111; // Invalid30 decode
        
         
         endcase // casex(xfer_bus_size30)
        
       else

         n_be30 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate30 (enternal30) Byte30 Enables30.
//----------------------------------------------------------------------

   always @(posedge sys_clk30 or negedge n_sys_reset30)
     
     begin
        
        if (~n_sys_reset30)
          
           smc_n_be30 <= 4'hF;
        
        
        else if (smc_nextstate30 == `SMC_RW30)
          
           smc_n_be30 <= n_be30;
        
        else
          
           smc_n_be30 <= 4'hF;
        
     end
   
   
endmodule

