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
<%--    引入插件   依赖jquery--%>
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <title>演示echarts插件</title>

        <script type="text/javascript">

            $(function (){


            // 基于准备好的dom，初始化echarts实例   告诉插件  容器是哪个
            var myChart = echarts.init(document.getElementById('main'));

                myChart.setOption(
            // 指定图表的配置项和数据
            {
            title: {
            text: 'ECharts 入门示例',
                subtext: '副标题',
                textStyle:{
                fontStyle:'italic'
                }
        },
                //    提示框
            tooltip: {
                textStyle: {
                    color:'blue'
                }
            },
            legend: {
            data: ['销量']
        },
            xAxis: {
            data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
        }, yAxis: {},
                //系列
           series: [{
            name: '销量',
            type: 'bar',//系列的种类   bar---柱状    line---折线图
            data: [5, 20, 36, 10, 10, 20]//系列的数据
        }]
        })
            // 使用刚指定的配置项和数据显示图表。

            })
    </script>
</head>
<body>

<!-- 为 ECharts 准备一个定义了宽高的 DOM -->
<div id="main" style="width: 600px;height:400px;"></div>
</body>

</html>
