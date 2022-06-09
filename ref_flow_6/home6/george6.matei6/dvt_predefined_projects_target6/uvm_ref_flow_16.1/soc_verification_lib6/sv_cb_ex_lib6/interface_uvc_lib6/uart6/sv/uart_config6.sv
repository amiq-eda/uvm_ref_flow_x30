/*-------------------------------------------------------------------------
File6 name   : uart_config6.sv
Title6       : configuration file
Project6     :
Created6     :
Description6 : This6 file contains6 configuration information for the UART6
              device6
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV6
`define UART_CONFIG_SV6

class uart_config6 extends uvm_object;
  //UART6 topology parameters6
  uvm_active_passive_enum  is_tx_active6 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active6 = UVM_PASSIVE;

  // UART6 device6 parameters6
  rand bit [7:0]    baud_rate_gen6;  // Baud6 Rate6 Generator6 Register
  rand bit [7:0]    baud_rate_div6;  // Baud6 Rate6 Divider6 Register

  // Line6 Control6 Register Fields
  rand bit [1:0]    char_length6; // Character6 length (ua_lcr6[1:0])
  rand bit          nbstop6;        // Number6 stop bits (ua_lcr6[2])
  rand bit          parity_en6 ;    // Parity6 Enable6    (ua_lcr6[3])
  rand bit [1:0]    parity_mode6;   // Parity6 Mode6      (ua_lcr6[5:4])

  int unsigned chrl6;  
  int unsigned stop_bt6;  

  // Control6 Register Fields
  rand bit          cts_en6 ;
  rand bit          rts_en6 ;

 // Calculated6 in post_randomize() so not randomized6
  byte unsigned char_len_val6;      // (8, 7 or 6)
  byte unsigned stop_bit_val6;      // (1, 1.5 or 2)

  // These6 default constraints can be overriden6
  // Constrain6 configuration based on UVC6/RTL6 capabilities6
//  constraint c_num_stop_bits6  { nbstop6      inside {[0:1]};}
  constraint c_bgen6          { baud_rate_gen6       == 1;}
  constraint c_brgr6          { baud_rate_div6       == 0;}
  constraint c_rts_en6         { rts_en6      == 0;}
  constraint c_cts_en6         { cts_en6      == 0;}

  // These6 declarations6 implement the create() and get_type_name()
  // as well6 as enable automation6 of the tx_frame6's fields   
  `uvm_object_utils_begin(uart_config6)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active6, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active6, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen6, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div6, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length6, UVM_DEFAULT)
    `uvm_field_int(nbstop6, UVM_DEFAULT )  
    `uvm_field_int(parity_en6, UVM_DEFAULT)
    `uvm_field_int(parity_mode6, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This6 requires for registration6 of the ptp_tx_frame6   
  function new(string name = "uart_config6");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl6();
    ConvToIntStpBt6();
  endfunction 

  // Function6 to convert the 2 bit Character6 length to integer
  function void ConvToIntChrl6();
    case(char_length6)
      2'b00 : char_len_val6 = 5;
      2'b01 : char_len_val6 = 6;
      2'b10 : char_len_val6 = 7;
      2'b11 : char_len_val6 = 8;
      default : char_len_val6 = 8;
    endcase
  endfunction : ConvToIntChrl6
    
  // Function6 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt6();
    case(nbstop6)
      2'b00 : stop_bit_val6 = 1;
      2'b01 : stop_bit_val6 = 2;
      default : stop_bit_val6 = 2;
    endcase
  endfunction : ConvToIntStpBt6
    
endclass
`endif  // UART_CONFIG_SV6
