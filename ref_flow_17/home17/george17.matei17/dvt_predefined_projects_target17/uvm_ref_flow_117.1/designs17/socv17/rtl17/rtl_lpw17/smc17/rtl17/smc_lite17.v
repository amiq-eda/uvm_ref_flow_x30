//File17 name   : smc_lite17.v
//Title17       : SMC17 top level
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

 `include "smc_defs_lite17.v"

//static memory controller17
module          smc_lite17(
                    //apb17 inputs17
                    n_preset17, 
                    pclk17, 
                    psel17, 
                    penable17, 
                    pwrite17, 
                    paddr17, 
                    pwdata17,
                    //ahb17 inputs17                    
                    hclk17,
                    n_sys_reset17,
                    haddr17,
                    htrans17,
                    hsel17,
                    hwrite17,
                    hsize17,
                    hwdata17,
                    hready17,
                    data_smc17,
                    

                    //test signal17 inputs17

                    scan_in_117,
                    scan_in_217,
                    scan_in_317,
                    scan_en17,

                    //apb17 outputs17                    
                    prdata17,

                    //design output
                    
                    smc_hrdata17, 
                    smc_hready17,
                    smc_valid17,
                    smc_hresp17,
                    smc_addr17,
                    smc_data17, 
                    smc_n_be17,
                    smc_n_cs17,
                    smc_n_wr17,                    
                    smc_n_we17,
                    smc_n_rd17,
                    smc_n_ext_oe17,
                    smc_busy17,

                    //test signal17 output

                    scan_out_117,
                    scan_out_217,
                    scan_out_317
                   );
// define parameters17
// change using defaparam17 statements17


  // APB17 Inputs17 (use is optional17 on INCLUDE_APB17)
  input        n_preset17;           // APBreset17 
  input        pclk17;               // APB17 clock17
  input        psel17;               // APB17 select17
  input        penable17;            // APB17 enable 
  input        pwrite17;             // APB17 write strobe17 
  input [4:0]  paddr17;              // APB17 address bus
  input [31:0] pwdata17;             // APB17 write data 

  // APB17 Output17 (use is optional17 on INCLUDE_APB17)

  output [31:0] prdata17;        //APB17 output



//System17 I17/O17

  input                    hclk17;          // AHB17 System17 clock17
  input                    n_sys_reset17;   // AHB17 System17 reset (Active17 LOW17)

//AHB17 I17/O17

  input  [31:0]            haddr17;         // AHB17 Address
  input  [1:0]             htrans17;        // AHB17 transfer17 type
  input               hsel17;          // chip17 selects17
  input                    hwrite17;        // AHB17 read/write indication17
  input  [2:0]             hsize17;         // AHB17 transfer17 size
  input  [31:0]            hwdata17;        // AHB17 write data
  input                    hready17;        // AHB17 Muxed17 ready signal17

  
  output [31:0]            smc_hrdata17;    // smc17 read data back to AHB17 master17
  output                   smc_hready17;    // smc17 ready signal17
  output [1:0]             smc_hresp17;     // AHB17 Response17 signal17
  output                   smc_valid17;     // Ack17 valid address

//External17 memory interface (EMI17)

  output [31:0]            smc_addr17;      // External17 Memory (EMI17) address
  output [31:0]            smc_data17;      // EMI17 write data
  input  [31:0]            data_smc17;      // EMI17 read data
  output [3:0]             smc_n_be17;      // EMI17 byte enables17 (Active17 LOW17)
  output             smc_n_cs17;      // EMI17 Chip17 Selects17 (Active17 LOW17)
  output [3:0]             smc_n_we17;      // EMI17 write strobes17 (Active17 LOW17)
  output                   smc_n_wr17;      // EMI17 write enable (Active17 LOW17)
  output                   smc_n_rd17;      // EMI17 read stobe17 (Active17 LOW17)
  output 	           smc_n_ext_oe17;  // EMI17 write data output enable

//AHB17 Memory Interface17 Control17

   output                   smc_busy17;      // smc17 busy

   
   


//scan17 signals17

   input                  scan_in_117;        //scan17 input
   input                  scan_in_217;        //scan17 input
   input                  scan_en17;         //scan17 enable
   output                 scan_out_117;       //scan17 output
   output                 scan_out_217;       //scan17 output
// third17 scan17 chain17 only used on INCLUDE_APB17
   input                  scan_in_317;        //scan17 input
   output                 scan_out_317;       //scan17 output
   
//----------------------------------------------------------------------
// Signal17 declarations17
//----------------------------------------------------------------------

// Bus17 Interface17
   
  wire  [31:0]   smc_hrdata17;         //smc17 read data back to AHB17 master17
  wire           smc_hready17;         //smc17 ready signal17
  wire  [1:0]    smc_hresp17;          //AHB17 Response17 signal17
  wire           smc_valid17;          //Ack17 valid address

// MAC17

  wire [31:0]    smc_data17;           //Data to external17 bus via MUX17

// Strobe17 Generation17

  wire           smc_n_wr17;           //EMI17 write enable (Active17 LOW17)
  wire  [3:0]    smc_n_we17;           //EMI17 write strobes17 (Active17 LOW17)
  wire           smc_n_rd17;           //EMI17 read stobe17 (Active17 LOW17)
  wire           smc_busy17;           //smc17 busy
  wire           smc_n_ext_oe17;       //Enable17 External17 bus drivers17.(CS17 & !RD17)

// Address Generation17

  wire [31:0]    smc_addr17;           //External17 Memory Interface17(EMI17) address
  wire [3:0]     smc_n_be17;   //EMI17 byte enables17 (Active17 LOW17)
  wire      smc_n_cs17;   //EMI17 Chip17 Selects17 (Active17 LOW17)

// Bus17 Interface17

  wire           new_access17;         // New17 AHB17 access to smc17 detected
  wire [31:0]    addr;               // Copy17 of address
  wire [31:0]    write_data17;         // Data to External17 Bus17
  wire      cs;         // Chip17(bank17) Select17 Lines17
  wire [1:0]     xfer_size17;          // Width17 of current transfer17
  wire           n_read17;             // Active17 low17 read signal17                   
  
// Configuration17 Block


// Counters17

  wire [1:0]     r_csle_count17;       // Chip17 select17 LE17 counter
  wire [1:0]     r_wele_count17;       // Write counter
  wire [1:0]     r_cste_count17;       // chip17 select17 TE17 counter
  wire [7:0]     r_ws_count17; // Wait17 state select17 counter
  
// These17 strobes17 finish early17 so no counter is required17. The stored17 value
// is compared with WS17 counter to determine17 when the strobe17 should end.

  wire [1:0]     r_wete_store17;       // Write strobe17 TE17 end time before CS17
  wire [1:0]     r_oete_store17;       // Read strobe17 TE17 end time before CS17
  
// The following17 four17 wireisrers17 are used to store17 the configuration during
// mulitple17 accesses. The counters17 are reloaded17 from these17 wireisters17
//  before each cycle.

  wire [1:0]     r_csle_store17;       // Chip17 select17 LE17 store17
  wire [1:0]     r_wele_store17;       // Write strobe17 LE17 store17
  wire [7:0]     r_ws_store17;         // Wait17 state store17
  wire [1:0]     r_cste_store17;       // Chip17 Select17 TE17 delay (Bus17 float17 time)


// Multiple17 access control17

  wire           mac_done17;           // Indicates17 last cycle of last access
  wire [1:0]     r_num_access17;       // Access counter
  wire [1:0]     v_xfer_size17;        // Store17 size for MAC17 
  wire [1:0]     v_bus_size17;         // Store17 size for MAC17
  wire [31:0]    read_data17;          // Data path to bus IF
  wire [31:0]    r_read_data17;        // Internal data store17

// smc17 state machine17


  wire           valid_access17;       // New17 acces17 can proceed
  wire   [4:0]   smc_nextstate17;      // state machine17 (async17 encoding17)
  wire   [4:0]   r_smc_currentstate17; // Synchronised17 smc17 state machine17
  wire           ws_enable17;          // Wait17 state counter enable
  wire           cste_enable17;        // Chip17 select17 counter enable
  wire           smc_done17;           // Asserted17 during last cycle of
                                     //    an access
  wire           le_enable17;          // Start17 counters17 after STORED17 
                                     //    access
  wire           latch_data17;         // latch_data17 is used by the MAC17 
                                     //    block to store17 read data 
                                     //    if CSTE17 > 0
  wire           smc_idle17;           // idle17 state

// Address Generation17

  wire [3:0]     n_be17;               // Full cycle write strobe17

// Strobe17 Generation17

  wire           r_full17;             // Full cycle write strobe17
  wire           n_r_read17;           // Store17 RW srate17 for multiple accesses
  wire           n_r_wr17;             // write strobe17
  wire [3:0]     n_r_we17;             // write enable  
  wire      r_cs17;       // registered chip17 select17 

   //apb17
   

   wire n_sys_reset17;                        //AHB17 system reset(active low17)

// assign a default value to the signal17 if the bank17 has
// been disabled and the APB17 has been excluded17 (i.e. the config signals17
// come17 from the top level
   
   smc_apb_lite_if17 i_apb_lite17 (
                     //Inputs17
                     
                     .n_preset17(n_preset17),
                     .pclk17(pclk17),
                     .psel17(psel17),
                     .penable17(penable17),
                     .pwrite17(pwrite17),
                     .paddr17(paddr17),
                     .pwdata17(pwdata17),
                     
                    //Outputs17
                     
                     .prdata17(prdata17)
                     
                     );
   
   smc_ahb_lite_if17 i_ahb_lite17  (
                     //Inputs17
                     
		     .hclk17 (hclk17),
                     .n_sys_reset17 (n_sys_reset17),
                     .haddr17 (haddr17),
                     .hsel17 (hsel17),                                                
                     .htrans17 (htrans17),                    
                     .hwrite17 (hwrite17),
                     .hsize17 (hsize17),                
                     .hwdata17 (hwdata17),
                     .hready17 (hready17),
                     .read_data17 (read_data17),
                     .mac_done17 (mac_done17),
                     .smc_done17 (smc_done17),
                     .smc_idle17 (smc_idle17),
                     
                     // Outputs17
                     
                     .xfer_size17 (xfer_size17),
                     .n_read17 (n_read17),
                     .new_access17 (new_access17),
                     .addr (addr),
                     .smc_hrdata17 (smc_hrdata17), 
                     .smc_hready17 (smc_hready17),
                     .smc_hresp17 (smc_hresp17),
                     .smc_valid17 (smc_valid17),
                     .cs (cs),
                     .write_data17 (write_data17)
                     );
   
   

   
   
   smc_counter_lite17 i_counter_lite17 (
                          
                          // Inputs17
                          
                          .sys_clk17 (hclk17),
                          .n_sys_reset17 (n_sys_reset17),
                          .valid_access17 (valid_access17),
                          .mac_done17 (mac_done17),
                          .smc_done17 (smc_done17),
                          .cste_enable17 (cste_enable17),
                          .ws_enable17 (ws_enable17),
                          .le_enable17 (le_enable17),
                          
                          // Outputs17
                          
                          .r_csle_store17 (r_csle_store17),
                          .r_csle_count17 (r_csle_count17),
                          .r_wele_count17 (r_wele_count17),
                          .r_ws_count17 (r_ws_count17),
                          .r_ws_store17 (r_ws_store17),
                          .r_oete_store17 (r_oete_store17),
                          .r_wete_store17 (r_wete_store17),
                          .r_wele_store17 (r_wele_store17),
                          .r_cste_count17 (r_cste_count17));
   
   
   smc_mac_lite17 i_mac_lite17         (
                          
                          // Inputs17
                          
                          .sys_clk17 (hclk17),
                          .n_sys_reset17 (n_sys_reset17),
                          .valid_access17 (valid_access17),
                          .xfer_size17 (xfer_size17),
                          .smc_done17 (smc_done17),
                          .data_smc17 (data_smc17),
                          .write_data17 (write_data17),
                          .smc_nextstate17 (smc_nextstate17),
                          .latch_data17 (latch_data17),
                          
                          // Outputs17
                          
                          .r_num_access17 (r_num_access17),
                          .mac_done17 (mac_done17),
                          .v_bus_size17 (v_bus_size17),
                          .v_xfer_size17 (v_xfer_size17),
                          .read_data17 (read_data17),
                          .smc_data17 (smc_data17));
   
   
   smc_state_lite17 i_state_lite17     (
                          
                          // Inputs17
                          
                          .sys_clk17 (hclk17),
                          .n_sys_reset17 (n_sys_reset17),
                          .new_access17 (new_access17),
                          .r_cste_count17 (r_cste_count17),
                          .r_csle_count17 (r_csle_count17),
                          .r_ws_count17 (r_ws_count17),
                          .mac_done17 (mac_done17),
                          .n_read17 (n_read17),
                          .n_r_read17 (n_r_read17),
                          .r_csle_store17 (r_csle_store17),
                          .r_oete_store17 (r_oete_store17),
                          .cs(cs),
                          .r_cs17(r_cs17),

                          // Outputs17
                          
                          .r_smc_currentstate17 (r_smc_currentstate17),
                          .smc_nextstate17 (smc_nextstate17),
                          .cste_enable17 (cste_enable17),
                          .ws_enable17 (ws_enable17),
                          .smc_done17 (smc_done17),
                          .valid_access17 (valid_access17),
                          .le_enable17 (le_enable17),
                          .latch_data17 (latch_data17),
                          .smc_idle17 (smc_idle17));
   
   smc_strobe_lite17 i_strobe_lite17   (

                          //inputs17

                          .sys_clk17 (hclk17),
                          .n_sys_reset17 (n_sys_reset17),
                          .valid_access17 (valid_access17),
                          .n_read17 (n_read17),
                          .cs(cs),
                          .r_smc_currentstate17 (r_smc_currentstate17),
                          .smc_nextstate17 (smc_nextstate17),
                          .n_be17 (n_be17),
                          .r_wele_store17 (r_wele_store17),
                          .r_wele_count17 (r_wele_count17),
                          .r_wete_store17 (r_wete_store17),
                          .r_oete_store17 (r_oete_store17),
                          .r_ws_count17 (r_ws_count17),
                          .r_ws_store17 (r_ws_store17),
                          .smc_done17 (smc_done17),
                          .mac_done17 (mac_done17),
                          
                          //outputs17

                          .smc_n_rd17 (smc_n_rd17),
                          .smc_n_ext_oe17 (smc_n_ext_oe17),
                          .smc_busy17 (smc_busy17),
                          .n_r_read17 (n_r_read17),
                          .r_cs17(r_cs17),
                          .r_full17 (r_full17),
                          .n_r_we17 (n_r_we17),
                          .n_r_wr17 (n_r_wr17));
   
   smc_wr_enable_lite17 i_wr_enable_lite17 (

                            //inputs17

                          .n_sys_reset17 (n_sys_reset17),
                          .r_full17(r_full17),
                          .n_r_we17(n_r_we17),
                          .n_r_wr17 (n_r_wr17),
                              
                          //output                

                          .smc_n_we17(smc_n_we17),
                          .smc_n_wr17 (smc_n_wr17));
   
   
   
   smc_addr_lite17 i_add_lite17        (
                          //inputs17

                          .sys_clk17 (hclk17),
                          .n_sys_reset17 (n_sys_reset17),
                          .valid_access17 (valid_access17),
                          .r_num_access17 (r_num_access17),
                          .v_bus_size17 (v_bus_size17),
                          .v_xfer_size17 (v_xfer_size17),
                          .cs (cs),
                          .addr (addr),
                          .smc_done17 (smc_done17),
                          .smc_nextstate17 (smc_nextstate17),
                          
                          //outputs17

                          .smc_addr17 (smc_addr17),
                          .smc_n_be17 (smc_n_be17),
                          .smc_n_cs17 (smc_n_cs17),
                          .n_be17 (n_be17));
   
   
endmodule
