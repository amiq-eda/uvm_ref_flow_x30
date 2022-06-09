//File7 name   : smc_mac_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : Multiple7 access controller7.
//            : Static7 Memory Controller7.
//            : The Multiple7 Access Control7 Block keeps7 trace7 of the
//            : number7 of accesses required7 to fulfill7 the
//            : requirements7 of the AHB7 transfer7. The data is
//            : registered when multiple reads are required7. The AHB7
//            : holds7 the data during multiple writes.
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

`include "smc_defs_lite7.v"

module smc_mac_lite7     (

                    //inputs7
                    
                    sys_clk7,
                    n_sys_reset7,
                    valid_access7,
                    xfer_size7,
                    smc_done7,
                    data_smc7,
                    write_data7,
                    smc_nextstate7,
                    latch_data7,
                    
                    //outputs7
                    
                    r_num_access7,
                    mac_done7,
                    v_bus_size7,
                    v_xfer_size7,
                    read_data7,
                    smc_data7);
   
   
   
 


// State7 Machine7// I7/O7

  input                sys_clk7;        // System7 clock7
  input                n_sys_reset7;    // System7 reset (Active7 LOW7)
  input                valid_access7;   // Address cycle of new transfer7
  input  [1:0]         xfer_size7;      // xfer7 size, valid with valid_access7
  input                smc_done7;       // End7 of transfer7
  input  [31:0]        data_smc7;       // External7 read data
  input  [31:0]        write_data7;     // Data from internal bus 
  input  [4:0]         smc_nextstate7;  // State7 Machine7  
  input                latch_data7;     //latch_data7 is used by the MAC7 block    
  
  output [1:0]         r_num_access7;   // Access counter
  output               mac_done7;       // End7 of all transfers7
  output [1:0]         v_bus_size7;     // Registered7 sizes7 for subsequent7
  output [1:0]         v_xfer_size7;    // transfers7 in MAC7 transfer7
  output [31:0]        read_data7;      // Data to internal bus
  output [31:0]        smc_data7;       // Data to external7 bus
  

// Output7 register declarations7

  reg                  mac_done7;       // Indicates7 last cycle of last access
  reg [1:0]            r_num_access7;   // Access counter
  reg [1:0]            num_accesses7;   //number7 of access
  reg [1:0]            r_xfer_size7;    // Store7 size for MAC7 
  reg [1:0]            r_bus_size7;     // Store7 size for MAC7
  reg [31:0]           read_data7;      // Data path to bus IF
  reg [31:0]           r_read_data7;    // Internal data store7
  reg [31:0]           smc_data7;


// Internal Signals7

  reg [1:0]            v_bus_size7;
  reg [1:0]            v_xfer_size7;
  wire [4:0]           smc_nextstate7;    //specifies7 next state
  wire [4:0]           xfer_bus_ldata7;  //concatenation7 of xfer_size7
                                         // and latch_data7  
  wire [3:0]           bus_size_num_access7; //concatenation7 of 
                                              // r_num_access7
  wire [5:0]           wt_ldata_naccs_bsiz7;  //concatenation7 of 
                                            //latch_data7,r_num_access7
 
   


// Main7 Code7

//----------------------------------------------------------------------------
// Store7 transfer7 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk7 or negedge n_sys_reset7)
  
    begin
       
       if (~n_sys_reset7)
         
          r_xfer_size7 <= 2'b00;
       
       
       else if (valid_access7)
         
          r_xfer_size7 <= xfer_size7;
       
       else
         
          r_xfer_size7 <= r_xfer_size7;
       
    end

//--------------------------------------------------------------------
// Store7 bus size generation7
//--------------------------------------------------------------------
  
  always @(posedge sys_clk7 or negedge n_sys_reset7)
    
    begin
       
       if (~n_sys_reset7)
         
          r_bus_size7 <= 2'b00;
       
       
       else if (valid_access7)
         
          r_bus_size7 <= 2'b00;
       
       else
         
          r_bus_size7 <= r_bus_size7;
       
    end
   

//--------------------------------------------------------------------
// Validate7 sizes7 generation7
//--------------------------------------------------------------------

  always @(valid_access7 or r_bus_size7 )

    begin
       
       if (valid_access7)
         
          v_bus_size7 = 2'b0;
       
       else
         
          v_bus_size7 = r_bus_size7;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size7 generation7
//----------------------------------------------------------------------------   

  always @(valid_access7 or r_xfer_size7 or xfer_size7)

    begin
       
       if (valid_access7)
         
          v_xfer_size7 = xfer_size7;
       
       else
         
          v_xfer_size7 = r_xfer_size7;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions7
// Determines7 the number7 of accesses required7 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size7)
  
    begin
       
       if ((xfer_size7[1:0] == `XSIZ_167))
         
          num_accesses7 = 2'h1; // Two7 accesses
       
       else if ( (xfer_size7[1:0] == `XSIZ_327))
         
          num_accesses7 = 2'h3; // Four7 accesses
       
       else
         
          num_accesses7 = 2'h0; // One7 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep7 track7 of the current access number7
//--------------------------------------------------------------------
   
  always @(posedge sys_clk7 or negedge n_sys_reset7)
  
    begin
       
       if (~n_sys_reset7)
         
          r_num_access7 <= 2'b00;
       
       else if (valid_access7)
         
          r_num_access7 <= num_accesses7;
       
       else if (smc_done7 & (smc_nextstate7 != `SMC_STORE7)  &
                      (smc_nextstate7 != `SMC_IDLE7)   )
         
          r_num_access7 <= r_num_access7 - 2'd1;
       
       else
         
          r_num_access7 <= r_num_access7;
       
    end
   
   

//--------------------------------------------------------------------
// Detect7 last access
//--------------------------------------------------------------------
   
   always @(r_num_access7)
     
     begin
        
        if (r_num_access7 == 2'h0)
          
           mac_done7 = 1'b1;
             
        else
          
           mac_done7 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals7 concatenation7 used in case statement7 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz7 = { 1'b0, latch_data7, r_num_access7,
                                  r_bus_size7};
 
   
//--------------------------------------------------------------------
// Store7 Read Data if required7
//--------------------------------------------------------------------

   always @(posedge sys_clk7 or negedge n_sys_reset7)
     
     begin
        
        if (~n_sys_reset7)
          
           r_read_data7 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz7)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data7 <= r_read_data7;
            
            //    latch_data7
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data7[31:24] <= data_smc7[7:0];
                 r_read_data7[23:0] <= 24'h0;
                 
              end
            
            // r_num_access7 =2, v_bus_size7 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data7[23:16] <= data_smc7[7:0];
                 r_read_data7[31:24] <= r_read_data7[31:24];
                 r_read_data7[15:0] <= 16'h0;
                 
              end
            
            // r_num_access7 =1, v_bus_size7 = `XSIZ_167
            
            {1'b0,1'b1,2'h1,`XSIZ_167}:
              
              begin
                 
                 r_read_data7[15:0] <= 16'h0;
                 r_read_data7[31:16] <= data_smc7[15:0];
                 
              end
            
            //  r_num_access7 =1,v_bus_size7 == `XSIZ_87
            
            {1'b0,1'b1,2'h1,`XSIZ_87}:          
              
              begin
                 
                 r_read_data7[15:8] <= data_smc7[7:0];
                 r_read_data7[31:16] <= r_read_data7[31:16];
                 r_read_data7[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access7 = 0, v_bus_size7 == `XSIZ_167
            
            {1'b0,1'b1,2'h0,`XSIZ_167}:  // r_num_access7 =0
              
              
              begin
                 
                 r_read_data7[15:0] <= data_smc7[15:0];
                 r_read_data7[31:16] <= r_read_data7[31:16];
                 
              end
            
            //  r_num_access7 = 0, v_bus_size7 == `XSIZ_87 
            
            {1'b0,1'b1,2'h0,`XSIZ_87}:
              
              begin
                 
                 r_read_data7[7:0] <= data_smc7[7:0];
                 r_read_data7[31:8] <= r_read_data7[31:8];
                 
              end
            
            //  r_num_access7 = 0, v_bus_size7 == `XSIZ_327
            
            {1'b0,1'b1,2'h0,`XSIZ_327}:
              
               r_read_data7[31:0] <= data_smc7[31:0];                      
            
            default :
              
               r_read_data7 <= r_read_data7;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals7 concatenation7 for case statement7 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata7 = {r_xfer_size7,r_bus_size7,latch_data7};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata7 or data_smc7 or r_read_data7 )
       
     begin
        
        casex(xfer_bus_ldata7)
          
          {`XSIZ_327,`BSIZ_327,1'b1} :
            
             read_data7[31:0] = data_smc7[31:0];
          
          {`XSIZ_327,`BSIZ_167,1'b1} :
                              
            begin
               
               read_data7[31:16] = r_read_data7[31:16];
               read_data7[15:0]  = data_smc7[15:0];
               
            end
          
          {`XSIZ_327,`BSIZ_87,1'b1} :
            
            begin
               
               read_data7[31:8] = r_read_data7[31:8];
               read_data7[7:0]  = data_smc7[7:0];
               
            end
          
          {`XSIZ_327,1'bx,1'bx,1'bx} :
            
            read_data7 = r_read_data7;
          
          {`XSIZ_167,`BSIZ_167,1'b1} :
                        
            begin
               
               read_data7[31:16] = data_smc7[15:0];
               read_data7[15:0] = data_smc7[15:0];
               
            end
          
          {`XSIZ_167,`BSIZ_167,1'b0} :  
            
            begin
               
               read_data7[31:16] = r_read_data7[15:0];
               read_data7[15:0] = r_read_data7[15:0];
               
            end
          
          {`XSIZ_167,`BSIZ_327,1'b1} :  
            
            read_data7 = data_smc7;
          
          {`XSIZ_167,`BSIZ_87,1'b1} : 
                        
            begin
               
               read_data7[31:24] = r_read_data7[15:8];
               read_data7[23:16] = data_smc7[7:0];
               read_data7[15:8] = r_read_data7[15:8];
               read_data7[7:0] = data_smc7[7:0];
            end
          
          {`XSIZ_167,`BSIZ_87,1'b0} : 
            
            begin
               
               read_data7[31:16] = r_read_data7[15:0];
               read_data7[15:0] = r_read_data7[15:0];
               
            end
          
          {`XSIZ_167,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data7[31:16] = r_read_data7[31:16];
               read_data7[15:0] = r_read_data7[15:0];
               
            end
          
          {`XSIZ_87,`BSIZ_167,1'b1} :
            
            begin
               
               read_data7[31:16] = data_smc7[15:0];
               read_data7[15:0] = data_smc7[15:0];
               
            end
          
          {`XSIZ_87,`BSIZ_167,1'b0} :
            
            begin
               
               read_data7[31:16] = r_read_data7[15:0];
               read_data7[15:0]  = r_read_data7[15:0];
               
            end
          
          {`XSIZ_87,`BSIZ_327,1'b1} :   
            
            read_data7 = data_smc7;
          
          {`XSIZ_87,`BSIZ_327,1'b0} :              
                        
                        read_data7 = r_read_data7;
          
          {`XSIZ_87,`BSIZ_87,1'b1} :   
                                    
            begin
               
               read_data7[31:24] = data_smc7[7:0];
               read_data7[23:16] = data_smc7[7:0];
               read_data7[15:8]  = data_smc7[7:0];
               read_data7[7:0]   = data_smc7[7:0];
               
            end
          
          default:
            
            begin
               
               read_data7[31:24] = r_read_data7[7:0];
               read_data7[23:16] = r_read_data7[7:0];
               read_data7[15:8]  = r_read_data7[7:0];
               read_data7[7:0]   = r_read_data7[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata7)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal7 concatenation7 for use in case statement7
//----------------------------------------------------------------------------
   
   assign bus_size_num_access7 = { r_bus_size7, r_num_access7};
   
//--------------------------------------------------------------------
// Select7 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access7 or write_data7)
  
    begin
       
       casex(bus_size_num_access7)
         
         {`BSIZ_327,1'bx,1'bx}://    (v_bus_size7 == `BSIZ_327)
           
           smc_data7 = write_data7;
         
         {`BSIZ_167,2'h1}:    // r_num_access7 == 1
                      
           begin
              
              smc_data7[31:16] = 16'h0;
              smc_data7[15:0] = write_data7[31:16];
              
           end 
         
         {`BSIZ_167,1'bx,1'bx}:  // (v_bus_size7 == `BSIZ_167)  
           
           begin
              
              smc_data7[31:16] = 16'h0;
              smc_data7[15:0]  = write_data7[15:0];
              
           end
         
         {`BSIZ_87,2'h3}:  //  (r_num_access7 == 3)
           
           begin
              
              smc_data7[31:8] = 24'h0;
              smc_data7[7:0] = write_data7[31:24];
           end
         
         {`BSIZ_87,2'h2}:  //   (r_num_access7 == 2)
           
           begin
              
              smc_data7[31:8] = 24'h0;
              smc_data7[7:0] = write_data7[23:16];
              
           end
         
         {`BSIZ_87,2'h1}:  //  (r_num_access7 == 2)
           
           begin
              
              smc_data7[31:8] = 24'h0;
              smc_data7[7:0]  = write_data7[15:8];
              
           end 
         
         {`BSIZ_87,2'h0}:  //  (r_num_access7 == 0) 
           
           begin
              
              smc_data7[31:8] = 24'h0;
              smc_data7[7:0] = write_data7[7:0];
              
           end 
         
         default:
           
           smc_data7 = 32'h0;
         
       endcase // casex(bus_size_num_access7)
       
       
    end
   
endmodule
