//File19 name   : alut19.v
//Title19       : ALUT19 top level
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
module alut19
(   
   // Inputs19
   pclk19,
   n_p_reset19,
   psel19,            
   penable19,       
   pwrite19,         
   paddr19,           
   pwdata19,          

   // Outputs19
   prdata19  
);

   parameter   DW19 = 83;          // width of data busses19
   parameter   DD19 = 256;         // depth of RAM19


   // APB19 Inputs19
   input             pclk19;               // APB19 clock19                          
   input             n_p_reset19;          // Reset19                              
   input             psel19;               // Module19 select19 signal19               
   input             penable19;            // Enable19 signal19                      
   input             pwrite19;             // Write when HIGH19 and read when LOW19  
   input [6:0]       paddr19;              // Address bus for read write         
   input [31:0]      pwdata19;             // APB19 write bus                      

   output [31:0]     prdata19;             // APB19 read bus                       

   wire              pclk19;               // APB19 clock19                           
   wire [7:0]        mem_addr_add19;       // hash19 address for R/W19 to memory     
   wire              mem_write_add19;      // R/W19 flag19 (write = high19)            
   wire [DW19-1:0]     mem_write_data_add19; // write data for memory             
   wire [7:0]        mem_addr_age19;       // hash19 address for R/W19 to memory     
   wire              mem_write_age19;      // R/W19 flag19 (write = high19)            
   wire [DW19-1:0]     mem_write_data_age19; // write data for memory             
   wire [DW19-1:0]     mem_read_data_add19;  // read data from mem                 
   wire [DW19-1:0]     mem_read_data_age19;  // read data from mem  
   wire [31:0]       curr_time19;          // current time
   wire              active;             // status[0] adress19 checker active
   wire              inval_in_prog19;      // status[1] 
   wire              reused19;             // status[2] ALUT19 location19 overwritten19
   wire [4:0]        d_port19;             // calculated19 destination19 port for tx19
   wire [47:0]       lst_inv_addr_nrm19;   // last invalidated19 addr normal19 op
   wire [1:0]        lst_inv_port_nrm19;   // last invalidated19 port normal19 op
   wire [47:0]       lst_inv_addr_cmd19;   // last invalidated19 addr via cmd19
   wire [1:0]        lst_inv_port_cmd19;   // last invalidated19 port via cmd19
   wire [47:0]       mac_addr19;           // address of the switch19
   wire [47:0]       d_addr19;             // address of frame19 to be checked19
   wire [47:0]       s_addr19;             // address of frame19 to be stored19
   wire [1:0]        s_port19;             // source19 port of current frame19
   wire [31:0]       best_bfr_age19;       // best19 before age19
   wire [7:0]        div_clk19;            // programmed19 clock19 divider19 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata19;             // APB19 read bus
   wire              age_confirmed19;      // valid flag19 from age19 checker        
   wire              age_ok19;             // result from age19 checker 
   wire              clear_reused19;       // read/clear flag19 for reused19 signal19           
   wire              check_age19;          // request flag19 for age19 check
   wire [31:0]       last_accessed19;      // time field sent19 for age19 check




alut_reg_bank19 i_alut_reg_bank19
(   
   // Inputs19
   .pclk19(pclk19),
   .n_p_reset19(n_p_reset19),
   .psel19(psel19),            
   .penable19(penable19),       
   .pwrite19(pwrite19),         
   .paddr19(paddr19),           
   .pwdata19(pwdata19),          
   .curr_time19(curr_time19),
   .add_check_active19(add_check_active19),
   .age_check_active19(age_check_active19),
   .inval_in_prog19(inval_in_prog19),
   .reused19(reused19),
   .d_port19(d_port19),
   .lst_inv_addr_nrm19(lst_inv_addr_nrm19),
   .lst_inv_port_nrm19(lst_inv_port_nrm19),
   .lst_inv_addr_cmd19(lst_inv_addr_cmd19),
   .lst_inv_port_cmd19(lst_inv_port_cmd19),

   // Outputs19
   .mac_addr19(mac_addr19),    
   .d_addr19(d_addr19),   
   .s_addr19(s_addr19),    
   .s_port19(s_port19),    
   .best_bfr_age19(best_bfr_age19),
   .div_clk19(div_clk19),     
   .command(command), 
   .prdata19(prdata19),  
   .clear_reused19(clear_reused19)           
);


