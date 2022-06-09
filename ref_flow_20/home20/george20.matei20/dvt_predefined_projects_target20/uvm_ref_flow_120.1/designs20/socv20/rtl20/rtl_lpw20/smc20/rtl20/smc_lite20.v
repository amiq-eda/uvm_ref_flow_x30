//File20 name   : smc_lite20.v
//Title20       : SMC20 top level
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

 `include "smc_defs_lite20.v"

//static memory controller20
module          smc_lite20(
                    //apb20 inputs20
                    n_preset20, 
                    pclk20, 
                    psel20, 
                    penable20, 
                    pwrite20, 
                    paddr20, 
                    pwdata20,
                    //ahb20 inputs20                    
                    hclk20,
                    n_sys_reset20,
                    haddr20,
                    htrans20,
                    hsel20,
                    hwrite20,
                    hsize20,
                    hwdata20,
                    hready20,
                    data_smc20,
                    

                    //test signal20 inputs20

                    scan_in_120,
                    scan_in_220,
                    scan_in_320,
                    scan_en20,

                    //apb20 outputs20                    
                    prdata20,

                    //design output
                    
                    smc_hrdata20, 
                    smc_hready20,
                    smc_valid20,
                    smc_hresp20,
                    smc_addr20,
                    smc_data20, 
                    smc_n_be20,
                    smc_n_cs20,
                    smc_n_wr20,                    
                    smc_n_we20,
                    smc_n_rd20,
                    smc_n_ext_oe20,
                    smc_busy20,

                    //test signal20 output

                    scan_out_120,
                    scan_out_220,
                    scan_out_320
                   );
// define parameters20
// change using defaparam20 statements20


  // APB20 Inputs20 (use is optional20 on INCLUDE_APB20)
  input        n_preset20;           // APBreset20 
  input        pclk20;               // APB20 clock20
  input        psel20;               // APB20 select20
  input        penable20;            // APB20 enable 
  input        pwrite20;             // APB20 write strobe20 
  input [4:0]  paddr20;              // APB20 address bus
  input [31:0] pwdata20;             // APB20 write data 

  // APB20 Output20 (use is optional20 on INCLUDE_APB20)

  output [31:0] prdata20;        //APB20 output



//System20 I20/O20

  input                    hclk20;          // AHB20 System20 clock20
  input                    n_sys_reset20;   // AHB20 System20 reset (Active20 LOW20)

//AHB20 I20/O20

  input  [31:0]            haddr20;         // AHB20 Address
  input  [1:0]             htrans20;        // AHB20 transfer20 type
  input               hsel20;          // chip20 selects20
  input                    hwrite20;        // AHB20 read/write indication20
  input  [2:0]             hsize20;         // AHB20 transfer20 size
  input  [31:0]            hwdata20;        // AHB20 write data
  input                    hready20;        // AHB20 Muxed20 ready signal20

  
  output [31:0]            smc_hrdata20;    // smc20 read data back to AHB20 master20
  output                   smc_hready20;    // smc20 ready signal20
  output [1:0]             smc_hresp20;     // AHB20 Response20 signal20
  output                   smc_valid20;     // Ack20 valid address

//External20 memory interface (EMI20)

  output [31:0]            smc_addr20;      // External20 Memory (EMI20) address
  output [31:0]            smc_data20;      // EMI20 write data
  input  [31:0]            data_smc20;      // EMI20 read data
  output [3:0]             smc_n_be20;      // EMI20 byte enables20 (Active20 LOW20)
  output             smc_n_cs20;      // EMI20 Chip20 Selects20 (Active20 LOW20)
  output [3:0]             smc_n_we20;      // EMI20 write strobes20 (Active20 LOW20)
  output                   smc_n_wr20;      // EMI20 write enable (Active20 LOW20)
  output                   smc_n_rd20;      // EMI20 read stobe20 (Active20 LOW20)
  output 	           smc_n_ext_oe20;  // EMI20 write data output enable

//AHB20 Memory Interface20 Control20

   output                   smc_busy20;      // smc20 busy

   
   


//scan20 signals20

   input                  scan_in_120;        //scan20 input
   input                  scan_in_220;        //scan20 input
   input                  scan_en20;         //scan20 enable
   output                 scan_out_120;       //scan20 output
   output                 scan_out_220;       //scan20 output
// third20 scan20 chain20 only used on INCLUDE_APB20
   input                  scan_in_320;        //scan20 input
   output                 scan_out_320;       //scan20 output
   
//----------------------------------------------------------------------
// Signal20 declarations20
//----------------------------------------------------------------------

// Bus20 Interface20
   
  wire  [31:0]   smc_hrdata20;         //smc20 read data back to AHB20 master20
  wire           smc_hready20;         //smc20 ready signal20
  wire  [1:0]    smc_hresp20;          //AHB20 Response20 signal20
  wire           smc_valid20;          //Ack20 valid address

// MAC20

  wire [31:0]    smc_data20;           //Data to external20 bus via MUX20

// Strobe20 Generation20

  wire           smc_n_wr20;           //EMI20 write enable (Active20 LOW20)
  wire  [3:0]    smc_n_we20;           //EMI20 write strobes20 (Active20 LOW20)
  wire           smc_n_rd20;           //EMI20 read stobe20 (Active20 LOW20)
  wire           smc_busy20;           //smc20 busy
  wire           smc_n_ext_oe20;       //Enable20 External20 bus drivers20.(CS20 & !RD20)

// Address Generation20

  wire [31:0]    smc_addr20;           //External20 Memory Interface20(EMI20) address
  wire [3:0]     smc_n_be20;   //EMI20 byte enables20 (Active20 LOW20)
  wire      smc_n_cs20;   //EMI20 Chip20 Selects20 (Active20 LOW20)

// Bus20 Interface20

  wire           new_access20;         // New20 AHB20 access to smc20 detected
  wire [31:0]    addr;               // Copy20 of address
  wire [31:0]    write_data20;         // Data to External20 Bus20
  wire      cs;         // Chip20(bank20) Select20 Lines20
  wire [1:0]     xfer_size20;          // Width20 of current transfer20
  wire           n_read20;             // Active20 low20 read signal20                   
  
// Configuration20 Block


// Counters20

  wire [1:0]     r_csle_count20;       // Chip20 select20 LE20 counter
  wire [1:0]     r_wele_count20;       // Write counter
  wire [1:0]     r_cste_count20;       // chip20 select20 TE20 counter
  wire [7:0]     r_ws_count20; // Wait20 state select20 counter
  
// These20 strobes20 finish early20 so no counter is required20. The stored20 value
// is compared with WS20 counter to determine20 when the strobe20 should end.

  wire [1:0]     r_wete_store20;       // Write strobe20 TE20 end time before CS20
  wire [1:0]     r_oete_store20;       // Read strobe20 TE20 end time before CS20
  
// The following20 four20 wireisrers20 are used to store20 the configuration during
// mulitple20 accesses. The counters20 are reloaded20 from these20 wireisters20
//  before each cycle.

  wire [1:0]     r_csle_store20;       // Chip20 select20 LE20 store20
  wire [1:0]     r_wele_store20;       // Write strobe20 LE20 store20
  wire [7:0]     r_ws_store20;         // Wait20 state store20
  wire [1:0]     r_cste_store20;       // Chip20 Select20 TE20 delay (Bus20 float20 time)


// Multiple20 access control20

  wire           mac_done20;           // Indicates20 last cycle of last access
  wire [1:0]     r_num_access20;       // Access counter
  wire [1:0]     v_xfer_size20;        // Store20 size for MAC20 
  wire [1:0]     v_bus_size20;         // Store20 size for MAC20
  wire [31:0]    read_data20;          // Data path to bus IF
  wire [31:0]    r_read_data20;        // Internal data store20

// smc20 state machine20


  wire           valid_access20;       // New20 acces20 can proceed
  wire   [4:0]   smc_nextstate20;      // state machine20 (async20 encoding20)
  wire   [4:0]   r_smc_currentstate20; // Synchronised20 smc20 state machine20
  wire           ws_enable20;          // Wait20 state counter enable
  wire           cste_enable20;        // Chip20 select20 counter enable
  wire           smc_done20;           // Asserted20 during last cycle of
                                     //    an access
  wire           le_enable20;          // Start20 counters20 after STORED20 
                                     //    access
  wire           latch_data20;         // latch_data20 is used by the MAC20 
                                     //    block to store20 read data 
                                     //    if CSTE20 > 0
  wire           smc_idle20;           // idle20 state

// Address Generation20

  wire [3:0]     n_be20;               // Full cycle write strobe20

// Strobe20 Generation20

  wire           r_full20;             // Full cycle write strobe20
  wire           n_r_read20;           // Store20 RW srate20 for multiple accesses
  wire           n_r_wr20;             // write strobe20
  wire [3:0]     n_r_we20;             // write enable  
  wire      r_cs20;       // registered chip20 select20 

   //apb20
   

   wire n_sys_reset20;                        //AHB20 system reset(active low20)

// assign a default value to the signal20 if the bank20 has
// been disabled and the APB20 has been excluded20 (i.e. the config signals20
// come20 from the top level
   
   smc_apb_lite_if20 i_apb_lite20 (
                     //Inputs20
                     
                     .n_preset20(n_preset20),
                     .pclk20(pclk20),
                     .psel20(psel20),
                     .penable20(penable20),
                     .pwrite20(pwrite20),
                     .paddr20(paddr20),
                     .pwdata20(pwdata20),
                     
                    //Outputs20
                     
                     .prdata20(prdata20)
                     
                     );
   
   smc_ahb_lite_if20 i_ahb_lite20  (
                     //Inputs20
                     
		     .hclk20 (hclk20),
                     .n_sys_reset20 (n_sys_reset20),
                     .haddr20 (haddr20),
                     .hsel20 (hsel20),                                                
                     .htrans20 (htrans20),                    
                     .hwrite20 (hwrite20),
                     .hsize20 (hsize20),                
                     .hwdata20 (hwdata20),
                     .hready20 (hready20),
                     .read_data20 (read_data20),
                     .mac_done20 (mac_done20),
                     .smc_done20 (smc_done20),
                     .smc_idle20 (smc_idle20),
                     
                     // Outputs20
                     
                     .xfer_size20 (xfer_size20),
                     .n_read20 (n_read20),
                     .new_access20 (new_access20),
                     .addr (addr),
                     .smc_hrdata20 (smc_hrdata20), 
                     .smc_hready20 (smc_hready20),
                     .smc_hresp20 (smc_hresp20),
                     .smc_valid20 (smc_valid20),
                     .cs (cs),
                     .write_data20 (write_data20)
                     );
   
   

   
   
   smc_counter_lite20 i_counter_lite20 (
                          
                          // Inputs20
                          
                          .sys_clk20 (hclk20),
                          .n_sys_reset20 (n_sys_reset20),
                          .valid_access20 (valid_access20),
                          .mac_done20 (mac_done20),
                          .smc_done20 (smc_done20),
                          .cste_enable20 (cste_enable20),
                          .ws_enable20 (ws_enable20),
                          .le_enable20 (le_enable20),
                          
                          // Outputs20
                          
                          .r_csle_store20 (r_csle_store20),
                          .r_csle_count20 (r_csle_count20),
                          .r_wele_count20 (r_wele_count20),
                          .r_ws_count20 (r_ws_count20),
                          .r_ws_store20 (r_ws_store20),
                          .r_oete_store20 (r_oete_store20),
                          .r_wete_store20 (r_wete_store20),
                          .r_wele_store20 (r_wele_store20),
                          .r_cste_count20 (r_cste_count20));
   
   
   smc_mac_lite20 i_mac_lite20         (
                          
                          // Inputs20
                          
                          .sys_clk20 (hclk20),
                          .n_sys_reset20 (n_sys_reset20),
                          .valid_access20 (valid_access20),
                          .xfer_size20 (xfer_size20),
                          .smc_done20 (smc_done20),
                          .data_smc20 (data_smc20),
                          .write_data20 (write_data20),
                          .smc_nextstate20 (smc_nextstate20),
                          .latch_data20 (latch_data20),
                          
                          // Outputs20
                          
                          .r_num_access20 (r_num_access20),
                          .mac_done20 (mac_done20),
                          .v_bus_size20 (v_bus_size20),
                          .v_xfer_size20 (v_xfer_size20),
                          .read_data20 (read_data20),
                          .smc_data20 (smc_data20));
   
   
   smc_state_lite20 i_state_lite20     (
                          
                          // Inputs20
                          
                          .sys_clk20 (hclk20),
                          .n_sys_reset20 (n_sys_reset20),
                          .new_access20 (new_access20),
                          .r_cste_count20 (r_cste_count20),
                          .r_csle_count20 (r_csle_count20),
                          .r_ws_count20 (r_ws_count20),
                          .mac_done20 (mac_done20),
                          .n_read20 (n_read20),
                          .n_r_read20 (n_r_read20),
                          .r_csle_store20 (r_csle_store20),
                          .r_oete_store20 (r_oete_store20),
                          .cs(cs),
                          .r_cs20(r_cs20),

                          // Outputs20
                          
                          .r_smc_currentstate20 (r_smc_currentstate20),
                          .smc_nextstate20 (smc_nextstate20),
                          .cste_enable20 (cste_enable20),
                          .ws_enable20 (ws_enable20),
                          .smc_done20 (smc_done20),
                          .valid_access20 (valid_access20),
                          .le_enable20 (le_enable20),
                          .latch_data20 (latch_data20),
                          .smc_idle20 (smc_idle20));
   
   smc_strobe_lite20 i_strobe_lite20   (

                          //inputs20

                          .sys_clk20 (hclk20),
                          .n_sys_reset20 (n_sys_reset20),
                          .valid_access20 (valid_access20),
                          .n_read20 (n_read20),
                          .cs(cs),
                          .r_smc_currentstate20 (r_smc_currentstate20),
                          .smc_nextstate20 (smc_nextstate20),
                          .n_be20 (n_be20),
                          .r_wele_store20 (r_wele_store20),
                          .r_wele_count20 (r_wele_count20),
                          .r_wete_store20 (r_wete_store20),
                          .r_oete_store20 (r_oete_store20),
                          .r_ws_count20 (r_ws_count20),
                          .r_ws_store20 (r_ws_store20),
                          .smc_done20 (smc_done20),
                          .mac_done20 (mac_done20),
                          
                          //outputs20

                          .smc_n_rd20 (smc_n_rd20),
                          .smc_n_ext_oe20 (smc_n_ext_oe20),
                          .smc_busy20 (smc_busy20),
                          .n_r_read20 (n_r_read20),
                          .r_cs20(r_cs20),
                          .r_full20 (r_full20),
                          .n_r_we20 (n_r_we20),
                          .n_r_wr20 (n_r_wr20));
   
   smc_wr_enable_lite20 i_wr_enable_lite20 (

                            //inputs20

                          .n_sys_reset20 (n_sys_reset20),
                          .r_full20(r_full20),
                          .n_r_we20(n_r_we20),
                          .n_r_wr20 (n_r_wr20),
                              
                          //output                

                          .smc_n_we20(smc_n_we20),
                          .smc_n_wr20 (smc_n_wr20));
   
   
   
   smc_addr_lite20 i_add_lite20        (
                          //inputs20

                          .sys_clk20 (hclk20),
                          .n_sys_reset20 (n_sys_reset20),
                          .valid_access20 (valid_access20),
                          .r_num_access20 (r_num_access20),
                          .v_bus_size20 (v_bus_size20),
                          .v_xfer_size20 (v_xfer_size20),
                          .cs (cs),
                          .addr (addr),
                          .smc_done20 (smc_done20),
                          .smc_nextstate20 (smc_nextstate20),
                          
                          //outputs20

                          .smc_addr20 (smc_addr20),
                          .smc_n_be20 (smc_n_be20),
                          .smc_n_cs20 (smc_n_cs20),
                          .n_be20 (n_be20));
   
   
endmodule
