/*******************************************************************************
  FILE : apb_master_seq_lib7.sv
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV7
`define APB_MASTER_SEQ_LIB_SV7

//------------------------------------------------------------------------------
// SEQUENCE7: read_byte_seq7
//------------------------------------------------------------------------------
class apb_master_base_seq7 extends uvm_sequence #(apb_transfer7);
  // NOTE7: KATHLEEN7 - ALSO7 NEED7 TO HANDLE7 KILL7 HERE7??

  function new(string name="apb_master_base_seq7");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq7)
  `uvm_declare_p_sequencer(apb_master_sequencer7)

// Use a base sequence to raise/drop7 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running7 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq7

//------------------------------------------------------------------------------
// SEQUENCE7: read_byte_seq7
//------------------------------------------------------------------------------
class read_byte_seq7 extends apb_master_base_seq7;
  rand bit [31:0] start_addr7;
  rand int unsigned transmit_del7;

  function new(string name="read_byte_seq7");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq7)

  constraint transmit_del_ct7 { (transmit_del7 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr7;
        req.direction7 == APB_READ7;
        req.transmit_delay7 == transmit_del7; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr7 = 'h%0h, req_data7 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr7 = 'h%0h, rsp_data7 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq7

// SEQUENCE7: write_byte_seq7
class write_byte_seq7 extends apb_master_base_seq7;
  rand bit [31:0] start_addr7;
  rand bit [7:0] write_data7;
  rand int unsigned transmit_del7;

  function new(string name="write_byte_seq7");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq7)

  constraint transmit_del_ct7 { (transmit_del7 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr7;
        req.direction7 == APB_WRITE7;
        req.data == write_data7;
        req.transmit_delay7 == transmit_del7; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq7

//------------------------------------------------------------------------------
// SEQUENCE7: read_word_seq7
//------------------------------------------------------------------------------
class read_word_seq7 extends apb_master_base_seq7;
  rand bit [31:0] start_addr7;
  rand int unsigned transmit_del7;

  function new(string name="read_word_seq7");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq7)

  constraint transmit_del_ct7 { (transmit_del7 <= 10); }
  constraint addr_ct7 {(start_addr7[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr7;
        req.direction7 == APB_READ7;
        req.transmit_delay7 == transmit_del7; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr7 = 'h%0h, req_data7 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr7 = 'h%0h, rsp_data7 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq7

// SEQUENCE7: write_word_seq7
class write_word_seq7 extends apb_master_base_seq7;
  rand bit [31:0] start_addr7;
  rand bit [31:0] write_data7;
  rand int unsigned transmit_del7;

  function new(string name="write_word_seq7");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq7)

  constraint transmit_del_ct7 { (transmit_del7 <= 10); }
  constraint addr_ct7 {(start_addr7[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr7;
        req.direction7 == APB_WRITE7;
        req.data == write_data7;
        req.transmit_delay7 == transmit_del7; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq7

// SEQUENCE7: read_after_write_seq7
class read_after_write_seq7 extends apb_master_base_seq7;

  rand bit [31:0] start_addr7;
  rand bit [31:0] write_data7;
  rand int unsigned transmit_del7;

  function new(string name="read_after_write_seq7");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq7)

  constraint transmit_del_ct7 { (transmit_del7 <= 10); }
  constraint addr_ct7 {(start_addr7[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr7;
        req.direction7 == APB_WRITE7;
        req.data == write_data7;
        req.transmit_delay7 == transmit_del7; } )
    `uvm_do_with(req, 
      { req.addr == start_addr7;
        req.direction7 == APB_READ7;
        req.transmit_delay7 == transmit_del7; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq7

// SEQUENCE7: multiple_read_after_write_seq7
class multiple_read_after_write_seq7 extends apb_master_base_seq7;

    read_after_write_seq7 raw_seq7;
    write_byte_seq7 w_seq7;
    read_byte_seq7 r_seq7;
    rand int unsigned num_of_seq7;

    function new(string name="multiple_read_after_write_seq7");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq7)

    constraint num_of_seq_c7 { num_of_seq7 <= 10; num_of_seq7 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq7; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq7)
      end
      repeat (3) `uvm_do_with(w_seq7, {transmit_del7 == 1;} )
      repeat (3) `uvm_do_with(r_seq7, {transmit_del7 == 1;} )
    endtask
endclass : multiple_read_after_write_seq7
`endif // APB_MASTER_SEQ_LIB_SV7
