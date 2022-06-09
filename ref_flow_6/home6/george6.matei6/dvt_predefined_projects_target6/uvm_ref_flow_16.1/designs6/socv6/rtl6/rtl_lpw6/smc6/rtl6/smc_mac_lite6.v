//File6 name   : smc_mac_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : Multiple6 access controller6.
//            : Static6 Memory Controller6.
//            : The Multiple6 Access Control6 Block keeps6 trace6 of the
//            : number6 of accesses required6 to fulfill6 the
//            : requirements6 of the AHB6 transfer6. The data is
//            : registered when multiple reads are required6. The AHB6
//            : holds6 the data during multiple writes.
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

`include "smc_defs_lite6.v"

module smc_mac_lite6     (

                    //inputs6
                    
                    sys_clk6,
                    n_sys_reset6,
                    valid_access6,
                    xfer_size6,
                    smc_done6,
                    data_smc6,
                    write_data6,
                    smc_nextstate6,
                    latch_data6,
                    
                    //outputs6
                    
                    r_num_access6,
                    mac_done6,
                    v_bus_size6,
                    v_xfer_size6,
                    read_data6,
                    smc_data6);
   
   
   
 


// State6 Machine6// I6/O6

  input                sys_clk6;        // System6 clock6
  input                n_sys_reset6;    // System6 reset (Active6 LOW6)
  input                valid_access6;   // Address cycle of new transfer6
  input  [1:0]         xfer_size6;      // xfer6 size, valid with valid_access6
  input                smc_done6;       // End6 of transfer6
  input  [31:0]        data_smc6;       // External6 read data
  input  [31:0]        write_data6;     // Data from internal bus 
  input  [4:0]         smc_nextstate6;  // State6 Machine6  
  input                latch_data6;     //latch_data6 is used by the MAC6 block    
  
  output [1:0]         r_num_access6;   // Access counter
  output               mac_done6;       // End6 of all transfers6
  output [1:0]         v_bus_size6;     // Registered6 sizes6 for subsequent6
  output [1:0]         v_xfer_size6;    // transfers6 in MAC6 transfer6
  output [31:0]        read_data6;      // Data to internal bus
  output [31:0]        smc_data6;       // Data to external6 bus
  

// Output6 register declarations6

  reg                  mac_done6;       // Indicates6 last cycle of last access
  reg [1:0]            r_num_access6;   // Access counter
  reg [1:0]            num_accesses6;   //number6 of access
  reg [1:0]            r_xfer_size6;    // Store6 size for MAC6 
  reg [1:0]            r_bus_size6;     // Store6 size for MAC6
  reg [31:0]           read_data6;      // Data path to bus IF
  reg [31:0]           r_read_data6;    // Internal data store6
  reg [31:0]           smc_data6;


// Internal Signals6

  reg [1:0]            v_bus_size6;
  reg [1:0]            v_xfer_size6;
  wire [4:0]           smc_nextstate6;    //specifies6 next state
  wire [4:0]           xfer_bus_ldata6;  //concatenation6 of xfer_size6
                                         // and latch_data6  
  wire [3:0]           bus_size_num_access6; //concatenation6 of 
                                              // r_num_access6
  wire [5:0]           wt_ldata_naccs_bsiz6;  //concatenation6 of 
                                            //latch_data6,r_num_access6
 
   


// Main6 Code6

//----------------------------------------------------------------------------
// Store6 transfer6 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk6 or negedge n_sys_reset6)
  
    begin
       
       if (~n_sys_reset6)
         
          r_xfer_size6 <= 2'b00;
       
       
       else if (valid_access6)
         
          r_xfer_size6 <= xfer_size6;
       
       else
         
          r_xfer_size6 <= r_xfer_size6;
       
    end

//--------------------------------------------------------------------
// Store6 bus size generation6
//--------------------------------------------------------------------
  
  always @(posedge sys_clk6 or negedge n_sys_reset6)
    
    begin
       
       if (~n_sys_reset6)
         
          r_bus_size6 <= 2'b00;
       
       
       else if (valid_access6)
         
          r_bus_size6 <= 2'b00;
       
       else
         
          r_bus_size6 <= r_bus_size6;
       
    end
   

//--------------------------------------------------------------------
// Validate6 sizes6 generation6
//--------------------------------------------------------------------

  always @(valid_access6 or r_bus_size6 )

    begin
       
       if (valid_access6)
         
          v_bus_size6 = 2'b0;
       
       else
         
          v_bus_size6 = r_bus_size6;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size6 generation6
//----------------------------------------------------------------------------   

  always @(valid_access6 or r_xfer_size6 or xfer_size6)

    begin
       
       if (valid_access6)
         
          v_xfer_size6 = xfer_size6;
       
       else
         
          v_xfer_size6 = r_xfer_size6;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions6
// Determines6 the number6 of accesses required6 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size6)
  
    begin
       
       if ((xfer_size6[1:0] == `XSIZ_166))
         
          num_accesses6 = 2'h1; // Two6 accesses
       
       else if ( (xfer_size6[1:0] == `XSIZ_326))
         
          num_accesses6 = 2'h3; // Four6 accesses
       
       else
         
          num_accesses6 = 2'h0; // One6 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep6 track6 of the current access number6
//--------------------------------------------------------------------
   
  always @(posedge sys_clk6 or negedge n_sys_reset6)
  
    begin
       
       if (~n_sys_reset6)
         
          r_num_access6 <= 2'b00;
       
       else if (valid_access6)
         
          r_num_access6 <= num_accesses6;
       
       else if (smc_done6 & (smc_nextstate6 != `SMC_STORE6)  &
                      (smc_nextstate6 != `SMC_IDLE6)   )
         
          r_num_access6 <= r_num_access6 - 2'd1;
       
       else
         
          r_num_access6 <= r_num_access6;
       
    end
   
   

//--------------------------------------------------------------------
// Detect6 last access
//--------------------------------------------------------------------
   
   always @(r_num_access6)
     
     begin
        
        if (r_num_access6 == 2'h0)
          
           mac_done6 = 1'b1;
             
        else
          
           mac_done6 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals6 concatenation6 used in case statement6 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz6 = { 1'b0, latch_data6, r_num_access6,
                                  r_bus_size6};
 
   
//--------------------------------------------------------------------
// Store6 Read Data if required6
//--------------------------------------------------------------------

   always @(posedge sys_clk6 or negedge n_sys_reset6)
     
     begin
        
        if (~n_sys_reset6)
          
           r_read_data6 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz6)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data6 <= r_read_data6;
            
            //    latch_data6
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data6[31:24] <= data_smc6[7:0];
                 r_read_data6[23:0] <= 24'h0;
                 
              end
            
            // r_num_access6 =2, v_bus_size6 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data6[23:16] <= data_smc6[7:0];
                 r_read_data6[31:24] <= r_read_data6[31:24];
                 r_read_data6[15:0] <= 16'h0;
                 
              end
            
            // r_num_access6 =1, v_bus_size6 = `XSIZ_166
            
            {1'b0,1'b1,2'h1,`XSIZ_166}:
              
              begin
                 
                 r_read_data6[15:0] <= 16'h0;
                 r_read_data6[31:16] <= data_smc6[15:0];
                 
              end
            
            //  r_num_access6 =1,v_bus_size6 == `XSIZ_86
            
            {1'b0,1'b1,2'h1,`XSIZ_86}:          
              
              begin
                 
                 r_read_data6[15:8] <= data_smc6[7:0];
                 r_read_data6[31:16] <= r_read_data6[31:16];
                 r_read_data6[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access6 = 0, v_bus_size6 == `XSIZ_166
            
            {1'b0,1'b1,2'h0,`XSIZ_166}:  // r_num_access6 =0
              
              
              begin
                 
                 r_read_data6[15:0] <= data_smc6[15:0];
                 r_read_data6[31:16] <= r_read_data6[31:16];
                 
              end
            
            //  r_num_access6 = 0, v_bus_size6 == `XSIZ_86 
            
            {1'b0,1'b1,2'h0,`XSIZ_86}:
              
              begin
                 
                 r_read_data6[7:0] <= data_smc6[7:0];
                 r_read_data6[31:8] <= r_read_data6[31:8];
                 
              end
            
            //  r_num_access6 = 0, v_bus_size6 == `XSIZ_326
            
            {1'b0,1'b1,2'h0,`XSIZ_326}:
              
               r_read_data6[31:0] <= data_smc6[31:0];                      
            
            default :
              
               r_read_data6 <= r_read_data6;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals6 concatenation6 for case statement6 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata6 = {r_xfer_size6,r_bus_size6,latch_data6};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata6 or data_smc6 or r_read_data6 )
       
     begin
        
        casex(xfer_bus_ldata6)
          
          {`XSIZ_326,`BSIZ_326,1'b1} :
            
             read_data6[31:0] = data_smc6[31:0];
          
          {`XSIZ_326,`BSIZ_166,1'b1} :
                              
            begin
               
               read_data6[31:16] = r_read_data6[31:16];
               read_data6[15:0]  = data_smc6[15:0];
               
            end
          
          {`XSIZ_326,`BSIZ_86,1'b1} :
            
            begin
               
               read_data6[31:8] = r_read_data6[31:8];
               read_data6[7:0]  = data_smc6[7:0];
               
            end
          
          {`XSIZ_326,1'bx,1'bx,1'bx} :
            
            read_data6 = r_read_data6;
          
          {`XSIZ_166,`BSIZ_166,1'b1} :
                        
            begin
               
               read_data6[31:16] = data_smc6[15:0];
               read_data6[15:0] = data_smc6[15:0];
               
            end
          
          {`XSIZ_166,`BSIZ_166,1'b0} :  
            
            begin
               
               read_data6[31:16] = r_read_data6[15:0];
               read_data6[15:0] = r_read_data6[15:0];
               
            end
          
          {`XSIZ_166,`BSIZ_326,1'b1} :  
            
            read_data6 = data_smc6;
          
          {`XSIZ_166,`BSIZ_86,1'b1} : 
                        
            begin
               
               read_data6[31:24] = r_read_data6[15:8];
               read_data6[23:16] = data_smc6[7:0];
               read_data6[15:8] = r_read_data6[15:8];
               read_data6[7:0] = data_smc6[7:0];
            end
          
          {`XSIZ_166,`BSIZ_86,1'b0} : 
            
            begin
               
               read_data6[31:16] = r_read_data6[15:0];
               read_data6[15:0] = r_read_data6[15:0];
               
            end
          
          {`XSIZ_166,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data6[31:16] = r_read_data6[31:16];
               read_data6[15:0] = r_read_data6[15:0];
               
            end
          
          {`XSIZ_86,`BSIZ_166,1'b1} :
            
            begin
               
               read_data6[31:16] = data_smc6[15:0];
               read_data6[15:0] = data_smc6[15:0];
               
            end
          
          {`XSIZ_86,`BSIZ_166,1'b0} :
            
            begin
               
               read_data6[31:16] = r_read_data6[15:0];
               read_data6[15:0]  = r_read_data6[15:0];
               
            end
          
          {`XSIZ_86,`BSIZ_326,1'b1} :   
            
            read_data6 = data_smc6;
          
          {`XSIZ_86,`BSIZ_326,1'b0} :              
                        
                        read_data6 = r_read_data6;
          
          {`XSIZ_86,`BSIZ_86,1'b1} :   
                                    
            begin
               
               read_data6[31:24] = data_smc6[7:0];
               read_data6[23:16] = data_smc6[7:0];
               read_data6[15:8]  = data_smc6[7:0];
               read_data6[7:0]   = data_smc6[7:0];
               
            end
          
          default:
            
            begin
               
               read_data6[31:24] = r_read_data6[7:0];
               read_data6[23:16] = r_read_data6[7:0];
               read_data6[15:8]  = r_read_data6[7:0];
               read_data6[7:0]   = r_read_data6[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata6)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal6 concatenation6 for use in case statement6
//----------------------------------------------------------------------------
   
   assign bus_size_num_access6 = { r_bus_size6, r_num_access6};
   
//--------------------------------------------------------------------
// Select6 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access6 or write_data6)
  
    begin
       
       casex(bus_size_num_access6)
         
         {`BSIZ_326,1'bx,1'bx}://    (v_bus_size6 == `BSIZ_326)
           
           smc_data6 = write_data6;
         
         {`BSIZ_166,2'h1}:    // r_num_access6 == 1
                      
           begin
              
              smc_data6[31:16] = 16'h0;
              smc_data6[15:0] = write_data6[31:16];
              
           end 
         
         {`BSIZ_166,1'bx,1'bx}:  // (v_bus_size6 == `BSIZ_166)  
           
           begin
              
              smc_data6[31:16] = 16'h0;
              smc_data6[15:0]  = write_data6[15:0];
              
           end
         
         {`BSIZ_86,2'h3}:  //  (r_num_access6 == 3)
           
           begin
              
              smc_data6[31:8] = 24'h0;
              smc_data6[7:0] = write_data6[31:24];
           end
         
         {`BSIZ_86,2'h2}:  //   (r_num_access6 == 2)
           
           begin
              
              smc_data6[31:8] = 24'h0;
              smc_data6[7:0] = write_data6[23:16];
              
           end
         
         {`BSIZ_86,2'h1}:  //  (r_num_access6 == 2)
           
           begin
              
              smc_data6[31:8] = 24'h0;
              smc_data6[7:0]  = write_data6[15:8];
              
           end 
         
         {`BSIZ_86,2'h0}:  //  (r_num_access6 == 0) 
           
           begin
              
              smc_data6[31:8] = 24'h0;
              smc_data6[7:0] = write_data6[7:0];
              
           end 
         
         default:
           
           smc_data6 = 32'h0;
         
       endcase // casex(bus_size_num_access6)
       
       
    end
   
endmodule
