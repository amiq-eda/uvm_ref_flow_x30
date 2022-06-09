//File2 name   : smc_lite2.v
//Title2       : SMC2 top level
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

 `include "smc_defs_lite2.v"

//static memory controller2
module          smc_lite2(
                    //apb2 inputs2
                    n_preset2, 
                    pclk2, 
                    psel2, 
                    penable2, 
                    pwrite2, 
                    paddr2, 
                    pwdata2,
                    //ahb2 inputs2                    
                    hclk2,
                    n_sys_reset2,
                    haddr2,
                    htrans2,
                    hsel2,
                    hwrite2,
                    hsize2,
                    hwdata2,
                    hready2,
                    data_smc2,
                    

                    //test signal2 inputs2

                    scan_in_12,
                    scan_in_22,
                    scan_in_32,
                    scan_en2,

                    //apb2 outputs2                    
                    prdata2,

                    //design output
                    
                    smc_hrdata2, 
                    smc_hready2,
                    smc_valid2,
                    smc_hresp2,
                    smc_addr2,
                    smc_data2, 
                    smc_n_be2,
                    smc_n_cs2,
                    smc_n_wr2,                    
                    smc_n_we2,
                    smc_n_rd2,
                    smc_n_ext_oe2,
                    smc_busy2,

                    //test signal2 output

                    scan_out_12,
                    scan_out_22,
                    scan_out_32
                   );
// define parameters2
// change using defaparam2 statements2


  // APB2 Inputs2 (use is optional2 on INCLUDE_APB2)
  input        n_preset2;           // APBreset2 
  input        pclk2;               // APB2 clock2
  input        psel2;               // APB2 select2
  input        penable2;            // APB2 enable 
  input        pwrite2;             // APB2 write strobe2 
  input [4:0]  paddr2;              // APB2 address bus
  input [31:0] pwdata2;             // APB2 write data 

  // APB2 Output2 (use is optional2 on INCLUDE_APB2)

  output [31:0] prdata2;        //APB2 output



//System2 I2/O2

  input                    hclk2;          // AHB2 System2 clock2
  input                    n_sys_reset2;   // AHB2 System2 reset (Active2 LOW2)

//AHB2 I2/O2

  input  [31:0]            haddr2;         // AHB2 Address
  input  [1:0]             htrans2;        // AHB2 transfer2 type
  input               hsel2;          // chip2 selects2
  input                    hwrite2;        // AHB2 read/write indication2
  input  [2:0]             hsize2;         // AHB2 transfer2 size
  input  [31:0]            hwdata2;        // AHB2 write data
  input                    hready2;        // AHB2 Muxed2 ready signal2

  
  output [31:0]            smc_hrdata2;    // smc2 read data back to AHB2 master2
  output                   smc_hready2;    // smc2 ready signal2
  output [1:0]             smc_hresp2;     // AHB2 Response2 signal2
  output                   smc_valid2;     // Ack2 valid address

//External2 memory interface (EMI2)

  output [31:0]            smc_addr2;      // External2 Memory (EMI2) address
  output [31:0]            smc_data2;      // EMI2 write data
  input  [31:0]            data_smc2;      // EMI2 read data
  output [3:0]             smc_n_be2;      // EMI2 byte enables2 (Active2 LOW2)
  output             smc_n_cs2;      // EMI2 Chip2 Selects2 (Active2 LOW2)
  output [3:0]             smc_n_we2;      // EMI2 write strobes2 (Active2 LOW2)
  output                   smc_n_wr2;      // EMI2 write enable (Active2 LOW2)
  output                   smc_n_rd2;      // EMI2 read stobe2 (Active2 LOW2)
  output 	           smc_n_ext_oe2;  // EMI2 write data output enable

//AHB2 Memory Interface2 Control2

   output                   smc_busy2;      // smc2 busy

   
   


//scan2 signals2

   input                  scan_in_12;        //scan2 input
   input                  scan_in_22;        //scan2 input
   input                  scan_en2;         //scan2 enable
   output                 scan_out_12;       //scan2 output
   output                 scan_out_22;       //scan2 output
// third2 scan2 chain2 only used on INCLUDE_APB2
   input                  scan_in_32;        //scan2 input
   output                 scan_out_32;       //scan2 output
   
//----------------------------------------------------------------------
// Signal2 declarations2
//----------------------------------------------------------------------

// Bus2 Interface2
   
  wire  [31:0]   smc_hrdata2;         //smc2 read data back to AHB2 master2
  wire           smc_hready2;         //smc2 ready signal2
  wire  [1:0]    smc_hresp2;          //AHB2 Response2 signal2
  wire           smc_valid2;          //Ack2 valid address

// MAC2

  wire [31:0]    smc_data2;           //Data to external2 bus via MUX2

// Strobe2 Generation2

  wire           smc_n_wr2;           //EMI2 write enable (Active2 LOW2)
  wire  [3:0]    smc_n_we2;           //EMI2 write strobes2 (Active2 LOW2)
  wire           smc_n_rd2;           //EMI2 read stobe2 (Active2 LOW2)
  wire           smc_busy2;           //smc2 busy
  wire           smc_n_ext_oe2;       //Enable2 External2 bus drivers2.(CS2 & !RD2)

// Address Generation2

  wire [31:0]    smc_addr2;           //External2 Memory Interface2(EMI2) address
  wire [3:0]     smc_n_be2;   //EMI2 byte enables2 (Active2 LOW2)
  wire      smc_n_cs2;   //EMI2 Chip2 Selects2 (Active2 LOW2)

// Bus2 Interface2

  wire           new_access2;         // New2 AHB2 access to smc2 detected
  wire [31:0]    addr;               // Copy2 of address
  wire [31:0]    write_data2;         // Data to External2 Bus2
  wire      cs;         // Chip2(bank2) Select2 Lines2
  wire [1:0]     xfer_size2;          // Width2 of current transfer2
  wire           n_read2;             // Active2 low2 read signal2                   
  
// Configuration2 Block


// Counters2

  wire [1:0]     r_csle_count2;       // Chip2 select2 LE2 counter
  wire [1:0]     r_wele_count2;       // Write counter
  wire [1:0]     r_cste_count2;       // chip2 select2 TE2 counter
  wire [7:0]     r_ws_count2; // Wait2 state select2 counter
  
// These2 strobes2 finish early2 so no counter is required2. The stored2 value
// is compared with WS2 counter to determine2 when the strobe2 should end.

  wire [1:0]     r_wete_store2;       // Write strobe2 TE2 end time before CS2
  wire [1:0]     r_oete_store2;       // Read strobe2 TE2 end time before CS2
  
// The following2 four2 wireisrers2 are used to store2 the configuration during
// mulitple2 accesses. The counters2 are reloaded2 from these2 wireisters2
//  before each cycle.

  wire [1:0]     r_csle_store2;       // Chip2 select2 LE2 store2
  wire [1:0]     r_wele_store2;       // Write strobe2 LE2 store2
  wire [7:0]     r_ws_store2;         // Wait2 state store2
  wire [1:0]     r_cste_store2;       // Chip2 Select2 TE2 delay (Bus2 float2 time)


// Multiple2 access control2

  wire           mac_done2;           // Indicates2 last cycle of last access
  wire [1:0]     r_num_access2;       // Access counter
  wire [1:0]     v_xfer_size2;        // Store2 size for MAC2 
  wire [1:0]     v_bus_size2;         // Store2 size for MAC2
  wire [31:0]    read_data2;          // Data path to bus IF
  wire [31:0]    r_read_data2;        // Internal data store2

// smc2 state machine2


  wire           valid_access2;       // New2 acces2 can proceed
  wire   [4:0]   smc_nextstate2;      // state machine2 (async2 encoding2)
  wire   [4:0]   r_smc_currentstate2; // Synchronised2 smc2 state machine2
  wire           ws_enable2;          // Wait2 state counter enable
  wire           cste_enable2;        // Chip2 select2 counter enable
  wire           smc_done2;           // Asserted2 during last cycle of
                                     //    an access
  wire           le_enable2;          // Start2 counters2 after STORED2 
                                     //    access
  wire           latch_data2;         // latch_data2 is used by the MAC2 
                                     //    block to store2 read data 
                                     //    if CSTE2 > 0
  wire           smc_idle2;           // idle2 state

// Address Generation2

  wire [3:0]     n_be2;               // Full cycle write strobe2

// Strobe2 Generation2

  wire           r_full2;             // Full cycle write strobe2
  wire           n_r_read2;           // Store2 RW srate2 for multiple accesses
  wire           n_r_wr2;             // write strobe2
  wire [3:0]     n_r_we2;             // write enable  
  wire      r_cs2;       // registered chip2 select2 

   //apb2
   

   wire n_sys_reset2;                        //AHB2 system reset(active low2)

// assign a default value to the signal2 if the bank2 has
// been disabled and the APB2 has been excluded2 (i.e. the config signals2
// come2 from the top level
   
   smc_apb_lite_if2 i_apb_lite2 (
                     //Inputs2
                     
                     .n_preset2(n_preset2),
                     .pclk2(pclk2),
                     .psel2(psel2),
                     .penable2(penable2),
                     .pwrite2(pwrite2),
                     .paddr2(paddr2),
                     .pwdata2(pwdata2),
                     
                    //Outputs2
                     
                     .prdata2(prdata2)
                     
                     );
   
   smc_ahb_lite_if2 i_ahb_lite2  (
                     //Inputs2
                     
		     .hclk2 (hclk2),
                     .n_sys_reset2 (n_sys_reset2),
                     .haddr2 (haddr2),
                     .hsel2 (hsel2),                                                
                     .htrans2 (htrans2),                    
                     .hwrite2 (hwrite2),
                     .hsize2 (hsize2),                
                     .hwdata2 (hwdata2),
                     .hready2 (hready2),
                     .read_data2 (read_data2),
                     .mac_done2 (mac_done2),
                     .smc_done2 (smc_done2),
                     .smc_idle2 (smc_idle2),
                     
                     // Outputs2
                     
                     .xfer_size2 (xfer_size2),
                     .n_read2 (n_read2),
                     .new_access2 (new_access2),
                     .addr (addr),
                     .smc_hrdata2 (smc_hrdata2), 
                     .smc_hready2 (smc_hready2),
                     .smc_hresp2 (smc_hresp2),
                     .smc_valid2 (smc_valid2),
                     .cs (cs),
                     .write_data2 (write_data2)
                     );
   
   

   
   
   smc_counter_lite2 i_counter_lite2 (
                          
                          // Inputs2
                          
                          .sys_clk2 (hclk2),
                          .n_sys_reset2 (n_sys_reset2),
                          .valid_access2 (valid_access2),
                          .mac_done2 (mac_done2),
                          .smc_done2 (smc_done2),
                          .cste_enable2 (cste_enable2),
                          .ws_enable2 (ws_enable2),
                          .le_enable2 (le_enable2),
                          
                          // Outputs2
                          
                          .r_csle_store2 (r_csle_store2),
                          .r_csle_count2 (r_csle_count2),
                          .r_wele_count2 (r_wele_count2),
                          .r_ws_count2 (r_ws_count2),
                          .r_ws_store2 (r_ws_store2),
                          .r_oete_store2 (r_oete_store2),
                          .r_wete_store2 (r_wete_store2),
                          .r_wele_store2 (r_wele_store2),
                          .r_cste_count2 (r_cste_count2));
   
   
   smc_mac_lite2 i_mac_lite2         (
                          
                          // Inputs2
                          
                          .sys_clk2 (hclk2),
                          .n_sys_reset2 (n_sys_reset2),
                          .valid_access2 (valid_access2),
                          .xfer_size2 (xfer_size2),
                          .smc_done2 (smc_done2),
                          .data_smc2 (data_smc2),
                          .write_data2 (write_data2),
                          .smc_nextstate2 (smc_nextstate2),
                          .latch_data2 (latch_data2),
                          
                          // Outputs2
                          
                          .r_num_access2 (r_num_access2),
                          .mac_done2 (mac_done2),
                          .v_bus_size2 (v_bus_size2),
                          .v_xfer_size2 (v_xfer_size2),
                          .read_data2 (read_data2),
                          .smc_data2 (smc_data2));
   
   
   smc_state_lite2 i_state_lite2     (
                          
                          // Inputs2
                          
                          .sys_clk2 (hclk2),
                          .n_sys_reset2 (n_sys_reset2),
                          .new_access2 (new_access2),
                          .r_cste_count2 (r_cste_count2),
                          .r_csle_count2 (r_csle_count2),
                          .r_ws_count2 (r_ws_count2),
                          .mac_done2 (mac_done2),
                          .n_read2 (n_read2),
                          .n_r_read2 (n_r_read2),
                          .r_csle_store2 (r_csle_store2),
                          .r_oete_store2 (r_oete_store2),
                          .cs(cs),
                          .r_cs2(r_cs2),

                          // Outputs2
                          
                          .r_smc_currentstate2 (r_smc_currentstate2),
                          .smc_nextstate2 (smc_nextstate2),
                          .cste_enable2 (cste_enable2),
                          .ws_enable2 (ws_enable2),
                          .smc_done2 (smc_done2),
                          .valid_access2 (valid_access2),
                          .le_enable2 (le_enable2),
                          .latch_data2 (latch_data2),
                          .smc_idle2 (smc_idle2));
   
   smc_strobe_lite2 i_strobe_lite2   (

                          //inputs2

                          .sys_clk2 (hclk2),
                          .n_sys_reset2 (n_sys_reset2),
                          .valid_access2 (valid_access2),
                          .n_read2 (n_read2),
                          .cs(cs),
                          .r_smc_currentstate2 (r_smc_currentstate2),
                          .smc_nextstate2 (smc_nextstate2),
                          .n_be2 (n_be2),
                          .r_wele_store2 (r_wele_store2),
                          .r_wele_count2 (r_wele_count2),
                          .r_wete_store2 (r_wete_store2),
                          .r_oete_store2 (r_oete_store2),
                          .r_ws_count2 (r_ws_count2),
                          .r_ws_store2 (r_ws_store2),
                          .smc_done2 (smc_done2),
                          .mac_done2 (mac_done2),
                          
                          //outputs2

                          .smc_n_rd2 (smc_n_rd2),
                          .smc_n_ext_oe2 (smc_n_ext_oe2),
                          .smc_busy2 (smc_busy2),
                          .n_r_read2 (n_r_read2),
                          .r_cs2(r_cs2),
                          .r_full2 (r_full2),
                          .n_r_we2 (n_r_we2),
                          .n_r_wr2 (n_r_wr2));
   
   smc_wr_enable_lite2 i_wr_enable_lite2 (

                            //inputs2

                          .n_sys_reset2 (n_sys_reset2),
                          .r_full2(r_full2),
                          .n_r_we2(n_r_we2),
                          .n_r_wr2 (n_r_wr2),
                              
                          //output                

                          .smc_n_we2(smc_n_we2),
                          .smc_n_wr2 (smc_n_wr2));
   
   
   
   smc_addr_lite2 i_add_lite2        (
                          //inputs2

                          .sys_clk2 (hclk2),
                          .n_sys_reset2 (n_sys_reset2),
                          .valid_access2 (valid_access2),
                          .r_num_access2 (r_num_access2),
                          .v_bus_size2 (v_bus_size2),
                          .v_xfer_size2 (v_xfer_size2),
                          .cs (cs),
                          .addr (addr),
                          .smc_done2 (smc_done2),
                          .smc_nextstate2 (smc_nextstate2),
                          
                          //outputs2

                          .smc_addr2 (smc_addr2),
                          .smc_n_be2 (smc_n_be2),
                          .smc_n_cs2 (smc_n_cs2),
                          .n_be2 (n_be2));
   
   
endmodule
