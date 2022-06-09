//File14 name   : smc_mac_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : Multiple14 access controller14.
//            : Static14 Memory Controller14.
//            : The Multiple14 Access Control14 Block keeps14 trace14 of the
//            : number14 of accesses required14 to fulfill14 the
//            : requirements14 of the AHB14 transfer14. The data is
//            : registered when multiple reads are required14. The AHB14
//            : holds14 the data during multiple writes.
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

`include "smc_defs_lite14.v"

module smc_mac_lite14     (

                    //inputs14
                    
                    sys_clk14,
                    n_sys_reset14,
                    valid_access14,
                    xfer_size14,
                    smc_done14,
                    data_smc14,
                    write_data14,
                    smc_nextstate14,
                    latch_data14,
                    
                    //outputs14
                    
                    r_num_access14,
                    mac_done14,
                    v_bus_size14,
                    v_xfer_size14,
                    read_data14,
                    smc_data14);
   
   
   
 


// State14 Machine14// I14/O14

  input                sys_clk14;        // System14 clock14
  input                n_sys_reset14;    // System14 reset (Active14 LOW14)
  input                valid_access14;   // Address cycle of new transfer14
  input  [1:0]         xfer_size14;      // xfer14 size, valid with valid_access14
  input                smc_done14;       // End14 of transfer14
  input  [31:0]        data_smc14;       // External14 read data
  input  [31:0]        write_data14;     // Data from internal bus 
  input  [4:0]         smc_nextstate14;  // State14 Machine14  
  input                latch_data14;     //latch_data14 is used by the MAC14 block    
  
  output [1:0]         r_num_access14;   // Access counter
  output               mac_done14;       // End14 of all transfers14
  output [1:0]         v_bus_size14;     // Registered14 sizes14 for subsequent14
  output [1:0]         v_xfer_size14;    // transfers14 in MAC14 transfer14
  output [31:0]        read_data14;      // Data to internal bus
  output [31:0]        smc_data14;       // Data to external14 bus
  

// Output14 register declarations14

  reg                  mac_done14;       // Indicates14 last cycle of last access
  reg [1:0]            r_num_access14;   // Access counter
  reg [1:0]            num_accesses14;   //number14 of access
  reg [1:0]            r_xfer_size14;    // Store14 size for MAC14 
  reg [1:0]            r_bus_size14;     // Store14 size for MAC14
  reg [31:0]           read_data14;      // Data path to bus IF
  reg [31:0]           r_read_data14;    // Internal data store14
  reg [31:0]           smc_data14;


// Internal Signals14

  reg [1:0]            v_bus_size14;
  reg [1:0]            v_xfer_size14;
  wire [4:0]           smc_nextstate14;    //specifies14 next state
  wire [4:0]           xfer_bus_ldata14;  //concatenation14 of xfer_size14
                                         // and latch_data14  
  wire [3:0]           bus_size_num_access14; //concatenation14 of 
                                              // r_num_access14
  wire [5:0]           wt_ldata_naccs_bsiz14;  //concatenation14 of 
                                            //latch_data14,r_num_access14
 
   


// Main14 Code14

//----------------------------------------------------------------------------
// Store14 transfer14 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk14 or negedge n_sys_reset14)
  
    begin
       
       if (~n_sys_reset14)
         
          r_xfer_size14 <= 2'b00;
       
       
       else if (valid_access14)
         
          r_xfer_size14 <= xfer_size14;
       
       else
         
          r_xfer_size14 <= r_xfer_size14;
       
    end

//--------------------------------------------------------------------
// Store14 bus size generation14
//--------------------------------------------------------------------
  
  always @(posedge sys_clk14 or negedge n_sys_reset14)
    
    begin
       
       if (~n_sys_reset14)
         
          r_bus_size14 <= 2'b00;
       
       
       else if (valid_access14)
         
          r_bus_size14 <= 2'b00;
       
       else
         
          r_bus_size14 <= r_bus_size14;
       
    end
   

//--------------------------------------------------------------------
// Validate14 sizes14 generation14
//--------------------------------------------------------------------

  always @(valid_access14 or r_bus_size14 )

    begin
       
       if (valid_access14)
         
          v_bus_size14 = 2'b0;
       
       else
         
          v_bus_size14 = r_bus_size14;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size14 generation14
//----------------------------------------------------------------------------   

  always @(valid_access14 or r_xfer_size14 or xfer_size14)

    begin
       
       if (valid_access14)
         
          v_xfer_size14 = xfer_size14;
       
       else
         
          v_xfer_size14 = r_xfer_size14;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions14
// Determines14 the number14 of accesses required14 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size14)
  
    begin
       
       if ((xfer_size14[1:0] == `XSIZ_1614))
         
          num_accesses14 = 2'h1; // Two14 accesses
       
       else if ( (xfer_size14[1:0] == `XSIZ_3214))
         
          num_accesses14 = 2'h3; // Four14 accesses
       
       else
         
          num_accesses14 = 2'h0; // One14 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep14 track14 of the current access number14
//--------------------------------------------------------------------
   
  always @(posedge sys_clk14 or negedge n_sys_reset14)
  
    begin
       
       if (~n_sys_reset14)
         
          r_num_access14 <= 2'b00;
       
       else if (valid_access14)
         
          r_num_access14 <= num_accesses14;
       
       else if (smc_done14 & (smc_nextstate14 != `SMC_STORE14)  &
                      (smc_nextstate14 != `SMC_IDLE14)   )
         
          r_num_access14 <= r_num_access14 - 2'd1;
       
       else
         
          r_num_access14 <= r_num_access14;
       
    end
   
   

//--------------------------------------------------------------------
// Detect14 last access
//--------------------------------------------------------------------
   
   always @(r_num_access14)
     
     begin
        
        if (r_num_access14 == 2'h0)
          
           mac_done14 = 1'b1;
             
        else
          
           mac_done14 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals14 concatenation14 used in case statement14 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz14 = { 1'b0, latch_data14, r_num_access14,
                                  r_bus_size14};
 
   
//--------------------------------------------------------------------
// Store14 Read Data if required14
//--------------------------------------------------------------------

   always @(posedge sys_clk14 or negedge n_sys_reset14)
     
     begin
        
        if (~n_sys_reset14)
          
           r_read_data14 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz14)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data14 <= r_read_data14;
            
            //    latch_data14
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data14[31:24] <= data_smc14[7:0];
                 r_read_data14[23:0] <= 24'h0;
                 
              end
            
            // r_num_access14 =2, v_bus_size14 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data14[23:16] <= data_smc14[7:0];
                 r_read_data14[31:24] <= r_read_data14[31:24];
                 r_read_data14[15:0] <= 16'h0;
                 
              end
            
            // r_num_access14 =1, v_bus_size14 = `XSIZ_1614
            
            {1'b0,1'b1,2'h1,`XSIZ_1614}:
              
              begin
                 
                 r_read_data14[15:0] <= 16'h0;
                 r_read_data14[31:16] <= data_smc14[15:0];
                 
              end
            
            //  r_num_access14 =1,v_bus_size14 == `XSIZ_814
            
            {1'b0,1'b1,2'h1,`XSIZ_814}:          
              
              begin
                 
                 r_read_data14[15:8] <= data_smc14[7:0];
                 r_read_data14[31:16] <= r_read_data14[31:16];
                 r_read_data14[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access14 = 0, v_bus_size14 == `XSIZ_1614
            
            {1'b0,1'b1,2'h0,`XSIZ_1614}:  // r_num_access14 =0
              
              
              begin
                 
                 r_read_data14[15:0] <= data_smc14[15:0];
                 r_read_data14[31:16] <= r_read_data14[31:16];
                 
              end
            
            //  r_num_access14 = 0, v_bus_size14 == `XSIZ_814 
            
            {1'b0,1'b1,2'h0,`XSIZ_814}:
              
              begin
                 
                 r_read_data14[7:0] <= data_smc14[7:0];
                 r_read_data14[31:8] <= r_read_data14[31:8];
                 
              end
            
            //  r_num_access14 = 0, v_bus_size14 == `XSIZ_3214
            
            {1'b0,1'b1,2'h0,`XSIZ_3214}:
              
               r_read_data14[31:0] <= data_smc14[31:0];                      
            
            default :
              
               r_read_data14 <= r_read_data14;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals14 concatenation14 for case statement14 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata14 = {r_xfer_size14,r_bus_size14,latch_data14};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata14 or data_smc14 or r_read_data14 )
       
     begin
        
        casex(xfer_bus_ldata14)
          
          {`XSIZ_3214,`BSIZ_3214,1'b1} :
            
             read_data14[31:0] = data_smc14[31:0];
          
          {`XSIZ_3214,`BSIZ_1614,1'b1} :
                              
            begin
               
               read_data14[31:16] = r_read_data14[31:16];
               read_data14[15:0]  = data_smc14[15:0];
               
            end
          
          {`XSIZ_3214,`BSIZ_814,1'b1} :
            
            begin
               
               read_data14[31:8] = r_read_data14[31:8];
               read_data14[7:0]  = data_smc14[7:0];
               
            end
          
          {`XSIZ_3214,1'bx,1'bx,1'bx} :
            
            read_data14 = r_read_data14;
          
          {`XSIZ_1614,`BSIZ_1614,1'b1} :
                        
            begin
               
               read_data14[31:16] = data_smc14[15:0];
               read_data14[15:0] = data_smc14[15:0];
               
            end
          
          {`XSIZ_1614,`BSIZ_1614,1'b0} :  
            
            begin
               
               read_data14[31:16] = r_read_data14[15:0];
               read_data14[15:0] = r_read_data14[15:0];
               
            end
          
          {`XSIZ_1614,`BSIZ_3214,1'b1} :  
            
            read_data14 = data_smc14;
          
          {`XSIZ_1614,`BSIZ_814,1'b1} : 
                        
            begin
               
               read_data14[31:24] = r_read_data14[15:8];
               read_data14[23:16] = data_smc14[7:0];
               read_data14[15:8] = r_read_data14[15:8];
               read_data14[7:0] = data_smc14[7:0];
            end
          
          {`XSIZ_1614,`BSIZ_814,1'b0} : 
            
            begin
               
               read_data14[31:16] = r_read_data14[15:0];
               read_data14[15:0] = r_read_data14[15:0];
               
            end
          
          {`XSIZ_1614,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data14[31:16] = r_read_data14[31:16];
               read_data14[15:0] = r_read_data14[15:0];
               
            end
          
          {`XSIZ_814,`BSIZ_1614,1'b1} :
            
            begin
               
               read_data14[31:16] = data_smc14[15:0];
               read_data14[15:0] = data_smc14[15:0];
               
            end
          
          {`XSIZ_814,`BSIZ_1614,1'b0} :
            
            begin
               
               read_data14[31:16] = r_read_data14[15:0];
               read_data14[15:0]  = r_read_data14[15:0];
               
            end
          
          {`XSIZ_814,`BSIZ_3214,1'b1} :   
            
            read_data14 = data_smc14;
          
          {`XSIZ_814,`BSIZ_3214,1'b0} :              
                        
                        read_data14 = r_read_data14;
          
          {`XSIZ_814,`BSIZ_814,1'b1} :   
                                    
            begin
               
               read_data14[31:24] = data_smc14[7:0];
               read_data14[23:16] = data_smc14[7:0];
               read_data14[15:8]  = data_smc14[7:0];
               read_data14[7:0]   = data_smc14[7:0];
               
            end
          
          default:
            
            begin
               
               read_data14[31:24] = r_read_data14[7:0];
               read_data14[23:16] = r_read_data14[7:0];
               read_data14[15:8]  = r_read_data14[7:0];
               read_data14[7:0]   = r_read_data14[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata14)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal14 concatenation14 for use in case statement14
//----------------------------------------------------------------------------
   
   assign bus_size_num_access14 = { r_bus_size14, r_num_access14};
   
//--------------------------------------------------------------------
// Select14 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access14 or write_data14)
  
    begin
       
       casex(bus_size_num_access14)
         
         {`BSIZ_3214,1'bx,1'bx}://    (v_bus_size14 == `BSIZ_3214)
           
           smc_data14 = write_data14;
         
         {`BSIZ_1614,2'h1}:    // r_num_access14 == 1
                      
           begin
              
              smc_data14[31:16] = 16'h0;
              smc_data14[15:0] = write_data14[31:16];
              
           end 
         
         {`BSIZ_1614,1'bx,1'bx}:  // (v_bus_size14 == `BSIZ_1614)  
           
           begin
              
              smc_data14[31:16] = 16'h0;
              smc_data14[15:0]  = write_data14[15:0];
              
           end
         
         {`BSIZ_814,2'h3}:  //  (r_num_access14 == 3)
           
           begin
              
              smc_data14[31:8] = 24'h0;
              smc_data14[7:0] = write_data14[31:24];
           end
         
         {`BSIZ_814,2'h2}:  //   (r_num_access14 == 2)
           
           begin
              
              smc_data14[31:8] = 24'h0;
              smc_data14[7:0] = write_data14[23:16];
              
           end
         
         {`BSIZ_814,2'h1}:  //  (r_num_access14 == 2)
           
           begin
              
              smc_data14[31:8] = 24'h0;
              smc_data14[7:0]  = write_data14[15:8];
              
           end 
         
         {`BSIZ_814,2'h0}:  //  (r_num_access14 == 0) 
           
           begin
              
              smc_data14[31:8] = 24'h0;
              smc_data14[7:0] = write_data14[7:0];
              
           end 
         
         default:
           
           smc_data14 = 32'h0;
         
       endcase // casex(bus_size_num_access14)
       
       
    end
   
endmodule
