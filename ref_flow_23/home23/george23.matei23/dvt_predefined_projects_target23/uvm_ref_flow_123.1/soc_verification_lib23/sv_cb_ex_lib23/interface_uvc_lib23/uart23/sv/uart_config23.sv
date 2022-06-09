/*-------------------------------------------------------------------------
File23 name   : uart_config23.sv
Title23       : configuration file
Project23     :
Created23     :
Description23 : This23 file contains23 configuration information for the UART23
              device23
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV23
`define UART_CONFIG_SV23

class uart_config23 extends uvm_object;
  //UART23 topology parameters23
  uvm_active_passive_enum  is_tx_active23 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active23 = UVM_PASSIVE;

  // UART23 device23 parameters23
  rand bit [7:0]    baud_rate_gen23;  // Baud23 Rate23 Generator23 Register
  rand bit [7:0]    baud_rate_div23;  // Baud23 Rate23 Divider23 Register

  // Line23 Control23 Register Fields
  rand bit [1:0]    char_length23; // Character23 length (ua_lcr23[1:0])
  rand bit          nbstop23;        // Number23 stop bits (ua_lcr23[2])
  rand bit          parity_en23 ;    // Parity23 Enable23    (ua_lcr23[3])
  rand bit [1:0]    parity_mode23;   // Parity23 Mode23      (ua_lcr23[5:4])

  int unsigned chrl23;  
  int unsigned stop_bt23;  

  // Control23 Register Fields
  rand bit          cts_en23 ;
  rand bit          rts_en23 ;

 // Calculated23 in post_randomize() so not randomized23
  byte unsigned char_len_val23;      // (8, 7 or 6)
  byte unsigned stop_bit_val23;      // (1, 1.5 or 2)

  // These23 default constraints can be overriden23
  // Constrain23 configuration based on UVC23/RTL23 capabilities23
//  constraint c_num_stop_bits23  { nbstop23      inside {[0:1]};}
  constraint c_bgen23          { baud_rate_gen23       == 1;}
  constraint c_brgr23          { baud_rate_div23       == 0;}
  constraint c_rts_en23         { rts_en23      == 0;}
  constraint c_cts_en23         { cts_en23      == 0;}

  // These23 declarations23 implement the create() and get_type_name()
  // as well23 as enable automation23 of the tx_frame23's fields   
  `uvm_object_utils_begin(uart_config23)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active23, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active23, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen23, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div23, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length23, UVM_DEFAULT)
    `uvm_field_int(nbstop23, UVM_DEFAULT )  
    `uvm_field_int(parity_en23, UVM_DEFAULT)
    `uvm_field_int(parity_mode23, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This23 requires for registration23 of the ptp_tx_frame23   
  function new(string name = "uart_config23");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl23();
    ConvToIntStpBt23();
  endfunction 

  // Function23 to convert the 2 bit Character23 length to integer
  function void ConvToIntChrl23();
    case(char_length23)
      2'b00 : char_len_val23 = 5;
      2'b01 : char_len_val23 = 6;
      2'b10 : char_len_val23 = 7;
      2'b11 : char_len_val23 = 8;
      default : char_len_val23 = 8;
    endcase
  endfunction : ConvToIntChrl23
    
  // Function23 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt23();
    case(nbstop23)
      2'b00 : stop_bit_val23 = 1;
      2'b01 : stop_bit_val23 = 2;
      default : stop_bit_val23 = 2;
    endcase
  endfunction : ConvToIntStpBt23
    
endclass
`endif  // UART_CONFIG_SV23
