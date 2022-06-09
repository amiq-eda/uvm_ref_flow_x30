//File15 name   : smc_addr_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : This15 block registers the address and chip15 select15
//              lines15 for the current access. The address may only
//              driven15 for one cycle by the AHB15. If15 multiple
//              accesses are required15 the bottom15 two15 address bits
//              are modified between cycles15 depending15 on the current
//              transfer15 and bus size.
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

//


`include "smc_defs_lite15.v"

// address decoder15

module smc_addr_lite15    (
                    //inputs15

                    sys_clk15,
                    n_sys_reset15,
                    valid_access15,
                    r_num_access15,
                    v_bus_size15,
                    v_xfer_size15,
                    cs,
                    addr,
                    smc_done15,
                    smc_nextstate15,


                    //outputs15

                    smc_addr15,
                    smc_n_be15,
                    smc_n_cs15,
                    n_be15);



// I15/O15

   input                    sys_clk15;      //AHB15 System15 clock15
   input                    n_sys_reset15;  //AHB15 System15 reset 
   input                    valid_access15; //Start15 of new cycle
   input [1:0]              r_num_access15; //MAC15 counter
   input [1:0]              v_bus_size15;   //bus width for current access
   input [1:0]              v_xfer_size15;  //Transfer15 size for current 
                                              // access
   input               cs;           //Chip15 (Bank15) select15(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done15;     //Transfer15 complete (state 
                                              // machine15)
   input [4:0]              smc_nextstate15;//Next15 state 

   
   output [31:0]            smc_addr15;     //External15 Memory Interface15 
                                              //  address
   output [3:0]             smc_n_be15;     //EMI15 byte enables15 
   output              smc_n_cs15;     //EMI15 Chip15 Selects15 
   output [3:0]             n_be15;         //Unregistered15 Byte15 strobes15
                                             // used to genetate15 
                                             // individual15 write strobes15

// Output15 register declarations15
   
   reg [31:0]                  smc_addr15;
   reg [3:0]                   smc_n_be15;
   reg                    smc_n_cs15;
   reg [3:0]                   n_be15;
   
   
   // Internal register declarations15
   
   reg [1:0]                  r_addr15;           // Stored15 Address bits 
   reg                   r_cs15;             // Stored15 CS15
   reg [1:0]                  v_addr15;           // Validated15 Address
                                                     //  bits
   reg [7:0]                  v_cs15;             // Validated15 CS15
   
   wire                       ored_v_cs15;        //oring15 of v_sc15
   wire [4:0]                 cs_xfer_bus_size15; //concatenated15 bus and 
                                                  // xfer15 size
   wire [2:0]                 wait_access_smdone15;//concatenated15 signal15
   

// Main15 Code15
//----------------------------------------------------------------------
// Address Store15, CS15 Store15 & BE15 Store15
//----------------------------------------------------------------------

   always @(posedge sys_clk15 or negedge n_sys_reset15)
     
     begin
        
        if (~n_sys_reset15)
          
           r_cs15 <= 1'b0;
        
        
        else if (valid_access15)
          
           r_cs15 <= cs ;
        
        else
          
           r_cs15 <= r_cs15 ;
        
     end

//----------------------------------------------------------------------
//v_cs15 generation15   
//----------------------------------------------------------------------
   
   always @(cs or r_cs15 or valid_access15 )
     
     begin
        
        if (valid_access15)
          
           v_cs15 = cs ;
        
        else
          
           v_cs15 = r_cs15;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone15 = {1'b0,valid_access15,smc_done15};

//----------------------------------------------------------------------
//smc_addr15 generation15
//----------------------------------------------------------------------

  always @(posedge sys_clk15 or negedge n_sys_reset15)
    
    begin
      
      if (~n_sys_reset15)
        
         smc_addr15 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone15)
             3'b1xx :

               smc_addr15 <= smc_addr15;
                        //valid_access15 
             3'b01x : begin
               // Set up address for first access
               // little15-endian from max address downto15 0
               // big-endian from 0 upto15 max_address15
               smc_addr15 [31:2] <= addr [31:2];

               casez( { v_xfer_size15, v_bus_size15, 1'b0 } )

               { `XSIZ_3215, `BSIZ_3215, 1'b? } : smc_addr15[1:0] <= 2'b00;
               { `XSIZ_3215, `BSIZ_1615, 1'b0 } : smc_addr15[1:0] <= 2'b10;
               { `XSIZ_3215, `BSIZ_1615, 1'b1 } : smc_addr15[1:0] <= 2'b00;
               { `XSIZ_3215, `BSIZ_815, 1'b0 } :  smc_addr15[1:0] <= 2'b11;
               { `XSIZ_3215, `BSIZ_815, 1'b1 } :  smc_addr15[1:0] <= 2'b00;
               { `XSIZ_1615, `BSIZ_3215, 1'b? } : smc_addr15[1:0] <= {addr[1],1'b0};
               { `XSIZ_1615, `BSIZ_1615, 1'b? } : smc_addr15[1:0] <= {addr[1],1'b0};
               { `XSIZ_1615, `BSIZ_815, 1'b0 } :  smc_addr15[1:0] <= {addr[1],1'b1};
               { `XSIZ_1615, `BSIZ_815, 1'b1 } :  smc_addr15[1:0] <= {addr[1],1'b0};
               { `XSIZ_815, 2'b??, 1'b? } :     smc_addr15[1:0] <= addr[1:0];
               default:                       smc_addr15[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses15 fro15 subsequent15 accesses
                // little15 endian decrements15 according15 to access no.
                // bigendian15 increments15 as access no decrements15

                  smc_addr15[31:2] <= smc_addr15[31:2];
                  
               casez( { v_xfer_size15, v_bus_size15, 1'b0 } )

               { `XSIZ_3215, `BSIZ_3215, 1'b? } : smc_addr15[1:0] <= 2'b00;
               { `XSIZ_3215, `BSIZ_1615, 1'b0 } : smc_addr15[1:0] <= 2'b00;
               { `XSIZ_3215, `BSIZ_1615, 1'b1 } : smc_addr15[1:0] <= 2'b10;
               { `XSIZ_3215, `BSIZ_815,  1'b0 } : 
                  case( r_num_access15 ) 
                  2'b11:   smc_addr15[1:0] <= 2'b10;
                  2'b10:   smc_addr15[1:0] <= 2'b01;
                  2'b01:   smc_addr15[1:0] <= 2'b00;
                  default: smc_addr15[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3215, `BSIZ_815, 1'b1 } :  
                  case( r_num_access15 ) 
                  2'b11:   smc_addr15[1:0] <= 2'b01;
                  2'b10:   smc_addr15[1:0] <= 2'b10;
                  2'b01:   smc_addr15[1:0] <= 2'b11;
                  default: smc_addr15[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1615, `BSIZ_3215, 1'b? } : smc_addr15[1:0] <= {r_addr15[1],1'b0};
               { `XSIZ_1615, `BSIZ_1615, 1'b? } : smc_addr15[1:0] <= {r_addr15[1],1'b0};
               { `XSIZ_1615, `BSIZ_815, 1'b0 } :  smc_addr15[1:0] <= {r_addr15[1],1'b0};
               { `XSIZ_1615, `BSIZ_815, 1'b1 } :  smc_addr15[1:0] <= {r_addr15[1],1'b1};
               { `XSIZ_815, 2'b??, 1'b? } :     smc_addr15[1:0] <= r_addr15[1:0];
               default:                       smc_addr15[1:0] <= r_addr15[1:0];

               endcase
                 
            end
            
            default :

               smc_addr15 <= smc_addr15;
            
          endcase // casex(wait_access_smdone15)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate15 Chip15 Select15 Output15 
//----------------------------------------------------------------------

   always @(posedge sys_clk15 or negedge n_sys_reset15)
     
     begin
        
        if (~n_sys_reset15)
          
          begin
             
             smc_n_cs15 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate15 == `SMC_RW15)
          
           begin
             
              if (valid_access15)
               
                 smc_n_cs15 <= ~cs ;
             
              else
               
                 smc_n_cs15 <= ~r_cs15 ;

           end
        
        else
          
           smc_n_cs15 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch15 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk15 or negedge n_sys_reset15)
     
     begin
        
        if (~n_sys_reset15)
          
           r_addr15 <= 2'd0;
        
        
        else if (valid_access15)
          
           r_addr15 <= addr[1:0];
        
        else
          
           r_addr15 <= r_addr15;
        
     end
   


//----------------------------------------------------------------------
// Validate15 LSB of addr with valid_access15
//----------------------------------------------------------------------

   always @(r_addr15 or valid_access15 or addr)
     
      begin
        
         if (valid_access15)
           
            v_addr15 = addr[1:0];
         
         else
           
            v_addr15 = r_addr15;
         
      end
//----------------------------------------------------------------------
//cancatenation15 of signals15
//----------------------------------------------------------------------
                               //check for v_cs15 = 0
   assign ored_v_cs15 = |v_cs15;   //signal15 concatenation15 to be used in case
   
//----------------------------------------------------------------------
// Generate15 (internal) Byte15 Enables15.
//----------------------------------------------------------------------

   always @(v_cs15 or v_xfer_size15 or v_bus_size15 or v_addr15 )
     
     begin

       if ( |v_cs15 == 1'b1 ) 
        
         casez( {v_xfer_size15, v_bus_size15, 1'b0, v_addr15[1:0] } )
          
         {`XSIZ_815, `BSIZ_815, 1'b?, 2'b??} : n_be15 = 4'b1110; // Any15 on RAM15 B015
         {`XSIZ_815, `BSIZ_1615,1'b0, 2'b?0} : n_be15 = 4'b1110; // B215 or B015 = RAM15 B015
         {`XSIZ_815, `BSIZ_1615,1'b0, 2'b?1} : n_be15 = 4'b1101; // B315 or B115 = RAM15 B115
         {`XSIZ_815, `BSIZ_1615,1'b1, 2'b?0} : n_be15 = 4'b1101; // B215 or B015 = RAM15 B115
         {`XSIZ_815, `BSIZ_1615,1'b1, 2'b?1} : n_be15 = 4'b1110; // B315 or B115 = RAM15 B015
         {`XSIZ_815, `BSIZ_3215,1'b0, 2'b00} : n_be15 = 4'b1110; // B015 = RAM15 B015
         {`XSIZ_815, `BSIZ_3215,1'b0, 2'b01} : n_be15 = 4'b1101; // B115 = RAM15 B115
         {`XSIZ_815, `BSIZ_3215,1'b0, 2'b10} : n_be15 = 4'b1011; // B215 = RAM15 B215
         {`XSIZ_815, `BSIZ_3215,1'b0, 2'b11} : n_be15 = 4'b0111; // B315 = RAM15 B315
         {`XSIZ_815, `BSIZ_3215,1'b1, 2'b00} : n_be15 = 4'b0111; // B015 = RAM15 B315
         {`XSIZ_815, `BSIZ_3215,1'b1, 2'b01} : n_be15 = 4'b1011; // B115 = RAM15 B215
         {`XSIZ_815, `BSIZ_3215,1'b1, 2'b10} : n_be15 = 4'b1101; // B215 = RAM15 B115
         {`XSIZ_815, `BSIZ_3215,1'b1, 2'b11} : n_be15 = 4'b1110; // B315 = RAM15 B015
         {`XSIZ_1615,`BSIZ_815, 1'b?, 2'b??} : n_be15 = 4'b1110; // Any15 on RAM15 B015
         {`XSIZ_1615,`BSIZ_1615,1'b?, 2'b??} : n_be15 = 4'b1100; // Any15 on RAMB1015
         {`XSIZ_1615,`BSIZ_3215,1'b0, 2'b0?} : n_be15 = 4'b1100; // B1015 = RAM15 B1015
         {`XSIZ_1615,`BSIZ_3215,1'b0, 2'b1?} : n_be15 = 4'b0011; // B2315 = RAM15 B2315
         {`XSIZ_1615,`BSIZ_3215,1'b1, 2'b0?} : n_be15 = 4'b0011; // B1015 = RAM15 B2315
         {`XSIZ_1615,`BSIZ_3215,1'b1, 2'b1?} : n_be15 = 4'b1100; // B2315 = RAM15 B1015
         {`XSIZ_3215,`BSIZ_815, 1'b?, 2'b??} : n_be15 = 4'b1110; // Any15 on RAM15 B015
         {`XSIZ_3215,`BSIZ_1615,1'b?, 2'b??} : n_be15 = 4'b1100; // Any15 on RAM15 B1015
         {`XSIZ_3215,`BSIZ_3215,1'b?, 2'b??} : n_be15 = 4'b0000; // Any15 on RAM15 B321015
         default                         : n_be15 = 4'b1111; // Invalid15 decode
        
         
         endcase // casex(xfer_bus_size15)
        
       else

         n_be15 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate15 (enternal15) Byte15 Enables15.
//----------------------------------------------------------------------

   always @(posedge sys_clk15 or negedge n_sys_reset15)
     
     begin
        
        if (~n_sys_reset15)
          
           smc_n_be15 <= 4'hF;
        
        
        else if (smc_nextstate15 == `SMC_RW15)
          
           smc_n_be15 <= n_be15;
        
        else
          
           smc_n_be15 <= 4'hF;
        
     end
   
   
endmodule

