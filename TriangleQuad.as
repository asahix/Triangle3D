package  {
	
	public class TriangleQuad extends TriangleMesh{
		//中心四边形片面 这个片面会构建2个特殊的TriangleQuadUnit
		//中心四边形单元拥有1个中心
		public var quadWidth:Number;
		public var quadHeight:Number;//半高
		protected var standWidth:Number;//对角线
		public var ADMode:Boolean;//广告版
		public function TriangleQuad(w:Number,h:Number,map:TriangleMaterial) {
			// constructor code
			//w h为片面的长和宽；程序会根据wh自动创建2个TriangleQuadUnit
			//片面有两种显示方式 第一种是作为可连接片面呈现3维效果，第二种是作为广告版呈现在画面顶层（始终正对摄影机）
			ADMode=true;
			quadWidth=w/2;
			quadHeight=h/2;
			standWidth=Math.sqrt(w*w+h*h);//对角线长度
			var p0:TriangleVertex=new TriangleVertex(-quadWidth,-quadHeight,0,0,0);
			var p1:TriangleVertex=new TriangleVertex(quadWidth,-quadHeight,0,1,0);
			var p2:TriangleVertex=new TriangleVertex(quadWidth,quadHeight,0,1,1);
			var p3:TriangleVertex=new TriangleVertex(-quadWidth,quadHeight,0,0,1);
			super([new TriangleQuadUnit(p0,p1,p2,p3)],map);
			
		}

	}
	
}
