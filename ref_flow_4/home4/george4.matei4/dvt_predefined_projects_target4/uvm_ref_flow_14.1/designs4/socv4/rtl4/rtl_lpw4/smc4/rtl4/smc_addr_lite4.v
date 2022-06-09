//File4 name   : smc_addr_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : This4 block registers the address and chip4 select4
//              lines4 for the current access. The address may only
//              driven4 for one cycle by the AHB4. If4 multiple
//              accesses are required4 the bottom4 two4 address bits
//              are modified between cycles4 depending4 on the current
//              transfer4 and bus size.
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

//


`include "smc_defs_lite4.v"

// address decoder4

module smc_addr_lite4    (
                    //inputs4

                    sys_clk4,
                    n_sys_reset4,
                    valid_access4,
                    r_num_access4,
                    v_bus_size4,
                    v_xfer_size4,
                    cs,
                    addr,
                    smc_done4,
                    smc_nextstate4,


                    //outputs4

                    smc_addr4,
                    smc_n_be4,
                    smc_n_cs4,
                    n_be4);



// I4/O4

   input                    sys_clk4;      //AHB4 System4 clock4
   input                    n_sys_reset4;  //AHB4 System4 reset 
   input                    valid_access4; //Start4 of new cycle
   input [1:0]              r_num_access4; //MAC4 counter
   input [1:0]              v_bus_size4;   //bus width for current access
   input [1:0]              v_xfer_size4;  //Transfer4 size for current 
                                              // access
   input               cs;           //Chip4 (Bank4) select4(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done4;     //Transfer4 complete (state 
                                              // machine4)
   input [4:0]              smc_nextstate4;//Next4 state 

   
   output [31:0]            smc_addr4;     //External4 Memory Interface4 
                                              //  address
   output [3:0]             smc_n_be4;     //EMI4 byte enables4 
   output              smc_n_cs4;     //EMI4 Chip4 Selects4 
   output [3:0]             n_be4;         //Unregistered4 Byte4 strobes4
                                             // used to genetate4 
                                             // individual4 write strobes4

// Output4 register declarations4
   
   reg [31:0]                  smc_addr4;
   reg [3:0]                   smc_n_be4;
   reg                    smc_n_cs4;
   reg [3:0]                   n_be4;
   
   
   // Internal register declarations4
   
   reg [1:0]                  r_addr4;           // Stored4 Address bits 
   reg                   r_cs4;             // Stored4 CS4
   reg [1:0]                  v_addr4;           // Validated4 Address
                                                     //  bits
   reg [7:0]                  v_cs4;             // Validated4 CS4
   
   wire                       ored_v_cs4;        //oring4 of v_sc4
   wire [4:0]                 cs_xfer_bus_size4; //concatenated4 bus and 
                                                  // xfer4 size
   wire [2:0]                 wait_access_smdone4;//concatenated4 signal4
   

// Main4 Code4
//----------------------------------------------------------------------
// Address Store4, CS4 Store4 & BE4 Store4
//----------------------------------------------------------------------

   always @(posedge sys_clk4 or negedge n_sys_reset4)
     
     begin
        
        if (~n_sys_reset4)
          
           r_cs4 <= 1'b0;
        
        
        else if (valid_access4)
          
           r_cs4 <= cs ;
        
        else
          
           r_cs4 <= r_cs4 ;
        
     end

//----------------------------------------------------------------------
//v_cs4 generation4   
//----------------------------------------------------------------------
   
   always @(cs or r_cs4 or valid_access4 )
     
     begin
        
        if (valid_access4)
          
           v_cs4 = cs ;
        
        else
          
           v_cs4 = r_cs4;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone4 = {1'b0,valid_access4,smc_done4};

//----------------------------------------------------------------------
//smc_addr4 generation4
//----------------------------------------------------------------------

  always @(posedge sys_clk4 or negedge n_sys_reset4)
    
    begin
      
      if (~n_sys_reset4)
        
         smc_addr4 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone4)
             3'b1xx :

               smc_addr4 <= smc_addr4;
                        //valid_access4 
             3'b01x : begin
               // Set up address for first access
               // little4-endian from max address downto4 0
               // big-endian from 0 upto4 max_address4
               smc_addr4 [31:2] <= addr [31:2];

               casez( { v_xfer_size4, v_bus_size4, 1'b0 } )

               { `XSIZ_324, `BSIZ_324, 1'b? } : smc_addr4[1:0] <= 2'b00;
               { `XSIZ_324, `BSIZ_164, 1'b0 } : smc_addr4[1:0] <= 2'b10;
               { `XSIZ_324, `BSIZ_164, 1'b1 } : smc_addr4[1:0] <= 2'b00;
               { `XSIZ_324, `BSIZ_84, 1'b0 } :  smc_addr4[1:0] <= 2'b11;
               { `XSIZ_324, `BSIZ_84, 1'b1 } :  smc_addr4[1:0] <= 2'b00;
               { `XSIZ_164, `BSIZ_324, 1'b? } : smc_addr4[1:0] <= {addr[1],1'b0};
               { `XSIZ_164, `BSIZ_164, 1'b? } : smc_addr4[1:0] <= {addr[1],1'b0};
               { `XSIZ_164, `BSIZ_84, 1'b0 } :  smc_addr4[1:0] <= {addr[1],1'b1};
               { `XSIZ_164, `BSIZ_84, 1'b1 } :  smc_addr4[1:0] <= {addr[1],1'b0};
               { `XSIZ_84, 2'b??, 1'b? } :     smc_addr4[1:0] <= addr[1:0];
               default:                       smc_addr4[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses4 fro4 subsequent4 accesses
                // little4 endian decrements4 according4 to access no.
                // bigendian4 increments4 as access no decrements4

                  smc_addr4[31:2] <= smc_addr4[31:2];
                  
               casez( { v_xfer_size4, v_bus_size4, 1'b0 } )

               { `XSIZ_324, `BSIZ_324, 1'b? } : smc_addr4[1:0] <= 2'b00;
               { `XSIZ_324, `BSIZ_164, 1'b0 } : smc_addr4[1:0] <= 2'b00;
               { `XSIZ_324, `BSIZ_164, 1'b1 } : smc_addr4[1:0] <= 2'b10;
               { `XSIZ_324, `BSIZ_84,  1'b0 } : 
                  case( r_num_access4 ) 
                  2'b11:   smc_addr4[1:0] <= 2'b10;
                  2'b10:   smc_addr4[1:0] <= 2'b01;
                  2'b01:   smc_addr4[1:0] <= 2'b00;
                  default: smc_addr4[1:0] <= 2'b11;
                  endcase
               { `XSIZ_324, `BSIZ_84, 1'b1 } :  
                  case( r_num_access4 ) 
                  2'b11:   smc_addr4[1:0] <= 2'b01;
                  2'b10:   smc_addr4[1:0] <= 2'b10;
                  2'b01:   smc_addr4[1:0] <= 2'b11;
                  default: smc_addr4[1:0] <= 2'b00;
                  endcase
               { `XSIZ_164, `BSIZ_324, 1'b? } : smc_addr4[1:0] <= {r_addr4[1],1'b0};
               { `XSIZ_164, `BSIZ_164, 1'b? } : smc_addr4[1:0] <= {r_addr4[1],1'b0};
               { `XSIZ_164, `BSIZ_84, 1'b0 } :  smc_addr4[1:0] <= {r_addr4[1],1'b0};
               { `XSIZ_164, `BSIZ_84, 1'b1 } :  smc_addr4[1:0] <= {r_addr4[1],1'b1};
               { `XSIZ_84, 2'b??, 1'b? } :     smc_addr4[1:0] <= r_addr4[1:0];
               default:                       smc_addr4[1:0] <= r_addr4[1:0];

               endcase
                 
            end
            
            default :

               smc_addr4 <= smc_addr4;
            
          endcase // casex(wait_access_smdone4)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate4 Chip4 Select4 Output4 
//----------------------------------------------------------------------

   always @(posedge sys_clk4 or negedge n_sys_reset4)
     
     begin
        
        if (~n_sys_reset4)
          
          begin
             
             smc_n_cs4 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate4 == `SMC_RW4)
          
           begin
             
              if (valid_access4)
               
                 smc_n_cs4 <= ~cs ;
             
              else
               
                 smc_n_cs4 <= ~r_cs4 ;

           end
        
        else
          
           smc_n_cs4 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch4 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk4 or negedge n_sys_reset4)
     
     begin
        
        if (~n_sys_reset4)
          
           r_addr4 <= 2'd0;
        
        
        else if (valid_access4)
          
           r_addr4 <= addr[1:0];
        
        else
          
           r_addr4 <= r_addr4;
        
     end
   


//----------------------------------------------------------------------
// Validate4 LSB of addr with valid_access4
//----------------------------------------------------------------------

   always @(r_addr4 or valid_access4 or addr)
     
      begin
        
         if (valid_access4)
           
            v_addr4 = addr[1:0];
         
         else
           
            v_addr4 = r_addr4;
         
      end
//----------------------------------------------------------------------
//cancatenation4 of signals4
//----------------------------------------------------------------------
                               //check for v_cs4 = 0
   assign ored_v_cs4 = |v_cs4;   //signal4 concatenation4 to be used in case
   
//----------------------------------------------------------------------
// Generate4 (internal) Byte4 Enables4.
//----------------------------------------------------------------------

   always @(v_cs4 or v_xfer_size4 or v_bus_size4 or v_addr4 )
     
     begin

       if ( |v_cs4 == 1'b1 ) 
        
         casez( {v_xfer_size4, v_bus_size4, 1'b0, v_addr4[1:0] } )
          
         {`XSIZ_84, `BSIZ_84, 1'b?, 2'b??} : n_be4 = 4'b1110; // Any4 on RAM4 B04
         {`XSIZ_84, `BSIZ_164,1'b0, 2'b?0} : n_be4 = 4'b1110; // B24 or B04 = RAM4 B04
         {`XSIZ_84, `BSIZ_164,1'b0, 2'b?1} : n_be4 = 4'b1101; // B34 or B14 = RAM4 B14
         {`XSIZ_84, `BSIZ_164,1'b1, 2'b?0} : n_be4 = 4'b1101; // B24 or B04 = RAM4 B14
         {`XSIZ_84, `BSIZ_164,1'b1, 2'b?1} : n_be4 = 4'b1110; // B34 or B14 = RAM4 B04
         {`XSIZ_84, `BSIZ_324,1'b0, 2'b00} : n_be4 = 4'b1110; // B04 = RAM4 B04
         {`XSIZ_84, `BSIZ_324,1'b0, 2'b01} : n_be4 = 4'b1101; // B14 = RAM4 B14
         {`XSIZ_84, `BSIZ_324,1'b0, 2'b10} : n_be4 = 4'b1011; // B24 = RAM4 B24
         {`XSIZ_84, `BSIZ_324,1'b0, 2'b11} : n_be4 = 4'b0111; // B34 = RAM4 B34
         {`XSIZ_84, `BSIZ_324,1'b1, 2'b00} : n_be4 = 4'b0111; // B04 = RAM4 B34
         {`XSIZ_84, `BSIZ_324,1'b1, 2'b01} : n_be4 = 4'b1011; // B14 = RAM4 B24
         {`XSIZ_84, `BSIZ_324,1'b1, 2'b10} : n_be4 = 4'b1101; // B24 = RAM4 B14
         {`XSIZ_84, `BSIZ_324,1'b1, 2'b11} : n_be4 = 4'b1110; // B34 = RAM4 B04
         {`XSIZ_164,`BSIZ_84, 1'b?, 2'b??} : n_be4 = 4'b1110; // Any4 on RAM4 B04
         {`XSIZ_164,`BSIZ_164,1'b?, 2'b??} : n_be4 = 4'b1100; // Any4 on RAMB104
         {`XSIZ_164,`BSIZ_324,1'b0, 2'b0?} : n_be4 = 4'b1100; // B104 = RAM4 B104
         {`XSIZ_164,`BSIZ_324,1'b0, 2'b1?} : n_be4 = 4'b0011; // B234 = RAM4 B234
         {`XSIZ_164,`BSIZ_324,1'b1, 2'b0?} : n_be4 = 4'b0011; // B104 = RAM4 B234
         {`XSIZ_164,`BSIZ_324,1'b1, 2'b1?} : n_be4 = 4'b1100; // B234 = RAM4 B104
         {`XSIZ_324,`BSIZ_84, 1'b?, 2'b??} : n_be4 = 4'b1110; // Any4 on RAM4 B04
         {`XSIZ_324,`BSIZ_164,1'b?, 2'b??} : n_be4 = 4'b1100; // Any4 on RAM4 B104
         {`XSIZ_324,`BSIZ_324,1'b?, 2'b??} : n_be4 = 4'b0000; // Any4 on RAM4 B32104
         default                         : n_be4 = 4'b1111; // Invalid4 decode
        
         
         endcase // casex(xfer_bus_size4)
        
       else

         n_be4 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate4 (enternal4) Byte4 Enables4.
//----------------------------------------------------------------------

   always @(posedge sys_clk4 or negedge n_sys_reset4)
     
     begin
        
        if (~n_sys_reset4)
          
           smc_n_be4 <= 4'hF;
        
        
        else if (smc_nextstate4 == `SMC_RW4)
          
           smc_n_be4 <= n_be4;
        
        else
          
           smc_n_be4 <= 4'hF;
        
     end
   
   
endmodule

