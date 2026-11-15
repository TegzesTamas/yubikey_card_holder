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

module nvidia_logo(long_size) {
    logo_width = long_size;
    logo_height = logo_width * 258.785 / 351.46;

    color("#769B00"){
        translate([-logo_width/2, -logo_height*0.29, 0]) {
            linear_extrude(height=logo_depth)
                resize([logo_width, logo_height])
                    import("NVIDIA_logo.svg", center=false);
        }
    }
}

module card_holder_without_yubikey_nvidia() {
    union() {
        color("black") {
            card_holder_without_yubikey();
        }
        height_minus_cutout = card_only_height-finger_cutout_radius;
        translate([0, -total_thickness/2, height_minus_cutout/2]) {
            rotate([90, 0, 0]) {
                rotate([0, 0, 90]) {
                    nvidia_logo(height_minus_cutout*0.90);
                }   
            }    
        }
        translate([0, total_thickness/2, height_minus_cutout/2]) {
            rotate([0, 0, 180]) {
                rotate([90, 0, 0]) {
                    rotate([0, 0, 90]) {
                        nvidia_logo(height_minus_cutout*0.90);
                    }   
                }    
            }
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

module yubikey_card_holder_nvidia() {
    union() {
        color("black") {
            yubikey_card_holder();
        }
        bottom_margin = wall_thickness+usb_length+yubikey_cutout_height;
        height_minus_cutout = total_height-finger_cutout_radius-bottom_margin;
        translate([0, 0, bottom_margin]) {
            translate([0, -total_thickness/2, height_minus_cutout/2]) {
                rotate([90, 0, 0]) {
                    rotate([0, 0, 90]) {
                        nvidia_logo(height_minus_cutout*0.90);
                    }   
                }    
            }
            translate([0, total_thickness/2, height_minus_cutout/2]) {
                rotate([0, 0, 180]) {
                    rotate([90, 0, 0]) {
                        rotate([0, 0, 90]) {
                            nvidia_logo(height_minus_cutout*0.90);
                        }   
                    }    
                }
            }
        }
    }
}
//yubikey_card_holder();

module yubikey_tester() {
    difference() {
        rounded_cube_z0(yubikey_cutout_width, total_thickness, wall_thickness+usb_length, fillet_radius);
        translate([0, 0, wall_thickness]) usb_c_cutout();
    }
}
// Select the model to render:
// card_holder_without_yubikey_nvidia();
yubikey_card_holder_nvidia();
// yubikey_tester();
