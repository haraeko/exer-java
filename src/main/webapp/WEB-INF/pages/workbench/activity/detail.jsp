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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		//鼠标悬停事件
		//现在的bug是新创建的评论不触发鼠标悬停事件
		// $(".remarkDiv").mouseover(function(){
		// 	//当前标签的子标签的子标签
		// 	$(this).children("div").children("div").show();
		// });

		//固有的父元素   on
		$("#remarkDivList").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})


		$("#remarkDivList").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		});

		$("#remarkDivList").on("mouseover",".myHref",function(){
			$(this).children("span").css("color","red");
		});

		$("#remarkDivList").on("mouseout",".myHref",function(){
			$(this).children("span").css("color","#E6E6E6");
		});

	//	给保存按钮添加单击事件
		$("#saveCreateActivityRemarkBtn").click(function (){
		//收集参数
			var noteContent=$.trim($("#remark").val());
			//获取当前页面activity的id   在作用域  el表达式

			<%--'${activity.id}'在服务器取到，如果不加‘’，会被浏览器认为是变量，而不是字符串常量
			--%>
			var activityId= '${activity.id}'
		//	表单验证
			if (noteContent==""){
				alert("内容不能为空")
				return
			}
			$.ajax({
				url:'workbench/activity/saveCreateActivityRemark.do',
				//data里的内容不加''   加上就成为常量字符串了，无法作为变量动态展示
				data:{
					noteContent:noteContent,
					//上面有单引号了，此处就不加了
					// activityId:activityId
					activityId:'${activity.id}'
				},
				type:'post',
				dataType:'json',
				success:function (data){
					if (data.code=='1'){
						// var remark=data.retData   不可以这样？？？
					//	清空输入框   空值
						$("#remark").val("")
					//	把刷新列表  动态拼出来一个字符串
					var htmlStr=""
							//id=\"div_"   +data.retDate.id+ 减少id冲突，加前缀div_
							htmlStr+="<div id=\"div_"   +data.retDate.id+   "class=\"remarkDiv\" style=\"height: 60px;\">"
							<%--//从session中取值${sessionScope.sessionUser.name}   sessionUser在哪里设置了呢？？？？--%>
							htmlStr+="		<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">"
							htmlStr+="		<div style=\"position: relative; top: -40px; left: 40px;\" >"
							//成功状态下    直接使用收集到的参数
							//加上h5_    避免重名发生冲突
							htmlStr+="			<h5>"   +noteContent+   "</h5>"
						// htmlStr+="			<h5>"   +data.retData.noteContent+"</h5>"
							htmlStr+="			<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name}</b> <small style=\"color: gray;\">"   +data.retData.CreateTime+  "由${sessionScope.sessionUser.name}创建</small>"
							htmlStr+="			<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
						//修改图标  要和id 绑定
							htmlStr+="				<a class=\"myHref\" name=\"editA\" remarkId=\""   +data.retData.id+   "href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
							htmlStr+="				&nbsp;&nbsp;&nbsp;&nbsp;"
							htmlStr+="				<a class=\"myHref\" name=\"deleteA\" remarkId=\""   +data.retData.id+   "href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
							htmlStr+="			</div>"
							htmlStr+="		</div>"
							htmlStr+=" </div>"
					//用选择器.before      找下一个标签
						$("#remarkDiv").before(htmlStr)
					}
						//+data.retData.id+     拼接字符串取值   为什么  不是已经设置一个变量remark了吗
						//	alert(data.message)   js函数内
						else {
							alert(data.message)
					}
				}
			})
		})

		//	给删除图标添加单击事件
	//	动态生成的   用on   找父元素
	// 	a[name='deleteA']  从a标签中取值
		$("#remarkDivList").on("click","a[name='deleteA']",function (){
			//收集参数   有dom对象，如何获取jquer属性  用$   attr是啥
			var remarkId=$(this).attr("remarkId")
			$.ajax({
				url: 'workbench/activity/clearActivityRemarkById.do',
				//什么时候用{}  什么时候直接冒号？
				data: {remarkId:'remarkId'},
				type: 'post',
				dataType: 'json',
				success:function (data){
					if (data.code=='1'){
					//	刷新列表
					// 	错误   window.location.href="workbench/activity/detailActivity.do"
					// 	前台删除东西  用remove    怎么找到标签呢？    使图标的id属性和div的id值相同
						$("#div_"+id).remove()
					}else {
						alert(data.message)
					}
				}
			})

		})

	//	给修改图标添加单击事件
		$("#remarkDivList").on("click","a[name='editA']",function (){

		//	收集参数
			var remarkId=$(this).attr("remarkId")
					//不懂！！！！！
					// <>间接父子选择器  空格直接的父子选择器
			var noteContent=$("#div_"+remarkId+" h5").text()
			//把两个id关联起来    ？为什么
			$("#edit-id").val(remarkId)
			$("#edit-noteContent").val(noteContent)
			//这里不用重新发送请求，可以直接获取内容
			// $.ajax({
			// 	url:'workbench/activity/queryActivityRemarkById.do',
			// 	data:{
			// 		remarkId:'remarkId'
			// 	},
			// 	type:'post',
			// 	dataType:'json',
			// 	success:function (data){
			// 		$("#remarkId").val(data.noteContent)
			// 	}
			// })

			//	弹出模态窗口
			$("#editRemarkModal").modal("show")
		})

	//	给更新按钮添加单击事件
		$("#updateRemarkBtn").click(function (){

		//	收集文本框的内容
			var noteContent=$.trim($("#edit-noteContent").val())

			//	收集文本框的内容
			var remarkId=$("#edit-id").val()


			if (noteContent==""){
				alert("修改内容不允许为空")
				return
			}
			$.ajax({
				url:'workbench/activity/editActivityRemarkById.do',
				data:{
					//这里的id 不能是remarkId,因为要和controller层的remark的属性id保持一致
					id:remarkId,
					noteContent:noteContent
				},
				type:'post',
				dataType:'json',
				success:function (data){
					if (data.code=='1'){
						$("#editRemarkModal").modal("hide")
					//	刷新列表    展示修改的内容
					// 	$("#edit-noteContent").val(noteContent)   为什么这种不刷新？不懂下面的操作
					//	动态拼接  找父选择器
						$("#div_"+data.retData.id+" h5").text(data.retData.noteContent)
						$("#div_"+data.retData.id+" small").text(" "+data.retData.editTime+" 由${sessionScope.sessionUser.name}修改")

					}else {
						$("#editRemarkModal").modal("show")
					}
				}
			})
		})
	})



