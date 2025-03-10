library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity countAndSetting is
    port (
        clk : in std_logic;                        -- 时钟信号
        reset : in std_logic;                      -- 复位信号
        set : in std_logic;                        -- 设置信号，用于控制是否进入设置状态
        input : in unsigned(11 downto 0);-- 临时变量，用于存储输入的设置值，9位宽
		print_light_one : out unsigned(6 downto 0);
		show_switch : in unsigned(1 downto 0);
		show : out unsigned(7 downto 0); 
		start : in std_logic;
		pause : in std_logic		
    );
end entity countAndSetting;

architecture Behavioral of countAndSetting is
    signal pills_need : unsigned(11 downto 0);  -- 输入的设置值，用于设置每瓶需要装的药片数量上限
    signal bottom_need : unsigned(7 downto 0);
    signal pills_count_8421 : unsigned(11 downto 0);  -- 计数器，用于记录已装入的药片数的8421码
    signal bottom_count_8421:unsigned(7 downto 0);
	signal error : std_logic;
	signal show_temp : unsigned(11 downto 0);
	signal stop : std_logic;
	signal tik : std_logic;
begin
    process(clk,reset,set,start,pause)
    begin
        if reset = '1' then
            -- 清零计数器
            pills_need <= (others => '0');
            bottom_need <= (others => '0');
            pills_count_8421 <= (others => '0');  
            bottom_count_8421<=(others =>'0');
            error <= '0';
            stop <= '1';
            tik <='0';
        elsif set = '1' then
			if input = "000000000000"then
				error<='1';
			end if;
			case show_switch is
				when "00" =>		
					pills_need <=input;
				when "01" =>
					bottom_need <=input(7 downto 0);
				when others =>
					null;
			end case;
		elsif start = '1' and pills_need /= "000000000000" and bottom_need /="00000000" then
			stop<='0';
		elsif pause = '1' then
			stop<='1';
		elsif rising_edge(clk) and stop='0' then
			if tik = '0' then
				tik<='1';
			else 
				tik<='0';
				if pills_count_8421(3 downto 0) = "1001"then
					if pills_count_8421(7 downto 0) = "10011001"then
						pills_count_8421 <= pills_count_8421 + "01100111";
					else
						pills_count_8421 <= pills_count_8421 + "0111";
					end if;
				else 
					pills_count_8421 <= pills_count_8421 + 1;  -- 每次装药片时计数器加一
				end if;
				if pills_count_8421 = pills_need-1 then
					pills_count_8421 <= "000000000000";
					if bottom_count_8421(3 downto 0) = "1001"then
						bottom_count_8421 <= bottom_count_8421 + "0111";
					else 
						bottom_count_8421 <= bottom_count_8421 + 1;
					end if;
				end if;
				if bottom_count_8421 = bottom_need then
					stop<='1';
					pills_count_8421<="000000000000";
				end if;
			end if;
        end if;
		case show_switch is
			when "00" =>
				show_temp <=pills_need;
			when "01" =>
				show_temp <="0000"&bottom_need;
			when "10" =>
				show_temp <=pills_count_8421;
			when "11" =>
				show_temp <="0000"&bottom_count_8421;
			when others =>
				null;
		end case;
		if error = '1' then
			show_temp<="100010001000";
		end if;
    end process;
	
	process(show_temp,clk)
	begin
		case show_temp(3 downto 0) is
			when "0000" =>
				print_light_one <= "1111110"; -- 0
			when "0001" =>
				print_light_one <= "0110000"; -- 1
			when "0010" =>
				print_light_one <= "1101101"; -- 2
			when "0011" =>
				print_light_one <= "1111001"; -- 3
			when "0100" =>
				print_light_one <= "0110011"; -- 4
			when "0101" =>
				print_light_one <= "1011011"; -- 5
			when "0110" =>
				print_light_one <= "0011111"; -- 6
			when "0111" =>
				print_light_one <= "1110000"; -- 7
			when "1000" =>
				print_light_one <= "1111111"; -- 8
			when "1001" =>
				print_light_one <= "1110011"; -- 9
			when others =>
				-- 如果没有匹配的情况，则不进行任何操作，可根据需要添加适当的处理逻辑
				null;
		end case;
	end process;
	show <= show_temp(11 downto 4);
end architecture Behavioral;