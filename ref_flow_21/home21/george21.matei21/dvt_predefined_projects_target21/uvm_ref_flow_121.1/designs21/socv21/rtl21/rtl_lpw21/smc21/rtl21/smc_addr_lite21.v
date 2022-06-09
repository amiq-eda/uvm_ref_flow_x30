//File21 name   : smc_addr_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : This21 block registers the address and chip21 select21
//              lines21 for the current access. The address may only
//              driven21 for one cycle by the AHB21. If21 multiple
//              accesses are required21 the bottom21 two21 address bits
//              are modified between cycles21 depending21 on the current
//              transfer21 and bus size.
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

//


`include "smc_defs_lite21.v"

// address decoder21

module smc_addr_lite21    (
                    //inputs21

                    sys_clk21,
                    n_sys_reset21,
                    valid_access21,
                    r_num_access21,
                    v_bus_size21,
                    v_xfer_size21,
                    cs,
                    addr,
                    smc_done21,
                    smc_nextstate21,


                    //outputs21

                    smc_addr21,
                    smc_n_be21,
                    smc_n_cs21,
                    n_be21);



// I21/O21

   input                    sys_clk21;      //AHB21 System21 clock21
   input                    n_sys_reset21;  //AHB21 System21 reset 
   input                    valid_access21; //Start21 of new cycle
   input [1:0]              r_num_access21; //MAC21 counter
   input [1:0]              v_bus_size21;   //bus width for current access
   input [1:0]              v_xfer_size21;  //Transfer21 size for current 
                                              // access
   input               cs;           //Chip21 (Bank21) select21(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done21;     //Transfer21 complete (state 
                                              // machine21)
   input [4:0]              smc_nextstate21;//Next21 state 

   
   output [31:0]            smc_addr21;     //External21 Memory Interface21 
                                              //  address
   output [3:0]             smc_n_be21;     //EMI21 byte enables21 
   output              smc_n_cs21;     //EMI21 Chip21 Selects21 
   output [3:0]             n_be21;         //Unregistered21 Byte21 strobes21
                                             // used to genetate21 
                                             // individual21 write strobes21

// Output21 register declarations21
   
   reg [31:0]                  smc_addr21;
   reg [3:0]                   smc_n_be21;
   reg                    smc_n_cs21;
   reg [3:0]                   n_be21;
   
   
   // Internal register declarations21
   
   reg [1:0]                  r_addr21;           // Stored21 Address bits 
   reg                   r_cs21;             // Stored21 CS21
   reg [1:0]                  v_addr21;           // Validated21 Address
                                                     //  bits
   reg [7:0]                  v_cs21;             // Validated21 CS21
   
   wire                       ored_v_cs21;        //oring21 of v_sc21
   wire [4:0]                 cs_xfer_bus_size21; //concatenated21 bus and 
                                                  // xfer21 size
   wire [2:0]                 wait_access_smdone21;//concatenated21 signal21
   

// Main21 Code21
//----------------------------------------------------------------------
// Address Store21, CS21 Store21 & BE21 Store21
//----------------------------------------------------------------------

   always @(posedge sys_clk21 or negedge n_sys_reset21)
     
     begin
        
        if (~n_sys_reset21)
          
           r_cs21 <= 1'b0;
        
        
        else if (valid_access21)
          
           r_cs21 <= cs ;
        
        else
          
           r_cs21 <= r_cs21 ;
        
     end

//----------------------------------------------------------------------
//v_cs21 generation21   
//----------------------------------------------------------------------
   
   always @(cs or r_cs21 or valid_access21 )
     
     begin
        
        if (valid_access21)
          
           v_cs21 = cs ;
        
        else
          
           v_cs21 = r_cs21;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone21 = {1'b0,valid_access21,smc_done21};

//----------------------------------------------------------------------
//smc_addr21 generation21
//----------------------------------------------------------------------

  always @(posedge sys_clk21 or negedge n_sys_reset21)
    
    begin
      
      if (~n_sys_reset21)
        
         smc_addr21 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone21)
             3'b1xx :

               smc_addr21 <= smc_addr21;
                        //valid_access21 
             3'b01x : begin
               // Set up address for first access
               // little21-endian from max address downto21 0
               // big-endian from 0 upto21 max_address21
               smc_addr21 [31:2] <= addr [31:2];

               casez( { v_xfer_size21, v_bus_size21, 1'b0 } )

               { `XSIZ_3221, `BSIZ_3221, 1'b? } : smc_addr21[1:0] <= 2'b00;
               { `XSIZ_3221, `BSIZ_1621, 1'b0 } : smc_addr21[1:0] <= 2'b10;
               { `XSIZ_3221, `BSIZ_1621, 1'b1 } : smc_addr21[1:0] <= 2'b00;
               { `XSIZ_3221, `BSIZ_821, 1'b0 } :  smc_addr21[1:0] <= 2'b11;
               { `XSIZ_3221, `BSIZ_821, 1'b1 } :  smc_addr21[1:0] <= 2'b00;
               { `XSIZ_1621, `BSIZ_3221, 1'b? } : smc_addr21[1:0] <= {addr[1],1'b0};
               { `XSIZ_1621, `BSIZ_1621, 1'b? } : smc_addr21[1:0] <= {addr[1],1'b0};
               { `XSIZ_1621, `BSIZ_821, 1'b0 } :  smc_addr21[1:0] <= {addr[1],1'b1};
               { `XSIZ_1621, `BSIZ_821, 1'b1 } :  smc_addr21[1:0] <= {addr[1],1'b0};
               { `XSIZ_821, 2'b??, 1'b? } :     smc_addr21[1:0] <= addr[1:0];
               default:                       smc_addr21[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses21 fro21 subsequent21 accesses
                // little21 endian decrements21 according21 to access no.
                // bigendian21 increments21 as access no decrements21

                  smc_addr21[31:2] <= smc_addr21[31:2];
                  
               casez( { v_xfer_size21, v_bus_size21, 1'b0 } )

               { `XSIZ_3221, `BSIZ_3221, 1'b? } : smc_addr21[1:0] <= 2'b00;
               { `XSIZ_3221, `BSIZ_1621, 1'b0 } : smc_addr21[1:0] <= 2'b00;
               { `XSIZ_3221, `BSIZ_1621, 1'b1 } : smc_addr21[1:0] <= 2'b10;
               { `XSIZ_3221, `BSIZ_821,  1'b0 } : 
                  case( r_num_access21 ) 
                  2'b11:   smc_addr21[1:0] <= 2'b10;
                  2'b10:   smc_addr21[1:0] <= 2'b01;
                  2'b01:   smc_addr21[1:0] <= 2'b00;
                  default: smc_addr21[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3221, `BSIZ_821, 1'b1 } :  
                  case( r_num_access21 ) 
                  2'b11:   smc_addr21[1:0] <= 2'b01;
                  2'b10:   smc_addr21[1:0] <= 2'b10;
                  2'b01:   smc_addr21[1:0] <= 2'b11;
                  default: smc_addr21[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1621, `BSIZ_3221, 1'b? } : smc_addr21[1:0] <= {r_addr21[1],1'b0};
               { `XSIZ_1621, `BSIZ_1621, 1'b? } : smc_addr21[1:0] <= {r_addr21[1],1'b0};
               { `XSIZ_1621, `BSIZ_821, 1'b0 } :  smc_addr21[1:0] <= {r_addr21[1],1'b0};
               { `XSIZ_1621, `BSIZ_821, 1'b1 } :  smc_addr21[1:0] <= {r_addr21[1],1'b1};
               { `XSIZ_821, 2'b??, 1'b? } :     smc_addr21[1:0] <= r_addr21[1:0];
               default:                       smc_addr21[1:0] <= r_addr21[1:0];

               endcase
                 
            end
            
            default :

               smc_addr21 <= smc_addr21;
            
          endcase // casex(wait_access_smdone21)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate21 Chip21 Select21 Output21 
//----------------------------------------------------------------------

   always @(posedge sys_clk21 or negedge n_sys_reset21)
     
     begin
        
        if (~n_sys_reset21)
          
          begin
             
             smc_n_cs21 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate21 == `SMC_RW21)
          
           begin
             
              if (valid_access21)
               
                 smc_n_cs21 <= ~cs ;
             
              else
               
                 smc_n_cs21 <= ~r_cs21 ;

           end
        
        else
          
           smc_n_cs21 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch21 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk21 or negedge n_sys_reset21)
     
     begin
        
        if (~n_sys_reset21)
          
           r_addr21 <= 2'd0;
        
        
        else if (valid_access21)
          
           r_addr21 <= addr[1:0];
        
        else
          
           r_addr21 <= r_addr21;
        
     end
   


//----------------------------------------------------------------------
// Validate21 LSB of addr with valid_access21
//----------------------------------------------------------------------

   always @(r_addr21 or valid_access21 or addr)
     
      begin
        
         if (valid_access21)
           
            v_addr21 = addr[1:0];
         
         else
           
            v_addr21 = r_addr21;
         
      end
//----------------------------------------------------------------------
//cancatenation21 of signals21
//----------------------------------------------------------------------
                               //check for v_cs21 = 0
   assign ored_v_cs21 = |v_cs21;   //signal21 concatenation21 to be used in case
   
//----------------------------------------------------------------------
// Generate21 (internal) Byte21 Enables21.
//----------------------------------------------------------------------

   always @(v_cs21 or v_xfer_size21 or v_bus_size21 or v_addr21 )
     
     begin

       if ( |v_cs21 == 1'b1 ) 
        
         casez( {v_xfer_size21, v_bus_size21, 1'b0, v_addr21[1:0] } )
          
         {`XSIZ_821, `BSIZ_821, 1'b?, 2'b??} : n_be21 = 4'b1110; // Any21 on RAM21 B021
         {`XSIZ_821, `BSIZ_1621,1'b0, 2'b?0} : n_be21 = 4'b1110; // B221 or B021 = RAM21 B021
         {`XSIZ_821, `BSIZ_1621,1'b0, 2'b?1} : n_be21 = 4'b1101; // B321 or B121 = RAM21 B121
         {`XSIZ_821, `BSIZ_1621,1'b1, 2'b?0} : n_be21 = 4'b1101; // B221 or B021 = RAM21 B121
         {`XSIZ_821, `BSIZ_1621,1'b1, 2'b?1} : n_be21 = 4'b1110; // B321 or B121 = RAM21 B021
         {`XSIZ_821, `BSIZ_3221,1'b0, 2'b00} : n_be21 = 4'b1110; // B021 = RAM21 B021
         {`XSIZ_821, `BSIZ_3221,1'b0, 2'b01} : n_be21 = 4'b1101; // B121 = RAM21 B121
         {`XSIZ_821, `BSIZ_3221,1'b0, 2'b10} : n_be21 = 4'b1011; // B221 = RAM21 B221
         {`XSIZ_821, `BSIZ_3221,1'b0, 2'b11} : n_be21 = 4'b0111; // B321 = RAM21 B321
         {`XSIZ_821, `BSIZ_3221,1'b1, 2'b00} : n_be21 = 4'b0111; // B021 = RAM21 B321
         {`XSIZ_821, `BSIZ_3221,1'b1, 2'b01} : n_be21 = 4'b1011; // B121 = RAM21 B221
         {`XSIZ_821, `BSIZ_3221,1'b1, 2'b10} : n_be21 = 4'b1101; // B221 = RAM21 B121
         {`XSIZ_821, `BSIZ_3221,1'b1, 2'b11} : n_be21 = 4'b1110; // B321 = RAM21 B021
         {`XSIZ_1621,`BSIZ_821, 1'b?, 2'b??} : n_be21 = 4'b1110; // Any21 on RAM21 B021
         {`XSIZ_1621,`BSIZ_1621,1'b?, 2'b??} : n_be21 = 4'b1100; // Any21 on RAMB1021
         {`XSIZ_1621,`BSIZ_3221,1'b0, 2'b0?} : n_be21 = 4'b1100; // B1021 = RAM21 B1021
         {`XSIZ_1621,`BSIZ_3221,1'b0, 2'b1?} : n_be21 = 4'b0011; // B2321 = RAM21 B2321
         {`XSIZ_1621,`BSIZ_3221,1'b1, 2'b0?} : n_be21 = 4'b0011; // B1021 = RAM21 B2321
         {`XSIZ_1621,`BSIZ_3221,1'b1, 2'b1?} : n_be21 = 4'b1100; // B2321 = RAM21 B1021
         {`XSIZ_3221,`BSIZ_821, 1'b?, 2'b??} : n_be21 = 4'b1110; // Any21 on RAM21 B021
         {`XSIZ_3221,`BSIZ_1621,1'b?, 2'b??} : n_be21 = 4'b1100; // Any21 on RAM21 B1021
         {`XSIZ_3221,`BSIZ_3221,1'b?, 2'b??} : n_be21 = 4'b0000; // Any21 on RAM21 B321021
         default                         : n_be21 = 4'b1111; // Invalid21 decode
        
         
         endcase // casex(xfer_bus_size21)
        
       else

         n_be21 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate21 (enternal21) Byte21 Enables21.
//----------------------------------------------------------------------

   always @(posedge sys_clk21 or negedge n_sys_reset21)
     
     begin
        
        if (~n_sys_reset21)
          
           smc_n_be21 <= 4'hF;
        
        
        else if (smc_nextstate21 == `SMC_RW21)
          
           smc_n_be21 <= n_be21;
        
        else
          
           smc_n_be21 <= 4'hF;
        
     end
   
   
endmodule

