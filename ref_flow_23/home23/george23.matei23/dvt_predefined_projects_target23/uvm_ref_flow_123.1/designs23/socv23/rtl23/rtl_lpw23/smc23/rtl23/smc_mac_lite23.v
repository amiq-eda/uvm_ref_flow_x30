//File23 name   : smc_mac_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : Multiple23 access controller23.
//            : Static23 Memory Controller23.
//            : The Multiple23 Access Control23 Block keeps23 trace23 of the
//            : number23 of accesses required23 to fulfill23 the
//            : requirements23 of the AHB23 transfer23. The data is
//            : registered when multiple reads are required23. The AHB23
//            : holds23 the data during multiple writes.
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

`include "smc_defs_lite23.v"

module smc_mac_lite23     (

                    //inputs23
                    
                    sys_clk23,
                    n_sys_reset23,
                    valid_access23,
                    xfer_size23,
                    smc_done23,
                    data_smc23,
                    write_data23,
                    smc_nextstate23,
                    latch_data23,
                    
                    //outputs23
                    
                    r_num_access23,
                    mac_done23,
                    v_bus_size23,
                    v_xfer_size23,
                    read_data23,
                    smc_data23);
   
   
   
 


// State23 Machine23// I23/O23

  input                sys_clk23;        // System23 clock23
  input                n_sys_reset23;    // System23 reset (Active23 LOW23)
  input                valid_access23;   // Address cycle of new transfer23
  input  [1:0]         xfer_size23;      // xfer23 size, valid with valid_access23
  input                smc_done23;       // End23 of transfer23
  input  [31:0]        data_smc23;       // External23 read data
  input  [31:0]        write_data23;     // Data from internal bus 
  input  [4:0]         smc_nextstate23;  // State23 Machine23  
  input                latch_data23;     //latch_data23 is used by the MAC23 block    
  
  output [1:0]         r_num_access23;   // Access counter
  output               mac_done23;       // End23 of all transfers23
  output [1:0]         v_bus_size23;     // Registered23 sizes23 for subsequent23
  output [1:0]         v_xfer_size23;    // transfers23 in MAC23 transfer23
  output [31:0]        read_data23;      // Data to internal bus
  output [31:0]        smc_data23;       // Data to external23 bus
  

// Output23 register declarations23

  reg                  mac_done23;       // Indicates23 last cycle of last access
  reg [1:0]            r_num_access23;   // Access counter
  reg [1:0]            num_accesses23;   //number23 of access
  reg [1:0]            r_xfer_size23;    // Store23 size for MAC23 
  reg [1:0]            r_bus_size23;     // Store23 size for MAC23
  reg [31:0]           read_data23;      // Data path to bus IF
  reg [31:0]           r_read_data23;    // Internal data store23
  reg [31:0]           smc_data23;


// Internal Signals23

  reg [1:0]            v_bus_size23;
  reg [1:0]            v_xfer_size23;
  wire [4:0]           smc_nextstate23;    //specifies23 next state
  wire [4:0]           xfer_bus_ldata23;  //concatenation23 of xfer_size23
                                         // and latch_data23  
  wire [3:0]           bus_size_num_access23; //concatenation23 of 
                                              // r_num_access23
  wire [5:0]           wt_ldata_naccs_bsiz23;  //concatenation23 of 
                                            //latch_data23,r_num_access23
 
   


// Main23 Code23

//----------------------------------------------------------------------------
// Store23 transfer23 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk23 or negedge n_sys_reset23)
  
    begin
       
       if (~n_sys_reset23)
         
          r_xfer_size23 <= 2'b00;
       
       
       else if (valid_access23)
         
          r_xfer_size23 <= xfer_size23;
       
       else
         
          r_xfer_size23 <= r_xfer_size23;
       
    end

//--------------------------------------------------------------------
// Store23 bus size generation23
//--------------------------------------------------------------------
  
  always @(posedge sys_clk23 or negedge n_sys_reset23)
    
    begin
       
       if (~n_sys_reset23)
         
          r_bus_size23 <= 2'b00;
       
       
       else if (valid_access23)
         
          r_bus_size23 <= 2'b00;
       
       else
         
          r_bus_size23 <= r_bus_size23;
       
    end
   

//--------------------------------------------------------------------
// Validate23 sizes23 generation23
//--------------------------------------------------------------------

  always @(valid_access23 or r_bus_size23 )

    begin
       
       if (valid_access23)
         
          v_bus_size23 = 2'b0;
       
       else
         
          v_bus_size23 = r_bus_size23;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size23 generation23
//----------------------------------------------------------------------------   

  always @(valid_access23 or r_xfer_size23 or xfer_size23)

    begin
       
       if (valid_access23)
         
          v_xfer_size23 = xfer_size23;
       
       else
         
          v_xfer_size23 = r_xfer_size23;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions23
// Determines23 the number23 of accesses required23 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size23)
  
    begin
       
       if ((xfer_size23[1:0] == `XSIZ_1623))
         
          num_accesses23 = 2'h1; // Two23 accesses
       
       else if ( (xfer_size23[1:0] == `XSIZ_3223))
         
          num_accesses23 = 2'h3; // Four23 accesses
       
       else
         
          num_accesses23 = 2'h0; // One23 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep23 track23 of the current access number23
//--------------------------------------------------------------------
   
  always @(posedge sys_clk23 or negedge n_sys_reset23)
  
    begin
       
       if (~n_sys_reset23)
         
          r_num_access23 <= 2'b00;
       
       else if (valid_access23)
         
          r_num_access23 <= num_accesses23;
       
       else if (smc_done23 & (smc_nextstate23 != `SMC_STORE23)  &
                      (smc_nextstate23 != `SMC_IDLE23)   )
         
          r_num_access23 <= r_num_access23 - 2'd1;
       
       else
         
          r_num_access23 <= r_num_access23;
       
    end
   
   

//--------------------------------------------------------------------
// Detect23 last access
//--------------------------------------------------------------------
   
   always @(r_num_access23)
     
     begin
        
        if (r_num_access23 == 2'h0)
          
           mac_done23 = 1'b1;
             
        else
          
           mac_done23 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals23 concatenation23 used in case statement23 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz23 = { 1'b0, latch_data23, r_num_access23,
                                  r_bus_size23};
 
   
//--------------------------------------------------------------------
// Store23 Read Data if required23
//--------------------------------------------------------------------

   always @(posedge sys_clk23 or negedge n_sys_reset23)
     
     begin
        
        if (~n_sys_reset23)
          
           r_read_data23 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz23)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data23 <= r_read_data23;
            
            //    latch_data23
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data23[31:24] <= data_smc23[7:0];
                 r_read_data23[23:0] <= 24'h0;
                 
              end
            
            // r_num_access23 =2, v_bus_size23 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data23[23:16] <= data_smc23[7:0];
                 r_read_data23[31:24] <= r_read_data23[31:24];
                 r_read_data23[15:0] <= 16'h0;
                 
              end
            
            // r_num_access23 =1, v_bus_size23 = `XSIZ_1623
            
            {1'b0,1'b1,2'h1,`XSIZ_1623}:
              
              begin
                 
                 r_read_data23[15:0] <= 16'h0;
                 r_read_data23[31:16] <= data_smc23[15:0];
                 
              end
            
            //  r_num_access23 =1,v_bus_size23 == `XSIZ_823
            
            {1'b0,1'b1,2'h1,`XSIZ_823}:          
              
              begin
                 
                 r_read_data23[15:8] <= data_smc23[7:0];
                 r_read_data23[31:16] <= r_read_data23[31:16];
                 r_read_data23[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access23 = 0, v_bus_size23 == `XSIZ_1623
            
            {1'b0,1'b1,2'h0,`XSIZ_1623}:  // r_num_access23 =0
              
              
              begin
                 
                 r_read_data23[15:0] <= data_smc23[15:0];
                 r_read_data23[31:16] <= r_read_data23[31:16];
                 
              end
            
            //  r_num_access23 = 0, v_bus_size23 == `XSIZ_823 
            
            {1'b0,1'b1,2'h0,`XSIZ_823}:
              
              begin
                 
                 r_read_data23[7:0] <= data_smc23[7:0];
                 r_read_data23[31:8] <= r_read_data23[31:8];
                 
              end
            
            //  r_num_access23 = 0, v_bus_size23 == `XSIZ_3223
            
            {1'b0,1'b1,2'h0,`XSIZ_3223}:
              
               r_read_data23[31:0] <= data_smc23[31:0];                      
            
            default :
              
               r_read_data23 <= r_read_data23;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals23 concatenation23 for case statement23 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata23 = {r_xfer_size23,r_bus_size23,latch_data23};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata23 or data_smc23 or r_read_data23 )
       
     begin
        
        casex(xfer_bus_ldata23)
          
          {`XSIZ_3223,`BSIZ_3223,1'b1} :
            
             read_data23[31:0] = data_smc23[31:0];
          
          {`XSIZ_3223,`BSIZ_1623,1'b1} :
                              
            begin
               
               read_data23[31:16] = r_read_data23[31:16];
               read_data23[15:0]  = data_smc23[15:0];
               
            end
          
          {`XSIZ_3223,`BSIZ_823,1'b1} :
            
            begin
               
               read_data23[31:8] = r_read_data23[31:8];
               read_data23[7:0]  = data_smc23[7:0];
               
            end
          
          {`XSIZ_3223,1'bx,1'bx,1'bx} :
            
            read_data23 = r_read_data23;
          
          {`XSIZ_1623,`BSIZ_1623,1'b1} :
                        
            begin
               
               read_data23[31:16] = data_smc23[15:0];
               read_data23[15:0] = data_smc23[15:0];
               
            end
          
          {`XSIZ_1623,`BSIZ_1623,1'b0} :  
            
            begin
               
               read_data23[31:16] = r_read_data23[15:0];
               read_data23[15:0] = r_read_data23[15:0];
               
            end
          
          {`XSIZ_1623,`BSIZ_3223,1'b1} :  
            
            read_data23 = data_smc23;
          
          {`XSIZ_1623,`BSIZ_823,1'b1} : 
                        
            begin
               
               read_data23[31:24] = r_read_data23[15:8];
               read_data23[23:16] = data_smc23[7:0];
               read_data23[15:8] = r_read_data23[15:8];
               read_data23[7:0] = data_smc23[7:0];
            end
          
          {`XSIZ_1623,`BSIZ_823,1'b0} : 
            
            begin
               
               read_data23[31:16] = r_read_data23[15:0];
               read_data23[15:0] = r_read_data23[15:0];
               
            end
          
          {`XSIZ_1623,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data23[31:16] = r_read_data23[31:16];
               read_data23[15:0] = r_read_data23[15:0];
               
            end
          
          {`XSIZ_823,`BSIZ_1623,1'b1} :
            
            begin
               
               read_data23[31:16] = data_smc23[15:0];
               read_data23[15:0] = data_smc23[15:0];
               
            end
          
          {`XSIZ_823,`BSIZ_1623,1'b0} :
            
            begin
               
               read_data23[31:16] = r_read_data23[15:0];
               read_data23[15:0]  = r_read_data23[15:0];
               
            end
          
          {`XSIZ_823,`BSIZ_3223,1'b1} :   
            
            read_data23 = data_smc23;
          
          {`XSIZ_823,`BSIZ_3223,1'b0} :              
                        
                        read_data23 = r_read_data23;
          
          {`XSIZ_823,`BSIZ_823,1'b1} :   
                                    
            begin
               
               read_data23[31:24] = data_smc23[7:0];
               read_data23[23:16] = data_smc23[7:0];
               read_data23[15:8]  = data_smc23[7:0];
               read_data23[7:0]   = data_smc23[7:0];
               
            end
          
          default:
            
            begin
               
               read_data23[31:24] = r_read_data23[7:0];
               read_data23[23:16] = r_read_data23[7:0];
               read_data23[15:8]  = r_read_data23[7:0];
               read_data23[7:0]   = r_read_data23[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata23)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal23 concatenation23 for use in case statement23
//----------------------------------------------------------------------------
   
   assign bus_size_num_access23 = { r_bus_size23, r_num_access23};
   
//--------------------------------------------------------------------
// Select23 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access23 or write_data23)
  
    begin
       
       casex(bus_size_num_access23)
         
         {`BSIZ_3223,1'bx,1'bx}://    (v_bus_size23 == `BSIZ_3223)
           
           smc_data23 = write_data23;
         
         {`BSIZ_1623,2'h1}:    // r_num_access23 == 1
                      
           begin
              
              smc_data23[31:16] = 16'h0;
              smc_data23[15:0] = write_data23[31:16];
              
           end 
         
         {`BSIZ_1623,1'bx,1'bx}:  // (v_bus_size23 == `BSIZ_1623)  
           
           begin
              
              smc_data23[31:16] = 16'h0;
              smc_data23[15:0]  = write_data23[15:0];
              
           end
         
         {`BSIZ_823,2'h3}:  //  (r_num_access23 == 3)
           
           begin
              
              smc_data23[31:8] = 24'h0;
              smc_data23[7:0] = write_data23[31:24];
           end
         
         {`BSIZ_823,2'h2}:  //   (r_num_access23 == 2)
           
           begin
              
              smc_data23[31:8] = 24'h0;
              smc_data23[7:0] = write_data23[23:16];
              
           end
         
         {`BSIZ_823,2'h1}:  //  (r_num_access23 == 2)
           
           begin
              
              smc_data23[31:8] = 24'h0;
              smc_data23[7:0]  = write_data23[15:8];
              
           end 
         
         {`BSIZ_823,2'h0}:  //  (r_num_access23 == 0) 
           
           begin
              
              smc_data23[31:8] = 24'h0;
              smc_data23[7:0] = write_data23[7:0];
              
           end 
         
         default:
           
           smc_data23 = 32'h0;
         
       endcase // casex(bus_size_num_access23)
       
       
    end
   
endmodule
