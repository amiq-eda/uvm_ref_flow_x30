//File2 name   : smc_mac_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : Multiple2 access controller2.
//            : Static2 Memory Controller2.
//            : The Multiple2 Access Control2 Block keeps2 trace2 of the
//            : number2 of accesses required2 to fulfill2 the
//            : requirements2 of the AHB2 transfer2. The data is
//            : registered when multiple reads are required2. The AHB2
//            : holds2 the data during multiple writes.
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

`include "smc_defs_lite2.v"

module smc_mac_lite2     (

                    //inputs2
                    
                    sys_clk2,
                    n_sys_reset2,
                    valid_access2,
                    xfer_size2,
                    smc_done2,
                    data_smc2,
                    write_data2,
                    smc_nextstate2,
                    latch_data2,
                    
                    //outputs2
                    
                    r_num_access2,
                    mac_done2,
                    v_bus_size2,
                    v_xfer_size2,
                    read_data2,
                    smc_data2);
   
   
   
 


// State2 Machine2// I2/O2

  input                sys_clk2;        // System2 clock2
  input                n_sys_reset2;    // System2 reset (Active2 LOW2)
  input                valid_access2;   // Address cycle of new transfer2
  input  [1:0]         xfer_size2;      // xfer2 size, valid with valid_access2
  input                smc_done2;       // End2 of transfer2
  input  [31:0]        data_smc2;       // External2 read data
  input  [31:0]        write_data2;     // Data from internal bus 
  input  [4:0]         smc_nextstate2;  // State2 Machine2  
  input                latch_data2;     //latch_data2 is used by the MAC2 block    
  
  output [1:0]         r_num_access2;   // Access counter
  output               mac_done2;       // End2 of all transfers2
  output [1:0]         v_bus_size2;     // Registered2 sizes2 for subsequent2
  output [1:0]         v_xfer_size2;    // transfers2 in MAC2 transfer2
  output [31:0]        read_data2;      // Data to internal bus
  output [31:0]        smc_data2;       // Data to external2 bus
  

// Output2 register declarations2

  reg                  mac_done2;       // Indicates2 last cycle of last access
  reg [1:0]            r_num_access2;   // Access counter
  reg [1:0]            num_accesses2;   //number2 of access
  reg [1:0]            r_xfer_size2;    // Store2 size for MAC2 
  reg [1:0]            r_bus_size2;     // Store2 size for MAC2
  reg [31:0]           read_data2;      // Data path to bus IF
  reg [31:0]           r_read_data2;    // Internal data store2
  reg [31:0]           smc_data2;


// Internal Signals2

  reg [1:0]            v_bus_size2;
  reg [1:0]            v_xfer_size2;
  wire [4:0]           smc_nextstate2;    //specifies2 next state
  wire [4:0]           xfer_bus_ldata2;  //concatenation2 of xfer_size2
                                         // and latch_data2  
  wire [3:0]           bus_size_num_access2; //concatenation2 of 
                                              // r_num_access2
  wire [5:0]           wt_ldata_naccs_bsiz2;  //concatenation2 of 
                                            //latch_data2,r_num_access2
 
   


// Main2 Code2

//----------------------------------------------------------------------------
// Store2 transfer2 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk2 or negedge n_sys_reset2)
  
    begin
       
       if (~n_sys_reset2)
         
          r_xfer_size2 <= 2'b00;
       
       
       else if (valid_access2)
         
          r_xfer_size2 <= xfer_size2;
       
       else
         
          r_xfer_size2 <= r_xfer_size2;
       
    end

//--------------------------------------------------------------------
// Store2 bus size generation2
//--------------------------------------------------------------------
  
  always @(posedge sys_clk2 or negedge n_sys_reset2)
    
    begin
       
       if (~n_sys_reset2)
         
          r_bus_size2 <= 2'b00;
       
       
       else if (valid_access2)
         
          r_bus_size2 <= 2'b00;
       
       else
         
          r_bus_size2 <= r_bus_size2;
       
    end
   

//--------------------------------------------------------------------
// Validate2 sizes2 generation2
//--------------------------------------------------------------------

  always @(valid_access2 or r_bus_size2 )

    begin
       
       if (valid_access2)
         
          v_bus_size2 = 2'b0;
       
       else
         
          v_bus_size2 = r_bus_size2;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size2 generation2
//----------------------------------------------------------------------------   

  always @(valid_access2 or r_xfer_size2 or xfer_size2)

    begin
       
       if (valid_access2)
         
          v_xfer_size2 = xfer_size2;
       
       else
         
          v_xfer_size2 = r_xfer_size2;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions2
// Determines2 the number2 of accesses required2 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size2)
  
    begin
       
       if ((xfer_size2[1:0] == `XSIZ_162))
         
          num_accesses2 = 2'h1; // Two2 accesses
       
       else if ( (xfer_size2[1:0] == `XSIZ_322))
         
          num_accesses2 = 2'h3; // Four2 accesses
       
       else
         
          num_accesses2 = 2'h0; // One2 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep2 track2 of the current access number2
//--------------------------------------------------------------------
   
  always @(posedge sys_clk2 or negedge n_sys_reset2)
  
    begin
       
       if (~n_sys_reset2)
         
          r_num_access2 <= 2'b00;
       
       else if (valid_access2)
         
          r_num_access2 <= num_accesses2;
       
       else if (smc_done2 & (smc_nextstate2 != `SMC_STORE2)  &
                      (smc_nextstate2 != `SMC_IDLE2)   )
         
          r_num_access2 <= r_num_access2 - 2'd1;
       
       else
         
          r_num_access2 <= r_num_access2;
       
    end
   
   

//--------------------------------------------------------------------
// Detect2 last access
//--------------------------------------------------------------------
   
   always @(r_num_access2)
     
     begin
        
        if (r_num_access2 == 2'h0)
          
           mac_done2 = 1'b1;
             
        else
          
           mac_done2 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals2 concatenation2 used in case statement2 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz2 = { 1'b0, latch_data2, r_num_access2,
                                  r_bus_size2};
 
   
//--------------------------------------------------------------------
// Store2 Read Data if required2
//--------------------------------------------------------------------

   always @(posedge sys_clk2 or negedge n_sys_reset2)
     
     begin
        
        if (~n_sys_reset2)
          
           r_read_data2 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz2)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data2 <= r_read_data2;
            
            //    latch_data2
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data2[31:24] <= data_smc2[7:0];
                 r_read_data2[23:0] <= 24'h0;
                 
              end
            
            // r_num_access2 =2, v_bus_size2 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data2[23:16] <= data_smc2[7:0];
                 r_read_data2[31:24] <= r_read_data2[31:24];
                 r_read_data2[15:0] <= 16'h0;
                 
              end
            
            // r_num_access2 =1, v_bus_size2 = `XSIZ_162
            
            {1'b0,1'b1,2'h1,`XSIZ_162}:
              
              begin
                 
                 r_read_data2[15:0] <= 16'h0;
                 r_read_data2[31:16] <= data_smc2[15:0];
                 
              end
            
            //  r_num_access2 =1,v_bus_size2 == `XSIZ_82
            
            {1'b0,1'b1,2'h1,`XSIZ_82}:          
              
              begin
                 
                 r_read_data2[15:8] <= data_smc2[7:0];
                 r_read_data2[31:16] <= r_read_data2[31:16];
                 r_read_data2[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access2 = 0, v_bus_size2 == `XSIZ_162
            
            {1'b0,1'b1,2'h0,`XSIZ_162}:  // r_num_access2 =0
              
              
              begin
                 
                 r_read_data2[15:0] <= data_smc2[15:0];
                 r_read_data2[31:16] <= r_read_data2[31:16];
                 
              end
            
            //  r_num_access2 = 0, v_bus_size2 == `XSIZ_82 
            
            {1'b0,1'b1,2'h0,`XSIZ_82}:
              
              begin
                 
                 r_read_data2[7:0] <= data_smc2[7:0];
                 r_read_data2[31:8] <= r_read_data2[31:8];
                 
              end
            
            //  r_num_access2 = 0, v_bus_size2 == `XSIZ_322
            
            {1'b0,1'b1,2'h0,`XSIZ_322}:
              
               r_read_data2[31:0] <= data_smc2[31:0];                      
            
            default :
              
               r_read_data2 <= r_read_data2;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals2 concatenation2 for case statement2 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata2 = {r_xfer_size2,r_bus_size2,latch_data2};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata2 or data_smc2 or r_read_data2 )
       
     begin
        
        casex(xfer_bus_ldata2)
          
          {`XSIZ_322,`BSIZ_322,1'b1} :
            
             read_data2[31:0] = data_smc2[31:0];
          
          {`XSIZ_322,`BSIZ_162,1'b1} :
                              
            begin
               
               read_data2[31:16] = r_read_data2[31:16];
               read_data2[15:0]  = data_smc2[15:0];
               
            end
          
          {`XSIZ_322,`BSIZ_82,1'b1} :
            
            begin
               
               read_data2[31:8] = r_read_data2[31:8];
               read_data2[7:0]  = data_smc2[7:0];
               
            end
          
          {`XSIZ_322,1'bx,1'bx,1'bx} :
            
            read_data2 = r_read_data2;
          
          {`XSIZ_162,`BSIZ_162,1'b1} :
                        
            begin
               
               read_data2[31:16] = data_smc2[15:0];
               read_data2[15:0] = data_smc2[15:0];
               
            end
          
          {`XSIZ_162,`BSIZ_162,1'b0} :  
            
            begin
               
               read_data2[31:16] = r_read_data2[15:0];
               read_data2[15:0] = r_read_data2[15:0];
               
            end
          
          {`XSIZ_162,`BSIZ_322,1'b1} :  
            
            read_data2 = data_smc2;
          
          {`XSIZ_162,`BSIZ_82,1'b1} : 
                        
            begin
               
               read_data2[31:24] = r_read_data2[15:8];
               read_data2[23:16] = data_smc2[7:0];
               read_data2[15:8] = r_read_data2[15:8];
               read_data2[7:0] = data_smc2[7:0];
            end
          
          {`XSIZ_162,`BSIZ_82,1'b0} : 
            
            begin
               
               read_data2[31:16] = r_read_data2[15:0];
               read_data2[15:0] = r_read_data2[15:0];
               
            end
          
          {`XSIZ_162,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data2[31:16] = r_read_data2[31:16];
               read_data2[15:0] = r_read_data2[15:0];
               
            end
          
          {`XSIZ_82,`BSIZ_162,1'b1} :
            
            begin
               
               read_data2[31:16] = data_smc2[15:0];
               read_data2[15:0] = data_smc2[15:0];
               
            end
          
          {`XSIZ_82,`BSIZ_162,1'b0} :
            
            begin
               
               read_data2[31:16] = r_read_data2[15:0];
               read_data2[15:0]  = r_read_data2[15:0];
               
            end
          
          {`XSIZ_82,`BSIZ_322,1'b1} :   
            
            read_data2 = data_smc2;
          
          {`XSIZ_82,`BSIZ_322,1'b0} :              
                        
                        read_data2 = r_read_data2;
          
          {`XSIZ_82,`BSIZ_82,1'b1} :   
                                    
            begin
               
               read_data2[31:24] = data_smc2[7:0];
               read_data2[23:16] = data_smc2[7:0];
               read_data2[15:8]  = data_smc2[7:0];
               read_data2[7:0]   = data_smc2[7:0];
               
            end
          
          default:
            
            begin
               
               read_data2[31:24] = r_read_data2[7:0];
               read_data2[23:16] = r_read_data2[7:0];
               read_data2[15:8]  = r_read_data2[7:0];
               read_data2[7:0]   = r_read_data2[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata2)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal2 concatenation2 for use in case statement2
//----------------------------------------------------------------------------
   
   assign bus_size_num_access2 = { r_bus_size2, r_num_access2};
   
//--------------------------------------------------------------------
// Select2 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access2 or write_data2)
  
    begin
       
       casex(bus_size_num_access2)
         
         {`BSIZ_322,1'bx,1'bx}://    (v_bus_size2 == `BSIZ_322)
           
           smc_data2 = write_data2;
         
         {`BSIZ_162,2'h1}:    // r_num_access2 == 1
                      
           begin
              
              smc_data2[31:16] = 16'h0;
              smc_data2[15:0] = write_data2[31:16];
              
           end 
         
         {`BSIZ_162,1'bx,1'bx}:  // (v_bus_size2 == `BSIZ_162)  
           
           begin
              
              smc_data2[31:16] = 16'h0;
              smc_data2[15:0]  = write_data2[15:0];
              
           end
         
         {`BSIZ_82,2'h3}:  //  (r_num_access2 == 3)
           
           begin
              
              smc_data2[31:8] = 24'h0;
              smc_data2[7:0] = write_data2[31:24];
           end
         
         {`BSIZ_82,2'h2}:  //   (r_num_access2 == 2)
           
           begin
              
              smc_data2[31:8] = 24'h0;
              smc_data2[7:0] = write_data2[23:16];
              
           end
         
         {`BSIZ_82,2'h1}:  //  (r_num_access2 == 2)
           
           begin
              
              smc_data2[31:8] = 24'h0;
              smc_data2[7:0]  = write_data2[15:8];
              
           end 
         
         {`BSIZ_82,2'h0}:  //  (r_num_access2 == 0) 
           
           begin
              
              smc_data2[31:8] = 24'h0;
              smc_data2[7:0] = write_data2[7:0];
              
           end 
         
         default:
           
           smc_data2 = 32'h0;
         
       endcase // casex(bus_size_num_access2)
       
       
    end
   
endmodule
