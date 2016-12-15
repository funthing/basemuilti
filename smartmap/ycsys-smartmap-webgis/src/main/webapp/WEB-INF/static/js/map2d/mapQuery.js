var nameField;//要素名称字段
var summaryFields;//概要组合字段
var displayFields;//用于地图上属性表显示的字段
var arrFeaturesTemp=[];//保存几何要素的数组
var arrQueryInfoItem;//属性查询结果条目

var queryCatalog=0;//查询类别：0,1,2分别代表属性查询、空间查询、逻辑查询

$(function(argument){
});

/**====================================逻辑查询========================================*/

function addLogicItem2d(lyrItem,fildItem,logicItem,fildValue){
	var fieldName=fildItem.value;
	var logic=logicItem.label;
	var fieldType=fildItem.type;
	var fieldValue=fildValue;
	
	var id;
	var data=$('#tableLogic').bootstrapTable('getOptions').data;
	if(data){
		id=data.length;
	}else{
		id=0;
	}
	var o=formatOption(logic,fieldValue,fieldType);
	var row={
			id:id,
			fieldName:fieldName,
			fieldOpt:logic,
			logicOpt:o.opt,
			fieldVal:fieldValue,
			logicVal:o.val,
			fieldLogic:''
	}
	$('#tableLogic').bootstrapTable('append',row);
//	setTimeout(function(){
//		$('.switch-button').bootstrapSwitch();
//		$('.switch-button').on('switch-change', function (e, data) {
//		    var $el = $(data.el), value = data.value;
//		    console.log(e, $el, value);
//		});
//	},500);
	
}
function formatOption(fieldOpt,fieldValue,fieldType){
	var o={};
	//处理逻辑符
	switch (fieldOpt) {
	case '大于':
		o.opt='>';
		break;
	case '大于等于':
		o.opt='>=';
		break;
	case '等于':
		o.opt='=';
		break;
	case '小于':
		o.opt='<';
		break;
	case '小于等于':
		o.opt='<=';
		break;
	case '不等':
		o.opt='<>';
		break;
	case '包含':
		o.opt='LIKE';
		fieldValue="%"+fieldValue+"%";
		break;
	case '为空':
		o.opt='IS NULL';
		fieldValue="";
		break;

	default:
		break;
	}
	//处理字符串型的值
	switch (fieldType) {
	case "esriFieldTypeString":
	case "esriFieldTypeDate":
		if(o.opt !='IS NULL'){
			fieldValue="'"+fieldValue+"'";
		}
		break;
	default:
		break;
	}
	o.val=fieldValue;
	return o;
}
function logicFormatter(value, row, index) {
	var id=row.id;
	var opt="<select onchange='setLogic("+index+");' id='logicSel"+index+"' style='width:100%;border:0px;margin:0px;padding:0px;'><option label='' value=''><option value='AND' label='且'><option value='OR' label='或'></selection>";
//	var opt="<input type='checkbox' checked class='switch-button' data-on-text='且' data-off-text='或'>";
	return opt;
}
function setLogic(index){
	var sel=$('#logicSel'+index)[0];
	var indx=sel.selectedIndex;
	var row=$('#tableLogic').bootstrapTable('getOptions').data[index];
	row.fieldLogic=sel.options[indx].value;
	console.log(row);
}
function delLogic2d(e){
	var row=$('#tableLogic').bootstrapTable('getSelections')[0];
	$('#tableLogic').bootstrapTable('removeByUniqueId',row.id);
}

function queryAttrLogic2d(layerItem){
	queryCatalog=2;//逻辑查询
	initFields(layerItem);
	var data=$('#tableLogic').bootstrapTable('getOptions').data;
	if(!data)return;
	//验证逻辑
	var validate=true;
	var sqls=[];
	for(var i=0;i<data.length;i++){
		var row=data[i];
		var sql;
		if(data.length>1 && i<=data.length-2){
			if(!row.fieldLogic){
				validate=false;
				break;
			}
			sql=row.fieldName+' '+row.logicOpt+' '+row.logicVal+' ' +row.fieldLogic+' ';
		}else{
			sql=row.fieldName+' '+row.logicOpt+' '+row.logicVal +' ';
		}
		sqls.push(sql);
	}
	if(!validate){
		showAlertDialog('查询逻辑不正确，请重试');
		return;
	}
	var sqlWhere=sqls.join("");
	console.log(sqlWhere);
	query(layerItem.url,sqlWhere);
}

