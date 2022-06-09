//File13 name   : smc_lite13.v
//Title13       : SMC13 top level
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

 `include "smc_defs_lite13.v"

//static memory controller13
module          smc_lite13(
                    //apb13 inputs13
                    n_preset13, 
                    pclk13, 
                    psel13, 
                    penable13, 
                    pwrite13, 
                    paddr13, 
                    pwdata13,
                    //ahb13 inputs13                    
                    hclk13,
                    n_sys_reset13,
                    haddr13,
                    htrans13,
                    hsel13,
                    hwrite13,
                    hsize13,
                    hwdata13,
                    hready13,
                    data_smc13,
                    

                    //test signal13 inputs13

                    scan_in_113,
                    scan_in_213,
                    scan_in_313,
                    scan_en13,

                    //apb13 outputs13                    
                    prdata13,

                    //design output
                    
                    smc_hrdata13, 
                    smc_hready13,
                    smc_valid13,
                    smc_hresp13,
                    smc_addr13,
                    smc_data13, 
                    smc_n_be13,
                    smc_n_cs13,
                    smc_n_wr13,                    
                    smc_n_we13,
                    smc_n_rd13,
                    smc_n_ext_oe13,
                    smc_busy13,

                    //test signal13 output

                    scan_out_113,
                    scan_out_213,
                    scan_out_313
                   );
// define parameters13
// change using defaparam13 statements13


  // APB13 Inputs13 (use is optional13 on INCLUDE_APB13)
  input        n_preset13;           // APBreset13 
  input        pclk13;               // APB13 clock13
  input        psel13;               // APB13 select13
  input        penable13;            // APB13 enable 
  input        pwrite13;             // APB13 write strobe13 
  input [4:0]  paddr13;              // APB13 address bus
  input [31:0] pwdata13;             // APB13 write data 

  // APB13 Output13 (use is optional13 on INCLUDE_APB13)

  output [31:0] prdata13;        //APB13 output



//System13 I13/O13

  input                    hclk13;          // AHB13 System13 clock13
  input                    n_sys_reset13;   // AHB13 System13 reset (Active13 LOW13)

//AHB13 I13/O13

  input  [31:0]            haddr13;         // AHB13 Address
  input  [1:0]             htrans13;        // AHB13 transfer13 type
  input               hsel13;          // chip13 selects13
  input                    hwrite13;        // AHB13 read/write indication13
  input  [2:0]             hsize13;         // AHB13 transfer13 size
  input  [31:0]            hwdata13;        // AHB13 write data
  input                    hready13;        // AHB13 Muxed13 ready signal13

  
  output [31:0]            smc_hrdata13;    // smc13 read data back to AHB13 master13
  output                   smc_hready13;    // smc13 ready signal13
  output [1:0]             smc_hresp13;     // AHB13 Response13 signal13
  output                   smc_valid13;     // Ack13 valid address

//External13 memory interface (EMI13)

  output [31:0]            smc_addr13;      // External13 Memory (EMI13) address
  output [31:0]            smc_data13;      // EMI13 write data
  input  [31:0]            data_smc13;      // EMI13 read data
  output [3:0]             smc_n_be13;      // EMI13 byte enables13 (Active13 LOW13)
  output             smc_n_cs13;      // EMI13 Chip13 Selects13 (Active13 LOW13)
  output [3:0]             smc_n_we13;      // EMI13 write strobes13 (Active13 LOW13)
  output                   smc_n_wr13;      // EMI13 write enable (Active13 LOW13)
  output                   smc_n_rd13;      // EMI13 read stobe13 (Active13 LOW13)
  output 	           smc_n_ext_oe13;  // EMI13 write data output enable

//AHB13 Memory Interface13 Control13

   output                   smc_busy13;      // smc13 busy

   
   


//scan13 signals13

   input                  scan_in_113;        //scan13 input
   input                  scan_in_213;        //scan13 input
   input                  scan_en13;         //scan13 enable
   output                 scan_out_113;       //scan13 output
   output                 scan_out_213;       //scan13 output
// third13 scan13 chain13 only used on INCLUDE_APB13
   input                  scan_in_313;        //scan13 input
   output                 scan_out_313;       //scan13 output
   
//----------------------------------------------------------------------
// Signal13 declarations13
//----------------------------------------------------------------------

// Bus13 Interface13
   
  wire  [31:0]   smc_hrdata13;         //smc13 read data back to AHB13 master13
  wire           smc_hready13;         //smc13 ready signal13
  wire  [1:0]    smc_hresp13;          //AHB13 Response13 signal13
  wire           smc_valid13;          //Ack13 valid address

// MAC13

  wire [31:0]    smc_data13;           //Data to external13 bus via MUX13

// Strobe13 Generation13

  wire           smc_n_wr13;           //EMI13 write enable (Active13 LOW13)
  wire  [3:0]    smc_n_we13;           //EMI13 write strobes13 (Active13 LOW13)
  wire           smc_n_rd13;           //EMI13 read stobe13 (Active13 LOW13)
  wire           smc_busy13;           //smc13 busy
  wire           smc_n_ext_oe13;       //Enable13 External13 bus drivers13.(CS13 & !RD13)

// Address Generation13

  wire [31:0]    smc_addr13;           //External13 Memory Interface13(EMI13) address
  wire [3:0]     smc_n_be13;   //EMI13 byte enables13 (Active13 LOW13)
  wire      smc_n_cs13;   //EMI13 Chip13 Selects13 (Active13 LOW13)

// Bus13 Interface13

  wire           new_access13;         // New13 AHB13 access to smc13 detected
  wire [31:0]    addr;               // Copy13 of address
  wire [31:0]    write_data13;         // Data to External13 Bus13
  wire      cs;         // Chip13(bank13) Select13 Lines13
  wire [1:0]     xfer_size13;          // Width13 of current transfer13
  wire           n_read13;             // Active13 low13 read signal13                   
  
// Configuration13 Block


// Counters13

  wire [1:0]     r_csle_count13;       // Chip13 select13 LE13 counter
  wire [1:0]     r_wele_count13;       // Write counter
  wire [1:0]     r_cste_count13;       // chip13 select13 TE13 counter
  wire [7:0]     r_ws_count13; // Wait13 state select13 counter
  
// These13 strobes13 finish early13 so no counter is required13. The stored13 value
// is compared with WS13 counter to determine13 when the strobe13 should end.

  wire [1:0]     r_wete_store13;       // Write strobe13 TE13 end time before CS13
  wire [1:0]     r_oete_store13;       // Read strobe13 TE13 end time before CS13
  
// The following13 four13 wireisrers13 are used to store13 the configuration during
// mulitple13 accesses. The counters13 are reloaded13 from these13 wireisters13
//  before each cycle.

  wire [1:0]     r_csle_store13;       // Chip13 select13 LE13 store13
  wire [1:0]     r_wele_store13;       // Write strobe13 LE13 store13
  wire [7:0]     r_ws_store13;         // Wait13 state store13
  wire [1:0]     r_cste_store13;       // Chip13 Select13 TE13 delay (Bus13 float13 time)


// Multiple13 access control13

  wire           mac_done13;           // Indicates13 last cycle of last access
  wire [1:0]     r_num_access13;       // Access counter
  wire [1:0]     v_xfer_size13;        // Store13 size for MAC13 
  wire [1:0]     v_bus_size13;         // Store13 size for MAC13
  wire [31:0]    read_data13;          // Data path to bus IF
  wire [31:0]    r_read_data13;        // Internal data store13

// smc13 state machine13


  wire           valid_access13;       // New13 acces13 can proceed
  wire   [4:0]   smc_nextstate13;      // state machine13 (async13 encoding13)
  wire   [4:0]   r_smc_currentstate13; // Synchronised13 smc13 state machine13
  wire           ws_enable13;          // Wait13 state counter enable
  wire           cste_enable13;        // Chip13 select13 counter enable
  wire           smc_done13;           // Asserted13 during last cycle of
                                     //    an access
  wire           le_enable13;          // Start13 counters13 after STORED13 
                                     //    access
  wire           latch_data13;         // latch_data13 is used by the MAC13 
                                     //    block to store13 read data 
                                     //    if CSTE13 > 0
  wire           smc_idle13;           // idle13 state

// Address Generation13

  wire [3:0]     n_be13;               // Full cycle write strobe13

// Strobe13 Generation13

  wire           r_full13;             // Full cycle write strobe13
  wire           n_r_read13;           // Store13 RW srate13 for multiple accesses
  wire           n_r_wr13;             // write strobe13
  wire [3:0]     n_r_we13;             // write enable  
  wire      r_cs13;       // registered chip13 select13 

   //apb13
   

   wire n_sys_reset13;                        //AHB13 system reset(active low13)

// assign a default value to the signal13 if the bank13 has
// been disabled and the APB13 has been excluded13 (i.e. the config signals13
// come13 from the top level
   
   smc_apb_lite_if13 i_apb_lite13 (
                     //Inputs13
                     
                     .n_preset13(n_preset13),
                     .pclk13(pclk13),
                     .psel13(psel13),
                     .penable13(penable13),
                     .pwrite13(pwrite13),
                     .paddr13(paddr13),
                     .pwdata13(pwdata13),
                     
                    //Outputs13
                     
                     .prdata13(prdata13)
                     
                     );
   
   smc_ahb_lite_if13 i_ahb_lite13  (
                     //Inputs13
                     
		     .hclk13 (hclk13),
                     .n_sys_reset13 (n_sys_reset13),
                     .haddr13 (haddr13),
                     .hsel13 (hsel13),                                                
                     .htrans13 (htrans13),                    
                     .hwrite13 (hwrite13),
                     .hsize13 (hsize13),                
                     .hwdata13 (hwdata13),
                     .hready13 (hready13),
                     .read_data13 (read_data13),
                     .mac_done13 (mac_done13),
                     .smc_done13 (smc_done13),
                     .smc_idle13 (smc_idle13),
                     
                     // Outputs13
                     
                     .xfer_size13 (xfer_size13),
                     .n_read13 (n_read13),
                     .new_access13 (new_access13),
                     .addr (addr),
                     .smc_hrdata13 (smc_hrdata13), 
                     .smc_hready13 (smc_hready13),
                     .smc_hresp13 (smc_hresp13),
                     .smc_valid13 (smc_valid13),
                     .cs (cs),
                     .write_data13 (write_data13)
                     );
   
   

   
   
   smc_counter_lite13 i_counter_lite13 (
                          
                          // Inputs13
                          
                          .sys_clk13 (hclk13),
                          .n_sys_reset13 (n_sys_reset13),
                          .valid_access13 (valid_access13),
                          .mac_done13 (mac_done13),
                          .smc_done13 (smc_done13),
                          .cste_enable13 (cste_enable13),
                          .ws_enable13 (ws_enable13),
                          .le_enable13 (le_enable13),
                          
                          // Outputs13
                          
                          .r_csle_store13 (r_csle_store13),
                          .r_csle_count13 (r_csle_count13),
                          .r_wele_count13 (r_wele_count13),
                          .r_ws_count13 (r_ws_count13),
                          .r_ws_store13 (r_ws_store13),
                          .r_oete_store13 (r_oete_store13),
                          .r_wete_store13 (r_wete_store13),
                          .r_wele_store13 (r_wele_store13),
                          .r_cste_count13 (r_cste_count13));
   
   
   smc_mac_lite13 i_mac_lite13         (
                          
                          // Inputs13
                          
                          .sys_clk13 (hclk13),
                          .n_sys_reset13 (n_sys_reset13),
                          .valid_access13 (valid_access13),
                          .xfer_size13 (xfer_size13),
                          .smc_done13 (smc_done13),
                          .data_smc13 (data_smc13),
                          .write_data13 (write_data13),
                          .smc_nextstate13 (smc_nextstate13),
                          .latch_data13 (latch_data13),
                          
                          // Outputs13
                          
                          .r_num_access13 (r_num_access13),
                          .mac_done13 (mac_done13),
                          .v_bus_size13 (v_bus_size13),
                          .v_xfer_size13 (v_xfer_size13),
                          .read_data13 (read_data13),
                          .smc_data13 (smc_data13));
   
   
   smc_state_lite13 i_state_lite13     (
                          
                          // Inputs13
                          
                          .sys_clk13 (hclk13),
                          .n_sys_reset13 (n_sys_reset13),
                          .new_access13 (new_access13),
                          .r_cste_count13 (r_cste_count13),
                          .r_csle_count13 (r_csle_count13),
                          .r_ws_count13 (r_ws_count13),
                          .mac_done13 (mac_done13),
                          .n_read13 (n_read13),
                          .n_r_read13 (n_r_read13),
                          .r_csle_store13 (r_csle_store13),
                          .r_oete_store13 (r_oete_store13),
                          .cs(cs),
                          .r_cs13(r_cs13),

                          // Outputs13
                          
                          .r_smc_currentstate13 (r_smc_currentstate13),
                          .smc_nextstate13 (smc_nextstate13),
                          .cste_enable13 (cste_enable13),
                          .ws_enable13 (ws_enable13),
                          .smc_done13 (smc_done13),
                          .valid_access13 (valid_access13),
                          .le_enable13 (le_enable13),
                          .latch_data13 (latch_data13),
                          .smc_idle13 (smc_idle13));
   
   smc_strobe_lite13 i_strobe_lite13   (

                          //inputs13

                          .sys_clk13 (hclk13),
                          .n_sys_reset13 (n_sys_reset13),
                          .valid_access13 (valid_access13),
                          .n_read13 (n_read13),
                          .cs(cs),
                          .r_smc_currentstate13 (r_smc_currentstate13),
                          .smc_nextstate13 (smc_nextstate13),
                          .n_be13 (n_be13),
                          .r_wele_store13 (r_wele_store13),
                          .r_wele_count13 (r_wele_count13),
                          .r_wete_store13 (r_wete_store13),
                          .r_oete_store13 (r_oete_store13),
                          .r_ws_count13 (r_ws_count13),
                          .r_ws_store13 (r_ws_store13),
                          .smc_done13 (smc_done13),
                          .mac_done13 (mac_done13),
                          
                          //outputs13

                          .smc_n_rd13 (smc_n_rd13),
                          .smc_n_ext_oe13 (smc_n_ext_oe13),
                          .smc_busy13 (smc_busy13),
                          .n_r_read13 (n_r_read13),
                          .r_cs13(r_cs13),
                          .r_full13 (r_full13),
                          .n_r_we13 (n_r_we13),
                          .n_r_wr13 (n_r_wr13));
   
   smc_wr_enable_lite13 i_wr_enable_lite13 (

                            //inputs13

                          .n_sys_reset13 (n_sys_reset13),
                          .r_full13(r_full13),
                          .n_r_we13(n_r_we13),
                          .n_r_wr13 (n_r_wr13),
                              
                          //output                

                          .smc_n_we13(smc_n_we13),
                          .smc_n_wr13 (smc_n_wr13));
   
   
   
   smc_addr_lite13 i_add_lite13        (
                          //inputs13

                          .sys_clk13 (hclk13),
                          .n_sys_reset13 (n_sys_reset13),
                          .valid_access13 (valid_access13),
                          .r_num_access13 (r_num_access13),
                          .v_bus_size13 (v_bus_size13),
                          .v_xfer_size13 (v_xfer_size13),
                          .cs (cs),
                          .addr (addr),
                          .smc_done13 (smc_done13),
                          .smc_nextstate13 (smc_nextstate13),
                          
                          //outputs13

                          .smc_addr13 (smc_addr13),
                          .smc_n_be13 (smc_n_be13),
                          .smc_n_cs13 (smc_n_cs13),
                          .n_be13 (n_be13));
   
   
endmodule
