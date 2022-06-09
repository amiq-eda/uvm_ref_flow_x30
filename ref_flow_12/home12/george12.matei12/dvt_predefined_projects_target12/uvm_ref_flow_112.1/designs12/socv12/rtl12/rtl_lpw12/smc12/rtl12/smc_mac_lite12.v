//File12 name   : smc_mac_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : Multiple12 access controller12.
//            : Static12 Memory Controller12.
//            : The Multiple12 Access Control12 Block keeps12 trace12 of the
//            : number12 of accesses required12 to fulfill12 the
//            : requirements12 of the AHB12 transfer12. The data is
//            : registered when multiple reads are required12. The AHB12
//            : holds12 the data during multiple writes.
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

`include "smc_defs_lite12.v"

module smc_mac_lite12     (

                    //inputs12
                    
                    sys_clk12,
                    n_sys_reset12,
                    valid_access12,
                    xfer_size12,
                    smc_done12,
                    data_smc12,
                    write_data12,
                    smc_nextstate12,
                    latch_data12,
                    
                    //outputs12
                    
                    r_num_access12,
                    mac_done12,
                    v_bus_size12,
                    v_xfer_size12,
                    read_data12,
                    smc_data12);
   
   
   
 


// State12 Machine12// I12/O12

  input                sys_clk12;        // System12 clock12
  input                n_sys_reset12;    // System12 reset (Active12 LOW12)
  input                valid_access12;   // Address cycle of new transfer12
  input  [1:0]         xfer_size12;      // xfer12 size, valid with valid_access12
  input                smc_done12;       // End12 of transfer12
  input  [31:0]        data_smc12;       // External12 read data
  input  [31:0]        write_data12;     // Data from internal bus 
  input  [4:0]         smc_nextstate12;  // State12 Machine12  
  input                latch_data12;     //latch_data12 is used by the MAC12 block    
  
  output [1:0]         r_num_access12;   // Access counter
  output               mac_done12;       // End12 of all transfers12
  output [1:0]         v_bus_size12;     // Registered12 sizes12 for subsequent12
  output [1:0]         v_xfer_size12;    // transfers12 in MAC12 transfer12
  output [31:0]        read_data12;      // Data to internal bus
  output [31:0]        smc_data12;       // Data to external12 bus
  

// Output12 register declarations12

  reg                  mac_done12;       // Indicates12 last cycle of last access
  reg [1:0]            r_num_access12;   // Access counter
  reg [1:0]            num_accesses12;   //number12 of access
  reg [1:0]            r_xfer_size12;    // Store12 size for MAC12 
  reg [1:0]            r_bus_size12;     // Store12 size for MAC12
  reg [31:0]           read_data12;      // Data path to bus IF
  reg [31:0]           r_read_data12;    // Internal data store12
  reg [31:0]           smc_data12;


// Internal Signals12

  reg [1:0]            v_bus_size12;
  reg [1:0]            v_xfer_size12;
  wire [4:0]           smc_nextstate12;    //specifies12 next state
  wire [4:0]           xfer_bus_ldata12;  //concatenation12 of xfer_size12
                                         // and latch_data12  
  wire [3:0]           bus_size_num_access12; //concatenation12 of 
                                              // r_num_access12
  wire [5:0]           wt_ldata_naccs_bsiz12;  //concatenation12 of 
                                            //latch_data12,r_num_access12
 
   


// Main12 Code12

//----------------------------------------------------------------------------
// Store12 transfer12 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk12 or negedge n_sys_reset12)
  
    begin
       
       if (~n_sys_reset12)
         
          r_xfer_size12 <= 2'b00;
       
       
       else if (valid_access12)
         
          r_xfer_size12 <= xfer_size12;
       
       else
         
          r_xfer_size12 <= r_xfer_size12;
       
    end

//--------------------------------------------------------------------
// Store12 bus size generation12
//--------------------------------------------------------------------
  
  always @(posedge sys_clk12 or negedge n_sys_reset12)
    
    begin
       
       if (~n_sys_reset12)
         
          r_bus_size12 <= 2'b00;
       
       
       else if (valid_access12)
         
          r_bus_size12 <= 2'b00;
       
       else
         
          r_bus_size12 <= r_bus_size12;
       
    end
   

//--------------------------------------------------------------------
// Validate12 sizes12 generation12
//--------------------------------------------------------------------

  always @(valid_access12 or r_bus_size12 )

    begin
       
       if (valid_access12)
         
          v_bus_size12 = 2'b0;
       
       else
         
          v_bus_size12 = r_bus_size12;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size12 generation12
//----------------------------------------------------------------------------   

  always @(valid_access12 or r_xfer_size12 or xfer_size12)

    begin
       
       if (valid_access12)
         
          v_xfer_size12 = xfer_size12;
       
       else
         
          v_xfer_size12 = r_xfer_size12;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions12
// Determines12 the number12 of accesses required12 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size12)
  
    begin
       
       if ((xfer_size12[1:0] == `XSIZ_1612))
         
          num_accesses12 = 2'h1; // Two12 accesses
       
       else if ( (xfer_size12[1:0] == `XSIZ_3212))
         
          num_accesses12 = 2'h3; // Four12 accesses
       
       else
         
          num_accesses12 = 2'h0; // One12 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep12 track12 of the current access number12
//--------------------------------------------------------------------
   
  always @(posedge sys_clk12 or negedge n_sys_reset12)
  
    begin
       
       if (~n_sys_reset12)
         
          r_num_access12 <= 2'b00;
       
       else if (valid_access12)
         
          r_num_access12 <= num_accesses12;
       
       else if (smc_done12 & (smc_nextstate12 != `SMC_STORE12)  &
                      (smc_nextstate12 != `SMC_IDLE12)   )
         
          r_num_access12 <= r_num_access12 - 2'd1;
       
       else
         
          r_num_access12 <= r_num_access12;
       
    end
   
   

//--------------------------------------------------------------------
// Detect12 last access
//--------------------------------------------------------------------
   
   always @(r_num_access12)
     
     begin
        
        if (r_num_access12 == 2'h0)
          
           mac_done12 = 1'b1;
             
        else
          
           mac_done12 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals12 concatenation12 used in case statement12 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz12 = { 1'b0, latch_data12, r_num_access12,
                                  r_bus_size12};
 
   
//--------------------------------------------------------------------
// Store12 Read Data if required12
//--------------------------------------------------------------------

   always @(posedge sys_clk12 or negedge n_sys_reset12)
     
     begin
        
        if (~n_sys_reset12)
          
           r_read_data12 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz12)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data12 <= r_read_data12;
            
            //    latch_data12
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data12[31:24] <= data_smc12[7:0];
                 r_read_data12[23:0] <= 24'h0;
                 
              end
            
            // r_num_access12 =2, v_bus_size12 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data12[23:16] <= data_smc12[7:0];
                 r_read_data12[31:24] <= r_read_data12[31:24];
                 r_read_data12[15:0] <= 16'h0;
                 
              end
            
            // r_num_access12 =1, v_bus_size12 = `XSIZ_1612
            
            {1'b0,1'b1,2'h1,`XSIZ_1612}:
              
              begin
                 
                 r_read_data12[15:0] <= 16'h0;
                 r_read_data12[31:16] <= data_smc12[15:0];
                 
              end
            
            //  r_num_access12 =1,v_bus_size12 == `XSIZ_812
            
            {1'b0,1'b1,2'h1,`XSIZ_812}:          
              
              begin
                 
                 r_read_data12[15:8] <= data_smc12[7:0];
                 r_read_data12[31:16] <= r_read_data12[31:16];
                 r_read_data12[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access12 = 0, v_bus_size12 == `XSIZ_1612
            
            {1'b0,1'b1,2'h0,`XSIZ_1612}:  // r_num_access12 =0
              
              
              begin
                 
                 r_read_data12[15:0] <= data_smc12[15:0];
                 r_read_data12[31:16] <= r_read_data12[31:16];
                 
              end
            
            //  r_num_access12 = 0, v_bus_size12 == `XSIZ_812 
            
            {1'b0,1'b1,2'h0,`XSIZ_812}:
              
              begin
                 
                 r_read_data12[7:0] <= data_smc12[7:0];
                 r_read_data12[31:8] <= r_read_data12[31:8];
                 
              end
            
            //  r_num_access12 = 0, v_bus_size12 == `XSIZ_3212
            
            {1'b0,1'b1,2'h0,`XSIZ_3212}:
              
               r_read_data12[31:0] <= data_smc12[31:0];                      
            
            default :
              
               r_read_data12 <= r_read_data12;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals12 concatenation12 for case statement12 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata12 = {r_xfer_size12,r_bus_size12,latch_data12};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata12 or data_smc12 or r_read_data12 )
       
     begin
        
        casex(xfer_bus_ldata12)
          
          {`XSIZ_3212,`BSIZ_3212,1'b1} :
            
             read_data12[31:0] = data_smc12[31:0];
          
          {`XSIZ_3212,`BSIZ_1612,1'b1} :
                              
            begin
               
               read_data12[31:16] = r_read_data12[31:16];
               read_data12[15:0]  = data_smc12[15:0];
               
            end
          
          {`XSIZ_3212,`BSIZ_812,1'b1} :
            
            begin
               
               read_data12[31:8] = r_read_data12[31:8];
               read_data12[7:0]  = data_smc12[7:0];
               
            end
          
          {`XSIZ_3212,1'bx,1'bx,1'bx} :
            
            read_data12 = r_read_data12;
          
          {`XSIZ_1612,`BSIZ_1612,1'b1} :
                        
            begin
               
               read_data12[31:16] = data_smc12[15:0];
               read_data12[15:0] = data_smc12[15:0];
               
            end
          
          {`XSIZ_1612,`BSIZ_1612,1'b0} :  
            
            begin
               
               read_data12[31:16] = r_read_data12[15:0];
               read_data12[15:0] = r_read_data12[15:0];
               
            end
          
          {`XSIZ_1612,`BSIZ_3212,1'b1} :  
            
            read_data12 = data_smc12;
          
          {`XSIZ_1612,`BSIZ_812,1'b1} : 
                        
            begin
               
               read_data12[31:24] = r_read_data12[15:8];
               read_data12[23:16] = data_smc12[7:0];
               read_data12[15:8] = r_read_data12[15:8];
               read_data12[7:0] = data_smc12[7:0];
            end
          
          {`XSIZ_1612,`BSIZ_812,1'b0} : 
            
            begin
               
               read_data12[31:16] = r_read_data12[15:0];
               read_data12[15:0] = r_read_data12[15:0];
               
            end
          
          {`XSIZ_1612,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data12[31:16] = r_read_data12[31:16];
               read_data12[15:0] = r_read_data12[15:0];
               
            end
          
          {`XSIZ_812,`BSIZ_1612,1'b1} :
            
            begin
               
               read_data12[31:16] = data_smc12[15:0];
               read_data12[15:0] = data_smc12[15:0];
               
            end
          
          {`XSIZ_812,`BSIZ_1612,1'b0} :
            
            begin
               
               read_data12[31:16] = r_read_data12[15:0];
               read_data12[15:0]  = r_read_data12[15:0];
               
            end
          
          {`XSIZ_812,`BSIZ_3212,1'b1} :   
            
            read_data12 = data_smc12;
          
          {`XSIZ_812,`BSIZ_3212,1'b0} :              
                        
                        read_data12 = r_read_data12;
          
          {`XSIZ_812,`BSIZ_812,1'b1} :   
                                    
            begin
               
               read_data12[31:24] = data_smc12[7:0];
               read_data12[23:16] = data_smc12[7:0];
               read_data12[15:8]  = data_smc12[7:0];
               read_data12[7:0]   = data_smc12[7:0];
               
            end
          
          default:
            
            begin
               
               read_data12[31:24] = r_read_data12[7:0];
               read_data12[23:16] = r_read_data12[7:0];
               read_data12[15:8]  = r_read_data12[7:0];
               read_data12[7:0]   = r_read_data12[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata12)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal12 concatenation12 for use in case statement12
//----------------------------------------------------------------------------
   
   assign bus_size_num_access12 = { r_bus_size12, r_num_access12};
   
//--------------------------------------------------------------------
// Select12 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access12 or write_data12)
  
    begin
       
       casex(bus_size_num_access12)
         
         {`BSIZ_3212,1'bx,1'bx}://    (v_bus_size12 == `BSIZ_3212)
           
           smc_data12 = write_data12;
         
         {`BSIZ_1612,2'h1}:    // r_num_access12 == 1
                      
           begin
              
              smc_data12[31:16] = 16'h0;
              smc_data12[15:0] = write_data12[31:16];
              
           end 
         
         {`BSIZ_1612,1'bx,1'bx}:  // (v_bus_size12 == `BSIZ_1612)  
           
           begin
              
              smc_data12[31:16] = 16'h0;
              smc_data12[15:0]  = write_data12[15:0];
              
           end
         
         {`BSIZ_812,2'h3}:  //  (r_num_access12 == 3)
           
           begin
              
              smc_data12[31:8] = 24'h0;
              smc_data12[7:0] = write_data12[31:24];
           end
         
         {`BSIZ_812,2'h2}:  //   (r_num_access12 == 2)
           
           begin
              
              smc_data12[31:8] = 24'h0;
              smc_data12[7:0] = write_data12[23:16];
              
           end
         
         {`BSIZ_812,2'h1}:  //  (r_num_access12 == 2)
           
           begin
              
              smc_data12[31:8] = 24'h0;
              smc_data12[7:0]  = write_data12[15:8];
              
           end 
         
         {`BSIZ_812,2'h0}:  //  (r_num_access12 == 0) 
           
           begin
              
              smc_data12[31:8] = 24'h0;
              smc_data12[7:0] = write_data12[7:0];
              
           end 
         
         default:
           
           smc_data12 = 32'h0;
         
       endcase // casex(bus_size_num_access12)
       
       
    end
   
endmodule
