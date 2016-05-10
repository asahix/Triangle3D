package  {
	import flash.display.TriangleCulling;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Graphics;
	public class TriangleView{
		//所有显示的三角形将被绘制到这里
		public var buffRect:Rectangle;//绘制的范围，如果三角形超出这个范围则不进行绘制一般情况下这个范围略大于舞台范围
		public var camera:TriangleCamera;//摄影机，存储了绘画矩阵
		protected var _meshs:Array;//存放需要绘制的mesh 
		protected var _triangleArray:Array;
		public var triangleCulling:String;
		//
		public var skybox:TriangleSkyBox;//天空盒
		public function TriangleView(rect:Rectangle,cam:TriangleCamera=null,culling:String="positive") {
			// constructor code
			_meshs=new Array();
			triangleCulling=culling;
			buffRect=rect;
			_triangleArray=new Array();
			camera=cam || new TriangleCamera(45,new Point(rect.x+rect.width/2,rect.y+rect.height/2));//得到本地摄影机
		}
		public function addChild(mesh:TriangleMesh){
			_meshs.push(mesh);
			updateTriangleArray();
		}
		protected function updateTriangleArray(){
			_triangleArray=new Array();
			for each(var mesh:TriangleMesh in _meshs){
				if(mesh.visible){
					_triangleArray=_triangleArray.concat(mesh.geometry);
				}
			}
		}
		public function removeChild(mesh:TriangleMesh){
			var id:int=_meshs.indexOf(mesh);
			if(id!=-1){
				_meshs.splice(id,1);
				updateTriangleArray();
			}
		}
		public function render(g:Graphics){
			
			g.clear();
			if(skybox!=null){
				skybox.render(g,camera);
			}
			//下面将所有的mesh的三角形都放在一个数组里
			//下面计算与摄影机的相对位置距离越近的越先画
			for each(var tmp:TriangleUnit in _triangleArray){
				//计算与摄影机权值确定哪个图形会被显示
				tmp.ca_depth(camera);
			}
			var drawArr:Array=new Array();
			//trace(_triangleArray.length);
			for each(tmp in _triangleArray){
				if(camera.farView>=tmp.depth){//计算是否绘制三角形
				
					drawArr.push(tmp);
				}
			}
			//确定了需要绘制的三角形准备投影计算和api
			drawArr.sortOn("depth",Array.DESCENDING | Array.NUMERIC);
			//trace("可画的="+drawArr.length);
			var i:int;
			var len:int=drawArr.length;
			for(i=0;i<len;i++){
				drawArr[i].drawTrangle(g,camera.screenCenter,camera.ViewMatrix3D,buffRect,triangleCulling);
			}
		}
	}
	
}
