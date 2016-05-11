package  {
	//基本的三维材质
	import flash.display.BitmapData;
	public class TriangleMaterial {
		public var texture:BitmapData;
		public var color:uint;//颜色
		public var colorAble:Boolean;//如果设置开启这个值将会绘制颜色（在_data的基础上绘制）
		public var colorAlpha:Number;//颜色透明度
		//
		public var lineAble:Boolean;
		public var lineColor:uint;
		public var lineAlpha:Number;
		public var thickness:Number;//线条粗细
		//
		public var repeat:Boolean;
		public var smooth:Boolean;
		public function TriangleMaterial(tex:BitmapData=null,cb:Boolean=false,c:uint=0x333333,calp:Number=1,lb:Boolean=false,tn:Number=0.25,cl:uint=1,lalp:Number=1) {
			// constructor code
			texture=tex;
			if(tex==null){
				cb=true;//如果传入了空的贴图则默认开启颜色渲染
			}
			SetColor(cb,c,calp);
			SetLine(lb,cl,lalp);
			repeat=true;
			smooth=false;
		}
		
		public function clone():TriangleMaterial{//深拷贝材质
			return new TriangleMaterial(texture.clone(),colorAble,color,colorAlpha,lineAble,lineColor,lineAlpha);
		}
		public function SetColor(b:Boolean=false,c:uint=0x333333,alp:Number=1){
			color=c;
			colorAble=b;
			colorAlpha=alp;
		}
		public function SetLine(b:Boolean=false,c:uint=0xFFFF00,alp:Number=1,thick:Number=0.25){
			lineAble=b;
			lineColor=c;
			lineAlpha=alp;
			thickness=thick;
		}

	}
	
}