alut_addr_checker19 i_alut_addr_checker19
(   
   // Inputs19
   .pclk19(pclk19),
   .n_p_reset19(n_p_reset19),
   .command(command),
   .mac_addr19(mac_addr19),
   .d_addr19(d_addr19),
   .s_addr19(s_addr19),
   .s_port19(s_port19),
   .curr_time19(curr_time19),
   .mem_read_data_add19(mem_read_data_add19),
   .age_confirmed19(age_confirmed19),
   .age_ok19(age_ok19),
   .clear_reused19(clear_reused19),

   //outputs19
   .d_port19(d_port19),
   .add_check_active19(add_check_active19),
   .mem_addr_add19(mem_addr_add19),
   .mem_write_add19(mem_write_add19),
   .mem_write_data_add19(mem_write_data_add19),
   .lst_inv_addr_nrm19(lst_inv_addr_nrm19),
   .lst_inv_port_nrm19(lst_inv_port_nrm19),
   .check_age19(check_age19),
   .last_accessed19(last_accessed19),
   .reused19(reused19)
);


alut_age_checker19 i_alut_age_checker19
(   
   // Inputs19
   .pclk19(pclk19),
   .n_p_reset19(n_p_reset19),
   .command(command),          
   .div_clk19(div_clk19),          
   .mem_read_data_age19(mem_read_data_age19),
   .check_age19(check_age19),        
   .last_accessed19(last_accessed19), 
   .best_bfr_age19(best_bfr_age19),   
   .add_check_active19(add_check_active19),

   // outputs19
   .curr_time19(curr_time19),         
   .mem_addr_age19(mem_addr_age19),      
   .mem_write_age19(mem_write_age19),     
   .mem_write_data_age19(mem_write_data_age19),
   .lst_inv_addr_cmd19(lst_inv_addr_cmd19),  
   .lst_inv_port_cmd19(lst_inv_port_cmd19),  
   .age_confirmed19(age_confirmed19),     
   .age_ok19(age_ok19),
   .inval_in_prog19(inval_in_prog19),            
   .age_check_active19(age_check_active19)
);   


alut_mem19 i_alut_mem19
(   
   // Inputs19
   .pclk19(pclk19),
   .mem_addr_add19(mem_addr_add19),
   .mem_write_add19(mem_write_add19),
   .mem_write_data_add19(mem_write_data_add19),
   .mem_addr_age19(mem_addr_age19),
   .mem_write_age19(mem_write_age19),
   .mem_write_data_age19(mem_write_data_age19),

   .mem_read_data_add19(mem_read_data_add19),  
   .mem_read_data_age19(mem_read_data_age19)
);   



`ifdef ABV_ON19
// psl19 default clock19 = (posedge pclk19);

// ASSUMPTIONS19

// ASSERTION19 CHECKS19
// the invalidate19 aged19 in progress19 flag19 and the active flag19 
// should never both be set.
// psl19 assert_inval_in_prog_active19 : assert never (inval_in_prog19 & active);

// it should never be possible19 for the destination19 port to indicate19 the MAC19
// switch19 address and one of the other 4 Ethernets19
// psl19 assert_valid_dest_port19 : assert never (d_port19[4] & |{d_port19[3:0]});

// COVER19 SANITY19 CHECKS19
// check all values of destination19 port can be returned.
// psl19 cover_d_port_019 : cover { d_port19 == 5'b0_0001 };
// psl19 cover_d_port_119 : cover { d_port19 == 5'b0_0010 };
// psl19 cover_d_port_219 : cover { d_port19 == 5'b0_0100 };
// psl19 cover_d_port_319 : cover { d_port19 == 5'b0_1000 };
// psl19 cover_d_port_419 : cover { d_port19 == 5'b1_0000 };
// psl19 cover_d_port_all19 : cover { d_port19 == 5'b0_1111 };

`endif


endmodule
