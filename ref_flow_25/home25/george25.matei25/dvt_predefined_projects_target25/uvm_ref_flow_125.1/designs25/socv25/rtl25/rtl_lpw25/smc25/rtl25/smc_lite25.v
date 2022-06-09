//File25 name   : smc_lite25.v
//Title25       : SMC25 top level
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

 `include "smc_defs_lite25.v"

//static memory controller25
module          smc_lite25(
                    //apb25 inputs25
                    n_preset25, 
                    pclk25, 
                    psel25, 
                    penable25, 
                    pwrite25, 
                    paddr25, 
                    pwdata25,
                    //ahb25 inputs25                    
                    hclk25,
                    n_sys_reset25,
                    haddr25,
                    htrans25,
                    hsel25,
                    hwrite25,
                    hsize25,
                    hwdata25,
                    hready25,
                    data_smc25,
                    

                    //test signal25 inputs25

                    scan_in_125,
                    scan_in_225,
                    scan_in_325,
                    scan_en25,

                    //apb25 outputs25                    
                    prdata25,

                    //design output
                    
                    smc_hrdata25, 
                    smc_hready25,
                    smc_valid25,
                    smc_hresp25,
                    smc_addr25,
                    smc_data25, 
                    smc_n_be25,
                    smc_n_cs25,
                    smc_n_wr25,                    
                    smc_n_we25,
                    smc_n_rd25,
                    smc_n_ext_oe25,
                    smc_busy25,

                    //test signal25 output

                    scan_out_125,
                    scan_out_225,
                    scan_out_325
                   );
// define parameters25
// change using defaparam25 statements25


  // APB25 Inputs25 (use is optional25 on INCLUDE_APB25)
  input        n_preset25;           // APBreset25 
  input        pclk25;               // APB25 clock25
  input        psel25;               // APB25 select25
  input        penable25;            // APB25 enable 
  input        pwrite25;             // APB25 write strobe25 
  input [4:0]  paddr25;              // APB25 address bus
  input [31:0] pwdata25;             // APB25 write data 

  // APB25 Output25 (use is optional25 on INCLUDE_APB25)

  output [31:0] prdata25;        //APB25 output



//System25 I25/O25

  input                    hclk25;          // AHB25 System25 clock25
  input                    n_sys_reset25;   // AHB25 System25 reset (Active25 LOW25)

//AHB25 I25/O25

  input  [31:0]            haddr25;         // AHB25 Address
  input  [1:0]             htrans25;        // AHB25 transfer25 type
  input               hsel25;          // chip25 selects25
  input                    hwrite25;        // AHB25 read/write indication25
  input  [2:0]             hsize25;         // AHB25 transfer25 size
  input  [31:0]            hwdata25;        // AHB25 write data
  input                    hready25;        // AHB25 Muxed25 ready signal25

  
  output [31:0]            smc_hrdata25;    // smc25 read data back to AHB25 master25
  output                   smc_hready25;    // smc25 ready signal25
  output [1:0]             smc_hresp25;     // AHB25 Response25 signal25
  output                   smc_valid25;     // Ack25 valid address

//External25 memory interface (EMI25)

  output [31:0]            smc_addr25;      // External25 Memory (EMI25) address
  output [31:0]            smc_data25;      // EMI25 write data
  input  [31:0]            data_smc25;      // EMI25 read data
  output [3:0]             smc_n_be25;      // EMI25 byte enables25 (Active25 LOW25)
  output             smc_n_cs25;      // EMI25 Chip25 Selects25 (Active25 LOW25)
  output [3:0]             smc_n_we25;      // EMI25 write strobes25 (Active25 LOW25)
  output                   smc_n_wr25;      // EMI25 write enable (Active25 LOW25)
  output                   smc_n_rd25;      // EMI25 read stobe25 (Active25 LOW25)
  output 	           smc_n_ext_oe25;  // EMI25 write data output enable

//AHB25 Memory Interface25 Control25

   output                   smc_busy25;      // smc25 busy

   
   


//scan25 signals25

   input                  scan_in_125;        //scan25 input
   input                  scan_in_225;        //scan25 input
   input                  scan_en25;         //scan25 enable
   output                 scan_out_125;       //scan25 output
   output                 scan_out_225;       //scan25 output
// third25 scan25 chain25 only used on INCLUDE_APB25
   input                  scan_in_325;        //scan25 input
   output                 scan_out_325;       //scan25 output
   
//----------------------------------------------------------------------
// Signal25 declarations25
//----------------------------------------------------------------------

// Bus25 Interface25
   
  wire  [31:0]   smc_hrdata25;         //smc25 read data back to AHB25 master25
  wire           smc_hready25;         //smc25 ready signal25
  wire  [1:0]    smc_hresp25;          //AHB25 Response25 signal25
  wire           smc_valid25;          //Ack25 valid address

// MAC25

  wire [31:0]    smc_data25;           //Data to external25 bus via MUX25

// Strobe25 Generation25

  wire           smc_n_wr25;           //EMI25 write enable (Active25 LOW25)
  wire  [3:0]    smc_n_we25;           //EMI25 write strobes25 (Active25 LOW25)
  wire           smc_n_rd25;           //EMI25 read stobe25 (Active25 LOW25)
  wire           smc_busy25;           //smc25 busy
  wire           smc_n_ext_oe25;       //Enable25 External25 bus drivers25.(CS25 & !RD25)

// Address Generation25

  wire [31:0]    smc_addr25;           //External25 Memory Interface25(EMI25) address
  wire [3:0]     smc_n_be25;   //EMI25 byte enables25 (Active25 LOW25)
  wire      smc_n_cs25;   //EMI25 Chip25 Selects25 (Active25 LOW25)

// Bus25 Interface25

  wire           new_access25;         // New25 AHB25 access to smc25 detected
  wire [31:0]    addr;               // Copy25 of address
  wire [31:0]    write_data25;         // Data to External25 Bus25
  wire      cs;         // Chip25(bank25) Select25 Lines25
  wire [1:0]     xfer_size25;          // Width25 of current transfer25
  wire           n_read25;             // Active25 low25 read signal25                   
  
// Configuration25 Block


// Counters25

  wire [1:0]     r_csle_count25;       // Chip25 select25 LE25 counter
  wire [1:0]     r_wele_count25;       // Write counter
  wire [1:0]     r_cste_count25;       // chip25 select25 TE25 counter
  wire [7:0]     r_ws_count25; // Wait25 state select25 counter
  
// These25 strobes25 finish early25 so no counter is required25. The stored25 value
// is compared with WS25 counter to determine25 when the strobe25 should end.

  wire [1:0]     r_wete_store25;       // Write strobe25 TE25 end time before CS25
  wire [1:0]     r_oete_store25;       // Read strobe25 TE25 end time before CS25
  
// The following25 four25 wireisrers25 are used to store25 the configuration during
// mulitple25 accesses. The counters25 are reloaded25 from these25 wireisters25
//  before each cycle.

  wire [1:0]     r_csle_store25;       // Chip25 select25 LE25 store25
  wire [1:0]     r_wele_store25;       // Write strobe25 LE25 store25
  wire [7:0]     r_ws_store25;         // Wait25 state store25
  wire [1:0]     r_cste_store25;       // Chip25 Select25 TE25 delay (Bus25 float25 time)


// Multiple25 access control25

  wire           mac_done25;           // Indicates25 last cycle of last access
  wire [1:0]     r_num_access25;       // Access counter
  wire [1:0]     v_xfer_size25;        // Store25 size for MAC25 
  wire [1:0]     v_bus_size25;         // Store25 size for MAC25
  wire [31:0]    read_data25;          // Data path to bus IF
  wire [31:0]    r_read_data25;        // Internal data store25

// smc25 state machine25


  wire           valid_access25;       // New25 acces25 can proceed
  wire   [4:0]   smc_nextstate25;      // state machine25 (async25 encoding25)
  wire   [4:0]   r_smc_currentstate25; // Synchronised25 smc25 state machine25
  wire           ws_enable25;          // Wait25 state counter enable
  wire           cste_enable25;        // Chip25 select25 counter enable
  wire           smc_done25;           // Asserted25 during last cycle of
                                     //    an access
  wire           le_enable25;          // Start25 counters25 after STORED25 
                                     //    access
  wire           latch_data25;         // latch_data25 is used by the MAC25 
                                     //    block to store25 read data 
                                     //    if CSTE25 > 0
  wire           smc_idle25;           // idle25 state

// Address Generation25

  wire [3:0]     n_be25;               // Full cycle write strobe25

// Strobe25 Generation25

  wire           r_full25;             // Full cycle write strobe25
  wire           n_r_read25;           // Store25 RW srate25 for multiple accesses
  wire           n_r_wr25;             // write strobe25
  wire [3:0]     n_r_we25;             // write enable  
  wire      r_cs25;       // registered chip25 select25 

   //apb25
   

   wire n_sys_reset25;                        //AHB25 system reset(active low25)

// assign a default value to the signal25 if the bank25 has
// been disabled and the APB25 has been excluded25 (i.e. the config signals25
// come25 from the top level
   
   smc_apb_lite_if25 i_apb_lite25 (
                     //Inputs25
                     
                     .n_preset25(n_preset25),
                     .pclk25(pclk25),
                     .psel25(psel25),
                     .penable25(penable25),
                     .pwrite25(pwrite25),
                     .paddr25(paddr25),
                     .pwdata25(pwdata25),
                     
                    //Outputs25
                     
                     .prdata25(prdata25)
                     
                     );
   
   smc_ahb_lite_if25 i_ahb_lite25  (
                     //Inputs25
                     
		     .hclk25 (hclk25),
                     .n_sys_reset25 (n_sys_reset25),
                     .haddr25 (haddr25),
                     .hsel25 (hsel25),                                                
                     .htrans25 (htrans25),                    
                     .hwrite25 (hwrite25),
                     .hsize25 (hsize25),                
                     .hwdata25 (hwdata25),
                     .hready25 (hready25),
                     .read_data25 (read_data25),
                     .mac_done25 (mac_done25),
                     .smc_done25 (smc_done25),
                     .smc_idle25 (smc_idle25),
                     
                     // Outputs25
                     
                     .xfer_size25 (xfer_size25),
                     .n_read25 (n_read25),
                     .new_access25 (new_access25),
                     .addr (addr),
                     .smc_hrdata25 (smc_hrdata25), 
                     .smc_hready25 (smc_hready25),
                     .smc_hresp25 (smc_hresp25),
                     .smc_valid25 (smc_valid25),
                     .cs (cs),
                     .write_data25 (write_data25)
                     );
   
   

   
   
   smc_counter_lite25 i_counter_lite25 (
                          
                          // Inputs25
                          
                          .sys_clk25 (hclk25),
                          .n_sys_reset25 (n_sys_reset25),
                          .valid_access25 (valid_access25),
                          .mac_done25 (mac_done25),
                          .smc_done25 (smc_done25),
                          .cste_enable25 (cste_enable25),
                          .ws_enable25 (ws_enable25),
                          .le_enable25 (le_enable25),
                          
                          // Outputs25
                          
                          .r_csle_store25 (r_csle_store25),
                          .r_csle_count25 (r_csle_count25),
                          .r_wele_count25 (r_wele_count25),
                          .r_ws_count25 (r_ws_count25),
                          .r_ws_store25 (r_ws_store25),
                          .r_oete_store25 (r_oete_store25),
                          .r_wete_store25 (r_wete_store25),
                          .r_wele_store25 (r_wele_store25),
                          .r_cste_count25 (r_cste_count25));
   
   
   smc_mac_lite25 i_mac_lite25         (
                          
                          // Inputs25
                          
                          .sys_clk25 (hclk25),
                          .n_sys_reset25 (n_sys_reset25),
                          .valid_access25 (valid_access25),
                          .xfer_size25 (xfer_size25),
                          .smc_done25 (smc_done25),
                          .data_smc25 (data_smc25),
                          .write_data25 (write_data25),
                          .smc_nextstate25 (smc_nextstate25),
                          .latch_data25 (latch_data25),
                          
                          // Outputs25
                          
                          .r_num_access25 (r_num_access25),
                          .mac_done25 (mac_done25),
                          .v_bus_size25 (v_bus_size25),
                          .v_xfer_size25 (v_xfer_size25),
                          .read_data25 (read_data25),
                          .smc_data25 (smc_data25));
   
   
   smc_state_lite25 i_state_lite25     (
                          
                          // Inputs25
                          
                          .sys_clk25 (hclk25),
                          .n_sys_reset25 (n_sys_reset25),
                          .new_access25 (new_access25),
                          .r_cste_count25 (r_cste_count25),
                          .r_csle_count25 (r_csle_count25),
                          .r_ws_count25 (r_ws_count25),
                          .mac_done25 (mac_done25),
                          .n_read25 (n_read25),
                          .n_r_read25 (n_r_read25),
                          .r_csle_store25 (r_csle_store25),
                          .r_oete_store25 (r_oete_store25),
                          .cs(cs),
                          .r_cs25(r_cs25),

                          // Outputs25
                          
                          .r_smc_currentstate25 (r_smc_currentstate25),
                          .smc_nextstate25 (smc_nextstate25),
                          .cste_enable25 (cste_enable25),
                          .ws_enable25 (ws_enable25),
                          .smc_done25 (smc_done25),
                          .valid_access25 (valid_access25),
                          .le_enable25 (le_enable25),
                          .latch_data25 (latch_data25),
                          .smc_idle25 (smc_idle25));
   
   smc_strobe_lite25 i_strobe_lite25   (

                          //inputs25

                          .sys_clk25 (hclk25),
                          .n_sys_reset25 (n_sys_reset25),
                          .valid_access25 (valid_access25),
                          .n_read25 (n_read25),
                          .cs(cs),
                          .r_smc_currentstate25 (r_smc_currentstate25),
                          .smc_nextstate25 (smc_nextstate25),
                          .n_be25 (n_be25),
                          .r_wele_store25 (r_wele_store25),
                          .r_wele_count25 (r_wele_count25),
                          .r_wete_store25 (r_wete_store25),
                          .r_oete_store25 (r_oete_store25),
                          .r_ws_count25 (r_ws_count25),
                          .r_ws_store25 (r_ws_store25),
                          .smc_done25 (smc_done25),
                          .mac_done25 (mac_done25),
                          
                          //outputs25

                          .smc_n_rd25 (smc_n_rd25),
                          .smc_n_ext_oe25 (smc_n_ext_oe25),
                          .smc_busy25 (smc_busy25),
                          .n_r_read25 (n_r_read25),
                          .r_cs25(r_cs25),
                          .r_full25 (r_full25),
                          .n_r_we25 (n_r_we25),
                          .n_r_wr25 (n_r_wr25));
   
   smc_wr_enable_lite25 i_wr_enable_lite25 (

                            //inputs25

                          .n_sys_reset25 (n_sys_reset25),
                          .r_full25(r_full25),
                          .n_r_we25(n_r_we25),
                          .n_r_wr25 (n_r_wr25),
                              
                          //output                

                          .smc_n_we25(smc_n_we25),
                          .smc_n_wr25 (smc_n_wr25));
   
   
   
   smc_addr_lite25 i_add_lite25        (
                          //inputs25

                          .sys_clk25 (hclk25),
                          .n_sys_reset25 (n_sys_reset25),
                          .valid_access25 (valid_access25),
                          .r_num_access25 (r_num_access25),
                          .v_bus_size25 (v_bus_size25),
                          .v_xfer_size25 (v_xfer_size25),
                          .cs (cs),
                          .addr (addr),
                          .smc_done25 (smc_done25),
                          .smc_nextstate25 (smc_nextstate25),
                          
                          //outputs25

                          .smc_addr25 (smc_addr25),
                          .smc_n_be25 (smc_n_be25),
                          .smc_n_cs25 (smc_n_cs25),
                          .n_be25 (n_be25));
   
   
endmodule
