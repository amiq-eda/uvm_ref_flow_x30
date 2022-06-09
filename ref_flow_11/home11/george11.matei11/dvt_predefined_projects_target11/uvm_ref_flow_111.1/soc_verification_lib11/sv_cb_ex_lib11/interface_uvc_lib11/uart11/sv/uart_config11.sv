/*-------------------------------------------------------------------------
File11 name   : uart_config11.sv
Title11       : configuration file
Project11     :
Created11     :
Description11 : This11 file contains11 configuration information for the UART11
              device11
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV11
`define UART_CONFIG_SV11

class uart_config11 extends uvm_object;
  //UART11 topology parameters11
  uvm_active_passive_enum  is_tx_active11 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active11 = UVM_PASSIVE;

  // UART11 device11 parameters11
  rand bit [7:0]    baud_rate_gen11;  // Baud11 Rate11 Generator11 Register
  rand bit [7:0]    baud_rate_div11;  // Baud11 Rate11 Divider11 Register

  // Line11 Control11 Register Fields
  rand bit [1:0]    char_length11; // Character11 length (ua_lcr11[1:0])
  rand bit          nbstop11;        // Number11 stop bits (ua_lcr11[2])
  rand bit          parity_en11 ;    // Parity11 Enable11    (ua_lcr11[3])
  rand bit [1:0]    parity_mode11;   // Parity11 Mode11      (ua_lcr11[5:4])

  int unsigned chrl11;  
  int unsigned stop_bt11;  

  // Control11 Register Fields
  rand bit          cts_en11 ;
  rand bit          rts_en11 ;

 // Calculated11 in post_randomize() so not randomized11
  byte unsigned char_len_val11;      // (8, 7 or 6)
  byte unsigned stop_bit_val11;      // (1, 1.5 or 2)

  // These11 default constraints can be overriden11
  // Constrain11 configuration based on UVC11/RTL11 capabilities11
//  constraint c_num_stop_bits11  { nbstop11      inside {[0:1]};}
  constraint c_bgen11          { baud_rate_gen11       == 1;}
  constraint c_brgr11          { baud_rate_div11       == 0;}
  constraint c_rts_en11         { rts_en11      == 0;}
  constraint c_cts_en11         { cts_en11      == 0;}

  // These11 declarations11 implement the create() and get_type_name()
  // as well11 as enable automation11 of the tx_frame11's fields   
  `uvm_object_utils_begin(uart_config11)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active11, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active11, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen11, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div11, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length11, UVM_DEFAULT)
    `uvm_field_int(nbstop11, UVM_DEFAULT )  
    `uvm_field_int(parity_en11, UVM_DEFAULT)
    `uvm_field_int(parity_mode11, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This11 requires for registration11 of the ptp_tx_frame11   
  function new(string name = "uart_config11");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl11();
    ConvToIntStpBt11();
  endfunction 

  // Function11 to convert the 2 bit Character11 length to integer
  function void ConvToIntChrl11();
    case(char_length11)
      2'b00 : char_len_val11 = 5;
      2'b01 : char_len_val11 = 6;
      2'b10 : char_len_val11 = 7;
      2'b11 : char_len_val11 = 8;
      default : char_len_val11 = 8;
    endcase
  endfunction : ConvToIntChrl11
    
  // Function11 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt11();
    case(nbstop11)
      2'b00 : stop_bit_val11 = 1;
      2'b01 : stop_bit_val11 = 2;
      default : stop_bit_val11 = 2;
    endcase
  endfunction : ConvToIntStpBt11
    
endclass
`endif  // UART_CONFIG_SV11
