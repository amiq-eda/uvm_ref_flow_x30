//File28 name   : smc_lite28.v
//Title28       : SMC28 top level
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

 `include "smc_defs_lite28.v"

//static memory controller28
module          smc_lite28(
                    //apb28 inputs28
                    n_preset28, 
                    pclk28, 
                    psel28, 
                    penable28, 
                    pwrite28, 
                    paddr28, 
                    pwdata28,
                    //ahb28 inputs28                    
                    hclk28,
                    n_sys_reset28,
                    haddr28,
                    htrans28,
                    hsel28,
                    hwrite28,
                    hsize28,
                    hwdata28,
                    hready28,
                    data_smc28,
                    

                    //test signal28 inputs28

                    scan_in_128,
                    scan_in_228,
                    scan_in_328,
                    scan_en28,

                    //apb28 outputs28                    
                    prdata28,

                    //design output
                    
                    smc_hrdata28, 
                    smc_hready28,
                    smc_valid28,
                    smc_hresp28,
                    smc_addr28,
                    smc_data28, 
                    smc_n_be28,
                    smc_n_cs28,
                    smc_n_wr28,                    
                    smc_n_we28,
                    smc_n_rd28,
                    smc_n_ext_oe28,
                    smc_busy28,

                    //test signal28 output

                    scan_out_128,
                    scan_out_228,
                    scan_out_328
                   );
// define parameters28
// change using defaparam28 statements28


  // APB28 Inputs28 (use is optional28 on INCLUDE_APB28)
  input        n_preset28;           // APBreset28 
  input        pclk28;               // APB28 clock28
  input        psel28;               // APB28 select28
  input        penable28;            // APB28 enable 
  input        pwrite28;             // APB28 write strobe28 
  input [4:0]  paddr28;              // APB28 address bus
  input [31:0] pwdata28;             // APB28 write data 

  // APB28 Output28 (use is optional28 on INCLUDE_APB28)

  output [31:0] prdata28;        //APB28 output



//System28 I28/O28

  input                    hclk28;          // AHB28 System28 clock28
  input                    n_sys_reset28;   // AHB28 System28 reset (Active28 LOW28)

//AHB28 I28/O28

  input  [31:0]            haddr28;         // AHB28 Address
  input  [1:0]             htrans28;        // AHB28 transfer28 type
  input               hsel28;          // chip28 selects28
  input                    hwrite28;        // AHB28 read/write indication28
  input  [2:0]             hsize28;         // AHB28 transfer28 size
  input  [31:0]            hwdata28;        // AHB28 write data
  input                    hready28;        // AHB28 Muxed28 ready signal28

  
  output [31:0]            smc_hrdata28;    // smc28 read data back to AHB28 master28
  output                   smc_hready28;    // smc28 ready signal28
  output [1:0]             smc_hresp28;     // AHB28 Response28 signal28
  output                   smc_valid28;     // Ack28 valid address

//External28 memory interface (EMI28)

  output [31:0]            smc_addr28;      // External28 Memory (EMI28) address
  output [31:0]            smc_data28;      // EMI28 write data
  input  [31:0]            data_smc28;      // EMI28 read data
  output [3:0]             smc_n_be28;      // EMI28 byte enables28 (Active28 LOW28)
  output             smc_n_cs28;      // EMI28 Chip28 Selects28 (Active28 LOW28)
  output [3:0]             smc_n_we28;      // EMI28 write strobes28 (Active28 LOW28)
  output                   smc_n_wr28;      // EMI28 write enable (Active28 LOW28)
  output                   smc_n_rd28;      // EMI28 read stobe28 (Active28 LOW28)
  output 	           smc_n_ext_oe28;  // EMI28 write data output enable

//AHB28 Memory Interface28 Control28

   output                   smc_busy28;      // smc28 busy

   
   


//scan28 signals28

   input                  scan_in_128;        //scan28 input
   input                  scan_in_228;        //scan28 input
   input                  scan_en28;         //scan28 enable
   output                 scan_out_128;       //scan28 output
   output                 scan_out_228;       //scan28 output
// third28 scan28 chain28 only used on INCLUDE_APB28
   input                  scan_in_328;        //scan28 input
   output                 scan_out_328;       //scan28 output
   
//----------------------------------------------------------------------
// Signal28 declarations28
//----------------------------------------------------------------------

// Bus28 Interface28
   
  wire  [31:0]   smc_hrdata28;         //smc28 read data back to AHB28 master28
  wire           smc_hready28;         //smc28 ready signal28
  wire  [1:0]    smc_hresp28;          //AHB28 Response28 signal28
  wire           smc_valid28;          //Ack28 valid address

// MAC28

  wire [31:0]    smc_data28;           //Data to external28 bus via MUX28

// Strobe28 Generation28

  wire           smc_n_wr28;           //EMI28 write enable (Active28 LOW28)
  wire  [3:0]    smc_n_we28;           //EMI28 write strobes28 (Active28 LOW28)
  wire           smc_n_rd28;           //EMI28 read stobe28 (Active28 LOW28)
  wire           smc_busy28;           //smc28 busy
  wire           smc_n_ext_oe28;       //Enable28 External28 bus drivers28.(CS28 & !RD28)

// Address Generation28

  wire [31:0]    smc_addr28;           //External28 Memory Interface28(EMI28) address
  wire [3:0]     smc_n_be28;   //EMI28 byte enables28 (Active28 LOW28)
  wire      smc_n_cs28;   //EMI28 Chip28 Selects28 (Active28 LOW28)

// Bus28 Interface28

  wire           new_access28;         // New28 AHB28 access to smc28 detected
  wire [31:0]    addr;               // Copy28 of address
  wire [31:0]    write_data28;         // Data to External28 Bus28
  wire      cs;         // Chip28(bank28) Select28 Lines28
  wire [1:0]     xfer_size28;          // Width28 of current transfer28
  wire           n_read28;             // Active28 low28 read signal28                   
  
// Configuration28 Block


// Counters28

  wire [1:0]     r_csle_count28;       // Chip28 select28 LE28 counter
  wire [1:0]     r_wele_count28;       // Write counter
  wire [1:0]     r_cste_count28;       // chip28 select28 TE28 counter
  wire [7:0]     r_ws_count28; // Wait28 state select28 counter
  
// These28 strobes28 finish early28 so no counter is required28. The stored28 value
// is compared with WS28 counter to determine28 when the strobe28 should end.

  wire [1:0]     r_wete_store28;       // Write strobe28 TE28 end time before CS28
  wire [1:0]     r_oete_store28;       // Read strobe28 TE28 end time before CS28
  
// The following28 four28 wireisrers28 are used to store28 the configuration during
// mulitple28 accesses. The counters28 are reloaded28 from these28 wireisters28
//  before each cycle.

  wire [1:0]     r_csle_store28;       // Chip28 select28 LE28 store28
  wire [1:0]     r_wele_store28;       // Write strobe28 LE28 store28
  wire [7:0]     r_ws_store28;         // Wait28 state store28
  wire [1:0]     r_cste_store28;       // Chip28 Select28 TE28 delay (Bus28 float28 time)


// Multiple28 access control28

  wire           mac_done28;           // Indicates28 last cycle of last access
  wire [1:0]     r_num_access28;       // Access counter
  wire [1:0]     v_xfer_size28;        // Store28 size for MAC28 
  wire [1:0]     v_bus_size28;         // Store28 size for MAC28
  wire [31:0]    read_data28;          // Data path to bus IF
  wire [31:0]    r_read_data28;        // Internal data store28

// smc28 state machine28


  wire           valid_access28;       // New28 acces28 can proceed
  wire   [4:0]   smc_nextstate28;      // state machine28 (async28 encoding28)
  wire   [4:0]   r_smc_currentstate28; // Synchronised28 smc28 state machine28
  wire           ws_enable28;          // Wait28 state counter enable
  wire           cste_enable28;        // Chip28 select28 counter enable
  wire           smc_done28;           // Asserted28 during last cycle of
                                     //    an access
  wire           le_enable28;          // Start28 counters28 after STORED28 
                                     //    access
  wire           latch_data28;         // latch_data28 is used by the MAC28 
                                     //    block to store28 read data 
                                     //    if CSTE28 > 0
  wire           smc_idle28;           // idle28 state

// Address Generation28

  wire [3:0]     n_be28;               // Full cycle write strobe28

// Strobe28 Generation28

  wire           r_full28;             // Full cycle write strobe28
  wire           n_r_read28;           // Store28 RW srate28 for multiple accesses
  wire           n_r_wr28;             // write strobe28
  wire [3:0]     n_r_we28;             // write enable  
  wire      r_cs28;       // registered chip28 select28 

   //apb28
   

   wire n_sys_reset28;                        //AHB28 system reset(active low28)

// assign a default value to the signal28 if the bank28 has
// been disabled and the APB28 has been excluded28 (i.e. the config signals28
// come28 from the top level
   
   smc_apb_lite_if28 i_apb_lite28 (
                     //Inputs28
                     
                     .n_preset28(n_preset28),
                     .pclk28(pclk28),
                     .psel28(psel28),
                     .penable28(penable28),
                     .pwrite28(pwrite28),
                     .paddr28(paddr28),
                     .pwdata28(pwdata28),
                     
                    //Outputs28
                     
                     .prdata28(prdata28)
                     
                     );
   
   smc_ahb_lite_if28 i_ahb_lite28  (
                     //Inputs28
                     
		     .hclk28 (hclk28),
                     .n_sys_reset28 (n_sys_reset28),
                     .haddr28 (haddr28),
                     .hsel28 (hsel28),                                                
                     .htrans28 (htrans28),                    
                     .hwrite28 (hwrite28),
                     .hsize28 (hsize28),                
                     .hwdata28 (hwdata28),
                     .hready28 (hready28),
                     .read_data28 (read_data28),
                     .mac_done28 (mac_done28),
                     .smc_done28 (smc_done28),
                     .smc_idle28 (smc_idle28),
                     
                     // Outputs28
                     
                     .xfer_size28 (xfer_size28),
                     .n_read28 (n_read28),
                     .new_access28 (new_access28),
                     .addr (addr),
                     .smc_hrdata28 (smc_hrdata28), 
                     .smc_hready28 (smc_hready28),
                     .smc_hresp28 (smc_hresp28),
                     .smc_valid28 (smc_valid28),
                     .cs (cs),
                     .write_data28 (write_data28)
                     );
   
   

   
   
   smc_counter_lite28 i_counter_lite28 (
                          
                          // Inputs28
                          
                          .sys_clk28 (hclk28),
                          .n_sys_reset28 (n_sys_reset28),
                          .valid_access28 (valid_access28),
                          .mac_done28 (mac_done28),
                          .smc_done28 (smc_done28),
                          .cste_enable28 (cste_enable28),
                          .ws_enable28 (ws_enable28),
                          .le_enable28 (le_enable28),
                          
                          // Outputs28
                          
                          .r_csle_store28 (r_csle_store28),
                          .r_csle_count28 (r_csle_count28),
                          .r_wele_count28 (r_wele_count28),
                          .r_ws_count28 (r_ws_count28),
                          .r_ws_store28 (r_ws_store28),
                          .r_oete_store28 (r_oete_store28),
                          .r_wete_store28 (r_wete_store28),
                          .r_wele_store28 (r_wele_store28),
                          .r_cste_count28 (r_cste_count28));
   
   
   smc_mac_lite28 i_mac_lite28         (
                          
                          // Inputs28
                          
                          .sys_clk28 (hclk28),
                          .n_sys_reset28 (n_sys_reset28),
                          .valid_access28 (valid_access28),
                          .xfer_size28 (xfer_size28),
                          .smc_done28 (smc_done28),
                          .data_smc28 (data_smc28),
                          .write_data28 (write_data28),
                          .smc_nextstate28 (smc_nextstate28),
                          .latch_data28 (latch_data28),
                          
                          // Outputs28
                          
                          .r_num_access28 (r_num_access28),
                          .mac_done28 (mac_done28),
                          .v_bus_size28 (v_bus_size28),
                          .v_xfer_size28 (v_xfer_size28),
                          .read_data28 (read_data28),
                          .smc_data28 (smc_data28));
   
   
   smc_state_lite28 i_state_lite28     (
                          
                          // Inputs28
                          
                          .sys_clk28 (hclk28),
                          .n_sys_reset28 (n_sys_reset28),
                          .new_access28 (new_access28),
                          .r_cste_count28 (r_cste_count28),
                          .r_csle_count28 (r_csle_count28),
                          .r_ws_count28 (r_ws_count28),
                          .mac_done28 (mac_done28),
                          .n_read28 (n_read28),
                          .n_r_read28 (n_r_read28),
                          .r_csle_store28 (r_csle_store28),
                          .r_oete_store28 (r_oete_store28),
                          .cs(cs),
                          .r_cs28(r_cs28),

                          // Outputs28
                          
                          .r_smc_currentstate28 (r_smc_currentstate28),
                          .smc_nextstate28 (smc_nextstate28),
                          .cste_enable28 (cste_enable28),
                          .ws_enable28 (ws_enable28),
                          .smc_done28 (smc_done28),
                          .valid_access28 (valid_access28),
                          .le_enable28 (le_enable28),
                          .latch_data28 (latch_data28),
                          .smc_idle28 (smc_idle28));
   
   smc_strobe_lite28 i_strobe_lite28   (

                          //inputs28

                          .sys_clk28 (hclk28),
                          .n_sys_reset28 (n_sys_reset28),
                          .valid_access28 (valid_access28),
                          .n_read28 (n_read28),
                          .cs(cs),
                          .r_smc_currentstate28 (r_smc_currentstate28),
                          .smc_nextstate28 (smc_nextstate28),
                          .n_be28 (n_be28),
                          .r_wele_store28 (r_wele_store28),
                          .r_wele_count28 (r_wele_count28),
                          .r_wete_store28 (r_wete_store28),
                          .r_oete_store28 (r_oete_store28),
                          .r_ws_count28 (r_ws_count28),
                          .r_ws_store28 (r_ws_store28),
                          .smc_done28 (smc_done28),
                          .mac_done28 (mac_done28),
                          
                          //outputs28

                          .smc_n_rd28 (smc_n_rd28),
                          .smc_n_ext_oe28 (smc_n_ext_oe28),
                          .smc_busy28 (smc_busy28),
                          .n_r_read28 (n_r_read28),
                          .r_cs28(r_cs28),
                          .r_full28 (r_full28),
                          .n_r_we28 (n_r_we28),
                          .n_r_wr28 (n_r_wr28));
   
   smc_wr_enable_lite28 i_wr_enable_lite28 (

                            //inputs28

                          .n_sys_reset28 (n_sys_reset28),
                          .r_full28(r_full28),
                          .n_r_we28(n_r_we28),
                          .n_r_wr28 (n_r_wr28),
                              
                          //output                

                          .smc_n_we28(smc_n_we28),
                          .smc_n_wr28 (smc_n_wr28));
   
   
   
   smc_addr_lite28 i_add_lite28        (
                          //inputs28

                          .sys_clk28 (hclk28),
                          .n_sys_reset28 (n_sys_reset28),
                          .valid_access28 (valid_access28),
                          .r_num_access28 (r_num_access28),
                          .v_bus_size28 (v_bus_size28),
                          .v_xfer_size28 (v_xfer_size28),
                          .cs (cs),
                          .addr (addr),
                          .smc_done28 (smc_done28),
                          .smc_nextstate28 (smc_nextstate28),
                          
                          //outputs28

                          .smc_addr28 (smc_addr28),
                          .smc_n_be28 (smc_n_be28),
                          .smc_n_cs28 (smc_n_cs28),
                          .n_be28 (n_be28));
   
   
endmodule
