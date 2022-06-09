/*-------------------------------------------------------------------------
File19 name   : uart_config19.sv
Title19       : configuration file
Project19     :
Created19     :
Description19 : This19 file contains19 configuration information for the UART19
              device19
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV19
`define UART_CONFIG_SV19

class uart_config19 extends uvm_object;
  //UART19 topology parameters19
  uvm_active_passive_enum  is_tx_active19 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active19 = UVM_PASSIVE;

  // UART19 device19 parameters19
  rand bit [7:0]    baud_rate_gen19;  // Baud19 Rate19 Generator19 Register
  rand bit [7:0]    baud_rate_div19;  // Baud19 Rate19 Divider19 Register

  // Line19 Control19 Register Fields
  rand bit [1:0]    char_length19; // Character19 length (ua_lcr19[1:0])
  rand bit          nbstop19;        // Number19 stop bits (ua_lcr19[2])
  rand bit          parity_en19 ;    // Parity19 Enable19    (ua_lcr19[3])
  rand bit [1:0]    parity_mode19;   // Parity19 Mode19      (ua_lcr19[5:4])

  int unsigned chrl19;  
  int unsigned stop_bt19;  

  // Control19 Register Fields
  rand bit          cts_en19 ;
  rand bit          rts_en19 ;

 // Calculated19 in post_randomize() so not randomized19
  byte unsigned char_len_val19;      // (8, 7 or 6)
  byte unsigned stop_bit_val19;      // (1, 1.5 or 2)

  // These19 default constraints can be overriden19
  // Constrain19 configuration based on UVC19/RTL19 capabilities19
//  constraint c_num_stop_bits19  { nbstop19      inside {[0:1]};}
  constraint c_bgen19          { baud_rate_gen19       == 1;}
  constraint c_brgr19          { baud_rate_div19       == 0;}
  constraint c_rts_en19         { rts_en19      == 0;}
  constraint c_cts_en19         { cts_en19      == 0;}

  // These19 declarations19 implement the create() and get_type_name()
  // as well19 as enable automation19 of the tx_frame19's fields   
  `uvm_object_utils_begin(uart_config19)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active19, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active19, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen19, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div19, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length19, UVM_DEFAULT)
    `uvm_field_int(nbstop19, UVM_DEFAULT )  
    `uvm_field_int(parity_en19, UVM_DEFAULT)
    `uvm_field_int(parity_mode19, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This19 requires for registration19 of the ptp_tx_frame19   
  function new(string name = "uart_config19");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl19();
    ConvToIntStpBt19();
  endfunction 

  // Function19 to convert the 2 bit Character19 length to integer
  function void ConvToIntChrl19();
    case(char_length19)
      2'b00 : char_len_val19 = 5;
      2'b01 : char_len_val19 = 6;
      2'b10 : char_len_val19 = 7;
      2'b11 : char_len_val19 = 8;
      default : char_len_val19 = 8;
    endcase
  endfunction : ConvToIntChrl19
    
  // Function19 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt19();
    case(nbstop19)
      2'b00 : stop_bit_val19 = 1;
      2'b01 : stop_bit_val19 = 2;
      default : stop_bit_val19 = 2;
    endcase
  endfunction : ConvToIntStpBt19
    
endclass
`endif  // UART_CONFIG_SV19
