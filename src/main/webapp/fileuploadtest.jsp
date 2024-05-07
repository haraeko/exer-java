<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<meta charset="UTF-8">
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <%--    引入jquery--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <title>演示文件上传</title>
</head>

<body>
<%--文件上传 的表单三个条件
   1.表单组件标签只能用 <input type="file">
   2.请求方式只能用post
   3.文件上传表单的编码格式只能用：multipart/form-data
   根据HTTP协议，浏览器向后台提交参数 ，默认采用的编码格式是URLencoded    把所有参数转成字符串
--%>
<form action="workbench/activity/fileUpload.do" method="post" enctype="multipart/form-data">
    <input type="file" name="myFile"><br>
    <input type="text" name="username"><br>
    <input type="submit" value="提交"><br>
</form>
</body>
</html>
