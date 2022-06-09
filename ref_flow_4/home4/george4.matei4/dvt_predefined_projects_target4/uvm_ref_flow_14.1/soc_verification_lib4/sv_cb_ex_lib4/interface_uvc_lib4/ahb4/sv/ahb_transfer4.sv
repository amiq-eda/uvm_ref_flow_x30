// IVB4 checksum4: 2173772784
/*-----------------------------------------------------------------
File4 name     : ahb_transfer4.sv
Created4       : Wed4 May4 19 15:42:20 2010
Description4   :  This4 file declares4 the OVC4 transfer4. It is
              :  used by both master4 and slave4.
Notes4         :
-----------------------------------------------------------------*/
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


`ifndef AHB_TRANSFER_SV4
`define AHB_TRANSFER_SV4

//------------------------------------------------------------------------------
//
// ahb4 transfer4 enums4, parameters4, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE4 = 0,
		HALFWORD4 = 1,
		WORD4 = 2,
		TWO_WORDS4 = 3,
		FOUR_WORDS4 = 4,
		EIGHT_WORDS4 = 5,
		SIXTEEN_WORDS4 = 6,
		K_BITS4 = 7
} ahb_transfer_size4;
typedef enum logic[1:0]  {
		IDLE4 = 0,
		BUSY4 = 1,
		NONSEQ4 = 2,
		SEQ = 3
} ahb_transfer_kind4;
typedef enum logic[1:0]  {
		OKAY4 = 0,
		ERROR4 = 1,
		RETRY4 = 2,
		SPLIT4 = 3
} ahb_response_kind4;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction4;
typedef enum logic[2:0]  {
		SINGLE4 = 0,
		INCR = 1,
		WRAP44 = 2,
		INCR44 = 3,
		WRAP84 = 4,
		INCR84 = 5,
		WRAP164 = 6,
		INCR164 = 7
} ahb_burst_kind4;
 
//------------------------------------------------------------------------------
//
// CLASS4: ahb_transfer4
//
//------------------------------------------------------------------------------

class ahb_transfer4 extends uvm_sequence_item;

  /***************************************************************************
   IVB4-NOTE4 : REQUIRED4 : transfer4 definitions4 : Item4 definitions4
   ---------------------------------------------------------------------------
   Adjust4 the transfer4 attribute4 names as required4 and add any 
   necessary4 attributes4.
   Note4 that if you change an attribute4 name, you must change it in all of your4
   OVC4 files.
   Make4 sure4 to edit4 the uvm_object_utils_begin to get various4 utilities4 (like4
   print and copy) for each attribute4 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH4-1:0] data;
  rand logic [`AHB_ADDR_WIDTH4-1:0] address;
  rand ahb_direction4 direction4 ;
  rand ahb_transfer_size4  hsize4;
  rand ahb_burst_kind4  burst;
  rand logic [3:0] prot4 ;
 
  `uvm_object_utils_begin(ahb_transfer4)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction4,direction4, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size4,hsize4, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind4,burst, UVM_ALL_ON)
    `uvm_field_int(prot4, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor4 - required4 syntax4 for UVM automation4 and utilities4
  function new (string name = "unnamed4-ahb_transfer4");
    super.new(name);
  endfunction : new

endclass : ahb_transfer4

`endif // AHB_TRANSFER_SV4

