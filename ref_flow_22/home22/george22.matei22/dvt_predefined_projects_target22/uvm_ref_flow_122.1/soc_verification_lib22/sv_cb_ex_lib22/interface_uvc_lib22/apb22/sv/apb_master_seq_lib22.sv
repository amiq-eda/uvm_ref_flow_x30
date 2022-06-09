/*******************************************************************************
  FILE : apb_master_seq_lib22.sv
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV22
`define APB_MASTER_SEQ_LIB_SV22

//------------------------------------------------------------------------------
// SEQUENCE22: read_byte_seq22
//------------------------------------------------------------------------------
class apb_master_base_seq22 extends uvm_sequence #(apb_transfer22);
  // NOTE22: KATHLEEN22 - ALSO22 NEED22 TO HANDLE22 KILL22 HERE22??

  function new(string name="apb_master_base_seq22");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq22)
  `uvm_declare_p_sequencer(apb_master_sequencer22)

// Use a base sequence to raise/drop22 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running22 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq22

//------------------------------------------------------------------------------
// SEQUENCE22: read_byte_seq22
//------------------------------------------------------------------------------
class read_byte_seq22 extends apb_master_base_seq22;
  rand bit [31:0] start_addr22;
  rand int unsigned transmit_del22;

  function new(string name="read_byte_seq22");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq22)

  constraint transmit_del_ct22 { (transmit_del22 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr22;
        req.direction22 == APB_READ22;
        req.transmit_delay22 == transmit_del22; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr22 = 'h%0h, req_data22 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr22 = 'h%0h, rsp_data22 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq22

// SEQUENCE22: write_byte_seq22
class write_byte_seq22 extends apb_master_base_seq22;
  rand bit [31:0] start_addr22;
  rand bit [7:0] write_data22;
  rand int unsigned transmit_del22;

  function new(string name="write_byte_seq22");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq22)

  constraint transmit_del_ct22 { (transmit_del22 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr22;
        req.direction22 == APB_WRITE22;
        req.data == write_data22;
        req.transmit_delay22 == transmit_del22; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq22

//------------------------------------------------------------------------------
// SEQUENCE22: read_word_seq22
//------------------------------------------------------------------------------
class read_word_seq22 extends apb_master_base_seq22;
  rand bit [31:0] start_addr22;
  rand int unsigned transmit_del22;

  function new(string name="read_word_seq22");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq22)

  constraint transmit_del_ct22 { (transmit_del22 <= 10); }
  constraint addr_ct22 {(start_addr22[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr22;
        req.direction22 == APB_READ22;
        req.transmit_delay22 == transmit_del22; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr22 = 'h%0h, req_data22 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr22 = 'h%0h, rsp_data22 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq22

// SEQUENCE22: write_word_seq22
class write_word_seq22 extends apb_master_base_seq22;
  rand bit [31:0] start_addr22;
  rand bit [31:0] write_data22;
  rand int unsigned transmit_del22;

  function new(string name="write_word_seq22");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq22)

  constraint transmit_del_ct22 { (transmit_del22 <= 10); }
  constraint addr_ct22 {(start_addr22[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr22;
        req.direction22 == APB_WRITE22;
        req.data == write_data22;
        req.transmit_delay22 == transmit_del22; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq22

// SEQUENCE22: read_after_write_seq22
class read_after_write_seq22 extends apb_master_base_seq22;

  rand bit [31:0] start_addr22;
  rand bit [31:0] write_data22;
  rand int unsigned transmit_del22;

  function new(string name="read_after_write_seq22");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq22)

  constraint transmit_del_ct22 { (transmit_del22 <= 10); }
  constraint addr_ct22 {(start_addr22[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr22;
        req.direction22 == APB_WRITE22;
        req.data == write_data22;
        req.transmit_delay22 == transmit_del22; } )
    `uvm_do_with(req, 
      { req.addr == start_addr22;
        req.direction22 == APB_READ22;
        req.transmit_delay22 == transmit_del22; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq22

// SEQUENCE22: multiple_read_after_write_seq22
class multiple_read_after_write_seq22 extends apb_master_base_seq22;

    read_after_write_seq22 raw_seq22;
    write_byte_seq22 w_seq22;
    read_byte_seq22 r_seq22;
    rand int unsigned num_of_seq22;

    function new(string name="multiple_read_after_write_seq22");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq22)

    constraint num_of_seq_c22 { num_of_seq22 <= 10; num_of_seq22 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq22; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq22)
      end
      repeat (3) `uvm_do_with(w_seq22, {transmit_del22 == 1;} )
      repeat (3) `uvm_do_with(r_seq22, {transmit_del22 == 1;} )
    endtask
endclass : multiple_read_after_write_seq22
`endif // APB_MASTER_SEQ_LIB_SV22
