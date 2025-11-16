extends Object
class_name Constants

enum FloorColor {Dark, Green, Orange, Purple, Red, Light}

enum PlayerTag {None = -1, Player1, RedNpc, OrangeNpc, PurpleNpc}

static var colors : Dictionary[FloorColor, Color] = {
	FloorColor.Green: Color("1bd977"),
	FloorColor.Orange: Color("ff8c00"),
	FloorColor.Purple: Color("9d22fa"),
	FloorColor.Red: Color("ff0038"),
}
