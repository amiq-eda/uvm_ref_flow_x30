//File11 name   : smc_lite11.v
//Title11       : SMC11 top level
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

 `include "smc_defs_lite11.v"

//static memory controller11
module          smc_lite11(
                    //apb11 inputs11
                    n_preset11, 
                    pclk11, 
                    psel11, 
                    penable11, 
                    pwrite11, 
                    paddr11, 
                    pwdata11,
                    //ahb11 inputs11                    
                    hclk11,
                    n_sys_reset11,
                    haddr11,
                    htrans11,
                    hsel11,
                    hwrite11,
                    hsize11,
                    hwdata11,
                    hready11,
                    data_smc11,
                    

                    //test signal11 inputs11

                    scan_in_111,
                    scan_in_211,
                    scan_in_311,
                    scan_en11,

                    //apb11 outputs11                    
                    prdata11,

                    //design output
                    
                    smc_hrdata11, 
                    smc_hready11,
                    smc_valid11,
                    smc_hresp11,
                    smc_addr11,
                    smc_data11, 
                    smc_n_be11,
                    smc_n_cs11,
                    smc_n_wr11,                    
                    smc_n_we11,
                    smc_n_rd11,
                    smc_n_ext_oe11,
                    smc_busy11,

                    //test signal11 output

                    scan_out_111,
                    scan_out_211,
                    scan_out_311
                   );
// define parameters11
// change using defaparam11 statements11


  // APB11 Inputs11 (use is optional11 on INCLUDE_APB11)
  input        n_preset11;           // APBreset11 
  input        pclk11;               // APB11 clock11
  input        psel11;               // APB11 select11
  input        penable11;            // APB11 enable 
  input        pwrite11;             // APB11 write strobe11 
  input [4:0]  paddr11;              // APB11 address bus
  input [31:0] pwdata11;             // APB11 write data 

  // APB11 Output11 (use is optional11 on INCLUDE_APB11)

  output [31:0] prdata11;        //APB11 output



//System11 I11/O11

  input                    hclk11;          // AHB11 System11 clock11
  input                    n_sys_reset11;   // AHB11 System11 reset (Active11 LOW11)

//AHB11 I11/O11

  input  [31:0]            haddr11;         // AHB11 Address
  input  [1:0]             htrans11;        // AHB11 transfer11 type
  input               hsel11;          // chip11 selects11
  input                    hwrite11;        // AHB11 read/write indication11
  input  [2:0]             hsize11;         // AHB11 transfer11 size
  input  [31:0]            hwdata11;        // AHB11 write data
  input                    hready11;        // AHB11 Muxed11 ready signal11

  
  output [31:0]            smc_hrdata11;    // smc11 read data back to AHB11 master11
  output                   smc_hready11;    // smc11 ready signal11
  output [1:0]             smc_hresp11;     // AHB11 Response11 signal11
  output                   smc_valid11;     // Ack11 valid address

//External11 memory interface (EMI11)

  output [31:0]            smc_addr11;      // External11 Memory (EMI11) address
  output [31:0]            smc_data11;      // EMI11 write data
  input  [31:0]            data_smc11;      // EMI11 read data
  output [3:0]             smc_n_be11;      // EMI11 byte enables11 (Active11 LOW11)
  output             smc_n_cs11;      // EMI11 Chip11 Selects11 (Active11 LOW11)
  output [3:0]             smc_n_we11;      // EMI11 write strobes11 (Active11 LOW11)
  output                   smc_n_wr11;      // EMI11 write enable (Active11 LOW11)
  output                   smc_n_rd11;      // EMI11 read stobe11 (Active11 LOW11)
  output 	           smc_n_ext_oe11;  // EMI11 write data output enable

//AHB11 Memory Interface11 Control11

   output                   smc_busy11;      // smc11 busy

   
   


//scan11 signals11

   input                  scan_in_111;        //scan11 input
   input                  scan_in_211;        //scan11 input
   input                  scan_en11;         //scan11 enable
   output                 scan_out_111;       //scan11 output
   output                 scan_out_211;       //scan11 output
// third11 scan11 chain11 only used on INCLUDE_APB11
   input                  scan_in_311;        //scan11 input
   output                 scan_out_311;       //scan11 output
   
//----------------------------------------------------------------------
// Signal11 declarations11
//----------------------------------------------------------------------

// Bus11 Interface11
   
  wire  [31:0]   smc_hrdata11;         //smc11 read data back to AHB11 master11
  wire           smc_hready11;         //smc11 ready signal11
  wire  [1:0]    smc_hresp11;          //AHB11 Response11 signal11
  wire           smc_valid11;          //Ack11 valid address

// MAC11

  wire [31:0]    smc_data11;           //Data to external11 bus via MUX11

// Strobe11 Generation11

  wire           smc_n_wr11;           //EMI11 write enable (Active11 LOW11)
  wire  [3:0]    smc_n_we11;           //EMI11 write strobes11 (Active11 LOW11)
  wire           smc_n_rd11;           //EMI11 read stobe11 (Active11 LOW11)
  wire           smc_busy11;           //smc11 busy
  wire           smc_n_ext_oe11;       //Enable11 External11 bus drivers11.(CS11 & !RD11)

// Address Generation11

  wire [31:0]    smc_addr11;           //External11 Memory Interface11(EMI11) address
  wire [3:0]     smc_n_be11;   //EMI11 byte enables11 (Active11 LOW11)
  wire      smc_n_cs11;   //EMI11 Chip11 Selects11 (Active11 LOW11)

// Bus11 Interface11

  wire           new_access11;         // New11 AHB11 access to smc11 detected
  wire [31:0]    addr;               // Copy11 of address
  wire [31:0]    write_data11;         // Data to External11 Bus11
  wire      cs;         // Chip11(bank11) Select11 Lines11
  wire [1:0]     xfer_size11;          // Width11 of current transfer11
  wire           n_read11;             // Active11 low11 read signal11                   
  
// Configuration11 Block


// Counters11

  wire [1:0]     r_csle_count11;       // Chip11 select11 LE11 counter
  wire [1:0]     r_wele_count11;       // Write counter
  wire [1:0]     r_cste_count11;       // chip11 select11 TE11 counter
  wire [7:0]     r_ws_count11; // Wait11 state select11 counter
  
// These11 strobes11 finish early11 so no counter is required11. The stored11 value
// is compared with WS11 counter to determine11 when the strobe11 should end.

  wire [1:0]     r_wete_store11;       // Write strobe11 TE11 end time before CS11
  wire [1:0]     r_oete_store11;       // Read strobe11 TE11 end time before CS11
  
// The following11 four11 wireisrers11 are used to store11 the configuration during
// mulitple11 accesses. The counters11 are reloaded11 from these11 wireisters11
//  before each cycle.

  wire [1:0]     r_csle_store11;       // Chip11 select11 LE11 store11
  wire [1:0]     r_wele_store11;       // Write strobe11 LE11 store11
  wire [7:0]     r_ws_store11;         // Wait11 state store11
  wire [1:0]     r_cste_store11;       // Chip11 Select11 TE11 delay (Bus11 float11 time)


// Multiple11 access control11

  wire           mac_done11;           // Indicates11 last cycle of last access
  wire [1:0]     r_num_access11;       // Access counter
  wire [1:0]     v_xfer_size11;        // Store11 size for MAC11 
  wire [1:0]     v_bus_size11;         // Store11 size for MAC11
  wire [31:0]    read_data11;          // Data path to bus IF
  wire [31:0]    r_read_data11;        // Internal data store11

// smc11 state machine11


  wire           valid_access11;       // New11 acces11 can proceed
  wire   [4:0]   smc_nextstate11;      // state machine11 (async11 encoding11)
  wire   [4:0]   r_smc_currentstate11; // Synchronised11 smc11 state machine11
  wire           ws_enable11;          // Wait11 state counter enable
  wire           cste_enable11;        // Chip11 select11 counter enable
  wire           smc_done11;           // Asserted11 during last cycle of
                                     //    an access
  wire           le_enable11;          // Start11 counters11 after STORED11 
                                     //    access
  wire           latch_data11;         // latch_data11 is used by the MAC11 
                                     //    block to store11 read data 
                                     //    if CSTE11 > 0
  wire           smc_idle11;           // idle11 state

// Address Generation11

  wire [3:0]     n_be11;               // Full cycle write strobe11

// Strobe11 Generation11

  wire           r_full11;             // Full cycle write strobe11
  wire           n_r_read11;           // Store11 RW srate11 for multiple accesses
  wire           n_r_wr11;             // write strobe11
  wire [3:0]     n_r_we11;             // write enable  
  wire      r_cs11;       // registered chip11 select11 

   //apb11
   

   wire n_sys_reset11;                        //AHB11 system reset(active low11)

// assign a default value to the signal11 if the bank11 has
// been disabled and the APB11 has been excluded11 (i.e. the config signals11
// come11 from the top level
   
   smc_apb_lite_if11 i_apb_lite11 (
                     //Inputs11
                     
                     .n_preset11(n_preset11),
                     .pclk11(pclk11),
                     .psel11(psel11),
                     .penable11(penable11),
                     .pwrite11(pwrite11),
                     .paddr11(paddr11),
                     .pwdata11(pwdata11),
                     
                    //Outputs11
                     
                     .prdata11(prdata11)
                     
                     );
   
   smc_ahb_lite_if11 i_ahb_lite11  (
                     //Inputs11
                     
		     .hclk11 (hclk11),
                     .n_sys_reset11 (n_sys_reset11),
                     .haddr11 (haddr11),
                     .hsel11 (hsel11),                                                
                     .htrans11 (htrans11),                    
                     .hwrite11 (hwrite11),
                     .hsize11 (hsize11),                
                     .hwdata11 (hwdata11),
                     .hready11 (hready11),
                     .read_data11 (read_data11),
                     .mac_done11 (mac_done11),
                     .smc_done11 (smc_done11),
                     .smc_idle11 (smc_idle11),
                     
                     // Outputs11
                     
                     .xfer_size11 (xfer_size11),
                     .n_read11 (n_read11),
                     .new_access11 (new_access11),
                     .addr (addr),
                     .smc_hrdata11 (smc_hrdata11), 
                     .smc_hready11 (smc_hready11),
                     .smc_hresp11 (smc_hresp11),
                     .smc_valid11 (smc_valid11),
                     .cs (cs),
                     .write_data11 (write_data11)
                     );
   
   

   
   
   smc_counter_lite11 i_counter_lite11 (
                          
                          // Inputs11
                          
                          .sys_clk11 (hclk11),
                          .n_sys_reset11 (n_sys_reset11),
                          .valid_access11 (valid_access11),
                          .mac_done11 (mac_done11),
                          .smc_done11 (smc_done11),
                          .cste_enable11 (cste_enable11),
                          .ws_enable11 (ws_enable11),
                          .le_enable11 (le_enable11),
                          
                          // Outputs11
                          
                          .r_csle_store11 (r_csle_store11),
                          .r_csle_count11 (r_csle_count11),
                          .r_wele_count11 (r_wele_count11),
                          .r_ws_count11 (r_ws_count11),
                          .r_ws_store11 (r_ws_store11),
                          .r_oete_store11 (r_oete_store11),
                          .r_wete_store11 (r_wete_store11),
                          .r_wele_store11 (r_wele_store11),
                          .r_cste_count11 (r_cste_count11));
   
   
   smc_mac_lite11 i_mac_lite11         (
                          
                          // Inputs11
                          
                          .sys_clk11 (hclk11),
                          .n_sys_reset11 (n_sys_reset11),
                          .valid_access11 (valid_access11),
                          .xfer_size11 (xfer_size11),
                          .smc_done11 (smc_done11),
                          .data_smc11 (data_smc11),
                          .write_data11 (write_data11),
                          .smc_nextstate11 (smc_nextstate11),
                          .latch_data11 (latch_data11),
                          
                          // Outputs11
                          
                          .r_num_access11 (r_num_access11),
                          .mac_done11 (mac_done11),
                          .v_bus_size11 (v_bus_size11),
                          .v_xfer_size11 (v_xfer_size11),
                          .read_data11 (read_data11),
                          .smc_data11 (smc_data11));
   
   
   smc_state_lite11 i_state_lite11     (
                          
                          // Inputs11
                          
                          .sys_clk11 (hclk11),
                          .n_sys_reset11 (n_sys_reset11),
                          .new_access11 (new_access11),
                          .r_cste_count11 (r_cste_count11),
                          .r_csle_count11 (r_csle_count11),
                          .r_ws_count11 (r_ws_count11),
                          .mac_done11 (mac_done11),
                          .n_read11 (n_read11),
                          .n_r_read11 (n_r_read11),
                          .r_csle_store11 (r_csle_store11),
                          .r_oete_store11 (r_oete_store11),
                          .cs(cs),
                          .r_cs11(r_cs11),

                          // Outputs11
                          
                          .r_smc_currentstate11 (r_smc_currentstate11),
                          .smc_nextstate11 (smc_nextstate11),
                          .cste_enable11 (cste_enable11),
                          .ws_enable11 (ws_enable11),
                          .smc_done11 (smc_done11),
                          .valid_access11 (valid_access11),
                          .le_enable11 (le_enable11),
                          .latch_data11 (latch_data11),
                          .smc_idle11 (smc_idle11));
   
   smc_strobe_lite11 i_strobe_lite11   (

                          //inputs11

                          .sys_clk11 (hclk11),
                          .n_sys_reset11 (n_sys_reset11),
                          .valid_access11 (valid_access11),
                          .n_read11 (n_read11),
                          .cs(cs),
                          .r_smc_currentstate11 (r_smc_currentstate11),
                          .smc_nextstate11 (smc_nextstate11),
                          .n_be11 (n_be11),
                          .r_wele_store11 (r_wele_store11),
                          .r_wele_count11 (r_wele_count11),
                          .r_wete_store11 (r_wete_store11),
                          .r_oete_store11 (r_oete_store11),
                          .r_ws_count11 (r_ws_count11),
                          .r_ws_store11 (r_ws_store11),
                          .smc_done11 (smc_done11),
                          .mac_done11 (mac_done11),
                          
                          //outputs11

                          .smc_n_rd11 (smc_n_rd11),
                          .smc_n_ext_oe11 (smc_n_ext_oe11),
                          .smc_busy11 (smc_busy11),
                          .n_r_read11 (n_r_read11),
                          .r_cs11(r_cs11),
                          .r_full11 (r_full11),
                          .n_r_we11 (n_r_we11),
                          .n_r_wr11 (n_r_wr11));
   
   smc_wr_enable_lite11 i_wr_enable_lite11 (

                            //inputs11

                          .n_sys_reset11 (n_sys_reset11),
                          .r_full11(r_full11),
                          .n_r_we11(n_r_we11),
                          .n_r_wr11 (n_r_wr11),
                              
                          //output                

                          .smc_n_we11(smc_n_we11),
                          .smc_n_wr11 (smc_n_wr11));
   
   
   
   smc_addr_lite11 i_add_lite11        (
                          //inputs11

                          .sys_clk11 (hclk11),
                          .n_sys_reset11 (n_sys_reset11),
                          .valid_access11 (valid_access11),
                          .r_num_access11 (r_num_access11),
                          .v_bus_size11 (v_bus_size11),
                          .v_xfer_size11 (v_xfer_size11),
                          .cs (cs),
                          .addr (addr),
                          .smc_done11 (smc_done11),
                          .smc_nextstate11 (smc_nextstate11),
                          
                          //outputs11

                          .smc_addr11 (smc_addr11),
                          .smc_n_be11 (smc_n_be11),
                          .smc_n_cs11 (smc_n_cs11),
                          .n_be11 (n_be11));
   
   
endmodule
