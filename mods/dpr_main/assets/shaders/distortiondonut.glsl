uniform vec2 distort_pos;
uniform vec3 donut;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	float pi = 3.14159265359;
	
	//Vector from distort pos to frag coord
	vec2 vect = vec2( screen_coords.x - distort_pos.x, screen_coords.y - distort_pos.y);
	
	//vec2 vectN = normalize(vect);
	//Length of vector
	float dist = sqrt(vect.x * vect.x + vect.y * vect.y);
	
	//Angle (0-1, counterclockwise from right) of vector
	float angle = atan(vect.y, -vect.x) / ( pi);
	float distort = sin( (clamp( dist - donut.x, 0.0, donut.y) / donut.y) * pi) * donut.z;
	
	//distort pixels
	texture_coords.x = texture_coords.x + (distort * cos(angle)) * 0.1;
	texture_coords.y = texture_coords.y + (distort * cos(angle)) * 0.1;
	
	vec4 pixel = Texel(tex, texture_coords);
	//remove alpha from center
	pixel.a = pixel.a * ( dist / (donut.x + (donut.y * 0.5)));
	
    return pixel * color;
}