<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@include file="/WEB-INF/views/common/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>羽辰智慧林业平台运维管理系统-平台操作系统统计</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <link rel="shortcut icon" href="favicon.ico" />
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="${res }/bootstrap/css/bootstrap.css">
  <!-- iconfont -->
  <link rel="stylesheet" href="${res }/iconfont/iconfont.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="${res }/dist/css/AdminLTE.css">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="${res }/dist/css/skins/_all-skins.css">
  <!-- list -->
  <link href="${res }/plugins/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />
  <!-- 弹出框 -->
  <link href="${res }/plugins/dialog/dialog.css" rel="stylesheet" type="text/css">
<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
    <style>
body {
	overflow-y: auto;
}
  </style>
</head>
<body>
	<div>
    <!-- Content Header (Page header) -->
    <section class="content-header" style="background-color: #f1f1f1;">
      <h1>平台操作系统统计</h1>
    </section>

    <!-- Main content -->
   <!--  <section class="content"> -->
    <div class="row">
        <div class="col-md-12">
          <div class="btn_box" style="float: left;margin:10px 0 10px 10px;"> 
            	时间：<input name="startTime" id="startTime" type="text" class="text date_plug" value="${curDate }" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})"> 
            	至 <input name="endTime" id="endTime" type="text" class="text date_plug" value="${curDateTo }" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})">
            	统计类型：<select id="statType" name="statType" class="text">
		            		<option value="1">CPU参数</option>
		            		<option value="2">网络包裹流量参数</option>
		            		<option value="3">网络字节流量参数</option>
		            		<option value="4">内存参数</option>
		              </select>&nbsp;&nbsp;
            <button class="current" id="queryBtn"><i class="glyphicon glyphicon-search"></i>查询</button>
          </div>
          <div class="charts" id="chart"></div>
          <div id="maingrid4"></div>
        </div>
        </div>
      <!-- /.row -->
    <!-- </section> -->
    <!-- /.content -->
  </div>
