//File25 name   : alut_addr_checker25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

// compiler25 directives25
`include "alut_defines25.v"


module alut_addr_checker25
(   
   // Inputs25
   pclk25,
   n_p_reset25,
   command,
   mac_addr25,
   d_addr25,
   s_addr25,
   s_port25,
   curr_time25,
   mem_read_data_add25,
   age_confirmed25,
   age_ok25,
   clear_reused25,

   //outputs25
   d_port25,
   add_check_active25,
   mem_addr_add25,
   mem_write_add25,
   mem_write_data_add25,
   lst_inv_addr_nrm25,
   lst_inv_port_nrm25,
   check_age25,
   last_accessed25,
   reused25
);



   input               pclk25;               // APB25 clock25                           
   input               n_p_reset25;          // Reset25                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr25;           // address of the switch25              
   input [47:0]        d_addr25;             // address of frame25 to be checked25     
   input [47:0]        s_addr25;             // address of frame25 to be stored25      
   input [1:0]         s_port25;             // source25 port of current frame25       
   input [31:0]        curr_time25;          // current time,for storing25 in mem    
   input [82:0]        mem_read_data_add25;  // read data from mem                 
   input               age_confirmed25;      // valid flag25 from age25 checker        
   input               age_ok25;             // result from age25 checker 
   input               clear_reused25;       // read/clear flag25 for reused25 signal25           

   output [4:0]        d_port25;             // calculated25 destination25 port for tx25 
   output              add_check_active25;   // bit 0 of status register           
   output [7:0]        mem_addr_add25;       // hash25 address for R/W25 to memory     
   output              mem_write_add25;      // R/W25 flag25 (write = high25)            
   output [82:0]       mem_write_data_add25; // write data for memory             
   output [47:0]       lst_inv_addr_nrm25;   // last invalidated25 addr normal25 op    
   output [1:0]        lst_inv_port_nrm25;   // last invalidated25 port normal25 op    
   output              check_age25;          // request flag25 for age25 check
   output [31:0]       last_accessed25;      // time field sent25 for age25 check
   output              reused25;             // indicates25 ALUT25 location25 overwritten25

   reg   [2:0]         add_chk_state25;      // current address checker state
   reg   [2:0]         nxt_add_chk_state25;  // current address checker state
   reg   [4:0]         d_port25;             // calculated25 destination25 port for tx25 
   reg   [3:0]         port_mem25;           // bitwise25 conversion25 of 2bit port
   reg   [7:0]         mem_addr_add25;       // hash25 address for R/W25 to memory
   reg                 mem_write_add25;      // R/W25 flag25 (write = high25)            
   reg                 reused25;             // indicates25 ALUT25 location25 overwritten25
   reg   [47:0]        lst_inv_addr_nrm25;   // last invalidated25 addr normal25 op    
   reg   [1:0]         lst_inv_port_nrm25;   // last invalidated25 port normal25 op    
   reg                 check_age25;          // request flag25 for age25 checker
   reg   [31:0]        last_accessed25;      // time field sent25 for age25 check


   wire   [7:0]        s_addr_hash25;        // hash25 of address for storing25
   wire   [7:0]        d_addr_hash25;        // hash25 of address for checking
   wire   [82:0]       mem_write_data_add25; // write data for memory  
   wire                add_check_active25;   // bit 0 of status register           


// Parameters25 for Address Checking25 FSM25 states25
   parameter idle25           = 3'b000;
   parameter mac_addr_chk25   = 3'b001;
   parameter read_dest_add25  = 3'b010;
   parameter valid_chk25      = 3'b011;
   parameter age_chk25        = 3'b100;
   parameter addr_chk25       = 3'b101;
   parameter read_src_add25   = 3'b110;
   parameter write_src25      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash25 conversion25 of source25 and destination25 addresses25
// -----------------------------------------------------------------------------
   assign s_addr_hash25 = s_addr25[7:0] ^ s_addr25[15:8] ^ s_addr25[23:16] ^
                        s_addr25[31:24] ^ s_addr25[39:32] ^ s_addr25[47:40];

   assign d_addr_hash25 = d_addr25[7:0] ^ d_addr25[15:8] ^ d_addr25[23:16] ^
                        d_addr25[31:24] ^ d_addr25[39:32] ^ d_addr25[47:40];



// -----------------------------------------------------------------------------
//   State25 Machine25 For25 handling25 the destination25 address checking process and
//   and storing25 of new source25 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state25 or age_confirmed25 or age_ok25)
   begin
      case (add_chk_state25)
      
      idle25:
         if (command == 2'b01)
            nxt_add_chk_state25 = mac_addr_chk25;
         else
            nxt_add_chk_state25 = idle25;

      mac_addr_chk25:   // check if destination25 address match MAC25 switch25 address
         if (d_addr25 == mac_addr25)
            nxt_add_chk_state25 = idle25;  // return dest25 port as 5'b1_0000
         else
            nxt_add_chk_state25 = read_dest_add25;

      read_dest_add25:       // read data from memory using hash25 of destination25 address
            nxt_add_chk_state25 = valid_chk25;

      valid_chk25:      // check if read data had25 valid bit set
         nxt_add_chk_state25 = age_chk25;

      age_chk25:        // request age25 checker to check if still in date25
         if (age_confirmed25)
            nxt_add_chk_state25 = addr_chk25;
         else
            nxt_add_chk_state25 = age_chk25; 

      addr_chk25:       // perform25 compare between dest25 and read addresses25
            nxt_add_chk_state25 = read_src_add25; // return read port from ALUT25 mem

      read_src_add25:   // read from memory location25 about25 to be overwritten25
            nxt_add_chk_state25 = write_src25; 

      write_src25:      // write new source25 data (addr and port) to memory
            nxt_add_chk_state25 = idle25; 

      default:
            nxt_add_chk_state25 = idle25;
      endcase
   end


// destination25 check FSM25 current state
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
      add_chk_state25 <= idle25;
   else
      add_chk_state25 <= nxt_add_chk_state25;
   end



// -----------------------------------------------------------------------------
//   Generate25 returned value of port for sending25 new frame25 to
// -----------------------------------------------------------------------------
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
      d_port25 <= 5'b0_1111;
   else if ((add_chk_state25 == mac_addr_chk25) & (d_addr25 == mac_addr25))
      d_port25 <= 5'b1_0000;
   else if (((add_chk_state25 == valid_chk25) & ~mem_read_data_add25[82]) |
            ((add_chk_state25 == age_chk25) & ~(age_confirmed25 & age_ok25)) |
            ((add_chk_state25 == addr_chk25) & (d_addr25 != mem_read_data_add25[47:0])))
      d_port25 <= 5'b0_1111 & ~( 1 << s_port25 );
   else if ((add_chk_state25 == addr_chk25) & (d_addr25 == mem_read_data_add25[47:0]))
      d_port25 <= {1'b0, port_mem25} & ~( 1 << s_port25 );
   else
      d_port25 <= d_port25;
   end


// -----------------------------------------------------------------------------
//   convert read port source25 value from 2bits to bitwise25 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
      port_mem25 <= 4'b1111;
   else begin
      case (mem_read_data_add25[49:48])
         2'b00: port_mem25 <= 4'b0001;
         2'b01: port_mem25 <= 4'b0010;
         2'b10: port_mem25 <= 4'b0100;
         2'b11: port_mem25 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded25 off25 add_chk_state25
// -----------------------------------------------------------------------------
assign add_check_active25 = (add_chk_state25 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate25 memory addressing25 signals25.
//   The check address command will be taken25 as the indication25 from SW25 that the 
//   source25 fields (address and port) can be written25 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25) 
   begin
       mem_write_add25 <= 1'b0;
       mem_addr_add25  <= 8'd0;
   end
   else if (add_chk_state25 == read_dest_add25)
   begin
       mem_write_add25 <= 1'b0;
       mem_addr_add25  <= d_addr_hash25;
   end
// Need25 to set address two25 cycles25 before check
   else if ( (add_chk_state25 == age_chk25) && age_confirmed25 )
   begin
       mem_write_add25 <= 1'b0;
       mem_addr_add25  <= s_addr_hash25;
   end
   else if (add_chk_state25 == write_src25)
   begin
       mem_write_add25 <= 1'b1;
       mem_addr_add25  <= s_addr_hash25;
   end
   else
   begin
       mem_write_add25 <= 1'b0;
       mem_addr_add25  <= d_addr_hash25;
   end
   end


// -----------------------------------------------------------------------------
//   Generate25 databus25 for writing to memory
//   Data written25 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add25 = {1'b1, curr_time25, s_port25, s_addr25};



// -----------------------------------------------------------------------------
//   Evaluate25 read back data that is about25 to be overwritten25 with new source25 
//   address and port values. Decide25 whether25 the reused25 flag25 must be set and
//   last_inval25 address and port values updated.
//   reused25 needs25 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25) 
   begin
      reused25 <= 1'b0;
      lst_inv_addr_nrm25 <= 48'd0;
      lst_inv_port_nrm25 <= 2'd0;
   end
   else if ((add_chk_state25 == read_src_add25) & mem_read_data_add25[82] &
            (s_addr25 != mem_read_data_add25[47:0]))
   begin
      reused25 <= 1'b1;
      lst_inv_addr_nrm25 <= mem_read_data_add25[47:0];
      lst_inv_port_nrm25 <= mem_read_data_add25[49:48];
   end
   else if (clear_reused25)
   begin
      reused25 <= 1'b0;
      lst_inv_addr_nrm25 <= lst_inv_addr_nrm25;
      lst_inv_port_nrm25 <= lst_inv_addr_nrm25;
   end
   else 
   begin
      reused25 <= reused25;
      lst_inv_addr_nrm25 <= lst_inv_addr_nrm25;
      lst_inv_port_nrm25 <= lst_inv_addr_nrm25;
   end
   end


// -----------------------------------------------------------------------------
//   Generate25 signals25 for age25 checker to perform25 in-date25 check
// -----------------------------------------------------------------------------
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25) 
   begin
      check_age25 <= 1'b0;  
      last_accessed25 <= 32'd0;
   end
   else if (check_age25)
   begin
      check_age25 <= 1'b0;  
      last_accessed25 <= mem_read_data_add25[81:50];
   end
   else if (add_chk_state25 == age_chk25)
   begin
      check_age25 <= 1'b1;  
      last_accessed25 <= mem_read_data_add25[81:50];
   end
   else 
   begin
      check_age25 <= 1'b0;  
      last_accessed25 <= 32'd0;
   end
   end


`ifdef ABV_ON25

// psl25 default clock25 = (posedge pclk25);

// ASSERTION25 CHECKS25
/* Commented25 out as also checking in toplevel25
// it should never be possible25 for the destination25 port to indicate25 the MAC25
// switch25 address and one of the other 4 Ethernets25
// psl25 assert_valid_dest_port25 : assert never (d_port25[4] & |{d_port25[3:0]});


// COVER25 SANITY25 CHECKS25
// check all values of destination25 port can be returned.
// psl25 cover_d_port_025 : cover { d_port25 == 5'b0_0001 };
// psl25 cover_d_port_125 : cover { d_port25 == 5'b0_0010 };
// psl25 cover_d_port_225 : cover { d_port25 == 5'b0_0100 };
// psl25 cover_d_port_325 : cover { d_port25 == 5'b0_1000 };
// psl25 cover_d_port_425 : cover { d_port25 == 5'b1_0000 };
// psl25 cover_d_port_all25 : cover { d_port25 == 5'b0_1111 };
*/
`endif


endmodule 









