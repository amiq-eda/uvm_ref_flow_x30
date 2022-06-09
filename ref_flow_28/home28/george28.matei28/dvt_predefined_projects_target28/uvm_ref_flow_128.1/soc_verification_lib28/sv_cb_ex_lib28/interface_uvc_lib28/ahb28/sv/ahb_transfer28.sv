// IVB28 checksum28: 2173772784
/*-----------------------------------------------------------------
File28 name     : ahb_transfer28.sv
Created28       : Wed28 May28 19 15:42:20 2010
Description28   :  This28 file declares28 the OVC28 transfer28. It is
              :  used by both master28 and slave28.
Notes28         :
-----------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV28
`define AHB_TRANSFER_SV28

//------------------------------------------------------------------------------
//
// ahb28 transfer28 enums28, parameters28, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE28 = 0,
		HALFWORD28 = 1,
		WORD28 = 2,
		TWO_WORDS28 = 3,
		FOUR_WORDS28 = 4,
		EIGHT_WORDS28 = 5,
		SIXTEEN_WORDS28 = 6,
		K_BITS28 = 7
} ahb_transfer_size28;
typedef enum logic[1:0]  {
		IDLE28 = 0,
		BUSY28 = 1,
		NONSEQ28 = 2,
		SEQ = 3
} ahb_transfer_kind28;
typedef enum logic[1:0]  {
		OKAY28 = 0,
		ERROR28 = 1,
		RETRY28 = 2,
		SPLIT28 = 3
} ahb_response_kind28;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction28;
typedef enum logic[2:0]  {
		SINGLE28 = 0,
		INCR = 1,
		WRAP428 = 2,
		INCR428 = 3,
		WRAP828 = 4,
		INCR828 = 5,
		WRAP1628 = 6,
		INCR1628 = 7
} ahb_burst_kind28;
 
//------------------------------------------------------------------------------
//
// CLASS28: ahb_transfer28
//
//------------------------------------------------------------------------------

class ahb_transfer28 extends uvm_sequence_item;

  /***************************************************************************
   IVB28-NOTE28 : REQUIRED28 : transfer28 definitions28 : Item28 definitions28
   ---------------------------------------------------------------------------
   Adjust28 the transfer28 attribute28 names as required28 and add any 
   necessary28 attributes28.
   Note28 that if you change an attribute28 name, you must change it in all of your28
   OVC28 files.
   Make28 sure28 to edit28 the uvm_object_utils_begin to get various28 utilities28 (like28
   print and copy) for each attribute28 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH28-1:0] data;
  rand logic [`AHB_ADDR_WIDTH28-1:0] address;
  rand ahb_direction28 direction28 ;
  rand ahb_transfer_size28  hsize28;
  rand ahb_burst_kind28  burst;
  rand logic [3:0] prot28 ;
 
  `uvm_object_utils_begin(ahb_transfer28)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction28,direction28, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size28,hsize28, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind28,burst, UVM_ALL_ON)
    `uvm_field_int(prot28, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor28 - required28 syntax28 for UVM automation28 and utilities28
  function new (string name = "unnamed28-ahb_transfer28");
    super.new(name);
  endfunction : new

endclass : ahb_transfer28

`endif // AHB_TRANSFER_SV28

