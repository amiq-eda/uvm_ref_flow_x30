//File5 name   : smc_addr_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : This5 block registers the address and chip5 select5
//              lines5 for the current access. The address may only
//              driven5 for one cycle by the AHB5. If5 multiple
//              accesses are required5 the bottom5 two5 address bits
//              are modified between cycles5 depending5 on the current
//              transfer5 and bus size.
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

//


`include "smc_defs_lite5.v"

// address decoder5

module smc_addr_lite5    (
                    //inputs5

                    sys_clk5,
                    n_sys_reset5,
                    valid_access5,
                    r_num_access5,
                    v_bus_size5,
                    v_xfer_size5,
                    cs,
                    addr,
                    smc_done5,
                    smc_nextstate5,


                    //outputs5

                    smc_addr5,
                    smc_n_be5,
                    smc_n_cs5,
                    n_be5);



// I5/O5

   input                    sys_clk5;      //AHB5 System5 clock5
   input                    n_sys_reset5;  //AHB5 System5 reset 
   input                    valid_access5; //Start5 of new cycle
   input [1:0]              r_num_access5; //MAC5 counter
   input [1:0]              v_bus_size5;   //bus width for current access
   input [1:0]              v_xfer_size5;  //Transfer5 size for current 
                                              // access
   input               cs;           //Chip5 (Bank5) select5(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done5;     //Transfer5 complete (state 
                                              // machine5)
   input [4:0]              smc_nextstate5;//Next5 state 

   
   output [31:0]            smc_addr5;     //External5 Memory Interface5 
                                              //  address
   output [3:0]             smc_n_be5;     //EMI5 byte enables5 
   output              smc_n_cs5;     //EMI5 Chip5 Selects5 
   output [3:0]             n_be5;         //Unregistered5 Byte5 strobes5
                                             // used to genetate5 
                                             // individual5 write strobes5

// Output5 register declarations5
   
   reg [31:0]                  smc_addr5;
   reg [3:0]                   smc_n_be5;
   reg                    smc_n_cs5;
   reg [3:0]                   n_be5;
   
   
   // Internal register declarations5
   
   reg [1:0]                  r_addr5;           // Stored5 Address bits 
   reg                   r_cs5;             // Stored5 CS5
   reg [1:0]                  v_addr5;           // Validated5 Address
                                                     //  bits
   reg [7:0]                  v_cs5;             // Validated5 CS5
   
   wire                       ored_v_cs5;        //oring5 of v_sc5
   wire [4:0]                 cs_xfer_bus_size5; //concatenated5 bus and 
                                                  // xfer5 size
   wire [2:0]                 wait_access_smdone5;//concatenated5 signal5
   

// Main5 Code5
//----------------------------------------------------------------------
// Address Store5, CS5 Store5 & BE5 Store5
//----------------------------------------------------------------------

   always @(posedge sys_clk5 or negedge n_sys_reset5)
     
     begin
        
        if (~n_sys_reset5)
          
           r_cs5 <= 1'b0;
        
        
        else if (valid_access5)
          
           r_cs5 <= cs ;
        
        else
          
           r_cs5 <= r_cs5 ;
        
     end

//----------------------------------------------------------------------
//v_cs5 generation5   
//----------------------------------------------------------------------
   
   always @(cs or r_cs5 or valid_access5 )
     
     begin
        
        if (valid_access5)
          
           v_cs5 = cs ;
        
        else
          
           v_cs5 = r_cs5;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone5 = {1'b0,valid_access5,smc_done5};

//----------------------------------------------------------------------
//smc_addr5 generation5
//----------------------------------------------------------------------

  always @(posedge sys_clk5 or negedge n_sys_reset5)
    
    begin
      
      if (~n_sys_reset5)
        
         smc_addr5 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone5)
             3'b1xx :

               smc_addr5 <= smc_addr5;
                        //valid_access5 
             3'b01x : begin
               // Set up address for first access
               // little5-endian from max address downto5 0
               // big-endian from 0 upto5 max_address5
               smc_addr5 [31:2] <= addr [31:2];

               casez( { v_xfer_size5, v_bus_size5, 1'b0 } )

               { `XSIZ_325, `BSIZ_325, 1'b? } : smc_addr5[1:0] <= 2'b00;
               { `XSIZ_325, `BSIZ_165, 1'b0 } : smc_addr5[1:0] <= 2'b10;
               { `XSIZ_325, `BSIZ_165, 1'b1 } : smc_addr5[1:0] <= 2'b00;
               { `XSIZ_325, `BSIZ_85, 1'b0 } :  smc_addr5[1:0] <= 2'b11;
               { `XSIZ_325, `BSIZ_85, 1'b1 } :  smc_addr5[1:0] <= 2'b00;
               { `XSIZ_165, `BSIZ_325, 1'b? } : smc_addr5[1:0] <= {addr[1],1'b0};
               { `XSIZ_165, `BSIZ_165, 1'b? } : smc_addr5[1:0] <= {addr[1],1'b0};
               { `XSIZ_165, `BSIZ_85, 1'b0 } :  smc_addr5[1:0] <= {addr[1],1'b1};
               { `XSIZ_165, `BSIZ_85, 1'b1 } :  smc_addr5[1:0] <= {addr[1],1'b0};
               { `XSIZ_85, 2'b??, 1'b? } :     smc_addr5[1:0] <= addr[1:0];
               default:                       smc_addr5[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses5 fro5 subsequent5 accesses
                // little5 endian decrements5 according5 to access no.
                // bigendian5 increments5 as access no decrements5

                  smc_addr5[31:2] <= smc_addr5[31:2];
                  
               casez( { v_xfer_size5, v_bus_size5, 1'b0 } )

               { `XSIZ_325, `BSIZ_325, 1'b? } : smc_addr5[1:0] <= 2'b00;
               { `XSIZ_325, `BSIZ_165, 1'b0 } : smc_addr5[1:0] <= 2'b00;
               { `XSIZ_325, `BSIZ_165, 1'b1 } : smc_addr5[1:0] <= 2'b10;
               { `XSIZ_325, `BSIZ_85,  1'b0 } : 
                  case( r_num_access5 ) 
                  2'b11:   smc_addr5[1:0] <= 2'b10;
                  2'b10:   smc_addr5[1:0] <= 2'b01;
                  2'b01:   smc_addr5[1:0] <= 2'b00;
                  default: smc_addr5[1:0] <= 2'b11;
                  endcase
               { `XSIZ_325, `BSIZ_85, 1'b1 } :  
                  case( r_num_access5 ) 
                  2'b11:   smc_addr5[1:0] <= 2'b01;
                  2'b10:   smc_addr5[1:0] <= 2'b10;
                  2'b01:   smc_addr5[1:0] <= 2'b11;
                  default: smc_addr5[1:0] <= 2'b00;
                  endcase
               { `XSIZ_165, `BSIZ_325, 1'b? } : smc_addr5[1:0] <= {r_addr5[1],1'b0};
               { `XSIZ_165, `BSIZ_165, 1'b? } : smc_addr5[1:0] <= {r_addr5[1],1'b0};
               { `XSIZ_165, `BSIZ_85, 1'b0 } :  smc_addr5[1:0] <= {r_addr5[1],1'b0};
               { `XSIZ_165, `BSIZ_85, 1'b1 } :  smc_addr5[1:0] <= {r_addr5[1],1'b1};
               { `XSIZ_85, 2'b??, 1'b? } :     smc_addr5[1:0] <= r_addr5[1:0];
               default:                       smc_addr5[1:0] <= r_addr5[1:0];

               endcase
                 
            end
            
            default :

               smc_addr5 <= smc_addr5;
            
          endcase // casex(wait_access_smdone5)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate5 Chip5 Select5 Output5 
//----------------------------------------------------------------------

   always @(posedge sys_clk5 or negedge n_sys_reset5)
     
     begin
        
        if (~n_sys_reset5)
          
          begin
             
             smc_n_cs5 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate5 == `SMC_RW5)
          
           begin
             
              if (valid_access5)
               
                 smc_n_cs5 <= ~cs ;
             
              else
               
                 smc_n_cs5 <= ~r_cs5 ;

           end
        
        else
          
           smc_n_cs5 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch5 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk5 or negedge n_sys_reset5)
     
     begin
        
        if (~n_sys_reset5)
          
           r_addr5 <= 2'd0;
        
        
        else if (valid_access5)
          
           r_addr5 <= addr[1:0];
        
        else
          
           r_addr5 <= r_addr5;
        
     end
   


//----------------------------------------------------------------------
// Validate5 LSB of addr with valid_access5
//----------------------------------------------------------------------

   always @(r_addr5 or valid_access5 or addr)
     
      begin
        
         if (valid_access5)
           
            v_addr5 = addr[1:0];
         
         else
           
            v_addr5 = r_addr5;
         
      end
//----------------------------------------------------------------------
//cancatenation5 of signals5
//----------------------------------------------------------------------
                               //check for v_cs5 = 0
   assign ored_v_cs5 = |v_cs5;   //signal5 concatenation5 to be used in case
   
//----------------------------------------------------------------------
// Generate5 (internal) Byte5 Enables5.
//----------------------------------------------------------------------

   always @(v_cs5 or v_xfer_size5 or v_bus_size5 or v_addr5 )
     
     begin

       if ( |v_cs5 == 1'b1 ) 
        
         casez( {v_xfer_size5, v_bus_size5, 1'b0, v_addr5[1:0] } )
          
         {`XSIZ_85, `BSIZ_85, 1'b?, 2'b??} : n_be5 = 4'b1110; // Any5 on RAM5 B05
         {`XSIZ_85, `BSIZ_165,1'b0, 2'b?0} : n_be5 = 4'b1110; // B25 or B05 = RAM5 B05
         {`XSIZ_85, `BSIZ_165,1'b0, 2'b?1} : n_be5 = 4'b1101; // B35 or B15 = RAM5 B15
         {`XSIZ_85, `BSIZ_165,1'b1, 2'b?0} : n_be5 = 4'b1101; // B25 or B05 = RAM5 B15
         {`XSIZ_85, `BSIZ_165,1'b1, 2'b?1} : n_be5 = 4'b1110; // B35 or B15 = RAM5 B05
         {`XSIZ_85, `BSIZ_325,1'b0, 2'b00} : n_be5 = 4'b1110; // B05 = RAM5 B05
         {`XSIZ_85, `BSIZ_325,1'b0, 2'b01} : n_be5 = 4'b1101; // B15 = RAM5 B15
         {`XSIZ_85, `BSIZ_325,1'b0, 2'b10} : n_be5 = 4'b1011; // B25 = RAM5 B25
         {`XSIZ_85, `BSIZ_325,1'b0, 2'b11} : n_be5 = 4'b0111; // B35 = RAM5 B35
         {`XSIZ_85, `BSIZ_325,1'b1, 2'b00} : n_be5 = 4'b0111; // B05 = RAM5 B35
         {`XSIZ_85, `BSIZ_325,1'b1, 2'b01} : n_be5 = 4'b1011; // B15 = RAM5 B25
         {`XSIZ_85, `BSIZ_325,1'b1, 2'b10} : n_be5 = 4'b1101; // B25 = RAM5 B15
         {`XSIZ_85, `BSIZ_325,1'b1, 2'b11} : n_be5 = 4'b1110; // B35 = RAM5 B05
         {`XSIZ_165,`BSIZ_85, 1'b?, 2'b??} : n_be5 = 4'b1110; // Any5 on RAM5 B05
         {`XSIZ_165,`BSIZ_165,1'b?, 2'b??} : n_be5 = 4'b1100; // Any5 on RAMB105
         {`XSIZ_165,`BSIZ_325,1'b0, 2'b0?} : n_be5 = 4'b1100; // B105 = RAM5 B105
         {`XSIZ_165,`BSIZ_325,1'b0, 2'b1?} : n_be5 = 4'b0011; // B235 = RAM5 B235
         {`XSIZ_165,`BSIZ_325,1'b1, 2'b0?} : n_be5 = 4'b0011; // B105 = RAM5 B235
         {`XSIZ_165,`BSIZ_325,1'b1, 2'b1?} : n_be5 = 4'b1100; // B235 = RAM5 B105
         {`XSIZ_325,`BSIZ_85, 1'b?, 2'b??} : n_be5 = 4'b1110; // Any5 on RAM5 B05
         {`XSIZ_325,`BSIZ_165,1'b?, 2'b??} : n_be5 = 4'b1100; // Any5 on RAM5 B105
         {`XSIZ_325,`BSIZ_325,1'b?, 2'b??} : n_be5 = 4'b0000; // Any5 on RAM5 B32105
         default                         : n_be5 = 4'b1111; // Invalid5 decode
        
         
         endcase // casex(xfer_bus_size5)
        
       else

         n_be5 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate5 (enternal5) Byte5 Enables5.
//----------------------------------------------------------------------

   always @(posedge sys_clk5 or negedge n_sys_reset5)
     
     begin
        
        if (~n_sys_reset5)
          
           smc_n_be5 <= 4'hF;
        
        
        else if (smc_nextstate5 == `SMC_RW5)
          
           smc_n_be5 <= n_be5;
        
        else
          
           smc_n_be5 <= 4'hF;
        
     end
   
   
endmodule

