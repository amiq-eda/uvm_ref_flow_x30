/*-------------------------------------------------------------------------
File27 name   : reg_to_ahb_adapter27.sv
Title27       : Register Operations27 to AHB27 Transactions27 Adapter Sequence
Project27     :
Created27     :
Description27 : UVM_REG - Adapter Sequence converts27 UVM register operations27
            : to AHB27 bus transactions
Notes27       : This27 example27 does not provide27 any random transfer27 delay
            : for the transaction.  This27 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright27 1999-2011 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

class reg_to_ahb_adapter27 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter27)

  function new(string name="reg_to_ahb_adapter27");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer27 transfer27;
    transfer27 = ahb_transfer27::type_id::create("transfer27");
    transfer27.address = rw.addr;
    transfer27.data = rw.data;
    transfer27.direction27 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer27);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer27 transfer27;
    if (!$cast(transfer27, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE27",
       "Provided bus_item is not of the correct27 type. Expecting27 ahb_transfer27")
       return;
    end
    rw.kind =  (transfer27.direction27 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer27.address;
    rw.data = transfer27.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter27
