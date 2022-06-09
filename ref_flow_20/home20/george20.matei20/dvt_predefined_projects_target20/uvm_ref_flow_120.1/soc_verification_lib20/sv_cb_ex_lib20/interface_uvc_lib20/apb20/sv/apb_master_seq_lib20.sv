/*******************************************************************************
  FILE : apb_master_seq_lib20.sv
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV20
`define APB_MASTER_SEQ_LIB_SV20

//------------------------------------------------------------------------------
// SEQUENCE20: read_byte_seq20
//------------------------------------------------------------------------------
class apb_master_base_seq20 extends uvm_sequence #(apb_transfer20);
  // NOTE20: KATHLEEN20 - ALSO20 NEED20 TO HANDLE20 KILL20 HERE20??

  function new(string name="apb_master_base_seq20");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq20)
  `uvm_declare_p_sequencer(apb_master_sequencer20)

// Use a base sequence to raise/drop20 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running20 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq20

//------------------------------------------------------------------------------
// SEQUENCE20: read_byte_seq20
//------------------------------------------------------------------------------
class read_byte_seq20 extends apb_master_base_seq20;
  rand bit [31:0] start_addr20;
  rand int unsigned transmit_del20;

  function new(string name="read_byte_seq20");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq20)

  constraint transmit_del_ct20 { (transmit_del20 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr20;
        req.direction20 == APB_READ20;
        req.transmit_delay20 == transmit_del20; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr20 = 'h%0h, req_data20 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr20 = 'h%0h, rsp_data20 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq20

// SEQUENCE20: write_byte_seq20
class write_byte_seq20 extends apb_master_base_seq20;
  rand bit [31:0] start_addr20;
  rand bit [7:0] write_data20;
  rand int unsigned transmit_del20;

  function new(string name="write_byte_seq20");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq20)

  constraint transmit_del_ct20 { (transmit_del20 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr20;
        req.direction20 == APB_WRITE20;
        req.data == write_data20;
        req.transmit_delay20 == transmit_del20; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq20

//------------------------------------------------------------------------------
// SEQUENCE20: read_word_seq20
//------------------------------------------------------------------------------
class read_word_seq20 extends apb_master_base_seq20;
  rand bit [31:0] start_addr20;
  rand int unsigned transmit_del20;

  function new(string name="read_word_seq20");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq20)

  constraint transmit_del_ct20 { (transmit_del20 <= 10); }
  constraint addr_ct20 {(start_addr20[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr20;
        req.direction20 == APB_READ20;
        req.transmit_delay20 == transmit_del20; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr20 = 'h%0h, req_data20 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr20 = 'h%0h, rsp_data20 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq20

// SEQUENCE20: write_word_seq20
class write_word_seq20 extends apb_master_base_seq20;
  rand bit [31:0] start_addr20;
  rand bit [31:0] write_data20;
  rand int unsigned transmit_del20;

  function new(string name="write_word_seq20");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq20)

  constraint transmit_del_ct20 { (transmit_del20 <= 10); }
  constraint addr_ct20 {(start_addr20[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr20;
        req.direction20 == APB_WRITE20;
        req.data == write_data20;
        req.transmit_delay20 == transmit_del20; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq20

// SEQUENCE20: read_after_write_seq20
class read_after_write_seq20 extends apb_master_base_seq20;

  rand bit [31:0] start_addr20;
  rand bit [31:0] write_data20;
  rand int unsigned transmit_del20;

  function new(string name="read_after_write_seq20");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq20)

  constraint transmit_del_ct20 { (transmit_del20 <= 10); }
  constraint addr_ct20 {(start_addr20[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr20;
        req.direction20 == APB_WRITE20;
        req.data == write_data20;
        req.transmit_delay20 == transmit_del20; } )
    `uvm_do_with(req, 
      { req.addr == start_addr20;
        req.direction20 == APB_READ20;
        req.transmit_delay20 == transmit_del20; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq20

// SEQUENCE20: multiple_read_after_write_seq20
class multiple_read_after_write_seq20 extends apb_master_base_seq20;

    read_after_write_seq20 raw_seq20;
    write_byte_seq20 w_seq20;
    read_byte_seq20 r_seq20;
    rand int unsigned num_of_seq20;

    function new(string name="multiple_read_after_write_seq20");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq20)

    constraint num_of_seq_c20 { num_of_seq20 <= 10; num_of_seq20 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq20; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq20)
      end
      repeat (3) `uvm_do_with(w_seq20, {transmit_del20 == 1;} )
      repeat (3) `uvm_do_with(r_seq20, {transmit_del20 == 1;} )
    endtask
endclass : multiple_read_after_write_seq20
`endif // APB_MASTER_SEQ_LIB_SV20
