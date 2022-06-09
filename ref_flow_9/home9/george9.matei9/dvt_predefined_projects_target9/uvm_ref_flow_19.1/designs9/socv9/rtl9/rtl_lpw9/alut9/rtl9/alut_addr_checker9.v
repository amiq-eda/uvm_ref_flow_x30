//File9 name   : alut_addr_checker9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

// compiler9 directives9
`include "alut_defines9.v"


module alut_addr_checker9
(   
   // Inputs9
   pclk9,
   n_p_reset9,
   command,
   mac_addr9,
   d_addr9,
   s_addr9,
   s_port9,
   curr_time9,
   mem_read_data_add9,
   age_confirmed9,
   age_ok9,
   clear_reused9,

   //outputs9
   d_port9,
   add_check_active9,
   mem_addr_add9,
   mem_write_add9,
   mem_write_data_add9,
   lst_inv_addr_nrm9,
   lst_inv_port_nrm9,
   check_age9,
   last_accessed9,
   reused9
);



   input               pclk9;               // APB9 clock9                           
   input               n_p_reset9;          // Reset9                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr9;           // address of the switch9              
   input [47:0]        d_addr9;             // address of frame9 to be checked9     
   input [47:0]        s_addr9;             // address of frame9 to be stored9      
   input [1:0]         s_port9;             // source9 port of current frame9       
   input [31:0]        curr_time9;          // current time,for storing9 in mem    
   input [82:0]        mem_read_data_add9;  // read data from mem                 
   input               age_confirmed9;      // valid flag9 from age9 checker        
   input               age_ok9;             // result from age9 checker 
   input               clear_reused9;       // read/clear flag9 for reused9 signal9           

   output [4:0]        d_port9;             // calculated9 destination9 port for tx9 
   output              add_check_active9;   // bit 0 of status register           
   output [7:0]        mem_addr_add9;       // hash9 address for R/W9 to memory     
   output              mem_write_add9;      // R/W9 flag9 (write = high9)            
   output [82:0]       mem_write_data_add9; // write data for memory             
   output [47:0]       lst_inv_addr_nrm9;   // last invalidated9 addr normal9 op    
   output [1:0]        lst_inv_port_nrm9;   // last invalidated9 port normal9 op    
   output              check_age9;          // request flag9 for age9 check
   output [31:0]       last_accessed9;      // time field sent9 for age9 check
   output              reused9;             // indicates9 ALUT9 location9 overwritten9

   reg   [2:0]         add_chk_state9;      // current address checker state
   reg   [2:0]         nxt_add_chk_state9;  // current address checker state
   reg   [4:0]         d_port9;             // calculated9 destination9 port for tx9 
   reg   [3:0]         port_mem9;           // bitwise9 conversion9 of 2bit port
   reg   [7:0]         mem_addr_add9;       // hash9 address for R/W9 to memory
   reg                 mem_write_add9;      // R/W9 flag9 (write = high9)            
   reg                 reused9;             // indicates9 ALUT9 location9 overwritten9
   reg   [47:0]        lst_inv_addr_nrm9;   // last invalidated9 addr normal9 op    
   reg   [1:0]         lst_inv_port_nrm9;   // last invalidated9 port normal9 op    
   reg                 check_age9;          // request flag9 for age9 checker
   reg   [31:0]        last_accessed9;      // time field sent9 for age9 check


   wire   [7:0]        s_addr_hash9;        // hash9 of address for storing9
   wire   [7:0]        d_addr_hash9;        // hash9 of address for checking
   wire   [82:0]       mem_write_data_add9; // write data for memory  
   wire                add_check_active9;   // bit 0 of status register           


// Parameters9 for Address Checking9 FSM9 states9
   parameter idle9           = 3'b000;
   parameter mac_addr_chk9   = 3'b001;
   parameter read_dest_add9  = 3'b010;
   parameter valid_chk9      = 3'b011;
   parameter age_chk9        = 3'b100;
   parameter addr_chk9       = 3'b101;
   parameter read_src_add9   = 3'b110;
   parameter write_src9      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash9 conversion9 of source9 and destination9 addresses9
// -----------------------------------------------------------------------------
   assign s_addr_hash9 = s_addr9[7:0] ^ s_addr9[15:8] ^ s_addr9[23:16] ^
                        s_addr9[31:24] ^ s_addr9[39:32] ^ s_addr9[47:40];

   assign d_addr_hash9 = d_addr9[7:0] ^ d_addr9[15:8] ^ d_addr9[23:16] ^
                        d_addr9[31:24] ^ d_addr9[39:32] ^ d_addr9[47:40];



// -----------------------------------------------------------------------------
//   State9 Machine9 For9 handling9 the destination9 address checking process and
//   and storing9 of new source9 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state9 or age_confirmed9 or age_ok9)
   begin
      case (add_chk_state9)
      
      idle9:
         if (command == 2'b01)
            nxt_add_chk_state9 = mac_addr_chk9;
         else
            nxt_add_chk_state9 = idle9;

      mac_addr_chk9:   // check if destination9 address match MAC9 switch9 address
         if (d_addr9 == mac_addr9)
            nxt_add_chk_state9 = idle9;  // return dest9 port as 5'b1_0000
         else
            nxt_add_chk_state9 = read_dest_add9;

      read_dest_add9:       // read data from memory using hash9 of destination9 address
            nxt_add_chk_state9 = valid_chk9;

      valid_chk9:      // check if read data had9 valid bit set
         nxt_add_chk_state9 = age_chk9;

      age_chk9:        // request age9 checker to check if still in date9
         if (age_confirmed9)
            nxt_add_chk_state9 = addr_chk9;
         else
            nxt_add_chk_state9 = age_chk9; 

      addr_chk9:       // perform9 compare between dest9 and read addresses9
            nxt_add_chk_state9 = read_src_add9; // return read port from ALUT9 mem

      read_src_add9:   // read from memory location9 about9 to be overwritten9
            nxt_add_chk_state9 = write_src9; 

      write_src9:      // write new source9 data (addr and port) to memory
            nxt_add_chk_state9 = idle9; 

      default:
            nxt_add_chk_state9 = idle9;
      endcase
   end


// destination9 check FSM9 current state
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
      add_chk_state9 <= idle9;
   else
      add_chk_state9 <= nxt_add_chk_state9;
   end



// -----------------------------------------------------------------------------
//   Generate9 returned value of port for sending9 new frame9 to
// -----------------------------------------------------------------------------
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
      d_port9 <= 5'b0_1111;
   else if ((add_chk_state9 == mac_addr_chk9) & (d_addr9 == mac_addr9))
      d_port9 <= 5'b1_0000;
   else if (((add_chk_state9 == valid_chk9) & ~mem_read_data_add9[82]) |
            ((add_chk_state9 == age_chk9) & ~(age_confirmed9 & age_ok9)) |
            ((add_chk_state9 == addr_chk9) & (d_addr9 != mem_read_data_add9[47:0])))
      d_port9 <= 5'b0_1111 & ~( 1 << s_port9 );
   else if ((add_chk_state9 == addr_chk9) & (d_addr9 == mem_read_data_add9[47:0]))
      d_port9 <= {1'b0, port_mem9} & ~( 1 << s_port9 );
   else
      d_port9 <= d_port9;
   end


// -----------------------------------------------------------------------------
//   convert read port source9 value from 2bits to bitwise9 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
      port_mem9 <= 4'b1111;
   else begin
      case (mem_read_data_add9[49:48])
         2'b00: port_mem9 <= 4'b0001;
         2'b01: port_mem9 <= 4'b0010;
         2'b10: port_mem9 <= 4'b0100;
         2'b11: port_mem9 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded9 off9 add_chk_state9
// -----------------------------------------------------------------------------
assign add_check_active9 = (add_chk_state9 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate9 memory addressing9 signals9.
//   The check address command will be taken9 as the indication9 from SW9 that the 
//   source9 fields (address and port) can be written9 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9) 
   begin
       mem_write_add9 <= 1'b0;
       mem_addr_add9  <= 8'd0;
   end
   else if (add_chk_state9 == read_dest_add9)
   begin
       mem_write_add9 <= 1'b0;
       mem_addr_add9  <= d_addr_hash9;
   end
// Need9 to set address two9 cycles9 before check
   else if ( (add_chk_state9 == age_chk9) && age_confirmed9 )
   begin
       mem_write_add9 <= 1'b0;
       mem_addr_add9  <= s_addr_hash9;
   end
   else if (add_chk_state9 == write_src9)
   begin
       mem_write_add9 <= 1'b1;
       mem_addr_add9  <= s_addr_hash9;
   end
   else
   begin
       mem_write_add9 <= 1'b0;
       mem_addr_add9  <= d_addr_hash9;
   end
   end


// -----------------------------------------------------------------------------
//   Generate9 databus9 for writing to memory
//   Data written9 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add9 = {1'b1, curr_time9, s_port9, s_addr9};



// -----------------------------------------------------------------------------
//   Evaluate9 read back data that is about9 to be overwritten9 with new source9 
//   address and port values. Decide9 whether9 the reused9 flag9 must be set and
//   last_inval9 address and port values updated.
//   reused9 needs9 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9) 
   begin
      reused9 <= 1'b0;
      lst_inv_addr_nrm9 <= 48'd0;
      lst_inv_port_nrm9 <= 2'd0;
   end
   else if ((add_chk_state9 == read_src_add9) & mem_read_data_add9[82] &
            (s_addr9 != mem_read_data_add9[47:0]))
   begin
      reused9 <= 1'b1;
      lst_inv_addr_nrm9 <= mem_read_data_add9[47:0];
      lst_inv_port_nrm9 <= mem_read_data_add9[49:48];
   end
   else if (clear_reused9)
   begin
      reused9 <= 1'b0;
      lst_inv_addr_nrm9 <= lst_inv_addr_nrm9;
      lst_inv_port_nrm9 <= lst_inv_addr_nrm9;
   end
   else 
   begin
      reused9 <= reused9;
      lst_inv_addr_nrm9 <= lst_inv_addr_nrm9;
      lst_inv_port_nrm9 <= lst_inv_addr_nrm9;
   end
   end


// -----------------------------------------------------------------------------
//   Generate9 signals9 for age9 checker to perform9 in-date9 check
// -----------------------------------------------------------------------------
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9) 
   begin
      check_age9 <= 1'b0;  
      last_accessed9 <= 32'd0;
   end
   else if (check_age9)
   begin
      check_age9 <= 1'b0;  
      last_accessed9 <= mem_read_data_add9[81:50];
   end
   else if (add_chk_state9 == age_chk9)
   begin
      check_age9 <= 1'b1;  
      last_accessed9 <= mem_read_data_add9[81:50];
   end
   else 
   begin
      check_age9 <= 1'b0;  
      last_accessed9 <= 32'd0;
   end
   end


`ifdef ABV_ON9

// psl9 default clock9 = (posedge pclk9);

// ASSERTION9 CHECKS9
/* Commented9 out as also checking in toplevel9
// it should never be possible9 for the destination9 port to indicate9 the MAC9
// switch9 address and one of the other 4 Ethernets9
// psl9 assert_valid_dest_port9 : assert never (d_port9[4] & |{d_port9[3:0]});


// COVER9 SANITY9 CHECKS9
// check all values of destination9 port can be returned.
// psl9 cover_d_port_09 : cover { d_port9 == 5'b0_0001 };
// psl9 cover_d_port_19 : cover { d_port9 == 5'b0_0010 };
// psl9 cover_d_port_29 : cover { d_port9 == 5'b0_0100 };
// psl9 cover_d_port_39 : cover { d_port9 == 5'b0_1000 };
// psl9 cover_d_port_49 : cover { d_port9 == 5'b1_0000 };
// psl9 cover_d_port_all9 : cover { d_port9 == 5'b0_1111 };
*/
`endif


endmodule 









