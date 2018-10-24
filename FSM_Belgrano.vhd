library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.semaforo_tipo.all;

entity FSM_Belgrano is
	generic( N: natural := 12; N_SM: natural := 16 );
	port(
		Circuito_Via: in std_logic_vector(N-1 downto 0);
		clock,reset: in std_logic;
		ruta: in integer; 
		--Semaforos: out SEMAFORO;
		Semaforos: out std_logic_vector(N_SM-1 downto 0);
		Maquina: out std_logic;
		PaN: out std_logic
	);
end FSM_Belgrano;

architecture FSM_Belgrano_arq of FSM_Belgrano is
	constant N_CV: natural := 12;
	--constant N_SM: natural := 16;
	constant N_rutas: natural := 6;	
	
	type rutas is (RUTA0,RUTA1,RUTA2,RUTA3,RUTA4,RUTA5,RUTA6,RUTA7,RUTA8,RUTA9,RUTA10,RUTA11,RUTA12,RUTA13,RUTA14);
	type rutas_asc is (ASC_0,ASC_1,ASC_2,ASC_5,ASC_6,ASC_7,ASC_9,ASC_10,ASC_13);
	type rutas_des is (DES_0,DES_3,DES_4,DES_5,DES_6,DES_8,DES_11,DES_12,DES_14);
	type circuitos_t is (CIRC1,CIRC2,CIRC3,CIRC4,CIRC5,CIRC6,CIRC7,CIRC8,CIRC9,CIRC10,CIRC11,CIRC12);
	type semaforos_t is (SEM_A,SEM_B,SEM_C,SEM_D,SEM_E,SEM_F,SEM_G,SEM_H,SEM_I,SEM_J,SEM_K,SEM_L,SEM_M,SEM_N,SEM_O,SEM_P);
	type sem_asc_t is (SEM_A,SEM_B,SEM_C,SEM_D,SEM_E,SEM_K,SEM_L,SEM_O);
	type sem_des_t is (SEM_F,SEM_G,SEM_H,SEM_I,SEM_J,SEM_M,SEM_N,SEM_P);
	
	
	signal ruta_ascendente: rutas_asc := ASC_0;
	signal ruta_descendente: rutas_des := DES_0;
	
	constant OCUPADO: std_logic := '0';
	constant LIBRE: std_logic := '1';
	--constant ROJO: SM_ESTADO := "00";		--  0
	--constant AMARILLO: SM_ESTADO := "01";	-- +1
	--constant VERDE: SM_ESTADO := "11";		-- -1
	constant ROJO: std_logic := '0';		--  0
	constant AMARILLO: std_logic := '1';	-- +1
	constant VERDE: std_logic := '1';		-- -1
	constant NORMAL: std_logic := '0';
	constant REVERSA: std_logic := '1';
	constant BARRERA_BAJA: std_logic := '0';
	constant BARRERA_ALTA: std_logic := '1';	
	
	signal habilitacion: std_logic_vector(N_rutas downto 0);
	
	signal Semaforos_ASC: std_logic_vector(N_SM/2-1 downto 0);
	signal Semaforos_DES: std_logic_vector(N_SM/2-1 downto 0);
	
	signal PaN_ASC: std_logic := '0';
	signal PaN_DES: std_logic := '0';
	signal Maquina_ASC: std_logic := '0';
	signal Maquina_DES: std_logic := '0';
	
