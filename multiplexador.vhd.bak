------------------------------------------------
-- Design: multiplexador 2x1
-- Entity: multiplexador
-- Author: Diogo & George
-- Rev. : 1.0
-- Date : 03/16/2021
------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY multiplexador IS
  PORT (
    i_SEL : IN  STD_LOGIC;                     -- selector
    i_A   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data A
    i_B   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data B
    o_Q   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- data output
END multiplexador;
ARCHITECTURE arch_1 OF multiplexador IS

BEGIN

  o_Q <= i_A WHEN (i_SEL = '0') ELSE i_B;

END arch_1;

