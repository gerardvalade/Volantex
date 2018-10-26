// Volantex Ranger 2000  - a OpenSCAD 
// Copyright (C) 2016  Gerard Valade

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
$fn=60;

plate_type = 2;
plate_thickness = 2;
border_height = 10;


module hexaprismx(
	ri =  1.0,  // radius of inscribed circle
	h  =  1.0)  // height of hexaprism
{ // -----------------------------------------------

	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=false);
}

module roundCornersCube(x,y,z,r)  // Now we just substract the shape we have created in the four corners
{
	module createMeniscus(h,radius) // This module creates the shape that needs to be substracted from a cube to make its corners rounded.
	{
		difference(){        //This shape is basicly the difference between a quarter of cylinder and a cube
		   translate([radius/2+0.1,radius/2+0.1,0]){
		      cube([radius+0.2,radius+0.1,h+0.2],center=true);         // All that 0.x numbers are to avoid "ghost boundaries" when substracting
		   }
		
		   cylinder(h=h+0.2,r=radius,$fn = 25,center=true);
		}
	
	}
	difference(){
	   cube([x,y,z], center=true);
	
	translate([x/2-r,y/2-r]){  // We move to the first corner (x,y)
	      rotate(0){  
	         createMeniscus(z,r); // And substract the meniscus
	      }
	   }
	   translate([-x/2+r,y/2-r]){ // To the second corner (-x,y)
	      rotate(90){
	         createMeniscus(z,r); // But this time we have to rotate the meniscus 90 deg
	      }
	   }
	      translate([-x/2+r,-y/2+r]){ // ... 
	      rotate(180){
	         createMeniscus(z,r);
	      }
	   }
	      translate([x/2-r,-y/2+r]){
	      rotate(270){
	         createMeniscus(z,r);
	      }
	   }
	}
}
module main_plate()
{
	module round(x, z, dia=6)
	{
 		translate([x, 0, 0]) rotate([0, 0, 45]) translate([z, 0, 0])
 		{
// 			rotate([0, 90, 0]) cylinder(h=90, d=1, center=false);
 			cylinder(h=plate_thickness, d=dia, center=false);
 		}
		
	}
	
	module bumper()
	{
		translate([0, 0, 8]) rotate([90, 0, 0]) cylinder(h=5, d=4, center=true);
		translate([0, -0, 5]) cube([4, 5, 6], center=true);
	}
	
	module half_border()
	{
 		color("green") translate([70, 30, 0]) rotate([0, 0, 1.4]) {
 			difference() {
 				union(){
 					cube([110, 3, border_height], center=false);
 					translate([12, 0, 0]) bumper();
 					translate([81.6, 0, 0]) bumper();
 				
 				}
 				translate([12, 0, 8]) rotate([90, 0, 0])  cylinder(h=10, d=2, center=true); 
 				translate([81.6, 0, 8]) rotate([90, 0, 0])  cylinder(h=10, d=2, center=true); 
			} 			
		}
 		color("green") translate([0.5, 20, 0]) rotate([0, 0, 8]) {
 			difference() {
 				union(){
 					cube([72, 3, border_height], center=false);
 					translate([12, 0, 0]) bumper();
 					translate([62, 0, 0]) bumper();
 				
 				}
 				translate([12, 0, 8]) rotate([90, 0, 0])  cylinder(h=10, d=2, center=true); 
 				translate([62, 0, 8]) rotate([90, 0, 0])  cylinder(h=10, d=2, center=true); 
 			}
 			
 		}
		
	}
	module half_plate1()
	{
		if (plate_type==1) {
			a=[[-0,0],[-0,25.4],[73.7,35.5],[178.5,37.35],[181.5, 34.5],[181.5, 23.6],[190, 23.4],[196.5, 16],[196.5, 0]];
 			linear_extrude (height=plate_thickness) polygon(a);
 			round(144.1, 48.6);
	 		round(173, 22.5, 15);
 		}
		if (plate_type==2) {
			a=[[-0,0],[-0,25.4],[73.7,35.5],[178.5,37.35],[181.5, 34.5],[181.5, 0]];
 			linear_extrude (height=plate_thickness) polygon(a);
 			round(144.1, 48.6);
		}
	}
	module half_plate2()
	{
		a=[[-0,0],[-0,25.4],[73.7,35.5],[178.5,37.35],[181.5, 34.5],[181.5, 0]];
 		b=[[3,0,1,2]];
 		linear_extrude (height=plate_thickness) polygon(a);
 		round(144.1, 48.6);
 		//round(173, 22.5, 15);
	}
	
	
	module half()
	{
		
