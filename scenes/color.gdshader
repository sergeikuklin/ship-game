shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform int nodeColor = 0;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	pixelColor.a *= 0.8;
	
	if (nodeColor == 0) {
		pixelColor = vec4(1.0, 0.0, 0.0, pixelColor.a);		
	}
	
	if (nodeColor == 1) {
		pixelColor = vec4(0.0, 0.0, 1.0, pixelColor.a);		
	}
	COLOR = pixelColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
