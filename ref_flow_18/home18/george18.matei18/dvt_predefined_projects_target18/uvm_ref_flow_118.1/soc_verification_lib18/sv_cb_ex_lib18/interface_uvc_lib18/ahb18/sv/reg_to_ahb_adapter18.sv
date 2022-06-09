/*-------------------------------------------------------------------------
File18 name   : reg_to_ahb_adapter18.sv
Title18       : Register Operations18 to AHB18 Transactions18 Adapter Sequence
Project18     :
Created18     :
Description18 : UVM_REG - Adapter Sequence converts18 UVM register operations18
            : to AHB18 bus transactions
Notes18       : This18 example18 does not provide18 any random transfer18 delay
            : for the transaction.  This18 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright18 1999-2011 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

class reg_to_ahb_adapter18 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter18)

  function new(string name="reg_to_ahb_adapter18");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer18 transfer18;
    transfer18 = ahb_transfer18::type_id::create("transfer18");
    transfer18.address = rw.addr;
    transfer18.data = rw.data;
    transfer18.direction18 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer18);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer18 transfer18;
    if (!$cast(transfer18, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE18",
       "Provided bus_item is not of the correct18 type. Expecting18 ahb_transfer18")
       return;
    end
    rw.kind =  (transfer18.direction18 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer18.address;
    rw.data = transfer18.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter18
