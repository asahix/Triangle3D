package  {
	import flash.geom.Point;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	import flash.display.Shape;
	public class TriangleSkyBox {
		//可变动天空盒子，这个类用于组织和显示天空盒 这个类只能用于TriangleView对象
		public static const SKYPLANE_X:String="sky_x";
		public static const SKYPLANE_NX:String="sky_nx";
		public static const SKYPLANE_Y:String="sky_y";
		public static const SKYPLANE_NY:String="sky_ny";
		public static const SKYPLANE_Z:String="sky_z";
		public static const SKYPLANE_NZ:String="sky_nz";
		//

		protected var leftPlane:TriangleSkyBoxPlane;
		protected var rightPlane:TriangleSkyBoxPlane;
		protected var frontPlane:TriangleSkyBoxPlane;
		protected var backPlane:TriangleSkyBoxPlane;
		protected var upPlane:TriangleSkyBoxPlane;
		protected var downPlane:TriangleSkyBoxPlane;
		
		protected var _vertex:Array;//所有天空盒的顶点数组
		protected var _triangle:Array;//所有天空盒的三角形组,用于渲染
		protected var skyCamera:TriangleCamera;
		//
		public function TriangleSkyBox(screenCenter:Point,left:BitmapData,right:BitmapData,up:BitmapData,down:BitmapData,front:BitmapData,back:BitmapData,step:int=3,weldEdge:Number=0.005,vof:Number=90) {
			// constructor code
			//screenCenter:内置的摄影机的屏幕中心，应该设置为场景摄影机的中心
			//left-back为天空盒的6张贴图
			//step为天空盒的分段数。数量越大天空盒越不容易出现画面空缺的问题。这个值不能小于2（等于2的时候很可能会出现画面不全的问题）设置过高则会出现性能问题
			//weldEdge消除边界功能，默认值为0.005设置值低于这个值将可能出现边界。设置过高则会造成画面错位；
			//
			_vertex=new Array();
			_triangle=new Array();
			leftPlane=new TriangleSkyBoxPlane(step,SKYPLANE_NX,new TriangleMaterial(left),_vertex,_triangle,weldEdge);
			rightPlane=new TriangleSkyBoxPlane(step,SKYPLANE_X,new TriangleMaterial(right),_vertex,_triangle,weldEdge);
			frontPlane=new TriangleSkyBoxPlane(step,SKYPLANE_Z,new TriangleMaterial(back),_vertex,_triangle,weldEdge);
			backPlane=new TriangleSkyBoxPlane(step,SKYPLANE_NZ,new TriangleMaterial(front),_vertex,_triangle,weldEdge);
			upPlane=new TriangleSkyBoxPlane(step,SKYPLANE_NY,new TriangleMaterial(up),_vertex,_triangle,weldEdge);
			downPlane=new TriangleSkyBoxPlane(step,SKYPLANE_Y,new TriangleMaterial(down),_vertex,_triangle,weldEdge);
			//执行后将产生总的数组
			skyCamera=new TriangleCamera(vof,screenCenter);
			
			
		}
		
		
		public function render(g:Graphics,camera:TriangleCamera,rect:Rectangle){
			var cx:Number=camera.x;
			var cy:Number=camera.y;
			var cz:Number=camera.z;
			skyCamera.x=cx;
			skyCamera.y=cy;
			skyCamera.z=cz;
			skyCamera.rotationX=camera.rotationX;
			skyCamera.rotationY=camera.rotationY;
			skyCamera.rotationZ=camera.rotationZ;
			
			leftPlane.updatePosition(cx,cy,cz);
			rightPlane.updatePosition(cx,cy,cz);
			frontPlane.updatePosition(cx,cy,cz);
			backPlane.updatePosition(cx,cy,cz);
			upPlane.updatePosition(cx,cy,cz);
			downPlane.updatePosition(cx,cy,cz);
			var i:int;
			var len:int=_triangle.length;
			var tmp:TriangleUnit;
			for(i=0;i<len;i++){
				tmp=_triangle[i];
				tmp.ca_depth(camera);//
				tmp.drawTrangle(g,camera.screenCenter,skyCamera.ViewMatrix3D,rect,"positive");
			}
			
			
		}
	}
	
}
import flash.display.Graphics;
class TriangleSkyBoxPlane extends TriangleMesh{
	//可调节的天空盒面
	protected var positionType:String;//这个值决定了天空盒平面以何种状态进行摆放
	protected var planeWidth:Number;
	public function TriangleSkyBoxPlane(step:int,pType:String,map:TriangleMaterial,_vertex:Array,_triangle:Array,weldEdge:Number=0.004){//width为面高度 step为面分段数
		var vec:Array=new Array();
		//uvclamp为消除接缝功能，值越高则接缝出现的几率越低
		//存放的是mesh的点
		positionType=pType;
		planeWidth=1000;//是宽度的一半。用于计算位置
		//接下来生成整个平面的顶点数据
		var i:int;
		var j:int;
		var tmpw:Number=2000/step;
		var len:int=step;
		var tmpTarr:Array=new Array();//存放4点组
		var tarr:Array=new Array();//存放生成的三角形
		var tmparr4p:Array;//4点组缓存
		var count:int=0;//用于确定数组上界的
		var u:Number;
		var v:Number;
		
		switch(pType){
			case TriangleSkyBox.SKYPLANE_X://x轴向的顶点
				for(i=0;i<=len;i++){
					for(j=0;j<=len;j++){
						u=j/step;
						v=i/step;
						if(u==1){
							u-=weldEdge;
						}else if(u==0){
							u+=weldEdge;
						}
						if(v==1){
							v-=weldEdge;
						}else if(v==0){
							v+=weldEdge;
						}
						if(u>1){
							u=1;
						}else if(u<0){
							u=0;
						}
						if(v>1){
							v=1;
						}else if(v<0){
							v=0;
						}
						vec.push(new TriangleVertex(0,-planeWidth+i*tmpw,planeWidth-j*tmpw,u,v));
					}
				}
			//完成后生成三角形 并送入构造方法中
			
			len=vec.length;
			//trace(len);
			count=0;
			for(i=0;i<len;i++){
				if(count<step && i+step+2<len){
					//trace("i="+i+"    i+1="+(i+1)+"     step+i+1="+(step+i+1)+"     i+step+2="+(i+step+2));
					tmpTarr.push([vec[i],vec[i+1],vec[step+i+1],vec[i+step+2]]);
					count+=1;
				}else{
					count=0;
				}
			}
			//生成组对象 下面根据组对象的顶点数据生成三角形
			len=tmpTarr.length;
			//trace("tmpTarr.length="+len);
			
			for(i=0;i<len;i++){
				tmparr4p=tmpTarr[i];
				tarr.push(new TriangleUnit(tmparr4p[3],tmparr4p[1],tmparr4p[0]));
				tarr.push(new TriangleUnit(tmparr4p[2],tmparr4p[3],tmparr4p[0]));
			}
			
			break;
			case TriangleSkyBox.SKYPLANE_NX:
			for(i=0;i<=len;i++){
				for(j=0;j<=len;j++){
					u=j/step;
					v=i/step;
					if(u==1){
						u-=weldEdge;
					}else if(u==0){
						u+=weldEdge;
					}
					if(v==1){
						v-=weldEdge;
					}else if(v==0){
						v+=weldEdge;
					}
					if(u>1){
						u=1;
					}else if(u<0){
						u=0;
					}
					if(v>1){
						v=1;
					}else if(v<0){
						v=0;
					}
					vec.push(new TriangleVertex(0,-planeWidth+i*tmpw,-planeWidth+j*tmpw,u,v));
				}
			}
			//完成后生成三角形 并送入构造方法中
			len=vec.length;
			//trace(len);
			count=0;
			for(i=0;i<len;i++){
				if(count<step && i+step+2<len){
					//trace("i="+i+"    i+1="+(i+1)+"     step+i+1="+(step+i+1)+"     i+step+2="+(i+step+2));
					tmpTarr.push([vec[i],vec[i+1],vec[step+i+1],vec[i+step+2]]);
					count+=1;
				}else{
					count=0;
				}
			}
			//生成组对象 下面根据组对象的顶点数据生成三角形
			len=tmpTarr.length;
			//trace("tmpTarr.length="+len);
			
			for(i=0;i<len;i++){
				tmparr4p=tmpTarr[i];
				tarr.push(new TriangleUnit(tmparr4p[3],tmparr4p[1],tmparr4p[0]));
				tarr.push(new TriangleUnit(tmparr4p[2],tmparr4p[3],tmparr4p[0]));
			}
			
			break;
			case TriangleSkyBox.SKYPLANE_Y://x轴向的顶点
			for(i=0;i<=len;i++){
				for(j=0;j<=len;j++){
					u=i/step;
					v=j/step;
					if(u==1){
						u-=weldEdge;
					}else if(u==0){
						u+=weldEdge;
					}
					if(v==1){
						v-=weldEdge;
					}else if(v==0){
						v+=weldEdge;
					}
					if(u>1){
						u=1;
					}else if(u<0){
						u=0;
					}
					if(v>1){
						v=1;
					}else if(v<0){
						v=0;
					}
					vec.push(new TriangleVertex(-planeWidth+i*tmpw,0,planeWidth-j*tmpw,u,v));
				}
			}
			//完成后生成三角形 并送入构造方法中
			len=vec.length;
			count=0;
			for(i=0;i<len;i++){
				if(count<step && i+step+2<len){
					tmpTarr.push([vec[i],vec[i+1],vec[step+i+1],vec[i+step+2]]);
					count+=1;
				}else{
					count=0;
				}
				
			}
			//生成组对象 下面根据组对象的顶点数据生成三角形
			len=tmpTarr.length;
			for(i=0;i<len;i++){
				tmparr4p=tmpTarr[i];
				tarr.push(new TriangleUnit(tmparr4p[0],tmparr4p[1],tmparr4p[3]));
				tarr.push(new TriangleUnit(tmparr4p[0],tmparr4p[3],tmparr4p[2]));
			}
			
			break;
			case TriangleSkyBox.SKYPLANE_NY:
			for(i=0;i<=len;i++){
				for(j=0;j<=len;j++){
					u=i/step;
					v=j/step;
					if(u==1){
						u-=weldEdge;
					}else if(u==0){
						u+=weldEdge;
					}
					if(v==1){
						v-=weldEdge;
					}else if(v==0){
						v+=weldEdge;
					}
					if(u>1){
						u=1;
					}else if(u<0){
						u=0;
					}
					if(v>1){
						v=1;
					}else if(v<0){
						v=0;
					}
					vec.push(new TriangleVertex(-planeWidth+i*tmpw,0,-planeWidth+j*tmpw,u,v));
				}
			}
			//完成后生成三角形 并送入构造方法中
			len=vec.length;
			count=0;
			for(i=0;i<len;i++){
				if(count<step && i+step+2<len){
					tmpTarr.push([vec[i],vec[i+1],vec[step+i+1],vec[i+step+2]]);
					count+=1;
				}else{
					count=0;
				}
				
			}
			//生成组对象 下面根据组对象的顶点数据生成三角形
			len=tmpTarr.length;
			for(i=0;i<len;i++){
				tmparr4p=tmpTarr[i];
				tarr.push(new TriangleUnit(tmparr4p[0],tmparr4p[1],tmparr4p[3]));
				tarr.push(new TriangleUnit(tmparr4p[0],tmparr4p[3],tmparr4p[2]));
			}
			
			break;
			case TriangleSkyBox.SKYPLANE_Z://x轴向的顶点
			for(i=0;i<=len;i++){
				for(j=0;j<=len;j++){
					u=i/step;
					v=j/step;
					if(u==1){
						u-=weldEdge;
					}else if(u==0){
						u+=weldEdge;
					}
					if(v==1){
						v-=weldEdge;
					}else if(v==0){
						v+=weldEdge;
					}
					if(u>1){
						u=1;
					}else if(u<0){
						u=0;
					}
					if(v>1){
						v=1;
					}else if(v<0){
						v=0;
					}
					vec.push(new TriangleVertex(-planeWidth+i*tmpw,-planeWidth+j*tmpw,0,u,v));
				}
			}
			//完成后生成三角形 并送入构造方法中
			len=vec.length;
			count=0;
			for(i=0;i<len;i++){
				if(count<step && i+step+2<len){
					tmpTarr.push([vec[i],vec[i+1],vec[i+step+1],vec[i+step+2]]);
					count+=1;
				}else{
					count=0;
				}
			}
			//生成组对象 下面根据组对象的顶点数据生成三角形
			len=tmpTarr.length;
			for(i=0;i<len;i++){
				tmparr4p=tmpTarr[i];
				tarr.push(new TriangleUnit(tmparr4p[0],tmparr4p[1],tmparr4p[3]));
				tarr.push(new TriangleUnit(tmparr4p[0],tmparr4p[3],tmparr4p[2]));
			}
			
			break;
			case TriangleSkyBox.SKYPLANE_NZ:
			for(i=0;i<=len;i++){
				for(j=0;j<=len;j++){
					u=i/step;
					v=j/step;
					if(u==1){
						u-=weldEdge;
					}else if(u==0){
						u+=weldEdge;
					}
					if(v==1){
						v-=weldEdge;
					}else if(v==0){
						v+=weldEdge;
					}
					if(u>1){
						u=1;
					}else if(u<0){
						u=0;
					}
					if(v>1){
						v=1;
					}else if(v<0){
						v=0;
					}
					vec.push(new TriangleVertex(planeWidth-i*tmpw,-planeWidth+j*tmpw,0,u,v));
				}
			}
			//完成后生成三角形 并送入构造方法中
			len=vec.length;
			count=0;
			for(i=0;i<len;i++){
				if(count<step && i+step+2<len){
					tmpTarr.push([vec[i],vec[i+1],vec[i+step+1],vec[i+step+2]]);
					count+=1;
				}else{
					count=0;
				}
			}
			//生成组对象 下面根据组对象的顶点数据生成三角形
			len=tmpTarr.length;
			for(i=0;i<len;i++){
				tmparr4p=tmpTarr[i];
				tarr.push(new TriangleUnit(tmparr4p[0],tmparr4p[1],tmparr4p[3]));
				tarr.push(new TriangleUnit(tmparr4p[0],tmparr4p[3],tmparr4p[2]));
			}
			
			break;
		}
		len=vec.length;
		for(i=0;i<len;i++){
			_vertex.push(vec[i]);
		}
		len=tarr.length;
		for(i=0;i<len;i++){
			_triangle.push(tarr[i]);
		}
		super(tarr,map);
	}
	public function updatePosition(cx:Number,cy:Number,cz:Number){
		switch(positionType){
			case TriangleSkyBox.SKYPLANE_X:
				transform.x=cx+planeWidth;
				transform.y=cy;
				transform.z=cz;
			break;
			case TriangleSkyBox.SKYPLANE_NX:
				transform.x=cx-planeWidth;
				transform.y=cy;
				transform.z=cz;
			break;
			case TriangleSkyBox.SKYPLANE_Y:
				transform.x=cx;
				transform.y=cy+planeWidth;
				transform.z=cz;
			break;
			case TriangleSkyBox.SKYPLANE_NY:
				transform.x=cx;
				transform.y=cy-planeWidth;
				transform.z=cz;
			break;
			case TriangleSkyBox.SKYPLANE_Z:
				transform.x=cx;
				transform.y=cy;
				transform.z=cz+planeWidth;
			break;
			case TriangleSkyBox.SKYPLANE_NZ:
				transform.x=cx;
				transform.y=cy;
				transform.z=cz-planeWidth;
			break;
			
		}
	}
}
