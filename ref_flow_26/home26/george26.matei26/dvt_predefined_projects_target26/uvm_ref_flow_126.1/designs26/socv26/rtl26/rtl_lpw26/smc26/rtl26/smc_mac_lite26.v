//File26 name   : smc_mac_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : Multiple26 access controller26.
//            : Static26 Memory Controller26.
//            : The Multiple26 Access Control26 Block keeps26 trace26 of the
//            : number26 of accesses required26 to fulfill26 the
//            : requirements26 of the AHB26 transfer26. The data is
//            : registered when multiple reads are required26. The AHB26
//            : holds26 the data during multiple writes.
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

`include "smc_defs_lite26.v"

module smc_mac_lite26     (

                    //inputs26
                    
                    sys_clk26,
                    n_sys_reset26,
                    valid_access26,
                    xfer_size26,
                    smc_done26,
                    data_smc26,
                    write_data26,
                    smc_nextstate26,
                    latch_data26,
                    
                    //outputs26
                    
                    r_num_access26,
                    mac_done26,
                    v_bus_size26,
                    v_xfer_size26,
                    read_data26,
                    smc_data26);
   
   
   
 


// State26 Machine26// I26/O26

  input                sys_clk26;        // System26 clock26
  input                n_sys_reset26;    // System26 reset (Active26 LOW26)
  input                valid_access26;   // Address cycle of new transfer26
  input  [1:0]         xfer_size26;      // xfer26 size, valid with valid_access26
  input                smc_done26;       // End26 of transfer26
  input  [31:0]        data_smc26;       // External26 read data
  input  [31:0]        write_data26;     // Data from internal bus 
  input  [4:0]         smc_nextstate26;  // State26 Machine26  
  input                latch_data26;     //latch_data26 is used by the MAC26 block    
  
  output [1:0]         r_num_access26;   // Access counter
  output               mac_done26;       // End26 of all transfers26
  output [1:0]         v_bus_size26;     // Registered26 sizes26 for subsequent26
  output [1:0]         v_xfer_size26;    // transfers26 in MAC26 transfer26
  output [31:0]        read_data26;      // Data to internal bus
  output [31:0]        smc_data26;       // Data to external26 bus
  

// Output26 register declarations26

  reg                  mac_done26;       // Indicates26 last cycle of last access
  reg [1:0]            r_num_access26;   // Access counter
  reg [1:0]            num_accesses26;   //number26 of access
  reg [1:0]            r_xfer_size26;    // Store26 size for MAC26 
  reg [1:0]            r_bus_size26;     // Store26 size for MAC26
  reg [31:0]           read_data26;      // Data path to bus IF
  reg [31:0]           r_read_data26;    // Internal data store26
  reg [31:0]           smc_data26;


// Internal Signals26

  reg [1:0]            v_bus_size26;
  reg [1:0]            v_xfer_size26;
  wire [4:0]           smc_nextstate26;    //specifies26 next state
  wire [4:0]           xfer_bus_ldata26;  //concatenation26 of xfer_size26
                                         // and latch_data26  
  wire [3:0]           bus_size_num_access26; //concatenation26 of 
                                              // r_num_access26
  wire [5:0]           wt_ldata_naccs_bsiz26;  //concatenation26 of 
                                            //latch_data26,r_num_access26
 
   


// Main26 Code26

//----------------------------------------------------------------------------
// Store26 transfer26 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk26 or negedge n_sys_reset26)
  
    begin
       
       if (~n_sys_reset26)
         
          r_xfer_size26 <= 2'b00;
       
       
       else if (valid_access26)
         
          r_xfer_size26 <= xfer_size26;
       
       else
         
          r_xfer_size26 <= r_xfer_size26;
       
    end

//--------------------------------------------------------------------
// Store26 bus size generation26
//--------------------------------------------------------------------
  
  always @(posedge sys_clk26 or negedge n_sys_reset26)
    
    begin
       
       if (~n_sys_reset26)
         
          r_bus_size26 <= 2'b00;
       
       
       else if (valid_access26)
         
          r_bus_size26 <= 2'b00;
       
       else
         
          r_bus_size26 <= r_bus_size26;
       
    end
   

//--------------------------------------------------------------------
// Validate26 sizes26 generation26
//--------------------------------------------------------------------

  always @(valid_access26 or r_bus_size26 )

    begin
       
       if (valid_access26)
         
          v_bus_size26 = 2'b0;
       
       else
         
          v_bus_size26 = r_bus_size26;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size26 generation26
//----------------------------------------------------------------------------   

  always @(valid_access26 or r_xfer_size26 or xfer_size26)

    begin
       
       if (valid_access26)
         
          v_xfer_size26 = xfer_size26;
       
       else
         
          v_xfer_size26 = r_xfer_size26;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions26
// Determines26 the number26 of accesses required26 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size26)
  
    begin
       
       if ((xfer_size26[1:0] == `XSIZ_1626))
         
          num_accesses26 = 2'h1; // Two26 accesses
       
       else if ( (xfer_size26[1:0] == `XSIZ_3226))
         
          num_accesses26 = 2'h3; // Four26 accesses
       
       else
         
          num_accesses26 = 2'h0; // One26 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep26 track26 of the current access number26
//--------------------------------------------------------------------
   
  always @(posedge sys_clk26 or negedge n_sys_reset26)
  
    begin
       
       if (~n_sys_reset26)
         
          r_num_access26 <= 2'b00;
       
       else if (valid_access26)
         
          r_num_access26 <= num_accesses26;
       
       else if (smc_done26 & (smc_nextstate26 != `SMC_STORE26)  &
                      (smc_nextstate26 != `SMC_IDLE26)   )
         
          r_num_access26 <= r_num_access26 - 2'd1;
       
       else
         
          r_num_access26 <= r_num_access26;
       
    end
   
   

//--------------------------------------------------------------------
// Detect26 last access
//--------------------------------------------------------------------
   
   always @(r_num_access26)
     
     begin
        
        if (r_num_access26 == 2'h0)
          
           mac_done26 = 1'b1;
             
        else
          
           mac_done26 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals26 concatenation26 used in case statement26 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz26 = { 1'b0, latch_data26, r_num_access26,
                                  r_bus_size26};
 
   
//--------------------------------------------------------------------
// Store26 Read Data if required26
//--------------------------------------------------------------------

   always @(posedge sys_clk26 or negedge n_sys_reset26)
     
     begin
        
        if (~n_sys_reset26)
          
           r_read_data26 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz26)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data26 <= r_read_data26;
            
            //    latch_data26
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data26[31:24] <= data_smc26[7:0];
                 r_read_data26[23:0] <= 24'h0;
                 
              end
            
            // r_num_access26 =2, v_bus_size26 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data26[23:16] <= data_smc26[7:0];
                 r_read_data26[31:24] <= r_read_data26[31:24];
                 r_read_data26[15:0] <= 16'h0;
                 
              end
            
            // r_num_access26 =1, v_bus_size26 = `XSIZ_1626
            
            {1'b0,1'b1,2'h1,`XSIZ_1626}:
              
              begin
                 
                 r_read_data26[15:0] <= 16'h0;
                 r_read_data26[31:16] <= data_smc26[15:0];
                 
              end
            
            //  r_num_access26 =1,v_bus_size26 == `XSIZ_826
            
            {1'b0,1'b1,2'h1,`XSIZ_826}:          
              
              begin
                 
                 r_read_data26[15:8] <= data_smc26[7:0];
                 r_read_data26[31:16] <= r_read_data26[31:16];
                 r_read_data26[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access26 = 0, v_bus_size26 == `XSIZ_1626
            
            {1'b0,1'b1,2'h0,`XSIZ_1626}:  // r_num_access26 =0
              
              
              begin
                 
                 r_read_data26[15:0] <= data_smc26[15:0];
                 r_read_data26[31:16] <= r_read_data26[31:16];
                 
              end
            
            //  r_num_access26 = 0, v_bus_size26 == `XSIZ_826 
            
            {1'b0,1'b1,2'h0,`XSIZ_826}:
              
              begin
                 
                 r_read_data26[7:0] <= data_smc26[7:0];
                 r_read_data26[31:8] <= r_read_data26[31:8];
                 
              end
            
            //  r_num_access26 = 0, v_bus_size26 == `XSIZ_3226
            
            {1'b0,1'b1,2'h0,`XSIZ_3226}:
              
               r_read_data26[31:0] <= data_smc26[31:0];                      
            
            default :
              
               r_read_data26 <= r_read_data26;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals26 concatenation26 for case statement26 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata26 = {r_xfer_size26,r_bus_size26,latch_data26};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata26 or data_smc26 or r_read_data26 )
       
     begin
        
        casex(xfer_bus_ldata26)
          
          {`XSIZ_3226,`BSIZ_3226,1'b1} :
            
             read_data26[31:0] = data_smc26[31:0];
          
          {`XSIZ_3226,`BSIZ_1626,1'b1} :
                              
            begin
               
               read_data26[31:16] = r_read_data26[31:16];
               read_data26[15:0]  = data_smc26[15:0];
               
            end
          
          {`XSIZ_3226,`BSIZ_826,1'b1} :
            
            begin
               
               read_data26[31:8] = r_read_data26[31:8];
               read_data26[7:0]  = data_smc26[7:0];
               
            end
          
          {`XSIZ_3226,1'bx,1'bx,1'bx} :
            
            read_data26 = r_read_data26;
          
          {`XSIZ_1626,`BSIZ_1626,1'b1} :
                        
            begin
               
               read_data26[31:16] = data_smc26[15:0];
               read_data26[15:0] = data_smc26[15:0];
               
            end
          
          {`XSIZ_1626,`BSIZ_1626,1'b0} :  
            
            begin
               
               read_data26[31:16] = r_read_data26[15:0];
               read_data26[15:0] = r_read_data26[15:0];
               
            end
          
          {`XSIZ_1626,`BSIZ_3226,1'b1} :  
            
            read_data26 = data_smc26;
          
          {`XSIZ_1626,`BSIZ_826,1'b1} : 
                        
            begin
               
               read_data26[31:24] = r_read_data26[15:8];
               read_data26[23:16] = data_smc26[7:0];
               read_data26[15:8] = r_read_data26[15:8];
               read_data26[7:0] = data_smc26[7:0];
            end
          
          {`XSIZ_1626,`BSIZ_826,1'b0} : 
            
            begin
               
               read_data26[31:16] = r_read_data26[15:0];
               read_data26[15:0] = r_read_data26[15:0];
               
            end
          
          {`XSIZ_1626,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data26[31:16] = r_read_data26[31:16];
               read_data26[15:0] = r_read_data26[15:0];
               
            end
          
          {`XSIZ_826,`BSIZ_1626,1'b1} :
            
            begin
               
               read_data26[31:16] = data_smc26[15:0];
               read_data26[15:0] = data_smc26[15:0];
               
            end
          
          {`XSIZ_826,`BSIZ_1626,1'b0} :
            
            begin
               
               read_data26[31:16] = r_read_data26[15:0];
               read_data26[15:0]  = r_read_data26[15:0];
               
            end
          
          {`XSIZ_826,`BSIZ_3226,1'b1} :   
            
            read_data26 = data_smc26;
          
          {`XSIZ_826,`BSIZ_3226,1'b0} :              
                        
                        read_data26 = r_read_data26;
          
          {`XSIZ_826,`BSIZ_826,1'b1} :   
                                    
            begin
               
               read_data26[31:24] = data_smc26[7:0];
               read_data26[23:16] = data_smc26[7:0];
               read_data26[15:8]  = data_smc26[7:0];
               read_data26[7:0]   = data_smc26[7:0];
               
            end
          
          default:
            
            begin
               
               read_data26[31:24] = r_read_data26[7:0];
               read_data26[23:16] = r_read_data26[7:0];
               read_data26[15:8]  = r_read_data26[7:0];
               read_data26[7:0]   = r_read_data26[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata26)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal26 concatenation26 for use in case statement26
//----------------------------------------------------------------------------
   
   assign bus_size_num_access26 = { r_bus_size26, r_num_access26};
   
//--------------------------------------------------------------------
// Select26 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access26 or write_data26)
  
    begin
       
       casex(bus_size_num_access26)
         
         {`BSIZ_3226,1'bx,1'bx}://    (v_bus_size26 == `BSIZ_3226)
           
           smc_data26 = write_data26;
         
         {`BSIZ_1626,2'h1}:    // r_num_access26 == 1
                      
           begin
              
              smc_data26[31:16] = 16'h0;
              smc_data26[15:0] = write_data26[31:16];
              
           end 
         
         {`BSIZ_1626,1'bx,1'bx}:  // (v_bus_size26 == `BSIZ_1626)  
           
           begin
              
              smc_data26[31:16] = 16'h0;
              smc_data26[15:0]  = write_data26[15:0];
              
           end
         
         {`BSIZ_826,2'h3}:  //  (r_num_access26 == 3)
           
           begin
              
              smc_data26[31:8] = 24'h0;
              smc_data26[7:0] = write_data26[31:24];
           end
         
         {`BSIZ_826,2'h2}:  //   (r_num_access26 == 2)
           
           begin
              
              smc_data26[31:8] = 24'h0;
              smc_data26[7:0] = write_data26[23:16];
              
           end
         
         {`BSIZ_826,2'h1}:  //  (r_num_access26 == 2)
           
           begin
              
              smc_data26[31:8] = 24'h0;
              smc_data26[7:0]  = write_data26[15:8];
              
           end 
         
         {`BSIZ_826,2'h0}:  //  (r_num_access26 == 0) 
           
           begin
              
              smc_data26[31:8] = 24'h0;
              smc_data26[7:0] = write_data26[7:0];
              
           end 
         
         default:
           
           smc_data26 = 32'h0;
         
       endcase // casex(bus_size_num_access26)
       
       
    end
   
endmodule
