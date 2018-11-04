library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package semaforo_tipo is
	constant N_SM: natural := 11;
	type sem_tipo is array(N_SM-1 downto 0) of integer;
    type SM_ESTADO is array (1 downto 0) of std_logic;
	type SEMAFORO is array (N_SM-1 downto 0) of SM_ESTADO;
	type ruta_array is array(2-1 downto 0) of integer;
end package semaforo_tipo;