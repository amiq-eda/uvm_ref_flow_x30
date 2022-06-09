/*******************************************************************************
  FILE : apb_master_seq_lib8.sv
*******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV8
`define APB_MASTER_SEQ_LIB_SV8

//------------------------------------------------------------------------------
// SEQUENCE8: read_byte_seq8
//------------------------------------------------------------------------------
class apb_master_base_seq8 extends uvm_sequence #(apb_transfer8);
  // NOTE8: KATHLEEN8 - ALSO8 NEED8 TO HANDLE8 KILL8 HERE8??

  function new(string name="apb_master_base_seq8");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq8)
  `uvm_declare_p_sequencer(apb_master_sequencer8)

// Use a base sequence to raise/drop8 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running8 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq8

//------------------------------------------------------------------------------
// SEQUENCE8: read_byte_seq8
//------------------------------------------------------------------------------
class read_byte_seq8 extends apb_master_base_seq8;
  rand bit [31:0] start_addr8;
  rand int unsigned transmit_del8;

  function new(string name="read_byte_seq8");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq8)

  constraint transmit_del_ct8 { (transmit_del8 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr8;
        req.direction8 == APB_READ8;
        req.transmit_delay8 == transmit_del8; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr8 = 'h%0h, req_data8 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr8 = 'h%0h, rsp_data8 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq8

// SEQUENCE8: write_byte_seq8
class write_byte_seq8 extends apb_master_base_seq8;
  rand bit [31:0] start_addr8;
  rand bit [7:0] write_data8;
  rand int unsigned transmit_del8;

  function new(string name="write_byte_seq8");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq8)

  constraint transmit_del_ct8 { (transmit_del8 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr8;
        req.direction8 == APB_WRITE8;
        req.data == write_data8;
        req.transmit_delay8 == transmit_del8; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq8

//------------------------------------------------------------------------------
// SEQUENCE8: read_word_seq8
//------------------------------------------------------------------------------
class read_word_seq8 extends apb_master_base_seq8;
  rand bit [31:0] start_addr8;
  rand int unsigned transmit_del8;

  function new(string name="read_word_seq8");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq8)

  constraint transmit_del_ct8 { (transmit_del8 <= 10); }
  constraint addr_ct8 {(start_addr8[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr8;
        req.direction8 == APB_READ8;
        req.transmit_delay8 == transmit_del8; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr8 = 'h%0h, req_data8 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr8 = 'h%0h, rsp_data8 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq8

// SEQUENCE8: write_word_seq8
class write_word_seq8 extends apb_master_base_seq8;
  rand bit [31:0] start_addr8;
  rand bit [31:0] write_data8;
  rand int unsigned transmit_del8;

  function new(string name="write_word_seq8");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq8)

  constraint transmit_del_ct8 { (transmit_del8 <= 10); }
  constraint addr_ct8 {(start_addr8[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr8;
        req.direction8 == APB_WRITE8;
        req.data == write_data8;
        req.transmit_delay8 == transmit_del8; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq8

// SEQUENCE8: read_after_write_seq8
class read_after_write_seq8 extends apb_master_base_seq8;

  rand bit [31:0] start_addr8;
  rand bit [31:0] write_data8;
  rand int unsigned transmit_del8;

  function new(string name="read_after_write_seq8");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq8)

  constraint transmit_del_ct8 { (transmit_del8 <= 10); }
  constraint addr_ct8 {(start_addr8[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr8;
        req.direction8 == APB_WRITE8;
        req.data == write_data8;
        req.transmit_delay8 == transmit_del8; } )
    `uvm_do_with(req, 
      { req.addr == start_addr8;
        req.direction8 == APB_READ8;
        req.transmit_delay8 == transmit_del8; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq8

// SEQUENCE8: multiple_read_after_write_seq8
class multiple_read_after_write_seq8 extends apb_master_base_seq8;

    read_after_write_seq8 raw_seq8;
    write_byte_seq8 w_seq8;
    read_byte_seq8 r_seq8;
    rand int unsigned num_of_seq8;

    function new(string name="multiple_read_after_write_seq8");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq8)

    constraint num_of_seq_c8 { num_of_seq8 <= 10; num_of_seq8 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq8; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq8)
      end
      repeat (3) `uvm_do_with(w_seq8, {transmit_del8 == 1;} )
      repeat (3) `uvm_do_with(r_seq8, {transmit_del8 == 1;} )
    endtask
endclass : multiple_read_after_write_seq8
`endif // APB_MASTER_SEQ_LIB_SV8
