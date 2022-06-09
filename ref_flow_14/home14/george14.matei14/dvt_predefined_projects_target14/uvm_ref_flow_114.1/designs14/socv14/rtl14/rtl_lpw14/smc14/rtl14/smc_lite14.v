//File14 name   : smc_lite14.v
//Title14       : SMC14 top level
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

 `include "smc_defs_lite14.v"

//static memory controller14
module          smc_lite14(
                    //apb14 inputs14
                    n_preset14, 
                    pclk14, 
                    psel14, 
                    penable14, 
                    pwrite14, 
                    paddr14, 
                    pwdata14,
                    //ahb14 inputs14                    
                    hclk14,
                    n_sys_reset14,
                    haddr14,
                    htrans14,
                    hsel14,
                    hwrite14,
                    hsize14,
                    hwdata14,
                    hready14,
                    data_smc14,
                    

                    //test signal14 inputs14

                    scan_in_114,
                    scan_in_214,
                    scan_in_314,
                    scan_en14,

                    //apb14 outputs14                    
                    prdata14,

                    //design output
                    
                    smc_hrdata14, 
                    smc_hready14,
                    smc_valid14,
                    smc_hresp14,
                    smc_addr14,
                    smc_data14, 
                    smc_n_be14,
                    smc_n_cs14,
                    smc_n_wr14,                    
                    smc_n_we14,
                    smc_n_rd14,
                    smc_n_ext_oe14,
                    smc_busy14,

                    //test signal14 output

                    scan_out_114,
                    scan_out_214,
                    scan_out_314
                   );
// define parameters14
// change using defaparam14 statements14


  // APB14 Inputs14 (use is optional14 on INCLUDE_APB14)
  input        n_preset14;           // APBreset14 
  input        pclk14;               // APB14 clock14
  input        psel14;               // APB14 select14
  input        penable14;            // APB14 enable 
  input        pwrite14;             // APB14 write strobe14 
  input [4:0]  paddr14;              // APB14 address bus
  input [31:0] pwdata14;             // APB14 write data 

  // APB14 Output14 (use is optional14 on INCLUDE_APB14)

  output [31:0] prdata14;        //APB14 output



//System14 I14/O14

  input                    hclk14;          // AHB14 System14 clock14
  input                    n_sys_reset14;   // AHB14 System14 reset (Active14 LOW14)

//AHB14 I14/O14

  input  [31:0]            haddr14;         // AHB14 Address
  input  [1:0]             htrans14;        // AHB14 transfer14 type
  input               hsel14;          // chip14 selects14
  input                    hwrite14;        // AHB14 read/write indication14
  input  [2:0]             hsize14;         // AHB14 transfer14 size
  input  [31:0]            hwdata14;        // AHB14 write data
  input                    hready14;        // AHB14 Muxed14 ready signal14

  
  output [31:0]            smc_hrdata14;    // smc14 read data back to AHB14 master14
  output                   smc_hready14;    // smc14 ready signal14
  output [1:0]             smc_hresp14;     // AHB14 Response14 signal14
  output                   smc_valid14;     // Ack14 valid address

//External14 memory interface (EMI14)

  output [31:0]            smc_addr14;      // External14 Memory (EMI14) address
  output [31:0]            smc_data14;      // EMI14 write data
  input  [31:0]            data_smc14;      // EMI14 read data
  output [3:0]             smc_n_be14;      // EMI14 byte enables14 (Active14 LOW14)
  output             smc_n_cs14;      // EMI14 Chip14 Selects14 (Active14 LOW14)
  output [3:0]             smc_n_we14;      // EMI14 write strobes14 (Active14 LOW14)
  output                   smc_n_wr14;      // EMI14 write enable (Active14 LOW14)
  output                   smc_n_rd14;      // EMI14 read stobe14 (Active14 LOW14)
  output 	           smc_n_ext_oe14;  // EMI14 write data output enable

//AHB14 Memory Interface14 Control14

   output                   smc_busy14;      // smc14 busy

   
   


//scan14 signals14

   input                  scan_in_114;        //scan14 input
   input                  scan_in_214;        //scan14 input
   input                  scan_en14;         //scan14 enable
   output                 scan_out_114;       //scan14 output
   output                 scan_out_214;       //scan14 output
// third14 scan14 chain14 only used on INCLUDE_APB14
   input                  scan_in_314;        //scan14 input
   output                 scan_out_314;       //scan14 output
   
//----------------------------------------------------------------------
// Signal14 declarations14
//----------------------------------------------------------------------

// Bus14 Interface14
   
  wire  [31:0]   smc_hrdata14;         //smc14 read data back to AHB14 master14
  wire           smc_hready14;         //smc14 ready signal14
  wire  [1:0]    smc_hresp14;          //AHB14 Response14 signal14
  wire           smc_valid14;          //Ack14 valid address

// MAC14

  wire [31:0]    smc_data14;           //Data to external14 bus via MUX14

// Strobe14 Generation14

  wire           smc_n_wr14;           //EMI14 write enable (Active14 LOW14)
  wire  [3:0]    smc_n_we14;           //EMI14 write strobes14 (Active14 LOW14)
  wire           smc_n_rd14;           //EMI14 read stobe14 (Active14 LOW14)
  wire           smc_busy14;           //smc14 busy
  wire           smc_n_ext_oe14;       //Enable14 External14 bus drivers14.(CS14 & !RD14)

// Address Generation14

  wire [31:0]    smc_addr14;           //External14 Memory Interface14(EMI14) address
  wire [3:0]     smc_n_be14;   //EMI14 byte enables14 (Active14 LOW14)
  wire      smc_n_cs14;   //EMI14 Chip14 Selects14 (Active14 LOW14)

// Bus14 Interface14

  wire           new_access14;         // New14 AHB14 access to smc14 detected
  wire [31:0]    addr;               // Copy14 of address
  wire [31:0]    write_data14;         // Data to External14 Bus14
  wire      cs;         // Chip14(bank14) Select14 Lines14
  wire [1:0]     xfer_size14;          // Width14 of current transfer14
  wire           n_read14;             // Active14 low14 read signal14                   
  
// Configuration14 Block


// Counters14

  wire [1:0]     r_csle_count14;       // Chip14 select14 LE14 counter
  wire [1:0]     r_wele_count14;       // Write counter
  wire [1:0]     r_cste_count14;       // chip14 select14 TE14 counter
  wire [7:0]     r_ws_count14; // Wait14 state select14 counter
  
// These14 strobes14 finish early14 so no counter is required14. The stored14 value
// is compared with WS14 counter to determine14 when the strobe14 should end.

  wire [1:0]     r_wete_store14;       // Write strobe14 TE14 end time before CS14
  wire [1:0]     r_oete_store14;       // Read strobe14 TE14 end time before CS14
  
// The following14 four14 wireisrers14 are used to store14 the configuration during
// mulitple14 accesses. The counters14 are reloaded14 from these14 wireisters14
//  before each cycle.

  wire [1:0]     r_csle_store14;       // Chip14 select14 LE14 store14
  wire [1:0]     r_wele_store14;       // Write strobe14 LE14 store14
  wire [7:0]     r_ws_store14;         // Wait14 state store14
  wire [1:0]     r_cste_store14;       // Chip14 Select14 TE14 delay (Bus14 float14 time)


// Multiple14 access control14

  wire           mac_done14;           // Indicates14 last cycle of last access
  wire [1:0]     r_num_access14;       // Access counter
  wire [1:0]     v_xfer_size14;        // Store14 size for MAC14 
  wire [1:0]     v_bus_size14;         // Store14 size for MAC14
  wire [31:0]    read_data14;          // Data path to bus IF
  wire [31:0]    r_read_data14;        // Internal data store14

// smc14 state machine14


  wire           valid_access14;       // New14 acces14 can proceed
  wire   [4:0]   smc_nextstate14;      // state machine14 (async14 encoding14)
  wire   [4:0]   r_smc_currentstate14; // Synchronised14 smc14 state machine14
  wire           ws_enable14;          // Wait14 state counter enable
  wire           cste_enable14;        // Chip14 select14 counter enable
  wire           smc_done14;           // Asserted14 during last cycle of
                                     //    an access
  wire           le_enable14;          // Start14 counters14 after STORED14 
                                     //    access
  wire           latch_data14;         // latch_data14 is used by the MAC14 
                                     //    block to store14 read data 
                                     //    if CSTE14 > 0
  wire           smc_idle14;           // idle14 state

// Address Generation14

  wire [3:0]     n_be14;               // Full cycle write strobe14

// Strobe14 Generation14

  wire           r_full14;             // Full cycle write strobe14
  wire           n_r_read14;           // Store14 RW srate14 for multiple accesses
  wire           n_r_wr14;             // write strobe14
  wire [3:0]     n_r_we14;             // write enable  
  wire      r_cs14;       // registered chip14 select14 

   //apb14
   

   wire n_sys_reset14;                        //AHB14 system reset(active low14)

// assign a default value to the signal14 if the bank14 has
// been disabled and the APB14 has been excluded14 (i.e. the config signals14
// come14 from the top level
   
   smc_apb_lite_if14 i_apb_lite14 (
                     //Inputs14
                     
                     .n_preset14(n_preset14),
                     .pclk14(pclk14),
                     .psel14(psel14),
                     .penable14(penable14),
                     .pwrite14(pwrite14),
                     .paddr14(paddr14),
                     .pwdata14(pwdata14),
                     
                    //Outputs14
                     
                     .prdata14(prdata14)
                     
                     );
   
   smc_ahb_lite_if14 i_ahb_lite14  (
                     //Inputs14
                     
		     .hclk14 (hclk14),
                     .n_sys_reset14 (n_sys_reset14),
                     .haddr14 (haddr14),
                     .hsel14 (hsel14),                                                
                     .htrans14 (htrans14),                    
                     .hwrite14 (hwrite14),
                     .hsize14 (hsize14),                
                     .hwdata14 (hwdata14),
                     .hready14 (hready14),
                     .read_data14 (read_data14),
                     .mac_done14 (mac_done14),
                     .smc_done14 (smc_done14),
                     .smc_idle14 (smc_idle14),
                     
                     // Outputs14
                     
                     .xfer_size14 (xfer_size14),
                     .n_read14 (n_read14),
                     .new_access14 (new_access14),
                     .addr (addr),
                     .smc_hrdata14 (smc_hrdata14), 
                     .smc_hready14 (smc_hready14),
                     .smc_hresp14 (smc_hresp14),
                     .smc_valid14 (smc_valid14),
                     .cs (cs),
                     .write_data14 (write_data14)
                     );
   
   

   
   
   smc_counter_lite14 i_counter_lite14 (
                          
                          // Inputs14
                          
                          .sys_clk14 (hclk14),
                          .n_sys_reset14 (n_sys_reset14),
                          .valid_access14 (valid_access14),
                          .mac_done14 (mac_done14),
                          .smc_done14 (smc_done14),
                          .cste_enable14 (cste_enable14),
                          .ws_enable14 (ws_enable14),
                          .le_enable14 (le_enable14),
                          
                          // Outputs14
                          
                          .r_csle_store14 (r_csle_store14),
                          .r_csle_count14 (r_csle_count14),
                          .r_wele_count14 (r_wele_count14),
                          .r_ws_count14 (r_ws_count14),
                          .r_ws_store14 (r_ws_store14),
                          .r_oete_store14 (r_oete_store14),
                          .r_wete_store14 (r_wete_store14),
                          .r_wele_store14 (r_wele_store14),
                          .r_cste_count14 (r_cste_count14));
   
   
   smc_mac_lite14 i_mac_lite14         (
                          
                          // Inputs14
                          
                          .sys_clk14 (hclk14),
                          .n_sys_reset14 (n_sys_reset14),
                          .valid_access14 (valid_access14),
                          .xfer_size14 (xfer_size14),
                          .smc_done14 (smc_done14),
                          .data_smc14 (data_smc14),
                          .write_data14 (write_data14),
                          .smc_nextstate14 (smc_nextstate14),
                          .latch_data14 (latch_data14),
                          
                          // Outputs14
                          
                          .r_num_access14 (r_num_access14),
                          .mac_done14 (mac_done14),
                          .v_bus_size14 (v_bus_size14),
                          .v_xfer_size14 (v_xfer_size14),
                          .read_data14 (read_data14),
                          .smc_data14 (smc_data14));
   
   
   smc_state_lite14 i_state_lite14     (
                          
                          // Inputs14
                          
                          .sys_clk14 (hclk14),
                          .n_sys_reset14 (n_sys_reset14),
                          .new_access14 (new_access14),
                          .r_cste_count14 (r_cste_count14),
                          .r_csle_count14 (r_csle_count14),
                          .r_ws_count14 (r_ws_count14),
                          .mac_done14 (mac_done14),
                          .n_read14 (n_read14),
                          .n_r_read14 (n_r_read14),
                          .r_csle_store14 (r_csle_store14),
                          .r_oete_store14 (r_oete_store14),
                          .cs(cs),
                          .r_cs14(r_cs14),

                          // Outputs14
                          
                          .r_smc_currentstate14 (r_smc_currentstate14),
                          .smc_nextstate14 (smc_nextstate14),
                          .cste_enable14 (cste_enable14),
                          .ws_enable14 (ws_enable14),
                          .smc_done14 (smc_done14),
                          .valid_access14 (valid_access14),
                          .le_enable14 (le_enable14),
                          .latch_data14 (latch_data14),
                          .smc_idle14 (smc_idle14));
   
   smc_strobe_lite14 i_strobe_lite14   (

                          //inputs14

                          .sys_clk14 (hclk14),
                          .n_sys_reset14 (n_sys_reset14),
                          .valid_access14 (valid_access14),
                          .n_read14 (n_read14),
                          .cs(cs),
                          .r_smc_currentstate14 (r_smc_currentstate14),
                          .smc_nextstate14 (smc_nextstate14),
                          .n_be14 (n_be14),
                          .r_wele_store14 (r_wele_store14),
                          .r_wele_count14 (r_wele_count14),
                          .r_wete_store14 (r_wete_store14),
                          .r_oete_store14 (r_oete_store14),
                          .r_ws_count14 (r_ws_count14),
                          .r_ws_store14 (r_ws_store14),
                          .smc_done14 (smc_done14),
                          .mac_done14 (mac_done14),
                          
                          //outputs14

                          .smc_n_rd14 (smc_n_rd14),
                          .smc_n_ext_oe14 (smc_n_ext_oe14),
                          .smc_busy14 (smc_busy14),
                          .n_r_read14 (n_r_read14),
                          .r_cs14(r_cs14),
                          .r_full14 (r_full14),
                          .n_r_we14 (n_r_we14),
                          .n_r_wr14 (n_r_wr14));
   
   smc_wr_enable_lite14 i_wr_enable_lite14 (

                            //inputs14

                          .n_sys_reset14 (n_sys_reset14),
                          .r_full14(r_full14),
                          .n_r_we14(n_r_we14),
                          .n_r_wr14 (n_r_wr14),
                              
                          //output                

                          .smc_n_we14(smc_n_we14),
                          .smc_n_wr14 (smc_n_wr14));
   
   
   
   smc_addr_lite14 i_add_lite14        (
                          //inputs14

                          .sys_clk14 (hclk14),
                          .n_sys_reset14 (n_sys_reset14),
                          .valid_access14 (valid_access14),
                          .r_num_access14 (r_num_access14),
                          .v_bus_size14 (v_bus_size14),
                          .v_xfer_size14 (v_xfer_size14),
                          .cs (cs),
                          .addr (addr),
                          .smc_done14 (smc_done14),
                          .smc_nextstate14 (smc_nextstate14),
                          
                          //outputs14

                          .smc_addr14 (smc_addr14),
                          .smc_n_be14 (smc_n_be14),
                          .smc_n_cs14 (smc_n_cs14),
                          .n_be14 (n_be14));
   
   
endmodule
