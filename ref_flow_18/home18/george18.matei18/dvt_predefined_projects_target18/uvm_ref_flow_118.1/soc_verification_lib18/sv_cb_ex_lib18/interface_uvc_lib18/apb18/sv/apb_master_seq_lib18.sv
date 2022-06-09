/*******************************************************************************
  FILE : apb_master_seq_lib18.sv
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV18
`define APB_MASTER_SEQ_LIB_SV18

//------------------------------------------------------------------------------
// SEQUENCE18: read_byte_seq18
//------------------------------------------------------------------------------
class apb_master_base_seq18 extends uvm_sequence #(apb_transfer18);
  // NOTE18: KATHLEEN18 - ALSO18 NEED18 TO HANDLE18 KILL18 HERE18??

  function new(string name="apb_master_base_seq18");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq18)
  `uvm_declare_p_sequencer(apb_master_sequencer18)

// Use a base sequence to raise/drop18 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running18 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq18

//------------------------------------------------------------------------------
// SEQUENCE18: read_byte_seq18
//------------------------------------------------------------------------------
class read_byte_seq18 extends apb_master_base_seq18;
  rand bit [31:0] start_addr18;
  rand int unsigned transmit_del18;

  function new(string name="read_byte_seq18");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq18)

  constraint transmit_del_ct18 { (transmit_del18 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr18;
        req.direction18 == APB_READ18;
        req.transmit_delay18 == transmit_del18; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr18 = 'h%0h, req_data18 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr18 = 'h%0h, rsp_data18 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq18

// SEQUENCE18: write_byte_seq18
class write_byte_seq18 extends apb_master_base_seq18;
  rand bit [31:0] start_addr18;
  rand bit [7:0] write_data18;
  rand int unsigned transmit_del18;

  function new(string name="write_byte_seq18");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq18)

  constraint transmit_del_ct18 { (transmit_del18 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr18;
        req.direction18 == APB_WRITE18;
        req.data == write_data18;
        req.transmit_delay18 == transmit_del18; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq18

//------------------------------------------------------------------------------
// SEQUENCE18: read_word_seq18
//------------------------------------------------------------------------------
class read_word_seq18 extends apb_master_base_seq18;
  rand bit [31:0] start_addr18;
  rand int unsigned transmit_del18;

  function new(string name="read_word_seq18");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq18)

  constraint transmit_del_ct18 { (transmit_del18 <= 10); }
  constraint addr_ct18 {(start_addr18[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr18;
        req.direction18 == APB_READ18;
        req.transmit_delay18 == transmit_del18; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr18 = 'h%0h, req_data18 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr18 = 'h%0h, rsp_data18 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq18

// SEQUENCE18: write_word_seq18
class write_word_seq18 extends apb_master_base_seq18;
  rand bit [31:0] start_addr18;
  rand bit [31:0] write_data18;
  rand int unsigned transmit_del18;

  function new(string name="write_word_seq18");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq18)

  constraint transmit_del_ct18 { (transmit_del18 <= 10); }
  constraint addr_ct18 {(start_addr18[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr18;
        req.direction18 == APB_WRITE18;
        req.data == write_data18;
        req.transmit_delay18 == transmit_del18; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq18

// SEQUENCE18: read_after_write_seq18
class read_after_write_seq18 extends apb_master_base_seq18;

  rand bit [31:0] start_addr18;
  rand bit [31:0] write_data18;
  rand int unsigned transmit_del18;

  function new(string name="read_after_write_seq18");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq18)

  constraint transmit_del_ct18 { (transmit_del18 <= 10); }
  constraint addr_ct18 {(start_addr18[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr18;
        req.direction18 == APB_WRITE18;
        req.data == write_data18;
        req.transmit_delay18 == transmit_del18; } )
    `uvm_do_with(req, 
      { req.addr == start_addr18;
        req.direction18 == APB_READ18;
        req.transmit_delay18 == transmit_del18; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq18

// SEQUENCE18: multiple_read_after_write_seq18
class multiple_read_after_write_seq18 extends apb_master_base_seq18;

    read_after_write_seq18 raw_seq18;
    write_byte_seq18 w_seq18;
    read_byte_seq18 r_seq18;
    rand int unsigned num_of_seq18;

    function new(string name="multiple_read_after_write_seq18");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq18)

    constraint num_of_seq_c18 { num_of_seq18 <= 10; num_of_seq18 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq18; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq18)
      end
      repeat (3) `uvm_do_with(w_seq18, {transmit_del18 == 1;} )
      repeat (3) `uvm_do_with(r_seq18, {transmit_del18 == 1;} )
    endtask
endclass : multiple_read_after_write_seq18
`endif // APB_MASTER_SEQ_LIB_SV18
