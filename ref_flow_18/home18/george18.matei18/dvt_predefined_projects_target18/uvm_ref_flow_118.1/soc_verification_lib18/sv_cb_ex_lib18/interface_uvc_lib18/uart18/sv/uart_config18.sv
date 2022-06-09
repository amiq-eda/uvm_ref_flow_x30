/*-------------------------------------------------------------------------
File18 name   : uart_config18.sv
Title18       : configuration file
Project18     :
Created18     :
Description18 : This18 file contains18 configuration information for the UART18
              device18
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV18
`define UART_CONFIG_SV18

class uart_config18 extends uvm_object;
  //UART18 topology parameters18
  uvm_active_passive_enum  is_tx_active18 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active18 = UVM_PASSIVE;

  // UART18 device18 parameters18
  rand bit [7:0]    baud_rate_gen18;  // Baud18 Rate18 Generator18 Register
  rand bit [7:0]    baud_rate_div18;  // Baud18 Rate18 Divider18 Register

  // Line18 Control18 Register Fields
  rand bit [1:0]    char_length18; // Character18 length (ua_lcr18[1:0])
  rand bit          nbstop18;        // Number18 stop bits (ua_lcr18[2])
  rand bit          parity_en18 ;    // Parity18 Enable18    (ua_lcr18[3])
  rand bit [1:0]    parity_mode18;   // Parity18 Mode18      (ua_lcr18[5:4])

  int unsigned chrl18;  
  int unsigned stop_bt18;  

  // Control18 Register Fields
  rand bit          cts_en18 ;
  rand bit          rts_en18 ;

 // Calculated18 in post_randomize() so not randomized18
  byte unsigned char_len_val18;      // (8, 7 or 6)
  byte unsigned stop_bit_val18;      // (1, 1.5 or 2)

  // These18 default constraints can be overriden18
  // Constrain18 configuration based on UVC18/RTL18 capabilities18
//  constraint c_num_stop_bits18  { nbstop18      inside {[0:1]};}
  constraint c_bgen18          { baud_rate_gen18       == 1;}
  constraint c_brgr18          { baud_rate_div18       == 0;}
  constraint c_rts_en18         { rts_en18      == 0;}
  constraint c_cts_en18         { cts_en18      == 0;}

  // These18 declarations18 implement the create() and get_type_name()
  // as well18 as enable automation18 of the tx_frame18's fields   
  `uvm_object_utils_begin(uart_config18)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active18, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active18, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen18, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div18, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length18, UVM_DEFAULT)
    `uvm_field_int(nbstop18, UVM_DEFAULT )  
    `uvm_field_int(parity_en18, UVM_DEFAULT)
    `uvm_field_int(parity_mode18, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This18 requires for registration18 of the ptp_tx_frame18   
  function new(string name = "uart_config18");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl18();
    ConvToIntStpBt18();
  endfunction 

  // Function18 to convert the 2 bit Character18 length to integer
  function void ConvToIntChrl18();
    case(char_length18)
      2'b00 : char_len_val18 = 5;
      2'b01 : char_len_val18 = 6;
      2'b10 : char_len_val18 = 7;
      2'b11 : char_len_val18 = 8;
      default : char_len_val18 = 8;
    endcase
  endfunction : ConvToIntChrl18
    
  // Function18 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt18();
    case(nbstop18)
      2'b00 : stop_bit_val18 = 1;
      2'b01 : stop_bit_val18 = 2;
      default : stop_bit_val18 = 2;
    endcase
  endfunction : ConvToIntStpBt18
    
endclass
`endif  // UART_CONFIG_SV18
