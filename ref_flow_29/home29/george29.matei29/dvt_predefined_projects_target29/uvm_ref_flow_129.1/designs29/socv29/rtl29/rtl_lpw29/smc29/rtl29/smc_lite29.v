//File29 name   : smc_lite29.v
//Title29       : SMC29 top level
//Created29     : 1999
//Description29 : 
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

//static memory controller29
module          smc_lite29(
                    //apb29 inputs29
                    n_preset29, 
                    pclk29, 
                    psel29, 
                    penable29, 
                    pwrite29, 
                    paddr29, 
                    pwdata29,
                    //ahb29 inputs29                    
                    hclk29,
                    n_sys_reset29,
                    haddr29,
                    htrans29,
                    hsel29,
                    hwrite29,
                    hsize29,
                    hwdata29,
                    hready29,
                    data_smc29,
                    

                    //test signal29 inputs29

                    scan_in_129,
                    scan_in_229,
                    scan_in_329,
                    scan_en29,

                    //apb29 outputs29                    
                    prdata29,

                    //design output
                    
                    smc_hrdata29, 
                    smc_hready29,
                    smc_valid29,
                    smc_hresp29,
                    smc_addr29,
                    smc_data29, 
                    smc_n_be29,
                    smc_n_cs29,
                    smc_n_wr29,                    
                    smc_n_we29,
                    smc_n_rd29,
                    smc_n_ext_oe29,
                    smc_busy29,

                    //test signal29 output

                    scan_out_129,
                    scan_out_229,
                    scan_out_329
                   );
// define parameters29
// change using defaparam29 statements29


  // APB29 Inputs29 (use is optional29 on INCLUDE_APB29)
  input        n_preset29;           // APBreset29 
  input        pclk29;               // APB29 clock29
  input        psel29;               // APB29 select29
  input        penable29;            // APB29 enable 
  input        pwrite29;             // APB29 write strobe29 
  input [4:0]  paddr29;              // APB29 address bus
  input [31:0] pwdata29;             // APB29 write data 

  // APB29 Output29 (use is optional29 on INCLUDE_APB29)

  output [31:0] prdata29;        //APB29 output



//System29 I29/O29

  input                    hclk29;          // AHB29 System29 clock29
  input                    n_sys_reset29;   // AHB29 System29 reset (Active29 LOW29)

//AHB29 I29/O29

  input  [31:0]            haddr29;         // AHB29 Address
  input  [1:0]             htrans29;        // AHB29 transfer29 type
  input               hsel29;          // chip29 selects29
  input                    hwrite29;        // AHB29 read/write indication29
  input  [2:0]             hsize29;         // AHB29 transfer29 size
  input  [31:0]            hwdata29;        // AHB29 write data
  input                    hready29;        // AHB29 Muxed29 ready signal29

  
  output [31:0]            smc_hrdata29;    // smc29 read data back to AHB29 master29
  output                   smc_hready29;    // smc29 ready signal29
  output [1:0]             smc_hresp29;     // AHB29 Response29 signal29
  output                   smc_valid29;     // Ack29 valid address

//External29 memory interface (EMI29)

  output [31:0]            smc_addr29;      // External29 Memory (EMI29) address
  output [31:0]            smc_data29;      // EMI29 write data
  input  [31:0]            data_smc29;      // EMI29 read data
  output [3:0]             smc_n_be29;      // EMI29 byte enables29 (Active29 LOW29)
  output             smc_n_cs29;      // EMI29 Chip29 Selects29 (Active29 LOW29)
  output [3:0]             smc_n_we29;      // EMI29 write strobes29 (Active29 LOW29)
  output                   smc_n_wr29;      // EMI29 write enable (Active29 LOW29)
  output                   smc_n_rd29;      // EMI29 read stobe29 (Active29 LOW29)
  output 	           smc_n_ext_oe29;  // EMI29 write data output enable

//AHB29 Memory Interface29 Control29

   output                   smc_busy29;      // smc29 busy

   
   


