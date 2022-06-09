//File18 name   : smc_mac_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : Multiple18 access controller18.
//            : Static18 Memory Controller18.
//            : The Multiple18 Access Control18 Block keeps18 trace18 of the
//            : number18 of accesses required18 to fulfill18 the
//            : requirements18 of the AHB18 transfer18. The data is
//            : registered when multiple reads are required18. The AHB18
//            : holds18 the data during multiple writes.
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

`include "smc_defs_lite18.v"

module smc_mac_lite18     (

                    //inputs18
                    
                    sys_clk18,
                    n_sys_reset18,
                    valid_access18,
                    xfer_size18,
                    smc_done18,
                    data_smc18,
                    write_data18,
                    smc_nextstate18,
                    latch_data18,
                    
                    //outputs18
                    
                    r_num_access18,
                    mac_done18,
                    v_bus_size18,
                    v_xfer_size18,
                    read_data18,
                    smc_data18);
   
   
   
 


// State18 Machine18// I18/O18

  input                sys_clk18;        // System18 clock18
  input                n_sys_reset18;    // System18 reset (Active18 LOW18)
  input                valid_access18;   // Address cycle of new transfer18
  input  [1:0]         xfer_size18;      // xfer18 size, valid with valid_access18
  input                smc_done18;       // End18 of transfer18
  input  [31:0]        data_smc18;       // External18 read data
  input  [31:0]        write_data18;     // Data from internal bus 
  input  [4:0]         smc_nextstate18;  // State18 Machine18  
  input                latch_data18;     //latch_data18 is used by the MAC18 block    
  
  output [1:0]         r_num_access18;   // Access counter
  output               mac_done18;       // End18 of all transfers18
  output [1:0]         v_bus_size18;     // Registered18 sizes18 for subsequent18
  output [1:0]         v_xfer_size18;    // transfers18 in MAC18 transfer18
  output [31:0]        read_data18;      // Data to internal bus
  output [31:0]        smc_data18;       // Data to external18 bus
  

// Output18 register declarations18

  reg                  mac_done18;       // Indicates18 last cycle of last access
  reg [1:0]            r_num_access18;   // Access counter
  reg [1:0]            num_accesses18;   //number18 of access
  reg [1:0]            r_xfer_size18;    // Store18 size for MAC18 
  reg [1:0]            r_bus_size18;     // Store18 size for MAC18
  reg [31:0]           read_data18;      // Data path to bus IF
  reg [31:0]           r_read_data18;    // Internal data store18
  reg [31:0]           smc_data18;


// Internal Signals18

  reg [1:0]            v_bus_size18;
  reg [1:0]            v_xfer_size18;
  wire [4:0]           smc_nextstate18;    //specifies18 next state
  wire [4:0]           xfer_bus_ldata18;  //concatenation18 of xfer_size18
                                         // and latch_data18  
  wire [3:0]           bus_size_num_access18; //concatenation18 of 
                                              // r_num_access18
  wire [5:0]           wt_ldata_naccs_bsiz18;  //concatenation18 of 
                                            //latch_data18,r_num_access18
 
   


// Main18 Code18

//----------------------------------------------------------------------------
// Store18 transfer18 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk18 or negedge n_sys_reset18)
  
    begin
       
       if (~n_sys_reset18)
         
          r_xfer_size18 <= 2'b00;
       
       
       else if (valid_access18)
         
          r_xfer_size18 <= xfer_size18;
       
       else
         
          r_xfer_size18 <= r_xfer_size18;
       
    end

//--------------------------------------------------------------------
// Store18 bus size generation18
//--------------------------------------------------------------------
  
  always @(posedge sys_clk18 or negedge n_sys_reset18)
    
    begin
       
       if (~n_sys_reset18)
         
          r_bus_size18 <= 2'b00;
       
       
       else if (valid_access18)
         
          r_bus_size18 <= 2'b00;
       
       else
         
          r_bus_size18 <= r_bus_size18;
       
    end
   

//--------------------------------------------------------------------
// Validate18 sizes18 generation18
//--------------------------------------------------------------------

  always @(valid_access18 or r_bus_size18 )

    begin
       
       if (valid_access18)
         
          v_bus_size18 = 2'b0;
       
       else
         
          v_bus_size18 = r_bus_size18;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size18 generation18
//----------------------------------------------------------------------------   

  always @(valid_access18 or r_xfer_size18 or xfer_size18)

    begin
       
       if (valid_access18)
         
          v_xfer_size18 = xfer_size18;
       
       else
         
          v_xfer_size18 = r_xfer_size18;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions18
// Determines18 the number18 of accesses required18 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size18)
  
    begin
       
       if ((xfer_size18[1:0] == `XSIZ_1618))
         
          num_accesses18 = 2'h1; // Two18 accesses
       
       else if ( (xfer_size18[1:0] == `XSIZ_3218))
         
          num_accesses18 = 2'h3; // Four18 accesses
       
       else
         
          num_accesses18 = 2'h0; // One18 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep18 track18 of the current access number18
//--------------------------------------------------------------------
   
  always @(posedge sys_clk18 or negedge n_sys_reset18)
  
    begin
       
       if (~n_sys_reset18)
         
          r_num_access18 <= 2'b00;
       
       else if (valid_access18)
         
          r_num_access18 <= num_accesses18;
       
       else if (smc_done18 & (smc_nextstate18 != `SMC_STORE18)  &
                      (smc_nextstate18 != `SMC_IDLE18)   )
         
          r_num_access18 <= r_num_access18 - 2'd1;
       
       else
         
          r_num_access18 <= r_num_access18;
       
    end
   
   

//--------------------------------------------------------------------
// Detect18 last access
//--------------------------------------------------------------------
   
   always @(r_num_access18)
     
     begin
        
        if (r_num_access18 == 2'h0)
          
           mac_done18 = 1'b1;
             
        else
          
           mac_done18 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals18 concatenation18 used in case statement18 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz18 = { 1'b0, latch_data18, r_num_access18,
                                  r_bus_size18};
 
   
//--------------------------------------------------------------------
// Store18 Read Data if required18
//--------------------------------------------------------------------

   always @(posedge sys_clk18 or negedge n_sys_reset18)
     
     begin
        
        if (~n_sys_reset18)
          
           r_read_data18 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz18)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data18 <= r_read_data18;
            
            //    latch_data18
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data18[31:24] <= data_smc18[7:0];
                 r_read_data18[23:0] <= 24'h0;
                 
              end
            
            // r_num_access18 =2, v_bus_size18 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data18[23:16] <= data_smc18[7:0];
                 r_read_data18[31:24] <= r_read_data18[31:24];
                 r_read_data18[15:0] <= 16'h0;
                 
              end
            
            // r_num_access18 =1, v_bus_size18 = `XSIZ_1618
            
            {1'b0,1'b1,2'h1,`XSIZ_1618}:
              
              begin
                 
                 r_read_data18[15:0] <= 16'h0;
                 r_read_data18[31:16] <= data_smc18[15:0];
                 
              end
            
            //  r_num_access18 =1,v_bus_size18 == `XSIZ_818
            
            {1'b0,1'b1,2'h1,`XSIZ_818}:          
              
              begin
                 
                 r_read_data18[15:8] <= data_smc18[7:0];
                 r_read_data18[31:16] <= r_read_data18[31:16];
                 r_read_data18[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access18 = 0, v_bus_size18 == `XSIZ_1618
            
            {1'b0,1'b1,2'h0,`XSIZ_1618}:  // r_num_access18 =0
              
              
              begin
                 
                 r_read_data18[15:0] <= data_smc18[15:0];
                 r_read_data18[31:16] <= r_read_data18[31:16];
                 
              end
            
            //  r_num_access18 = 0, v_bus_size18 == `XSIZ_818 
            
            {1'b0,1'b1,2'h0,`XSIZ_818}:
              
              begin
                 
                 r_read_data18[7:0] <= data_smc18[7:0];
                 r_read_data18[31:8] <= r_read_data18[31:8];
                 
              end
            
            //  r_num_access18 = 0, v_bus_size18 == `XSIZ_3218
            
            {1'b0,1'b1,2'h0,`XSIZ_3218}:
              
               r_read_data18[31:0] <= data_smc18[31:0];                      
            
            default :
              
               r_read_data18 <= r_read_data18;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals18 concatenation18 for case statement18 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata18 = {r_xfer_size18,r_bus_size18,latch_data18};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata18 or data_smc18 or r_read_data18 )
       
     begin
        
        casex(xfer_bus_ldata18)
          
          {`XSIZ_3218,`BSIZ_3218,1'b1} :
            
             read_data18[31:0] = data_smc18[31:0];
          
          {`XSIZ_3218,`BSIZ_1618,1'b1} :
                              
            begin
               
               read_data18[31:16] = r_read_data18[31:16];
               read_data18[15:0]  = data_smc18[15:0];
               
            end
          
          {`XSIZ_3218,`BSIZ_818,1'b1} :
            
            begin
               
               read_data18[31:8] = r_read_data18[31:8];
               read_data18[7:0]  = data_smc18[7:0];
               
            end
          
          {`XSIZ_3218,1'bx,1'bx,1'bx} :
            
            read_data18 = r_read_data18;
          
          {`XSIZ_1618,`BSIZ_1618,1'b1} :
                        
            begin
               
               read_data18[31:16] = data_smc18[15:0];
               read_data18[15:0] = data_smc18[15:0];
               
            end
          
          {`XSIZ_1618,`BSIZ_1618,1'b0} :  
            
            begin
               
               read_data18[31:16] = r_read_data18[15:0];
               read_data18[15:0] = r_read_data18[15:0];
               
            end
          
          {`XSIZ_1618,`BSIZ_3218,1'b1} :  
            
            read_data18 = data_smc18;
          
          {`XSIZ_1618,`BSIZ_818,1'b1} : 
                        
            begin
               
               read_data18[31:24] = r_read_data18[15:8];
               read_data18[23:16] = data_smc18[7:0];
               read_data18[15:8] = r_read_data18[15:8];
               read_data18[7:0] = data_smc18[7:0];
            end
          
          {`XSIZ_1618,`BSIZ_818,1'b0} : 
            
            begin
               
               read_data18[31:16] = r_read_data18[15:0];
               read_data18[15:0] = r_read_data18[15:0];
               
            end
          
          {`XSIZ_1618,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data18[31:16] = r_read_data18[31:16];
               read_data18[15:0] = r_read_data18[15:0];
               
            end
          
          {`XSIZ_818,`BSIZ_1618,1'b1} :
            
            begin
               
               read_data18[31:16] = data_smc18[15:0];
               read_data18[15:0] = data_smc18[15:0];
               
            end
          
          {`XSIZ_818,`BSIZ_1618,1'b0} :
            
            begin
               
               read_data18[31:16] = r_read_data18[15:0];
               read_data18[15:0]  = r_read_data18[15:0];
               
            end
          
          {`XSIZ_818,`BSIZ_3218,1'b1} :   
            
            read_data18 = data_smc18;
          
          {`XSIZ_818,`BSIZ_3218,1'b0} :              
                        
                        read_data18 = r_read_data18;
          
          {`XSIZ_818,`BSIZ_818,1'b1} :   
                                    
            begin
               
               read_data18[31:24] = data_smc18[7:0];
               read_data18[23:16] = data_smc18[7:0];
               read_data18[15:8]  = data_smc18[7:0];
               read_data18[7:0]   = data_smc18[7:0];
               
            end
          
          default:
            
            begin
               
               read_data18[31:24] = r_read_data18[7:0];
               read_data18[23:16] = r_read_data18[7:0];
               read_data18[15:8]  = r_read_data18[7:0];
               read_data18[7:0]   = r_read_data18[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata18)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal18 concatenation18 for use in case statement18
//----------------------------------------------------------------------------
   
   assign bus_size_num_access18 = { r_bus_size18, r_num_access18};
   
//--------------------------------------------------------------------
// Select18 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access18 or write_data18)
  
    begin
       
       casex(bus_size_num_access18)
         
         {`BSIZ_3218,1'bx,1'bx}://    (v_bus_size18 == `BSIZ_3218)
           
           smc_data18 = write_data18;
         
         {`BSIZ_1618,2'h1}:    // r_num_access18 == 1
                      
           begin
              
              smc_data18[31:16] = 16'h0;
              smc_data18[15:0] = write_data18[31:16];
              
           end 
         
         {`BSIZ_1618,1'bx,1'bx}:  // (v_bus_size18 == `BSIZ_1618)  
           
           begin
              
              smc_data18[31:16] = 16'h0;
              smc_data18[15:0]  = write_data18[15:0];
              
           end
         
         {`BSIZ_818,2'h3}:  //  (r_num_access18 == 3)
           
           begin
              
              smc_data18[31:8] = 24'h0;
              smc_data18[7:0] = write_data18[31:24];
           end
         
         {`BSIZ_818,2'h2}:  //   (r_num_access18 == 2)
           
           begin
              
              smc_data18[31:8] = 24'h0;
              smc_data18[7:0] = write_data18[23:16];
              
           end
         
         {`BSIZ_818,2'h1}:  //  (r_num_access18 == 2)
           
           begin
              
              smc_data18[31:8] = 24'h0;
              smc_data18[7:0]  = write_data18[15:8];
              
           end 
         
         {`BSIZ_818,2'h0}:  //  (r_num_access18 == 0) 
           
           begin
              
              smc_data18[31:8] = 24'h0;
              smc_data18[7:0] = write_data18[7:0];
              
           end 
         
         default:
           
           smc_data18 = 32'h0;
         
       endcase // casex(bus_size_num_access18)
       
       
    end
   
endmodule
