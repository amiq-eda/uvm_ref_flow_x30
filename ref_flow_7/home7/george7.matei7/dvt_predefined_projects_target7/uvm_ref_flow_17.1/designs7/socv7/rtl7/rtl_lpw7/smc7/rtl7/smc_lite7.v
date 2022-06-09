//File7 name   : smc_lite7.v
//Title7       : SMC7 top level
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

 `include "smc_defs_lite7.v"

//static memory controller7
module          smc_lite7(
                    //apb7 inputs7
                    n_preset7, 
                    pclk7, 
                    psel7, 
                    penable7, 
                    pwrite7, 
                    paddr7, 
                    pwdata7,
                    //ahb7 inputs7                    
                    hclk7,
                    n_sys_reset7,
                    haddr7,
                    htrans7,
                    hsel7,
                    hwrite7,
                    hsize7,
                    hwdata7,
                    hready7,
                    data_smc7,
                    

                    //test signal7 inputs7

                    scan_in_17,
                    scan_in_27,
                    scan_in_37,
                    scan_en7,

                    //apb7 outputs7                    
                    prdata7,

                    //design output
                    
                    smc_hrdata7, 
                    smc_hready7,
                    smc_valid7,
                    smc_hresp7,
                    smc_addr7,
                    smc_data7, 
                    smc_n_be7,
                    smc_n_cs7,
                    smc_n_wr7,                    
                    smc_n_we7,
                    smc_n_rd7,
                    smc_n_ext_oe7,
                    smc_busy7,

                    //test signal7 output

                    scan_out_17,
                    scan_out_27,
                    scan_out_37
                   );
// define parameters7
// change using defaparam7 statements7


  // APB7 Inputs7 (use is optional7 on INCLUDE_APB7)
  input        n_preset7;           // APBreset7 
  input        pclk7;               // APB7 clock7
  input        psel7;               // APB7 select7
  input        penable7;            // APB7 enable 
  input        pwrite7;             // APB7 write strobe7 
  input [4:0]  paddr7;              // APB7 address bus
  input [31:0] pwdata7;             // APB7 write data 

  // APB7 Output7 (use is optional7 on INCLUDE_APB7)

  output [31:0] prdata7;        //APB7 output



//System7 I7/O7

  input                    hclk7;          // AHB7 System7 clock7
  input                    n_sys_reset7;   // AHB7 System7 reset (Active7 LOW7)

//AHB7 I7/O7

  input  [31:0]            haddr7;         // AHB7 Address
  input  [1:0]             htrans7;        // AHB7 transfer7 type
  input               hsel7;          // chip7 selects7
  input                    hwrite7;        // AHB7 read/write indication7
  input  [2:0]             hsize7;         // AHB7 transfer7 size
  input  [31:0]            hwdata7;        // AHB7 write data
  input                    hready7;        // AHB7 Muxed7 ready signal7

  
  output [31:0]            smc_hrdata7;    // smc7 read data back to AHB7 master7
  output                   smc_hready7;    // smc7 ready signal7
  output [1:0]             smc_hresp7;     // AHB7 Response7 signal7
  output                   smc_valid7;     // Ack7 valid address

//External7 memory interface (EMI7)

  output [31:0]            smc_addr7;      // External7 Memory (EMI7) address
  output [31:0]            smc_data7;      // EMI7 write data
  input  [31:0]            data_smc7;      // EMI7 read data
  output [3:0]             smc_n_be7;      // EMI7 byte enables7 (Active7 LOW7)
  output             smc_n_cs7;      // EMI7 Chip7 Selects7 (Active7 LOW7)
  output [3:0]             smc_n_we7;      // EMI7 write strobes7 (Active7 LOW7)
  output                   smc_n_wr7;      // EMI7 write enable (Active7 LOW7)
  output                   smc_n_rd7;      // EMI7 read stobe7 (Active7 LOW7)
  output 	           smc_n_ext_oe7;  // EMI7 write data output enable

//AHB7 Memory Interface7 Control7

   output                   smc_busy7;      // smc7 busy

   
   


//scan7 signals7

   input                  scan_in_17;        //scan7 input
   input                  scan_in_27;        //scan7 input
   input                  scan_en7;         //scan7 enable
   output                 scan_out_17;       //scan7 output
   output                 scan_out_27;       //scan7 output
// third7 scan7 chain7 only used on INCLUDE_APB7
   input                  scan_in_37;        //scan7 input
   output                 scan_out_37;       //scan7 output
   
//----------------------------------------------------------------------
// Signal7 declarations7
//----------------------------------------------------------------------

// Bus7 Interface7
   
  wire  [31:0]   smc_hrdata7;         //smc7 read data back to AHB7 master7
  wire           smc_hready7;         //smc7 ready signal7
  wire  [1:0]    smc_hresp7;          //AHB7 Response7 signal7
  wire           smc_valid7;          //Ack7 valid address

// MAC7

  wire [31:0]    smc_data7;           //Data to external7 bus via MUX7

// Strobe7 Generation7

  wire           smc_n_wr7;           //EMI7 write enable (Active7 LOW7)
  wire  [3:0]    smc_n_we7;           //EMI7 write strobes7 (Active7 LOW7)
  wire           smc_n_rd7;           //EMI7 read stobe7 (Active7 LOW7)
  wire           smc_busy7;           //smc7 busy
  wire           smc_n_ext_oe7;       //Enable7 External7 bus drivers7.(CS7 & !RD7)

// Address Generation7

  wire [31:0]    smc_addr7;           //External7 Memory Interface7(EMI7) address
  wire [3:0]     smc_n_be7;   //EMI7 byte enables7 (Active7 LOW7)
  wire      smc_n_cs7;   //EMI7 Chip7 Selects7 (Active7 LOW7)

// Bus7 Interface7

  wire           new_access7;         // New7 AHB7 access to smc7 detected
  wire [31:0]    addr;               // Copy7 of address
  wire [31:0]    write_data7;         // Data to External7 Bus7
  wire      cs;         // Chip7(bank7) Select7 Lines7
  wire [1:0]     xfer_size7;          // Width7 of current transfer7
  wire           n_read7;             // Active7 low7 read signal7                   
  
// Configuration7 Block


// Counters7

  wire [1:0]     r_csle_count7;       // Chip7 select7 LE7 counter
  wire [1:0]     r_wele_count7;       // Write counter
  wire [1:0]     r_cste_count7;       // chip7 select7 TE7 counter
  wire [7:0]     r_ws_count7; // Wait7 state select7 counter
  
// These7 strobes7 finish early7 so no counter is required7. The stored7 value
// is compared with WS7 counter to determine7 when the strobe7 should end.

  wire [1:0]     r_wete_store7;       // Write strobe7 TE7 end time before CS7
  wire [1:0]     r_oete_store7;       // Read strobe7 TE7 end time before CS7
  
// The following7 four7 wireisrers7 are used to store7 the configuration during
// mulitple7 accesses. The counters7 are reloaded7 from these7 wireisters7
//  before each cycle.

  wire [1:0]     r_csle_store7;       // Chip7 select7 LE7 store7
  wire [1:0]     r_wele_store7;       // Write strobe7 LE7 store7
  wire [7:0]     r_ws_store7;         // Wait7 state store7
  wire [1:0]     r_cste_store7;       // Chip7 Select7 TE7 delay (Bus7 float7 time)


// Multiple7 access control7

  wire           mac_done7;           // Indicates7 last cycle of last access
  wire [1:0]     r_num_access7;       // Access counter
  wire [1:0]     v_xfer_size7;        // Store7 size for MAC7 
  wire [1:0]     v_bus_size7;         // Store7 size for MAC7
  wire [31:0]    read_data7;          // Data path to bus IF
  wire [31:0]    r_read_data7;        // Internal data store7

// smc7 state machine7


  wire           valid_access7;       // New7 acces7 can proceed
  wire   [4:0]   smc_nextstate7;      // state machine7 (async7 encoding7)
  wire   [4:0]   r_smc_currentstate7; // Synchronised7 smc7 state machine7
  wire           ws_enable7;          // Wait7 state counter enable
  wire           cste_enable7;        // Chip7 select7 counter enable
  wire           smc_done7;           // Asserted7 during last cycle of
                                     //    an access
  wire           le_enable7;          // Start7 counters7 after STORED7 
                                     //    access
  wire           latch_data7;         // latch_data7 is used by the MAC7 
                                     //    block to store7 read data 
                                     //    if CSTE7 > 0
  wire           smc_idle7;           // idle7 state

// Address Generation7

  wire [3:0]     n_be7;               // Full cycle write strobe7

// Strobe7 Generation7

  wire           r_full7;             // Full cycle write strobe7
  wire           n_r_read7;           // Store7 RW srate7 for multiple accesses
  wire           n_r_wr7;             // write strobe7
  wire [3:0]     n_r_we7;             // write enable  
  wire      r_cs7;       // registered chip7 select7 

   //apb7
   

   wire n_sys_reset7;                        //AHB7 system reset(active low7)

// assign a default value to the signal7 if the bank7 has
// been disabled and the APB7 has been excluded7 (i.e. the config signals7
// come7 from the top level
   
   smc_apb_lite_if7 i_apb_lite7 (
                     //Inputs7
                     
                     .n_preset7(n_preset7),
                     .pclk7(pclk7),
                     .psel7(psel7),
                     .penable7(penable7),
                     .pwrite7(pwrite7),
                     .paddr7(paddr7),
                     .pwdata7(pwdata7),
                     
                    //Outputs7
                     
                     .prdata7(prdata7)
                     
                     );
   
   smc_ahb_lite_if7 i_ahb_lite7  (
                     //Inputs7
                     
		     .hclk7 (hclk7),
                     .n_sys_reset7 (n_sys_reset7),
                     .haddr7 (haddr7),
                     .hsel7 (hsel7),                                                
                     .htrans7 (htrans7),                    
                     .hwrite7 (hwrite7),
                     .hsize7 (hsize7),                
                     .hwdata7 (hwdata7),
                     .hready7 (hready7),
                     .read_data7 (read_data7),
                     .mac_done7 (mac_done7),
                     .smc_done7 (smc_done7),
                     .smc_idle7 (smc_idle7),
                     
                     // Outputs7
                     
                     .xfer_size7 (xfer_size7),
                     .n_read7 (n_read7),
                     .new_access7 (new_access7),
                     .addr (addr),
                     .smc_hrdata7 (smc_hrdata7), 
                     .smc_hready7 (smc_hready7),
                     .smc_hresp7 (smc_hresp7),
                     .smc_valid7 (smc_valid7),
                     .cs (cs),
                     .write_data7 (write_data7)
                     );
   
   

   
   
   smc_counter_lite7 i_counter_lite7 (
                          
                          // Inputs7
                          
                          .sys_clk7 (hclk7),
                          .n_sys_reset7 (n_sys_reset7),
                          .valid_access7 (valid_access7),
                          .mac_done7 (mac_done7),
                          .smc_done7 (smc_done7),
                          .cste_enable7 (cste_enable7),
                          .ws_enable7 (ws_enable7),
                          .le_enable7 (le_enable7),
                          
                          // Outputs7
                          
                          .r_csle_store7 (r_csle_store7),
                          .r_csle_count7 (r_csle_count7),
                          .r_wele_count7 (r_wele_count7),
                          .r_ws_count7 (r_ws_count7),
                          .r_ws_store7 (r_ws_store7),
                          .r_oete_store7 (r_oete_store7),
                          .r_wete_store7 (r_wete_store7),
                          .r_wele_store7 (r_wele_store7),
                          .r_cste_count7 (r_cste_count7));
   
   
   smc_mac_lite7 i_mac_lite7         (
                          
                          // Inputs7
                          
                          .sys_clk7 (hclk7),
                          .n_sys_reset7 (n_sys_reset7),
                          .valid_access7 (valid_access7),
                          .xfer_size7 (xfer_size7),
                          .smc_done7 (smc_done7),
                          .data_smc7 (data_smc7),
                          .write_data7 (write_data7),
                          .smc_nextstate7 (smc_nextstate7),
                          .latch_data7 (latch_data7),
                          
                          // Outputs7
                          
                          .r_num_access7 (r_num_access7),
                          .mac_done7 (mac_done7),
                          .v_bus_size7 (v_bus_size7),
                          .v_xfer_size7 (v_xfer_size7),
                          .read_data7 (read_data7),
                          .smc_data7 (smc_data7));
   
   
   smc_state_lite7 i_state_lite7     (
                          
                          // Inputs7
                          
                          .sys_clk7 (hclk7),
                          .n_sys_reset7 (n_sys_reset7),
                          .new_access7 (new_access7),
                          .r_cste_count7 (r_cste_count7),
                          .r_csle_count7 (r_csle_count7),
                          .r_ws_count7 (r_ws_count7),
                          .mac_done7 (mac_done7),
                          .n_read7 (n_read7),
                          .n_r_read7 (n_r_read7),
                          .r_csle_store7 (r_csle_store7),
                          .r_oete_store7 (r_oete_store7),
                          .cs(cs),
                          .r_cs7(r_cs7),

                          // Outputs7
                          
                          .r_smc_currentstate7 (r_smc_currentstate7),
                          .smc_nextstate7 (smc_nextstate7),
                          .cste_enable7 (cste_enable7),
                          .ws_enable7 (ws_enable7),
                          .smc_done7 (smc_done7),
                          .valid_access7 (valid_access7),
                          .le_enable7 (le_enable7),
                          .latch_data7 (latch_data7),
                          .smc_idle7 (smc_idle7));
   
   smc_strobe_lite7 i_strobe_lite7   (

                          //inputs7

                          .sys_clk7 (hclk7),
                          .n_sys_reset7 (n_sys_reset7),
                          .valid_access7 (valid_access7),
                          .n_read7 (n_read7),
                          .cs(cs),
                          .r_smc_currentstate7 (r_smc_currentstate7),
                          .smc_nextstate7 (smc_nextstate7),
                          .n_be7 (n_be7),
                          .r_wele_store7 (r_wele_store7),
                          .r_wele_count7 (r_wele_count7),
                          .r_wete_store7 (r_wete_store7),
                          .r_oete_store7 (r_oete_store7),
                          .r_ws_count7 (r_ws_count7),
                          .r_ws_store7 (r_ws_store7),
                          .smc_done7 (smc_done7),
                          .mac_done7 (mac_done7),
                          
                          //outputs7

                          .smc_n_rd7 (smc_n_rd7),
                          .smc_n_ext_oe7 (smc_n_ext_oe7),
                          .smc_busy7 (smc_busy7),
                          .n_r_read7 (n_r_read7),
                          .r_cs7(r_cs7),
                          .r_full7 (r_full7),
                          .n_r_we7 (n_r_we7),
                          .n_r_wr7 (n_r_wr7));
   
   smc_wr_enable_lite7 i_wr_enable_lite7 (

                            //inputs7

                          .n_sys_reset7 (n_sys_reset7),
                          .r_full7(r_full7),
                          .n_r_we7(n_r_we7),
                          .n_r_wr7 (n_r_wr7),
                              
                          //output                

                          .smc_n_we7(smc_n_we7),
                          .smc_n_wr7 (smc_n_wr7));
   
   
   
   smc_addr_lite7 i_add_lite7        (
                          //inputs7

                          .sys_clk7 (hclk7),
                          .n_sys_reset7 (n_sys_reset7),
                          .valid_access7 (valid_access7),
                          .r_num_access7 (r_num_access7),
                          .v_bus_size7 (v_bus_size7),
                          .v_xfer_size7 (v_xfer_size7),
                          .cs (cs),
                          .addr (addr),
                          .smc_done7 (smc_done7),
                          .smc_nextstate7 (smc_nextstate7),
                          
                          //outputs7

                          .smc_addr7 (smc_addr7),
                          .smc_n_be7 (smc_n_be7),
                          .smc_n_cs7 (smc_n_cs7),
                          .n_be7 (n_be7));
   
   
endmodule
