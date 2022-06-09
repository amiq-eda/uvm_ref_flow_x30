//File25 name   : smc_addr_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : This25 block registers the address and chip25 select25
//              lines25 for the current access. The address may only
//              driven25 for one cycle by the AHB25. If25 multiple
//              accesses are required25 the bottom25 two25 address bits
//              are modified between cycles25 depending25 on the current
//              transfer25 and bus size.
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

//


`include "smc_defs_lite25.v"

// address decoder25

module smc_addr_lite25    (
                    //inputs25

                    sys_clk25,
                    n_sys_reset25,
                    valid_access25,
                    r_num_access25,
                    v_bus_size25,
                    v_xfer_size25,
                    cs,
                    addr,
                    smc_done25,
                    smc_nextstate25,


                    //outputs25

                    smc_addr25,
                    smc_n_be25,
                    smc_n_cs25,
                    n_be25);



// I25/O25

   input                    sys_clk25;      //AHB25 System25 clock25
   input                    n_sys_reset25;  //AHB25 System25 reset 
   input                    valid_access25; //Start25 of new cycle
   input [1:0]              r_num_access25; //MAC25 counter
   input [1:0]              v_bus_size25;   //bus width for current access
   input [1:0]              v_xfer_size25;  //Transfer25 size for current 
                                              // access
   input               cs;           //Chip25 (Bank25) select25(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done25;     //Transfer25 complete (state 
                                              // machine25)
   input [4:0]              smc_nextstate25;//Next25 state 

   
   output [31:0]            smc_addr25;     //External25 Memory Interface25 
                                              //  address
   output [3:0]             smc_n_be25;     //EMI25 byte enables25 
   output              smc_n_cs25;     //EMI25 Chip25 Selects25 
   output [3:0]             n_be25;         //Unregistered25 Byte25 strobes25
                                             // used to genetate25 
                                             // individual25 write strobes25

// Output25 register declarations25
   
   reg [31:0]                  smc_addr25;
   reg [3:0]                   smc_n_be25;
   reg                    smc_n_cs25;
   reg [3:0]                   n_be25;
   
   
   // Internal register declarations25
   
   reg [1:0]                  r_addr25;           // Stored25 Address bits 
   reg                   r_cs25;             // Stored25 CS25
   reg [1:0]                  v_addr25;           // Validated25 Address
                                                     //  bits
   reg [7:0]                  v_cs25;             // Validated25 CS25
   
   wire                       ored_v_cs25;        //oring25 of v_sc25
   wire [4:0]                 cs_xfer_bus_size25; //concatenated25 bus and 
                                                  // xfer25 size
   wire [2:0]                 wait_access_smdone25;//concatenated25 signal25
   

// Main25 Code25
//----------------------------------------------------------------------
// Address Store25, CS25 Store25 & BE25 Store25
//----------------------------------------------------------------------

   always @(posedge sys_clk25 or negedge n_sys_reset25)
     
     begin
        
        if (~n_sys_reset25)
          
           r_cs25 <= 1'b0;
        
        
        else if (valid_access25)
          
           r_cs25 <= cs ;
        
        else
          
           r_cs25 <= r_cs25 ;
        
     end

//----------------------------------------------------------------------
//v_cs25 generation25   
//----------------------------------------------------------------------
   
   always @(cs or r_cs25 or valid_access25 )
     
     begin
        
        if (valid_access25)
          
           v_cs25 = cs ;
        
        else
          
           v_cs25 = r_cs25;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone25 = {1'b0,valid_access25,smc_done25};

//----------------------------------------------------------------------
//smc_addr25 generation25
//----------------------------------------------------------------------

  always @(posedge sys_clk25 or negedge n_sys_reset25)
    
    begin
      
      if (~n_sys_reset25)
        
         smc_addr25 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone25)
             3'b1xx :

               smc_addr25 <= smc_addr25;
                        //valid_access25 
             3'b01x : begin
               // Set up address for first access
               // little25-endian from max address downto25 0
               // big-endian from 0 upto25 max_address25
               smc_addr25 [31:2] <= addr [31:2];

               casez( { v_xfer_size25, v_bus_size25, 1'b0 } )

               { `XSIZ_3225, `BSIZ_3225, 1'b? } : smc_addr25[1:0] <= 2'b00;
               { `XSIZ_3225, `BSIZ_1625, 1'b0 } : smc_addr25[1:0] <= 2'b10;
               { `XSIZ_3225, `BSIZ_1625, 1'b1 } : smc_addr25[1:0] <= 2'b00;
               { `XSIZ_3225, `BSIZ_825, 1'b0 } :  smc_addr25[1:0] <= 2'b11;
               { `XSIZ_3225, `BSIZ_825, 1'b1 } :  smc_addr25[1:0] <= 2'b00;
               { `XSIZ_1625, `BSIZ_3225, 1'b? } : smc_addr25[1:0] <= {addr[1],1'b0};
               { `XSIZ_1625, `BSIZ_1625, 1'b? } : smc_addr25[1:0] <= {addr[1],1'b0};
               { `XSIZ_1625, `BSIZ_825, 1'b0 } :  smc_addr25[1:0] <= {addr[1],1'b1};
               { `XSIZ_1625, `BSIZ_825, 1'b1 } :  smc_addr25[1:0] <= {addr[1],1'b0};
               { `XSIZ_825, 2'b??, 1'b? } :     smc_addr25[1:0] <= addr[1:0];
               default:                       smc_addr25[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses25 fro25 subsequent25 accesses
                // little25 endian decrements25 according25 to access no.
                // bigendian25 increments25 as access no decrements25

                  smc_addr25[31:2] <= smc_addr25[31:2];
                  
               casez( { v_xfer_size25, v_bus_size25, 1'b0 } )

               { `XSIZ_3225, `BSIZ_3225, 1'b? } : smc_addr25[1:0] <= 2'b00;
               { `XSIZ_3225, `BSIZ_1625, 1'b0 } : smc_addr25[1:0] <= 2'b00;
               { `XSIZ_3225, `BSIZ_1625, 1'b1 } : smc_addr25[1:0] <= 2'b10;
               { `XSIZ_3225, `BSIZ_825,  1'b0 } : 
                  case( r_num_access25 ) 
                  2'b11:   smc_addr25[1:0] <= 2'b10;
                  2'b10:   smc_addr25[1:0] <= 2'b01;
                  2'b01:   smc_addr25[1:0] <= 2'b00;
                  default: smc_addr25[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3225, `BSIZ_825, 1'b1 } :  
                  case( r_num_access25 ) 
                  2'b11:   smc_addr25[1:0] <= 2'b01;
                  2'b10:   smc_addr25[1:0] <= 2'b10;
                  2'b01:   smc_addr25[1:0] <= 2'b11;
                  default: smc_addr25[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1625, `BSIZ_3225, 1'b? } : smc_addr25[1:0] <= {r_addr25[1],1'b0};
               { `XSIZ_1625, `BSIZ_1625, 1'b? } : smc_addr25[1:0] <= {r_addr25[1],1'b0};
               { `XSIZ_1625, `BSIZ_825, 1'b0 } :  smc_addr25[1:0] <= {r_addr25[1],1'b0};
               { `XSIZ_1625, `BSIZ_825, 1'b1 } :  smc_addr25[1:0] <= {r_addr25[1],1'b1};
               { `XSIZ_825, 2'b??, 1'b? } :     smc_addr25[1:0] <= r_addr25[1:0];
               default:                       smc_addr25[1:0] <= r_addr25[1:0];

               endcase
                 
            end
            
            default :

               smc_addr25 <= smc_addr25;
            
          endcase // casex(wait_access_smdone25)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate25 Chip25 Select25 Output25 
//----------------------------------------------------------------------

   always @(posedge sys_clk25 or negedge n_sys_reset25)
     
     begin
        
        if (~n_sys_reset25)
          
          begin
             
             smc_n_cs25 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate25 == `SMC_RW25)
          
           begin
             
              if (valid_access25)
               
                 smc_n_cs25 <= ~cs ;
             
              else
               
                 smc_n_cs25 <= ~r_cs25 ;

           end
        
        else
          
           smc_n_cs25 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch25 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk25 or negedge n_sys_reset25)
     
     begin
        
        if (~n_sys_reset25)
          
           r_addr25 <= 2'd0;
        
        
        else if (valid_access25)
          
           r_addr25 <= addr[1:0];
        
        else
          
           r_addr25 <= r_addr25;
        
     end
   


//----------------------------------------------------------------------
// Validate25 LSB of addr with valid_access25
//----------------------------------------------------------------------

   always @(r_addr25 or valid_access25 or addr)
     
      begin
        
         if (valid_access25)
           
            v_addr25 = addr[1:0];
         
         else
           
            v_addr25 = r_addr25;
         
      end
//----------------------------------------------------------------------
//cancatenation25 of signals25
//----------------------------------------------------------------------
                               //check for v_cs25 = 0
   assign ored_v_cs25 = |v_cs25;   //signal25 concatenation25 to be used in case
   
//----------------------------------------------------------------------
// Generate25 (internal) Byte25 Enables25.
//----------------------------------------------------------------------

   always @(v_cs25 or v_xfer_size25 or v_bus_size25 or v_addr25 )
     
     begin

       if ( |v_cs25 == 1'b1 ) 
        
         casez( {v_xfer_size25, v_bus_size25, 1'b0, v_addr25[1:0] } )
          
         {`XSIZ_825, `BSIZ_825, 1'b?, 2'b??} : n_be25 = 4'b1110; // Any25 on RAM25 B025
         {`XSIZ_825, `BSIZ_1625,1'b0, 2'b?0} : n_be25 = 4'b1110; // B225 or B025 = RAM25 B025
         {`XSIZ_825, `BSIZ_1625,1'b0, 2'b?1} : n_be25 = 4'b1101; // B325 or B125 = RAM25 B125
         {`XSIZ_825, `BSIZ_1625,1'b1, 2'b?0} : n_be25 = 4'b1101; // B225 or B025 = RAM25 B125
         {`XSIZ_825, `BSIZ_1625,1'b1, 2'b?1} : n_be25 = 4'b1110; // B325 or B125 = RAM25 B025
         {`XSIZ_825, `BSIZ_3225,1'b0, 2'b00} : n_be25 = 4'b1110; // B025 = RAM25 B025
         {`XSIZ_825, `BSIZ_3225,1'b0, 2'b01} : n_be25 = 4'b1101; // B125 = RAM25 B125
         {`XSIZ_825, `BSIZ_3225,1'b0, 2'b10} : n_be25 = 4'b1011; // B225 = RAM25 B225
         {`XSIZ_825, `BSIZ_3225,1'b0, 2'b11} : n_be25 = 4'b0111; // B325 = RAM25 B325
         {`XSIZ_825, `BSIZ_3225,1'b1, 2'b00} : n_be25 = 4'b0111; // B025 = RAM25 B325
         {`XSIZ_825, `BSIZ_3225,1'b1, 2'b01} : n_be25 = 4'b1011; // B125 = RAM25 B225
         {`XSIZ_825, `BSIZ_3225,1'b1, 2'b10} : n_be25 = 4'b1101; // B225 = RAM25 B125
         {`XSIZ_825, `BSIZ_3225,1'b1, 2'b11} : n_be25 = 4'b1110; // B325 = RAM25 B025
         {`XSIZ_1625,`BSIZ_825, 1'b?, 2'b??} : n_be25 = 4'b1110; // Any25 on RAM25 B025
         {`XSIZ_1625,`BSIZ_1625,1'b?, 2'b??} : n_be25 = 4'b1100; // Any25 on RAMB1025
         {`XSIZ_1625,`BSIZ_3225,1'b0, 2'b0?} : n_be25 = 4'b1100; // B1025 = RAM25 B1025
         {`XSIZ_1625,`BSIZ_3225,1'b0, 2'b1?} : n_be25 = 4'b0011; // B2325 = RAM25 B2325
         {`XSIZ_1625,`BSIZ_3225,1'b1, 2'b0?} : n_be25 = 4'b0011; // B1025 = RAM25 B2325
         {`XSIZ_1625,`BSIZ_3225,1'b1, 2'b1?} : n_be25 = 4'b1100; // B2325 = RAM25 B1025
         {`XSIZ_3225,`BSIZ_825, 1'b?, 2'b??} : n_be25 = 4'b1110; // Any25 on RAM25 B025
         {`XSIZ_3225,`BSIZ_1625,1'b?, 2'b??} : n_be25 = 4'b1100; // Any25 on RAM25 B1025
         {`XSIZ_3225,`BSIZ_3225,1'b?, 2'b??} : n_be25 = 4'b0000; // Any25 on RAM25 B321025
         default                         : n_be25 = 4'b1111; // Invalid25 decode
        
         
         endcase // casex(xfer_bus_size25)
        
       else

         n_be25 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate25 (enternal25) Byte25 Enables25.
//----------------------------------------------------------------------

   always @(posedge sys_clk25 or negedge n_sys_reset25)
     
     begin
        
        if (~n_sys_reset25)
          
           smc_n_be25 <= 4'hF;
        
        
        else if (smc_nextstate25 == `SMC_RW25)
          
           smc_n_be25 <= n_be25;
        
        else
          
           smc_n_be25 <= 4'hF;
        
     end
   
   
endmodule

