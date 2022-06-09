//File8 name   : smc_lite8.v
//Title8       : SMC8 top level
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

 `include "smc_defs_lite8.v"

//static memory controller8
module          smc_lite8(
                    //apb8 inputs8
                    n_preset8, 
                    pclk8, 
                    psel8, 
                    penable8, 
                    pwrite8, 
                    paddr8, 
                    pwdata8,
                    //ahb8 inputs8                    
                    hclk8,
                    n_sys_reset8,
                    haddr8,
                    htrans8,
                    hsel8,
                    hwrite8,
                    hsize8,
                    hwdata8,
                    hready8,
                    data_smc8,
                    

                    //test signal8 inputs8

                    scan_in_18,
                    scan_in_28,
                    scan_in_38,
                    scan_en8,

                    //apb8 outputs8                    
                    prdata8,

                    //design output
                    
                    smc_hrdata8, 
                    smc_hready8,
                    smc_valid8,
                    smc_hresp8,
                    smc_addr8,
                    smc_data8, 
                    smc_n_be8,
                    smc_n_cs8,
                    smc_n_wr8,                    
                    smc_n_we8,
                    smc_n_rd8,
                    smc_n_ext_oe8,
                    smc_busy8,

                    //test signal8 output

                    scan_out_18,
                    scan_out_28,
                    scan_out_38
                   );
// define parameters8
// change using defaparam8 statements8


  // APB8 Inputs8 (use is optional8 on INCLUDE_APB8)
  input        n_preset8;           // APBreset8 
  input        pclk8;               // APB8 clock8
  input        psel8;               // APB8 select8
  input        penable8;            // APB8 enable 
  input        pwrite8;             // APB8 write strobe8 
  input [4:0]  paddr8;              // APB8 address bus
  input [31:0] pwdata8;             // APB8 write data 

  // APB8 Output8 (use is optional8 on INCLUDE_APB8)

  output [31:0] prdata8;        //APB8 output



//System8 I8/O8

  input                    hclk8;          // AHB8 System8 clock8
  input                    n_sys_reset8;   // AHB8 System8 reset (Active8 LOW8)

//AHB8 I8/O8

  input  [31:0]            haddr8;         // AHB8 Address
  input  [1:0]             htrans8;        // AHB8 transfer8 type
  input               hsel8;          // chip8 selects8
  input                    hwrite8;        // AHB8 read/write indication8
  input  [2:0]             hsize8;         // AHB8 transfer8 size
  input  [31:0]            hwdata8;        // AHB8 write data
  input                    hready8;        // AHB8 Muxed8 ready signal8

  
  output [31:0]            smc_hrdata8;    // smc8 read data back to AHB8 master8
  output                   smc_hready8;    // smc8 ready signal8
  output [1:0]             smc_hresp8;     // AHB8 Response8 signal8
  output                   smc_valid8;     // Ack8 valid address

//External8 memory interface (EMI8)

  output [31:0]            smc_addr8;      // External8 Memory (EMI8) address
  output [31:0]            smc_data8;      // EMI8 write data
  input  [31:0]            data_smc8;      // EMI8 read data
  output [3:0]             smc_n_be8;      // EMI8 byte enables8 (Active8 LOW8)
  output             smc_n_cs8;      // EMI8 Chip8 Selects8 (Active8 LOW8)
  output [3:0]             smc_n_we8;      // EMI8 write strobes8 (Active8 LOW8)
  output                   smc_n_wr8;      // EMI8 write enable (Active8 LOW8)
  output                   smc_n_rd8;      // EMI8 read stobe8 (Active8 LOW8)
  output 	           smc_n_ext_oe8;  // EMI8 write data output enable

//AHB8 Memory Interface8 Control8

   output                   smc_busy8;      // smc8 busy

   
   


//scan8 signals8

   input                  scan_in_18;        //scan8 input
   input                  scan_in_28;        //scan8 input
   input                  scan_en8;         //scan8 enable
   output                 scan_out_18;       //scan8 output
   output                 scan_out_28;       //scan8 output
// third8 scan8 chain8 only used on INCLUDE_APB8
   input                  scan_in_38;        //scan8 input
   output                 scan_out_38;       //scan8 output
   
//----------------------------------------------------------------------
// Signal8 declarations8
//----------------------------------------------------------------------

// Bus8 Interface8
   
  wire  [31:0]   smc_hrdata8;         //smc8 read data back to AHB8 master8
  wire           smc_hready8;         //smc8 ready signal8
  wire  [1:0]    smc_hresp8;          //AHB8 Response8 signal8
  wire           smc_valid8;          //Ack8 valid address

// MAC8

  wire [31:0]    smc_data8;           //Data to external8 bus via MUX8

// Strobe8 Generation8

  wire           smc_n_wr8;           //EMI8 write enable (Active8 LOW8)
  wire  [3:0]    smc_n_we8;           //EMI8 write strobes8 (Active8 LOW8)
  wire           smc_n_rd8;           //EMI8 read stobe8 (Active8 LOW8)
  wire           smc_busy8;           //smc8 busy
  wire           smc_n_ext_oe8;       //Enable8 External8 bus drivers8.(CS8 & !RD8)

// Address Generation8

  wire [31:0]    smc_addr8;           //External8 Memory Interface8(EMI8) address
  wire [3:0]     smc_n_be8;   //EMI8 byte enables8 (Active8 LOW8)
  wire      smc_n_cs8;   //EMI8 Chip8 Selects8 (Active8 LOW8)

// Bus8 Interface8

  wire           new_access8;         // New8 AHB8 access to smc8 detected
  wire [31:0]    addr;               // Copy8 of address
  wire [31:0]    write_data8;         // Data to External8 Bus8
  wire      cs;         // Chip8(bank8) Select8 Lines8
  wire [1:0]     xfer_size8;          // Width8 of current transfer8
  wire           n_read8;             // Active8 low8 read signal8                   
  
// Configuration8 Block


// Counters8

  wire [1:0]     r_csle_count8;       // Chip8 select8 LE8 counter
  wire [1:0]     r_wele_count8;       // Write counter
  wire [1:0]     r_cste_count8;       // chip8 select8 TE8 counter
  wire [7:0]     r_ws_count8; // Wait8 state select8 counter
  
// These8 strobes8 finish early8 so no counter is required8. The stored8 value
// is compared with WS8 counter to determine8 when the strobe8 should end.

  wire [1:0]     r_wete_store8;       // Write strobe8 TE8 end time before CS8
  wire [1:0]     r_oete_store8;       // Read strobe8 TE8 end time before CS8
  
// The following8 four8 wireisrers8 are used to store8 the configuration during
// mulitple8 accesses. The counters8 are reloaded8 from these8 wireisters8
//  before each cycle.

  wire [1:0]     r_csle_store8;       // Chip8 select8 LE8 store8
  wire [1:0]     r_wele_store8;       // Write strobe8 LE8 store8
  wire [7:0]     r_ws_store8;         // Wait8 state store8
  wire [1:0]     r_cste_store8;       // Chip8 Select8 TE8 delay (Bus8 float8 time)


// Multiple8 access control8

  wire           mac_done8;           // Indicates8 last cycle of last access
  wire [1:0]     r_num_access8;       // Access counter
  wire [1:0]     v_xfer_size8;        // Store8 size for MAC8 
  wire [1:0]     v_bus_size8;         // Store8 size for MAC8
  wire [31:0]    read_data8;          // Data path to bus IF
  wire [31:0]    r_read_data8;        // Internal data store8

// smc8 state machine8


  wire           valid_access8;       // New8 acces8 can proceed
  wire   [4:0]   smc_nextstate8;      // state machine8 (async8 encoding8)
  wire   [4:0]   r_smc_currentstate8; // Synchronised8 smc8 state machine8
  wire           ws_enable8;          // Wait8 state counter enable
  wire           cste_enable8;        // Chip8 select8 counter enable
  wire           smc_done8;           // Asserted8 during last cycle of
                                     //    an access
  wire           le_enable8;          // Start8 counters8 after STORED8 
                                     //    access
  wire           latch_data8;         // latch_data8 is used by the MAC8 
                                     //    block to store8 read data 
                                     //    if CSTE8 > 0
  wire           smc_idle8;           // idle8 state

// Address Generation8

  wire [3:0]     n_be8;               // Full cycle write strobe8

// Strobe8 Generation8

  wire           r_full8;             // Full cycle write strobe8
  wire           n_r_read8;           // Store8 RW srate8 for multiple accesses
  wire           n_r_wr8;             // write strobe8
  wire [3:0]     n_r_we8;             // write enable  
  wire      r_cs8;       // registered chip8 select8 

   //apb8
   

   wire n_sys_reset8;                        //AHB8 system reset(active low8)

// assign a default value to the signal8 if the bank8 has
// been disabled and the APB8 has been excluded8 (i.e. the config signals8
// come8 from the top level
   
   smc_apb_lite_if8 i_apb_lite8 (
                     //Inputs8
                     
                     .n_preset8(n_preset8),
                     .pclk8(pclk8),
                     .psel8(psel8),
                     .penable8(penable8),
                     .pwrite8(pwrite8),
                     .paddr8(paddr8),
                     .pwdata8(pwdata8),
                     
                    //Outputs8
                     
                     .prdata8(prdata8)
                     
                     );
   
   smc_ahb_lite_if8 i_ahb_lite8  (
                     //Inputs8
                     
		     .hclk8 (hclk8),
                     .n_sys_reset8 (n_sys_reset8),
                     .haddr8 (haddr8),
                     .hsel8 (hsel8),                                                
                     .htrans8 (htrans8),                    
                     .hwrite8 (hwrite8),
                     .hsize8 (hsize8),                
                     .hwdata8 (hwdata8),
                     .hready8 (hready8),
                     .read_data8 (read_data8),
                     .mac_done8 (mac_done8),
                     .smc_done8 (smc_done8),
                     .smc_idle8 (smc_idle8),
                     
                     // Outputs8
                     
                     .xfer_size8 (xfer_size8),
                     .n_read8 (n_read8),
                     .new_access8 (new_access8),
                     .addr (addr),
                     .smc_hrdata8 (smc_hrdata8), 
                     .smc_hready8 (smc_hready8),
                     .smc_hresp8 (smc_hresp8),
                     .smc_valid8 (smc_valid8),
                     .cs (cs),
                     .write_data8 (write_data8)
                     );
   
   

   
   
   smc_counter_lite8 i_counter_lite8 (
                          
                          // Inputs8
                          
                          .sys_clk8 (hclk8),
                          .n_sys_reset8 (n_sys_reset8),
                          .valid_access8 (valid_access8),
                          .mac_done8 (mac_done8),
                          .smc_done8 (smc_done8),
                          .cste_enable8 (cste_enable8),
                          .ws_enable8 (ws_enable8),
                          .le_enable8 (le_enable8),
                          
                          // Outputs8
                          
                          .r_csle_store8 (r_csle_store8),
                          .r_csle_count8 (r_csle_count8),
                          .r_wele_count8 (r_wele_count8),
                          .r_ws_count8 (r_ws_count8),
                          .r_ws_store8 (r_ws_store8),
                          .r_oete_store8 (r_oete_store8),
                          .r_wete_store8 (r_wete_store8),
                          .r_wele_store8 (r_wele_store8),
                          .r_cste_count8 (r_cste_count8));
   
   
   smc_mac_lite8 i_mac_lite8         (
                          
                          // Inputs8
                          
                          .sys_clk8 (hclk8),
                          .n_sys_reset8 (n_sys_reset8),
                          .valid_access8 (valid_access8),
                          .xfer_size8 (xfer_size8),
                          .smc_done8 (smc_done8),
                          .data_smc8 (data_smc8),
                          .write_data8 (write_data8),
                          .smc_nextstate8 (smc_nextstate8),
                          .latch_data8 (latch_data8),
                          
                          // Outputs8
                          
                          .r_num_access8 (r_num_access8),
                          .mac_done8 (mac_done8),
                          .v_bus_size8 (v_bus_size8),
                          .v_xfer_size8 (v_xfer_size8),
                          .read_data8 (read_data8),
                          .smc_data8 (smc_data8));
   
   
   smc_state_lite8 i_state_lite8     (
                          
                          // Inputs8
                          
                          .sys_clk8 (hclk8),
                          .n_sys_reset8 (n_sys_reset8),
                          .new_access8 (new_access8),
                          .r_cste_count8 (r_cste_count8),
                          .r_csle_count8 (r_csle_count8),
                          .r_ws_count8 (r_ws_count8),
                          .mac_done8 (mac_done8),
                          .n_read8 (n_read8),
                          .n_r_read8 (n_r_read8),
                          .r_csle_store8 (r_csle_store8),
                          .r_oete_store8 (r_oete_store8),
                          .cs(cs),
                          .r_cs8(r_cs8),

                          // Outputs8
                          
                          .r_smc_currentstate8 (r_smc_currentstate8),
                          .smc_nextstate8 (smc_nextstate8),
                          .cste_enable8 (cste_enable8),
                          .ws_enable8 (ws_enable8),
                          .smc_done8 (smc_done8),
                          .valid_access8 (valid_access8),
                          .le_enable8 (le_enable8),
                          .latch_data8 (latch_data8),
                          .smc_idle8 (smc_idle8));
   
   smc_strobe_lite8 i_strobe_lite8   (

                          //inputs8

                          .sys_clk8 (hclk8),
                          .n_sys_reset8 (n_sys_reset8),
                          .valid_access8 (valid_access8),
                          .n_read8 (n_read8),
                          .cs(cs),
                          .r_smc_currentstate8 (r_smc_currentstate8),
                          .smc_nextstate8 (smc_nextstate8),
                          .n_be8 (n_be8),
                          .r_wele_store8 (r_wele_store8),
                          .r_wele_count8 (r_wele_count8),
                          .r_wete_store8 (r_wete_store8),
                          .r_oete_store8 (r_oete_store8),
                          .r_ws_count8 (r_ws_count8),
                          .r_ws_store8 (r_ws_store8),
                          .smc_done8 (smc_done8),
                          .mac_done8 (mac_done8),
                          
                          //outputs8

                          .smc_n_rd8 (smc_n_rd8),
                          .smc_n_ext_oe8 (smc_n_ext_oe8),
                          .smc_busy8 (smc_busy8),
                          .n_r_read8 (n_r_read8),
                          .r_cs8(r_cs8),
                          .r_full8 (r_full8),
                          .n_r_we8 (n_r_we8),
                          .n_r_wr8 (n_r_wr8));
   
   smc_wr_enable_lite8 i_wr_enable_lite8 (

                            //inputs8

                          .n_sys_reset8 (n_sys_reset8),
                          .r_full8(r_full8),
                          .n_r_we8(n_r_we8),
                          .n_r_wr8 (n_r_wr8),
                              
                          //output                

                          .smc_n_we8(smc_n_we8),
                          .smc_n_wr8 (smc_n_wr8));
   
   
   
   smc_addr_lite8 i_add_lite8        (
                          //inputs8

                          .sys_clk8 (hclk8),
                          .n_sys_reset8 (n_sys_reset8),
                          .valid_access8 (valid_access8),
                          .r_num_access8 (r_num_access8),
                          .v_bus_size8 (v_bus_size8),
                          .v_xfer_size8 (v_xfer_size8),
                          .cs (cs),
                          .addr (addr),
                          .smc_done8 (smc_done8),
                          .smc_nextstate8 (smc_nextstate8),
                          
                          //outputs8

                          .smc_addr8 (smc_addr8),
                          .smc_n_be8 (smc_n_be8),
                          .smc_n_cs8 (smc_n_cs8),
                          .n_be8 (n_be8));
   
   
endmodule
