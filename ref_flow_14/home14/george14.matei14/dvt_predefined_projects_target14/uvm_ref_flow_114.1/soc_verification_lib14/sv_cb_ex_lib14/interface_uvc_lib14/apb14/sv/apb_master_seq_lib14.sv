/*******************************************************************************
  FILE : apb_master_seq_lib14.sv
*******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV14
`define APB_MASTER_SEQ_LIB_SV14

//------------------------------------------------------------------------------
// SEQUENCE14: read_byte_seq14
//------------------------------------------------------------------------------
class apb_master_base_seq14 extends uvm_sequence #(apb_transfer14);
  // NOTE14: KATHLEEN14 - ALSO14 NEED14 TO HANDLE14 KILL14 HERE14??

  function new(string name="apb_master_base_seq14");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq14)
  `uvm_declare_p_sequencer(apb_master_sequencer14)

// Use a base sequence to raise/drop14 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running14 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq14

//------------------------------------------------------------------------------
// SEQUENCE14: read_byte_seq14
//------------------------------------------------------------------------------
class read_byte_seq14 extends apb_master_base_seq14;
  rand bit [31:0] start_addr14;
  rand int unsigned transmit_del14;

  function new(string name="read_byte_seq14");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq14)

  constraint transmit_del_ct14 { (transmit_del14 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr14;
        req.direction14 == APB_READ14;
        req.transmit_delay14 == transmit_del14; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr14 = 'h%0h, req_data14 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr14 = 'h%0h, rsp_data14 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq14

// SEQUENCE14: write_byte_seq14
class write_byte_seq14 extends apb_master_base_seq14;
  rand bit [31:0] start_addr14;
  rand bit [7:0] write_data14;
  rand int unsigned transmit_del14;

  function new(string name="write_byte_seq14");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq14)

  constraint transmit_del_ct14 { (transmit_del14 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr14;
        req.direction14 == APB_WRITE14;
        req.data == write_data14;
        req.transmit_delay14 == transmit_del14; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq14

//------------------------------------------------------------------------------
// SEQUENCE14: read_word_seq14
//------------------------------------------------------------------------------
class read_word_seq14 extends apb_master_base_seq14;
  rand bit [31:0] start_addr14;
  rand int unsigned transmit_del14;

  function new(string name="read_word_seq14");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq14)

  constraint transmit_del_ct14 { (transmit_del14 <= 10); }
  constraint addr_ct14 {(start_addr14[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr14;
        req.direction14 == APB_READ14;
        req.transmit_delay14 == transmit_del14; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr14 = 'h%0h, req_data14 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr14 = 'h%0h, rsp_data14 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq14

// SEQUENCE14: write_word_seq14
class write_word_seq14 extends apb_master_base_seq14;
  rand bit [31:0] start_addr14;
  rand bit [31:0] write_data14;
  rand int unsigned transmit_del14;

  function new(string name="write_word_seq14");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq14)

  constraint transmit_del_ct14 { (transmit_del14 <= 10); }
  constraint addr_ct14 {(start_addr14[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr14;
        req.direction14 == APB_WRITE14;
        req.data == write_data14;
        req.transmit_delay14 == transmit_del14; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq14

// SEQUENCE14: read_after_write_seq14
class read_after_write_seq14 extends apb_master_base_seq14;

  rand bit [31:0] start_addr14;
  rand bit [31:0] write_data14;
  rand int unsigned transmit_del14;

  function new(string name="read_after_write_seq14");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq14)

  constraint transmit_del_ct14 { (transmit_del14 <= 10); }
  constraint addr_ct14 {(start_addr14[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr14;
        req.direction14 == APB_WRITE14;
        req.data == write_data14;
        req.transmit_delay14 == transmit_del14; } )
    `uvm_do_with(req, 
      { req.addr == start_addr14;
        req.direction14 == APB_READ14;
        req.transmit_delay14 == transmit_del14; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq14

// SEQUENCE14: multiple_read_after_write_seq14
class multiple_read_after_write_seq14 extends apb_master_base_seq14;

    read_after_write_seq14 raw_seq14;
    write_byte_seq14 w_seq14;
    read_byte_seq14 r_seq14;
    rand int unsigned num_of_seq14;

    function new(string name="multiple_read_after_write_seq14");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq14)

    constraint num_of_seq_c14 { num_of_seq14 <= 10; num_of_seq14 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq14; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq14)
      end
      repeat (3) `uvm_do_with(w_seq14, {transmit_del14 == 1;} )
      repeat (3) `uvm_do_with(r_seq14, {transmit_del14 == 1;} )
    endtask
endclass : multiple_read_after_write_seq14
`endif // APB_MASTER_SEQ_LIB_SV14
