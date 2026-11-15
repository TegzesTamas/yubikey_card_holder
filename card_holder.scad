$fn = 128;

logo_depth = 0.4;
card_thickness = 1.7;
card_width = 58;
card_height = 85;
card_height_margin = 3;

finger_cutout_radius = 20;

wall_thickness = 1.4;
fillet_radius = 0.75;

card_only_height = wall_thickness + card_height + card_height_margin;
total_thickness = 2*wall_thickness + card_thickness;
total_width = 2*wall_thickness + card_width;

module rounded_cube_z0(width, length, height, r) {
    sphere_center_x_dist = width - 2*r;
    sphere_center_y_dist = length - 2*r;
    hull() {
        translate([-sphere_center_x_dist/2, -sphere_center_y_dist/2, r]) sphere(r=r);
        translate([-sphere_center_x_dist/2, +sphere_center_y_dist/2, r]) sphere(r=r);
        translate([+sphere_center_x_dist/2, -sphere_center_y_dist/2, r]) sphere(r=r);
        translate([+sphere_center_x_dist/2, +sphere_center_y_dist/2, r]) sphere(r=r);
        translate([-sphere_center_x_dist/2, -sphere_center_y_dist/2, height-r]) sphere(r=r);
        translate([-sphere_center_x_dist/2, +sphere_center_y_dist/2, height-r]) sphere(r=r);
        translate([+sphere_center_x_dist/2, -sphere_center_y_dist/2, height-r]) sphere(r=r);
        translate([+sphere_center_x_dist/2, +sphere_center_y_dist/2, height-r]) sphere(r=r);   
    }
}

module cube_on_z0(width, length, height) {
    translate([0, 0, height/2]) {
        cube(size=[width, length, height], center=true);
    }
}


difference() {
    rounded_cube_z0(total_width, total_thickness, card_only_height,fillet_radius);
    translate([0, 0, wall_thickness]) cube_on_z0(card_width, card_thickness, card_only_height);
    translate([0, 0, card_only_height]) {
        rotate([90, 0, 0]) cylinder(r=finger_cutout_radius, h=10*total_thickness, center=true);   
    }
}