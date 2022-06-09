/*******************************************************************************
  FILE : apb_master_seq_lib17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV17
`define APB_MASTER_SEQ_LIB_SV17

//------------------------------------------------------------------------------
// SEQUENCE17: read_byte_seq17
//------------------------------------------------------------------------------
class apb_master_base_seq17 extends uvm_sequence #(apb_transfer17);
  // NOTE17: KATHLEEN17 - ALSO17 NEED17 TO HANDLE17 KILL17 HERE17??

  function new(string name="apb_master_base_seq17");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq17)
  `uvm_declare_p_sequencer(apb_master_sequencer17)

// Use a base sequence to raise/drop17 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running17 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq17

//------------------------------------------------------------------------------
// SEQUENCE17: read_byte_seq17
//------------------------------------------------------------------------------
class read_byte_seq17 extends apb_master_base_seq17;
  rand bit [31:0] start_addr17;
  rand int unsigned transmit_del17;

  function new(string name="read_byte_seq17");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq17)

  constraint transmit_del_ct17 { (transmit_del17 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr17;
        req.direction17 == APB_READ17;
        req.transmit_delay17 == transmit_del17; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr17 = 'h%0h, req_data17 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr17 = 'h%0h, rsp_data17 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq17

// SEQUENCE17: write_byte_seq17
class write_byte_seq17 extends apb_master_base_seq17;
  rand bit [31:0] start_addr17;
  rand bit [7:0] write_data17;
  rand int unsigned transmit_del17;

  function new(string name="write_byte_seq17");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq17)

  constraint transmit_del_ct17 { (transmit_del17 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr17;
        req.direction17 == APB_WRITE17;
        req.data == write_data17;
        req.transmit_delay17 == transmit_del17; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq17

//------------------------------------------------------------------------------
// SEQUENCE17: read_word_seq17
//------------------------------------------------------------------------------
class read_word_seq17 extends apb_master_base_seq17;
  rand bit [31:0] start_addr17;
  rand int unsigned transmit_del17;

  function new(string name="read_word_seq17");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq17)

  constraint transmit_del_ct17 { (transmit_del17 <= 10); }
  constraint addr_ct17 {(start_addr17[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr17;
        req.direction17 == APB_READ17;
        req.transmit_delay17 == transmit_del17; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr17 = 'h%0h, req_data17 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr17 = 'h%0h, rsp_data17 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq17

// SEQUENCE17: write_word_seq17
class write_word_seq17 extends apb_master_base_seq17;
  rand bit [31:0] start_addr17;
  rand bit [31:0] write_data17;
  rand int unsigned transmit_del17;

  function new(string name="write_word_seq17");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq17)

  constraint transmit_del_ct17 { (transmit_del17 <= 10); }
  constraint addr_ct17 {(start_addr17[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr17;
        req.direction17 == APB_WRITE17;
        req.data == write_data17;
        req.transmit_delay17 == transmit_del17; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq17

// SEQUENCE17: read_after_write_seq17
class read_after_write_seq17 extends apb_master_base_seq17;

  rand bit [31:0] start_addr17;
  rand bit [31:0] write_data17;
  rand int unsigned transmit_del17;

  function new(string name="read_after_write_seq17");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq17)

  constraint transmit_del_ct17 { (transmit_del17 <= 10); }
  constraint addr_ct17 {(start_addr17[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr17;
        req.direction17 == APB_WRITE17;
        req.data == write_data17;
        req.transmit_delay17 == transmit_del17; } )
    `uvm_do_with(req, 
      { req.addr == start_addr17;
        req.direction17 == APB_READ17;
        req.transmit_delay17 == transmit_del17; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq17

// SEQUENCE17: multiple_read_after_write_seq17
class multiple_read_after_write_seq17 extends apb_master_base_seq17;

    read_after_write_seq17 raw_seq17;
    write_byte_seq17 w_seq17;
    read_byte_seq17 r_seq17;
    rand int unsigned num_of_seq17;

    function new(string name="multiple_read_after_write_seq17");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq17)

    constraint num_of_seq_c17 { num_of_seq17 <= 10; num_of_seq17 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq17; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq17)
      end
      repeat (3) `uvm_do_with(w_seq17, {transmit_del17 == 1;} )
      repeat (3) `uvm_do_with(r_seq17, {transmit_del17 == 1;} )
    endtask
endclass : multiple_read_after_write_seq17
`endif // APB_MASTER_SEQ_LIB_SV17
