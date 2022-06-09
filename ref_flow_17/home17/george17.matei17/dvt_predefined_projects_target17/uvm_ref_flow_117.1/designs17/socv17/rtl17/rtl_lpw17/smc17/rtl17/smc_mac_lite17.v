//File17 name   : smc_mac_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : Multiple17 access controller17.
//            : Static17 Memory Controller17.
//            : The Multiple17 Access Control17 Block keeps17 trace17 of the
//            : number17 of accesses required17 to fulfill17 the
//            : requirements17 of the AHB17 transfer17. The data is
//            : registered when multiple reads are required17. The AHB17
//            : holds17 the data during multiple writes.
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

`include "smc_defs_lite17.v"

module smc_mac_lite17     (

                    //inputs17
                    
                    sys_clk17,
                    n_sys_reset17,
                    valid_access17,
                    xfer_size17,
                    smc_done17,
                    data_smc17,
                    write_data17,
                    smc_nextstate17,
                    latch_data17,
                    
                    //outputs17
                    
                    r_num_access17,
                    mac_done17,
                    v_bus_size17,
                    v_xfer_size17,
                    read_data17,
                    smc_data17);
   
   
   
 


// State17 Machine17// I17/O17

  input                sys_clk17;        // System17 clock17
  input                n_sys_reset17;    // System17 reset (Active17 LOW17)
  input                valid_access17;   // Address cycle of new transfer17
  input  [1:0]         xfer_size17;      // xfer17 size, valid with valid_access17
  input                smc_done17;       // End17 of transfer17
  input  [31:0]        data_smc17;       // External17 read data
  input  [31:0]        write_data17;     // Data from internal bus 
  input  [4:0]         smc_nextstate17;  // State17 Machine17  
  input                latch_data17;     //latch_data17 is used by the MAC17 block    
  
  output [1:0]         r_num_access17;   // Access counter
  output               mac_done17;       // End17 of all transfers17
  output [1:0]         v_bus_size17;     // Registered17 sizes17 for subsequent17
  output [1:0]         v_xfer_size17;    // transfers17 in MAC17 transfer17
  output [31:0]        read_data17;      // Data to internal bus
  output [31:0]        smc_data17;       // Data to external17 bus
  

// Output17 register declarations17

  reg                  mac_done17;       // Indicates17 last cycle of last access
  reg [1:0]            r_num_access17;   // Access counter
  reg [1:0]            num_accesses17;   //number17 of access
  reg [1:0]            r_xfer_size17;    // Store17 size for MAC17 
  reg [1:0]            r_bus_size17;     // Store17 size for MAC17
  reg [31:0]           read_data17;      // Data path to bus IF
  reg [31:0]           r_read_data17;    // Internal data store17
  reg [31:0]           smc_data17;


// Internal Signals17

  reg [1:0]            v_bus_size17;
  reg [1:0]            v_xfer_size17;
  wire [4:0]           smc_nextstate17;    //specifies17 next state
  wire [4:0]           xfer_bus_ldata17;  //concatenation17 of xfer_size17
                                         // and latch_data17  
  wire [3:0]           bus_size_num_access17; //concatenation17 of 
                                              // r_num_access17
  wire [5:0]           wt_ldata_naccs_bsiz17;  //concatenation17 of 
                                            //latch_data17,r_num_access17
 
   


// Main17 Code17

//----------------------------------------------------------------------------
// Store17 transfer17 size
//----------------------------------------------------------------------------

  always @(posedge sys_clk17 or negedge n_sys_reset17)
  
    begin
       
       if (~n_sys_reset17)
         
          r_xfer_size17 <= 2'b00;
       
       
       else if (valid_access17)
         
          r_xfer_size17 <= xfer_size17;
       
       else
         
          r_xfer_size17 <= r_xfer_size17;
       
    end

//--------------------------------------------------------------------
// Store17 bus size generation17
//--------------------------------------------------------------------
  
  always @(posedge sys_clk17 or negedge n_sys_reset17)
    
    begin
       
       if (~n_sys_reset17)
         
          r_bus_size17 <= 2'b00;
       
       
       else if (valid_access17)
         
          r_bus_size17 <= 2'b00;
       
       else
         
          r_bus_size17 <= r_bus_size17;
       
    end
   

//--------------------------------------------------------------------
// Validate17 sizes17 generation17
//--------------------------------------------------------------------

  always @(valid_access17 or r_bus_size17 )

    begin
       
       if (valid_access17)
         
          v_bus_size17 = 2'b0;
       
       else
         
          v_bus_size17 = r_bus_size17;
       
    end

//----------------------------------------------------------------------------
//v_xfer_size17 generation17
//----------------------------------------------------------------------------   

  always @(valid_access17 or r_xfer_size17 or xfer_size17)

    begin
       
       if (valid_access17)
         
          v_xfer_size17 = xfer_size17;
       
       else
         
          v_xfer_size17 = r_xfer_size17;
       
    end
   
  

//----------------------------------------------------------------------------
// Access size decisions17
// Determines17 the number17 of accesses required17 to build up full size
//----------------------------------------------------------------------------
   
  always @( xfer_size17)
  
    begin
       
       if ((xfer_size17[1:0] == `XSIZ_1617))
         
          num_accesses17 = 2'h1; // Two17 accesses
       
       else if ( (xfer_size17[1:0] == `XSIZ_3217))
         
          num_accesses17 = 2'h3; // Four17 accesses
       
       else
         
          num_accesses17 = 2'h0; // One17 access
       
    end
   
   
   
//--------------------------------------------------------------------
// Keep17 track17 of the current access number17
//--------------------------------------------------------------------
   
  always @(posedge sys_clk17 or negedge n_sys_reset17)
  
    begin
       
       if (~n_sys_reset17)
         
          r_num_access17 <= 2'b00;
       
       else if (valid_access17)
         
          r_num_access17 <= num_accesses17;
       
       else if (smc_done17 & (smc_nextstate17 != `SMC_STORE17)  &
                      (smc_nextstate17 != `SMC_IDLE17)   )
         
          r_num_access17 <= r_num_access17 - 2'd1;
       
       else
         
          r_num_access17 <= r_num_access17;
       
    end
   
   

//--------------------------------------------------------------------
// Detect17 last access
//--------------------------------------------------------------------
   
   always @(r_num_access17)
     
     begin
        
        if (r_num_access17 == 2'h0)
          
           mac_done17 = 1'b1;
             
        else
          
           mac_done17 = 1'b0;
          
     end
   
//----------------------------------------------------------------------------   
//signals17 concatenation17 used in case statement17 for read data logic
//----------------------------------------------------------------------------   

   assign wt_ldata_naccs_bsiz17 = { 1'b0, latch_data17, r_num_access17,
                                  r_bus_size17};
 
   
//--------------------------------------------------------------------
// Store17 Read Data if required17
//--------------------------------------------------------------------

   always @(posedge sys_clk17 or negedge n_sys_reset17)
     
     begin
        
        if (~n_sys_reset17)
          
           r_read_data17 <= 32'h0;
        
        else
          
          
          casex(wt_ldata_naccs_bsiz17)
            
            
            {1'b1,5'bxxxxx} :
              
               r_read_data17 <= r_read_data17;
            
            //    latch_data17
            
            {1'b0,1'b1,2'h3,2'bxx}:
                             
              begin
                 
                 r_read_data17[31:24] <= data_smc17[7:0];
                 r_read_data17[23:0] <= 24'h0;
                 
              end
            
            // r_num_access17 =2, v_bus_size17 = X
            
            {1'b0,1'b1,2'h2,2'bx}: 
              
              begin
                 
                 r_read_data17[23:16] <= data_smc17[7:0];
                 r_read_data17[31:24] <= r_read_data17[31:24];
                 r_read_data17[15:0] <= 16'h0;
                 
              end
            
            // r_num_access17 =1, v_bus_size17 = `XSIZ_1617
            
            {1'b0,1'b1,2'h1,`XSIZ_1617}:
              
              begin
                 
                 r_read_data17[15:0] <= 16'h0;
                 r_read_data17[31:16] <= data_smc17[15:0];
                 
              end
            
            //  r_num_access17 =1,v_bus_size17 == `XSIZ_817
            
            {1'b0,1'b1,2'h1,`XSIZ_817}:          
              
              begin
                 
                 r_read_data17[15:8] <= data_smc17[7:0];
                 r_read_data17[31:16] <= r_read_data17[31:16];
                 r_read_data17[7:0] <= 8'h0;
                 
              end
            
            
            //  r_num_access17 = 0, v_bus_size17 == `XSIZ_1617
            
            {1'b0,1'b1,2'h0,`XSIZ_1617}:  // r_num_access17 =0
              
              
              begin
                 
                 r_read_data17[15:0] <= data_smc17[15:0];
                 r_read_data17[31:16] <= r_read_data17[31:16];
                 
              end
            
            //  r_num_access17 = 0, v_bus_size17 == `XSIZ_817 
            
            {1'b0,1'b1,2'h0,`XSIZ_817}:
              
              begin
                 
                 r_read_data17[7:0] <= data_smc17[7:0];
                 r_read_data17[31:8] <= r_read_data17[31:8];
                 
              end
            
            //  r_num_access17 = 0, v_bus_size17 == `XSIZ_3217
            
            {1'b0,1'b1,2'h0,`XSIZ_3217}:
              
               r_read_data17[31:0] <= data_smc17[31:0];                      
            
            default :
              
               r_read_data17 <= r_read_data17;
            
            
          endcase // case
        
        
        
     end
   
   
//--------------------------------------------------------------------------
// signals17 concatenation17 for case statement17 use.
//--------------------------------------------------------------------------

   
   assign xfer_bus_ldata17 = {r_xfer_size17,r_bus_size17,latch_data17};

//--------------------------------------------------------------------------
// read data
//--------------------------------------------------------------------------
                           
   always @( xfer_bus_ldata17 or data_smc17 or r_read_data17 )
       
     begin
        
        casex(xfer_bus_ldata17)
          
          {`XSIZ_3217,`BSIZ_3217,1'b1} :
            
             read_data17[31:0] = data_smc17[31:0];
          
          {`XSIZ_3217,`BSIZ_1617,1'b1} :
                              
            begin
               
               read_data17[31:16] = r_read_data17[31:16];
               read_data17[15:0]  = data_smc17[15:0];
               
            end
          
          {`XSIZ_3217,`BSIZ_817,1'b1} :
            
            begin
               
               read_data17[31:8] = r_read_data17[31:8];
               read_data17[7:0]  = data_smc17[7:0];
               
            end
          
          {`XSIZ_3217,1'bx,1'bx,1'bx} :
            
            read_data17 = r_read_data17;
          
          {`XSIZ_1617,`BSIZ_1617,1'b1} :
                        
            begin
               
               read_data17[31:16] = data_smc17[15:0];
               read_data17[15:0] = data_smc17[15:0];
               
            end
          
          {`XSIZ_1617,`BSIZ_1617,1'b0} :  
            
            begin
               
               read_data17[31:16] = r_read_data17[15:0];
               read_data17[15:0] = r_read_data17[15:0];
               
            end
          
          {`XSIZ_1617,`BSIZ_3217,1'b1} :  
            
            read_data17 = data_smc17;
          
          {`XSIZ_1617,`BSIZ_817,1'b1} : 
                        
            begin
               
               read_data17[31:24] = r_read_data17[15:8];
               read_data17[23:16] = data_smc17[7:0];
               read_data17[15:8] = r_read_data17[15:8];
               read_data17[7:0] = data_smc17[7:0];
            end
          
          {`XSIZ_1617,`BSIZ_817,1'b0} : 
            
            begin
               
               read_data17[31:16] = r_read_data17[15:0];
               read_data17[15:0] = r_read_data17[15:0];
               
            end
          
          {`XSIZ_1617,1'bx,1'bx,1'bx} :
            
            begin
               
               read_data17[31:16] = r_read_data17[31:16];
               read_data17[15:0] = r_read_data17[15:0];
               
            end
          
          {`XSIZ_817,`BSIZ_1617,1'b1} :
            
            begin
               
               read_data17[31:16] = data_smc17[15:0];
               read_data17[15:0] = data_smc17[15:0];
               
            end
          
          {`XSIZ_817,`BSIZ_1617,1'b0} :
            
            begin
               
               read_data17[31:16] = r_read_data17[15:0];
               read_data17[15:0]  = r_read_data17[15:0];
               
            end
          
          {`XSIZ_817,`BSIZ_3217,1'b1} :   
            
            read_data17 = data_smc17;
          
          {`XSIZ_817,`BSIZ_3217,1'b0} :              
                        
                        read_data17 = r_read_data17;
          
          {`XSIZ_817,`BSIZ_817,1'b1} :   
                                    
            begin
               
               read_data17[31:24] = data_smc17[7:0];
               read_data17[23:16] = data_smc17[7:0];
               read_data17[15:8]  = data_smc17[7:0];
               read_data17[7:0]   = data_smc17[7:0];
               
            end
          
          default:
            
            begin
               
               read_data17[31:24] = r_read_data17[7:0];
               read_data17[23:16] = r_read_data17[7:0];
               read_data17[15:8]  = r_read_data17[7:0];
               read_data17[7:0]   = r_read_data17[7:0];
               
            end
          
        endcase // case( xfer_bus_ldata17)
        
        
     end
   
//---------------------------------------------------------------------------- 
// signal17 concatenation17 for use in case statement17
//----------------------------------------------------------------------------
   
   assign bus_size_num_access17 = { r_bus_size17, r_num_access17};
   
//--------------------------------------------------------------------
// Select17 write data
//--------------------------------------------------------------------

  always @(bus_size_num_access17 or write_data17)
  
    begin
       
       casex(bus_size_num_access17)
         
         {`BSIZ_3217,1'bx,1'bx}://    (v_bus_size17 == `BSIZ_3217)
           
           smc_data17 = write_data17;
         
         {`BSIZ_1617,2'h1}:    // r_num_access17 == 1
                      
           begin
              
              smc_data17[31:16] = 16'h0;
              smc_data17[15:0] = write_data17[31:16];
              
           end 
         
         {`BSIZ_1617,1'bx,1'bx}:  // (v_bus_size17 == `BSIZ_1617)  
           
           begin
              
              smc_data17[31:16] = 16'h0;
              smc_data17[15:0]  = write_data17[15:0];
              
           end
         
         {`BSIZ_817,2'h3}:  //  (r_num_access17 == 3)
           
           begin
              
              smc_data17[31:8] = 24'h0;
              smc_data17[7:0] = write_data17[31:24];
           end
         
         {`BSIZ_817,2'h2}:  //   (r_num_access17 == 2)
           
           begin
              
              smc_data17[31:8] = 24'h0;
              smc_data17[7:0] = write_data17[23:16];
              
           end
         
         {`BSIZ_817,2'h1}:  //  (r_num_access17 == 2)
           
           begin
              
              smc_data17[31:8] = 24'h0;
              smc_data17[7:0]  = write_data17[15:8];
              
           end 
         
         {`BSIZ_817,2'h0}:  //  (r_num_access17 == 0) 
           
           begin
              
              smc_data17[31:8] = 24'h0;
              smc_data17[7:0] = write_data17[7:0];
              
           end 
         
         default:
           
           smc_data17 = 32'h0;
         
       endcase // casex(bus_size_num_access17)
       
       
    end
   
endmodule