</body>
<!-- jQuery 2.2.3 -->
<script src="${res }/plugins/jQuery/jquery-2.2.3.min.js"></script> 
<!--grid-->
<script src="${res }/plugins/ligerUI/js/core/base.js" type="text/javascript"></script>
<script src="${res }/plugins/ligerUI/js/plugins/ligerGrid.js" type="text/javascript"></script>  
<script src="${res }/plugins/ligerUI/js/plugins/ligerDrag.js" type="text/javascript"></script>  
<script src="${res }/plugins/ligerUI/js/plugins/ligerMenu.js" type="text/javascript"></script>  
<script src="${res }/plugins/ligerUI/js/plugins/ligerTree.js" type="text/javascript"></script>  
<script src="${res }/plugins/ligerUI/js/plugins/CustomersData.js" type="text/javascript"></script> 
<!-- Bootstrap 3.3.6 -->
<script src="${res }/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="${res }/dist/js/app.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="${res }/dist/js/demo.js"></script>
<!-- echarts -->
<script src="${res }/plugins/echarts/echarts-all.js"></script>
<script src="${res }/plugins/My97DatePicker/WdatePicker.js"></script>
<%-- <script src="${res }/dist/js/pages/ptsj.js"></script> --%>
<script>
$(document).ready(function() {
	//统计类型改变事件
	$("#statType").on("change",function() {
		$("#queryBtn").click();
	});
	
	//查询按钮绑定单击事件
	$("#queryBtn").on("click",function(){
		query();
	});
	
	//点击查询
	$("#queryBtn").click();
	
	//查询 start
	function query() {
	 	var myChart = echarts.init(document.getElementById('chart'),'macarons');
	 	myChart.showLoading({
	        text: "图表数据正在努力加载..."
	    });
	 	
	 	//统计类型
	 	var statType = $("#statType").val();
	 	var unit = "";//单位
	 	var legendName = "";
	 	var seriesName1 = "";
	 	var seriesName2 = "";
	 	if(statType == 1) {
	 		unit = " %";
	 		legendName = ["CPU使用率","CPU空闲率"];
	 		seriesName1 = "CPU使用率";
	 		seriesName2 = "CPU空闲率";
	 	}
	 	else if(statType == 2) {
	 		unit = " MB";
	 		legendName = ["网络发送包裹","网络接收包裹"];
	 		seriesName1 = "网络发送包裹";
	 		seriesName2 = "网络接收包裹";
	 	}
	 	else if(statType == 3) {
	 		unit = " MB";
	 		legendName = ["发送流量","接收流量"];
	 		seriesName1 = "发送流量";
	 		seriesName2 = "接收流量";
	 	}
	 	else if(statType == 4) {
	 		unit = " MB";
	 		legendName = ["内存使用"];
	 		seriesName1 = "内存使用";
	 	}
	 	
	    //获取平台操作系统信息 start
	    $.ajax({
			url:"${ctx}/statistics/getOperratingSysInfo",
			method:"post",
			data:{'startTime':$("#startTime").val(),'endTime':$("#endTime").val(),"statType":$("#statType").val()},
			dataType:"json",
			success:function(ret) {
				myChart.hideLoading();
				var xData = "";
				var seriesData1 = "";
				var seriesData2 = "";
				if(ret.xAxisData) {
					xData = JSON.parse(ret.xAxisData);
				}
				if(ret.seriesData1) {
					seriesData1 = JSON.parse(ret.seriesData1);
				}
				if(ret.seriesData2) {
					seriesData2 = JSON.parse(ret.seriesData2);
				}
				//console.log("seriesData1=" + seriesData1);
				//console.log("seriesData2=" + seriesData2);
			    var option = {
			    		  title : {
			    		      text : '平台操作系统统计'
			    		  },
			    		  tooltip : {
			    		      trigger: 'item',
			    		  },
			    		  toolbox: {
			    		      show : false,
			    		      feature : {
			    		          mark : {show: true},
			    		          dataView : {show: true, readOnly: false},
			    		          restore : {show: true},
			    		          saveAsImage : {show: true}
			    		      }
			    		  },
			    		  legend : {
			    		      data : legendName
			    		  },
			    		  grid: {
			    		      y2: 80
			    		  },
			    		  xAxis : [
			    		      {	
			    		    	  type : 'category',
				                  boundaryGap : false,
			    		    	  data:xData
			    		          //type : 'time',
			    		          //splitNumber:10
			    		      }
			    		  ],
			    		  yAxis : [
			    		      {
			    		          type : 'value',
			    		          axisLabel : {
				                       formatter: '{value}' + unit
				                   },
			    		      }
			    		  ],
			    		  series : [
			    		      {
			    		          name: seriesName1,
			    		          type: 'line',
			    		          data:seriesData1,
			    		          markPoint : {
				                       data : [
				                           {type : 'max', name: '最大值'},
				                           {type : 'min', name: '最小值'}
				                       ]
				                   }
			    		      },
			    		      {
			    		          name: seriesName2,
			    		          type: 'line',
			    		          data:seriesData2,
			    		          markPoint : {
				                       data : [
				                           {type : 'max', name: '最大值'},
				                           {type : 'min', name: '最小值'}
				                       ]
				                   }
			    		      }
			    		  ]
			    		};
			    if(xData == "") {
			    	option.series=[''];
			    }
			    myChart.setOption(option);
			},
			error: function(result) {
				alert("connection error!");		
			}
	    });
	  //获取平台操作系统信息 end
	  
	  //数据库列表start
	   $(function () {
		   if(statType == "1") {
			   $("#maingrid4").ligerGrid({
			         checkbox: false,
			         columns: [
			         { display: '服务器名称', name: 'serverName', minwidth: 80 },
			         { display: 'CPU使用率最大值', name: 'useMax', minwidth: 100 },
			         { display: 'CPU使用率最小值', name: 'useMin', minwidth: 100 },
			         { display: 'CPU使用率平均值', name: 'useAverage', minwidth: 100 },
			         { display: 'CPU当前空闲率最大值', name: 'freeMax', minwidth: 150 },
			         { display: 'CPU当前空闲率最小值', name: 'freeMin', minwidth: 150 },
			         { display: 'CPU当前空闲率平均值', name: 'freeAverage', minwidth: 150 }
			         ], pageSize:10,
			         url:"${ctx}/statistics/listOperatingSysData?statType="+statType + "&startTime=" + $("#startTime").val() + "&endTime=" + $("#endTime").val(),
			         usePager: false,
			         width: '100%',height:'300px'
		     	});
		   }
		   else if(statType == "2"){
			   $("#maingrid4").ligerGrid({
			         checkbox: false,
			         columns: [
			         { display: '服务器名称', name: 'serverName', minwidth: 80 },
			         { display: '网络发送包裹最大值', name: 'sendPackageMax', minwidth: 100 },
			         { display: '网络发送包裹最小值', name: 'sendPackageMin', minwidth: 100 },
			         { display: '网络发送包裹平均值', name: 'sendPackageAverage', minwidth: 100 },
			         { display: '网络接收包裹最大值', name: 'recPackageMax', minwidth: 150 },
			         { display: '网络接收包裹最小值', name: 'recPackageMin', minwidth: 150 },
			         { display: '网络接收包裹平均值', name: 'recPackageAverage', minwidth: 150 }
			         ], pageSize:10,
			         url:"${ctx}/statistics/listOperatingSysData?statType="+statType + "&startTime=" + $("#startTime").val() + "&endTime=" + $("#endTime").val(),
			         usePager: false,
			         width: '100%',height:'300px'
		     	});
		   }
		   else if(statType == "3"){
			   $("#maingrid4").ligerGrid({
			         checkbox: false,
			         columns: [
			         { display: '服务器名称', name: 'serverName', minwidth: 80 },
			         { display: '发送流量最大值', name: 'sendByteMax', minwidth: 100 },
			         { display: '发送流量最小值', name: 'sendByteMin', minwidth: 100 },
			         { display: '发送流量平均值', name: 'sendByteAverage', minwidth: 100 },
			         { display: '接收流量最大值', name: 'recPackageMax', minwidth: 150 },
			         { display: '接收流量最小值', name: 'recPackageMin', minwidth: 150 },
			         { display: '接收流量平均值', name: 'recPackageAverage', minwidth: 150 }
			         ], pageSize:10,
			         url:"${ctx}/statistics/listOperatingSysData?statType="+statType + "&startTime=" + $("#startTime").val() + "&endTime=" + $("#endTime").val(),
			         usePager: false,
			         width: '100%',height:'300px'
		     	});
		   }
		   else if(statType == "4"){
			   $("#maingrid4").ligerGrid({
			         checkbox: false,
			         columns: [
			         { display: '服务器名称', name: 'serverName', minwidth: 80 },
			         { display: '使用内存最大值', name: 'usedMemoryMax', minwidth: 100 },
			         { display: '使用内存最小值', name: 'usedMemoryMin', minwidth: 100 },
			         { display: '使用内存平均值', name: 'usedMemoryAverage', minwidth: 100 }
			         ], pageSize:10,
			         url:"${ctx}/statistics/listOperatingSysData?statType="+statType + "&startTime=" + $("#startTime").val() + "&endTime=" + $("#endTime").val(),
			         usePager: false,
			         width: '100%',height:'300px'
		     	});
		   }
	     $("#pageloading").hide(); 
	 });
	//数据库列表end 
}
	//查询  end
});
</script>
</html>
