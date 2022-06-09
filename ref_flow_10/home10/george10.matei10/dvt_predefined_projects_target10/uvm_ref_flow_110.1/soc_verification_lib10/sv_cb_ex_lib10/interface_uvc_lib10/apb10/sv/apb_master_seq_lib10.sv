/*******************************************************************************
  FILE : apb_master_seq_lib10.sv
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV10
`define APB_MASTER_SEQ_LIB_SV10

//------------------------------------------------------------------------------
// SEQUENCE10: read_byte_seq10
//------------------------------------------------------------------------------
class apb_master_base_seq10 extends uvm_sequence #(apb_transfer10);
  // NOTE10: KATHLEEN10 - ALSO10 NEED10 TO HANDLE10 KILL10 HERE10??

  function new(string name="apb_master_base_seq10");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq10)
  `uvm_declare_p_sequencer(apb_master_sequencer10)

// Use a base sequence to raise/drop10 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running10 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq10

//------------------------------------------------------------------------------
// SEQUENCE10: read_byte_seq10
//------------------------------------------------------------------------------
class read_byte_seq10 extends apb_master_base_seq10;
  rand bit [31:0] start_addr10;
  rand int unsigned transmit_del10;

  function new(string name="read_byte_seq10");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq10)

  constraint transmit_del_ct10 { (transmit_del10 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr10;
        req.direction10 == APB_READ10;
        req.transmit_delay10 == transmit_del10; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr10 = 'h%0h, req_data10 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr10 = 'h%0h, rsp_data10 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq10

// SEQUENCE10: write_byte_seq10
class write_byte_seq10 extends apb_master_base_seq10;
  rand bit [31:0] start_addr10;
  rand bit [7:0] write_data10;
  rand int unsigned transmit_del10;

  function new(string name="write_byte_seq10");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq10)

  constraint transmit_del_ct10 { (transmit_del10 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr10;
        req.direction10 == APB_WRITE10;
        req.data == write_data10;
        req.transmit_delay10 == transmit_del10; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq10

//------------------------------------------------------------------------------
// SEQUENCE10: read_word_seq10
//------------------------------------------------------------------------------
class read_word_seq10 extends apb_master_base_seq10;
  rand bit [31:0] start_addr10;
  rand int unsigned transmit_del10;

  function new(string name="read_word_seq10");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq10)

  constraint transmit_del_ct10 { (transmit_del10 <= 10); }
  constraint addr_ct10 {(start_addr10[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr10;
        req.direction10 == APB_READ10;
        req.transmit_delay10 == transmit_del10; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr10 = 'h%0h, req_data10 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr10 = 'h%0h, rsp_data10 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq10

// SEQUENCE10: write_word_seq10
class write_word_seq10 extends apb_master_base_seq10;
  rand bit [31:0] start_addr10;
  rand bit [31:0] write_data10;
  rand int unsigned transmit_del10;

  function new(string name="write_word_seq10");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq10)

  constraint transmit_del_ct10 { (transmit_del10 <= 10); }
  constraint addr_ct10 {(start_addr10[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr10;
        req.direction10 == APB_WRITE10;
        req.data == write_data10;
        req.transmit_delay10 == transmit_del10; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq10

// SEQUENCE10: read_after_write_seq10
class read_after_write_seq10 extends apb_master_base_seq10;

  rand bit [31:0] start_addr10;
  rand bit [31:0] write_data10;
  rand int unsigned transmit_del10;

  function new(string name="read_after_write_seq10");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq10)

  constraint transmit_del_ct10 { (transmit_del10 <= 10); }
  constraint addr_ct10 {(start_addr10[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr10;
        req.direction10 == APB_WRITE10;
        req.data == write_data10;
        req.transmit_delay10 == transmit_del10; } )
    `uvm_do_with(req, 
      { req.addr == start_addr10;
        req.direction10 == APB_READ10;
        req.transmit_delay10 == transmit_del10; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq10

// SEQUENCE10: multiple_read_after_write_seq10
class multiple_read_after_write_seq10 extends apb_master_base_seq10;

    read_after_write_seq10 raw_seq10;
    write_byte_seq10 w_seq10;
    read_byte_seq10 r_seq10;
    rand int unsigned num_of_seq10;

    function new(string name="multiple_read_after_write_seq10");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq10)

    constraint num_of_seq_c10 { num_of_seq10 <= 10; num_of_seq10 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq10; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq10)
      end
      repeat (3) `uvm_do_with(w_seq10, {transmit_del10 == 1;} )
      repeat (3) `uvm_do_with(r_seq10, {transmit_del10 == 1;} )
    endtask
endclass : multiple_read_after_write_seq10
`endif // APB_MASTER_SEQ_LIB_SV10
