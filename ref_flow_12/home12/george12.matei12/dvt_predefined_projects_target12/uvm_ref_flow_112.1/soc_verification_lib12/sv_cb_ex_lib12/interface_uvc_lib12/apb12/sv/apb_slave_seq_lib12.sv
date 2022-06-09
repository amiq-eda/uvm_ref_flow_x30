/*******************************************************************************
  FILE : apb_slave_seq_lib12.sv
*******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV12
`define APB_SLAVE_SEQ_LIB_SV12

//------------------------------------------------------------------------------
// SEQUENCE12: simple_response_seq12
//------------------------------------------------------------------------------

class simple_response_seq12 extends uvm_sequence #(apb_transfer12);

  function new(string name="simple_response_seq12");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq12)
  `uvm_declare_p_sequencer(apb_slave_sequencer12)

  apb_transfer12 req;
  apb_transfer12 util_transfer12;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port12.peek(util_transfer12);
      if((util_transfer12.direction12 == APB_READ12) && 
        (p_sequencer.cfg.check_address_range12(util_transfer12.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range12 Matching12 read.  Responding12...", util_transfer12.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction12 == APB_READ12; } )
      end
    end
  endtask : body

endclass : simple_response_seq12

//------------------------------------------------------------------------------
// SEQUENCE12: mem_response_seq12
//------------------------------------------------------------------------------
class mem_response_seq12 extends uvm_sequence #(apb_transfer12);

  function new(string name="mem_response_seq12");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data12;

  `uvm_object_utils(mem_response_seq12)
  `uvm_declare_p_sequencer(apb_slave_sequencer12)

  //simple12 assoc12 array to hold12 values
  logic [31:0] slave_mem12[int];

  apb_transfer12 req;
  apb_transfer12 util_transfer12;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port12.peek(util_transfer12);
      if((util_transfer12.direction12 == APB_READ12) && 
        (p_sequencer.cfg.check_address_range12(util_transfer12.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range12 Matching12 APB_READ12.  Responding12...", util_transfer12.addr), UVM_MEDIUM);
        if (slave_mem12.exists(util_transfer12.addr))
        `uvm_do_with(req, { req.direction12 == APB_READ12;
                            req.addr == util_transfer12.addr;
                            req.data == slave_mem12[util_transfer12.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction12 == APB_READ12;
                            req.addr == util_transfer12.addr;
                            req.data == mem_data12; } )
         mem_data12++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range12(util_transfer12.addr) == 1) begin
        slave_mem12[util_transfer12.addr] = util_transfer12.data;
        // DUMMY12 response with same information
        `uvm_do_with(req, { req.direction12 == APB_WRITE12;
                            req.addr == util_transfer12.addr;
                            req.data == util_transfer12.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq12

`endif // APB_SLAVE_SEQ_LIB_SV12
