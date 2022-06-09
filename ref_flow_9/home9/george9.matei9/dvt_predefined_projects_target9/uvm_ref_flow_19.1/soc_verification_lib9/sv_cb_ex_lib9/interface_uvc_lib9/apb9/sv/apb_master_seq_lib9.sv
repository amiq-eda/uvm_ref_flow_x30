/*******************************************************************************
  FILE : apb_master_seq_lib9.sv
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV9
`define APB_MASTER_SEQ_LIB_SV9

//------------------------------------------------------------------------------
// SEQUENCE9: read_byte_seq9
//------------------------------------------------------------------------------
class apb_master_base_seq9 extends uvm_sequence #(apb_transfer9);
  // NOTE9: KATHLEEN9 - ALSO9 NEED9 TO HANDLE9 KILL9 HERE9??

  function new(string name="apb_master_base_seq9");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq9)
  `uvm_declare_p_sequencer(apb_master_sequencer9)

// Use a base sequence to raise/drop9 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running9 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq9

//------------------------------------------------------------------------------
// SEQUENCE9: read_byte_seq9
//------------------------------------------------------------------------------
class read_byte_seq9 extends apb_master_base_seq9;
  rand bit [31:0] start_addr9;
  rand int unsigned transmit_del9;

  function new(string name="read_byte_seq9");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq9)

  constraint transmit_del_ct9 { (transmit_del9 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr9;
        req.direction9 == APB_READ9;
        req.transmit_delay9 == transmit_del9; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr9 = 'h%0h, req_data9 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr9 = 'h%0h, rsp_data9 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq9

// SEQUENCE9: write_byte_seq9
class write_byte_seq9 extends apb_master_base_seq9;
  rand bit [31:0] start_addr9;
  rand bit [7:0] write_data9;
  rand int unsigned transmit_del9;

  function new(string name="write_byte_seq9");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq9)

  constraint transmit_del_ct9 { (transmit_del9 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr9;
        req.direction9 == APB_WRITE9;
        req.data == write_data9;
        req.transmit_delay9 == transmit_del9; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq9

//------------------------------------------------------------------------------
// SEQUENCE9: read_word_seq9
//------------------------------------------------------------------------------
class read_word_seq9 extends apb_master_base_seq9;
  rand bit [31:0] start_addr9;
  rand int unsigned transmit_del9;

  function new(string name="read_word_seq9");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq9)

  constraint transmit_del_ct9 { (transmit_del9 <= 10); }
  constraint addr_ct9 {(start_addr9[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr9;
        req.direction9 == APB_READ9;
        req.transmit_delay9 == transmit_del9; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr9 = 'h%0h, req_data9 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr9 = 'h%0h, rsp_data9 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq9

// SEQUENCE9: write_word_seq9
class write_word_seq9 extends apb_master_base_seq9;
  rand bit [31:0] start_addr9;
  rand bit [31:0] write_data9;
  rand int unsigned transmit_del9;

  function new(string name="write_word_seq9");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq9)

  constraint transmit_del_ct9 { (transmit_del9 <= 10); }
  constraint addr_ct9 {(start_addr9[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr9;
        req.direction9 == APB_WRITE9;
        req.data == write_data9;
        req.transmit_delay9 == transmit_del9; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq9

// SEQUENCE9: read_after_write_seq9
class read_after_write_seq9 extends apb_master_base_seq9;

  rand bit [31:0] start_addr9;
  rand bit [31:0] write_data9;
  rand int unsigned transmit_del9;

  function new(string name="read_after_write_seq9");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq9)

  constraint transmit_del_ct9 { (transmit_del9 <= 10); }
  constraint addr_ct9 {(start_addr9[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr9;
        req.direction9 == APB_WRITE9;
        req.data == write_data9;
        req.transmit_delay9 == transmit_del9; } )
    `uvm_do_with(req, 
      { req.addr == start_addr9;
        req.direction9 == APB_READ9;
        req.transmit_delay9 == transmit_del9; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq9

// SEQUENCE9: multiple_read_after_write_seq9
class multiple_read_after_write_seq9 extends apb_master_base_seq9;

    read_after_write_seq9 raw_seq9;
    write_byte_seq9 w_seq9;
    read_byte_seq9 r_seq9;
    rand int unsigned num_of_seq9;

    function new(string name="multiple_read_after_write_seq9");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq9)

    constraint num_of_seq_c9 { num_of_seq9 <= 10; num_of_seq9 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq9; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq9)
      end
      repeat (3) `uvm_do_with(w_seq9, {transmit_del9 == 1;} )
      repeat (3) `uvm_do_with(r_seq9, {transmit_del9 == 1;} )
    endtask
endclass : multiple_read_after_write_seq9
`endif // APB_MASTER_SEQ_LIB_SV9
