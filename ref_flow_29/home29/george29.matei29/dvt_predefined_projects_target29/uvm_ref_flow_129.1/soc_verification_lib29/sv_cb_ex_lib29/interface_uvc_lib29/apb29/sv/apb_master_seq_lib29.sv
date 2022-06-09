/*******************************************************************************
  FILE : apb_master_seq_lib29.sv
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV29
`define APB_MASTER_SEQ_LIB_SV29

//------------------------------------------------------------------------------
// SEQUENCE29: read_byte_seq29
//------------------------------------------------------------------------------
class apb_master_base_seq29 extends uvm_sequence #(apb_transfer29);
  // NOTE29: KATHLEEN29 - ALSO29 NEED29 TO HANDLE29 KILL29 HERE29??

  function new(string name="apb_master_base_seq29");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq29)
  `uvm_declare_p_sequencer(apb_master_sequencer29)

// Use a base sequence to raise/drop29 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running29 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq29

//------------------------------------------------------------------------------
// SEQUENCE29: read_byte_seq29
//------------------------------------------------------------------------------
class read_byte_seq29 extends apb_master_base_seq29;
  rand bit [31:0] start_addr29;
  rand int unsigned transmit_del29;

  function new(string name="read_byte_seq29");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq29)

  constraint transmit_del_ct29 { (transmit_del29 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr29;
        req.direction29 == APB_READ29;
        req.transmit_delay29 == transmit_del29; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr29 = 'h%0h, req_data29 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr29 = 'h%0h, rsp_data29 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq29

// SEQUENCE29: write_byte_seq29
class write_byte_seq29 extends apb_master_base_seq29;
  rand bit [31:0] start_addr29;
  rand bit [7:0] write_data29;
  rand int unsigned transmit_del29;

  function new(string name="write_byte_seq29");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq29)

  constraint transmit_del_ct29 { (transmit_del29 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr29;
        req.direction29 == APB_WRITE29;
        req.data == write_data29;
        req.transmit_delay29 == transmit_del29; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq29

//------------------------------------------------------------------------------
// SEQUENCE29: read_word_seq29
//------------------------------------------------------------------------------
class read_word_seq29 extends apb_master_base_seq29;
  rand bit [31:0] start_addr29;
  rand int unsigned transmit_del29;

  function new(string name="read_word_seq29");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq29)

  constraint transmit_del_ct29 { (transmit_del29 <= 10); }
  constraint addr_ct29 {(start_addr29[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr29;
        req.direction29 == APB_READ29;
        req.transmit_delay29 == transmit_del29; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr29 = 'h%0h, req_data29 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr29 = 'h%0h, rsp_data29 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq29

// SEQUENCE29: write_word_seq29
class write_word_seq29 extends apb_master_base_seq29;
  rand bit [31:0] start_addr29;
  rand bit [31:0] write_data29;
  rand int unsigned transmit_del29;

  function new(string name="write_word_seq29");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq29)

  constraint transmit_del_ct29 { (transmit_del29 <= 10); }
  constraint addr_ct29 {(start_addr29[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr29;
        req.direction29 == APB_WRITE29;
        req.data == write_data29;
        req.transmit_delay29 == transmit_del29; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq29

// SEQUENCE29: read_after_write_seq29
class read_after_write_seq29 extends apb_master_base_seq29;

  rand bit [31:0] start_addr29;
  rand bit [31:0] write_data29;
  rand int unsigned transmit_del29;

  function new(string name="read_after_write_seq29");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq29)

  constraint transmit_del_ct29 { (transmit_del29 <= 10); }
  constraint addr_ct29 {(start_addr29[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr29;
        req.direction29 == APB_WRITE29;
        req.data == write_data29;
        req.transmit_delay29 == transmit_del29; } )
    `uvm_do_with(req, 
      { req.addr == start_addr29;
        req.direction29 == APB_READ29;
        req.transmit_delay29 == transmit_del29; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq29

// SEQUENCE29: multiple_read_after_write_seq29
class multiple_read_after_write_seq29 extends apb_master_base_seq29;

    read_after_write_seq29 raw_seq29;
    write_byte_seq29 w_seq29;
    read_byte_seq29 r_seq29;
    rand int unsigned num_of_seq29;

    function new(string name="multiple_read_after_write_seq29");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq29)

    constraint num_of_seq_c29 { num_of_seq29 <= 10; num_of_seq29 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq29; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq29)
      end
      repeat (3) `uvm_do_with(w_seq29, {transmit_del29 == 1;} )
      repeat (3) `uvm_do_with(r_seq29, {transmit_del29 == 1;} )
    endtask
endclass : multiple_read_after_write_seq29
`endif // APB_MASTER_SEQ_LIB_SV29
