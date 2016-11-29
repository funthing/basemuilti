<%@ page contentType="text/html;charset=UTF-8" language="java"
	isELIgnored="false"%>
<%@include file="/WEB-INF/views/common/taglib.jsp"%>
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
<link rel="stylesheet" href="${res}/iconfont/iconfont.css">
<!-- Theme style -->
<link rel="stylesheet" href="${res}/dist/css/AdminLTE.css">


<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

</head>
<body>
	<form action="" method="get" id="form_id">

		<table width="100%" border="0" cellpadding="0" cellspacing="0"
			class="date_add_table">

			<tr>
				<td class="t_r">服务资源：</td>
				<td><input type="checkbox" name="category" value="信息" />非SD文件<input
					type="checkbox" name="category" value="信息" />SD文件</td>
			</tr>
			<tr>
				<td class="t_r">服务类型：</td>
				<td><select type="text" name="textfield3" id="textfield3"
					class="text">
						<option>WMTS</option>
						<option>Feature Access</option>
						<option>Mapping(always enabled)</option>
						<option>KML</option>
				</select></td>
			</tr>
			<tr>
				<td class="t_r">资源文件：</td>
				<td><input type="file" id="exampleInputFile"></td>
			</tr>
			<tr>
				<td class="t_r">服务名称：</td>
				<td><input type="text" name="textfield2" id="textfield2"
					class="text validate[required]" /></td>
			</tr>
			<tr>
				<td class="t_r">GIS Server集群：</td>
				<td><select type="text" name="textfield3" id="textfield3"
					class="text">
						<option>WMTS</option>
						<option>Feature Access</option>
						<option>Mapping(always enabled)</option>
						<option>KML</option>
				</select></td>
			</tr>
			<tr>
				<td class="t_r">发布目录：</td>
				<td><select type="text" name="textfield3" id="textfield3"
					class="text">
						<option>WMTS</option>
						<option>Feature Access</option>
						<option>Mapping(always enabled)</option>
						<option>KML</option>
				</select></td>
			</tr>
		</table>
	</form>
</body>
<script>
	
</script>
</html>
