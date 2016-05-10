package  {
	import flash.geom.Vector3D;
	public class TriangleVertex extends Vector3D{
		protected var _u:Number;
		protected var _v:Number;
		public var offsetU:Number;
		public var offsetV:Number;//uv偏移
		public function TriangleVertex(nx:Number,ny:Number,nz:Number,nu:Number,nv:Number) {
			// constructor code
			super(nx,ny,nz);
			_u=nu;
			_v=nv;
			offsetU=offsetV=0;
		}
		public function cloneVertex():TriangleVertex{
			var re:TriangleVertex=new TriangleVertex(x,y,z,_u,_v);
			re.offsetU=offsetU;
			re.offsetV=offsetV;
			return re;
		}
		public function get u():Number{
			return _u+offsetU;
		}
		public function get v():Number{
			return _v+offsetV;
		}
		public static function interpolate(v1:TriangleVertex,v2:TriangleVertex,f:Number,interpolateUV:Boolean=false):TriangleVertex{
			//差值点v1 差值到v2
			var dx:Number=v2.x-v1.x;
			var dy:Number=v2.y-v1.y;
			var dz:Number=v2.z-v1.z;
			//interpolateUV开启则连uv都变换，这多用于在三角形之间进行细分的操作
			var du:Number=v2.u-v1.u;
			var dv:Number=v2.v-v1.v;
			var re:TriangleVertex;
			if(interpolateUV){
				re=new TriangleVertex(v1.x+dx*f,v1.y+dy*f,v1.z+dz*f,v1.u+du*f,v1.v+dv*f);
			}else{
				re=new TriangleVertex(v1.x+dx*f,v1.y+dy*f,v1.z+dz*f,v1.u,v1.v);
			}
			return re;
			
		}
	}
	
}
