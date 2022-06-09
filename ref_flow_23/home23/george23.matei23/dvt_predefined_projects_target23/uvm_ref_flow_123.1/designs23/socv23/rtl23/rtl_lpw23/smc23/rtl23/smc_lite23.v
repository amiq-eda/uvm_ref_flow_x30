//File23 name   : smc_lite23.v
//Title23       : SMC23 top level
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

 `include "smc_defs_lite23.v"

//static memory controller23
module          smc_lite23(
                    //apb23 inputs23
                    n_preset23, 
                    pclk23, 
                    psel23, 
                    penable23, 
                    pwrite23, 
                    paddr23, 
                    pwdata23,
                    //ahb23 inputs23                    
                    hclk23,
                    n_sys_reset23,
                    haddr23,
                    htrans23,
                    hsel23,
                    hwrite23,
                    hsize23,
                    hwdata23,
                    hready23,
                    data_smc23,
                    

                    //test signal23 inputs23

                    scan_in_123,
                    scan_in_223,
                    scan_in_323,
                    scan_en23,

                    //apb23 outputs23                    
                    prdata23,

                    //design output
                    
                    smc_hrdata23, 
                    smc_hready23,
                    smc_valid23,
                    smc_hresp23,
                    smc_addr23,
                    smc_data23, 
                    smc_n_be23,
                    smc_n_cs23,
                    smc_n_wr23,                    
                    smc_n_we23,
                    smc_n_rd23,
                    smc_n_ext_oe23,
                    smc_busy23,

                    //test signal23 output

                    scan_out_123,
                    scan_out_223,
                    scan_out_323
                   );
// define parameters23
// change using defaparam23 statements23


  // APB23 Inputs23 (use is optional23 on INCLUDE_APB23)
  input        n_preset23;           // APBreset23 
  input        pclk23;               // APB23 clock23
  input        psel23;               // APB23 select23
  input        penable23;            // APB23 enable 
  input        pwrite23;             // APB23 write strobe23 
  input [4:0]  paddr23;              // APB23 address bus
  input [31:0] pwdata23;             // APB23 write data 

  // APB23 Output23 (use is optional23 on INCLUDE_APB23)

  output [31:0] prdata23;        //APB23 output



//System23 I23/O23

  input                    hclk23;          // AHB23 System23 clock23
  input                    n_sys_reset23;   // AHB23 System23 reset (Active23 LOW23)

//AHB23 I23/O23

  input  [31:0]            haddr23;         // AHB23 Address
  input  [1:0]             htrans23;        // AHB23 transfer23 type
  input               hsel23;          // chip23 selects23
  input                    hwrite23;        // AHB23 read/write indication23
  input  [2:0]             hsize23;         // AHB23 transfer23 size
  input  [31:0]            hwdata23;        // AHB23 write data
  input                    hready23;        // AHB23 Muxed23 ready signal23

  
  output [31:0]            smc_hrdata23;    // smc23 read data back to AHB23 master23
  output                   smc_hready23;    // smc23 ready signal23
  output [1:0]             smc_hresp23;     // AHB23 Response23 signal23
  output                   smc_valid23;     // Ack23 valid address

//External23 memory interface (EMI23)

  output [31:0]            smc_addr23;      // External23 Memory (EMI23) address
  output [31:0]            smc_data23;      // EMI23 write data
  input  [31:0]            data_smc23;      // EMI23 read data
  output [3:0]             smc_n_be23;      // EMI23 byte enables23 (Active23 LOW23)
  output             smc_n_cs23;      // EMI23 Chip23 Selects23 (Active23 LOW23)
  output [3:0]             smc_n_we23;      // EMI23 write strobes23 (Active23 LOW23)
  output                   smc_n_wr23;      // EMI23 write enable (Active23 LOW23)
  output                   smc_n_rd23;      // EMI23 read stobe23 (Active23 LOW23)
  output 	           smc_n_ext_oe23;  // EMI23 write data output enable

//AHB23 Memory Interface23 Control23

   output                   smc_busy23;      // smc23 busy

   
   


//scan23 signals23

   input                  scan_in_123;        //scan23 input
   input                  scan_in_223;        //scan23 input
   input                  scan_en23;         //scan23 enable
   output                 scan_out_123;       //scan23 output
   output                 scan_out_223;       //scan23 output
// third23 scan23 chain23 only used on INCLUDE_APB23
   input                  scan_in_323;        //scan23 input
   output                 scan_out_323;       //scan23 output
   
//----------------------------------------------------------------------
// Signal23 declarations23
//----------------------------------------------------------------------

// Bus23 Interface23
   
  wire  [31:0]   smc_hrdata23;         //smc23 read data back to AHB23 master23
  wire           smc_hready23;         //smc23 ready signal23
  wire  [1:0]    smc_hresp23;          //AHB23 Response23 signal23
  wire           smc_valid23;          //Ack23 valid address

// MAC23

  wire [31:0]    smc_data23;           //Data to external23 bus via MUX23

// Strobe23 Generation23

  wire           smc_n_wr23;           //EMI23 write enable (Active23 LOW23)
  wire  [3:0]    smc_n_we23;           //EMI23 write strobes23 (Active23 LOW23)
  wire           smc_n_rd23;           //EMI23 read stobe23 (Active23 LOW23)
  wire           smc_busy23;           //smc23 busy
  wire           smc_n_ext_oe23;       //Enable23 External23 bus drivers23.(CS23 & !RD23)

// Address Generation23

  wire [31:0]    smc_addr23;           //External23 Memory Interface23(EMI23) address
  wire [3:0]     smc_n_be23;   //EMI23 byte enables23 (Active23 LOW23)
  wire      smc_n_cs23;   //EMI23 Chip23 Selects23 (Active23 LOW23)

// Bus23 Interface23

  wire           new_access23;         // New23 AHB23 access to smc23 detected
  wire [31:0]    addr;               // Copy23 of address
  wire [31:0]    write_data23;         // Data to External23 Bus23
  wire      cs;         // Chip23(bank23) Select23 Lines23
  wire [1:0]     xfer_size23;          // Width23 of current transfer23
  wire           n_read23;             // Active23 low23 read signal23                   
  
// Configuration23 Block


// Counters23

  wire [1:0]     r_csle_count23;       // Chip23 select23 LE23 counter
  wire [1:0]     r_wele_count23;       // Write counter
  wire [1:0]     r_cste_count23;       // chip23 select23 TE23 counter
  wire [7:0]     r_ws_count23; // Wait23 state select23 counter
  
// These23 strobes23 finish early23 so no counter is required23. The stored23 value
// is compared with WS23 counter to determine23 when the strobe23 should end.

  wire [1:0]     r_wete_store23;       // Write strobe23 TE23 end time before CS23
  wire [1:0]     r_oete_store23;       // Read strobe23 TE23 end time before CS23
  
// The following23 four23 wireisrers23 are used to store23 the configuration during
// mulitple23 accesses. The counters23 are reloaded23 from these23 wireisters23
//  before each cycle.

  wire [1:0]     r_csle_store23;       // Chip23 select23 LE23 store23
  wire [1:0]     r_wele_store23;       // Write strobe23 LE23 store23
  wire [7:0]     r_ws_store23;         // Wait23 state store23
  wire [1:0]     r_cste_store23;       // Chip23 Select23 TE23 delay (Bus23 float23 time)


// Multiple23 access control23

  wire           mac_done23;           // Indicates23 last cycle of last access
  wire [1:0]     r_num_access23;       // Access counter
  wire [1:0]     v_xfer_size23;        // Store23 size for MAC23 
  wire [1:0]     v_bus_size23;         // Store23 size for MAC23
  wire [31:0]    read_data23;          // Data path to bus IF
  wire [31:0]    r_read_data23;        // Internal data store23

// smc23 state machine23


  wire           valid_access23;       // New23 acces23 can proceed
  wire   [4:0]   smc_nextstate23;      // state machine23 (async23 encoding23)
  wire   [4:0]   r_smc_currentstate23; // Synchronised23 smc23 state machine23
  wire           ws_enable23;          // Wait23 state counter enable
  wire           cste_enable23;        // Chip23 select23 counter enable
  wire           smc_done23;           // Asserted23 during last cycle of
                                     //    an access
  wire           le_enable23;          // Start23 counters23 after STORED23 
                                     //    access
  wire           latch_data23;         // latch_data23 is used by the MAC23 
                                     //    block to store23 read data 
                                     //    if CSTE23 > 0
  wire           smc_idle23;           // idle23 state

// Address Generation23

  wire [3:0]     n_be23;               // Full cycle write strobe23

// Strobe23 Generation23

  wire           r_full23;             // Full cycle write strobe23
  wire           n_r_read23;           // Store23 RW srate23 for multiple accesses
  wire           n_r_wr23;             // write strobe23
  wire [3:0]     n_r_we23;             // write enable  
  wire      r_cs23;       // registered chip23 select23 

   //apb23
   

   wire n_sys_reset23;                        //AHB23 system reset(active low23)

// assign a default value to the signal23 if the bank23 has
// been disabled and the APB23 has been excluded23 (i.e. the config signals23
// come23 from the top level
   
   smc_apb_lite_if23 i_apb_lite23 (
                     //Inputs23
                     
                     .n_preset23(n_preset23),
                     .pclk23(pclk23),
                     .psel23(psel23),
                     .penable23(penable23),
                     .pwrite23(pwrite23),
                     .paddr23(paddr23),
                     .pwdata23(pwdata23),
                     
                    //Outputs23
                     
                     .prdata23(prdata23)
                     
                     );
   
   smc_ahb_lite_if23 i_ahb_lite23  (
                     //Inputs23
                     
		     .hclk23 (hclk23),
                     .n_sys_reset23 (n_sys_reset23),
                     .haddr23 (haddr23),
                     .hsel23 (hsel23),                                                
                     .htrans23 (htrans23),                    
                     .hwrite23 (hwrite23),
                     .hsize23 (hsize23),                
                     .hwdata23 (hwdata23),
                     .hready23 (hready23),
                     .read_data23 (read_data23),
                     .mac_done23 (mac_done23),
                     .smc_done23 (smc_done23),
                     .smc_idle23 (smc_idle23),
                     
                     // Outputs23
                     
                     .xfer_size23 (xfer_size23),
                     .n_read23 (n_read23),
                     .new_access23 (new_access23),
                     .addr (addr),
                     .smc_hrdata23 (smc_hrdata23), 
                     .smc_hready23 (smc_hready23),
                     .smc_hresp23 (smc_hresp23),
                     .smc_valid23 (smc_valid23),
                     .cs (cs),
                     .write_data23 (write_data23)
                     );
   
   

   
   
   smc_counter_lite23 i_counter_lite23 (
                          
                          // Inputs23
                          
                          .sys_clk23 (hclk23),
                          .n_sys_reset23 (n_sys_reset23),
                          .valid_access23 (valid_access23),
                          .mac_done23 (mac_done23),
                          .smc_done23 (smc_done23),
                          .cste_enable23 (cste_enable23),
                          .ws_enable23 (ws_enable23),
                          .le_enable23 (le_enable23),
                          
                          // Outputs23
                          
                          .r_csle_store23 (r_csle_store23),
                          .r_csle_count23 (r_csle_count23),
                          .r_wele_count23 (r_wele_count23),
                          .r_ws_count23 (r_ws_count23),
                          .r_ws_store23 (r_ws_store23),
                          .r_oete_store23 (r_oete_store23),
                          .r_wete_store23 (r_wete_store23),
                          .r_wele_store23 (r_wele_store23),
                          .r_cste_count23 (r_cste_count23));
   
   
   smc_mac_lite23 i_mac_lite23         (
                          
                          // Inputs23
                          
                          .sys_clk23 (hclk23),
                          .n_sys_reset23 (n_sys_reset23),
                          .valid_access23 (valid_access23),
                          .xfer_size23 (xfer_size23),
                          .smc_done23 (smc_done23),
                          .data_smc23 (data_smc23),
                          .write_data23 (write_data23),
                          .smc_nextstate23 (smc_nextstate23),
                          .latch_data23 (latch_data23),
                          
                          // Outputs23
                          
                          .r_num_access23 (r_num_access23),
                          .mac_done23 (mac_done23),
                          .v_bus_size23 (v_bus_size23),
                          .v_xfer_size23 (v_xfer_size23),
                          .read_data23 (read_data23),
                          .smc_data23 (smc_data23));
   
   
   smc_state_lite23 i_state_lite23     (
                          
                          // Inputs23
                          
                          .sys_clk23 (hclk23),
                          .n_sys_reset23 (n_sys_reset23),
                          .new_access23 (new_access23),
                          .r_cste_count23 (r_cste_count23),
                          .r_csle_count23 (r_csle_count23),
                          .r_ws_count23 (r_ws_count23),
                          .mac_done23 (mac_done23),
                          .n_read23 (n_read23),
                          .n_r_read23 (n_r_read23),
                          .r_csle_store23 (r_csle_store23),
                          .r_oete_store23 (r_oete_store23),
                          .cs(cs),
                          .r_cs23(r_cs23),

                          // Outputs23
                          
                          .r_smc_currentstate23 (r_smc_currentstate23),
                          .smc_nextstate23 (smc_nextstate23),
                          .cste_enable23 (cste_enable23),
                          .ws_enable23 (ws_enable23),
                          .smc_done23 (smc_done23),
                          .valid_access23 (valid_access23),
                          .le_enable23 (le_enable23),
                          .latch_data23 (latch_data23),
                          .smc_idle23 (smc_idle23));
   
   smc_strobe_lite23 i_strobe_lite23   (

                          //inputs23

                          .sys_clk23 (hclk23),
                          .n_sys_reset23 (n_sys_reset23),
                          .valid_access23 (valid_access23),
                          .n_read23 (n_read23),
                          .cs(cs),
                          .r_smc_currentstate23 (r_smc_currentstate23),
                          .smc_nextstate23 (smc_nextstate23),
                          .n_be23 (n_be23),
                          .r_wele_store23 (r_wele_store23),
                          .r_wele_count23 (r_wele_count23),
                          .r_wete_store23 (r_wete_store23),
                          .r_oete_store23 (r_oete_store23),
                          .r_ws_count23 (r_ws_count23),
                          .r_ws_store23 (r_ws_store23),
                          .smc_done23 (smc_done23),
                          .mac_done23 (mac_done23),
                          
                          //outputs23

                          .smc_n_rd23 (smc_n_rd23),
                          .smc_n_ext_oe23 (smc_n_ext_oe23),
                          .smc_busy23 (smc_busy23),
                          .n_r_read23 (n_r_read23),
                          .r_cs23(r_cs23),
                          .r_full23 (r_full23),
                          .n_r_we23 (n_r_we23),
                          .n_r_wr23 (n_r_wr23));
   
   smc_wr_enable_lite23 i_wr_enable_lite23 (

                            //inputs23

                          .n_sys_reset23 (n_sys_reset23),
                          .r_full23(r_full23),
                          .n_r_we23(n_r_we23),
                          .n_r_wr23 (n_r_wr23),
                              
                          //output                

                          .smc_n_we23(smc_n_we23),
                          .smc_n_wr23 (smc_n_wr23));
   
   
   
   smc_addr_lite23 i_add_lite23        (
                          //inputs23

                          .sys_clk23 (hclk23),
                          .n_sys_reset23 (n_sys_reset23),
                          .valid_access23 (valid_access23),
                          .r_num_access23 (r_num_access23),
                          .v_bus_size23 (v_bus_size23),
                          .v_xfer_size23 (v_xfer_size23),
                          .cs (cs),
                          .addr (addr),
                          .smc_done23 (smc_done23),
                          .smc_nextstate23 (smc_nextstate23),
                          
                          //outputs23

                          .smc_addr23 (smc_addr23),
                          .smc_n_be23 (smc_n_be23),
                          .smc_n_cs23 (smc_n_cs23),
                          .n_be23 (n_be23));
   
   
endmodule
