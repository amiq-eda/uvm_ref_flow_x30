//File19 name   : smc_mac_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : Multiple19 access controller19.
//            : Static19 Memory Controller19.
//            : The Multiple19 Access Control19 Block keeps19 trace19 of the
//            : number19 of accesses required19 to fulfill19 the
//            : requirements19 of the AHB19 transfer19. The data is
//            : registered when multiple reads are required19. The AHB19
//            : holds19 the data during multiple writes.
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

`include "smc_defs_lite19.v"

module smc_mac_lite19     (

                    //inputs19
                    
                    sys_clk19,
                    n_sys_reset19,
                    valid_access19,
                    xfer_size19,
                    smc_done19,
                    data_smc19,
                    write_data19,
                    smc_nextstate19,
                    latch_data19,
                    
                    //outputs19
                    
                    r_num_access19,
                    mac_done19,
                    v_bus_size19,
                    v_xfer_size19,
                    read_data19,
                    smc_data19);
   
   
   
 


// State19 Machine19// I19/O19

  input                sys_clk19;        // System19 clock19
  input                n_sys_reset19;    // System19 reset (Active19 LOW19)
  input                valid_access19;   // Address cycle of new transfer19
  input  [1:0]         xfer_size19;      // xfer19 size, valid with valid_access19
  input                smc_done19;       // End19 of transfer19
  input  [31:0]        data_smc19;       // External19 read data
  input  [31:0]        write_data19;     // Data from internal bus 
  input  [4:0]         smc_nextstate19;  // State19 Machine19  
  input                latch_data19;     //latch_data19 is used by the MAC19 block    
  
  output [1:0]         r_num_access19;   // Access counter
  output               mac_done19;       // End19 of all transfers19
  output [1:0]         v_bus_size19;     // Registered19 sizes19 for subsequent19
  output [1:0]         v_xfer_size19;    // transfers19 in MAC19 transfer19
  output [31:0]        read_data19;      // Data to internal bus
  output [31:0]        smc_data19;       // Data to external19 bus
  

// Output19 register declarations19

  reg                  mac_done19;       // Indicates19 last cycle of last access
  reg [1:0]            r_num_access19;   // Access counter
  reg [1:0]            num_accesses19;   //number19 of access
  reg [1:0]            r_xfer_size19;    // Store19 size for MAC19 
  reg [1:0]            r_bus_size19;     // Store19 size for MAC19
  reg [31:0]           read_data19;      // Data path to bus IF
  reg [31:0]           r_read_data19;    // Internal data store19
  reg [31:0]           smc_data19;


// Internal Signals19

  reg [1:0]            v_bus_size19;
  reg [1:0]            v_xfer_size19;
  wire [4:0]           smc_nextstate19;    //specifies19 next state
  wire [4:0]           xfer_bus_ldata19;  //concatenation19 of xfer_size19
                                         // and latch_data19  
  wire [3:0]           bus_size_num_access19; //concatenation19 of 
                                              // r_num_access19
  wire [5:0]           wt_ldata_naccs_bsiz19;  //concatenation19 of 
                                            //latch_data19,r_num_access19
 
   


// Main19 Code19

//----------------------------------------------------------------------------
// Store19 transfer19 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk19 or negedge n_sys_reset19)
  
    begin
       
       if (~n_sys_reset19)
         
          r_xfer_size19 <= 2'b00;
       
       
       else if (valid_access19)
         
          r_xfer_size19 <= xfer_size19;
       
       else
         
          r_xfer_size19 <= r_xfer_size19;
       
    end

//--------------------------------------------------------------------
// Store19 bus size generation19
//--------------------------------------------------------------------
  
  always @(posedge sys_clk19 or negedge n_sys_reset19)
    
    begin
       
       if (~n_sys_reset19)
         
          r_bus_size19 <= 2'b00;
       
       
       else if (valid_access19)
         
          r_bus_size19 <= 2'b00;
       
       else
         
          r_bus_size19 <= r_bus_size19;
       
    end
   

//--------------------------------------------------------------------
// Validate19 sizes19 generation19
//--------------------------------------------------------------------

  always @(valid_access19 or r_bus_size19 )

    begin
       
       if (valid_access19)
         
          v_bus_size19 = 2'b0;
       
       else
         
          v_bus_size19 = r_bus_size19;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size19 generation19
//----------------------------------------------------------------------------   

  always @(valid_access19 or r_xfer_size19 or xfer_size19)

    begin
       
       if (valid_access19)
         
          v_xfer_size19 = xfer_size19;
       
       else
         
          v_xfer_size19 = r_xfer_size19;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions19
// Determines19 the number19 of accesses required19 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size19)
  
    begin
       
       if ((xfer_size19[1:0] == `XSIZ_1619))
         
          num_accesses19 = 2'h1; // Two19 accesses
       
       else if ( (xfer_size19[1:0] == `XSIZ_3219))
         
          num_accesses19 = 2'h3; // Four19 accesses
       
       else
         
          num_accesses19 = 2'h0; // One19 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep19 track19 of the current access number19
//--------------------------------------------------------------------
   
  always @(posedge sys_clk19 or negedge n_sys_reset19)
  
    begin
       
       if (~n_sys_reset19)
         
          r_num_access19 <= 2'b00;
       
       else if (valid_access19)
         
          r_num_access19 <= num_accesses19;
       
       else if (smc_done19 & (smc_nextstate19 != `SMC_STORE19)  &
                      (smc_nextstate19 != `SMC_IDLE19)   )
         
          r_num_access19 <= r_num_access19 - 2'd1;
       
       else
         
          r_num_access19 <= r_num_access19;
       
    end
   
   

//--------------------------------------------------------------------
// Detect19 last access
//--------------------------------------------------------------------
   
   always @(r_num_access19)
     
     begin
        
        if (r_num_access19 == 2'h0)
          
           mac_done19 = 1'b1;
             
        else
          
           mac_done19 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals19 concatenation19 used in case statement19 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz19 = { 1'b0, latch_data19, r_num_access19,
                                  r_bus_size19};
 
   
//--------------------------------------------------------------------
// Store19 Read Data if required19
//--------------------------------------------------------------------

   always @(posedge sys_clk19 or negedge n_sys_reset19)
     
     begin
        
        if (~n_sys_reset19)
          
           r_read_data19 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz19)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data19 <= r_read_data19;
            
            //    latch_data19
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data19[31:24] <= data_smc19[7:0];
                 r_read_data19[23:0] <= 24'h0;
                 
              end
            
            // r_num_access19 =2, v_bus_size19 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data19[23:16] <= data_smc19[7:0];
                 r_read_data19[31:24] <= r_read_data19[31:24];
                 r_read_data19[15:0] <= 16'h0;
                 
              end
            
            // r_num_access19 =1, v_bus_size19 = `XSIZ_1619
            
            {1'b0,1'b1,2'h1,`XSIZ_1619}:
              
              begin
                 
                 r_read_data19[15:0] <= 16'h0;
                 r_read_data19[31:16] <= data_smc19[15:0];
                 
              end
            
            //  r_num_access19 =1,v_bus_size19 == `XSIZ_819
            
            {1'b0,1'b1,2'h1,`XSIZ_819}:          
              
              begin
                 
                 r_read_data19[15:8] <= data_smc19[7:0];
                 r_read_data19[31:16] <= r_read_data19[31:16];
                 r_read_data19[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access19 = 0, v_bus_size19 == `XSIZ_1619
            
            {1'b0,1'b1,2'h0,`XSIZ_1619}:  // r_num_access19 =0
              
              
              begin
                 
                 r_read_data19[15:0] <= data_smc19[15:0];
                 r_read_data19[31:16] <= r_read_data19[31:16];
                 
              end
            
            //  r_num_access19 = 0, v_bus_size19 == `XSIZ_819 
            
            {1'b0,1'b1,2'h0,`XSIZ_819}:
              
              begin
                 
                 r_read_data19[7:0] <= data_smc19[7:0];
                 r_read_data19[31:8] <= r_read_data19[31:8];
                 
              end
            
            //  r_num_access19 = 0, v_bus_size19 == `XSIZ_3219
            
            {1'b0,1'b1,2'h0,`XSIZ_3219}:
              
               r_read_data19[31:0] <= data_smc19[31:0];                      
            
            default :
              
               r_read_data19 <= r_read_data19;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals19 concatenation19 for case statement19 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata19 = {r_xfer_size19,r_bus_size19,latch_data19};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata19 or data_smc19 or r_read_data19 )
       
     begin
        
        casex(xfer_bus_ldata19)
          
          {`XSIZ_3219,`BSIZ_3219,1'b1} :
            
             read_data19[31:0] = data_smc19[31:0];
          
          {`XSIZ_3219,`BSIZ_1619,1'b1} :
                              
            begin
               
               read_data19[31:16] = r_read_data19[31:16];
               read_data19[15:0]  = data_smc19[15:0];
               
            end
          
          {`XSIZ_3219,`BSIZ_819,1'b1} :
            
            begin
               
               read_data19[31:8] = r_read_data19[31:8];
               read_data19[7:0]  = data_smc19[7:0];
               
            end
          
          {`XSIZ_3219,1'bx,1'bx,1'bx} :
            
            read_data19 = r_read_data19;
          
          {`XSIZ_1619,`BSIZ_1619,1'b1} :
                        
            begin
               
               read_data19[31:16] = data_smc19[15:0];
               read_data19[15:0] = data_smc19[15:0];
               
            end
          
          {`XSIZ_1619,`BSIZ_1619,1'b0} :  
            
            begin
               
               read_data19[31:16] = r_read_data19[15:0];
               read_data19[15:0] = r_read_data19[15:0];
               
            end
          
          {`XSIZ_1619,`BSIZ_3219,1'b1} :  
            
            read_data19 = data_smc19;
          
          {`XSIZ_1619,`BSIZ_819,1'b1} : 
                        
            begin
               
               read_data19[31:24] = r_read_data19[15:8];
               read_data19[23:16] = data_smc19[7:0];
               read_data19[15:8] = r_read_data19[15:8];
               read_data19[7:0] = data_smc19[7:0];
            end
          
          {`XSIZ_1619,`BSIZ_819,1'b0} : 
            
            begin
               
               read_data19[31:16] = r_read_data19[15:0];
               read_data19[15:0] = r_read_data19[15:0];
               
            end
          
          {`XSIZ_1619,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data19[31:16] = r_read_data19[31:16];
               read_data19[15:0] = r_read_data19[15:0];
               
            end
          
          {`XSIZ_819,`BSIZ_1619,1'b1} :
            
            begin
               
               read_data19[31:16] = data_smc19[15:0];
               read_data19[15:0] = data_smc19[15:0];
               
            end
          
          {`XSIZ_819,`BSIZ_1619,1'b0} :
            
            begin
               
               read_data19[31:16] = r_read_data19[15:0];
               read_data19[15:0]  = r_read_data19[15:0];
               
            end
          
          {`XSIZ_819,`BSIZ_3219,1'b1} :   
            
            read_data19 = data_smc19;
          
          {`XSIZ_819,`BSIZ_3219,1'b0} :              
                        
                        read_data19 = r_read_data19;
          
          {`XSIZ_819,`BSIZ_819,1'b1} :   
                                    
            begin
               
               read_data19[31:24] = data_smc19[7:0];
               read_data19[23:16] = data_smc19[7:0];
               read_data19[15:8]  = data_smc19[7:0];
               read_data19[7:0]   = data_smc19[7:0];
               
            end
          
          default:
            
            begin
               
               read_data19[31:24] = r_read_data19[7:0];
               read_data19[23:16] = r_read_data19[7:0];
               read_data19[15:8]  = r_read_data19[7:0];
               read_data19[7:0]   = r_read_data19[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata19)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal19 concatenation19 for use in case statement19
//----------------------------------------------------------------------------
   
   assign bus_size_num_access19 = { r_bus_size19, r_num_access19};
   
//--------------------------------------------------------------------
// Select19 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access19 or write_data19)
  
    begin
       
       casex(bus_size_num_access19)
         
         {`BSIZ_3219,1'bx,1'bx}://    (v_bus_size19 == `BSIZ_3219)
           
           smc_data19 = write_data19;
         
         {`BSIZ_1619,2'h1}:    // r_num_access19 == 1
                      
           begin
              
              smc_data19[31:16] = 16'h0;
              smc_data19[15:0] = write_data19[31:16];
              
           end 
         
         {`BSIZ_1619,1'bx,1'bx}:  // (v_bus_size19 == `BSIZ_1619)  
           
           begin
              
              smc_data19[31:16] = 16'h0;
              smc_data19[15:0]  = write_data19[15:0];
              
           end
         
         {`BSIZ_819,2'h3}:  //  (r_num_access19 == 3)
           
           begin
              
              smc_data19[31:8] = 24'h0;
              smc_data19[7:0] = write_data19[31:24];
           end
         
         {`BSIZ_819,2'h2}:  //   (r_num_access19 == 2)
           
           begin
              
              smc_data19[31:8] = 24'h0;
              smc_data19[7:0] = write_data19[23:16];
              
           end
         
         {`BSIZ_819,2'h1}:  //  (r_num_access19 == 2)
           
           begin
              
              smc_data19[31:8] = 24'h0;
              smc_data19[7:0]  = write_data19[15:8];
              
           end 
         
         {`BSIZ_819,2'h0}:  //  (r_num_access19 == 0) 
           
           begin
              
              smc_data19[31:8] = 24'h0;
              smc_data19[7:0] = write_data19[7:0];
              
           end 
         
         default:
           
           smc_data19 = 32'h0;
         
       endcase // casex(bus_size_num_access19)
       
       
    end
   
endmodule
