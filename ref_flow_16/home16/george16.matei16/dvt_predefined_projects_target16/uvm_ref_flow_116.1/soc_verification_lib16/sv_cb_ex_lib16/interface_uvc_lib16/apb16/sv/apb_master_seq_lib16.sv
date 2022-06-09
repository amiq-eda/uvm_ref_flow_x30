/*******************************************************************************
  FILE : apb_master_seq_lib16.sv
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV16
`define APB_MASTER_SEQ_LIB_SV16

//------------------------------------------------------------------------------
// SEQUENCE16: read_byte_seq16
//------------------------------------------------------------------------------
class apb_master_base_seq16 extends uvm_sequence #(apb_transfer16);
  // NOTE16: KATHLEEN16 - ALSO16 NEED16 TO HANDLE16 KILL16 HERE16??

  function new(string name="apb_master_base_seq16");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq16)
  `uvm_declare_p_sequencer(apb_master_sequencer16)

// Use a base sequence to raise/drop16 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running16 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq16

//------------------------------------------------------------------------------
// SEQUENCE16: read_byte_seq16
//------------------------------------------------------------------------------
class read_byte_seq16 extends apb_master_base_seq16;
  rand bit [31:0] start_addr16;
  rand int unsigned transmit_del16;

  function new(string name="read_byte_seq16");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq16)

  constraint transmit_del_ct16 { (transmit_del16 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr16;
        req.direction16 == APB_READ16;
        req.transmit_delay16 == transmit_del16; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr16 = 'h%0h, req_data16 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr16 = 'h%0h, rsp_data16 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq16

// SEQUENCE16: write_byte_seq16
class write_byte_seq16 extends apb_master_base_seq16;
  rand bit [31:0] start_addr16;
  rand bit [7:0] write_data16;
  rand int unsigned transmit_del16;

  function new(string name="write_byte_seq16");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq16)

  constraint transmit_del_ct16 { (transmit_del16 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr16;
        req.direction16 == APB_WRITE16;
        req.data == write_data16;
        req.transmit_delay16 == transmit_del16; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq16

//------------------------------------------------------------------------------
// SEQUENCE16: read_word_seq16
//------------------------------------------------------------------------------
class read_word_seq16 extends apb_master_base_seq16;
  rand bit [31:0] start_addr16;
  rand int unsigned transmit_del16;

  function new(string name="read_word_seq16");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq16)

  constraint transmit_del_ct16 { (transmit_del16 <= 10); }
  constraint addr_ct16 {(start_addr16[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr16;
        req.direction16 == APB_READ16;
        req.transmit_delay16 == transmit_del16; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr16 = 'h%0h, req_data16 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr16 = 'h%0h, rsp_data16 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq16

// SEQUENCE16: write_word_seq16
class write_word_seq16 extends apb_master_base_seq16;
  rand bit [31:0] start_addr16;
  rand bit [31:0] write_data16;
  rand int unsigned transmit_del16;

  function new(string name="write_word_seq16");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq16)

  constraint transmit_del_ct16 { (transmit_del16 <= 10); }
  constraint addr_ct16 {(start_addr16[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr16;
        req.direction16 == APB_WRITE16;
        req.data == write_data16;
        req.transmit_delay16 == transmit_del16; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq16

// SEQUENCE16: read_after_write_seq16
class read_after_write_seq16 extends apb_master_base_seq16;

  rand bit [31:0] start_addr16;
  rand bit [31:0] write_data16;
  rand int unsigned transmit_del16;

  function new(string name="read_after_write_seq16");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq16)

  constraint transmit_del_ct16 { (transmit_del16 <= 10); }
  constraint addr_ct16 {(start_addr16[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr16;
        req.direction16 == APB_WRITE16;
        req.data == write_data16;
        req.transmit_delay16 == transmit_del16; } )
    `uvm_do_with(req, 
      { req.addr == start_addr16;
        req.direction16 == APB_READ16;
        req.transmit_delay16 == transmit_del16; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq16

// SEQUENCE16: multiple_read_after_write_seq16
class multiple_read_after_write_seq16 extends apb_master_base_seq16;

    read_after_write_seq16 raw_seq16;
    write_byte_seq16 w_seq16;
    read_byte_seq16 r_seq16;
    rand int unsigned num_of_seq16;

    function new(string name="multiple_read_after_write_seq16");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq16)

    constraint num_of_seq_c16 { num_of_seq16 <= 10; num_of_seq16 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq16; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq16)
      end
      repeat (3) `uvm_do_with(w_seq16, {transmit_del16 == 1;} )
      repeat (3) `uvm_do_with(r_seq16, {transmit_del16 == 1;} )
    endtask
endclass : multiple_read_after_write_seq16
`endif // APB_MASTER_SEQ_LIB_SV16
