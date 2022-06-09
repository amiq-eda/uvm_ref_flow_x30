/*******************************************************************************
  FILE : apb_master_seq_lib3.sv
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV3
`define APB_MASTER_SEQ_LIB_SV3

//------------------------------------------------------------------------------
// SEQUENCE3: read_byte_seq3
//------------------------------------------------------------------------------
class apb_master_base_seq3 extends uvm_sequence #(apb_transfer3);
  // NOTE3: KATHLEEN3 - ALSO3 NEED3 TO HANDLE3 KILL3 HERE3??

  function new(string name="apb_master_base_seq3");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq3)
  `uvm_declare_p_sequencer(apb_master_sequencer3)

// Use a base sequence to raise/drop3 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running3 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq3

//------------------------------------------------------------------------------
// SEQUENCE3: read_byte_seq3
//------------------------------------------------------------------------------
class read_byte_seq3 extends apb_master_base_seq3;
  rand bit [31:0] start_addr3;
  rand int unsigned transmit_del3;

  function new(string name="read_byte_seq3");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq3)

  constraint transmit_del_ct3 { (transmit_del3 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr3;
        req.direction3 == APB_READ3;
        req.transmit_delay3 == transmit_del3; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr3 = 'h%0h, req_data3 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr3 = 'h%0h, rsp_data3 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq3

// SEQUENCE3: write_byte_seq3
class write_byte_seq3 extends apb_master_base_seq3;
  rand bit [31:0] start_addr3;
  rand bit [7:0] write_data3;
  rand int unsigned transmit_del3;

  function new(string name="write_byte_seq3");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq3)

  constraint transmit_del_ct3 { (transmit_del3 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr3;
        req.direction3 == APB_WRITE3;
        req.data == write_data3;
        req.transmit_delay3 == transmit_del3; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq3

//------------------------------------------------------------------------------
// SEQUENCE3: read_word_seq3
//------------------------------------------------------------------------------
class read_word_seq3 extends apb_master_base_seq3;
  rand bit [31:0] start_addr3;
  rand int unsigned transmit_del3;

  function new(string name="read_word_seq3");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq3)

  constraint transmit_del_ct3 { (transmit_del3 <= 10); }
  constraint addr_ct3 {(start_addr3[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr3;
        req.direction3 == APB_READ3;
        req.transmit_delay3 == transmit_del3; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr3 = 'h%0h, req_data3 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr3 = 'h%0h, rsp_data3 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq3

// SEQUENCE3: write_word_seq3
class write_word_seq3 extends apb_master_base_seq3;
  rand bit [31:0] start_addr3;
  rand bit [31:0] write_data3;
  rand int unsigned transmit_del3;

  function new(string name="write_word_seq3");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq3)

  constraint transmit_del_ct3 { (transmit_del3 <= 10); }
  constraint addr_ct3 {(start_addr3[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr3;
        req.direction3 == APB_WRITE3;
        req.data == write_data3;
        req.transmit_delay3 == transmit_del3; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq3

// SEQUENCE3: read_after_write_seq3
class read_after_write_seq3 extends apb_master_base_seq3;

  rand bit [31:0] start_addr3;
  rand bit [31:0] write_data3;
  rand int unsigned transmit_del3;

  function new(string name="read_after_write_seq3");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq3)

  constraint transmit_del_ct3 { (transmit_del3 <= 10); }
  constraint addr_ct3 {(start_addr3[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr3;
        req.direction3 == APB_WRITE3;
        req.data == write_data3;
        req.transmit_delay3 == transmit_del3; } )
    `uvm_do_with(req, 
      { req.addr == start_addr3;
        req.direction3 == APB_READ3;
        req.transmit_delay3 == transmit_del3; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq3

// SEQUENCE3: multiple_read_after_write_seq3
class multiple_read_after_write_seq3 extends apb_master_base_seq3;

    read_after_write_seq3 raw_seq3;
    write_byte_seq3 w_seq3;
    read_byte_seq3 r_seq3;
    rand int unsigned num_of_seq3;

    function new(string name="multiple_read_after_write_seq3");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq3)

    constraint num_of_seq_c3 { num_of_seq3 <= 10; num_of_seq3 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq3; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq3)
      end
      repeat (3) `uvm_do_with(w_seq3, {transmit_del3 == 1;} )
      repeat (3) `uvm_do_with(r_seq3, {transmit_del3 == 1;} )
    endtask
endclass : multiple_read_after_write_seq3
`endif // APB_MASTER_SEQ_LIB_SV3
