/*-------------------------------------------------------------------------
File3 name   : reg_to_ahb_adapter3.sv
Title3       : Register Operations3 to AHB3 Transactions3 Adapter Sequence
Project3     :
Created3     :
Description3 : UVM_REG - Adapter Sequence converts3 UVM register operations3
            : to AHB3 bus transactions
Notes3       : This3 example3 does not provide3 any random transfer3 delay
            : for the transaction.  This3 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright3 1999-2011 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

class reg_to_ahb_adapter3 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter3)

  function new(string name="reg_to_ahb_adapter3");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer3 transfer3;
    transfer3 = ahb_transfer3::type_id::create("transfer3");
    transfer3.address = rw.addr;
    transfer3.data = rw.data;
    transfer3.direction3 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer3);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer3 transfer3;
    if (!$cast(transfer3, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE3",
       "Provided bus_item is not of the correct3 type. Expecting3 ahb_transfer3")
       return;
    end
    rw.kind =  (transfer3.direction3 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer3.address;
    rw.data = transfer3.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter3