/**===========================属性查询======================================*/

/**
 * 初始化一些字段
 * @param layerItem
 * @returns
 */
function initFields(layerItem){
	nameField=layerItem.nameField;
	summaryFields=layerItem.summaryFields;
	displayFields=layerItem.displayFields;
}
/**
 * 属性查询
 * @param layerUrl 图层url
 * @param fieldName 字段名
 * @param fieldType 字段类型
 * @param fieldValue 字段值
 * @returns
 */
function queryAttr2d(layerItem,fieldName,fieldType,fieldValue){
	queryCatalog=0;//属性查询
	initFields(layerItem);
	var opt=" = ";
	if(fieldType=="esriFieldTypeString"){
		opt=" LIKE ";
		fieldValue="'%"+fieldValue+"%'";
	}else if(fieldType=="esriFieldTypeDate"){
		fieldValue="date '"+fieldValue+"'";
	}
	var sqlWhere=fieldName + opt + fieldValue;
	query(layerItem.url,sqlWhere);
}

function query(url,sqlWhere){
	var query=new esri.tasks.Query();
	query.returnGeometry=true;
	query.outFields=["*"];
	query.where=sqlWhere;
	var task=new esri.tasks.QueryTask(url);
	task.execute(query,okCall,failCall);
}

function okCall(featureSet){
	clear2dMap();
	arrQueryInfoItem=[];
	
	//获取要素的信息
	var displayFieldName=featureSet.displayFieldName;
	var fieldAliases=featureSet.fieldAliases;
	var geometryType=featureSet.geometryType;
	var features=featureSet.features;
	arrFeaturesTemp=features;
	console.log(arrFeaturesTemp);
	
	//构建弹出内容
	var info=createTemplateContent(displayFields,fieldAliases);
	//符号样式
	var symbol=getSymbol(geometryType);
	//显示查询结果图层
	var tempLayer=new esri.layers.GraphicsLayer({id:'queryLyr'});
	for(var i=0;i<features.length;i++){
		var feature=features[i];
		feature.setSymbol(symbol);
		feature.setInfoTemplate(new esri.InfoTemplate("Info",info));
		tempLayer.add(feature);
		//分页条目信息
		var li=createItem(feature,i+1);
		arrQueryInfoItem.push(li);
	}
	map.addLayer(tempLayer);
	//显示属性查询页
	//initPager(arrQueryInfoItem,pageDiv,resultNumDiv,backDiv,mainDiv)
	if(queryCatalog==0){
		$('#Sxcxbox-result').css('display','block');
		initPager(arrQueryInfoItem,"#Pagination","#queryNum","#btnBack","#Sxcxbox-result");
	}else if(queryCatalog==2){
		$('#Sxcxbox-logic').css('display','block');
		initPager(arrQueryInfoItem,"#PaginationLogic","#queryLogicNum","#btnLogicBack","#Sxcxbox-logic");
	}
}

/**
 * 构建弹窗内容
 * @param displayFieldsStr 属性字段字符串，分号相隔
 * @param fieldAliasesObj 要素别名对象
 * @returns
 */
function createTemplateContent(displayFieldsStr,fieldAliasesObj){
	//别名和字段名数组
	var arrDisplayFields=[],html;
	if(displayFieldsStr){
		arrDisplayFields=displayFieldsStr.split(";");
		var arrDisplayFieldsAlias=[];
		for(var p=0;p<arrDisplayFields.length;p++){
			$.each(fieldAliasesObj,function(o,v){
				if(o==arrDisplayFields[p]){
					arrDisplayFieldsAlias.push(v);
				}
			})
		}
		//构建模板内容
		var arr=[];
		for(var i=0;i<arrDisplayFields.length;i++){
			var temp=arrDisplayFieldsAlias[i]+"：${"+arrDisplayFields[i]+"}<br>";
			arr.push(temp);
		}
		html=arr.join("");
	}else{
		html="${*}";
	}
	return html;
}

