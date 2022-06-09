//File12 name   : smc_lite12.v
//Title12       : SMC12 top level
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

 `include "smc_defs_lite12.v"

//static memory controller12
module          smc_lite12(
                    //apb12 inputs12
                    n_preset12, 
                    pclk12, 
                    psel12, 
                    penable12, 
                    pwrite12, 
                    paddr12, 
                    pwdata12,
                    //ahb12 inputs12                    
                    hclk12,
                    n_sys_reset12,
                    haddr12,
                    htrans12,
                    hsel12,
                    hwrite12,
                    hsize12,
                    hwdata12,
                    hready12,
                    data_smc12,
                    

                    //test signal12 inputs12

                    scan_in_112,
                    scan_in_212,
                    scan_in_312,
                    scan_en12,

                    //apb12 outputs12                    
                    prdata12,

                    //design output
                    
                    smc_hrdata12, 
                    smc_hready12,
                    smc_valid12,
                    smc_hresp12,
                    smc_addr12,
                    smc_data12, 
                    smc_n_be12,
                    smc_n_cs12,
                    smc_n_wr12,                    
                    smc_n_we12,
                    smc_n_rd12,
                    smc_n_ext_oe12,
                    smc_busy12,

                    //test signal12 output

                    scan_out_112,
                    scan_out_212,
                    scan_out_312
                   );
// define parameters12
// change using defaparam12 statements12


  // APB12 Inputs12 (use is optional12 on INCLUDE_APB12)
  input        n_preset12;           // APBreset12 
  input        pclk12;               // APB12 clock12
  input        psel12;               // APB12 select12
  input        penable12;            // APB12 enable 
  input        pwrite12;             // APB12 write strobe12 
  input [4:0]  paddr12;              // APB12 address bus
  input [31:0] pwdata12;             // APB12 write data 

  // APB12 Output12 (use is optional12 on INCLUDE_APB12)

  output [31:0] prdata12;        //APB12 output



//System12 I12/O12

  input                    hclk12;          // AHB12 System12 clock12
  input                    n_sys_reset12;   // AHB12 System12 reset (Active12 LOW12)

//AHB12 I12/O12

  input  [31:0]            haddr12;         // AHB12 Address
  input  [1:0]             htrans12;        // AHB12 transfer12 type
  input               hsel12;          // chip12 selects12
  input                    hwrite12;        // AHB12 read/write indication12
  input  [2:0]             hsize12;         // AHB12 transfer12 size
  input  [31:0]            hwdata12;        // AHB12 write data
  input                    hready12;        // AHB12 Muxed12 ready signal12

  
  output [31:0]            smc_hrdata12;    // smc12 read data back to AHB12 master12
  output                   smc_hready12;    // smc12 ready signal12
  output [1:0]             smc_hresp12;     // AHB12 Response12 signal12
  output                   smc_valid12;     // Ack12 valid address

//External12 memory interface (EMI12)

  output [31:0]            smc_addr12;      // External12 Memory (EMI12) address
  output [31:0]            smc_data12;      // EMI12 write data
  input  [31:0]            data_smc12;      // EMI12 read data
  output [3:0]             smc_n_be12;      // EMI12 byte enables12 (Active12 LOW12)
  output             smc_n_cs12;      // EMI12 Chip12 Selects12 (Active12 LOW12)
  output [3:0]             smc_n_we12;      // EMI12 write strobes12 (Active12 LOW12)
  output                   smc_n_wr12;      // EMI12 write enable (Active12 LOW12)
  output                   smc_n_rd12;      // EMI12 read stobe12 (Active12 LOW12)
  output 	           smc_n_ext_oe12;  // EMI12 write data output enable

//AHB12 Memory Interface12 Control12

   output                   smc_busy12;      // smc12 busy

   
   


//scan12 signals12

   input                  scan_in_112;        //scan12 input
   input                  scan_in_212;        //scan12 input
   input                  scan_en12;         //scan12 enable
   output                 scan_out_112;       //scan12 output
   output                 scan_out_212;       //scan12 output
// third12 scan12 chain12 only used on INCLUDE_APB12
   input                  scan_in_312;        //scan12 input
   output                 scan_out_312;       //scan12 output
   
//----------------------------------------------------------------------
// Signal12 declarations12
//----------------------------------------------------------------------

// Bus12 Interface12
   
  wire  [31:0]   smc_hrdata12;         //smc12 read data back to AHB12 master12
  wire           smc_hready12;         //smc12 ready signal12
  wire  [1:0]    smc_hresp12;          //AHB12 Response12 signal12
  wire           smc_valid12;          //Ack12 valid address

// MAC12

  wire [31:0]    smc_data12;           //Data to external12 bus via MUX12

// Strobe12 Generation12

  wire           smc_n_wr12;           //EMI12 write enable (Active12 LOW12)
  wire  [3:0]    smc_n_we12;           //EMI12 write strobes12 (Active12 LOW12)
  wire           smc_n_rd12;           //EMI12 read stobe12 (Active12 LOW12)
  wire           smc_busy12;           //smc12 busy
  wire           smc_n_ext_oe12;       //Enable12 External12 bus drivers12.(CS12 & !RD12)

// Address Generation12

  wire [31:0]    smc_addr12;           //External12 Memory Interface12(EMI12) address
  wire [3:0]     smc_n_be12;   //EMI12 byte enables12 (Active12 LOW12)
  wire      smc_n_cs12;   //EMI12 Chip12 Selects12 (Active12 LOW12)

// Bus12 Interface12

  wire           new_access12;         // New12 AHB12 access to smc12 detected
  wire [31:0]    addr;               // Copy12 of address
  wire [31:0]    write_data12;         // Data to External12 Bus12
  wire      cs;         // Chip12(bank12) Select12 Lines12
  wire [1:0]     xfer_size12;          // Width12 of current transfer12
  wire           n_read12;             // Active12 low12 read signal12                   
  
// Configuration12 Block


// Counters12

  wire [1:0]     r_csle_count12;       // Chip12 select12 LE12 counter
  wire [1:0]     r_wele_count12;       // Write counter
  wire [1:0]     r_cste_count12;       // chip12 select12 TE12 counter
  wire [7:0]     r_ws_count12; // Wait12 state select12 counter
  
// These12 strobes12 finish early12 so no counter is required12. The stored12 value
// is compared with WS12 counter to determine12 when the strobe12 should end.

  wire [1:0]     r_wete_store12;       // Write strobe12 TE12 end time before CS12
  wire [1:0]     r_oete_store12;       // Read strobe12 TE12 end time before CS12
  
// The following12 four12 wireisrers12 are used to store12 the configuration during
// mulitple12 accesses. The counters12 are reloaded12 from these12 wireisters12
//  before each cycle.

  wire [1:0]     r_csle_store12;       // Chip12 select12 LE12 store12
  wire [1:0]     r_wele_store12;       // Write strobe12 LE12 store12
  wire [7:0]     r_ws_store12;         // Wait12 state store12
  wire [1:0]     r_cste_store12;       // Chip12 Select12 TE12 delay (Bus12 float12 time)


// Multiple12 access control12

  wire           mac_done12;           // Indicates12 last cycle of last access
  wire [1:0]     r_num_access12;       // Access counter
  wire [1:0]     v_xfer_size12;        // Store12 size for MAC12 
  wire [1:0]     v_bus_size12;         // Store12 size for MAC12
  wire [31:0]    read_data12;          // Data path to bus IF
  wire [31:0]    r_read_data12;        // Internal data store12

// smc12 state machine12


  wire           valid_access12;       // New12 acces12 can proceed
  wire   [4:0]   smc_nextstate12;      // state machine12 (async12 encoding12)
  wire   [4:0]   r_smc_currentstate12; // Synchronised12 smc12 state machine12
  wire           ws_enable12;          // Wait12 state counter enable
  wire           cste_enable12;        // Chip12 select12 counter enable
  wire           smc_done12;           // Asserted12 during last cycle of
                                     //    an access
  wire           le_enable12;          // Start12 counters12 after STORED12 
                                     //    access
  wire           latch_data12;         // latch_data12 is used by the MAC12 
                                     //    block to store12 read data 
                                     //    if CSTE12 > 0
  wire           smc_idle12;           // idle12 state

// Address Generation12

  wire [3:0]     n_be12;               // Full cycle write strobe12

// Strobe12 Generation12

  wire           r_full12;             // Full cycle write strobe12
  wire           n_r_read12;           // Store12 RW srate12 for multiple accesses
  wire           n_r_wr12;             // write strobe12
  wire [3:0]     n_r_we12;             // write enable  
  wire      r_cs12;       // registered chip12 select12 

   //apb12
   

   wire n_sys_reset12;                        //AHB12 system reset(active low12)

// assign a default value to the signal12 if the bank12 has
// been disabled and the APB12 has been excluded12 (i.e. the config signals12
// come12 from the top level
   
   smc_apb_lite_if12 i_apb_lite12 (
                     //Inputs12
                     
                     .n_preset12(n_preset12),
                     .pclk12(pclk12),
                     .psel12(psel12),
                     .penable12(penable12),
                     .pwrite12(pwrite12),
                     .paddr12(paddr12),
                     .pwdata12(pwdata12),
                     
                    //Outputs12
                     
                     .prdata12(prdata12)
                     
                     );
   
   smc_ahb_lite_if12 i_ahb_lite12  (
                     //Inputs12
                     
		     .hclk12 (hclk12),
                     .n_sys_reset12 (n_sys_reset12),
                     .haddr12 (haddr12),
                     .hsel12 (hsel12),                                                
                     .htrans12 (htrans12),                    
                     .hwrite12 (hwrite12),
                     .hsize12 (hsize12),                
                     .hwdata12 (hwdata12),
                     .hready12 (hready12),
                     .read_data12 (read_data12),
                     .mac_done12 (mac_done12),
                     .smc_done12 (smc_done12),
                     .smc_idle12 (smc_idle12),
                     
                     // Outputs12
                     
                     .xfer_size12 (xfer_size12),
                     .n_read12 (n_read12),
                     .new_access12 (new_access12),
                     .addr (addr),
                     .smc_hrdata12 (smc_hrdata12), 
                     .smc_hready12 (smc_hready12),
                     .smc_hresp12 (smc_hresp12),
                     .smc_valid12 (smc_valid12),
                     .cs (cs),
                     .write_data12 (write_data12)
                     );
   
   

   
   
   smc_counter_lite12 i_counter_lite12 (
                          
                          // Inputs12
                          
                          .sys_clk12 (hclk12),
                          .n_sys_reset12 (n_sys_reset12),
                          .valid_access12 (valid_access12),
                          .mac_done12 (mac_done12),
                          .smc_done12 (smc_done12),
                          .cste_enable12 (cste_enable12),
                          .ws_enable12 (ws_enable12),
                          .le_enable12 (le_enable12),
                          
                          // Outputs12
                          
                          .r_csle_store12 (r_csle_store12),
                          .r_csle_count12 (r_csle_count12),
                          .r_wele_count12 (r_wele_count12),
                          .r_ws_count12 (r_ws_count12),
                          .r_ws_store12 (r_ws_store12),
                          .r_oete_store12 (r_oete_store12),
                          .r_wete_store12 (r_wete_store12),
                          .r_wele_store12 (r_wele_store12),
                          .r_cste_count12 (r_cste_count12));
   
   
   smc_mac_lite12 i_mac_lite12         (
                          
                          // Inputs12
                          
                          .sys_clk12 (hclk12),
                          .n_sys_reset12 (n_sys_reset12),
                          .valid_access12 (valid_access12),
                          .xfer_size12 (xfer_size12),
                          .smc_done12 (smc_done12),
                          .data_smc12 (data_smc12),
                          .write_data12 (write_data12),
                          .smc_nextstate12 (smc_nextstate12),
                          .latch_data12 (latch_data12),
                          
                          // Outputs12
                          
                          .r_num_access12 (r_num_access12),
                          .mac_done12 (mac_done12),
                          .v_bus_size12 (v_bus_size12),
                          .v_xfer_size12 (v_xfer_size12),
                          .read_data12 (read_data12),
                          .smc_data12 (smc_data12));
   
   
   smc_state_lite12 i_state_lite12     (
                          
                          // Inputs12
                          
                          .sys_clk12 (hclk12),
                          .n_sys_reset12 (n_sys_reset12),
                          .new_access12 (new_access12),
                          .r_cste_count12 (r_cste_count12),
                          .r_csle_count12 (r_csle_count12),
                          .r_ws_count12 (r_ws_count12),
                          .mac_done12 (mac_done12),
                          .n_read12 (n_read12),
                          .n_r_read12 (n_r_read12),
                          .r_csle_store12 (r_csle_store12),
                          .r_oete_store12 (r_oete_store12),
                          .cs(cs),
                          .r_cs12(r_cs12),

                          // Outputs12
                          
                          .r_smc_currentstate12 (r_smc_currentstate12),
                          .smc_nextstate12 (smc_nextstate12),
                          .cste_enable12 (cste_enable12),
                          .ws_enable12 (ws_enable12),
                          .smc_done12 (smc_done12),
                          .valid_access12 (valid_access12),
                          .le_enable12 (le_enable12),
                          .latch_data12 (latch_data12),
                          .smc_idle12 (smc_idle12));
   
   smc_strobe_lite12 i_strobe_lite12   (

                          //inputs12

                          .sys_clk12 (hclk12),
                          .n_sys_reset12 (n_sys_reset12),
                          .valid_access12 (valid_access12),
                          .n_read12 (n_read12),
                          .cs(cs),
                          .r_smc_currentstate12 (r_smc_currentstate12),
                          .smc_nextstate12 (smc_nextstate12),
                          .n_be12 (n_be12),
                          .r_wele_store12 (r_wele_store12),
                          .r_wele_count12 (r_wele_count12),
                          .r_wete_store12 (r_wete_store12),
                          .r_oete_store12 (r_oete_store12),
                          .r_ws_count12 (r_ws_count12),
                          .r_ws_store12 (r_ws_store12),
                          .smc_done12 (smc_done12),
                          .mac_done12 (mac_done12),
                          
                          //outputs12

                          .smc_n_rd12 (smc_n_rd12),
                          .smc_n_ext_oe12 (smc_n_ext_oe12),
                          .smc_busy12 (smc_busy12),
                          .n_r_read12 (n_r_read12),
                          .r_cs12(r_cs12),
                          .r_full12 (r_full12),
                          .n_r_we12 (n_r_we12),
                          .n_r_wr12 (n_r_wr12));
   
   smc_wr_enable_lite12 i_wr_enable_lite12 (

                            //inputs12

                          .n_sys_reset12 (n_sys_reset12),
                          .r_full12(r_full12),
                          .n_r_we12(n_r_we12),
                          .n_r_wr12 (n_r_wr12),
                              
                          //output                

                          .smc_n_we12(smc_n_we12),
                          .smc_n_wr12 (smc_n_wr12));
   
   
   
   smc_addr_lite12 i_add_lite12        (
                          //inputs12

                          .sys_clk12 (hclk12),
                          .n_sys_reset12 (n_sys_reset12),
                          .valid_access12 (valid_access12),
                          .r_num_access12 (r_num_access12),
                          .v_bus_size12 (v_bus_size12),
                          .v_xfer_size12 (v_xfer_size12),
                          .cs (cs),
                          .addr (addr),
                          .smc_done12 (smc_done12),
                          .smc_nextstate12 (smc_nextstate12),
                          
                          //outputs12

                          .smc_addr12 (smc_addr12),
                          .smc_n_be12 (smc_n_be12),
                          .smc_n_cs12 (smc_n_cs12),
                          .n_be12 (n_be12));
   
   
endmodule
