//File30 name   : smc_lite30.v
//Title30       : SMC30 top level
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

 `include "smc_defs_lite30.v"

//static memory controller30
module          smc_lite30(
                    //apb30 inputs30
                    n_preset30, 
                    pclk30, 
                    psel30, 
                    penable30, 
                    pwrite30, 
                    paddr30, 
                    pwdata30,
                    //ahb30 inputs30                    
                    hclk30,
                    n_sys_reset30,
                    haddr30,
                    htrans30,
                    hsel30,
                    hwrite30,
                    hsize30,
                    hwdata30,
                    hready30,
                    data_smc30,
                    

                    //test signal30 inputs30

                    scan_in_130,
                    scan_in_230,
                    scan_in_330,
                    scan_en30,

                    //apb30 outputs30                    
                    prdata30,

                    //design output
                    
                    smc_hrdata30, 
                    smc_hready30,
                    smc_valid30,
                    smc_hresp30,
                    smc_addr30,
                    smc_data30, 
                    smc_n_be30,
                    smc_n_cs30,
                    smc_n_wr30,                    
                    smc_n_we30,
                    smc_n_rd30,
                    smc_n_ext_oe30,
                    smc_busy30,

                    //test signal30 output

                    scan_out_130,
                    scan_out_230,
                    scan_out_330
                   );
// define parameters30
// change using defaparam30 statements30


  // APB30 Inputs30 (use is optional30 on INCLUDE_APB30)
  input        n_preset30;           // APBreset30 
  input        pclk30;               // APB30 clock30
  input        psel30;               // APB30 select30
  input        penable30;            // APB30 enable 
  input        pwrite30;             // APB30 write strobe30 
  input [4:0]  paddr30;              // APB30 address bus
  input [31:0] pwdata30;             // APB30 write data 

  // APB30 Output30 (use is optional30 on INCLUDE_APB30)

  output [31:0] prdata30;        //APB30 output



//System30 I30/O30

  input                    hclk30;          // AHB30 System30 clock30
  input                    n_sys_reset30;   // AHB30 System30 reset (Active30 LOW30)

//AHB30 I30/O30

  input  [31:0]            haddr30;         // AHB30 Address
  input  [1:0]             htrans30;        // AHB30 transfer30 type
  input               hsel30;          // chip30 selects30
  input                    hwrite30;        // AHB30 read/write indication30
  input  [2:0]             hsize30;         // AHB30 transfer30 size
  input  [31:0]            hwdata30;        // AHB30 write data
  input                    hready30;        // AHB30 Muxed30 ready signal30

  
  output [31:0]            smc_hrdata30;    // smc30 read data back to AHB30 master30
  output                   smc_hready30;    // smc30 ready signal30
  output [1:0]             smc_hresp30;     // AHB30 Response30 signal30
  output                   smc_valid30;     // Ack30 valid address

//External30 memory interface (EMI30)

  output [31:0]            smc_addr30;      // External30 Memory (EMI30) address
  output [31:0]            smc_data30;      // EMI30 write data
  input  [31:0]            data_smc30;      // EMI30 read data
  output [3:0]             smc_n_be30;      // EMI30 byte enables30 (Active30 LOW30)
  output             smc_n_cs30;      // EMI30 Chip30 Selects30 (Active30 LOW30)
  output [3:0]             smc_n_we30;      // EMI30 write strobes30 (Active30 LOW30)
  output                   smc_n_wr30;      // EMI30 write enable (Active30 LOW30)
  output                   smc_n_rd30;      // EMI30 read stobe30 (Active30 LOW30)
  output 	           smc_n_ext_oe30;  // EMI30 write data output enable

//AHB30 Memory Interface30 Control30

   output                   smc_busy30;      // smc30 busy

   
   


//scan30 signals30

   input                  scan_in_130;        //scan30 input
   input                  scan_in_230;        //scan30 input
   input                  scan_en30;         //scan30 enable
   output                 scan_out_130;       //scan30 output
   output                 scan_out_230;       //scan30 output
// third30 scan30 chain30 only used on INCLUDE_APB30
   input                  scan_in_330;        //scan30 input
   output                 scan_out_330;       //scan30 output
   
//----------------------------------------------------------------------
// Signal30 declarations30
//----------------------------------------------------------------------

// Bus30 Interface30
   
  wire  [31:0]   smc_hrdata30;         //smc30 read data back to AHB30 master30
  wire           smc_hready30;         //smc30 ready signal30
  wire  [1:0]    smc_hresp30;          //AHB30 Response30 signal30
  wire           smc_valid30;          //Ack30 valid address

// MAC30

  wire [31:0]    smc_data30;           //Data to external30 bus via MUX30

// Strobe30 Generation30

  wire           smc_n_wr30;           //EMI30 write enable (Active30 LOW30)
  wire  [3:0]    smc_n_we30;           //EMI30 write strobes30 (Active30 LOW30)
  wire           smc_n_rd30;           //EMI30 read stobe30 (Active30 LOW30)
  wire           smc_busy30;           //smc30 busy
  wire           smc_n_ext_oe30;       //Enable30 External30 bus drivers30.(CS30 & !RD30)

// Address Generation30

  wire [31:0]    smc_addr30;           //External30 Memory Interface30(EMI30) address
  wire [3:0]     smc_n_be30;   //EMI30 byte enables30 (Active30 LOW30)
  wire      smc_n_cs30;   //EMI30 Chip30 Selects30 (Active30 LOW30)

// Bus30 Interface30

  wire           new_access30;         // New30 AHB30 access to smc30 detected
  wire [31:0]    addr;               // Copy30 of address
  wire [31:0]    write_data30;         // Data to External30 Bus30
  wire      cs;         // Chip30(bank30) Select30 Lines30
  wire [1:0]     xfer_size30;          // Width30 of current transfer30
  wire           n_read30;             // Active30 low30 read signal30                   
  
// Configuration30 Block


// Counters30

  wire [1:0]     r_csle_count30;       // Chip30 select30 LE30 counter
  wire [1:0]     r_wele_count30;       // Write counter
  wire [1:0]     r_cste_count30;       // chip30 select30 TE30 counter
  wire [7:0]     r_ws_count30; // Wait30 state select30 counter
  
// These30 strobes30 finish early30 so no counter is required30. The stored30 value
// is compared with WS30 counter to determine30 when the strobe30 should end.

  wire [1:0]     r_wete_store30;       // Write strobe30 TE30 end time before CS30
  wire [1:0]     r_oete_store30;       // Read strobe30 TE30 end time before CS30
  
// The following30 four30 wireisrers30 are used to store30 the configuration during
// mulitple30 accesses. The counters30 are reloaded30 from these30 wireisters30
//  before each cycle.

  wire [1:0]     r_csle_store30;       // Chip30 select30 LE30 store30
  wire [1:0]     r_wele_store30;       // Write strobe30 LE30 store30
  wire [7:0]     r_ws_store30;         // Wait30 state store30
  wire [1:0]     r_cste_store30;       // Chip30 Select30 TE30 delay (Bus30 float30 time)


// Multiple30 access control30

  wire           mac_done30;           // Indicates30 last cycle of last access
  wire [1:0]     r_num_access30;       // Access counter
  wire [1:0]     v_xfer_size30;        // Store30 size for MAC30 
  wire [1:0]     v_bus_size30;         // Store30 size for MAC30
  wire [31:0]    read_data30;          // Data path to bus IF
  wire [31:0]    r_read_data30;        // Internal data store30

// smc30 state machine30


  wire           valid_access30;       // New30 acces30 can proceed
  wire   [4:0]   smc_nextstate30;      // state machine30 (async30 encoding30)
  wire   [4:0]   r_smc_currentstate30; // Synchronised30 smc30 state machine30
  wire           ws_enable30;          // Wait30 state counter enable
  wire           cste_enable30;        // Chip30 select30 counter enable
  wire           smc_done30;           // Asserted30 during last cycle of
                                     //    an access
  wire           le_enable30;          // Start30 counters30 after STORED30 
                                     //    access
  wire           latch_data30;         // latch_data30 is used by the MAC30 
                                     //    block to store30 read data 
                                     //    if CSTE30 > 0
  wire           smc_idle30;           // idle30 state

// Address Generation30

  wire [3:0]     n_be30;               // Full cycle write strobe30

// Strobe30 Generation30

  wire           r_full30;             // Full cycle write strobe30
  wire           n_r_read30;           // Store30 RW srate30 for multiple accesses
  wire           n_r_wr30;             // write strobe30
  wire [3:0]     n_r_we30;             // write enable  
  wire      r_cs30;       // registered chip30 select30 

   //apb30
   

   wire n_sys_reset30;                        //AHB30 system reset(active low30)

// assign a default value to the signal30 if the bank30 has
// been disabled and the APB30 has been excluded30 (i.e. the config signals30
// come30 from the top level
   
   smc_apb_lite_if30 i_apb_lite30 (
                     //Inputs30
                     
                     .n_preset30(n_preset30),
                     .pclk30(pclk30),
                     .psel30(psel30),
                     .penable30(penable30),
                     .pwrite30(pwrite30),
                     .paddr30(paddr30),
                     .pwdata30(pwdata30),
                     
                    //Outputs30
                     
                     .prdata30(prdata30)
                     
                     );
   
   smc_ahb_lite_if30 i_ahb_lite30  (
                     //Inputs30
                     
		     .hclk30 (hclk30),
                     .n_sys_reset30 (n_sys_reset30),
                     .haddr30 (haddr30),
                     .hsel30 (hsel30),                                                
                     .htrans30 (htrans30),                    
                     .hwrite30 (hwrite30),
                     .hsize30 (hsize30),                
                     .hwdata30 (hwdata30),
                     .hready30 (hready30),
                     .read_data30 (read_data30),
                     .mac_done30 (mac_done30),
                     .smc_done30 (smc_done30),
                     .smc_idle30 (smc_idle30),
                     
                     // Outputs30
                     
                     .xfer_size30 (xfer_size30),
                     .n_read30 (n_read30),
                     .new_access30 (new_access30),
                     .addr (addr),
                     .smc_hrdata30 (smc_hrdata30), 
                     .smc_hready30 (smc_hready30),
                     .smc_hresp30 (smc_hresp30),
                     .smc_valid30 (smc_valid30),
                     .cs (cs),
                     .write_data30 (write_data30)
                     );
   
   

   
   
   smc_counter_lite30 i_counter_lite30 (
                          
                          // Inputs30
                          
                          .sys_clk30 (hclk30),
                          .n_sys_reset30 (n_sys_reset30),
                          .valid_access30 (valid_access30),
                          .mac_done30 (mac_done30),
                          .smc_done30 (smc_done30),
                          .cste_enable30 (cste_enable30),
                          .ws_enable30 (ws_enable30),
                          .le_enable30 (le_enable30),
                          
                          // Outputs30
                          
                          .r_csle_store30 (r_csle_store30),
                          .r_csle_count30 (r_csle_count30),
                          .r_wele_count30 (r_wele_count30),
                          .r_ws_count30 (r_ws_count30),
                          .r_ws_store30 (r_ws_store30),
                          .r_oete_store30 (r_oete_store30),
                          .r_wete_store30 (r_wete_store30),
                          .r_wele_store30 (r_wele_store30),
                          .r_cste_count30 (r_cste_count30));
   
   
   smc_mac_lite30 i_mac_lite30         (
                          
                          // Inputs30
                          
                          .sys_clk30 (hclk30),
                          .n_sys_reset30 (n_sys_reset30),
                          .valid_access30 (valid_access30),
                          .xfer_size30 (xfer_size30),
                          .smc_done30 (smc_done30),
                          .data_smc30 (data_smc30),
                          .write_data30 (write_data30),
                          .smc_nextstate30 (smc_nextstate30),
                          .latch_data30 (latch_data30),
                          
                          // Outputs30
                          
                          .r_num_access30 (r_num_access30),
                          .mac_done30 (mac_done30),
                          .v_bus_size30 (v_bus_size30),
                          .v_xfer_size30 (v_xfer_size30),
                          .read_data30 (read_data30),
                          .smc_data30 (smc_data30));
   
   
   smc_state_lite30 i_state_lite30     (
                          
                          // Inputs30
                          
                          .sys_clk30 (hclk30),
                          .n_sys_reset30 (n_sys_reset30),
                          .new_access30 (new_access30),
                          .r_cste_count30 (r_cste_count30),
                          .r_csle_count30 (r_csle_count30),
                          .r_ws_count30 (r_ws_count30),
                          .mac_done30 (mac_done30),
                          .n_read30 (n_read30),
                          .n_r_read30 (n_r_read30),
                          .r_csle_store30 (r_csle_store30),
                          .r_oete_store30 (r_oete_store30),
                          .cs(cs),
                          .r_cs30(r_cs30),

                          // Outputs30
                          
                          .r_smc_currentstate30 (r_smc_currentstate30),
                          .smc_nextstate30 (smc_nextstate30),
                          .cste_enable30 (cste_enable30),
                          .ws_enable30 (ws_enable30),
                          .smc_done30 (smc_done30),
                          .valid_access30 (valid_access30),
                          .le_enable30 (le_enable30),
                          .latch_data30 (latch_data30),
                          .smc_idle30 (smc_idle30));
   
   smc_strobe_lite30 i_strobe_lite30   (

                          //inputs30

                          .sys_clk30 (hclk30),
                          .n_sys_reset30 (n_sys_reset30),
                          .valid_access30 (valid_access30),
                          .n_read30 (n_read30),
                          .cs(cs),
                          .r_smc_currentstate30 (r_smc_currentstate30),
                          .smc_nextstate30 (smc_nextstate30),
                          .n_be30 (n_be30),
                          .r_wele_store30 (r_wele_store30),
                          .r_wele_count30 (r_wele_count30),
                          .r_wete_store30 (r_wete_store30),
                          .r_oete_store30 (r_oete_store30),
                          .r_ws_count30 (r_ws_count30),
                          .r_ws_store30 (r_ws_store30),
                          .smc_done30 (smc_done30),
                          .mac_done30 (mac_done30),
                          
                          //outputs30

                          .smc_n_rd30 (smc_n_rd30),
                          .smc_n_ext_oe30 (smc_n_ext_oe30),
                          .smc_busy30 (smc_busy30),
                          .n_r_read30 (n_r_read30),
                          .r_cs30(r_cs30),
                          .r_full30 (r_full30),
                          .n_r_we30 (n_r_we30),
                          .n_r_wr30 (n_r_wr30));
   
   smc_wr_enable_lite30 i_wr_enable_lite30 (

                            //inputs30

                          .n_sys_reset30 (n_sys_reset30),
                          .r_full30(r_full30),
                          .n_r_we30(n_r_we30),
                          .n_r_wr30 (n_r_wr30),
                              
                          //output                

                          .smc_n_we30(smc_n_we30),
                          .smc_n_wr30 (smc_n_wr30));
   
   
   
   smc_addr_lite30 i_add_lite30        (
                          //inputs30

                          .sys_clk30 (hclk30),
                          .n_sys_reset30 (n_sys_reset30),
                          .valid_access30 (valid_access30),
                          .r_num_access30 (r_num_access30),
                          .v_bus_size30 (v_bus_size30),
                          .v_xfer_size30 (v_xfer_size30),
                          .cs (cs),
                          .addr (addr),
                          .smc_done30 (smc_done30),
                          .smc_nextstate30 (smc_nextstate30),
                          
                          //outputs30

                          .smc_addr30 (smc_addr30),
                          .smc_n_be30 (smc_n_be30),
                          .smc_n_cs30 (smc_n_cs30),
                          .n_be30 (n_be30));
   
   
endmodule
