=begin
作業時間
start:1854
1915(21m) 動いた（つもりだった）
1925(31m) リファクタリング＆バグ修正
start2:1925
2016 引数 "1 1" 成功
deadline:2024(90m) 終了。column_name_conv2_timeover.rb に保存して継続
2026 "1 (num)" とすべき引数を "1 (chars)" と打ってハマっていたことに気づく
2035 いまさら if $DEBUG を導入
2037 "1 27" 成功、"1 26" 失敗
2039(105m) 動いた。column_name_conv2_successed.rb に保存して継続
2218(3h24m=204m) リファクタリング終了
2249(235m) 記事を読んで反省終了。1位のreverseしない計算方法に感心した
=end

=begin 思考過程
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

ruby column_name_conv2.rb 1 26
ruby column_name_conv2.rb 1 27
ruby column_name_conv2.rb 1 1
ruby column_name_conv2.rb 1 16384
#=> Z, AA, A XFD

ruby -d column_name_conv2.rb 1 16384

=end

=begin 反省
・あほな実行をしてしまうのでテストコードを書いたほうがよかった
・↑タイムオーバーですぐ気づいたのでリラックス大事
・+-1の差に注意。考えるよりも puts で確認したほうがはやい
・最初から puts var if $DEBUG を書きまくっておけばよかった
・繰り上がりの数字である 26 をどう扱うかで悩んだ。素直に 26 でもよかった。
・つたない英語で変数名にこだわるとめんどい
・凝った if $DEBUG を書くならテストコードでよかった


今後こころがけること
・開発中は p, puts しまくる
・手ストが一瞬でもめんどうに感じたらテストコードを書く（絶対ミスる）
・英語調べるよりもローマ字とコメント遣う（そのうち直せばいい）
・ハマったら落ち着いて「怪しいと思うところ」「ではないところ」を見る
=end

mode = {0=>:to_num, 1=>:to_char}[ARGV[0].to_i]
val_to_conv = ARGV[1]

NUM_OF = {'A'=>1, 'B'=>2, 'C'=>3, 'D'=>4, 'E'=>5, 'F'=>6, 'G'=>7, 'H'=>8, 'I'=>9, 'J'=>10, 'K'=>11, 'L'=>12, 'M'=>13, 'N'=>14, 'O'=>15, 'P'=>16, 'Q'=>17, 'R'=>18, 'S'=>19, 'T'=>20, 'U'=>21, 'V'=>22, 'W'=>23, 'X'=>24, 'Y'=>25, 'Z'=>26}
CHAR_OF = NUM_OF.invert
CHARS_SIZE = NUM_OF.size # n進数のnに当たる数字、なんていう？

def do_div(rest_num, result="", depth=0) # 割り算をしながら文字を求めていく
	if rest_num <= CHARS_SIZE # 終了条件
		char_added = CHAR_OF[rest_num]
		if $DEBUG
			result_div = rest_num / CHARS_SIZE**0
			puts "  "*depth + "result_div: #{rest_num} / #{CHARS_SIZE}**0 = #{result_div} => #{char_added}"
		end
		return result + char_added
	end

	i = 0 # rest_num / CHARS_SIZE**i > 0 である最大の i を求める
		# <=> rest_num % CHARS_SIZE**i < rest_num である最大の i を求める
	result_div = rest_num / CHARS_SIZE**i
	result_div = rest_num / CHARS_SIZE**(i+=1) while result_div > 0
	i -= 1
	#puts i if $DEBUG
	result_div = rest_num / CHARS_SIZE**i # 追加文字を表す数
	char_added = CHAR_OF[result_div]
	result_mod = rest_num % CHARS_SIZE**i # 次に割る数
	if $DEBUG
		puts "  "*depth + "result_div: #{rest_num} / #{CHARS_SIZE}**#{i} = #{result_div} => #{char_added}"
		puts "  "*depth + "result_mod: #{rest_num} % #{CHARS_SIZE}**#{i} = #{result_mod}" 
	end
	do_div(result_mod, result + char_added, depth+1)
end
def to_num(column_name)
	result = 0
	column_name.split(//).reverse.each_with_index do |char, i| # split忘れず！
		result += (CHARS_SIZE**i) * NUM_OF[char]
	end
	return result
end
def to_char(column_num)
	do_div(column_num)
end

# main

if mode == :to_num
	column_name = val_to_conv
	puts result = to_num(column_name)
elsif mode == :to_char
	column_num = val_to_conv.to_i
	puts result = to_char(column_num)
end

if $DEBUG # 逆算して確認する
	if mode == :to_num
		$DEBUG = false
		result_rollback = to_char(result)
	elsif mode == :to_char
		result_rollback = to_num(result)
	end
	print "rollback: #{result_rollback}"
	mes = {true=>" (OK)", false=>" (NG)"}
	puts mes[val_to_conv.to_s==result_rollback.to_s]
end