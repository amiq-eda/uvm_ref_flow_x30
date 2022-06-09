/*******************************************************************************
  FILE : apb_slave_seq_lib14.sv
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


`ifndef APB_SLAVE_SEQ_LIB_SV14
`define APB_SLAVE_SEQ_LIB_SV14

//------------------------------------------------------------------------------
// SEQUENCE14: simple_response_seq14
//------------------------------------------------------------------------------

class simple_response_seq14 extends uvm_sequence #(apb_transfer14);

  function new(string name="simple_response_seq14");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq14)
  `uvm_declare_p_sequencer(apb_slave_sequencer14)

  apb_transfer14 req;
  apb_transfer14 util_transfer14;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port14.peek(util_transfer14);
      if((util_transfer14.direction14 == APB_READ14) && 
        (p_sequencer.cfg.check_address_range14(util_transfer14.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range14 Matching14 read.  Responding14...", util_transfer14.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction14 == APB_READ14; } )
      end
    end
  endtask : body

endclass : simple_response_seq14

//------------------------------------------------------------------------------
// SEQUENCE14: mem_response_seq14
//------------------------------------------------------------------------------
class mem_response_seq14 extends uvm_sequence #(apb_transfer14);

  function new(string name="mem_response_seq14");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data14;

  `uvm_object_utils(mem_response_seq14)
  `uvm_declare_p_sequencer(apb_slave_sequencer14)

  //simple14 assoc14 array to hold14 values
  logic [31:0] slave_mem14[int];

  apb_transfer14 req;
  apb_transfer14 util_transfer14;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port14.peek(util_transfer14);
      if((util_transfer14.direction14 == APB_READ14) && 
        (p_sequencer.cfg.check_address_range14(util_transfer14.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range14 Matching14 APB_READ14.  Responding14...", util_transfer14.addr), UVM_MEDIUM);
        if (slave_mem14.exists(util_transfer14.addr))
        `uvm_do_with(req, { req.direction14 == APB_READ14;
                            req.addr == util_transfer14.addr;
                            req.data == slave_mem14[util_transfer14.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction14 == APB_READ14;
                            req.addr == util_transfer14.addr;
                            req.data == mem_data14; } )
         mem_data14++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range14(util_transfer14.addr) == 1) begin
        slave_mem14[util_transfer14.addr] = util_transfer14.data;
        // DUMMY14 response with same information
        `uvm_do_with(req, { req.direction14 == APB_WRITE14;
                            req.addr == util_transfer14.addr;
                            req.data == util_transfer14.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq14

`endif // APB_SLAVE_SEQ_LIB_SV14
