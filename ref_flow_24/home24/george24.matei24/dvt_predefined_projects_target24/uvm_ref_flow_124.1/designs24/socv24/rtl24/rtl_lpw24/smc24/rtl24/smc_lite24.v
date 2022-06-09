//File24 name   : smc_lite24.v
//Title24       : SMC24 top level
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

 `include "smc_defs_lite24.v"

//static memory controller24
module          smc_lite24(
                    //apb24 inputs24
                    n_preset24, 
                    pclk24, 
                    psel24, 
                    penable24, 
                    pwrite24, 
                    paddr24, 
                    pwdata24,
                    //ahb24 inputs24                    
                    hclk24,
                    n_sys_reset24,
                    haddr24,
                    htrans24,
                    hsel24,
                    hwrite24,
                    hsize24,
                    hwdata24,
                    hready24,
                    data_smc24,
                    

                    //test signal24 inputs24

                    scan_in_124,
                    scan_in_224,
                    scan_in_324,
                    scan_en24,

                    //apb24 outputs24                    
                    prdata24,

                    //design output
                    
                    smc_hrdata24, 
                    smc_hready24,
                    smc_valid24,
                    smc_hresp24,
                    smc_addr24,
                    smc_data24, 
                    smc_n_be24,
                    smc_n_cs24,
                    smc_n_wr24,                    
                    smc_n_we24,
                    smc_n_rd24,
                    smc_n_ext_oe24,
                    smc_busy24,

                    //test signal24 output

                    scan_out_124,
                    scan_out_224,
                    scan_out_324
                   );
// define parameters24
// change using defaparam24 statements24


  // APB24 Inputs24 (use is optional24 on INCLUDE_APB24)
  input        n_preset24;           // APBreset24 
  input        pclk24;               // APB24 clock24
  input        psel24;               // APB24 select24
  input        penable24;            // APB24 enable 
  input        pwrite24;             // APB24 write strobe24 
  input [4:0]  paddr24;              // APB24 address bus
  input [31:0] pwdata24;             // APB24 write data 

  // APB24 Output24 (use is optional24 on INCLUDE_APB24)

  output [31:0] prdata24;        //APB24 output



//System24 I24/O24

  input                    hclk24;          // AHB24 System24 clock24
  input                    n_sys_reset24;   // AHB24 System24 reset (Active24 LOW24)

//AHB24 I24/O24

  input  [31:0]            haddr24;         // AHB24 Address
  input  [1:0]             htrans24;        // AHB24 transfer24 type
  input               hsel24;          // chip24 selects24
  input                    hwrite24;        // AHB24 read/write indication24
  input  [2:0]             hsize24;         // AHB24 transfer24 size
  input  [31:0]            hwdata24;        // AHB24 write data
  input                    hready24;        // AHB24 Muxed24 ready signal24

  
  output [31:0]            smc_hrdata24;    // smc24 read data back to AHB24 master24
  output                   smc_hready24;    // smc24 ready signal24
  output [1:0]             smc_hresp24;     // AHB24 Response24 signal24
  output                   smc_valid24;     // Ack24 valid address

//External24 memory interface (EMI24)

  output [31:0]            smc_addr24;      // External24 Memory (EMI24) address
  output [31:0]            smc_data24;      // EMI24 write data
  input  [31:0]            data_smc24;      // EMI24 read data
  output [3:0]             smc_n_be24;      // EMI24 byte enables24 (Active24 LOW24)
  output             smc_n_cs24;      // EMI24 Chip24 Selects24 (Active24 LOW24)
  output [3:0]             smc_n_we24;      // EMI24 write strobes24 (Active24 LOW24)
  output                   smc_n_wr24;      // EMI24 write enable (Active24 LOW24)
  output                   smc_n_rd24;      // EMI24 read stobe24 (Active24 LOW24)
  output 	           smc_n_ext_oe24;  // EMI24 write data output enable

//AHB24 Memory Interface24 Control24

   output                   smc_busy24;      // smc24 busy

   
   


//scan24 signals24

   input                  scan_in_124;        //scan24 input
   input                  scan_in_224;        //scan24 input
   input                  scan_en24;         //scan24 enable
   output                 scan_out_124;       //scan24 output
   output                 scan_out_224;       //scan24 output
// third24 scan24 chain24 only used on INCLUDE_APB24
   input                  scan_in_324;        //scan24 input
   output                 scan_out_324;       //scan24 output
   
//----------------------------------------------------------------------
// Signal24 declarations24
//----------------------------------------------------------------------

// Bus24 Interface24
   
  wire  [31:0]   smc_hrdata24;         //smc24 read data back to AHB24 master24
  wire           smc_hready24;         //smc24 ready signal24
  wire  [1:0]    smc_hresp24;          //AHB24 Response24 signal24
  wire           smc_valid24;          //Ack24 valid address

// MAC24

  wire [31:0]    smc_data24;           //Data to external24 bus via MUX24

// Strobe24 Generation24

  wire           smc_n_wr24;           //EMI24 write enable (Active24 LOW24)
  wire  [3:0]    smc_n_we24;           //EMI24 write strobes24 (Active24 LOW24)
  wire           smc_n_rd24;           //EMI24 read stobe24 (Active24 LOW24)
  wire           smc_busy24;           //smc24 busy
  wire           smc_n_ext_oe24;       //Enable24 External24 bus drivers24.(CS24 & !RD24)

// Address Generation24

  wire [31:0]    smc_addr24;           //External24 Memory Interface24(EMI24) address
  wire [3:0]     smc_n_be24;   //EMI24 byte enables24 (Active24 LOW24)
  wire      smc_n_cs24;   //EMI24 Chip24 Selects24 (Active24 LOW24)

// Bus24 Interface24

  wire           new_access24;         // New24 AHB24 access to smc24 detected
  wire [31:0]    addr;               // Copy24 of address
  wire [31:0]    write_data24;         // Data to External24 Bus24
  wire      cs;         // Chip24(bank24) Select24 Lines24
  wire [1:0]     xfer_size24;          // Width24 of current transfer24
  wire           n_read24;             // Active24 low24 read signal24                   
  
// Configuration24 Block


// Counters24

  wire [1:0]     r_csle_count24;       // Chip24 select24 LE24 counter
  wire [1:0]     r_wele_count24;       // Write counter
  wire [1:0]     r_cste_count24;       // chip24 select24 TE24 counter
  wire [7:0]     r_ws_count24; // Wait24 state select24 counter
  
// These24 strobes24 finish early24 so no counter is required24. The stored24 value
// is compared with WS24 counter to determine24 when the strobe24 should end.

  wire [1:0]     r_wete_store24;       // Write strobe24 TE24 end time before CS24
  wire [1:0]     r_oete_store24;       // Read strobe24 TE24 end time before CS24
  
// The following24 four24 wireisrers24 are used to store24 the configuration during
// mulitple24 accesses. The counters24 are reloaded24 from these24 wireisters24
//  before each cycle.

  wire [1:0]     r_csle_store24;       // Chip24 select24 LE24 store24
  wire [1:0]     r_wele_store24;       // Write strobe24 LE24 store24
  wire [7:0]     r_ws_store24;         // Wait24 state store24
  wire [1:0]     r_cste_store24;       // Chip24 Select24 TE24 delay (Bus24 float24 time)


// Multiple24 access control24

  wire           mac_done24;           // Indicates24 last cycle of last access
  wire [1:0]     r_num_access24;       // Access counter
  wire [1:0]     v_xfer_size24;        // Store24 size for MAC24 
  wire [1:0]     v_bus_size24;         // Store24 size for MAC24
  wire [31:0]    read_data24;          // Data path to bus IF
  wire [31:0]    r_read_data24;        // Internal data store24

// smc24 state machine24


  wire           valid_access24;       // New24 acces24 can proceed
  wire   [4:0]   smc_nextstate24;      // state machine24 (async24 encoding24)
  wire   [4:0]   r_smc_currentstate24; // Synchronised24 smc24 state machine24
  wire           ws_enable24;          // Wait24 state counter enable
  wire           cste_enable24;        // Chip24 select24 counter enable
  wire           smc_done24;           // Asserted24 during last cycle of
                                     //    an access
  wire           le_enable24;          // Start24 counters24 after STORED24 
                                     //    access
  wire           latch_data24;         // latch_data24 is used by the MAC24 
                                     //    block to store24 read data 
                                     //    if CSTE24 > 0
  wire           smc_idle24;           // idle24 state

// Address Generation24

  wire [3:0]     n_be24;               // Full cycle write strobe24

// Strobe24 Generation24

  wire           r_full24;             // Full cycle write strobe24
  wire           n_r_read24;           // Store24 RW srate24 for multiple accesses
  wire           n_r_wr24;             // write strobe24
  wire [3:0]     n_r_we24;             // write enable  
  wire      r_cs24;       // registered chip24 select24 

   //apb24
   

   wire n_sys_reset24;                        //AHB24 system reset(active low24)

// assign a default value to the signal24 if the bank24 has
// been disabled and the APB24 has been excluded24 (i.e. the config signals24
// come24 from the top level
   
   smc_apb_lite_if24 i_apb_lite24 (
                     //Inputs24
                     
                     .n_preset24(n_preset24),
                     .pclk24(pclk24),
                     .psel24(psel24),
                     .penable24(penable24),
                     .pwrite24(pwrite24),
                     .paddr24(paddr24),
                     .pwdata24(pwdata24),
                     
                    //Outputs24
                     
                     .prdata24(prdata24)
                     
                     );
   
   smc_ahb_lite_if24 i_ahb_lite24  (
                     //Inputs24
                     
		     .hclk24 (hclk24),
                     .n_sys_reset24 (n_sys_reset24),
                     .haddr24 (haddr24),
                     .hsel24 (hsel24),                                                
                     .htrans24 (htrans24),                    
                     .hwrite24 (hwrite24),
                     .hsize24 (hsize24),                
                     .hwdata24 (hwdata24),
                     .hready24 (hready24),
                     .read_data24 (read_data24),
                     .mac_done24 (mac_done24),
                     .smc_done24 (smc_done24),
                     .smc_idle24 (smc_idle24),
                     
                     // Outputs24
                     
                     .xfer_size24 (xfer_size24),
                     .n_read24 (n_read24),
                     .new_access24 (new_access24),
                     .addr (addr),
                     .smc_hrdata24 (smc_hrdata24), 
                     .smc_hready24 (smc_hready24),
                     .smc_hresp24 (smc_hresp24),
                     .smc_valid24 (smc_valid24),
                     .cs (cs),
                     .write_data24 (write_data24)
                     );
   
   

   
   
   smc_counter_lite24 i_counter_lite24 (
                          
                          // Inputs24
                          
                          .sys_clk24 (hclk24),
                          .n_sys_reset24 (n_sys_reset24),
                          .valid_access24 (valid_access24),
                          .mac_done24 (mac_done24),
                          .smc_done24 (smc_done24),
                          .cste_enable24 (cste_enable24),
                          .ws_enable24 (ws_enable24),
                          .le_enable24 (le_enable24),
                          
                          // Outputs24
                          
                          .r_csle_store24 (r_csle_store24),
                          .r_csle_count24 (r_csle_count24),
                          .r_wele_count24 (r_wele_count24),
                          .r_ws_count24 (r_ws_count24),
                          .r_ws_store24 (r_ws_store24),
                          .r_oete_store24 (r_oete_store24),
                          .r_wete_store24 (r_wete_store24),
                          .r_wele_store24 (r_wele_store24),
                          .r_cste_count24 (r_cste_count24));
   
   
   smc_mac_lite24 i_mac_lite24         (
                          
                          // Inputs24
                          
                          .sys_clk24 (hclk24),
                          .n_sys_reset24 (n_sys_reset24),
                          .valid_access24 (valid_access24),
                          .xfer_size24 (xfer_size24),
                          .smc_done24 (smc_done24),
                          .data_smc24 (data_smc24),
                          .write_data24 (write_data24),
                          .smc_nextstate24 (smc_nextstate24),
                          .latch_data24 (latch_data24),
                          
                          // Outputs24
                          
                          .r_num_access24 (r_num_access24),
                          .mac_done24 (mac_done24),
                          .v_bus_size24 (v_bus_size24),
                          .v_xfer_size24 (v_xfer_size24),
                          .read_data24 (read_data24),
                          .smc_data24 (smc_data24));
   
   
   smc_state_lite24 i_state_lite24     (
                          
                          // Inputs24
                          
                          .sys_clk24 (hclk24),
                          .n_sys_reset24 (n_sys_reset24),
                          .new_access24 (new_access24),
                          .r_cste_count24 (r_cste_count24),
                          .r_csle_count24 (r_csle_count24),
                          .r_ws_count24 (r_ws_count24),
                          .mac_done24 (mac_done24),
                          .n_read24 (n_read24),
                          .n_r_read24 (n_r_read24),
                          .r_csle_store24 (r_csle_store24),
                          .r_oete_store24 (r_oete_store24),
                          .cs(cs),
                          .r_cs24(r_cs24),

                          // Outputs24
                          
                          .r_smc_currentstate24 (r_smc_currentstate24),
                          .smc_nextstate24 (smc_nextstate24),
                          .cste_enable24 (cste_enable24),
                          .ws_enable24 (ws_enable24),
                          .smc_done24 (smc_done24),
                          .valid_access24 (valid_access24),
                          .le_enable24 (le_enable24),
                          .latch_data24 (latch_data24),
                          .smc_idle24 (smc_idle24));
   
   smc_strobe_lite24 i_strobe_lite24   (

                          //inputs24

                          .sys_clk24 (hclk24),
                          .n_sys_reset24 (n_sys_reset24),
                          .valid_access24 (valid_access24),
                          .n_read24 (n_read24),
                          .cs(cs),
                          .r_smc_currentstate24 (r_smc_currentstate24),
                          .smc_nextstate24 (smc_nextstate24),
                          .n_be24 (n_be24),
                          .r_wele_store24 (r_wele_store24),
                          .r_wele_count24 (r_wele_count24),
                          .r_wete_store24 (r_wete_store24),
                          .r_oete_store24 (r_oete_store24),
                          .r_ws_count24 (r_ws_count24),
                          .r_ws_store24 (r_ws_store24),
                          .smc_done24 (smc_done24),
                          .mac_done24 (mac_done24),
                          
                          //outputs24

                          .smc_n_rd24 (smc_n_rd24),
                          .smc_n_ext_oe24 (smc_n_ext_oe24),
                          .smc_busy24 (smc_busy24),
                          .n_r_read24 (n_r_read24),
                          .r_cs24(r_cs24),
                          .r_full24 (r_full24),
                          .n_r_we24 (n_r_we24),
                          .n_r_wr24 (n_r_wr24));
   
   smc_wr_enable_lite24 i_wr_enable_lite24 (

                            //inputs24

                          .n_sys_reset24 (n_sys_reset24),
                          .r_full24(r_full24),
                          .n_r_we24(n_r_we24),
                          .n_r_wr24 (n_r_wr24),
                              
                          //output                

                          .smc_n_we24(smc_n_we24),
                          .smc_n_wr24 (smc_n_wr24));
   
   
   
   smc_addr_lite24 i_add_lite24        (
                          //inputs24

                          .sys_clk24 (hclk24),
                          .n_sys_reset24 (n_sys_reset24),
                          .valid_access24 (valid_access24),
                          .r_num_access24 (r_num_access24),
                          .v_bus_size24 (v_bus_size24),
                          .v_xfer_size24 (v_xfer_size24),
                          .cs (cs),
                          .addr (addr),
                          .smc_done24 (smc_done24),
                          .smc_nextstate24 (smc_nextstate24),
                          
                          //outputs24

                          .smc_addr24 (smc_addr24),
                          .smc_n_be24 (smc_n_be24),
                          .smc_n_cs24 (smc_n_cs24),
                          .n_be24 (n_be24));
   
   
endmodule
