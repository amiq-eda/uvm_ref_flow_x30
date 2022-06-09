//File22 name   : smc_addr_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : This22 block registers the address and chip22 select22
//              lines22 for the current access. The address may only
//              driven22 for one cycle by the AHB22. If22 multiple
//              accesses are required22 the bottom22 two22 address bits
//              are modified between cycles22 depending22 on the current
//              transfer22 and bus size.
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

//


`include "smc_defs_lite22.v"

// address decoder22

module smc_addr_lite22    (
                    //inputs22

                    sys_clk22,
                    n_sys_reset22,
                    valid_access22,
                    r_num_access22,
                    v_bus_size22,
                    v_xfer_size22,
                    cs,
                    addr,
                    smc_done22,
                    smc_nextstate22,


                    //outputs22

                    smc_addr22,
                    smc_n_be22,
                    smc_n_cs22,
                    n_be22);



// I22/O22

   input                    sys_clk22;      //AHB22 System22 clock22
   input                    n_sys_reset22;  //AHB22 System22 reset 
   input                    valid_access22; //Start22 of new cycle
   input [1:0]              r_num_access22; //MAC22 counter
   input [1:0]              v_bus_size22;   //bus width for current access
   input [1:0]              v_xfer_size22;  //Transfer22 size for current 
                                              // access
   input               cs;           //Chip22 (Bank22) select22(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done22;     //Transfer22 complete (state 
                                              // machine22)
   input [4:0]              smc_nextstate22;//Next22 state 

   
   output [31:0]            smc_addr22;     //External22 Memory Interface22 
                                              //  address
   output [3:0]             smc_n_be22;     //EMI22 byte enables22 
   output              smc_n_cs22;     //EMI22 Chip22 Selects22 
   output [3:0]             n_be22;         //Unregistered22 Byte22 strobes22
                                             // used to genetate22 
                                             // individual22 write strobes22

// Output22 register declarations22
   
   reg [31:0]                  smc_addr22;
   reg [3:0]                   smc_n_be22;
   reg                    smc_n_cs22;
   reg [3:0]                   n_be22;
   
   
   // Internal register declarations22
   
   reg [1:0]                  r_addr22;           // Stored22 Address bits 
   reg                   r_cs22;             // Stored22 CS22
   reg [1:0]                  v_addr22;           // Validated22 Address
                                                     //  bits
   reg [7:0]                  v_cs22;             // Validated22 CS22
   
   wire                       ored_v_cs22;        //oring22 of v_sc22
   wire [4:0]                 cs_xfer_bus_size22; //concatenated22 bus and 
                                                  // xfer22 size
   wire [2:0]                 wait_access_smdone22;//concatenated22 signal22
   

// Main22 Code22
//----------------------------------------------------------------------
// Address Store22, CS22 Store22 & BE22 Store22
//----------------------------------------------------------------------

   always @(posedge sys_clk22 or negedge n_sys_reset22)
     
     begin
        
        if (~n_sys_reset22)
          
           r_cs22 <= 1'b0;
        
        
        else if (valid_access22)
          
           r_cs22 <= cs ;
        
        else
          
           r_cs22 <= r_cs22 ;
        
     end

//----------------------------------------------------------------------
//v_cs22 generation22   
//----------------------------------------------------------------------
   
   always @(cs or r_cs22 or valid_access22 )
     
     begin
        
        if (valid_access22)
          
           v_cs22 = cs ;
        
        else
          
           v_cs22 = r_cs22;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone22 = {1'b0,valid_access22,smc_done22};

//----------------------------------------------------------------------
//smc_addr22 generation22
//----------------------------------------------------------------------

  always @(posedge sys_clk22 or negedge n_sys_reset22)
    
    begin
      
      if (~n_sys_reset22)
        
         smc_addr22 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone22)
             3'b1xx :

               smc_addr22 <= smc_addr22;
                        //valid_access22 
             3'b01x : begin
               // Set up address for first access
               // little22-endian from max address downto22 0
               // big-endian from 0 upto22 max_address22
               smc_addr22 [31:2] <= addr [31:2];

               casez( { v_xfer_size22, v_bus_size22, 1'b0 } )

               { `XSIZ_3222, `BSIZ_3222, 1'b? } : smc_addr22[1:0] <= 2'b00;
               { `XSIZ_3222, `BSIZ_1622, 1'b0 } : smc_addr22[1:0] <= 2'b10;
               { `XSIZ_3222, `BSIZ_1622, 1'b1 } : smc_addr22[1:0] <= 2'b00;
               { `XSIZ_3222, `BSIZ_822, 1'b0 } :  smc_addr22[1:0] <= 2'b11;
               { `XSIZ_3222, `BSIZ_822, 1'b1 } :  smc_addr22[1:0] <= 2'b00;
               { `XSIZ_1622, `BSIZ_3222, 1'b? } : smc_addr22[1:0] <= {addr[1],1'b0};
               { `XSIZ_1622, `BSIZ_1622, 1'b? } : smc_addr22[1:0] <= {addr[1],1'b0};
               { `XSIZ_1622, `BSIZ_822, 1'b0 } :  smc_addr22[1:0] <= {addr[1],1'b1};
               { `XSIZ_1622, `BSIZ_822, 1'b1 } :  smc_addr22[1:0] <= {addr[1],1'b0};
               { `XSIZ_822, 2'b??, 1'b? } :     smc_addr22[1:0] <= addr[1:0];
               default:                       smc_addr22[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses22 fro22 subsequent22 accesses
                // little22 endian decrements22 according22 to access no.
                // bigendian22 increments22 as access no decrements22

                  smc_addr22[31:2] <= smc_addr22[31:2];
                  
               casez( { v_xfer_size22, v_bus_size22, 1'b0 } )

               { `XSIZ_3222, `BSIZ_3222, 1'b? } : smc_addr22[1:0] <= 2'b00;
               { `XSIZ_3222, `BSIZ_1622, 1'b0 } : smc_addr22[1:0] <= 2'b00;
               { `XSIZ_3222, `BSIZ_1622, 1'b1 } : smc_addr22[1:0] <= 2'b10;
               { `XSIZ_3222, `BSIZ_822,  1'b0 } : 
                  case( r_num_access22 ) 
                  2'b11:   smc_addr22[1:0] <= 2'b10;
                  2'b10:   smc_addr22[1:0] <= 2'b01;
                  2'b01:   smc_addr22[1:0] <= 2'b00;
                  default: smc_addr22[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3222, `BSIZ_822, 1'b1 } :  
                  case( r_num_access22 ) 
                  2'b11:   smc_addr22[1:0] <= 2'b01;
                  2'b10:   smc_addr22[1:0] <= 2'b10;
                  2'b01:   smc_addr22[1:0] <= 2'b11;
                  default: smc_addr22[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1622, `BSIZ_3222, 1'b? } : smc_addr22[1:0] <= {r_addr22[1],1'b0};
               { `XSIZ_1622, `BSIZ_1622, 1'b? } : smc_addr22[1:0] <= {r_addr22[1],1'b0};
               { `XSIZ_1622, `BSIZ_822, 1'b0 } :  smc_addr22[1:0] <= {r_addr22[1],1'b0};
               { `XSIZ_1622, `BSIZ_822, 1'b1 } :  smc_addr22[1:0] <= {r_addr22[1],1'b1};
               { `XSIZ_822, 2'b??, 1'b? } :     smc_addr22[1:0] <= r_addr22[1:0];
               default:                       smc_addr22[1:0] <= r_addr22[1:0];

               endcase
                 
            end
            
            default :

               smc_addr22 <= smc_addr22;
            
          endcase // casex(wait_access_smdone22)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate22 Chip22 Select22 Output22 
//----------------------------------------------------------------------

   always @(posedge sys_clk22 or negedge n_sys_reset22)
     
     begin
        
        if (~n_sys_reset22)
          
          begin
             
             smc_n_cs22 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate22 == `SMC_RW22)
          
           begin
             
              if (valid_access22)
               
                 smc_n_cs22 <= ~cs ;
             
              else
               
                 smc_n_cs22 <= ~r_cs22 ;

           end
        
        else
          
           smc_n_cs22 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch22 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk22 or negedge n_sys_reset22)
     
     begin
        
        if (~n_sys_reset22)
          
           r_addr22 <= 2'd0;
        
        
        else if (valid_access22)
          
           r_addr22 <= addr[1:0];
        
        else
          
           r_addr22 <= r_addr22;
        
     end
   


//----------------------------------------------------------------------
// Validate22 LSB of addr with valid_access22
//----------------------------------------------------------------------

   always @(r_addr22 or valid_access22 or addr)
     
      begin
        
         if (valid_access22)
           
            v_addr22 = addr[1:0];
         
         else
           
            v_addr22 = r_addr22;
         
      end
//----------------------------------------------------------------------
//cancatenation22 of signals22
//----------------------------------------------------------------------
                               //check for v_cs22 = 0
   assign ored_v_cs22 = |v_cs22;   //signal22 concatenation22 to be used in case
   
//----------------------------------------------------------------------
// Generate22 (internal) Byte22 Enables22.
//----------------------------------------------------------------------

   always @(v_cs22 or v_xfer_size22 or v_bus_size22 or v_addr22 )
     
     begin

       if ( |v_cs22 == 1'b1 ) 
        
         casez( {v_xfer_size22, v_bus_size22, 1'b0, v_addr22[1:0] } )
          
         {`XSIZ_822, `BSIZ_822, 1'b?, 2'b??} : n_be22 = 4'b1110; // Any22 on RAM22 B022
         {`XSIZ_822, `BSIZ_1622,1'b0, 2'b?0} : n_be22 = 4'b1110; // B222 or B022 = RAM22 B022
         {`XSIZ_822, `BSIZ_1622,1'b0, 2'b?1} : n_be22 = 4'b1101; // B322 or B122 = RAM22 B122
         {`XSIZ_822, `BSIZ_1622,1'b1, 2'b?0} : n_be22 = 4'b1101; // B222 or B022 = RAM22 B122
         {`XSIZ_822, `BSIZ_1622,1'b1, 2'b?1} : n_be22 = 4'b1110; // B322 or B122 = RAM22 B022
         {`XSIZ_822, `BSIZ_3222,1'b0, 2'b00} : n_be22 = 4'b1110; // B022 = RAM22 B022
         {`XSIZ_822, `BSIZ_3222,1'b0, 2'b01} : n_be22 = 4'b1101; // B122 = RAM22 B122
         {`XSIZ_822, `BSIZ_3222,1'b0, 2'b10} : n_be22 = 4'b1011; // B222 = RAM22 B222
         {`XSIZ_822, `BSIZ_3222,1'b0, 2'b11} : n_be22 = 4'b0111; // B322 = RAM22 B322
         {`XSIZ_822, `BSIZ_3222,1'b1, 2'b00} : n_be22 = 4'b0111; // B022 = RAM22 B322
         {`XSIZ_822, `BSIZ_3222,1'b1, 2'b01} : n_be22 = 4'b1011; // B122 = RAM22 B222
         {`XSIZ_822, `BSIZ_3222,1'b1, 2'b10} : n_be22 = 4'b1101; // B222 = RAM22 B122
         {`XSIZ_822, `BSIZ_3222,1'b1, 2'b11} : n_be22 = 4'b1110; // B322 = RAM22 B022
         {`XSIZ_1622,`BSIZ_822, 1'b?, 2'b??} : n_be22 = 4'b1110; // Any22 on RAM22 B022
         {`XSIZ_1622,`BSIZ_1622,1'b?, 2'b??} : n_be22 = 4'b1100; // Any22 on RAMB1022
         {`XSIZ_1622,`BSIZ_3222,1'b0, 2'b0?} : n_be22 = 4'b1100; // B1022 = RAM22 B1022
         {`XSIZ_1622,`BSIZ_3222,1'b0, 2'b1?} : n_be22 = 4'b0011; // B2322 = RAM22 B2322
         {`XSIZ_1622,`BSIZ_3222,1'b1, 2'b0?} : n_be22 = 4'b0011; // B1022 = RAM22 B2322
         {`XSIZ_1622,`BSIZ_3222,1'b1, 2'b1?} : n_be22 = 4'b1100; // B2322 = RAM22 B1022
         {`XSIZ_3222,`BSIZ_822, 1'b?, 2'b??} : n_be22 = 4'b1110; // Any22 on RAM22 B022
         {`XSIZ_3222,`BSIZ_1622,1'b?, 2'b??} : n_be22 = 4'b1100; // Any22 on RAM22 B1022
         {`XSIZ_3222,`BSIZ_3222,1'b?, 2'b??} : n_be22 = 4'b0000; // Any22 on RAM22 B321022
         default                         : n_be22 = 4'b1111; // Invalid22 decode
        
         
         endcase // casex(xfer_bus_size22)
        
       else

         n_be22 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate22 (enternal22) Byte22 Enables22.
//----------------------------------------------------------------------

   always @(posedge sys_clk22 or negedge n_sys_reset22)
     
     begin
        
        if (~n_sys_reset22)
          
           smc_n_be22 <= 4'hF;
        
        
        else if (smc_nextstate22 == `SMC_RW22)
          
           smc_n_be22 <= n_be22;
        
        else
          
           smc_n_be22 <= 4'hF;
        
     end
   
   
endmodule

