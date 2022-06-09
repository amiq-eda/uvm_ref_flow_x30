/*******************************************************************************
  FILE : apb_master_seq_lib25.sv
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV25
`define APB_MASTER_SEQ_LIB_SV25

//------------------------------------------------------------------------------
// SEQUENCE25: read_byte_seq25
//------------------------------------------------------------------------------
class apb_master_base_seq25 extends uvm_sequence #(apb_transfer25);
  // NOTE25: KATHLEEN25 - ALSO25 NEED25 TO HANDLE25 KILL25 HERE25??

  function new(string name="apb_master_base_seq25");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq25)
  `uvm_declare_p_sequencer(apb_master_sequencer25)

// Use a base sequence to raise/drop25 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running25 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq25

//------------------------------------------------------------------------------
// SEQUENCE25: read_byte_seq25
//------------------------------------------------------------------------------
class read_byte_seq25 extends apb_master_base_seq25;
  rand bit [31:0] start_addr25;
  rand int unsigned transmit_del25;

  function new(string name="read_byte_seq25");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq25)

  constraint transmit_del_ct25 { (transmit_del25 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr25;
        req.direction25 == APB_READ25;
        req.transmit_delay25 == transmit_del25; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr25 = 'h%0h, req_data25 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr25 = 'h%0h, rsp_data25 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq25

// SEQUENCE25: write_byte_seq25
class write_byte_seq25 extends apb_master_base_seq25;
  rand bit [31:0] start_addr25;
  rand bit [7:0] write_data25;
  rand int unsigned transmit_del25;

  function new(string name="write_byte_seq25");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq25)

  constraint transmit_del_ct25 { (transmit_del25 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr25;
        req.direction25 == APB_WRITE25;
        req.data == write_data25;
        req.transmit_delay25 == transmit_del25; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq25

//------------------------------------------------------------------------------
// SEQUENCE25: read_word_seq25
//------------------------------------------------------------------------------
class read_word_seq25 extends apb_master_base_seq25;
  rand bit [31:0] start_addr25;
  rand int unsigned transmit_del25;

  function new(string name="read_word_seq25");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq25)

  constraint transmit_del_ct25 { (transmit_del25 <= 10); }
  constraint addr_ct25 {(start_addr25[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr25;
        req.direction25 == APB_READ25;
        req.transmit_delay25 == transmit_del25; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr25 = 'h%0h, req_data25 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr25 = 'h%0h, rsp_data25 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq25

// SEQUENCE25: write_word_seq25
class write_word_seq25 extends apb_master_base_seq25;
  rand bit [31:0] start_addr25;
  rand bit [31:0] write_data25;
  rand int unsigned transmit_del25;

  function new(string name="write_word_seq25");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq25)

  constraint transmit_del_ct25 { (transmit_del25 <= 10); }
  constraint addr_ct25 {(start_addr25[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr25;
        req.direction25 == APB_WRITE25;
        req.data == write_data25;
        req.transmit_delay25 == transmit_del25; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq25

// SEQUENCE25: read_after_write_seq25
class read_after_write_seq25 extends apb_master_base_seq25;

  rand bit [31:0] start_addr25;
  rand bit [31:0] write_data25;
  rand int unsigned transmit_del25;

  function new(string name="read_after_write_seq25");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq25)

  constraint transmit_del_ct25 { (transmit_del25 <= 10); }
  constraint addr_ct25 {(start_addr25[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr25;
        req.direction25 == APB_WRITE25;
        req.data == write_data25;
        req.transmit_delay25 == transmit_del25; } )
    `uvm_do_with(req, 
      { req.addr == start_addr25;
        req.direction25 == APB_READ25;
        req.transmit_delay25 == transmit_del25; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq25

// SEQUENCE25: multiple_read_after_write_seq25
class multiple_read_after_write_seq25 extends apb_master_base_seq25;

    read_after_write_seq25 raw_seq25;
    write_byte_seq25 w_seq25;
    read_byte_seq25 r_seq25;
    rand int unsigned num_of_seq25;

    function new(string name="multiple_read_after_write_seq25");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq25)

    constraint num_of_seq_c25 { num_of_seq25 <= 10; num_of_seq25 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq25; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq25)
      end
      repeat (3) `uvm_do_with(w_seq25, {transmit_del25 == 1;} )
      repeat (3) `uvm_do_with(r_seq25, {transmit_del25 == 1;} )
    endtask
endclass : multiple_read_after_write_seq25
`endif // APB_MASTER_SEQ_LIB_SV25
