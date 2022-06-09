/*-------------------------------------------------------------------------
File28 name   : uart_config28.sv
Title28       : configuration file
Project28     :
Created28     :
Description28 : This28 file contains28 configuration information for the UART28
              device28
Notes28       :  
----------------------------------------------------------------------*/
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


`ifndef UART_CONFIG_SV28
`define UART_CONFIG_SV28

class uart_config28 extends uvm_object;
  //UART28 topology parameters28
  uvm_active_passive_enum  is_tx_active28 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active28 = UVM_PASSIVE;

  // UART28 device28 parameters28
  rand bit [7:0]    baud_rate_gen28;  // Baud28 Rate28 Generator28 Register
  rand bit [7:0]    baud_rate_div28;  // Baud28 Rate28 Divider28 Register

  // Line28 Control28 Register Fields
  rand bit [1:0]    char_length28; // Character28 length (ua_lcr28[1:0])
  rand bit          nbstop28;        // Number28 stop bits (ua_lcr28[2])
  rand bit          parity_en28 ;    // Parity28 Enable28    (ua_lcr28[3])
  rand bit [1:0]    parity_mode28;   // Parity28 Mode28      (ua_lcr28[5:4])

  int unsigned chrl28;  
  int unsigned stop_bt28;  

  // Control28 Register Fields
  rand bit          cts_en28 ;
  rand bit          rts_en28 ;

 // Calculated28 in post_randomize() so not randomized28
  byte unsigned char_len_val28;      // (8, 7 or 6)
  byte unsigned stop_bit_val28;      // (1, 1.5 or 2)

  // These28 default constraints can be overriden28
  // Constrain28 configuration based on UVC28/RTL28 capabilities28
//  constraint c_num_stop_bits28  { nbstop28      inside {[0:1]};}
  constraint c_bgen28          { baud_rate_gen28       == 1;}
  constraint c_brgr28          { baud_rate_div28       == 0;}
  constraint c_rts_en28         { rts_en28      == 0;}
  constraint c_cts_en28         { cts_en28      == 0;}

  // These28 declarations28 implement the create() and get_type_name()
  // as well28 as enable automation28 of the tx_frame28's fields   
  `uvm_object_utils_begin(uart_config28)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active28, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active28, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen28, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div28, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length28, UVM_DEFAULT)
    `uvm_field_int(nbstop28, UVM_DEFAULT )  
    `uvm_field_int(parity_en28, UVM_DEFAULT)
    `uvm_field_int(parity_mode28, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This28 requires for registration28 of the ptp_tx_frame28   
  function new(string name = "uart_config28");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl28();
    ConvToIntStpBt28();
  endfunction 

  // Function28 to convert the 2 bit Character28 length to integer
  function void ConvToIntChrl28();
    case(char_length28)
      2'b00 : char_len_val28 = 5;
      2'b01 : char_len_val28 = 6;
      2'b10 : char_len_val28 = 7;
      2'b11 : char_len_val28 = 8;
      default : char_len_val28 = 8;
    endcase
  endfunction : ConvToIntChrl28
    
  // Function28 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt28();
    case(nbstop28)
      2'b00 : stop_bit_val28 = 1;
      2'b01 : stop_bit_val28 = 2;
      default : stop_bit_val28 = 2;
    endcase
  endfunction : ConvToIntStpBt28
    
endclass
`endif  // UART_CONFIG_SV28
