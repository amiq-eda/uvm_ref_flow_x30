//File7 name   : smc_addr_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : This7 block registers the address and chip7 select7
//              lines7 for the current access. The address may only
//              driven7 for one cycle by the AHB7. If7 multiple
//              accesses are required7 the bottom7 two7 address bits
//              are modified between cycles7 depending7 on the current
//              transfer7 and bus size.
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

//


`include "smc_defs_lite7.v"

// address decoder7

module smc_addr_lite7    (
                    //inputs7

                    sys_clk7,
                    n_sys_reset7,
                    valid_access7,
                    r_num_access7,
                    v_bus_size7,
                    v_xfer_size7,
                    cs,
                    addr,
                    smc_done7,
                    smc_nextstate7,


                    //outputs7

                    smc_addr7,
                    smc_n_be7,
                    smc_n_cs7,
                    n_be7);



// I7/O7

   input                    sys_clk7;      //AHB7 System7 clock7
   input                    n_sys_reset7;  //AHB7 System7 reset 
   input                    valid_access7; //Start7 of new cycle
   input [1:0]              r_num_access7; //MAC7 counter
   input [1:0]              v_bus_size7;   //bus width for current access
   input [1:0]              v_xfer_size7;  //Transfer7 size for current 
                                              // access
   input               cs;           //Chip7 (Bank7) select7(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done7;     //Transfer7 complete (state 
                                              // machine7)
   input [4:0]              smc_nextstate7;//Next7 state 

   
   output [31:0]            smc_addr7;     //External7 Memory Interface7 
                                              //  address
   output [3:0]             smc_n_be7;     //EMI7 byte enables7 
   output              smc_n_cs7;     //EMI7 Chip7 Selects7 
   output [3:0]             n_be7;         //Unregistered7 Byte7 strobes7
                                             // used to genetate7 
                                             // individual7 write strobes7

// Output7 register declarations7
   
   reg [31:0]                  smc_addr7;
   reg [3:0]                   smc_n_be7;
   reg                    smc_n_cs7;
   reg [3:0]                   n_be7;
   
   
   // Internal register declarations7
   
   reg [1:0]                  r_addr7;           // Stored7 Address bits 
   reg                   r_cs7;             // Stored7 CS7
   reg [1:0]                  v_addr7;           // Validated7 Address
                                                     //  bits
   reg [7:0]                  v_cs7;             // Validated7 CS7
   
   wire                       ored_v_cs7;        //oring7 of v_sc7
   wire [4:0]                 cs_xfer_bus_size7; //concatenated7 bus and 
                                                  // xfer7 size
   wire [2:0]                 wait_access_smdone7;//concatenated7 signal7
   

// Main7 Code7
//----------------------------------------------------------------------
// Address Store7, CS7 Store7 & BE7 Store7
//----------------------------------------------------------------------

   always @(posedge sys_clk7 or negedge n_sys_reset7)
     
     begin
        
        if (~n_sys_reset7)
          
           r_cs7 <= 1'b0;
        
        
        else if (valid_access7)
          
           r_cs7 <= cs ;
        
        else
          
           r_cs7 <= r_cs7 ;
        
     end

//----------------------------------------------------------------------
//v_cs7 generation7   
//----------------------------------------------------------------------
   
   always @(cs or r_cs7 or valid_access7 )
     
     begin
        
        if (valid_access7)
          
           v_cs7 = cs ;
        
        else
          
           v_cs7 = r_cs7;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone7 = {1'b0,valid_access7,smc_done7};

//----------------------------------------------------------------------
//smc_addr7 generation7
//----------------------------------------------------------------------

  always @(posedge sys_clk7 or negedge n_sys_reset7)
    
    begin
      
      if (~n_sys_reset7)
        
         smc_addr7 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone7)
             3'b1xx :

               smc_addr7 <= smc_addr7;
                        //valid_access7 
             3'b01x : begin
               // Set up address for first access
               // little7-endian from max address downto7 0
               // big-endian from 0 upto7 max_address7
               smc_addr7 [31:2] <= addr [31:2];

               casez( { v_xfer_size7, v_bus_size7, 1'b0 } )

               { `XSIZ_327, `BSIZ_327, 1'b? } : smc_addr7[1:0] <= 2'b00;
               { `XSIZ_327, `BSIZ_167, 1'b0 } : smc_addr7[1:0] <= 2'b10;
               { `XSIZ_327, `BSIZ_167, 1'b1 } : smc_addr7[1:0] <= 2'b00;
               { `XSIZ_327, `BSIZ_87, 1'b0 } :  smc_addr7[1:0] <= 2'b11;
               { `XSIZ_327, `BSIZ_87, 1'b1 } :  smc_addr7[1:0] <= 2'b00;
               { `XSIZ_167, `BSIZ_327, 1'b? } : smc_addr7[1:0] <= {addr[1],1'b0};
               { `XSIZ_167, `BSIZ_167, 1'b? } : smc_addr7[1:0] <= {addr[1],1'b0};
               { `XSIZ_167, `BSIZ_87, 1'b0 } :  smc_addr7[1:0] <= {addr[1],1'b1};
               { `XSIZ_167, `BSIZ_87, 1'b1 } :  smc_addr7[1:0] <= {addr[1],1'b0};
               { `XSIZ_87, 2'b??, 1'b? } :     smc_addr7[1:0] <= addr[1:0];
               default:                       smc_addr7[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses7 fro7 subsequent7 accesses
                // little7 endian decrements7 according7 to access no.
                // bigendian7 increments7 as access no decrements7

                  smc_addr7[31:2] <= smc_addr7[31:2];
                  
               casez( { v_xfer_size7, v_bus_size7, 1'b0 } )

               { `XSIZ_327, `BSIZ_327, 1'b? } : smc_addr7[1:0] <= 2'b00;
               { `XSIZ_327, `BSIZ_167, 1'b0 } : smc_addr7[1:0] <= 2'b00;
               { `XSIZ_327, `BSIZ_167, 1'b1 } : smc_addr7[1:0] <= 2'b10;
               { `XSIZ_327, `BSIZ_87,  1'b0 } : 
                  case( r_num_access7 ) 
                  2'b11:   smc_addr7[1:0] <= 2'b10;
                  2'b10:   smc_addr7[1:0] <= 2'b01;
                  2'b01:   smc_addr7[1:0] <= 2'b00;
                  default: smc_addr7[1:0] <= 2'b11;
                  endcase
               { `XSIZ_327, `BSIZ_87, 1'b1 } :  
                  case( r_num_access7 ) 
                  2'b11:   smc_addr7[1:0] <= 2'b01;
                  2'b10:   smc_addr7[1:0] <= 2'b10;
                  2'b01:   smc_addr7[1:0] <= 2'b11;
                  default: smc_addr7[1:0] <= 2'b00;
                  endcase
               { `XSIZ_167, `BSIZ_327, 1'b? } : smc_addr7[1:0] <= {r_addr7[1],1'b0};
               { `XSIZ_167, `BSIZ_167, 1'b? } : smc_addr7[1:0] <= {r_addr7[1],1'b0};
               { `XSIZ_167, `BSIZ_87, 1'b0 } :  smc_addr7[1:0] <= {r_addr7[1],1'b0};
               { `XSIZ_167, `BSIZ_87, 1'b1 } :  smc_addr7[1:0] <= {r_addr7[1],1'b1};
               { `XSIZ_87, 2'b??, 1'b? } :     smc_addr7[1:0] <= r_addr7[1:0];
               default:                       smc_addr7[1:0] <= r_addr7[1:0];

               endcase
                 
            end
            
            default :

               smc_addr7 <= smc_addr7;
            
          endcase // casex(wait_access_smdone7)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate7 Chip7 Select7 Output7 
//----------------------------------------------------------------------

   always @(posedge sys_clk7 or negedge n_sys_reset7)
     
     begin
        
        if (~n_sys_reset7)
          
          begin
             
             smc_n_cs7 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate7 == `SMC_RW7)
          
           begin
             
              if (valid_access7)
               
                 smc_n_cs7 <= ~cs ;
             
              else
               
                 smc_n_cs7 <= ~r_cs7 ;

           end
        
        else
          
           smc_n_cs7 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch7 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk7 or negedge n_sys_reset7)
     
     begin
        
        if (~n_sys_reset7)
          
           r_addr7 <= 2'd0;
        
        
        else if (valid_access7)
          
           r_addr7 <= addr[1:0];
        
        else
          
           r_addr7 <= r_addr7;
        
     end
   


//----------------------------------------------------------------------
// Validate7 LSB of addr with valid_access7
//----------------------------------------------------------------------

   always @(r_addr7 or valid_access7 or addr)
     
      begin
        
         if (valid_access7)
           
            v_addr7 = addr[1:0];
         
         else
           
            v_addr7 = r_addr7;
         
      end
//----------------------------------------------------------------------
//cancatenation7 of signals7
//----------------------------------------------------------------------
                               //check for v_cs7 = 0
   assign ored_v_cs7 = |v_cs7;   //signal7 concatenation7 to be used in case
   
//----------------------------------------------------------------------
// Generate7 (internal) Byte7 Enables7.
//----------------------------------------------------------------------

   always @(v_cs7 or v_xfer_size7 or v_bus_size7 or v_addr7 )
     
     begin

       if ( |v_cs7 == 1'b1 ) 
        
         casez( {v_xfer_size7, v_bus_size7, 1'b0, v_addr7[1:0] } )
          
         {`XSIZ_87, `BSIZ_87, 1'b?, 2'b??} : n_be7 = 4'b1110; // Any7 on RAM7 B07
         {`XSIZ_87, `BSIZ_167,1'b0, 2'b?0} : n_be7 = 4'b1110; // B27 or B07 = RAM7 B07
         {`XSIZ_87, `BSIZ_167,1'b0, 2'b?1} : n_be7 = 4'b1101; // B37 or B17 = RAM7 B17
         {`XSIZ_87, `BSIZ_167,1'b1, 2'b?0} : n_be7 = 4'b1101; // B27 or B07 = RAM7 B17
         {`XSIZ_87, `BSIZ_167,1'b1, 2'b?1} : n_be7 = 4'b1110; // B37 or B17 = RAM7 B07
         {`XSIZ_87, `BSIZ_327,1'b0, 2'b00} : n_be7 = 4'b1110; // B07 = RAM7 B07
         {`XSIZ_87, `BSIZ_327,1'b0, 2'b01} : n_be7 = 4'b1101; // B17 = RAM7 B17
         {`XSIZ_87, `BSIZ_327,1'b0, 2'b10} : n_be7 = 4'b1011; // B27 = RAM7 B27
         {`XSIZ_87, `BSIZ_327,1'b0, 2'b11} : n_be7 = 4'b0111; // B37 = RAM7 B37
         {`XSIZ_87, `BSIZ_327,1'b1, 2'b00} : n_be7 = 4'b0111; // B07 = RAM7 B37
         {`XSIZ_87, `BSIZ_327,1'b1, 2'b01} : n_be7 = 4'b1011; // B17 = RAM7 B27
         {`XSIZ_87, `BSIZ_327,1'b1, 2'b10} : n_be7 = 4'b1101; // B27 = RAM7 B17
         {`XSIZ_87, `BSIZ_327,1'b1, 2'b11} : n_be7 = 4'b1110; // B37 = RAM7 B07
         {`XSIZ_167,`BSIZ_87, 1'b?, 2'b??} : n_be7 = 4'b1110; // Any7 on RAM7 B07
         {`XSIZ_167,`BSIZ_167,1'b?, 2'b??} : n_be7 = 4'b1100; // Any7 on RAMB107
         {`XSIZ_167,`BSIZ_327,1'b0, 2'b0?} : n_be7 = 4'b1100; // B107 = RAM7 B107
         {`XSIZ_167,`BSIZ_327,1'b0, 2'b1?} : n_be7 = 4'b0011; // B237 = RAM7 B237
         {`XSIZ_167,`BSIZ_327,1'b1, 2'b0?} : n_be7 = 4'b0011; // B107 = RAM7 B237
         {`XSIZ_167,`BSIZ_327,1'b1, 2'b1?} : n_be7 = 4'b1100; // B237 = RAM7 B107
         {`XSIZ_327,`BSIZ_87, 1'b?, 2'b??} : n_be7 = 4'b1110; // Any7 on RAM7 B07
         {`XSIZ_327,`BSIZ_167,1'b?, 2'b??} : n_be7 = 4'b1100; // Any7 on RAM7 B107
         {`XSIZ_327,`BSIZ_327,1'b?, 2'b??} : n_be7 = 4'b0000; // Any7 on RAM7 B32107
         default                         : n_be7 = 4'b1111; // Invalid7 decode
        
         
         endcase // casex(xfer_bus_size7)
        
       else

         n_be7 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate7 (enternal7) Byte7 Enables7.
//----------------------------------------------------------------------

   always @(posedge sys_clk7 or negedge n_sys_reset7)
     
     begin
        
        if (~n_sys_reset7)
          
           smc_n_be7 <= 4'hF;
        
        
        else if (smc_nextstate7 == `SMC_RW7)
          
           smc_n_be7 <= n_be7;
        
        else
          
           smc_n_be7 <= 4'hF;
        
     end
   
   
endmodule

