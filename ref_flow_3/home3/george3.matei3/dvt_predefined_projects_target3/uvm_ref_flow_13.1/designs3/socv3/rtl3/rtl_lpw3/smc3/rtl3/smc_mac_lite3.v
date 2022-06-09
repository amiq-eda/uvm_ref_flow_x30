//File3 name   : smc_mac_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : Multiple3 access controller3.
//            : Static3 Memory Controller3.
//            : The Multiple3 Access Control3 Block keeps3 trace3 of the
//            : number3 of accesses required3 to fulfill3 the
//            : requirements3 of the AHB3 transfer3. The data is
//            : registered when multiple reads are required3. The AHB3
//            : holds3 the data during multiple writes.
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

`include "smc_defs_lite3.v"

module smc_mac_lite3     (

                    //inputs3
                    
                    sys_clk3,
                    n_sys_reset3,
                    valid_access3,
                    xfer_size3,
                    smc_done3,
                    data_smc3,
                    write_data3,
                    smc_nextstate3,
                    latch_data3,
                    
                    //outputs3
                    
                    r_num_access3,
                    mac_done3,
                    v_bus_size3,
                    v_xfer_size3,
                    read_data3,
                    smc_data3);
   
   
   
 


// State3 Machine3// I3/O3

  input                sys_clk3;        // System3 clock3
  input                n_sys_reset3;    // System3 reset (Active3 LOW3)
  input                valid_access3;   // Address cycle of new transfer3
  input  [1:0]         xfer_size3;      // xfer3 size, valid with valid_access3
  input                smc_done3;       // End3 of transfer3
  input  [31:0]        data_smc3;       // External3 read data
  input  [31:0]        write_data3;     // Data from internal bus 
  input  [4:0]         smc_nextstate3;  // State3 Machine3  
  input                latch_data3;     //latch_data3 is used by the MAC3 block    
  
  output [1:0]         r_num_access3;   // Access counter
  output               mac_done3;       // End3 of all transfers3
  output [1:0]         v_bus_size3;     // Registered3 sizes3 for subsequent3
  output [1:0]         v_xfer_size3;    // transfers3 in MAC3 transfer3
  output [31:0]        read_data3;      // Data to internal bus
  output [31:0]        smc_data3;       // Data to external3 bus
  

// Output3 register declarations3

  reg                  mac_done3;       // Indicates3 last cycle of last access
  reg [1:0]            r_num_access3;   // Access counter
  reg [1:0]            num_accesses3;   //number3 of access
  reg [1:0]            r_xfer_size3;    // Store3 size for MAC3 
  reg [1:0]            r_bus_size3;     // Store3 size for MAC3
  reg [31:0]           read_data3;      // Data path to bus IF
  reg [31:0]           r_read_data3;    // Internal data store3
  reg [31:0]           smc_data3;


// Internal Signals3

  reg [1:0]            v_bus_size3;
  reg [1:0]            v_xfer_size3;
  wire [4:0]           smc_nextstate3;    //specifies3 next state
  wire [4:0]           xfer_bus_ldata3;  //concatenation3 of xfer_size3
                                         // and latch_data3  
  wire [3:0]           bus_size_num_access3; //concatenation3 of 
                                              // r_num_access3
  wire [5:0]           wt_ldata_naccs_bsiz3;  //concatenation3 of 
                                            //latch_data3,r_num_access3
 
   


// Main3 Code3

//----------------------------------------------------------------------------
// Store3 transfer3 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk3 or negedge n_sys_reset3)
  
    begin
       
       if (~n_sys_reset3)
         
          r_xfer_size3 <= 2'b00;
       
       
       else if (valid_access3)
         
          r_xfer_size3 <= xfer_size3;
       
       else
         
          r_xfer_size3 <= r_xfer_size3;
       
    end

//--------------------------------------------------------------------
// Store3 bus size generation3
//--------------------------------------------------------------------
  
  always @(posedge sys_clk3 or negedge n_sys_reset3)
    
    begin
       
       if (~n_sys_reset3)
         
          r_bus_size3 <= 2'b00;
       
       
       else if (valid_access3)
         
          r_bus_size3 <= 2'b00;
       
       else
         
          r_bus_size3 <= r_bus_size3;
       
    end
   

//--------------------------------------------------------------------
// Validate3 sizes3 generation3
//--------------------------------------------------------------------

  always @(valid_access3 or r_bus_size3 )

    begin
       
       if (valid_access3)
         
          v_bus_size3 = 2'b0;
       
       else
         
          v_bus_size3 = r_bus_size3;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size3 generation3
//----------------------------------------------------------------------------   

  always @(valid_access3 or r_xfer_size3 or xfer_size3)

    begin
       
       if (valid_access3)
         
          v_xfer_size3 = xfer_size3;
       
       else
         
          v_xfer_size3 = r_xfer_size3;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions3
// Determines3 the number3 of accesses required3 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size3)
  
    begin
       
       if ((xfer_size3[1:0] == `XSIZ_163))
         
          num_accesses3 = 2'h1; // Two3 accesses
       
       else if ( (xfer_size3[1:0] == `XSIZ_323))
         
          num_accesses3 = 2'h3; // Four3 accesses
       
       else
         
          num_accesses3 = 2'h0; // One3 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep3 track3 of the current access number3
//--------------------------------------------------------------------
   
  always @(posedge sys_clk3 or negedge n_sys_reset3)
  
    begin
       
       if (~n_sys_reset3)
         
          r_num_access3 <= 2'b00;
       
       else if (valid_access3)
         
          r_num_access3 <= num_accesses3;
       
       else if (smc_done3 & (smc_nextstate3 != `SMC_STORE3)  &
                      (smc_nextstate3 != `SMC_IDLE3)   )
         
          r_num_access3 <= r_num_access3 - 2'd1;
       
       else
         
          r_num_access3 <= r_num_access3;
       
    end
   
   

//--------------------------------------------------------------------
// Detect3 last access
//--------------------------------------------------------------------
   
   always @(r_num_access3)
     
     begin
        
        if (r_num_access3 == 2'h0)
          
           mac_done3 = 1'b1;
             
        else
          
           mac_done3 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals3 concatenation3 used in case statement3 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz3 = { 1'b0, latch_data3, r_num_access3,
                                  r_bus_size3};
 
   
//--------------------------------------------------------------------
// Store3 Read Data if required3
//--------------------------------------------------------------------

   always @(posedge sys_clk3 or negedge n_sys_reset3)
     
     begin
        
        if (~n_sys_reset3)
          
           r_read_data3 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz3)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data3 <= r_read_data3;
            
            //    latch_data3
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data3[31:24] <= data_smc3[7:0];
                 r_read_data3[23:0] <= 24'h0;
                 
              end
            
            // r_num_access3 =2, v_bus_size3 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data3[23:16] <= data_smc3[7:0];
                 r_read_data3[31:24] <= r_read_data3[31:24];
                 r_read_data3[15:0] <= 16'h0;
                 
              end
            
            // r_num_access3 =1, v_bus_size3 = `XSIZ_163
            
            {1'b0,1'b1,2'h1,`XSIZ_163}:
              
              begin
                 
                 r_read_data3[15:0] <= 16'h0;
                 r_read_data3[31:16] <= data_smc3[15:0];
                 
              end
            
            //  r_num_access3 =1,v_bus_size3 == `XSIZ_83
            
            {1'b0,1'b1,2'h1,`XSIZ_83}:          
              
              begin
                 
                 r_read_data3[15:8] <= data_smc3[7:0];
                 r_read_data3[31:16] <= r_read_data3[31:16];
                 r_read_data3[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access3 = 0, v_bus_size3 == `XSIZ_163
            
            {1'b0,1'b1,2'h0,`XSIZ_163}:  // r_num_access3 =0
              
              
              begin
                 
                 r_read_data3[15:0] <= data_smc3[15:0];
                 r_read_data3[31:16] <= r_read_data3[31:16];
                 
              end
            
            //  r_num_access3 = 0, v_bus_size3 == `XSIZ_83 
            
            {1'b0,1'b1,2'h0,`XSIZ_83}:
              
              begin
                 
                 r_read_data3[7:0] <= data_smc3[7:0];
                 r_read_data3[31:8] <= r_read_data3[31:8];
                 
              end
            
            //  r_num_access3 = 0, v_bus_size3 == `XSIZ_323
            
            {1'b0,1'b1,2'h0,`XSIZ_323}:
              
               r_read_data3[31:0] <= data_smc3[31:0];                      
            
            default :
              
               r_read_data3 <= r_read_data3;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals3 concatenation3 for case statement3 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata3 = {r_xfer_size3,r_bus_size3,latch_data3};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata3 or data_smc3 or r_read_data3 )
       
     begin
        
        casex(xfer_bus_ldata3)
          
          {`XSIZ_323,`BSIZ_323,1'b1} :
            
             read_data3[31:0] = data_smc3[31:0];
          
          {`XSIZ_323,`BSIZ_163,1'b1} :
                              
            begin
               
               read_data3[31:16] = r_read_data3[31:16];
               read_data3[15:0]  = data_smc3[15:0];
               
            end
          
          {`XSIZ_323,`BSIZ_83,1'b1} :
            
            begin
               
               read_data3[31:8] = r_read_data3[31:8];
               read_data3[7:0]  = data_smc3[7:0];
               
            end
          
          {`XSIZ_323,1'bx,1'bx,1'bx} :
            
            read_data3 = r_read_data3;
          
          {`XSIZ_163,`BSIZ_163,1'b1} :
                        
            begin
               
               read_data3[31:16] = data_smc3[15:0];
               read_data3[15:0] = data_smc3[15:0];
               
            end
          
          {`XSIZ_163,`BSIZ_163,1'b0} :  
            
            begin
               
               read_data3[31:16] = r_read_data3[15:0];
               read_data3[15:0] = r_read_data3[15:0];
               
            end
          
          {`XSIZ_163,`BSIZ_323,1'b1} :  
            
            read_data3 = data_smc3;
          
          {`XSIZ_163,`BSIZ_83,1'b1} : 
                        
            begin
               
               read_data3[31:24] = r_read_data3[15:8];
               read_data3[23:16] = data_smc3[7:0];
               read_data3[15:8] = r_read_data3[15:8];
               read_data3[7:0] = data_smc3[7:0];
            end
          
          {`XSIZ_163,`BSIZ_83,1'b0} : 
            
            begin
               
               read_data3[31:16] = r_read_data3[15:0];
               read_data3[15:0] = r_read_data3[15:0];
               
            end
          
          {`XSIZ_163,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data3[31:16] = r_read_data3[31:16];
               read_data3[15:0] = r_read_data3[15:0];
               
            end
          
          {`XSIZ_83,`BSIZ_163,1'b1} :
            
            begin
               
               read_data3[31:16] = data_smc3[15:0];
               read_data3[15:0] = data_smc3[15:0];
               
            end
          
          {`XSIZ_83,`BSIZ_163,1'b0} :
            
            begin
               
               read_data3[31:16] = r_read_data3[15:0];
               read_data3[15:0]  = r_read_data3[15:0];
               
            end
          
          {`XSIZ_83,`BSIZ_323,1'b1} :   
            
            read_data3 = data_smc3;
          
          {`XSIZ_83,`BSIZ_323,1'b0} :              
                        
                        read_data3 = r_read_data3;
          
          {`XSIZ_83,`BSIZ_83,1'b1} :   
                                    
            begin
               
               read_data3[31:24] = data_smc3[7:0];
               read_data3[23:16] = data_smc3[7:0];
               read_data3[15:8]  = data_smc3[7:0];
               read_data3[7:0]   = data_smc3[7:0];
               
            end
          
          default:
            
            begin
               
               read_data3[31:24] = r_read_data3[7:0];
               read_data3[23:16] = r_read_data3[7:0];
               read_data3[15:8]  = r_read_data3[7:0];
               read_data3[7:0]   = r_read_data3[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata3)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal3 concatenation3 for use in case statement3
//----------------------------------------------------------------------------
   
   assign bus_size_num_access3 = { r_bus_size3, r_num_access3};
   
//--------------------------------------------------------------------
// Select3 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access3 or write_data3)
  
    begin
       
       casex(bus_size_num_access3)
         
         {`BSIZ_323,1'bx,1'bx}://    (v_bus_size3 == `BSIZ_323)
           
           smc_data3 = write_data3;
         
         {`BSIZ_163,2'h1}:    // r_num_access3 == 1
                      
           begin
              
              smc_data3[31:16] = 16'h0;
              smc_data3[15:0] = write_data3[31:16];
              
           end 
         
         {`BSIZ_163,1'bx,1'bx}:  // (v_bus_size3 == `BSIZ_163)  
           
           begin
              
              smc_data3[31:16] = 16'h0;
              smc_data3[15:0]  = write_data3[15:0];
              
           end
         
         {`BSIZ_83,2'h3}:  //  (r_num_access3 == 3)
           
           begin
              
              smc_data3[31:8] = 24'h0;
              smc_data3[7:0] = write_data3[31:24];
           end
         
         {`BSIZ_83,2'h2}:  //   (r_num_access3 == 2)
           
           begin
              
              smc_data3[31:8] = 24'h0;
              smc_data3[7:0] = write_data3[23:16];
              
           end
         
         {`BSIZ_83,2'h1}:  //  (r_num_access3 == 2)
           
           begin
              
              smc_data3[31:8] = 24'h0;
              smc_data3[7:0]  = write_data3[15:8];
              
           end 
         
         {`BSIZ_83,2'h0}:  //  (r_num_access3 == 0) 
           
           begin
              
              smc_data3[31:8] = 24'h0;
              smc_data3[7:0] = write_data3[7:0];
              
           end 
         
         default:
           
           smc_data3 = 32'h0;
         
       endcase // casex(bus_size_num_access3)
       
       
    end
   
endmodule
