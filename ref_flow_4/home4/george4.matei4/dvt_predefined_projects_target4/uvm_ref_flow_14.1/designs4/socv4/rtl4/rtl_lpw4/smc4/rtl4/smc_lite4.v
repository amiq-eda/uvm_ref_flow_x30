//File4 name   : smc_lite4.v
//Title4       : SMC4 top level
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

 `include "smc_defs_lite4.v"

//static memory controller4
module          smc_lite4(
                    //apb4 inputs4
                    n_preset4, 
                    pclk4, 
                    psel4, 
                    penable4, 
                    pwrite4, 
                    paddr4, 
                    pwdata4,
                    //ahb4 inputs4                    
                    hclk4,
                    n_sys_reset4,
                    haddr4,
                    htrans4,
                    hsel4,
                    hwrite4,
                    hsize4,
                    hwdata4,
                    hready4,
                    data_smc4,
                    

                    //test signal4 inputs4

                    scan_in_14,
                    scan_in_24,
                    scan_in_34,
                    scan_en4,

                    //apb4 outputs4                    
                    prdata4,

                    //design output
                    
                    smc_hrdata4, 
                    smc_hready4,
                    smc_valid4,
                    smc_hresp4,
                    smc_addr4,
                    smc_data4, 
                    smc_n_be4,
                    smc_n_cs4,
                    smc_n_wr4,                    
                    smc_n_we4,
                    smc_n_rd4,
                    smc_n_ext_oe4,
                    smc_busy4,

                    //test signal4 output

                    scan_out_14,
                    scan_out_24,
                    scan_out_34
                   );
// define parameters4
// change using defaparam4 statements4


  // APB4 Inputs4 (use is optional4 on INCLUDE_APB4)
  input        n_preset4;           // APBreset4 
  input        pclk4;               // APB4 clock4
  input        psel4;               // APB4 select4
  input        penable4;            // APB4 enable 
  input        pwrite4;             // APB4 write strobe4 
  input [4:0]  paddr4;              // APB4 address bus
  input [31:0] pwdata4;             // APB4 write data 

  // APB4 Output4 (use is optional4 on INCLUDE_APB4)

  output [31:0] prdata4;        //APB4 output



//System4 I4/O4

  input                    hclk4;          // AHB4 System4 clock4
  input                    n_sys_reset4;   // AHB4 System4 reset (Active4 LOW4)

//AHB4 I4/O4

  input  [31:0]            haddr4;         // AHB4 Address
  input  [1:0]             htrans4;        // AHB4 transfer4 type
  input               hsel4;          // chip4 selects4
  input                    hwrite4;        // AHB4 read/write indication4
  input  [2:0]             hsize4;         // AHB4 transfer4 size
  input  [31:0]            hwdata4;        // AHB4 write data
  input                    hready4;        // AHB4 Muxed4 ready signal4

  
  output [31:0]            smc_hrdata4;    // smc4 read data back to AHB4 master4
  output                   smc_hready4;    // smc4 ready signal4
  output [1:0]             smc_hresp4;     // AHB4 Response4 signal4
  output                   smc_valid4;     // Ack4 valid address

//External4 memory interface (EMI4)

  output [31:0]            smc_addr4;      // External4 Memory (EMI4) address
  output [31:0]            smc_data4;      // EMI4 write data
  input  [31:0]            data_smc4;      // EMI4 read data
  output [3:0]             smc_n_be4;      // EMI4 byte enables4 (Active4 LOW4)
  output             smc_n_cs4;      // EMI4 Chip4 Selects4 (Active4 LOW4)
  output [3:0]             smc_n_we4;      // EMI4 write strobes4 (Active4 LOW4)
  output                   smc_n_wr4;      // EMI4 write enable (Active4 LOW4)
  output                   smc_n_rd4;      // EMI4 read stobe4 (Active4 LOW4)
  output 	           smc_n_ext_oe4;  // EMI4 write data output enable

//AHB4 Memory Interface4 Control4

   output                   smc_busy4;      // smc4 busy

   
   


//scan4 signals4

   input                  scan_in_14;        //scan4 input
   input                  scan_in_24;        //scan4 input
   input                  scan_en4;         //scan4 enable
   output                 scan_out_14;       //scan4 output
   output                 scan_out_24;       //scan4 output
// third4 scan4 chain4 only used on INCLUDE_APB4
   input                  scan_in_34;        //scan4 input
   output                 scan_out_34;       //scan4 output
   
//----------------------------------------------------------------------
// Signal4 declarations4
//----------------------------------------------------------------------

// Bus4 Interface4
   
  wire  [31:0]   smc_hrdata4;         //smc4 read data back to AHB4 master4
  wire           smc_hready4;         //smc4 ready signal4
  wire  [1:0]    smc_hresp4;          //AHB4 Response4 signal4
  wire           smc_valid4;          //Ack4 valid address

// MAC4

  wire [31:0]    smc_data4;           //Data to external4 bus via MUX4

// Strobe4 Generation4

  wire           smc_n_wr4;           //EMI4 write enable (Active4 LOW4)
  wire  [3:0]    smc_n_we4;           //EMI4 write strobes4 (Active4 LOW4)
  wire           smc_n_rd4;           //EMI4 read stobe4 (Active4 LOW4)
  wire           smc_busy4;           //smc4 busy
  wire           smc_n_ext_oe4;       //Enable4 External4 bus drivers4.(CS4 & !RD4)

// Address Generation4

  wire [31:0]    smc_addr4;           //External4 Memory Interface4(EMI4) address
  wire [3:0]     smc_n_be4;   //EMI4 byte enables4 (Active4 LOW4)
  wire      smc_n_cs4;   //EMI4 Chip4 Selects4 (Active4 LOW4)

// Bus4 Interface4

  wire           new_access4;         // New4 AHB4 access to smc4 detected
  wire [31:0]    addr;               // Copy4 of address
  wire [31:0]    write_data4;         // Data to External4 Bus4
  wire      cs;         // Chip4(bank4) Select4 Lines4
  wire [1:0]     xfer_size4;          // Width4 of current transfer4
  wire           n_read4;             // Active4 low4 read signal4                   
  
// Configuration4 Block


// Counters4

  wire [1:0]     r_csle_count4;       // Chip4 select4 LE4 counter
  wire [1:0]     r_wele_count4;       // Write counter
  wire [1:0]     r_cste_count4;       // chip4 select4 TE4 counter
  wire [7:0]     r_ws_count4; // Wait4 state select4 counter
  
// These4 strobes4 finish early4 so no counter is required4. The stored4 value
// is compared with WS4 counter to determine4 when the strobe4 should end.

  wire [1:0]     r_wete_store4;       // Write strobe4 TE4 end time before CS4
  wire [1:0]     r_oete_store4;       // Read strobe4 TE4 end time before CS4
  
// The following4 four4 wireisrers4 are used to store4 the configuration during
// mulitple4 accesses. The counters4 are reloaded4 from these4 wireisters4
//  before each cycle.

  wire [1:0]     r_csle_store4;       // Chip4 select4 LE4 store4
  wire [1:0]     r_wele_store4;       // Write strobe4 LE4 store4
  wire [7:0]     r_ws_store4;         // Wait4 state store4
  wire [1:0]     r_cste_store4;       // Chip4 Select4 TE4 delay (Bus4 float4 time)


// Multiple4 access control4

  wire           mac_done4;           // Indicates4 last cycle of last access
  wire [1:0]     r_num_access4;       // Access counter
  wire [1:0]     v_xfer_size4;        // Store4 size for MAC4 
  wire [1:0]     v_bus_size4;         // Store4 size for MAC4
  wire [31:0]    read_data4;          // Data path to bus IF
  wire [31:0]    r_read_data4;        // Internal data store4

// smc4 state machine4


  wire           valid_access4;       // New4 acces4 can proceed
  wire   [4:0]   smc_nextstate4;      // state machine4 (async4 encoding4)
  wire   [4:0]   r_smc_currentstate4; // Synchronised4 smc4 state machine4
  wire           ws_enable4;          // Wait4 state counter enable
  wire           cste_enable4;        // Chip4 select4 counter enable
  wire           smc_done4;           // Asserted4 during last cycle of
                                     //    an access
  wire           le_enable4;          // Start4 counters4 after STORED4 
                                     //    access
  wire           latch_data4;         // latch_data4 is used by the MAC4 
                                     //    block to store4 read data 
                                     //    if CSTE4 > 0
  wire           smc_idle4;           // idle4 state

// Address Generation4

  wire [3:0]     n_be4;               // Full cycle write strobe4

// Strobe4 Generation4

  wire           r_full4;             // Full cycle write strobe4
  wire           n_r_read4;           // Store4 RW srate4 for multiple accesses
  wire           n_r_wr4;             // write strobe4
  wire [3:0]     n_r_we4;             // write enable  
  wire      r_cs4;       // registered chip4 select4 

   //apb4
   

   wire n_sys_reset4;                        //AHB4 system reset(active low4)

// assign a default value to the signal4 if the bank4 has
// been disabled and the APB4 has been excluded4 (i.e. the config signals4
// come4 from the top level
   
   smc_apb_lite_if4 i_apb_lite4 (
                     //Inputs4
                     
                     .n_preset4(n_preset4),
                     .pclk4(pclk4),
                     .psel4(psel4),
                     .penable4(penable4),
                     .pwrite4(pwrite4),
                     .paddr4(paddr4),
                     .pwdata4(pwdata4),
                     
                    //Outputs4
                     
                     .prdata4(prdata4)
                     
                     );
   
   smc_ahb_lite_if4 i_ahb_lite4  (
                     //Inputs4
                     
		     .hclk4 (hclk4),
                     .n_sys_reset4 (n_sys_reset4),
                     .haddr4 (haddr4),
                     .hsel4 (hsel4),                                                
                     .htrans4 (htrans4),                    
                     .hwrite4 (hwrite4),
                     .hsize4 (hsize4),                
                     .hwdata4 (hwdata4),
                     .hready4 (hready4),
                     .read_data4 (read_data4),
                     .mac_done4 (mac_done4),
                     .smc_done4 (smc_done4),
                     .smc_idle4 (smc_idle4),
                     
                     // Outputs4
                     
                     .xfer_size4 (xfer_size4),
                     .n_read4 (n_read4),
                     .new_access4 (new_access4),
                     .addr (addr),
                     .smc_hrdata4 (smc_hrdata4), 
                     .smc_hready4 (smc_hready4),
                     .smc_hresp4 (smc_hresp4),
                     .smc_valid4 (smc_valid4),
                     .cs (cs),
                     .write_data4 (write_data4)
                     );
   
   

   
   
   smc_counter_lite4 i_counter_lite4 (
                          
                          // Inputs4
                          
                          .sys_clk4 (hclk4),
                          .n_sys_reset4 (n_sys_reset4),
                          .valid_access4 (valid_access4),
                          .mac_done4 (mac_done4),
                          .smc_done4 (smc_done4),
                          .cste_enable4 (cste_enable4),
                          .ws_enable4 (ws_enable4),
                          .le_enable4 (le_enable4),
                          
                          // Outputs4
                          
                          .r_csle_store4 (r_csle_store4),
                          .r_csle_count4 (r_csle_count4),
                          .r_wele_count4 (r_wele_count4),
                          .r_ws_count4 (r_ws_count4),
                          .r_ws_store4 (r_ws_store4),
                          .r_oete_store4 (r_oete_store4),
                          .r_wete_store4 (r_wete_store4),
                          .r_wele_store4 (r_wele_store4),
                          .r_cste_count4 (r_cste_count4));
   
   
   smc_mac_lite4 i_mac_lite4         (
                          
                          // Inputs4
                          
                          .sys_clk4 (hclk4),
                          .n_sys_reset4 (n_sys_reset4),
                          .valid_access4 (valid_access4),
                          .xfer_size4 (xfer_size4),
                          .smc_done4 (smc_done4),
                          .data_smc4 (data_smc4),
                          .write_data4 (write_data4),
                          .smc_nextstate4 (smc_nextstate4),
                          .latch_data4 (latch_data4),
                          
                          // Outputs4
                          
                          .r_num_access4 (r_num_access4),
                          .mac_done4 (mac_done4),
                          .v_bus_size4 (v_bus_size4),
                          .v_xfer_size4 (v_xfer_size4),
                          .read_data4 (read_data4),
                          .smc_data4 (smc_data4));
   
   
   smc_state_lite4 i_state_lite4     (
                          
                          // Inputs4
                          
                          .sys_clk4 (hclk4),
                          .n_sys_reset4 (n_sys_reset4),
                          .new_access4 (new_access4),
                          .r_cste_count4 (r_cste_count4),
                          .r_csle_count4 (r_csle_count4),
                          .r_ws_count4 (r_ws_count4),
                          .mac_done4 (mac_done4),
                          .n_read4 (n_read4),
                          .n_r_read4 (n_r_read4),
                          .r_csle_store4 (r_csle_store4),
                          .r_oete_store4 (r_oete_store4),
                          .cs(cs),
                          .r_cs4(r_cs4),

                          // Outputs4
                          
                          .r_smc_currentstate4 (r_smc_currentstate4),
                          .smc_nextstate4 (smc_nextstate4),
                          .cste_enable4 (cste_enable4),
                          .ws_enable4 (ws_enable4),
                          .smc_done4 (smc_done4),
                          .valid_access4 (valid_access4),
                          .le_enable4 (le_enable4),
                          .latch_data4 (latch_data4),
                          .smc_idle4 (smc_idle4));
   
   smc_strobe_lite4 i_strobe_lite4   (

                          //inputs4

                          .sys_clk4 (hclk4),
                          .n_sys_reset4 (n_sys_reset4),
                          .valid_access4 (valid_access4),
                          .n_read4 (n_read4),
                          .cs(cs),
                          .r_smc_currentstate4 (r_smc_currentstate4),
                          .smc_nextstate4 (smc_nextstate4),
                          .n_be4 (n_be4),
                          .r_wele_store4 (r_wele_store4),
                          .r_wele_count4 (r_wele_count4),
                          .r_wete_store4 (r_wete_store4),
                          .r_oete_store4 (r_oete_store4),
                          .r_ws_count4 (r_ws_count4),
                          .r_ws_store4 (r_ws_store4),
                          .smc_done4 (smc_done4),
                          .mac_done4 (mac_done4),
                          
                          //outputs4

                          .smc_n_rd4 (smc_n_rd4),
                          .smc_n_ext_oe4 (smc_n_ext_oe4),
                          .smc_busy4 (smc_busy4),
                          .n_r_read4 (n_r_read4),
                          .r_cs4(r_cs4),
                          .r_full4 (r_full4),
                          .n_r_we4 (n_r_we4),
                          .n_r_wr4 (n_r_wr4));
   
   smc_wr_enable_lite4 i_wr_enable_lite4 (

                            //inputs4

                          .n_sys_reset4 (n_sys_reset4),
                          .r_full4(r_full4),
                          .n_r_we4(n_r_we4),
                          .n_r_wr4 (n_r_wr4),
                              
                          //output                

                          .smc_n_we4(smc_n_we4),
                          .smc_n_wr4 (smc_n_wr4));
   
   
   
   smc_addr_lite4 i_add_lite4        (
                          //inputs4

                          .sys_clk4 (hclk4),
                          .n_sys_reset4 (n_sys_reset4),
                          .valid_access4 (valid_access4),
                          .r_num_access4 (r_num_access4),
                          .v_bus_size4 (v_bus_size4),
                          .v_xfer_size4 (v_xfer_size4),
                          .cs (cs),
                          .addr (addr),
                          .smc_done4 (smc_done4),
                          .smc_nextstate4 (smc_nextstate4),
                          
                          //outputs4

                          .smc_addr4 (smc_addr4),
                          .smc_n_be4 (smc_n_be4),
                          .smc_n_cs4 (smc_n_cs4),
                          .n_be4 (n_be4));
   
   
endmodule
