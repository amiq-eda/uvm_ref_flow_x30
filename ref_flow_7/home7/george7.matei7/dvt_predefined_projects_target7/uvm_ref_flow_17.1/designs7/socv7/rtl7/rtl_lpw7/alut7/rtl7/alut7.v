//File7 name   : alut7.v
//Title7       : ALUT7 top level
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
module alut7
(   
   // Inputs7
   pclk7,
   n_p_reset7,
   psel7,            
   penable7,       
   pwrite7,         
   paddr7,           
   pwdata7,          

   // Outputs7
   prdata7  
);

   parameter   DW7 = 83;          // width of data busses7
   parameter   DD7 = 256;         // depth of RAM7


   // APB7 Inputs7
   input             pclk7;               // APB7 clock7                          
   input             n_p_reset7;          // Reset7                              
   input             psel7;               // Module7 select7 signal7               
   input             penable7;            // Enable7 signal7                      
   input             pwrite7;             // Write when HIGH7 and read when LOW7  
   input [6:0]       paddr7;              // Address bus for read write         
   input [31:0]      pwdata7;             // APB7 write bus                      

   output [31:0]     prdata7;             // APB7 read bus                       

   wire              pclk7;               // APB7 clock7                           
   wire [7:0]        mem_addr_add7;       // hash7 address for R/W7 to memory     
   wire              mem_write_add7;      // R/W7 flag7 (write = high7)            
   wire [DW7-1:0]     mem_write_data_add7; // write data for memory             
   wire [7:0]        mem_addr_age7;       // hash7 address for R/W7 to memory     
   wire              mem_write_age7;      // R/W7 flag7 (write = high7)            
   wire [DW7-1:0]     mem_write_data_age7; // write data for memory             
   wire [DW7-1:0]     mem_read_data_add7;  // read data from mem                 
   wire [DW7-1:0]     mem_read_data_age7;  // read data from mem  
   wire [31:0]       curr_time7;          // current time
   wire              active;             // status[0] adress7 checker active
   wire              inval_in_prog7;      // status[1] 
   wire              reused7;             // status[2] ALUT7 location7 overwritten7
   wire [4:0]        d_port7;             // calculated7 destination7 port for tx7
   wire [47:0]       lst_inv_addr_nrm7;   // last invalidated7 addr normal7 op
   wire [1:0]        lst_inv_port_nrm7;   // last invalidated7 port normal7 op
   wire [47:0]       lst_inv_addr_cmd7;   // last invalidated7 addr via cmd7
   wire [1:0]        lst_inv_port_cmd7;   // last invalidated7 port via cmd7
   wire [47:0]       mac_addr7;           // address of the switch7
   wire [47:0]       d_addr7;             // address of frame7 to be checked7
   wire [47:0]       s_addr7;             // address of frame7 to be stored7
   wire [1:0]        s_port7;             // source7 port of current frame7
   wire [31:0]       best_bfr_age7;       // best7 before age7
   wire [7:0]        div_clk7;            // programmed7 clock7 divider7 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata7;             // APB7 read bus
   wire              age_confirmed7;      // valid flag7 from age7 checker        
   wire              age_ok7;             // result from age7 checker 
   wire              clear_reused7;       // read/clear flag7 for reused7 signal7           
   wire              check_age7;          // request flag7 for age7 check
   wire [31:0]       last_accessed7;      // time field sent7 for age7 check




alut_reg_bank7 i_alut_reg_bank7
(   
   // Inputs7
   .pclk7(pclk7),
   .n_p_reset7(n_p_reset7),
   .psel7(psel7),            
   .penable7(penable7),       
   .pwrite7(pwrite7),         
   .paddr7(paddr7),           
   .pwdata7(pwdata7),          
   .curr_time7(curr_time7),
   .add_check_active7(add_check_active7),
   .age_check_active7(age_check_active7),
   .inval_in_prog7(inval_in_prog7),
   .reused7(reused7),
   .d_port7(d_port7),
   .lst_inv_addr_nrm7(lst_inv_addr_nrm7),
   .lst_inv_port_nrm7(lst_inv_port_nrm7),
   .lst_inv_addr_cmd7(lst_inv_addr_cmd7),
   .lst_inv_port_cmd7(lst_inv_port_cmd7),

   // Outputs7
   .mac_addr7(mac_addr7),    
   .d_addr7(d_addr7),   
   .s_addr7(s_addr7),    
   .s_port7(s_port7),    
   .best_bfr_age7(best_bfr_age7),
   .div_clk7(div_clk7),     
   .command(command), 
   .prdata7(prdata7),  
   .clear_reused7(clear_reused7)           
);


