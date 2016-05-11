package  {
	//提供给Triangle引擎的ASE解析程序
	//输入模型内容解析出TriangleMesh （无贴图）
	public class TriangleASEParser {
		static public function decode(str:String):TriangleMesh{
			var vertex:Array=new Array();
			var posS:int=0;
			var posE:int;
			var posI:int=0;//索引位置
			var tstr:String;
			var tmpOB:Object;
			var findStr:String="*MESH_VERTEX ";
			
			do{
				
				posS=str.indexOf(findStr,posI);
				tstr=str.substring(posS);//去掉前部的
				//下面分段
				posE=tstr.indexOf("\n",0);
				//至此确定了一行顶点数据，下面将顶点数据提取出来放在object
				tstr=tstr.substring(0,posE);
				if(posS==-1 || posE==-1){
					break;
				}
				posI=posE+posS+1;
				
				tmpOB=new Object();
				//找第一行标签
				//解析标签内容
				posS=tstr.indexOf("\t",0);//去头
				posS+=1;
				posE=tstr.indexOf("\t",posS);//
				tmpOB.vx=-Number(tstr.substring(posS,posE));//得到x
				posS=posE+1;
				posE=tstr.indexOf("\t",posS);
				tmpOB.vy=-Number(tstr.substring(posS,posE));//得到y
				posS=posE+1;
				tmpOB.vz=Number(tstr.substring(posS));//得到z
				vertex.push(tmpOB);//放入一个
				
			}while(true);
			//至此，得到了顶点列表
			//下面解析UV数据得到UV列表
			var uv:Vector.<Object>=new Vector.<Object>();
			posI=0;
			do{
				posS=str.indexOf("*MESH_TVERT ",posI);
				tstr=str.substring(posS);//去掉前部的
				//下面分段
				posE=tstr.indexOf("\n",0);
				//至此确定了一行顶点数据，下面将顶点数据提取出来放在object
				tstr=tstr.substring(0,posE);
				if(posS==-1 || posE==-1){
					break;
				}
				posI=posE+posS+1;
				//break;
				tmpOB=new Object();
				//找第一行标签
				//解析标签内容
				posS=tstr.indexOf("\t",0);//去头
				posS+=1;
				posE=tstr.indexOf("\t",posS);//
				tmpOB.vu=Number(tstr.substring(posS,posE));//得到u
				posS=posE+1;
				posE=tstr.indexOf("\t",posS);
				tmpOB.vv=-Number(tstr.substring(posS,posE));//得到v
				uv.push(tmpOB);//放入一个
				//trace(uv);
			}while(true);
			//至此，得到了uv列表
			/*//下面解析法线数据
			var normal:Vector.<Object>=new Vector.<Object>();
			posI=0;
			do{
				posS=str.indexOf("*MESH_FACENORMAL "+posI,0);
				tstr=str.substring(posS);//去掉前部的
				//下面分段
				posI+=1;
				posE=tstr.indexOf("\n",0);
				//至此确定了一行顶点数据，下面将顶点数据提取出来放在object
				tstr=tstr.substring(0,posE);
				//trace(tstr);
				if(posS==-1){
					break;
				}
				
				//break;
				tmpOB=new Object();
				//找第一行标签
				//解析标签内容
				posS=tstr.indexOf("\t",0);//去头
				posS+=1;
				posE=tstr.indexOf("\t",posS);//
				tmpOB.nx=Number(tstr.substring(posS,posE));//得到法线x
				posS=posE+1;
				posE=tstr.indexOf("\t",posS);
				tmpOB.ny=Number(tstr.substring(posS,posE));//得到法线y
				posS=posE+1;
				tmpOB.nz=Number(tstr.substring(posS));//得到法线z
				normal.push(tmpOB);//放入一个
				//trace("入"+posI);
			}while(true);*/
			//trace(normal.length);
			//至此法线组解析完毕了 下面根据组表解析出顶点缓冲 uv缓冲 法线缓冲
			var vertexBuff:Vector.<Number>=new Vector.<Number>();
			var uvBuff:Vector.<Number>=new Vector.<Number>();
			//var norBuff:Vector.<Number>=new Vector.<Number>();
			//var indBuff:Vector.<uint>=new Vector.<uint>();//索引缓冲数据
			//首先解析顶点缓冲
			var tD:int=0;//三角形查找索引
			
			var t2str:String;
			posI=0;
			do{
				posS=str.indexOf(" A:",posI);
				if(posS==-1){
					break;
				}
				posS+=3;//跳过A
				
				tstr=str.substring(posS);//去掉前部的
				posE=tstr.indexOf(" AB:",0);
				posI=posS+posE+1;
				tstr=tstr.substring(0,posE);
				//trace(tstr);
				//下面分段
				//break;
				posE=tstr.indexOf(" B:",0);//找到后面的
				t2str=tstr.substring(0,posE);//去掉后面的
				//这其中的串就是A位置的顶点索引
				posS=t2str.search(/\d/);
				t2str=t2str.substring(posS);
				//得到第一个索引了
				tmpOB=vertex[Number(t2str)];
				vertexBuff.push(tmpOB.vx);
				vertexBuff.push(tmpOB.vy);
				vertexBuff.push(tmpOB.vz);
				posS=posE+3;
				posE=tstr.indexOf(" C:",0);
				t2str=tstr.substring(posS,posE);
				posS=t2str.search(/\d/);
				t2str=t2str.substring(posS);
				tmpOB=vertex[Number(t2str)];
				vertexBuff.push(tmpOB.vx);
				vertexBuff.push(tmpOB.vy);
				vertexBuff.push(tmpOB.vz);
				posS=posE+3;
				
				t2str=tstr.substring(posS);
				posS=t2str.search(/\d/);
				t2str=t2str.substring(posS);
				tmpOB=vertex[Number(t2str)];
				vertexBuff.push(tmpOB.vx);
				vertexBuff.push(tmpOB.vy);
				vertexBuff.push(tmpOB.vz);/**/
				//至此填充一次顶点缓冲
				//下面进行数字解析；
				//至此确定了一行顶点数据，下面将顶点数据提取出来放在object
				
			}while(true);
			//下面找UV数据组
			
			tD=0;
			do{
				posS=str.indexOf("*MESH_TFACE "+tD,0);
				if(posS==-1){
					break;
				}
				tD+=1;
				
				tstr=str.substring(posS);//去掉前部的
				//下面分段
				posS=tstr.indexOf("\t",0);//找到第一个位置
				posE=tstr.indexOf("\t",posS+1);//找到后面的
				t2str=tstr.substring(posS,posE);//去掉后面的
				//这其中的串就是三角形一个顶点的uv索引
				tmpOB=uv[Number(t2str)];
				//trace(tmpOB==uv[0]);
				//得到第一个索引了
				uvBuff.push(tmpOB.vu);
				uvBuff.push(tmpOB.vv);
				posS=posE+1;
				posE=tstr.indexOf("\t",posS);
				t2str=tstr.substring(posS,posE);//去掉后面的
				tmpOB=uv[Number(t2str)];
				//得到第一个索引了
				uvBuff.push(tmpOB.vu);
				uvBuff.push(tmpOB.vv);
				posS=posE+1;
				posE=tstr.indexOf("\n",posS);
				t2str=tstr.substring(posS,posE);//去掉后面的
				tmpOB=uv[Number(t2str)];
				//得到第一个索引了
				uvBuff.push(tmpOB.vu);
				uvBuff.push(tmpOB.vv);
				
			}while(true);
			//至此得到了三角形的uv缓冲/**/
			//接下来组装三角形顶点(带有uv数据)
			var vt2:Array=new Array();
			var i:int;
			var j:int;
			var len:int=vertexBuff.length;
			var tmp:TriangleVertex;
			for(i=0;i<len;i+=3,j+=2){
				tmp=new TriangleVertex(vertexBuff[i],vertexBuff[i+1],vertexBuff[i+2],uvBuff[j],uvBuff[j+1]);
				vt2.push(tmp);
			}
			
			//得到了顶点组
			//下面根据三个顶点1个三角形的原则合成unit组
			len=vt2.length
			var tunit:TriangleUnit;
			var unitArr:Array=new Array();
			for(i=0;i<len;i+=3){
				tunit=new TriangleUnit(vt2[i],vt2[i+1],vt2[i+2]);
				unitArr.push(tunit);
			}
			return new TriangleMesh(unitArr,new TriangleMaterial());
			
		
		}
	}
	
}
