//File25 name   : smc_mac_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : Multiple25 access controller25.
//            : Static25 Memory Controller25.
//            : The Multiple25 Access Control25 Block keeps25 trace25 of the
//            : number25 of accesses required25 to fulfill25 the
//            : requirements25 of the AHB25 transfer25. The data is
//            : registered when multiple reads are required25. The AHB25
//            : holds25 the data during multiple writes.
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

`include "smc_defs_lite25.v"

module smc_mac_lite25     (

                    //inputs25
                    
                    sys_clk25,
                    n_sys_reset25,
                    valid_access25,
                    xfer_size25,
                    smc_done25,
                    data_smc25,
                    write_data25,
                    smc_nextstate25,
                    latch_data25,
                    
                    //outputs25
                    
                    r_num_access25,
                    mac_done25,
                    v_bus_size25,
                    v_xfer_size25,
                    read_data25,
                    smc_data25);
   
   
   
 


// State25 Machine25// I25/O25

  input                sys_clk25;        // System25 clock25
  input                n_sys_reset25;    // System25 reset (Active25 LOW25)
  input                valid_access25;   // Address cycle of new transfer25
  input  [1:0]         xfer_size25;      // xfer25 size, valid with valid_access25
  input                smc_done25;       // End25 of transfer25
  input  [31:0]        data_smc25;       // External25 read data
  input  [31:0]        write_data25;     // Data from internal bus 
  input  [4:0]         smc_nextstate25;  // State25 Machine25  
  input                latch_data25;     //latch_data25 is used by the MAC25 block    
  
  output [1:0]         r_num_access25;   // Access counter
  output               mac_done25;       // End25 of all transfers25
  output [1:0]         v_bus_size25;     // Registered25 sizes25 for subsequent25
  output [1:0]         v_xfer_size25;    // transfers25 in MAC25 transfer25
  output [31:0]        read_data25;      // Data to internal bus
  output [31:0]        smc_data25;       // Data to external25 bus
  

// Output25 register declarations25

  reg                  mac_done25;       // Indicates25 last cycle of last access
  reg [1:0]            r_num_access25;   // Access counter
  reg [1:0]            num_accesses25;   //number25 of access
  reg [1:0]            r_xfer_size25;    // Store25 size for MAC25 
  reg [1:0]            r_bus_size25;     // Store25 size for MAC25
  reg [31:0]           read_data25;      // Data path to bus IF
  reg [31:0]           r_read_data25;    // Internal data store25
  reg [31:0]           smc_data25;


// Internal Signals25

  reg [1:0]            v_bus_size25;
  reg [1:0]            v_xfer_size25;
  wire [4:0]           smc_nextstate25;    //specifies25 next state
  wire [4:0]           xfer_bus_ldata25;  //concatenation25 of xfer_size25
                                         // and latch_data25  
  wire [3:0]           bus_size_num_access25; //concatenation25 of 
                                              // r_num_access25
  wire [5:0]           wt_ldata_naccs_bsiz25;  //concatenation25 of 
                                            //latch_data25,r_num_access25
 
   


// Main25 Code25

//----------------------------------------------------------------------------
// Store25 transfer25 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk25 or negedge n_sys_reset25)
  
    begin
       
       if (~n_sys_reset25)
         
          r_xfer_size25 <= 2'b00;
       
       
       else if (valid_access25)
         
          r_xfer_size25 <= xfer_size25;
       
       else
         
          r_xfer_size25 <= r_xfer_size25;
       
    end

//--------------------------------------------------------------------
// Store25 bus size generation25
//--------------------------------------------------------------------
  
  always @(posedge sys_clk25 or negedge n_sys_reset25)
    
    begin
       
       if (~n_sys_reset25)
         
          r_bus_size25 <= 2'b00;
       
       
       else if (valid_access25)
         
          r_bus_size25 <= 2'b00;
       
       else
         
          r_bus_size25 <= r_bus_size25;
       
    end
   

//--------------------------------------------------------------------
// Validate25 sizes25 generation25
//--------------------------------------------------------------------

  always @(valid_access25 or r_bus_size25 )

    begin
       
       if (valid_access25)
         
          v_bus_size25 = 2'b0;
       
       else
         
          v_bus_size25 = r_bus_size25;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size25 generation25
//----------------------------------------------------------------------------   

  always @(valid_access25 or r_xfer_size25 or xfer_size25)

    begin
       
       if (valid_access25)
         
          v_xfer_size25 = xfer_size25;
       
       else
         
          v_xfer_size25 = r_xfer_size25;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions25
// Determines25 the number25 of accesses required25 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size25)
  
    begin
       
       if ((xfer_size25[1:0] == `XSIZ_1625))
         
          num_accesses25 = 2'h1; // Two25 accesses
       
       else if ( (xfer_size25[1:0] == `XSIZ_3225))
         
          num_accesses25 = 2'h3; // Four25 accesses
       
       else
         
          num_accesses25 = 2'h0; // One25 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep25 track25 of the current access number25
//--------------------------------------------------------------------
   
  always @(posedge sys_clk25 or negedge n_sys_reset25)
  
    begin
       
       if (~n_sys_reset25)
         
          r_num_access25 <= 2'b00;
       
       else if (valid_access25)
         
          r_num_access25 <= num_accesses25;
       
       else if (smc_done25 & (smc_nextstate25 != `SMC_STORE25)  &
                      (smc_nextstate25 != `SMC_IDLE25)   )
         
          r_num_access25 <= r_num_access25 - 2'd1;
       
       else
         
          r_num_access25 <= r_num_access25;
       
    end
   
   

//--------------------------------------------------------------------
// Detect25 last access
//--------------------------------------------------------------------
   
   always @(r_num_access25)
     
     begin
        
        if (r_num_access25 == 2'h0)
          
           mac_done25 = 1'b1;
             
        else
          
           mac_done25 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals25 concatenation25 used in case statement25 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz25 = { 1'b0, latch_data25, r_num_access25,
                                  r_bus_size25};
 
   
//--------------------------------------------------------------------
// Store25 Read Data if required25
//--------------------------------------------------------------------

   always @(posedge sys_clk25 or negedge n_sys_reset25)
     
     begin
        
        if (~n_sys_reset25)
          
           r_read_data25 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz25)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data25 <= r_read_data25;
            
            //    latch_data25
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data25[31:24] <= data_smc25[7:0];
                 r_read_data25[23:0] <= 24'h0;
                 
              end
            
            // r_num_access25 =2, v_bus_size25 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data25[23:16] <= data_smc25[7:0];
                 r_read_data25[31:24] <= r_read_data25[31:24];
                 r_read_data25[15:0] <= 16'h0;
                 
              end
            
            // r_num_access25 =1, v_bus_size25 = `XSIZ_1625
            
            {1'b0,1'b1,2'h1,`XSIZ_1625}:
              
              begin
                 
                 r_read_data25[15:0] <= 16'h0;
                 r_read_data25[31:16] <= data_smc25[15:0];
                 
              end
            
            //  r_num_access25 =1,v_bus_size25 == `XSIZ_825
            
            {1'b0,1'b1,2'h1,`XSIZ_825}:          
              
              begin
                 
                 r_read_data25[15:8] <= data_smc25[7:0];
                 r_read_data25[31:16] <= r_read_data25[31:16];
                 r_read_data25[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access25 = 0, v_bus_size25 == `XSIZ_1625
            
            {1'b0,1'b1,2'h0,`XSIZ_1625}:  // r_num_access25 =0
              
              
              begin
                 
                 r_read_data25[15:0] <= data_smc25[15:0];
                 r_read_data25[31:16] <= r_read_data25[31:16];
                 
              end
            
            //  r_num_access25 = 0, v_bus_size25 == `XSIZ_825 
            
            {1'b0,1'b1,2'h0,`XSIZ_825}:
              
              begin
                 
                 r_read_data25[7:0] <= data_smc25[7:0];
                 r_read_data25[31:8] <= r_read_data25[31:8];
                 
              end
            
            //  r_num_access25 = 0, v_bus_size25 == `XSIZ_3225
            
            {1'b0,1'b1,2'h0,`XSIZ_3225}:
              
               r_read_data25[31:0] <= data_smc25[31:0];                      
            
            default :
              
               r_read_data25 <= r_read_data25;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals25 concatenation25 for case statement25 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata25 = {r_xfer_size25,r_bus_size25,latch_data25};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata25 or data_smc25 or r_read_data25 )
       
     begin
        
        casex(xfer_bus_ldata25)
          
          {`XSIZ_3225,`BSIZ_3225,1'b1} :
            
             read_data25[31:0] = data_smc25[31:0];
          
          {`XSIZ_3225,`BSIZ_1625,1'b1} :
                              
            begin
               
               read_data25[31:16] = r_read_data25[31:16];
               read_data25[15:0]  = data_smc25[15:0];
               
            end
          
          {`XSIZ_3225,`BSIZ_825,1'b1} :
            
            begin
               
               read_data25[31:8] = r_read_data25[31:8];
               read_data25[7:0]  = data_smc25[7:0];
               
            end
          
          {`XSIZ_3225,1'bx,1'bx,1'bx} :
            
            read_data25 = r_read_data25;
          
          {`XSIZ_1625,`BSIZ_1625,1'b1} :
                        
            begin
               
               read_data25[31:16] = data_smc25[15:0];
               read_data25[15:0] = data_smc25[15:0];
               
            end
          
          {`XSIZ_1625,`BSIZ_1625,1'b0} :  
            
            begin
               
               read_data25[31:16] = r_read_data25[15:0];
               read_data25[15:0] = r_read_data25[15:0];
               
            end
          
          {`XSIZ_1625,`BSIZ_3225,1'b1} :  
            
            read_data25 = data_smc25;
          
          {`XSIZ_1625,`BSIZ_825,1'b1} : 
                        
            begin
               
               read_data25[31:24] = r_read_data25[15:8];
               read_data25[23:16] = data_smc25[7:0];
               read_data25[15:8] = r_read_data25[15:8];
               read_data25[7:0] = data_smc25[7:0];
            end
          
          {`XSIZ_1625,`BSIZ_825,1'b0} : 
            
            begin
               
               read_data25[31:16] = r_read_data25[15:0];
               read_data25[15:0] = r_read_data25[15:0];
               
            end
          
          {`XSIZ_1625,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data25[31:16] = r_read_data25[31:16];
               read_data25[15:0] = r_read_data25[15:0];
               
            end
          
          {`XSIZ_825,`BSIZ_1625,1'b1} :
            
            begin
               
               read_data25[31:16] = data_smc25[15:0];
               read_data25[15:0] = data_smc25[15:0];
               
            end
          
          {`XSIZ_825,`BSIZ_1625,1'b0} :
            
            begin
               
               read_data25[31:16] = r_read_data25[15:0];
               read_data25[15:0]  = r_read_data25[15:0];
               
            end
          
          {`XSIZ_825,`BSIZ_3225,1'b1} :   
            
            read_data25 = data_smc25;
          
          {`XSIZ_825,`BSIZ_3225,1'b0} :              
                        
                        read_data25 = r_read_data25;
          
          {`XSIZ_825,`BSIZ_825,1'b1} :   
                                    
            begin
               
               read_data25[31:24] = data_smc25[7:0];
               read_data25[23:16] = data_smc25[7:0];
               read_data25[15:8]  = data_smc25[7:0];
               read_data25[7:0]   = data_smc25[7:0];
               
            end
          
          default:
            
            begin
               
               read_data25[31:24] = r_read_data25[7:0];
               read_data25[23:16] = r_read_data25[7:0];
               read_data25[15:8]  = r_read_data25[7:0];
               read_data25[7:0]   = r_read_data25[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata25)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal25 concatenation25 for use in case statement25
//----------------------------------------------------------------------------
   
   assign bus_size_num_access25 = { r_bus_size25, r_num_access25};
   
//--------------------------------------------------------------------
// Select25 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access25 or write_data25)
  
    begin
       
       casex(bus_size_num_access25)
         
         {`BSIZ_3225,1'bx,1'bx}://    (v_bus_size25 == `BSIZ_3225)
           
           smc_data25 = write_data25;
         
         {`BSIZ_1625,2'h1}:    // r_num_access25 == 1
                      
           begin
              
              smc_data25[31:16] = 16'h0;
              smc_data25[15:0] = write_data25[31:16];
              
           end 
         
         {`BSIZ_1625,1'bx,1'bx}:  // (v_bus_size25 == `BSIZ_1625)  
           
           begin
              
              smc_data25[31:16] = 16'h0;
              smc_data25[15:0]  = write_data25[15:0];
              
           end
         
         {`BSIZ_825,2'h3}:  //  (r_num_access25 == 3)
           
           begin
              
              smc_data25[31:8] = 24'h0;
              smc_data25[7:0] = write_data25[31:24];
           end
         
         {`BSIZ_825,2'h2}:  //   (r_num_access25 == 2)
           
           begin
              
              smc_data25[31:8] = 24'h0;
              smc_data25[7:0] = write_data25[23:16];
              
           end
         
         {`BSIZ_825,2'h1}:  //  (r_num_access25 == 2)
           
           begin
              
              smc_data25[31:8] = 24'h0;
              smc_data25[7:0]  = write_data25[15:8];
              
           end 
         
         {`BSIZ_825,2'h0}:  //  (r_num_access25 == 0) 
           
           begin
              
              smc_data25[31:8] = 24'h0;
              smc_data25[7:0] = write_data25[7:0];
              
           end 
         
         default:
           
           smc_data25 = 32'h0;
         
       endcase // casex(bus_size_num_access25)
       
       
    end
   
endmodule
