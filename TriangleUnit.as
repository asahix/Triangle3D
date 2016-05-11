package  {
	//三角形基元 
	import flash.display.Graphics;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.geom.Utils3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TriangleUnit {
		protected var _p0:TriangleVertex;
		protected var _p1:TriangleVertex;
		protected var _p2:TriangleVertex;
		public var material:TriangleMaterial;//顶点的贴图
		public var parentMesh:TriangleMesh;//实体
		public var depth:Number;//这个值决定了哪个三角形会被先绘制
		protected var _p0tmp:Vector3D;
		protected var _p1tmp:Vector3D;
		protected var _p2tmp:Vector3D;//相对于摄影机的位置
		protected var _p0tmpR:Vector3D;//实际绕转位置 这三个值会在ca_depth中计算
		protected var _p1tmpR:Vector3D;
		protected var _p2tmpR:Vector3D;
		protected static const TRIANGLE_INDEX:Vector.<int>=Vector.<int>([0,1,2]);
		protected var _uv:Vector.<Number>;
		public var drawBuffer:Vector.<Number>;//正常状态下是否绘制了 这样在下次绘制的时候将不需要进行检查
		
		public function clone(dc:Boolean=false):TriangleUnit{//传入true则进行顶点深拷贝
			var re:TriangleUnit;
			if(dc){
				re=new TriangleUnit(_p0.cloneVertex(),_p1.cloneVertex(),_p2.cloneVertex());
			}else{
				re=new TriangleUnit(_p0,_p1,_p2);
			}
			return re;
		}
		public function get Center():Vector3D{
			//返回当前三角形的三角中心所在//实际位置
			var re:Vector3D=new Vector3D(_p0tmpR.x+_p1tmpR.x+_p2tmpR.x,_p0tmpR.y+_p1tmpR.y+_p2tmpR.y,_p0tmpR.z+_p1tmpR.z+_p2tmpR.z);
			re.scaleBy(0.3);
			return re;
		}
		public function TriangleUnit(p1:TriangleVertex,p2:TriangleVertex,p3:TriangleVertex) {
			// constructor code
			_p0=p1;
			_p1=p2;
			_p2=p3;
			
			_p0tmp=new Vector3D();
			_p1tmp=new Vector3D();
			_p2tmp=new Vector3D();
			_p0tmpR=new Vector3D();
			_p1tmpR=new Vector3D();
			_p2tmpR=new Vector3D();
			_uv=new Vector.<Number>([]);
		}
		//public function get vertex_real():Vector.<Number>{
			//return Vector.<Number>([_p0tmpR.x,_p0tmpR.y,_p0tmpR.z,_p1tmpR.x,_p1tmpR.y,_p1tmpR.z,_p2tmpR.x,_p2tmpR.y,_p2tmpR.z]);
		//}
		/*public function get vertex():Vector.<Number>{
			//返回顶点位置的向量
			return Vector.<Number>([_p0tmp.x,_p0tmp.y,_p0tmp.z,_p1tmp.x,_p1tmp.y,_p1tmp.z,_p2tmp.x,_p2tmp.y,_p2tmp.z]);
		}
		public function get uv():Vector.<Number>{
			return Vector.<Number>([_p0.u,_p0.v,1,_p1.u,_p1.v,1,_p2.u,_p2.v,1]);
		}
		public function get index():Vector.<int>{
			return TRIANGLE_INDEX;
		}*/
		public function ca_depth(cam:TriangleCamera){
			_p0tmpR.x=_p0.x;
			_p0tmpR.y=_p0.y;
			_p0tmpR.z=_p0.z;
			
			_p1tmpR.x=_p1.x;
			_p1tmpR.y=_p1.y;
			_p1tmpR.z=_p1.z;
			
			_p2tmpR.x=_p2.x;
			_p2tmpR.y=_p2.y;
			_p2tmpR.z=_p2.z;
			
			//根据
			if(parentMesh!=null){
				var parentPos:Vector3D=parentMesh.transform;
			//绕转自身
				var meshmat:Matrix3D=parentMesh.transform.transformMatrix3D;
			
				_p0tmpR=meshmat.transformVector(_p0tmpR);
				_p1tmpR=meshmat.transformVector(_p1tmpR);
				_p2tmpR=meshmat.transformVector(_p2tmpR);
			
				_p0tmpR.x+=parentPos.x;
				_p0tmpR.y+=parentPos.y;
				_p0tmpR.z+=parentPos.z;
			
				_p1tmpR.x+=parentPos.x;
				_p1tmpR.y+=parentPos.y;
				_p1tmpR.z+=parentPos.z;
			
				_p2tmpR.x+=parentPos.x;
				_p2tmpR.y+=parentPos.y;
				_p2tmpR.z+=parentPos.z;
			
			}
			_p0tmp.x=_p0tmpR.x;
			_p0tmp.y=_p0tmpR.y;
			_p0tmp.z=_p0tmpR.z;
			
			_p1tmp.x=_p1tmpR.x;
			_p1tmp.y=_p1tmpR.y;
			_p1tmp.z=_p1tmpR.z;
			
			_p2tmp.x=_p2tmpR.x;
			_p2tmp.y=_p2tmpR.y;
			_p2tmp.z=_p2tmpR.z;
			//先计算自身的绕转
			//下面计算顶点与摄影机的相对位置
			_p0tmp.x-=cam.x;
			_p0tmp.y-=cam.y;
			_p0tmp.z-=cam.z;
			
			_p1tmp.x-=cam.x;
			_p1tmp.y-=cam.y;
			_p1tmp.z-=cam.z;
			
			_p2tmp.x-=cam.x;
			_p2tmp.y-=cam.y;
			_p2tmp.z-=cam.z;
			
			//
			//根据摄影机矩阵进行绕转
			var cammat:Matrix3D=cam.transformMatrix;
			_p0tmp=cammat.transformVector(_p0tmp);
			_p1tmp=cammat.transformVector(_p1tmp);
			_p2tmp=cammat.transformVector(_p2tmp);
			
			//计算相对位置
			
			//计算三个顶点到摄影机的距离并以最低的为三角形的绘制depth
			var dis0:Number=Vector3D.distance(cam,_p0tmp);
			var dis1:Number=Vector3D.distance(cam,_p1tmp);
			var dis2:Number=Vector3D.distance(cam,_p2tmp);
			var min:Number=dis0;
			if(dis1<min){
				min=dis1;
			}
			if(dis2<min){
				min=dis2;
			}
			depth=min;//计算结果用于深度排序
			//trace(depth);
		}
		public function drawTrangle(g:Graphics,center:Point,mat:Matrix3D,rect:Rectangle=null,culling:String="none"):Boolean{
			//绘制自己
			//新引擎中所有的绘制工作都交给了三角形
			var tmp:Vector.<Number>=new Vector.<Number>();//投影结果
			var tmpuv:Vector.<Number>=Vector.<Number>([_p0.u,_p0.v,1,_p1.u,_p1.v,1,_p2.u,_p2.v,1]);
			Utils3D.projectVectors(mat,Vector.<Number>([_p0tmp.x,_p0tmp.y,_p0tmp.z,_p1tmp.x,_p1tmp.y,_p1tmp.z,_p2tmp.x,_p2tmp.y,_p2tmp.z]),tmp,tmpuv);//投影
			
			
			
			drawBuffer=new Vector.<Number>();
			var re:Boolean=false;
			if(tmpuv[2]>=0 && tmpuv[5]>=0 && tmpuv[8]>=0){
			
			var cx:Number=center.x;
			var cy:Number=center.y;
			var n1x:Number=tmp[0]+cx;
			var n1y:Number=tmp[1]+cy;
			var n2x:Number=tmp[2]+cx;
			var n2y:Number=tmp[3]+cy;
			var n3x:Number=tmp[4]+cx;
			var n3y:Number=tmp[5]+cy;
			tmp[0]=n1x;
			tmp[1]=n1y;
			tmp[2]=n2x;
			tmp[3]=n2y;
			tmp[4]=n3x;
			tmp[5]=n3y;
			var rx:Number=rect.x;
			var ry:Number=rect.y;
			var rw:Number=rect.width;
			var rh:Number=rect.height;
			
			if(!(n1x<rx || n1y<ry ||n1x>rw ||n1y>rh) || !(n2x<rx || n2y<ry ||n2x>rw ||n2y>rh) || !(n3x<rx || n3y<ry ||n3x>rw ||n3y>rh)){
				if(material.lineAble){
					g.lineStyle(material.thickness,material.lineColor,material.lineAlpha);
				}else{
					g.lineStyle(NaN);
				}
				if(material.texture!=null){
					g.beginBitmapFill(material.texture,null,material.repeat,material.smooth);
					g.drawTriangles(tmp,TRIANGLE_INDEX,tmpuv,culling);
					g.endFill();
					drawBuffer=tmp;
					re=true;
				}
				if(material.colorAble){
					g.beginFill(material.color,material.colorAlpha);
					g.drawTriangles(tmp,null,null,culling);
					g.endFill();
					drawBuffer=tmp;
					re=true;
				}
			}
			}
			return re;
		}
		public function intersectTriangle(orig:Vector3D,dir:Vector3D):Vector3D{
    		var v0:Vector3D=_p0tmp;
			var v1:Vector3D=_p1tmp;
			var v2:Vector3D=_p2tmp;
				// E1
    		var E1:Vector3D = new Vector3D(v1.x - v0.x,v1.y-v0.y,v1.z-v0.z);
     			// E2
     		var E2:Vector3D = new Vector3D(v2.x - v0.x,v2.y-v0.y,v2.z-v0.z);
     			// P
		    var P:Vector3D = dir.crossProduct(E2);
				// determinant
			var det:Number = E1.dotProduct(P);
			    // keep det > 0, modify T accordingly
	    	var T:Vector3D;
			if( det >0 ){
         		T =new Vector3D(orig.x - v0.x,orig.y-v0.y,orig.z-v0.z);
     		}else{
			    T =new Vector3D(v0.x - orig.x,v0.y-orig.y,v0.z-orig.z);
				det = -det;
     		}
  				// If determinant is near zero, ray lies in plane of triangle
     		if( det < 0.0001){
         		return null;
			}
     			// Calculate u and make sure u <= 1
     		var u:Number = T.dotProduct(P);
			if( u < 0 || u > det ){
         		return null;
			}
		    	 // Q
			var Q:Vector3D = T.crossProduct(E1);
		    	 // Calculate v and make sure u + v <= 1
			var v:Number = dir.dotProduct(Q);
      		if( v < 0 || u + v > det ){
          		return null;
			}
 		     	// Calculate t, scale parameters, ray intersects triangle
 		    var t:Number = E2.dotProduct(Q);
 			var fInvDet:Number = 1 / det;
			t *= fInvDet;
			u *= fInvDet;
     		v *= fInvDet;
			var re:Vector3D=orig.clone();
			var dir2:Vector3D=dir.clone();
			dir2.scaleBy(t);
			re.add(dir2);
    		return re;
		}
	}
}
