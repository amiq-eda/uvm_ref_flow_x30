//File11 name   : smc_mac_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : Multiple11 access controller11.
//            : Static11 Memory Controller11.
//            : The Multiple11 Access Control11 Block keeps11 trace11 of the
//            : number11 of accesses required11 to fulfill11 the
//            : requirements11 of the AHB11 transfer11. The data is
//            : registered when multiple reads are required11. The AHB11
//            : holds11 the data during multiple writes.
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

`include "smc_defs_lite11.v"

module smc_mac_lite11     (

                    //inputs11
                    
                    sys_clk11,
                    n_sys_reset11,
                    valid_access11,
                    xfer_size11,
                    smc_done11,
                    data_smc11,
                    write_data11,
                    smc_nextstate11,
                    latch_data11,
                    
                    //outputs11
                    
                    r_num_access11,
                    mac_done11,
                    v_bus_size11,
                    v_xfer_size11,
                    read_data11,
                    smc_data11);
   
   
   
 


// State11 Machine11// I11/O11

  input                sys_clk11;        // System11 clock11
  input                n_sys_reset11;    // System11 reset (Active11 LOW11)
  input                valid_access11;   // Address cycle of new transfer11
  input  [1:0]         xfer_size11;      // xfer11 size, valid with valid_access11
  input                smc_done11;       // End11 of transfer11
  input  [31:0]        data_smc11;       // External11 read data
  input  [31:0]        write_data11;     // Data from internal bus 
  input  [4:0]         smc_nextstate11;  // State11 Machine11  
  input                latch_data11;     //latch_data11 is used by the MAC11 block    
  
  output [1:0]         r_num_access11;   // Access counter
  output               mac_done11;       // End11 of all transfers11
  output [1:0]         v_bus_size11;     // Registered11 sizes11 for subsequent11
  output [1:0]         v_xfer_size11;    // transfers11 in MAC11 transfer11
  output [31:0]        read_data11;      // Data to internal bus
  output [31:0]        smc_data11;       // Data to external11 bus
  

// Output11 register declarations11

  reg                  mac_done11;       // Indicates11 last cycle of last access
  reg [1:0]            r_num_access11;   // Access counter
  reg [1:0]            num_accesses11;   //number11 of access
  reg [1:0]            r_xfer_size11;    // Store11 size for MAC11 
  reg [1:0]            r_bus_size11;     // Store11 size for MAC11
  reg [31:0]           read_data11;      // Data path to bus IF
  reg [31:0]           r_read_data11;    // Internal data store11
  reg [31:0]           smc_data11;


// Internal Signals11

  reg [1:0]            v_bus_size11;
  reg [1:0]            v_xfer_size11;
  wire [4:0]           smc_nextstate11;    //specifies11 next state
  wire [4:0]           xfer_bus_ldata11;  //concatenation11 of xfer_size11
                                         // and latch_data11  
  wire [3:0]           bus_size_num_access11; //concatenation11 of 
                                              // r_num_access11
  wire [5:0]           wt_ldata_naccs_bsiz11;  //concatenation11 of 
                                            //latch_data11,r_num_access11
 
   


// Main11 Code11

//----------------------------------------------------------------------------
// Store11 transfer11 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk11 or negedge n_sys_reset11)
  
    begin
       
       if (~n_sys_reset11)
         
          r_xfer_size11 <= 2'b00;
       
       
       else if (valid_access11)
         
          r_xfer_size11 <= xfer_size11;
       
       else
         
          r_xfer_size11 <= r_xfer_size11;
       
    end

//--------------------------------------------------------------------
// Store11 bus size generation11
//--------------------------------------------------------------------
  
  always @(posedge sys_clk11 or negedge n_sys_reset11)
    
    begin
       
       if (~n_sys_reset11)
         
          r_bus_size11 <= 2'b00;
       
       
       else if (valid_access11)
         
          r_bus_size11 <= 2'b00;
       
       else
         
          r_bus_size11 <= r_bus_size11;
       
    end
   

//--------------------------------------------------------------------
// Validate11 sizes11 generation11
//--------------------------------------------------------------------

  always @(valid_access11 or r_bus_size11 )

    begin
       
       if (valid_access11)
         
          v_bus_size11 = 2'b0;
       
       else
         
          v_bus_size11 = r_bus_size11;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size11 generation11
//----------------------------------------------------------------------------   

  always @(valid_access11 or r_xfer_size11 or xfer_size11)

    begin
       
       if (valid_access11)
         
          v_xfer_size11 = xfer_size11;
       
       else
         
          v_xfer_size11 = r_xfer_size11;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions11
// Determines11 the number11 of accesses required11 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size11)
  
    begin
       
       if ((xfer_size11[1:0] == `XSIZ_1611))
         
          num_accesses11 = 2'h1; // Two11 accesses
       
       else if ( (xfer_size11[1:0] == `XSIZ_3211))
         
          num_accesses11 = 2'h3; // Four11 accesses
       
       else
         
          num_accesses11 = 2'h0; // One11 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep11 track11 of the current access number11
//--------------------------------------------------------------------
   
  always @(posedge sys_clk11 or negedge n_sys_reset11)
  
    begin
       
       if (~n_sys_reset11)
         
          r_num_access11 <= 2'b00;
       
       else if (valid_access11)
         
          r_num_access11 <= num_accesses11;
       
       else if (smc_done11 & (smc_nextstate11 != `SMC_STORE11)  &
                      (smc_nextstate11 != `SMC_IDLE11)   )
         
          r_num_access11 <= r_num_access11 - 2'd1;
       
       else
         
          r_num_access11 <= r_num_access11;
       
    end
   
   

//--------------------------------------------------------------------
// Detect11 last access
//--------------------------------------------------------------------
   
   always @(r_num_access11)
     
     begin
        
        if (r_num_access11 == 2'h0)
          
           mac_done11 = 1'b1;
             
        else
          
           mac_done11 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals11 concatenation11 used in case statement11 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz11 = { 1'b0, latch_data11, r_num_access11,
                                  r_bus_size11};
 
   
//--------------------------------------------------------------------
// Store11 Read Data if required11
//--------------------------------------------------------------------

   always @(posedge sys_clk11 or negedge n_sys_reset11)
     
     begin
        
        if (~n_sys_reset11)
          
           r_read_data11 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz11)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data11 <= r_read_data11;
            
            //    latch_data11
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data11[31:24] <= data_smc11[7:0];
                 r_read_data11[23:0] <= 24'h0;
                 
              end
            
            // r_num_access11 =2, v_bus_size11 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data11[23:16] <= data_smc11[7:0];
                 r_read_data11[31:24] <= r_read_data11[31:24];
                 r_read_data11[15:0] <= 16'h0;
                 
              end
            
            // r_num_access11 =1, v_bus_size11 = `XSIZ_1611
            
            {1'b0,1'b1,2'h1,`XSIZ_1611}:
              
              begin
                 
                 r_read_data11[15:0] <= 16'h0;
                 r_read_data11[31:16] <= data_smc11[15:0];
                 
              end
            
            //  r_num_access11 =1,v_bus_size11 == `XSIZ_811
            
            {1'b0,1'b1,2'h1,`XSIZ_811}:          
              
              begin
                 
                 r_read_data11[15:8] <= data_smc11[7:0];
                 r_read_data11[31:16] <= r_read_data11[31:16];
                 r_read_data11[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access11 = 0, v_bus_size11 == `XSIZ_1611
            
            {1'b0,1'b1,2'h0,`XSIZ_1611}:  // r_num_access11 =0
              
              
              begin
                 
                 r_read_data11[15:0] <= data_smc11[15:0];
                 r_read_data11[31:16] <= r_read_data11[31:16];
                 
              end
            
            //  r_num_access11 = 0, v_bus_size11 == `XSIZ_811 
            
            {1'b0,1'b1,2'h0,`XSIZ_811}:
              
              begin
                 
                 r_read_data11[7:0] <= data_smc11[7:0];
                 r_read_data11[31:8] <= r_read_data11[31:8];
                 
              end
            
            //  r_num_access11 = 0, v_bus_size11 == `XSIZ_3211
            
            {1'b0,1'b1,2'h0,`XSIZ_3211}:
              
               r_read_data11[31:0] <= data_smc11[31:0];                      
            
            default :
              
               r_read_data11 <= r_read_data11;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals11 concatenation11 for case statement11 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata11 = {r_xfer_size11,r_bus_size11,latch_data11};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata11 or data_smc11 or r_read_data11 )
       
     begin
        
        casex(xfer_bus_ldata11)
          
          {`XSIZ_3211,`BSIZ_3211,1'b1} :
            
             read_data11[31:0] = data_smc11[31:0];
          
          {`XSIZ_3211,`BSIZ_1611,1'b1} :
                              
            begin
               
               read_data11[31:16] = r_read_data11[31:16];
               read_data11[15:0]  = data_smc11[15:0];
               
            end
          
          {`XSIZ_3211,`BSIZ_811,1'b1} :
            
            begin
               
               read_data11[31:8] = r_read_data11[31:8];
               read_data11[7:0]  = data_smc11[7:0];
               
            end
          
          {`XSIZ_3211,1'bx,1'bx,1'bx} :
            
            read_data11 = r_read_data11;
          
          {`XSIZ_1611,`BSIZ_1611,1'b1} :
                        
            begin
               
               read_data11[31:16] = data_smc11[15:0];
               read_data11[15:0] = data_smc11[15:0];
               
            end
          
          {`XSIZ_1611,`BSIZ_1611,1'b0} :  
            
            begin
               
               read_data11[31:16] = r_read_data11[15:0];
               read_data11[15:0] = r_read_data11[15:0];
               
            end
          
          {`XSIZ_1611,`BSIZ_3211,1'b1} :  
            
            read_data11 = data_smc11;
          
          {`XSIZ_1611,`BSIZ_811,1'b1} : 
                        
            begin
               
               read_data11[31:24] = r_read_data11[15:8];
               read_data11[23:16] = data_smc11[7:0];
               read_data11[15:8] = r_read_data11[15:8];
               read_data11[7:0] = data_smc11[7:0];
            end
          
          {`XSIZ_1611,`BSIZ_811,1'b0} : 
            
            begin
               
               read_data11[31:16] = r_read_data11[15:0];
               read_data11[15:0] = r_read_data11[15:0];
               
            end
          
          {`XSIZ_1611,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data11[31:16] = r_read_data11[31:16];
               read_data11[15:0] = r_read_data11[15:0];
               
            end
          
          {`XSIZ_811,`BSIZ_1611,1'b1} :
            
            begin
               
               read_data11[31:16] = data_smc11[15:0];
               read_data11[15:0] = data_smc11[15:0];
               
            end
          
          {`XSIZ_811,`BSIZ_1611,1'b0} :
            
            begin
               
               read_data11[31:16] = r_read_data11[15:0];
               read_data11[15:0]  = r_read_data11[15:0];
               
            end
          
          {`XSIZ_811,`BSIZ_3211,1'b1} :   
            
            read_data11 = data_smc11;
          
          {`XSIZ_811,`BSIZ_3211,1'b0} :              
                        
                        read_data11 = r_read_data11;
          
          {`XSIZ_811,`BSIZ_811,1'b1} :   
                                    
            begin
               
               read_data11[31:24] = data_smc11[7:0];
               read_data11[23:16] = data_smc11[7:0];
               read_data11[15:8]  = data_smc11[7:0];
               read_data11[7:0]   = data_smc11[7:0];
               
            end
          
          default:
            
            begin
               
               read_data11[31:24] = r_read_data11[7:0];
               read_data11[23:16] = r_read_data11[7:0];
               read_data11[15:8]  = r_read_data11[7:0];
               read_data11[7:0]   = r_read_data11[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata11)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal11 concatenation11 for use in case statement11
//----------------------------------------------------------------------------
   
   assign bus_size_num_access11 = { r_bus_size11, r_num_access11};
   
//--------------------------------------------------------------------
// Select11 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access11 or write_data11)
  
    begin
       
       casex(bus_size_num_access11)
         
         {`BSIZ_3211,1'bx,1'bx}://    (v_bus_size11 == `BSIZ_3211)
           
           smc_data11 = write_data11;
         
         {`BSIZ_1611,2'h1}:    // r_num_access11 == 1
                      
           begin
              
              smc_data11[31:16] = 16'h0;
              smc_data11[15:0] = write_data11[31:16];
              
           end 
         
         {`BSIZ_1611,1'bx,1'bx}:  // (v_bus_size11 == `BSIZ_1611)  
           
           begin
              
              smc_data11[31:16] = 16'h0;
              smc_data11[15:0]  = write_data11[15:0];
              
           end
         
         {`BSIZ_811,2'h3}:  //  (r_num_access11 == 3)
           
           begin
              
              smc_data11[31:8] = 24'h0;
              smc_data11[7:0] = write_data11[31:24];
           end
         
         {`BSIZ_811,2'h2}:  //   (r_num_access11 == 2)
           
           begin
              
              smc_data11[31:8] = 24'h0;
              smc_data11[7:0] = write_data11[23:16];
              
           end
         
         {`BSIZ_811,2'h1}:  //  (r_num_access11 == 2)
           
           begin
              
              smc_data11[31:8] = 24'h0;
              smc_data11[7:0]  = write_data11[15:8];
              
           end 
         
         {`BSIZ_811,2'h0}:  //  (r_num_access11 == 0) 
           
           begin
              
              smc_data11[31:8] = 24'h0;
              smc_data11[7:0] = write_data11[7:0];
              
           end 
         
         default:
           
           smc_data11 = 32'h0;
         
       endcase // casex(bus_size_num_access11)
       
       
    end
   
endmodule
