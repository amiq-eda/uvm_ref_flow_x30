//File19 name   : smc_lite19.v
//Title19       : SMC19 top level
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

 `include "smc_defs_lite19.v"

//static memory controller19
module          smc_lite19(
                    //apb19 inputs19
                    n_preset19, 
                    pclk19, 
                    psel19, 
                    penable19, 
                    pwrite19, 
                    paddr19, 
                    pwdata19,
                    //ahb19 inputs19                    
                    hclk19,
                    n_sys_reset19,
                    haddr19,
                    htrans19,
                    hsel19,
                    hwrite19,
                    hsize19,
                    hwdata19,
                    hready19,
                    data_smc19,
                    

                    //test signal19 inputs19

                    scan_in_119,
                    scan_in_219,
                    scan_in_319,
                    scan_en19,

                    //apb19 outputs19                    
                    prdata19,

                    //design output
                    
                    smc_hrdata19, 
                    smc_hready19,
                    smc_valid19,
                    smc_hresp19,
                    smc_addr19,
                    smc_data19, 
                    smc_n_be19,
                    smc_n_cs19,
                    smc_n_wr19,                    
                    smc_n_we19,
                    smc_n_rd19,
                    smc_n_ext_oe19,
                    smc_busy19,

                    //test signal19 output

                    scan_out_119,
                    scan_out_219,
                    scan_out_319
                   );
// define parameters19
// change using defaparam19 statements19


  // APB19 Inputs19 (use is optional19 on INCLUDE_APB19)
  input        n_preset19;           // APBreset19 
  input        pclk19;               // APB19 clock19
  input        psel19;               // APB19 select19
  input        penable19;            // APB19 enable 
  input        pwrite19;             // APB19 write strobe19 
  input [4:0]  paddr19;              // APB19 address bus
  input [31:0] pwdata19;             // APB19 write data 

  // APB19 Output19 (use is optional19 on INCLUDE_APB19)

  output [31:0] prdata19;        //APB19 output



//System19 I19/O19

  input                    hclk19;          // AHB19 System19 clock19
  input                    n_sys_reset19;   // AHB19 System19 reset (Active19 LOW19)

//AHB19 I19/O19

  input  [31:0]            haddr19;         // AHB19 Address
  input  [1:0]             htrans19;        // AHB19 transfer19 type
  input               hsel19;          // chip19 selects19
  input                    hwrite19;        // AHB19 read/write indication19
  input  [2:0]             hsize19;         // AHB19 transfer19 size
  input  [31:0]            hwdata19;        // AHB19 write data
  input                    hready19;        // AHB19 Muxed19 ready signal19

  
  output [31:0]            smc_hrdata19;    // smc19 read data back to AHB19 master19
  output                   smc_hready19;    // smc19 ready signal19
  output [1:0]             smc_hresp19;     // AHB19 Response19 signal19
  output                   smc_valid19;     // Ack19 valid address

//External19 memory interface (EMI19)

  output [31:0]            smc_addr19;      // External19 Memory (EMI19) address
  output [31:0]            smc_data19;      // EMI19 write data
  input  [31:0]            data_smc19;      // EMI19 read data
  output [3:0]             smc_n_be19;      // EMI19 byte enables19 (Active19 LOW19)
  output             smc_n_cs19;      // EMI19 Chip19 Selects19 (Active19 LOW19)
  output [3:0]             smc_n_we19;      // EMI19 write strobes19 (Active19 LOW19)
  output                   smc_n_wr19;      // EMI19 write enable (Active19 LOW19)
  output                   smc_n_rd19;      // EMI19 read stobe19 (Active19 LOW19)
  output 	           smc_n_ext_oe19;  // EMI19 write data output enable

//AHB19 Memory Interface19 Control19

   output                   smc_busy19;      // smc19 busy

   
   


//scan19 signals19

   input                  scan_in_119;        //scan19 input
   input                  scan_in_219;        //scan19 input
   input                  scan_en19;         //scan19 enable
   output                 scan_out_119;       //scan19 output
   output                 scan_out_219;       //scan19 output
// third19 scan19 chain19 only used on INCLUDE_APB19
   input                  scan_in_319;        //scan19 input
   output                 scan_out_319;       //scan19 output
   
//----------------------------------------------------------------------
// Signal19 declarations19
//----------------------------------------------------------------------

// Bus19 Interface19
   
  wire  [31:0]   smc_hrdata19;         //smc19 read data back to AHB19 master19
  wire           smc_hready19;         //smc19 ready signal19
  wire  [1:0]    smc_hresp19;          //AHB19 Response19 signal19
  wire           smc_valid19;          //Ack19 valid address

// MAC19

  wire [31:0]    smc_data19;           //Data to external19 bus via MUX19

// Strobe19 Generation19

  wire           smc_n_wr19;           //EMI19 write enable (Active19 LOW19)
  wire  [3:0]    smc_n_we19;           //EMI19 write strobes19 (Active19 LOW19)
  wire           smc_n_rd19;           //EMI19 read stobe19 (Active19 LOW19)
  wire           smc_busy19;           //smc19 busy
  wire           smc_n_ext_oe19;       //Enable19 External19 bus drivers19.(CS19 & !RD19)

// Address Generation19

  wire [31:0]    smc_addr19;           //External19 Memory Interface19(EMI19) address
  wire [3:0]     smc_n_be19;   //EMI19 byte enables19 (Active19 LOW19)
  wire      smc_n_cs19;   //EMI19 Chip19 Selects19 (Active19 LOW19)

// Bus19 Interface19

  wire           new_access19;         // New19 AHB19 access to smc19 detected
  wire [31:0]    addr;               // Copy19 of address
  wire [31:0]    write_data19;         // Data to External19 Bus19
  wire      cs;         // Chip19(bank19) Select19 Lines19
  wire [1:0]     xfer_size19;          // Width19 of current transfer19
  wire           n_read19;             // Active19 low19 read signal19                   
  
// Configuration19 Block


// Counters19

  wire [1:0]     r_csle_count19;       // Chip19 select19 LE19 counter
  wire [1:0]     r_wele_count19;       // Write counter
  wire [1:0]     r_cste_count19;       // chip19 select19 TE19 counter
  wire [7:0]     r_ws_count19; // Wait19 state select19 counter
  
// These19 strobes19 finish early19 so no counter is required19. The stored19 value
// is compared with WS19 counter to determine19 when the strobe19 should end.

  wire [1:0]     r_wete_store19;       // Write strobe19 TE19 end time before CS19
  wire [1:0]     r_oete_store19;       // Read strobe19 TE19 end time before CS19
  
// The following19 four19 wireisrers19 are used to store19 the configuration during
// mulitple19 accesses. The counters19 are reloaded19 from these19 wireisters19
//  before each cycle.

  wire [1:0]     r_csle_store19;       // Chip19 select19 LE19 store19
  wire [1:0]     r_wele_store19;       // Write strobe19 LE19 store19
  wire [7:0]     r_ws_store19;         // Wait19 state store19
  wire [1:0]     r_cste_store19;       // Chip19 Select19 TE19 delay (Bus19 float19 time)


// Multiple19 access control19

  wire           mac_done19;           // Indicates19 last cycle of last access
  wire [1:0]     r_num_access19;       // Access counter
  wire [1:0]     v_xfer_size19;        // Store19 size for MAC19 
  wire [1:0]     v_bus_size19;         // Store19 size for MAC19
  wire [31:0]    read_data19;          // Data path to bus IF
  wire [31:0]    r_read_data19;        // Internal data store19

// smc19 state machine19


  wire           valid_access19;       // New19 acces19 can proceed
  wire   [4:0]   smc_nextstate19;      // state machine19 (async19 encoding19)
  wire   [4:0]   r_smc_currentstate19; // Synchronised19 smc19 state machine19
  wire           ws_enable19;          // Wait19 state counter enable
  wire           cste_enable19;        // Chip19 select19 counter enable
  wire           smc_done19;           // Asserted19 during last cycle of
                                     //    an access
  wire           le_enable19;          // Start19 counters19 after STORED19 
                                     //    access
  wire           latch_data19;         // latch_data19 is used by the MAC19 
                                     //    block to store19 read data 
                                     //    if CSTE19 > 0
  wire           smc_idle19;           // idle19 state

// Address Generation19

  wire [3:0]     n_be19;               // Full cycle write strobe19

// Strobe19 Generation19

  wire           r_full19;             // Full cycle write strobe19
  wire           n_r_read19;           // Store19 RW srate19 for multiple accesses
  wire           n_r_wr19;             // write strobe19
  wire [3:0]     n_r_we19;             // write enable  
  wire      r_cs19;       // registered chip19 select19 

   //apb19
   

   wire n_sys_reset19;                        //AHB19 system reset(active low19)

// assign a default value to the signal19 if the bank19 has
// been disabled and the APB19 has been excluded19 (i.e. the config signals19
// come19 from the top level
   
   smc_apb_lite_if19 i_apb_lite19 (
                     //Inputs19
                     
                     .n_preset19(n_preset19),
                     .pclk19(pclk19),
                     .psel19(psel19),
                     .penable19(penable19),
                     .pwrite19(pwrite19),
                     .paddr19(paddr19),
                     .pwdata19(pwdata19),
                     
                    //Outputs19
                     
                     .prdata19(prdata19)
                     
                     );
   
   smc_ahb_lite_if19 i_ahb_lite19  (
                     //Inputs19
                     
		     .hclk19 (hclk19),
                     .n_sys_reset19 (n_sys_reset19),
                     .haddr19 (haddr19),
                     .hsel19 (hsel19),                                                
                     .htrans19 (htrans19),                    
                     .hwrite19 (hwrite19),
                     .hsize19 (hsize19),                
                     .hwdata19 (hwdata19),
                     .hready19 (hready19),
                     .read_data19 (read_data19),
                     .mac_done19 (mac_done19),
                     .smc_done19 (smc_done19),
                     .smc_idle19 (smc_idle19),
                     
                     // Outputs19
                     
                     .xfer_size19 (xfer_size19),
                     .n_read19 (n_read19),
                     .new_access19 (new_access19),
                     .addr (addr),
                     .smc_hrdata19 (smc_hrdata19), 
                     .smc_hready19 (smc_hready19),
                     .smc_hresp19 (smc_hresp19),
                     .smc_valid19 (smc_valid19),
                     .cs (cs),
                     .write_data19 (write_data19)
                     );
   
   

   
   
   smc_counter_lite19 i_counter_lite19 (
                          
                          // Inputs19
                          
                          .sys_clk19 (hclk19),
                          .n_sys_reset19 (n_sys_reset19),
                          .valid_access19 (valid_access19),
                          .mac_done19 (mac_done19),
                          .smc_done19 (smc_done19),
                          .cste_enable19 (cste_enable19),
                          .ws_enable19 (ws_enable19),
                          .le_enable19 (le_enable19),
                          
                          // Outputs19
                          
                          .r_csle_store19 (r_csle_store19),
                          .r_csle_count19 (r_csle_count19),
                          .r_wele_count19 (r_wele_count19),
                          .r_ws_count19 (r_ws_count19),
                          .r_ws_store19 (r_ws_store19),
                          .r_oete_store19 (r_oete_store19),
                          .r_wete_store19 (r_wete_store19),
                          .r_wele_store19 (r_wele_store19),
                          .r_cste_count19 (r_cste_count19));
   
   
   smc_mac_lite19 i_mac_lite19         (
                          
                          // Inputs19
                          
                          .sys_clk19 (hclk19),
                          .n_sys_reset19 (n_sys_reset19),
                          .valid_access19 (valid_access19),
                          .xfer_size19 (xfer_size19),
                          .smc_done19 (smc_done19),
                          .data_smc19 (data_smc19),
                          .write_data19 (write_data19),
                          .smc_nextstate19 (smc_nextstate19),
                          .latch_data19 (latch_data19),
                          
                          // Outputs19
                          
                          .r_num_access19 (r_num_access19),
                          .mac_done19 (mac_done19),
                          .v_bus_size19 (v_bus_size19),
                          .v_xfer_size19 (v_xfer_size19),
                          .read_data19 (read_data19),
                          .smc_data19 (smc_data19));
   
   
   smc_state_lite19 i_state_lite19     (
                          
                          // Inputs19
                          
                          .sys_clk19 (hclk19),
                          .n_sys_reset19 (n_sys_reset19),
                          .new_access19 (new_access19),
                          .r_cste_count19 (r_cste_count19),
                          .r_csle_count19 (r_csle_count19),
                          .r_ws_count19 (r_ws_count19),
                          .mac_done19 (mac_done19),
                          .n_read19 (n_read19),
                          .n_r_read19 (n_r_read19),
                          .r_csle_store19 (r_csle_store19),
                          .r_oete_store19 (r_oete_store19),
                          .cs(cs),
                          .r_cs19(r_cs19),

                          // Outputs19
                          
                          .r_smc_currentstate19 (r_smc_currentstate19),
                          .smc_nextstate19 (smc_nextstate19),
                          .cste_enable19 (cste_enable19),
                          .ws_enable19 (ws_enable19),
                          .smc_done19 (smc_done19),
                          .valid_access19 (valid_access19),
                          .le_enable19 (le_enable19),
                          .latch_data19 (latch_data19),
                          .smc_idle19 (smc_idle19));
   
   smc_strobe_lite19 i_strobe_lite19   (

                          //inputs19

                          .sys_clk19 (hclk19),
                          .n_sys_reset19 (n_sys_reset19),
                          .valid_access19 (valid_access19),
                          .n_read19 (n_read19),
                          .cs(cs),
                          .r_smc_currentstate19 (r_smc_currentstate19),
                          .smc_nextstate19 (smc_nextstate19),
                          .n_be19 (n_be19),
                          .r_wele_store19 (r_wele_store19),
                          .r_wele_count19 (r_wele_count19),
                          .r_wete_store19 (r_wete_store19),
                          .r_oete_store19 (r_oete_store19),
                          .r_ws_count19 (r_ws_count19),
                          .r_ws_store19 (r_ws_store19),
                          .smc_done19 (smc_done19),
                          .mac_done19 (mac_done19),
                          
                          //outputs19

                          .smc_n_rd19 (smc_n_rd19),
                          .smc_n_ext_oe19 (smc_n_ext_oe19),
                          .smc_busy19 (smc_busy19),
                          .n_r_read19 (n_r_read19),
                          .r_cs19(r_cs19),
                          .r_full19 (r_full19),
                          .n_r_we19 (n_r_we19),
                          .n_r_wr19 (n_r_wr19));
   
   smc_wr_enable_lite19 i_wr_enable_lite19 (

                            //inputs19

                          .n_sys_reset19 (n_sys_reset19),
                          .r_full19(r_full19),
                          .n_r_we19(n_r_we19),
                          .n_r_wr19 (n_r_wr19),
                              
                          //output                

                          .smc_n_we19(smc_n_we19),
                          .smc_n_wr19 (smc_n_wr19));
   
   
   
   smc_addr_lite19 i_add_lite19        (
                          //inputs19

                          .sys_clk19 (hclk19),
                          .n_sys_reset19 (n_sys_reset19),
                          .valid_access19 (valid_access19),
                          .r_num_access19 (r_num_access19),
                          .v_bus_size19 (v_bus_size19),
                          .v_xfer_size19 (v_xfer_size19),
                          .cs (cs),
                          .addr (addr),
                          .smc_done19 (smc_done19),
                          .smc_nextstate19 (smc_nextstate19),
                          
                          //outputs19

                          .smc_addr19 (smc_addr19),
                          .smc_n_be19 (smc_n_be19),
                          .smc_n_cs19 (smc_n_cs19),
                          .n_be19 (n_be19));
   
   
endmodule
