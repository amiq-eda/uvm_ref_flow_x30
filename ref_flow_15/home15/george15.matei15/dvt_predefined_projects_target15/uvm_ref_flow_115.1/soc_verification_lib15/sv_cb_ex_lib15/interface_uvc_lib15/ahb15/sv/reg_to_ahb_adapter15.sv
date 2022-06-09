/*-------------------------------------------------------------------------
File15 name   : reg_to_ahb_adapter15.sv
Title15       : Register Operations15 to AHB15 Transactions15 Adapter Sequence
Project15     :
Created15     :
Description15 : UVM_REG - Adapter Sequence converts15 UVM register operations15
            : to AHB15 bus transactions
Notes15       : This15 example15 does not provide15 any random transfer15 delay
            : for the transaction.  This15 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright15 1999-2011 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

class reg_to_ahb_adapter15 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter15)

  function new(string name="reg_to_ahb_adapter15");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer15 transfer15;
    transfer15 = ahb_transfer15::type_id::create("transfer15");
    transfer15.address = rw.addr;
    transfer15.data = rw.data;
    transfer15.direction15 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer15);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer15 transfer15;
    if (!$cast(transfer15, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE15",
       "Provided bus_item is not of the correct15 type. Expecting15 ahb_transfer15")
       return;
    end
    rw.kind =  (transfer15.direction15 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer15.address;
    rw.data = transfer15.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter15
