package  {
	import flash.display.TriangleCulling;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.display.StageDisplayState;
	public class TriangleView{
		//所有显示的三角形将被绘制到这里
		public var buffRect:Rectangle;//绘制的范围，如果三角形超出这个范围则不进行绘制一般情况下这个范围略大于舞台范围
		public var camera:TriangleCamera;//摄影机，存储了绘画矩阵
		public var triangleCulling:String;
		//
		public var scene:TriangleScene;//
		public function TriangleView(rect:Rectangle,cam:TriangleCamera=null,culling:String="positive") {
			// constructor code
			
			triangleCulling=culling;
			buffRect=rect;
			camera=cam || new TriangleCamera(45,new Point(rect.x+rect.width/2,rect.y+rect.height/2));//得到本地摄影机
			scene=new TriangleScene();
		}
		public function render(g:Graphics){
			if(scene!=null){
				scene.renderScene(g,camera,buffRect,triangleCulling);
			}
		}
	}
	
}
