//File1 name   : smc_lite1.v
//Title1       : SMC1 top level
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

 `include "smc_defs_lite1.v"

//static memory controller1
module          smc_lite1(
                    //apb1 inputs1
                    n_preset1, 
                    pclk1, 
                    psel1, 
                    penable1, 
                    pwrite1, 
                    paddr1, 
                    pwdata1,
                    //ahb1 inputs1                    
                    hclk1,
                    n_sys_reset1,
                    haddr1,
                    htrans1,
                    hsel1,
                    hwrite1,
                    hsize1,
                    hwdata1,
                    hready1,
                    data_smc1,
                    

                    //test signal1 inputs1

                    scan_in_11,
                    scan_in_21,
                    scan_in_31,
                    scan_en1,

                    //apb1 outputs1                    
                    prdata1,

                    //design output
                    
                    smc_hrdata1, 
                    smc_hready1,
                    smc_valid1,
                    smc_hresp1,
                    smc_addr1,
                    smc_data1, 
                    smc_n_be1,
                    smc_n_cs1,
                    smc_n_wr1,                    
                    smc_n_we1,
                    smc_n_rd1,
                    smc_n_ext_oe1,
                    smc_busy1,

                    //test signal1 output

                    scan_out_11,
                    scan_out_21,
                    scan_out_31
                   );
// define parameters1
// change using defaparam1 statements1


  // APB1 Inputs1 (use is optional1 on INCLUDE_APB1)
  input        n_preset1;           // APBreset1 
  input        pclk1;               // APB1 clock1
  input        psel1;               // APB1 select1
  input        penable1;            // APB1 enable 
  input        pwrite1;             // APB1 write strobe1 
  input [4:0]  paddr1;              // APB1 address bus
  input [31:0] pwdata1;             // APB1 write data 

  // APB1 Output1 (use is optional1 on INCLUDE_APB1)

  output [31:0] prdata1;        //APB1 output



//System1 I1/O1

  input                    hclk1;          // AHB1 System1 clock1
  input                    n_sys_reset1;   // AHB1 System1 reset (Active1 LOW1)

//AHB1 I1/O1

  input  [31:0]            haddr1;         // AHB1 Address
  input  [1:0]             htrans1;        // AHB1 transfer1 type
  input               hsel1;          // chip1 selects1
  input                    hwrite1;        // AHB1 read/write indication1
  input  [2:0]             hsize1;         // AHB1 transfer1 size
  input  [31:0]            hwdata1;        // AHB1 write data
  input                    hready1;        // AHB1 Muxed1 ready signal1

  
  output [31:0]            smc_hrdata1;    // smc1 read data back to AHB1 master1
  output                   smc_hready1;    // smc1 ready signal1
  output [1:0]             smc_hresp1;     // AHB1 Response1 signal1
  output                   smc_valid1;     // Ack1 valid address

//External1 memory interface (EMI1)

  output [31:0]            smc_addr1;      // External1 Memory (EMI1) address
  output [31:0]            smc_data1;      // EMI1 write data
  input  [31:0]            data_smc1;      // EMI1 read data
  output [3:0]             smc_n_be1;      // EMI1 byte enables1 (Active1 LOW1)
  output             smc_n_cs1;      // EMI1 Chip1 Selects1 (Active1 LOW1)
  output [3:0]             smc_n_we1;      // EMI1 write strobes1 (Active1 LOW1)
  output                   smc_n_wr1;      // EMI1 write enable (Active1 LOW1)
  output                   smc_n_rd1;      // EMI1 read stobe1 (Active1 LOW1)
  output 	           smc_n_ext_oe1;  // EMI1 write data output enable

//AHB1 Memory Interface1 Control1

   output                   smc_busy1;      // smc1 busy

   
   


//scan1 signals1

   input                  scan_in_11;        //scan1 input
   input                  scan_in_21;        //scan1 input
   input                  scan_en1;         //scan1 enable
   output                 scan_out_11;       //scan1 output
   output                 scan_out_21;       //scan1 output
// third1 scan1 chain1 only used on INCLUDE_APB1
   input                  scan_in_31;        //scan1 input
   output                 scan_out_31;       //scan1 output
   
//----------------------------------------------------------------------
// Signal1 declarations1
//----------------------------------------------------------------------

// Bus1 Interface1
   
  wire  [31:0]   smc_hrdata1;         //smc1 read data back to AHB1 master1
  wire           smc_hready1;         //smc1 ready signal1
  wire  [1:0]    smc_hresp1;          //AHB1 Response1 signal1
  wire           smc_valid1;          //Ack1 valid address

// MAC1

  wire [31:0]    smc_data1;           //Data to external1 bus via MUX1

// Strobe1 Generation1

  wire           smc_n_wr1;           //EMI1 write enable (Active1 LOW1)
  wire  [3:0]    smc_n_we1;           //EMI1 write strobes1 (Active1 LOW1)
  wire           smc_n_rd1;           //EMI1 read stobe1 (Active1 LOW1)
  wire           smc_busy1;           //smc1 busy
  wire           smc_n_ext_oe1;       //Enable1 External1 bus drivers1.(CS1 & !RD1)

// Address Generation1

  wire [31:0]    smc_addr1;           //External1 Memory Interface1(EMI1) address
  wire [3:0]     smc_n_be1;   //EMI1 byte enables1 (Active1 LOW1)
  wire      smc_n_cs1;   //EMI1 Chip1 Selects1 (Active1 LOW1)

// Bus1 Interface1

  wire           new_access1;         // New1 AHB1 access to smc1 detected
  wire [31:0]    addr;               // Copy1 of address
  wire [31:0]    write_data1;         // Data to External1 Bus1
  wire      cs;         // Chip1(bank1) Select1 Lines1
  wire [1:0]     xfer_size1;          // Width1 of current transfer1
  wire           n_read1;             // Active1 low1 read signal1                   
  
// Configuration1 Block


// Counters1

  wire [1:0]     r_csle_count1;       // Chip1 select1 LE1 counter
  wire [1:0]     r_wele_count1;       // Write counter
  wire [1:0]     r_cste_count1;       // chip1 select1 TE1 counter
  wire [7:0]     r_ws_count1; // Wait1 state select1 counter
  
// These1 strobes1 finish early1 so no counter is required1. The stored1 value
// is compared with WS1 counter to determine1 when the strobe1 should end.

  wire [1:0]     r_wete_store1;       // Write strobe1 TE1 end time before CS1
  wire [1:0]     r_oete_store1;       // Read strobe1 TE1 end time before CS1
  
// The following1 four1 wireisrers1 are used to store1 the configuration during
// mulitple1 accesses. The counters1 are reloaded1 from these1 wireisters1
//  before each cycle.

  wire [1:0]     r_csle_store1;       // Chip1 select1 LE1 store1
  wire [1:0]     r_wele_store1;       // Write strobe1 LE1 store1
  wire [7:0]     r_ws_store1;         // Wait1 state store1
  wire [1:0]     r_cste_store1;       // Chip1 Select1 TE1 delay (Bus1 float1 time)


// Multiple1 access control1

  wire           mac_done1;           // Indicates1 last cycle of last access
  wire [1:0]     r_num_access1;       // Access counter
  wire [1:0]     v_xfer_size1;        // Store1 size for MAC1 
  wire [1:0]     v_bus_size1;         // Store1 size for MAC1
  wire [31:0]    read_data1;          // Data path to bus IF
  wire [31:0]    r_read_data1;        // Internal data store1

// smc1 state machine1


  wire           valid_access1;       // New1 acces1 can proceed
  wire   [4:0]   smc_nextstate1;      // state machine1 (async1 encoding1)
  wire   [4:0]   r_smc_currentstate1; // Synchronised1 smc1 state machine1
  wire           ws_enable1;          // Wait1 state counter enable
  wire           cste_enable1;        // Chip1 select1 counter enable
  wire           smc_done1;           // Asserted1 during last cycle of
                                     //    an access
  wire           le_enable1;          // Start1 counters1 after STORED1 
                                     //    access
  wire           latch_data1;         // latch_data1 is used by the MAC1 
                                     //    block to store1 read data 
                                     //    if CSTE1 > 0
  wire           smc_idle1;           // idle1 state

// Address Generation1

  wire [3:0]     n_be1;               // Full cycle write strobe1

// Strobe1 Generation1

  wire           r_full1;             // Full cycle write strobe1
  wire           n_r_read1;           // Store1 RW srate1 for multiple accesses
  wire           n_r_wr1;             // write strobe1
  wire [3:0]     n_r_we1;             // write enable  
  wire      r_cs1;       // registered chip1 select1 

   //apb1
   

   wire n_sys_reset1;                        //AHB1 system reset(active low1)

// assign a default value to the signal1 if the bank1 has
// been disabled and the APB1 has been excluded1 (i.e. the config signals1
// come1 from the top level
   
   smc_apb_lite_if1 i_apb_lite1 (
                     //Inputs1
                     
                     .n_preset1(n_preset1),
                     .pclk1(pclk1),
                     .psel1(psel1),
                     .penable1(penable1),
                     .pwrite1(pwrite1),
                     .paddr1(paddr1),
                     .pwdata1(pwdata1),
                     
                    //Outputs1
                     
                     .prdata1(prdata1)
                     
                     );
   
   smc_ahb_lite_if1 i_ahb_lite1  (
                     //Inputs1
                     
		     .hclk1 (hclk1),
                     .n_sys_reset1 (n_sys_reset1),
                     .haddr1 (haddr1),
                     .hsel1 (hsel1),                                                
                     .htrans1 (htrans1),                    
                     .hwrite1 (hwrite1),
                     .hsize1 (hsize1),                
                     .hwdata1 (hwdata1),
                     .hready1 (hready1),
                     .read_data1 (read_data1),
                     .mac_done1 (mac_done1),
                     .smc_done1 (smc_done1),
                     .smc_idle1 (smc_idle1),
                     
                     // Outputs1
                     
                     .xfer_size1 (xfer_size1),
                     .n_read1 (n_read1),
                     .new_access1 (new_access1),
                     .addr (addr),
                     .smc_hrdata1 (smc_hrdata1), 
                     .smc_hready1 (smc_hready1),
                     .smc_hresp1 (smc_hresp1),
                     .smc_valid1 (smc_valid1),
                     .cs (cs),
                     .write_data1 (write_data1)
                     );
   
   

   
   
   smc_counter_lite1 i_counter_lite1 (
                          
                          // Inputs1
                          
                          .sys_clk1 (hclk1),
                          .n_sys_reset1 (n_sys_reset1),
                          .valid_access1 (valid_access1),
                          .mac_done1 (mac_done1),
                          .smc_done1 (smc_done1),
                          .cste_enable1 (cste_enable1),
                          .ws_enable1 (ws_enable1),
                          .le_enable1 (le_enable1),
                          
                          // Outputs1
                          
                          .r_csle_store1 (r_csle_store1),
                          .r_csle_count1 (r_csle_count1),
                          .r_wele_count1 (r_wele_count1),
                          .r_ws_count1 (r_ws_count1),
                          .r_ws_store1 (r_ws_store1),
                          .r_oete_store1 (r_oete_store1),
                          .r_wete_store1 (r_wete_store1),
                          .r_wele_store1 (r_wele_store1),
                          .r_cste_count1 (r_cste_count1));
   
   
   smc_mac_lite1 i_mac_lite1         (
                          
                          // Inputs1
                          
                          .sys_clk1 (hclk1),
                          .n_sys_reset1 (n_sys_reset1),
                          .valid_access1 (valid_access1),
                          .xfer_size1 (xfer_size1),
                          .smc_done1 (smc_done1),
                          .data_smc1 (data_smc1),
                          .write_data1 (write_data1),
                          .smc_nextstate1 (smc_nextstate1),
                          .latch_data1 (latch_data1),
                          
                          // Outputs1
                          
                          .r_num_access1 (r_num_access1),
                          .mac_done1 (mac_done1),
                          .v_bus_size1 (v_bus_size1),
                          .v_xfer_size1 (v_xfer_size1),
                          .read_data1 (read_data1),
                          .smc_data1 (smc_data1));
   
   
   smc_state_lite1 i_state_lite1     (
                          
                          // Inputs1
                          
                          .sys_clk1 (hclk1),
                          .n_sys_reset1 (n_sys_reset1),
                          .new_access1 (new_access1),
                          .r_cste_count1 (r_cste_count1),
                          .r_csle_count1 (r_csle_count1),
                          .r_ws_count1 (r_ws_count1),
                          .mac_done1 (mac_done1),
                          .n_read1 (n_read1),
                          .n_r_read1 (n_r_read1),
                          .r_csle_store1 (r_csle_store1),
                          .r_oete_store1 (r_oete_store1),
                          .cs(cs),
                          .r_cs1(r_cs1),

                          // Outputs1
                          
                          .r_smc_currentstate1 (r_smc_currentstate1),
                          .smc_nextstate1 (smc_nextstate1),
                          .cste_enable1 (cste_enable1),
                          .ws_enable1 (ws_enable1),
                          .smc_done1 (smc_done1),
                          .valid_access1 (valid_access1),
                          .le_enable1 (le_enable1),
                          .latch_data1 (latch_data1),
                          .smc_idle1 (smc_idle1));
   
   smc_strobe_lite1 i_strobe_lite1   (

                          //inputs1

                          .sys_clk1 (hclk1),
                          .n_sys_reset1 (n_sys_reset1),
                          .valid_access1 (valid_access1),
                          .n_read1 (n_read1),
                          .cs(cs),
                          .r_smc_currentstate1 (r_smc_currentstate1),
                          .smc_nextstate1 (smc_nextstate1),
                          .n_be1 (n_be1),
                          .r_wele_store1 (r_wele_store1),
                          .r_wele_count1 (r_wele_count1),
                          .r_wete_store1 (r_wete_store1),
                          .r_oete_store1 (r_oete_store1),
                          .r_ws_count1 (r_ws_count1),
                          .r_ws_store1 (r_ws_store1),
                          .smc_done1 (smc_done1),
                          .mac_done1 (mac_done1),
                          
                          //outputs1

                          .smc_n_rd1 (smc_n_rd1),
                          .smc_n_ext_oe1 (smc_n_ext_oe1),
                          .smc_busy1 (smc_busy1),
                          .n_r_read1 (n_r_read1),
                          .r_cs1(r_cs1),
                          .r_full1 (r_full1),
                          .n_r_we1 (n_r_we1),
                          .n_r_wr1 (n_r_wr1));
   
   smc_wr_enable_lite1 i_wr_enable_lite1 (

                            //inputs1

                          .n_sys_reset1 (n_sys_reset1),
                          .r_full1(r_full1),
                          .n_r_we1(n_r_we1),
                          .n_r_wr1 (n_r_wr1),
                              
                          //output                

                          .smc_n_we1(smc_n_we1),
                          .smc_n_wr1 (smc_n_wr1));
   
   
   
   smc_addr_lite1 i_add_lite1        (
                          //inputs1

                          .sys_clk1 (hclk1),
                          .n_sys_reset1 (n_sys_reset1),
                          .valid_access1 (valid_access1),
                          .r_num_access1 (r_num_access1),
                          .v_bus_size1 (v_bus_size1),
                          .v_xfer_size1 (v_xfer_size1),
                          .cs (cs),
                          .addr (addr),
                          .smc_done1 (smc_done1),
                          .smc_nextstate1 (smc_nextstate1),
                          
                          //outputs1

                          .smc_addr1 (smc_addr1),
                          .smc_n_be1 (smc_n_be1),
                          .smc_n_cs1 (smc_n_cs1),
                          .n_be1 (n_be1));
   
   
endmodule
