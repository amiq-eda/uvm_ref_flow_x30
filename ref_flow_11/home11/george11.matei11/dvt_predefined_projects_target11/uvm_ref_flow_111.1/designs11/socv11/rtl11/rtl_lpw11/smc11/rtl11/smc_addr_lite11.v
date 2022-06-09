//File11 name   : smc_addr_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : This11 block registers the address and chip11 select11
//              lines11 for the current access. The address may only
//              driven11 for one cycle by the AHB11. If11 multiple
//              accesses are required11 the bottom11 two11 address bits
//              are modified between cycles11 depending11 on the current
//              transfer11 and bus size.
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

//


`include "smc_defs_lite11.v"

// address decoder11

module smc_addr_lite11    (
                    //inputs11

                    sys_clk11,
                    n_sys_reset11,
                    valid_access11,
                    r_num_access11,
                    v_bus_size11,
                    v_xfer_size11,
                    cs,
                    addr,
                    smc_done11,
                    smc_nextstate11,


                    //outputs11

                    smc_addr11,
                    smc_n_be11,
                    smc_n_cs11,
                    n_be11);



// I11/O11

   input                    sys_clk11;      //AHB11 System11 clock11
   input                    n_sys_reset11;  //AHB11 System11 reset 
   input                    valid_access11; //Start11 of new cycle
   input [1:0]              r_num_access11; //MAC11 counter
   input [1:0]              v_bus_size11;   //bus width for current access
   input [1:0]              v_xfer_size11;  //Transfer11 size for current 
                                              // access
   input               cs;           //Chip11 (Bank11) select11(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done11;     //Transfer11 complete (state 
                                              // machine11)
   input [4:0]              smc_nextstate11;//Next11 state 

   
   output [31:0]            smc_addr11;     //External11 Memory Interface11 
                                              //  address
   output [3:0]             smc_n_be11;     //EMI11 byte enables11 
   output              smc_n_cs11;     //EMI11 Chip11 Selects11 
   output [3:0]             n_be11;         //Unregistered11 Byte11 strobes11
                                             // used to genetate11 
                                             // individual11 write strobes11

// Output11 register declarations11
   
   reg [31:0]                  smc_addr11;
   reg [3:0]                   smc_n_be11;
   reg                    smc_n_cs11;
   reg [3:0]                   n_be11;
   
   
   // Internal register declarations11
   
   reg [1:0]                  r_addr11;           // Stored11 Address bits 
   reg                   r_cs11;             // Stored11 CS11
   reg [1:0]                  v_addr11;           // Validated11 Address
                                                     //  bits
   reg [7:0]                  v_cs11;             // Validated11 CS11
   
   wire                       ored_v_cs11;        //oring11 of v_sc11
   wire [4:0]                 cs_xfer_bus_size11; //concatenated11 bus and 
                                                  // xfer11 size
   wire [2:0]                 wait_access_smdone11;//concatenated11 signal11
   

// Main11 Code11
//----------------------------------------------------------------------
// Address Store11, CS11 Store11 & BE11 Store11
//----------------------------------------------------------------------

   always @(posedge sys_clk11 or negedge n_sys_reset11)
     
     begin
        
        if (~n_sys_reset11)
          
           r_cs11 <= 1'b0;
        
        
        else if (valid_access11)
          
           r_cs11 <= cs ;
        
        else
          
           r_cs11 <= r_cs11 ;
        
     end

//----------------------------------------------------------------------
//v_cs11 generation11   
//----------------------------------------------------------------------
   
   always @(cs or r_cs11 or valid_access11 )
     
     begin
        
        if (valid_access11)
          
           v_cs11 = cs ;
        
        else
          
           v_cs11 = r_cs11;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone11 = {1'b0,valid_access11,smc_done11};

//----------------------------------------------------------------------
//smc_addr11 generation11
//----------------------------------------------------------------------

  always @(posedge sys_clk11 or negedge n_sys_reset11)
    
    begin
      
      if (~n_sys_reset11)
        
         smc_addr11 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone11)
             3'b1xx :

               smc_addr11 <= smc_addr11;
                        //valid_access11 
             3'b01x : begin
               // Set up address for first access
               // little11-endian from max address downto11 0
               // big-endian from 0 upto11 max_address11
               smc_addr11 [31:2] <= addr [31:2];

               casez( { v_xfer_size11, v_bus_size11, 1'b0 } )

               { `XSIZ_3211, `BSIZ_3211, 1'b? } : smc_addr11[1:0] <= 2'b00;
               { `XSIZ_3211, `BSIZ_1611, 1'b0 } : smc_addr11[1:0] <= 2'b10;
               { `XSIZ_3211, `BSIZ_1611, 1'b1 } : smc_addr11[1:0] <= 2'b00;
               { `XSIZ_3211, `BSIZ_811, 1'b0 } :  smc_addr11[1:0] <= 2'b11;
               { `XSIZ_3211, `BSIZ_811, 1'b1 } :  smc_addr11[1:0] <= 2'b00;
               { `XSIZ_1611, `BSIZ_3211, 1'b? } : smc_addr11[1:0] <= {addr[1],1'b0};
               { `XSIZ_1611, `BSIZ_1611, 1'b? } : smc_addr11[1:0] <= {addr[1],1'b0};
               { `XSIZ_1611, `BSIZ_811, 1'b0 } :  smc_addr11[1:0] <= {addr[1],1'b1};
               { `XSIZ_1611, `BSIZ_811, 1'b1 } :  smc_addr11[1:0] <= {addr[1],1'b0};
               { `XSIZ_811, 2'b??, 1'b? } :     smc_addr11[1:0] <= addr[1:0];
               default:                       smc_addr11[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses11 fro11 subsequent11 accesses
                // little11 endian decrements11 according11 to access no.
                // bigendian11 increments11 as access no decrements11

                  smc_addr11[31:2] <= smc_addr11[31:2];
                  
               casez( { v_xfer_size11, v_bus_size11, 1'b0 } )

               { `XSIZ_3211, `BSIZ_3211, 1'b? } : smc_addr11[1:0] <= 2'b00;
               { `XSIZ_3211, `BSIZ_1611, 1'b0 } : smc_addr11[1:0] <= 2'b00;
               { `XSIZ_3211, `BSIZ_1611, 1'b1 } : smc_addr11[1:0] <= 2'b10;
               { `XSIZ_3211, `BSIZ_811,  1'b0 } : 
                  case( r_num_access11 ) 
                  2'b11:   smc_addr11[1:0] <= 2'b10;
                  2'b10:   smc_addr11[1:0] <= 2'b01;
                  2'b01:   smc_addr11[1:0] <= 2'b00;
                  default: smc_addr11[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3211, `BSIZ_811, 1'b1 } :  
                  case( r_num_access11 ) 
                  2'b11:   smc_addr11[1:0] <= 2'b01;
                  2'b10:   smc_addr11[1:0] <= 2'b10;
                  2'b01:   smc_addr11[1:0] <= 2'b11;
                  default: smc_addr11[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1611, `BSIZ_3211, 1'b? } : smc_addr11[1:0] <= {r_addr11[1],1'b0};
               { `XSIZ_1611, `BSIZ_1611, 1'b? } : smc_addr11[1:0] <= {r_addr11[1],1'b0};
               { `XSIZ_1611, `BSIZ_811, 1'b0 } :  smc_addr11[1:0] <= {r_addr11[1],1'b0};
               { `XSIZ_1611, `BSIZ_811, 1'b1 } :  smc_addr11[1:0] <= {r_addr11[1],1'b1};
               { `XSIZ_811, 2'b??, 1'b? } :     smc_addr11[1:0] <= r_addr11[1:0];
               default:                       smc_addr11[1:0] <= r_addr11[1:0];

               endcase
                 
            end
            
            default :

               smc_addr11 <= smc_addr11;
            
          endcase // casex(wait_access_smdone11)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate11 Chip11 Select11 Output11 
//----------------------------------------------------------------------

   always @(posedge sys_clk11 or negedge n_sys_reset11)
     
     begin
        
        if (~n_sys_reset11)
          
          begin
             
             smc_n_cs11 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate11 == `SMC_RW11)
          
           begin
             
              if (valid_access11)
               
                 smc_n_cs11 <= ~cs ;
             
              else
               
                 smc_n_cs11 <= ~r_cs11 ;

           end
        
        else
          
           smc_n_cs11 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch11 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk11 or negedge n_sys_reset11)
     
     begin
        
        if (~n_sys_reset11)
          
           r_addr11 <= 2'd0;
        
        
        else if (valid_access11)
          
           r_addr11 <= addr[1:0];
        
        else
          
           r_addr11 <= r_addr11;
        
     end
   


//----------------------------------------------------------------------
// Validate11 LSB of addr with valid_access11
//----------------------------------------------------------------------

   always @(r_addr11 or valid_access11 or addr)
     
      begin
        
         if (valid_access11)
           
            v_addr11 = addr[1:0];
         
         else
           
            v_addr11 = r_addr11;
         
      end
//----------------------------------------------------------------------
//cancatenation11 of signals11
//----------------------------------------------------------------------
                               //check for v_cs11 = 0
   assign ored_v_cs11 = |v_cs11;   //signal11 concatenation11 to be used in case
   
//----------------------------------------------------------------------
// Generate11 (internal) Byte11 Enables11.
//----------------------------------------------------------------------

   always @(v_cs11 or v_xfer_size11 or v_bus_size11 or v_addr11 )
     
     begin

       if ( |v_cs11 == 1'b1 ) 
        
         casez( {v_xfer_size11, v_bus_size11, 1'b0, v_addr11[1:0] } )
          
         {`XSIZ_811, `BSIZ_811, 1'b?, 2'b??} : n_be11 = 4'b1110; // Any11 on RAM11 B011
         {`XSIZ_811, `BSIZ_1611,1'b0, 2'b?0} : n_be11 = 4'b1110; // B211 or B011 = RAM11 B011
         {`XSIZ_811, `BSIZ_1611,1'b0, 2'b?1} : n_be11 = 4'b1101; // B311 or B111 = RAM11 B111
         {`XSIZ_811, `BSIZ_1611,1'b1, 2'b?0} : n_be11 = 4'b1101; // B211 or B011 = RAM11 B111
         {`XSIZ_811, `BSIZ_1611,1'b1, 2'b?1} : n_be11 = 4'b1110; // B311 or B111 = RAM11 B011
         {`XSIZ_811, `BSIZ_3211,1'b0, 2'b00} : n_be11 = 4'b1110; // B011 = RAM11 B011
         {`XSIZ_811, `BSIZ_3211,1'b0, 2'b01} : n_be11 = 4'b1101; // B111 = RAM11 B111
         {`XSIZ_811, `BSIZ_3211,1'b0, 2'b10} : n_be11 = 4'b1011; // B211 = RAM11 B211
         {`XSIZ_811, `BSIZ_3211,1'b0, 2'b11} : n_be11 = 4'b0111; // B311 = RAM11 B311
         {`XSIZ_811, `BSIZ_3211,1'b1, 2'b00} : n_be11 = 4'b0111; // B011 = RAM11 B311
         {`XSIZ_811, `BSIZ_3211,1'b1, 2'b01} : n_be11 = 4'b1011; // B111 = RAM11 B211
         {`XSIZ_811, `BSIZ_3211,1'b1, 2'b10} : n_be11 = 4'b1101; // B211 = RAM11 B111
         {`XSIZ_811, `BSIZ_3211,1'b1, 2'b11} : n_be11 = 4'b1110; // B311 = RAM11 B011
         {`XSIZ_1611,`BSIZ_811, 1'b?, 2'b??} : n_be11 = 4'b1110; // Any11 on RAM11 B011
         {`XSIZ_1611,`BSIZ_1611,1'b?, 2'b??} : n_be11 = 4'b1100; // Any11 on RAMB1011
         {`XSIZ_1611,`BSIZ_3211,1'b0, 2'b0?} : n_be11 = 4'b1100; // B1011 = RAM11 B1011
         {`XSIZ_1611,`BSIZ_3211,1'b0, 2'b1?} : n_be11 = 4'b0011; // B2311 = RAM11 B2311
         {`XSIZ_1611,`BSIZ_3211,1'b1, 2'b0?} : n_be11 = 4'b0011; // B1011 = RAM11 B2311
         {`XSIZ_1611,`BSIZ_3211,1'b1, 2'b1?} : n_be11 = 4'b1100; // B2311 = RAM11 B1011
         {`XSIZ_3211,`BSIZ_811, 1'b?, 2'b??} : n_be11 = 4'b1110; // Any11 on RAM11 B011
         {`XSIZ_3211,`BSIZ_1611,1'b?, 2'b??} : n_be11 = 4'b1100; // Any11 on RAM11 B1011
         {`XSIZ_3211,`BSIZ_3211,1'b?, 2'b??} : n_be11 = 4'b0000; // Any11 on RAM11 B321011
         default                         : n_be11 = 4'b1111; // Invalid11 decode
        
         
         endcase // casex(xfer_bus_size11)
        
       else

         n_be11 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate11 (enternal11) Byte11 Enables11.
//----------------------------------------------------------------------

   always @(posedge sys_clk11 or negedge n_sys_reset11)
     
     begin
        
        if (~n_sys_reset11)
          
           smc_n_be11 <= 4'hF;
        
        
        else if (smc_nextstate11 == `SMC_RW11)
          
           smc_n_be11 <= n_be11;
        
        else
          
           smc_n_be11 <= 4'hF;
        
     end
   
   
endmodule

