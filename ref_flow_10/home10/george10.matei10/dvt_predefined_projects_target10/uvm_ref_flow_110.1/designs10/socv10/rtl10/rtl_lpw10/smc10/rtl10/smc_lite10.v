//File10 name   : smc_lite10.v
//Title10       : SMC10 top level
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

 `include "smc_defs_lite10.v"

//static memory controller10
module          smc_lite10(
                    //apb10 inputs10
                    n_preset10, 
                    pclk10, 
                    psel10, 
                    penable10, 
                    pwrite10, 
                    paddr10, 
                    pwdata10,
                    //ahb10 inputs10                    
                    hclk10,
                    n_sys_reset10,
                    haddr10,
                    htrans10,
                    hsel10,
                    hwrite10,
                    hsize10,
                    hwdata10,
                    hready10,
                    data_smc10,
                    

                    //test signal10 inputs10

                    scan_in_110,
                    scan_in_210,
                    scan_in_310,
                    scan_en10,

                    //apb10 outputs10                    
                    prdata10,

                    //design output
                    
                    smc_hrdata10, 
                    smc_hready10,
                    smc_valid10,
                    smc_hresp10,
                    smc_addr10,
                    smc_data10, 
                    smc_n_be10,
                    smc_n_cs10,
                    smc_n_wr10,                    
                    smc_n_we10,
                    smc_n_rd10,
                    smc_n_ext_oe10,
                    smc_busy10,

                    //test signal10 output

                    scan_out_110,
                    scan_out_210,
                    scan_out_310
                   );
// define parameters10
// change using defaparam10 statements10


  // APB10 Inputs10 (use is optional10 on INCLUDE_APB10)
  input        n_preset10;           // APBreset10 
  input        pclk10;               // APB10 clock10
  input        psel10;               // APB10 select10
  input        penable10;            // APB10 enable 
  input        pwrite10;             // APB10 write strobe10 
  input [4:0]  paddr10;              // APB10 address bus
  input [31:0] pwdata10;             // APB10 write data 

  // APB10 Output10 (use is optional10 on INCLUDE_APB10)

  output [31:0] prdata10;        //APB10 output



//System10 I10/O10

  input                    hclk10;          // AHB10 System10 clock10
  input                    n_sys_reset10;   // AHB10 System10 reset (Active10 LOW10)

//AHB10 I10/O10

  input  [31:0]            haddr10;         // AHB10 Address
  input  [1:0]             htrans10;        // AHB10 transfer10 type
  input               hsel10;          // chip10 selects10
  input                    hwrite10;        // AHB10 read/write indication10
  input  [2:0]             hsize10;         // AHB10 transfer10 size
  input  [31:0]            hwdata10;        // AHB10 write data
  input                    hready10;        // AHB10 Muxed10 ready signal10

  
  output [31:0]            smc_hrdata10;    // smc10 read data back to AHB10 master10
  output                   smc_hready10;    // smc10 ready signal10
  output [1:0]             smc_hresp10;     // AHB10 Response10 signal10
  output                   smc_valid10;     // Ack10 valid address

//External10 memory interface (EMI10)

  output [31:0]            smc_addr10;      // External10 Memory (EMI10) address
  output [31:0]            smc_data10;      // EMI10 write data
  input  [31:0]            data_smc10;      // EMI10 read data
  output [3:0]             smc_n_be10;      // EMI10 byte enables10 (Active10 LOW10)
  output             smc_n_cs10;      // EMI10 Chip10 Selects10 (Active10 LOW10)
  output [3:0]             smc_n_we10;      // EMI10 write strobes10 (Active10 LOW10)
  output                   smc_n_wr10;      // EMI10 write enable (Active10 LOW10)
  output                   smc_n_rd10;      // EMI10 read stobe10 (Active10 LOW10)
  output 	           smc_n_ext_oe10;  // EMI10 write data output enable

//AHB10 Memory Interface10 Control10

   output                   smc_busy10;      // smc10 busy

   
   


//scan10 signals10

   input                  scan_in_110;        //scan10 input
   input                  scan_in_210;        //scan10 input
   input                  scan_en10;         //scan10 enable
   output                 scan_out_110;       //scan10 output
   output                 scan_out_210;       //scan10 output
// third10 scan10 chain10 only used on INCLUDE_APB10
   input                  scan_in_310;        //scan10 input
   output                 scan_out_310;       //scan10 output
   
//----------------------------------------------------------------------
// Signal10 declarations10
//----------------------------------------------------------------------

// Bus10 Interface10
   
  wire  [31:0]   smc_hrdata10;         //smc10 read data back to AHB10 master10
  wire           smc_hready10;         //smc10 ready signal10
  wire  [1:0]    smc_hresp10;          //AHB10 Response10 signal10
  wire           smc_valid10;          //Ack10 valid address

// MAC10

  wire [31:0]    smc_data10;           //Data to external10 bus via MUX10

// Strobe10 Generation10

  wire           smc_n_wr10;           //EMI10 write enable (Active10 LOW10)
  wire  [3:0]    smc_n_we10;           //EMI10 write strobes10 (Active10 LOW10)
  wire           smc_n_rd10;           //EMI10 read stobe10 (Active10 LOW10)
  wire           smc_busy10;           //smc10 busy
  wire           smc_n_ext_oe10;       //Enable10 External10 bus drivers10.(CS10 & !RD10)

// Address Generation10

  wire [31:0]    smc_addr10;           //External10 Memory Interface10(EMI10) address
  wire [3:0]     smc_n_be10;   //EMI10 byte enables10 (Active10 LOW10)
  wire      smc_n_cs10;   //EMI10 Chip10 Selects10 (Active10 LOW10)

// Bus10 Interface10

  wire           new_access10;         // New10 AHB10 access to smc10 detected
  wire [31:0]    addr;               // Copy10 of address
  wire [31:0]    write_data10;         // Data to External10 Bus10
  wire      cs;         // Chip10(bank10) Select10 Lines10
  wire [1:0]     xfer_size10;          // Width10 of current transfer10
  wire           n_read10;             // Active10 low10 read signal10                   
  
// Configuration10 Block


// Counters10

  wire [1:0]     r_csle_count10;       // Chip10 select10 LE10 counter
  wire [1:0]     r_wele_count10;       // Write counter
  wire [1:0]     r_cste_count10;       // chip10 select10 TE10 counter
  wire [7:0]     r_ws_count10; // Wait10 state select10 counter
  
// These10 strobes10 finish early10 so no counter is required10. The stored10 value
// is compared with WS10 counter to determine10 when the strobe10 should end.

  wire [1:0]     r_wete_store10;       // Write strobe10 TE10 end time before CS10
  wire [1:0]     r_oete_store10;       // Read strobe10 TE10 end time before CS10
  
// The following10 four10 wireisrers10 are used to store10 the configuration during
// mulitple10 accesses. The counters10 are reloaded10 from these10 wireisters10
//  before each cycle.

  wire [1:0]     r_csle_store10;       // Chip10 select10 LE10 store10
  wire [1:0]     r_wele_store10;       // Write strobe10 LE10 store10
  wire [7:0]     r_ws_store10;         // Wait10 state store10
  wire [1:0]     r_cste_store10;       // Chip10 Select10 TE10 delay (Bus10 float10 time)


// Multiple10 access control10

  wire           mac_done10;           // Indicates10 last cycle of last access
  wire [1:0]     r_num_access10;       // Access counter
  wire [1:0]     v_xfer_size10;        // Store10 size for MAC10 
  wire [1:0]     v_bus_size10;         // Store10 size for MAC10
  wire [31:0]    read_data10;          // Data path to bus IF
  wire [31:0]    r_read_data10;        // Internal data store10

// smc10 state machine10


  wire           valid_access10;       // New10 acces10 can proceed
  wire   [4:0]   smc_nextstate10;      // state machine10 (async10 encoding10)
  wire   [4:0]   r_smc_currentstate10; // Synchronised10 smc10 state machine10
  wire           ws_enable10;          // Wait10 state counter enable
  wire           cste_enable10;        // Chip10 select10 counter enable
  wire           smc_done10;           // Asserted10 during last cycle of
                                     //    an access
  wire           le_enable10;          // Start10 counters10 after STORED10 
                                     //    access
  wire           latch_data10;         // latch_data10 is used by the MAC10 
                                     //    block to store10 read data 
                                     //    if CSTE10 > 0
  wire           smc_idle10;           // idle10 state

// Address Generation10

  wire [3:0]     n_be10;               // Full cycle write strobe10

// Strobe10 Generation10

  wire           r_full10;             // Full cycle write strobe10
  wire           n_r_read10;           // Store10 RW srate10 for multiple accesses
  wire           n_r_wr10;             // write strobe10
  wire [3:0]     n_r_we10;             // write enable  
  wire      r_cs10;       // registered chip10 select10 

   //apb10
   

   wire n_sys_reset10;                        //AHB10 system reset(active low10)

// assign a default value to the signal10 if the bank10 has
// been disabled and the APB10 has been excluded10 (i.e. the config signals10
// come10 from the top level
   
   smc_apb_lite_if10 i_apb_lite10 (
                     //Inputs10
                     
                     .n_preset10(n_preset10),
                     .pclk10(pclk10),
                     .psel10(psel10),
                     .penable10(penable10),
                     .pwrite10(pwrite10),
                     .paddr10(paddr10),
                     .pwdata10(pwdata10),
                     
                    //Outputs10
                     
                     .prdata10(prdata10)
                     
                     );
   
   smc_ahb_lite_if10 i_ahb_lite10  (
                     //Inputs10
                     
		     .hclk10 (hclk10),
                     .n_sys_reset10 (n_sys_reset10),
                     .haddr10 (haddr10),
                     .hsel10 (hsel10),                                                
                     .htrans10 (htrans10),                    
                     .hwrite10 (hwrite10),
                     .hsize10 (hsize10),                
                     .hwdata10 (hwdata10),
                     .hready10 (hready10),
                     .read_data10 (read_data10),
                     .mac_done10 (mac_done10),
                     .smc_done10 (smc_done10),
                     .smc_idle10 (smc_idle10),
                     
                     // Outputs10
                     
                     .xfer_size10 (xfer_size10),
                     .n_read10 (n_read10),
                     .new_access10 (new_access10),
                     .addr (addr),
                     .smc_hrdata10 (smc_hrdata10), 
                     .smc_hready10 (smc_hready10),
                     .smc_hresp10 (smc_hresp10),
                     .smc_valid10 (smc_valid10),
                     .cs (cs),
                     .write_data10 (write_data10)
                     );
   
   

   
   
   smc_counter_lite10 i_counter_lite10 (
                          
                          // Inputs10
                          
                          .sys_clk10 (hclk10),
                          .n_sys_reset10 (n_sys_reset10),
                          .valid_access10 (valid_access10),
                          .mac_done10 (mac_done10),
                          .smc_done10 (smc_done10),
                          .cste_enable10 (cste_enable10),
                          .ws_enable10 (ws_enable10),
                          .le_enable10 (le_enable10),
                          
                          // Outputs10
                          
                          .r_csle_store10 (r_csle_store10),
                          .r_csle_count10 (r_csle_count10),
                          .r_wele_count10 (r_wele_count10),
                          .r_ws_count10 (r_ws_count10),
                          .r_ws_store10 (r_ws_store10),
                          .r_oete_store10 (r_oete_store10),
                          .r_wete_store10 (r_wete_store10),
                          .r_wele_store10 (r_wele_store10),
                          .r_cste_count10 (r_cste_count10));
   
   
   smc_mac_lite10 i_mac_lite10         (
                          
                          // Inputs10
                          
                          .sys_clk10 (hclk10),
                          .n_sys_reset10 (n_sys_reset10),
                          .valid_access10 (valid_access10),
                          .xfer_size10 (xfer_size10),
                          .smc_done10 (smc_done10),
                          .data_smc10 (data_smc10),
                          .write_data10 (write_data10),
                          .smc_nextstate10 (smc_nextstate10),
                          .latch_data10 (latch_data10),
                          
                          // Outputs10
                          
                          .r_num_access10 (r_num_access10),
                          .mac_done10 (mac_done10),
                          .v_bus_size10 (v_bus_size10),
                          .v_xfer_size10 (v_xfer_size10),
                          .read_data10 (read_data10),
                          .smc_data10 (smc_data10));
   
   
   smc_state_lite10 i_state_lite10     (
                          
                          // Inputs10
                          
                          .sys_clk10 (hclk10),
                          .n_sys_reset10 (n_sys_reset10),
                          .new_access10 (new_access10),
                          .r_cste_count10 (r_cste_count10),
                          .r_csle_count10 (r_csle_count10),
                          .r_ws_count10 (r_ws_count10),
                          .mac_done10 (mac_done10),
                          .n_read10 (n_read10),
                          .n_r_read10 (n_r_read10),
                          .r_csle_store10 (r_csle_store10),
                          .r_oete_store10 (r_oete_store10),
                          .cs(cs),
                          .r_cs10(r_cs10),

                          // Outputs10
                          
                          .r_smc_currentstate10 (r_smc_currentstate10),
                          .smc_nextstate10 (smc_nextstate10),
                          .cste_enable10 (cste_enable10),
                          .ws_enable10 (ws_enable10),
                          .smc_done10 (smc_done10),
                          .valid_access10 (valid_access10),
                          .le_enable10 (le_enable10),
                          .latch_data10 (latch_data10),
                          .smc_idle10 (smc_idle10));
   
   smc_strobe_lite10 i_strobe_lite10   (

                          //inputs10

                          .sys_clk10 (hclk10),
                          .n_sys_reset10 (n_sys_reset10),
                          .valid_access10 (valid_access10),
                          .n_read10 (n_read10),
                          .cs(cs),
                          .r_smc_currentstate10 (r_smc_currentstate10),
                          .smc_nextstate10 (smc_nextstate10),
                          .n_be10 (n_be10),
                          .r_wele_store10 (r_wele_store10),
                          .r_wele_count10 (r_wele_count10),
                          .r_wete_store10 (r_wete_store10),
                          .r_oete_store10 (r_oete_store10),
                          .r_ws_count10 (r_ws_count10),
                          .r_ws_store10 (r_ws_store10),
                          .smc_done10 (smc_done10),
                          .mac_done10 (mac_done10),
                          
                          //outputs10

                          .smc_n_rd10 (smc_n_rd10),
                          .smc_n_ext_oe10 (smc_n_ext_oe10),
                          .smc_busy10 (smc_busy10),
                          .n_r_read10 (n_r_read10),
                          .r_cs10(r_cs10),
                          .r_full10 (r_full10),
                          .n_r_we10 (n_r_we10),
                          .n_r_wr10 (n_r_wr10));
   
   smc_wr_enable_lite10 i_wr_enable_lite10 (

                            //inputs10

                          .n_sys_reset10 (n_sys_reset10),
                          .r_full10(r_full10),
                          .n_r_we10(n_r_we10),
                          .n_r_wr10 (n_r_wr10),
                              
                          //output                

                          .smc_n_we10(smc_n_we10),
                          .smc_n_wr10 (smc_n_wr10));
   
   
   
   smc_addr_lite10 i_add_lite10        (
                          //inputs10

                          .sys_clk10 (hclk10),
                          .n_sys_reset10 (n_sys_reset10),
                          .valid_access10 (valid_access10),
                          .r_num_access10 (r_num_access10),
                          .v_bus_size10 (v_bus_size10),
                          .v_xfer_size10 (v_xfer_size10),
                          .cs (cs),
                          .addr (addr),
                          .smc_done10 (smc_done10),
                          .smc_nextstate10 (smc_nextstate10),
                          
                          //outputs10

                          .smc_addr10 (smc_addr10),
                          .smc_n_be10 (smc_n_be10),
                          .smc_n_cs10 (smc_n_cs10),
                          .n_be10 (n_be10));
   
   
endmodule
