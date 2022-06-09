//File3 name   : smc_lite3.v
//Title3       : SMC3 top level
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

 `include "smc_defs_lite3.v"

//static memory controller3
module          smc_lite3(
                    //apb3 inputs3
                    n_preset3, 
                    pclk3, 
                    psel3, 
                    penable3, 
                    pwrite3, 
                    paddr3, 
                    pwdata3,
                    //ahb3 inputs3                    
                    hclk3,
                    n_sys_reset3,
                    haddr3,
                    htrans3,
                    hsel3,
                    hwrite3,
                    hsize3,
                    hwdata3,
                    hready3,
                    data_smc3,
                    

                    //test signal3 inputs3

                    scan_in_13,
                    scan_in_23,
                    scan_in_33,
                    scan_en3,

                    //apb3 outputs3                    
                    prdata3,

                    //design output
                    
                    smc_hrdata3, 
                    smc_hready3,
                    smc_valid3,
                    smc_hresp3,
                    smc_addr3,
                    smc_data3, 
                    smc_n_be3,
                    smc_n_cs3,
                    smc_n_wr3,                    
                    smc_n_we3,
                    smc_n_rd3,
                    smc_n_ext_oe3,
                    smc_busy3,

                    //test signal3 output

                    scan_out_13,
                    scan_out_23,
                    scan_out_33
                   );
// define parameters3
// change using defaparam3 statements3


  // APB3 Inputs3 (use is optional3 on INCLUDE_APB3)
  input        n_preset3;           // APBreset3 
  input        pclk3;               // APB3 clock3
  input        psel3;               // APB3 select3
  input        penable3;            // APB3 enable 
  input        pwrite3;             // APB3 write strobe3 
  input [4:0]  paddr3;              // APB3 address bus
  input [31:0] pwdata3;             // APB3 write data 

  // APB3 Output3 (use is optional3 on INCLUDE_APB3)

  output [31:0] prdata3;        //APB3 output



//System3 I3/O3

  input                    hclk3;          // AHB3 System3 clock3
  input                    n_sys_reset3;   // AHB3 System3 reset (Active3 LOW3)

//AHB3 I3/O3

  input  [31:0]            haddr3;         // AHB3 Address
  input  [1:0]             htrans3;        // AHB3 transfer3 type
  input               hsel3;          // chip3 selects3
  input                    hwrite3;        // AHB3 read/write indication3
  input  [2:0]             hsize3;         // AHB3 transfer3 size
  input  [31:0]            hwdata3;        // AHB3 write data
  input                    hready3;        // AHB3 Muxed3 ready signal3

  
  output [31:0]            smc_hrdata3;    // smc3 read data back to AHB3 master3
  output                   smc_hready3;    // smc3 ready signal3
  output [1:0]             smc_hresp3;     // AHB3 Response3 signal3
  output                   smc_valid3;     // Ack3 valid address

//External3 memory interface (EMI3)

  output [31:0]            smc_addr3;      // External3 Memory (EMI3) address
  output [31:0]            smc_data3;      // EMI3 write data
  input  [31:0]            data_smc3;      // EMI3 read data
  output [3:0]             smc_n_be3;      // EMI3 byte enables3 (Active3 LOW3)
  output             smc_n_cs3;      // EMI3 Chip3 Selects3 (Active3 LOW3)
  output [3:0]             smc_n_we3;      // EMI3 write strobes3 (Active3 LOW3)
  output                   smc_n_wr3;      // EMI3 write enable (Active3 LOW3)
  output                   smc_n_rd3;      // EMI3 read stobe3 (Active3 LOW3)
  output 	           smc_n_ext_oe3;  // EMI3 write data output enable

//AHB3 Memory Interface3 Control3

   output                   smc_busy3;      // smc3 busy

   
   


//scan3 signals3

   input                  scan_in_13;        //scan3 input
   input                  scan_in_23;        //scan3 input
   input                  scan_en3;         //scan3 enable
   output                 scan_out_13;       //scan3 output
   output                 scan_out_23;       //scan3 output
// third3 scan3 chain3 only used on INCLUDE_APB3
   input                  scan_in_33;        //scan3 input
   output                 scan_out_33;       //scan3 output
   
//----------------------------------------------------------------------
// Signal3 declarations3
//----------------------------------------------------------------------

// Bus3 Interface3
   
  wire  [31:0]   smc_hrdata3;         //smc3 read data back to AHB3 master3
  wire           smc_hready3;         //smc3 ready signal3
  wire  [1:0]    smc_hresp3;          //AHB3 Response3 signal3
  wire           smc_valid3;          //Ack3 valid address

// MAC3

  wire [31:0]    smc_data3;           //Data to external3 bus via MUX3

// Strobe3 Generation3

  wire           smc_n_wr3;           //EMI3 write enable (Active3 LOW3)
  wire  [3:0]    smc_n_we3;           //EMI3 write strobes3 (Active3 LOW3)
  wire           smc_n_rd3;           //EMI3 read stobe3 (Active3 LOW3)
  wire           smc_busy3;           //smc3 busy
  wire           smc_n_ext_oe3;       //Enable3 External3 bus drivers3.(CS3 & !RD3)

// Address Generation3

  wire [31:0]    smc_addr3;           //External3 Memory Interface3(EMI3) address
  wire [3:0]     smc_n_be3;   //EMI3 byte enables3 (Active3 LOW3)
  wire      smc_n_cs3;   //EMI3 Chip3 Selects3 (Active3 LOW3)

// Bus3 Interface3

  wire           new_access3;         // New3 AHB3 access to smc3 detected
  wire [31:0]    addr;               // Copy3 of address
  wire [31:0]    write_data3;         // Data to External3 Bus3
  wire      cs;         // Chip3(bank3) Select3 Lines3
  wire [1:0]     xfer_size3;          // Width3 of current transfer3
  wire           n_read3;             // Active3 low3 read signal3                   
  
// Configuration3 Block


// Counters3

  wire [1:0]     r_csle_count3;       // Chip3 select3 LE3 counter
  wire [1:0]     r_wele_count3;       // Write counter
  wire [1:0]     r_cste_count3;       // chip3 select3 TE3 counter
  wire [7:0]     r_ws_count3; // Wait3 state select3 counter
  
// These3 strobes3 finish early3 so no counter is required3. The stored3 value
// is compared with WS3 counter to determine3 when the strobe3 should end.

  wire [1:0]     r_wete_store3;       // Write strobe3 TE3 end time before CS3
  wire [1:0]     r_oete_store3;       // Read strobe3 TE3 end time before CS3
  
// The following3 four3 wireisrers3 are used to store3 the configuration during
// mulitple3 accesses. The counters3 are reloaded3 from these3 wireisters3
//  before each cycle.

  wire [1:0]     r_csle_store3;       // Chip3 select3 LE3 store3
  wire [1:0]     r_wele_store3;       // Write strobe3 LE3 store3
  wire [7:0]     r_ws_store3;         // Wait3 state store3
  wire [1:0]     r_cste_store3;       // Chip3 Select3 TE3 delay (Bus3 float3 time)


// Multiple3 access control3

  wire           mac_done3;           // Indicates3 last cycle of last access
  wire [1:0]     r_num_access3;       // Access counter
  wire [1:0]     v_xfer_size3;        // Store3 size for MAC3 
  wire [1:0]     v_bus_size3;         // Store3 size for MAC3
  wire [31:0]    read_data3;          // Data path to bus IF
  wire [31:0]    r_read_data3;        // Internal data store3

// smc3 state machine3


  wire           valid_access3;       // New3 acces3 can proceed
  wire   [4:0]   smc_nextstate3;      // state machine3 (async3 encoding3)
  wire   [4:0]   r_smc_currentstate3; // Synchronised3 smc3 state machine3
  wire           ws_enable3;          // Wait3 state counter enable
  wire           cste_enable3;        // Chip3 select3 counter enable
  wire           smc_done3;           // Asserted3 during last cycle of
                                     //    an access
  wire           le_enable3;          // Start3 counters3 after STORED3 
                                     //    access
  wire           latch_data3;         // latch_data3 is used by the MAC3 
                                     //    block to store3 read data 
                                     //    if CSTE3 > 0
  wire           smc_idle3;           // idle3 state

// Address Generation3

  wire [3:0]     n_be3;               // Full cycle write strobe3

// Strobe3 Generation3

  wire           r_full3;             // Full cycle write strobe3
  wire           n_r_read3;           // Store3 RW srate3 for multiple accesses
  wire           n_r_wr3;             // write strobe3
  wire [3:0]     n_r_we3;             // write enable  
  wire      r_cs3;       // registered chip3 select3 

   //apb3
   

   wire n_sys_reset3;                        //AHB3 system reset(active low3)

// assign a default value to the signal3 if the bank3 has
// been disabled and the APB3 has been excluded3 (i.e. the config signals3
// come3 from the top level
   
   smc_apb_lite_if3 i_apb_lite3 (
                     //Inputs3
                     
                     .n_preset3(n_preset3),
                     .pclk3(pclk3),
                     .psel3(psel3),
                     .penable3(penable3),
                     .pwrite3(pwrite3),
                     .paddr3(paddr3),
                     .pwdata3(pwdata3),
                     
                    //Outputs3
                     
                     .prdata3(prdata3)
                     
                     );
   
   smc_ahb_lite_if3 i_ahb_lite3  (
                     //Inputs3
                     
		     .hclk3 (hclk3),
                     .n_sys_reset3 (n_sys_reset3),
                     .haddr3 (haddr3),
                     .hsel3 (hsel3),                                                
                     .htrans3 (htrans3),                    
                     .hwrite3 (hwrite3),
                     .hsize3 (hsize3),                
                     .hwdata3 (hwdata3),
                     .hready3 (hready3),
                     .read_data3 (read_data3),
                     .mac_done3 (mac_done3),
                     .smc_done3 (smc_done3),
                     .smc_idle3 (smc_idle3),
                     
                     // Outputs3
                     
                     .xfer_size3 (xfer_size3),
                     .n_read3 (n_read3),
                     .new_access3 (new_access3),
                     .addr (addr),
                     .smc_hrdata3 (smc_hrdata3), 
                     .smc_hready3 (smc_hready3),
                     .smc_hresp3 (smc_hresp3),
                     .smc_valid3 (smc_valid3),
                     .cs (cs),
                     .write_data3 (write_data3)
                     );
   
   

   
   
   smc_counter_lite3 i_counter_lite3 (
                          
                          // Inputs3
                          
                          .sys_clk3 (hclk3),
                          .n_sys_reset3 (n_sys_reset3),
                          .valid_access3 (valid_access3),
                          .mac_done3 (mac_done3),
                          .smc_done3 (smc_done3),
                          .cste_enable3 (cste_enable3),
                          .ws_enable3 (ws_enable3),
                          .le_enable3 (le_enable3),
                          
                          // Outputs3
                          
                          .r_csle_store3 (r_csle_store3),
                          .r_csle_count3 (r_csle_count3),
                          .r_wele_count3 (r_wele_count3),
                          .r_ws_count3 (r_ws_count3),
                          .r_ws_store3 (r_ws_store3),
                          .r_oete_store3 (r_oete_store3),
                          .r_wete_store3 (r_wete_store3),
                          .r_wele_store3 (r_wele_store3),
                          .r_cste_count3 (r_cste_count3));
   
   
   smc_mac_lite3 i_mac_lite3         (
                          
                          // Inputs3
                          
                          .sys_clk3 (hclk3),
                          .n_sys_reset3 (n_sys_reset3),
                          .valid_access3 (valid_access3),
                          .xfer_size3 (xfer_size3),
                          .smc_done3 (smc_done3),
                          .data_smc3 (data_smc3),
                          .write_data3 (write_data3),
                          .smc_nextstate3 (smc_nextstate3),
                          .latch_data3 (latch_data3),
                          
                          // Outputs3
                          
                          .r_num_access3 (r_num_access3),
                          .mac_done3 (mac_done3),
                          .v_bus_size3 (v_bus_size3),
                          .v_xfer_size3 (v_xfer_size3),
                          .read_data3 (read_data3),
                          .smc_data3 (smc_data3));
   
   
   smc_state_lite3 i_state_lite3     (
                          
                          // Inputs3
                          
                          .sys_clk3 (hclk3),
                          .n_sys_reset3 (n_sys_reset3),
                          .new_access3 (new_access3),
                          .r_cste_count3 (r_cste_count3),
                          .r_csle_count3 (r_csle_count3),
                          .r_ws_count3 (r_ws_count3),
                          .mac_done3 (mac_done3),
                          .n_read3 (n_read3),
                          .n_r_read3 (n_r_read3),
                          .r_csle_store3 (r_csle_store3),
                          .r_oete_store3 (r_oete_store3),
                          .cs(cs),
                          .r_cs3(r_cs3),

                          // Outputs3
                          
                          .r_smc_currentstate3 (r_smc_currentstate3),
                          .smc_nextstate3 (smc_nextstate3),
                          .cste_enable3 (cste_enable3),
                          .ws_enable3 (ws_enable3),
                          .smc_done3 (smc_done3),
                          .valid_access3 (valid_access3),
                          .le_enable3 (le_enable3),
                          .latch_data3 (latch_data3),
                          .smc_idle3 (smc_idle3));
   
   smc_strobe_lite3 i_strobe_lite3   (

                          //inputs3

                          .sys_clk3 (hclk3),
                          .n_sys_reset3 (n_sys_reset3),
                          .valid_access3 (valid_access3),
                          .n_read3 (n_read3),
                          .cs(cs),
                          .r_smc_currentstate3 (r_smc_currentstate3),
                          .smc_nextstate3 (smc_nextstate3),
                          .n_be3 (n_be3),
                          .r_wele_store3 (r_wele_store3),
                          .r_wele_count3 (r_wele_count3),
                          .r_wete_store3 (r_wete_store3),
                          .r_oete_store3 (r_oete_store3),
                          .r_ws_count3 (r_ws_count3),
                          .r_ws_store3 (r_ws_store3),
                          .smc_done3 (smc_done3),
                          .mac_done3 (mac_done3),
                          
                          //outputs3

                          .smc_n_rd3 (smc_n_rd3),
                          .smc_n_ext_oe3 (smc_n_ext_oe3),
                          .smc_busy3 (smc_busy3),
                          .n_r_read3 (n_r_read3),
                          .r_cs3(r_cs3),
                          .r_full3 (r_full3),
                          .n_r_we3 (n_r_we3),
                          .n_r_wr3 (n_r_wr3));
   
   smc_wr_enable_lite3 i_wr_enable_lite3 (

                            //inputs3

                          .n_sys_reset3 (n_sys_reset3),
                          .r_full3(r_full3),
                          .n_r_we3(n_r_we3),
                          .n_r_wr3 (n_r_wr3),
                              
                          //output                

                          .smc_n_we3(smc_n_we3),
                          .smc_n_wr3 (smc_n_wr3));
   
   
   
   smc_addr_lite3 i_add_lite3        (
                          //inputs3

                          .sys_clk3 (hclk3),
                          .n_sys_reset3 (n_sys_reset3),
                          .valid_access3 (valid_access3),
                          .r_num_access3 (r_num_access3),
                          .v_bus_size3 (v_bus_size3),
                          .v_xfer_size3 (v_xfer_size3),
                          .cs (cs),
                          .addr (addr),
                          .smc_done3 (smc_done3),
                          .smc_nextstate3 (smc_nextstate3),
                          
                          //outputs3

                          .smc_addr3 (smc_addr3),
                          .smc_n_be3 (smc_n_be3),
                          .smc_n_cs3 (smc_n_cs3),
                          .n_be3 (n_be3));
   
   
endmodule
