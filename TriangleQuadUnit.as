package  {
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.display.Graphics;
	import flash.geom.Utils3D;
	public class TriangleQuadUnit extends TriangleUnit{
		protected var _p3:TriangleVertex;
		protected var _p3tmp:Vector3D;
		protected var _p3tmpR:Vector3D;
		protected static const TRIANGLE_QUAD_INDEX:Vector.<int>=Vector.<int>([0,1,2,3,4,5]);
		public function TriangleQuadUnit(t0:TriangleVertex,t1:TriangleVertex,t2:TriangleVertex,t3:TriangleVertex) {
			// constructor code
			super(t0,t1,t2);
			_p3tmp=new Vector3D();
			_p3tmpR=new Vector3D();
			_p3=t3;
		}
		
		override public function drawTrangle(g:Graphics,center:Point,mat:Matrix3D,rect:Rectangle=null,culling:String="none"):Boolean{
			//绘制自己
			//新引擎中所有的绘制工作都交给了三角形
			var cx:Number=center.x;
			var cy:Number=center.y;
			var tmp:Vector.<Number>=new Vector.<Number>();//投影结果
			var tmpuv:Vector.<Number>=Vector.<Number>([_p0.u,_p0.v,1,_p1.u,_p1.v,1,_p2.u,_p2.v,1]);
			Utils3D.projectVectors(mat,Vector.<Number>([_p0tmp.x,_p0tmp.y,_p0tmp.z,_p1tmp.x,_p1tmp.y,_p1tmp.z,_p2tmp.x,_p2tmp.y,_p2tmp.z]),tmp,tmpuv);//投影
			var tmp2:Vector.<Number>=new Vector.<Number>();
			var tmpuv2:Vector.<Number>=Vector.<Number>([_p0.u,_p0.v,1,_p2.u,_p2.v,1,_p3.u,_p3.v,1]);
			Utils3D.projectVectors(mat,Vector.<Number>([_p0tmp.x,_p0tmp.y,_p0tmp.z,_p2tmp.x,_p2tmp.y,_p2tmp.z,_p3tmp.x,_p3tmp.y,_p3tmp.z]),tmp2,tmpuv2);//投影
			//trace(tmp);
			if(TriangleQuad(parentMesh).ADMode){
				//作为平行渲染
				/*var tmpcenter:Vector.<Number>=new Vector.<Number>();
				var tmpcuv:Vector.<Number>=Vector.<Number>([0,0,1]);
				Utils3D.projectVectors(mat,Vector.<Number>([parentMesh.transform.x,parentMesh.transform.y,parentMesh.transform.z]),tmpcenter,tmpcuv);
				//trace(tmpcenter);
				
				tmpcenter[0]+=cx;
				tmpcenter[1]+=cy;
				
				var diagonal:Number=_p;//实际对角线长度
				if(rect.contains(tmpcenter[0],tmpcenter[1])){
					//在范围内
					//绘制
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
				}*/
			}else{
				drawBuffer=new Vector.<Number>();
				
				var re:Boolean=false;
				if(tmpuv[2]>=0 && tmpuv[5]>=0 && tmpuv[8]>=0 && tmpuv2[2]>=0 && tmpuv2[5]>=0 && tmpuv2[8]>=0){
					var rx:Number=rect.x;
					var ry:Number=rect.y;
					var rw:Number=rect.width;
					var rh:Number=rect.height;
				//
					
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
				//
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
				//
				n1x=tmp2[0]+cx;
				n1y=tmp2[1]+cy;
				n2x=tmp2[2]+cx;
				n2y=tmp2[3]+cy;
				n3x=tmp2[4]+cx;
				n3y=tmp2[5]+cy;
				tmp2[0]=n1x;
				tmp2[1]=n1y;
				tmp2[2]=n2x;
				tmp2[3]=n2y;
				tmp2[4]=n3x;
				tmp2[5]=n3y;
			
				if(!(n1x<rx || n1y<ry ||n1x>rw ||n1y>rh) || !(n2x<rx || n2y<ry ||n2x>rw ||n2y>rh) || !(n3x<rx || n3y<ry ||n3x>rw ||n3y>rh)){
					if(material.lineAble){
						g.lineStyle(material.thickness,material.lineColor,material.lineAlpha);
					}else{
						g.lineStyle(NaN);
					}
					if(material.texture!=null){
						g.beginBitmapFill(material.texture,null,material.repeat,material.smooth);
						g.drawTriangles(tmp2,TRIANGLE_INDEX,tmpuv2,culling);
						g.endFill();
						drawBuffer=tmp2;
						re=true;
					}
					if(material.colorAble){
						g.beginFill(material.color,material.colorAlpha);
						g.drawTriangles(tmp2,null,null,culling);
						g.endFill();
						drawBuffer=tmp2;
						re=true;
					}
				}
			}
			}
			return re;
		}
		override public function ca_depth(cam:TriangleCamera){
			
			//根据
			_p0tmpR.x=_p0.x;
			_p0tmpR.y=_p0.y;
			_p0tmpR.z=_p0.z;
			
			_p1tmpR.x=_p1.x;
			_p1tmpR.y=_p1.y;
			_p1tmpR.z=_p1.z;
			
			_p2tmpR.x=_p2.x;
			_p2tmpR.y=_p2.y;
			_p2tmpR.z=_p2.z;
			
			_p3tmpR.x=_p3.x;
			_p3tmpR.y=_p3.y;
			_p3tmpR.z=_p3.z;
			//根据
			if(parentMesh!=null){
				var parentPos:Vector3D=parentMesh.transform;
				parentMesh.transform.lookAt(cam);
				var px:Number=parentPos.x;
				var py:Number=parentPos.y;
				var pz:Number=parentPos.z;
				//绕转自身
				var meshmat:Matrix3D=parentMesh.transform.transformMatrix3D;
				_p0tmpR=meshmat.transformVector(_p0tmpR);
				_p1tmpR=meshmat.transformVector(_p1tmpR);
				_p2tmpR=meshmat.transformVector(_p2tmpR);
				_p3tmpR=meshmat.transformVector(_p3tmpR);
			
				_p0tmpR.x+=px;
				_p0tmpR.y+=py;
				_p0tmpR.z+=pz;
			
				_p1tmpR.x+=px;
				_p1tmpR.y+=py;
				_p1tmpR.z+=pz;
			
				_p2tmpR.x+=px;
				_p2tmpR.y+=py;
				_p2tmpR.z+=pz;
			
				_p3tmpR.x+=px;
				_p3tmpR.y+=py;
				_p3tmpR.z+=pz;
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
			
			_p3tmp.x=_p3tmpR.x;
			_p3tmp.y=_p3tmpR.y;
			_p3tmp.z=_p3tmpR.z;
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
			
			_p3tmp.x-=cam.x;
			_p3tmp.y-=cam.y;
			_p3tmp.z-=cam.z;
			//
			//根据摄影机矩阵进行绕转
			var cammat:Matrix3D=cam.transformMatrix;
			_p0tmp=cammat.transformVector(_p0tmp);
			_p1tmp=cammat.transformVector(_p1tmp);
			_p2tmp=cammat.transformVector(_p2tmp);
			_p3tmp=cammat.transformVector(_p3tmp);
			parentPos=cammat.transformVector(parentPos);
			//计算相对位置
			//计算三个顶点到摄影机的距离并以最低的为三角形的绘制depth
			depth=Vector3D.distance(cam,parentPos);//计算结果用于深度排序
			
		}
		
		override public function intersectTriangle(orig:Vector3D,dir:Vector3D):Vector3D{
    		var v0:Vector3D=_p0tmp;
			var v1:Vector3D=_p1tmp;
			var v2:Vector3D=_p2tmp;
			var u:Number;
			var v:Number;
			var Q:Vector3D;
			var t:Number;
			var dir2:Vector3D;
			var fInvDet:Number;
			var re:Vector3D;
			var intersect:Boolean=true;
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
         		//return null;
				intersect=false;
			}
			if(intersect){
     			// Calculate u and make sure u <= 1
     			u= T.dotProduct(P);
				if( u < 0 || u > det ){
					intersect=false;
				}
				if(intersect){
		    	 // Q
					 Q = T.crossProduct(E1);
		    	 // Calculate v and make sure u + v <= 1
					 v = dir.dotProduct(Q);
      				if( v < 0 || u + v > det ){
          				intersect=false;
					}
					if(intersect){
 		     		// Calculate t, scale parameters, ray intersects triangle
 					  	t = E2.dotProduct(Q);
						
 						fInvDet= 1 / det;
						t *= fInvDet;
						u *= fInvDet;
     					v *= fInvDet;
						re=orig.clone();
						dir2=dir.clone();
						dir2.scaleBy(t);
						re.add(dir2);
						return re;
					}
				}
			}
			
			v0=_p0tmp;
			v1=_p2tmp;
			v2=_p3tmp;
				// E1
    		E1 = new Vector3D(v1.x - v0.x,v1.y-v0.y,v1.z-v0.z);
     			// E2
     		E2 = new Vector3D(v2.x - v0.x,v2.y-v0.y,v2.z-v0.z);
     			// P
			P = dir.crossProduct(E2);
				// determinant
			det = E1.dotProduct(P);
			    // keep det > 0, modify T accordingly
	    	
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
     		u = T.dotProduct(P);
			if( u < 0 || u > det ){
         		return null;
			}
		    	 // Q
			Q = T.crossProduct(E1);
		    	 // Calculate v and make sure u + v <= 1
			v = dir.dotProduct(Q);
      		if( v < 0 || u + v > det ){
          		return null;
			}
 		     	// Calculate t, scale parameters, ray intersects triangle
 		    t = E2.dotProduct(Q);
 			fInvDet = 1 / det;
			t *= fInvDet;
			u *= fInvDet;
     		v *= fInvDet;
			re=orig.clone();
			dir2=dir.clone();
			dir2.scaleBy(t);
			re.add(dir2);
    		return re;
		}
	}
	
}
