/*******************************************************************************
  FILE : apb_slave_seq_lib4.sv
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


`ifndef APB_SLAVE_SEQ_LIB_SV4
`define APB_SLAVE_SEQ_LIB_SV4

//------------------------------------------------------------------------------
// SEQUENCE4: simple_response_seq4
//------------------------------------------------------------------------------

class simple_response_seq4 extends uvm_sequence #(apb_transfer4);

  function new(string name="simple_response_seq4");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq4)
  `uvm_declare_p_sequencer(apb_slave_sequencer4)

  apb_transfer4 req;
  apb_transfer4 util_transfer4;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port4.peek(util_transfer4);
      if((util_transfer4.direction4 == APB_READ4) && 
        (p_sequencer.cfg.check_address_range4(util_transfer4.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range4 Matching4 read.  Responding4...", util_transfer4.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction4 == APB_READ4; } )
      end
    end
  endtask : body

endclass : simple_response_seq4

//------------------------------------------------------------------------------
// SEQUENCE4: mem_response_seq4
//------------------------------------------------------------------------------
class mem_response_seq4 extends uvm_sequence #(apb_transfer4);

  function new(string name="mem_response_seq4");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data4;

  `uvm_object_utils(mem_response_seq4)
  `uvm_declare_p_sequencer(apb_slave_sequencer4)

  //simple4 assoc4 array to hold4 values
  logic [31:0] slave_mem4[int];

  apb_transfer4 req;
  apb_transfer4 util_transfer4;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port4.peek(util_transfer4);
      if((util_transfer4.direction4 == APB_READ4) && 
        (p_sequencer.cfg.check_address_range4(util_transfer4.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range4 Matching4 APB_READ4.  Responding4...", util_transfer4.addr), UVM_MEDIUM);
        if (slave_mem4.exists(util_transfer4.addr))
        `uvm_do_with(req, { req.direction4 == APB_READ4;
                            req.addr == util_transfer4.addr;
                            req.data == slave_mem4[util_transfer4.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction4 == APB_READ4;
                            req.addr == util_transfer4.addr;
                            req.data == mem_data4; } )
         mem_data4++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range4(util_transfer4.addr) == 1) begin
        slave_mem4[util_transfer4.addr] = util_transfer4.data;
        // DUMMY4 response with same information
        `uvm_do_with(req, { req.direction4 == APB_WRITE4;
                            req.addr == util_transfer4.addr;
                            req.data == util_transfer4.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq4

`endif // APB_SLAVE_SEQ_LIB_SV4
