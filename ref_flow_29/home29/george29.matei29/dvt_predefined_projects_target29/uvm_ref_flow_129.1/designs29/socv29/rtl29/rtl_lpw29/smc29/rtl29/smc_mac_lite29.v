//File29 name   : smc_mac_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : Multiple29 access controller29.
//            : Static29 Memory Controller29.
//            : The Multiple29 Access Control29 Block keeps29 trace29 of the
//            : number29 of accesses required29 to fulfill29 the
//            : requirements29 of the AHB29 transfer29. The data is
//            : registered when multiple reads are required29. The AHB29
//            : holds29 the data during multiple writes.
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

`include "smc_defs_lite29.v"

module smc_mac_lite29     (

                    //inputs29
                    
                    sys_clk29,
                    n_sys_reset29,
                    valid_access29,
                    xfer_size29,
                    smc_done29,
                    data_smc29,
                    write_data29,
                    smc_nextstate29,
                    latch_data29,
                    
                    //outputs29
                    
                    r_num_access29,
                    mac_done29,
                    v_bus_size29,
                    v_xfer_size29,
                    read_data29,
                    smc_data29);
   
   
   
 


// State29 Machine29// I29/O29

  input                sys_clk29;        // System29 clock29
  input                n_sys_reset29;    // System29 reset (Active29 LOW29)
  input                valid_access29;   // Address cycle of new transfer29
  input  [1:0]         xfer_size29;      // xfer29 size, valid with valid_access29
  input                smc_done29;       // End29 of transfer29
  input  [31:0]        data_smc29;       // External29 read data
  input  [31:0]        write_data29;     // Data from internal bus 
  input  [4:0]         smc_nextstate29;  // State29 Machine29  
  input                latch_data29;     //latch_data29 is used by the MAC29 block    
  
  output [1:0]         r_num_access29;   // Access counter
  output               mac_done29;       // End29 of all transfers29
  output [1:0]         v_bus_size29;     // Registered29 sizes29 for subsequent29
  output [1:0]         v_xfer_size29;    // transfers29 in MAC29 transfer29
  output [31:0]        read_data29;      // Data to internal bus
  output [31:0]        smc_data29;       // Data to external29 bus
  

// Output29 register declarations29

  reg                  mac_done29;       // Indicates29 last cycle of last access
  reg [1:0]            r_num_access29;   // Access counter
  reg [1:0]            num_accesses29;   //number29 of access
  reg [1:0]            r_xfer_size29;    // Store29 size for MAC29 
  reg [1:0]            r_bus_size29;     // Store29 size for MAC29
  reg [31:0]           read_data29;      // Data path to bus IF
  reg [31:0]           r_read_data29;    // Internal data store29
  reg [31:0]           smc_data29;


// Internal Signals29

  reg [1:0]            v_bus_size29;
  reg [1:0]            v_xfer_size29;
  wire [4:0]           smc_nextstate29;    //specifies29 next state
  wire [4:0]           xfer_bus_ldata29;  //concatenation29 of xfer_size29
                                         // and latch_data29  
  wire [3:0]           bus_size_num_access29; //concatenation29 of 
                                              // r_num_access29
  wire [5:0]           wt_ldata_naccs_bsiz29;  //concatenation29 of 
                                            //latch_data29,r_num_access29
 
   


// Main29 Code29

//----------------------------------------------------------------------------
// Store29 transfer29 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk29 or negedge n_sys_reset29)
  
    begin
       
       if (~n_sys_reset29)
         
          r_xfer_size29 <= 2'b00;
       
       
       else if (valid_access29)
         
          r_xfer_size29 <= xfer_size29;
       
       else
         
          r_xfer_size29 <= r_xfer_size29;
       
    end

//--------------------------------------------------------------------
// Store29 bus size generation29
//--------------------------------------------------------------------
  
  always @(posedge sys_clk29 or negedge n_sys_reset29)
    
    begin
       
       if (~n_sys_reset29)
         
          r_bus_size29 <= 2'b00;
       
       
       else if (valid_access29)
         
          r_bus_size29 <= 2'b00;
       
       else
         
          r_bus_size29 <= r_bus_size29;
       
    end
   

//--------------------------------------------------------------------
// Validate29 sizes29 generation29
//--------------------------------------------------------------------

  always @(valid_access29 or r_bus_size29 )

    begin
       
       if (valid_access29)
         
          v_bus_size29 = 2'b0;
       
       else
         
          v_bus_size29 = r_bus_size29;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size29 generation29
//----------------------------------------------------------------------------   

  always @(valid_access29 or r_xfer_size29 or xfer_size29)

    begin
       
       if (valid_access29)
         
          v_xfer_size29 = xfer_size29;
       
       else
         
          v_xfer_size29 = r_xfer_size29;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions29
// Determines29 the number29 of accesses required29 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size29)
  
    begin
       
       if ((xfer_size29[1:0] == `XSIZ_1629))
         
          num_accesses29 = 2'h1; // Two29 accesses
       
       else if ( (xfer_size29[1:0] == `XSIZ_3229))
         
          num_accesses29 = 2'h3; // Four29 accesses
       
       else
         
          num_accesses29 = 2'h0; // One29 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep29 track29 of the current access number29
//--------------------------------------------------------------------
   
  always @(posedge sys_clk29 or negedge n_sys_reset29)
  
    begin
       
       if (~n_sys_reset29)
         
          r_num_access29 <= 2'b00;
       
       else if (valid_access29)
         
          r_num_access29 <= num_accesses29;
       
       else if (smc_done29 & (smc_nextstate29 != `SMC_STORE29)  &
                      (smc_nextstate29 != `SMC_IDLE29)   )
         
          r_num_access29 <= r_num_access29 - 2'd1;
       
       else
         
          r_num_access29 <= r_num_access29;
       
    end
   
   

//--------------------------------------------------------------------
// Detect29 last access
//--------------------------------------------------------------------
   
   always @(r_num_access29)
     
     begin
        
        if (r_num_access29 == 2'h0)
          
           mac_done29 = 1'b1;
             
        else
          
           mac_done29 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals29 concatenation29 used in case statement29 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz29 = { 1'b0, latch_data29, r_num_access29,
                                  r_bus_size29};
 
   
//--------------------------------------------------------------------
// Store29 Read Data if required29
//--------------------------------------------------------------------

   always @(posedge sys_clk29 or negedge n_sys_reset29)
     
     begin
        
        if (~n_sys_reset29)
          
           r_read_data29 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz29)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data29 <= r_read_data29;
            
            //    latch_data29
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data29[31:24] <= data_smc29[7:0];
                 r_read_data29[23:0] <= 24'h0;
                 
              end
            
            // r_num_access29 =2, v_bus_size29 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data29[23:16] <= data_smc29[7:0];
                 r_read_data29[31:24] <= r_read_data29[31:24];
                 r_read_data29[15:0] <= 16'h0;
                 
              end
            
            // r_num_access29 =1, v_bus_size29 = `XSIZ_1629
            
            {1'b0,1'b1,2'h1,`XSIZ_1629}:
              
              begin
                 
                 r_read_data29[15:0] <= 16'h0;
                 r_read_data29[31:16] <= data_smc29[15:0];
                 
              end
            
            //  r_num_access29 =1,v_bus_size29 == `XSIZ_829
            
            {1'b0,1'b1,2'h1,`XSIZ_829}:          
              
              begin
                 
                 r_read_data29[15:8] <= data_smc29[7:0];
                 r_read_data29[31:16] <= r_read_data29[31:16];
                 r_read_data29[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access29 = 0, v_bus_size29 == `XSIZ_1629
            
            {1'b0,1'b1,2'h0,`XSIZ_1629}:  // r_num_access29 =0
              
              
              begin
                 
                 r_read_data29[15:0] <= data_smc29[15:0];
                 r_read_data29[31:16] <= r_read_data29[31:16];
                 
              end
            
            //  r_num_access29 = 0, v_bus_size29 == `XSIZ_829 
            
            {1'b0,1'b1,2'h0,`XSIZ_829}:
              
              begin
                 
                 r_read_data29[7:0] <= data_smc29[7:0];
                 r_read_data29[31:8] <= r_read_data29[31:8];
                 
              end
            
            //  r_num_access29 = 0, v_bus_size29 == `XSIZ_3229
            
            {1'b0,1'b1,2'h0,`XSIZ_3229}:
              
               r_read_data29[31:0] <= data_smc29[31:0];                      
            
            default :
              
               r_read_data29 <= r_read_data29;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals29 concatenation29 for case statement29 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata29 = {r_xfer_size29,r_bus_size29,latch_data29};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata29 or data_smc29 or r_read_data29 )
       
     begin
        
        casex(xfer_bus_ldata29)
          
          {`XSIZ_3229,`BSIZ_3229,1'b1} :
            
             read_data29[31:0] = data_smc29[31:0];
          
          {`XSIZ_3229,`BSIZ_1629,1'b1} :
                              
            begin
               
               read_data29[31:16] = r_read_data29[31:16];
               read_data29[15:0]  = data_smc29[15:0];
               
            end
          
          {`XSIZ_3229,`BSIZ_829,1'b1} :
            
            begin
               
               read_data29[31:8] = r_read_data29[31:8];
               read_data29[7:0]  = data_smc29[7:0];
               
            end
          
          {`XSIZ_3229,1'bx,1'bx,1'bx} :
            
            read_data29 = r_read_data29;
          
          {`XSIZ_1629,`BSIZ_1629,1'b1} :
                        
            begin
               
               read_data29[31:16] = data_smc29[15:0];
               read_data29[15:0] = data_smc29[15:0];
               
            end
          
          {`XSIZ_1629,`BSIZ_1629,1'b0} :  
            
            begin
               
               read_data29[31:16] = r_read_data29[15:0];
               read_data29[15:0] = r_read_data29[15:0];
               
            end
          
          {`XSIZ_1629,`BSIZ_3229,1'b1} :  
            
            read_data29 = data_smc29;
          
          {`XSIZ_1629,`BSIZ_829,1'b1} : 
                        
            begin
               
               read_data29[31:24] = r_read_data29[15:8];
               read_data29[23:16] = data_smc29[7:0];
               read_data29[15:8] = r_read_data29[15:8];
               read_data29[7:0] = data_smc29[7:0];
            end
          
          {`XSIZ_1629,`BSIZ_829,1'b0} : 
            
            begin
               
               read_data29[31:16] = r_read_data29[15:0];
               read_data29[15:0] = r_read_data29[15:0];
               
            end
          
          {`XSIZ_1629,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data29[31:16] = r_read_data29[31:16];
               read_data29[15:0] = r_read_data29[15:0];
               
            end
          
          {`XSIZ_829,`BSIZ_1629,1'b1} :
            
            begin
               
               read_data29[31:16] = data_smc29[15:0];
               read_data29[15:0] = data_smc29[15:0];
               
            end
          
          {`XSIZ_829,`BSIZ_1629,1'b0} :
            
            begin
               
               read_data29[31:16] = r_read_data29[15:0];
               read_data29[15:0]  = r_read_data29[15:0];
               
            end
          
          {`XSIZ_829,`BSIZ_3229,1'b1} :   
            
            read_data29 = data_smc29;
          
          {`XSIZ_829,`BSIZ_3229,1'b0} :              
                        
                        read_data29 = r_read_data29;
          
          {`XSIZ_829,`BSIZ_829,1'b1} :   
                                    
            begin
               
               read_data29[31:24] = data_smc29[7:0];
               read_data29[23:16] = data_smc29[7:0];
               read_data29[15:8]  = data_smc29[7:0];
               read_data29[7:0]   = data_smc29[7:0];
               
            end
          
          default:
            
            begin
               
               read_data29[31:24] = r_read_data29[7:0];
               read_data29[23:16] = r_read_data29[7:0];
               read_data29[15:8]  = r_read_data29[7:0];
               read_data29[7:0]   = r_read_data29[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata29)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal29 concatenation29 for use in case statement29
//----------------------------------------------------------------------------
   
   assign bus_size_num_access29 = { r_bus_size29, r_num_access29};
   
//--------------------------------------------------------------------
// Select29 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access29 or write_data29)
  
    begin
       
       casex(bus_size_num_access29)
         
         {`BSIZ_3229,1'bx,1'bx}://    (v_bus_size29 == `BSIZ_3229)
           
           smc_data29 = write_data29;
         
         {`BSIZ_1629,2'h1}:    // r_num_access29 == 1
                      
           begin
              
              smc_data29[31:16] = 16'h0;
              smc_data29[15:0] = write_data29[31:16];
              
           end 
         
         {`BSIZ_1629,1'bx,1'bx}:  // (v_bus_size29 == `BSIZ_1629)  
           
           begin
              
              smc_data29[31:16] = 16'h0;
              smc_data29[15:0]  = write_data29[15:0];
              
           end
         
         {`BSIZ_829,2'h3}:  //  (r_num_access29 == 3)
           
           begin
              
              smc_data29[31:8] = 24'h0;
              smc_data29[7:0] = write_data29[31:24];
           end
         
         {`BSIZ_829,2'h2}:  //   (r_num_access29 == 2)
           
           begin
              
              smc_data29[31:8] = 24'h0;
              smc_data29[7:0] = write_data29[23:16];
              
           end
         
         {`BSIZ_829,2'h1}:  //  (r_num_access29 == 2)
           
           begin
              
              smc_data29[31:8] = 24'h0;
              smc_data29[7:0]  = write_data29[15:8];
              
           end 
         
         {`BSIZ_829,2'h0}:  //  (r_num_access29 == 0) 
           
           begin
              
              smc_data29[31:8] = 24'h0;
              smc_data29[7:0] = write_data29[7:0];
              
           end 
         
         default:
           
           smc_data29 = 32'h0;
         
       endcase // casex(bus_size_num_access29)
       
       
    end
   
endmodule
