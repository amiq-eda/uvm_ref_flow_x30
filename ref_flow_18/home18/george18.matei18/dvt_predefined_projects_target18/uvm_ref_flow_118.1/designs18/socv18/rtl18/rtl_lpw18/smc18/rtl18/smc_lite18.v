//File18 name   : smc_lite18.v
//Title18       : SMC18 top level
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

 `include "smc_defs_lite18.v"

//static memory controller18
module          smc_lite18(
                    //apb18 inputs18
                    n_preset18, 
                    pclk18, 
                    psel18, 
                    penable18, 
                    pwrite18, 
                    paddr18, 
                    pwdata18,
                    //ahb18 inputs18                    
                    hclk18,
                    n_sys_reset18,
                    haddr18,
                    htrans18,
                    hsel18,
                    hwrite18,
                    hsize18,
                    hwdata18,
                    hready18,
                    data_smc18,
                    

                    //test signal18 inputs18

                    scan_in_118,
                    scan_in_218,
                    scan_in_318,
                    scan_en18,

                    //apb18 outputs18                    
                    prdata18,

                    //design output
                    
                    smc_hrdata18, 
                    smc_hready18,
                    smc_valid18,
                    smc_hresp18,
                    smc_addr18,
                    smc_data18, 
                    smc_n_be18,
                    smc_n_cs18,
                    smc_n_wr18,                    
                    smc_n_we18,
                    smc_n_rd18,
                    smc_n_ext_oe18,
                    smc_busy18,

                    //test signal18 output

                    scan_out_118,
                    scan_out_218,
                    scan_out_318
                   );
// define parameters18
// change using defaparam18 statements18


  // APB18 Inputs18 (use is optional18 on INCLUDE_APB18)
  input        n_preset18;           // APBreset18 
  input        pclk18;               // APB18 clock18
  input        psel18;               // APB18 select18
  input        penable18;            // APB18 enable 
  input        pwrite18;             // APB18 write strobe18 
  input [4:0]  paddr18;              // APB18 address bus
  input [31:0] pwdata18;             // APB18 write data 

  // APB18 Output18 (use is optional18 on INCLUDE_APB18)

  output [31:0] prdata18;        //APB18 output



//System18 I18/O18

  input                    hclk18;          // AHB18 System18 clock18
  input                    n_sys_reset18;   // AHB18 System18 reset (Active18 LOW18)

//AHB18 I18/O18

  input  [31:0]            haddr18;         // AHB18 Address
  input  [1:0]             htrans18;        // AHB18 transfer18 type
  input               hsel18;          // chip18 selects18
  input                    hwrite18;        // AHB18 read/write indication18
  input  [2:0]             hsize18;         // AHB18 transfer18 size
  input  [31:0]            hwdata18;        // AHB18 write data
  input                    hready18;        // AHB18 Muxed18 ready signal18

  
  output [31:0]            smc_hrdata18;    // smc18 read data back to AHB18 master18
  output                   smc_hready18;    // smc18 ready signal18
  output [1:0]             smc_hresp18;     // AHB18 Response18 signal18
  output                   smc_valid18;     // Ack18 valid address

//External18 memory interface (EMI18)

  output [31:0]            smc_addr18;      // External18 Memory (EMI18) address
  output [31:0]            smc_data18;      // EMI18 write data
  input  [31:0]            data_smc18;      // EMI18 read data
  output [3:0]             smc_n_be18;      // EMI18 byte enables18 (Active18 LOW18)
  output             smc_n_cs18;      // EMI18 Chip18 Selects18 (Active18 LOW18)
  output [3:0]             smc_n_we18;      // EMI18 write strobes18 (Active18 LOW18)
  output                   smc_n_wr18;      // EMI18 write enable (Active18 LOW18)
  output                   smc_n_rd18;      // EMI18 read stobe18 (Active18 LOW18)
  output 	           smc_n_ext_oe18;  // EMI18 write data output enable

//AHB18 Memory Interface18 Control18

   output                   smc_busy18;      // smc18 busy

   
   


//scan18 signals18

   input                  scan_in_118;        //scan18 input
   input                  scan_in_218;        //scan18 input
   input                  scan_en18;         //scan18 enable
   output                 scan_out_118;       //scan18 output
   output                 scan_out_218;       //scan18 output
// third18 scan18 chain18 only used on INCLUDE_APB18
   input                  scan_in_318;        //scan18 input
   output                 scan_out_318;       //scan18 output
   
//----------------------------------------------------------------------
// Signal18 declarations18
//----------------------------------------------------------------------

// Bus18 Interface18
   
  wire  [31:0]   smc_hrdata18;         //smc18 read data back to AHB18 master18
  wire           smc_hready18;         //smc18 ready signal18
  wire  [1:0]    smc_hresp18;          //AHB18 Response18 signal18
  wire           smc_valid18;          //Ack18 valid address

// MAC18

  wire [31:0]    smc_data18;           //Data to external18 bus via MUX18

// Strobe18 Generation18

  wire           smc_n_wr18;           //EMI18 write enable (Active18 LOW18)
  wire  [3:0]    smc_n_we18;           //EMI18 write strobes18 (Active18 LOW18)
  wire           smc_n_rd18;           //EMI18 read stobe18 (Active18 LOW18)
  wire           smc_busy18;           //smc18 busy
  wire           smc_n_ext_oe18;       //Enable18 External18 bus drivers18.(CS18 & !RD18)

// Address Generation18

  wire [31:0]    smc_addr18;           //External18 Memory Interface18(EMI18) address
  wire [3:0]     smc_n_be18;   //EMI18 byte enables18 (Active18 LOW18)
  wire      smc_n_cs18;   //EMI18 Chip18 Selects18 (Active18 LOW18)

// Bus18 Interface18

  wire           new_access18;         // New18 AHB18 access to smc18 detected
  wire [31:0]    addr;               // Copy18 of address
  wire [31:0]    write_data18;         // Data to External18 Bus18
  wire      cs;         // Chip18(bank18) Select18 Lines18
  wire [1:0]     xfer_size18;          // Width18 of current transfer18
  wire           n_read18;             // Active18 low18 read signal18                   
  
// Configuration18 Block


// Counters18

  wire [1:0]     r_csle_count18;       // Chip18 select18 LE18 counter
  wire [1:0]     r_wele_count18;       // Write counter
  wire [1:0]     r_cste_count18;       // chip18 select18 TE18 counter
  wire [7:0]     r_ws_count18; // Wait18 state select18 counter
  
// These18 strobes18 finish early18 so no counter is required18. The stored18 value
// is compared with WS18 counter to determine18 when the strobe18 should end.

  wire [1:0]     r_wete_store18;       // Write strobe18 TE18 end time before CS18
  wire [1:0]     r_oete_store18;       // Read strobe18 TE18 end time before CS18
  
// The following18 four18 wireisrers18 are used to store18 the configuration during
// mulitple18 accesses. The counters18 are reloaded18 from these18 wireisters18
//  before each cycle.

  wire [1:0]     r_csle_store18;       // Chip18 select18 LE18 store18
  wire [1:0]     r_wele_store18;       // Write strobe18 LE18 store18
  wire [7:0]     r_ws_store18;         // Wait18 state store18
  wire [1:0]     r_cste_store18;       // Chip18 Select18 TE18 delay (Bus18 float18 time)


// Multiple18 access control18

  wire           mac_done18;           // Indicates18 last cycle of last access
  wire [1:0]     r_num_access18;       // Access counter
  wire [1:0]     v_xfer_size18;        // Store18 size for MAC18 
  wire [1:0]     v_bus_size18;         // Store18 size for MAC18
  wire [31:0]    read_data18;          // Data path to bus IF
  wire [31:0]    r_read_data18;        // Internal data store18

// smc18 state machine18


  wire           valid_access18;       // New18 acces18 can proceed
  wire   [4:0]   smc_nextstate18;      // state machine18 (async18 encoding18)
  wire   [4:0]   r_smc_currentstate18; // Synchronised18 smc18 state machine18
  wire           ws_enable18;          // Wait18 state counter enable
  wire           cste_enable18;        // Chip18 select18 counter enable
  wire           smc_done18;           // Asserted18 during last cycle of
                                     //    an access
  wire           le_enable18;          // Start18 counters18 after STORED18 
                                     //    access
  wire           latch_data18;         // latch_data18 is used by the MAC18 
                                     //    block to store18 read data 
                                     //    if CSTE18 > 0
  wire           smc_idle18;           // idle18 state

// Address Generation18

  wire [3:0]     n_be18;               // Full cycle write strobe18

// Strobe18 Generation18

  wire           r_full18;             // Full cycle write strobe18
  wire           n_r_read18;           // Store18 RW srate18 for multiple accesses
  wire           n_r_wr18;             // write strobe18
  wire [3:0]     n_r_we18;             // write enable  
  wire      r_cs18;       // registered chip18 select18 

   //apb18
   

   wire n_sys_reset18;                        //AHB18 system reset(active low18)

// assign a default value to the signal18 if the bank18 has
// been disabled and the APB18 has been excluded18 (i.e. the config signals18
// come18 from the top level
   
   smc_apb_lite_if18 i_apb_lite18 (
                     //Inputs18
                     
                     .n_preset18(n_preset18),
                     .pclk18(pclk18),
                     .psel18(psel18),
                     .penable18(penable18),
                     .pwrite18(pwrite18),
                     .paddr18(paddr18),
                     .pwdata18(pwdata18),
                     
                    //Outputs18
                     
                     .prdata18(prdata18)
                     
                     );
   
   smc_ahb_lite_if18 i_ahb_lite18  (
                     //Inputs18
                     
		     .hclk18 (hclk18),
                     .n_sys_reset18 (n_sys_reset18),
                     .haddr18 (haddr18),
                     .hsel18 (hsel18),                                                
                     .htrans18 (htrans18),                    
                     .hwrite18 (hwrite18),
                     .hsize18 (hsize18),                
                     .hwdata18 (hwdata18),
                     .hready18 (hready18),
                     .read_data18 (read_data18),
                     .mac_done18 (mac_done18),
                     .smc_done18 (smc_done18),
                     .smc_idle18 (smc_idle18),
                     
                     // Outputs18
                     
                     .xfer_size18 (xfer_size18),
                     .n_read18 (n_read18),
                     .new_access18 (new_access18),
                     .addr (addr),
                     .smc_hrdata18 (smc_hrdata18), 
                     .smc_hready18 (smc_hready18),
                     .smc_hresp18 (smc_hresp18),
                     .smc_valid18 (smc_valid18),
                     .cs (cs),
                     .write_data18 (write_data18)
                     );
   
   

   
   
   smc_counter_lite18 i_counter_lite18 (
                          
                          // Inputs18
                          
                          .sys_clk18 (hclk18),
                          .n_sys_reset18 (n_sys_reset18),
                          .valid_access18 (valid_access18),
                          .mac_done18 (mac_done18),
                          .smc_done18 (smc_done18),
                          .cste_enable18 (cste_enable18),
                          .ws_enable18 (ws_enable18),
                          .le_enable18 (le_enable18),
                          
                          // Outputs18
                          
                          .r_csle_store18 (r_csle_store18),
                          .r_csle_count18 (r_csle_count18),
                          .r_wele_count18 (r_wele_count18),
                          .r_ws_count18 (r_ws_count18),
                          .r_ws_store18 (r_ws_store18),
                          .r_oete_store18 (r_oete_store18),
                          .r_wete_store18 (r_wete_store18),
                          .r_wele_store18 (r_wele_store18),
                          .r_cste_count18 (r_cste_count18));
   
   
   smc_mac_lite18 i_mac_lite18         (
                          
                          // Inputs18
                          
                          .sys_clk18 (hclk18),
                          .n_sys_reset18 (n_sys_reset18),
                          .valid_access18 (valid_access18),
                          .xfer_size18 (xfer_size18),
                          .smc_done18 (smc_done18),
                          .data_smc18 (data_smc18),
                          .write_data18 (write_data18),
                          .smc_nextstate18 (smc_nextstate18),
                          .latch_data18 (latch_data18),
                          
                          // Outputs18
                          
                          .r_num_access18 (r_num_access18),
                          .mac_done18 (mac_done18),
                          .v_bus_size18 (v_bus_size18),
                          .v_xfer_size18 (v_xfer_size18),
                          .read_data18 (read_data18),
                          .smc_data18 (smc_data18));
   
   
   smc_state_lite18 i_state_lite18     (
                          
                          // Inputs18
                          
                          .sys_clk18 (hclk18),
                          .n_sys_reset18 (n_sys_reset18),
                          .new_access18 (new_access18),
                          .r_cste_count18 (r_cste_count18),
                          .r_csle_count18 (r_csle_count18),
                          .r_ws_count18 (r_ws_count18),
                          .mac_done18 (mac_done18),
                          .n_read18 (n_read18),
                          .n_r_read18 (n_r_read18),
                          .r_csle_store18 (r_csle_store18),
                          .r_oete_store18 (r_oete_store18),
                          .cs(cs),
                          .r_cs18(r_cs18),

                          // Outputs18
                          
                          .r_smc_currentstate18 (r_smc_currentstate18),
                          .smc_nextstate18 (smc_nextstate18),
                          .cste_enable18 (cste_enable18),
                          .ws_enable18 (ws_enable18),
                          .smc_done18 (smc_done18),
                          .valid_access18 (valid_access18),
                          .le_enable18 (le_enable18),
                          .latch_data18 (latch_data18),
                          .smc_idle18 (smc_idle18));
   
   smc_strobe_lite18 i_strobe_lite18   (

                          //inputs18

                          .sys_clk18 (hclk18),
                          .n_sys_reset18 (n_sys_reset18),
                          .valid_access18 (valid_access18),
                          .n_read18 (n_read18),
                          .cs(cs),
                          .r_smc_currentstate18 (r_smc_currentstate18),
                          .smc_nextstate18 (smc_nextstate18),
                          .n_be18 (n_be18),
                          .r_wele_store18 (r_wele_store18),
                          .r_wele_count18 (r_wele_count18),
                          .r_wete_store18 (r_wete_store18),
                          .r_oete_store18 (r_oete_store18),
                          .r_ws_count18 (r_ws_count18),
                          .r_ws_store18 (r_ws_store18),
                          .smc_done18 (smc_done18),
                          .mac_done18 (mac_done18),
                          
                          //outputs18

                          .smc_n_rd18 (smc_n_rd18),
                          .smc_n_ext_oe18 (smc_n_ext_oe18),
                          .smc_busy18 (smc_busy18),
                          .n_r_read18 (n_r_read18),
                          .r_cs18(r_cs18),
                          .r_full18 (r_full18),
                          .n_r_we18 (n_r_we18),
                          .n_r_wr18 (n_r_wr18));
   
   smc_wr_enable_lite18 i_wr_enable_lite18 (

                            //inputs18

                          .n_sys_reset18 (n_sys_reset18),
                          .r_full18(r_full18),
                          .n_r_we18(n_r_we18),
                          .n_r_wr18 (n_r_wr18),
                              
                          //output                

                          .smc_n_we18(smc_n_we18),
                          .smc_n_wr18 (smc_n_wr18));
   
   
   
   smc_addr_lite18 i_add_lite18        (
                          //inputs18

                          .sys_clk18 (hclk18),
                          .n_sys_reset18 (n_sys_reset18),
                          .valid_access18 (valid_access18),
                          .r_num_access18 (r_num_access18),
                          .v_bus_size18 (v_bus_size18),
                          .v_xfer_size18 (v_xfer_size18),
                          .cs (cs),
                          .addr (addr),
                          .smc_done18 (smc_done18),
                          .smc_nextstate18 (smc_nextstate18),
                          
                          //outputs18

                          .smc_addr18 (smc_addr18),
                          .smc_n_be18 (smc_n_be18),
                          .smc_n_cs18 (smc_n_cs18),
                          .n_be18 (n_be18));
   
   
endmodule
