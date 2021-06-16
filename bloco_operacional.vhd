------------------------------------------------
-- Design: bloco operacional
-- Entity: bloco_operacional
-- Author: Diogo & George
-- Rev. : 1.0
-- Date : 03/16/2021
------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY bloco_operacional IS
  PORT (
    i_CLK          : IN  STD_LOGIC;
    i_CLR_N        : IN  STD_LOGIC;
    i_INC_CONT     : IN  STD_LOGIC;                    -- enable contador
    i_CLR_CONT     : IN  STD_LOGIC;                    -- clear contador
    i_DATA_IMG     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input
	 i_DATA_RUIDO_G : IN  STD_LOGIC_VECTOR(8 DOWNTO 0); -- data input
	 i_DATA_RUIDO_S : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input
    i_R_EN_ROM     : IN  STD_LOGIC;                    -- input read enable in rom memory
    i_WR_EN_RAM    : IN  STD_LOGIC;                    -- data input 
    o_NEXT         : OUT STD_LOGIC;                    -- data output continue
    o_R_EN_ROM     : OUT STD_LOGIC;                    -- output read enable in rom memory  
    o_WR_EN_RAM    : OUT STD_LOGIC; -- output write enable ram 
	 o_ADDR         : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);-- data output
	 o_VALOR_WR_RAM : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- data output
  );
END bloco_operacional;

ARCHITECTURE rtl OF bloco_operacional IS


  component registrador8bit IS
    PORT (
      i_CLK   : IN  STD_LOGIC;
      i_CLR_N : IN  STD_LOGIC;
      i_ENA   : IN  STD_LOGIC;                     -- enable
      i_A     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data input       
      o_Q     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- data output
  END component;

  component comparadorMaior8Bit IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
	 i_B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC                 -- data output
  );
  END component;
  
  component multiplexador IS
  PORT (
    i_SEL : IN  STD_LOGIC;                     -- selector
    i_A   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data A
    i_B   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data B
    o_Q   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- data output
  END component;
  
  component contador IS
  PORT (
    i_CLR  : IN  STD_LOGIC;                    -- clear/reset
    i_CLK  : IN  STD_LOGIC;                    -- clock
    i_ENA  : IN  STD_LOGIC;                    -- enable 		 
    o_CONT : OUT STD_LOGIC_VECTOR(19 DOWNTO 0) -- data output
  );
  END component;
  
  component comparadorMenor8Bit IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
	 i_B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC                 -- data output
  );
  END component;
  
  component comparador20Bit IS
  PORT (
    i_ADDR : IN  STD_LOGIC_VECTOR(19 DOWNTO 0); -- data input 1	 
	 i_COMPARE : IN  STD_LOGIC_VECTOR(19 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC                 -- data output
  );
  END component;
  
  component somador IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
	 i_B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)  -- data output
  );
  END component;
  
  component absoluto IS
  PORT (
    i_A    : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);-- data input		 
    o_SAIDA : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) -- data output
  );
  END component;
  
  
  


BEGIN

  u_registrador1bit : registrador1bit PORT MAP(
    i_CLK   => i_CLK,
    i_CLR_N => i_CLR_n,
    i_A     => w_o_COMPARE,
    o_Q     => w_o_REG_1_bit
  );

  u_multiplexador : multiplexador PORT MAP(
    i_SEL => w_o_REG_1_bit,
    i_A   => "00000000",
    i_B   => "11111111",
    o_Q   => o_VALOR_WR_RAM
  );

  u_comparador : comparador PORT MAP(
    i_VALOR => i_DATA,
    o_Q     => w_o_COMPARE
  );

  --connecting contador with bloco_controle and maquinaEstados
  u_contador : contador PORT MAP(
    i_CLR  => i_CLR_CONT,
    i_CLK  => i_CLK,
    i_ENA  => i_INC_CONT,
    o_CONT => w_o_C_CONT
  );

  o_ADDR       <= w_o_C_CONT(11 DOWNTO 0);
  o_WR_EN_RAM  <= i_EN_WR_RAM;
  o_R_EN_ROM   <= i_R_EN_ROM;
  o_CONTINUE_n <= w_o_C_CONT(12);

END rtl;