begin	
	habilitacion(rutas'pos(RUTA0)) <= '1';
	habilitacion(rutas'pos(RUTA1)) <= '1' when 
						 Circuito_Via(circuitos_t'pos(CIRC1)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA2)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC1)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA3)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA4)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA5)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA6)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
		
	ASCENDENTE: process(clock, reset)
	begin
		if (clock ='1' and clock'Event and reset='1') then
			ruta_ascendente <= ASC_0;
			ruta_descendente <= DES_0;
		elsif (clock'event and clock='1') then
			if (ruta = 0 and habilitacion(rutas'pos(RUTA0)) = '1') then
				ruta_ascendente <= ASC_0;
				ruta_descendente <= DES_0;
			end if;
			if (ruta = 1 and habilitacion(rutas'pos(RUTA1)) = '1') then
				ruta_ascendente <= ASC_1;
			end if;
			if (ruta = 2 and habilitacion(rutas'pos(RUTA2)) = '1') then
				ruta_ascendente <= ASC_2;
			end if;
			if (ruta = 3 and habilitacion(rutas'pos(RUTA3)) = '1') then
				ruta_descendente <= DES_3;
			end if;
			if (ruta = 4 and habilitacion(rutas'pos(RUTA4)) = '1') then
				ruta_descendente <= DES_4;
			end if;
			if (ruta = 5 and habilitacion(rutas'pos(RUTA5)) = '1') then
				ruta_ascendente <= ASC_5;
				ruta_descendente <= DES_5;
			end if;
			if (ruta = 6 and habilitacion(rutas'pos(RUTA6)) = '1') then
				ruta_ascendente <= ASC_6;
				ruta_descendente <= DES_6;
			end if;
		end if;
	end process ASCENDENTE;	
	
	-- DESCENDENTE: process(clock, reset)
	-- begin
		-- if (clock ='1' and clock'Event and reset='1') then
			-- ruta_descendente <= DES_0;
		-- elsif (clock'event and clock='1') then
			-- if (ruta = 3 and habilitacion(rutas'pos(RUTA3)) = '1') then
				-- ruta_descendente <= DES_3;
			-- end if;
			-- if (ruta = 4 and habilitacion(rutas'pos(RUTA4)) = '1') then
				-- ruta_descendente <= DES_4;
			-- end if;
			-- if (ruta = 5 and habilitacion(rutas'pos(RUTA5)) = '1') then
				-- ruta_descendente <= DES_5;
			-- end if;
			-- if (ruta = 6 and habilitacion(rutas'pos(RUTA6)) = '1') then
				-- ruta_descendente <= DES_6;
			-- end if;
		-- end if;
	-- end process DESCENDENTE;
	
	RUTA_ASC: process (ruta_ascendente,clock)
	begin
		if (clock'event and clock ='1') then
		case ruta_ascendente is
			when ASC_0 => -- Ruta no asignada
				Semaforos_ASC(sem_asc_t'pos(SEM_A)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_B)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_C)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_D)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_E)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_K)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_L)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_O)) <= ROJO;
				Maquina_ASC <= NORMAL;
				PaN_ASC <= BARRERA_BAJA;
			when ASC_1 => 
				Semaforos_ASC(sem_asc_t'pos(SEM_A)) <= VERDE;
				Semaforos_ASC(sem_asc_t'pos(SEM_B)) <= VERDE;
				Semaforos_ASC(sem_asc_t'pos(SEM_C)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_D)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_E)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_K)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_L)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_O)) <= ROJO;			
				Maquina_ASC <= NORMAL;
				PaN_ASC <= BARRERA_BAJA;
			when ASC_2 => 
				Semaforos_ASC(sem_asc_t'pos(SEM_A)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_B)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_C)) <= VERDE;
				Semaforos_ASC(sem_asc_t'pos(SEM_D)) <= VERDE;
				Semaforos_ASC(sem_asc_t'pos(SEM_E)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_K)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_L)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_O)) <= ROJO;			
				Maquina_ASC <= NORMAL;
				PaN_ASC <= BARRERA_BAJA;
			when ASC_5 => 
				Semaforos_ASC(sem_asc_t'pos(SEM_A)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_B)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_C)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_D)) <= VERDE;
				Semaforos_ASC(sem_asc_t'pos(SEM_E)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_K)) <= ROJO;	
				Semaforos_ASC(sem_asc_t'pos(SEM_L)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_O)) <= ROJO;
				Maquina_ASC <= REVERSA;
				PaN_ASC <= BARRERA_BAJA;
			when ASC_6 =>
				Semaforos_ASC(sem_asc_t'pos(SEM_A)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_B)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_C)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_D)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_E)) <= ROJO;
				Semaforos_ASC(sem_asc_t'pos(SEM_K)) <= ROJO;	
				Semaforos_ASC(sem_asc_t'pos(SEM_L)) <= AMARILLO;
				Semaforos_ASC(sem_asc_t'pos(SEM_O)) <= ROJO;
				Maquina_ASC <= REVERSA;
				PaN_ASC <= BARRERA_BAJA;
			when ASC_7 => Maquina_ASC <= NORMAL;	
			when ASC_9 => Maquina_ASC <= NORMAL;
			when ASC_10 => Maquina_ASC <= NORMAL;
			when ASC_13 => Maquina_ASC <= NORMAL;
		end case;
		end if;		
	end process RUTA_ASC;
	
	RUTA_DES: process (ruta_descendente,clock)
	begin
		if (clock'event and clock ='1') then
		case ruta_descendente is
			when DES_0 => -- Ruta no asignada
				Semaforos_DES(sem_des_t'pos(SEM_F)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_G)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_H)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_I)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_J)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_M)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_N)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_P)) <= ROJO;
				Maquina_DES <= NORMAL;
				PaN_DES <= BARRERA_BAJA;
			when DES_3 => 
				Semaforos_DES(sem_des_t'pos(SEM_F)) <= VERDE;
				Semaforos_DES(sem_des_t'pos(SEM_G)) <= VERDE;
				Semaforos_DES(sem_des_t'pos(SEM_H)) <= VERDE;
				Semaforos_DES(sem_des_t'pos(SEM_I)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_J)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_M)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_N)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_P)) <= ROJO;			
				Maquina_DES <= NORMAL;
				PaN_DES <= BARRERA_BAJA;
			when DES_4 => 
				Semaforos_DES(sem_des_t'pos(SEM_F)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_G)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_H)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_I)) <= VERDE;
				Semaforos_DES(sem_des_t'pos(SEM_J)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_M)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_N)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_P)) <= ROJO;			
				Maquina_DES <= NORMAL;
				PaN_DES <= BARRERA_ALTA;
			when DES_5 =>
				Semaforos_DES(sem_des_t'pos(SEM_F)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_G)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_H)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_I)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_J)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_M)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_N)) <= VERDE;
				Semaforos_DES(sem_des_t'pos(SEM_P)) <= VERDE;
				Maquina_DES <= REVERSA;
				PaN_DES <= BARRERA_BAJA;
			when DES_6 =>
				Semaforos_DES(sem_des_t'pos(SEM_F)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_G)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_H)) <= VERDE;
				Semaforos_DES(sem_des_t'pos(SEM_I)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_J)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_M)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_N)) <= ROJO;
				Semaforos_DES(sem_des_t'pos(SEM_P)) <= ROJO;
				Maquina_DES <= REVERSA;
				PaN_DES <= BARRERA_BAJA;
			when DES_8 => 
				Maquina_DES <= NORMAL;
			when DES_11 =>
				Maquina_DES <= NORMAL;
			when DES_12 => 
				Maquina_DES <= NORMAL;
			when DES_14 => 
				Maquina_DES <= NORMAL;
		end case;
		end if;		
	end process RUTA_DES;
	
	SEMAFORO_ASIGNADOR: process(clock, reset)
	begin
		if (clock ='1' and clock'Event and reset='1') then
			Semaforos <= "0000000000000000";
		elsif (clock'event and clock='1') then
			Semaforos(semaforos_t'pos(SEM_A)) <= Semaforos_ASC(sem_asc_t'pos(SEM_A));
			Semaforos(semaforos_t'pos(SEM_B)) <= Semaforos_ASC(sem_asc_t'pos(SEM_B));
			Semaforos(semaforos_t'pos(SEM_C)) <= Semaforos_ASC(sem_asc_t'pos(SEM_C));
			Semaforos(semaforos_t'pos(SEM_D)) <= Semaforos_ASC(sem_asc_t'pos(SEM_D));
			Semaforos(semaforos_t'pos(SEM_E)) <= Semaforos_ASC(sem_asc_t'pos(SEM_E));
			Semaforos(semaforos_t'pos(SEM_F)) <= Semaforos_DES(sem_des_t'pos(SEM_F));
			Semaforos(semaforos_t'pos(SEM_G)) <= Semaforos_DES(sem_des_t'pos(SEM_G));
			Semaforos(semaforos_t'pos(SEM_H)) <= Semaforos_DES(sem_des_t'pos(SEM_H));
			Semaforos(semaforos_t'pos(SEM_I)) <= Semaforos_DES(sem_des_t'pos(SEM_I));
			Semaforos(semaforos_t'pos(SEM_J)) <= Semaforos_DES(sem_des_t'pos(SEM_J));
			Semaforos(semaforos_t'pos(SEM_K)) <= Semaforos_ASC(sem_asc_t'pos(SEM_K));
			Semaforos(semaforos_t'pos(SEM_L)) <= Semaforos_ASC(sem_asc_t'pos(SEM_L));
			Semaforos(semaforos_t'pos(SEM_M)) <= Semaforos_DES(sem_des_t'pos(SEM_M));
			Semaforos(semaforos_t'pos(SEM_N)) <= Semaforos_DES(sem_des_t'pos(SEM_N));
			Semaforos(semaforos_t'pos(SEM_O)) <= Semaforos_ASC(sem_asc_t'pos(SEM_O));
			Semaforos(semaforos_t'pos(SEM_P)) <= Semaforos_DES(sem_des_t'pos(SEM_P));
		end if;
	end process SEMAFORO_ASIGNADOR;
	
	BARRERAS: process(clock, reset)
	begin
		if (clock ='1' and clock'Event and reset='1') then
			PaN <= BARRERA_BAJA;
		elsif (clock'event and clock='1') then
			PaN <= PaN_ASC and PaN_DES;
		end if;
	end process BARRERAS;
	
	MAQUINAS: process(clock, reset)
	begin
		if (clock ='1' and clock'Event and reset='1') then
			Maquina <= NORMAL;
		elsif (clock'event and clock='1') then
			Maquina <= Maquina_ASC and Maquina_DES;
		end if;
	end process MAQUINAS;
	
end architecture;