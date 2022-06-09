//File26 name   : smc_lite26.v
//Title26       : SMC26 top level
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

 `include "smc_defs_lite26.v"

//static memory controller26
module          smc_lite26(
                    //apb26 inputs26
                    n_preset26, 
                    pclk26, 
                    psel26, 
                    penable26, 
                    pwrite26, 
                    paddr26, 
                    pwdata26,
                    //ahb26 inputs26                    
                    hclk26,
                    n_sys_reset26,
                    haddr26,
                    htrans26,
                    hsel26,
                    hwrite26,
                    hsize26,
                    hwdata26,
                    hready26,
                    data_smc26,
                    

                    //test signal26 inputs26

                    scan_in_126,
                    scan_in_226,
                    scan_in_326,
                    scan_en26,

                    //apb26 outputs26                    
                    prdata26,

                    //design output
                    
                    smc_hrdata26, 
                    smc_hready26,
                    smc_valid26,
                    smc_hresp26,
                    smc_addr26,
                    smc_data26, 
                    smc_n_be26,
                    smc_n_cs26,
                    smc_n_wr26,                    
                    smc_n_we26,
                    smc_n_rd26,
                    smc_n_ext_oe26,
                    smc_busy26,

                    //test signal26 output

                    scan_out_126,
                    scan_out_226,
                    scan_out_326
                   );
// define parameters26
// change using defaparam26 statements26


  // APB26 Inputs26 (use is optional26 on INCLUDE_APB26)
  input        n_preset26;           // APBreset26 
  input        pclk26;               // APB26 clock26
  input        psel26;               // APB26 select26
  input        penable26;            // APB26 enable 
  input        pwrite26;             // APB26 write strobe26 
  input [4:0]  paddr26;              // APB26 address bus
  input [31:0] pwdata26;             // APB26 write data 

  // APB26 Output26 (use is optional26 on INCLUDE_APB26)

  output [31:0] prdata26;        //APB26 output



//System26 I26/O26

  input                    hclk26;          // AHB26 System26 clock26
  input                    n_sys_reset26;   // AHB26 System26 reset (Active26 LOW26)

//AHB26 I26/O26

  input  [31:0]            haddr26;         // AHB26 Address
  input  [1:0]             htrans26;        // AHB26 transfer26 type
  input               hsel26;          // chip26 selects26
  input                    hwrite26;        // AHB26 read/write indication26
  input  [2:0]             hsize26;         // AHB26 transfer26 size
  input  [31:0]            hwdata26;        // AHB26 write data
  input                    hready26;        // AHB26 Muxed26 ready signal26

  
  output [31:0]            smc_hrdata26;    // smc26 read data back to AHB26 master26
  output                   smc_hready26;    // smc26 ready signal26
  output [1:0]             smc_hresp26;     // AHB26 Response26 signal26
  output                   smc_valid26;     // Ack26 valid address

//External26 memory interface (EMI26)

  output [31:0]            smc_addr26;      // External26 Memory (EMI26) address
  output [31:0]            smc_data26;      // EMI26 write data
  input  [31:0]            data_smc26;      // EMI26 read data
  output [3:0]             smc_n_be26;      // EMI26 byte enables26 (Active26 LOW26)
  output             smc_n_cs26;      // EMI26 Chip26 Selects26 (Active26 LOW26)
  output [3:0]             smc_n_we26;      // EMI26 write strobes26 (Active26 LOW26)
  output                   smc_n_wr26;      // EMI26 write enable (Active26 LOW26)
  output                   smc_n_rd26;      // EMI26 read stobe26 (Active26 LOW26)
  output 	           smc_n_ext_oe26;  // EMI26 write data output enable

//AHB26 Memory Interface26 Control26

   output                   smc_busy26;      // smc26 busy

   
   


//scan26 signals26

   input                  scan_in_126;        //scan26 input
   input                  scan_in_226;        //scan26 input
   input                  scan_en26;         //scan26 enable
   output                 scan_out_126;       //scan26 output
   output                 scan_out_226;       //scan26 output
// third26 scan26 chain26 only used on INCLUDE_APB26
   input                  scan_in_326;        //scan26 input
   output                 scan_out_326;       //scan26 output
   
//----------------------------------------------------------------------
// Signal26 declarations26
//----------------------------------------------------------------------

// Bus26 Interface26
   
  wire  [31:0]   smc_hrdata26;         //smc26 read data back to AHB26 master26
  wire           smc_hready26;         //smc26 ready signal26
  wire  [1:0]    smc_hresp26;          //AHB26 Response26 signal26
  wire           smc_valid26;          //Ack26 valid address

// MAC26

  wire [31:0]    smc_data26;           //Data to external26 bus via MUX26

// Strobe26 Generation26

  wire           smc_n_wr26;           //EMI26 write enable (Active26 LOW26)
  wire  [3:0]    smc_n_we26;           //EMI26 write strobes26 (Active26 LOW26)
  wire           smc_n_rd26;           //EMI26 read stobe26 (Active26 LOW26)
  wire           smc_busy26;           //smc26 busy
  wire           smc_n_ext_oe26;       //Enable26 External26 bus drivers26.(CS26 & !RD26)

// Address Generation26

  wire [31:0]    smc_addr26;           //External26 Memory Interface26(EMI26) address
  wire [3:0]     smc_n_be26;   //EMI26 byte enables26 (Active26 LOW26)
  wire      smc_n_cs26;   //EMI26 Chip26 Selects26 (Active26 LOW26)

// Bus26 Interface26

  wire           new_access26;         // New26 AHB26 access to smc26 detected
  wire [31:0]    addr;               // Copy26 of address
  wire [31:0]    write_data26;         // Data to External26 Bus26
  wire      cs;         // Chip26(bank26) Select26 Lines26
  wire [1:0]     xfer_size26;          // Width26 of current transfer26
  wire           n_read26;             // Active26 low26 read signal26                   
  
// Configuration26 Block


// Counters26

  wire [1:0]     r_csle_count26;       // Chip26 select26 LE26 counter
  wire [1:0]     r_wele_count26;       // Write counter
  wire [1:0]     r_cste_count26;       // chip26 select26 TE26 counter
  wire [7:0]     r_ws_count26; // Wait26 state select26 counter
  
// These26 strobes26 finish early26 so no counter is required26. The stored26 value
// is compared with WS26 counter to determine26 when the strobe26 should end.

  wire [1:0]     r_wete_store26;       // Write strobe26 TE26 end time before CS26
  wire [1:0]     r_oete_store26;       // Read strobe26 TE26 end time before CS26
  
// The following26 four26 wireisrers26 are used to store26 the configuration during
// mulitple26 accesses. The counters26 are reloaded26 from these26 wireisters26
//  before each cycle.

  wire [1:0]     r_csle_store26;       // Chip26 select26 LE26 store26
  wire [1:0]     r_wele_store26;       // Write strobe26 LE26 store26
  wire [7:0]     r_ws_store26;         // Wait26 state store26
  wire [1:0]     r_cste_store26;       // Chip26 Select26 TE26 delay (Bus26 float26 time)


// Multiple26 access control26

  wire           mac_done26;           // Indicates26 last cycle of last access
  wire [1:0]     r_num_access26;       // Access counter
  wire [1:0]     v_xfer_size26;        // Store26 size for MAC26 
  wire [1:0]     v_bus_size26;         // Store26 size for MAC26
  wire [31:0]    read_data26;          // Data path to bus IF
  wire [31:0]    r_read_data26;        // Internal data store26

// smc26 state machine26


  wire           valid_access26;       // New26 acces26 can proceed
  wire   [4:0]   smc_nextstate26;      // state machine26 (async26 encoding26)
  wire   [4:0]   r_smc_currentstate26; // Synchronised26 smc26 state machine26
  wire           ws_enable26;          // Wait26 state counter enable
  wire           cste_enable26;        // Chip26 select26 counter enable
  wire           smc_done26;           // Asserted26 during last cycle of
                                     //    an access
  wire           le_enable26;          // Start26 counters26 after STORED26 
                                     //    access
  wire           latch_data26;         // latch_data26 is used by the MAC26 
                                     //    block to store26 read data 
                                     //    if CSTE26 > 0
  wire           smc_idle26;           // idle26 state

// Address Generation26

  wire [3:0]     n_be26;               // Full cycle write strobe26

// Strobe26 Generation26

  wire           r_full26;             // Full cycle write strobe26
  wire           n_r_read26;           // Store26 RW srate26 for multiple accesses
  wire           n_r_wr26;             // write strobe26
  wire [3:0]     n_r_we26;             // write enable  
  wire      r_cs26;       // registered chip26 select26 

   //apb26
   

   wire n_sys_reset26;                        //AHB26 system reset(active low26)

// assign a default value to the signal26 if the bank26 has
// been disabled and the APB26 has been excluded26 (i.e. the config signals26
// come26 from the top level
   
   smc_apb_lite_if26 i_apb_lite26 (
                     //Inputs26
                     
                     .n_preset26(n_preset26),
                     .pclk26(pclk26),
                     .psel26(psel26),
                     .penable26(penable26),
                     .pwrite26(pwrite26),
                     .paddr26(paddr26),
                     .pwdata26(pwdata26),
                     
                    //Outputs26
                     
                     .prdata26(prdata26)
                     
                     );
   
   smc_ahb_lite_if26 i_ahb_lite26  (
                     //Inputs26
                     
		     .hclk26 (hclk26),
                     .n_sys_reset26 (n_sys_reset26),
                     .haddr26 (haddr26),
                     .hsel26 (hsel26),                                                
                     .htrans26 (htrans26),                    
                     .hwrite26 (hwrite26),
                     .hsize26 (hsize26),                
                     .hwdata26 (hwdata26),
                     .hready26 (hready26),
                     .read_data26 (read_data26),
                     .mac_done26 (mac_done26),
                     .smc_done26 (smc_done26),
                     .smc_idle26 (smc_idle26),
                     
                     // Outputs26
                     
                     .xfer_size26 (xfer_size26),
                     .n_read26 (n_read26),
                     .new_access26 (new_access26),
                     .addr (addr),
                     .smc_hrdata26 (smc_hrdata26), 
                     .smc_hready26 (smc_hready26),
                     .smc_hresp26 (smc_hresp26),
                     .smc_valid26 (smc_valid26),
                     .cs (cs),
                     .write_data26 (write_data26)
                     );
   
   

   
   
   smc_counter_lite26 i_counter_lite26 (
                          
                          // Inputs26
                          
                          .sys_clk26 (hclk26),
                          .n_sys_reset26 (n_sys_reset26),
                          .valid_access26 (valid_access26),
                          .mac_done26 (mac_done26),
                          .smc_done26 (smc_done26),
                          .cste_enable26 (cste_enable26),
                          .ws_enable26 (ws_enable26),
                          .le_enable26 (le_enable26),
                          
                          // Outputs26
                          
                          .r_csle_store26 (r_csle_store26),
                          .r_csle_count26 (r_csle_count26),
                          .r_wele_count26 (r_wele_count26),
                          .r_ws_count26 (r_ws_count26),
                          .r_ws_store26 (r_ws_store26),
                          .r_oete_store26 (r_oete_store26),
                          .r_wete_store26 (r_wete_store26),
                          .r_wele_store26 (r_wele_store26),
                          .r_cste_count26 (r_cste_count26));
   
   
   smc_mac_lite26 i_mac_lite26         (
                          
                          // Inputs26
                          
                          .sys_clk26 (hclk26),
                          .n_sys_reset26 (n_sys_reset26),
                          .valid_access26 (valid_access26),
                          .xfer_size26 (xfer_size26),
                          .smc_done26 (smc_done26),
                          .data_smc26 (data_smc26),
                          .write_data26 (write_data26),
                          .smc_nextstate26 (smc_nextstate26),
                          .latch_data26 (latch_data26),
                          
                          // Outputs26
                          
                          .r_num_access26 (r_num_access26),
                          .mac_done26 (mac_done26),
                          .v_bus_size26 (v_bus_size26),
                          .v_xfer_size26 (v_xfer_size26),
                          .read_data26 (read_data26),
                          .smc_data26 (smc_data26));
   
   
   smc_state_lite26 i_state_lite26     (
                          
                          // Inputs26
                          
                          .sys_clk26 (hclk26),
                          .n_sys_reset26 (n_sys_reset26),
                          .new_access26 (new_access26),
                          .r_cste_count26 (r_cste_count26),
                          .r_csle_count26 (r_csle_count26),
                          .r_ws_count26 (r_ws_count26),
                          .mac_done26 (mac_done26),
                          .n_read26 (n_read26),
                          .n_r_read26 (n_r_read26),
                          .r_csle_store26 (r_csle_store26),
                          .r_oete_store26 (r_oete_store26),
                          .cs(cs),
                          .r_cs26(r_cs26),

                          // Outputs26
                          
                          .r_smc_currentstate26 (r_smc_currentstate26),
                          .smc_nextstate26 (smc_nextstate26),
                          .cste_enable26 (cste_enable26),
                          .ws_enable26 (ws_enable26),
                          .smc_done26 (smc_done26),
                          .valid_access26 (valid_access26),
                          .le_enable26 (le_enable26),
                          .latch_data26 (latch_data26),
                          .smc_idle26 (smc_idle26));
   
   smc_strobe_lite26 i_strobe_lite26   (

                          //inputs26

                          .sys_clk26 (hclk26),
                          .n_sys_reset26 (n_sys_reset26),
                          .valid_access26 (valid_access26),
                          .n_read26 (n_read26),
                          .cs(cs),
                          .r_smc_currentstate26 (r_smc_currentstate26),
                          .smc_nextstate26 (smc_nextstate26),
                          .n_be26 (n_be26),
                          .r_wele_store26 (r_wele_store26),
                          .r_wele_count26 (r_wele_count26),
                          .r_wete_store26 (r_wete_store26),
                          .r_oete_store26 (r_oete_store26),
                          .r_ws_count26 (r_ws_count26),
                          .r_ws_store26 (r_ws_store26),
                          .smc_done26 (smc_done26),
                          .mac_done26 (mac_done26),
                          
                          //outputs26

                          .smc_n_rd26 (smc_n_rd26),
                          .smc_n_ext_oe26 (smc_n_ext_oe26),
                          .smc_busy26 (smc_busy26),
                          .n_r_read26 (n_r_read26),
                          .r_cs26(r_cs26),
                          .r_full26 (r_full26),
                          .n_r_we26 (n_r_we26),
                          .n_r_wr26 (n_r_wr26));
   
   smc_wr_enable_lite26 i_wr_enable_lite26 (

                            //inputs26

                          .n_sys_reset26 (n_sys_reset26),
                          .r_full26(r_full26),
                          .n_r_we26(n_r_we26),
                          .n_r_wr26 (n_r_wr26),
                              
                          //output                

                          .smc_n_we26(smc_n_we26),
                          .smc_n_wr26 (smc_n_wr26));
   
   
   
   smc_addr_lite26 i_add_lite26        (
                          //inputs26

                          .sys_clk26 (hclk26),
                          .n_sys_reset26 (n_sys_reset26),
                          .valid_access26 (valid_access26),
                          .r_num_access26 (r_num_access26),
                          .v_bus_size26 (v_bus_size26),
                          .v_xfer_size26 (v_xfer_size26),
                          .cs (cs),
                          .addr (addr),
                          .smc_done26 (smc_done26),
                          .smc_nextstate26 (smc_nextstate26),
                          
                          //outputs26

                          .smc_addr26 (smc_addr26),
                          .smc_n_be26 (smc_n_be26),
                          .smc_n_cs26 (smc_n_cs26),
                          .n_be26 (n_be26));
   
   
endmodule
