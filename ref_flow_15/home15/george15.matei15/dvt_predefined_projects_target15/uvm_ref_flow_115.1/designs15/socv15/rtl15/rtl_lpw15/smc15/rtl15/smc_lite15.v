//File15 name   : smc_lite15.v
//Title15       : SMC15 top level
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

 `include "smc_defs_lite15.v"

//static memory controller15
module          smc_lite15(
                    //apb15 inputs15
                    n_preset15, 
                    pclk15, 
                    psel15, 
                    penable15, 
                    pwrite15, 
                    paddr15, 
                    pwdata15,
                    //ahb15 inputs15                    
                    hclk15,
                    n_sys_reset15,
                    haddr15,
                    htrans15,
                    hsel15,
                    hwrite15,
                    hsize15,
                    hwdata15,
                    hready15,
                    data_smc15,
                    

                    //test signal15 inputs15

                    scan_in_115,
                    scan_in_215,
                    scan_in_315,
                    scan_en15,

                    //apb15 outputs15                    
                    prdata15,

                    //design output
                    
                    smc_hrdata15, 
                    smc_hready15,
                    smc_valid15,
                    smc_hresp15,
                    smc_addr15,
                    smc_data15, 
                    smc_n_be15,
                    smc_n_cs15,
                    smc_n_wr15,                    
                    smc_n_we15,
                    smc_n_rd15,
                    smc_n_ext_oe15,
                    smc_busy15,

                    //test signal15 output

                    scan_out_115,
                    scan_out_215,
                    scan_out_315
                   );
// define parameters15
// change using defaparam15 statements15


  // APB15 Inputs15 (use is optional15 on INCLUDE_APB15)
  input        n_preset15;           // APBreset15 
  input        pclk15;               // APB15 clock15
  input        psel15;               // APB15 select15
  input        penable15;            // APB15 enable 
  input        pwrite15;             // APB15 write strobe15 
  input [4:0]  paddr15;              // APB15 address bus
  input [31:0] pwdata15;             // APB15 write data 

  // APB15 Output15 (use is optional15 on INCLUDE_APB15)

  output [31:0] prdata15;        //APB15 output



//System15 I15/O15

  input                    hclk15;          // AHB15 System15 clock15
  input                    n_sys_reset15;   // AHB15 System15 reset (Active15 LOW15)

//AHB15 I15/O15

  input  [31:0]            haddr15;         // AHB15 Address
  input  [1:0]             htrans15;        // AHB15 transfer15 type
  input               hsel15;          // chip15 selects15
  input                    hwrite15;        // AHB15 read/write indication15
  input  [2:0]             hsize15;         // AHB15 transfer15 size
  input  [31:0]            hwdata15;        // AHB15 write data
  input                    hready15;        // AHB15 Muxed15 ready signal15

  
  output [31:0]            smc_hrdata15;    // smc15 read data back to AHB15 master15
  output                   smc_hready15;    // smc15 ready signal15
  output [1:0]             smc_hresp15;     // AHB15 Response15 signal15
  output                   smc_valid15;     // Ack15 valid address

//External15 memory interface (EMI15)

  output [31:0]            smc_addr15;      // External15 Memory (EMI15) address
  output [31:0]            smc_data15;      // EMI15 write data
  input  [31:0]            data_smc15;      // EMI15 read data
  output [3:0]             smc_n_be15;      // EMI15 byte enables15 (Active15 LOW15)
  output             smc_n_cs15;      // EMI15 Chip15 Selects15 (Active15 LOW15)
  output [3:0]             smc_n_we15;      // EMI15 write strobes15 (Active15 LOW15)
  output                   smc_n_wr15;      // EMI15 write enable (Active15 LOW15)
  output                   smc_n_rd15;      // EMI15 read stobe15 (Active15 LOW15)
  output 	           smc_n_ext_oe15;  // EMI15 write data output enable

//AHB15 Memory Interface15 Control15

   output                   smc_busy15;      // smc15 busy

   
   


//scan15 signals15

   input                  scan_in_115;        //scan15 input
   input                  scan_in_215;        //scan15 input
   input                  scan_en15;         //scan15 enable
   output                 scan_out_115;       //scan15 output
   output                 scan_out_215;       //scan15 output
// third15 scan15 chain15 only used on INCLUDE_APB15
   input                  scan_in_315;        //scan15 input
   output                 scan_out_315;       //scan15 output
   
//----------------------------------------------------------------------
// Signal15 declarations15
//----------------------------------------------------------------------

// Bus15 Interface15
   
  wire  [31:0]   smc_hrdata15;         //smc15 read data back to AHB15 master15
  wire           smc_hready15;         //smc15 ready signal15
  wire  [1:0]    smc_hresp15;          //AHB15 Response15 signal15
  wire           smc_valid15;          //Ack15 valid address

// MAC15

  wire [31:0]    smc_data15;           //Data to external15 bus via MUX15

// Strobe15 Generation15

  wire           smc_n_wr15;           //EMI15 write enable (Active15 LOW15)
  wire  [3:0]    smc_n_we15;           //EMI15 write strobes15 (Active15 LOW15)
  wire           smc_n_rd15;           //EMI15 read stobe15 (Active15 LOW15)
  wire           smc_busy15;           //smc15 busy
  wire           smc_n_ext_oe15;       //Enable15 External15 bus drivers15.(CS15 & !RD15)

// Address Generation15

  wire [31:0]    smc_addr15;           //External15 Memory Interface15(EMI15) address
  wire [3:0]     smc_n_be15;   //EMI15 byte enables15 (Active15 LOW15)
  wire      smc_n_cs15;   //EMI15 Chip15 Selects15 (Active15 LOW15)

// Bus15 Interface15

  wire           new_access15;         // New15 AHB15 access to smc15 detected
  wire [31:0]    addr;               // Copy15 of address
  wire [31:0]    write_data15;         // Data to External15 Bus15
  wire      cs;         // Chip15(bank15) Select15 Lines15
  wire [1:0]     xfer_size15;          // Width15 of current transfer15
  wire           n_read15;             // Active15 low15 read signal15                   
  
// Configuration15 Block


// Counters15

  wire [1:0]     r_csle_count15;       // Chip15 select15 LE15 counter
  wire [1:0]     r_wele_count15;       // Write counter
  wire [1:0]     r_cste_count15;       // chip15 select15 TE15 counter
  wire [7:0]     r_ws_count15; // Wait15 state select15 counter
  
// These15 strobes15 finish early15 so no counter is required15. The stored15 value
// is compared with WS15 counter to determine15 when the strobe15 should end.

  wire [1:0]     r_wete_store15;       // Write strobe15 TE15 end time before CS15
  wire [1:0]     r_oete_store15;       // Read strobe15 TE15 end time before CS15
  
// The following15 four15 wireisrers15 are used to store15 the configuration during
// mulitple15 accesses. The counters15 are reloaded15 from these15 wireisters15
//  before each cycle.

  wire [1:0]     r_csle_store15;       // Chip15 select15 LE15 store15
  wire [1:0]     r_wele_store15;       // Write strobe15 LE15 store15
  wire [7:0]     r_ws_store15;         // Wait15 state store15
  wire [1:0]     r_cste_store15;       // Chip15 Select15 TE15 delay (Bus15 float15 time)


// Multiple15 access control15

  wire           mac_done15;           // Indicates15 last cycle of last access
  wire [1:0]     r_num_access15;       // Access counter
  wire [1:0]     v_xfer_size15;        // Store15 size for MAC15 
  wire [1:0]     v_bus_size15;         // Store15 size for MAC15
  wire [31:0]    read_data15;          // Data path to bus IF
  wire [31:0]    r_read_data15;        // Internal data store15

// smc15 state machine15


  wire           valid_access15;       // New15 acces15 can proceed
  wire   [4:0]   smc_nextstate15;      // state machine15 (async15 encoding15)
  wire   [4:0]   r_smc_currentstate15; // Synchronised15 smc15 state machine15
  wire           ws_enable15;          // Wait15 state counter enable
  wire           cste_enable15;        // Chip15 select15 counter enable
  wire           smc_done15;           // Asserted15 during last cycle of
                                     //    an access
  wire           le_enable15;          // Start15 counters15 after STORED15 
                                     //    access
  wire           latch_data15;         // latch_data15 is used by the MAC15 
                                     //    block to store15 read data 
                                     //    if CSTE15 > 0
  wire           smc_idle15;           // idle15 state

// Address Generation15

  wire [3:0]     n_be15;               // Full cycle write strobe15

// Strobe15 Generation15

  wire           r_full15;             // Full cycle write strobe15
  wire           n_r_read15;           // Store15 RW srate15 for multiple accesses
  wire           n_r_wr15;             // write strobe15
  wire [3:0]     n_r_we15;             // write enable  
  wire      r_cs15;       // registered chip15 select15 

   //apb15
   

   wire n_sys_reset15;                        //AHB15 system reset(active low15)

// assign a default value to the signal15 if the bank15 has
// been disabled and the APB15 has been excluded15 (i.e. the config signals15
// come15 from the top level
   
   smc_apb_lite_if15 i_apb_lite15 (
                     //Inputs15
                     
                     .n_preset15(n_preset15),
                     .pclk15(pclk15),
                     .psel15(psel15),
                     .penable15(penable15),
                     .pwrite15(pwrite15),
                     .paddr15(paddr15),
                     .pwdata15(pwdata15),
                     
                    //Outputs15
                     
                     .prdata15(prdata15)
                     
                     );
   
   smc_ahb_lite_if15 i_ahb_lite15  (
                     //Inputs15
                     
		     .hclk15 (hclk15),
                     .n_sys_reset15 (n_sys_reset15),
                     .haddr15 (haddr15),
                     .hsel15 (hsel15),                                                
                     .htrans15 (htrans15),                    
                     .hwrite15 (hwrite15),
                     .hsize15 (hsize15),                
                     .hwdata15 (hwdata15),
                     .hready15 (hready15),
                     .read_data15 (read_data15),
                     .mac_done15 (mac_done15),
                     .smc_done15 (smc_done15),
                     .smc_idle15 (smc_idle15),
                     
                     // Outputs15
                     
                     .xfer_size15 (xfer_size15),
                     .n_read15 (n_read15),
                     .new_access15 (new_access15),
                     .addr (addr),
                     .smc_hrdata15 (smc_hrdata15), 
                     .smc_hready15 (smc_hready15),
                     .smc_hresp15 (smc_hresp15),
                     .smc_valid15 (smc_valid15),
                     .cs (cs),
                     .write_data15 (write_data15)
                     );
   
   

   
   
   smc_counter_lite15 i_counter_lite15 (
                          
                          // Inputs15
                          
                          .sys_clk15 (hclk15),
                          .n_sys_reset15 (n_sys_reset15),
                          .valid_access15 (valid_access15),
                          .mac_done15 (mac_done15),
                          .smc_done15 (smc_done15),
                          .cste_enable15 (cste_enable15),
                          .ws_enable15 (ws_enable15),
                          .le_enable15 (le_enable15),
                          
                          // Outputs15
                          
                          .r_csle_store15 (r_csle_store15),
                          .r_csle_count15 (r_csle_count15),
                          .r_wele_count15 (r_wele_count15),
                          .r_ws_count15 (r_ws_count15),
                          .r_ws_store15 (r_ws_store15),
                          .r_oete_store15 (r_oete_store15),
                          .r_wete_store15 (r_wete_store15),
                          .r_wele_store15 (r_wele_store15),
                          .r_cste_count15 (r_cste_count15));
   
   
   smc_mac_lite15 i_mac_lite15         (
                          
                          // Inputs15
                          
                          .sys_clk15 (hclk15),
                          .n_sys_reset15 (n_sys_reset15),
                          .valid_access15 (valid_access15),
                          .xfer_size15 (xfer_size15),
                          .smc_done15 (smc_done15),
                          .data_smc15 (data_smc15),
                          .write_data15 (write_data15),
                          .smc_nextstate15 (smc_nextstate15),
                          .latch_data15 (latch_data15),
                          
                          // Outputs15
                          
                          .r_num_access15 (r_num_access15),
                          .mac_done15 (mac_done15),
                          .v_bus_size15 (v_bus_size15),
                          .v_xfer_size15 (v_xfer_size15),
                          .read_data15 (read_data15),
                          .smc_data15 (smc_data15));
   
   
   smc_state_lite15 i_state_lite15     (
                          
                          // Inputs15
                          
                          .sys_clk15 (hclk15),
                          .n_sys_reset15 (n_sys_reset15),
                          .new_access15 (new_access15),
                          .r_cste_count15 (r_cste_count15),
                          .r_csle_count15 (r_csle_count15),
                          .r_ws_count15 (r_ws_count15),
                          .mac_done15 (mac_done15),
                          .n_read15 (n_read15),
                          .n_r_read15 (n_r_read15),
                          .r_csle_store15 (r_csle_store15),
                          .r_oete_store15 (r_oete_store15),
                          .cs(cs),
                          .r_cs15(r_cs15),

                          // Outputs15
                          
                          .r_smc_currentstate15 (r_smc_currentstate15),
                          .smc_nextstate15 (smc_nextstate15),
                          .cste_enable15 (cste_enable15),
                          .ws_enable15 (ws_enable15),
                          .smc_done15 (smc_done15),
                          .valid_access15 (valid_access15),
                          .le_enable15 (le_enable15),
                          .latch_data15 (latch_data15),
                          .smc_idle15 (smc_idle15));
   
   smc_strobe_lite15 i_strobe_lite15   (

                          //inputs15

                          .sys_clk15 (hclk15),
                          .n_sys_reset15 (n_sys_reset15),
                          .valid_access15 (valid_access15),
                          .n_read15 (n_read15),
                          .cs(cs),
                          .r_smc_currentstate15 (r_smc_currentstate15),
                          .smc_nextstate15 (smc_nextstate15),
                          .n_be15 (n_be15),
                          .r_wele_store15 (r_wele_store15),
                          .r_wele_count15 (r_wele_count15),
                          .r_wete_store15 (r_wete_store15),
                          .r_oete_store15 (r_oete_store15),
                          .r_ws_count15 (r_ws_count15),
                          .r_ws_store15 (r_ws_store15),
                          .smc_done15 (smc_done15),
                          .mac_done15 (mac_done15),
                          
                          //outputs15

                          .smc_n_rd15 (smc_n_rd15),
                          .smc_n_ext_oe15 (smc_n_ext_oe15),
                          .smc_busy15 (smc_busy15),
                          .n_r_read15 (n_r_read15),
                          .r_cs15(r_cs15),
                          .r_full15 (r_full15),
                          .n_r_we15 (n_r_we15),
                          .n_r_wr15 (n_r_wr15));
   
   smc_wr_enable_lite15 i_wr_enable_lite15 (

                            //inputs15

                          .n_sys_reset15 (n_sys_reset15),
                          .r_full15(r_full15),
                          .n_r_we15(n_r_we15),
                          .n_r_wr15 (n_r_wr15),
                              
                          //output                

                          .smc_n_we15(smc_n_we15),
                          .smc_n_wr15 (smc_n_wr15));
   
   
   
   smc_addr_lite15 i_add_lite15        (
                          //inputs15

                          .sys_clk15 (hclk15),
                          .n_sys_reset15 (n_sys_reset15),
                          .valid_access15 (valid_access15),
                          .r_num_access15 (r_num_access15),
                          .v_bus_size15 (v_bus_size15),
                          .v_xfer_size15 (v_xfer_size15),
                          .cs (cs),
                          .addr (addr),
                          .smc_done15 (smc_done15),
                          .smc_nextstate15 (smc_nextstate15),
                          
                          //outputs15

                          .smc_addr15 (smc_addr15),
                          .smc_n_be15 (smc_n_be15),
                          .smc_n_cs15 (smc_n_cs15),
                          .n_be15 (n_be15));
   
   
endmodule
