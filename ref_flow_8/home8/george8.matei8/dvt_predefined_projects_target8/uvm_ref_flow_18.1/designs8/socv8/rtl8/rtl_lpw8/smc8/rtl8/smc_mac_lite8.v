//File8 name   : smc_mac_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : Multiple8 access controller8.
//            : Static8 Memory Controller8.
//            : The Multiple8 Access Control8 Block keeps8 trace8 of the
//            : number8 of accesses required8 to fulfill8 the
//            : requirements8 of the AHB8 transfer8. The data is
//            : registered when multiple reads are required8. The AHB8
//            : holds8 the data during multiple writes.
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

`include "smc_defs_lite8.v"

module smc_mac_lite8     (

                    //inputs8
                    
                    sys_clk8,
                    n_sys_reset8,
                    valid_access8,
                    xfer_size8,
                    smc_done8,
                    data_smc8,
                    write_data8,
                    smc_nextstate8,
                    latch_data8,
                    
                    //outputs8
                    
                    r_num_access8,
                    mac_done8,
                    v_bus_size8,
                    v_xfer_size8,
                    read_data8,
                    smc_data8);
   
   
   
 


// State8 Machine8// I8/O8

  input                sys_clk8;        // System8 clock8
  input                n_sys_reset8;    // System8 reset (Active8 LOW8)
  input                valid_access8;   // Address cycle of new transfer8
  input  [1:0]         xfer_size8;      // xfer8 size, valid with valid_access8
  input                smc_done8;       // End8 of transfer8
  input  [31:0]        data_smc8;       // External8 read data
  input  [31:0]        write_data8;     // Data from internal bus 
  input  [4:0]         smc_nextstate8;  // State8 Machine8  
  input                latch_data8;     //latch_data8 is used by the MAC8 block    
  
  output [1:0]         r_num_access8;   // Access counter
  output               mac_done8;       // End8 of all transfers8
  output [1:0]         v_bus_size8;     // Registered8 sizes8 for subsequent8
  output [1:0]         v_xfer_size8;    // transfers8 in MAC8 transfer8
  output [31:0]        read_data8;      // Data to internal bus
  output [31:0]        smc_data8;       // Data to external8 bus
  

// Output8 register declarations8

  reg                  mac_done8;       // Indicates8 last cycle of last access
  reg [1:0]            r_num_access8;   // Access counter
  reg [1:0]            num_accesses8;   //number8 of access
  reg [1:0]            r_xfer_size8;    // Store8 size for MAC8 
  reg [1:0]            r_bus_size8;     // Store8 size for MAC8
  reg [31:0]           read_data8;      // Data path to bus IF
  reg [31:0]           r_read_data8;    // Internal data store8
  reg [31:0]           smc_data8;


// Internal Signals8

  reg [1:0]            v_bus_size8;
  reg [1:0]            v_xfer_size8;
  wire [4:0]           smc_nextstate8;    //specifies8 next state
  wire [4:0]           xfer_bus_ldata8;  //concatenation8 of xfer_size8
                                         // and latch_data8  
  wire [3:0]           bus_size_num_access8; //concatenation8 of 
                                              // r_num_access8
  wire [5:0]           wt_ldata_naccs_bsiz8;  //concatenation8 of 
                                            //latch_data8,r_num_access8
 
   


// Main8 Code8

//----------------------------------------------------------------------------
// Store8 transfer8 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk8 or negedge n_sys_reset8)
  
    begin
       
       if (~n_sys_reset8)
         
          r_xfer_size8 <= 2'b00;
       
       
       else if (valid_access8)
         
          r_xfer_size8 <= xfer_size8;
       
       else
         
          r_xfer_size8 <= r_xfer_size8;
       
    end

//--------------------------------------------------------------------
// Store8 bus size generation8
//--------------------------------------------------------------------
  
  always @(posedge sys_clk8 or negedge n_sys_reset8)
    
    begin
       
       if (~n_sys_reset8)
         
          r_bus_size8 <= 2'b00;
       
       
       else if (valid_access8)
         
          r_bus_size8 <= 2'b00;
       
       else
         
          r_bus_size8 <= r_bus_size8;
       
    end
   

//--------------------------------------------------------------------
// Validate8 sizes8 generation8
//--------------------------------------------------------------------

  always @(valid_access8 or r_bus_size8 )

    begin
       
       if (valid_access8)
         
          v_bus_size8 = 2'b0;
       
       else
         
          v_bus_size8 = r_bus_size8;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size8 generation8
//----------------------------------------------------------------------------   

  always @(valid_access8 or r_xfer_size8 or xfer_size8)

    begin
       
       if (valid_access8)
         
          v_xfer_size8 = xfer_size8;
       
       else
         
          v_xfer_size8 = r_xfer_size8;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions8
// Determines8 the number8 of accesses required8 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size8)
  
    begin
       
       if ((xfer_size8[1:0] == `XSIZ_168))
         
          num_accesses8 = 2'h1; // Two8 accesses
       
       else if ( (xfer_size8[1:0] == `XSIZ_328))
         
          num_accesses8 = 2'h3; // Four8 accesses
       
       else
         
          num_accesses8 = 2'h0; // One8 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep8 track8 of the current access number8
//--------------------------------------------------------------------
   
  always @(posedge sys_clk8 or negedge n_sys_reset8)
  
    begin
       
       if (~n_sys_reset8)
         
          r_num_access8 <= 2'b00;
       
       else if (valid_access8)
         
          r_num_access8 <= num_accesses8;
       
       else if (smc_done8 & (smc_nextstate8 != `SMC_STORE8)  &
                      (smc_nextstate8 != `SMC_IDLE8)   )
         
          r_num_access8 <= r_num_access8 - 2'd1;
       
       else
         
          r_num_access8 <= r_num_access8;
       
    end
   
   

//--------------------------------------------------------------------
// Detect8 last access
//--------------------------------------------------------------------
   
   always @(r_num_access8)
     
     begin
        
        if (r_num_access8 == 2'h0)
          
           mac_done8 = 1'b1;
             
        else
          
           mac_done8 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals8 concatenation8 used in case statement8 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz8 = { 1'b0, latch_data8, r_num_access8,
                                  r_bus_size8};
 
   
//--------------------------------------------------------------------
// Store8 Read Data if required8
//--------------------------------------------------------------------

   always @(posedge sys_clk8 or negedge n_sys_reset8)
     
     begin
        
        if (~n_sys_reset8)
          
           r_read_data8 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz8)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data8 <= r_read_data8;
            
            //    latch_data8
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data8[31:24] <= data_smc8[7:0];
                 r_read_data8[23:0] <= 24'h0;
                 
              end
            
            // r_num_access8 =2, v_bus_size8 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data8[23:16] <= data_smc8[7:0];
                 r_read_data8[31:24] <= r_read_data8[31:24];
                 r_read_data8[15:0] <= 16'h0;
                 
              end
            
            // r_num_access8 =1, v_bus_size8 = `XSIZ_168
            
            {1'b0,1'b1,2'h1,`XSIZ_168}:
              
              begin
                 
                 r_read_data8[15:0] <= 16'h0;
                 r_read_data8[31:16] <= data_smc8[15:0];
                 
              end
            
            //  r_num_access8 =1,v_bus_size8 == `XSIZ_88
            
            {1'b0,1'b1,2'h1,`XSIZ_88}:          
              
              begin
                 
                 r_read_data8[15:8] <= data_smc8[7:0];
                 r_read_data8[31:16] <= r_read_data8[31:16];
                 r_read_data8[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access8 = 0, v_bus_size8 == `XSIZ_168
            
            {1'b0,1'b1,2'h0,`XSIZ_168}:  // r_num_access8 =0
              
              
              begin
                 
                 r_read_data8[15:0] <= data_smc8[15:0];
                 r_read_data8[31:16] <= r_read_data8[31:16];
                 
              end
            
            //  r_num_access8 = 0, v_bus_size8 == `XSIZ_88 
            
            {1'b0,1'b1,2'h0,`XSIZ_88}:
              
              begin
                 
                 r_read_data8[7:0] <= data_smc8[7:0];
                 r_read_data8[31:8] <= r_read_data8[31:8];
                 
              end
            
            //  r_num_access8 = 0, v_bus_size8 == `XSIZ_328
            
            {1'b0,1'b1,2'h0,`XSIZ_328}:
              
               r_read_data8[31:0] <= data_smc8[31:0];                      
            
            default :
              
               r_read_data8 <= r_read_data8;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals8 concatenation8 for case statement8 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata8 = {r_xfer_size8,r_bus_size8,latch_data8};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata8 or data_smc8 or r_read_data8 )
       
     begin
        
        casex(xfer_bus_ldata8)
          
          {`XSIZ_328,`BSIZ_328,1'b1} :
            
             read_data8[31:0] = data_smc8[31:0];
          
          {`XSIZ_328,`BSIZ_168,1'b1} :
                              
            begin
               
               read_data8[31:16] = r_read_data8[31:16];
               read_data8[15:0]  = data_smc8[15:0];
               
            end
          
          {`XSIZ_328,`BSIZ_88,1'b1} :
            
            begin
               
               read_data8[31:8] = r_read_data8[31:8];
               read_data8[7:0]  = data_smc8[7:0];
               
            end
          
          {`XSIZ_328,1'bx,1'bx,1'bx} :
            
            read_data8 = r_read_data8;
          
          {`XSIZ_168,`BSIZ_168,1'b1} :
                        
            begin
               
               read_data8[31:16] = data_smc8[15:0];
               read_data8[15:0] = data_smc8[15:0];
               
            end
          
          {`XSIZ_168,`BSIZ_168,1'b0} :  
            
            begin
               
               read_data8[31:16] = r_read_data8[15:0];
               read_data8[15:0] = r_read_data8[15:0];
               
            end
          
          {`XSIZ_168,`BSIZ_328,1'b1} :  
            
            read_data8 = data_smc8;
          
          {`XSIZ_168,`BSIZ_88,1'b1} : 
                        
            begin
               
               read_data8[31:24] = r_read_data8[15:8];
               read_data8[23:16] = data_smc8[7:0];
               read_data8[15:8] = r_read_data8[15:8];
               read_data8[7:0] = data_smc8[7:0];
            end
          
          {`XSIZ_168,`BSIZ_88,1'b0} : 
            
            begin
               
               read_data8[31:16] = r_read_data8[15:0];
               read_data8[15:0] = r_read_data8[15:0];
               
            end
          
          {`XSIZ_168,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data8[31:16] = r_read_data8[31:16];
               read_data8[15:0] = r_read_data8[15:0];
               
            end
          
          {`XSIZ_88,`BSIZ_168,1'b1} :
            
            begin
               
               read_data8[31:16] = data_smc8[15:0];
               read_data8[15:0] = data_smc8[15:0];
               
            end
          
          {`XSIZ_88,`BSIZ_168,1'b0} :
            
            begin
               
               read_data8[31:16] = r_read_data8[15:0];
               read_data8[15:0]  = r_read_data8[15:0];
               
            end
          
          {`XSIZ_88,`BSIZ_328,1'b1} :   
            
            read_data8 = data_smc8;
          
          {`XSIZ_88,`BSIZ_328,1'b0} :              
                        
                        read_data8 = r_read_data8;
          
          {`XSIZ_88,`BSIZ_88,1'b1} :   
                                    
            begin
               
               read_data8[31:24] = data_smc8[7:0];
               read_data8[23:16] = data_smc8[7:0];
               read_data8[15:8]  = data_smc8[7:0];
               read_data8[7:0]   = data_smc8[7:0];
               
            end
          
          default:
            
            begin
               
               read_data8[31:24] = r_read_data8[7:0];
               read_data8[23:16] = r_read_data8[7:0];
               read_data8[15:8]  = r_read_data8[7:0];
               read_data8[7:0]   = r_read_data8[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata8)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal8 concatenation8 for use in case statement8
//----------------------------------------------------------------------------
   
   assign bus_size_num_access8 = { r_bus_size8, r_num_access8};
   
//--------------------------------------------------------------------
// Select8 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access8 or write_data8)
  
    begin
       
       casex(bus_size_num_access8)
         
         {`BSIZ_328,1'bx,1'bx}://    (v_bus_size8 == `BSIZ_328)
           
           smc_data8 = write_data8;
         
         {`BSIZ_168,2'h1}:    // r_num_access8 == 1
                      
           begin
              
              smc_data8[31:16] = 16'h0;
              smc_data8[15:0] = write_data8[31:16];
              
           end 
         
         {`BSIZ_168,1'bx,1'bx}:  // (v_bus_size8 == `BSIZ_168)  
           
           begin
              
              smc_data8[31:16] = 16'h0;
              smc_data8[15:0]  = write_data8[15:0];
              
           end
         
         {`BSIZ_88,2'h3}:  //  (r_num_access8 == 3)
           
           begin
              
              smc_data8[31:8] = 24'h0;
              smc_data8[7:0] = write_data8[31:24];
           end
         
         {`BSIZ_88,2'h2}:  //   (r_num_access8 == 2)
           
           begin
              
              smc_data8[31:8] = 24'h0;
              smc_data8[7:0] = write_data8[23:16];
              
           end
         
         {`BSIZ_88,2'h1}:  //  (r_num_access8 == 2)
           
           begin
              
              smc_data8[31:8] = 24'h0;
              smc_data8[7:0]  = write_data8[15:8];
              
           end 
         
         {`BSIZ_88,2'h0}:  //  (r_num_access8 == 0) 
           
           begin
              
              smc_data8[31:8] = 24'h0;
              smc_data8[7:0] = write_data8[7:0];
              
           end 
         
         default:
           
           smc_data8 = 32'h0;
         
       endcase // casex(bus_size_num_access8)
       
       
    end
   
endmodule
