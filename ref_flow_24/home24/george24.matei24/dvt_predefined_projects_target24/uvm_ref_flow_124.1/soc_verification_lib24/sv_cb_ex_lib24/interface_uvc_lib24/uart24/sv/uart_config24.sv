/*-------------------------------------------------------------------------
File24 name   : uart_config24.sv
Title24       : configuration file
Project24     :
Created24     :
Description24 : This24 file contains24 configuration information for the UART24
              device24
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV24
`define UART_CONFIG_SV24

class uart_config24 extends uvm_object;
  //UART24 topology parameters24
  uvm_active_passive_enum  is_tx_active24 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active24 = UVM_PASSIVE;

  // UART24 device24 parameters24
  rand bit [7:0]    baud_rate_gen24;  // Baud24 Rate24 Generator24 Register
  rand bit [7:0]    baud_rate_div24;  // Baud24 Rate24 Divider24 Register

  // Line24 Control24 Register Fields
  rand bit [1:0]    char_length24; // Character24 length (ua_lcr24[1:0])
  rand bit          nbstop24;        // Number24 stop bits (ua_lcr24[2])
  rand bit          parity_en24 ;    // Parity24 Enable24    (ua_lcr24[3])
  rand bit [1:0]    parity_mode24;   // Parity24 Mode24      (ua_lcr24[5:4])

  int unsigned chrl24;  
  int unsigned stop_bt24;  

  // Control24 Register Fields
  rand bit          cts_en24 ;
  rand bit          rts_en24 ;

 // Calculated24 in post_randomize() so not randomized24
  byte unsigned char_len_val24;      // (8, 7 or 6)
  byte unsigned stop_bit_val24;      // (1, 1.5 or 2)

  // These24 default constraints can be overriden24
  // Constrain24 configuration based on UVC24/RTL24 capabilities24
//  constraint c_num_stop_bits24  { nbstop24      inside {[0:1]};}
  constraint c_bgen24          { baud_rate_gen24       == 1;}
  constraint c_brgr24          { baud_rate_div24       == 0;}
  constraint c_rts_en24         { rts_en24      == 0;}
  constraint c_cts_en24         { cts_en24      == 0;}

  // These24 declarations24 implement the create() and get_type_name()
  // as well24 as enable automation24 of the tx_frame24's fields   
  `uvm_object_utils_begin(uart_config24)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active24, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active24, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen24, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div24, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length24, UVM_DEFAULT)
    `uvm_field_int(nbstop24, UVM_DEFAULT )  
    `uvm_field_int(parity_en24, UVM_DEFAULT)
    `uvm_field_int(parity_mode24, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This24 requires for registration24 of the ptp_tx_frame24   
  function new(string name = "uart_config24");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl24();
    ConvToIntStpBt24();
  endfunction 

  // Function24 to convert the 2 bit Character24 length to integer
  function void ConvToIntChrl24();
    case(char_length24)
      2'b00 : char_len_val24 = 5;
      2'b01 : char_len_val24 = 6;
      2'b10 : char_len_val24 = 7;
      2'b11 : char_len_val24 = 8;
      default : char_len_val24 = 8;
    endcase
  endfunction : ConvToIntChrl24
    
  // Function24 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt24();
    case(nbstop24)
      2'b00 : stop_bit_val24 = 1;
      2'b01 : stop_bit_val24 = 2;
      default : stop_bit_val24 = 2;
    endcase
  endfunction : ConvToIntStpBt24
    
endclass
`endif  // UART_CONFIG_SV24
