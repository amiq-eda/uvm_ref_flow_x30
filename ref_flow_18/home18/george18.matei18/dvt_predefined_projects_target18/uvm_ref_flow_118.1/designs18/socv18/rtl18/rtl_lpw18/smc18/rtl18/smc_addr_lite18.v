//File18 name   : smc_addr_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : This18 block registers the address and chip18 select18
//              lines18 for the current access. The address may only
//              driven18 for one cycle by the AHB18. If18 multiple
//              accesses are required18 the bottom18 two18 address bits
//              are modified between cycles18 depending18 on the current
//              transfer18 and bus size.
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

//


`include "smc_defs_lite18.v"

// address decoder18

module smc_addr_lite18    (
                    //inputs18

                    sys_clk18,
                    n_sys_reset18,
                    valid_access18,
                    r_num_access18,
                    v_bus_size18,
                    v_xfer_size18,
                    cs,
                    addr,
                    smc_done18,
                    smc_nextstate18,


                    //outputs18

                    smc_addr18,
                    smc_n_be18,
                    smc_n_cs18,
                    n_be18);



// I18/O18

   input                    sys_clk18;      //AHB18 System18 clock18
   input                    n_sys_reset18;  //AHB18 System18 reset 
   input                    valid_access18; //Start18 of new cycle
   input [1:0]              r_num_access18; //MAC18 counter
   input [1:0]              v_bus_size18;   //bus width for current access
   input [1:0]              v_xfer_size18;  //Transfer18 size for current 
                                              // access
   input               cs;           //Chip18 (Bank18) select18(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done18;     //Transfer18 complete (state 
                                              // machine18)
   input [4:0]              smc_nextstate18;//Next18 state 

   
   output [31:0]            smc_addr18;     //External18 Memory Interface18 
                                              //  address
   output [3:0]             smc_n_be18;     //EMI18 byte enables18 
   output              smc_n_cs18;     //EMI18 Chip18 Selects18 
   output [3:0]             n_be18;         //Unregistered18 Byte18 strobes18
                                             // used to genetate18 
                                             // individual18 write strobes18

// Output18 register declarations18
   
   reg [31:0]                  smc_addr18;
   reg [3:0]                   smc_n_be18;
   reg                    smc_n_cs18;
   reg [3:0]                   n_be18;
   
   
   // Internal register declarations18
   
   reg [1:0]                  r_addr18;           // Stored18 Address bits 
   reg                   r_cs18;             // Stored18 CS18
   reg [1:0]                  v_addr18;           // Validated18 Address
                                                     //  bits
   reg [7:0]                  v_cs18;             // Validated18 CS18
   
   wire                       ored_v_cs18;        //oring18 of v_sc18
   wire [4:0]                 cs_xfer_bus_size18; //concatenated18 bus and 
                                                  // xfer18 size
   wire [2:0]                 wait_access_smdone18;//concatenated18 signal18
   

// Main18 Code18
//----------------------------------------------------------------------
// Address Store18, CS18 Store18 & BE18 Store18
//----------------------------------------------------------------------

   always @(posedge sys_clk18 or negedge n_sys_reset18)
     
     begin
        
        if (~n_sys_reset18)
          
           r_cs18 <= 1'b0;
        
        
        else if (valid_access18)
          
           r_cs18 <= cs ;
        
        else
          
           r_cs18 <= r_cs18 ;
        
     end

//----------------------------------------------------------------------
//v_cs18 generation18   
//----------------------------------------------------------------------
   
   always @(cs or r_cs18 or valid_access18 )
     
     begin
        
        if (valid_access18)
          
           v_cs18 = cs ;
        
        else
          
           v_cs18 = r_cs18;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone18 = {1'b0,valid_access18,smc_done18};

//----------------------------------------------------------------------
//smc_addr18 generation18
//----------------------------------------------------------------------

  always @(posedge sys_clk18 or negedge n_sys_reset18)
    
    begin
      
      if (~n_sys_reset18)
        
         smc_addr18 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone18)
             3'b1xx :

               smc_addr18 <= smc_addr18;
                        //valid_access18 
             3'b01x : begin
               // Set up address for first access
               // little18-endian from max address downto18 0
               // big-endian from 0 upto18 max_address18
               smc_addr18 [31:2] <= addr [31:2];

               casez( { v_xfer_size18, v_bus_size18, 1'b0 } )

               { `XSIZ_3218, `BSIZ_3218, 1'b? } : smc_addr18[1:0] <= 2'b00;
               { `XSIZ_3218, `BSIZ_1618, 1'b0 } : smc_addr18[1:0] <= 2'b10;
               { `XSIZ_3218, `BSIZ_1618, 1'b1 } : smc_addr18[1:0] <= 2'b00;
               { `XSIZ_3218, `BSIZ_818, 1'b0 } :  smc_addr18[1:0] <= 2'b11;
               { `XSIZ_3218, `BSIZ_818, 1'b1 } :  smc_addr18[1:0] <= 2'b00;
               { `XSIZ_1618, `BSIZ_3218, 1'b? } : smc_addr18[1:0] <= {addr[1],1'b0};
               { `XSIZ_1618, `BSIZ_1618, 1'b? } : smc_addr18[1:0] <= {addr[1],1'b0};
               { `XSIZ_1618, `BSIZ_818, 1'b0 } :  smc_addr18[1:0] <= {addr[1],1'b1};
               { `XSIZ_1618, `BSIZ_818, 1'b1 } :  smc_addr18[1:0] <= {addr[1],1'b0};
               { `XSIZ_818, 2'b??, 1'b? } :     smc_addr18[1:0] <= addr[1:0];
               default:                       smc_addr18[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses18 fro18 subsequent18 accesses
                // little18 endian decrements18 according18 to access no.
                // bigendian18 increments18 as access no decrements18

                  smc_addr18[31:2] <= smc_addr18[31:2];
                  
               casez( { v_xfer_size18, v_bus_size18, 1'b0 } )

               { `XSIZ_3218, `BSIZ_3218, 1'b? } : smc_addr18[1:0] <= 2'b00;
               { `XSIZ_3218, `BSIZ_1618, 1'b0 } : smc_addr18[1:0] <= 2'b00;
               { `XSIZ_3218, `BSIZ_1618, 1'b1 } : smc_addr18[1:0] <= 2'b10;
               { `XSIZ_3218, `BSIZ_818,  1'b0 } : 
                  case( r_num_access18 ) 
                  2'b11:   smc_addr18[1:0] <= 2'b10;
                  2'b10:   smc_addr18[1:0] <= 2'b01;
                  2'b01:   smc_addr18[1:0] <= 2'b00;
                  default: smc_addr18[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3218, `BSIZ_818, 1'b1 } :  
                  case( r_num_access18 ) 
                  2'b11:   smc_addr18[1:0] <= 2'b01;
                  2'b10:   smc_addr18[1:0] <= 2'b10;
                  2'b01:   smc_addr18[1:0] <= 2'b11;
                  default: smc_addr18[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1618, `BSIZ_3218, 1'b? } : smc_addr18[1:0] <= {r_addr18[1],1'b0};
               { `XSIZ_1618, `BSIZ_1618, 1'b? } : smc_addr18[1:0] <= {r_addr18[1],1'b0};
               { `XSIZ_1618, `BSIZ_818, 1'b0 } :  smc_addr18[1:0] <= {r_addr18[1],1'b0};
               { `XSIZ_1618, `BSIZ_818, 1'b1 } :  smc_addr18[1:0] <= {r_addr18[1],1'b1};
               { `XSIZ_818, 2'b??, 1'b? } :     smc_addr18[1:0] <= r_addr18[1:0];
               default:                       smc_addr18[1:0] <= r_addr18[1:0];

               endcase
                 
            end
            
            default :

               smc_addr18 <= smc_addr18;
            
          endcase // casex(wait_access_smdone18)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate18 Chip18 Select18 Output18 
//----------------------------------------------------------------------

   always @(posedge sys_clk18 or negedge n_sys_reset18)
     
     begin
        
        if (~n_sys_reset18)
          
          begin
             
             smc_n_cs18 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate18 == `SMC_RW18)
          
           begin
             
              if (valid_access18)
               
                 smc_n_cs18 <= ~cs ;
             
              else
               
                 smc_n_cs18 <= ~r_cs18 ;

           end
        
        else
          
           smc_n_cs18 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch18 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk18 or negedge n_sys_reset18)
     
     begin
        
        if (~n_sys_reset18)
          
           r_addr18 <= 2'd0;
        
        
        else if (valid_access18)
          
           r_addr18 <= addr[1:0];
        
        else
          
           r_addr18 <= r_addr18;
        
     end
   


//----------------------------------------------------------------------
// Validate18 LSB of addr with valid_access18
//----------------------------------------------------------------------

   always @(r_addr18 or valid_access18 or addr)
     
      begin
        
         if (valid_access18)
           
            v_addr18 = addr[1:0];
         
         else
           
            v_addr18 = r_addr18;
         
      end
//----------------------------------------------------------------------
//cancatenation18 of signals18
//----------------------------------------------------------------------
                               //check for v_cs18 = 0
   assign ored_v_cs18 = |v_cs18;   //signal18 concatenation18 to be used in case
   
//----------------------------------------------------------------------
// Generate18 (internal) Byte18 Enables18.
//----------------------------------------------------------------------

   always @(v_cs18 or v_xfer_size18 or v_bus_size18 or v_addr18 )
     
     begin

       if ( |v_cs18 == 1'b1 ) 
        
         casez( {v_xfer_size18, v_bus_size18, 1'b0, v_addr18[1:0] } )
          
         {`XSIZ_818, `BSIZ_818, 1'b?, 2'b??} : n_be18 = 4'b1110; // Any18 on RAM18 B018
         {`XSIZ_818, `BSIZ_1618,1'b0, 2'b?0} : n_be18 = 4'b1110; // B218 or B018 = RAM18 B018
         {`XSIZ_818, `BSIZ_1618,1'b0, 2'b?1} : n_be18 = 4'b1101; // B318 or B118 = RAM18 B118
         {`XSIZ_818, `BSIZ_1618,1'b1, 2'b?0} : n_be18 = 4'b1101; // B218 or B018 = RAM18 B118
         {`XSIZ_818, `BSIZ_1618,1'b1, 2'b?1} : n_be18 = 4'b1110; // B318 or B118 = RAM18 B018
         {`XSIZ_818, `BSIZ_3218,1'b0, 2'b00} : n_be18 = 4'b1110; // B018 = RAM18 B018
         {`XSIZ_818, `BSIZ_3218,1'b0, 2'b01} : n_be18 = 4'b1101; // B118 = RAM18 B118
         {`XSIZ_818, `BSIZ_3218,1'b0, 2'b10} : n_be18 = 4'b1011; // B218 = RAM18 B218
         {`XSIZ_818, `BSIZ_3218,1'b0, 2'b11} : n_be18 = 4'b0111; // B318 = RAM18 B318
         {`XSIZ_818, `BSIZ_3218,1'b1, 2'b00} : n_be18 = 4'b0111; // B018 = RAM18 B318
         {`XSIZ_818, `BSIZ_3218,1'b1, 2'b01} : n_be18 = 4'b1011; // B118 = RAM18 B218
         {`XSIZ_818, `BSIZ_3218,1'b1, 2'b10} : n_be18 = 4'b1101; // B218 = RAM18 B118
         {`XSIZ_818, `BSIZ_3218,1'b1, 2'b11} : n_be18 = 4'b1110; // B318 = RAM18 B018
         {`XSIZ_1618,`BSIZ_818, 1'b?, 2'b??} : n_be18 = 4'b1110; // Any18 on RAM18 B018
         {`XSIZ_1618,`BSIZ_1618,1'b?, 2'b??} : n_be18 = 4'b1100; // Any18 on RAMB1018
         {`XSIZ_1618,`BSIZ_3218,1'b0, 2'b0?} : n_be18 = 4'b1100; // B1018 = RAM18 B1018
         {`XSIZ_1618,`BSIZ_3218,1'b0, 2'b1?} : n_be18 = 4'b0011; // B2318 = RAM18 B2318
         {`XSIZ_1618,`BSIZ_3218,1'b1, 2'b0?} : n_be18 = 4'b0011; // B1018 = RAM18 B2318
         {`XSIZ_1618,`BSIZ_3218,1'b1, 2'b1?} : n_be18 = 4'b1100; // B2318 = RAM18 B1018
         {`XSIZ_3218,`BSIZ_818, 1'b?, 2'b??} : n_be18 = 4'b1110; // Any18 on RAM18 B018
         {`XSIZ_3218,`BSIZ_1618,1'b?, 2'b??} : n_be18 = 4'b1100; // Any18 on RAM18 B1018
         {`XSIZ_3218,`BSIZ_3218,1'b?, 2'b??} : n_be18 = 4'b0000; // Any18 on RAM18 B321018
         default                         : n_be18 = 4'b1111; // Invalid18 decode
        
         
         endcase // casex(xfer_bus_size18)
        
       else

         n_be18 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate18 (enternal18) Byte18 Enables18.
//----------------------------------------------------------------------

   always @(posedge sys_clk18 or negedge n_sys_reset18)
     
     begin
        
        if (~n_sys_reset18)
          
           smc_n_be18 <= 4'hF;
        
        
        else if (smc_nextstate18 == `SMC_RW18)
          
           smc_n_be18 <= n_be18;
        
        else
          
           smc_n_be18 <= 4'hF;
        
     end
   
   
endmodule

