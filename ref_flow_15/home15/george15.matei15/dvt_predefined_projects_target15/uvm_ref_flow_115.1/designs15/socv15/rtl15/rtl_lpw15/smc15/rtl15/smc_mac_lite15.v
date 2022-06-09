//File15 name   : smc_mac_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : Multiple15 access controller15.
//            : Static15 Memory Controller15.
//            : The Multiple15 Access Control15 Block keeps15 trace15 of the
//            : number15 of accesses required15 to fulfill15 the
//            : requirements15 of the AHB15 transfer15. The data is
//            : registered when multiple reads are required15. The AHB15
//            : holds15 the data during multiple writes.
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

`include "smc_defs_lite15.v"

module smc_mac_lite15     (

                    //inputs15
                    
                    sys_clk15,
                    n_sys_reset15,
                    valid_access15,
                    xfer_size15,
                    smc_done15,
                    data_smc15,
                    write_data15,
                    smc_nextstate15,
                    latch_data15,
                    
                    //outputs15
                    
                    r_num_access15,
                    mac_done15,
                    v_bus_size15,
                    v_xfer_size15,
                    read_data15,
                    smc_data15);
   
   
   
 


// State15 Machine15// I15/O15

  input                sys_clk15;        // System15 clock15
  input                n_sys_reset15;    // System15 reset (Active15 LOW15)
  input                valid_access15;   // Address cycle of new transfer15
  input  [1:0]         xfer_size15;      // xfer15 size, valid with valid_access15
  input                smc_done15;       // End15 of transfer15
  input  [31:0]        data_smc15;       // External15 read data
  input  [31:0]        write_data15;     // Data from internal bus 
  input  [4:0]         smc_nextstate15;  // State15 Machine15  
  input                latch_data15;     //latch_data15 is used by the MAC15 block    
  
  output [1:0]         r_num_access15;   // Access counter
  output               mac_done15;       // End15 of all transfers15
  output [1:0]         v_bus_size15;     // Registered15 sizes15 for subsequent15
  output [1:0]         v_xfer_size15;    // transfers15 in MAC15 transfer15
  output [31:0]        read_data15;      // Data to internal bus
  output [31:0]        smc_data15;       // Data to external15 bus
  

// Output15 register declarations15

  reg                  mac_done15;       // Indicates15 last cycle of last access
  reg [1:0]            r_num_access15;   // Access counter
  reg [1:0]            num_accesses15;   //number15 of access
  reg [1:0]            r_xfer_size15;    // Store15 size for MAC15 
  reg [1:0]            r_bus_size15;     // Store15 size for MAC15
  reg [31:0]           read_data15;      // Data path to bus IF
  reg [31:0]           r_read_data15;    // Internal data store15
  reg [31:0]           smc_data15;


// Internal Signals15

  reg [1:0]            v_bus_size15;
  reg [1:0]            v_xfer_size15;
  wire [4:0]           smc_nextstate15;    //specifies15 next state
  wire [4:0]           xfer_bus_ldata15;  //concatenation15 of xfer_size15
                                         // and latch_data15  
  wire [3:0]           bus_size_num_access15; //concatenation15 of 
                                              // r_num_access15
  wire [5:0]           wt_ldata_naccs_bsiz15;  //concatenation15 of 
                                            //latch_data15,r_num_access15
 
   


// Main15 Code15

//----------------------------------------------------------------------------
// Store15 transfer15 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk15 or negedge n_sys_reset15)
  
    begin
       
       if (~n_sys_reset15)
         
          r_xfer_size15 <= 2'b00;
       
       
       else if (valid_access15)
         
          r_xfer_size15 <= xfer_size15;
       
       else
         
          r_xfer_size15 <= r_xfer_size15;
       
    end

//--------------------------------------------------------------------
// Store15 bus size generation15
//--------------------------------------------------------------------
  
  always @(posedge sys_clk15 or negedge n_sys_reset15)
    
    begin
       
       if (~n_sys_reset15)
         
          r_bus_size15 <= 2'b00;
       
       
       else if (valid_access15)
         
          r_bus_size15 <= 2'b00;
       
       else
         
          r_bus_size15 <= r_bus_size15;
       
    end
   

//--------------------------------------------------------------------
// Validate15 sizes15 generation15
//--------------------------------------------------------------------

  always @(valid_access15 or r_bus_size15 )

    begin
       
       if (valid_access15)
         
          v_bus_size15 = 2'b0;
       
       else
         
          v_bus_size15 = r_bus_size15;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size15 generation15
//----------------------------------------------------------------------------   

  always @(valid_access15 or r_xfer_size15 or xfer_size15)

    begin
       
       if (valid_access15)
         
          v_xfer_size15 = xfer_size15;
       
       else
         
          v_xfer_size15 = r_xfer_size15;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions15
// Determines15 the number15 of accesses required15 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size15)
  
    begin
       
       if ((xfer_size15[1:0] == `XSIZ_1615))
         
          num_accesses15 = 2'h1; // Two15 accesses
       
       else if ( (xfer_size15[1:0] == `XSIZ_3215))
         
          num_accesses15 = 2'h3; // Four15 accesses
       
       else
         
          num_accesses15 = 2'h0; // One15 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep15 track15 of the current access number15
//--------------------------------------------------------------------
   
  always @(posedge sys_clk15 or negedge n_sys_reset15)
  
    begin
       
       if (~n_sys_reset15)
         
          r_num_access15 <= 2'b00;
       
       else if (valid_access15)
         
          r_num_access15 <= num_accesses15;
       
       else if (smc_done15 & (smc_nextstate15 != `SMC_STORE15)  &
                      (smc_nextstate15 != `SMC_IDLE15)   )
         
          r_num_access15 <= r_num_access15 - 2'd1;
       
       else
         
          r_num_access15 <= r_num_access15;
       
    end
   
   

//--------------------------------------------------------------------
// Detect15 last access
//--------------------------------------------------------------------
   
   always @(r_num_access15)
     
     begin
        
        if (r_num_access15 == 2'h0)
          
           mac_done15 = 1'b1;
             
        else
          
           mac_done15 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals15 concatenation15 used in case statement15 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz15 = { 1'b0, latch_data15, r_num_access15,
                                  r_bus_size15};
 
   
//--------------------------------------------------------------------
// Store15 Read Data if required15
//--------------------------------------------------------------------

   always @(posedge sys_clk15 or negedge n_sys_reset15)
     
     begin
        
        if (~n_sys_reset15)
          
           r_read_data15 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz15)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data15 <= r_read_data15;
            
            //    latch_data15
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data15[31:24] <= data_smc15[7:0];
                 r_read_data15[23:0] <= 24'h0;
                 
              end
            
            // r_num_access15 =2, v_bus_size15 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data15[23:16] <= data_smc15[7:0];
                 r_read_data15[31:24] <= r_read_data15[31:24];
                 r_read_data15[15:0] <= 16'h0;
                 
              end
            
            // r_num_access15 =1, v_bus_size15 = `XSIZ_1615
            
            {1'b0,1'b1,2'h1,`XSIZ_1615}:
              
              begin
                 
                 r_read_data15[15:0] <= 16'h0;
                 r_read_data15[31:16] <= data_smc15[15:0];
                 
              end
            
            //  r_num_access15 =1,v_bus_size15 == `XSIZ_815
            
            {1'b0,1'b1,2'h1,`XSIZ_815}:          
              
              begin
                 
                 r_read_data15[15:8] <= data_smc15[7:0];
                 r_read_data15[31:16] <= r_read_data15[31:16];
                 r_read_data15[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access15 = 0, v_bus_size15 == `XSIZ_1615
            
            {1'b0,1'b1,2'h0,`XSIZ_1615}:  // r_num_access15 =0
              
              
              begin
                 
                 r_read_data15[15:0] <= data_smc15[15:0];
                 r_read_data15[31:16] <= r_read_data15[31:16];
                 
              end
            
            //  r_num_access15 = 0, v_bus_size15 == `XSIZ_815 
            
            {1'b0,1'b1,2'h0,`XSIZ_815}:
              
              begin
                 
                 r_read_data15[7:0] <= data_smc15[7:0];
                 r_read_data15[31:8] <= r_read_data15[31:8];
                 
              end
            
            //  r_num_access15 = 0, v_bus_size15 == `XSIZ_3215
            
            {1'b0,1'b1,2'h0,`XSIZ_3215}:
              
               r_read_data15[31:0] <= data_smc15[31:0];                      
            
            default :
              
               r_read_data15 <= r_read_data15;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals15 concatenation15 for case statement15 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata15 = {r_xfer_size15,r_bus_size15,latch_data15};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata15 or data_smc15 or r_read_data15 )
       
     begin
        
        casex(xfer_bus_ldata15)
          
          {`XSIZ_3215,`BSIZ_3215,1'b1} :
            
             read_data15[31:0] = data_smc15[31:0];
          
          {`XSIZ_3215,`BSIZ_1615,1'b1} :
                              
            begin
               
               read_data15[31:16] = r_read_data15[31:16];
               read_data15[15:0]  = data_smc15[15:0];
               
            end
          
          {`XSIZ_3215,`BSIZ_815,1'b1} :
            
            begin
               
               read_data15[31:8] = r_read_data15[31:8];
               read_data15[7:0]  = data_smc15[7:0];
               
            end
          
          {`XSIZ_3215,1'bx,1'bx,1'bx} :
            
            read_data15 = r_read_data15;
          
          {`XSIZ_1615,`BSIZ_1615,1'b1} :
                        
            begin
               
               read_data15[31:16] = data_smc15[15:0];
               read_data15[15:0] = data_smc15[15:0];
               
            end
          
          {`XSIZ_1615,`BSIZ_1615,1'b0} :  
            
            begin
               
               read_data15[31:16] = r_read_data15[15:0];
               read_data15[15:0] = r_read_data15[15:0];
               
            end
          
          {`XSIZ_1615,`BSIZ_3215,1'b1} :  
            
            read_data15 = data_smc15;
          
          {`XSIZ_1615,`BSIZ_815,1'b1} : 
                        
            begin
               
               read_data15[31:24] = r_read_data15[15:8];
               read_data15[23:16] = data_smc15[7:0];
               read_data15[15:8] = r_read_data15[15:8];
               read_data15[7:0] = data_smc15[7:0];
            end
          
          {`XSIZ_1615,`BSIZ_815,1'b0} : 
            
            begin
               
               read_data15[31:16] = r_read_data15[15:0];
               read_data15[15:0] = r_read_data15[15:0];
               
            end
          
          {`XSIZ_1615,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data15[31:16] = r_read_data15[31:16];
               read_data15[15:0] = r_read_data15[15:0];
               
            end
          
          {`XSIZ_815,`BSIZ_1615,1'b1} :
            
            begin
               
               read_data15[31:16] = data_smc15[15:0];
               read_data15[15:0] = data_smc15[15:0];
               
            end
          
          {`XSIZ_815,`BSIZ_1615,1'b0} :
            
            begin
               
               read_data15[31:16] = r_read_data15[15:0];
               read_data15[15:0]  = r_read_data15[15:0];
               
            end
          
          {`XSIZ_815,`BSIZ_3215,1'b1} :   
            
            read_data15 = data_smc15;
          
          {`XSIZ_815,`BSIZ_3215,1'b0} :              
                        
                        read_data15 = r_read_data15;
          
          {`XSIZ_815,`BSIZ_815,1'b1} :   
                                    
            begin
               
               read_data15[31:24] = data_smc15[7:0];
               read_data15[23:16] = data_smc15[7:0];
               read_data15[15:8]  = data_smc15[7:0];
               read_data15[7:0]   = data_smc15[7:0];
               
            end
          
          default:
            
            begin
               
               read_data15[31:24] = r_read_data15[7:0];
               read_data15[23:16] = r_read_data15[7:0];
               read_data15[15:8]  = r_read_data15[7:0];
               read_data15[7:0]   = r_read_data15[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata15)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal15 concatenation15 for use in case statement15
//----------------------------------------------------------------------------
   
   assign bus_size_num_access15 = { r_bus_size15, r_num_access15};
   
//--------------------------------------------------------------------
// Select15 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access15 or write_data15)
  
    begin
       
       casex(bus_size_num_access15)
         
         {`BSIZ_3215,1'bx,1'bx}://    (v_bus_size15 == `BSIZ_3215)
           
           smc_data15 = write_data15;
         
         {`BSIZ_1615,2'h1}:    // r_num_access15 == 1
                      
           begin
              
              smc_data15[31:16] = 16'h0;
              smc_data15[15:0] = write_data15[31:16];
              
           end 
         
         {`BSIZ_1615,1'bx,1'bx}:  // (v_bus_size15 == `BSIZ_1615)  
           
           begin
              
              smc_data15[31:16] = 16'h0;
              smc_data15[15:0]  = write_data15[15:0];
              
           end
         
         {`BSIZ_815,2'h3}:  //  (r_num_access15 == 3)
           
           begin
              
              smc_data15[31:8] = 24'h0;
              smc_data15[7:0] = write_data15[31:24];
           end
         
         {`BSIZ_815,2'h2}:  //   (r_num_access15 == 2)
           
           begin
              
              smc_data15[31:8] = 24'h0;
              smc_data15[7:0] = write_data15[23:16];
              
           end
         
         {`BSIZ_815,2'h1}:  //  (r_num_access15 == 2)
           
           begin
              
              smc_data15[31:8] = 24'h0;
              smc_data15[7:0]  = write_data15[15:8];
              
           end 
         
         {`BSIZ_815,2'h0}:  //  (r_num_access15 == 0) 
           
           begin
              
              smc_data15[31:8] = 24'h0;
              smc_data15[7:0] = write_data15[7:0];
              
           end 
         
         default:
           
           smc_data15 = 32'h0;
         
       endcase // casex(bus_size_num_access15)
       
       
    end
   
endmodule
