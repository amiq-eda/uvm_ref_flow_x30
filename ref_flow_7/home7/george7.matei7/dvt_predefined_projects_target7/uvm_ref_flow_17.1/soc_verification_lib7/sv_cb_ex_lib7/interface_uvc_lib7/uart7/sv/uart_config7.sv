/*-------------------------------------------------------------------------
File7 name   : uart_config7.sv
Title7       : configuration file
Project7     :
Created7     :
Description7 : This7 file contains7 configuration information for the UART7
              device7
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV7
`define UART_CONFIG_SV7

class uart_config7 extends uvm_object;
  //UART7 topology parameters7
  uvm_active_passive_enum  is_tx_active7 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active7 = UVM_PASSIVE;

  // UART7 device7 parameters7
  rand bit [7:0]    baud_rate_gen7;  // Baud7 Rate7 Generator7 Register
  rand bit [7:0]    baud_rate_div7;  // Baud7 Rate7 Divider7 Register

  // Line7 Control7 Register Fields
  rand bit [1:0]    char_length7; // Character7 length (ua_lcr7[1:0])
  rand bit          nbstop7;        // Number7 stop bits (ua_lcr7[2])
  rand bit          parity_en7 ;    // Parity7 Enable7    (ua_lcr7[3])
  rand bit [1:0]    parity_mode7;   // Parity7 Mode7      (ua_lcr7[5:4])

  int unsigned chrl7;  
  int unsigned stop_bt7;  

  // Control7 Register Fields
  rand bit          cts_en7 ;
  rand bit          rts_en7 ;

 // Calculated7 in post_randomize() so not randomized7
  byte unsigned char_len_val7;      // (8, 7 or 6)
  byte unsigned stop_bit_val7;      // (1, 1.5 or 2)

  // These7 default constraints can be overriden7
  // Constrain7 configuration based on UVC7/RTL7 capabilities7
//  constraint c_num_stop_bits7  { nbstop7      inside {[0:1]};}
  constraint c_bgen7          { baud_rate_gen7       == 1;}
  constraint c_brgr7          { baud_rate_div7       == 0;}
  constraint c_rts_en7         { rts_en7      == 0;}
  constraint c_cts_en7         { cts_en7      == 0;}

  // These7 declarations7 implement the create() and get_type_name()
  // as well7 as enable automation7 of the tx_frame7's fields   
  `uvm_object_utils_begin(uart_config7)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active7, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active7, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen7, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div7, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length7, UVM_DEFAULT)
    `uvm_field_int(nbstop7, UVM_DEFAULT )  
    `uvm_field_int(parity_en7, UVM_DEFAULT)
    `uvm_field_int(parity_mode7, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This7 requires for registration7 of the ptp_tx_frame7   
  function new(string name = "uart_config7");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl7();
    ConvToIntStpBt7();
  endfunction 

  // Function7 to convert the 2 bit Character7 length to integer
  function void ConvToIntChrl7();
    case(char_length7)
      2'b00 : char_len_val7 = 5;
      2'b01 : char_len_val7 = 6;
      2'b10 : char_len_val7 = 7;
      2'b11 : char_len_val7 = 8;
      default : char_len_val7 = 8;
    endcase
  endfunction : ConvToIntChrl7
    
  // Function7 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt7();
    case(nbstop7)
      2'b00 : stop_bit_val7 = 1;
      2'b01 : stop_bit_val7 = 2;
      default : stop_bit_val7 = 2;
    endcase
  endfunction : ConvToIntStpBt7
    
endclass
`endif  // UART_CONFIG_SV7
