//File24 name   : smc_mac_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : Multiple24 access controller24.
//            : Static24 Memory Controller24.
//            : The Multiple24 Access Control24 Block keeps24 trace24 of the
//            : number24 of accesses required24 to fulfill24 the
//            : requirements24 of the AHB24 transfer24. The data is
//            : registered when multiple reads are required24. The AHB24
//            : holds24 the data during multiple writes.
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

`include "smc_defs_lite24.v"

module smc_mac_lite24     (

                    //inputs24
                    
                    sys_clk24,
                    n_sys_reset24,
                    valid_access24,
                    xfer_size24,
                    smc_done24,
                    data_smc24,
                    write_data24,
                    smc_nextstate24,
                    latch_data24,
                    
                    //outputs24
                    
                    r_num_access24,
                    mac_done24,
                    v_bus_size24,
                    v_xfer_size24,
                    read_data24,
                    smc_data24);
   
   
   
 


// State24 Machine24// I24/O24

  input                sys_clk24;        // System24 clock24
  input                n_sys_reset24;    // System24 reset (Active24 LOW24)
  input                valid_access24;   // Address cycle of new transfer24
  input  [1:0]         xfer_size24;      // xfer24 size, valid with valid_access24
  input                smc_done24;       // End24 of transfer24
  input  [31:0]        data_smc24;       // External24 read data
  input  [31:0]        write_data24;     // Data from internal bus 
  input  [4:0]         smc_nextstate24;  // State24 Machine24  
  input                latch_data24;     //latch_data24 is used by the MAC24 block    
  
  output [1:0]         r_num_access24;   // Access counter
  output               mac_done24;       // End24 of all transfers24
  output [1:0]         v_bus_size24;     // Registered24 sizes24 for subsequent24
  output [1:0]         v_xfer_size24;    // transfers24 in MAC24 transfer24
  output [31:0]        read_data24;      // Data to internal bus
  output [31:0]        smc_data24;       // Data to external24 bus
  

// Output24 register declarations24

  reg                  mac_done24;       // Indicates24 last cycle of last access
  reg [1:0]            r_num_access24;   // Access counter
  reg [1:0]            num_accesses24;   //number24 of access
  reg [1:0]            r_xfer_size24;    // Store24 size for MAC24 
  reg [1:0]            r_bus_size24;     // Store24 size for MAC24
  reg [31:0]           read_data24;      // Data path to bus IF
  reg [31:0]           r_read_data24;    // Internal data store24
  reg [31:0]           smc_data24;


// Internal Signals24

  reg [1:0]            v_bus_size24;
  reg [1:0]            v_xfer_size24;
  wire [4:0]           smc_nextstate24;    //specifies24 next state
  wire [4:0]           xfer_bus_ldata24;  //concatenation24 of xfer_size24
                                         // and latch_data24  
  wire [3:0]           bus_size_num_access24; //concatenation24 of 
                                              // r_num_access24
  wire [5:0]           wt_ldata_naccs_bsiz24;  //concatenation24 of 
                                            //latch_data24,r_num_access24
 
   


// Main24 Code24

//----------------------------------------------------------------------------
// Store24 transfer24 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk24 or negedge n_sys_reset24)
  
    begin
       
       if (~n_sys_reset24)
         
          r_xfer_size24 <= 2'b00;
       
       
       else if (valid_access24)
         
          r_xfer_size24 <= xfer_size24;
       
       else
         
          r_xfer_size24 <= r_xfer_size24;
       
    end

//--------------------------------------------------------------------
// Store24 bus size generation24
//--------------------------------------------------------------------
  
  always @(posedge sys_clk24 or negedge n_sys_reset24)
    
    begin
       
       if (~n_sys_reset24)
         
          r_bus_size24 <= 2'b00;
       
       
       else if (valid_access24)
         
          r_bus_size24 <= 2'b00;
       
       else
         
          r_bus_size24 <= r_bus_size24;
       
    end
   

//--------------------------------------------------------------------
// Validate24 sizes24 generation24
//--------------------------------------------------------------------

  always @(valid_access24 or r_bus_size24 )

    begin
       
       if (valid_access24)
         
          v_bus_size24 = 2'b0;
       
       else
         
          v_bus_size24 = r_bus_size24;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size24 generation24
//----------------------------------------------------------------------------   

  always @(valid_access24 or r_xfer_size24 or xfer_size24)

    begin
       
       if (valid_access24)
         
          v_xfer_size24 = xfer_size24;
       
       else
         
          v_xfer_size24 = r_xfer_size24;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions24
// Determines24 the number24 of accesses required24 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size24)
  
    begin
       
       if ((xfer_size24[1:0] == `XSIZ_1624))
         
          num_accesses24 = 2'h1; // Two24 accesses
       
       else if ( (xfer_size24[1:0] == `XSIZ_3224))
         
          num_accesses24 = 2'h3; // Four24 accesses
       
       else
         
          num_accesses24 = 2'h0; // One24 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep24 track24 of the current access number24
//--------------------------------------------------------------------
   
  always @(posedge sys_clk24 or negedge n_sys_reset24)
  
    begin
       
       if (~n_sys_reset24)
         
          r_num_access24 <= 2'b00;
       
       else if (valid_access24)
         
          r_num_access24 <= num_accesses24;
       
       else if (smc_done24 & (smc_nextstate24 != `SMC_STORE24)  &
                      (smc_nextstate24 != `SMC_IDLE24)   )
         
          r_num_access24 <= r_num_access24 - 2'd1;
       
       else
         
          r_num_access24 <= r_num_access24;
       
    end
   
   

//--------------------------------------------------------------------
// Detect24 last access
//--------------------------------------------------------------------
   
   always @(r_num_access24)
     
     begin
        
        if (r_num_access24 == 2'h0)
          
           mac_done24 = 1'b1;
             
        else
          
           mac_done24 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals24 concatenation24 used in case statement24 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz24 = { 1'b0, latch_data24, r_num_access24,
                                  r_bus_size24};
 
   
//--------------------------------------------------------------------
// Store24 Read Data if required24
//--------------------------------------------------------------------

   always @(posedge sys_clk24 or negedge n_sys_reset24)
     
     begin
        
        if (~n_sys_reset24)
          
           r_read_data24 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz24)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data24 <= r_read_data24;
            
            //    latch_data24
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data24[31:24] <= data_smc24[7:0];
                 r_read_data24[23:0] <= 24'h0;
                 
              end
            
            // r_num_access24 =2, v_bus_size24 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data24[23:16] <= data_smc24[7:0];
                 r_read_data24[31:24] <= r_read_data24[31:24];
                 r_read_data24[15:0] <= 16'h0;
                 
              end
            
            // r_num_access24 =1, v_bus_size24 = `XSIZ_1624
            
            {1'b0,1'b1,2'h1,`XSIZ_1624}:
              
              begin
                 
                 r_read_data24[15:0] <= 16'h0;
                 r_read_data24[31:16] <= data_smc24[15:0];
                 
              end
            
            //  r_num_access24 =1,v_bus_size24 == `XSIZ_824
            
            {1'b0,1'b1,2'h1,`XSIZ_824}:          
              
              begin
                 
                 r_read_data24[15:8] <= data_smc24[7:0];
                 r_read_data24[31:16] <= r_read_data24[31:16];
                 r_read_data24[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access24 = 0, v_bus_size24 == `XSIZ_1624
            
            {1'b0,1'b1,2'h0,`XSIZ_1624}:  // r_num_access24 =0
              
              
              begin
                 
                 r_read_data24[15:0] <= data_smc24[15:0];
                 r_read_data24[31:16] <= r_read_data24[31:16];
                 
              end
            
            //  r_num_access24 = 0, v_bus_size24 == `XSIZ_824 
            
            {1'b0,1'b1,2'h0,`XSIZ_824}:
              
              begin
                 
                 r_read_data24[7:0] <= data_smc24[7:0];
                 r_read_data24[31:8] <= r_read_data24[31:8];
                 
              end
            
            //  r_num_access24 = 0, v_bus_size24 == `XSIZ_3224
            
            {1'b0,1'b1,2'h0,`XSIZ_3224}:
              
               r_read_data24[31:0] <= data_smc24[31:0];                      
            
            default :
              
               r_read_data24 <= r_read_data24;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals24 concatenation24 for case statement24 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata24 = {r_xfer_size24,r_bus_size24,latch_data24};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata24 or data_smc24 or r_read_data24 )
       
     begin
        
        casex(xfer_bus_ldata24)
          
          {`XSIZ_3224,`BSIZ_3224,1'b1} :
            
             read_data24[31:0] = data_smc24[31:0];
          
          {`XSIZ_3224,`BSIZ_1624,1'b1} :
                              
            begin
               
               read_data24[31:16] = r_read_data24[31:16];
               read_data24[15:0]  = data_smc24[15:0];
               
            end
          
          {`XSIZ_3224,`BSIZ_824,1'b1} :
            
            begin
               
               read_data24[31:8] = r_read_data24[31:8];
               read_data24[7:0]  = data_smc24[7:0];
               
            end
          
          {`XSIZ_3224,1'bx,1'bx,1'bx} :
            
            read_data24 = r_read_data24;
          
          {`XSIZ_1624,`BSIZ_1624,1'b1} :
                        
            begin
               
               read_data24[31:16] = data_smc24[15:0];
               read_data24[15:0] = data_smc24[15:0];
               
            end
          
          {`XSIZ_1624,`BSIZ_1624,1'b0} :  
            
            begin
               
               read_data24[31:16] = r_read_data24[15:0];
               read_data24[15:0] = r_read_data24[15:0];
               
            end
          
          {`XSIZ_1624,`BSIZ_3224,1'b1} :  
            
            read_data24 = data_smc24;
          
          {`XSIZ_1624,`BSIZ_824,1'b1} : 
                        
            begin
               
               read_data24[31:24] = r_read_data24[15:8];
               read_data24[23:16] = data_smc24[7:0];
               read_data24[15:8] = r_read_data24[15:8];
               read_data24[7:0] = data_smc24[7:0];
            end
          
          {`XSIZ_1624,`BSIZ_824,1'b0} : 
            
            begin
               
               read_data24[31:16] = r_read_data24[15:0];
               read_data24[15:0] = r_read_data24[15:0];
               
            end
          
          {`XSIZ_1624,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data24[31:16] = r_read_data24[31:16];
               read_data24[15:0] = r_read_data24[15:0];
               
            end
          
          {`XSIZ_824,`BSIZ_1624,1'b1} :
            
            begin
               
               read_data24[31:16] = data_smc24[15:0];
               read_data24[15:0] = data_smc24[15:0];
               
            end
          
          {`XSIZ_824,`BSIZ_1624,1'b0} :
            
            begin
               
               read_data24[31:16] = r_read_data24[15:0];
               read_data24[15:0]  = r_read_data24[15:0];
               
            end
          
          {`XSIZ_824,`BSIZ_3224,1'b1} :   
            
            read_data24 = data_smc24;
          
          {`XSIZ_824,`BSIZ_3224,1'b0} :              
                        
                        read_data24 = r_read_data24;
          
          {`XSIZ_824,`BSIZ_824,1'b1} :   
                                    
            begin
               
               read_data24[31:24] = data_smc24[7:0];
               read_data24[23:16] = data_smc24[7:0];
               read_data24[15:8]  = data_smc24[7:0];
               read_data24[7:0]   = data_smc24[7:0];
               
            end
          
          default:
            
            begin
               
               read_data24[31:24] = r_read_data24[7:0];
               read_data24[23:16] = r_read_data24[7:0];
               read_data24[15:8]  = r_read_data24[7:0];
               read_data24[7:0]   = r_read_data24[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata24)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal24 concatenation24 for use in case statement24
//----------------------------------------------------------------------------
   
   assign bus_size_num_access24 = { r_bus_size24, r_num_access24};
   
//--------------------------------------------------------------------
// Select24 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access24 or write_data24)
  
    begin
       
       casex(bus_size_num_access24)
         
         {`BSIZ_3224,1'bx,1'bx}://    (v_bus_size24 == `BSIZ_3224)
           
           smc_data24 = write_data24;
         
         {`BSIZ_1624,2'h1}:    // r_num_access24 == 1
                      
           begin
              
              smc_data24[31:16] = 16'h0;
              smc_data24[15:0] = write_data24[31:16];
              
           end 
         
         {`BSIZ_1624,1'bx,1'bx}:  // (v_bus_size24 == `BSIZ_1624)  
           
           begin
              
              smc_data24[31:16] = 16'h0;
              smc_data24[15:0]  = write_data24[15:0];
              
           end
         
         {`BSIZ_824,2'h3}:  //  (r_num_access24 == 3)
           
           begin
              
              smc_data24[31:8] = 24'h0;
              smc_data24[7:0] = write_data24[31:24];
           end
         
         {`BSIZ_824,2'h2}:  //   (r_num_access24 == 2)
           
           begin
              
              smc_data24[31:8] = 24'h0;
              smc_data24[7:0] = write_data24[23:16];
              
           end
         
         {`BSIZ_824,2'h1}:  //  (r_num_access24 == 2)
           
           begin
              
              smc_data24[31:8] = 24'h0;
              smc_data24[7:0]  = write_data24[15:8];
              
           end 
         
         {`BSIZ_824,2'h0}:  //  (r_num_access24 == 0) 
           
           begin
              
              smc_data24[31:8] = 24'h0;
              smc_data24[7:0] = write_data24[7:0];
              
           end 
         
         default:
           
           smc_data24 = 32'h0;
         
       endcase // casex(bus_size_num_access24)
       
       
    end
   
endmodule
