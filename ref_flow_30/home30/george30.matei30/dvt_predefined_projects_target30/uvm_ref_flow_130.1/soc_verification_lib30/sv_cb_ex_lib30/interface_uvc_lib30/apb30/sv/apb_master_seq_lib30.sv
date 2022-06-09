/*******************************************************************************
  FILE : apb_master_seq_lib30.sv
*******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV30
`define APB_MASTER_SEQ_LIB_SV30

//------------------------------------------------------------------------------
// SEQUENCE30: read_byte_seq30
//------------------------------------------------------------------------------
class apb_master_base_seq30 extends uvm_sequence #(apb_transfer30);
  // NOTE30: KATHLEEN30 - ALSO30 NEED30 TO HANDLE30 KILL30 HERE30??

  function new(string name="apb_master_base_seq30");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq30)
  `uvm_declare_p_sequencer(apb_master_sequencer30)

// Use a base sequence to raise/drop30 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running30 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq30

//------------------------------------------------------------------------------
// SEQUENCE30: read_byte_seq30
//------------------------------------------------------------------------------
class read_byte_seq30 extends apb_master_base_seq30;
  rand bit [31:0] start_addr30;
  rand int unsigned transmit_del30;

  function new(string name="read_byte_seq30");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq30)

  constraint transmit_del_ct30 { (transmit_del30 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr30;
        req.direction30 == APB_READ30;
        req.transmit_delay30 == transmit_del30; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr30 = 'h%0h, req_data30 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr30 = 'h%0h, rsp_data30 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq30

// SEQUENCE30: write_byte_seq30
class write_byte_seq30 extends apb_master_base_seq30;
  rand bit [31:0] start_addr30;
  rand bit [7:0] write_data30;
  rand int unsigned transmit_del30;

  function new(string name="write_byte_seq30");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq30)

  constraint transmit_del_ct30 { (transmit_del30 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr30;
        req.direction30 == APB_WRITE30;
        req.data == write_data30;
        req.transmit_delay30 == transmit_del30; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq30

//------------------------------------------------------------------------------
// SEQUENCE30: read_word_seq30
//------------------------------------------------------------------------------
class read_word_seq30 extends apb_master_base_seq30;
  rand bit [31:0] start_addr30;
  rand int unsigned transmit_del30;

  function new(string name="read_word_seq30");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq30)

  constraint transmit_del_ct30 { (transmit_del30 <= 10); }
  constraint addr_ct30 {(start_addr30[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr30;
        req.direction30 == APB_READ30;
        req.transmit_delay30 == transmit_del30; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr30 = 'h%0h, req_data30 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr30 = 'h%0h, rsp_data30 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq30

// SEQUENCE30: write_word_seq30
class write_word_seq30 extends apb_master_base_seq30;
  rand bit [31:0] start_addr30;
  rand bit [31:0] write_data30;
  rand int unsigned transmit_del30;

  function new(string name="write_word_seq30");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq30)

  constraint transmit_del_ct30 { (transmit_del30 <= 10); }
  constraint addr_ct30 {(start_addr30[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr30;
        req.direction30 == APB_WRITE30;
        req.data == write_data30;
        req.transmit_delay30 == transmit_del30; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq30

// SEQUENCE30: read_after_write_seq30
class read_after_write_seq30 extends apb_master_base_seq30;

  rand bit [31:0] start_addr30;
  rand bit [31:0] write_data30;
  rand int unsigned transmit_del30;

  function new(string name="read_after_write_seq30");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq30)

  constraint transmit_del_ct30 { (transmit_del30 <= 10); }
  constraint addr_ct30 {(start_addr30[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr30;
        req.direction30 == APB_WRITE30;
        req.data == write_data30;
        req.transmit_delay30 == transmit_del30; } )
    `uvm_do_with(req, 
      { req.addr == start_addr30;
        req.direction30 == APB_READ30;
        req.transmit_delay30 == transmit_del30; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq30

// SEQUENCE30: multiple_read_after_write_seq30
class multiple_read_after_write_seq30 extends apb_master_base_seq30;

    read_after_write_seq30 raw_seq30;
    write_byte_seq30 w_seq30;
    read_byte_seq30 r_seq30;
    rand int unsigned num_of_seq30;

    function new(string name="multiple_read_after_write_seq30");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq30)

    constraint num_of_seq_c30 { num_of_seq30 <= 10; num_of_seq30 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq30; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq30)
      end
      repeat (3) `uvm_do_with(w_seq30, {transmit_del30 == 1;} )
      repeat (3) `uvm_do_with(r_seq30, {transmit_del30 == 1;} )
    endtask
endclass : multiple_read_after_write_seq30
`endif // APB_MASTER_SEQ_LIB_SV30
