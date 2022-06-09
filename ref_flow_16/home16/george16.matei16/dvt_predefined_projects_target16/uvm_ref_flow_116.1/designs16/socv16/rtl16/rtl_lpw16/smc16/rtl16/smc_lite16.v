//File16 name   : smc_lite16.v
//Title16       : SMC16 top level
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

 `include "smc_defs_lite16.v"

//static memory controller16
module          smc_lite16(
                    //apb16 inputs16
                    n_preset16, 
                    pclk16, 
                    psel16, 
                    penable16, 
                    pwrite16, 
                    paddr16, 
                    pwdata16,
                    //ahb16 inputs16                    
                    hclk16,
                    n_sys_reset16,
                    haddr16,
                    htrans16,
                    hsel16,
                    hwrite16,
                    hsize16,
                    hwdata16,
                    hready16,
                    data_smc16,
                    

                    //test signal16 inputs16

                    scan_in_116,
                    scan_in_216,
                    scan_in_316,
                    scan_en16,

                    //apb16 outputs16                    
                    prdata16,

                    //design output
                    
                    smc_hrdata16, 
                    smc_hready16,
                    smc_valid16,
                    smc_hresp16,
                    smc_addr16,
                    smc_data16, 
                    smc_n_be16,
                    smc_n_cs16,
                    smc_n_wr16,                    
                    smc_n_we16,
                    smc_n_rd16,
                    smc_n_ext_oe16,
                    smc_busy16,

                    //test signal16 output

                    scan_out_116,
                    scan_out_216,
                    scan_out_316
                   );
// define parameters16
// change using defaparam16 statements16


  // APB16 Inputs16 (use is optional16 on INCLUDE_APB16)
  input        n_preset16;           // APBreset16 
  input        pclk16;               // APB16 clock16
  input        psel16;               // APB16 select16
  input        penable16;            // APB16 enable 
  input        pwrite16;             // APB16 write strobe16 
  input [4:0]  paddr16;              // APB16 address bus
  input [31:0] pwdata16;             // APB16 write data 

  // APB16 Output16 (use is optional16 on INCLUDE_APB16)

  output [31:0] prdata16;        //APB16 output



//System16 I16/O16

  input                    hclk16;          // AHB16 System16 clock16
  input                    n_sys_reset16;   // AHB16 System16 reset (Active16 LOW16)

//AHB16 I16/O16

  input  [31:0]            haddr16;         // AHB16 Address
  input  [1:0]             htrans16;        // AHB16 transfer16 type
  input               hsel16;          // chip16 selects16
  input                    hwrite16;        // AHB16 read/write indication16
  input  [2:0]             hsize16;         // AHB16 transfer16 size
  input  [31:0]            hwdata16;        // AHB16 write data
  input                    hready16;        // AHB16 Muxed16 ready signal16

  
  output [31:0]            smc_hrdata16;    // smc16 read data back to AHB16 master16
  output                   smc_hready16;    // smc16 ready signal16
  output [1:0]             smc_hresp16;     // AHB16 Response16 signal16
  output                   smc_valid16;     // Ack16 valid address

//External16 memory interface (EMI16)

  output [31:0]            smc_addr16;      // External16 Memory (EMI16) address
  output [31:0]            smc_data16;      // EMI16 write data
  input  [31:0]            data_smc16;      // EMI16 read data
  output [3:0]             smc_n_be16;      // EMI16 byte enables16 (Active16 LOW16)
  output             smc_n_cs16;      // EMI16 Chip16 Selects16 (Active16 LOW16)
  output [3:0]             smc_n_we16;      // EMI16 write strobes16 (Active16 LOW16)
  output                   smc_n_wr16;      // EMI16 write enable (Active16 LOW16)
  output                   smc_n_rd16;      // EMI16 read stobe16 (Active16 LOW16)
  output 	           smc_n_ext_oe16;  // EMI16 write data output enable

//AHB16 Memory Interface16 Control16

   output                   smc_busy16;      // smc16 busy

   
   


//scan16 signals16

   input                  scan_in_116;        //scan16 input
   input                  scan_in_216;        //scan16 input
   input                  scan_en16;         //scan16 enable
   output                 scan_out_116;       //scan16 output
   output                 scan_out_216;       //scan16 output
// third16 scan16 chain16 only used on INCLUDE_APB16
   input                  scan_in_316;        //scan16 input
   output                 scan_out_316;       //scan16 output
   
//----------------------------------------------------------------------
// Signal16 declarations16
//----------------------------------------------------------------------

// Bus16 Interface16
   
  wire  [31:0]   smc_hrdata16;         //smc16 read data back to AHB16 master16
  wire           smc_hready16;         //smc16 ready signal16
  wire  [1:0]    smc_hresp16;          //AHB16 Response16 signal16
  wire           smc_valid16;          //Ack16 valid address

// MAC16

  wire [31:0]    smc_data16;           //Data to external16 bus via MUX16

// Strobe16 Generation16

  wire           smc_n_wr16;           //EMI16 write enable (Active16 LOW16)
  wire  [3:0]    smc_n_we16;           //EMI16 write strobes16 (Active16 LOW16)
  wire           smc_n_rd16;           //EMI16 read stobe16 (Active16 LOW16)
  wire           smc_busy16;           //smc16 busy
  wire           smc_n_ext_oe16;       //Enable16 External16 bus drivers16.(CS16 & !RD16)

// Address Generation16

  wire [31:0]    smc_addr16;           //External16 Memory Interface16(EMI16) address
  wire [3:0]     smc_n_be16;   //EMI16 byte enables16 (Active16 LOW16)
  wire      smc_n_cs16;   //EMI16 Chip16 Selects16 (Active16 LOW16)

// Bus16 Interface16

  wire           new_access16;         // New16 AHB16 access to smc16 detected
  wire [31:0]    addr;               // Copy16 of address
  wire [31:0]    write_data16;         // Data to External16 Bus16
  wire      cs;         // Chip16(bank16) Select16 Lines16
  wire [1:0]     xfer_size16;          // Width16 of current transfer16
  wire           n_read16;             // Active16 low16 read signal16                   
  
// Configuration16 Block


// Counters16

  wire [1:0]     r_csle_count16;       // Chip16 select16 LE16 counter
  wire [1:0]     r_wele_count16;       // Write counter
  wire [1:0]     r_cste_count16;       // chip16 select16 TE16 counter
  wire [7:0]     r_ws_count16; // Wait16 state select16 counter
  
// These16 strobes16 finish early16 so no counter is required16. The stored16 value
// is compared with WS16 counter to determine16 when the strobe16 should end.

  wire [1:0]     r_wete_store16;       // Write strobe16 TE16 end time before CS16
  wire [1:0]     r_oete_store16;       // Read strobe16 TE16 end time before CS16
  
// The following16 four16 wireisrers16 are used to store16 the configuration during
// mulitple16 accesses. The counters16 are reloaded16 from these16 wireisters16
//  before each cycle.

  wire [1:0]     r_csle_store16;       // Chip16 select16 LE16 store16
  wire [1:0]     r_wele_store16;       // Write strobe16 LE16 store16
  wire [7:0]     r_ws_store16;         // Wait16 state store16
  wire [1:0]     r_cste_store16;       // Chip16 Select16 TE16 delay (Bus16 float16 time)


// Multiple16 access control16

  wire           mac_done16;           // Indicates16 last cycle of last access
  wire [1:0]     r_num_access16;       // Access counter
  wire [1:0]     v_xfer_size16;        // Store16 size for MAC16 
  wire [1:0]     v_bus_size16;         // Store16 size for MAC16
  wire [31:0]    read_data16;          // Data path to bus IF
  wire [31:0]    r_read_data16;        // Internal data store16

// smc16 state machine16


  wire           valid_access16;       // New16 acces16 can proceed
  wire   [4:0]   smc_nextstate16;      // state machine16 (async16 encoding16)
  wire   [4:0]   r_smc_currentstate16; // Synchronised16 smc16 state machine16
  wire           ws_enable16;          // Wait16 state counter enable
  wire           cste_enable16;        // Chip16 select16 counter enable
  wire           smc_done16;           // Asserted16 during last cycle of
                                     //    an access
  wire           le_enable16;          // Start16 counters16 after STORED16 
                                     //    access
  wire           latch_data16;         // latch_data16 is used by the MAC16 
                                     //    block to store16 read data 
                                     //    if CSTE16 > 0
  wire           smc_idle16;           // idle16 state

// Address Generation16

  wire [3:0]     n_be16;               // Full cycle write strobe16

// Strobe16 Generation16

  wire           r_full16;             // Full cycle write strobe16
  wire           n_r_read16;           // Store16 RW srate16 for multiple accesses
  wire           n_r_wr16;             // write strobe16
  wire [3:0]     n_r_we16;             // write enable  
  wire      r_cs16;       // registered chip16 select16 

   //apb16
   

   wire n_sys_reset16;                        //AHB16 system reset(active low16)

// assign a default value to the signal16 if the bank16 has
// been disabled and the APB16 has been excluded16 (i.e. the config signals16
// come16 from the top level
   
   smc_apb_lite_if16 i_apb_lite16 (
                     //Inputs16
                     
                     .n_preset16(n_preset16),
                     .pclk16(pclk16),
                     .psel16(psel16),
                     .penable16(penable16),
                     .pwrite16(pwrite16),
                     .paddr16(paddr16),
                     .pwdata16(pwdata16),
                     
                    //Outputs16
                     
                     .prdata16(prdata16)
                     
                     );
   
   smc_ahb_lite_if16 i_ahb_lite16  (
                     //Inputs16
                     
		     .hclk16 (hclk16),
                     .n_sys_reset16 (n_sys_reset16),
                     .haddr16 (haddr16),
                     .hsel16 (hsel16),                                                
                     .htrans16 (htrans16),                    
                     .hwrite16 (hwrite16),
                     .hsize16 (hsize16),                
                     .hwdata16 (hwdata16),
                     .hready16 (hready16),
                     .read_data16 (read_data16),
                     .mac_done16 (mac_done16),
                     .smc_done16 (smc_done16),
                     .smc_idle16 (smc_idle16),
                     
                     // Outputs16
                     
                     .xfer_size16 (xfer_size16),
                     .n_read16 (n_read16),
                     .new_access16 (new_access16),
                     .addr (addr),
                     .smc_hrdata16 (smc_hrdata16), 
                     .smc_hready16 (smc_hready16),
                     .smc_hresp16 (smc_hresp16),
                     .smc_valid16 (smc_valid16),
                     .cs (cs),
                     .write_data16 (write_data16)
                     );
   
   

   
   
   smc_counter_lite16 i_counter_lite16 (
                          
                          // Inputs16
                          
                          .sys_clk16 (hclk16),
                          .n_sys_reset16 (n_sys_reset16),
                          .valid_access16 (valid_access16),
                          .mac_done16 (mac_done16),
                          .smc_done16 (smc_done16),
                          .cste_enable16 (cste_enable16),
                          .ws_enable16 (ws_enable16),
                          .le_enable16 (le_enable16),
                          
                          // Outputs16
                          
                          .r_csle_store16 (r_csle_store16),
                          .r_csle_count16 (r_csle_count16),
                          .r_wele_count16 (r_wele_count16),
                          .r_ws_count16 (r_ws_count16),
                          .r_ws_store16 (r_ws_store16),
                          .r_oete_store16 (r_oete_store16),
                          .r_wete_store16 (r_wete_store16),
                          .r_wele_store16 (r_wele_store16),
                          .r_cste_count16 (r_cste_count16));
   
   
   smc_mac_lite16 i_mac_lite16         (
                          
                          // Inputs16
                          
                          .sys_clk16 (hclk16),
                          .n_sys_reset16 (n_sys_reset16),
                          .valid_access16 (valid_access16),
                          .xfer_size16 (xfer_size16),
                          .smc_done16 (smc_done16),
                          .data_smc16 (data_smc16),
                          .write_data16 (write_data16),
                          .smc_nextstate16 (smc_nextstate16),
                          .latch_data16 (latch_data16),
                          
                          // Outputs16
                          
                          .r_num_access16 (r_num_access16),
                          .mac_done16 (mac_done16),
                          .v_bus_size16 (v_bus_size16),
                          .v_xfer_size16 (v_xfer_size16),
                          .read_data16 (read_data16),
                          .smc_data16 (smc_data16));
   
   
   smc_state_lite16 i_state_lite16     (
                          
                          // Inputs16
                          
                          .sys_clk16 (hclk16),
                          .n_sys_reset16 (n_sys_reset16),
                          .new_access16 (new_access16),
                          .r_cste_count16 (r_cste_count16),
                          .r_csle_count16 (r_csle_count16),
                          .r_ws_count16 (r_ws_count16),
                          .mac_done16 (mac_done16),
                          .n_read16 (n_read16),
                          .n_r_read16 (n_r_read16),
                          .r_csle_store16 (r_csle_store16),
                          .r_oete_store16 (r_oete_store16),
                          .cs(cs),
                          .r_cs16(r_cs16),

                          // Outputs16
                          
                          .r_smc_currentstate16 (r_smc_currentstate16),
                          .smc_nextstate16 (smc_nextstate16),
                          .cste_enable16 (cste_enable16),
                          .ws_enable16 (ws_enable16),
                          .smc_done16 (smc_done16),
                          .valid_access16 (valid_access16),
                          .le_enable16 (le_enable16),
                          .latch_data16 (latch_data16),
                          .smc_idle16 (smc_idle16));
   
   smc_strobe_lite16 i_strobe_lite16   (

                          //inputs16

                          .sys_clk16 (hclk16),
                          .n_sys_reset16 (n_sys_reset16),
                          .valid_access16 (valid_access16),
                          .n_read16 (n_read16),
                          .cs(cs),
                          .r_smc_currentstate16 (r_smc_currentstate16),
                          .smc_nextstate16 (smc_nextstate16),
                          .n_be16 (n_be16),
                          .r_wele_store16 (r_wele_store16),
                          .r_wele_count16 (r_wele_count16),
                          .r_wete_store16 (r_wete_store16),
                          .r_oete_store16 (r_oete_store16),
                          .r_ws_count16 (r_ws_count16),
                          .r_ws_store16 (r_ws_store16),
                          .smc_done16 (smc_done16),
                          .mac_done16 (mac_done16),
                          
                          //outputs16

                          .smc_n_rd16 (smc_n_rd16),
                          .smc_n_ext_oe16 (smc_n_ext_oe16),
                          .smc_busy16 (smc_busy16),
                          .n_r_read16 (n_r_read16),
                          .r_cs16(r_cs16),
                          .r_full16 (r_full16),
                          .n_r_we16 (n_r_we16),
                          .n_r_wr16 (n_r_wr16));
   
   smc_wr_enable_lite16 i_wr_enable_lite16 (

                            //inputs16

                          .n_sys_reset16 (n_sys_reset16),
                          .r_full16(r_full16),
                          .n_r_we16(n_r_we16),
                          .n_r_wr16 (n_r_wr16),
                              
                          //output                

                          .smc_n_we16(smc_n_we16),
                          .smc_n_wr16 (smc_n_wr16));
   
   
   
   smc_addr_lite16 i_add_lite16        (
                          //inputs16

                          .sys_clk16 (hclk16),
                          .n_sys_reset16 (n_sys_reset16),
                          .valid_access16 (valid_access16),
                          .r_num_access16 (r_num_access16),
                          .v_bus_size16 (v_bus_size16),
                          .v_xfer_size16 (v_xfer_size16),
                          .cs (cs),
                          .addr (addr),
                          .smc_done16 (smc_done16),
                          .smc_nextstate16 (smc_nextstate16),
                          
                          //outputs16

                          .smc_addr16 (smc_addr16),
                          .smc_n_be16 (smc_n_be16),
                          .smc_n_cs16 (smc_n_cs16),
                          .n_be16 (n_be16));
   
   
endmodule
