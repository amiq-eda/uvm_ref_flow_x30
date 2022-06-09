/*-------------------------------------------------------------------------
File1 name   : uart_config1.sv
Title1       : configuration file
Project1     :
Created1     :
Description1 : This1 file contains1 configuration information for the UART1
              device1
Notes1       :  
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV1
`define UART_CONFIG_SV1

class uart_config1 extends uvm_object;
  //UART1 topology parameters1
  uvm_active_passive_enum  is_tx_active1 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active1 = UVM_PASSIVE;

  // UART1 device1 parameters1
  rand bit [7:0]    baud_rate_gen1;  // Baud1 Rate1 Generator1 Register
  rand bit [7:0]    baud_rate_div1;  // Baud1 Rate1 Divider1 Register

  // Line1 Control1 Register Fields
  rand bit [1:0]    char_length1; // Character1 length (ua_lcr1[1:0])
  rand bit          nbstop1;        // Number1 stop bits (ua_lcr1[2])
  rand bit          parity_en1 ;    // Parity1 Enable1    (ua_lcr1[3])
  rand bit [1:0]    parity_mode1;   // Parity1 Mode1      (ua_lcr1[5:4])

  int unsigned chrl1;  
  int unsigned stop_bt1;  

  // Control1 Register Fields
  rand bit          cts_en1 ;
  rand bit          rts_en1 ;

 // Calculated1 in post_randomize() so not randomized1
  byte unsigned char_len_val1;      // (8, 7 or 6)
  byte unsigned stop_bit_val1;      // (1, 1.5 or 2)

  // These1 default constraints can be overriden1
  // Constrain1 configuration based on UVC1/RTL1 capabilities1
//  constraint c_num_stop_bits1  { nbstop1      inside {[0:1]};}
  constraint c_bgen1          { baud_rate_gen1       == 1;}
  constraint c_brgr1          { baud_rate_div1       == 0;}
  constraint c_rts_en1         { rts_en1      == 0;}
  constraint c_cts_en1         { cts_en1      == 0;}

  // These1 declarations1 implement the create() and get_type_name()
  // as well1 as enable automation1 of the tx_frame1's fields   
  `uvm_object_utils_begin(uart_config1)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active1, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active1, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen1, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div1, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length1, UVM_DEFAULT)
    `uvm_field_int(nbstop1, UVM_DEFAULT )  
    `uvm_field_int(parity_en1, UVM_DEFAULT)
    `uvm_field_int(parity_mode1, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This1 requires for registration1 of the ptp_tx_frame1   
  function new(string name = "uart_config1");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl1();
    ConvToIntStpBt1();
  endfunction 

  // Function1 to convert the 2 bit Character1 length to integer
  function void ConvToIntChrl1();
    case(char_length1)
      2'b00 : char_len_val1 = 5;
      2'b01 : char_len_val1 = 6;
      2'b10 : char_len_val1 = 7;
      2'b11 : char_len_val1 = 8;
      default : char_len_val1 = 8;
    endcase
  endfunction : ConvToIntChrl1
    
  // Function1 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt1();
    case(nbstop1)
      2'b00 : stop_bit_val1 = 1;
      2'b01 : stop_bit_val1 = 2;
      default : stop_bit_val1 = 2;
    endcase
  endfunction : ConvToIntStpBt1
    
endclass
`endif  // UART_CONFIG_SV1
