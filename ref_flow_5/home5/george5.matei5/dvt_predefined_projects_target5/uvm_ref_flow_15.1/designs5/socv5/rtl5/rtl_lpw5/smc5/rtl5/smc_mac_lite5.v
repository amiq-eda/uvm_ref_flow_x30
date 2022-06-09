//File5 name   : smc_mac_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : Multiple5 access controller5.
//            : Static5 Memory Controller5.
//            : The Multiple5 Access Control5 Block keeps5 trace5 of the
//            : number5 of accesses required5 to fulfill5 the
//            : requirements5 of the AHB5 transfer5. The data is
//            : registered when multiple reads are required5. The AHB5
//            : holds5 the data during multiple writes.
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

`include "smc_defs_lite5.v"

module smc_mac_lite5     (

                    //inputs5
                    
                    sys_clk5,
                    n_sys_reset5,
                    valid_access5,
                    xfer_size5,
                    smc_done5,
                    data_smc5,
                    write_data5,
                    smc_nextstate5,
                    latch_data5,
                    
                    //outputs5
                    
                    r_num_access5,
                    mac_done5,
                    v_bus_size5,
                    v_xfer_size5,
                    read_data5,
                    smc_data5);
   
   
   
 


// State5 Machine5// I5/O5

  input                sys_clk5;        // System5 clock5
  input                n_sys_reset5;    // System5 reset (Active5 LOW5)
  input                valid_access5;   // Address cycle of new transfer5
  input  [1:0]         xfer_size5;      // xfer5 size, valid with valid_access5
  input                smc_done5;       // End5 of transfer5
  input  [31:0]        data_smc5;       // External5 read data
  input  [31:0]        write_data5;     // Data from internal bus 
  input  [4:0]         smc_nextstate5;  // State5 Machine5  
  input                latch_data5;     //latch_data5 is used by the MAC5 block    
  
  output [1:0]         r_num_access5;   // Access counter
  output               mac_done5;       // End5 of all transfers5
  output [1:0]         v_bus_size5;     // Registered5 sizes5 for subsequent5
  output [1:0]         v_xfer_size5;    // transfers5 in MAC5 transfer5
  output [31:0]        read_data5;      // Data to internal bus
  output [31:0]        smc_data5;       // Data to external5 bus
  

// Output5 register declarations5

  reg                  mac_done5;       // Indicates5 last cycle of last access
  reg [1:0]            r_num_access5;   // Access counter
  reg [1:0]            num_accesses5;   //number5 of access
  reg [1:0]            r_xfer_size5;    // Store5 size for MAC5 
  reg [1:0]            r_bus_size5;     // Store5 size for MAC5
  reg [31:0]           read_data5;      // Data path to bus IF
  reg [31:0]           r_read_data5;    // Internal data store5
  reg [31:0]           smc_data5;


// Internal Signals5

  reg [1:0]            v_bus_size5;
  reg [1:0]            v_xfer_size5;
  wire [4:0]           smc_nextstate5;    //specifies5 next state
  wire [4:0]           xfer_bus_ldata5;  //concatenation5 of xfer_size5
                                         // and latch_data5  
  wire [3:0]           bus_size_num_access5; //concatenation5 of 
                                              // r_num_access5
  wire [5:0]           wt_ldata_naccs_bsiz5;  //concatenation5 of 
                                            //latch_data5,r_num_access5
 
   


// Main5 Code5

//----------------------------------------------------------------------------
// Store5 transfer5 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk5 or negedge n_sys_reset5)
  
    begin
       
       if (~n_sys_reset5)
         
          r_xfer_size5 <= 2'b00;
       
       
       else if (valid_access5)
         
          r_xfer_size5 <= xfer_size5;
       
       else
         
          r_xfer_size5 <= r_xfer_size5;
       
    end

//--------------------------------------------------------------------
// Store5 bus size generation5
//--------------------------------------------------------------------
  
  always @(posedge sys_clk5 or negedge n_sys_reset5)
    
    begin
       
       if (~n_sys_reset5)
         
          r_bus_size5 <= 2'b00;
       
       
       else if (valid_access5)
         
          r_bus_size5 <= 2'b00;
       
       else
         
          r_bus_size5 <= r_bus_size5;
       
    end
   

//--------------------------------------------------------------------
// Validate5 sizes5 generation5
//--------------------------------------------------------------------

  always @(valid_access5 or r_bus_size5 )

    begin
       
       if (valid_access5)
         
          v_bus_size5 = 2'b0;
       
       else
         
          v_bus_size5 = r_bus_size5;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size5 generation5
//----------------------------------------------------------------------------   

  always @(valid_access5 or r_xfer_size5 or xfer_size5)

    begin
       
       if (valid_access5)
         
          v_xfer_size5 = xfer_size5;
       
       else
         
          v_xfer_size5 = r_xfer_size5;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions5
// Determines5 the number5 of accesses required5 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size5)
  
    begin
       
       if ((xfer_size5[1:0] == `XSIZ_165))
         
          num_accesses5 = 2'h1; // Two5 accesses
       
       else if ( (xfer_size5[1:0] == `XSIZ_325))
         
          num_accesses5 = 2'h3; // Four5 accesses
       
       else
         
          num_accesses5 = 2'h0; // One5 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep5 track5 of the current access number5
//--------------------------------------------------------------------
   
  always @(posedge sys_clk5 or negedge n_sys_reset5)
  
    begin
       
       if (~n_sys_reset5)
         
          r_num_access5 <= 2'b00;
       
       else if (valid_access5)
         
          r_num_access5 <= num_accesses5;
       
       else if (smc_done5 & (smc_nextstate5 != `SMC_STORE5)  &
                      (smc_nextstate5 != `SMC_IDLE5)   )
         
          r_num_access5 <= r_num_access5 - 2'd1;
       
       else
         
          r_num_access5 <= r_num_access5;
       
    end
   
   

//--------------------------------------------------------------------
// Detect5 last access
//--------------------------------------------------------------------
   
   always @(r_num_access5)
     
     begin
        
        if (r_num_access5 == 2'h0)
          
           mac_done5 = 1'b1;
             
        else
          
           mac_done5 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals5 concatenation5 used in case statement5 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz5 = { 1'b0, latch_data5, r_num_access5,
                                  r_bus_size5};
 
   
//--------------------------------------------------------------------
// Store5 Read Data if required5
//--------------------------------------------------------------------

   always @(posedge sys_clk5 or negedge n_sys_reset5)
     
     begin
        
        if (~n_sys_reset5)
          
           r_read_data5 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz5)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data5 <= r_read_data5;
            
            //    latch_data5
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data5[31:24] <= data_smc5[7:0];
                 r_read_data5[23:0] <= 24'h0;
                 
              end
            
            // r_num_access5 =2, v_bus_size5 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data5[23:16] <= data_smc5[7:0];
                 r_read_data5[31:24] <= r_read_data5[31:24];
                 r_read_data5[15:0] <= 16'h0;
                 
              end
            
            // r_num_access5 =1, v_bus_size5 = `XSIZ_165
            
            {1'b0,1'b1,2'h1,`XSIZ_165}:
              
              begin
                 
                 r_read_data5[15:0] <= 16'h0;
                 r_read_data5[31:16] <= data_smc5[15:0];
                 
              end
            
            //  r_num_access5 =1,v_bus_size5 == `XSIZ_85
            
            {1'b0,1'b1,2'h1,`XSIZ_85}:          
              
              begin
                 
                 r_read_data5[15:8] <= data_smc5[7:0];
                 r_read_data5[31:16] <= r_read_data5[31:16];
                 r_read_data5[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access5 = 0, v_bus_size5 == `XSIZ_165
            
            {1'b0,1'b1,2'h0,`XSIZ_165}:  // r_num_access5 =0
              
              
              begin
                 
                 r_read_data5[15:0] <= data_smc5[15:0];
                 r_read_data5[31:16] <= r_read_data5[31:16];
                 
              end
            
            //  r_num_access5 = 0, v_bus_size5 == `XSIZ_85 
            
            {1'b0,1'b1,2'h0,`XSIZ_85}:
              
              begin
                 
                 r_read_data5[7:0] <= data_smc5[7:0];
                 r_read_data5[31:8] <= r_read_data5[31:8];
                 
              end
            
            //  r_num_access5 = 0, v_bus_size5 == `XSIZ_325
            
            {1'b0,1'b1,2'h0,`XSIZ_325}:
              
               r_read_data5[31:0] <= data_smc5[31:0];                      
            
            default :
              
               r_read_data5 <= r_read_data5;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals5 concatenation5 for case statement5 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata5 = {r_xfer_size5,r_bus_size5,latch_data5};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata5 or data_smc5 or r_read_data5 )
       
     begin
        
        casex(xfer_bus_ldata5)
          
          {`XSIZ_325,`BSIZ_325,1'b1} :
            
             read_data5[31:0] = data_smc5[31:0];
          
          {`XSIZ_325,`BSIZ_165,1'b1} :
                              
            begin
               
               read_data5[31:16] = r_read_data5[31:16];
               read_data5[15:0]  = data_smc5[15:0];
               
            end
          
          {`XSIZ_325,`BSIZ_85,1'b1} :
            
            begin
               
               read_data5[31:8] = r_read_data5[31:8];
               read_data5[7:0]  = data_smc5[7:0];
               
            end
          
          {`XSIZ_325,1'bx,1'bx,1'bx} :
            
            read_data5 = r_read_data5;
          
          {`XSIZ_165,`BSIZ_165,1'b1} :
                        
            begin
               
               read_data5[31:16] = data_smc5[15:0];
               read_data5[15:0] = data_smc5[15:0];
               
            end
          
          {`XSIZ_165,`BSIZ_165,1'b0} :  
            
            begin
               
               read_data5[31:16] = r_read_data5[15:0];
               read_data5[15:0] = r_read_data5[15:0];
               
            end
          
          {`XSIZ_165,`BSIZ_325,1'b1} :  
            
            read_data5 = data_smc5;
          
          {`XSIZ_165,`BSIZ_85,1'b1} : 
                        
            begin
               
               read_data5[31:24] = r_read_data5[15:8];
               read_data5[23:16] = data_smc5[7:0];
               read_data5[15:8] = r_read_data5[15:8];
               read_data5[7:0] = data_smc5[7:0];
            end
          
          {`XSIZ_165,`BSIZ_85,1'b0} : 
            
            begin
               
               read_data5[31:16] = r_read_data5[15:0];
               read_data5[15:0] = r_read_data5[15:0];
               
            end
          
          {`XSIZ_165,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data5[31:16] = r_read_data5[31:16];
               read_data5[15:0] = r_read_data5[15:0];
               
            end
          
          {`XSIZ_85,`BSIZ_165,1'b1} :
            
            begin
               
               read_data5[31:16] = data_smc5[15:0];
               read_data5[15:0] = data_smc5[15:0];
               
            end
          
          {`XSIZ_85,`BSIZ_165,1'b0} :
            
            begin
               
               read_data5[31:16] = r_read_data5[15:0];
               read_data5[15:0]  = r_read_data5[15:0];
               
            end
          
          {`XSIZ_85,`BSIZ_325,1'b1} :   
            
            read_data5 = data_smc5;
          
          {`XSIZ_85,`BSIZ_325,1'b0} :              
                        
                        read_data5 = r_read_data5;
          
          {`XSIZ_85,`BSIZ_85,1'b1} :   
                                    
            begin
               
               read_data5[31:24] = data_smc5[7:0];
               read_data5[23:16] = data_smc5[7:0];
               read_data5[15:8]  = data_smc5[7:0];
               read_data5[7:0]   = data_smc5[7:0];
               
            end
          
          default:
            
            begin
               
               read_data5[31:24] = r_read_data5[7:0];
               read_data5[23:16] = r_read_data5[7:0];
               read_data5[15:8]  = r_read_data5[7:0];
               read_data5[7:0]   = r_read_data5[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata5)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal5 concatenation5 for use in case statement5
//----------------------------------------------------------------------------
   
   assign bus_size_num_access5 = { r_bus_size5, r_num_access5};
   
//--------------------------------------------------------------------
// Select5 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access5 or write_data5)
  
    begin
       
       casex(bus_size_num_access5)
         
         {`BSIZ_325,1'bx,1'bx}://    (v_bus_size5 == `BSIZ_325)
           
           smc_data5 = write_data5;
         
         {`BSIZ_165,2'h1}:    // r_num_access5 == 1
                      
           begin
              
              smc_data5[31:16] = 16'h0;
              smc_data5[15:0] = write_data5[31:16];
              
           end 
         
         {`BSIZ_165,1'bx,1'bx}:  // (v_bus_size5 == `BSIZ_165)  
           
           begin
              
              smc_data5[31:16] = 16'h0;
              smc_data5[15:0]  = write_data5[15:0];
              
           end
         
         {`BSIZ_85,2'h3}:  //  (r_num_access5 == 3)
           
           begin
              
              smc_data5[31:8] = 24'h0;
              smc_data5[7:0] = write_data5[31:24];
           end
         
         {`BSIZ_85,2'h2}:  //   (r_num_access5 == 2)
           
           begin
              
              smc_data5[31:8] = 24'h0;
              smc_data5[7:0] = write_data5[23:16];
              
           end
         
         {`BSIZ_85,2'h1}:  //  (r_num_access5 == 2)
           
           begin
              
              smc_data5[31:8] = 24'h0;
              smc_data5[7:0]  = write_data5[15:8];
              
           end 
         
         {`BSIZ_85,2'h0}:  //  (r_num_access5 == 0) 
           
           begin
              
              smc_data5[31:8] = 24'h0;
              smc_data5[7:0] = write_data5[7:0];
              
           end 
         
         default:
           
           smc_data5 = 32'h0;
         
       endcase // casex(bus_size_num_access5)
       
       
    end
   
endmodule
