//File9 name   : smc_lite9.v
//Title9       : SMC9 top level
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

 `include "smc_defs_lite9.v"

//static memory controller9
module          smc_lite9(
                    //apb9 inputs9
                    n_preset9, 
                    pclk9, 
                    psel9, 
                    penable9, 
                    pwrite9, 
                    paddr9, 
                    pwdata9,
                    //ahb9 inputs9                    
                    hclk9,
                    n_sys_reset9,
                    haddr9,
                    htrans9,
                    hsel9,
                    hwrite9,
                    hsize9,
                    hwdata9,
                    hready9,
                    data_smc9,
                    

                    //test signal9 inputs9

                    scan_in_19,
                    scan_in_29,
                    scan_in_39,
                    scan_en9,

                    //apb9 outputs9                    
                    prdata9,

                    //design output
                    
                    smc_hrdata9, 
                    smc_hready9,
                    smc_valid9,
                    smc_hresp9,
                    smc_addr9,
                    smc_data9, 
                    smc_n_be9,
                    smc_n_cs9,
                    smc_n_wr9,                    
                    smc_n_we9,
                    smc_n_rd9,
                    smc_n_ext_oe9,
                    smc_busy9,

                    //test signal9 output

                    scan_out_19,
                    scan_out_29,
                    scan_out_39
                   );
// define parameters9
// change using defaparam9 statements9


  // APB9 Inputs9 (use is optional9 on INCLUDE_APB9)
  input        n_preset9;           // APBreset9 
  input        pclk9;               // APB9 clock9
  input        psel9;               // APB9 select9
  input        penable9;            // APB9 enable 
  input        pwrite9;             // APB9 write strobe9 
  input [4:0]  paddr9;              // APB9 address bus
  input [31:0] pwdata9;             // APB9 write data 

  // APB9 Output9 (use is optional9 on INCLUDE_APB9)

  output [31:0] prdata9;        //APB9 output



//System9 I9/O9

  input                    hclk9;          // AHB9 System9 clock9
  input                    n_sys_reset9;   // AHB9 System9 reset (Active9 LOW9)

//AHB9 I9/O9

  input  [31:0]            haddr9;         // AHB9 Address
  input  [1:0]             htrans9;        // AHB9 transfer9 type
  input               hsel9;          // chip9 selects9
  input                    hwrite9;        // AHB9 read/write indication9
  input  [2:0]             hsize9;         // AHB9 transfer9 size
  input  [31:0]            hwdata9;        // AHB9 write data
  input                    hready9;        // AHB9 Muxed9 ready signal9

  
  output [31:0]            smc_hrdata9;    // smc9 read data back to AHB9 master9
  output                   smc_hready9;    // smc9 ready signal9
  output [1:0]             smc_hresp9;     // AHB9 Response9 signal9
  output                   smc_valid9;     // Ack9 valid address

//External9 memory interface (EMI9)

  output [31:0]            smc_addr9;      // External9 Memory (EMI9) address
  output [31:0]            smc_data9;      // EMI9 write data
  input  [31:0]            data_smc9;      // EMI9 read data
  output [3:0]             smc_n_be9;      // EMI9 byte enables9 (Active9 LOW9)
  output             smc_n_cs9;      // EMI9 Chip9 Selects9 (Active9 LOW9)
  output [3:0]             smc_n_we9;      // EMI9 write strobes9 (Active9 LOW9)
  output                   smc_n_wr9;      // EMI9 write enable (Active9 LOW9)
  output                   smc_n_rd9;      // EMI9 read stobe9 (Active9 LOW9)
  output 	           smc_n_ext_oe9;  // EMI9 write data output enable

//AHB9 Memory Interface9 Control9

   output                   smc_busy9;      // smc9 busy

   
   


//scan9 signals9

   input                  scan_in_19;        //scan9 input
   input                  scan_in_29;        //scan9 input
   input                  scan_en9;         //scan9 enable
   output                 scan_out_19;       //scan9 output
   output                 scan_out_29;       //scan9 output
// third9 scan9 chain9 only used on INCLUDE_APB9
   input                  scan_in_39;        //scan9 input
   output                 scan_out_39;       //scan9 output
   
//----------------------------------------------------------------------
// Signal9 declarations9
//----------------------------------------------------------------------

// Bus9 Interface9
   
  wire  [31:0]   smc_hrdata9;         //smc9 read data back to AHB9 master9
  wire           smc_hready9;         //smc9 ready signal9
  wire  [1:0]    smc_hresp9;          //AHB9 Response9 signal9
  wire           smc_valid9;          //Ack9 valid address

// MAC9

  wire [31:0]    smc_data9;           //Data to external9 bus via MUX9

// Strobe9 Generation9

  wire           smc_n_wr9;           //EMI9 write enable (Active9 LOW9)
  wire  [3:0]    smc_n_we9;           //EMI9 write strobes9 (Active9 LOW9)
  wire           smc_n_rd9;           //EMI9 read stobe9 (Active9 LOW9)
  wire           smc_busy9;           //smc9 busy
  wire           smc_n_ext_oe9;       //Enable9 External9 bus drivers9.(CS9 & !RD9)

// Address Generation9

  wire [31:0]    smc_addr9;           //External9 Memory Interface9(EMI9) address
  wire [3:0]     smc_n_be9;   //EMI9 byte enables9 (Active9 LOW9)
  wire      smc_n_cs9;   //EMI9 Chip9 Selects9 (Active9 LOW9)

// Bus9 Interface9

  wire           new_access9;         // New9 AHB9 access to smc9 detected
  wire [31:0]    addr;               // Copy9 of address
  wire [31:0]    write_data9;         // Data to External9 Bus9
  wire      cs;         // Chip9(bank9) Select9 Lines9
  wire [1:0]     xfer_size9;          // Width9 of current transfer9
  wire           n_read9;             // Active9 low9 read signal9                   
  
// Configuration9 Block


// Counters9

  wire [1:0]     r_csle_count9;       // Chip9 select9 LE9 counter
  wire [1:0]     r_wele_count9;       // Write counter
  wire [1:0]     r_cste_count9;       // chip9 select9 TE9 counter
  wire [7:0]     r_ws_count9; // Wait9 state select9 counter
  
// These9 strobes9 finish early9 so no counter is required9. The stored9 value
// is compared with WS9 counter to determine9 when the strobe9 should end.

  wire [1:0]     r_wete_store9;       // Write strobe9 TE9 end time before CS9
  wire [1:0]     r_oete_store9;       // Read strobe9 TE9 end time before CS9
  
// The following9 four9 wireisrers9 are used to store9 the configuration during
// mulitple9 accesses. The counters9 are reloaded9 from these9 wireisters9
//  before each cycle.

  wire [1:0]     r_csle_store9;       // Chip9 select9 LE9 store9
  wire [1:0]     r_wele_store9;       // Write strobe9 LE9 store9
  wire [7:0]     r_ws_store9;         // Wait9 state store9
  wire [1:0]     r_cste_store9;       // Chip9 Select9 TE9 delay (Bus9 float9 time)


// Multiple9 access control9

  wire           mac_done9;           // Indicates9 last cycle of last access
  wire [1:0]     r_num_access9;       // Access counter
  wire [1:0]     v_xfer_size9;        // Store9 size for MAC9 
  wire [1:0]     v_bus_size9;         // Store9 size for MAC9
  wire [31:0]    read_data9;          // Data path to bus IF
  wire [31:0]    r_read_data9;        // Internal data store9

// smc9 state machine9


  wire           valid_access9;       // New9 acces9 can proceed
  wire   [4:0]   smc_nextstate9;      // state machine9 (async9 encoding9)
  wire   [4:0]   r_smc_currentstate9; // Synchronised9 smc9 state machine9
  wire           ws_enable9;          // Wait9 state counter enable
  wire           cste_enable9;        // Chip9 select9 counter enable
  wire           smc_done9;           // Asserted9 during last cycle of
                                     //    an access
  wire           le_enable9;          // Start9 counters9 after STORED9 
                                     //    access
  wire           latch_data9;         // latch_data9 is used by the MAC9 
                                     //    block to store9 read data 
                                     //    if CSTE9 > 0
  wire           smc_idle9;           // idle9 state

// Address Generation9

  wire [3:0]     n_be9;               // Full cycle write strobe9

// Strobe9 Generation9

  wire           r_full9;             // Full cycle write strobe9
  wire           n_r_read9;           // Store9 RW srate9 for multiple accesses
  wire           n_r_wr9;             // write strobe9
  wire [3:0]     n_r_we9;             // write enable  
  wire      r_cs9;       // registered chip9 select9 

   //apb9
   

   wire n_sys_reset9;                        //AHB9 system reset(active low9)

// assign a default value to the signal9 if the bank9 has
// been disabled and the APB9 has been excluded9 (i.e. the config signals9
// come9 from the top level
   
   smc_apb_lite_if9 i_apb_lite9 (
                     //Inputs9
                     
                     .n_preset9(n_preset9),
                     .pclk9(pclk9),
                     .psel9(psel9),
                     .penable9(penable9),
                     .pwrite9(pwrite9),
                     .paddr9(paddr9),
                     .pwdata9(pwdata9),
                     
                    //Outputs9
                     
                     .prdata9(prdata9)
                     
                     );
   
   smc_ahb_lite_if9 i_ahb_lite9  (
                     //Inputs9
                     
		     .hclk9 (hclk9),
                     .n_sys_reset9 (n_sys_reset9),
                     .haddr9 (haddr9),
                     .hsel9 (hsel9),                                                
                     .htrans9 (htrans9),                    
                     .hwrite9 (hwrite9),
                     .hsize9 (hsize9),                
                     .hwdata9 (hwdata9),
                     .hready9 (hready9),
                     .read_data9 (read_data9),
                     .mac_done9 (mac_done9),
                     .smc_done9 (smc_done9),
                     .smc_idle9 (smc_idle9),
                     
                     // Outputs9
                     
                     .xfer_size9 (xfer_size9),
                     .n_read9 (n_read9),
                     .new_access9 (new_access9),
                     .addr (addr),
                     .smc_hrdata9 (smc_hrdata9), 
                     .smc_hready9 (smc_hready9),
                     .smc_hresp9 (smc_hresp9),
                     .smc_valid9 (smc_valid9),
                     .cs (cs),
                     .write_data9 (write_data9)
                     );
   
   

   
   
   smc_counter_lite9 i_counter_lite9 (
                          
                          // Inputs9
                          
                          .sys_clk9 (hclk9),
                          .n_sys_reset9 (n_sys_reset9),
                          .valid_access9 (valid_access9),
                          .mac_done9 (mac_done9),
                          .smc_done9 (smc_done9),
                          .cste_enable9 (cste_enable9),
                          .ws_enable9 (ws_enable9),
                          .le_enable9 (le_enable9),
                          
                          // Outputs9
                          
                          .r_csle_store9 (r_csle_store9),
                          .r_csle_count9 (r_csle_count9),
                          .r_wele_count9 (r_wele_count9),
                          .r_ws_count9 (r_ws_count9),
                          .r_ws_store9 (r_ws_store9),
                          .r_oete_store9 (r_oete_store9),
                          .r_wete_store9 (r_wete_store9),
                          .r_wele_store9 (r_wele_store9),
                          .r_cste_count9 (r_cste_count9));
   
   
   smc_mac_lite9 i_mac_lite9         (
                          
                          // Inputs9
                          
                          .sys_clk9 (hclk9),
                          .n_sys_reset9 (n_sys_reset9),
                          .valid_access9 (valid_access9),
                          .xfer_size9 (xfer_size9),
                          .smc_done9 (smc_done9),
                          .data_smc9 (data_smc9),
                          .write_data9 (write_data9),
                          .smc_nextstate9 (smc_nextstate9),
                          .latch_data9 (latch_data9),
                          
                          // Outputs9
                          
                          .r_num_access9 (r_num_access9),
                          .mac_done9 (mac_done9),
                          .v_bus_size9 (v_bus_size9),
                          .v_xfer_size9 (v_xfer_size9),
                          .read_data9 (read_data9),
                          .smc_data9 (smc_data9));
   
   
   smc_state_lite9 i_state_lite9     (
                          
                          // Inputs9
                          
                          .sys_clk9 (hclk9),
                          .n_sys_reset9 (n_sys_reset9),
                          .new_access9 (new_access9),
                          .r_cste_count9 (r_cste_count9),
                          .r_csle_count9 (r_csle_count9),
                          .r_ws_count9 (r_ws_count9),
                          .mac_done9 (mac_done9),
                          .n_read9 (n_read9),
                          .n_r_read9 (n_r_read9),
                          .r_csle_store9 (r_csle_store9),
                          .r_oete_store9 (r_oete_store9),
                          .cs(cs),
                          .r_cs9(r_cs9),

                          // Outputs9
                          
                          .r_smc_currentstate9 (r_smc_currentstate9),
                          .smc_nextstate9 (smc_nextstate9),
                          .cste_enable9 (cste_enable9),
                          .ws_enable9 (ws_enable9),
                          .smc_done9 (smc_done9),
                          .valid_access9 (valid_access9),
                          .le_enable9 (le_enable9),
                          .latch_data9 (latch_data9),
                          .smc_idle9 (smc_idle9));
   
   smc_strobe_lite9 i_strobe_lite9   (

                          //inputs9

                          .sys_clk9 (hclk9),
                          .n_sys_reset9 (n_sys_reset9),
                          .valid_access9 (valid_access9),
                          .n_read9 (n_read9),
                          .cs(cs),
                          .r_smc_currentstate9 (r_smc_currentstate9),
                          .smc_nextstate9 (smc_nextstate9),
                          .n_be9 (n_be9),
                          .r_wele_store9 (r_wele_store9),
                          .r_wele_count9 (r_wele_count9),
                          .r_wete_store9 (r_wete_store9),
                          .r_oete_store9 (r_oete_store9),
                          .r_ws_count9 (r_ws_count9),
                          .r_ws_store9 (r_ws_store9),
                          .smc_done9 (smc_done9),
                          .mac_done9 (mac_done9),
                          
                          //outputs9

                          .smc_n_rd9 (smc_n_rd9),
                          .smc_n_ext_oe9 (smc_n_ext_oe9),
                          .smc_busy9 (smc_busy9),
                          .n_r_read9 (n_r_read9),
                          .r_cs9(r_cs9),
                          .r_full9 (r_full9),
                          .n_r_we9 (n_r_we9),
                          .n_r_wr9 (n_r_wr9));
   
   smc_wr_enable_lite9 i_wr_enable_lite9 (

                            //inputs9

                          .n_sys_reset9 (n_sys_reset9),
                          .r_full9(r_full9),
                          .n_r_we9(n_r_we9),
                          .n_r_wr9 (n_r_wr9),
                              
                          //output                

                          .smc_n_we9(smc_n_we9),
                          .smc_n_wr9 (smc_n_wr9));
   
   
   
   smc_addr_lite9 i_add_lite9        (
                          //inputs9

                          .sys_clk9 (hclk9),
                          .n_sys_reset9 (n_sys_reset9),
                          .valid_access9 (valid_access9),
                          .r_num_access9 (r_num_access9),
                          .v_bus_size9 (v_bus_size9),
                          .v_xfer_size9 (v_xfer_size9),
                          .cs (cs),
                          .addr (addr),
                          .smc_done9 (smc_done9),
                          .smc_nextstate9 (smc_nextstate9),
                          
                          //outputs9

                          .smc_addr9 (smc_addr9),
                          .smc_n_be9 (smc_n_be9),
                          .smc_n_cs9 (smc_n_cs9),
                          .n_be9 (n_be9));
   
   
endmodule
