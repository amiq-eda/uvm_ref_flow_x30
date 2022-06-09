/*******************************************************************************
  FILE : apb_master_seq_lib4.sv
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV4
`define APB_MASTER_SEQ_LIB_SV4

//------------------------------------------------------------------------------
// SEQUENCE4: read_byte_seq4
//------------------------------------------------------------------------------
class apb_master_base_seq4 extends uvm_sequence #(apb_transfer4);
  // NOTE4: KATHLEEN4 - ALSO4 NEED4 TO HANDLE4 KILL4 HERE4??

  function new(string name="apb_master_base_seq4");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq4)
  `uvm_declare_p_sequencer(apb_master_sequencer4)

// Use a base sequence to raise/drop4 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running4 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq4

//------------------------------------------------------------------------------
// SEQUENCE4: read_byte_seq4
//------------------------------------------------------------------------------
class read_byte_seq4 extends apb_master_base_seq4;
  rand bit [31:0] start_addr4;
  rand int unsigned transmit_del4;

  function new(string name="read_byte_seq4");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq4)

  constraint transmit_del_ct4 { (transmit_del4 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr4;
        req.direction4 == APB_READ4;
        req.transmit_delay4 == transmit_del4; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr4 = 'h%0h, req_data4 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr4 = 'h%0h, rsp_data4 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq4

// SEQUENCE4: write_byte_seq4
class write_byte_seq4 extends apb_master_base_seq4;
  rand bit [31:0] start_addr4;
  rand bit [7:0] write_data4;
  rand int unsigned transmit_del4;

  function new(string name="write_byte_seq4");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq4)

  constraint transmit_del_ct4 { (transmit_del4 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr4;
        req.direction4 == APB_WRITE4;
        req.data == write_data4;
        req.transmit_delay4 == transmit_del4; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq4

//------------------------------------------------------------------------------
// SEQUENCE4: read_word_seq4
//------------------------------------------------------------------------------
class read_word_seq4 extends apb_master_base_seq4;
  rand bit [31:0] start_addr4;
  rand int unsigned transmit_del4;

  function new(string name="read_word_seq4");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq4)

  constraint transmit_del_ct4 { (transmit_del4 <= 10); }
  constraint addr_ct4 {(start_addr4[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr4;
        req.direction4 == APB_READ4;
        req.transmit_delay4 == transmit_del4; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr4 = 'h%0h, req_data4 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr4 = 'h%0h, rsp_data4 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq4

// SEQUENCE4: write_word_seq4
class write_word_seq4 extends apb_master_base_seq4;
  rand bit [31:0] start_addr4;
  rand bit [31:0] write_data4;
  rand int unsigned transmit_del4;

  function new(string name="write_word_seq4");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq4)

  constraint transmit_del_ct4 { (transmit_del4 <= 10); }
  constraint addr_ct4 {(start_addr4[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr4;
        req.direction4 == APB_WRITE4;
        req.data == write_data4;
        req.transmit_delay4 == transmit_del4; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq4

// SEQUENCE4: read_after_write_seq4
class read_after_write_seq4 extends apb_master_base_seq4;

  rand bit [31:0] start_addr4;
  rand bit [31:0] write_data4;
  rand int unsigned transmit_del4;

  function new(string name="read_after_write_seq4");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq4)

  constraint transmit_del_ct4 { (transmit_del4 <= 10); }
  constraint addr_ct4 {(start_addr4[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr4;
        req.direction4 == APB_WRITE4;
        req.data == write_data4;
        req.transmit_delay4 == transmit_del4; } )
    `uvm_do_with(req, 
      { req.addr == start_addr4;
        req.direction4 == APB_READ4;
        req.transmit_delay4 == transmit_del4; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq4

// SEQUENCE4: multiple_read_after_write_seq4
class multiple_read_after_write_seq4 extends apb_master_base_seq4;

    read_after_write_seq4 raw_seq4;
    write_byte_seq4 w_seq4;
    read_byte_seq4 r_seq4;
    rand int unsigned num_of_seq4;

    function new(string name="multiple_read_after_write_seq4");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq4)

    constraint num_of_seq_c4 { num_of_seq4 <= 10; num_of_seq4 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq4; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq4)
      end
      repeat (3) `uvm_do_with(w_seq4, {transmit_del4 == 1;} )
      repeat (3) `uvm_do_with(r_seq4, {transmit_del4 == 1;} )
    endtask
endclass : multiple_read_after_write_seq4
`endif // APB_MASTER_SEQ_LIB_SV4
