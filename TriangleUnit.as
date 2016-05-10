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
		protected var _p2tmp:Vector3D;
		public static const TRIANGLE_INDEX:Vector.<int>=Vector.<int>([0,1,2]);
		public function clone(dc:Boolean=false):TriangleUnit{//传入true则进行顶点深拷贝
			var re:TriangleUnit;
			if(dc){
				re=new TriangleUnit(_p0.cloneVertex(),_p1.cloneVertex(),_p2.cloneVertex());
			}else{
				re=new TriangleUnit(_p0,_p1,_p2);
			}
			return re;
		}
		public function TriangleUnit(p1:TriangleVertex,p2:TriangleVertex,p3:TriangleVertex) {
			// constructor code
			_p0=p1;
			_p1=p2;
			_p2=p3;
			
		}
		public function get vertex():Vector.<Number>{
			//返回顶点位置的向量
			return Vector.<Number>([_p0tmp.x,_p0tmp.y,_p0tmp.z,_p1tmp.x,_p1tmp.y,_p1tmp.z,_p2tmp.x,_p2tmp.y,_p2tmp.z]);
		}
		public function get uv():Vector.<Number>{
			return Vector.<Number>([_p0.u,_p0.v,1,_p1.u,_p1.v,1,_p2.u,_p2.v,1]);
		}
		public function ca_depth(cam:TriangleCamera){
			//
			//trace("ca_depth");
			_p0tmp=_p0.clone();
			_p1tmp=_p1.clone();
			_p2tmp=_p2.clone();
			//根据
			if(parentMesh!=null){
				var parentPos:Vector3D=parentMesh.transform;
			//绕转自身
				var meshmat:Matrix3D=parentMesh.transform.transformMatrix3D;
			
				_p0tmp=meshmat.transformVector(_p0tmp);
				_p1tmp=meshmat.transformVector(_p1tmp);
				_p2tmp=meshmat.transformVector(_p2tmp);
			
				_p0tmp.x+=parentPos.x;
				_p0tmp.y+=parentPos.y;
				_p0tmp.z+=parentPos.z;
			
				_p1tmp.x+=parentPos.x;
				_p1tmp.y+=parentPos.y;
				_p1tmp.z+=parentPos.z;
			
				_p2tmp.x+=parentPos.x;
				_p2tmp.y+=parentPos.y;
				_p2tmp.z+=parentPos.z;
			
			}
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
		public function drawTrangle(g:Graphics,center:Point,mat:Matrix3D,rect:Rectangle=null,culling:String="none"){
			//绘制自己
			//新引擎中所有的绘制工作都交给了三角形
			var tmp:Vector.<Number>=new Vector.<Number>();//投影结果
			var tmpuv:Vector.<Number>=uv;
			Utils3D.projectVectors(mat,vertex,tmp,tmpuv);//投影
			//trace(tmp);
			//trace(mat);
			if(tmpuv[2]>0){
			tmp[0]+=center.x;
			tmp[2]+=center.x;
			tmp[4]+=center.x;
			tmp[1]+=center.y;
			tmp[3]+=center.y;
			tmp[5]+=center.y;
			if(rect!=null){
				if(rect.contains(tmp[0],tmp[1]) ||rect.contains(tmp[2],tmp[3])||rect.contains(tmp[4],tmp[5])){
					if(material.lineAble){
						g.lineStyle(material.thickness,material.lineColor,material.lineAlpha);
					}else{
						g.lineStyle(NaN);
					}
					if(material.texture!=null){
						g.beginBitmapFill(material.texture);
						g.drawTriangles(tmp,TRIANGLE_INDEX,tmpuv,culling);
						g.endFill();
					}
					if(material.colorAble){
						g.beginFill(material.color,material.colorAlpha);
						g.drawTriangles(tmp,null,null,culling);
						g.endFill();
					}
				}
			}else{
				if(material.lineAble){
					g.lineStyle(material.thickness,material.lineColor,material.lineAlpha);
				}else{
					g.lineStyle(NaN);
				}
				if(material.texture!=null){
					g.beginBitmapFill(material.texture);
					g.drawTriangles(tmp,TRIANGLE_INDEX,tmpuv,culling);
					g.endFill();
				}
				if(material.colorAble){
					g.beginFill(material.color,material.colorAlpha);
					g.drawTriangles(tmp,null,null,culling);
					g.endFill();
				}
			}
			}
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
