//File6 name   : smc_lite6.v
//Title6       : SMC6 top level
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

 `include "smc_defs_lite6.v"

//static memory controller6
module          smc_lite6(
                    //apb6 inputs6
                    n_preset6, 
                    pclk6, 
                    psel6, 
                    penable6, 
                    pwrite6, 
                    paddr6, 
                    pwdata6,
                    //ahb6 inputs6                    
                    hclk6,
                    n_sys_reset6,
                    haddr6,
                    htrans6,
                    hsel6,
                    hwrite6,
                    hsize6,
                    hwdata6,
                    hready6,
                    data_smc6,
                    

                    //test signal6 inputs6

                    scan_in_16,
                    scan_in_26,
                    scan_in_36,
                    scan_en6,

                    //apb6 outputs6                    
                    prdata6,

                    //design output
                    
                    smc_hrdata6, 
                    smc_hready6,
                    smc_valid6,
                    smc_hresp6,
                    smc_addr6,
                    smc_data6, 
                    smc_n_be6,
                    smc_n_cs6,
                    smc_n_wr6,                    
                    smc_n_we6,
                    smc_n_rd6,
                    smc_n_ext_oe6,
                    smc_busy6,

                    //test signal6 output

                    scan_out_16,
                    scan_out_26,
                    scan_out_36
                   );
// define parameters6
// change using defaparam6 statements6


  // APB6 Inputs6 (use is optional6 on INCLUDE_APB6)
  input        n_preset6;           // APBreset6 
  input        pclk6;               // APB6 clock6
  input        psel6;               // APB6 select6
  input        penable6;            // APB6 enable 
  input        pwrite6;             // APB6 write strobe6 
  input [4:0]  paddr6;              // APB6 address bus
  input [31:0] pwdata6;             // APB6 write data 

  // APB6 Output6 (use is optional6 on INCLUDE_APB6)

  output [31:0] prdata6;        //APB6 output



//System6 I6/O6

  input                    hclk6;          // AHB6 System6 clock6
  input                    n_sys_reset6;   // AHB6 System6 reset (Active6 LOW6)

//AHB6 I6/O6

  input  [31:0]            haddr6;         // AHB6 Address
  input  [1:0]             htrans6;        // AHB6 transfer6 type
  input               hsel6;          // chip6 selects6
  input                    hwrite6;        // AHB6 read/write indication6
  input  [2:0]             hsize6;         // AHB6 transfer6 size
  input  [31:0]            hwdata6;        // AHB6 write data
  input                    hready6;        // AHB6 Muxed6 ready signal6

  
  output [31:0]            smc_hrdata6;    // smc6 read data back to AHB6 master6
  output                   smc_hready6;    // smc6 ready signal6
  output [1:0]             smc_hresp6;     // AHB6 Response6 signal6
  output                   smc_valid6;     // Ack6 valid address

//External6 memory interface (EMI6)

  output [31:0]            smc_addr6;      // External6 Memory (EMI6) address
  output [31:0]            smc_data6;      // EMI6 write data
  input  [31:0]            data_smc6;      // EMI6 read data
  output [3:0]             smc_n_be6;      // EMI6 byte enables6 (Active6 LOW6)
  output             smc_n_cs6;      // EMI6 Chip6 Selects6 (Active6 LOW6)
  output [3:0]             smc_n_we6;      // EMI6 write strobes6 (Active6 LOW6)
  output                   smc_n_wr6;      // EMI6 write enable (Active6 LOW6)
  output                   smc_n_rd6;      // EMI6 read stobe6 (Active6 LOW6)
  output 	           smc_n_ext_oe6;  // EMI6 write data output enable

//AHB6 Memory Interface6 Control6

   output                   smc_busy6;      // smc6 busy

   
   


//scan6 signals6

   input                  scan_in_16;        //scan6 input
   input                  scan_in_26;        //scan6 input
   input                  scan_en6;         //scan6 enable
   output                 scan_out_16;       //scan6 output
   output                 scan_out_26;       //scan6 output
// third6 scan6 chain6 only used on INCLUDE_APB6
   input                  scan_in_36;        //scan6 input
   output                 scan_out_36;       //scan6 output
   
//----------------------------------------------------------------------
// Signal6 declarations6
//----------------------------------------------------------------------

// Bus6 Interface6
   
  wire  [31:0]   smc_hrdata6;         //smc6 read data back to AHB6 master6
  wire           smc_hready6;         //smc6 ready signal6
  wire  [1:0]    smc_hresp6;          //AHB6 Response6 signal6
  wire           smc_valid6;          //Ack6 valid address

// MAC6

  wire [31:0]    smc_data6;           //Data to external6 bus via MUX6

// Strobe6 Generation6

  wire           smc_n_wr6;           //EMI6 write enable (Active6 LOW6)
  wire  [3:0]    smc_n_we6;           //EMI6 write strobes6 (Active6 LOW6)
  wire           smc_n_rd6;           //EMI6 read stobe6 (Active6 LOW6)
  wire           smc_busy6;           //smc6 busy
  wire           smc_n_ext_oe6;       //Enable6 External6 bus drivers6.(CS6 & !RD6)

// Address Generation6

  wire [31:0]    smc_addr6;           //External6 Memory Interface6(EMI6) address
  wire [3:0]     smc_n_be6;   //EMI6 byte enables6 (Active6 LOW6)
  wire      smc_n_cs6;   //EMI6 Chip6 Selects6 (Active6 LOW6)

// Bus6 Interface6

  wire           new_access6;         // New6 AHB6 access to smc6 detected
  wire [31:0]    addr;               // Copy6 of address
  wire [31:0]    write_data6;         // Data to External6 Bus6
  wire      cs;         // Chip6(bank6) Select6 Lines6
  wire [1:0]     xfer_size6;          // Width6 of current transfer6
  wire           n_read6;             // Active6 low6 read signal6                   
  
// Configuration6 Block


// Counters6

  wire [1:0]     r_csle_count6;       // Chip6 select6 LE6 counter
  wire [1:0]     r_wele_count6;       // Write counter
  wire [1:0]     r_cste_count6;       // chip6 select6 TE6 counter
  wire [7:0]     r_ws_count6; // Wait6 state select6 counter
  
// These6 strobes6 finish early6 so no counter is required6. The stored6 value
// is compared with WS6 counter to determine6 when the strobe6 should end.

  wire [1:0]     r_wete_store6;       // Write strobe6 TE6 end time before CS6
  wire [1:0]     r_oete_store6;       // Read strobe6 TE6 end time before CS6
  
// The following6 four6 wireisrers6 are used to store6 the configuration during
// mulitple6 accesses. The counters6 are reloaded6 from these6 wireisters6
//  before each cycle.

  wire [1:0]     r_csle_store6;       // Chip6 select6 LE6 store6
  wire [1:0]     r_wele_store6;       // Write strobe6 LE6 store6
  wire [7:0]     r_ws_store6;         // Wait6 state store6
  wire [1:0]     r_cste_store6;       // Chip6 Select6 TE6 delay (Bus6 float6 time)


// Multiple6 access control6

  wire           mac_done6;           // Indicates6 last cycle of last access
  wire [1:0]     r_num_access6;       // Access counter
  wire [1:0]     v_xfer_size6;        // Store6 size for MAC6 
  wire [1:0]     v_bus_size6;         // Store6 size for MAC6
  wire [31:0]    read_data6;          // Data path to bus IF
  wire [31:0]    r_read_data6;        // Internal data store6

// smc6 state machine6


  wire           valid_access6;       // New6 acces6 can proceed
  wire   [4:0]   smc_nextstate6;      // state machine6 (async6 encoding6)
  wire   [4:0]   r_smc_currentstate6; // Synchronised6 smc6 state machine6
  wire           ws_enable6;          // Wait6 state counter enable
  wire           cste_enable6;        // Chip6 select6 counter enable
  wire           smc_done6;           // Asserted6 during last cycle of
                                     //    an access
  wire           le_enable6;          // Start6 counters6 after STORED6 
                                     //    access
  wire           latch_data6;         // latch_data6 is used by the MAC6 
                                     //    block to store6 read data 
                                     //    if CSTE6 > 0
  wire           smc_idle6;           // idle6 state

// Address Generation6

  wire [3:0]     n_be6;               // Full cycle write strobe6

// Strobe6 Generation6

  wire           r_full6;             // Full cycle write strobe6
  wire           n_r_read6;           // Store6 RW srate6 for multiple accesses
  wire           n_r_wr6;             // write strobe6
  wire [3:0]     n_r_we6;             // write enable  
  wire      r_cs6;       // registered chip6 select6 

   //apb6
   

   wire n_sys_reset6;                        //AHB6 system reset(active low6)

// assign a default value to the signal6 if the bank6 has
// been disabled and the APB6 has been excluded6 (i.e. the config signals6
// come6 from the top level
   
   smc_apb_lite_if6 i_apb_lite6 (
                     //Inputs6
                     
                     .n_preset6(n_preset6),
                     .pclk6(pclk6),
                     .psel6(psel6),
                     .penable6(penable6),
                     .pwrite6(pwrite6),
                     .paddr6(paddr6),
                     .pwdata6(pwdata6),
                     
                    //Outputs6
                     
                     .prdata6(prdata6)
                     
                     );
   
   smc_ahb_lite_if6 i_ahb_lite6  (
                     //Inputs6
                     
		     .hclk6 (hclk6),
                     .n_sys_reset6 (n_sys_reset6),
                     .haddr6 (haddr6),
                     .hsel6 (hsel6),                                                
                     .htrans6 (htrans6),                    
                     .hwrite6 (hwrite6),
                     .hsize6 (hsize6),                
                     .hwdata6 (hwdata6),
                     .hready6 (hready6),
                     .read_data6 (read_data6),
                     .mac_done6 (mac_done6),
                     .smc_done6 (smc_done6),
                     .smc_idle6 (smc_idle6),
                     
                     // Outputs6
                     
                     .xfer_size6 (xfer_size6),
                     .n_read6 (n_read6),
                     .new_access6 (new_access6),
                     .addr (addr),
                     .smc_hrdata6 (smc_hrdata6), 
                     .smc_hready6 (smc_hready6),
                     .smc_hresp6 (smc_hresp6),
                     .smc_valid6 (smc_valid6),
                     .cs (cs),
                     .write_data6 (write_data6)
                     );
   
   

   
   
   smc_counter_lite6 i_counter_lite6 (
                          
                          // Inputs6
                          
                          .sys_clk6 (hclk6),
                          .n_sys_reset6 (n_sys_reset6),
                          .valid_access6 (valid_access6),
                          .mac_done6 (mac_done6),
                          .smc_done6 (smc_done6),
                          .cste_enable6 (cste_enable6),
                          .ws_enable6 (ws_enable6),
                          .le_enable6 (le_enable6),
                          
                          // Outputs6
                          
                          .r_csle_store6 (r_csle_store6),
                          .r_csle_count6 (r_csle_count6),
                          .r_wele_count6 (r_wele_count6),
                          .r_ws_count6 (r_ws_count6),
                          .r_ws_store6 (r_ws_store6),
                          .r_oete_store6 (r_oete_store6),
                          .r_wete_store6 (r_wete_store6),
                          .r_wele_store6 (r_wele_store6),
                          .r_cste_count6 (r_cste_count6));
   
   
   smc_mac_lite6 i_mac_lite6         (
                          
                          // Inputs6
                          
                          .sys_clk6 (hclk6),
                          .n_sys_reset6 (n_sys_reset6),
                          .valid_access6 (valid_access6),
                          .xfer_size6 (xfer_size6),
                          .smc_done6 (smc_done6),
                          .data_smc6 (data_smc6),
                          .write_data6 (write_data6),
                          .smc_nextstate6 (smc_nextstate6),
                          .latch_data6 (latch_data6),
                          
                          // Outputs6
                          
                          .r_num_access6 (r_num_access6),
                          .mac_done6 (mac_done6),
                          .v_bus_size6 (v_bus_size6),
                          .v_xfer_size6 (v_xfer_size6),
                          .read_data6 (read_data6),
                          .smc_data6 (smc_data6));
   
   
   smc_state_lite6 i_state_lite6     (
                          
                          // Inputs6
                          
                          .sys_clk6 (hclk6),
                          .n_sys_reset6 (n_sys_reset6),
                          .new_access6 (new_access6),
                          .r_cste_count6 (r_cste_count6),
                          .r_csle_count6 (r_csle_count6),
                          .r_ws_count6 (r_ws_count6),
                          .mac_done6 (mac_done6),
                          .n_read6 (n_read6),
                          .n_r_read6 (n_r_read6),
                          .r_csle_store6 (r_csle_store6),
                          .r_oete_store6 (r_oete_store6),
                          .cs(cs),
                          .r_cs6(r_cs6),

                          // Outputs6
                          
                          .r_smc_currentstate6 (r_smc_currentstate6),
                          .smc_nextstate6 (smc_nextstate6),
                          .cste_enable6 (cste_enable6),
                          .ws_enable6 (ws_enable6),
                          .smc_done6 (smc_done6),
                          .valid_access6 (valid_access6),
                          .le_enable6 (le_enable6),
                          .latch_data6 (latch_data6),
                          .smc_idle6 (smc_idle6));
   
   smc_strobe_lite6 i_strobe_lite6   (

                          //inputs6

                          .sys_clk6 (hclk6),
                          .n_sys_reset6 (n_sys_reset6),
                          .valid_access6 (valid_access6),
                          .n_read6 (n_read6),
                          .cs(cs),
                          .r_smc_currentstate6 (r_smc_currentstate6),
                          .smc_nextstate6 (smc_nextstate6),
                          .n_be6 (n_be6),
                          .r_wele_store6 (r_wele_store6),
                          .r_wele_count6 (r_wele_count6),
                          .r_wete_store6 (r_wete_store6),
                          .r_oete_store6 (r_oete_store6),
                          .r_ws_count6 (r_ws_count6),
                          .r_ws_store6 (r_ws_store6),
                          .smc_done6 (smc_done6),
                          .mac_done6 (mac_done6),
                          
                          //outputs6

                          .smc_n_rd6 (smc_n_rd6),
                          .smc_n_ext_oe6 (smc_n_ext_oe6),
                          .smc_busy6 (smc_busy6),
                          .n_r_read6 (n_r_read6),
                          .r_cs6(r_cs6),
                          .r_full6 (r_full6),
                          .n_r_we6 (n_r_we6),
                          .n_r_wr6 (n_r_wr6));
   
   smc_wr_enable_lite6 i_wr_enable_lite6 (

                            //inputs6

                          .n_sys_reset6 (n_sys_reset6),
                          .r_full6(r_full6),
                          .n_r_we6(n_r_we6),
                          .n_r_wr6 (n_r_wr6),
                              
                          //output                

                          .smc_n_we6(smc_n_we6),
                          .smc_n_wr6 (smc_n_wr6));
   
   
   
   smc_addr_lite6 i_add_lite6        (
                          //inputs6

                          .sys_clk6 (hclk6),
                          .n_sys_reset6 (n_sys_reset6),
                          .valid_access6 (valid_access6),
                          .r_num_access6 (r_num_access6),
                          .v_bus_size6 (v_bus_size6),
                          .v_xfer_size6 (v_xfer_size6),
                          .cs (cs),
                          .addr (addr),
                          .smc_done6 (smc_done6),
                          .smc_nextstate6 (smc_nextstate6),
                          
                          //outputs6

                          .smc_addr6 (smc_addr6),
                          .smc_n_be6 (smc_n_be6),
                          .smc_n_cs6 (smc_n_cs6),
                          .n_be6 (n_be6));
   
   
endmodule