		half_plate1();
 		half_border();
	}
	
	module fc_4hole(dia=3, heigth=20)
	{
		for(x=[1, -1]) for(y=[1, -1])
			translate([x*30.5/2, y*30.5/2, 0]) cylinder(h=heigth, d=dia, center=true); 
		
	}
	module wing_4hole(dia=1.5, heigth=20)
	{
		for(x=[1, -1]) for(y=[1, -1])
			translate([x*12.2/2, y*25.6/2, 0]) cylinder(h=heigth, d=dia, center=true); 
		for(y=[1, -1]) translate([-10+20/2, y*4.8, 0]) rotate([0, 0, 0]) cube([20, 2, 10], center=true);
		for(y=[1, -1]) translate([0, y*10.5, 0]) rotate([0, 0, 0]) cube([2, 11, 10], center=true);
		
	}
	module fc_hole(heigth=20)
	{
		fc_4hole(dia=3, heigth=heigth);
		cylinder(h=heigth, d=25, center=true);
		
	}
	module square_hole(heigth=20)
	{
		for(x=[1, -1])  translate([x*12.5, 0, 0]) rotate([0, 0, 0]) cube([15, 42, 10], center=true);		
	}
	
	split_x=90;
	module plate()
	{
		half();
		mirror([0, 1, 0]) half();
		hole_heigth=plate_thickness+2;
		if (plate_type==1) {
			translate([175.25, 0, hole_heigth/2])  fc_4hole(dia=6, heigth=hole_heigth);
		}
		if (plate_type==2) {
			translate([155.25, 0, hole_heigth/2])  fc_4hole(dia=6, heigth=hole_heigth);
		}
		translate([112.2, 0, hole_heigth/2]) fc_4hole(dia=6, heigth=hole_heigth);
		difference() {
			translate([split_x, 0, border_height/2]) cube([4, 65, border_height], center=true);
			translate([split_x, 0, border_height/2+4]) cube([5, 55, border_height], center=true);
		}
	}
	module holes()
	{
		if (plate_type==1) {
			translate([175.25, 0, 0]) fc_hole();
		}
		if (plate_type==2) {
			translate([155.25, 0, 0]) fc_hole();
		}
		translate([112.2, 0, 0]) fc_hole();
		translate([24.1, 0, 0]) wing_4hole();
		translate([65, 0, 0])  square_hole();
		
		translate([5, 0, 0]){ 
			hull() {
				translate([0, 10, 0]) cylinder(d=3, h=15, center=true);
				translate([0, -10, 0]) cylinder(d=3, h=15, center=true);
			}
			translate([-15, 0, 0]) rotate([0, 0, 0]) cube([30, 2, 10], center=true);
		}
	}
	difference()  {
		plate();
		holes();
		translate([split_x, 0, 0]) cube([0.1, 100, 50], center=true);
	}
}

	module xt60_hole()
	{
		len=12;
		width=8.5;
		translate([0, 0, 0]) {
			cube([len, width, 10], center=true);
			translate([-len/2, 0, 0]) cylinder(d=width, h=10, center=true);
		}
	}


//translate([134.4, 0, 2.5]) color("red") mirror([0, 0, 1]) import("Ranger_2000_FC_platforme_v2g_-_Part_1.stl");
//translate([180, -37.5, 0]) color("red") mirror([1, 0, 0]) import("ranger2000-v2.stl");

//translate([33.15, -48+0.15, -81]) color("red") rotate([0, -90, 0]) import("Clip_Replacement.stl");
//translate([33.15, 48-0.15, -81]) color("red") mirror([0, 1, 0])  rotate([0, -90, 0]) import("Clip_Replacement.stl");
main_plate();

