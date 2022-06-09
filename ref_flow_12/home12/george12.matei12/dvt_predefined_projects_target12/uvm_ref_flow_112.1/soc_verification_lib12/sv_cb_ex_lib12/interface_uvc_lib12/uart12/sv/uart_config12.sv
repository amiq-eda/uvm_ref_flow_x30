/*-------------------------------------------------------------------------
File12 name   : uart_config12.sv
Title12       : configuration file
Project12     :
Created12     :
Description12 : This12 file contains12 configuration information for the UART12
              device12
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV12
`define UART_CONFIG_SV12

class uart_config12 extends uvm_object;
  //UART12 topology parameters12
  uvm_active_passive_enum  is_tx_active12 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active12 = UVM_PASSIVE;

  // UART12 device12 parameters12
  rand bit [7:0]    baud_rate_gen12;  // Baud12 Rate12 Generator12 Register
  rand bit [7:0]    baud_rate_div12;  // Baud12 Rate12 Divider12 Register

  // Line12 Control12 Register Fields
  rand bit [1:0]    char_length12; // Character12 length (ua_lcr12[1:0])
  rand bit          nbstop12;        // Number12 stop bits (ua_lcr12[2])
  rand bit          parity_en12 ;    // Parity12 Enable12    (ua_lcr12[3])
  rand bit [1:0]    parity_mode12;   // Parity12 Mode12      (ua_lcr12[5:4])

  int unsigned chrl12;  
  int unsigned stop_bt12;  

  // Control12 Register Fields
  rand bit          cts_en12 ;
  rand bit          rts_en12 ;

 // Calculated12 in post_randomize() so not randomized12
  byte unsigned char_len_val12;      // (8, 7 or 6)
  byte unsigned stop_bit_val12;      // (1, 1.5 or 2)

  // These12 default constraints can be overriden12
  // Constrain12 configuration based on UVC12/RTL12 capabilities12
//  constraint c_num_stop_bits12  { nbstop12      inside {[0:1]};}
  constraint c_bgen12          { baud_rate_gen12       == 1;}
  constraint c_brgr12          { baud_rate_div12       == 0;}
  constraint c_rts_en12         { rts_en12      == 0;}
  constraint c_cts_en12         { cts_en12      == 0;}

  // These12 declarations12 implement the create() and get_type_name()
  // as well12 as enable automation12 of the tx_frame12's fields   
  `uvm_object_utils_begin(uart_config12)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active12, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active12, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen12, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div12, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length12, UVM_DEFAULT)
    `uvm_field_int(nbstop12, UVM_DEFAULT )  
    `uvm_field_int(parity_en12, UVM_DEFAULT)
    `uvm_field_int(parity_mode12, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This12 requires for registration12 of the ptp_tx_frame12   
  function new(string name = "uart_config12");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl12();
    ConvToIntStpBt12();
  endfunction 

  // Function12 to convert the 2 bit Character12 length to integer
  function void ConvToIntChrl12();
    case(char_length12)
      2'b00 : char_len_val12 = 5;
      2'b01 : char_len_val12 = 6;
      2'b10 : char_len_val12 = 7;
      2'b11 : char_len_val12 = 8;
      default : char_len_val12 = 8;
    endcase
  endfunction : ConvToIntChrl12
    
  // Function12 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt12();
    case(nbstop12)
      2'b00 : stop_bit_val12 = 1;
      2'b01 : stop_bit_val12 = 2;
      default : stop_bit_val12 = 2;
    endcase
  endfunction : ConvToIntStpBt12
    
endclass
`endif  // UART_CONFIG_SV12
