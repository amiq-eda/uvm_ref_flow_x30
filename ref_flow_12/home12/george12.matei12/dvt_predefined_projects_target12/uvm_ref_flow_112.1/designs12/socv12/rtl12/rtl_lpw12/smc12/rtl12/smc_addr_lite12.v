//File12 name   : smc_addr_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : This12 block registers the address and chip12 select12
//              lines12 for the current access. The address may only
//              driven12 for one cycle by the AHB12. If12 multiple
//              accesses are required12 the bottom12 two12 address bits
//              are modified between cycles12 depending12 on the current
//              transfer12 and bus size.
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

//


`include "smc_defs_lite12.v"

// address decoder12

module smc_addr_lite12    (
                    //inputs12

                    sys_clk12,
                    n_sys_reset12,
                    valid_access12,
                    r_num_access12,
                    v_bus_size12,
                    v_xfer_size12,
                    cs,
                    addr,
                    smc_done12,
                    smc_nextstate12,


                    //outputs12

                    smc_addr12,
                    smc_n_be12,
                    smc_n_cs12,
                    n_be12);



// I12/O12

   input                    sys_clk12;      //AHB12 System12 clock12
   input                    n_sys_reset12;  //AHB12 System12 reset 
   input                    valid_access12; //Start12 of new cycle
   input [1:0]              r_num_access12; //MAC12 counter
   input [1:0]              v_bus_size12;   //bus width for current access
   input [1:0]              v_xfer_size12;  //Transfer12 size for current 
                                              // access
   input               cs;           //Chip12 (Bank12) select12(internal)
   input [31:0]             addr;         //Internal address
   input                    smc_done12;     //Transfer12 complete (state 
                                              // machine12)
   input [4:0]              smc_nextstate12;//Next12 state 

   
   output [31:0]            smc_addr12;     //External12 Memory Interface12 
                                              //  address
   output [3:0]             smc_n_be12;     //EMI12 byte enables12 
   output              smc_n_cs12;     //EMI12 Chip12 Selects12 
   output [3:0]             n_be12;         //Unregistered12 Byte12 strobes12
                                             // used to genetate12 
                                             // individual12 write strobes12

// Output12 register declarations12
   
   reg [31:0]                  smc_addr12;
   reg [3:0]                   smc_n_be12;
   reg                    smc_n_cs12;
   reg [3:0]                   n_be12;
   
   
   // Internal register declarations12
   
   reg [1:0]                  r_addr12;           // Stored12 Address bits 
   reg                   r_cs12;             // Stored12 CS12
   reg [1:0]                  v_addr12;           // Validated12 Address
                                                     //  bits
   reg [7:0]                  v_cs12;             // Validated12 CS12
   
   wire                       ored_v_cs12;        //oring12 of v_sc12
   wire [4:0]                 cs_xfer_bus_size12; //concatenated12 bus and 
                                                  // xfer12 size
   wire [2:0]                 wait_access_smdone12;//concatenated12 signal12
   

// Main12 Code12
//----------------------------------------------------------------------
// Address Store12, CS12 Store12 & BE12 Store12
//----------------------------------------------------------------------

   always @(posedge sys_clk12 or negedge n_sys_reset12)
     
     begin
        
        if (~n_sys_reset12)
          
           r_cs12 <= 1'b0;
        
        
        else if (valid_access12)
          
           r_cs12 <= cs ;
        
        else
          
           r_cs12 <= r_cs12 ;
        
     end

//----------------------------------------------------------------------
//v_cs12 generation12   
//----------------------------------------------------------------------
   
   always @(cs or r_cs12 or valid_access12 )
     
     begin
        
        if (valid_access12)
          
           v_cs12 = cs ;
        
        else
          
           v_cs12 = r_cs12;
        
     end

//----------------------------------------------------------------------

   assign wait_access_smdone12 = {1'b0,valid_access12,smc_done12};

//----------------------------------------------------------------------
//smc_addr12 generation12
//----------------------------------------------------------------------

  always @(posedge sys_clk12 or negedge n_sys_reset12)
    
    begin
      
      if (~n_sys_reset12)
        
         smc_addr12 <= 32'h0;
      
      else

        begin

          casex(wait_access_smdone12)
             3'b1xx :

               smc_addr12 <= smc_addr12;
                        //valid_access12 
             3'b01x : begin
               // Set up address for first access
               // little12-endian from max address downto12 0
               // big-endian from 0 upto12 max_address12
               smc_addr12 [31:2] <= addr [31:2];

               casez( { v_xfer_size12, v_bus_size12, 1'b0 } )

               { `XSIZ_3212, `BSIZ_3212, 1'b? } : smc_addr12[1:0] <= 2'b00;
               { `XSIZ_3212, `BSIZ_1612, 1'b0 } : smc_addr12[1:0] <= 2'b10;
               { `XSIZ_3212, `BSIZ_1612, 1'b1 } : smc_addr12[1:0] <= 2'b00;
               { `XSIZ_3212, `BSIZ_812, 1'b0 } :  smc_addr12[1:0] <= 2'b11;
               { `XSIZ_3212, `BSIZ_812, 1'b1 } :  smc_addr12[1:0] <= 2'b00;
               { `XSIZ_1612, `BSIZ_3212, 1'b? } : smc_addr12[1:0] <= {addr[1],1'b0};
               { `XSIZ_1612, `BSIZ_1612, 1'b? } : smc_addr12[1:0] <= {addr[1],1'b0};
               { `XSIZ_1612, `BSIZ_812, 1'b0 } :  smc_addr12[1:0] <= {addr[1],1'b1};
               { `XSIZ_1612, `BSIZ_812, 1'b1 } :  smc_addr12[1:0] <= {addr[1],1'b0};
               { `XSIZ_812, 2'b??, 1'b? } :     smc_addr12[1:0] <= addr[1:0];
               default:                       smc_addr12[1:0] <= addr[1:0];

               endcase

             end
              
             3'b001 : begin

                // set up addresses12 fro12 subsequent12 accesses
                // little12 endian decrements12 according12 to access no.
                // bigendian12 increments12 as access no decrements12

                  smc_addr12[31:2] <= smc_addr12[31:2];
                  
               casez( { v_xfer_size12, v_bus_size12, 1'b0 } )

               { `XSIZ_3212, `BSIZ_3212, 1'b? } : smc_addr12[1:0] <= 2'b00;
               { `XSIZ_3212, `BSIZ_1612, 1'b0 } : smc_addr12[1:0] <= 2'b00;
               { `XSIZ_3212, `BSIZ_1612, 1'b1 } : smc_addr12[1:0] <= 2'b10;
               { `XSIZ_3212, `BSIZ_812,  1'b0 } : 
                  case( r_num_access12 ) 
                  2'b11:   smc_addr12[1:0] <= 2'b10;
                  2'b10:   smc_addr12[1:0] <= 2'b01;
                  2'b01:   smc_addr12[1:0] <= 2'b00;
                  default: smc_addr12[1:0] <= 2'b11;
                  endcase
               { `XSIZ_3212, `BSIZ_812, 1'b1 } :  
                  case( r_num_access12 ) 
                  2'b11:   smc_addr12[1:0] <= 2'b01;
                  2'b10:   smc_addr12[1:0] <= 2'b10;
                  2'b01:   smc_addr12[1:0] <= 2'b11;
                  default: smc_addr12[1:0] <= 2'b00;
                  endcase
               { `XSIZ_1612, `BSIZ_3212, 1'b? } : smc_addr12[1:0] <= {r_addr12[1],1'b0};
               { `XSIZ_1612, `BSIZ_1612, 1'b? } : smc_addr12[1:0] <= {r_addr12[1],1'b0};
               { `XSIZ_1612, `BSIZ_812, 1'b0 } :  smc_addr12[1:0] <= {r_addr12[1],1'b0};
               { `XSIZ_1612, `BSIZ_812, 1'b1 } :  smc_addr12[1:0] <= {r_addr12[1],1'b1};
               { `XSIZ_812, 2'b??, 1'b? } :     smc_addr12[1:0] <= r_addr12[1:0];
               default:                       smc_addr12[1:0] <= r_addr12[1:0];

               endcase
                 
            end
            
            default :

               smc_addr12 <= smc_addr12;
            
          endcase // casex(wait_access_smdone12)
           
        end
      
    end
  


//----------------------------------------------------------------------
// Generate12 Chip12 Select12 Output12 
//----------------------------------------------------------------------

   always @(posedge sys_clk12 or negedge n_sys_reset12)
     
     begin
        
        if (~n_sys_reset12)
          
          begin
             
             smc_n_cs12 <= 1'b0;
             
          end
        
        
        else if  (smc_nextstate12 == `SMC_RW12)
          
           begin
             
              if (valid_access12)
               
                 smc_n_cs12 <= ~cs ;
             
              else
               
                 smc_n_cs12 <= ~r_cs12 ;

           end
        
        else
          
           smc_n_cs12 <= 1;
           
     end



//----------------------------------------------------------------------
// Latch12 LSB of addr
//----------------------------------------------------------------------

   always @(posedge sys_clk12 or negedge n_sys_reset12)
     
     begin
        
        if (~n_sys_reset12)
          
           r_addr12 <= 2'd0;
        
        
        else if (valid_access12)
          
           r_addr12 <= addr[1:0];
        
        else
          
           r_addr12 <= r_addr12;
        
     end
   


//----------------------------------------------------------------------
// Validate12 LSB of addr with valid_access12
//----------------------------------------------------------------------

   always @(r_addr12 or valid_access12 or addr)
     
      begin
        
         if (valid_access12)
           
            v_addr12 = addr[1:0];
         
         else
           
            v_addr12 = r_addr12;
         
      end
//----------------------------------------------------------------------
//cancatenation12 of signals12
//----------------------------------------------------------------------
                               //check for v_cs12 = 0
   assign ored_v_cs12 = |v_cs12;   //signal12 concatenation12 to be used in case
   
//----------------------------------------------------------------------
// Generate12 (internal) Byte12 Enables12.
//----------------------------------------------------------------------

   always @(v_cs12 or v_xfer_size12 or v_bus_size12 or v_addr12 )
     
     begin

       if ( |v_cs12 == 1'b1 ) 
        
         casez( {v_xfer_size12, v_bus_size12, 1'b0, v_addr12[1:0] } )
          
         {`XSIZ_812, `BSIZ_812, 1'b?, 2'b??} : n_be12 = 4'b1110; // Any12 on RAM12 B012
         {`XSIZ_812, `BSIZ_1612,1'b0, 2'b?0} : n_be12 = 4'b1110; // B212 or B012 = RAM12 B012
         {`XSIZ_812, `BSIZ_1612,1'b0, 2'b?1} : n_be12 = 4'b1101; // B312 or B112 = RAM12 B112
         {`XSIZ_812, `BSIZ_1612,1'b1, 2'b?0} : n_be12 = 4'b1101; // B212 or B012 = RAM12 B112
         {`XSIZ_812, `BSIZ_1612,1'b1, 2'b?1} : n_be12 = 4'b1110; // B312 or B112 = RAM12 B012
         {`XSIZ_812, `BSIZ_3212,1'b0, 2'b00} : n_be12 = 4'b1110; // B012 = RAM12 B012
         {`XSIZ_812, `BSIZ_3212,1'b0, 2'b01} : n_be12 = 4'b1101; // B112 = RAM12 B112
         {`XSIZ_812, `BSIZ_3212,1'b0, 2'b10} : n_be12 = 4'b1011; // B212 = RAM12 B212
         {`XSIZ_812, `BSIZ_3212,1'b0, 2'b11} : n_be12 = 4'b0111; // B312 = RAM12 B312
         {`XSIZ_812, `BSIZ_3212,1'b1, 2'b00} : n_be12 = 4'b0111; // B012 = RAM12 B312
         {`XSIZ_812, `BSIZ_3212,1'b1, 2'b01} : n_be12 = 4'b1011; // B112 = RAM12 B212
         {`XSIZ_812, `BSIZ_3212,1'b1, 2'b10} : n_be12 = 4'b1101; // B212 = RAM12 B112
         {`XSIZ_812, `BSIZ_3212,1'b1, 2'b11} : n_be12 = 4'b1110; // B312 = RAM12 B012
         {`XSIZ_1612,`BSIZ_812, 1'b?, 2'b??} : n_be12 = 4'b1110; // Any12 on RAM12 B012
         {`XSIZ_1612,`BSIZ_1612,1'b?, 2'b??} : n_be12 = 4'b1100; // Any12 on RAMB1012
         {`XSIZ_1612,`BSIZ_3212,1'b0, 2'b0?} : n_be12 = 4'b1100; // B1012 = RAM12 B1012
         {`XSIZ_1612,`BSIZ_3212,1'b0, 2'b1?} : n_be12 = 4'b0011; // B2312 = RAM12 B2312
         {`XSIZ_1612,`BSIZ_3212,1'b1, 2'b0?} : n_be12 = 4'b0011; // B1012 = RAM12 B2312
         {`XSIZ_1612,`BSIZ_3212,1'b1, 2'b1?} : n_be12 = 4'b1100; // B2312 = RAM12 B1012
         {`XSIZ_3212,`BSIZ_812, 1'b?, 2'b??} : n_be12 = 4'b1110; // Any12 on RAM12 B012
         {`XSIZ_3212,`BSIZ_1612,1'b?, 2'b??} : n_be12 = 4'b1100; // Any12 on RAM12 B1012
         {`XSIZ_3212,`BSIZ_3212,1'b?, 2'b??} : n_be12 = 4'b0000; // Any12 on RAM12 B321012
         default                         : n_be12 = 4'b1111; // Invalid12 decode
        
         
         endcase // casex(xfer_bus_size12)
        
       else

         n_be12 = 4'b1111;

       
        
     end
   
   

//----------------------------------------------------------------------
// Generate12 (enternal12) Byte12 Enables12.
//----------------------------------------------------------------------

   always @(posedge sys_clk12 or negedge n_sys_reset12)
     
     begin
        
        if (~n_sys_reset12)
          
           smc_n_be12 <= 4'hF;
        
        
        else if (smc_nextstate12 == `SMC_RW12)
          
           smc_n_be12 <= n_be12;
        
        else
          
           smc_n_be12 <= 4'hF;
        
     end
   
   
endmodule

