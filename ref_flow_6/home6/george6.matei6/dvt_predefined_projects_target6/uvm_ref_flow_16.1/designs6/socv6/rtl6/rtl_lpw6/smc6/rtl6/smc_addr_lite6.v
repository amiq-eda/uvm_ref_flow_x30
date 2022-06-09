//File6 name   : smc_addr_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : This6 block registers the address and chip6 select6
//              lines6 for the current access. The address may only
//              driven6 for one cycle by the AHB6. If6 multiple
//              accesses are required6 the bottom6 two6 address bits
//              are modified between cycles6 depending6 on the current
//              transfer6 and bus size.
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

//


`include "smc_defs_lite6.v"

// address decoder6

module smc_addr_lite6    (
                    //inputs6

                    sys_clk6,
                    n_sys_reset6,
                    valid_access6,
                    r_num_access6,
                    v_bus_size6,
                    v_xfer_size6,
                    cs,
                    addr,
                    smc_done6,
                    smc_nextstate6,


                    //outputs6

                    smc_addr6,
                    smc_n_be6,
                    smc_n_cs6,
                    n_be6);



// I6/O6

   input                    sys_clk6;      //AHB6 System6 clock6
   input                    n_sys_reset6;  //AHB6 System6 reset 
   input                    valid_access6; //Start6 of new cycle
   input [1:0]              r_num_access6; //MAC6 counter
   input [1:0]              v_bus_size6;   //bus width for current access
   input [1:0]              v_xfer_size6;  //Transfer6 size for current 
                                              // access
   input               cs;           //Chip6 (Bank6) select6(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done6;     //Transfer6 complete (state 
                                              // machine6)
   input [4:0]              smc_nextstate6;//Next6 state 

   
   output [31:0]            smc_addr6;     //External6 Memory Interface6 
                                              //  address
   output [3:0]             smc_n_be6;     //EMI6 byte enables6 
   output              smc_n_cs6;     //EMI6 Chip6 Selects6 
   output [3:0]             n_be6;         //Unregistered6 Byte6 strobes6
                                             // used to genetate6 
                                             // individual6 write strobes6

// Output6 register declarations6
   
   reg [31:0]                  smc_addr6;
   reg [3:0]                   smc_n_be6;
   reg                    smc_n_cs6;
   reg [3:0]                   n_be6;
   
   
   // Internal register declarations6
   
   reg [1:0]                  r_addr6;           // Stored6 Address bits 
   reg                   r_cs6;             // Stored6 CS6
   reg [1:0]                  v_addr6;           // Validated6 Address
                                                     //  bits
   reg [7:0]                  v_cs6;             // Validated6 CS6
   
   wire                       ored_v_cs6;        //oring6 of v_sc6
   wire [4:0]                 cs_xfer_bus_size6; //concatenated6 bus and 
                                                  // xfer6 size
   wire [2:0]                 wait_access_smdone6;//concatenated6 signal6
   

// Main6 Code6
//----------------------------------------------------------------------
// Address Store6, CS6 Store6 & BE6 Store6
//----------------------------------------------------------------------

   always @(posedge sys_clk6 or negedge n_sys_reset6)
     
     begin
        
        if (~n_sys_reset6)
          
           r_cs6 <= 1'b0;
        
        
        else if (valid_access6)
          
           r_cs6 <= cs ;
        
        else
          
           r_cs6 <= r_cs6 ;
        
     end

//----------------------------------------------------------------------
//v_cs6 generation6   
//----------------------------------------------------------------------
   
   always @(cs or r_cs6 or valid_access6 )
     
     begin
        
        if (valid_access6)
          
           v_cs6 = cs ;
        
        else
          
           v_cs6 = r_cs6;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone6 = {1'b0,valid_access6,smc_done6};

//----------------------------------------------------------------------
//smc_addr6 generation6
//----------------------------------------------------------------------

  always @(posedge sys_clk6 or negedge n_sys_reset6)
    
    begin
      
      if (~n_sys_reset6)
        
         smc_addr6 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone6)
             3'b1xx :

               smc_addr6 <= smc_addr6;
                        //valid_access6 
             3'b01x : begin
               // Set up address for first access
               // little6-endian from max address downto6 0
               // big-endian from 0 upto6 max_address6
               smc_addr6 [31:2] <= addr [31:2];

               casez( { v_xfer_size6, v_bus_size6, 1'b0 } )

               { `XSIZ_326, `BSIZ_326, 1'b? } : smc_addr6[1:0] <= 2'b00;
               { `XSIZ_326, `BSIZ_166, 1'b0 } : smc_addr6[1:0] <= 2'b10;
               { `XSIZ_326, `BSIZ_166, 1'b1 } : smc_addr6[1:0] <= 2'b00;
               { `XSIZ_326, `BSIZ_86, 1'b0 } :  smc_addr6[1:0] <= 2'b11;
               { `XSIZ_326, `BSIZ_86, 1'b1 } :  smc_addr6[1:0] <= 2'b00;
               { `XSIZ_166, `BSIZ_326, 1'b? } : smc_addr6[1:0] <= {addr[1],1'b0};
               { `XSIZ_166, `BSIZ_166, 1'b? } : smc_addr6[1:0] <= {addr[1],1'b0};
               { `XSIZ_166, `BSIZ_86, 1'b0 } :  smc_addr6[1:0] <= {addr[1],1'b1};
               { `XSIZ_166, `BSIZ_86, 1'b1 } :  smc_addr6[1:0] <= {addr[1],1'b0};
               { `XSIZ_86, 2'b??, 1'b? } :     smc_addr6[1:0] <= addr[1:0];
               default:                       smc_addr6[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses6 fro6 subsequent6 accesses
                // little6 endian decrements6 according6 to access no.
                // bigendian6 increments6 as access no decrements6

                  smc_addr6[31:2] <= smc_addr6[31:2];
                  
               casez( { v_xfer_size6, v_bus_size6, 1'b0 } )

               { `XSIZ_326, `BSIZ_326, 1'b? } : smc_addr6[1:0] <= 2'b00;
               { `XSIZ_326, `BSIZ_166, 1'b0 } : smc_addr6[1:0] <= 2'b00;
               { `XSIZ_326, `BSIZ_166, 1'b1 } : smc_addr6[1:0] <= 2'b10;
               { `XSIZ_326, `BSIZ_86,  1'b0 } : 
                  case( r_num_access6 ) 
                  2'b11:   smc_addr6[1:0] <= 2'b10;
                  2'b10:   smc_addr6[1:0] <= 2'b01;
                  2'b01:   smc_addr6[1:0] <= 2'b00;
                  default: smc_addr6[1:0] <= 2'b11;
                  endcase
               { `XSIZ_326, `BSIZ_86, 1'b1 } :  
                  case( r_num_access6 ) 
                  2'b11:   smc_addr6[1:0] <= 2'b01;
                  2'b10:   smc_addr6[1:0] <= 2'b10;
                  2'b01:   smc_addr6[1:0] <= 2'b11;
                  default: smc_addr6[1:0] <= 2'b00;
                  endcase
               { `XSIZ_166, `BSIZ_326, 1'b? } : smc_addr6[1:0] <= {r_addr6[1],1'b0};
               { `XSIZ_166, `BSIZ_166, 1'b? } : smc_addr6[1:0] <= {r_addr6[1],1'b0};
               { `XSIZ_166, `BSIZ_86, 1'b0 } :  smc_addr6[1:0] <= {r_addr6[1],1'b0};
               { `XSIZ_166, `BSIZ_86, 1'b1 } :  smc_addr6[1:0] <= {r_addr6[1],1'b1};
               { `XSIZ_86, 2'b??, 1'b? } :     smc_addr6[1:0] <= r_addr6[1:0];
               default:                       smc_addr6[1:0] <= r_addr6[1:0];

               endcase
                 
            end
            
            default :

               smc_addr6 <= smc_addr6;
            
          endcase // casex(wait_access_smdone6)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate6 Chip6 Select6 Output6 
//----------------------------------------------------------------------

   always @(posedge sys_clk6 or negedge n_sys_reset6)
     
     begin
        
        if (~n_sys_reset6)
          
          begin
             
             smc_n_cs6 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate6 == `SMC_RW6)
          
           begin
             
              if (valid_access6)
               
                 smc_n_cs6 <= ~cs ;
             
              else
               
                 smc_n_cs6 <= ~r_cs6 ;

           end
        
        else
          
           smc_n_cs6 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch6 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk6 or negedge n_sys_reset6)
     
     begin
        
        if (~n_sys_reset6)
          
           r_addr6 <= 2'd0;
        
        
        else if (valid_access6)
          
           r_addr6 <= addr[1:0];
        
        else
          
           r_addr6 <= r_addr6;
        
     end
   


//----------------------------------------------------------------------
// Validate6 LSB of addr with valid_access6
//----------------------------------------------------------------------

   always @(r_addr6 or valid_access6 or addr)
     
      begin
        
         if (valid_access6)
           
            v_addr6 = addr[1:0];
         
         else
           
            v_addr6 = r_addr6;
         
      end
//----------------------------------------------------------------------
//cancatenation6 of signals6
//----------------------------------------------------------------------
                               //check for v_cs6 = 0
   assign ored_v_cs6 = |v_cs6;   //signal6 concatenation6 to be used in case
   
//----------------------------------------------------------------------
// Generate6 (internal) Byte6 Enables6.
//----------------------------------------------------------------------

   always @(v_cs6 or v_xfer_size6 or v_bus_size6 or v_addr6 )
     
     begin

       if ( |v_cs6 == 1'b1 ) 
        
         casez( {v_xfer_size6, v_bus_size6, 1'b0, v_addr6[1:0] } )
          
         {`XSIZ_86, `BSIZ_86, 1'b?, 2'b??} : n_be6 = 4'b1110; // Any6 on RAM6 B06
         {`XSIZ_86, `BSIZ_166,1'b0, 2'b?0} : n_be6 = 4'b1110; // B26 or B06 = RAM6 B06
         {`XSIZ_86, `BSIZ_166,1'b0, 2'b?1} : n_be6 = 4'b1101; // B36 or B16 = RAM6 B16
         {`XSIZ_86, `BSIZ_166,1'b1, 2'b?0} : n_be6 = 4'b1101; // B26 or B06 = RAM6 B16
         {`XSIZ_86, `BSIZ_166,1'b1, 2'b?1} : n_be6 = 4'b1110; // B36 or B16 = RAM6 B06
         {`XSIZ_86, `BSIZ_326,1'b0, 2'b00} : n_be6 = 4'b1110; // B06 = RAM6 B06
         {`XSIZ_86, `BSIZ_326,1'b0, 2'b01} : n_be6 = 4'b1101; // B16 = RAM6 B16
         {`XSIZ_86, `BSIZ_326,1'b0, 2'b10} : n_be6 = 4'b1011; // B26 = RAM6 B26
         {`XSIZ_86, `BSIZ_326,1'b0, 2'b11} : n_be6 = 4'b0111; // B36 = RAM6 B36
         {`XSIZ_86, `BSIZ_326,1'b1, 2'b00} : n_be6 = 4'b0111; // B06 = RAM6 B36
         {`XSIZ_86, `BSIZ_326,1'b1, 2'b01} : n_be6 = 4'b1011; // B16 = RAM6 B26
         {`XSIZ_86, `BSIZ_326,1'b1, 2'b10} : n_be6 = 4'b1101; // B26 = RAM6 B16
         {`XSIZ_86, `BSIZ_326,1'b1, 2'b11} : n_be6 = 4'b1110; // B36 = RAM6 B06
         {`XSIZ_166,`BSIZ_86, 1'b?, 2'b??} : n_be6 = 4'b1110; // Any6 on RAM6 B06
         {`XSIZ_166,`BSIZ_166,1'b?, 2'b??} : n_be6 = 4'b1100; // Any6 on RAMB106
         {`XSIZ_166,`BSIZ_326,1'b0, 2'b0?} : n_be6 = 4'b1100; // B106 = RAM6 B106
         {`XSIZ_166,`BSIZ_326,1'b0, 2'b1?} : n_be6 = 4'b0011; // B236 = RAM6 B236
         {`XSIZ_166,`BSIZ_326,1'b1, 2'b0?} : n_be6 = 4'b0011; // B106 = RAM6 B236
         {`XSIZ_166,`BSIZ_326,1'b1, 2'b1?} : n_be6 = 4'b1100; // B236 = RAM6 B106
         {`XSIZ_326,`BSIZ_86, 1'b?, 2'b??} : n_be6 = 4'b1110; // Any6 on RAM6 B06
         {`XSIZ_326,`BSIZ_166,1'b?, 2'b??} : n_be6 = 4'b1100; // Any6 on RAM6 B106
         {`XSIZ_326,`BSIZ_326,1'b?, 2'b??} : n_be6 = 4'b0000; // Any6 on RAM6 B32106
         default                         : n_be6 = 4'b1111; // Invalid6 decode
        
         
         endcase // casex(xfer_bus_size6)
        
       else

         n_be6 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate6 (enternal6) Byte6 Enables6.
//----------------------------------------------------------------------

   always @(posedge sys_clk6 or negedge n_sys_reset6)
     
     begin
        
        if (~n_sys_reset6)
          
           smc_n_be6 <= 4'hF;
        
        
        else if (smc_nextstate6 == `SMC_RW6)
          
           smc_n_be6 <= n_be6;
        
        else
          
           smc_n_be6 <= 4'hF;
        
     end
   
   
endmodule

