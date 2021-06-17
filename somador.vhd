------------------------------------------------
-- Design: comparador 8 bits
-- Entity: comparador
-- Author: Diogo & George
-- Rev. : 1.0
-- Date : 03/15/2021
------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY somador IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
	 i_B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)  -- data output
  );
END somador;

ARCHITECTURE arch_1 OF somador IS

signal w_A, w_B : STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";

BEGIN

  w_A(7 downto 0) <= i_A;
  w_B(7 downto 0) <= i_B;

  -- SAIDA
  o_Q <= w_A + w_B;

END arch_1;
