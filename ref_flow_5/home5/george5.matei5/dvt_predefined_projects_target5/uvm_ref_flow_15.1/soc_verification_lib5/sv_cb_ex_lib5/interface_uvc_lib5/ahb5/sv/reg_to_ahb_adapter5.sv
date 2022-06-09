/*-------------------------------------------------------------------------
File5 name   : reg_to_ahb_adapter5.sv
Title5       : Register Operations5 to AHB5 Transactions5 Adapter Sequence
Project5     :
Created5     :
Description5 : UVM_REG - Adapter Sequence converts5 UVM register operations5
            : to AHB5 bus transactions
Notes5       : This5 example5 does not provide5 any random transfer5 delay
            : for the transaction.  This5 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright5 1999-2011 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

class reg_to_ahb_adapter5 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter5)

  function new(string name="reg_to_ahb_adapter5");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer5 transfer5;
    transfer5 = ahb_transfer5::type_id::create("transfer5");
    transfer5.address = rw.addr;
    transfer5.data = rw.data;
    transfer5.direction5 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer5);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer5 transfer5;
    if (!$cast(transfer5, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE5",
       "Provided bus_item is not of the correct5 type. Expecting5 ahb_transfer5")
       return;
    end
    rw.kind =  (transfer5.direction5 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer5.address;
    rw.data = transfer5.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter5
