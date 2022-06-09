/*******************************************************************************
  FILE : apb_master_seq_lib11.sv
*******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV11
`define APB_MASTER_SEQ_LIB_SV11

//------------------------------------------------------------------------------
// SEQUENCE11: read_byte_seq11
//------------------------------------------------------------------------------
class apb_master_base_seq11 extends uvm_sequence #(apb_transfer11);
  // NOTE11: KATHLEEN11 - ALSO11 NEED11 TO HANDLE11 KILL11 HERE11??

  function new(string name="apb_master_base_seq11");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq11)
  `uvm_declare_p_sequencer(apb_master_sequencer11)

// Use a base sequence to raise/drop11 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running11 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq11

//------------------------------------------------------------------------------
// SEQUENCE11: read_byte_seq11
//------------------------------------------------------------------------------
class read_byte_seq11 extends apb_master_base_seq11;
  rand bit [31:0] start_addr11;
  rand int unsigned transmit_del11;

  function new(string name="read_byte_seq11");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq11)

  constraint transmit_del_ct11 { (transmit_del11 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr11;
        req.direction11 == APB_READ11;
        req.transmit_delay11 == transmit_del11; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr11 = 'h%0h, req_data11 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr11 = 'h%0h, rsp_data11 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq11

// SEQUENCE11: write_byte_seq11
class write_byte_seq11 extends apb_master_base_seq11;
  rand bit [31:0] start_addr11;
  rand bit [7:0] write_data11;
  rand int unsigned transmit_del11;

  function new(string name="write_byte_seq11");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq11)

  constraint transmit_del_ct11 { (transmit_del11 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr11;
        req.direction11 == APB_WRITE11;
        req.data == write_data11;
        req.transmit_delay11 == transmit_del11; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq11

//------------------------------------------------------------------------------
// SEQUENCE11: read_word_seq11
//------------------------------------------------------------------------------
class read_word_seq11 extends apb_master_base_seq11;
  rand bit [31:0] start_addr11;
  rand int unsigned transmit_del11;

  function new(string name="read_word_seq11");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq11)

  constraint transmit_del_ct11 { (transmit_del11 <= 10); }
  constraint addr_ct11 {(start_addr11[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr11;
        req.direction11 == APB_READ11;
        req.transmit_delay11 == transmit_del11; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr11 = 'h%0h, req_data11 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr11 = 'h%0h, rsp_data11 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq11

// SEQUENCE11: write_word_seq11
class write_word_seq11 extends apb_master_base_seq11;
  rand bit [31:0] start_addr11;
  rand bit [31:0] write_data11;
  rand int unsigned transmit_del11;

  function new(string name="write_word_seq11");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq11)

  constraint transmit_del_ct11 { (transmit_del11 <= 10); }
  constraint addr_ct11 {(start_addr11[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr11;
        req.direction11 == APB_WRITE11;
        req.data == write_data11;
        req.transmit_delay11 == transmit_del11; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq11

// SEQUENCE11: read_after_write_seq11
class read_after_write_seq11 extends apb_master_base_seq11;

  rand bit [31:0] start_addr11;
  rand bit [31:0] write_data11;
  rand int unsigned transmit_del11;

  function new(string name="read_after_write_seq11");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq11)

  constraint transmit_del_ct11 { (transmit_del11 <= 10); }
  constraint addr_ct11 {(start_addr11[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr11;
        req.direction11 == APB_WRITE11;
        req.data == write_data11;
        req.transmit_delay11 == transmit_del11; } )
    `uvm_do_with(req, 
      { req.addr == start_addr11;
        req.direction11 == APB_READ11;
        req.transmit_delay11 == transmit_del11; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq11

// SEQUENCE11: multiple_read_after_write_seq11
class multiple_read_after_write_seq11 extends apb_master_base_seq11;

    read_after_write_seq11 raw_seq11;
    write_byte_seq11 w_seq11;
    read_byte_seq11 r_seq11;
    rand int unsigned num_of_seq11;

    function new(string name="multiple_read_after_write_seq11");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq11)

    constraint num_of_seq_c11 { num_of_seq11 <= 10; num_of_seq11 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq11; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq11)
      end
      repeat (3) `uvm_do_with(w_seq11, {transmit_del11 == 1;} )
      repeat (3) `uvm_do_with(r_seq11, {transmit_del11 == 1;} )
    endtask
endclass : multiple_read_after_write_seq11
`endif // APB_MASTER_SEQ_LIB_SV11
