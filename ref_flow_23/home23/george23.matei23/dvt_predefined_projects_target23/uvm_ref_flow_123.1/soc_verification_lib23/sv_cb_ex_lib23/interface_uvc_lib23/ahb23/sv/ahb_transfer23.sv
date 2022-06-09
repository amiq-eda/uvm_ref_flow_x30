// IVB23 checksum23: 2173772784
/*-----------------------------------------------------------------
File23 name     : ahb_transfer23.sv
Created23       : Wed23 May23 19 15:42:20 2010
Description23   :  This23 file declares23 the OVC23 transfer23. It is
              :  used by both master23 and slave23.
Notes23         :
-----------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV23
`define AHB_TRANSFER_SV23

//------------------------------------------------------------------------------
//
// ahb23 transfer23 enums23, parameters23, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE23 = 0,
		HALFWORD23 = 1,
		WORD23 = 2,
		TWO_WORDS23 = 3,
		FOUR_WORDS23 = 4,
		EIGHT_WORDS23 = 5,
		SIXTEEN_WORDS23 = 6,
		K_BITS23 = 7
} ahb_transfer_size23;
typedef enum logic[1:0]  {
		IDLE23 = 0,
		BUSY23 = 1,
		NONSEQ23 = 2,
		SEQ = 3
} ahb_transfer_kind23;
typedef enum logic[1:0]  {
		OKAY23 = 0,
		ERROR23 = 1,
		RETRY23 = 2,
		SPLIT23 = 3
} ahb_response_kind23;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction23;
typedef enum logic[2:0]  {
		SINGLE23 = 0,
		INCR = 1,
		WRAP423 = 2,
		INCR423 = 3,
		WRAP823 = 4,
		INCR823 = 5,
		WRAP1623 = 6,
		INCR1623 = 7
} ahb_burst_kind23;
 
//------------------------------------------------------------------------------
//
// CLASS23: ahb_transfer23
//
//------------------------------------------------------------------------------

class ahb_transfer23 extends uvm_sequence_item;

  /***************************************************************************
   IVB23-NOTE23 : REQUIRED23 : transfer23 definitions23 : Item23 definitions23
   ---------------------------------------------------------------------------
   Adjust23 the transfer23 attribute23 names as required23 and add any 
   necessary23 attributes23.
   Note23 that if you change an attribute23 name, you must change it in all of your23
   OVC23 files.
   Make23 sure23 to edit23 the uvm_object_utils_begin to get various23 utilities23 (like23
   print and copy) for each attribute23 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH23-1:0] data;
  rand logic [`AHB_ADDR_WIDTH23-1:0] address;
  rand ahb_direction23 direction23 ;
  rand ahb_transfer_size23  hsize23;
  rand ahb_burst_kind23  burst;
  rand logic [3:0] prot23 ;
 
  `uvm_object_utils_begin(ahb_transfer23)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction23,direction23, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size23,hsize23, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind23,burst, UVM_ALL_ON)
    `uvm_field_int(prot23, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor23 - required23 syntax23 for UVM automation23 and utilities23
  function new (string name = "unnamed23-ahb_transfer23");
    super.new(name);
  endfunction : new

endclass : ahb_transfer23

`endif // AHB_TRANSFER_SV23

