/*******************************************************************************
  FILE : apb_master_seq_lib23.sv
*******************************************************************************/
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


`ifndef APB_MASTER_SEQ_LIB_SV23
`define APB_MASTER_SEQ_LIB_SV23

//------------------------------------------------------------------------------
// SEQUENCE23: read_byte_seq23
//------------------------------------------------------------------------------
class apb_master_base_seq23 extends uvm_sequence #(apb_transfer23);
  // NOTE23: KATHLEEN23 - ALSO23 NEED23 TO HANDLE23 KILL23 HERE23??

  function new(string name="apb_master_base_seq23");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq23)
  `uvm_declare_p_sequencer(apb_master_sequencer23)

// Use a base sequence to raise/drop23 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running23 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq23

//------------------------------------------------------------------------------
// SEQUENCE23: read_byte_seq23
//------------------------------------------------------------------------------
class read_byte_seq23 extends apb_master_base_seq23;
  rand bit [31:0] start_addr23;
  rand int unsigned transmit_del23;

  function new(string name="read_byte_seq23");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq23)

  constraint transmit_del_ct23 { (transmit_del23 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr23;
        req.direction23 == APB_READ23;
        req.transmit_delay23 == transmit_del23; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr23 = 'h%0h, req_data23 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr23 = 'h%0h, rsp_data23 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq23

// SEQUENCE23: write_byte_seq23
class write_byte_seq23 extends apb_master_base_seq23;
  rand bit [31:0] start_addr23;
  rand bit [7:0] write_data23;
  rand int unsigned transmit_del23;

  function new(string name="write_byte_seq23");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq23)

  constraint transmit_del_ct23 { (transmit_del23 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr23;
        req.direction23 == APB_WRITE23;
        req.data == write_data23;
        req.transmit_delay23 == transmit_del23; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq23

//------------------------------------------------------------------------------
// SEQUENCE23: read_word_seq23
//------------------------------------------------------------------------------
class read_word_seq23 extends apb_master_base_seq23;
  rand bit [31:0] start_addr23;
  rand int unsigned transmit_del23;

  function new(string name="read_word_seq23");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq23)

  constraint transmit_del_ct23 { (transmit_del23 <= 10); }
  constraint addr_ct23 {(start_addr23[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr23;
        req.direction23 == APB_READ23;
        req.transmit_delay23 == transmit_del23; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr23 = 'h%0h, req_data23 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr23 = 'h%0h, rsp_data23 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq23

// SEQUENCE23: write_word_seq23
class write_word_seq23 extends apb_master_base_seq23;
  rand bit [31:0] start_addr23;
  rand bit [31:0] write_data23;
  rand int unsigned transmit_del23;

  function new(string name="write_word_seq23");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq23)

  constraint transmit_del_ct23 { (transmit_del23 <= 10); }
  constraint addr_ct23 {(start_addr23[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr23;
        req.direction23 == APB_WRITE23;
        req.data == write_data23;
        req.transmit_delay23 == transmit_del23; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq23

// SEQUENCE23: read_after_write_seq23
class read_after_write_seq23 extends apb_master_base_seq23;

  rand bit [31:0] start_addr23;
  rand bit [31:0] write_data23;
  rand int unsigned transmit_del23;

  function new(string name="read_after_write_seq23");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq23)

  constraint transmit_del_ct23 { (transmit_del23 <= 10); }
  constraint addr_ct23 {(start_addr23[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr23;
        req.direction23 == APB_WRITE23;
        req.data == write_data23;
        req.transmit_delay23 == transmit_del23; } )
    `uvm_do_with(req, 
      { req.addr == start_addr23;
        req.direction23 == APB_READ23;
        req.transmit_delay23 == transmit_del23; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq23

// SEQUENCE23: multiple_read_after_write_seq23
class multiple_read_after_write_seq23 extends apb_master_base_seq23;

    read_after_write_seq23 raw_seq23;
    write_byte_seq23 w_seq23;
    read_byte_seq23 r_seq23;
    rand int unsigned num_of_seq23;

    function new(string name="multiple_read_after_write_seq23");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq23)

    constraint num_of_seq_c23 { num_of_seq23 <= 10; num_of_seq23 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq23; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq23)
      end
      repeat (3) `uvm_do_with(w_seq23, {transmit_del23 == 1;} )
      repeat (3) `uvm_do_with(r_seq23, {transmit_del23 == 1;} )
    endtask
endclass : multiple_read_after_write_seq23
`endif // APB_MASTER_SEQ_LIB_SV23
