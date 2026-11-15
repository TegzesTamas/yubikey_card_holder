include <parameters.scad>

module rounded_cube_z0(width, length, height, radius) {
    x_offset = width - 2 * radius;
    y_offset = length - 2 * radius;

    hull() {
        for (x = [-x_offset / 2, x_offset / 2])
            for (y = [-y_offset / 2, y_offset / 2])
                for (z = [radius, height - radius])
                    translate([x, y, z]) sphere(r=radius);
    }
}

module cube_on_z0(width, length, height) {
    translate([0, 0, height / 2])
        cube([width, length, height], center=true);
}

module finger_cutout(height) {
    translate([0, 0, height])
        rotate([90, 0, 0])
            cylinder(r=finger_cutout_radius, h=10 * total_thickness, center=true);
}

module usb_c_cutout() {
    hull() {
        for (x = [-usb_center_distance / 2, usb_center_distance / 2])
            translate([x, 0, 0]) cylinder(d=usb_thickness, h=usb_length * 2);
    }
}

module holder_body(with_yubikey=false) {
    body_height = with_yubikey ? total_height : card_only_height;

    difference() {
        rounded_cube_z0(total_width, total_thickness, body_height, fillet_radius);

        // Card slot. The extra height opens the slot at the top.
        translate([0, 0, wall_thickness + (with_yubikey ? usb_length : 0)])
            cube_on_z0(card_width, card_thickness,
                       card_only_height + (with_yubikey ? yubi_total_height : 0));

        finger_cutout(body_height);

        if (with_yubikey) {
            translate([0, 0, wall_thickness]) usb_c_cutout();
            translate([0, 0, wall_thickness + usb_length])
                cube_on_z0(yubikey_cutout_width, 2 * total_thickness,
                           yubikey_cutout_height);
        }
    }
}

module nvidia_logo(long_size) {
    logo_width = long_size;
    logo_height = logo_width * 258.785 / 351.46;

    color("#769B00")
        translate([-logo_width / 2, -logo_height * 0.29, 0])
            linear_extrude(height=logo_depth+wall_thickness/2)
                offset(delta=-0.01)
                    resize([logo_width, logo_height])
                        import("NVIDIA_logo.svg", center=false);
}

// Place matching raised logos on both broad faces of a holder.
module holder_logos(with_yubikey=false) {
    bottom_margin = with_yubikey
        ? wall_thickness + usb_length + yubikey_cutout_height
        : 0;
    body_height = with_yubikey ? total_height : card_only_height;
    logo_height = body_height - finger_cutout_radius - bottom_margin;

    translate([0, 0, bottom_margin]) {
        translate([0, -(total_thickness/2 - wall_thickness/2), logo_height / 2])
            rotate([90, 0, 0]) rotate([0, 0, 90])
                nvidia_logo(logo_height * 0.90);

        translate([0, +(total_thickness/2 - wall_thickness/2), logo_height / 2])
            rotate([0, 0, 180]) rotate([90, 0, 0]) rotate([0, 0, 90])
                nvidia_logo(logo_height * 0.90);
    }
}

module card_holder(with_yubikey=false, with_logo=false) {
    union() {
        color("black") holder_body(with_yubikey);
        if (with_logo) holder_logos(with_yubikey);
    }
}

module yubikey_tester_model() {
    difference() {
        rounded_cube_z0(yubikey_cutout_width, total_thickness,
                        wall_thickness + usb_length, fillet_radius);
        translate([0, 0, wall_thickness]) usb_c_cutout();
    }
}
