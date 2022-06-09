//File1 name   : smc_mac_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : Multiple1 access controller1.
//            : Static1 Memory Controller1.
//            : The Multiple1 Access Control1 Block keeps1 trace1 of the
//            : number1 of accesses required1 to fulfill1 the
//            : requirements1 of the AHB1 transfer1. The data is
//            : registered when multiple reads are required1. The AHB1
//            : holds1 the data during multiple writes.
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

`include "smc_defs_lite1.v"

module smc_mac_lite1     (

                    //inputs1
                    
                    sys_clk1,
                    n_sys_reset1,
                    valid_access1,
                    xfer_size1,
                    smc_done1,
                    data_smc1,
                    write_data1,
                    smc_nextstate1,
                    latch_data1,
                    
                    //outputs1
                    
                    r_num_access1,
                    mac_done1,
                    v_bus_size1,
                    v_xfer_size1,
                    read_data1,
                    smc_data1);
   
   
   
 


// State1 Machine1// I1/O1

  input                sys_clk1;        // System1 clock1
  input                n_sys_reset1;    // System1 reset (Active1 LOW1)
  input                valid_access1;   // Address cycle of new transfer1
  input  [1:0]         xfer_size1;      // xfer1 size, valid with valid_access1
  input                smc_done1;       // End1 of transfer1
  input  [31:0]        data_smc1;       // External1 read data
  input  [31:0]        write_data1;     // Data from internal bus 
  input  [4:0]         smc_nextstate1;  // State1 Machine1  
  input                latch_data1;     //latch_data1 is used by the MAC1 block    
  
  output [1:0]         r_num_access1;   // Access counter
  output               mac_done1;       // End1 of all transfers1
  output [1:0]         v_bus_size1;     // Registered1 sizes1 for subsequent1
  output [1:0]         v_xfer_size1;    // transfers1 in MAC1 transfer1
  output [31:0]        read_data1;      // Data to internal bus
  output [31:0]        smc_data1;       // Data to external1 bus
  

// Output1 register declarations1

  reg                  mac_done1;       // Indicates1 last cycle of last access
  reg [1:0]            r_num_access1;   // Access counter
  reg [1:0]            num_accesses1;   //number1 of access
  reg [1:0]            r_xfer_size1;    // Store1 size for MAC1 
  reg [1:0]            r_bus_size1;     // Store1 size for MAC1
  reg [31:0]           read_data1;      // Data path to bus IF
  reg [31:0]           r_read_data1;    // Internal data store1
  reg [31:0]           smc_data1;


// Internal Signals1

  reg [1:0]            v_bus_size1;
  reg [1:0]            v_xfer_size1;
  wire [4:0]           smc_nextstate1;    //specifies1 next state
  wire [4:0]           xfer_bus_ldata1;  //concatenation1 of xfer_size1
                                         // and latch_data1  
  wire [3:0]           bus_size_num_access1; //concatenation1 of 
                                              // r_num_access1
  wire [5:0]           wt_ldata_naccs_bsiz1;  //concatenation1 of 
                                            //latch_data1,r_num_access1
 
   


// Main1 Code1

//----------------------------------------------------------------------------
// Store1 transfer1 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk1 or negedge n_sys_reset1)
  
    begin
       
       if (~n_sys_reset1)
         
          r_xfer_size1 <= 2'b00;
       
       
       else if (valid_access1)
         
          r_xfer_size1 <= xfer_size1;
       
       else
         
          r_xfer_size1 <= r_xfer_size1;
       
    end

//--------------------------------------------------------------------
// Store1 bus size generation1
//--------------------------------------------------------------------
  
  always @(posedge sys_clk1 or negedge n_sys_reset1)
    
    begin
       
       if (~n_sys_reset1)
         
          r_bus_size1 <= 2'b00;
       
       
       else if (valid_access1)
         
          r_bus_size1 <= 2'b00;
       
       else
         
          r_bus_size1 <= r_bus_size1;
       
    end
   

//--------------------------------------------------------------------
// Validate1 sizes1 generation1
//--------------------------------------------------------------------

  always @(valid_access1 or r_bus_size1 )

    begin
       
       if (valid_access1)
         
          v_bus_size1 = 2'b0;
       
       else
         
          v_bus_size1 = r_bus_size1;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size1 generation1
//----------------------------------------------------------------------------   

  always @(valid_access1 or r_xfer_size1 or xfer_size1)

    begin
       
       if (valid_access1)
         
          v_xfer_size1 = xfer_size1;
       
       else
         
          v_xfer_size1 = r_xfer_size1;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions1
// Determines1 the number1 of accesses required1 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size1)
  
    begin
       
       if ((xfer_size1[1:0] == `XSIZ_161))
         
          num_accesses1 = 2'h1; // Two1 accesses
       
       else if ( (xfer_size1[1:0] == `XSIZ_321))
         
          num_accesses1 = 2'h3; // Four1 accesses
       
       else
         
          num_accesses1 = 2'h0; // One1 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep1 track1 of the current access number1
//--------------------------------------------------------------------
   
  always @(posedge sys_clk1 or negedge n_sys_reset1)
  
    begin
       
       if (~n_sys_reset1)
         
          r_num_access1 <= 2'b00;
       
       else if (valid_access1)
         
          r_num_access1 <= num_accesses1;
       
       else if (smc_done1 & (smc_nextstate1 != `SMC_STORE1)  &
                      (smc_nextstate1 != `SMC_IDLE1)   )
         
          r_num_access1 <= r_num_access1 - 2'd1;
       
       else
         
          r_num_access1 <= r_num_access1;
       
    end
   
   

//--------------------------------------------------------------------
// Detect1 last access
//--------------------------------------------------------------------
   
   always @(r_num_access1)
     
     begin
        
        if (r_num_access1 == 2'h0)
          
           mac_done1 = 1'b1;
             
        else
          
           mac_done1 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals1 concatenation1 used in case statement1 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz1 = { 1'b0, latch_data1, r_num_access1,
                                  r_bus_size1};
 
   
//--------------------------------------------------------------------
// Store1 Read Data if required1
//--------------------------------------------------------------------

   always @(posedge sys_clk1 or negedge n_sys_reset1)
     
     begin
        
        if (~n_sys_reset1)
          
           r_read_data1 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz1)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data1 <= r_read_data1;
            
            //    latch_data1
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data1[31:24] <= data_smc1[7:0];
                 r_read_data1[23:0] <= 24'h0;
                 
              end
            
            // r_num_access1 =2, v_bus_size1 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data1[23:16] <= data_smc1[7:0];
                 r_read_data1[31:24] <= r_read_data1[31:24];
                 r_read_data1[15:0] <= 16'h0;
                 
              end
            
            // r_num_access1 =1, v_bus_size1 = `XSIZ_161
            
            {1'b0,1'b1,2'h1,`XSIZ_161}:
              
              begin
                 
                 r_read_data1[15:0] <= 16'h0;
                 r_read_data1[31:16] <= data_smc1[15:0];
                 
              end
            
            //  r_num_access1 =1,v_bus_size1 == `XSIZ_81
            
            {1'b0,1'b1,2'h1,`XSIZ_81}:          
              
              begin
                 
                 r_read_data1[15:8] <= data_smc1[7:0];
                 r_read_data1[31:16] <= r_read_data1[31:16];
                 r_read_data1[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access1 = 0, v_bus_size1 == `XSIZ_161
            
            {1'b0,1'b1,2'h0,`XSIZ_161}:  // r_num_access1 =0
              
              
              begin
                 
                 r_read_data1[15:0] <= data_smc1[15:0];
                 r_read_data1[31:16] <= r_read_data1[31:16];
                 
              end
            
            //  r_num_access1 = 0, v_bus_size1 == `XSIZ_81 
            
            {1'b0,1'b1,2'h0,`XSIZ_81}:
              
              begin
                 
                 r_read_data1[7:0] <= data_smc1[7:0];
                 r_read_data1[31:8] <= r_read_data1[31:8];
                 
              end
            
            //  r_num_access1 = 0, v_bus_size1 == `XSIZ_321
            
            {1'b0,1'b1,2'h0,`XSIZ_321}:
              
               r_read_data1[31:0] <= data_smc1[31:0];                      
            
            default :
              
               r_read_data1 <= r_read_data1;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals1 concatenation1 for case statement1 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata1 = {r_xfer_size1,r_bus_size1,latch_data1};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata1 or data_smc1 or r_read_data1 )
       
     begin
        
        casex(xfer_bus_ldata1)
          
          {`XSIZ_321,`BSIZ_321,1'b1} :
            
             read_data1[31:0] = data_smc1[31:0];
          
          {`XSIZ_321,`BSIZ_161,1'b1} :
                              
            begin
               
               read_data1[31:16] = r_read_data1[31:16];
               read_data1[15:0]  = data_smc1[15:0];
               
            end
          
          {`XSIZ_321,`BSIZ_81,1'b1} :
            
            begin
               
               read_data1[31:8] = r_read_data1[31:8];
               read_data1[7:0]  = data_smc1[7:0];
               
            end
          
          {`XSIZ_321,1'bx,1'bx,1'bx} :
            
            read_data1 = r_read_data1;
          
          {`XSIZ_161,`BSIZ_161,1'b1} :
                        
            begin
               
               read_data1[31:16] = data_smc1[15:0];
               read_data1[15:0] = data_smc1[15:0];
               
            end
          
          {`XSIZ_161,`BSIZ_161,1'b0} :  
            
            begin
               
               read_data1[31:16] = r_read_data1[15:0];
               read_data1[15:0] = r_read_data1[15:0];
               
            end
          
          {`XSIZ_161,`BSIZ_321,1'b1} :  
            
            read_data1 = data_smc1;
          
          {`XSIZ_161,`BSIZ_81,1'b1} : 
                        
            begin
               
               read_data1[31:24] = r_read_data1[15:8];
               read_data1[23:16] = data_smc1[7:0];
               read_data1[15:8] = r_read_data1[15:8];
               read_data1[7:0] = data_smc1[7:0];
            end
          
          {`XSIZ_161,`BSIZ_81,1'b0} : 
            
            begin
               
               read_data1[31:16] = r_read_data1[15:0];
               read_data1[15:0] = r_read_data1[15:0];
               
            end
          
          {`XSIZ_161,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data1[31:16] = r_read_data1[31:16];
               read_data1[15:0] = r_read_data1[15:0];
               
            end
          
          {`XSIZ_81,`BSIZ_161,1'b1} :
            
            begin
               
               read_data1[31:16] = data_smc1[15:0];
               read_data1[15:0] = data_smc1[15:0];
               
            end
          
          {`XSIZ_81,`BSIZ_161,1'b0} :
            
            begin
               
               read_data1[31:16] = r_read_data1[15:0];
               read_data1[15:0]  = r_read_data1[15:0];
               
            end
          
          {`XSIZ_81,`BSIZ_321,1'b1} :   
            
            read_data1 = data_smc1;
          
          {`XSIZ_81,`BSIZ_321,1'b0} :              
                        
                        read_data1 = r_read_data1;
          
          {`XSIZ_81,`BSIZ_81,1'b1} :   
                                    
            begin
               
               read_data1[31:24] = data_smc1[7:0];
               read_data1[23:16] = data_smc1[7:0];
               read_data1[15:8]  = data_smc1[7:0];
               read_data1[7:0]   = data_smc1[7:0];
               
            end
          
          default:
            
            begin
               
               read_data1[31:24] = r_read_data1[7:0];
               read_data1[23:16] = r_read_data1[7:0];
               read_data1[15:8]  = r_read_data1[7:0];
               read_data1[7:0]   = r_read_data1[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata1)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal1 concatenation1 for use in case statement1
//----------------------------------------------------------------------------
   
   assign bus_size_num_access1 = { r_bus_size1, r_num_access1};
   
//--------------------------------------------------------------------
// Select1 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access1 or write_data1)
  
    begin
       
       casex(bus_size_num_access1)
         
         {`BSIZ_321,1'bx,1'bx}://    (v_bus_size1 == `BSIZ_321)
           
           smc_data1 = write_data1;
         
         {`BSIZ_161,2'h1}:    // r_num_access1 == 1
                      
           begin
              
              smc_data1[31:16] = 16'h0;
              smc_data1[15:0] = write_data1[31:16];
              
           end 
         
         {`BSIZ_161,1'bx,1'bx}:  // (v_bus_size1 == `BSIZ_161)  
           
           begin
              
              smc_data1[31:16] = 16'h0;
              smc_data1[15:0]  = write_data1[15:0];
              
           end
         
         {`BSIZ_81,2'h3}:  //  (r_num_access1 == 3)
           
           begin
              
              smc_data1[31:8] = 24'h0;
              smc_data1[7:0] = write_data1[31:24];
           end
         
         {`BSIZ_81,2'h2}:  //   (r_num_access1 == 2)
           
           begin
              
              smc_data1[31:8] = 24'h0;
              smc_data1[7:0] = write_data1[23:16];
              
           end
         
         {`BSIZ_81,2'h1}:  //  (r_num_access1 == 2)
           
           begin
              
              smc_data1[31:8] = 24'h0;
              smc_data1[7:0]  = write_data1[15:8];
              
           end 
         
         {`BSIZ_81,2'h0}:  //  (r_num_access1 == 0) 
           
           begin
              
              smc_data1[31:8] = 24'h0;
              smc_data1[7:0] = write_data1[7:0];
              
           end 
         
         default:
           
           smc_data1 = 32'h0;
         
       endcase // casex(bus_size_num_access1)
       
       
    end
   
endmodule
