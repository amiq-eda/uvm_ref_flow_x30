/*******************************************************************************
  FILE : apb_master_seq_lib13.sv
*******************************************************************************/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV13
`define APB_MASTER_SEQ_LIB_SV13

//------------------------------------------------------------------------------
// SEQUENCE13: read_byte_seq13
//------------------------------------------------------------------------------
class apb_master_base_seq13 extends uvm_sequence #(apb_transfer13);
  // NOTE13: KATHLEEN13 - ALSO13 NEED13 TO HANDLE13 KILL13 HERE13??

  function new(string name="apb_master_base_seq13");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq13)
  `uvm_declare_p_sequencer(apb_master_sequencer13)

// Use a base sequence to raise/drop13 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running13 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq13

//------------------------------------------------------------------------------
// SEQUENCE13: read_byte_seq13
//------------------------------------------------------------------------------
class read_byte_seq13 extends apb_master_base_seq13;
  rand bit [31:0] start_addr13;
  rand int unsigned transmit_del13;

  function new(string name="read_byte_seq13");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq13)

  constraint transmit_del_ct13 { (transmit_del13 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr13;
        req.direction13 == APB_READ13;
        req.transmit_delay13 == transmit_del13; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr13 = 'h%0h, req_data13 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr13 = 'h%0h, rsp_data13 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq13

// SEQUENCE13: write_byte_seq13
class write_byte_seq13 extends apb_master_base_seq13;
  rand bit [31:0] start_addr13;
  rand bit [7:0] write_data13;
  rand int unsigned transmit_del13;

  function new(string name="write_byte_seq13");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq13)

  constraint transmit_del_ct13 { (transmit_del13 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr13;
        req.direction13 == APB_WRITE13;
        req.data == write_data13;
        req.transmit_delay13 == transmit_del13; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq13

//------------------------------------------------------------------------------
// SEQUENCE13: read_word_seq13
//------------------------------------------------------------------------------
class read_word_seq13 extends apb_master_base_seq13;
  rand bit [31:0] start_addr13;
  rand int unsigned transmit_del13;

  function new(string name="read_word_seq13");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq13)

  constraint transmit_del_ct13 { (transmit_del13 <= 10); }
  constraint addr_ct13 {(start_addr13[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr13;
        req.direction13 == APB_READ13;
        req.transmit_delay13 == transmit_del13; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr13 = 'h%0h, req_data13 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr13 = 'h%0h, rsp_data13 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq13

// SEQUENCE13: write_word_seq13
class write_word_seq13 extends apb_master_base_seq13;
  rand bit [31:0] start_addr13;
  rand bit [31:0] write_data13;
  rand int unsigned transmit_del13;

  function new(string name="write_word_seq13");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq13)

  constraint transmit_del_ct13 { (transmit_del13 <= 10); }
  constraint addr_ct13 {(start_addr13[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr13;
        req.direction13 == APB_WRITE13;
        req.data == write_data13;
        req.transmit_delay13 == transmit_del13; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq13

// SEQUENCE13: read_after_write_seq13
class read_after_write_seq13 extends apb_master_base_seq13;

  rand bit [31:0] start_addr13;
  rand bit [31:0] write_data13;
  rand int unsigned transmit_del13;

  function new(string name="read_after_write_seq13");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq13)

  constraint transmit_del_ct13 { (transmit_del13 <= 10); }
  constraint addr_ct13 {(start_addr13[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr13;
        req.direction13 == APB_WRITE13;
        req.data == write_data13;
        req.transmit_delay13 == transmit_del13; } )
    `uvm_do_with(req, 
      { req.addr == start_addr13;
        req.direction13 == APB_READ13;
        req.transmit_delay13 == transmit_del13; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq13

// SEQUENCE13: multiple_read_after_write_seq13
class multiple_read_after_write_seq13 extends apb_master_base_seq13;

    read_after_write_seq13 raw_seq13;
    write_byte_seq13 w_seq13;
    read_byte_seq13 r_seq13;
    rand int unsigned num_of_seq13;

    function new(string name="multiple_read_after_write_seq13");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq13)

    constraint num_of_seq_c13 { num_of_seq13 <= 10; num_of_seq13 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq13; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq13)
      end
      repeat (3) `uvm_do_with(w_seq13, {transmit_del13 == 1;} )
      repeat (3) `uvm_do_with(r_seq13, {transmit_del13 == 1;} )
    endtask
endclass : multiple_read_after_write_seq13
`endif // APB_MASTER_SEQ_LIB_SV13
