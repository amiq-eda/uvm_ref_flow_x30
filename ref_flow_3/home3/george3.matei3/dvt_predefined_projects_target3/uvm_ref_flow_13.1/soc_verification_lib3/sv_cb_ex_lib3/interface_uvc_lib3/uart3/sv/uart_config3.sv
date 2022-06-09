/*-------------------------------------------------------------------------
File3 name   : uart_config3.sv
Title3       : configuration file
Project3     :
Created3     :
Description3 : This3 file contains3 configuration information for the UART3
              device3
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV3
`define UART_CONFIG_SV3

class uart_config3 extends uvm_object;
  //UART3 topology parameters3
  uvm_active_passive_enum  is_tx_active3 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active3 = UVM_PASSIVE;

  // UART3 device3 parameters3
  rand bit [7:0]    baud_rate_gen3;  // Baud3 Rate3 Generator3 Register
  rand bit [7:0]    baud_rate_div3;  // Baud3 Rate3 Divider3 Register

  // Line3 Control3 Register Fields
  rand bit [1:0]    char_length3; // Character3 length (ua_lcr3[1:0])
  rand bit          nbstop3;        // Number3 stop bits (ua_lcr3[2])
  rand bit          parity_en3 ;    // Parity3 Enable3    (ua_lcr3[3])
  rand bit [1:0]    parity_mode3;   // Parity3 Mode3      (ua_lcr3[5:4])

  int unsigned chrl3;  
  int unsigned stop_bt3;  

  // Control3 Register Fields
  rand bit          cts_en3 ;
  rand bit          rts_en3 ;

 // Calculated3 in post_randomize() so not randomized3
  byte unsigned char_len_val3;      // (8, 7 or 6)
  byte unsigned stop_bit_val3;      // (1, 1.5 or 2)

  // These3 default constraints can be overriden3
  // Constrain3 configuration based on UVC3/RTL3 capabilities3
//  constraint c_num_stop_bits3  { nbstop3      inside {[0:1]};}
  constraint c_bgen3          { baud_rate_gen3       == 1;}
  constraint c_brgr3          { baud_rate_div3       == 0;}
  constraint c_rts_en3         { rts_en3      == 0;}
  constraint c_cts_en3         { cts_en3      == 0;}

  // These3 declarations3 implement the create() and get_type_name()
  // as well3 as enable automation3 of the tx_frame3's fields   
  `uvm_object_utils_begin(uart_config3)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active3, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active3, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen3, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div3, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length3, UVM_DEFAULT)
    `uvm_field_int(nbstop3, UVM_DEFAULT )  
    `uvm_field_int(parity_en3, UVM_DEFAULT)
    `uvm_field_int(parity_mode3, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This3 requires for registration3 of the ptp_tx_frame3   
  function new(string name = "uart_config3");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl3();
    ConvToIntStpBt3();
  endfunction 

  // Function3 to convert the 2 bit Character3 length to integer
  function void ConvToIntChrl3();
    case(char_length3)
      2'b00 : char_len_val3 = 5;
      2'b01 : char_len_val3 = 6;
      2'b10 : char_len_val3 = 7;
      2'b11 : char_len_val3 = 8;
      default : char_len_val3 = 8;
    endcase
  endfunction : ConvToIntChrl3
    
  // Function3 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt3();
    case(nbstop3)
      2'b00 : stop_bit_val3 = 1;
      2'b01 : stop_bit_val3 = 2;
      default : stop_bit_val3 = 2;
    endcase
  endfunction : ConvToIntStpBt3
    
endclass
`endif  // UART_CONFIG_SV3
