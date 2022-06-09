/*******************************************************************************
  FILE : apb_master_seq_lib6.sv
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_MASTER_SEQ_LIB_SV6
`define APB_MASTER_SEQ_LIB_SV6

//------------------------------------------------------------------------------
// SEQUENCE6: read_byte_seq6
//------------------------------------------------------------------------------
class apb_master_base_seq6 extends uvm_sequence #(apb_transfer6);
  // NOTE6: KATHLEEN6 - ALSO6 NEED6 TO HANDLE6 KILL6 HERE6??

  function new(string name="apb_master_base_seq6");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq6)
  `uvm_declare_p_sequencer(apb_master_sequencer6)

// Use a base sequence to raise/drop6 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running6 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : apb_master_base_seq6

//------------------------------------------------------------------------------
// SEQUENCE6: read_byte_seq6
//------------------------------------------------------------------------------
class read_byte_seq6 extends apb_master_base_seq6;
  rand bit [31:0] start_addr6;
  rand int unsigned transmit_del6;

  function new(string name="read_byte_seq6");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq6)

  constraint transmit_del_ct6 { (transmit_del6 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr6;
        req.direction6 == APB_READ6;
        req.transmit_delay6 == transmit_del6; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr6 = 'h%0h, req_data6 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr6 = 'h%0h, rsp_data6 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq6

// SEQUENCE6: write_byte_seq6
class write_byte_seq6 extends apb_master_base_seq6;
  rand bit [31:0] start_addr6;
  rand bit [7:0] write_data6;
  rand int unsigned transmit_del6;

  function new(string name="write_byte_seq6");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq6)

  constraint transmit_del_ct6 { (transmit_del6 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr6;
        req.direction6 == APB_WRITE6;
        req.data == write_data6;
        req.transmit_delay6 == transmit_del6; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq6

//------------------------------------------------------------------------------
// SEQUENCE6: read_word_seq6
//------------------------------------------------------------------------------
class read_word_seq6 extends apb_master_base_seq6;
  rand bit [31:0] start_addr6;
  rand int unsigned transmit_del6;

  function new(string name="read_word_seq6");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq6)

  constraint transmit_del_ct6 { (transmit_del6 <= 10); }
  constraint addr_ct6 {(start_addr6[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr6;
        req.direction6 == APB_READ6;
        req.transmit_delay6 == transmit_del6; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr6 = 'h%0h, req_data6 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr6 = 'h%0h, rsp_data6 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq6

// SEQUENCE6: write_word_seq6
class write_word_seq6 extends apb_master_base_seq6;
  rand bit [31:0] start_addr6;
  rand bit [31:0] write_data6;
  rand int unsigned transmit_del6;

  function new(string name="write_word_seq6");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq6)

  constraint transmit_del_ct6 { (transmit_del6 <= 10); }
  constraint addr_ct6 {(start_addr6[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr6;
        req.direction6 == APB_WRITE6;
        req.data == write_data6;
        req.transmit_delay6 == transmit_del6; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq6

// SEQUENCE6: read_after_write_seq6
class read_after_write_seq6 extends apb_master_base_seq6;

  rand bit [31:0] start_addr6;
  rand bit [31:0] write_data6;
  rand int unsigned transmit_del6;

  function new(string name="read_after_write_seq6");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq6)

  constraint transmit_del_ct6 { (transmit_del6 <= 10); }
  constraint addr_ct6 {(start_addr6[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr6;
        req.direction6 == APB_WRITE6;
        req.data == write_data6;
        req.transmit_delay6 == transmit_del6; } )
    `uvm_do_with(req, 
      { req.addr == start_addr6;
        req.direction6 == APB_READ6;
        req.transmit_delay6 == transmit_del6; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq6

// SEQUENCE6: multiple_read_after_write_seq6
class multiple_read_after_write_seq6 extends apb_master_base_seq6;

    read_after_write_seq6 raw_seq6;
    write_byte_seq6 w_seq6;
    read_byte_seq6 r_seq6;
    rand int unsigned num_of_seq6;

    function new(string name="multiple_read_after_write_seq6");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq6)

    constraint num_of_seq_c6 { num_of_seq6 <= 10; num_of_seq6 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq6; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq6)
      end
      repeat (3) `uvm_do_with(w_seq6, {transmit_del6 == 1;} )
      repeat (3) `uvm_do_with(r_seq6, {transmit_del6 == 1;} )
    endtask
endclass : multiple_read_after_write_seq6
`endif // APB_MASTER_SEQ_LIB_SV6
