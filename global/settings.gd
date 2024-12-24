extends Node

const 편당말수 = 4

var 편인자들 = [
	편.인자틀.new("빨강색", Color.RED, 3, 1.45),
	편.인자틀.new("초록색", Color.GREEN, 4, 1.4),
	편.인자틀.new("하늘색", Color.SKY_BLUE, 5, 1.3),
	편.인자틀.new("노랑색", Color.YELLOW, 6, 1.25),
]

var 자동진행 :bool
var 모든길보기 :bool
var 눈번호보기 :bool
var 말빠르기 :float = 0.5
