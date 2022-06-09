//File27 name   : smc_mac_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : Multiple27 access controller27.
//            : Static27 Memory Controller27.
//            : The Multiple27 Access Control27 Block keeps27 trace27 of the
//            : number27 of accesses required27 to fulfill27 the
//            : requirements27 of the AHB27 transfer27. The data is
//            : registered when multiple reads are required27. The AHB27
//            : holds27 the data during multiple writes.
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

`include "smc_defs_lite27.v"

module smc_mac_lite27     (

                    //inputs27
                    
                    sys_clk27,
                    n_sys_reset27,
                    valid_access27,
                    xfer_size27,
                    smc_done27,
                    data_smc27,
                    write_data27,
                    smc_nextstate27,
                    latch_data27,
                    
                    //outputs27
                    
                    r_num_access27,
                    mac_done27,
                    v_bus_size27,
                    v_xfer_size27,
                    read_data27,
                    smc_data27);
   
   
   
 


// State27 Machine27// I27/O27

  input                sys_clk27;        // System27 clock27
  input                n_sys_reset27;    // System27 reset (Active27 LOW27)
  input                valid_access27;   // Address cycle of new transfer27
  input  [1:0]         xfer_size27;      // xfer27 size, valid with valid_access27
  input                smc_done27;       // End27 of transfer27
  input  [31:0]        data_smc27;       // External27 read data
  input  [31:0]        write_data27;     // Data from internal bus 
  input  [4:0]         smc_nextstate27;  // State27 Machine27  
  input                latch_data27;     //latch_data27 is used by the MAC27 block    
  
  output [1:0]         r_num_access27;   // Access counter
  output               mac_done27;       // End27 of all transfers27
  output [1:0]         v_bus_size27;     // Registered27 sizes27 for subsequent27
  output [1:0]         v_xfer_size27;    // transfers27 in MAC27 transfer27
  output [31:0]        read_data27;      // Data to internal bus
  output [31:0]        smc_data27;       // Data to external27 bus
  

// Output27 register declarations27

  reg                  mac_done27;       // Indicates27 last cycle of last access
  reg [1:0]            r_num_access27;   // Access counter
  reg [1:0]            num_accesses27;   //number27 of access
  reg [1:0]            r_xfer_size27;    // Store27 size for MAC27 
  reg [1:0]            r_bus_size27;     // Store27 size for MAC27
  reg [31:0]           read_data27;      // Data path to bus IF
  reg [31:0]           r_read_data27;    // Internal data store27
  reg [31:0]           smc_data27;


// Internal Signals27

  reg [1:0]            v_bus_size27;
  reg [1:0]            v_xfer_size27;
  wire [4:0]           smc_nextstate27;    //specifies27 next state
  wire [4:0]           xfer_bus_ldata27;  //concatenation27 of xfer_size27
                                         // and latch_data27  
  wire [3:0]           bus_size_num_access27; //concatenation27 of 
                                              // r_num_access27
  wire [5:0]           wt_ldata_naccs_bsiz27;  //concatenation27 of 
                                            //latch_data27,r_num_access27
 
   


// Main27 Code27

//----------------------------------------------------------------------------
// Store27 transfer27 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk27 or negedge n_sys_reset27)
  
    begin
       
       if (~n_sys_reset27)
         
          r_xfer_size27 <= 2'b00;
       
       
       else if (valid_access27)
         
          r_xfer_size27 <= xfer_size27;
       
       else
         
          r_xfer_size27 <= r_xfer_size27;
       
    end

//--------------------------------------------------------------------
// Store27 bus size generation27
//--------------------------------------------------------------------
  
  always @(posedge sys_clk27 or negedge n_sys_reset27)
    
    begin
       
       if (~n_sys_reset27)
         
          r_bus_size27 <= 2'b00;
       
       
       else if (valid_access27)
         
          r_bus_size27 <= 2'b00;
       
       else
         
          r_bus_size27 <= r_bus_size27;
       
    end
   

//--------------------------------------------------------------------
// Validate27 sizes27 generation27
//--------------------------------------------------------------------

  always @(valid_access27 or r_bus_size27 )

    begin
       
       if (valid_access27)
         
          v_bus_size27 = 2'b0;
       
       else
         
          v_bus_size27 = r_bus_size27;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size27 generation27
//----------------------------------------------------------------------------   

  always @(valid_access27 or r_xfer_size27 or xfer_size27)

    begin
       
       if (valid_access27)
         
          v_xfer_size27 = xfer_size27;
       
       else
         
          v_xfer_size27 = r_xfer_size27;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions27
// Determines27 the number27 of accesses required27 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size27)
  
    begin
       
       if ((xfer_size27[1:0] == `XSIZ_1627))
         
          num_accesses27 = 2'h1; // Two27 accesses
       
       else if ( (xfer_size27[1:0] == `XSIZ_3227))
         
          num_accesses27 = 2'h3; // Four27 accesses
       
       else
         
          num_accesses27 = 2'h0; // One27 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep27 track27 of the current access number27
//--------------------------------------------------------------------
   
  always @(posedge sys_clk27 or negedge n_sys_reset27)
  
    begin
       
       if (~n_sys_reset27)
         
          r_num_access27 <= 2'b00;
       
       else if (valid_access27)
         
          r_num_access27 <= num_accesses27;
       
       else if (smc_done27 & (smc_nextstate27 != `SMC_STORE27)  &
                      (smc_nextstate27 != `SMC_IDLE27)   )
         
          r_num_access27 <= r_num_access27 - 2'd1;
       
       else
         
          r_num_access27 <= r_num_access27;
       
    end
   
   

//--------------------------------------------------------------------
// Detect27 last access
//--------------------------------------------------------------------
   
   always @(r_num_access27)
     
     begin
        
        if (r_num_access27 == 2'h0)
          
           mac_done27 = 1'b1;
             
        else
          
           mac_done27 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals27 concatenation27 used in case statement27 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz27 = { 1'b0, latch_data27, r_num_access27,
                                  r_bus_size27};
 
   
//--------------------------------------------------------------------
// Store27 Read Data if required27
//--------------------------------------------------------------------

   always @(posedge sys_clk27 or negedge n_sys_reset27)
     
     begin
        
        if (~n_sys_reset27)
          
           r_read_data27 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz27)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data27 <= r_read_data27;
            
            //    latch_data27
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data27[31:24] <= data_smc27[7:0];
                 r_read_data27[23:0] <= 24'h0;
                 
              end
            
            // r_num_access27 =2, v_bus_size27 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data27[23:16] <= data_smc27[7:0];
                 r_read_data27[31:24] <= r_read_data27[31:24];
                 r_read_data27[15:0] <= 16'h0;
                 
              end
            
            // r_num_access27 =1, v_bus_size27 = `XSIZ_1627
            
            {1'b0,1'b1,2'h1,`XSIZ_1627}:
              
              begin
                 
                 r_read_data27[15:0] <= 16'h0;
                 r_read_data27[31:16] <= data_smc27[15:0];
                 
              end
            
            //  r_num_access27 =1,v_bus_size27 == `XSIZ_827
            
            {1'b0,1'b1,2'h1,`XSIZ_827}:          
              
              begin
                 
                 r_read_data27[15:8] <= data_smc27[7:0];
                 r_read_data27[31:16] <= r_read_data27[31:16];
                 r_read_data27[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access27 = 0, v_bus_size27 == `XSIZ_1627
            
            {1'b0,1'b1,2'h0,`XSIZ_1627}:  // r_num_access27 =0
              
              
              begin
                 
                 r_read_data27[15:0] <= data_smc27[15:0];
                 r_read_data27[31:16] <= r_read_data27[31:16];
                 
              end
            
            //  r_num_access27 = 0, v_bus_size27 == `XSIZ_827 
            
            {1'b0,1'b1,2'h0,`XSIZ_827}:
              
              begin
                 
                 r_read_data27[7:0] <= data_smc27[7:0];
                 r_read_data27[31:8] <= r_read_data27[31:8];
                 
              end
            
            //  r_num_access27 = 0, v_bus_size27 == `XSIZ_3227
            
            {1'b0,1'b1,2'h0,`XSIZ_3227}:
              
               r_read_data27[31:0] <= data_smc27[31:0];                      
            
            default :
              
               r_read_data27 <= r_read_data27;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals27 concatenation27 for case statement27 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata27 = {r_xfer_size27,r_bus_size27,latch_data27};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata27 or data_smc27 or r_read_data27 )
       
     begin
        
        casex(xfer_bus_ldata27)
          
          {`XSIZ_3227,`BSIZ_3227,1'b1} :
            
             read_data27[31:0] = data_smc27[31:0];
          
          {`XSIZ_3227,`BSIZ_1627,1'b1} :
                              
            begin
               
               read_data27[31:16] = r_read_data27[31:16];
               read_data27[15:0]  = data_smc27[15:0];
               
            end
          
          {`XSIZ_3227,`BSIZ_827,1'b1} :
            
            begin
               
               read_data27[31:8] = r_read_data27[31:8];
               read_data27[7:0]  = data_smc27[7:0];
               
            end
          
          {`XSIZ_3227,1'bx,1'bx,1'bx} :
            
            read_data27 = r_read_data27;
          
          {`XSIZ_1627,`BSIZ_1627,1'b1} :
                        
            begin
               
               read_data27[31:16] = data_smc27[15:0];
               read_data27[15:0] = data_smc27[15:0];
               
            end
          
          {`XSIZ_1627,`BSIZ_1627,1'b0} :  
            
            begin
               
               read_data27[31:16] = r_read_data27[15:0];
               read_data27[15:0] = r_read_data27[15:0];
               
            end
          
          {`XSIZ_1627,`BSIZ_3227,1'b1} :  
            
            read_data27 = data_smc27;
          
          {`XSIZ_1627,`BSIZ_827,1'b1} : 
                        
            begin
               
               read_data27[31:24] = r_read_data27[15:8];
               read_data27[23:16] = data_smc27[7:0];
               read_data27[15:8] = r_read_data27[15:8];
               read_data27[7:0] = data_smc27[7:0];
            end
          
          {`XSIZ_1627,`BSIZ_827,1'b0} : 
            
            begin
               
               read_data27[31:16] = r_read_data27[15:0];
               read_data27[15:0] = r_read_data27[15:0];
               
            end
          
          {`XSIZ_1627,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data27[31:16] = r_read_data27[31:16];
               read_data27[15:0] = r_read_data27[15:0];
               
            end
          
          {`XSIZ_827,`BSIZ_1627,1'b1} :
            
            begin
               
               read_data27[31:16] = data_smc27[15:0];
               read_data27[15:0] = data_smc27[15:0];
               
            end
          
          {`XSIZ_827,`BSIZ_1627,1'b0} :
            
            begin
               
               read_data27[31:16] = r_read_data27[15:0];
               read_data27[15:0]  = r_read_data27[15:0];
               
            end
          
          {`XSIZ_827,`BSIZ_3227,1'b1} :   
            
            read_data27 = data_smc27;
          
          {`XSIZ_827,`BSIZ_3227,1'b0} :              
                        
                        read_data27 = r_read_data27;
          
          {`XSIZ_827,`BSIZ_827,1'b1} :   
                                    
            begin
               
               read_data27[31:24] = data_smc27[7:0];
               read_data27[23:16] = data_smc27[7:0];
               read_data27[15:8]  = data_smc27[7:0];
               read_data27[7:0]   = data_smc27[7:0];
               
            end
          
          default:
            
            begin
               
               read_data27[31:24] = r_read_data27[7:0];
               read_data27[23:16] = r_read_data27[7:0];
               read_data27[15:8]  = r_read_data27[7:0];
               read_data27[7:0]   = r_read_data27[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata27)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal27 concatenation27 for use in case statement27
//----------------------------------------------------------------------------
   
   assign bus_size_num_access27 = { r_bus_size27, r_num_access27};
   
//--------------------------------------------------------------------
// Select27 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access27 or write_data27)
  
    begin
       
       casex(bus_size_num_access27)
         
         {`BSIZ_3227,1'bx,1'bx}://    (v_bus_size27 == `BSIZ_3227)
           
           smc_data27 = write_data27;
         
         {`BSIZ_1627,2'h1}:    // r_num_access27 == 1
                      
           begin
              
              smc_data27[31:16] = 16'h0;
              smc_data27[15:0] = write_data27[31:16];
              
           end 
         
         {`BSIZ_1627,1'bx,1'bx}:  // (v_bus_size27 == `BSIZ_1627)  
           
           begin
              
              smc_data27[31:16] = 16'h0;
              smc_data27[15:0]  = write_data27[15:0];
              
           end
         
         {`BSIZ_827,2'h3}:  //  (r_num_access27 == 3)
           
           begin
              
              smc_data27[31:8] = 24'h0;
              smc_data27[7:0] = write_data27[31:24];
           end
         
         {`BSIZ_827,2'h2}:  //   (r_num_access27 == 2)
           
           begin
              
              smc_data27[31:8] = 24'h0;
              smc_data27[7:0] = write_data27[23:16];
              
           end
         
         {`BSIZ_827,2'h1}:  //  (r_num_access27 == 2)
           
           begin
              
              smc_data27[31:8] = 24'h0;
              smc_data27[7:0]  = write_data27[15:8];
              
           end 
         
         {`BSIZ_827,2'h0}:  //  (r_num_access27 == 0) 
           
           begin
              
              smc_data27[31:8] = 24'h0;
              smc_data27[7:0] = write_data27[7:0];
              
           end 
         
         default:
           
           smc_data27 = 32'h0;
         
       endcase // casex(bus_size_num_access27)
       
       
    end
   
endmodule
