//File30 name   : smc_mac_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : Multiple30 access controller30.
//            : Static30 Memory Controller30.
//            : The Multiple30 Access Control30 Block keeps30 trace30 of the
//            : number30 of accesses required30 to fulfill30 the
//            : requirements30 of the AHB30 transfer30. The data is
//            : registered when multiple reads are required30. The AHB30
//            : holds30 the data during multiple writes.
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

`include "smc_defs_lite30.v"

module smc_mac_lite30     (

                    //inputs30
                    
                    sys_clk30,
                    n_sys_reset30,
                    valid_access30,
                    xfer_size30,
                    smc_done30,
                    data_smc30,
                    write_data30,
                    smc_nextstate30,
                    latch_data30,
                    
                    //outputs30
                    
                    r_num_access30,
                    mac_done30,
                    v_bus_size30,
                    v_xfer_size30,
                    read_data30,
                    smc_data30);
   
   
   
 


// State30 Machine30// I30/O30

  input                sys_clk30;        // System30 clock30
  input                n_sys_reset30;    // System30 reset (Active30 LOW30)
  input                valid_access30;   // Address cycle of new transfer30
  input  [1:0]         xfer_size30;      // xfer30 size, valid with valid_access30
  input                smc_done30;       // End30 of transfer30
  input  [31:0]        data_smc30;       // External30 read data
  input  [31:0]        write_data30;     // Data from internal bus 
  input  [4:0]         smc_nextstate30;  // State30 Machine30  
  input                latch_data30;     //latch_data30 is used by the MAC30 block    
  
  output [1:0]         r_num_access30;   // Access counter
  output               mac_done30;       // End30 of all transfers30
  output [1:0]         v_bus_size30;     // Registered30 sizes30 for subsequent30
  output [1:0]         v_xfer_size30;    // transfers30 in MAC30 transfer30
  output [31:0]        read_data30;      // Data to internal bus
  output [31:0]        smc_data30;       // Data to external30 bus
  

// Output30 register declarations30

  reg                  mac_done30;       // Indicates30 last cycle of last access
  reg [1:0]            r_num_access30;   // Access counter
  reg [1:0]            num_accesses30;   //number30 of access
  reg [1:0]            r_xfer_size30;    // Store30 size for MAC30 
  reg [1:0]            r_bus_size30;     // Store30 size for MAC30
  reg [31:0]           read_data30;      // Data path to bus IF
  reg [31:0]           r_read_data30;    // Internal data store30
  reg [31:0]           smc_data30;


// Internal Signals30

  reg [1:0]            v_bus_size30;
  reg [1:0]            v_xfer_size30;
  wire [4:0]           smc_nextstate30;    //specifies30 next state
  wire [4:0]           xfer_bus_ldata30;  //concatenation30 of xfer_size30
                                         // and latch_data30  
  wire [3:0]           bus_size_num_access30; //concatenation30 of 
                                              // r_num_access30
  wire [5:0]           wt_ldata_naccs_bsiz30;  //concatenation30 of 
                                            //latch_data30,r_num_access30
 
   


// Main30 Code30

//----------------------------------------------------------------------------
// Store30 transfer30 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk30 or negedge n_sys_reset30)
  
    begin
       
       if (~n_sys_reset30)
         
          r_xfer_size30 <= 2'b00;
       
       
       else if (valid_access30)
         
          r_xfer_size30 <= xfer_size30;
       
       else
         
          r_xfer_size30 <= r_xfer_size30;
       
    end

//--------------------------------------------------------------------
// Store30 bus size generation30
//--------------------------------------------------------------------
  
  always @(posedge sys_clk30 or negedge n_sys_reset30)
    
    begin
       
       if (~n_sys_reset30)
         
          r_bus_size30 <= 2'b00;
       
       
       else if (valid_access30)
         
          r_bus_size30 <= 2'b00;
       
       else
         
          r_bus_size30 <= r_bus_size30;
       
    end
   

//--------------------------------------------------------------------
// Validate30 sizes30 generation30
//--------------------------------------------------------------------

  always @(valid_access30 or r_bus_size30 )

    begin
       
       if (valid_access30)
         
          v_bus_size30 = 2'b0;
       
       else
         
          v_bus_size30 = r_bus_size30;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size30 generation30
//----------------------------------------------------------------------------   

  always @(valid_access30 or r_xfer_size30 or xfer_size30)

    begin
       
       if (valid_access30)
         
          v_xfer_size30 = xfer_size30;
       
       else
         
          v_xfer_size30 = r_xfer_size30;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions30
// Determines30 the number30 of accesses required30 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size30)
  
    begin
       
       if ((xfer_size30[1:0] == `XSIZ_1630))
         
          num_accesses30 = 2'h1; // Two30 accesses
       
       else if ( (xfer_size30[1:0] == `XSIZ_3230))
         
          num_accesses30 = 2'h3; // Four30 accesses
       
       else
         
          num_accesses30 = 2'h0; // One30 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep30 track30 of the current access number30
//--------------------------------------------------------------------
   
  always @(posedge sys_clk30 or negedge n_sys_reset30)
  
    begin
       
       if (~n_sys_reset30)
         
          r_num_access30 <= 2'b00;
       
       else if (valid_access30)
         
          r_num_access30 <= num_accesses30;
       
       else if (smc_done30 & (smc_nextstate30 != `SMC_STORE30)  &
                      (smc_nextstate30 != `SMC_IDLE30)   )
         
          r_num_access30 <= r_num_access30 - 2'd1;
       
       else
         
          r_num_access30 <= r_num_access30;
       
    end
   
   

//--------------------------------------------------------------------
// Detect30 last access
//--------------------------------------------------------------------
   
   always @(r_num_access30)
     
     begin
        
        if (r_num_access30 == 2'h0)
          
           mac_done30 = 1'b1;
             
        else
          
           mac_done30 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals30 concatenation30 used in case statement30 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz30 = { 1'b0, latch_data30, r_num_access30,
                                  r_bus_size30};
 
   
//--------------------------------------------------------------------
// Store30 Read Data if required30
//--------------------------------------------------------------------

   always @(posedge sys_clk30 or negedge n_sys_reset30)
     
     begin
        
        if (~n_sys_reset30)
          
           r_read_data30 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz30)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data30 <= r_read_data30;
            
            //    latch_data30
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data30[31:24] <= data_smc30[7:0];
                 r_read_data30[23:0] <= 24'h0;
                 
              end
            
            // r_num_access30 =2, v_bus_size30 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data30[23:16] <= data_smc30[7:0];
                 r_read_data30[31:24] <= r_read_data30[31:24];
                 r_read_data30[15:0] <= 16'h0;
                 
              end
            
            // r_num_access30 =1, v_bus_size30 = `XSIZ_1630
            
            {1'b0,1'b1,2'h1,`XSIZ_1630}:
              
              begin
                 
                 r_read_data30[15:0] <= 16'h0;
                 r_read_data30[31:16] <= data_smc30[15:0];
                 
              end
            
            //  r_num_access30 =1,v_bus_size30 == `XSIZ_830
            
            {1'b0,1'b1,2'h1,`XSIZ_830}:          
              
              begin
                 
                 r_read_data30[15:8] <= data_smc30[7:0];
                 r_read_data30[31:16] <= r_read_data30[31:16];
                 r_read_data30[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access30 = 0, v_bus_size30 == `XSIZ_1630
            
            {1'b0,1'b1,2'h0,`XSIZ_1630}:  // r_num_access30 =0
              
              
              begin
                 
                 r_read_data30[15:0] <= data_smc30[15:0];
                 r_read_data30[31:16] <= r_read_data30[31:16];
                 
              end
            
            //  r_num_access30 = 0, v_bus_size30 == `XSIZ_830 
            
            {1'b0,1'b1,2'h0,`XSIZ_830}:
              
              begin
                 
                 r_read_data30[7:0] <= data_smc30[7:0];
                 r_read_data30[31:8] <= r_read_data30[31:8];
                 
              end
            
            //  r_num_access30 = 0, v_bus_size30 == `XSIZ_3230
            
            {1'b0,1'b1,2'h0,`XSIZ_3230}:
              
               r_read_data30[31:0] <= data_smc30[31:0];                      
            
            default :
              
               r_read_data30 <= r_read_data30;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals30 concatenation30 for case statement30 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata30 = {r_xfer_size30,r_bus_size30,latch_data30};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata30 or data_smc30 or r_read_data30 )
       
     begin
        
        casex(xfer_bus_ldata30)
          
          {`XSIZ_3230,`BSIZ_3230,1'b1} :
            
             read_data30[31:0] = data_smc30[31:0];
          
          {`XSIZ_3230,`BSIZ_1630,1'b1} :
                              
            begin
               
               read_data30[31:16] = r_read_data30[31:16];
               read_data30[15:0]  = data_smc30[15:0];
               
            end
          
          {`XSIZ_3230,`BSIZ_830,1'b1} :
            
            begin
               
               read_data30[31:8] = r_read_data30[31:8];
               read_data30[7:0]  = data_smc30[7:0];
               
            end
          
          {`XSIZ_3230,1'bx,1'bx,1'bx} :
            
            read_data30 = r_read_data30;
          
          {`XSIZ_1630,`BSIZ_1630,1'b1} :
                        
            begin
               
               read_data30[31:16] = data_smc30[15:0];
               read_data30[15:0] = data_smc30[15:0];
               
            end
          
          {`XSIZ_1630,`BSIZ_1630,1'b0} :  
            
            begin
               
               read_data30[31:16] = r_read_data30[15:0];
               read_data30[15:0] = r_read_data30[15:0];
               
            end
          
          {`XSIZ_1630,`BSIZ_3230,1'b1} :  
            
            read_data30 = data_smc30;
          
          {`XSIZ_1630,`BSIZ_830,1'b1} : 
                        
            begin
               
               read_data30[31:24] = r_read_data30[15:8];
               read_data30[23:16] = data_smc30[7:0];
               read_data30[15:8] = r_read_data30[15:8];
               read_data30[7:0] = data_smc30[7:0];
            end
          
          {`XSIZ_1630,`BSIZ_830,1'b0} : 
            
            begin
               
               read_data30[31:16] = r_read_data30[15:0];
               read_data30[15:0] = r_read_data30[15:0];
               
            end
          
          {`XSIZ_1630,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data30[31:16] = r_read_data30[31:16];
               read_data30[15:0] = r_read_data30[15:0];
               
            end
          
          {`XSIZ_830,`BSIZ_1630,1'b1} :
            
            begin
               
               read_data30[31:16] = data_smc30[15:0];
               read_data30[15:0] = data_smc30[15:0];
               
            end
          
          {`XSIZ_830,`BSIZ_1630,1'b0} :
            
            begin
               
               read_data30[31:16] = r_read_data30[15:0];
               read_data30[15:0]  = r_read_data30[15:0];
               
            end
          
          {`XSIZ_830,`BSIZ_3230,1'b1} :   
            
            read_data30 = data_smc30;
          
          {`XSIZ_830,`BSIZ_3230,1'b0} :              
                        
                        read_data30 = r_read_data30;
          
          {`XSIZ_830,`BSIZ_830,1'b1} :   
                                    
            begin
               
               read_data30[31:24] = data_smc30[7:0];
               read_data30[23:16] = data_smc30[7:0];
               read_data30[15:8]  = data_smc30[7:0];
               read_data30[7:0]   = data_smc30[7:0];
               
            end
          
          default:
            
            begin
               
               read_data30[31:24] = r_read_data30[7:0];
               read_data30[23:16] = r_read_data30[7:0];
               read_data30[15:8]  = r_read_data30[7:0];
               read_data30[7:0]   = r_read_data30[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata30)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal30 concatenation30 for use in case statement30
//----------------------------------------------------------------------------
   
   assign bus_size_num_access30 = { r_bus_size30, r_num_access30};
   
//--------------------------------------------------------------------
// Select30 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access30 or write_data30)
  
    begin
       
       casex(bus_size_num_access30)
         
         {`BSIZ_3230,1'bx,1'bx}://    (v_bus_size30 == `BSIZ_3230)
           
           smc_data30 = write_data30;
         
         {`BSIZ_1630,2'h1}:    // r_num_access30 == 1
                      
           begin
              
              smc_data30[31:16] = 16'h0;
              smc_data30[15:0] = write_data30[31:16];
              
           end 
         
         {`BSIZ_1630,1'bx,1'bx}:  // (v_bus_size30 == `BSIZ_1630)  
           
           begin
              
              smc_data30[31:16] = 16'h0;
              smc_data30[15:0]  = write_data30[15:0];
              
           end
         
         {`BSIZ_830,2'h3}:  //  (r_num_access30 == 3)
           
           begin
              
              smc_data30[31:8] = 24'h0;
              smc_data30[7:0] = write_data30[31:24];
           end
         
         {`BSIZ_830,2'h2}:  //   (r_num_access30 == 2)
           
           begin
              
              smc_data30[31:8] = 24'h0;
              smc_data30[7:0] = write_data30[23:16];
              
           end
         
         {`BSIZ_830,2'h1}:  //  (r_num_access30 == 2)
           
           begin
              
              smc_data30[31:8] = 24'h0;
              smc_data30[7:0]  = write_data30[15:8];
              
           end 
         
         {`BSIZ_830,2'h0}:  //  (r_num_access30 == 0) 
           
           begin
              
              smc_data30[31:8] = 24'h0;
              smc_data30[7:0] = write_data30[7:0];
              
           end 
         
         default:
           
           smc_data30 = 32'h0;
         
       endcase // casex(bus_size_num_access30)
       
       
    end
   
endmodule
