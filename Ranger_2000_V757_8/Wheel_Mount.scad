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

module wheel()
{
	rotate([90, 0, 0])
	{ 
		difference() {
			union(){
				color("black") rotate_extrude(convexity = 10, $fn = 100) translate([19, 0, 0]) circle(d = 16, $fn = 100);
				color("gray") rotate_extrude(convexity = 10, $fn = 100) translate([15, 0, 0]) circle(d = 16, $fn = 100);
				color("white") {
					translate([0, 0, 0]) cylinder(d = 20, h=12, $fn = 100, center=true);
					translate([0, 0, 0]) cylinder(d = 6.9, h=16.86, $fn = 100, center=true);
				}
	
			}
			translate([0, 0, 0]) cylinder(d = 3, h=20, $fn = 100, center=true);
		}
		color("red") translate([0, 0, 0]) cylinder(d = .5, h=50, $fn = 100, center=true);
	}
}
module main_plate()
{
	wheel_z = -3;//5+5;

	module_cuble_w=31;
	module_cuble_l=78;

	top_cube_h = 20;
	top_cube_w = 25;
	top_cube_l = 70;
	top_cube_hull_length=top_cube_l-top_cube_w;


	module plate()
	{
		dia = 75;
		bottom_plate_h = 12;
		
		color("gray") translate([0, 0, top_cube_h/2]) roundCornersCube(module_cuble_l, module_cuble_w, top_cube_h, 5);
		difference() {
			color("green") translate([0, 0, bottom_plate_h/2-bottom_plate_h+3]) roundCornersCube(module_cuble_l+4, module_cuble_w+4, bottom_plate_h, 4);
			//translate([0, 0,  dia/2+1.5]) rotate([0, 90, 0]) cylinder(d=dia, h=module_cuble_l+10, center=true);
		}
		
		
	}

	module xx()
	{
		tin = 1.5;
		color("red") translate([0, 0, top_cube_h/2]) difference() {
			roundCornersCube(module_cuble_l+tin, module_cuble_w+tin, top_cube_h, 5);
			roundCornersCube(module_cuble_l+0.05, module_cuble_w+0.05, top_cube_h+2, 5);
		}			
	}


	module holes()
	{
		dia = top_cube_w-5;
		heigth= 40;
		hull_length=top_cube_hull_length-2;
		translate([0, 0, heigth/2-2-10]){ 
			hull() {
				translate([hull_length/2, 0,  0]) cylinder(d=dia, h=heigth, center=true);
				translate([-hull_length/2, 0, 0]) cylinder(d=dia, h=heigth, center=true);
			}
		}
		translate([0, 0, 0]) xx();
	}
	
	difference()  {
		union() {
			difference()  {
				plate();
				holes();
			}
			b_h = 3.2;
			for(y=[-1, 1])
			color("red") translate([0, y*(17+b_h+0.8)/2, 5]){ 
				rotate([90, 0, 0]) hull() {
					translate([0, 4,  0]) cylinder(d=10, h=b_h, center=true);
					translate([0, 0, 0]) cube([10, 10, b_h],center=true); 
				}
			}
		}
		translate([0, 0, wheel_z]) rotate([90, 0, 0]) cylinder(d = 3, h=50, $fn = 100, center=true);
	}
	translate([0, 0, wheel_z])  wheel();
	color("green") translate([0, 0, -27.5+wheel_z]) cube([100, top_cube_w+4, 1],center=true);
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


//translate([-13.5, 37, 0]) color("red") mirror([0, 0, 1]) import("calypso_wheel_mount_001.stl");
//translate([180, -37.5, 0]) color("red") mirror([1, 0, 0]) import("ranger2000-v2.stl");

//translate([33.15, -48+0.15, -81]) color("red") rotate([0, -90, 0]) import("Clip_Replacement.stl");
//translate([33.15, 48-0.15, -81]) color("red") mirror([0, 1, 0])  rotate([0, -90, 0]) import("Clip_Replacement.stl");
main_plate();

