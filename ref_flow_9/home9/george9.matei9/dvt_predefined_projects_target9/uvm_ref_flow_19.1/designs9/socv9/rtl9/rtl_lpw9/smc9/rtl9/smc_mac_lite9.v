//File9 name   : smc_mac_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : Multiple9 access controller9.
//            : Static9 Memory Controller9.
//            : The Multiple9 Access Control9 Block keeps9 trace9 of the
//            : number9 of accesses required9 to fulfill9 the
//            : requirements9 of the AHB9 transfer9. The data is
//            : registered when multiple reads are required9. The AHB9
//            : holds9 the data during multiple writes.
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

`include "smc_defs_lite9.v"

module smc_mac_lite9     (

                    //inputs9
                    
                    sys_clk9,
                    n_sys_reset9,
                    valid_access9,
                    xfer_size9,
                    smc_done9,
                    data_smc9,
                    write_data9,
                    smc_nextstate9,
                    latch_data9,
                    
                    //outputs9
                    
                    r_num_access9,
                    mac_done9,
                    v_bus_size9,
                    v_xfer_size9,
                    read_data9,
                    smc_data9);
   
   
   
 


// State9 Machine9// I9/O9

  input                sys_clk9;        // System9 clock9
  input                n_sys_reset9;    // System9 reset (Active9 LOW9)
  input                valid_access9;   // Address cycle of new transfer9
  input  [1:0]         xfer_size9;      // xfer9 size, valid with valid_access9
  input                smc_done9;       // End9 of transfer9
  input  [31:0]        data_smc9;       // External9 read data
  input  [31:0]        write_data9;     // Data from internal bus 
  input  [4:0]         smc_nextstate9;  // State9 Machine9  
  input                latch_data9;     //latch_data9 is used by the MAC9 block    
  
  output [1:0]         r_num_access9;   // Access counter
  output               mac_done9;       // End9 of all transfers9
  output [1:0]         v_bus_size9;     // Registered9 sizes9 for subsequent9
  output [1:0]         v_xfer_size9;    // transfers9 in MAC9 transfer9
  output [31:0]        read_data9;      // Data to internal bus
  output [31:0]        smc_data9;       // Data to external9 bus
  

// Output9 register declarations9

  reg                  mac_done9;       // Indicates9 last cycle of last access
  reg [1:0]            r_num_access9;   // Access counter
  reg [1:0]            num_accesses9;   //number9 of access
  reg [1:0]            r_xfer_size9;    // Store9 size for MAC9 
  reg [1:0]            r_bus_size9;     // Store9 size for MAC9
  reg [31:0]           read_data9;      // Data path to bus IF
  reg [31:0]           r_read_data9;    // Internal data store9
  reg [31:0]           smc_data9;


// Internal Signals9

  reg [1:0]            v_bus_size9;
  reg [1:0]            v_xfer_size9;
  wire [4:0]           smc_nextstate9;    //specifies9 next state
  wire [4:0]           xfer_bus_ldata9;  //concatenation9 of xfer_size9
                                         // and latch_data9  
  wire [3:0]           bus_size_num_access9; //concatenation9 of 
                                              // r_num_access9
  wire [5:0]           wt_ldata_naccs_bsiz9;  //concatenation9 of 
                                            //latch_data9,r_num_access9
 
   


// Main9 Code9

//----------------------------------------------------------------------------
// Store9 transfer9 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk9 or negedge n_sys_reset9)
  
    begin
       
       if (~n_sys_reset9)
         
          r_xfer_size9 <= 2'b00;
       
       
       else if (valid_access9)
         
          r_xfer_size9 <= xfer_size9;
       
       else
         
          r_xfer_size9 <= r_xfer_size9;
       
    end

//--------------------------------------------------------------------
// Store9 bus size generation9
//--------------------------------------------------------------------
  
  always @(posedge sys_clk9 or negedge n_sys_reset9)
    
    begin
       
       if (~n_sys_reset9)
         
          r_bus_size9 <= 2'b00;
       
       
       else if (valid_access9)
         
          r_bus_size9 <= 2'b00;
       
       else
         
          r_bus_size9 <= r_bus_size9;
       
    end
   

//--------------------------------------------------------------------
// Validate9 sizes9 generation9
//--------------------------------------------------------------------

  always @(valid_access9 or r_bus_size9 )

    begin
       
       if (valid_access9)
         
          v_bus_size9 = 2'b0;
       
       else
         
          v_bus_size9 = r_bus_size9;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size9 generation9
//----------------------------------------------------------------------------   

  always @(valid_access9 or r_xfer_size9 or xfer_size9)

    begin
       
       if (valid_access9)
         
          v_xfer_size9 = xfer_size9;
       
       else
         
          v_xfer_size9 = r_xfer_size9;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions9
// Determines9 the number9 of accesses required9 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size9)
  
    begin
       
       if ((xfer_size9[1:0] == `XSIZ_169))
         
          num_accesses9 = 2'h1; // Two9 accesses
       
       else if ( (xfer_size9[1:0] == `XSIZ_329))
         
          num_accesses9 = 2'h3; // Four9 accesses
       
       else
         
          num_accesses9 = 2'h0; // One9 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep9 track9 of the current access number9
//--------------------------------------------------------------------
   
  always @(posedge sys_clk9 or negedge n_sys_reset9)
  
    begin
       
       if (~n_sys_reset9)
         
          r_num_access9 <= 2'b00;
       
       else if (valid_access9)
         
          r_num_access9 <= num_accesses9;
       
       else if (smc_done9 & (smc_nextstate9 != `SMC_STORE9)  &
                      (smc_nextstate9 != `SMC_IDLE9)   )
         
          r_num_access9 <= r_num_access9 - 2'd1;
       
       else
         
          r_num_access9 <= r_num_access9;
       
    end
   
   

//--------------------------------------------------------------------
// Detect9 last access
//--------------------------------------------------------------------
   
   always @(r_num_access9)
     
     begin
        
        if (r_num_access9 == 2'h0)
          
           mac_done9 = 1'b1;
             
        else
          
           mac_done9 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals9 concatenation9 used in case statement9 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz9 = { 1'b0, latch_data9, r_num_access9,
                                  r_bus_size9};
 
   
//--------------------------------------------------------------------
// Store9 Read Data if required9
//--------------------------------------------------------------------

   always @(posedge sys_clk9 or negedge n_sys_reset9)
     
     begin
        
        if (~n_sys_reset9)
          
           r_read_data9 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz9)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data9 <= r_read_data9;
            
            //    latch_data9
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data9[31:24] <= data_smc9[7:0];
                 r_read_data9[23:0] <= 24'h0;
                 
              end
            
            // r_num_access9 =2, v_bus_size9 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data9[23:16] <= data_smc9[7:0];
                 r_read_data9[31:24] <= r_read_data9[31:24];
                 r_read_data9[15:0] <= 16'h0;
                 
              end
            
            // r_num_access9 =1, v_bus_size9 = `XSIZ_169
            
            {1'b0,1'b1,2'h1,`XSIZ_169}:
              
              begin
                 
                 r_read_data9[15:0] <= 16'h0;
                 r_read_data9[31:16] <= data_smc9[15:0];
                 
              end
            
            //  r_num_access9 =1,v_bus_size9 == `XSIZ_89
            
            {1'b0,1'b1,2'h1,`XSIZ_89}:          
              
              begin
                 
                 r_read_data9[15:8] <= data_smc9[7:0];
                 r_read_data9[31:16] <= r_read_data9[31:16];
                 r_read_data9[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access9 = 0, v_bus_size9 == `XSIZ_169
            
            {1'b0,1'b1,2'h0,`XSIZ_169}:  // r_num_access9 =0
              
              
              begin
                 
                 r_read_data9[15:0] <= data_smc9[15:0];
                 r_read_data9[31:16] <= r_read_data9[31:16];
                 
              end
            
            //  r_num_access9 = 0, v_bus_size9 == `XSIZ_89 
            
            {1'b0,1'b1,2'h0,`XSIZ_89}:
              
              begin
                 
                 r_read_data9[7:0] <= data_smc9[7:0];
                 r_read_data9[31:8] <= r_read_data9[31:8];
                 
              end
            
            //  r_num_access9 = 0, v_bus_size9 == `XSIZ_329
            
            {1'b0,1'b1,2'h0,`XSIZ_329}:
              
               r_read_data9[31:0] <= data_smc9[31:0];                      
            
            default :
              
               r_read_data9 <= r_read_data9;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals9 concatenation9 for case statement9 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata9 = {r_xfer_size9,r_bus_size9,latch_data9};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata9 or data_smc9 or r_read_data9 )
       
     begin
        
        casex(xfer_bus_ldata9)
          
          {`XSIZ_329,`BSIZ_329,1'b1} :
            
             read_data9[31:0] = data_smc9[31:0];
          
          {`XSIZ_329,`BSIZ_169,1'b1} :
                              
            begin
               
               read_data9[31:16] = r_read_data9[31:16];
               read_data9[15:0]  = data_smc9[15:0];
               
            end
          
          {`XSIZ_329,`BSIZ_89,1'b1} :
            
            begin
               
               read_data9[31:8] = r_read_data9[31:8];
               read_data9[7:0]  = data_smc9[7:0];
               
            end
          
          {`XSIZ_329,1'bx,1'bx,1'bx} :
            
            read_data9 = r_read_data9;
          
          {`XSIZ_169,`BSIZ_169,1'b1} :
                        
            begin
               
               read_data9[31:16] = data_smc9[15:0];
               read_data9[15:0] = data_smc9[15:0];
               
            end
          
          {`XSIZ_169,`BSIZ_169,1'b0} :  
            
            begin
               
               read_data9[31:16] = r_read_data9[15:0];
               read_data9[15:0] = r_read_data9[15:0];
               
            end
          
          {`XSIZ_169,`BSIZ_329,1'b1} :  
            
            read_data9 = data_smc9;
          
          {`XSIZ_169,`BSIZ_89,1'b1} : 
                        
            begin
               
               read_data9[31:24] = r_read_data9[15:8];
               read_data9[23:16] = data_smc9[7:0];
               read_data9[15:8] = r_read_data9[15:8];
               read_data9[7:0] = data_smc9[7:0];
            end
          
          {`XSIZ_169,`BSIZ_89,1'b0} : 
            
            begin
               
               read_data9[31:16] = r_read_data9[15:0];
               read_data9[15:0] = r_read_data9[15:0];
               
            end
          
          {`XSIZ_169,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data9[31:16] = r_read_data9[31:16];
               read_data9[15:0] = r_read_data9[15:0];
               
            end
          
          {`XSIZ_89,`BSIZ_169,1'b1} :
            
            begin
               
               read_data9[31:16] = data_smc9[15:0];
               read_data9[15:0] = data_smc9[15:0];
               
            end
          
          {`XSIZ_89,`BSIZ_169,1'b0} :
            
            begin
               
               read_data9[31:16] = r_read_data9[15:0];
               read_data9[15:0]  = r_read_data9[15:0];
               
            end
          
          {`XSIZ_89,`BSIZ_329,1'b1} :   
            
            read_data9 = data_smc9;
          
          {`XSIZ_89,`BSIZ_329,1'b0} :              
                        
                        read_data9 = r_read_data9;
          
          {`XSIZ_89,`BSIZ_89,1'b1} :   
                                    
            begin
               
               read_data9[31:24] = data_smc9[7:0];
               read_data9[23:16] = data_smc9[7:0];
               read_data9[15:8]  = data_smc9[7:0];
               read_data9[7:0]   = data_smc9[7:0];
               
            end
          
          default:
            
            begin
               
               read_data9[31:24] = r_read_data9[7:0];
               read_data9[23:16] = r_read_data9[7:0];
               read_data9[15:8]  = r_read_data9[7:0];
               read_data9[7:0]   = r_read_data9[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata9)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal9 concatenation9 for use in case statement9
//----------------------------------------------------------------------------
   
   assign bus_size_num_access9 = { r_bus_size9, r_num_access9};
   
//--------------------------------------------------------------------
// Select9 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access9 or write_data9)
  
    begin
       
       casex(bus_size_num_access9)
         
         {`BSIZ_329,1'bx,1'bx}://    (v_bus_size9 == `BSIZ_329)
           
           smc_data9 = write_data9;
         
         {`BSIZ_169,2'h1}:    // r_num_access9 == 1
                      
           begin
              
              smc_data9[31:16] = 16'h0;
              smc_data9[15:0] = write_data9[31:16];
              
           end 
         
         {`BSIZ_169,1'bx,1'bx}:  // (v_bus_size9 == `BSIZ_169)  
           
           begin
              
              smc_data9[31:16] = 16'h0;
              smc_data9[15:0]  = write_data9[15:0];
              
           end
         
         {`BSIZ_89,2'h3}:  //  (r_num_access9 == 3)
           
           begin
              
              smc_data9[31:8] = 24'h0;
              smc_data9[7:0] = write_data9[31:24];
           end
         
         {`BSIZ_89,2'h2}:  //   (r_num_access9 == 2)
           
           begin
              
              smc_data9[31:8] = 24'h0;
              smc_data9[7:0] = write_data9[23:16];
              
           end
         
         {`BSIZ_89,2'h1}:  //  (r_num_access9 == 2)
           
           begin
              
              smc_data9[31:8] = 24'h0;
              smc_data9[7:0]  = write_data9[15:8];
              
           end 
         
         {`BSIZ_89,2'h0}:  //  (r_num_access9 == 0) 
           
           begin
              
              smc_data9[31:8] = 24'h0;
              smc_data9[7:0] = write_data9[7:0];
              
           end 
         
         default:
           
           smc_data9 = 32'h0;
         
       endcase // casex(bus_size_num_access9)
       
       
    end
   
endmodule
