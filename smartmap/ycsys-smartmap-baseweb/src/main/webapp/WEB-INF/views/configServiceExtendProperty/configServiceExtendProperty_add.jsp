<%@ page contentType="text/html;charset=UTF-8" language="java"
	isELIgnored="false"%>
<%@include file="/WEB-INF/views/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>羽辰智慧林业综合管理平台-资源管理</title>
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">
<!-- iconfont -->
<link rel="stylesheet" href="${res }/iconfont/iconfont.css">
<!-- Theme style -->
<link rel="stylesheet" href="${res }/dist/css/AdminLTE.css">
<link href="${res}/plugins/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css" />

<script src="${res}/js/common/form.js"></script>
<script src="${res}/plugins/jQuery/jquery-2.2.3.min.js"></script>
<script src="${res}/plugins/jquery-validation-1.15.1/lib/jquery.form.js"></script>
<script
	src="${res}/plugins/jquery-validation-1.15.1/dist/jquery.validate.min.js"
	type="text/javascript"></script>
<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>
<body>
	<form action="" method="post" id="form_id">
		<input type="hidden" name="id" value="${configServiceExtendProperty.id}">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="date_add_table">
		  <tr>
		    <td class="t_r">属性字段名：</td>
		    <td><input type="text" name="name" id="name" 
		    value="${configServiceExtendProperty.name}" class="text validate[required]" /></td>
		  </tr>
		  <tr>
		    <td class="t_r">属性显示名：</td>
		    <td><input type="text" name="showName" id="showName" 
		    value="${configServiceExtendProperty.showName}" class="text validate[required]" /></td>
		  </tr>
		
		  <tr>
		    <td class="t_r">类型：</td>
		    <td>
		    <select type="text" name="type" id="type" value="${configServiceExtendProperty.type}" class="text">
		        <option value="0" >字符</option>
				<option value="1" >日期</option>
				<option value="2" >数字</option>
		    </select>
		    </td>
		  </tr>
		  <tr>
		    <td class="t_r">比否必填：</td>
		    <td>
		    <select type="text" name="need" id="need" class="text">
		        <option value="0" >是</option>
				<option value="1" >否</option>
		    </select>
		    </td>
		  </tr>
		  <tr>
		    <td class="t_r">默认值：</td>
		    <td><input type="text" name="defaultValue" id="defaultValue" 
		    value="${configServiceExtendProperty.defaultValue}" class="text validate[required]" /></td>
		  </tr>
		  <tr>
		    <td class="t_r">参考值：</td>
		    <td><input type="text" name="referenceValue" id="referenceValue" 
		    value="${configServiceExtendProperty.referenceValue}" class="text validate[required]" /></td>
		  </tr>
		</table>
	</form>
</body>
<script >
	$(function() {
		//设置下拉的值
		if("${configServiceExtendProperty.id}"){
			var type = "${configServiceExtendProperty.type}";
			var needType = "${configServiceExtendProperty.need}";
			$("#type option[value="+type+"]").attr("selected",true);
			$("#need option[value="+needType+"]").attr("selected",true);
		}
		
		var form = $("#form_id");
		var val_obj = exec_validate(form); //方法在 ${res}/js/common/form.js
		form.validate(val_obj);
		
		var parentWin = window.parent;
		var dialog = parentWin.art.dialog.list["editConfigServiceExtendPropertyDialog"];
		var dialog_div = dialog.DOM.wrap;
		dialog_div.on("ok", function() {
			var counts = $('div.l-exclamation'); //填的不对的记录数
			if(counts.length < 1) {
				//支持文件上传的ajax提交方式
				$("#form_id").ajaxSubmit({
					url : "${ctx }/configServiceExtendProperty/save",
	                success:function(data){
	                	parentWin.gridManager.reload();
						dialog.close();
	                 }//,
	                 //dataType:"json"
	             });
			}
			else {
				alert("请重新填写那些有误的信息！");
			}
		});
		
	});
</script>
</html>