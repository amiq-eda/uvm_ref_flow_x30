/*-------------------------------------------------------------------------
File29 name   : uart_config29.sv
Title29       : configuration file
Project29     :
Created29     :
Description29 : This29 file contains29 configuration information for the UART29
              device29
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV29
`define UART_CONFIG_SV29

class uart_config29 extends uvm_object;
  //UART29 topology parameters29
  uvm_active_passive_enum  is_tx_active29 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active29 = UVM_PASSIVE;

  // UART29 device29 parameters29
  rand bit [7:0]    baud_rate_gen29;  // Baud29 Rate29 Generator29 Register
  rand bit [7:0]    baud_rate_div29;  // Baud29 Rate29 Divider29 Register

  // Line29 Control29 Register Fields
  rand bit [1:0]    char_length29; // Character29 length (ua_lcr29[1:0])
  rand bit          nbstop29;        // Number29 stop bits (ua_lcr29[2])
  rand bit          parity_en29 ;    // Parity29 Enable29    (ua_lcr29[3])
  rand bit [1:0]    parity_mode29;   // Parity29 Mode29      (ua_lcr29[5:4])

  int unsigned chrl29;  
  int unsigned stop_bt29;  

  // Control29 Register Fields
  rand bit          cts_en29 ;
  rand bit          rts_en29 ;

 // Calculated29 in post_randomize() so not randomized29
  byte unsigned char_len_val29;      // (8, 7 or 6)
  byte unsigned stop_bit_val29;      // (1, 1.5 or 2)

  // These29 default constraints can be overriden29
  // Constrain29 configuration based on UVC29/RTL29 capabilities29
//  constraint c_num_stop_bits29  { nbstop29      inside {[0:1]};}
  constraint c_bgen29          { baud_rate_gen29       == 1;}
  constraint c_brgr29          { baud_rate_div29       == 0;}
  constraint c_rts_en29         { rts_en29      == 0;}
  constraint c_cts_en29         { cts_en29      == 0;}

  // These29 declarations29 implement the create() and get_type_name()
  // as well29 as enable automation29 of the tx_frame29's fields   
  `uvm_object_utils_begin(uart_config29)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active29, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active29, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen29, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div29, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length29, UVM_DEFAULT)
    `uvm_field_int(nbstop29, UVM_DEFAULT )  
    `uvm_field_int(parity_en29, UVM_DEFAULT)
    `uvm_field_int(parity_mode29, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This29 requires for registration29 of the ptp_tx_frame29   
  function new(string name = "uart_config29");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl29();
    ConvToIntStpBt29();
  endfunction 

  // Function29 to convert the 2 bit Character29 length to integer
  function void ConvToIntChrl29();
    case(char_length29)
      2'b00 : char_len_val29 = 5;
      2'b01 : char_len_val29 = 6;
      2'b10 : char_len_val29 = 7;
      2'b11 : char_len_val29 = 8;
      default : char_len_val29 = 8;
    endcase
  endfunction : ConvToIntChrl29
    
  // Function29 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt29();
    case(nbstop29)
      2'b00 : stop_bit_val29 = 1;
      2'b01 : stop_bit_val29 = 2;
      default : stop_bit_val29 = 2;
    endcase
  endfunction : ConvToIntStpBt29
    
endclass
`endif  // UART_CONFIG_SV29
