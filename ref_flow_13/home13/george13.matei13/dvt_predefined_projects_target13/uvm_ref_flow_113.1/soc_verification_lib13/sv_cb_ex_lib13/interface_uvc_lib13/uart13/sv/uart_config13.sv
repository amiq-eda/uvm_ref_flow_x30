/*-------------------------------------------------------------------------
File13 name   : uart_config13.sv
Title13       : configuration file
Project13     :
Created13     :
Description13 : This13 file contains13 configuration information for the UART13
              device13
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV13
`define UART_CONFIG_SV13

class uart_config13 extends uvm_object;
  //UART13 topology parameters13
  uvm_active_passive_enum  is_tx_active13 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active13 = UVM_PASSIVE;

  // UART13 device13 parameters13
  rand bit [7:0]    baud_rate_gen13;  // Baud13 Rate13 Generator13 Register
  rand bit [7:0]    baud_rate_div13;  // Baud13 Rate13 Divider13 Register

  // Line13 Control13 Register Fields
  rand bit [1:0]    char_length13; // Character13 length (ua_lcr13[1:0])
  rand bit          nbstop13;        // Number13 stop bits (ua_lcr13[2])
  rand bit          parity_en13 ;    // Parity13 Enable13    (ua_lcr13[3])
  rand bit [1:0]    parity_mode13;   // Parity13 Mode13      (ua_lcr13[5:4])

  int unsigned chrl13;  
  int unsigned stop_bt13;  

  // Control13 Register Fields
  rand bit          cts_en13 ;
  rand bit          rts_en13 ;

 // Calculated13 in post_randomize() so not randomized13
  byte unsigned char_len_val13;      // (8, 7 or 6)
  byte unsigned stop_bit_val13;      // (1, 1.5 or 2)

  // These13 default constraints can be overriden13
  // Constrain13 configuration based on UVC13/RTL13 capabilities13
//  constraint c_num_stop_bits13  { nbstop13      inside {[0:1]};}
  constraint c_bgen13          { baud_rate_gen13       == 1;}
  constraint c_brgr13          { baud_rate_div13       == 0;}
  constraint c_rts_en13         { rts_en13      == 0;}
  constraint c_cts_en13         { cts_en13      == 0;}

  // These13 declarations13 implement the create() and get_type_name()
  // as well13 as enable automation13 of the tx_frame13's fields   
  `uvm_object_utils_begin(uart_config13)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active13, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active13, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen13, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div13, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length13, UVM_DEFAULT)
    `uvm_field_int(nbstop13, UVM_DEFAULT )  
    `uvm_field_int(parity_en13, UVM_DEFAULT)
    `uvm_field_int(parity_mode13, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This13 requires for registration13 of the ptp_tx_frame13   
  function new(string name = "uart_config13");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl13();
    ConvToIntStpBt13();
  endfunction 

  // Function13 to convert the 2 bit Character13 length to integer
  function void ConvToIntChrl13();
    case(char_length13)
      2'b00 : char_len_val13 = 5;
      2'b01 : char_len_val13 = 6;
      2'b10 : char_len_val13 = 7;
      2'b11 : char_len_val13 = 8;
      default : char_len_val13 = 8;
    endcase
  endfunction : ConvToIntChrl13
    
  // Function13 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt13();
    case(nbstop13)
      2'b00 : stop_bit_val13 = 1;
      2'b01 : stop_bit_val13 = 2;
      default : stop_bit_val13 = 2;
    endcase
  endfunction : ConvToIntStpBt13
    
endclass
`endif  // UART_CONFIG_SV13
