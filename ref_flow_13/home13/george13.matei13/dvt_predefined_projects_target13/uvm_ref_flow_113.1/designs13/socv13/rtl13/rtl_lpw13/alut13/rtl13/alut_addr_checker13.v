//File13 name   : alut_addr_checker13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

// compiler13 directives13
`include "alut_defines13.v"


module alut_addr_checker13
(   
   // Inputs13
   pclk13,
   n_p_reset13,
   command,
   mac_addr13,
   d_addr13,
   s_addr13,
   s_port13,
   curr_time13,
   mem_read_data_add13,
   age_confirmed13,
   age_ok13,
   clear_reused13,

   //outputs13
   d_port13,
   add_check_active13,
   mem_addr_add13,
   mem_write_add13,
   mem_write_data_add13,
   lst_inv_addr_nrm13,
   lst_inv_port_nrm13,
   check_age13,
   last_accessed13,
   reused13
);



   input               pclk13;               // APB13 clock13                           
   input               n_p_reset13;          // Reset13                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr13;           // address of the switch13              
   input [47:0]        d_addr13;             // address of frame13 to be checked13     
   input [47:0]        s_addr13;             // address of frame13 to be stored13      
   input [1:0]         s_port13;             // source13 port of current frame13       
   input [31:0]        curr_time13;          // current time,for storing13 in mem    
   input [82:0]        mem_read_data_add13;  // read data from mem                 
   input               age_confirmed13;      // valid flag13 from age13 checker        
   input               age_ok13;             // result from age13 checker 
   input               clear_reused13;       // read/clear flag13 for reused13 signal13           

   output [4:0]        d_port13;             // calculated13 destination13 port for tx13 
   output              add_check_active13;   // bit 0 of status register           
   output [7:0]        mem_addr_add13;       // hash13 address for R/W13 to memory     
   output              mem_write_add13;      // R/W13 flag13 (write = high13)            
   output [82:0]       mem_write_data_add13; // write data for memory             
   output [47:0]       lst_inv_addr_nrm13;   // last invalidated13 addr normal13 op    
   output [1:0]        lst_inv_port_nrm13;   // last invalidated13 port normal13 op    
   output              check_age13;          // request flag13 for age13 check
   output [31:0]       last_accessed13;      // time field sent13 for age13 check
   output              reused13;             // indicates13 ALUT13 location13 overwritten13

   reg   [2:0]         add_chk_state13;      // current address checker state
   reg   [2:0]         nxt_add_chk_state13;  // current address checker state
   reg   [4:0]         d_port13;             // calculated13 destination13 port for tx13 
   reg   [3:0]         port_mem13;           // bitwise13 conversion13 of 2bit port
   reg   [7:0]         mem_addr_add13;       // hash13 address for R/W13 to memory
   reg                 mem_write_add13;      // R/W13 flag13 (write = high13)            
   reg                 reused13;             // indicates13 ALUT13 location13 overwritten13
   reg   [47:0]        lst_inv_addr_nrm13;   // last invalidated13 addr normal13 op    
   reg   [1:0]         lst_inv_port_nrm13;   // last invalidated13 port normal13 op    
   reg                 check_age13;          // request flag13 for age13 checker
   reg   [31:0]        last_accessed13;      // time field sent13 for age13 check


   wire   [7:0]        s_addr_hash13;        // hash13 of address for storing13
   wire   [7:0]        d_addr_hash13;        // hash13 of address for checking
   wire   [82:0]       mem_write_data_add13; // write data for memory  
   wire                add_check_active13;   // bit 0 of status register           


// Parameters13 for Address Checking13 FSM13 states13
   parameter idle13           = 3'b000;
   parameter mac_addr_chk13   = 3'b001;
   parameter read_dest_add13  = 3'b010;
   parameter valid_chk13      = 3'b011;
   parameter age_chk13        = 3'b100;
   parameter addr_chk13       = 3'b101;
   parameter read_src_add13   = 3'b110;
   parameter write_src13      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash13 conversion13 of source13 and destination13 addresses13
// -----------------------------------------------------------------------------
   assign s_addr_hash13 = s_addr13[7:0] ^ s_addr13[15:8] ^ s_addr13[23:16] ^
                        s_addr13[31:24] ^ s_addr13[39:32] ^ s_addr13[47:40];

   assign d_addr_hash13 = d_addr13[7:0] ^ d_addr13[15:8] ^ d_addr13[23:16] ^
                        d_addr13[31:24] ^ d_addr13[39:32] ^ d_addr13[47:40];



// -----------------------------------------------------------------------------
//   State13 Machine13 For13 handling13 the destination13 address checking process and
//   and storing13 of new source13 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state13 or age_confirmed13 or age_ok13)
   begin
      case (add_chk_state13)
      
      idle13:
         if (command == 2'b01)
            nxt_add_chk_state13 = mac_addr_chk13;
         else
            nxt_add_chk_state13 = idle13;

      mac_addr_chk13:   // check if destination13 address match MAC13 switch13 address
         if (d_addr13 == mac_addr13)
            nxt_add_chk_state13 = idle13;  // return dest13 port as 5'b1_0000
         else
            nxt_add_chk_state13 = read_dest_add13;

      read_dest_add13:       // read data from memory using hash13 of destination13 address
            nxt_add_chk_state13 = valid_chk13;

      valid_chk13:      // check if read data had13 valid bit set
         nxt_add_chk_state13 = age_chk13;

      age_chk13:        // request age13 checker to check if still in date13
         if (age_confirmed13)
            nxt_add_chk_state13 = addr_chk13;
         else
            nxt_add_chk_state13 = age_chk13; 

      addr_chk13:       // perform13 compare between dest13 and read addresses13
            nxt_add_chk_state13 = read_src_add13; // return read port from ALUT13 mem

      read_src_add13:   // read from memory location13 about13 to be overwritten13
            nxt_add_chk_state13 = write_src13; 

      write_src13:      // write new source13 data (addr and port) to memory
            nxt_add_chk_state13 = idle13; 

      default:
            nxt_add_chk_state13 = idle13;
      endcase
   end


// destination13 check FSM13 current state
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
      add_chk_state13 <= idle13;
   else
      add_chk_state13 <= nxt_add_chk_state13;
   end



// -----------------------------------------------------------------------------
//   Generate13 returned value of port for sending13 new frame13 to
// -----------------------------------------------------------------------------
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
      d_port13 <= 5'b0_1111;
   else if ((add_chk_state13 == mac_addr_chk13) & (d_addr13 == mac_addr13))
      d_port13 <= 5'b1_0000;
   else if (((add_chk_state13 == valid_chk13) & ~mem_read_data_add13[82]) |
            ((add_chk_state13 == age_chk13) & ~(age_confirmed13 & age_ok13)) |
            ((add_chk_state13 == addr_chk13) & (d_addr13 != mem_read_data_add13[47:0])))
      d_port13 <= 5'b0_1111 & ~( 1 << s_port13 );
   else if ((add_chk_state13 == addr_chk13) & (d_addr13 == mem_read_data_add13[47:0]))
      d_port13 <= {1'b0, port_mem13} & ~( 1 << s_port13 );
   else
      d_port13 <= d_port13;
   end


// -----------------------------------------------------------------------------
//   convert read port source13 value from 2bits to bitwise13 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
      port_mem13 <= 4'b1111;
   else begin
      case (mem_read_data_add13[49:48])
         2'b00: port_mem13 <= 4'b0001;
         2'b01: port_mem13 <= 4'b0010;
         2'b10: port_mem13 <= 4'b0100;
         2'b11: port_mem13 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded13 off13 add_chk_state13
// -----------------------------------------------------------------------------
assign add_check_active13 = (add_chk_state13 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate13 memory addressing13 signals13.
//   The check address command will be taken13 as the indication13 from SW13 that the 
//   source13 fields (address and port) can be written13 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13) 
   begin
       mem_write_add13 <= 1'b0;
       mem_addr_add13  <= 8'd0;
   end
   else if (add_chk_state13 == read_dest_add13)
   begin
       mem_write_add13 <= 1'b0;
       mem_addr_add13  <= d_addr_hash13;
   end
// Need13 to set address two13 cycles13 before check
   else if ( (add_chk_state13 == age_chk13) && age_confirmed13 )
   begin
       mem_write_add13 <= 1'b0;
       mem_addr_add13  <= s_addr_hash13;
   end
   else if (add_chk_state13 == write_src13)
   begin
       mem_write_add13 <= 1'b1;
       mem_addr_add13  <= s_addr_hash13;
   end
   else
   begin
       mem_write_add13 <= 1'b0;
       mem_addr_add13  <= d_addr_hash13;
   end
   end


// -----------------------------------------------------------------------------
//   Generate13 databus13 for writing to memory
//   Data written13 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add13 = {1'b1, curr_time13, s_port13, s_addr13};



// -----------------------------------------------------------------------------
//   Evaluate13 read back data that is about13 to be overwritten13 with new source13 
//   address and port values. Decide13 whether13 the reused13 flag13 must be set and
//   last_inval13 address and port values updated.
//   reused13 needs13 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13) 
   begin
      reused13 <= 1'b0;
      lst_inv_addr_nrm13 <= 48'd0;
      lst_inv_port_nrm13 <= 2'd0;
   end
   else if ((add_chk_state13 == read_src_add13) & mem_read_data_add13[82] &
            (s_addr13 != mem_read_data_add13[47:0]))
   begin
      reused13 <= 1'b1;
      lst_inv_addr_nrm13 <= mem_read_data_add13[47:0];
      lst_inv_port_nrm13 <= mem_read_data_add13[49:48];
   end
   else if (clear_reused13)
   begin
      reused13 <= 1'b0;
      lst_inv_addr_nrm13 <= lst_inv_addr_nrm13;
      lst_inv_port_nrm13 <= lst_inv_addr_nrm13;
   end
   else 
   begin
      reused13 <= reused13;
      lst_inv_addr_nrm13 <= lst_inv_addr_nrm13;
      lst_inv_port_nrm13 <= lst_inv_addr_nrm13;
   end
   end


// -----------------------------------------------------------------------------
//   Generate13 signals13 for age13 checker to perform13 in-date13 check
// -----------------------------------------------------------------------------
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13) 
   begin
      check_age13 <= 1'b0;  
      last_accessed13 <= 32'd0;
   end
   else if (check_age13)
   begin
      check_age13 <= 1'b0;  
      last_accessed13 <= mem_read_data_add13[81:50];
   end
   else if (add_chk_state13 == age_chk13)
   begin
      check_age13 <= 1'b1;  
      last_accessed13 <= mem_read_data_add13[81:50];
   end
   else 
   begin
      check_age13 <= 1'b0;  
      last_accessed13 <= 32'd0;
   end
   end


`ifdef ABV_ON13

// psl13 default clock13 = (posedge pclk13);

// ASSERTION13 CHECKS13
/* Commented13 out as also checking in toplevel13
// it should never be possible13 for the destination13 port to indicate13 the MAC13
// switch13 address and one of the other 4 Ethernets13
// psl13 assert_valid_dest_port13 : assert never (d_port13[4] & |{d_port13[3:0]});


// COVER13 SANITY13 CHECKS13
// check all values of destination13 port can be returned.
// psl13 cover_d_port_013 : cover { d_port13 == 5'b0_0001 };
// psl13 cover_d_port_113 : cover { d_port13 == 5'b0_0010 };
// psl13 cover_d_port_213 : cover { d_port13 == 5'b0_0100 };
// psl13 cover_d_port_313 : cover { d_port13 == 5'b0_1000 };
// psl13 cover_d_port_413 : cover { d_port13 == 5'b1_0000 };
// psl13 cover_d_port_all13 : cover { d_port13 == 5'b0_1111 };
*/
`endif


endmodule 









