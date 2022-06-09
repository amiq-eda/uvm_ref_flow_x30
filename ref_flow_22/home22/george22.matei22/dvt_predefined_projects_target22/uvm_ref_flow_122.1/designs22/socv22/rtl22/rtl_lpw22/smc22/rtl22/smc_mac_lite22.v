//File22 name   : smc_mac_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : Multiple22 access controller22.
//            : Static22 Memory Controller22.
//            : The Multiple22 Access Control22 Block keeps22 trace22 of the
//            : number22 of accesses required22 to fulfill22 the
//            : requirements22 of the AHB22 transfer22. The data is
//            : registered when multiple reads are required22. The AHB22
//            : holds22 the data during multiple writes.
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

`include "smc_defs_lite22.v"

module smc_mac_lite22     (

                    //inputs22
                    
                    sys_clk22,
                    n_sys_reset22,
                    valid_access22,
                    xfer_size22,
                    smc_done22,
                    data_smc22,
                    write_data22,
                    smc_nextstate22,
                    latch_data22,
                    
                    //outputs22
                    
                    r_num_access22,
                    mac_done22,
                    v_bus_size22,
                    v_xfer_size22,
                    read_data22,
                    smc_data22);
   
   
   
 


// State22 Machine22// I22/O22

  input                sys_clk22;        // System22 clock22
  input                n_sys_reset22;    // System22 reset (Active22 LOW22)
  input                valid_access22;   // Address cycle of new transfer22
  input  [1:0]         xfer_size22;      // xfer22 size, valid with valid_access22
  input                smc_done22;       // End22 of transfer22
  input  [31:0]        data_smc22;       // External22 read data
  input  [31:0]        write_data22;     // Data from internal bus 
  input  [4:0]         smc_nextstate22;  // State22 Machine22  
  input                latch_data22;     //latch_data22 is used by the MAC22 block    
  
  output [1:0]         r_num_access22;   // Access counter
  output               mac_done22;       // End22 of all transfers22
  output [1:0]         v_bus_size22;     // Registered22 sizes22 for subsequent22
  output [1:0]         v_xfer_size22;    // transfers22 in MAC22 transfer22
  output [31:0]        read_data22;      // Data to internal bus
  output [31:0]        smc_data22;       // Data to external22 bus
  

// Output22 register declarations22

  reg                  mac_done22;       // Indicates22 last cycle of last access
  reg [1:0]            r_num_access22;   // Access counter
  reg [1:0]            num_accesses22;   //number22 of access
  reg [1:0]            r_xfer_size22;    // Store22 size for MAC22 
  reg [1:0]            r_bus_size22;     // Store22 size for MAC22
  reg [31:0]           read_data22;      // Data path to bus IF
  reg [31:0]           r_read_data22;    // Internal data store22
  reg [31:0]           smc_data22;


// Internal Signals22

  reg [1:0]            v_bus_size22;
  reg [1:0]            v_xfer_size22;
  wire [4:0]           smc_nextstate22;    //specifies22 next state
  wire [4:0]           xfer_bus_ldata22;  //concatenation22 of xfer_size22
                                         // and latch_data22  
  wire [3:0]           bus_size_num_access22; //concatenation22 of 
                                              // r_num_access22
  wire [5:0]           wt_ldata_naccs_bsiz22;  //concatenation22 of 
                                            //latch_data22,r_num_access22
 
   


// Main22 Code22

//----------------------------------------------------------------------------
// Store22 transfer22 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk22 or negedge n_sys_reset22)
  
    begin
       
       if (~n_sys_reset22)
         
          r_xfer_size22 <= 2'b00;
       
       
       else if (valid_access22)
         
          r_xfer_size22 <= xfer_size22;
       
       else
         
          r_xfer_size22 <= r_xfer_size22;
       
    end

//--------------------------------------------------------------------
// Store22 bus size generation22
//--------------------------------------------------------------------
  
  always @(posedge sys_clk22 or negedge n_sys_reset22)
    
    begin
       
       if (~n_sys_reset22)
         
          r_bus_size22 <= 2'b00;
       
       
       else if (valid_access22)
         
          r_bus_size22 <= 2'b00;
       
       else
         
          r_bus_size22 <= r_bus_size22;
       
    end
   

//--------------------------------------------------------------------
// Validate22 sizes22 generation22
//--------------------------------------------------------------------

  always @(valid_access22 or r_bus_size22 )

    begin
       
       if (valid_access22)
         
          v_bus_size22 = 2'b0;
       
       else
         
          v_bus_size22 = r_bus_size22;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size22 generation22
//----------------------------------------------------------------------------   

  always @(valid_access22 or r_xfer_size22 or xfer_size22)

    begin
       
       if (valid_access22)
         
          v_xfer_size22 = xfer_size22;
       
       else
         
          v_xfer_size22 = r_xfer_size22;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions22
// Determines22 the number22 of accesses required22 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size22)
  
    begin
       
       if ((xfer_size22[1:0] == `XSIZ_1622))
         
          num_accesses22 = 2'h1; // Two22 accesses
       
       else if ( (xfer_size22[1:0] == `XSIZ_3222))
         
          num_accesses22 = 2'h3; // Four22 accesses
       
       else
         
          num_accesses22 = 2'h0; // One22 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep22 track22 of the current access number22
//--------------------------------------------------------------------
   
  always @(posedge sys_clk22 or negedge n_sys_reset22)
  
    begin
       
       if (~n_sys_reset22)
         
          r_num_access22 <= 2'b00;
       
       else if (valid_access22)
         
          r_num_access22 <= num_accesses22;
       
       else if (smc_done22 & (smc_nextstate22 != `SMC_STORE22)  &
                      (smc_nextstate22 != `SMC_IDLE22)   )
         
          r_num_access22 <= r_num_access22 - 2'd1;
       
       else
         
          r_num_access22 <= r_num_access22;
       
    end
   
   

//--------------------------------------------------------------------
// Detect22 last access
//--------------------------------------------------------------------
   
   always @(r_num_access22)
     
     begin
        
        if (r_num_access22 == 2'h0)
          
           mac_done22 = 1'b1;
             
        else
          
           mac_done22 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals22 concatenation22 used in case statement22 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz22 = { 1'b0, latch_data22, r_num_access22,
                                  r_bus_size22};
 
   
//--------------------------------------------------------------------
// Store22 Read Data if required22
//--------------------------------------------------------------------

   always @(posedge sys_clk22 or negedge n_sys_reset22)
     
     begin
        
        if (~n_sys_reset22)
          
           r_read_data22 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz22)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data22 <= r_read_data22;
            
            //    latch_data22
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data22[31:24] <= data_smc22[7:0];
                 r_read_data22[23:0] <= 24'h0;
                 
              end
            
            // r_num_access22 =2, v_bus_size22 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data22[23:16] <= data_smc22[7:0];
                 r_read_data22[31:24] <= r_read_data22[31:24];
                 r_read_data22[15:0] <= 16'h0;
                 
              end
            
            // r_num_access22 =1, v_bus_size22 = `XSIZ_1622
            
            {1'b0,1'b1,2'h1,`XSIZ_1622}:
              
              begin
                 
                 r_read_data22[15:0] <= 16'h0;
                 r_read_data22[31:16] <= data_smc22[15:0];
                 
              end
            
            //  r_num_access22 =1,v_bus_size22 == `XSIZ_822
            
            {1'b0,1'b1,2'h1,`XSIZ_822}:          
              
              begin
                 
                 r_read_data22[15:8] <= data_smc22[7:0];
                 r_read_data22[31:16] <= r_read_data22[31:16];
                 r_read_data22[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access22 = 0, v_bus_size22 == `XSIZ_1622
            
            {1'b0,1'b1,2'h0,`XSIZ_1622}:  // r_num_access22 =0
              
              
              begin
                 
                 r_read_data22[15:0] <= data_smc22[15:0];
                 r_read_data22[31:16] <= r_read_data22[31:16];
                 
              end
            
            //  r_num_access22 = 0, v_bus_size22 == `XSIZ_822 
            
            {1'b0,1'b1,2'h0,`XSIZ_822}:
              
              begin
                 
                 r_read_data22[7:0] <= data_smc22[7:0];
                 r_read_data22[31:8] <= r_read_data22[31:8];
                 
              end
            
            //  r_num_access22 = 0, v_bus_size22 == `XSIZ_3222
            
            {1'b0,1'b1,2'h0,`XSIZ_3222}:
              
               r_read_data22[31:0] <= data_smc22[31:0];                      
            
            default :
              
               r_read_data22 <= r_read_data22;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals22 concatenation22 for case statement22 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata22 = {r_xfer_size22,r_bus_size22,latch_data22};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata22 or data_smc22 or r_read_data22 )
       
     begin
        
        casex(xfer_bus_ldata22)
          
          {`XSIZ_3222,`BSIZ_3222,1'b1} :
            
             read_data22[31:0] = data_smc22[31:0];
          
          {`XSIZ_3222,`BSIZ_1622,1'b1} :
                              
            begin
               
               read_data22[31:16] = r_read_data22[31:16];
               read_data22[15:0]  = data_smc22[15:0];
               
            end
          
          {`XSIZ_3222,`BSIZ_822,1'b1} :
            
            begin
               
               read_data22[31:8] = r_read_data22[31:8];
               read_data22[7:0]  = data_smc22[7:0];
               
            end
          
          {`XSIZ_3222,1'bx,1'bx,1'bx} :
            
            read_data22 = r_read_data22;
          
          {`XSIZ_1622,`BSIZ_1622,1'b1} :
                        
            begin
               
               read_data22[31:16] = data_smc22[15:0];
               read_data22[15:0] = data_smc22[15:0];
               
            end
          
          {`XSIZ_1622,`BSIZ_1622,1'b0} :  
            
            begin
               
               read_data22[31:16] = r_read_data22[15:0];
               read_data22[15:0] = r_read_data22[15:0];
               
            end
          
          {`XSIZ_1622,`BSIZ_3222,1'b1} :  
            
            read_data22 = data_smc22;
          
          {`XSIZ_1622,`BSIZ_822,1'b1} : 
                        
            begin
               
               read_data22[31:24] = r_read_data22[15:8];
               read_data22[23:16] = data_smc22[7:0];
               read_data22[15:8] = r_read_data22[15:8];
               read_data22[7:0] = data_smc22[7:0];
            end
          
          {`XSIZ_1622,`BSIZ_822,1'b0} : 
            
            begin
               
               read_data22[31:16] = r_read_data22[15:0];
               read_data22[15:0] = r_read_data22[15:0];
               
            end
          
          {`XSIZ_1622,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data22[31:16] = r_read_data22[31:16];
               read_data22[15:0] = r_read_data22[15:0];
               
            end
          
          {`XSIZ_822,`BSIZ_1622,1'b1} :
            
            begin
               
               read_data22[31:16] = data_smc22[15:0];
               read_data22[15:0] = data_smc22[15:0];
               
            end
          
          {`XSIZ_822,`BSIZ_1622,1'b0} :
            
            begin
               
               read_data22[31:16] = r_read_data22[15:0];
               read_data22[15:0]  = r_read_data22[15:0];
               
            end
          
          {`XSIZ_822,`BSIZ_3222,1'b1} :   
            
            read_data22 = data_smc22;
          
          {`XSIZ_822,`BSIZ_3222,1'b0} :              
                        
                        read_data22 = r_read_data22;
          
          {`XSIZ_822,`BSIZ_822,1'b1} :   
                                    
            begin
               
               read_data22[31:24] = data_smc22[7:0];
               read_data22[23:16] = data_smc22[7:0];
               read_data22[15:8]  = data_smc22[7:0];
               read_data22[7:0]   = data_smc22[7:0];
               
            end
          
          default:
            
            begin
               
               read_data22[31:24] = r_read_data22[7:0];
               read_data22[23:16] = r_read_data22[7:0];
               read_data22[15:8]  = r_read_data22[7:0];
               read_data22[7:0]   = r_read_data22[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata22)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal22 concatenation22 for use in case statement22
//----------------------------------------------------------------------------
   
   assign bus_size_num_access22 = { r_bus_size22, r_num_access22};
   
//--------------------------------------------------------------------
// Select22 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access22 or write_data22)
  
    begin
       
       casex(bus_size_num_access22)
         
         {`BSIZ_3222,1'bx,1'bx}://    (v_bus_size22 == `BSIZ_3222)
           
           smc_data22 = write_data22;
         
         {`BSIZ_1622,2'h1}:    // r_num_access22 == 1
                      
           begin
              
              smc_data22[31:16] = 16'h0;
              smc_data22[15:0] = write_data22[31:16];
              
           end 
         
         {`BSIZ_1622,1'bx,1'bx}:  // (v_bus_size22 == `BSIZ_1622)  
           
           begin
              
              smc_data22[31:16] = 16'h0;
              smc_data22[15:0]  = write_data22[15:0];
              
           end
         
         {`BSIZ_822,2'h3}:  //  (r_num_access22 == 3)
           
           begin
              
              smc_data22[31:8] = 24'h0;
              smc_data22[7:0] = write_data22[31:24];
           end
         
         {`BSIZ_822,2'h2}:  //   (r_num_access22 == 2)
           
           begin
              
              smc_data22[31:8] = 24'h0;
              smc_data22[7:0] = write_data22[23:16];
              
           end
         
         {`BSIZ_822,2'h1}:  //  (r_num_access22 == 2)
           
           begin
              
              smc_data22[31:8] = 24'h0;
              smc_data22[7:0]  = write_data22[15:8];
              
           end 
         
         {`BSIZ_822,2'h0}:  //  (r_num_access22 == 0) 
           
           begin
              
              smc_data22[31:8] = 24'h0;
              smc_data22[7:0] = write_data22[7:0];
              
           end 
         
         default:
           
           smc_data22 = 32'h0;
         
       endcase // casex(bus_size_num_access22)
       
       
    end
   
endmodule
