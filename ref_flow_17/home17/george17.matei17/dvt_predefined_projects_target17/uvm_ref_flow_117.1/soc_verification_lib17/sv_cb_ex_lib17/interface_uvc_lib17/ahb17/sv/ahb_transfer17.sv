// IVB17 checksum17: 2173772784
/*-----------------------------------------------------------------
File17 name     : ahb_transfer17.sv
Created17       : Wed17 May17 19 15:42:20 2010
Description17   :  This17 file declares17 the OVC17 transfer17. It is
              :  used by both master17 and slave17.
Notes17         :
-----------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV17
`define AHB_TRANSFER_SV17

//------------------------------------------------------------------------------
//
// ahb17 transfer17 enums17, parameters17, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE17 = 0,
		HALFWORD17 = 1,
		WORD17 = 2,
		TWO_WORDS17 = 3,
		FOUR_WORDS17 = 4,
		EIGHT_WORDS17 = 5,
		SIXTEEN_WORDS17 = 6,
		K_BITS17 = 7
} ahb_transfer_size17;
typedef enum logic[1:0]  {
		IDLE17 = 0,
		BUSY17 = 1,
		NONSEQ17 = 2,
		SEQ = 3
} ahb_transfer_kind17;
typedef enum logic[1:0]  {
		OKAY17 = 0,
		ERROR17 = 1,
		RETRY17 = 2,
		SPLIT17 = 3
} ahb_response_kind17;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction17;
typedef enum logic[2:0]  {
		SINGLE17 = 0,
		INCR = 1,
		WRAP417 = 2,
		INCR417 = 3,
		WRAP817 = 4,
		INCR817 = 5,
		WRAP1617 = 6,
		INCR1617 = 7
} ahb_burst_kind17;
 
//------------------------------------------------------------------------------
//
// CLASS17: ahb_transfer17
//
//------------------------------------------------------------------------------

class ahb_transfer17 extends uvm_sequence_item;

  /***************************************************************************
   IVB17-NOTE17 : REQUIRED17 : transfer17 definitions17 : Item17 definitions17
   ---------------------------------------------------------------------------
   Adjust17 the transfer17 attribute17 names as required17 and add any 
   necessary17 attributes17.
   Note17 that if you change an attribute17 name, you must change it in all of your17
   OVC17 files.
   Make17 sure17 to edit17 the uvm_object_utils_begin to get various17 utilities17 (like17
   print and copy) for each attribute17 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH17-1:0] data;
  rand logic [`AHB_ADDR_WIDTH17-1:0] address;
  rand ahb_direction17 direction17 ;
  rand ahb_transfer_size17  hsize17;
  rand ahb_burst_kind17  burst;
  rand logic [3:0] prot17 ;
 
  `uvm_object_utils_begin(ahb_transfer17)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction17,direction17, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size17,hsize17, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind17,burst, UVM_ALL_ON)
    `uvm_field_int(prot17, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor17 - required17 syntax17 for UVM automation17 and utilities17
  function new (string name = "unnamed17-ahb_transfer17");
    super.new(name);
  endfunction : new

endclass : ahb_transfer17

`endif // AHB_TRANSFER_SV17

