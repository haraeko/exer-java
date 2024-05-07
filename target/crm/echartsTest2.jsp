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

        $(function () {
            // 基于准备好的dom，初始化echarts实例   告诉插件  容器是哪个
            var myChart = echarts.init(document.getElementById('main'));
            myChart.setOption(
                // 指定图表的配置项和数据
                {
                    title: {
                        text: '交易统计图表',
                        subtext: '交易表中各个阶段的数量'
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: "{a} <br/>{b} : {c}%"
                    },
                    toolbox: {
                        feature: {
                            dataView: {readOnly: false},
                            restore: {},
                            saveAsImage: {}
                        }
                    },
                    legend: {
                        data: ['展现', '点击', '访问', '咨询', '订单']
                    },
                    series: [
                        {
                            name: '预期',
                            type: 'funnel',
                            left: '10%',
                            width: '80%',
                            label: {
                                formatter: '{b}预期'
                            },
                            labelLine: {
                                show: false
                            },
                            itemStyle: {
                                opacity: 0.7
                            },
                            emphasis: {
                                label: {
                                    position: 'inside',
                                    formatter: '{b}预期: {c}%'
                                }
                            },
                            data: [
                                {value: 60, name: '访问'},
                                {value: 40, name: '咨询'},
                                {value: 20, name: '订单'},
                                {value: 80, name: '点击'},
                                {value: 100, name: '展现'}
                            ]
                        },
                        {
                            name: '实际',
                            type: 'funnel',
                            left: '10%',
                            width: '80%',
                            maxSize: '80%',
                            label: {
                                position: 'inside',
                                formatter: '{c}%',
                                color: '#fff'
                            },
                            itemStyle: {
                                opacity: 0.5,
                                borderColor: '#fff',
                                borderWidth: 2
                            },
                            emphasis: {
                                label: {
                                    position: 'inside',
                                    formatter: '{b}实际: {c}%'
                                }
                            },
                            data: [
                                {value: 30, name: '访问'},
                                {value: 10, name: '咨询'},
                                {value: 5, name: '订单'},
                                {value: 50, name: '点击'},
                                {value: 80, name: '展现'}
                            ]
                        }
                    ]
                })
        })
    </script>
</head>
<body>
<div id="main" style="width: 600px;height:400px;"></div>

</body>
</html>
