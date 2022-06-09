//File21 name   : smc_lite21.v
//Title21       : SMC21 top level
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

 `include "smc_defs_lite21.v"

//static memory controller21
module          smc_lite21(
                    //apb21 inputs21
                    n_preset21, 
                    pclk21, 
                    psel21, 
                    penable21, 
                    pwrite21, 
                    paddr21, 
                    pwdata21,
                    //ahb21 inputs21                    
                    hclk21,
                    n_sys_reset21,
                    haddr21,
                    htrans21,
                    hsel21,
                    hwrite21,
                    hsize21,
                    hwdata21,
                    hready21,
                    data_smc21,
                    

                    //test signal21 inputs21

                    scan_in_121,
                    scan_in_221,
                    scan_in_321,
                    scan_en21,

                    //apb21 outputs21                    
                    prdata21,

                    //design output
                    
                    smc_hrdata21, 
                    smc_hready21,
                    smc_valid21,
                    smc_hresp21,
                    smc_addr21,
                    smc_data21, 
                    smc_n_be21,
                    smc_n_cs21,
                    smc_n_wr21,                    
                    smc_n_we21,
                    smc_n_rd21,
                    smc_n_ext_oe21,
                    smc_busy21,

                    //test signal21 output

                    scan_out_121,
                    scan_out_221,
                    scan_out_321
                   );
// define parameters21
// change using defaparam21 statements21


  // APB21 Inputs21 (use is optional21 on INCLUDE_APB21)
  input        n_preset21;           // APBreset21 
  input        pclk21;               // APB21 clock21
  input        psel21;               // APB21 select21
  input        penable21;            // APB21 enable 
  input        pwrite21;             // APB21 write strobe21 
  input [4:0]  paddr21;              // APB21 address bus
  input [31:0] pwdata21;             // APB21 write data 

  // APB21 Output21 (use is optional21 on INCLUDE_APB21)

  output [31:0] prdata21;        //APB21 output



//System21 I21/O21

  input                    hclk21;          // AHB21 System21 clock21
  input                    n_sys_reset21;   // AHB21 System21 reset (Active21 LOW21)

//AHB21 I21/O21

  input  [31:0]            haddr21;         // AHB21 Address
  input  [1:0]             htrans21;        // AHB21 transfer21 type
  input               hsel21;          // chip21 selects21
  input                    hwrite21;        // AHB21 read/write indication21
  input  [2:0]             hsize21;         // AHB21 transfer21 size
  input  [31:0]            hwdata21;        // AHB21 write data
  input                    hready21;        // AHB21 Muxed21 ready signal21

  
  output [31:0]            smc_hrdata21;    // smc21 read data back to AHB21 master21
  output                   smc_hready21;    // smc21 ready signal21
  output [1:0]             smc_hresp21;     // AHB21 Response21 signal21
  output                   smc_valid21;     // Ack21 valid address

//External21 memory interface (EMI21)

  output [31:0]            smc_addr21;      // External21 Memory (EMI21) address
  output [31:0]            smc_data21;      // EMI21 write data
  input  [31:0]            data_smc21;      // EMI21 read data
  output [3:0]             smc_n_be21;      // EMI21 byte enables21 (Active21 LOW21)
  output             smc_n_cs21;      // EMI21 Chip21 Selects21 (Active21 LOW21)
  output [3:0]             smc_n_we21;      // EMI21 write strobes21 (Active21 LOW21)
  output                   smc_n_wr21;      // EMI21 write enable (Active21 LOW21)
  output                   smc_n_rd21;      // EMI21 read stobe21 (Active21 LOW21)
  output 	           smc_n_ext_oe21;  // EMI21 write data output enable

//AHB21 Memory Interface21 Control21

   output                   smc_busy21;      // smc21 busy

   
   


//scan21 signals21

   input                  scan_in_121;        //scan21 input
   input                  scan_in_221;        //scan21 input
   input                  scan_en21;         //scan21 enable
   output                 scan_out_121;       //scan21 output
   output                 scan_out_221;       //scan21 output
// third21 scan21 chain21 only used on INCLUDE_APB21
   input                  scan_in_321;        //scan21 input
   output                 scan_out_321;       //scan21 output
   
//----------------------------------------------------------------------
// Signal21 declarations21
//----------------------------------------------------------------------

// Bus21 Interface21
   
  wire  [31:0]   smc_hrdata21;         //smc21 read data back to AHB21 master21
  wire           smc_hready21;         //smc21 ready signal21
  wire  [1:0]    smc_hresp21;          //AHB21 Response21 signal21
  wire           smc_valid21;          //Ack21 valid address

// MAC21

  wire [31:0]    smc_data21;           //Data to external21 bus via MUX21

// Strobe21 Generation21

  wire           smc_n_wr21;           //EMI21 write enable (Active21 LOW21)
  wire  [3:0]    smc_n_we21;           //EMI21 write strobes21 (Active21 LOW21)
  wire           smc_n_rd21;           //EMI21 read stobe21 (Active21 LOW21)
  wire           smc_busy21;           //smc21 busy
  wire           smc_n_ext_oe21;       //Enable21 External21 bus drivers21.(CS21 & !RD21)

// Address Generation21

  wire [31:0]    smc_addr21;           //External21 Memory Interface21(EMI21) address
  wire [3:0]     smc_n_be21;   //EMI21 byte enables21 (Active21 LOW21)
  wire      smc_n_cs21;   //EMI21 Chip21 Selects21 (Active21 LOW21)

// Bus21 Interface21

  wire           new_access21;         // New21 AHB21 access to smc21 detected
  wire [31:0]    addr;               // Copy21 of address
  wire [31:0]    write_data21;         // Data to External21 Bus21
  wire      cs;         // Chip21(bank21) Select21 Lines21
  wire [1:0]     xfer_size21;          // Width21 of current transfer21
  wire           n_read21;             // Active21 low21 read signal21                   
  
// Configuration21 Block


// Counters21

  wire [1:0]     r_csle_count21;       // Chip21 select21 LE21 counter
  wire [1:0]     r_wele_count21;       // Write counter
  wire [1:0]     r_cste_count21;       // chip21 select21 TE21 counter
  wire [7:0]     r_ws_count21; // Wait21 state select21 counter
  
// These21 strobes21 finish early21 so no counter is required21. The stored21 value
// is compared with WS21 counter to determine21 when the strobe21 should end.

  wire [1:0]     r_wete_store21;       // Write strobe21 TE21 end time before CS21
  wire [1:0]     r_oete_store21;       // Read strobe21 TE21 end time before CS21
  
// The following21 four21 wireisrers21 are used to store21 the configuration during
// mulitple21 accesses. The counters21 are reloaded21 from these21 wireisters21
//  before each cycle.

  wire [1:0]     r_csle_store21;       // Chip21 select21 LE21 store21
  wire [1:0]     r_wele_store21;       // Write strobe21 LE21 store21
  wire [7:0]     r_ws_store21;         // Wait21 state store21
  wire [1:0]     r_cste_store21;       // Chip21 Select21 TE21 delay (Bus21 float21 time)


// Multiple21 access control21

  wire           mac_done21;           // Indicates21 last cycle of last access
  wire [1:0]     r_num_access21;       // Access counter
  wire [1:0]     v_xfer_size21;        // Store21 size for MAC21 
  wire [1:0]     v_bus_size21;         // Store21 size for MAC21
  wire [31:0]    read_data21;          // Data path to bus IF
  wire [31:0]    r_read_data21;        // Internal data store21

// smc21 state machine21


  wire           valid_access21;       // New21 acces21 can proceed
  wire   [4:0]   smc_nextstate21;      // state machine21 (async21 encoding21)
  wire   [4:0]   r_smc_currentstate21; // Synchronised21 smc21 state machine21
  wire           ws_enable21;          // Wait21 state counter enable
  wire           cste_enable21;        // Chip21 select21 counter enable
  wire           smc_done21;           // Asserted21 during last cycle of
                                     //    an access
  wire           le_enable21;          // Start21 counters21 after STORED21 
                                     //    access
  wire           latch_data21;         // latch_data21 is used by the MAC21 
                                     //    block to store21 read data 
                                     //    if CSTE21 > 0
  wire           smc_idle21;           // idle21 state

// Address Generation21

  wire [3:0]     n_be21;               // Full cycle write strobe21

// Strobe21 Generation21

  wire           r_full21;             // Full cycle write strobe21
  wire           n_r_read21;           // Store21 RW srate21 for multiple accesses
  wire           n_r_wr21;             // write strobe21
  wire [3:0]     n_r_we21;             // write enable  
  wire      r_cs21;       // registered chip21 select21 

   //apb21
   

   wire n_sys_reset21;                        //AHB21 system reset(active low21)

// assign a default value to the signal21 if the bank21 has
// been disabled and the APB21 has been excluded21 (i.e. the config signals21
// come21 from the top level
   
   smc_apb_lite_if21 i_apb_lite21 (
                     //Inputs21
                     
                     .n_preset21(n_preset21),
                     .pclk21(pclk21),
                     .psel21(psel21),
                     .penable21(penable21),
                     .pwrite21(pwrite21),
                     .paddr21(paddr21),
                     .pwdata21(pwdata21),
                     
                    //Outputs21
                     
                     .prdata21(prdata21)
                     
                     );
   
   smc_ahb_lite_if21 i_ahb_lite21  (
                     //Inputs21
                     
		     .hclk21 (hclk21),
                     .n_sys_reset21 (n_sys_reset21),
                     .haddr21 (haddr21),
                     .hsel21 (hsel21),                                                
                     .htrans21 (htrans21),                    
                     .hwrite21 (hwrite21),
                     .hsize21 (hsize21),                
                     .hwdata21 (hwdata21),
                     .hready21 (hready21),
                     .read_data21 (read_data21),
                     .mac_done21 (mac_done21),
                     .smc_done21 (smc_done21),
                     .smc_idle21 (smc_idle21),
                     
                     // Outputs21
                     
                     .xfer_size21 (xfer_size21),
                     .n_read21 (n_read21),
                     .new_access21 (new_access21),
                     .addr (addr),
                     .smc_hrdata21 (smc_hrdata21), 
                     .smc_hready21 (smc_hready21),
                     .smc_hresp21 (smc_hresp21),
                     .smc_valid21 (smc_valid21),
                     .cs (cs),
                     .write_data21 (write_data21)
                     );
   
   

   
   
   smc_counter_lite21 i_counter_lite21 (
                          
                          // Inputs21
                          
                          .sys_clk21 (hclk21),
                          .n_sys_reset21 (n_sys_reset21),
                          .valid_access21 (valid_access21),
                          .mac_done21 (mac_done21),
                          .smc_done21 (smc_done21),
                          .cste_enable21 (cste_enable21),
                          .ws_enable21 (ws_enable21),
                          .le_enable21 (le_enable21),
                          
                          // Outputs21
                          
                          .r_csle_store21 (r_csle_store21),
                          .r_csle_count21 (r_csle_count21),
                          .r_wele_count21 (r_wele_count21),
                          .r_ws_count21 (r_ws_count21),
                          .r_ws_store21 (r_ws_store21),
                          .r_oete_store21 (r_oete_store21),
                          .r_wete_store21 (r_wete_store21),
                          .r_wele_store21 (r_wele_store21),
                          .r_cste_count21 (r_cste_count21));
   
   
   smc_mac_lite21 i_mac_lite21         (
                          
                          // Inputs21
                          
                          .sys_clk21 (hclk21),
                          .n_sys_reset21 (n_sys_reset21),
                          .valid_access21 (valid_access21),
                          .xfer_size21 (xfer_size21),
                          .smc_done21 (smc_done21),
                          .data_smc21 (data_smc21),
                          .write_data21 (write_data21),
                          .smc_nextstate21 (smc_nextstate21),
                          .latch_data21 (latch_data21),
                          
                          // Outputs21
                          
                          .r_num_access21 (r_num_access21),
                          .mac_done21 (mac_done21),
                          .v_bus_size21 (v_bus_size21),
                          .v_xfer_size21 (v_xfer_size21),
                          .read_data21 (read_data21),
                          .smc_data21 (smc_data21));
   
   
   smc_state_lite21 i_state_lite21     (
                          
                          // Inputs21
                          
                          .sys_clk21 (hclk21),
                          .n_sys_reset21 (n_sys_reset21),
                          .new_access21 (new_access21),
                          .r_cste_count21 (r_cste_count21),
                          .r_csle_count21 (r_csle_count21),
                          .r_ws_count21 (r_ws_count21),
                          .mac_done21 (mac_done21),
                          .n_read21 (n_read21),
                          .n_r_read21 (n_r_read21),
                          .r_csle_store21 (r_csle_store21),
                          .r_oete_store21 (r_oete_store21),
                          .cs(cs),
                          .r_cs21(r_cs21),

                          // Outputs21
                          
                          .r_smc_currentstate21 (r_smc_currentstate21),
                          .smc_nextstate21 (smc_nextstate21),
                          .cste_enable21 (cste_enable21),
                          .ws_enable21 (ws_enable21),
                          .smc_done21 (smc_done21),
                          .valid_access21 (valid_access21),
                          .le_enable21 (le_enable21),
                          .latch_data21 (latch_data21),
                          .smc_idle21 (smc_idle21));
   
   smc_strobe_lite21 i_strobe_lite21   (

                          //inputs21

                          .sys_clk21 (hclk21),
                          .n_sys_reset21 (n_sys_reset21),
                          .valid_access21 (valid_access21),
                          .n_read21 (n_read21),
                          .cs(cs),
                          .r_smc_currentstate21 (r_smc_currentstate21),
                          .smc_nextstate21 (smc_nextstate21),
                          .n_be21 (n_be21),
                          .r_wele_store21 (r_wele_store21),
                          .r_wele_count21 (r_wele_count21),
                          .r_wete_store21 (r_wete_store21),
                          .r_oete_store21 (r_oete_store21),
                          .r_ws_count21 (r_ws_count21),
                          .r_ws_store21 (r_ws_store21),
                          .smc_done21 (smc_done21),
                          .mac_done21 (mac_done21),
                          
                          //outputs21

                          .smc_n_rd21 (smc_n_rd21),
                          .smc_n_ext_oe21 (smc_n_ext_oe21),
                          .smc_busy21 (smc_busy21),
                          .n_r_read21 (n_r_read21),
                          .r_cs21(r_cs21),
                          .r_full21 (r_full21),
                          .n_r_we21 (n_r_we21),
                          .n_r_wr21 (n_r_wr21));
   
   smc_wr_enable_lite21 i_wr_enable_lite21 (

                            //inputs21

                          .n_sys_reset21 (n_sys_reset21),
                          .r_full21(r_full21),
                          .n_r_we21(n_r_we21),
                          .n_r_wr21 (n_r_wr21),
                              
                          //output                

                          .smc_n_we21(smc_n_we21),
                          .smc_n_wr21 (smc_n_wr21));
   
   
   
   smc_addr_lite21 i_add_lite21        (
                          //inputs21

                          .sys_clk21 (hclk21),
                          .n_sys_reset21 (n_sys_reset21),
                          .valid_access21 (valid_access21),
                          .r_num_access21 (r_num_access21),
                          .v_bus_size21 (v_bus_size21),
                          .v_xfer_size21 (v_xfer_size21),
                          .cs (cs),
                          .addr (addr),
                          .smc_done21 (smc_done21),
                          .smc_nextstate21 (smc_nextstate21),
                          
                          //outputs21

                          .smc_addr21 (smc_addr21),
                          .smc_n_be21 (smc_n_be21),
                          .smc_n_cs21 (smc_n_cs21),
                          .n_be21 (n_be21));
   
   
endmodule
