/*******************************************************************************
  FILE : apb_master_seq_lib19.sv
*******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV19
`define APB_MASTER_SEQ_LIB_SV19

//------------------------------------------------------------------------------
// SEQUENCE19: read_byte_seq19
//------------------------------------------------------------------------------
class apb_master_base_seq19 extends uvm_sequence #(apb_transfer19);
  // NOTE19: KATHLEEN19 - ALSO19 NEED19 TO HANDLE19 KILL19 HERE19??

  function new(string name="apb_master_base_seq19");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq19)
  `uvm_declare_p_sequencer(apb_master_sequencer19)

// Use a base sequence to raise/drop19 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running19 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq19

//------------------------------------------------------------------------------
// SEQUENCE19: read_byte_seq19
//------------------------------------------------------------------------------
class read_byte_seq19 extends apb_master_base_seq19;
  rand bit [31:0] start_addr19;
  rand int unsigned transmit_del19;

  function new(string name="read_byte_seq19");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq19)

  constraint transmit_del_ct19 { (transmit_del19 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr19;
        req.direction19 == APB_READ19;
        req.transmit_delay19 == transmit_del19; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr19 = 'h%0h, req_data19 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr19 = 'h%0h, rsp_data19 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq19

// SEQUENCE19: write_byte_seq19
class write_byte_seq19 extends apb_master_base_seq19;
  rand bit [31:0] start_addr19;
  rand bit [7:0] write_data19;
  rand int unsigned transmit_del19;

  function new(string name="write_byte_seq19");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq19)

  constraint transmit_del_ct19 { (transmit_del19 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr19;
        req.direction19 == APB_WRITE19;
        req.data == write_data19;
        req.transmit_delay19 == transmit_del19; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq19

//------------------------------------------------------------------------------
// SEQUENCE19: read_word_seq19
//------------------------------------------------------------------------------
class read_word_seq19 extends apb_master_base_seq19;
  rand bit [31:0] start_addr19;
  rand int unsigned transmit_del19;

  function new(string name="read_word_seq19");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq19)

  constraint transmit_del_ct19 { (transmit_del19 <= 10); }
  constraint addr_ct19 {(start_addr19[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr19;
        req.direction19 == APB_READ19;
        req.transmit_delay19 == transmit_del19; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr19 = 'h%0h, req_data19 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr19 = 'h%0h, rsp_data19 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq19

// SEQUENCE19: write_word_seq19
class write_word_seq19 extends apb_master_base_seq19;
  rand bit [31:0] start_addr19;
  rand bit [31:0] write_data19;
  rand int unsigned transmit_del19;

  function new(string name="write_word_seq19");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq19)

  constraint transmit_del_ct19 { (transmit_del19 <= 10); }
  constraint addr_ct19 {(start_addr19[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr19;
        req.direction19 == APB_WRITE19;
        req.data == write_data19;
        req.transmit_delay19 == transmit_del19; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq19

// SEQUENCE19: read_after_write_seq19
class read_after_write_seq19 extends apb_master_base_seq19;

  rand bit [31:0] start_addr19;
  rand bit [31:0] write_data19;
  rand int unsigned transmit_del19;

  function new(string name="read_after_write_seq19");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq19)

  constraint transmit_del_ct19 { (transmit_del19 <= 10); }
  constraint addr_ct19 {(start_addr19[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr19;
        req.direction19 == APB_WRITE19;
        req.data == write_data19;
        req.transmit_delay19 == transmit_del19; } )
    `uvm_do_with(req, 
      { req.addr == start_addr19;
        req.direction19 == APB_READ19;
        req.transmit_delay19 == transmit_del19; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq19

// SEQUENCE19: multiple_read_after_write_seq19
class multiple_read_after_write_seq19 extends apb_master_base_seq19;

    read_after_write_seq19 raw_seq19;
    write_byte_seq19 w_seq19;
    read_byte_seq19 r_seq19;
    rand int unsigned num_of_seq19;

    function new(string name="multiple_read_after_write_seq19");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq19)

    constraint num_of_seq_c19 { num_of_seq19 <= 10; num_of_seq19 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq19; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq19)
      end
      repeat (3) `uvm_do_with(w_seq19, {transmit_del19 == 1;} )
      repeat (3) `uvm_do_with(r_seq19, {transmit_del19 == 1;} )
    endtask
endclass : multiple_read_after_write_seq19
`endif // APB_MASTER_SEQ_LIB_SV19
