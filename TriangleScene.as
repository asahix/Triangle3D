package  {
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	public class TriangleScene {
		//新的场景管理
		protected var _meshs:Array;//存放需要绘制的mesh 
		protected var _triangleArray:Array;
		public var skybox:TriangleSkyBox;//天空盒
		protected var _effect:Array;//TriangleEffectBase;//特效控制器 目前支持的是fog 和 light
		public function TriangleScene() {
			// constructor code
			_effect=new Array();
			_meshs=new Array();
			_triangleArray=new Array();
		}
		
		public function addEffect(eff:TriangleEffectBase){
			_effect.push(eff);
		}
		public function removeEffect(eff:TriangleEffectBase){
			var ind:int=_effect.indexOf(eff);
			if(ind!=-1){
				_effect.splice(ind,1);
			}
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
		public function renderScene(g:Graphics,camera:TriangleCamera,buffRect:Rectangle,triangleCulling:String){
			g.clear();
			if(skybox!=null){
				skybox.render(g,camera,buffRect);
			}
			//下面将所有的mesh的三角形都放在一个数组里
			//下面计算与摄影机的相对位置距离越近的越先画
			var i:int;
			var len:int=_triangleArray.length;
			var drawArr:Array=new Array();
			var fv:Number=camera.farView;
			var tmp:TriangleUnit;
			for (i=0;i<len;i++){
				//计算与摄影机权值确定哪个图形会被显示
				tmp=_triangleArray[i];
				tmp.ca_depth(camera);
				if(fv>=tmp.depth){
					drawArr.push(tmp);
				}
			}
			//确定了需要绘制的三角形准备投影计算和api
			drawArr.sortOn("depth",Array.DESCENDING | Array.NUMERIC);
			len=drawArr.length;
			var len2:int=_effect.length;
			var j:int;
			for(i=0;i<len;i++){
				tmp=drawArr[i];
				if(tmp.drawTrangle(g,camera.screenCenter,camera.ViewMatrix3D,buffRect,triangleCulling))
				{
					for(j=0;j<len2;j++){
						_effect[j].renderEffect(g,tmp);
					}
				}
			}
		}
	}
	
}