/**
 * 创建分页条目内容
 * @param feature
 * @param index
 * @returns
 */
function createItem(feature,index){
	//名称信息
	var title=feature.attributes[nameField];
	var layerName=feature.attributes.layerName;
	if(layerName){
		summaryFields="layerName;"+summaryFields;
	}
	//简略显示的字段数组
	var arrSummaryFields=[];
	var summary=[];
	if(summaryFields){
		arrSummaryFields=summaryFields.split(";");
		for(var j=0;j<arrSummaryFields.length;j++){
			var name=arrSummaryFields[j];
			summary.push(feature.attributes[name]);
		}
	}
	summary=summary.join("—");
	var html="<li><i class='no-"+index+"'></i><a href='#' onclick='toFeature("+feature.attributes.OBJECTID+")'>"+title+"</a><span>"+summary+"</span></li>";
	return html;
}

/**
 * 分页公用函数
 * @param arrQueryInfoItem 查询结果条目
 * @param pageDiv 分页#id
 * @param resultNumDiv 结果条数#id
 * @param backDiv 返回#id
 * @param mainContainerDiv 最外层#id
 * @returns
 */
function initPager(arrQueryInfoItem,pageDiv,resultNumDiv,backDiv,mainContainerDiv){
	var initPagination = function() {
        var num_entries = arrQueryInfoItem.length;
        // 创建分页
        $(pageDiv).pagination(num_entries, {
          num_edge_entries: 1, //边缘页数
          num_display_entries: 4, //主体页数
          callback: pageCallback,
          items_per_page:5 //每页显示1项
        });
       }();
       //初始化第一页
       pageCallback(0);
       $(resultNumDiv).text(arrQueryInfoItem.length);
       $(backDiv).on('click',function(){
    	   $(mainContainerDiv).css('display','none');
       });
}

function pageCallback(page_index, jq){
    var new_content = createPageContent(page_index);
    if(queryCatalog==0){
    	$("#queryItem").empty().append(new_content);
    }else if(queryCatalog==2){
        $("#queryItemLogic").empty().append(new_content);
    }else{
    	$("#queryItemGeo").empty().append(new_content);
    }
    return false;

  }

/**
 * 获取分页内容
 * @param pageIndex
 * @returns
 */
function createPageContent(pageIndex){
	var pageSize=5;//每页显示5条
	var _start=pageIndex*pageSize;
	var _end=_start+(pageSize-1);
	var arrTemp=[];
	for(var i=_start;i<=_end;i++){
		arrTemp.push(arrQueryInfoItem[i]);
	}
	return arrTemp.join("");
}
/**
 * 导航到地图中对应的要素
 * @param featureObjId
 * @returns
 */
function toFeature(featureObjId){
	for(var i=0;i<arrFeaturesTemp.length;i++){
		var feature=arrFeaturesTemp[i];
		if(feature.attributes.OBJECTID==featureObjId){
			highlightView(feature);
		}
	}
}

function highlightView(feature){
	var type=feature.geometry.type;
	var symbol=getSymbol(type,true);
	feature.setSymbol(symbol);
//	map.setExtent(feature._extent,true);
	map.centerAndZoom(feature._extent.getCenter(),10);
}

function failCall(){
	
}

/**===========================空间查询======================================*/
var arrNameField=[];//多个图层的要素名称字段数组
var arrSummaryFields=[];//多个图层的概要组合字段数组
var arrDisplayFields=[];//多个图层的用于地图上属性表显示的字段数组
var arrService=[];//树根节点级别数组，属性包含根节点url以及子节点（图层）的配置字段
//var arrFeaturesTemp;

