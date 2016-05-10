package  {
	//存储了投影矩阵的摄影机
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	public class TriangleCamera extends Vector3D{
		//
		protected var _rotateX:Number;
		protected var _rotateY:Number;
		protected var _rotateZ:Number;
		protected var perspectiveProjection:PerspectiveProjection;
		public var screenCenter:Point;//屏幕中心
		protected var _viewMatrix:Matrix3D;
		protected var _transformMatrix:Matrix3D;
		public var farView:Number;
		public function TriangleCamera(fov:Number,c:Point,fv:Number=20000) {
			// constructor code
			perspectiveProjection=new PerspectiveProjection();
			fieldOfView=fov;
			screenCenter=c;
			_rotateX=_rotateY=_rotateZ=0;
			_viewMatrix=perspectiveProjection.toMatrix3D();
			_transformMatrix=new Matrix3D();
			farView=fv;
		}
		public function get rotationX():Number{
			return _rotateX;
		}
		public function get rotationY():Number{
			return _rotateY;
		}
		public function get rotationZ():Number{
			return _rotateZ;
		}
		protected function updateTransformMatrix(){
			_transformMatrix.identity();
			_transformMatrix.appendRotation(-_rotateX,Vector3D.X_AXIS);
			_transformMatrix.appendRotation(-_rotateY,Vector3D.Y_AXIS);
			_transformMatrix.appendRotation(-_rotateZ,Vector3D.Z_AXIS);
		}
		public function set rotationX(r:Number){
			_rotateX=r%360;
			if(_rotateX<0){
				_rotateX+=360;
			}
			updateTransformMatrix();
		}
		public function set rotationY(r:Number){
			_rotateY=r%360;
			if(_rotateY<0){
				_rotateY+=360;
			}
			updateTransformMatrix();
		}
		public function set rotationZ(r:Number){
			_rotateZ=r%360;
			if(_rotateZ<0){
				_rotateZ+=360;
			}
			updateTransformMatrix();
		}
		public function get transformMatrix():Matrix3D{
			//_transformMatrix.position=this;
			return _transformMatrix;
		}
		public function set fieldOfView(fov:Number){
			perspectiveProjection.fieldOfView=fov;
			_viewMatrix=perspectiveProjection.toMatrix3D();
		}
		public function get ViewMatrix3D():Matrix3D{
			//将三维点转换到屏幕并绘图
			return _viewMatrix;
		}
	}
	
}
