package  {
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	public class TriangleTransform extends Vector3D{
		protected var _rot:Matrix3D;
		protected var _direct:Vector3D;
		protected var _rotateX:Number;
		protected var _rotateY:Number;
		protected var _rotateZ:Number;
		protected const Y_AXIS:Vector3D=new Vector3D(0,-1,0);
		public function lookAt(target:Vector3D){
			//设置指向
			_rot.pointAt(target,_direct,Y_AXIS);//Vector3D.Y_AXIS
		}
		public function TriangleTransform(nx:Number=0,ny:Number=0,nz:Number=0) {
			// constructor code
			super(nx,ny,nz);
			_direct=new Vector3D(0,0,1);//方向向量
			_rotateX=_rotateY=_rotateZ=0;
			_rot=new Matrix3D();
		}
		public function get direct():Vector3D{
			return _direct;
		}
		public function get transformMatrix3D():Matrix3D{
			return _rot;
		}
		protected function updateRotation(){
			_rot.identity();
			_rot.appendRotation(_rotateX,Vector3D.X_AXIS);
			_rot.appendRotation(_rotateY,Vector3D.Y_AXIS);
			_rot.appendRotation(_rotateZ,Vector3D.Z_AXIS);
			_direct.x=_direct.y=0;
			_direct.z=1;
			_direct=_rot.transformVector(_direct);
			//_rot.position=this;
		}
		public function set rotationX(i:Number){
			_rotateX=i%360;
			updateRotation();
		}
		public function set rotationY(i:Number){
			_rotateY=i%360;
			updateRotation();
		}
		public function set rotationZ(i:Number){
			_rotateZ=i%360;
			updateRotation();
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
	}
	
}
