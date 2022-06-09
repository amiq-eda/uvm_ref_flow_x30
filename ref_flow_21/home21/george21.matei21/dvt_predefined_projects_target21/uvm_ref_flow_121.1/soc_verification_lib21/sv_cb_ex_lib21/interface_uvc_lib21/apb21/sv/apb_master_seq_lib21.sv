/*******************************************************************************
  FILE : apb_master_seq_lib21.sv
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV21
`define APB_MASTER_SEQ_LIB_SV21

//------------------------------------------------------------------------------
// SEQUENCE21: read_byte_seq21
//------------------------------------------------------------------------------
class apb_master_base_seq21 extends uvm_sequence #(apb_transfer21);
  // NOTE21: KATHLEEN21 - ALSO21 NEED21 TO HANDLE21 KILL21 HERE21??

  function new(string name="apb_master_base_seq21");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq21)
  `uvm_declare_p_sequencer(apb_master_sequencer21)

// Use a base sequence to raise/drop21 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running21 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq21

//------------------------------------------------------------------------------
// SEQUENCE21: read_byte_seq21
//------------------------------------------------------------------------------
class read_byte_seq21 extends apb_master_base_seq21;
  rand bit [31:0] start_addr21;
  rand int unsigned transmit_del21;

  function new(string name="read_byte_seq21");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq21)

  constraint transmit_del_ct21 { (transmit_del21 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr21;
        req.direction21 == APB_READ21;
        req.transmit_delay21 == transmit_del21; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr21 = 'h%0h, req_data21 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr21 = 'h%0h, rsp_data21 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq21

// SEQUENCE21: write_byte_seq21
class write_byte_seq21 extends apb_master_base_seq21;
  rand bit [31:0] start_addr21;
  rand bit [7:0] write_data21;
  rand int unsigned transmit_del21;

  function new(string name="write_byte_seq21");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq21)

  constraint transmit_del_ct21 { (transmit_del21 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr21;
        req.direction21 == APB_WRITE21;
        req.data == write_data21;
        req.transmit_delay21 == transmit_del21; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq21

//------------------------------------------------------------------------------
// SEQUENCE21: read_word_seq21
//------------------------------------------------------------------------------
class read_word_seq21 extends apb_master_base_seq21;
  rand bit [31:0] start_addr21;
  rand int unsigned transmit_del21;

  function new(string name="read_word_seq21");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq21)

  constraint transmit_del_ct21 { (transmit_del21 <= 10); }
  constraint addr_ct21 {(start_addr21[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr21;
        req.direction21 == APB_READ21;
        req.transmit_delay21 == transmit_del21; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr21 = 'h%0h, req_data21 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr21 = 'h%0h, rsp_data21 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq21

// SEQUENCE21: write_word_seq21
class write_word_seq21 extends apb_master_base_seq21;
  rand bit [31:0] start_addr21;
  rand bit [31:0] write_data21;
  rand int unsigned transmit_del21;

  function new(string name="write_word_seq21");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq21)

  constraint transmit_del_ct21 { (transmit_del21 <= 10); }
  constraint addr_ct21 {(start_addr21[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr21;
        req.direction21 == APB_WRITE21;
        req.data == write_data21;
        req.transmit_delay21 == transmit_del21; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq21

// SEQUENCE21: read_after_write_seq21
class read_after_write_seq21 extends apb_master_base_seq21;

  rand bit [31:0] start_addr21;
  rand bit [31:0] write_data21;
  rand int unsigned transmit_del21;

  function new(string name="read_after_write_seq21");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq21)

  constraint transmit_del_ct21 { (transmit_del21 <= 10); }
  constraint addr_ct21 {(start_addr21[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr21;
        req.direction21 == APB_WRITE21;
        req.data == write_data21;
        req.transmit_delay21 == transmit_del21; } )
    `uvm_do_with(req, 
      { req.addr == start_addr21;
        req.direction21 == APB_READ21;
        req.transmit_delay21 == transmit_del21; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq21

// SEQUENCE21: multiple_read_after_write_seq21
class multiple_read_after_write_seq21 extends apb_master_base_seq21;

    read_after_write_seq21 raw_seq21;
    write_byte_seq21 w_seq21;
    read_byte_seq21 r_seq21;
    rand int unsigned num_of_seq21;

    function new(string name="multiple_read_after_write_seq21");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq21)

    constraint num_of_seq_c21 { num_of_seq21 <= 10; num_of_seq21 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq21; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq21)
      end
      repeat (3) `uvm_do_with(w_seq21, {transmit_del21 == 1;} )
      repeat (3) `uvm_do_with(r_seq21, {transmit_del21 == 1;} )
    endtask
endclass : multiple_read_after_write_seq21
`endif // APB_MASTER_SEQ_LIB_SV21
