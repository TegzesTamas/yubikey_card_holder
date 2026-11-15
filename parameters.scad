// Shared dimensions and print settings. Edit these values to configure all models.
$fn = 128;

logo_depth = 0.4;

card_thickness = 1.65;
card_width = 58;
card_height = 85;
card_height_margin = 3;

finger_cutout_radius = 20;

usb_length = 8;
usb_thickness = 2.3;
usb_width = 9;
yubi_total_height = 10;

yubikey_cutout_width = 13;
yubikey_cutout_height = 13;

wall_thickness = 1.4;
fillet_radius = 0.75;

// Derived dimensions shared by the holder variants.
card_only_height = wall_thickness + card_height + card_height_margin;
total_thickness = 2 * wall_thickness + card_thickness;
total_width = 2 * wall_thickness + card_width;
total_height = card_only_height + yubi_total_height;
usb_center_distance = usb_width - usb_thickness;