//scan29 signals29

   input                  scan_in_129;        //scan29 input
   input                  scan_in_229;        //scan29 input
   input                  scan_en29;         //scan29 enable
   output                 scan_out_129;       //scan29 output
   output                 scan_out_229;       //scan29 output
// third29 scan29 chain29 only used on INCLUDE_APB29
   input                  scan_in_329;        //scan29 input
   output                 scan_out_329;       //scan29 output
   
//----------------------------------------------------------------------
// Signal29 declarations29
//----------------------------------------------------------------------

// Bus29 Interface29
   
  wire  [31:0]   smc_hrdata29;         //smc29 read data back to AHB29 master29
  wire           smc_hready29;         //smc29 ready signal29
  wire  [1:0]    smc_hresp29;          //AHB29 Response29 signal29
  wire           smc_valid29;          //Ack29 valid address

// MAC29

  wire [31:0]    smc_data29;           //Data to external29 bus via MUX29

// Strobe29 Generation29

  wire           smc_n_wr29;           //EMI29 write enable (Active29 LOW29)
  wire  [3:0]    smc_n_we29;           //EMI29 write strobes29 (Active29 LOW29)
  wire           smc_n_rd29;           //EMI29 read stobe29 (Active29 LOW29)
  wire           smc_busy29;           //smc29 busy
  wire           smc_n_ext_oe29;       //Enable29 External29 bus drivers29.(CS29 & !RD29)

// Address Generation29

  wire [31:0]    smc_addr29;           //External29 Memory Interface29(EMI29) address
  wire [3:0]     smc_n_be29;   //EMI29 byte enables29 (Active29 LOW29)
  wire      smc_n_cs29;   //EMI29 Chip29 Selects29 (Active29 LOW29)

// Bus29 Interface29

  wire           new_access29;         // New29 AHB29 access to smc29 detected
  wire [31:0]    addr;               // Copy29 of address
  wire [31:0]    write_data29;         // Data to External29 Bus29
  wire      cs;         // Chip29(bank29) Select29 Lines29
  wire [1:0]     xfer_size29;          // Width29 of current transfer29
  wire           n_read29;             // Active29 low29 read signal29                   
  
// Configuration29 Block


// Counters29

  wire [1:0]     r_csle_count29;       // Chip29 select29 LE29 counter
  wire [1:0]     r_wele_count29;       // Write counter
  wire [1:0]     r_cste_count29;       // chip29 select29 TE29 counter
  wire [7:0]     r_ws_count29; // Wait29 state select29 counter
  
// These29 strobes29 finish early29 so no counter is required29. The stored29 value
// is compared with WS29 counter to determine29 when the strobe29 should end.

  wire [1:0]     r_wete_store29;       // Write strobe29 TE29 end time before CS29
  wire [1:0]     r_oete_store29;       // Read strobe29 TE29 end time before CS29
  
// The following29 four29 wireisrers29 are used to store29 the configuration during
// mulitple29 accesses. The counters29 are reloaded29 from these29 wireisters29
//  before each cycle.

  wire [1:0]     r_csle_store29;       // Chip29 select29 LE29 store29
  wire [1:0]     r_wele_store29;       // Write strobe29 LE29 store29
  wire [7:0]     r_ws_store29;         // Wait29 state store29
  wire [1:0]     r_cste_store29;       // Chip29 Select29 TE29 delay (Bus29 float29 time)


// Multiple29 access control29

  wire           mac_done29;           // Indicates29 last cycle of last access
  wire [1:0]     r_num_access29;       // Access counter
  wire [1:0]     v_xfer_size29;        // Store29 size for MAC29 
  wire [1:0]     v_bus_size29;         // Store29 size for MAC29
  wire [31:0]    read_data29;          // Data path to bus IF
  wire [31:0]    r_read_data29;        // Internal data store29

