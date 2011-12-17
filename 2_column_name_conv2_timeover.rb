=begin
start:1854
end:1915(21m)
end:1925(31m) リファクタリング＆バグ修正
start2:1925
end2:2016 ruby column_name_conv2.rb 1 1 成功
deadline:2024 終了……

26**0 => 1
A=>1
AA=> (26**1 * 1) + (26**0 * 1)
BA=> (26**1 * 2) + (26**0 * 1)
BB=> (26**1 * 2) + (26**0 * 2)
AAA=> (26**2 * 1) + (26**1 * 1) + (26**0 * 1)
XFD=> (26**2 * 24) + (26**1 * 6) + (26**0 * 4) => 16384

27 => (26**1 * 1) + (26**0 * 1) => AA
	27/26 = 1...1

26 => (26**0 * 26) => Z

16384 => (26**2 * 24) + (26**1 * 6) + (26**0 * 4) => XFD
	16384 % 26**2 => 160(rest) 
	16384 / 26**2 => 24 => X # 割り算がプラスになる一番大きい値を特定する
	160 % 26**1 => 4(rest)
	160 / 26**1 => 6 => F
	4 % 26**0 => 4 => D # restが26以下なら終了

・繰り返しで考える
・再帰させる
・文字の枠で考える（割り算のひっ算）
	
=end


mode = {0=>:to_num, 1=>:to_char}[ARGV[0].to_i]
val_to_conv = ARGV[1]

num_of = {'A'=>1, 'B'=>2, 'C'=>3, 'D'=>4, 'E'=>5, 'F'=>6, 'G'=>7, 'H'=>8, 'I'=>9, 'J'=>10, 'K'=>11, 'L'=>12, 'M'=>13, 'N'=>14, 'O'=>15, 'P'=>16, 'Q'=>17, 'R'=>18, 'S'=>19, 'T'=>20, 'U'=>21, 'V'=>22, 'W'=>23, 'X'=>24, 'Y'=>25, 'Z'=>26}


def do_div(result, rest_num, char_of) # 引数をmodしたときにプラスになる一番大きい値
	div_num = 0 # rest_num を割る値
	p rest_num
	if rest_num < char_of.size # 終了条件
		puts result += char_of[rest_num] 
		return result
	end
			
	# 次回の rest_num は mod で求まる
	# result の追加文字は rest_num / 26**div_num で求まる
	result_div = 1 # dummy
	while result_div > 0 # 割り算が0になったら、そのひとつまえのdiv_numを使おう
		result_div = rest_num / char_of.size**div_num
		div_num += 1
	end
	div_num -= 1 # rest_num を割ってあまりが出る最大の数
	puts result += char_of[rest_num / char_of.size**div_num]
	puts next_rest_num = rest_num % char_of.size**div_num
	do_div(result, next_rest_num, char_of)
end

if mode == :to_num
	column_name = val_to_conv
	result = 0
	column_name.split(//).reverse.each_with_index do |char, place| # split忘れず！
		result += (num_of.size**place) * num_of[char]
	end
	puts result

elsif mode == :to_char
	column_num = val_to_conv.to_i
	char_of = num_of.invert
	result = ""
	puts do_div(result, column_num, char_of)
end