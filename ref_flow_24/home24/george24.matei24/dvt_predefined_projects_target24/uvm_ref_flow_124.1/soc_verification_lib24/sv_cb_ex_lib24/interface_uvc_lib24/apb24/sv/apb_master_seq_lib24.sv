/*******************************************************************************
  FILE : apb_master_seq_lib24.sv
*******************************************************************************/
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


`ifndef APB_MASTER_SEQ_LIB_SV24
`define APB_MASTER_SEQ_LIB_SV24

//------------------------------------------------------------------------------
// SEQUENCE24: read_byte_seq24
//------------------------------------------------------------------------------
class apb_master_base_seq24 extends uvm_sequence #(apb_transfer24);
  // NOTE24: KATHLEEN24 - ALSO24 NEED24 TO HANDLE24 KILL24 HERE24??

  function new(string name="apb_master_base_seq24");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq24)
  `uvm_declare_p_sequencer(apb_master_sequencer24)

// Use a base sequence to raise/drop24 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running24 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq24

//------------------------------------------------------------------------------
// SEQUENCE24: read_byte_seq24
//------------------------------------------------------------------------------
class read_byte_seq24 extends apb_master_base_seq24;
  rand bit [31:0] start_addr24;
  rand int unsigned transmit_del24;

  function new(string name="read_byte_seq24");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq24)

  constraint transmit_del_ct24 { (transmit_del24 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr24;
        req.direction24 == APB_READ24;
        req.transmit_delay24 == transmit_del24; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr24 = 'h%0h, req_data24 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr24 = 'h%0h, rsp_data24 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq24

// SEQUENCE24: write_byte_seq24
class write_byte_seq24 extends apb_master_base_seq24;
  rand bit [31:0] start_addr24;
  rand bit [7:0] write_data24;
  rand int unsigned transmit_del24;

  function new(string name="write_byte_seq24");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq24)

  constraint transmit_del_ct24 { (transmit_del24 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr24;
        req.direction24 == APB_WRITE24;
        req.data == write_data24;
        req.transmit_delay24 == transmit_del24; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq24

//------------------------------------------------------------------------------
// SEQUENCE24: read_word_seq24
//------------------------------------------------------------------------------
class read_word_seq24 extends apb_master_base_seq24;
  rand bit [31:0] start_addr24;
  rand int unsigned transmit_del24;

  function new(string name="read_word_seq24");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq24)

  constraint transmit_del_ct24 { (transmit_del24 <= 10); }
  constraint addr_ct24 {(start_addr24[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr24;
        req.direction24 == APB_READ24;
        req.transmit_delay24 == transmit_del24; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr24 = 'h%0h, req_data24 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr24 = 'h%0h, rsp_data24 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq24

// SEQUENCE24: write_word_seq24
class write_word_seq24 extends apb_master_base_seq24;
  rand bit [31:0] start_addr24;
  rand bit [31:0] write_data24;
  rand int unsigned transmit_del24;

  function new(string name="write_word_seq24");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq24)

  constraint transmit_del_ct24 { (transmit_del24 <= 10); }
  constraint addr_ct24 {(start_addr24[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr24;
        req.direction24 == APB_WRITE24;
        req.data == write_data24;
        req.transmit_delay24 == transmit_del24; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq24

// SEQUENCE24: read_after_write_seq24
class read_after_write_seq24 extends apb_master_base_seq24;

  rand bit [31:0] start_addr24;
  rand bit [31:0] write_data24;
  rand int unsigned transmit_del24;

  function new(string name="read_after_write_seq24");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq24)

  constraint transmit_del_ct24 { (transmit_del24 <= 10); }
  constraint addr_ct24 {(start_addr24[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr24;
        req.direction24 == APB_WRITE24;
        req.data == write_data24;
        req.transmit_delay24 == transmit_del24; } )
    `uvm_do_with(req, 
      { req.addr == start_addr24;
        req.direction24 == APB_READ24;
        req.transmit_delay24 == transmit_del24; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq24

// SEQUENCE24: multiple_read_after_write_seq24
class multiple_read_after_write_seq24 extends apb_master_base_seq24;

    read_after_write_seq24 raw_seq24;
    write_byte_seq24 w_seq24;
    read_byte_seq24 r_seq24;
    rand int unsigned num_of_seq24;

    function new(string name="multiple_read_after_write_seq24");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq24)

    constraint num_of_seq_c24 { num_of_seq24 <= 10; num_of_seq24 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq24; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq24)
      end
      repeat (3) `uvm_do_with(w_seq24, {transmit_del24 == 1;} )
      repeat (3) `uvm_do_with(r_seq24, {transmit_del24 == 1;} )
    endtask
endclass : multiple_read_after_write_seq24
`endif // APB_MASTER_SEQ_LIB_SV24
