// FPV Raptor  - a OpenSCAD 
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

plate_thickness =4;

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
	module hole()
	{
	   translate([0, 0, -1])  cylinder(h=10, d=2, center=false); 
	}
	module bumper1()
	{
	   translate([0, 0, 0])  cylinder(h=7, d=12, center=false); 
	}
	module bumper2()
	{
	   translate([0, 0, 0])  cylinder(h=7, d=6, center=false); 
	}
	module hole_hexa()
	{
	   cylinder(h=20,d=3.5, center=true);
	   translate([0, 0, 3.5])  hexaprismx(ri=2.9, h=2.8);
	   translate([0, 0, 5.5])  hexaprismx(ri=2.8, h=5);
	}
	module bumper1s()
	{
		
		translate([97.75, 0, 0]) bumper2();
		translate([110.25, 0, 0]) bumper2();
		for(y=[1, -1]) {
			translate([104.65,y*29.5, 0]) bumper2();
			translate([106.25, y*12, 0]) bumper1();
		}
		
		
		for(y=[1, -1]) {
			translate([0, y*26.5, 20/2]) {
				difference() {
					cube([10, 10, 20], center=true);
   					translate([0, 0, 3])  rotate([0, 90, 0]) cylinder(h=17, d=2.5, center=true); 
				}
			}	
		}
	}
	module bumper2s()
	{
		translate([-62.75, 0, 0]) bumper2();
		translate([-98.25, 0, 0]) bumper1();
		translate([-110.25, 0, 0]) bumper1();
		for(y=[1, -1]) {
			translate([-79.75, y*14, 0]) bumper1();
			translate([-38.8, y*12, 0]) bumper1();
		}
		
	}
	module hole1s()
	{
		translate([97.75, 0, 0]) hole();
		translate([110.25, 0, 0]) hole();
		for(y=[1, -1]) {
			translate([104.65,y*29.5, 0]) hole();
			translate([106.25, y*12, 0]) hole_hexa();
		}
		
	}
	module hole2s()
	{
		translate([-62.75, 0, 0]) hole();
		translate([-98.25, 0, 0]) hole_hexa();
		translate([-110.25, 0, 0]) hole_hexa();
		for(y=[1, -1]) {
			translate([-79.75, y*14, 0]) hole_hexa();
			translate([-38.8, y*12, 0]) hole_hexa();
		}
		
	}
	module half()
	{
		translate([-98.25, 0, 0]) cylinder(d=44, h=plate_thickness);
		translate([-100, 12.2, 0]) rotate([0, 0, 9]) cube([25, 10, plate_thickness]);
		translate([-80, 15.5, 0]) rotate([0, 0, 4.8]) cube([170, 10, plate_thickness]);
		translate([88, 29.8, 0]) rotate([0, 0, 2.1]) cube([29, 10, plate_thickness]);
		
		translate([-88, 0, 0]) rotate([0, 0, 0]) cube([60, 20, plate_thickness]);
		translate([89, 0, 0]) rotate([0, 0, 0]) cube([28, 35, plate_thickness]);
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
	difference() 
	{
		union() 
		{
			half();
			mirror([0, 1, 0]) half();
			bumper1s();
			bumper2s();
		}
		hole1s();
		hole2s();
		sz=13;
		color("red") translate([-78.75, 0, 0]) {
			roundCornersCube(sz, sz+1, 20, 3);
			xt60_hole();
		}
	}	
}

module plate_part1()
{
	difference() {
		main_plate();
		translate([-130, -50, -1]) cube([130, 100, 25]);
	}
}
module plate_part2()
{
	difference() {
		main_plate();
		translate([0, -50, -1]) cube([120, 100, 25]);
	}
}


translate([1, 0, 0]) plate_part1();
translate([0, 0, 0]) plate_part2();

