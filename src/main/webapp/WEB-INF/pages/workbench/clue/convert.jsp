<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		$("#searchActivityBtn").click(function(){
			//清空搜索框
			$("#searchActivityText").val("")
			//清空列表
			$("#tbody").html("")
			$("#searchActivityModal").modal("show")
		})

	//	给活动搜索框添加键盘谈起事件
		$("#searchActivityText").keyup(function(){
			// var activityName = '$("#searchActivityText")'
			var activityName = this.value
			var clueId = '${clue.id}'
			$.ajax({
				url:'workbench/clue/queryActivityForConvert.do',
				data:{
				activityName:activityName,
				clueId:clueId
			},dataType:'json',
				type:'post',
				success:function (data){
					var htmlStr=""
					$.each(data,function (index,activity){
					htmlStr+="<tr>"
					//	方便获取activity的id和name,
					// 	是从data中获取数据，不是从作用域中
					htmlStr+="	<td><input type=\"radio\" value=\""  +activity.id+   "\"  activityName=\""+activity.name+"\" name=\"activity\"/></td>"
					htmlStr+="	<td>"+activity.name+"</td>"
					htmlStr+="	<td>"+activity.startDate+"</td>"
					htmlStr+="	<td>"+activity.endDate+"</td>"
					htmlStr+="	<td>"+activity.owner+"</td>"
					htmlStr+="</tr>"
					})
					$("#tbody").html(htmlStr)
				}
			})
		})
	//	给活动的单选按钮添加单击事件    然后关闭模态窗口，刷新显示
		$("#tbody").on("click","input[type='radio']",function (){
			var activityId = this.value
			var activityName = $(this).attr("activityName")

			//把id和name通过隐藏域设置到  转换详情页面
			$("#activityId").val(activityId)
			$("#activityName").val(activityName)

			$("#searchActivityModal").modal("hide")
		})
		//给转换按钮添加单击事件
		$("#saveConvertBtn").click(function(){
	//			收集参数
	// 		String clueId,String money,String name, String expectedDate,
	// 				String activityId,String stage,String isCreateTran,
			var clueId='${clue.id}'
			var money=$.trim($("#amountOfMoney").val())
			var name=$.trim($("#tradeName").val())
			var expectedDate=$("#expectedClosingDate").val()
			var activityId=$("#activityId").val()
			var stage=$("#stage").val()
			var isCreateTran=$("#isCreateTransaction").prop("checked")
	//表单验证
	//		金额   非负整数  正则表达式
			$.ajax({
				url: 'workbench/clue/saveConvert.do',
				data: {
					clueId: clueId,
					money: money,
					name: name,
					expectedDate: expectedDate,
					activityId: activityId,
					stage: stage,
					isCreateTran: isCreateTran
				},
				dataType: 'json',
				type: 'post',
				success:function (data){
					if (data.code=='1'){
						window.location.href='workbench/clue/index.do'
					}else {
						alert(data.message)
					}
				}
			})
	})
	})
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">

						    <input type="text" id="searchActivityText" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tbody">
<%--						<c:forEach items="${activityList}" var="activity">--%>
<%--							<tr>--%>
<%--								<td><input type="radio" value="${activity.id}" activityName="${activity.name}" name="activity"/></td>--%>
<%--								<td>${activity.name}</td>&ndash;%&gt;--%>
<%--								<td>${activity.startDate}</td>&ndash;%&gt;--%>
<%--								<td>${activity.endDate}</td>&ndash;%&gt;--%>
<%--								<td>${activity.owner}</td>&ndash;%&gt;--%>
<%--							</tr>--%>
<%--						</c:forEach>--%>

<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
				<c:forEach items="${stageList}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			  <%--						type="hidden"  隐藏域	  --%>
			  <input type="hidden" id="activityId">
			  <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" id="saveConvertBtn" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>