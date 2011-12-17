=begin
start:1854
end:1915(21m)
end:1925(31m) リファクタリング＆バグ修正
start2:1925
end2:2016 ruby column_name_conv2.rb 1 1 成功
deadline:2024 終了…… column_name_conv2_timeover.rb に保存して継続
2026 あー、ruby column_name_conv2.rb 1 (num) とすべき実行を ruby column_name_conv2.rb 1 (String) としていてハマっていた。
2035 いまさら if $DEBUG を導入
2037 27 成功、26 失敗
2039 26, 16384 成功 column_name_conv2_successed.rb に保存して継続

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
	return result += char_of[rest_num] if rest_num <= char_of.size # 終了条件
	# <= でないと 26 のときにエラー
			
	# 次回の rest_num は mod で求まる
	# result の追加文字は rest_num / 26**div_num で求まる
	div_num = 0 # rest_num を割る値
	result_div = rest_num / char_of.size**div_num
	while result_div > 0 # 割り算が0 => (rest_num < 26**div_num)
		div_num += 1
		result_div = rest_num / char_of.size**div_num
	end
	div_num -= 1
	puts "div_num: #{div_num}" if $DEBUG
	puts "rest_num: #{rest_num}" if $DEBUG
	result_div = rest_num / char_of.size**div_num
	puts "result_div: #{result_div}" if $DEBUG
	result += char_of[result_div]
	result_mod = rest_num % char_of.size**div_num
	puts "result_mod: #{result_mod}" if $DEBUG
	next_rest_num = result_mod
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