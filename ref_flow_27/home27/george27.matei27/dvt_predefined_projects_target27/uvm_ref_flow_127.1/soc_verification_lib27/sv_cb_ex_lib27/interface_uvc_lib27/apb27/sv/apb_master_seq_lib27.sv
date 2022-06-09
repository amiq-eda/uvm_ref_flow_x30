/*******************************************************************************
  FILE : apb_master_seq_lib27.sv
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV27
`define APB_MASTER_SEQ_LIB_SV27

//------------------------------------------------------------------------------
// SEQUENCE27: read_byte_seq27
//------------------------------------------------------------------------------
class apb_master_base_seq27 extends uvm_sequence #(apb_transfer27);
  // NOTE27: KATHLEEN27 - ALSO27 NEED27 TO HANDLE27 KILL27 HERE27??

  function new(string name="apb_master_base_seq27");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq27)
  `uvm_declare_p_sequencer(apb_master_sequencer27)

// Use a base sequence to raise/drop27 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running27 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq27

//------------------------------------------------------------------------------
// SEQUENCE27: read_byte_seq27
//------------------------------------------------------------------------------
class read_byte_seq27 extends apb_master_base_seq27;
  rand bit [31:0] start_addr27;
  rand int unsigned transmit_del27;

  function new(string name="read_byte_seq27");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq27)

  constraint transmit_del_ct27 { (transmit_del27 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr27;
        req.direction27 == APB_READ27;
        req.transmit_delay27 == transmit_del27; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr27 = 'h%0h, req_data27 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr27 = 'h%0h, rsp_data27 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq27

// SEQUENCE27: write_byte_seq27
class write_byte_seq27 extends apb_master_base_seq27;
  rand bit [31:0] start_addr27;
  rand bit [7:0] write_data27;
  rand int unsigned transmit_del27;

  function new(string name="write_byte_seq27");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq27)

  constraint transmit_del_ct27 { (transmit_del27 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr27;
        req.direction27 == APB_WRITE27;
        req.data == write_data27;
        req.transmit_delay27 == transmit_del27; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq27

//------------------------------------------------------------------------------
// SEQUENCE27: read_word_seq27
//------------------------------------------------------------------------------
class read_word_seq27 extends apb_master_base_seq27;
  rand bit [31:0] start_addr27;
  rand int unsigned transmit_del27;

  function new(string name="read_word_seq27");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq27)

  constraint transmit_del_ct27 { (transmit_del27 <= 10); }
  constraint addr_ct27 {(start_addr27[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr27;
        req.direction27 == APB_READ27;
        req.transmit_delay27 == transmit_del27; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr27 = 'h%0h, req_data27 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr27 = 'h%0h, rsp_data27 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq27

// SEQUENCE27: write_word_seq27
class write_word_seq27 extends apb_master_base_seq27;
  rand bit [31:0] start_addr27;
  rand bit [31:0] write_data27;
  rand int unsigned transmit_del27;

  function new(string name="write_word_seq27");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq27)

  constraint transmit_del_ct27 { (transmit_del27 <= 10); }
  constraint addr_ct27 {(start_addr27[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr27;
        req.direction27 == APB_WRITE27;
        req.data == write_data27;
        req.transmit_delay27 == transmit_del27; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq27

// SEQUENCE27: read_after_write_seq27
class read_after_write_seq27 extends apb_master_base_seq27;

  rand bit [31:0] start_addr27;
  rand bit [31:0] write_data27;
  rand int unsigned transmit_del27;

  function new(string name="read_after_write_seq27");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq27)

  constraint transmit_del_ct27 { (transmit_del27 <= 10); }
  constraint addr_ct27 {(start_addr27[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr27;
        req.direction27 == APB_WRITE27;
        req.data == write_data27;
        req.transmit_delay27 == transmit_del27; } )
    `uvm_do_with(req, 
      { req.addr == start_addr27;
        req.direction27 == APB_READ27;
        req.transmit_delay27 == transmit_del27; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq27

// SEQUENCE27: multiple_read_after_write_seq27
class multiple_read_after_write_seq27 extends apb_master_base_seq27;

    read_after_write_seq27 raw_seq27;
    write_byte_seq27 w_seq27;
    read_byte_seq27 r_seq27;
    rand int unsigned num_of_seq27;

    function new(string name="multiple_read_after_write_seq27");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq27)

    constraint num_of_seq_c27 { num_of_seq27 <= 10; num_of_seq27 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq27; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq27)
      end
      repeat (3) `uvm_do_with(w_seq27, {transmit_del27 == 1;} )
      repeat (3) `uvm_do_with(r_seq27, {transmit_del27 == 1;} )
    endtask
endclass : multiple_read_after_write_seq27
`endif // APB_MASTER_SEQ_LIB_SV27