function queryPoint2d(){
	draw.activate(esri.toolbars.Draw.POINT);
	toDraw(draw);
}
function queryPolyline2d(){
	draw.activate(esri.toolbars.Draw.POLYLINE);
	toDraw(draw);
}
function queryPolygon2d(){
	draw.activate(esri.toolbars.Draw.POLYGON);
	toDraw(draw);
}
function getQueryServiceArr(){
//	var zTree = $.fn.zTree.getZTreeObj("treeMaptcgl"),
//    nodes = zTree.getCheckedNodes();
//	if(nodes.length<1)return null;
//	var urls=[];
//	var serviceObj;
//	for(var i=0;i<nodes.length;i++){
//		var node=nodes[i];
//		if(node.type=='r'){
//			continue;
//		}
//		var url=node.address;
//		if(url.indexOf("MapServer")>-1){
//			url=url.substring(0,url.lastIndexOf("MapServer")+9);
//		}
//		if($.inArray(url, urls)<0){
//			urls.push(url);
//			
//		}
//		var fieldObj={//图层级别的展示字段对象
//				nameFidld:node.nameField,
//				summaryFields:node.summaryFields,
//				displayFields:node.displayFields
//		}
//		arrNameField.push(node.nameField);
//		arrSummaryFields.push(node.summaryFields);
//		arrDisplayFields.push(node.displayFields);
//	}
//	return urls;
	
	var zTree = $.fn.zTree.getZTreeObj("treeMaptcgl"),
	nodes = zTree.getCheckedNodes();
	if(nodes.length<1)return null;
	
	arrService=[];
	var rootes=getRootNodes(nodes);
	for(var n=0;n<rootes.length;n++){
		var parent=rootes[n];
		var root={
				url:parent.address,
				layerLevel:[]
		}
		var children=parent.children;
		for(var p=0;p<children.length;p++){
			var child=children[p];
			var address=child.address;
			var fieldObj={//图层级别展示字段对象
					id:address.substr(address.length-1,1),
					nameField:child.nameField,
					summaryFields:child.summaryFields,
					displayFields:child.displayFields
			}
			root.layerLevel.push(fieldObj);
		}
		arrService.push(root);
	}
	return arrService;
}
//获取所有选中的一级节点
function getRootNodes(selectedNodes){
	var nodes=selectedNodes;
	var roots=[];
	for(var i=0;i<nodes.length;i++){
		var node=nodes[i];
		if(node.type=='r'){
			roots.push(node);
		}
	}
	return roots;
}
function getQueryDefereds(geometry){
	var services=getQueryServiceArr();
	var deferreds=[];
	if(services && services.length>0){
		for(var i=0;i<services.length;i++){
			var service=services[i];
			deferreds.push(doQueryGeometry(service.url,geometry));
		}
	}else{
		showAlertDialog("当前没有可用于查询的图层");
		return ;
	}
	var all= new dojo.DeferredList(deferreds);
	return all;
}
function doQueryGeometry(serviceUrl,geometry){
	if(!serviceUrl) return;
	var task=new esri.tasks.IdentifyTask(serviceUrl);
	var params=new esri.tasks.IdentifyParameters();
	params.geometry=geometry;
	params.layerOption=esri.tasks.IdentifyParameters.LAYER_OPTION_VISIBLE;
	params.mapExtent=map.extent;
	params.returnGeometry=true;
	params.tolerance=3;
	return task.execute(params);
}
function toDraw(draw){
	queryCatalog=1;//空间查询
	clear2dMap();
	map.setMapCursor("crosshair");
	draw.on('draw-complete',function(geo1,geo2){
		map.graphics.add(geo1.geometry);
		var deferredList=getQueryDefereds(geo1.geometry);
		if(deferredList){
			deferredList.then(dealResults);
		}
		map.setMapCursor("default");
		draw.deactivate();
	});
}

/**
 * 显示空间查询结果
 * @param results
 * @returns
 */
