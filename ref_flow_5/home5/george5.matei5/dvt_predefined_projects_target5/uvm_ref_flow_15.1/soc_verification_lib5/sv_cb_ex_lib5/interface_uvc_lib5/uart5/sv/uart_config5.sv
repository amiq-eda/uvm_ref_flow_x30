/*-------------------------------------------------------------------------
File5 name   : uart_config5.sv
Title5       : configuration file
Project5     :
Created5     :
Description5 : This5 file contains5 configuration information for the UART5
              device5
Notes5       :  
----------------------------------------------------------------------*/
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


`ifndef UART_CONFIG_SV5
`define UART_CONFIG_SV5

class uart_config5 extends uvm_object;
  //UART5 topology parameters5
  uvm_active_passive_enum  is_tx_active5 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active5 = UVM_PASSIVE;

  // UART5 device5 parameters5
  rand bit [7:0]    baud_rate_gen5;  // Baud5 Rate5 Generator5 Register
  rand bit [7:0]    baud_rate_div5;  // Baud5 Rate5 Divider5 Register

  // Line5 Control5 Register Fields
  rand bit [1:0]    char_length5; // Character5 length (ua_lcr5[1:0])
  rand bit          nbstop5;        // Number5 stop bits (ua_lcr5[2])
  rand bit          parity_en5 ;    // Parity5 Enable5    (ua_lcr5[3])
  rand bit [1:0]    parity_mode5;   // Parity5 Mode5      (ua_lcr5[5:4])

  int unsigned chrl5;  
  int unsigned stop_bt5;  

  // Control5 Register Fields
  rand bit          cts_en5 ;
  rand bit          rts_en5 ;

 // Calculated5 in post_randomize() so not randomized5
  byte unsigned char_len_val5;      // (8, 7 or 6)
  byte unsigned stop_bit_val5;      // (1, 1.5 or 2)

  // These5 default constraints can be overriden5
  // Constrain5 configuration based on UVC5/RTL5 capabilities5
//  constraint c_num_stop_bits5  { nbstop5      inside {[0:1]};}
  constraint c_bgen5          { baud_rate_gen5       == 1;}
  constraint c_brgr5          { baud_rate_div5       == 0;}
  constraint c_rts_en5         { rts_en5      == 0;}
  constraint c_cts_en5         { cts_en5      == 0;}

  // These5 declarations5 implement the create() and get_type_name()
  // as well5 as enable automation5 of the tx_frame5's fields   
  `uvm_object_utils_begin(uart_config5)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active5, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active5, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen5, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div5, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length5, UVM_DEFAULT)
    `uvm_field_int(nbstop5, UVM_DEFAULT )  
    `uvm_field_int(parity_en5, UVM_DEFAULT)
    `uvm_field_int(parity_mode5, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This5 requires for registration5 of the ptp_tx_frame5   
  function new(string name = "uart_config5");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl5();
    ConvToIntStpBt5();
  endfunction 

  // Function5 to convert the 2 bit Character5 length to integer
  function void ConvToIntChrl5();
    case(char_length5)
      2'b00 : char_len_val5 = 5;
      2'b01 : char_len_val5 = 6;
      2'b10 : char_len_val5 = 7;
      2'b11 : char_len_val5 = 8;
      default : char_len_val5 = 8;
    endcase
  endfunction : ConvToIntChrl5
    
  // Function5 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt5();
    case(nbstop5)
      2'b00 : stop_bit_val5 = 1;
      2'b01 : stop_bit_val5 = 2;
      default : stop_bit_val5 = 2;
    endcase
  endfunction : ConvToIntStpBt5
    
endclass
`endif  // UART_CONFIG_SV5
