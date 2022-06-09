//File21 name   : smc_mac_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : Multiple21 access controller21.
//            : Static21 Memory Controller21.
//            : The Multiple21 Access Control21 Block keeps21 trace21 of the
//            : number21 of accesses required21 to fulfill21 the
//            : requirements21 of the AHB21 transfer21. The data is
//            : registered when multiple reads are required21. The AHB21
//            : holds21 the data during multiple writes.
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

`include "smc_defs_lite21.v"

module smc_mac_lite21     (

                    //inputs21
                    
                    sys_clk21,
                    n_sys_reset21,
                    valid_access21,
                    xfer_size21,
                    smc_done21,
                    data_smc21,
                    write_data21,
                    smc_nextstate21,
                    latch_data21,
                    
                    //outputs21
                    
                    r_num_access21,
                    mac_done21,
                    v_bus_size21,
                    v_xfer_size21,
                    read_data21,
                    smc_data21);
   
   
   
 


// State21 Machine21// I21/O21

  input                sys_clk21;        // System21 clock21
  input                n_sys_reset21;    // System21 reset (Active21 LOW21)
  input                valid_access21;   // Address cycle of new transfer21
  input  [1:0]         xfer_size21;      // xfer21 size, valid with valid_access21
  input                smc_done21;       // End21 of transfer21
  input  [31:0]        data_smc21;       // External21 read data
  input  [31:0]        write_data21;     // Data from internal bus 
  input  [4:0]         smc_nextstate21;  // State21 Machine21  
  input                latch_data21;     //latch_data21 is used by the MAC21 block    
  
  output [1:0]         r_num_access21;   // Access counter
  output               mac_done21;       // End21 of all transfers21
  output [1:0]         v_bus_size21;     // Registered21 sizes21 for subsequent21
  output [1:0]         v_xfer_size21;    // transfers21 in MAC21 transfer21
  output [31:0]        read_data21;      // Data to internal bus
  output [31:0]        smc_data21;       // Data to external21 bus
  

// Output21 register declarations21

  reg                  mac_done21;       // Indicates21 last cycle of last access
  reg [1:0]            r_num_access21;   // Access counter
  reg [1:0]            num_accesses21;   //number21 of access
  reg [1:0]            r_xfer_size21;    // Store21 size for MAC21 
  reg [1:0]            r_bus_size21;     // Store21 size for MAC21
  reg [31:0]           read_data21;      // Data path to bus IF
  reg [31:0]           r_read_data21;    // Internal data store21
  reg [31:0]           smc_data21;


// Internal Signals21

  reg [1:0]            v_bus_size21;
  reg [1:0]            v_xfer_size21;
  wire [4:0]           smc_nextstate21;    //specifies21 next state
  wire [4:0]           xfer_bus_ldata21;  //concatenation21 of xfer_size21
                                         // and latch_data21  
  wire [3:0]           bus_size_num_access21; //concatenation21 of 
                                              // r_num_access21
  wire [5:0]           wt_ldata_naccs_bsiz21;  //concatenation21 of 
                                            //latch_data21,r_num_access21
 
   


// Main21 Code21

//----------------------------------------------------------------------------
// Store21 transfer21 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk21 or negedge n_sys_reset21)
  
    begin
       
       if (~n_sys_reset21)
         
          r_xfer_size21 <= 2'b00;
       
       
       else if (valid_access21)
         
          r_xfer_size21 <= xfer_size21;
       
       else
         
          r_xfer_size21 <= r_xfer_size21;
       
    end

//--------------------------------------------------------------------
// Store21 bus size generation21
//--------------------------------------------------------------------
  
  always @(posedge sys_clk21 or negedge n_sys_reset21)
    
    begin
       
       if (~n_sys_reset21)
         
          r_bus_size21 <= 2'b00;
       
       
       else if (valid_access21)
         
          r_bus_size21 <= 2'b00;
       
       else
         
          r_bus_size21 <= r_bus_size21;
       
    end
   

//--------------------------------------------------------------------
// Validate21 sizes21 generation21
//--------------------------------------------------------------------

  always @(valid_access21 or r_bus_size21 )

    begin
       
       if (valid_access21)
         
          v_bus_size21 = 2'b0;
       
       else
         
          v_bus_size21 = r_bus_size21;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size21 generation21
//----------------------------------------------------------------------------   

  always @(valid_access21 or r_xfer_size21 or xfer_size21)

    begin
       
       if (valid_access21)
         
          v_xfer_size21 = xfer_size21;
       
       else
         
          v_xfer_size21 = r_xfer_size21;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions21
// Determines21 the number21 of accesses required21 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size21)
  
    begin
       
       if ((xfer_size21[1:0] == `XSIZ_1621))
         
          num_accesses21 = 2'h1; // Two21 accesses
       
       else if ( (xfer_size21[1:0] == `XSIZ_3221))
         
          num_accesses21 = 2'h3; // Four21 accesses
       
       else
         
          num_accesses21 = 2'h0; // One21 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep21 track21 of the current access number21
//--------------------------------------------------------------------
   
  always @(posedge sys_clk21 or negedge n_sys_reset21)
  
    begin
       
       if (~n_sys_reset21)
         
          r_num_access21 <= 2'b00;
       
       else if (valid_access21)
         
          r_num_access21 <= num_accesses21;
       
       else if (smc_done21 & (smc_nextstate21 != `SMC_STORE21)  &
                      (smc_nextstate21 != `SMC_IDLE21)   )
         
          r_num_access21 <= r_num_access21 - 2'd1;
       
       else
         
          r_num_access21 <= r_num_access21;
       
    end
   
   

//--------------------------------------------------------------------
// Detect21 last access
//--------------------------------------------------------------------
   
   always @(r_num_access21)
     
     begin
        
        if (r_num_access21 == 2'h0)
          
           mac_done21 = 1'b1;
             
        else
          
           mac_done21 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals21 concatenation21 used in case statement21 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz21 = { 1'b0, latch_data21, r_num_access21,
                                  r_bus_size21};
 
   
//--------------------------------------------------------------------
// Store21 Read Data if required21
//--------------------------------------------------------------------

   always @(posedge sys_clk21 or negedge n_sys_reset21)
     
     begin
        
        if (~n_sys_reset21)
          
           r_read_data21 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz21)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data21 <= r_read_data21;
            
            //    latch_data21
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data21[31:24] <= data_smc21[7:0];
                 r_read_data21[23:0] <= 24'h0;
                 
              end
            
            // r_num_access21 =2, v_bus_size21 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data21[23:16] <= data_smc21[7:0];
                 r_read_data21[31:24] <= r_read_data21[31:24];
                 r_read_data21[15:0] <= 16'h0;
                 
              end
            
            // r_num_access21 =1, v_bus_size21 = `XSIZ_1621
            
            {1'b0,1'b1,2'h1,`XSIZ_1621}:
              
              begin
                 
                 r_read_data21[15:0] <= 16'h0;
                 r_read_data21[31:16] <= data_smc21[15:0];
                 
              end
            
            //  r_num_access21 =1,v_bus_size21 == `XSIZ_821
            
            {1'b0,1'b1,2'h1,`XSIZ_821}:          
              
              begin
                 
                 r_read_data21[15:8] <= data_smc21[7:0];
                 r_read_data21[31:16] <= r_read_data21[31:16];
                 r_read_data21[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access21 = 0, v_bus_size21 == `XSIZ_1621
            
            {1'b0,1'b1,2'h0,`XSIZ_1621}:  // r_num_access21 =0
              
              
              begin
                 
                 r_read_data21[15:0] <= data_smc21[15:0];
                 r_read_data21[31:16] <= r_read_data21[31:16];
                 
              end
            
            //  r_num_access21 = 0, v_bus_size21 == `XSIZ_821 
            
            {1'b0,1'b1,2'h0,`XSIZ_821}:
              
              begin
                 
                 r_read_data21[7:0] <= data_smc21[7:0];
                 r_read_data21[31:8] <= r_read_data21[31:8];
                 
              end
            
            //  r_num_access21 = 0, v_bus_size21 == `XSIZ_3221
            
            {1'b0,1'b1,2'h0,`XSIZ_3221}:
              
               r_read_data21[31:0] <= data_smc21[31:0];                      
            
            default :
              
               r_read_data21 <= r_read_data21;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals21 concatenation21 for case statement21 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata21 = {r_xfer_size21,r_bus_size21,latch_data21};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata21 or data_smc21 or r_read_data21 )
       
     begin
        
        casex(xfer_bus_ldata21)
          
          {`XSIZ_3221,`BSIZ_3221,1'b1} :
            
             read_data21[31:0] = data_smc21[31:0];
          
          {`XSIZ_3221,`BSIZ_1621,1'b1} :
                              
            begin
               
               read_data21[31:16] = r_read_data21[31:16];
               read_data21[15:0]  = data_smc21[15:0];
               
            end
          
          {`XSIZ_3221,`BSIZ_821,1'b1} :
            
            begin
               
               read_data21[31:8] = r_read_data21[31:8];
               read_data21[7:0]  = data_smc21[7:0];
               
            end
          
          {`XSIZ_3221,1'bx,1'bx,1'bx} :
            
            read_data21 = r_read_data21;
          
          {`XSIZ_1621,`BSIZ_1621,1'b1} :
                        
            begin
               
               read_data21[31:16] = data_smc21[15:0];
               read_data21[15:0] = data_smc21[15:0];
               
            end
          
          {`XSIZ_1621,`BSIZ_1621,1'b0} :  
            
            begin
               
               read_data21[31:16] = r_read_data21[15:0];
               read_data21[15:0] = r_read_data21[15:0];
               
            end
          
          {`XSIZ_1621,`BSIZ_3221,1'b1} :  
            
            read_data21 = data_smc21;
          
          {`XSIZ_1621,`BSIZ_821,1'b1} : 
                        
            begin
               
               read_data21[31:24] = r_read_data21[15:8];
               read_data21[23:16] = data_smc21[7:0];
               read_data21[15:8] = r_read_data21[15:8];
               read_data21[7:0] = data_smc21[7:0];
            end
          
          {`XSIZ_1621,`BSIZ_821,1'b0} : 
            
            begin
               
               read_data21[31:16] = r_read_data21[15:0];
               read_data21[15:0] = r_read_data21[15:0];
               
            end
          
          {`XSIZ_1621,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data21[31:16] = r_read_data21[31:16];
               read_data21[15:0] = r_read_data21[15:0];
               
            end
          
          {`XSIZ_821,`BSIZ_1621,1'b1} :
            
            begin
               
               read_data21[31:16] = data_smc21[15:0];
               read_data21[15:0] = data_smc21[15:0];
               
            end
          
          {`XSIZ_821,`BSIZ_1621,1'b0} :
            
            begin
               
               read_data21[31:16] = r_read_data21[15:0];
               read_data21[15:0]  = r_read_data21[15:0];
               
            end
          
          {`XSIZ_821,`BSIZ_3221,1'b1} :   
            
            read_data21 = data_smc21;
          
          {`XSIZ_821,`BSIZ_3221,1'b0} :              
                        
                        read_data21 = r_read_data21;
          
          {`XSIZ_821,`BSIZ_821,1'b1} :   
                                    
            begin
               
               read_data21[31:24] = data_smc21[7:0];
               read_data21[23:16] = data_smc21[7:0];
               read_data21[15:8]  = data_smc21[7:0];
               read_data21[7:0]   = data_smc21[7:0];
               
            end
          
          default:
            
            begin
               
               read_data21[31:24] = r_read_data21[7:0];
               read_data21[23:16] = r_read_data21[7:0];
               read_data21[15:8]  = r_read_data21[7:0];
               read_data21[7:0]   = r_read_data21[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata21)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal21 concatenation21 for use in case statement21
//----------------------------------------------------------------------------
   
   assign bus_size_num_access21 = { r_bus_size21, r_num_access21};
   
//--------------------------------------------------------------------
// Select21 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access21 or write_data21)
  
    begin
       
       casex(bus_size_num_access21)
         
         {`BSIZ_3221,1'bx,1'bx}://    (v_bus_size21 == `BSIZ_3221)
           
           smc_data21 = write_data21;
         
         {`BSIZ_1621,2'h1}:    // r_num_access21 == 1
                      
           begin
              
              smc_data21[31:16] = 16'h0;
              smc_data21[15:0] = write_data21[31:16];
              
           end 
         
         {`BSIZ_1621,1'bx,1'bx}:  // (v_bus_size21 == `BSIZ_1621)  
           
           begin
              
              smc_data21[31:16] = 16'h0;
              smc_data21[15:0]  = write_data21[15:0];
              
           end
         
         {`BSIZ_821,2'h3}:  //  (r_num_access21 == 3)
           
           begin
              
              smc_data21[31:8] = 24'h0;
              smc_data21[7:0] = write_data21[31:24];
           end
         
         {`BSIZ_821,2'h2}:  //   (r_num_access21 == 2)
           
           begin
              
              smc_data21[31:8] = 24'h0;
              smc_data21[7:0] = write_data21[23:16];
              
           end
         
         {`BSIZ_821,2'h1}:  //  (r_num_access21 == 2)
           
           begin
              
              smc_data21[31:8] = 24'h0;
              smc_data21[7:0]  = write_data21[15:8];
              
           end 
         
         {`BSIZ_821,2'h0}:  //  (r_num_access21 == 0) 
           
           begin
              
              smc_data21[31:8] = 24'h0;
              smc_data21[7:0] = write_data21[7:0];
              
           end 
         
         default:
           
           smc_data21 = 32'h0;
         
       endcase // casex(bus_size_num_access21)
       
       
    end
   
endmodule
