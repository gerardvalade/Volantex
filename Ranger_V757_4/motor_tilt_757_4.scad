// TL250/280 motorTilt - a OpenSCAD 
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



$fn = 40;

M3_hexa = 5.47+0.4;
M3_hole = 3+0.6;
M3_head_hole = 5.38+0.7;
M3_head_heigth=3.8;

//		M2_hexa = 5.3;
//		M2_hole = 2.6;
//		M2_head_hole = 4.4;

M25_hexa = 5.4;
M25_hole = 2.9;
M25_head_hole = 5.2;

MX_hexa = M3_hexa;
MX_hole = M3_hole;
MX_head_hole = M3_head_hole;
MX_head_heigth = M3_head_heigth;
//         	

module hexaprismx(
	ri =  1.0,  // radius of inscribed circle
	h  =  1.0)  // height of hexaprism
{ // -----------------------------------------------

	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=false);
}
full=false;
module motor_tilt(forward_tilt = 3)
{
	dia = 42;
	heigth = 7;
	offset = 2;
	module plain()
	{
		module hole()
		{
			translate([0, 0, -1]) difference()
			{
					translate([0, 0, 0]) cylinder(d=40, h=50, center=true);
					translate([0, 0, -1]) cylinder(d=28, h=50, center=true);
				
			}
		}
		
		difference()
		{
			translate([0, 0, 0.5])  hull()
			{
				cylinder(d=dia, h=1, center=true);
				translate([0, 0, heigth]) rotate([forward_tilt, 0, 0]) cylinder(d=dia, h=1, center=true);
				
			}
			//hole();
		}
	}
	module hole()
	{
		translate([0, offset-0.5, 0])  difference() {
			translate([0, 0, 8]) cylinder(d=44, h=20, center=true);
			translate([0, 0, 8]) cylinder(d=28, h=25, center=true);
			for(n=[160, 240, -70])
				rotate([0, 0, n]) translate([0, 0, -3]) cube([30, 30, 25],center=false); 
		}
	}
	
	module motor_holes()
	{
		module motor_hole()
		{
			translate([0, 0, 8.2-2]) rotate([180, 0, 0]) {
			// hole screw
				translate([0, 0, -5])  cylinder(d=MX_hole, h=heigth+10, center=false);
				// head screw
				cylinder(d=MX_head_hole, h=MX_head_heigth+heigth, center=false);
			}
		}
		
		translate([0, offset, 0]) {
				
			rotate([forward_tilt, 0, 0]) translate([0, 0, 0])   {
				// motor center hole
				translate([0, 0, -2])  cylinder(d=8.2, h=heigth+7, center=false);
				for(n=[0,1])
				{
					rotate([0, 0, n*180+90]) translate([19/2, 0, 0])  {
						motor_hole();
					}
					rotate([0, 0, n*180]) translate([16/2, 0, 0])  {
						motor_hole();
					}
				
				}
			}
		}
	}

	module fixing_hex_holes()
	{
		
		for(n=[])
		{
			rotate([0, 0, n*90+45]) {
			
				translate([19/2, 0, 0]) { 
					translate([0, 0, -5]) cylinder(d=MX_hole, h=heigth+10, center=false);

					translate([0, 0, 1.8]) rotate([0, 0, 30])  hexaprismx(ri=(MX_hexa)/2, h=2.81);
					translate([0, 0, 1.8+2.8]) rotate([0, 0, 30])  hexaprismx(ri=(MX_hexa-0.2)/2, h=10);
					
				}
			}
		}
		for(n=[0,2,3])
		{
			rotate([0, 0, n*90]) {
			
				translate([30/2, 0, 0]) { 
					translate([0, 0, -2]) cylinder(d=MX_hole, h=heigth+10, center=false);

					translate([0, 0, 1.8]) rotate([0, 0, 30])  hexaprismx(ri=(MX_hexa)/2, h=2.81);
					translate([0, 0, 1.8+2.8]) rotate([0, 0, 30])  hexaprismx(ri=(MX_hexa-0.2)/2, h=heigth);
					
				}
			}
		}
	}
	
	translate([0, 0, 0]) {
		difference()
		{
			plain();
			hole();
			motor_holes();
			fixing_hex_holes();
		}
		if (full) {
			rotate([forward_tilt, 0, 0]) translate([0, 1, 0])   {
				color("aqua", 0.2) translate([0, 0, heigth+1.5]) {
					difference() {
					 cylinder(d=28, h=32, center=false);
					 translate([0, 0, -1]) cylinder(d=27, h=34, center=false);
					 
					 }
				}  
						
		   }
	   
	   }
	}
}


module fullview()
{
	module hh(delta=0, h=38)
	{
		hull() {
			translate([0, 0, h])  cylinder(d=42+delta, h=h, center=false);
			translate([0, 0, 0])  cylinder(d=42+delta, h=h, center=false);
			
		}
		
	}
	module xx(h=35)
	{
		translate([0, 0, -42]) difference() {
			translate([0, 0, 0]) hh(delta=1, h = 38);
			translate([0, 0, -0.1]) hh(delta=0, h = 39);
		}
		
	}

	if (full) {
		translate([0, -1, 0])   {
			rotate([-8, 0, 0])  translate([0, 0, 0])  color("magenta", 0.2) xx();
	   	}
		for(n=[0:3])
		{
			rotate([0, 0, n*90+45]) {
			
				translate([19/2, 0, 0]) { 
					translate([0, 0, -10]) cylinder(d=2, h=20, center=false);
				}
			}
			
		}
	}
				
	
}
fullview();

translate([0, 0, 0]) motor_tilt(forward_tilt = 5);
//translate([0, 40, 0]) motor_tilt(forward_tilt = 3);
//translate([-20, 0, 0]) import("stl/motor spacer 5degrees.STL");

