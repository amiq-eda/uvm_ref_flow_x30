//File22 name   : smc_lite22.v
//Title22       : SMC22 top level
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

 `include "smc_defs_lite22.v"

//static memory controller22
module          smc_lite22(
                    //apb22 inputs22
                    n_preset22, 
                    pclk22, 
                    psel22, 
                    penable22, 
                    pwrite22, 
                    paddr22, 
                    pwdata22,
                    //ahb22 inputs22                    
                    hclk22,
                    n_sys_reset22,
                    haddr22,
                    htrans22,
                    hsel22,
                    hwrite22,
                    hsize22,
                    hwdata22,
                    hready22,
                    data_smc22,
                    

                    //test signal22 inputs22

                    scan_in_122,
                    scan_in_222,
                    scan_in_322,
                    scan_en22,

                    //apb22 outputs22                    
                    prdata22,

                    //design output
                    
                    smc_hrdata22, 
                    smc_hready22,
                    smc_valid22,
                    smc_hresp22,
                    smc_addr22,
                    smc_data22, 
                    smc_n_be22,
                    smc_n_cs22,
                    smc_n_wr22,                    
                    smc_n_we22,
                    smc_n_rd22,
                    smc_n_ext_oe22,
                    smc_busy22,

                    //test signal22 output

                    scan_out_122,
                    scan_out_222,
                    scan_out_322
                   );
// define parameters22
// change using defaparam22 statements22


  // APB22 Inputs22 (use is optional22 on INCLUDE_APB22)
  input        n_preset22;           // APBreset22 
  input        pclk22;               // APB22 clock22
  input        psel22;               // APB22 select22
  input        penable22;            // APB22 enable 
  input        pwrite22;             // APB22 write strobe22 
  input [4:0]  paddr22;              // APB22 address bus
  input [31:0] pwdata22;             // APB22 write data 

  // APB22 Output22 (use is optional22 on INCLUDE_APB22)

  output [31:0] prdata22;        //APB22 output



//System22 I22/O22

  input                    hclk22;          // AHB22 System22 clock22
  input                    n_sys_reset22;   // AHB22 System22 reset (Active22 LOW22)

//AHB22 I22/O22

  input  [31:0]            haddr22;         // AHB22 Address
  input  [1:0]             htrans22;        // AHB22 transfer22 type
  input               hsel22;          // chip22 selects22
  input                    hwrite22;        // AHB22 read/write indication22
  input  [2:0]             hsize22;         // AHB22 transfer22 size
  input  [31:0]            hwdata22;        // AHB22 write data
  input                    hready22;        // AHB22 Muxed22 ready signal22

  
  output [31:0]            smc_hrdata22;    // smc22 read data back to AHB22 master22
  output                   smc_hready22;    // smc22 ready signal22
  output [1:0]             smc_hresp22;     // AHB22 Response22 signal22
  output                   smc_valid22;     // Ack22 valid address

//External22 memory interface (EMI22)

  output [31:0]            smc_addr22;      // External22 Memory (EMI22) address
  output [31:0]            smc_data22;      // EMI22 write data
  input  [31:0]            data_smc22;      // EMI22 read data
  output [3:0]             smc_n_be22;      // EMI22 byte enables22 (Active22 LOW22)
  output             smc_n_cs22;      // EMI22 Chip22 Selects22 (Active22 LOW22)
  output [3:0]             smc_n_we22;      // EMI22 write strobes22 (Active22 LOW22)
  output                   smc_n_wr22;      // EMI22 write enable (Active22 LOW22)
  output                   smc_n_rd22;      // EMI22 read stobe22 (Active22 LOW22)
  output 	           smc_n_ext_oe22;  // EMI22 write data output enable

//AHB22 Memory Interface22 Control22

   output                   smc_busy22;      // smc22 busy

   
   


//scan22 signals22

   input                  scan_in_122;        //scan22 input
   input                  scan_in_222;        //scan22 input
   input                  scan_en22;         //scan22 enable
   output                 scan_out_122;       //scan22 output
   output                 scan_out_222;       //scan22 output
// third22 scan22 chain22 only used on INCLUDE_APB22
   input                  scan_in_322;        //scan22 input
   output                 scan_out_322;       //scan22 output
   
//----------------------------------------------------------------------
// Signal22 declarations22
//----------------------------------------------------------------------

// Bus22 Interface22
   
  wire  [31:0]   smc_hrdata22;         //smc22 read data back to AHB22 master22
  wire           smc_hready22;         //smc22 ready signal22
  wire  [1:0]    smc_hresp22;          //AHB22 Response22 signal22
  wire           smc_valid22;          //Ack22 valid address

// MAC22

  wire [31:0]    smc_data22;           //Data to external22 bus via MUX22

// Strobe22 Generation22

  wire           smc_n_wr22;           //EMI22 write enable (Active22 LOW22)
  wire  [3:0]    smc_n_we22;           //EMI22 write strobes22 (Active22 LOW22)
  wire           smc_n_rd22;           //EMI22 read stobe22 (Active22 LOW22)
  wire           smc_busy22;           //smc22 busy
  wire           smc_n_ext_oe22;       //Enable22 External22 bus drivers22.(CS22 & !RD22)

// Address Generation22

  wire [31:0]    smc_addr22;           //External22 Memory Interface22(EMI22) address
  wire [3:0]     smc_n_be22;   //EMI22 byte enables22 (Active22 LOW22)
  wire      smc_n_cs22;   //EMI22 Chip22 Selects22 (Active22 LOW22)

// Bus22 Interface22

  wire           new_access22;         // New22 AHB22 access to smc22 detected
  wire [31:0]    addr;               // Copy22 of address
  wire [31:0]    write_data22;         // Data to External22 Bus22
  wire      cs;         // Chip22(bank22) Select22 Lines22
  wire [1:0]     xfer_size22;          // Width22 of current transfer22
  wire           n_read22;             // Active22 low22 read signal22                   
  
// Configuration22 Block


// Counters22

  wire [1:0]     r_csle_count22;       // Chip22 select22 LE22 counter
  wire [1:0]     r_wele_count22;       // Write counter
  wire [1:0]     r_cste_count22;       // chip22 select22 TE22 counter
  wire [7:0]     r_ws_count22; // Wait22 state select22 counter
  
// These22 strobes22 finish early22 so no counter is required22. The stored22 value
// is compared with WS22 counter to determine22 when the strobe22 should end.

  wire [1:0]     r_wete_store22;       // Write strobe22 TE22 end time before CS22
  wire [1:0]     r_oete_store22;       // Read strobe22 TE22 end time before CS22
  
// The following22 four22 wireisrers22 are used to store22 the configuration during
// mulitple22 accesses. The counters22 are reloaded22 from these22 wireisters22
//  before each cycle.

  wire [1:0]     r_csle_store22;       // Chip22 select22 LE22 store22
  wire [1:0]     r_wele_store22;       // Write strobe22 LE22 store22
  wire [7:0]     r_ws_store22;         // Wait22 state store22
  wire [1:0]     r_cste_store22;       // Chip22 Select22 TE22 delay (Bus22 float22 time)


// Multiple22 access control22

  wire           mac_done22;           // Indicates22 last cycle of last access
  wire [1:0]     r_num_access22;       // Access counter
  wire [1:0]     v_xfer_size22;        // Store22 size for MAC22 
  wire [1:0]     v_bus_size22;         // Store22 size for MAC22
  wire [31:0]    read_data22;          // Data path to bus IF
  wire [31:0]    r_read_data22;        // Internal data store22

// smc22 state machine22


  wire           valid_access22;       // New22 acces22 can proceed
  wire   [4:0]   smc_nextstate22;      // state machine22 (async22 encoding22)
  wire   [4:0]   r_smc_currentstate22; // Synchronised22 smc22 state machine22
  wire           ws_enable22;          // Wait22 state counter enable
  wire           cste_enable22;        // Chip22 select22 counter enable
  wire           smc_done22;           // Asserted22 during last cycle of
                                     //    an access
  wire           le_enable22;          // Start22 counters22 after STORED22 
                                     //    access
  wire           latch_data22;         // latch_data22 is used by the MAC22 
                                     //    block to store22 read data 
                                     //    if CSTE22 > 0
  wire           smc_idle22;           // idle22 state

// Address Generation22

  wire [3:0]     n_be22;               // Full cycle write strobe22

// Strobe22 Generation22

  wire           r_full22;             // Full cycle write strobe22
  wire           n_r_read22;           // Store22 RW srate22 for multiple accesses
  wire           n_r_wr22;             // write strobe22
  wire [3:0]     n_r_we22;             // write enable  
  wire      r_cs22;       // registered chip22 select22 

   //apb22
   

   wire n_sys_reset22;                        //AHB22 system reset(active low22)

// assign a default value to the signal22 if the bank22 has
// been disabled and the APB22 has been excluded22 (i.e. the config signals22
// come22 from the top level
   
   smc_apb_lite_if22 i_apb_lite22 (
                     //Inputs22
                     
                     .n_preset22(n_preset22),
                     .pclk22(pclk22),
                     .psel22(psel22),
                     .penable22(penable22),
                     .pwrite22(pwrite22),
                     .paddr22(paddr22),
                     .pwdata22(pwdata22),
                     
                    //Outputs22
                     
                     .prdata22(prdata22)
                     
                     );
   
   smc_ahb_lite_if22 i_ahb_lite22  (
                     //Inputs22
                     
		     .hclk22 (hclk22),
                     .n_sys_reset22 (n_sys_reset22),
                     .haddr22 (haddr22),
                     .hsel22 (hsel22),                                                
                     .htrans22 (htrans22),                    
                     .hwrite22 (hwrite22),
                     .hsize22 (hsize22),                
                     .hwdata22 (hwdata22),
                     .hready22 (hready22),
                     .read_data22 (read_data22),
                     .mac_done22 (mac_done22),
                     .smc_done22 (smc_done22),
                     .smc_idle22 (smc_idle22),
                     
                     // Outputs22
                     
                     .xfer_size22 (xfer_size22),
                     .n_read22 (n_read22),
                     .new_access22 (new_access22),
                     .addr (addr),
                     .smc_hrdata22 (smc_hrdata22), 
                     .smc_hready22 (smc_hready22),
                     .smc_hresp22 (smc_hresp22),
                     .smc_valid22 (smc_valid22),
                     .cs (cs),
                     .write_data22 (write_data22)
                     );
   
   

   
   
   smc_counter_lite22 i_counter_lite22 (
                          
                          // Inputs22
                          
                          .sys_clk22 (hclk22),
                          .n_sys_reset22 (n_sys_reset22),
                          .valid_access22 (valid_access22),
                          .mac_done22 (mac_done22),
                          .smc_done22 (smc_done22),
                          .cste_enable22 (cste_enable22),
                          .ws_enable22 (ws_enable22),
                          .le_enable22 (le_enable22),
                          
                          // Outputs22
                          
                          .r_csle_store22 (r_csle_store22),
                          .r_csle_count22 (r_csle_count22),
                          .r_wele_count22 (r_wele_count22),
                          .r_ws_count22 (r_ws_count22),
                          .r_ws_store22 (r_ws_store22),
                          .r_oete_store22 (r_oete_store22),
                          .r_wete_store22 (r_wete_store22),
                          .r_wele_store22 (r_wele_store22),
                          .r_cste_count22 (r_cste_count22));
   
   
   smc_mac_lite22 i_mac_lite22         (
                          
                          // Inputs22
                          
                          .sys_clk22 (hclk22),
                          .n_sys_reset22 (n_sys_reset22),
                          .valid_access22 (valid_access22),
                          .xfer_size22 (xfer_size22),
                          .smc_done22 (smc_done22),
                          .data_smc22 (data_smc22),
                          .write_data22 (write_data22),
                          .smc_nextstate22 (smc_nextstate22),
                          .latch_data22 (latch_data22),
                          
                          // Outputs22
                          
                          .r_num_access22 (r_num_access22),
                          .mac_done22 (mac_done22),
                          .v_bus_size22 (v_bus_size22),
                          .v_xfer_size22 (v_xfer_size22),
                          .read_data22 (read_data22),
                          .smc_data22 (smc_data22));
   
   
   smc_state_lite22 i_state_lite22     (
                          
                          // Inputs22
                          
                          .sys_clk22 (hclk22),
                          .n_sys_reset22 (n_sys_reset22),
                          .new_access22 (new_access22),
                          .r_cste_count22 (r_cste_count22),
                          .r_csle_count22 (r_csle_count22),
                          .r_ws_count22 (r_ws_count22),
                          .mac_done22 (mac_done22),
                          .n_read22 (n_read22),
                          .n_r_read22 (n_r_read22),
                          .r_csle_store22 (r_csle_store22),
                          .r_oete_store22 (r_oete_store22),
                          .cs(cs),
                          .r_cs22(r_cs22),

                          // Outputs22
                          
                          .r_smc_currentstate22 (r_smc_currentstate22),
                          .smc_nextstate22 (smc_nextstate22),
                          .cste_enable22 (cste_enable22),
                          .ws_enable22 (ws_enable22),
                          .smc_done22 (smc_done22),
                          .valid_access22 (valid_access22),
                          .le_enable22 (le_enable22),
                          .latch_data22 (latch_data22),
                          .smc_idle22 (smc_idle22));
   
   smc_strobe_lite22 i_strobe_lite22   (

                          //inputs22

                          .sys_clk22 (hclk22),
                          .n_sys_reset22 (n_sys_reset22),
                          .valid_access22 (valid_access22),
                          .n_read22 (n_read22),
                          .cs(cs),
                          .r_smc_currentstate22 (r_smc_currentstate22),
                          .smc_nextstate22 (smc_nextstate22),
                          .n_be22 (n_be22),
                          .r_wele_store22 (r_wele_store22),
                          .r_wele_count22 (r_wele_count22),
                          .r_wete_store22 (r_wete_store22),
                          .r_oete_store22 (r_oete_store22),
                          .r_ws_count22 (r_ws_count22),
                          .r_ws_store22 (r_ws_store22),
                          .smc_done22 (smc_done22),
                          .mac_done22 (mac_done22),
                          
                          //outputs22

                          .smc_n_rd22 (smc_n_rd22),
                          .smc_n_ext_oe22 (smc_n_ext_oe22),
                          .smc_busy22 (smc_busy22),
                          .n_r_read22 (n_r_read22),
                          .r_cs22(r_cs22),
                          .r_full22 (r_full22),
                          .n_r_we22 (n_r_we22),
                          .n_r_wr22 (n_r_wr22));
   
   smc_wr_enable_lite22 i_wr_enable_lite22 (

                            //inputs22

                          .n_sys_reset22 (n_sys_reset22),
                          .r_full22(r_full22),
                          .n_r_we22(n_r_we22),
                          .n_r_wr22 (n_r_wr22),
                              
                          //output                

                          .smc_n_we22(smc_n_we22),
                          .smc_n_wr22 (smc_n_wr22));
   
   
   
   smc_addr_lite22 i_add_lite22        (
                          //inputs22

                          .sys_clk22 (hclk22),
                          .n_sys_reset22 (n_sys_reset22),
                          .valid_access22 (valid_access22),
                          .r_num_access22 (r_num_access22),
                          .v_bus_size22 (v_bus_size22),
                          .v_xfer_size22 (v_xfer_size22),
                          .cs (cs),
                          .addr (addr),
                          .smc_done22 (smc_done22),
                          .smc_nextstate22 (smc_nextstate22),
                          
                          //outputs22

                          .smc_addr22 (smc_addr22),
                          .smc_n_be22 (smc_n_be22),
                          .smc_n_cs22 (smc_n_cs22),
                          .n_be22 (n_be22));
   
   
endmodule
