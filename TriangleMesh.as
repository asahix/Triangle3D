package  {
	//mesh 为三维实体的核心
	import flash.geom.Vector3D;
	public class TriangleMesh{
		public var geometry:Array;//三角形集合
		protected var _material:TriangleMaterial;//材质
		public var visible:Boolean;//是否绘制
		public var transform:TriangleTransform;//模型的缩放以及旋转矩阵内核
		public function TriangleMesh(tarr:Array,mat:TriangleMaterial) {
			// constructor code
			geometry=tarr;
			material=mat;
			for each(var tmp:TriangleUnit in tarr){
				tmp.parentMesh=this;
			}
			transform=new TriangleTransform();
			visible=true;
		}
		public function clone(dc:Boolean=false):TriangleMesh{//传入true进行顶点深拷贝 
			var arr:Array=new Array();
			for each(var tmp:TriangleUnit in geometry){
				arr.push(tmp.clone(dc));
			}
			return new TriangleMesh(arr,_material);
		}
		public function set material(m:TriangleMaterial){
			_material=m;
			for each(var tmp:TriangleUnit in geometry){
				tmp.material=m;
			}
		}
		public function get material():TriangleMaterial{
			return _material;
		}
		public function picking(orig:Vector3D,dir:Vector3D,minAble:Boolean=false):Vector3D{
			//返回射线与内部三角形的焦点 如果设置minAble为true 则进行顶点距离筛选否则返回第一个焦点（不判断方向）
			var re:Vector3D;
			var tmparr:Array;
			var tmp:TriangleUnit;
			if(minAble){
				tmparr=new Array();
				for each(tmp in geometry){
					re=tmp.intersectTriangle(orig,dir);
					if(re!=null){
						tmparr.push(re);
					}
				}
				for each(var np:Vector3D in tmparr){
					np.w=Vector3D.distance(np,orig);
				}
				tmparr.sortOn("w",Array.DESCENDING | Array.NUMERIC);
				re=tmparr[0];
			}else{
				for each(tmp in geometry){
					re=tmp.intersectTriangle(orig,dir);
					if(re!=null){
						break;
					}
				}
			}
			return re;
		}
	}
	
}
