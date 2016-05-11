package  {
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	public class TriangleFog extends TriangleEffectBase{
		public var fogColor:uint;
		public var minDis:Number;//距离摄影机的距离小于这个值则完全不显示雾效 
		public var maxDis:Number;//距离摄影机距离大于这个值则完全显示特效
		public var fogAlpha:Number;//完全显示特效浓度的透明度
		public var camera:TriangleCamera;//摄影机的引用，用于获得距离参数
		public function TriangleFog(cam:TriangleCamera,color:uint=0xFFFFFF,alp:Number=1,min:Number=0,max:Number=0) {
			// constructor code
			camera=cam;
			fogColor=color;
			fogAlpha=alp;
			minDis=min;
			maxDis=max;
		}
		override public function renderEffect(g:Graphics,u:TriangleUnit){
			var tmpdis:Number=Vector3D.distance(u.Center,camera);//首先计算三角形距离摄影机的距离
			var talp:Number;
			//trace("dis="+tmpdis);
			if(tmpdis<=minDis || maxDis<=minDis){
				
			}else if(tmpdis>=maxDis){
				
				g.beginFill(fogColor,fogAlpha);
				g.drawTriangles(u.drawBuffer);
				g.endFill();
			}else{
				talp=(tmpdis-minDis)/(maxDis-minDis);
				//trace("talp="+talp);
				g.beginFill(fogColor,talp*fogAlpha);
				g.drawTriangles(u.drawBuffer);
				g.endFill();
			}
			
		}

	}
	
}
