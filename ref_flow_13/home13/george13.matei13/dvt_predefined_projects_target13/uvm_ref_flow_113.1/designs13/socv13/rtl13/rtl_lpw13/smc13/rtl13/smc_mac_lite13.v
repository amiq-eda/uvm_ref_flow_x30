//File13 name   : smc_mac_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : Multiple13 access controller13.
//            : Static13 Memory Controller13.
//            : The Multiple13 Access Control13 Block keeps13 trace13 of the
//            : number13 of accesses required13 to fulfill13 the
//            : requirements13 of the AHB13 transfer13. The data is
//            : registered when multiple reads are required13. The AHB13
//            : holds13 the data during multiple writes.
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

`include "smc_defs_lite13.v"

module smc_mac_lite13     (

                    //inputs13
                    
                    sys_clk13,
                    n_sys_reset13,
                    valid_access13,
                    xfer_size13,
                    smc_done13,
                    data_smc13,
                    write_data13,
                    smc_nextstate13,
                    latch_data13,
                    
                    //outputs13
                    
                    r_num_access13,
                    mac_done13,
                    v_bus_size13,
                    v_xfer_size13,
                    read_data13,
                    smc_data13);
   
   
   
 


// State13 Machine13// I13/O13

  input                sys_clk13;        // System13 clock13
  input                n_sys_reset13;    // System13 reset (Active13 LOW13)
  input                valid_access13;   // Address cycle of new transfer13
  input  [1:0]         xfer_size13;      // xfer13 size, valid with valid_access13
  input                smc_done13;       // End13 of transfer13
  input  [31:0]        data_smc13;       // External13 read data
  input  [31:0]        write_data13;     // Data from internal bus 
  input  [4:0]         smc_nextstate13;  // State13 Machine13  
  input                latch_data13;     //latch_data13 is used by the MAC13 block    
  
  output [1:0]         r_num_access13;   // Access counter
  output               mac_done13;       // End13 of all transfers13
  output [1:0]         v_bus_size13;     // Registered13 sizes13 for subsequent13
  output [1:0]         v_xfer_size13;    // transfers13 in MAC13 transfer13
  output [31:0]        read_data13;      // Data to internal bus
  output [31:0]        smc_data13;       // Data to external13 bus
  

// Output13 register declarations13

  reg                  mac_done13;       // Indicates13 last cycle of last access
  reg [1:0]            r_num_access13;   // Access counter
  reg [1:0]            num_accesses13;   //number13 of access
  reg [1:0]            r_xfer_size13;    // Store13 size for MAC13 
  reg [1:0]            r_bus_size13;     // Store13 size for MAC13
  reg [31:0]           read_data13;      // Data path to bus IF
  reg [31:0]           r_read_data13;    // Internal data store13
  reg [31:0]           smc_data13;


// Internal Signals13

  reg [1:0]            v_bus_size13;
  reg [1:0]            v_xfer_size13;
  wire [4:0]           smc_nextstate13;    //specifies13 next state
  wire [4:0]           xfer_bus_ldata13;  //concatenation13 of xfer_size13
                                         // and latch_data13  
  wire [3:0]           bus_size_num_access13; //concatenation13 of 
                                              // r_num_access13
  wire [5:0]           wt_ldata_naccs_bsiz13;  //concatenation13 of 
                                            //latch_data13,r_num_access13
 
   


// Main13 Code13

//----------------------------------------------------------------------------
// Store13 transfer13 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk13 or negedge n_sys_reset13)
  
    begin
       
       if (~n_sys_reset13)
         
          r_xfer_size13 <= 2'b00;
       
       
       else if (valid_access13)
         
          r_xfer_size13 <= xfer_size13;
       
       else
         
          r_xfer_size13 <= r_xfer_size13;
       
    end

//--------------------------------------------------------------------
// Store13 bus size generation13
//--------------------------------------------------------------------
  
  always @(posedge sys_clk13 or negedge n_sys_reset13)
    
    begin
       
       if (~n_sys_reset13)
         
          r_bus_size13 <= 2'b00;
       
       
       else if (valid_access13)
         
          r_bus_size13 <= 2'b00;
       
       else
         
          r_bus_size13 <= r_bus_size13;
       
    end
   

//--------------------------------------------------------------------
// Validate13 sizes13 generation13
//--------------------------------------------------------------------

  always @(valid_access13 or r_bus_size13 )

    begin
       
       if (valid_access13)
         
          v_bus_size13 = 2'b0;
       
       else
         
          v_bus_size13 = r_bus_size13;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size13 generation13
//----------------------------------------------------------------------------   

  always @(valid_access13 or r_xfer_size13 or xfer_size13)

    begin
       
       if (valid_access13)
         
          v_xfer_size13 = xfer_size13;
       
       else
         
          v_xfer_size13 = r_xfer_size13;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions13
// Determines13 the number13 of accesses required13 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size13)
  
    begin
       
       if ((xfer_size13[1:0] == `XSIZ_1613))
         
          num_accesses13 = 2'h1; // Two13 accesses
       
       else if ( (xfer_size13[1:0] == `XSIZ_3213))
         
          num_accesses13 = 2'h3; // Four13 accesses
       
       else
         
          num_accesses13 = 2'h0; // One13 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep13 track13 of the current access number13
//--------------------------------------------------------------------
   
  always @(posedge sys_clk13 or negedge n_sys_reset13)
  
    begin
       
       if (~n_sys_reset13)
         
          r_num_access13 <= 2'b00;
       
       else if (valid_access13)
         
          r_num_access13 <= num_accesses13;
       
       else if (smc_done13 & (smc_nextstate13 != `SMC_STORE13)  &
                      (smc_nextstate13 != `SMC_IDLE13)   )
         
          r_num_access13 <= r_num_access13 - 2'd1;
       
       else
         
          r_num_access13 <= r_num_access13;
       
    end
   
   

//--------------------------------------------------------------------
// Detect13 last access
//--------------------------------------------------------------------
   
   always @(r_num_access13)
     
     begin
        
        if (r_num_access13 == 2'h0)
          
           mac_done13 = 1'b1;
             
        else
          
           mac_done13 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals13 concatenation13 used in case statement13 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz13 = { 1'b0, latch_data13, r_num_access13,
                                  r_bus_size13};
 
   
//--------------------------------------------------------------------
// Store13 Read Data if required13
//--------------------------------------------------------------------

   always @(posedge sys_clk13 or negedge n_sys_reset13)
     
     begin
        
        if (~n_sys_reset13)
          
           r_read_data13 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz13)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data13 <= r_read_data13;
            
            //    latch_data13
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data13[31:24] <= data_smc13[7:0];
                 r_read_data13[23:0] <= 24'h0;
                 
              end
            
            // r_num_access13 =2, v_bus_size13 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data13[23:16] <= data_smc13[7:0];
                 r_read_data13[31:24] <= r_read_data13[31:24];
                 r_read_data13[15:0] <= 16'h0;
                 
              end
            
            // r_num_access13 =1, v_bus_size13 = `XSIZ_1613
            
            {1'b0,1'b1,2'h1,`XSIZ_1613}:
              
              begin
                 
                 r_read_data13[15:0] <= 16'h0;
                 r_read_data13[31:16] <= data_smc13[15:0];
                 
              end
            
            //  r_num_access13 =1,v_bus_size13 == `XSIZ_813
            
            {1'b0,1'b1,2'h1,`XSIZ_813}:          
              
              begin
                 
                 r_read_data13[15:8] <= data_smc13[7:0];
                 r_read_data13[31:16] <= r_read_data13[31:16];
                 r_read_data13[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access13 = 0, v_bus_size13 == `XSIZ_1613
            
            {1'b0,1'b1,2'h0,`XSIZ_1613}:  // r_num_access13 =0
              
              
              begin
                 
                 r_read_data13[15:0] <= data_smc13[15:0];
                 r_read_data13[31:16] <= r_read_data13[31:16];
                 
              end
            
            //  r_num_access13 = 0, v_bus_size13 == `XSIZ_813 
            
            {1'b0,1'b1,2'h0,`XSIZ_813}:
              
              begin
                 
                 r_read_data13[7:0] <= data_smc13[7:0];
                 r_read_data13[31:8] <= r_read_data13[31:8];
                 
              end
            
            //  r_num_access13 = 0, v_bus_size13 == `XSIZ_3213
            
            {1'b0,1'b1,2'h0,`XSIZ_3213}:
              
               r_read_data13[31:0] <= data_smc13[31:0];                      
            
            default :
              
               r_read_data13 <= r_read_data13;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals13 concatenation13 for case statement13 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata13 = {r_xfer_size13,r_bus_size13,latch_data13};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata13 or data_smc13 or r_read_data13 )
       
     begin
        
        casex(xfer_bus_ldata13)
          
          {`XSIZ_3213,`BSIZ_3213,1'b1} :
            
             read_data13[31:0] = data_smc13[31:0];
          
          {`XSIZ_3213,`BSIZ_1613,1'b1} :
                              
            begin
               
               read_data13[31:16] = r_read_data13[31:16];
               read_data13[15:0]  = data_smc13[15:0];
               
            end
          
          {`XSIZ_3213,`BSIZ_813,1'b1} :
            
            begin
               
               read_data13[31:8] = r_read_data13[31:8];
               read_data13[7:0]  = data_smc13[7:0];
               
            end
          
          {`XSIZ_3213,1'bx,1'bx,1'bx} :
            
            read_data13 = r_read_data13;
          
          {`XSIZ_1613,`BSIZ_1613,1'b1} :
                        
            begin
               
               read_data13[31:16] = data_smc13[15:0];
               read_data13[15:0] = data_smc13[15:0];
               
            end
          
          {`XSIZ_1613,`BSIZ_1613,1'b0} :  
            
            begin
               
               read_data13[31:16] = r_read_data13[15:0];
               read_data13[15:0] = r_read_data13[15:0];
               
            end
          
          {`XSIZ_1613,`BSIZ_3213,1'b1} :  
            
            read_data13 = data_smc13;
          
          {`XSIZ_1613,`BSIZ_813,1'b1} : 
                        
            begin
               
               read_data13[31:24] = r_read_data13[15:8];
               read_data13[23:16] = data_smc13[7:0];
               read_data13[15:8] = r_read_data13[15:8];
               read_data13[7:0] = data_smc13[7:0];
            end
          
          {`XSIZ_1613,`BSIZ_813,1'b0} : 
            
            begin
               
               read_data13[31:16] = r_read_data13[15:0];
               read_data13[15:0] = r_read_data13[15:0];
               
            end
          
          {`XSIZ_1613,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data13[31:16] = r_read_data13[31:16];
               read_data13[15:0] = r_read_data13[15:0];
               
            end
          
          {`XSIZ_813,`BSIZ_1613,1'b1} :
            
            begin
               
               read_data13[31:16] = data_smc13[15:0];
               read_data13[15:0] = data_smc13[15:0];
               
            end
          
          {`XSIZ_813,`BSIZ_1613,1'b0} :
            
            begin
               
               read_data13[31:16] = r_read_data13[15:0];
               read_data13[15:0]  = r_read_data13[15:0];
               
            end
          
          {`XSIZ_813,`BSIZ_3213,1'b1} :   
            
            read_data13 = data_smc13;
          
          {`XSIZ_813,`BSIZ_3213,1'b0} :              
                        
                        read_data13 = r_read_data13;
          
          {`XSIZ_813,`BSIZ_813,1'b1} :   
                                    
            begin
               
               read_data13[31:24] = data_smc13[7:0];
               read_data13[23:16] = data_smc13[7:0];
               read_data13[15:8]  = data_smc13[7:0];
               read_data13[7:0]   = data_smc13[7:0];
               
            end
          
          default:
            
            begin
               
               read_data13[31:24] = r_read_data13[7:0];
               read_data13[23:16] = r_read_data13[7:0];
               read_data13[15:8]  = r_read_data13[7:0];
               read_data13[7:0]   = r_read_data13[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata13)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal13 concatenation13 for use in case statement13
//----------------------------------------------------------------------------
   
   assign bus_size_num_access13 = { r_bus_size13, r_num_access13};
   
//--------------------------------------------------------------------
// Select13 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access13 or write_data13)
  
    begin
       
       casex(bus_size_num_access13)
         
         {`BSIZ_3213,1'bx,1'bx}://    (v_bus_size13 == `BSIZ_3213)
           
           smc_data13 = write_data13;
         
         {`BSIZ_1613,2'h1}:    // r_num_access13 == 1
                      
           begin
              
              smc_data13[31:16] = 16'h0;
              smc_data13[15:0] = write_data13[31:16];
              
           end 
         
         {`BSIZ_1613,1'bx,1'bx}:  // (v_bus_size13 == `BSIZ_1613)  
           
           begin
              
              smc_data13[31:16] = 16'h0;
              smc_data13[15:0]  = write_data13[15:0];
              
           end
         
         {`BSIZ_813,2'h3}:  //  (r_num_access13 == 3)
           
           begin
              
              smc_data13[31:8] = 24'h0;
              smc_data13[7:0] = write_data13[31:24];
           end
         
         {`BSIZ_813,2'h2}:  //   (r_num_access13 == 2)
           
           begin
              
              smc_data13[31:8] = 24'h0;
              smc_data13[7:0] = write_data13[23:16];
              
           end
         
         {`BSIZ_813,2'h1}:  //  (r_num_access13 == 2)
           
           begin
              
              smc_data13[31:8] = 24'h0;
              smc_data13[7:0]  = write_data13[15:8];
              
           end 
         
         {`BSIZ_813,2'h0}:  //  (r_num_access13 == 0) 
           
           begin
              
              smc_data13[31:8] = 24'h0;
              smc_data13[7:0] = write_data13[7:0];
              
           end 
         
         default:
           
           smc_data13 = 32'h0;
         
       endcase // casex(bus_size_num_access13)
       
       
    end
   
endmodule
