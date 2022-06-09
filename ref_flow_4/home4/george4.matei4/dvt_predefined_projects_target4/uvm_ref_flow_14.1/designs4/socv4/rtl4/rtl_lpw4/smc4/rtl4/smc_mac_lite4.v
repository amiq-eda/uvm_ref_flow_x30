//File4 name   : smc_mac_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : Multiple4 access controller4.
//            : Static4 Memory Controller4.
//            : The Multiple4 Access Control4 Block keeps4 trace4 of the
//            : number4 of accesses required4 to fulfill4 the
//            : requirements4 of the AHB4 transfer4. The data is
//            : registered when multiple reads are required4. The AHB4
//            : holds4 the data during multiple writes.
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

`include "smc_defs_lite4.v"

module smc_mac_lite4     (

                    //inputs4
                    
                    sys_clk4,
                    n_sys_reset4,
                    valid_access4,
                    xfer_size4,
                    smc_done4,
                    data_smc4,
                    write_data4,
                    smc_nextstate4,
                    latch_data4,
                    
                    //outputs4
                    
                    r_num_access4,
                    mac_done4,
                    v_bus_size4,
                    v_xfer_size4,
                    read_data4,
                    smc_data4);
   
   
   
 


// State4 Machine4// I4/O4

  input                sys_clk4;        // System4 clock4
  input                n_sys_reset4;    // System4 reset (Active4 LOW4)
  input                valid_access4;   // Address cycle of new transfer4
  input  [1:0]         xfer_size4;      // xfer4 size, valid with valid_access4
  input                smc_done4;       // End4 of transfer4
  input  [31:0]        data_smc4;       // External4 read data
  input  [31:0]        write_data4;     // Data from internal bus 
  input  [4:0]         smc_nextstate4;  // State4 Machine4  
  input                latch_data4;     //latch_data4 is used by the MAC4 block    
  
  output [1:0]         r_num_access4;   // Access counter
  output               mac_done4;       // End4 of all transfers4
  output [1:0]         v_bus_size4;     // Registered4 sizes4 for subsequent4
  output [1:0]         v_xfer_size4;    // transfers4 in MAC4 transfer4
  output [31:0]        read_data4;      // Data to internal bus
  output [31:0]        smc_data4;       // Data to external4 bus
  

// Output4 register declarations4

  reg                  mac_done4;       // Indicates4 last cycle of last access
  reg [1:0]            r_num_access4;   // Access counter
  reg [1:0]            num_accesses4;   //number4 of access
  reg [1:0]            r_xfer_size4;    // Store4 size for MAC4 
  reg [1:0]            r_bus_size4;     // Store4 size for MAC4
  reg [31:0]           read_data4;      // Data path to bus IF
  reg [31:0]           r_read_data4;    // Internal data store4
  reg [31:0]           smc_data4;


// Internal Signals4

  reg [1:0]            v_bus_size4;
  reg [1:0]            v_xfer_size4;
  wire [4:0]           smc_nextstate4;    //specifies4 next state
  wire [4:0]           xfer_bus_ldata4;  //concatenation4 of xfer_size4
                                         // and latch_data4  
  wire [3:0]           bus_size_num_access4; //concatenation4 of 
                                              // r_num_access4
  wire [5:0]           wt_ldata_naccs_bsiz4;  //concatenation4 of 
                                            //latch_data4,r_num_access4
 
   


// Main4 Code4

//----------------------------------------------------------------------------
// Store4 transfer4 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk4 or negedge n_sys_reset4)
  
    begin
       
       if (~n_sys_reset4)
         
          r_xfer_size4 <= 2'b00;
       
       
       else if (valid_access4)
         
          r_xfer_size4 <= xfer_size4;
       
       else
         
          r_xfer_size4 <= r_xfer_size4;
       
    end

//--------------------------------------------------------------------
// Store4 bus size generation4
//--------------------------------------------------------------------
  
  always @(posedge sys_clk4 or negedge n_sys_reset4)
    
    begin
       
       if (~n_sys_reset4)
         
          r_bus_size4 <= 2'b00;
       
       
       else if (valid_access4)
         
          r_bus_size4 <= 2'b00;
       
       else
         
          r_bus_size4 <= r_bus_size4;
       
    end
   

//--------------------------------------------------------------------
// Validate4 sizes4 generation4
//--------------------------------------------------------------------

  always @(valid_access4 or r_bus_size4 )

    begin
       
       if (valid_access4)
         
          v_bus_size4 = 2'b0;
       
       else
         
          v_bus_size4 = r_bus_size4;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size4 generation4
//----------------------------------------------------------------------------   

  always @(valid_access4 or r_xfer_size4 or xfer_size4)

    begin
       
       if (valid_access4)
         
          v_xfer_size4 = xfer_size4;
       
       else
         
          v_xfer_size4 = r_xfer_size4;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions4
// Determines4 the number4 of accesses required4 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size4)
  
    begin
       
       if ((xfer_size4[1:0] == `XSIZ_164))
         
          num_accesses4 = 2'h1; // Two4 accesses
       
       else if ( (xfer_size4[1:0] == `XSIZ_324))
         
          num_accesses4 = 2'h3; // Four4 accesses
       
       else
         
          num_accesses4 = 2'h0; // One4 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep4 track4 of the current access number4
//--------------------------------------------------------------------
   
  always @(posedge sys_clk4 or negedge n_sys_reset4)
  
    begin
       
       if (~n_sys_reset4)
         
          r_num_access4 <= 2'b00;
       
       else if (valid_access4)
         
          r_num_access4 <= num_accesses4;
       
       else if (smc_done4 & (smc_nextstate4 != `SMC_STORE4)  &
                      (smc_nextstate4 != `SMC_IDLE4)   )
         
          r_num_access4 <= r_num_access4 - 2'd1;
       
       else
         
          r_num_access4 <= r_num_access4;
       
    end
   
   

//--------------------------------------------------------------------
// Detect4 last access
//--------------------------------------------------------------------
   
   always @(r_num_access4)
     
     begin
        
        if (r_num_access4 == 2'h0)
          
           mac_done4 = 1'b1;
             
        else
          
           mac_done4 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals4 concatenation4 used in case statement4 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz4 = { 1'b0, latch_data4, r_num_access4,
                                  r_bus_size4};
 
   
//--------------------------------------------------------------------
// Store4 Read Data if required4
//--------------------------------------------------------------------

   always @(posedge sys_clk4 or negedge n_sys_reset4)
     
     begin
        
        if (~n_sys_reset4)
          
           r_read_data4 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz4)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data4 <= r_read_data4;
            
            //    latch_data4
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data4[31:24] <= data_smc4[7:0];
                 r_read_data4[23:0] <= 24'h0;
                 
              end
            
            // r_num_access4 =2, v_bus_size4 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data4[23:16] <= data_smc4[7:0];
                 r_read_data4[31:24] <= r_read_data4[31:24];
                 r_read_data4[15:0] <= 16'h0;
                 
              end
            
            // r_num_access4 =1, v_bus_size4 = `XSIZ_164
            
            {1'b0,1'b1,2'h1,`XSIZ_164}:
              
              begin
                 
                 r_read_data4[15:0] <= 16'h0;
                 r_read_data4[31:16] <= data_smc4[15:0];
                 
              end
            
            //  r_num_access4 =1,v_bus_size4 == `XSIZ_84
            
            {1'b0,1'b1,2'h1,`XSIZ_84}:          
              
              begin
                 
                 r_read_data4[15:8] <= data_smc4[7:0];
                 r_read_data4[31:16] <= r_read_data4[31:16];
                 r_read_data4[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access4 = 0, v_bus_size4 == `XSIZ_164
            
            {1'b0,1'b1,2'h0,`XSIZ_164}:  // r_num_access4 =0
              
              
              begin
                 
                 r_read_data4[15:0] <= data_smc4[15:0];
                 r_read_data4[31:16] <= r_read_data4[31:16];
                 
              end
            
            //  r_num_access4 = 0, v_bus_size4 == `XSIZ_84 
            
            {1'b0,1'b1,2'h0,`XSIZ_84}:
              
              begin
                 
                 r_read_data4[7:0] <= data_smc4[7:0];
                 r_read_data4[31:8] <= r_read_data4[31:8];
                 
              end
            
            //  r_num_access4 = 0, v_bus_size4 == `XSIZ_324
            
            {1'b0,1'b1,2'h0,`XSIZ_324}:
              
               r_read_data4[31:0] <= data_smc4[31:0];                      
            
            default :
              
               r_read_data4 <= r_read_data4;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals4 concatenation4 for case statement4 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata4 = {r_xfer_size4,r_bus_size4,latch_data4};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata4 or data_smc4 or r_read_data4 )
       
     begin
        
        casex(xfer_bus_ldata4)
          
          {`XSIZ_324,`BSIZ_324,1'b1} :
            
             read_data4[31:0] = data_smc4[31:0];
          
          {`XSIZ_324,`BSIZ_164,1'b1} :
                              
            begin
               
               read_data4[31:16] = r_read_data4[31:16];
               read_data4[15:0]  = data_smc4[15:0];
               
            end
          
          {`XSIZ_324,`BSIZ_84,1'b1} :
            
            begin
               
               read_data4[31:8] = r_read_data4[31:8];
               read_data4[7:0]  = data_smc4[7:0];
               
            end
          
          {`XSIZ_324,1'bx,1'bx,1'bx} :
            
            read_data4 = r_read_data4;
          
          {`XSIZ_164,`BSIZ_164,1'b1} :
                        
            begin
               
               read_data4[31:16] = data_smc4[15:0];
               read_data4[15:0] = data_smc4[15:0];
               
            end
          
          {`XSIZ_164,`BSIZ_164,1'b0} :  
            
            begin
               
               read_data4[31:16] = r_read_data4[15:0];
               read_data4[15:0] = r_read_data4[15:0];
               
            end
          
          {`XSIZ_164,`BSIZ_324,1'b1} :  
            
            read_data4 = data_smc4;
          
          {`XSIZ_164,`BSIZ_84,1'b1} : 
                        
            begin
               
               read_data4[31:24] = r_read_data4[15:8];
               read_data4[23:16] = data_smc4[7:0];
               read_data4[15:8] = r_read_data4[15:8];
               read_data4[7:0] = data_smc4[7:0];
            end
          
          {`XSIZ_164,`BSIZ_84,1'b0} : 
            
            begin
               
               read_data4[31:16] = r_read_data4[15:0];
               read_data4[15:0] = r_read_data4[15:0];
               
            end
          
          {`XSIZ_164,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data4[31:16] = r_read_data4[31:16];
               read_data4[15:0] = r_read_data4[15:0];
               
            end
          
          {`XSIZ_84,`BSIZ_164,1'b1} :
            
            begin
               
               read_data4[31:16] = data_smc4[15:0];
               read_data4[15:0] = data_smc4[15:0];
               
            end
          
          {`XSIZ_84,`BSIZ_164,1'b0} :
            
            begin
               
               read_data4[31:16] = r_read_data4[15:0];
               read_data4[15:0]  = r_read_data4[15:0];
               
            end
          
          {`XSIZ_84,`BSIZ_324,1'b1} :   
            
            read_data4 = data_smc4;
          
          {`XSIZ_84,`BSIZ_324,1'b0} :              
                        
                        read_data4 = r_read_data4;
          
          {`XSIZ_84,`BSIZ_84,1'b1} :   
                                    
            begin
               
               read_data4[31:24] = data_smc4[7:0];
               read_data4[23:16] = data_smc4[7:0];
               read_data4[15:8]  = data_smc4[7:0];
               read_data4[7:0]   = data_smc4[7:0];
               
            end
          
          default:
            
            begin
               
               read_data4[31:24] = r_read_data4[7:0];
               read_data4[23:16] = r_read_data4[7:0];
               read_data4[15:8]  = r_read_data4[7:0];
               read_data4[7:0]   = r_read_data4[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata4)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal4 concatenation4 for use in case statement4
//----------------------------------------------------------------------------
   
   assign bus_size_num_access4 = { r_bus_size4, r_num_access4};
   
//--------------------------------------------------------------------
// Select4 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access4 or write_data4)
  
    begin
       
       casex(bus_size_num_access4)
         
         {`BSIZ_324,1'bx,1'bx}://    (v_bus_size4 == `BSIZ_324)
           
           smc_data4 = write_data4;
         
         {`BSIZ_164,2'h1}:    // r_num_access4 == 1
                      
           begin
              
              smc_data4[31:16] = 16'h0;
              smc_data4[15:0] = write_data4[31:16];
              
           end 
         
         {`BSIZ_164,1'bx,1'bx}:  // (v_bus_size4 == `BSIZ_164)  
           
           begin
              
              smc_data4[31:16] = 16'h0;
              smc_data4[15:0]  = write_data4[15:0];
              
           end
         
         {`BSIZ_84,2'h3}:  //  (r_num_access4 == 3)
           
           begin
              
              smc_data4[31:8] = 24'h0;
              smc_data4[7:0] = write_data4[31:24];
           end
         
         {`BSIZ_84,2'h2}:  //   (r_num_access4 == 2)
           
           begin
              
              smc_data4[31:8] = 24'h0;
              smc_data4[7:0] = write_data4[23:16];
              
           end
         
         {`BSIZ_84,2'h1}:  //  (r_num_access4 == 2)
           
           begin
              
              smc_data4[31:8] = 24'h0;
              smc_data4[7:0]  = write_data4[15:8];
              
           end 
         
         {`BSIZ_84,2'h0}:  //  (r_num_access4 == 0) 
           
           begin
              
              smc_data4[31:8] = 24'h0;
              smc_data4[7:0] = write_data4[7:0];
              
           end 
         
         default:
           
           smc_data4 = 32'h0;
         
       endcase // casex(bus_size_num_access4)
       
       
    end
   
endmodule
