package  {
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	public class TriangleLight extends TriangleEffectBase{
		public var applyArray:Array;//灯光影响的mesh
		public var lightColor:uint;//亮色
		public var lightAlpha:Number;//亮色alpha
		public var darkColor:uint;//暗色
		public var darkAlpha:Number;//暗色alpha
		public var lightstart:Number;//亮区，灯光亮区的三角形是以最亮显示
		public var lightend:Number;//亮区远端
		public var darkstart:Number;//暗区，灯光暗区的三角形以最暗显示
		public var darkend:Number;//暗区远端
		public function TriangleLight(lc:uint=0xFFFFFF,la:Number=1,dc:uint=0x000000,da:Number=1,ls:Number=0,lend:Number=300,ds:Number=300,dend:Number=500) {
			// constructor code
			
			applyArray=new Array();
			lightColor=lc;
			lightAlpha=la;
			darkColor=dc;
			darkAlpha=da;
			setLightArea(ls,lend,ds,dend);
		}
		public function setLightArea(ls:Number=0,lend:Number=300,ds:Number=300,dend:Number=500){
			lightstart=ls;
			lightend=lend;
			darkstart=ds;
			darkend=dend;
		}
		override public function renderEffect(g:Graphics,u:TriangleUnit){
			if(darkstart>=lightend &&lightend>0){
			var i:int;
			var len:int=applyArray.length;
			var disU:Number=0;
			var talp:Number=0;
			var tc:uint;
			//trace(len);
			for(i=0;i<len;i++){
				//trace(applyArray[0]);
				if(u.parentMesh==applyArray[i]){//处于渲染状态
					disU=Vector3D.distance(this,u.Center);//三角形距离
					
					if(disU>=lightend && disU<=darkstart){
						//trace(44);
					}else if(disU<=lightstart){
						talp=1;
						tc=lightColor;
						//trace(48);
						g.beginFill(tc,talp);
						g.drawTriangles(u.drawBuffer);
						g.endFill();
					}else if(disU>lightstart && disU<=lightend){
						talp=(lightend-disU)/(lightend-lightstart);
						tc=lightColor;
						//trace(55);
						g.beginFill(tc,talp);
						g.drawTriangles(u.drawBuffer);
						g.endFill();
					}else if(disU>=darkend){
						talp=1;
						//trace(61);
						tc=darkColor;
						g.beginFill(tc,talp);
						g.drawTriangles(u.drawBuffer);
						g.endFill();
					}else if(disU>darkstart && disU<=darkend){
						talp=1-((darkend-disU)/(darkend-darkstart));
						//trace(69);
						tc=darkColor;
						g.beginFill(tc,talp);
						g.drawTriangles(u.drawBuffer);
						g.endFill();
					}
					break;
				}
			}
			}
			
		}
	}
}
