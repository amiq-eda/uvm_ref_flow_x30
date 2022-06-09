//File20 name   : smc_mac_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : Multiple20 access controller20.
//            : Static20 Memory Controller20.
//            : The Multiple20 Access Control20 Block keeps20 trace20 of the
//            : number20 of accesses required20 to fulfill20 the
//            : requirements20 of the AHB20 transfer20. The data is
//            : registered when multiple reads are required20. The AHB20
//            : holds20 the data during multiple writes.
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

`include "smc_defs_lite20.v"

module smc_mac_lite20     (

                    //inputs20
                    
                    sys_clk20,
                    n_sys_reset20,
                    valid_access20,
                    xfer_size20,
                    smc_done20,
                    data_smc20,
                    write_data20,
                    smc_nextstate20,
                    latch_data20,
                    
                    //outputs20
                    
                    r_num_access20,
                    mac_done20,
                    v_bus_size20,
                    v_xfer_size20,
                    read_data20,
                    smc_data20);
   
   
   
 


// State20 Machine20// I20/O20

  input                sys_clk20;        // System20 clock20
  input                n_sys_reset20;    // System20 reset (Active20 LOW20)
  input                valid_access20;   // Address cycle of new transfer20
  input  [1:0]         xfer_size20;      // xfer20 size, valid with valid_access20
  input                smc_done20;       // End20 of transfer20
  input  [31:0]        data_smc20;       // External20 read data
  input  [31:0]        write_data20;     // Data from internal bus 
  input  [4:0]         smc_nextstate20;  // State20 Machine20  
  input                latch_data20;     //latch_data20 is used by the MAC20 block    
  
  output [1:0]         r_num_access20;   // Access counter
  output               mac_done20;       // End20 of all transfers20
  output [1:0]         v_bus_size20;     // Registered20 sizes20 for subsequent20
  output [1:0]         v_xfer_size20;    // transfers20 in MAC20 transfer20
  output [31:0]        read_data20;      // Data to internal bus
  output [31:0]        smc_data20;       // Data to external20 bus
  

// Output20 register declarations20

  reg                  mac_done20;       // Indicates20 last cycle of last access
  reg [1:0]            r_num_access20;   // Access counter
  reg [1:0]            num_accesses20;   //number20 of access
  reg [1:0]            r_xfer_size20;    // Store20 size for MAC20 
  reg [1:0]            r_bus_size20;     // Store20 size for MAC20
  reg [31:0]           read_data20;      // Data path to bus IF
  reg [31:0]           r_read_data20;    // Internal data store20
  reg [31:0]           smc_data20;


// Internal Signals20

  reg [1:0]            v_bus_size20;
  reg [1:0]            v_xfer_size20;
  wire [4:0]           smc_nextstate20;    //specifies20 next state
  wire [4:0]           xfer_bus_ldata20;  //concatenation20 of xfer_size20
                                         // and latch_data20  
  wire [3:0]           bus_size_num_access20; //concatenation20 of 
                                              // r_num_access20
  wire [5:0]           wt_ldata_naccs_bsiz20;  //concatenation20 of 
                                            //latch_data20,r_num_access20
 
   


// Main20 Code20

//----------------------------------------------------------------------------
// Store20 transfer20 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk20 or negedge n_sys_reset20)
  
    begin
       
       if (~n_sys_reset20)
         
          r_xfer_size20 <= 2'b00;
       
       
       else if (valid_access20)
         
          r_xfer_size20 <= xfer_size20;
       
       else
         
          r_xfer_size20 <= r_xfer_size20;
       
    end

//--------------------------------------------------------------------
// Store20 bus size generation20
//--------------------------------------------------------------------
  
  always @(posedge sys_clk20 or negedge n_sys_reset20)
    
    begin
       
       if (~n_sys_reset20)
         
          r_bus_size20 <= 2'b00;
       
       
       else if (valid_access20)
         
          r_bus_size20 <= 2'b00;
       
       else
         
          r_bus_size20 <= r_bus_size20;
       
    end
   

//--------------------------------------------------------------------
// Validate20 sizes20 generation20
//--------------------------------------------------------------------

  always @(valid_access20 or r_bus_size20 )

    begin
       
       if (valid_access20)
         
          v_bus_size20 = 2'b0;
       
       else
         
          v_bus_size20 = r_bus_size20;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size20 generation20
//----------------------------------------------------------------------------   

  always @(valid_access20 or r_xfer_size20 or xfer_size20)

    begin
       
       if (valid_access20)
         
          v_xfer_size20 = xfer_size20;
       
       else
         
          v_xfer_size20 = r_xfer_size20;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions20
// Determines20 the number20 of accesses required20 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size20)
  
    begin
       
       if ((xfer_size20[1:0] == `XSIZ_1620))
         
          num_accesses20 = 2'h1; // Two20 accesses
       
       else if ( (xfer_size20[1:0] == `XSIZ_3220))
         
          num_accesses20 = 2'h3; // Four20 accesses
       
       else
         
          num_accesses20 = 2'h0; // One20 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep20 track20 of the current access number20
//--------------------------------------------------------------------
   
  always @(posedge sys_clk20 or negedge n_sys_reset20)
  
    begin
       
       if (~n_sys_reset20)
         
          r_num_access20 <= 2'b00;
       
       else if (valid_access20)
         
          r_num_access20 <= num_accesses20;
       
       else if (smc_done20 & (smc_nextstate20 != `SMC_STORE20)  &
                      (smc_nextstate20 != `SMC_IDLE20)   )
         
          r_num_access20 <= r_num_access20 - 2'd1;
       
       else
         
          r_num_access20 <= r_num_access20;
       
    end
   
   

//--------------------------------------------------------------------
// Detect20 last access
//--------------------------------------------------------------------
   
   always @(r_num_access20)
     
     begin
        
        if (r_num_access20 == 2'h0)
          
           mac_done20 = 1'b1;
             
        else
          
           mac_done20 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals20 concatenation20 used in case statement20 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz20 = { 1'b0, latch_data20, r_num_access20,
                                  r_bus_size20};
 
   
//--------------------------------------------------------------------
// Store20 Read Data if required20
//--------------------------------------------------------------------

   always @(posedge sys_clk20 or negedge n_sys_reset20)
     
     begin
        
        if (~n_sys_reset20)
          
           r_read_data20 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz20)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data20 <= r_read_data20;
            
            //    latch_data20
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data20[31:24] <= data_smc20[7:0];
                 r_read_data20[23:0] <= 24'h0;
                 
              end
            
            // r_num_access20 =2, v_bus_size20 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data20[23:16] <= data_smc20[7:0];
                 r_read_data20[31:24] <= r_read_data20[31:24];
                 r_read_data20[15:0] <= 16'h0;
                 
              end
            
            // r_num_access20 =1, v_bus_size20 = `XSIZ_1620
            
            {1'b0,1'b1,2'h1,`XSIZ_1620}:
              
              begin
                 
                 r_read_data20[15:0] <= 16'h0;
                 r_read_data20[31:16] <= data_smc20[15:0];
                 
              end
            
            //  r_num_access20 =1,v_bus_size20 == `XSIZ_820
            
            {1'b0,1'b1,2'h1,`XSIZ_820}:          
              
              begin
                 
                 r_read_data20[15:8] <= data_smc20[7:0];
                 r_read_data20[31:16] <= r_read_data20[31:16];
                 r_read_data20[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access20 = 0, v_bus_size20 == `XSIZ_1620
            
            {1'b0,1'b1,2'h0,`XSIZ_1620}:  // r_num_access20 =0
              
              
              begin
                 
                 r_read_data20[15:0] <= data_smc20[15:0];
                 r_read_data20[31:16] <= r_read_data20[31:16];
                 
              end
            
            //  r_num_access20 = 0, v_bus_size20 == `XSIZ_820 
            
            {1'b0,1'b1,2'h0,`XSIZ_820}:
              
              begin
                 
                 r_read_data20[7:0] <= data_smc20[7:0];
                 r_read_data20[31:8] <= r_read_data20[31:8];
                 
              end
            
            //  r_num_access20 = 0, v_bus_size20 == `XSIZ_3220
            
            {1'b0,1'b1,2'h0,`XSIZ_3220}:
              
               r_read_data20[31:0] <= data_smc20[31:0];                      
            
            default :
              
               r_read_data20 <= r_read_data20;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals20 concatenation20 for case statement20 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata20 = {r_xfer_size20,r_bus_size20,latch_data20};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata20 or data_smc20 or r_read_data20 )
       
     begin
        
        casex(xfer_bus_ldata20)
          
          {`XSIZ_3220,`BSIZ_3220,1'b1} :
            
             read_data20[31:0] = data_smc20[31:0];
          
          {`XSIZ_3220,`BSIZ_1620,1'b1} :
                              
            begin
               
               read_data20[31:16] = r_read_data20[31:16];
               read_data20[15:0]  = data_smc20[15:0];
               
            end
          
          {`XSIZ_3220,`BSIZ_820,1'b1} :
            
            begin
               
               read_data20[31:8] = r_read_data20[31:8];
               read_data20[7:0]  = data_smc20[7:0];
               
            end
          
          {`XSIZ_3220,1'bx,1'bx,1'bx} :
            
            read_data20 = r_read_data20;
          
          {`XSIZ_1620,`BSIZ_1620,1'b1} :
                        
            begin
               
               read_data20[31:16] = data_smc20[15:0];
               read_data20[15:0] = data_smc20[15:0];
               
            end
          
          {`XSIZ_1620,`BSIZ_1620,1'b0} :  
            
            begin
               
               read_data20[31:16] = r_read_data20[15:0];
               read_data20[15:0] = r_read_data20[15:0];
               
            end
          
          {`XSIZ_1620,`BSIZ_3220,1'b1} :  
            
            read_data20 = data_smc20;
          
          {`XSIZ_1620,`BSIZ_820,1'b1} : 
                        
            begin
               
               read_data20[31:24] = r_read_data20[15:8];
               read_data20[23:16] = data_smc20[7:0];
               read_data20[15:8] = r_read_data20[15:8];
               read_data20[7:0] = data_smc20[7:0];
            end
          
          {`XSIZ_1620,`BSIZ_820,1'b0} : 
            
            begin
               
               read_data20[31:16] = r_read_data20[15:0];
               read_data20[15:0] = r_read_data20[15:0];
               
            end
          
          {`XSIZ_1620,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data20[31:16] = r_read_data20[31:16];
               read_data20[15:0] = r_read_data20[15:0];
               
            end
          
          {`XSIZ_820,`BSIZ_1620,1'b1} :
            
            begin
               
               read_data20[31:16] = data_smc20[15:0];
               read_data20[15:0] = data_smc20[15:0];
               
            end
          
          {`XSIZ_820,`BSIZ_1620,1'b0} :
            
            begin
               
               read_data20[31:16] = r_read_data20[15:0];
               read_data20[15:0]  = r_read_data20[15:0];
               
            end
          
          {`XSIZ_820,`BSIZ_3220,1'b1} :   
            
            read_data20 = data_smc20;
          
          {`XSIZ_820,`BSIZ_3220,1'b0} :              
                        
                        read_data20 = r_read_data20;
          
          {`XSIZ_820,`BSIZ_820,1'b1} :   
                                    
            begin
               
               read_data20[31:24] = data_smc20[7:0];
               read_data20[23:16] = data_smc20[7:0];
               read_data20[15:8]  = data_smc20[7:0];
               read_data20[7:0]   = data_smc20[7:0];
               
            end
          
          default:
            
            begin
               
               read_data20[31:24] = r_read_data20[7:0];
               read_data20[23:16] = r_read_data20[7:0];
               read_data20[15:8]  = r_read_data20[7:0];
               read_data20[7:0]   = r_read_data20[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata20)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal20 concatenation20 for use in case statement20
//----------------------------------------------------------------------------
   
   assign bus_size_num_access20 = { r_bus_size20, r_num_access20};
   
//--------------------------------------------------------------------
// Select20 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access20 or write_data20)
  
    begin
       
       casex(bus_size_num_access20)
         
         {`BSIZ_3220,1'bx,1'bx}://    (v_bus_size20 == `BSIZ_3220)
           
           smc_data20 = write_data20;
         
         {`BSIZ_1620,2'h1}:    // r_num_access20 == 1
                      
           begin
              
              smc_data20[31:16] = 16'h0;
              smc_data20[15:0] = write_data20[31:16];
              
           end 
         
         {`BSIZ_1620,1'bx,1'bx}:  // (v_bus_size20 == `BSIZ_1620)  
           
           begin
              
              smc_data20[31:16] = 16'h0;
              smc_data20[15:0]  = write_data20[15:0];
              
           end
         
         {`BSIZ_820,2'h3}:  //  (r_num_access20 == 3)
           
           begin
              
              smc_data20[31:8] = 24'h0;
              smc_data20[7:0] = write_data20[31:24];
           end
         
         {`BSIZ_820,2'h2}:  //   (r_num_access20 == 2)
           
           begin
              
              smc_data20[31:8] = 24'h0;
              smc_data20[7:0] = write_data20[23:16];
              
           end
         
         {`BSIZ_820,2'h1}:  //  (r_num_access20 == 2)
           
           begin
              
              smc_data20[31:8] = 24'h0;
              smc_data20[7:0]  = write_data20[15:8];
              
           end 
         
         {`BSIZ_820,2'h0}:  //  (r_num_access20 == 0) 
           
           begin
              
              smc_data20[31:8] = 24'h0;
              smc_data20[7:0] = write_data20[7:0];
              
           end 
         
         default:
           
           smc_data20 = 32'h0;
         
       endcase // casex(bus_size_num_access20)
       
       
    end
   
endmodule