function dealResults(results){
	console.log(results);
	arrQueryInfoItem=[];
	var pointLyr,polylineLyr,polygonLyr;
	for(var i=0;i<results.length;i++){//服务级别
		var result=results[i];
		if(!result[0]) continue;
		var featureSet=result[1];
		var layerArr=arrService[i].layerLevel;
		console.log(featureSet);
		for(var n=0;n<featureSet.length;n++){//图层级别:所有图层
			var featureObj=featureSet[n];//图层下的要素级别
			var feature=featureObj.feature;
			var geoType=feature.geometry.type
			var layerName=featureObj.layerName;
			var layerId=featureObj.layerId;
			arrFeaturesTemp.push(feature);
			feature.attributes.layerName=layerName;

			//遍历一个服务下面所有图层，找该要素对应的层的配置字段
			for(var j=0;j<layerArr.length;j++){
				var layerObj=layerArr[j];
				if(layerId==layerObj.id){
					nameField=layerObj.nameField;
					summaryFields=layerObj.summaryFields;
					displayFields=layerObj.displayFields;
					break;
				}
			}
			
			//查询列表展示
			var li=createItem(feature,n+1);
			arrQueryInfoItem.push(li);

			var plateInfo=createTemplateInfo(displayFields);
			var template = new esri.InfoTemplate("<b>属性</b>",plateInfo);
			feature.setInfoTemplate(template);
			feature.setSymbol(getSymbol(geoType,true));
			if(geoType=="point" || geoType=="multipoint"){
				if(!pointLyr){
					pointLyr=new esri.layers.GraphicsLayer({id:"iPointLyr"});
				}
				pointLyr.add(feature);
			}else if(geoType=="polyline"){
				if(!polylineLyr){
					polylineLyr=new esri.layers.GraphicsLayer({id:"iPolylineLyr"})
				}
				polylineLyr.add(feature);
			}else{
				if(!polygonLyr){
					polygonLyr=new esri.layers.GraphicsLayer({id:"iPolygonLyr"})
				}
				polygonLyr.add(feature);
			}
		}
	}
	$('#Sxcxbox-geometry').css('display','block');
	initPager(arrQueryInfoItem,"#PaginationGeo","#queryGeoNum","#btnGeoBack","#Sxcxbox-geometry");
	map.addLayers([polygonLyr,polylineLyr,pointLyr]);
}
//没有别名的情况
function createTemplateInfo(displayFieldsStr){
	//构建模板内容
	var arrDisplayFields=displayFieldsStr.split(";");
	var arr=[];
	for(var i=0;i<arrDisplayFields.length;i++){
		var temp=arrDisplayFields[i]+"：${"+arrDisplayFields[i]+"}<br>";
		arr.push(temp);
	}
	return arr.join("");
}

/**
 * 添加字段列表
 * @param layer 图层对象
 * @param selectCtrl 下拉框对象
 * @returns
 */
function doListFields(layer,selectCtrl){
	var fields=layer.fields;
	for(var i=0;i<fields.length;i++){
		var field=fields[i];
		switch (field.type) {
		case "esriFieldTypeSmallInteger":
		case "esriFieldTypeInteger":
		case "esriFieldTypeSingle":
		case "esriFieldTypeDouble":
		case "esriFieldTypeString":
		case "esriFieldTypeDate":
			var opt=new Option(field.alias,field.name);
			opt.type=field.type;
			selectCtrl.options.add(opt);
			break;
		default:
			break;
		}
	}
}
/**
 * 查询图层字段
 * @returns
 */
function listFields(){
	var select=$('#queryLyrLst')[0];
	var layerItem=select.options[select.selectedIndex];
	var selectField=$("#queryFieldsLst")[0];
	selectField.length=0;
	if(layerItem){
		var layer=map.getLayer(layerItem.value);
		doListFields(layer,selectField);
	}
}
/**
 * 逻辑查询图层字段
 * @returns
 */
function listFieldsLogic(){
	var select=$('#queryLyrLogic')[0];
	var layerItem=select.options[select.selectedIndex];
	if(layerItem){
		var layer=map.getLayer(layerItem.value);
		var selectField=$("#queryFieldsLogic")[0];
		selectField.length=0;
		doListFields(layer,selectField);
	}
}
