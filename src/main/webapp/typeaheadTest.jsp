<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<%--    引入插件--%>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <title>演示自动补全插件</title>
    <script type="text/javascript">
        $(function (){
           $("#customerName").typeahead({

                //js数组
                // source:['京东国际','阿里巴巴','百度科技']   静态
                //每次键盘谈起，都会自动触发  向后台发布请求，查询所有名称，返回前台，赋值给source
                source:function (jquery,process){
                    //jquery就是容器里的内容，相当于var customerName = $("#customerName").val()
                    // var customerName = $("#customerName").val()
                    $.ajax({
                      url:'workbench/transaction/queryAllCustomerName.do',
                        data:{
                            customerName:jquery
                        },
                      type:'post',
                      dataType:'json',
                      success:function (data){
                          //赋值给source
                          process(data)
                      }
                    })
                }
            })
        })
    </script>
</head>
<body>
<input type="text" id="customerName">
</body>
</html>
