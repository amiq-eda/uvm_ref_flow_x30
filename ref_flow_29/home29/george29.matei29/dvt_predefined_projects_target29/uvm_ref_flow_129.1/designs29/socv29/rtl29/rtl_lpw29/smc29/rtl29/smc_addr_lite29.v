//File29 name   : smc_addr_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : This29 block registers the address and chip29 select29
//              lines29 for the current access. The address may only
//              driven29 for one cycle by the AHB29. If29 multiple
//              accesses are required29 the bottom29 two29 address bits
//              are modified between cycles29 depending29 on the current
//              transfer29 and bus size.
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

//


`include "smc_defs_lite29.v"

// address decoder29

module smc_addr_lite29    (
                    //inputs29

                    sys_clk29,
                    n_sys_reset29,
                    valid_access29,
                    r_num_access29,
                    v_bus_size29,
                    v_xfer_size29,
                    cs,
                    addr,
                    smc_done29,
                    smc_nextstate29,


                    //outputs29

                    smc_addr29,
                    smc_n_be29,
                    smc_n_cs29,
                    n_be29);



// I29/O29

   input                    sys_clk29;      //AHB29 System29 clock29
   input                    n_sys_reset29;  //AHB29 System29 reset 
   input                    valid_access29; //Start29 of new cycle
   input [1:0]              r_num_access29; //MAC29 counter
   input [1:0]              v_bus_size29;   //bus width for current access
   input [1:0]              v_xfer_size29;  //Transfer29 size for current 
                                              // access
   input               cs;           //Chip29 (Bank29) select29(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done29;     //Transfer29 complete (state 
                                              // machine29)
   input [4:0]              smc_nextstate29;//Next29 state 

   
   output [31:0]            smc_addr29;     //External29 Memory Interface29 
                                              //  address
   output [3:0]             smc_n_be29;     //EMI29 byte enables29 
   output              smc_n_cs29;     //EMI29 Chip29 Selects29 
   output [3:0]             n_be29;         //Unregistered29 Byte29 strobes29
                                             // used to genetate29 
                                             // individual29 write strobes29

// Output29 register declarations29
   
   reg [31:0]                  smc_addr29;
   reg [3:0]                   smc_n_be29;
   reg                    smc_n_cs29;
   reg [3:0]                   n_be29;
   
   
   // Internal register declarations29
   
   reg [1:0]                  r_addr29;           // Stored29 Address bits 
   reg                   r_cs29;             // Stored29 CS29
   reg [1:0]                  v_addr29;           // Validated29 Address
                                                     //  bits
   reg [7:0]                  v_cs29;             // Validated29 CS29
   
   wire                       ored_v_cs29;        //oring29 of v_sc29
   wire [4:0]                 cs_xfer_bus_size29; //concatenated29 bus and 
                                                  // xfer29 size
   wire [2:0]                 wait_access_smdone29;//concatenated29 signal29
   

// Main29 Code29
//----------------------------------------------------------------------
// Address Store29, CS29 Store29 & BE29 Store29
//----------------------------------------------------------------------

   always @(posedge sys_clk29 or negedge n_sys_reset29)
     
     begin
        
        if (~n_sys_reset29)
          
           r_cs29 <= 1'b0;
        
        
        else if (valid_access29)
          
           r_cs29 <= cs ;
        
        else
          
           r_cs29 <= r_cs29 ;
        
     end

//----------------------------------------------------------------------
//v_cs29 generation29   
//----------------------------------------------------------------------
   
   always @(cs or r_cs29 or valid_access29 )
     
     begin
        
        if (valid_access29)
          
           v_cs29 = cs ;
        
        else
          
           v_cs29 = r_cs29;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone29 = {1'b0,valid_access29,smc_done29};

//----------------------------------------------------------------------
//smc_addr29 generation29
//----------------------------------------------------------------------

  always @(posedge sys_clk29 or negedge n_sys_reset29)
    
    begin
      
      if (~n_sys_reset29)
        
         smc_addr29 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone29)
             3'b1xx :

               smc_addr29 <= smc_addr29;
                        //valid_access29 
             3'b01x : begin
               // Set up address for first access
               // little29-endian from max address downto29 0
               // big-endian from 0 upto29 max_address29
               smc_addr29 [31:2] <= addr [31:2];

               casez( { v_xfer_size29, v_bus_size29, 1'b0 } )

               { `XSIZ_3229, `BSIZ_3229, 1'b? } : smc_addr29[1:0] <= 2'b00;
               { `XSIZ_3229, `BSIZ_1629, 1'b0 } : smc_addr29[1:0] <= 2'b10;
               { `XSIZ_3229, `BSIZ_1629, 1'b1 } : smc_addr29[1:0] <= 2'b00;
               { `XSIZ_3229, `BSIZ_829, 1'b0 } :  smc_addr29[1:0] <= 2'b11;
               { `XSIZ_3229, `BSIZ_829, 1'b1 } :  smc_addr29[1:0] <= 2'b00;
               { `XSIZ_1629, `BSIZ_3229, 1'b? } : smc_addr29[1:0] <= {addr[1],1'b0};
               { `XSIZ_1629, `BSIZ_1629, 1'b? } : smc_addr29[1:0] <= {addr[1],1'b0};
               { `XSIZ_1629, `BSIZ_829, 1'b0 } :  smc_addr29[1:0] <= {addr[1],1'b1};
               { `XSIZ_1629, `BSIZ_829, 1'b1 } :  smc_addr29[1:0] <= {addr[1],1'b0};
               { `XSIZ_829, 2'b??, 1'b? } :     smc_addr29[1:0] <= addr[1:0];
               default:                       smc_addr29[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses29 fro29 subsequent29 accesses
                // little29 endian decrements29 according29 to access no.
                // bigendian29 increments29 as access no decrements29

                  smc_addr29[31:2] <= smc_addr29[31:2];
                  
               casez( { v_xfer_size29, v_bus_size29, 1'b0 } )

               { `XSIZ_3229, `BSIZ_3229, 1'b? } : smc_addr29[1:0] <= 2'b00;
               { `XSIZ_3229, `BSIZ_1629, 1'b0 } : smc_addr29[1:0] <= 2'b00;
               { `XSIZ_3229, `BSIZ_1629, 1'b1 } : smc_addr29[1:0] <= 2'b10;
               { `XSIZ_3229, `BSIZ_829,  1'b0 } : 
                  case( r_num_access29 ) 
                  2'b11:   smc_addr29[1:0] <= 2'b10;
                  2'b10:   smc_addr29[1:0] <= 2'b01;
                  2'b01:   smc_addr29[1:0] <= 2'b00;
                  default: smc_addr29[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3229, `BSIZ_829, 1'b1 } :  
                  case( r_num_access29 ) 
                  2'b11:   smc_addr29[1:0] <= 2'b01;
                  2'b10:   smc_addr29[1:0] <= 2'b10;
                  2'b01:   smc_addr29[1:0] <= 2'b11;
                  default: smc_addr29[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1629, `BSIZ_3229, 1'b? } : smc_addr29[1:0] <= {r_addr29[1],1'b0};
               { `XSIZ_1629, `BSIZ_1629, 1'b? } : smc_addr29[1:0] <= {r_addr29[1],1'b0};
               { `XSIZ_1629, `BSIZ_829, 1'b0 } :  smc_addr29[1:0] <= {r_addr29[1],1'b0};
               { `XSIZ_1629, `BSIZ_829, 1'b1 } :  smc_addr29[1:0] <= {r_addr29[1],1'b1};
               { `XSIZ_829, 2'b??, 1'b? } :     smc_addr29[1:0] <= r_addr29[1:0];
               default:                       smc_addr29[1:0] <= r_addr29[1:0];

               endcase
                 
            end
            
            default :

               smc_addr29 <= smc_addr29;
            
          endcase // casex(wait_access_smdone29)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate29 Chip29 Select29 Output29 
//----------------------------------------------------------------------

   always @(posedge sys_clk29 or negedge n_sys_reset29)
     
     begin
        
        if (~n_sys_reset29)
          
          begin
             
             smc_n_cs29 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate29 == `SMC_RW29)
          
           begin
             
              if (valid_access29)
               
                 smc_n_cs29 <= ~cs ;
             
              else
               
                 smc_n_cs29 <= ~r_cs29 ;

           end
        
        else
          
           smc_n_cs29 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch29 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk29 or negedge n_sys_reset29)
     
     begin
        
        if (~n_sys_reset29)
          
           r_addr29 <= 2'd0;
        
        
        else if (valid_access29)
          
           r_addr29 <= addr[1:0];
        
        else
          
           r_addr29 <= r_addr29;
        
     end
   


//----------------------------------------------------------------------
// Validate29 LSB of addr with valid_access29
//----------------------------------------------------------------------

   always @(r_addr29 or valid_access29 or addr)
     
      begin
        
         if (valid_access29)
           
            v_addr29 = addr[1:0];
         
         else
           
            v_addr29 = r_addr29;
         
      end
//----------------------------------------------------------------------
//cancatenation29 of signals29
//----------------------------------------------------------------------
                               //check for v_cs29 = 0
   assign ored_v_cs29 = |v_cs29;   //signal29 concatenation29 to be used in case
   
//----------------------------------------------------------------------
// Generate29 (internal) Byte29 Enables29.
//----------------------------------------------------------------------

   always @(v_cs29 or v_xfer_size29 or v_bus_size29 or v_addr29 )
     
     begin

       if ( |v_cs29 == 1'b1 ) 
        
         casez( {v_xfer_size29, v_bus_size29, 1'b0, v_addr29[1:0] } )
          
         {`XSIZ_829, `BSIZ_829, 1'b?, 2'b??} : n_be29 = 4'b1110; // Any29 on RAM29 B029
         {`XSIZ_829, `BSIZ_1629,1'b0, 2'b?0} : n_be29 = 4'b1110; // B229 or B029 = RAM29 B029
         {`XSIZ_829, `BSIZ_1629,1'b0, 2'b?1} : n_be29 = 4'b1101; // B329 or B129 = RAM29 B129
         {`XSIZ_829, `BSIZ_1629,1'b1, 2'b?0} : n_be29 = 4'b1101; // B229 or B029 = RAM29 B129
         {`XSIZ_829, `BSIZ_1629,1'b1, 2'b?1} : n_be29 = 4'b1110; // B329 or B129 = RAM29 B029
         {`XSIZ_829, `BSIZ_3229,1'b0, 2'b00} : n_be29 = 4'b1110; // B029 = RAM29 B029
         {`XSIZ_829, `BSIZ_3229,1'b0, 2'b01} : n_be29 = 4'b1101; // B129 = RAM29 B129
         {`XSIZ_829, `BSIZ_3229,1'b0, 2'b10} : n_be29 = 4'b1011; // B229 = RAM29 B229
         {`XSIZ_829, `BSIZ_3229,1'b0, 2'b11} : n_be29 = 4'b0111; // B329 = RAM29 B329
         {`XSIZ_829, `BSIZ_3229,1'b1, 2'b00} : n_be29 = 4'b0111; // B029 = RAM29 B329
         {`XSIZ_829, `BSIZ_3229,1'b1, 2'b01} : n_be29 = 4'b1011; // B129 = RAM29 B229
         {`XSIZ_829, `BSIZ_3229,1'b1, 2'b10} : n_be29 = 4'b1101; // B229 = RAM29 B129
         {`XSIZ_829, `BSIZ_3229,1'b1, 2'b11} : n_be29 = 4'b1110; // B329 = RAM29 B029
         {`XSIZ_1629,`BSIZ_829, 1'b?, 2'b??} : n_be29 = 4'b1110; // Any29 on RAM29 B029
         {`XSIZ_1629,`BSIZ_1629,1'b?, 2'b??} : n_be29 = 4'b1100; // Any29 on RAMB1029
         {`XSIZ_1629,`BSIZ_3229,1'b0, 2'b0?} : n_be29 = 4'b1100; // B1029 = RAM29 B1029
         {`XSIZ_1629,`BSIZ_3229,1'b0, 2'b1?} : n_be29 = 4'b0011; // B2329 = RAM29 B2329
         {`XSIZ_1629,`BSIZ_3229,1'b1, 2'b0?} : n_be29 = 4'b0011; // B1029 = RAM29 B2329
         {`XSIZ_1629,`BSIZ_3229,1'b1, 2'b1?} : n_be29 = 4'b1100; // B2329 = RAM29 B1029
         {`XSIZ_3229,`BSIZ_829, 1'b?, 2'b??} : n_be29 = 4'b1110; // Any29 on RAM29 B029
         {`XSIZ_3229,`BSIZ_1629,1'b?, 2'b??} : n_be29 = 4'b1100; // Any29 on RAM29 B1029
         {`XSIZ_3229,`BSIZ_3229,1'b?, 2'b??} : n_be29 = 4'b0000; // Any29 on RAM29 B321029
         default                         : n_be29 = 4'b1111; // Invalid29 decode
        
         
         endcase // casex(xfer_bus_size29)
        
       else

         n_be29 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate29 (enternal29) Byte29 Enables29.
//----------------------------------------------------------------------

   always @(posedge sys_clk29 or negedge n_sys_reset29)
     
     begin
        
        if (~n_sys_reset29)
          
           smc_n_be29 <= 4'hF;
        
        
        else if (smc_nextstate29 == `SMC_RW29)
          
           smc_n_be29 <= n_be29;
        
        else
          
           smc_n_be29 <= 4'hF;
        
     end
   
   
endmodule

