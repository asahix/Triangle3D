Triangle3D是基于action script 3原生3d（cpu渲染）功能的工具库。
支持ASE格式3d模型导入；天空盒，灯光着色，远景雾效。射线方式碰撞检测；
使用方法：
搭建场景
var vf:TriangleView=new TriangleView(new Rectangle(-100,-100,750,600));
//创建TriangleView对象传入一个Rectangle参数（这个矩形要比舞台大一圈，这里的舞台是550×400，原因是当三角形的任何顶点处于区域外将不被绘制）
addEventListener(Event.ENTER_FRAME,run);
function run(e:Event){
vf.render(graphics);//驱动绘图到舞台上
}

使用天空盒子
var box:TriangleSkyBox =new TriangleSkyBox(new Point(275,200),new lf(),new rt(),new up(),new dn(),new fr(),new bk());
vf.scene.skybox=box;
//接上例，创建一个天空盒对象第一参数是屏幕中心的point对象；后面为盒子的六个面，方向是从左到右从上到下从前到后（位图文件）
//最后赋值给场景（TriangleScene的skybox属性）

创建模型贴图（位图）
var meshmaterial:TriangleMaterial=new TriangleMaterial(new pic());
//利用BitmapData创建一个贴图
meshmaterial.colorAble=false;
//是否使用贴图
meshmaterial.lineAble=true;
//是否显示贴图边界线
创建场景点光源
var light:TriangleLight=new TriangleLight(0xFF0000,1,0x000000,1,0,200,200,700);
view.scene.addEffect(light);
//创建的光源需要使用addEffect方法添加到场景
light.x=100;
light.y=0;
light.z=0;
//通过属性可调整光源位置

导入ASE格式的模型
使用URLLoader加载一个模型文件
var ld:URLLoader=new URLLoader();
ld.addEventListener(Event.COMPLETE,ld_com);
ld.load(new URLRequest("teaport.ase"));
var teaport:TriangleMesh;//加载完毕后的内容会被转换为mesh对象
function ld_com(e:Event){
	teaport=TriangleASEParser.decode(ld.data);
	//用TriangleASEParser解码为mesh对象；
	teaport.material=meshmaterial;
	//为转换的mesh添加贴图
	light.applyArray.push(teaport);
	//必须将mesh对象添加到光源的作用列表中
	view.scene.addChild(teaport);
	//把mesh添加到场景
	view.camera.x=100;
}
使用四边形片面
var	quad:TriangleQuad=new TriangleQuad(100,100,meshmaterial);
//创建一个100×100像素的四边形面，用meshmaterial（上例创建的位图纹理）作为贴图
view.scene.addChild(quad);
//添加四边面到场景

修改mesh或片面的位置以及旋转属性
quad.transform.z=200;
teaport.transform.z=100;



