shader_type canvas_item;

uniform sampler2D Circuit_Tex: filter_nearest;
uniform sampler2D BG_Tex: filter_nearest;
uniform sampler2D Border_Tex: filter_nearest;
uniform sampler2D Chip_Tex: filter_nearest;

uniform vec4 Circuit_Color: source_color;
uniform vec4 BG_Color: source_color;
uniform vec4 Border_Color: source_color;
uniform vec4 Chip_Color: source_color;

void fragment() {
	vec4 BG_Vec = BG_Color*texture(BG_Tex, UV);
	vec4 Circuit_Vec = Circuit_Color*texture(Circuit_Tex, UV);
	vec4 Border_Vec = Border_Color*texture(Border_Tex, UV);
	vec4 Chip_Vec = Chip_Color*texture(Chip_Tex, UV);
	COLOR = Circuit_Vec + BG_Vec + Border_Vec + Chip_Vec;


	//COLOR = texture(BG_Tex, UV) + texture(Circuit_Tex, UV) + texture(Border_Tex, UV);
	//COLOR = texture(BG_Tex, UV);
	//COLOR = texture(Circuit_Tex, UV);
	//COLOR = texture(Border_Tex, UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