alut_addr_checker7 i_alut_addr_checker7
(   
   // Inputs7
   .pclk7(pclk7),
   .n_p_reset7(n_p_reset7),
   .command(command),
   .mac_addr7(mac_addr7),
   .d_addr7(d_addr7),
   .s_addr7(s_addr7),
   .s_port7(s_port7),
   .curr_time7(curr_time7),
   .mem_read_data_add7(mem_read_data_add7),
   .age_confirmed7(age_confirmed7),
   .age_ok7(age_ok7),
   .clear_reused7(clear_reused7),

   //outputs7
   .d_port7(d_port7),
   .add_check_active7(add_check_active7),
   .mem_addr_add7(mem_addr_add7),
   .mem_write_add7(mem_write_add7),
   .mem_write_data_add7(mem_write_data_add7),
   .lst_inv_addr_nrm7(lst_inv_addr_nrm7),
   .lst_inv_port_nrm7(lst_inv_port_nrm7),
   .check_age7(check_age7),
   .last_accessed7(last_accessed7),
   .reused7(reused7)
);


alut_age_checker7 i_alut_age_checker7
(   
   // Inputs7
   .pclk7(pclk7),
   .n_p_reset7(n_p_reset7),
   .command(command),          
   .div_clk7(div_clk7),          
   .mem_read_data_age7(mem_read_data_age7),
   .check_age7(check_age7),        
   .last_accessed7(last_accessed7), 
   .best_bfr_age7(best_bfr_age7),   
   .add_check_active7(add_check_active7),

   // outputs7
   .curr_time7(curr_time7),         
   .mem_addr_age7(mem_addr_age7),      
   .mem_write_age7(mem_write_age7),     
   .mem_write_data_age7(mem_write_data_age7),
   .lst_inv_addr_cmd7(lst_inv_addr_cmd7),  
   .lst_inv_port_cmd7(lst_inv_port_cmd7),  
   .age_confirmed7(age_confirmed7),     
   .age_ok7(age_ok7),
   .inval_in_prog7(inval_in_prog7),            
   .age_check_active7(age_check_active7)
);   


alut_mem7 i_alut_mem7
(   
   // Inputs7
   .pclk7(pclk7),
   .mem_addr_add7(mem_addr_add7),
   .mem_write_add7(mem_write_add7),
   .mem_write_data_add7(mem_write_data_add7),
   .mem_addr_age7(mem_addr_age7),
   .mem_write_age7(mem_write_age7),
   .mem_write_data_age7(mem_write_data_age7),

   .mem_read_data_add7(mem_read_data_add7),  
   .mem_read_data_age7(mem_read_data_age7)
);   



`ifdef ABV_ON7
// psl7 default clock7 = (posedge pclk7);

// ASSUMPTIONS7

// ASSERTION7 CHECKS7
// the invalidate7 aged7 in progress7 flag7 and the active flag7 
// should never both be set.
// psl7 assert_inval_in_prog_active7 : assert never (inval_in_prog7 & active);

// it should never be possible7 for the destination7 port to indicate7 the MAC7
// switch7 address and one of the other 4 Ethernets7
// psl7 assert_valid_dest_port7 : assert never (d_port7[4] & |{d_port7[3:0]});

// COVER7 SANITY7 CHECKS7
// check all values of destination7 port can be returned.
// psl7 cover_d_port_07 : cover { d_port7 == 5'b0_0001 };
// psl7 cover_d_port_17 : cover { d_port7 == 5'b0_0010 };
// psl7 cover_d_port_27 : cover { d_port7 == 5'b0_0100 };
// psl7 cover_d_port_37 : cover { d_port7 == 5'b0_1000 };
// psl7 cover_d_port_47 : cover { d_port7 == 5'b1_0000 };
// psl7 cover_d_port_all7 : cover { d_port7 == 5'b0_1111 };

`endif


endmodule