// smc29 state machine29


  wire           valid_access29;       // New29 acces29 can proceed
  wire   [4:0]   smc_nextstate29;      // state machine29 (async29 encoding29)
  wire   [4:0]   r_smc_currentstate29; // Synchronised29 smc29 state machine29
  wire           ws_enable29;          // Wait29 state counter enable
  wire           cste_enable29;        // Chip29 select29 counter enable
  wire           smc_done29;           // Asserted29 during last cycle of
                                     //    an access
  wire           le_enable29;          // Start29 counters29 after STORED29 
                                     //    access
  wire           latch_data29;         // latch_data29 is used by the MAC29 
                                     //    block to store29 read data 
                                     //    if CSTE29 > 0
  wire           smc_idle29;           // idle29 state

// Address Generation29

  wire [3:0]     n_be29;               // Full cycle write strobe29

// Strobe29 Generation29

  wire           r_full29;             // Full cycle write strobe29
  wire           n_r_read29;           // Store29 RW srate29 for multiple accesses
  wire           n_r_wr29;             // write strobe29
  wire [3:0]     n_r_we29;             // write enable  
  wire      r_cs29;       // registered chip29 select29 

   //apb29
   

   wire n_sys_reset29;                        //AHB29 system reset(active low29)

// assign a default value to the signal29 if the bank29 has
// been disabled and the APB29 has been excluded29 (i.e. the config signals29
// come29 from the top level
   
   smc_apb_lite_if29 i_apb_lite29 (
                     //Inputs29
                     
                     .n_preset29(n_preset29),
                     .pclk29(pclk29),
                     .psel29(psel29),
                     .penable29(penable29),
                     .pwrite29(pwrite29),
                     .paddr29(paddr29),
                     .pwdata29(pwdata29),
                     
                    //Outputs29
                     
                     .prdata29(prdata29)
                     
                     );
   
   smc_ahb_lite_if29 i_ahb_lite29  (
                     //Inputs29
                     
		     .hclk29 (hclk29),
                     .n_sys_reset29 (n_sys_reset29),
                     .haddr29 (haddr29),
                     .hsel29 (hsel29),                                                
                     .htrans29 (htrans29),                    
                     .hwrite29 (hwrite29),
                     .hsize29 (hsize29),                
                     .hwdata29 (hwdata29),
                     .hready29 (hready29),
                     .read_data29 (read_data29),
                     .mac_done29 (mac_done29),
                     .smc_done29 (smc_done29),
                     .smc_idle29 (smc_idle29),
                     
                     // Outputs29
                     
                     .xfer_size29 (xfer_size29),
                     .n_read29 (n_read29),
                     .new_access29 (new_access29),
                     .addr (addr),
                     .smc_hrdata29 (smc_hrdata29), 
                     .smc_hready29 (smc_hready29),
                     .smc_hresp29 (smc_hresp29),
                     .smc_valid29 (smc_valid29),
                     .cs (cs),
                     .write_data29 (write_data29)
                     );
   
   

   
   
   smc_counter_lite29 i_counter_lite29 (
                          
                          // Inputs29
                          
                          .sys_clk29 (hclk29),
                          .n_sys_reset29 (n_sys_reset29),
                          .valid_access29 (valid_access29),
                          .mac_done29 (mac_done29),
                          .smc_done29 (smc_done29),
                          .cste_enable29 (cste_enable29),
                          .ws_enable29 (ws_enable29),
                          .le_enable29 (le_enable29),
                          
                          // Outputs29
                          
                          .r_csle_store29 (r_csle_store29),
                          .r_csle_count29 (r_csle_count29),
                          .r_wele_count29 (r_wele_count29),
                          .r_ws_count29 (r_ws_count29),
                          .r_ws_store29 (r_ws_store29),
                          .r_oete_store29 (r_oete_store29),
                          .r_wete_store29 (r_wete_store29),
                          .r_wele_store29 (r_wele_store29),
                          .r_cste_count29 (r_cste_count29));
   
   
   smc_mac_lite29 i_mac_lite29         (
                          
                          // Inputs29
                          
                          .sys_clk29 (hclk29),
                          .n_sys_reset29 (n_sys_reset29),
                          .valid_access29 (valid_access29),
                          .xfer_size29 (xfer_size29),
                          .smc_done29 (smc_done29),
                          .data_smc29 (data_smc29),
                          .write_data29 (write_data29),
                          .smc_nextstate29 (smc_nextstate29),
                          .latch_data29 (latch_data29),
                          
                          // Outputs29
                          
                          .r_num_access29 (r_num_access29),
                          .mac_done29 (mac_done29),
                          .v_bus_size29 (v_bus_size29),
                          .v_xfer_size29 (v_xfer_size29),
                          .read_data29 (read_data29),
                          .smc_data29 (smc_data29));
   
   
   smc_state_lite29 i_state_lite29     (
                          
                          // Inputs29
                          
                          .sys_clk29 (hclk29),
                          .n_sys_reset29 (n_sys_reset29),
                          .new_access29 (new_access29),
                          .r_cste_count29 (r_cste_count29),
                          .r_csle_count29 (r_csle_count29),
                          .r_ws_count29 (r_ws_count29),
                          .mac_done29 (mac_done29),
                          .n_read29 (n_read29),
                          .n_r_read29 (n_r_read29),
                          .r_csle_store29 (r_csle_store29),
                          .r_oete_store29 (r_oete_store29),
                          .cs(cs),
                          .r_cs29(r_cs29),

                          // Outputs29
                          
                          .r_smc_currentstate29 (r_smc_currentstate29),
                          .smc_nextstate29 (smc_nextstate29),
                          .cste_enable29 (cste_enable29),
                          .ws_enable29 (ws_enable29),
                          .smc_done29 (smc_done29),
                          .valid_access29 (valid_access29),
                          .le_enable29 (le_enable29),
                          .latch_data29 (latch_data29),
                          .smc_idle29 (smc_idle29));
   
   smc_strobe_lite29 i_strobe_lite29   (

                          //inputs29

                          .sys_clk29 (hclk29),
                          .n_sys_reset29 (n_sys_reset29),
                          .valid_access29 (valid_access29),
                          .n_read29 (n_read29),
                          .cs(cs),
                          .r_smc_currentstate29 (r_smc_currentstate29),
                          .smc_nextstate29 (smc_nextstate29),
                          .n_be29 (n_be29),
                          .r_wele_store29 (r_wele_store29),
                          .r_wele_count29 (r_wele_count29),
                          .r_wete_store29 (r_wete_store29),
                          .r_oete_store29 (r_oete_store29),
                          .r_ws_count29 (r_ws_count29),
                          .r_ws_store29 (r_ws_store29),
                          .smc_done29 (smc_done29),
                          .mac_done29 (mac_done29),
                          
                          //outputs29

                          .smc_n_rd29 (smc_n_rd29),
                          .smc_n_ext_oe29 (smc_n_ext_oe29),
                          .smc_busy29 (smc_busy29),
                          .n_r_read29 (n_r_read29),
                          .r_cs29(r_cs29),
                          .r_full29 (r_full29),
                          .n_r_we29 (n_r_we29),
                          .n_r_wr29 (n_r_wr29));
   
   smc_wr_enable_lite29 i_wr_enable_lite29 (

                            //inputs29

                          .n_sys_reset29 (n_sys_reset29),
                          .r_full29(r_full29),
                          .n_r_we29(n_r_we29),
                          .n_r_wr29 (n_r_wr29),
                              
                          //output                

                          .smc_n_we29(smc_n_we29),
                          .smc_n_wr29 (smc_n_wr29));
   
   
   
   smc_addr_lite29 i_add_lite29        (
                          //inputs29

                          .sys_clk29 (hclk29),
                          .n_sys_reset29 (n_sys_reset29),
                          .valid_access29 (valid_access29),
                          .r_num_access29 (r_num_access29),
                          .v_bus_size29 (v_bus_size29),
                          .v_xfer_size29 (v_xfer_size29),
                          .cs (cs),
                          .addr (addr),
                          .smc_done29 (smc_done29),
                          .smc_nextstate29 (smc_nextstate29),
                          
                          //outputs29

                          .smc_addr29 (smc_addr29),
                          .smc_n_be29 (smc_n_be29),
                          .smc_n_cs29 (smc_n_cs29),
                          .n_be29 (n_be29));
   
   
endmodule
