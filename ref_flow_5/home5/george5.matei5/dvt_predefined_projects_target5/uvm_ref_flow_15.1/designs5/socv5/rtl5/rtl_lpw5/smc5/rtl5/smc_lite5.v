//File5 name   : smc_lite5.v
//Title5       : SMC5 top level
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

 `include "smc_defs_lite5.v"

//static memory controller5
module          smc_lite5(
                    //apb5 inputs5
                    n_preset5, 
                    pclk5, 
                    psel5, 
                    penable5, 
                    pwrite5, 
                    paddr5, 
                    pwdata5,
                    //ahb5 inputs5                    
                    hclk5,
                    n_sys_reset5,
                    haddr5,
                    htrans5,
                    hsel5,
                    hwrite5,
                    hsize5,
                    hwdata5,
                    hready5,
                    data_smc5,
                    

                    //test signal5 inputs5

                    scan_in_15,
                    scan_in_25,
                    scan_in_35,
                    scan_en5,

                    //apb5 outputs5                    
                    prdata5,

                    //design output
                    
                    smc_hrdata5, 
                    smc_hready5,
                    smc_valid5,
                    smc_hresp5,
                    smc_addr5,
                    smc_data5, 
                    smc_n_be5,
                    smc_n_cs5,
                    smc_n_wr5,                    
                    smc_n_we5,
                    smc_n_rd5,
                    smc_n_ext_oe5,
                    smc_busy5,

                    //test signal5 output

                    scan_out_15,
                    scan_out_25,
                    scan_out_35
                   );
// define parameters5
// change using defaparam5 statements5


  // APB5 Inputs5 (use is optional5 on INCLUDE_APB5)
  input        n_preset5;           // APBreset5 
  input        pclk5;               // APB5 clock5
  input        psel5;               // APB5 select5
  input        penable5;            // APB5 enable 
  input        pwrite5;             // APB5 write strobe5 
  input [4:0]  paddr5;              // APB5 address bus
  input [31:0] pwdata5;             // APB5 write data 

  // APB5 Output5 (use is optional5 on INCLUDE_APB5)

  output [31:0] prdata5;        //APB5 output



//System5 I5/O5

  input                    hclk5;          // AHB5 System5 clock5
  input                    n_sys_reset5;   // AHB5 System5 reset (Active5 LOW5)

//AHB5 I5/O5

  input  [31:0]            haddr5;         // AHB5 Address
  input  [1:0]             htrans5;        // AHB5 transfer5 type
  input               hsel5;          // chip5 selects5
  input                    hwrite5;        // AHB5 read/write indication5
  input  [2:0]             hsize5;         // AHB5 transfer5 size
  input  [31:0]            hwdata5;        // AHB5 write data
  input                    hready5;        // AHB5 Muxed5 ready signal5

  
  output [31:0]            smc_hrdata5;    // smc5 read data back to AHB5 master5
  output                   smc_hready5;    // smc5 ready signal5
  output [1:0]             smc_hresp5;     // AHB5 Response5 signal5
  output                   smc_valid5;     // Ack5 valid address

//External5 memory interface (EMI5)

  output [31:0]            smc_addr5;      // External5 Memory (EMI5) address
  output [31:0]            smc_data5;      // EMI5 write data
  input  [31:0]            data_smc5;      // EMI5 read data
  output [3:0]             smc_n_be5;      // EMI5 byte enables5 (Active5 LOW5)
  output             smc_n_cs5;      // EMI5 Chip5 Selects5 (Active5 LOW5)
  output [3:0]             smc_n_we5;      // EMI5 write strobes5 (Active5 LOW5)
  output                   smc_n_wr5;      // EMI5 write enable (Active5 LOW5)
  output                   smc_n_rd5;      // EMI5 read stobe5 (Active5 LOW5)
  output 	           smc_n_ext_oe5;  // EMI5 write data output enable

//AHB5 Memory Interface5 Control5

   output                   smc_busy5;      // smc5 busy

   
   


//scan5 signals5

   input                  scan_in_15;        //scan5 input
   input                  scan_in_25;        //scan5 input
   input                  scan_en5;         //scan5 enable
   output                 scan_out_15;       //scan5 output
   output                 scan_out_25;       //scan5 output
// third5 scan5 chain5 only used on INCLUDE_APB5
   input                  scan_in_35;        //scan5 input
   output                 scan_out_35;       //scan5 output
   
//----------------------------------------------------------------------
// Signal5 declarations5
//----------------------------------------------------------------------

// Bus5 Interface5
   
  wire  [31:0]   smc_hrdata5;         //smc5 read data back to AHB5 master5
  wire           smc_hready5;         //smc5 ready signal5
  wire  [1:0]    smc_hresp5;          //AHB5 Response5 signal5
  wire           smc_valid5;          //Ack5 valid address

// MAC5

  wire [31:0]    smc_data5;           //Data to external5 bus via MUX5

// Strobe5 Generation5

  wire           smc_n_wr5;           //EMI5 write enable (Active5 LOW5)
  wire  [3:0]    smc_n_we5;           //EMI5 write strobes5 (Active5 LOW5)
  wire           smc_n_rd5;           //EMI5 read stobe5 (Active5 LOW5)
  wire           smc_busy5;           //smc5 busy
  wire           smc_n_ext_oe5;       //Enable5 External5 bus drivers5.(CS5 & !RD5)

// Address Generation5

  wire [31:0]    smc_addr5;           //External5 Memory Interface5(EMI5) address
  wire [3:0]     smc_n_be5;   //EMI5 byte enables5 (Active5 LOW5)
  wire      smc_n_cs5;   //EMI5 Chip5 Selects5 (Active5 LOW5)

// Bus5 Interface5

  wire           new_access5;         // New5 AHB5 access to smc5 detected
  wire [31:0]    addr;               // Copy5 of address
  wire [31:0]    write_data5;         // Data to External5 Bus5
  wire      cs;         // Chip5(bank5) Select5 Lines5
  wire [1:0]     xfer_size5;          // Width5 of current transfer5
  wire           n_read5;             // Active5 low5 read signal5                   
  
// Configuration5 Block


// Counters5

  wire [1:0]     r_csle_count5;       // Chip5 select5 LE5 counter
  wire [1:0]     r_wele_count5;       // Write counter
  wire [1:0]     r_cste_count5;       // chip5 select5 TE5 counter
  wire [7:0]     r_ws_count5; // Wait5 state select5 counter
  
// These5 strobes5 finish early5 so no counter is required5. The stored5 value
// is compared with WS5 counter to determine5 when the strobe5 should end.

  wire [1:0]     r_wete_store5;       // Write strobe5 TE5 end time before CS5
  wire [1:0]     r_oete_store5;       // Read strobe5 TE5 end time before CS5
  
// The following5 four5 wireisrers5 are used to store5 the configuration during
// mulitple5 accesses. The counters5 are reloaded5 from these5 wireisters5
//  before each cycle.

  wire [1:0]     r_csle_store5;       // Chip5 select5 LE5 store5
  wire [1:0]     r_wele_store5;       // Write strobe5 LE5 store5
  wire [7:0]     r_ws_store5;         // Wait5 state store5
  wire [1:0]     r_cste_store5;       // Chip5 Select5 TE5 delay (Bus5 float5 time)


// Multiple5 access control5

  wire           mac_done5;           // Indicates5 last cycle of last access
  wire [1:0]     r_num_access5;       // Access counter
  wire [1:0]     v_xfer_size5;        // Store5 size for MAC5 
  wire [1:0]     v_bus_size5;         // Store5 size for MAC5
  wire [31:0]    read_data5;          // Data path to bus IF
  wire [31:0]    r_read_data5;        // Internal data store5

// smc5 state machine5


  wire           valid_access5;       // New5 acces5 can proceed
  wire   [4:0]   smc_nextstate5;      // state machine5 (async5 encoding5)
  wire   [4:0]   r_smc_currentstate5; // Synchronised5 smc5 state machine5
  wire           ws_enable5;          // Wait5 state counter enable
  wire           cste_enable5;        // Chip5 select5 counter enable
  wire           smc_done5;           // Asserted5 during last cycle of
                                     //    an access
  wire           le_enable5;          // Start5 counters5 after STORED5 
                                     //    access
  wire           latch_data5;         // latch_data5 is used by the MAC5 
                                     //    block to store5 read data 
                                     //    if CSTE5 > 0
  wire           smc_idle5;           // idle5 state

// Address Generation5

  wire [3:0]     n_be5;               // Full cycle write strobe5

// Strobe5 Generation5

  wire           r_full5;             // Full cycle write strobe5
  wire           n_r_read5;           // Store5 RW srate5 for multiple accesses
  wire           n_r_wr5;             // write strobe5
  wire [3:0]     n_r_we5;             // write enable  
  wire      r_cs5;       // registered chip5 select5 

   //apb5
   

   wire n_sys_reset5;                        //AHB5 system reset(active low5)

// assign a default value to the signal5 if the bank5 has
// been disabled and the APB5 has been excluded5 (i.e. the config signals5
// come5 from the top level
   
   smc_apb_lite_if5 i_apb_lite5 (
                     //Inputs5
                     
                     .n_preset5(n_preset5),
                     .pclk5(pclk5),
                     .psel5(psel5),
                     .penable5(penable5),
                     .pwrite5(pwrite5),
                     .paddr5(paddr5),
                     .pwdata5(pwdata5),
                     
                    //Outputs5
                     
                     .prdata5(prdata5)
                     
                     );
   
   smc_ahb_lite_if5 i_ahb_lite5  (
                     //Inputs5
                     
		     .hclk5 (hclk5),
                     .n_sys_reset5 (n_sys_reset5),
                     .haddr5 (haddr5),
                     .hsel5 (hsel5),                                                
                     .htrans5 (htrans5),                    
                     .hwrite5 (hwrite5),
                     .hsize5 (hsize5),                
                     .hwdata5 (hwdata5),
                     .hready5 (hready5),
                     .read_data5 (read_data5),
                     .mac_done5 (mac_done5),
                     .smc_done5 (smc_done5),
                     .smc_idle5 (smc_idle5),
                     
                     // Outputs5
                     
                     .xfer_size5 (xfer_size5),
                     .n_read5 (n_read5),
                     .new_access5 (new_access5),
                     .addr (addr),
                     .smc_hrdata5 (smc_hrdata5), 
                     .smc_hready5 (smc_hready5),
                     .smc_hresp5 (smc_hresp5),
                     .smc_valid5 (smc_valid5),
                     .cs (cs),
                     .write_data5 (write_data5)
                     );
   
   

   
   
   smc_counter_lite5 i_counter_lite5 (
                          
                          // Inputs5
                          
                          .sys_clk5 (hclk5),
                          .n_sys_reset5 (n_sys_reset5),
                          .valid_access5 (valid_access5),
                          .mac_done5 (mac_done5),
                          .smc_done5 (smc_done5),
                          .cste_enable5 (cste_enable5),
                          .ws_enable5 (ws_enable5),
                          .le_enable5 (le_enable5),
                          
                          // Outputs5
                          
                          .r_csle_store5 (r_csle_store5),
                          .r_csle_count5 (r_csle_count5),
                          .r_wele_count5 (r_wele_count5),
                          .r_ws_count5 (r_ws_count5),
                          .r_ws_store5 (r_ws_store5),
                          .r_oete_store5 (r_oete_store5),
                          .r_wete_store5 (r_wete_store5),
                          .r_wele_store5 (r_wele_store5),
                          .r_cste_count5 (r_cste_count5));
   
   
   smc_mac_lite5 i_mac_lite5         (
                          
                          // Inputs5
                          
                          .sys_clk5 (hclk5),
                          .n_sys_reset5 (n_sys_reset5),
                          .valid_access5 (valid_access5),
                          .xfer_size5 (xfer_size5),
                          .smc_done5 (smc_done5),
                          .data_smc5 (data_smc5),
                          .write_data5 (write_data5),
                          .smc_nextstate5 (smc_nextstate5),
                          .latch_data5 (latch_data5),
                          
                          // Outputs5
                          
                          .r_num_access5 (r_num_access5),
                          .mac_done5 (mac_done5),
                          .v_bus_size5 (v_bus_size5),
                          .v_xfer_size5 (v_xfer_size5),
                          .read_data5 (read_data5),
                          .smc_data5 (smc_data5));
   
   
   smc_state_lite5 i_state_lite5     (
                          
                          // Inputs5
                          
                          .sys_clk5 (hclk5),
                          .n_sys_reset5 (n_sys_reset5),
                          .new_access5 (new_access5),
                          .r_cste_count5 (r_cste_count5),
                          .r_csle_count5 (r_csle_count5),
                          .r_ws_count5 (r_ws_count5),
                          .mac_done5 (mac_done5),
                          .n_read5 (n_read5),
                          .n_r_read5 (n_r_read5),
                          .r_csle_store5 (r_csle_store5),
                          .r_oete_store5 (r_oete_store5),
                          .cs(cs),
                          .r_cs5(r_cs5),

                          // Outputs5
                          
                          .r_smc_currentstate5 (r_smc_currentstate5),
                          .smc_nextstate5 (smc_nextstate5),
                          .cste_enable5 (cste_enable5),
                          .ws_enable5 (ws_enable5),
                          .smc_done5 (smc_done5),
                          .valid_access5 (valid_access5),
                          .le_enable5 (le_enable5),
                          .latch_data5 (latch_data5),
                          .smc_idle5 (smc_idle5));
   
   smc_strobe_lite5 i_strobe_lite5   (

                          //inputs5

                          .sys_clk5 (hclk5),
                          .n_sys_reset5 (n_sys_reset5),
                          .valid_access5 (valid_access5),
                          .n_read5 (n_read5),
                          .cs(cs),
                          .r_smc_currentstate5 (r_smc_currentstate5),
                          .smc_nextstate5 (smc_nextstate5),
                          .n_be5 (n_be5),
                          .r_wele_store5 (r_wele_store5),
                          .r_wele_count5 (r_wele_count5),
                          .r_wete_store5 (r_wete_store5),
                          .r_oete_store5 (r_oete_store5),
                          .r_ws_count5 (r_ws_count5),
                          .r_ws_store5 (r_ws_store5),
                          .smc_done5 (smc_done5),
                          .mac_done5 (mac_done5),
                          
                          //outputs5

                          .smc_n_rd5 (smc_n_rd5),
                          .smc_n_ext_oe5 (smc_n_ext_oe5),
                          .smc_busy5 (smc_busy5),
                          .n_r_read5 (n_r_read5),
                          .r_cs5(r_cs5),
                          .r_full5 (r_full5),
                          .n_r_we5 (n_r_we5),
                          .n_r_wr5 (n_r_wr5));
   
   smc_wr_enable_lite5 i_wr_enable_lite5 (

                            //inputs5

                          .n_sys_reset5 (n_sys_reset5),
                          .r_full5(r_full5),
                          .n_r_we5(n_r_we5),
                          .n_r_wr5 (n_r_wr5),
                              
                          //output                

                          .smc_n_we5(smc_n_we5),
                          .smc_n_wr5 (smc_n_wr5));
   
   
   
   smc_addr_lite5 i_add_lite5        (
                          //inputs5

                          .sys_clk5 (hclk5),
                          .n_sys_reset5 (n_sys_reset5),
                          .valid_access5 (valid_access5),
                          .r_num_access5 (r_num_access5),
                          .v_bus_size5 (v_bus_size5),
                          .v_xfer_size5 (v_xfer_size5),
                          .cs (cs),
                          .addr (addr),
                          .smc_done5 (smc_done5),
                          .smc_nextstate5 (smc_nextstate5),
                          
                          //outputs5

                          .smc_addr5 (smc_addr5),
                          .smc_n_be5 (smc_n_be5),
                          .smc_n_cs5 (smc_n_cs5),
                          .n_be5 (n_be5));
   
   
endmodule
