//File10 name   : smc_mac_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : Multiple10 access controller10.
//            : Static10 Memory Controller10.
//            : The Multiple10 Access Control10 Block keeps10 trace10 of the
//            : number10 of accesses required10 to fulfill10 the
//            : requirements10 of the AHB10 transfer10. The data is
//            : registered when multiple reads are required10. The AHB10
//            : holds10 the data during multiple writes.
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

`include "smc_defs_lite10.v"

module smc_mac_lite10     (

                    //inputs10
                    
                    sys_clk10,
                    n_sys_reset10,
                    valid_access10,
                    xfer_size10,
                    smc_done10,
                    data_smc10,
                    write_data10,
                    smc_nextstate10,
                    latch_data10,
                    
                    //outputs10
                    
                    r_num_access10,
                    mac_done10,
                    v_bus_size10,
                    v_xfer_size10,
                    read_data10,
                    smc_data10);
   
   
   
 


// State10 Machine10// I10/O10

  input                sys_clk10;        // System10 clock10
  input                n_sys_reset10;    // System10 reset (Active10 LOW10)
  input                valid_access10;   // Address cycle of new transfer10
  input  [1:0]         xfer_size10;      // xfer10 size, valid with valid_access10
  input                smc_done10;       // End10 of transfer10
  input  [31:0]        data_smc10;       // External10 read data
  input  [31:0]        write_data10;     // Data from internal bus 
  input  [4:0]         smc_nextstate10;  // State10 Machine10  
  input                latch_data10;     //latch_data10 is used by the MAC10 block    
  
  output [1:0]         r_num_access10;   // Access counter
  output               mac_done10;       // End10 of all transfers10
  output [1:0]         v_bus_size10;     // Registered10 sizes10 for subsequent10
  output [1:0]         v_xfer_size10;    // transfers10 in MAC10 transfer10
  output [31:0]        read_data10;      // Data to internal bus
  output [31:0]        smc_data10;       // Data to external10 bus
  

// Output10 register declarations10

  reg                  mac_done10;       // Indicates10 last cycle of last access
  reg [1:0]            r_num_access10;   // Access counter
  reg [1:0]            num_accesses10;   //number10 of access
  reg [1:0]            r_xfer_size10;    // Store10 size for MAC10 
  reg [1:0]            r_bus_size10;     // Store10 size for MAC10
  reg [31:0]           read_data10;      // Data path to bus IF
  reg [31:0]           r_read_data10;    // Internal data store10
  reg [31:0]           smc_data10;


// Internal Signals10

  reg [1:0]            v_bus_size10;
  reg [1:0]            v_xfer_size10;
  wire [4:0]           smc_nextstate10;    //specifies10 next state
  wire [4:0]           xfer_bus_ldata10;  //concatenation10 of xfer_size10
                                         // and latch_data10  
  wire [3:0]           bus_size_num_access10; //concatenation10 of 
                                              // r_num_access10
  wire [5:0]           wt_ldata_naccs_bsiz10;  //concatenation10 of 
                                            //latch_data10,r_num_access10
 
   


// Main10 Code10

//----------------------------------------------------------------------------
// Store10 transfer10 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk10 or negedge n_sys_reset10)
  
    begin
       
       if (~n_sys_reset10)
         
          r_xfer_size10 <= 2'b00;
       
       
       else if (valid_access10)
         
          r_xfer_size10 <= xfer_size10;
       
       else
         
          r_xfer_size10 <= r_xfer_size10;
       
    end

//--------------------------------------------------------------------
// Store10 bus size generation10
//--------------------------------------------------------------------
  
  always @(posedge sys_clk10 or negedge n_sys_reset10)
    
    begin
       
       if (~n_sys_reset10)
         
          r_bus_size10 <= 2'b00;
       
       
       else if (valid_access10)
         
          r_bus_size10 <= 2'b00;
       
       else
         
          r_bus_size10 <= r_bus_size10;
       
    end
   

//--------------------------------------------------------------------
// Validate10 sizes10 generation10
//--------------------------------------------------------------------

  always @(valid_access10 or r_bus_size10 )

    begin
       
       if (valid_access10)
         
          v_bus_size10 = 2'b0;
       
       else
         
          v_bus_size10 = r_bus_size10;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size10 generation10
//----------------------------------------------------------------------------   

  always @(valid_access10 or r_xfer_size10 or xfer_size10)

    begin
       
       if (valid_access10)
         
          v_xfer_size10 = xfer_size10;
       
       else
         
          v_xfer_size10 = r_xfer_size10;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions10
// Determines10 the number10 of accesses required10 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size10)
  
    begin
       
       if ((xfer_size10[1:0] == `XSIZ_1610))
         
          num_accesses10 = 2'h1; // Two10 accesses
       
       else if ( (xfer_size10[1:0] == `XSIZ_3210))
         
          num_accesses10 = 2'h3; // Four10 accesses
       
       else
         
          num_accesses10 = 2'h0; // One10 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep10 track10 of the current access number10
//--------------------------------------------------------------------
   
  always @(posedge sys_clk10 or negedge n_sys_reset10)
  
    begin
       
       if (~n_sys_reset10)
         
          r_num_access10 <= 2'b00;
       
       else if (valid_access10)
         
          r_num_access10 <= num_accesses10;
       
       else if (smc_done10 & (smc_nextstate10 != `SMC_STORE10)  &
                      (smc_nextstate10 != `SMC_IDLE10)   )
         
          r_num_access10 <= r_num_access10 - 2'd1;
       
       else
         
          r_num_access10 <= r_num_access10;
       
    end
   
   

//--------------------------------------------------------------------
// Detect10 last access
//--------------------------------------------------------------------
   
   always @(r_num_access10)
     
     begin
        
        if (r_num_access10 == 2'h0)
          
           mac_done10 = 1'b1;
             
        else
          
           mac_done10 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals10 concatenation10 used in case statement10 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz10 = { 1'b0, latch_data10, r_num_access10,
                                  r_bus_size10};
 
   
//--------------------------------------------------------------------
// Store10 Read Data if required10
//--------------------------------------------------------------------

   always @(posedge sys_clk10 or negedge n_sys_reset10)
     
     begin
        
        if (~n_sys_reset10)
          
           r_read_data10 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz10)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data10 <= r_read_data10;
            
            //    latch_data10
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data10[31:24] <= data_smc10[7:0];
                 r_read_data10[23:0] <= 24'h0;
                 
              end
            
            // r_num_access10 =2, v_bus_size10 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data10[23:16] <= data_smc10[7:0];
                 r_read_data10[31:24] <= r_read_data10[31:24];
                 r_read_data10[15:0] <= 16'h0;
                 
              end
            
            // r_num_access10 =1, v_bus_size10 = `XSIZ_1610
            
            {1'b0,1'b1,2'h1,`XSIZ_1610}:
              
              begin
                 
                 r_read_data10[15:0] <= 16'h0;
                 r_read_data10[31:16] <= data_smc10[15:0];
                 
              end
            
            //  r_num_access10 =1,v_bus_size10 == `XSIZ_810
            
            {1'b0,1'b1,2'h1,`XSIZ_810}:          
              
              begin
                 
                 r_read_data10[15:8] <= data_smc10[7:0];
                 r_read_data10[31:16] <= r_read_data10[31:16];
                 r_read_data10[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access10 = 0, v_bus_size10 == `XSIZ_1610
            
            {1'b0,1'b1,2'h0,`XSIZ_1610}:  // r_num_access10 =0
              
              
              begin
                 
                 r_read_data10[15:0] <= data_smc10[15:0];
                 r_read_data10[31:16] <= r_read_data10[31:16];
                 
              end
            
            //  r_num_access10 = 0, v_bus_size10 == `XSIZ_810 
            
            {1'b0,1'b1,2'h0,`XSIZ_810}:
              
              begin
                 
                 r_read_data10[7:0] <= data_smc10[7:0];
                 r_read_data10[31:8] <= r_read_data10[31:8];
                 
              end
            
            //  r_num_access10 = 0, v_bus_size10 == `XSIZ_3210
            
            {1'b0,1'b1,2'h0,`XSIZ_3210}:
              
               r_read_data10[31:0] <= data_smc10[31:0];                      
            
            default :
              
               r_read_data10 <= r_read_data10;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals10 concatenation10 for case statement10 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata10 = {r_xfer_size10,r_bus_size10,latch_data10};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata10 or data_smc10 or r_read_data10 )
       
     begin
        
        casex(xfer_bus_ldata10)
          
          {`XSIZ_3210,`BSIZ_3210,1'b1} :
            
             read_data10[31:0] = data_smc10[31:0];
          
          {`XSIZ_3210,`BSIZ_1610,1'b1} :
                              
            begin
               
               read_data10[31:16] = r_read_data10[31:16];
               read_data10[15:0]  = data_smc10[15:0];
               
            end
          
          {`XSIZ_3210,`BSIZ_810,1'b1} :
            
            begin
               
               read_data10[31:8] = r_read_data10[31:8];
               read_data10[7:0]  = data_smc10[7:0];
               
            end
          
          {`XSIZ_3210,1'bx,1'bx,1'bx} :
            
            read_data10 = r_read_data10;
          
          {`XSIZ_1610,`BSIZ_1610,1'b1} :
                        
            begin
               
               read_data10[31:16] = data_smc10[15:0];
               read_data10[15:0] = data_smc10[15:0];
               
            end
          
          {`XSIZ_1610,`BSIZ_1610,1'b0} :  
            
            begin
               
               read_data10[31:16] = r_read_data10[15:0];
               read_data10[15:0] = r_read_data10[15:0];
               
            end
          
          {`XSIZ_1610,`BSIZ_3210,1'b1} :  
            
            read_data10 = data_smc10;
          
          {`XSIZ_1610,`BSIZ_810,1'b1} : 
                        
            begin
               
               read_data10[31:24] = r_read_data10[15:8];
               read_data10[23:16] = data_smc10[7:0];
               read_data10[15:8] = r_read_data10[15:8];
               read_data10[7:0] = data_smc10[7:0];
            end
          
          {`XSIZ_1610,`BSIZ_810,1'b0} : 
            
            begin
               
               read_data10[31:16] = r_read_data10[15:0];
               read_data10[15:0] = r_read_data10[15:0];
               
            end
          
          {`XSIZ_1610,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data10[31:16] = r_read_data10[31:16];
               read_data10[15:0] = r_read_data10[15:0];
               
            end
          
          {`XSIZ_810,`BSIZ_1610,1'b1} :
            
            begin
               
               read_data10[31:16] = data_smc10[15:0];
               read_data10[15:0] = data_smc10[15:0];
               
            end
          
          {`XSIZ_810,`BSIZ_1610,1'b0} :
            
            begin
               
               read_data10[31:16] = r_read_data10[15:0];
               read_data10[15:0]  = r_read_data10[15:0];
               
            end
          
          {`XSIZ_810,`BSIZ_3210,1'b1} :   
            
            read_data10 = data_smc10;
          
          {`XSIZ_810,`BSIZ_3210,1'b0} :              
                        
                        read_data10 = r_read_data10;
          
          {`XSIZ_810,`BSIZ_810,1'b1} :   
                                    
            begin
               
               read_data10[31:24] = data_smc10[7:0];
               read_data10[23:16] = data_smc10[7:0];
               read_data10[15:8]  = data_smc10[7:0];
               read_data10[7:0]   = data_smc10[7:0];
               
            end
          
          default:
            
            begin
               
               read_data10[31:24] = r_read_data10[7:0];
               read_data10[23:16] = r_read_data10[7:0];
               read_data10[15:8]  = r_read_data10[7:0];
               read_data10[7:0]   = r_read_data10[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata10)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal10 concatenation10 for use in case statement10
//----------------------------------------------------------------------------
   
   assign bus_size_num_access10 = { r_bus_size10, r_num_access10};
   
//--------------------------------------------------------------------
// Select10 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access10 or write_data10)
  
    begin
       
       casex(bus_size_num_access10)
         
         {`BSIZ_3210,1'bx,1'bx}://    (v_bus_size10 == `BSIZ_3210)
           
           smc_data10 = write_data10;
         
         {`BSIZ_1610,2'h1}:    // r_num_access10 == 1
                      
           begin
              
              smc_data10[31:16] = 16'h0;
              smc_data10[15:0] = write_data10[31:16];
              
           end 
         
         {`BSIZ_1610,1'bx,1'bx}:  // (v_bus_size10 == `BSIZ_1610)  
           
           begin
              
              smc_data10[31:16] = 16'h0;
              smc_data10[15:0]  = write_data10[15:0];
              
           end
         
         {`BSIZ_810,2'h3}:  //  (r_num_access10 == 3)
           
           begin
              
              smc_data10[31:8] = 24'h0;
              smc_data10[7:0] = write_data10[31:24];
           end
         
         {`BSIZ_810,2'h2}:  //   (r_num_access10 == 2)
           
           begin
              
              smc_data10[31:8] = 24'h0;
              smc_data10[7:0] = write_data10[23:16];
              
           end
         
         {`BSIZ_810,2'h1}:  //  (r_num_access10 == 2)
           
           begin
              
              smc_data10[31:8] = 24'h0;
              smc_data10[7:0]  = write_data10[15:8];
              
           end 
         
         {`BSIZ_810,2'h0}:  //  (r_num_access10 == 0) 
           
           begin
              
              smc_data10[31:8] = 24'h0;
              smc_data10[7:0] = write_data10[7:0];
              
           end 
         
         default:
           
           smc_data10 = 32'h0;
         
       endcase // casex(bus_size_num_access10)
       
       
    end
   
endmodule
