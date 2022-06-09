/*******************************************************************************
  FILE : apb_master_seq_lib28.sv
*******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV28
`define APB_MASTER_SEQ_LIB_SV28

//------------------------------------------------------------------------------
// SEQUENCE28: read_byte_seq28
//------------------------------------------------------------------------------
class apb_master_base_seq28 extends uvm_sequence #(apb_transfer28);
  // NOTE28: KATHLEEN28 - ALSO28 NEED28 TO HANDLE28 KILL28 HERE28??

  function new(string name="apb_master_base_seq28");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq28)
  `uvm_declare_p_sequencer(apb_master_sequencer28)

// Use a base sequence to raise/drop28 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running28 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq28

//------------------------------------------------------------------------------
// SEQUENCE28: read_byte_seq28
//------------------------------------------------------------------------------
class read_byte_seq28 extends apb_master_base_seq28;
  rand bit [31:0] start_addr28;
  rand int unsigned transmit_del28;

  function new(string name="read_byte_seq28");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq28)

  constraint transmit_del_ct28 { (transmit_del28 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr28;
        req.direction28 == APB_READ28;
        req.transmit_delay28 == transmit_del28; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr28 = 'h%0h, req_data28 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr28 = 'h%0h, rsp_data28 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq28

// SEQUENCE28: write_byte_seq28
class write_byte_seq28 extends apb_master_base_seq28;
  rand bit [31:0] start_addr28;
  rand bit [7:0] write_data28;
  rand int unsigned transmit_del28;

  function new(string name="write_byte_seq28");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq28)

  constraint transmit_del_ct28 { (transmit_del28 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr28;
        req.direction28 == APB_WRITE28;
        req.data == write_data28;
        req.transmit_delay28 == transmit_del28; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq28

//------------------------------------------------------------------------------
// SEQUENCE28: read_word_seq28
//------------------------------------------------------------------------------
class read_word_seq28 extends apb_master_base_seq28;
  rand bit [31:0] start_addr28;
  rand int unsigned transmit_del28;

  function new(string name="read_word_seq28");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq28)

  constraint transmit_del_ct28 { (transmit_del28 <= 10); }
  constraint addr_ct28 {(start_addr28[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr28;
        req.direction28 == APB_READ28;
        req.transmit_delay28 == transmit_del28; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr28 = 'h%0h, req_data28 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr28 = 'h%0h, rsp_data28 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq28

// SEQUENCE28: write_word_seq28
class write_word_seq28 extends apb_master_base_seq28;
  rand bit [31:0] start_addr28;
  rand bit [31:0] write_data28;
  rand int unsigned transmit_del28;

  function new(string name="write_word_seq28");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq28)

  constraint transmit_del_ct28 { (transmit_del28 <= 10); }
  constraint addr_ct28 {(start_addr28[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr28;
        req.direction28 == APB_WRITE28;
        req.data == write_data28;
        req.transmit_delay28 == transmit_del28; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq28

// SEQUENCE28: read_after_write_seq28
class read_after_write_seq28 extends apb_master_base_seq28;

  rand bit [31:0] start_addr28;
  rand bit [31:0] write_data28;
  rand int unsigned transmit_del28;

  function new(string name="read_after_write_seq28");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq28)

  constraint transmit_del_ct28 { (transmit_del28 <= 10); }
  constraint addr_ct28 {(start_addr28[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr28;
        req.direction28 == APB_WRITE28;
        req.data == write_data28;
        req.transmit_delay28 == transmit_del28; } )
    `uvm_do_with(req, 
      { req.addr == start_addr28;
        req.direction28 == APB_READ28;
        req.transmit_delay28 == transmit_del28; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq28

// SEQUENCE28: multiple_read_after_write_seq28
class multiple_read_after_write_seq28 extends apb_master_base_seq28;

    read_after_write_seq28 raw_seq28;
    write_byte_seq28 w_seq28;
    read_byte_seq28 r_seq28;
    rand int unsigned num_of_seq28;

    function new(string name="multiple_read_after_write_seq28");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq28)

    constraint num_of_seq_c28 { num_of_seq28 <= 10; num_of_seq28 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq28; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq28)
      end
      repeat (3) `uvm_do_with(w_seq28, {transmit_del28 == 1;} )
      repeat (3) `uvm_do_with(r_seq28, {transmit_del28 == 1;} )
    endtask
endclass : multiple_read_after_write_seq28
`endif // APB_MASTER_SEQ_LIB_SV28