</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId" >
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
<%--						隐藏域   为了填充修改前的内容--%>
						<input type="hidden" id="edit-id">
                        <div class="form-group">
<%--							<label for="edit-describe" class="col-sm-2 control-label">内容</label>--%>
<%--label for 修饰标签   写修饰的内容的id--%>
							<label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
<%--			<h3>市场活动-发传单 <small>2020-10-10 ~ 2020-10-20</small></h3>--%>
				<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>

		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

<%--		遍历remarklist  有几个就显示几个div--%>
		<c:forEach items="${remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
					<%--title="zhangsan"   鼠标悬停会展示的内容			--%>
				<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
<%--					业务逻辑：如果修改过editflag为1，就显示修改时间      ，否则显示创建时间--%>
<%--					<c:if test="${remark.editFlag=='1'}">${remark.editTime}</c:if><c:if test="${remark.editFlag=='0'}">${remark.createTime}</c:if>--%>
<%--					${remark.editFlag=='1'?remark.editTime:remark.createTime}--%>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> ${remark.editFlag=='1'?remark.editTime:remark.createTime} 由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
							<%--					a标签加不同的样式，class="glyphicon glyphicon-edit"前台会展示不同的图标--%>
<%--						自定义标签       获取a标签下的值，前台显示的是图标--%>
						<a class="myHref" name="editA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--&lt;%&ndash;title="zhangsan"   鼠标悬停会展示的内容			&ndash;%&gt;--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--&lt;%&ndash;					a标签加不同的样式，class="glyphicon glyphicon-edit"前台会展示不同的图标&ndash;%&gt;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--		--%>
<%--		<!-- 备注2 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" id="saveCreateActivityRemarkBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>