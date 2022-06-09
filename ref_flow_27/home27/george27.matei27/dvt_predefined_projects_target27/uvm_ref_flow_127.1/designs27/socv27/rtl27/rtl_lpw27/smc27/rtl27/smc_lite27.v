//File27 name   : smc_lite27.v
//Title27       : SMC27 top level
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

 `include "smc_defs_lite27.v"

//static memory controller27
module          smc_lite27(
                    //apb27 inputs27
                    n_preset27, 
                    pclk27, 
                    psel27, 
                    penable27, 
                    pwrite27, 
                    paddr27, 
                    pwdata27,
                    //ahb27 inputs27                    
                    hclk27,
                    n_sys_reset27,
                    haddr27,
                    htrans27,
                    hsel27,
                    hwrite27,
                    hsize27,
                    hwdata27,
                    hready27,
                    data_smc27,
                    

                    //test signal27 inputs27

                    scan_in_127,
                    scan_in_227,
                    scan_in_327,
                    scan_en27,

                    //apb27 outputs27                    
                    prdata27,

                    //design output
                    
                    smc_hrdata27, 
                    smc_hready27,
                    smc_valid27,
                    smc_hresp27,
                    smc_addr27,
                    smc_data27, 
                    smc_n_be27,
                    smc_n_cs27,
                    smc_n_wr27,                    
                    smc_n_we27,
                    smc_n_rd27,
                    smc_n_ext_oe27,
                    smc_busy27,

                    //test signal27 output

                    scan_out_127,
                    scan_out_227,
                    scan_out_327
                   );
// define parameters27
// change using defaparam27 statements27


  // APB27 Inputs27 (use is optional27 on INCLUDE_APB27)
  input        n_preset27;           // APBreset27 
  input        pclk27;               // APB27 clock27
  input        psel27;               // APB27 select27
  input        penable27;            // APB27 enable 
  input        pwrite27;             // APB27 write strobe27 
  input [4:0]  paddr27;              // APB27 address bus
  input [31:0] pwdata27;             // APB27 write data 

  // APB27 Output27 (use is optional27 on INCLUDE_APB27)

  output [31:0] prdata27;        //APB27 output



//System27 I27/O27

  input                    hclk27;          // AHB27 System27 clock27
  input                    n_sys_reset27;   // AHB27 System27 reset (Active27 LOW27)

//AHB27 I27/O27

  input  [31:0]            haddr27;         // AHB27 Address
  input  [1:0]             htrans27;        // AHB27 transfer27 type
  input               hsel27;          // chip27 selects27
  input                    hwrite27;        // AHB27 read/write indication27
  input  [2:0]             hsize27;         // AHB27 transfer27 size
  input  [31:0]            hwdata27;        // AHB27 write data
  input                    hready27;        // AHB27 Muxed27 ready signal27

  
  output [31:0]            smc_hrdata27;    // smc27 read data back to AHB27 master27
  output                   smc_hready27;    // smc27 ready signal27
  output [1:0]             smc_hresp27;     // AHB27 Response27 signal27
  output                   smc_valid27;     // Ack27 valid address

//External27 memory interface (EMI27)

  output [31:0]            smc_addr27;      // External27 Memory (EMI27) address
  output [31:0]            smc_data27;      // EMI27 write data
  input  [31:0]            data_smc27;      // EMI27 read data
  output [3:0]             smc_n_be27;      // EMI27 byte enables27 (Active27 LOW27)
  output             smc_n_cs27;      // EMI27 Chip27 Selects27 (Active27 LOW27)
  output [3:0]             smc_n_we27;      // EMI27 write strobes27 (Active27 LOW27)
  output                   smc_n_wr27;      // EMI27 write enable (Active27 LOW27)
  output                   smc_n_rd27;      // EMI27 read stobe27 (Active27 LOW27)
  output 	           smc_n_ext_oe27;  // EMI27 write data output enable

//AHB27 Memory Interface27 Control27

   output                   smc_busy27;      // smc27 busy

   
   


//scan27 signals27

   input                  scan_in_127;        //scan27 input
   input                  scan_in_227;        //scan27 input
   input                  scan_en27;         //scan27 enable
   output                 scan_out_127;       //scan27 output
   output                 scan_out_227;       //scan27 output
// third27 scan27 chain27 only used on INCLUDE_APB27
   input                  scan_in_327;        //scan27 input
   output                 scan_out_327;       //scan27 output
   
//----------------------------------------------------------------------
// Signal27 declarations27
//----------------------------------------------------------------------

// Bus27 Interface27
   
  wire  [31:0]   smc_hrdata27;         //smc27 read data back to AHB27 master27
  wire           smc_hready27;         //smc27 ready signal27
  wire  [1:0]    smc_hresp27;          //AHB27 Response27 signal27
  wire           smc_valid27;          //Ack27 valid address

// MAC27

  wire [31:0]    smc_data27;           //Data to external27 bus via MUX27

// Strobe27 Generation27

  wire           smc_n_wr27;           //EMI27 write enable (Active27 LOW27)
  wire  [3:0]    smc_n_we27;           //EMI27 write strobes27 (Active27 LOW27)
  wire           smc_n_rd27;           //EMI27 read stobe27 (Active27 LOW27)
  wire           smc_busy27;           //smc27 busy
  wire           smc_n_ext_oe27;       //Enable27 External27 bus drivers27.(CS27 & !RD27)

// Address Generation27

  wire [31:0]    smc_addr27;           //External27 Memory Interface27(EMI27) address
  wire [3:0]     smc_n_be27;   //EMI27 byte enables27 (Active27 LOW27)
  wire      smc_n_cs27;   //EMI27 Chip27 Selects27 (Active27 LOW27)

// Bus27 Interface27

  wire           new_access27;         // New27 AHB27 access to smc27 detected
  wire [31:0]    addr;               // Copy27 of address
  wire [31:0]    write_data27;         // Data to External27 Bus27
  wire      cs;         // Chip27(bank27) Select27 Lines27
  wire [1:0]     xfer_size27;          // Width27 of current transfer27
  wire           n_read27;             // Active27 low27 read signal27                   
  
// Configuration27 Block


// Counters27

  wire [1:0]     r_csle_count27;       // Chip27 select27 LE27 counter
  wire [1:0]     r_wele_count27;       // Write counter
  wire [1:0]     r_cste_count27;       // chip27 select27 TE27 counter
  wire [7:0]     r_ws_count27; // Wait27 state select27 counter
  
// These27 strobes27 finish early27 so no counter is required27. The stored27 value
// is compared with WS27 counter to determine27 when the strobe27 should end.

  wire [1:0]     r_wete_store27;       // Write strobe27 TE27 end time before CS27
  wire [1:0]     r_oete_store27;       // Read strobe27 TE27 end time before CS27
  
// The following27 four27 wireisrers27 are used to store27 the configuration during
// mulitple27 accesses. The counters27 are reloaded27 from these27 wireisters27
//  before each cycle.

  wire [1:0]     r_csle_store27;       // Chip27 select27 LE27 store27
  wire [1:0]     r_wele_store27;       // Write strobe27 LE27 store27
  wire [7:0]     r_ws_store27;         // Wait27 state store27
  wire [1:0]     r_cste_store27;       // Chip27 Select27 TE27 delay (Bus27 float27 time)


// Multiple27 access control27

  wire           mac_done27;           // Indicates27 last cycle of last access
  wire [1:0]     r_num_access27;       // Access counter
  wire [1:0]     v_xfer_size27;        // Store27 size for MAC27 
  wire [1:0]     v_bus_size27;         // Store27 size for MAC27
  wire [31:0]    read_data27;          // Data path to bus IF
  wire [31:0]    r_read_data27;        // Internal data store27

// smc27 state machine27


  wire           valid_access27;       // New27 acces27 can proceed
  wire   [4:0]   smc_nextstate27;      // state machine27 (async27 encoding27)
  wire   [4:0]   r_smc_currentstate27; // Synchronised27 smc27 state machine27
  wire           ws_enable27;          // Wait27 state counter enable
  wire           cste_enable27;        // Chip27 select27 counter enable
  wire           smc_done27;           // Asserted27 during last cycle of
                                     //    an access
  wire           le_enable27;          // Start27 counters27 after STORED27 
                                     //    access
  wire           latch_data27;         // latch_data27 is used by the MAC27 
                                     //    block to store27 read data 
                                     //    if CSTE27 > 0
  wire           smc_idle27;           // idle27 state

// Address Generation27

  wire [3:0]     n_be27;               // Full cycle write strobe27

// Strobe27 Generation27

  wire           r_full27;             // Full cycle write strobe27
  wire           n_r_read27;           // Store27 RW srate27 for multiple accesses
  wire           n_r_wr27;             // write strobe27
  wire [3:0]     n_r_we27;             // write enable  
  wire      r_cs27;       // registered chip27 select27 

   //apb27
   

   wire n_sys_reset27;                        //AHB27 system reset(active low27)

// assign a default value to the signal27 if the bank27 has
// been disabled and the APB27 has been excluded27 (i.e. the config signals27
// come27 from the top level
   
   smc_apb_lite_if27 i_apb_lite27 (
                     //Inputs27
                     
                     .n_preset27(n_preset27),
                     .pclk27(pclk27),
                     .psel27(psel27),
                     .penable27(penable27),
                     .pwrite27(pwrite27),
                     .paddr27(paddr27),
                     .pwdata27(pwdata27),
                     
                    //Outputs27
                     
                     .prdata27(prdata27)
                     
                     );
   
   smc_ahb_lite_if27 i_ahb_lite27  (
                     //Inputs27
                     
		     .hclk27 (hclk27),
                     .n_sys_reset27 (n_sys_reset27),
                     .haddr27 (haddr27),
                     .hsel27 (hsel27),                                                
                     .htrans27 (htrans27),                    
                     .hwrite27 (hwrite27),
                     .hsize27 (hsize27),                
                     .hwdata27 (hwdata27),
                     .hready27 (hready27),
                     .read_data27 (read_data27),
                     .mac_done27 (mac_done27),
                     .smc_done27 (smc_done27),
                     .smc_idle27 (smc_idle27),
                     
                     // Outputs27
                     
                     .xfer_size27 (xfer_size27),
                     .n_read27 (n_read27),
                     .new_access27 (new_access27),
                     .addr (addr),
                     .smc_hrdata27 (smc_hrdata27), 
                     .smc_hready27 (smc_hready27),
                     .smc_hresp27 (smc_hresp27),
                     .smc_valid27 (smc_valid27),
                     .cs (cs),
                     .write_data27 (write_data27)
                     );
   
   

   
   
   smc_counter_lite27 i_counter_lite27 (
                          
                          // Inputs27
                          
                          .sys_clk27 (hclk27),
                          .n_sys_reset27 (n_sys_reset27),
                          .valid_access27 (valid_access27),
                          .mac_done27 (mac_done27),
                          .smc_done27 (smc_done27),
                          .cste_enable27 (cste_enable27),
                          .ws_enable27 (ws_enable27),
                          .le_enable27 (le_enable27),
                          
                          // Outputs27
                          
                          .r_csle_store27 (r_csle_store27),
                          .r_csle_count27 (r_csle_count27),
                          .r_wele_count27 (r_wele_count27),
                          .r_ws_count27 (r_ws_count27),
                          .r_ws_store27 (r_ws_store27),
                          .r_oete_store27 (r_oete_store27),
                          .r_wete_store27 (r_wete_store27),
                          .r_wele_store27 (r_wele_store27),
                          .r_cste_count27 (r_cste_count27));
   
   
   smc_mac_lite27 i_mac_lite27         (
                          
                          // Inputs27
                          
                          .sys_clk27 (hclk27),
                          .n_sys_reset27 (n_sys_reset27),
                          .valid_access27 (valid_access27),
                          .xfer_size27 (xfer_size27),
                          .smc_done27 (smc_done27),
                          .data_smc27 (data_smc27),
                          .write_data27 (write_data27),
                          .smc_nextstate27 (smc_nextstate27),
                          .latch_data27 (latch_data27),
                          
                          // Outputs27
                          
                          .r_num_access27 (r_num_access27),
                          .mac_done27 (mac_done27),
                          .v_bus_size27 (v_bus_size27),
                          .v_xfer_size27 (v_xfer_size27),
                          .read_data27 (read_data27),
                          .smc_data27 (smc_data27));
   
   
   smc_state_lite27 i_state_lite27     (
                          
                          // Inputs27
                          
                          .sys_clk27 (hclk27),
                          .n_sys_reset27 (n_sys_reset27),
                          .new_access27 (new_access27),
                          .r_cste_count27 (r_cste_count27),
                          .r_csle_count27 (r_csle_count27),
                          .r_ws_count27 (r_ws_count27),
                          .mac_done27 (mac_done27),
                          .n_read27 (n_read27),
                          .n_r_read27 (n_r_read27),
                          .r_csle_store27 (r_csle_store27),
                          .r_oete_store27 (r_oete_store27),
                          .cs(cs),
                          .r_cs27(r_cs27),

                          // Outputs27
                          
                          .r_smc_currentstate27 (r_smc_currentstate27),
                          .smc_nextstate27 (smc_nextstate27),
                          .cste_enable27 (cste_enable27),
                          .ws_enable27 (ws_enable27),
                          .smc_done27 (smc_done27),
                          .valid_access27 (valid_access27),
                          .le_enable27 (le_enable27),
                          .latch_data27 (latch_data27),
                          .smc_idle27 (smc_idle27));
   
   smc_strobe_lite27 i_strobe_lite27   (

                          //inputs27

                          .sys_clk27 (hclk27),
                          .n_sys_reset27 (n_sys_reset27),
                          .valid_access27 (valid_access27),
                          .n_read27 (n_read27),
                          .cs(cs),
                          .r_smc_currentstate27 (r_smc_currentstate27),
                          .smc_nextstate27 (smc_nextstate27),
                          .n_be27 (n_be27),
                          .r_wele_store27 (r_wele_store27),
                          .r_wele_count27 (r_wele_count27),
                          .r_wete_store27 (r_wete_store27),
                          .r_oete_store27 (r_oete_store27),
                          .r_ws_count27 (r_ws_count27),
                          .r_ws_store27 (r_ws_store27),
                          .smc_done27 (smc_done27),
                          .mac_done27 (mac_done27),
                          
                          //outputs27

                          .smc_n_rd27 (smc_n_rd27),
                          .smc_n_ext_oe27 (smc_n_ext_oe27),
                          .smc_busy27 (smc_busy27),
                          .n_r_read27 (n_r_read27),
                          .r_cs27(r_cs27),
                          .r_full27 (r_full27),
                          .n_r_we27 (n_r_we27),
                          .n_r_wr27 (n_r_wr27));
   
   smc_wr_enable_lite27 i_wr_enable_lite27 (

                            //inputs27

                          .n_sys_reset27 (n_sys_reset27),
                          .r_full27(r_full27),
                          .n_r_we27(n_r_we27),
                          .n_r_wr27 (n_r_wr27),
                              
                          //output                

                          .smc_n_we27(smc_n_we27),
                          .smc_n_wr27 (smc_n_wr27));
   
   
   
   smc_addr_lite27 i_add_lite27        (
                          //inputs27

                          .sys_clk27 (hclk27),
                          .n_sys_reset27 (n_sys_reset27),
                          .valid_access27 (valid_access27),
                          .r_num_access27 (r_num_access27),
                          .v_bus_size27 (v_bus_size27),
                          .v_xfer_size27 (v_xfer_size27),
                          .cs (cs),
                          .addr (addr),
                          .smc_done27 (smc_done27),
                          .smc_nextstate27 (smc_nextstate27),
                          
                          //outputs27

                          .smc_addr27 (smc_addr27),
                          .smc_n_be27 (smc_n_be27),
                          .smc_n_cs27 (smc_n_cs27),
                          .n_be27 (n_be27));
   
   
endmodule
