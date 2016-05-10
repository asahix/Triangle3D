package  {
	import flash.geom.Point;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	public class TriangleSkyBox {
		//可变动天空盒子，这个类用于组织和显示天空盒 这个类只能用于TriangleView对象
		protected var boxRaidus:Number;//天空盒的尺寸 天空盒会包围摄影机到中间
		protected var leftMap:TriangleMaterial;
		protected var rightMap:TriangleMaterial;
		protected var upMap:TriangleMaterial;
		protected var downMap:TriangleMaterial;
		protected var frontMap:TriangleMaterial;
		protected var backMap:TriangleMaterial;
		//
		protected var p1:TriangleVertex;//上面定点
		protected var p2:TriangleVertex;
		protected var p3:TriangleVertex;
		protected var p4:TriangleVertex;
		protected var p5:TriangleVertex;//下面顶点Y
		protected var p6:TriangleVertex;
		protected var p7:TriangleVertex;
		protected var p0:TriangleVertex;
		protected var p8:TriangleVertex;
		protected var p10:TriangleVertex;
		protected var p9:TriangleVertex;
		protected var p11:TriangleVertex;//上面定点
		protected var p12:TriangleVertex;
		protected var p13:TriangleVertex;
		protected var p14:TriangleVertex;
		protected var p15:TriangleVertex;//下面顶点Y
		protected var p16:TriangleVertex;
		protected var p17:TriangleVertex;
		protected var p20:TriangleVertex;
		
		protected var p18:TriangleVertex;//上面定点
		protected var p19:TriangleVertex;
		
		protected var p21:TriangleVertex;
		protected var p22:TriangleVertex;//下面顶点Y
		protected var p23:TriangleVertex;
		
		//
		protected var t0:TriangleUnit;
		protected var t1:TriangleUnit;//up
		
		protected var t2:TriangleUnit;
		protected var t3:TriangleUnit;//front
		
		protected var t4:TriangleUnit;
		protected var t5:TriangleUnit;//down
		
		protected var t6:TriangleUnit;
		protected var t7:TriangleUnit;//back
		
		protected var t8:TriangleUnit;
		protected var t9:TriangleUnit;//left
		
		protected var t10:TriangleUnit;
		protected var t11:TriangleUnit;//right
		

		
		public function TriangleSkyBox(br:Number,left:BitmapData,right:BitmapData,up:BitmapData,down:BitmapData,front:BitmapData,back:BitmapData) {
			// constructor code
			//
			boxRaidus=br;
			//
			backMap=new TriangleMaterial(back,false,0x000000,1,true,0.25,0xFFFFFF);
			leftMap=new TriangleMaterial(left,false,0x000000,1,true,0.25,0xFFFFFF);
			rightMap=new TriangleMaterial(right,false,0x000000,1,true,0.25,0xFFFFFF);
			downMap=new TriangleMaterial(down,false,0x000000,1,true,0.25,0xFFFFFF);
			upMap=new TriangleMaterial(up,false,0x000000,1,true,0.25,0xFFFFFF);
			frontMap=new TriangleMaterial(front,false,0x000000,1,true,0.25,0xFFFFFF);
			backMap=new TriangleMaterial(back,false,0x000000,1,true,0.25,0xFFFFFF);
			//下面创建6个面的定点（8个点）
			p0=new TriangleVertex(0,0,0,0,0);
			p1=new TriangleVertex(0,0,0,1,0);
			p2=new TriangleVertex(0,0,0,1,1);
			p3=new TriangleVertex(0,0,0,0,1);//用于顶面和底面 up
			//
			p4=new TriangleVertex(0,0,0,0,0);
			p5=new TriangleVertex(0,0,0,1,0);
			p6=new TriangleVertex(0,0,0,1,1);
			p7=new TriangleVertex(0,0,0,0,1);//用于front
			//
			p8=new TriangleVertex(0,0,0,0,0);
			p9=new TriangleVertex(0,0,0,1,0);
			p10=new TriangleVertex(0,0,0,1,1);
			p11=new TriangleVertex(0,0,0,0,1);//用于down
			//
			p12=new TriangleVertex(0,0,0,0,0);
			p13=new TriangleVertex(0,0,0,1,0);
			p14=new TriangleVertex(0,0,0,1,1);
			p15=new TriangleVertex(0,0,0,0,1);//用于back
			//
			p16=new TriangleVertex(0,0,0,0,0);
			p17=new TriangleVertex(0,0,0,1,0);
			p18=new TriangleVertex(0,0,0,1,1);
			p19=new TriangleVertex(0,0,0,0,1);//用于left
			
			//
			p20=new TriangleVertex(0,0,0,0,0);
			p21=new TriangleVertex(0,0,0,1,0);
			p22=new TriangleVertex(0,0,0,1,1);
			p23=new TriangleVertex(0,0,0,0,1);//用于right
			//下面用这些定点组成12个三角形
			t0=new TriangleUnit(p0,p1,p2);
			t1=new TriangleUnit(p0,p2,p3);
			
			t2=new TriangleUnit(p4,p5,p6);
			t3=new TriangleUnit(p4,p6,p7);
			
			t4=new TriangleUnit(p8,p9,p10);
			t5=new TriangleUnit(p8,p10,p11);
			
			t6=new TriangleUnit(p12,p13,p14);
			t7=new TriangleUnit(p12,p14,p15);
			
			t8=new TriangleUnit(p16,p17,p18);
			t9=new TriangleUnit(p18,p19,p16);
			
			t10=new TriangleUnit(p20,p21,p22);
			t11=new TriangleUnit(p22,p23,p20);
			
			t0.material=t1.material=upMap;
			
			t2.material=t3.material=frontMap;
			t4.material=t5.material=downMap;
			t6.material=t7.material=backMap;
			t8.material=t9.material=leftMap;
			t10.material=t11.material=rightMap;
			
		}
		public function render(g:Graphics,camera:TriangleCamera){
			var center:Point=camera.screenCenter;
			var mat:Matrix3D=camera.ViewMatrix3D;
			var sx:Number=camera.x-boxRaidus;
			var sy:Number=camera.y-boxRaidus;
			var sz:Number=camera.z-boxRaidus;
			var ax:Number=camera.x+boxRaidus;
			var ay:Number=camera.y+boxRaidus;
			var az:Number=camera.z+boxRaidus;
			//
			p0.x=sx;
			p0.y=sy;
			p0.z=sz;
			p1.x=sx;
			p1.y=sy;
			p1.z=ay;
			p2.x=ax;
			p2.y=sy;
			p2.z=ay;
			p3.x=ax;
			p3.y=sy;
			p3.z=sy;
			//
			p4.x=sx;
			p4.y=sy;
			p4.z=az;
			p5.x=ax;
			p5.y=sy;
			p5.z=ay;
			p6.x=ax;
			p6.y=ay;
			p6.z=ay;
			p7.x=sx;
			p7.y=ay;
			p7.z=az;
			//
			
			p8.x=sx;
			p8.y=ay;
			p8.z=az;
			p9.x=ax;
			p9.y=ay;
			p9.z=az;
			p10.x=ax;
			p10.y=ay;
			p10.z=sy;
			p11.x=sx;
			p11.y=ay;
			p11.z=sz;
			
			//
			t0.ca_depth(camera);
			t1.ca_depth(camera);
			t2.ca_depth(camera);
			t3.ca_depth(camera);
			t4.ca_depth(camera);
			t5.ca_depth(camera);
			/*t6.ca_depth(camera);
			t7.ca_depth(camera);
			t8.ca_depth(camera);
			t9.ca_depth(camera);
			t10.ca_depth(camera);
			t11.ca_depth(camera);*/
			//trace("skyDRAW"+p0+"  "+p1+"   "+p2+"   "+p3);
			t0.drawTrangle(g,center,mat,null,"positive");
			t1.drawTrangle(g,center,mat,null,"positive");
			
			t2.drawTrangle(g,center,mat,null,"positive");
			t3.drawTrangle(g,center,mat,null,"positive");
			t4.drawTrangle(g,center,mat,null,"positive");
			t5.drawTrangle(g,center,mat,null,"positive");
			/*t6.drawTrangle(g,center,mat,null,"positive");
			t7.drawTrangle(g,center,mat,null,"positive");
			t8.drawTrangle(g,center,mat,null,"positive");
			t9.drawTrangle(g,center,mat,null,"positive");
			t10.drawTrangle(g,center,mat,null,"positive");
			t11.drawTrangle(g,center,mat,null,"positive");*/
		}
	}
	
}
