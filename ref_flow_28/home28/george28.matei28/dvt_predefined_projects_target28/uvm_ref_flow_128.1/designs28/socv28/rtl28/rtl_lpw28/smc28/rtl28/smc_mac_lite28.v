//File28 name   : smc_mac_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : Multiple28 access controller28.
//            : Static28 Memory Controller28.
//            : The Multiple28 Access Control28 Block keeps28 trace28 of the
//            : number28 of accesses required28 to fulfill28 the
//            : requirements28 of the AHB28 transfer28. The data is
//            : registered when multiple reads are required28. The AHB28
//            : holds28 the data during multiple writes.
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

`include "smc_defs_lite28.v"

module smc_mac_lite28     (

                    //inputs28
                    
                    sys_clk28,
                    n_sys_reset28,
                    valid_access28,
                    xfer_size28,
                    smc_done28,
                    data_smc28,
                    write_data28,
                    smc_nextstate28,
                    latch_data28,
                    
                    //outputs28
                    
                    r_num_access28,
                    mac_done28,
                    v_bus_size28,
                    v_xfer_size28,
                    read_data28,
                    smc_data28);
   
   
   
 


// State28 Machine28// I28/O28

  input                sys_clk28;        // System28 clock28
  input                n_sys_reset28;    // System28 reset (Active28 LOW28)
  input                valid_access28;   // Address cycle of new transfer28
  input  [1:0]         xfer_size28;      // xfer28 size, valid with valid_access28
  input                smc_done28;       // End28 of transfer28
  input  [31:0]        data_smc28;       // External28 read data
  input  [31:0]        write_data28;     // Data from internal bus 
  input  [4:0]         smc_nextstate28;  // State28 Machine28  
  input                latch_data28;     //latch_data28 is used by the MAC28 block    
  
  output [1:0]         r_num_access28;   // Access counter
  output               mac_done28;       // End28 of all transfers28
  output [1:0]         v_bus_size28;     // Registered28 sizes28 for subsequent28
  output [1:0]         v_xfer_size28;    // transfers28 in MAC28 transfer28
  output [31:0]        read_data28;      // Data to internal bus
  output [31:0]        smc_data28;       // Data to external28 bus
  

// Output28 register declarations28

  reg                  mac_done28;       // Indicates28 last cycle of last access
  reg [1:0]            r_num_access28;   // Access counter
  reg [1:0]            num_accesses28;   //number28 of access
  reg [1:0]            r_xfer_size28;    // Store28 size for MAC28 
  reg [1:0]            r_bus_size28;     // Store28 size for MAC28
  reg [31:0]           read_data28;      // Data path to bus IF
  reg [31:0]           r_read_data28;    // Internal data store28
  reg [31:0]           smc_data28;


// Internal Signals28

  reg [1:0]            v_bus_size28;
  reg [1:0]            v_xfer_size28;
  wire [4:0]           smc_nextstate28;    //specifies28 next state
  wire [4:0]           xfer_bus_ldata28;  //concatenation28 of xfer_size28
                                         // and latch_data28  
  wire [3:0]           bus_size_num_access28; //concatenation28 of 
                                              // r_num_access28
  wire [5:0]           wt_ldata_naccs_bsiz28;  //concatenation28 of 
                                            //latch_data28,r_num_access28
 
   


// Main28 Code28

//----------------------------------------------------------------------------
// Store28 transfer28 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk28 or negedge n_sys_reset28)
  
    begin
       
       if (~n_sys_reset28)
         
          r_xfer_size28 <= 2'b00;
       
       
       else if (valid_access28)
         
          r_xfer_size28 <= xfer_size28;
       
       else
         
          r_xfer_size28 <= r_xfer_size28;
       
    end

//--------------------------------------------------------------------
// Store28 bus size generation28
//--------------------------------------------------------------------
  
  always @(posedge sys_clk28 or negedge n_sys_reset28)
    
    begin
       
       if (~n_sys_reset28)
         
          r_bus_size28 <= 2'b00;
       
       
       else if (valid_access28)
         
          r_bus_size28 <= 2'b00;
       
       else
         
          r_bus_size28 <= r_bus_size28;
       
    end
   

//--------------------------------------------------------------------
// Validate28 sizes28 generation28
//--------------------------------------------------------------------

  always @(valid_access28 or r_bus_size28 )

    begin
       
       if (valid_access28)
         
          v_bus_size28 = 2'b0;
       
       else
         
          v_bus_size28 = r_bus_size28;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size28 generation28
//----------------------------------------------------------------------------   

  always @(valid_access28 or r_xfer_size28 or xfer_size28)

    begin
       
       if (valid_access28)
         
          v_xfer_size28 = xfer_size28;
       
       else
         
          v_xfer_size28 = r_xfer_size28;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions28
// Determines28 the number28 of accesses required28 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size28)
  
    begin
       
       if ((xfer_size28[1:0] == `XSIZ_1628))
         
          num_accesses28 = 2'h1; // Two28 accesses
       
       else if ( (xfer_size28[1:0] == `XSIZ_3228))
         
          num_accesses28 = 2'h3; // Four28 accesses
       
       else
         
          num_accesses28 = 2'h0; // One28 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep28 track28 of the current access number28
//--------------------------------------------------------------------
   
  always @(posedge sys_clk28 or negedge n_sys_reset28)
  
    begin
       
       if (~n_sys_reset28)
         
          r_num_access28 <= 2'b00;
       
       else if (valid_access28)
         
          r_num_access28 <= num_accesses28;
       
       else if (smc_done28 & (smc_nextstate28 != `SMC_STORE28)  &
                      (smc_nextstate28 != `SMC_IDLE28)   )
         
          r_num_access28 <= r_num_access28 - 2'd1;
       
       else
         
          r_num_access28 <= r_num_access28;
       
    end
   
   

//--------------------------------------------------------------------
// Detect28 last access
//--------------------------------------------------------------------
   
   always @(r_num_access28)
     
     begin
        
        if (r_num_access28 == 2'h0)
          
           mac_done28 = 1'b1;
             
        else
          
           mac_done28 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals28 concatenation28 used in case statement28 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz28 = { 1'b0, latch_data28, r_num_access28,
                                  r_bus_size28};
 
   
//--------------------------------------------------------------------
// Store28 Read Data if required28
//--------------------------------------------------------------------

   always @(posedge sys_clk28 or negedge n_sys_reset28)
     
     begin
        
        if (~n_sys_reset28)
          
           r_read_data28 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz28)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data28 <= r_read_data28;
            
            //    latch_data28
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data28[31:24] <= data_smc28[7:0];
                 r_read_data28[23:0] <= 24'h0;
                 
              end
            
            // r_num_access28 =2, v_bus_size28 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data28[23:16] <= data_smc28[7:0];
                 r_read_data28[31:24] <= r_read_data28[31:24];
                 r_read_data28[15:0] <= 16'h0;
                 
              end
            
            // r_num_access28 =1, v_bus_size28 = `XSIZ_1628
            
            {1'b0,1'b1,2'h1,`XSIZ_1628}:
              
              begin
                 
                 r_read_data28[15:0] <= 16'h0;
                 r_read_data28[31:16] <= data_smc28[15:0];
                 
              end
            
            //  r_num_access28 =1,v_bus_size28 == `XSIZ_828
            
            {1'b0,1'b1,2'h1,`XSIZ_828}:          
              
              begin
                 
                 r_read_data28[15:8] <= data_smc28[7:0];
                 r_read_data28[31:16] <= r_read_data28[31:16];
                 r_read_data28[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access28 = 0, v_bus_size28 == `XSIZ_1628
            
            {1'b0,1'b1,2'h0,`XSIZ_1628}:  // r_num_access28 =0
              
              
              begin
                 
                 r_read_data28[15:0] <= data_smc28[15:0];
                 r_read_data28[31:16] <= r_read_data28[31:16];
                 
              end
            
            //  r_num_access28 = 0, v_bus_size28 == `XSIZ_828 
            
            {1'b0,1'b1,2'h0,`XSIZ_828}:
              
              begin
                 
                 r_read_data28[7:0] <= data_smc28[7:0];
                 r_read_data28[31:8] <= r_read_data28[31:8];
                 
              end
            
            //  r_num_access28 = 0, v_bus_size28 == `XSIZ_3228
            
            {1'b0,1'b1,2'h0,`XSIZ_3228}:
              
               r_read_data28[31:0] <= data_smc28[31:0];                      
            
            default :
              
               r_read_data28 <= r_read_data28;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals28 concatenation28 for case statement28 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata28 = {r_xfer_size28,r_bus_size28,latch_data28};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata28 or data_smc28 or r_read_data28 )
       
     begin
        
        casex(xfer_bus_ldata28)
          
          {`XSIZ_3228,`BSIZ_3228,1'b1} :
            
             read_data28[31:0] = data_smc28[31:0];
          
          {`XSIZ_3228,`BSIZ_1628,1'b1} :
                              
            begin
               
               read_data28[31:16] = r_read_data28[31:16];
               read_data28[15:0]  = data_smc28[15:0];
               
            end
          
          {`XSIZ_3228,`BSIZ_828,1'b1} :
            
            begin
               
               read_data28[31:8] = r_read_data28[31:8];
               read_data28[7:0]  = data_smc28[7:0];
               
            end
          
          {`XSIZ_3228,1'bx,1'bx,1'bx} :
            
            read_data28 = r_read_data28;
          
          {`XSIZ_1628,`BSIZ_1628,1'b1} :
                        
            begin
               
               read_data28[31:16] = data_smc28[15:0];
               read_data28[15:0] = data_smc28[15:0];
               
            end
          
          {`XSIZ_1628,`BSIZ_1628,1'b0} :  
            
            begin
               
               read_data28[31:16] = r_read_data28[15:0];
               read_data28[15:0] = r_read_data28[15:0];
               
            end
          
          {`XSIZ_1628,`BSIZ_3228,1'b1} :  
            
            read_data28 = data_smc28;
          
          {`XSIZ_1628,`BSIZ_828,1'b1} : 
                        
            begin
               
               read_data28[31:24] = r_read_data28[15:8];
               read_data28[23:16] = data_smc28[7:0];
               read_data28[15:8] = r_read_data28[15:8];
               read_data28[7:0] = data_smc28[7:0];
            end
          
          {`XSIZ_1628,`BSIZ_828,1'b0} : 
            
            begin
               
               read_data28[31:16] = r_read_data28[15:0];
               read_data28[15:0] = r_read_data28[15:0];
               
            end
          
          {`XSIZ_1628,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data28[31:16] = r_read_data28[31:16];
               read_data28[15:0] = r_read_data28[15:0];
               
            end
          
          {`XSIZ_828,`BSIZ_1628,1'b1} :
            
            begin
               
               read_data28[31:16] = data_smc28[15:0];
               read_data28[15:0] = data_smc28[15:0];
               
            end
          
          {`XSIZ_828,`BSIZ_1628,1'b0} :
            
            begin
               
               read_data28[31:16] = r_read_data28[15:0];
               read_data28[15:0]  = r_read_data28[15:0];
               
            end
          
          {`XSIZ_828,`BSIZ_3228,1'b1} :   
            
            read_data28 = data_smc28;
          
          {`XSIZ_828,`BSIZ_3228,1'b0} :              
                        
                        read_data28 = r_read_data28;
          
          {`XSIZ_828,`BSIZ_828,1'b1} :   
                                    
            begin
               
               read_data28[31:24] = data_smc28[7:0];
               read_data28[23:16] = data_smc28[7:0];
               read_data28[15:8]  = data_smc28[7:0];
               read_data28[7:0]   = data_smc28[7:0];
               
            end
          
          default:
            
            begin
               
               read_data28[31:24] = r_read_data28[7:0];
               read_data28[23:16] = r_read_data28[7:0];
               read_data28[15:8]  = r_read_data28[7:0];
               read_data28[7:0]   = r_read_data28[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata28)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal28 concatenation28 for use in case statement28
//----------------------------------------------------------------------------
   
   assign bus_size_num_access28 = { r_bus_size28, r_num_access28};
   
//--------------------------------------------------------------------
// Select28 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access28 or write_data28)
  
    begin
       
       casex(bus_size_num_access28)
         
         {`BSIZ_3228,1'bx,1'bx}://    (v_bus_size28 == `BSIZ_3228)
           
           smc_data28 = write_data28;
         
         {`BSIZ_1628,2'h1}:    // r_num_access28 == 1
                      
           begin
              
              smc_data28[31:16] = 16'h0;
              smc_data28[15:0] = write_data28[31:16];
              
           end 
         
         {`BSIZ_1628,1'bx,1'bx}:  // (v_bus_size28 == `BSIZ_1628)  
           
           begin
              
              smc_data28[31:16] = 16'h0;
              smc_data28[15:0]  = write_data28[15:0];
              
           end
         
         {`BSIZ_828,2'h3}:  //  (r_num_access28 == 3)
           
           begin
              
              smc_data28[31:8] = 24'h0;
              smc_data28[7:0] = write_data28[31:24];
           end
         
         {`BSIZ_828,2'h2}:  //   (r_num_access28 == 2)
           
           begin
              
              smc_data28[31:8] = 24'h0;
              smc_data28[7:0] = write_data28[23:16];
              
           end
         
         {`BSIZ_828,2'h1}:  //  (r_num_access28 == 2)
           
           begin
              
              smc_data28[31:8] = 24'h0;
              smc_data28[7:0]  = write_data28[15:8];
              
           end 
         
         {`BSIZ_828,2'h0}:  //  (r_num_access28 == 0) 
           
           begin
              
              smc_data28[31:8] = 24'h0;
              smc_data28[7:0] = write_data28[7:0];
              
           end 
         
         default:
           
           smc_data28 = 32'h0;
         
       endcase // casex(bus_size_num_access28)
       
       
    end
   
endmodule
