$fn = 128;

logo_depth = 0.4;

card_thickness = 1.7;
card_width = 58;
card_height = 85;
card_height_margin = 3;

finger_cutout_radius = 20;

usb_length = 8;
usb_thickness = 2.4;
usb_width = 8.3;
yubi_total_height = 10;

yubikey_cutout_width = 13;
yubikey_cutout_height = 13;

wall_thickness = 1.4;
fillet_radius = 0.75;

card_only_height = wall_thickness + card_height + card_height_margin;
total_thickness = 2*wall_thickness + card_thickness;
total_width = 2*wall_thickness + card_width;
total_height = card_only_height + yubi_total_height;

usb_center_distance = usb_width - usb_thickness;

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

module card_holder_without_yubikey() {
    difference() {
        rounded_cube_z0(total_width, total_thickness, card_only_height,fillet_radius);
        translate([0, 0, wall_thickness]) cube_on_z0(card_width, card_thickness, card_only_height);
        translate([0, 0, card_only_height]) {
            rotate([90, 0, 0]) cylinder(r=finger_cutout_radius, h=10*total_thickness, center=true);   
        }
    }
}

module usb_c_cutout() {
    hull() {
        translate([-usb_center_distance/2, 0, 0]) cylinder(d=usb_thickness, h=usb_length*2, center=false);
        translate([+usb_center_distance/2, 0, 0]) cylinder(d=usb_thickness, h=usb_length*2, center=false);
    }
}

module yubikey_card_holder() {
    difference() {
        rounded_cube_z0(total_width, total_thickness, total_height, fillet_radius);
        translate([0, 0, wall_thickness+usb_length]) cube_on_z0(card_width, card_thickness, card_only_height+yubi_total_height);
        translate([0, 0, total_height]) {
            rotate([90, 0, 0]) cylinder(r=finger_cutout_radius, h=10*total_thickness, center=true);   
        }
        translate([0, 0, wall_thickness]) usb_c_cutout();
        translate([0, 0, wall_thickness+usb_length]) cube_on_z0(yubikey_cutout_width, total_thickness*2, yubikey_cutout_height);

    }
}
//yubikey_card_holder();

module yubikey_tester() {
    difference() {
        rounded_cube_z0(yubikey_cutout_width, total_thickness, wall_thickness+usb_length, fillet_radius);
        translate([0, 0, wall_thickness]) usb_c_cutout();
    }
}
yubikey_tester();
