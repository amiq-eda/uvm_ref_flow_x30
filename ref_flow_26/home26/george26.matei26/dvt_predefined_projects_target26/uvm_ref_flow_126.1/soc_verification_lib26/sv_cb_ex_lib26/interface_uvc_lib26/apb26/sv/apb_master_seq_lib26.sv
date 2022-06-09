/*******************************************************************************
  FILE : apb_master_seq_lib26.sv
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV26
`define APB_MASTER_SEQ_LIB_SV26

//------------------------------------------------------------------------------
// SEQUENCE26: read_byte_seq26
//------------------------------------------------------------------------------
class apb_master_base_seq26 extends uvm_sequence #(apb_transfer26);
  // NOTE26: KATHLEEN26 - ALSO26 NEED26 TO HANDLE26 KILL26 HERE26??

  function new(string name="apb_master_base_seq26");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq26)
  `uvm_declare_p_sequencer(apb_master_sequencer26)

// Use a base sequence to raise/drop26 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running26 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq26

//------------------------------------------------------------------------------
// SEQUENCE26: read_byte_seq26
//------------------------------------------------------------------------------
class read_byte_seq26 extends apb_master_base_seq26;
  rand bit [31:0] start_addr26;
  rand int unsigned transmit_del26;

  function new(string name="read_byte_seq26");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq26)

  constraint transmit_del_ct26 { (transmit_del26 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr26;
        req.direction26 == APB_READ26;
        req.transmit_delay26 == transmit_del26; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr26 = 'h%0h, req_data26 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr26 = 'h%0h, rsp_data26 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq26

// SEQUENCE26: write_byte_seq26
class write_byte_seq26 extends apb_master_base_seq26;
  rand bit [31:0] start_addr26;
  rand bit [7:0] write_data26;
  rand int unsigned transmit_del26;

  function new(string name="write_byte_seq26");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq26)

  constraint transmit_del_ct26 { (transmit_del26 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr26;
        req.direction26 == APB_WRITE26;
        req.data == write_data26;
        req.transmit_delay26 == transmit_del26; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq26

//------------------------------------------------------------------------------
// SEQUENCE26: read_word_seq26
//------------------------------------------------------------------------------
class read_word_seq26 extends apb_master_base_seq26;
  rand bit [31:0] start_addr26;
  rand int unsigned transmit_del26;

  function new(string name="read_word_seq26");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq26)

  constraint transmit_del_ct26 { (transmit_del26 <= 10); }
  constraint addr_ct26 {(start_addr26[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr26;
        req.direction26 == APB_READ26;
        req.transmit_delay26 == transmit_del26; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr26 = 'h%0h, req_data26 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr26 = 'h%0h, rsp_data26 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq26

// SEQUENCE26: write_word_seq26
class write_word_seq26 extends apb_master_base_seq26;
  rand bit [31:0] start_addr26;
  rand bit [31:0] write_data26;
  rand int unsigned transmit_del26;

  function new(string name="write_word_seq26");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq26)

  constraint transmit_del_ct26 { (transmit_del26 <= 10); }
  constraint addr_ct26 {(start_addr26[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr26;
        req.direction26 == APB_WRITE26;
        req.data == write_data26;
        req.transmit_delay26 == transmit_del26; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq26

// SEQUENCE26: read_after_write_seq26
class read_after_write_seq26 extends apb_master_base_seq26;

  rand bit [31:0] start_addr26;
  rand bit [31:0] write_data26;
  rand int unsigned transmit_del26;

  function new(string name="read_after_write_seq26");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq26)

  constraint transmit_del_ct26 { (transmit_del26 <= 10); }
  constraint addr_ct26 {(start_addr26[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr26;
        req.direction26 == APB_WRITE26;
        req.data == write_data26;
        req.transmit_delay26 == transmit_del26; } )
    `uvm_do_with(req, 
      { req.addr == start_addr26;
        req.direction26 == APB_READ26;
        req.transmit_delay26 == transmit_del26; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq26

// SEQUENCE26: multiple_read_after_write_seq26
class multiple_read_after_write_seq26 extends apb_master_base_seq26;

    read_after_write_seq26 raw_seq26;
    write_byte_seq26 w_seq26;
    read_byte_seq26 r_seq26;
    rand int unsigned num_of_seq26;

    function new(string name="multiple_read_after_write_seq26");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq26)

    constraint num_of_seq_c26 { num_of_seq26 <= 10; num_of_seq26 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq26; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq26)
      end
      repeat (3) `uvm_do_with(w_seq26, {transmit_del26 == 1;} )
      repeat (3) `uvm_do_with(r_seq26, {transmit_del26 == 1;} )
    endtask
endclass : multiple_read_after_write_seq26
`endif // APB_MASTER_SEQ_LIB_SV26
