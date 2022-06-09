//File16 name   : smc_mac_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : Multiple16 access controller16.
//            : Static16 Memory Controller16.
//            : The Multiple16 Access Control16 Block keeps16 trace16 of the
//            : number16 of accesses required16 to fulfill16 the
//            : requirements16 of the AHB16 transfer16. The data is
//            : registered when multiple reads are required16. The AHB16
//            : holds16 the data during multiple writes.
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

`include "smc_defs_lite16.v"

module smc_mac_lite16     (

                    //inputs16
                    
                    sys_clk16,
                    n_sys_reset16,
                    valid_access16,
                    xfer_size16,
                    smc_done16,
                    data_smc16,
                    write_data16,
                    smc_nextstate16,
                    latch_data16,
                    
                    //outputs16
                    
                    r_num_access16,
                    mac_done16,
                    v_bus_size16,
                    v_xfer_size16,
                    read_data16,
                    smc_data16);
   
   
   
 


// State16 Machine16// I16/O16

  input                sys_clk16;        // System16 clock16
  input                n_sys_reset16;    // System16 reset (Active16 LOW16)
  input                valid_access16;   // Address cycle of new transfer16
  input  [1:0]         xfer_size16;      // xfer16 size, valid with valid_access16
  input                smc_done16;       // End16 of transfer16
  input  [31:0]        data_smc16;       // External16 read data
  input  [31:0]        write_data16;     // Data from internal bus 
  input  [4:0]         smc_nextstate16;  // State16 Machine16  
  input                latch_data16;     //latch_data16 is used by the MAC16 block    
  
  output [1:0]         r_num_access16;   // Access counter
  output               mac_done16;       // End16 of all transfers16
  output [1:0]         v_bus_size16;     // Registered16 sizes16 for subsequent16
  output [1:0]         v_xfer_size16;    // transfers16 in MAC16 transfer16
  output [31:0]        read_data16;      // Data to internal bus
  output [31:0]        smc_data16;       // Data to external16 bus
  

// Output16 register declarations16

  reg                  mac_done16;       // Indicates16 last cycle of last access
  reg [1:0]            r_num_access16;   // Access counter
  reg [1:0]            num_accesses16;   //number16 of access
  reg [1:0]            r_xfer_size16;    // Store16 size for MAC16 
  reg [1:0]            r_bus_size16;     // Store16 size for MAC16
  reg [31:0]           read_data16;      // Data path to bus IF
  reg [31:0]           r_read_data16;    // Internal data store16
  reg [31:0]           smc_data16;


// Internal Signals16

  reg [1:0]            v_bus_size16;
  reg [1:0]            v_xfer_size16;
  wire [4:0]           smc_nextstate16;    //specifies16 next state
  wire [4:0]           xfer_bus_ldata16;  //concatenation16 of xfer_size16
                                         // and latch_data16  
  wire [3:0]           bus_size_num_access16; //concatenation16 of 
                                              // r_num_access16
  wire [5:0]           wt_ldata_naccs_bsiz16;  //concatenation16 of 
                                            //latch_data16,r_num_access16
 
   


// Main16 Code16

//----------------------------------------------------------------------------
// Store16 transfer16 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk16 or negedge n_sys_reset16)
  
    begin
       
       if (~n_sys_reset16)
         
          r_xfer_size16 <= 2'b00;
       
       
       else if (valid_access16)
         
          r_xfer_size16 <= xfer_size16;
       
       else
         
          r_xfer_size16 <= r_xfer_size16;
       
    end

//--------------------------------------------------------------------
// Store16 bus size generation16
//--------------------------------------------------------------------
  
  always @(posedge sys_clk16 or negedge n_sys_reset16)
    
    begin
       
       if (~n_sys_reset16)
         
          r_bus_size16 <= 2'b00;
       
       
       else if (valid_access16)
         
          r_bus_size16 <= 2'b00;
       
       else
         
          r_bus_size16 <= r_bus_size16;
       
    end
   

//--------------------------------------------------------------------
// Validate16 sizes16 generation16
//--------------------------------------------------------------------

  always @(valid_access16 or r_bus_size16 )

    begin
       
       if (valid_access16)
         
          v_bus_size16 = 2'b0;
       
       else
         
          v_bus_size16 = r_bus_size16;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size16 generation16
//----------------------------------------------------------------------------   

  always @(valid_access16 or r_xfer_size16 or xfer_size16)

    begin
       
       if (valid_access16)
         
          v_xfer_size16 = xfer_size16;
       
       else
         
          v_xfer_size16 = r_xfer_size16;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions16
// Determines16 the number16 of accesses required16 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size16)
  
    begin
       
       if ((xfer_size16[1:0] == `XSIZ_1616))
         
          num_accesses16 = 2'h1; // Two16 accesses
       
       else if ( (xfer_size16[1:0] == `XSIZ_3216))
         
          num_accesses16 = 2'h3; // Four16 accesses
       
       else
         
          num_accesses16 = 2'h0; // One16 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep16 track16 of the current access number16
//--------------------------------------------------------------------
   
  always @(posedge sys_clk16 or negedge n_sys_reset16)
  
    begin
       
       if (~n_sys_reset16)
         
          r_num_access16 <= 2'b00;
       
       else if (valid_access16)
         
          r_num_access16 <= num_accesses16;
       
       else if (smc_done16 & (smc_nextstate16 != `SMC_STORE16)  &
                      (smc_nextstate16 != `SMC_IDLE16)   )
         
          r_num_access16 <= r_num_access16 - 2'd1;
       
       else
         
          r_num_access16 <= r_num_access16;
       
    end
   
   

//--------------------------------------------------------------------
// Detect16 last access
//--------------------------------------------------------------------
   
   always @(r_num_access16)
     
     begin
        
        if (r_num_access16 == 2'h0)
          
           mac_done16 = 1'b1;
             
        else
          
           mac_done16 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals16 concatenation16 used in case statement16 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz16 = { 1'b0, latch_data16, r_num_access16,
                                  r_bus_size16};
 
   
//--------------------------------------------------------------------
// Store16 Read Data if required16
//--------------------------------------------------------------------

   always @(posedge sys_clk16 or negedge n_sys_reset16)
     
     begin
        
        if (~n_sys_reset16)
          
           r_read_data16 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz16)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data16 <= r_read_data16;
            
            //    latch_data16
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data16[31:24] <= data_smc16[7:0];
                 r_read_data16[23:0] <= 24'h0;
                 
              end
            
            // r_num_access16 =2, v_bus_size16 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data16[23:16] <= data_smc16[7:0];
                 r_read_data16[31:24] <= r_read_data16[31:24];
                 r_read_data16[15:0] <= 16'h0;
                 
              end
            
            // r_num_access16 =1, v_bus_size16 = `XSIZ_1616
            
            {1'b0,1'b1,2'h1,`XSIZ_1616}:
              
              begin
                 
                 r_read_data16[15:0] <= 16'h0;
                 r_read_data16[31:16] <= data_smc16[15:0];
                 
              end
            
            //  r_num_access16 =1,v_bus_size16 == `XSIZ_816
            
            {1'b0,1'b1,2'h1,`XSIZ_816}:          
              
              begin
                 
                 r_read_data16[15:8] <= data_smc16[7:0];
                 r_read_data16[31:16] <= r_read_data16[31:16];
                 r_read_data16[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access16 = 0, v_bus_size16 == `XSIZ_1616
            
            {1'b0,1'b1,2'h0,`XSIZ_1616}:  // r_num_access16 =0
              
              
              begin
                 
                 r_read_data16[15:0] <= data_smc16[15:0];
                 r_read_data16[31:16] <= r_read_data16[31:16];
                 
              end
            
            //  r_num_access16 = 0, v_bus_size16 == `XSIZ_816 
            
            {1'b0,1'b1,2'h0,`XSIZ_816}:
              
              begin
                 
                 r_read_data16[7:0] <= data_smc16[7:0];
                 r_read_data16[31:8] <= r_read_data16[31:8];
                 
              end
            
            //  r_num_access16 = 0, v_bus_size16 == `XSIZ_3216
            
            {1'b0,1'b1,2'h0,`XSIZ_3216}:
              
               r_read_data16[31:0] <= data_smc16[31:0];                      
            
            default :
              
               r_read_data16 <= r_read_data16;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals16 concatenation16 for case statement16 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata16 = {r_xfer_size16,r_bus_size16,latch_data16};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata16 or data_smc16 or r_read_data16 )
       
     begin
        
        casex(xfer_bus_ldata16)
          
          {`XSIZ_3216,`BSIZ_3216,1'b1} :
            
             read_data16[31:0] = data_smc16[31:0];
          
          {`XSIZ_3216,`BSIZ_1616,1'b1} :
                              
            begin
               
               read_data16[31:16] = r_read_data16[31:16];
               read_data16[15:0]  = data_smc16[15:0];
               
            end
          
          {`XSIZ_3216,`BSIZ_816,1'b1} :
            
            begin
               
               read_data16[31:8] = r_read_data16[31:8];
               read_data16[7:0]  = data_smc16[7:0];
               
            end
          
          {`XSIZ_3216,1'bx,1'bx,1'bx} :
            
            read_data16 = r_read_data16;
          
          {`XSIZ_1616,`BSIZ_1616,1'b1} :
                        
            begin
               
               read_data16[31:16] = data_smc16[15:0];
               read_data16[15:0] = data_smc16[15:0];
               
            end
          
          {`XSIZ_1616,`BSIZ_1616,1'b0} :  
            
            begin
               
               read_data16[31:16] = r_read_data16[15:0];
               read_data16[15:0] = r_read_data16[15:0];
               
            end
          
          {`XSIZ_1616,`BSIZ_3216,1'b1} :  
            
            read_data16 = data_smc16;
          
          {`XSIZ_1616,`BSIZ_816,1'b1} : 
                        
            begin
               
               read_data16[31:24] = r_read_data16[15:8];
               read_data16[23:16] = data_smc16[7:0];
               read_data16[15:8] = r_read_data16[15:8];
               read_data16[7:0] = data_smc16[7:0];
            end
          
          {`XSIZ_1616,`BSIZ_816,1'b0} : 
            
            begin
               
               read_data16[31:16] = r_read_data16[15:0];
               read_data16[15:0] = r_read_data16[15:0];
               
            end
          
          {`XSIZ_1616,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data16[31:16] = r_read_data16[31:16];
               read_data16[15:0] = r_read_data16[15:0];
               
            end
          
          {`XSIZ_816,`BSIZ_1616,1'b1} :
            
            begin
               
               read_data16[31:16] = data_smc16[15:0];
               read_data16[15:0] = data_smc16[15:0];
               
            end
          
          {`XSIZ_816,`BSIZ_1616,1'b0} :
            
            begin
               
               read_data16[31:16] = r_read_data16[15:0];
               read_data16[15:0]  = r_read_data16[15:0];
               
            end
          
          {`XSIZ_816,`BSIZ_3216,1'b1} :   
            
            read_data16 = data_smc16;
          
          {`XSIZ_816,`BSIZ_3216,1'b0} :              
                        
                        read_data16 = r_read_data16;
          
          {`XSIZ_816,`BSIZ_816,1'b1} :   
                                    
            begin
               
               read_data16[31:24] = data_smc16[7:0];
               read_data16[23:16] = data_smc16[7:0];
               read_data16[15:8]  = data_smc16[7:0];
               read_data16[7:0]   = data_smc16[7:0];
               
            end
          
          default:
            
            begin
               
               read_data16[31:24] = r_read_data16[7:0];
               read_data16[23:16] = r_read_data16[7:0];
               read_data16[15:8]  = r_read_data16[7:0];
               read_data16[7:0]   = r_read_data16[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata16)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal16 concatenation16 for use in case statement16
//----------------------------------------------------------------------------
   
   assign bus_size_num_access16 = { r_bus_size16, r_num_access16};
   
//--------------------------------------------------------------------
// Select16 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access16 or write_data16)
  
    begin
       
       casex(bus_size_num_access16)
         
         {`BSIZ_3216,1'bx,1'bx}://    (v_bus_size16 == `BSIZ_3216)
           
           smc_data16 = write_data16;
         
         {`BSIZ_1616,2'h1}:    // r_num_access16 == 1
                      
           begin
              
              smc_data16[31:16] = 16'h0;
              smc_data16[15:0] = write_data16[31:16];
              
           end 
         
         {`BSIZ_1616,1'bx,1'bx}:  // (v_bus_size16 == `BSIZ_1616)  
           
           begin
              
              smc_data16[31:16] = 16'h0;
              smc_data16[15:0]  = write_data16[15:0];
              
           end
         
         {`BSIZ_816,2'h3}:  //  (r_num_access16 == 3)
           
           begin
              
              smc_data16[31:8] = 24'h0;
              smc_data16[7:0] = write_data16[31:24];
           end
         
         {`BSIZ_816,2'h2}:  //   (r_num_access16 == 2)
           
           begin
              
              smc_data16[31:8] = 24'h0;
              smc_data16[7:0] = write_data16[23:16];
              
           end
         
         {`BSIZ_816,2'h1}:  //  (r_num_access16 == 2)
           
           begin
              
              smc_data16[31:8] = 24'h0;
              smc_data16[7:0]  = write_data16[15:8];
              
           end 
         
         {`BSIZ_816,2'h0}:  //  (r_num_access16 == 0) 
           
           begin
              
              smc_data16[31:8] = 24'h0;
              smc_data16[7:0] = write_data16[7:0];
              
           end 
         
         default:
           
           smc_data16 = 32'h0;
         
       endcase // casex(bus_size_num_access16)
       
       
    end
   
endmodule
