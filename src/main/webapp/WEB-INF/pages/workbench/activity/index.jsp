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
	<link rel="stylesheet" type="text/css" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<%--<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />--%>
<%--<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />--%>

<%--<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>--%>
<%--<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>--%>
<%--<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>--%>
<%--<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>--%>
<%--<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css"/>--%>
<%--<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>--%>
<%--<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js/en.min.js"></script>--%>

	<script type="text/javascript">
<%--入口函数--%>
	$(function(){
		//给"创建"按钮添加单击事件
		$("#createActivityBtn").click(function () {
			//初始化工作
			//重置表单
			$("#createActivityForm").get(0).reset();

			//弹出创建市场活动的模态窗口
			$("#createActivityModal").modal("show");
		});
		
		//给"保存"按钮添加单击事件
		$("#saveCreateActivityBtn").click(function () {
			//收集参数
			var owner=$("#create-marketActivityOwner").val();
			var name=$.trim($("#create-marketActivityName").val());
			var startDate=$("#create-startDate").val();
			var endDate=$("#create-endDate").val();
			var cost=$.trim($("#create-cost").val());
			var description=$.trim($("#create-description").val());
			//表单验证
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==""){
				alert("名称不能为空");
				return;
			}
			if(startDate!=""&&endDate!=""){
				//使用字符串的大小代替日期的大小
				if(endDate<startDate){
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			/*
			  正则表达式：
			     1，语言，语法：定义字符串的匹配模式，可以用来判断指定的具体字符串是否符合匹配模式。
			     2,语法通则：
			       1)//:在js中定义一个正则表达式.  var regExp=/...../;
			       2)^：匹配字符串的开头位置
			         $: 匹配字符串的结尾
			       3)[]:匹配指定字符集中的一位字符。 var regExp=/^[abc]$/;
			                                    var regExp=/^[a-z0-9]$/;
			       4){}:匹配次数.var regExp=/^[abc]{5}$/;
			            {m}:匹配m此
			            {m,n}：匹配m次到n次
			            {m,}：匹配m次或者更多次
			       5)特殊符号：
			         \d:匹配一位数字，相当于[0-9]
			         \D:匹配一位非数字
			         \w：匹配所有字符，包括字母、数字、下划线。
			         \W:匹配非字符，除了字母、数字、下划线之外的字符。

			         *:匹配0次或者多次，相当于{0,}
			         +:匹配1次或者多次，相当于{1,}
			         ?:匹配0次或者1次，相当于{0,1}
			 */
			var regExp=/^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能为非负整数");
				return;
			}
			//发送请求
			$.ajax({
				url:'workbench/activity/saveCreateActivity.do',
				data:{
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//关闭模态窗口
						$("#createActivityModal").modal("hide");
						//刷新市场活动列，显示第一页数据，保持每页显示条数不变(保留)
						//分页插件工具函数
						queryActivityByConditionForPage(1,$("#page").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#createActivityModal").modal("show");//可以不写。
					}
				}
			});


		});
		//当容器加载完成之后，对容器调用工具函数
		//$("input[name='mydate']").datetimepicker({
		$(".mydate").datetimepicker({
			language:'zh-CN', //语言
			format:'yyyy-mm-dd',//日期的格式
			minView:'month', //可以选择的最小视图
			initialDate:new Date(),//初始化显示的日期
			autoclose:true,//设置选择完日期或者时间之后，日否自动关闭日历
			todayBtn:true,//设置是否显示"今天"按钮,默认是false
			clearBtn:true//设置是否显示"清空"按钮，默认是false
		});

	//当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数,默认每页显示5条
		queryActivityByConditionForPage(1,5);

	//给"查询"按钮添加单击事件
		$("#queryActivityBtn").click(function () {
		alert("aaaa");
		//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
		//查询分页
		// $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage')  是分页查询工具里的参数，可以获得pagesize
		// queryActivityByConditionForPage(1,$("#element_id").bs_pagination('getOption','option_name'));
		queryActivityByConditionForPage(1,5);
		// 1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage')
	//	这里如果和分页插件有关系的话，单击事件就转到页数1了，不知道问什么？
	});

	//给全选添加单击事件
		$("#checkAll").click(function (){
			//要获取   checked 属性值
			// $("#checkAll").prop("checked");太麻烦
			//用this,获取dom对象
			// if (this.checked==true){
			// 	//父子选择器  因为此页只有列表的input，所以可以直接写input
			// 	// $("#tBody>input[type='checkbox']")   >只能获取子标签，不能获取子子标签
			// 	//空格  可以选中所有的子标签
			// 	$("#tBody input[type='checkbox']").prop("checked",true);
			// }else {
			// 	$("#tBody input[type='checkbox']").prop("checked",false);
			// }

			$("#tBody input[type='checkbox']").prop("checked",this.checked);

		})

	//	自动取消全选  自动选择全选
	//	因为是异步请求，不会等前面分页查询加载，加载这个的时候，check还没有拼出来 所以不可
	// 	$("#tBody input[type='checkbox']").click(function (){
	// 	//	调试方法alert
	// 		alert("aaaa")
	// 	//	如果列表被用户全部选中，则自动全选
	// 	//	所有的check 的数量 和 所以checked的 数量一致，则全选的状态
	// 		if ($("#tBody input[type='checkbox']").size()==
	// 		$("#tBody input[type='checkbox']:checked").size()){
	// 			$("#checkAll").prop("checked",true);
	// 		}else {
	// 			$("#checkAll").prop("checked",false);
	// 		}
	// 	})
	//	使用jquery的父子选择器   on
		$("#tBody").on("click","input[type='checkbox']",function (){
			if ($("#tBody input[type='checkbox']").size()==
				$("#tBody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked",true);
			}else {
			 	$("#checkAll").prop("checked",false);
			}
		})


	//	给删除添加单机事件
		$("#deleteActivityBtn").click(function () {
			//	收集参数  所有被选中的id
			var checkedIds=$("#tBody input[type='checkbox']:checked");
			if (checkedIds.size()==0){
				alert("请选择要删除的市场活动");
				return
			}
			//阻塞函数  只有用户点true确定 false取消，才会执行后面的
			if (window.confirm("确定删除吗？")){
				//	遍历数组
<%--<c:forEach ></c:forEach>&ndash;%&gt;   获取作用域里的数据   这里不可用--%>
// alert("aaaa")
				var ids="";//声明变量
				$.each(checkedIds,function (){
					//this拿到dom对象
					ids+=  "id="  +this.value+  "&"
				})
				//	截取字符串
				ids=ids.substring(0,ids.length-1)
// alert("bbbb")
				//	发送请求
				$.ajax({
					url:'workbench/activity/deleteActivityByIds.do',
					data:ids,
					type:'post',
					dataType:'json',
					success:function (data){
						if (data.code=="1"){
							//	刷新   查询
							queryActivityByConditionForPage(1,5)
						}else {
							alert(data.message)
						}
					}
				})
			}
		})

	//	给修改按钮添加单击事件
		$("#editActivityBtn").click(function (){
			//收集参数
			//获取被选中的checkbox
			var checkedId=$("#tBody input[type='checkbox']:checked")
			// if (checkedId.size()!=1){
			// 	alert("请选择一条要修改的活动");
			// 	return;
			// }
			if(checkedId.size()==0){
				alert("请选择要修改的市场活动");
				return;
			}
			if(checkedId.size()>1){
				alert("每次只能修改一条市场活动");
				return;
			}
			//三个相同用法    后俩  拿到dom对象
			// var id=checkedId.val()
			// checkedId.get(0).value;
			var id=checkedId[0].value;
			$.ajax({
				url:'workbench/activity/queryActivityById.do',
				data:{
					// 不用加‘’
					id:id
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					$("#edit-id").val(data.id)
					//浏览器下拉列表会自动   根据id值选择
					$("#edit-marketActivityOwner").val(data.owner)
					$("#edit-marketActivityName").val(data.name)
					$("#edit-startDate").val(data.startDate);
					$("#edit-endDate").val(data.endDate);
					$("#edit-cost").val(data.cost);
					$("#edit-description").val(data.description);
					//弹出修改市场活动的模态窗口
					$("#editActivityModal").modal("show");}
				});
		});

		// 给"更新"按钮添加单击事件
		$("#saveEditActivityBtn").click(function () {
			//收集参数
			//隐藏域有id
			var id=$("#edit-id").val();
			var owner=$("#edit-marketActivityOwner").val();
			var name=$.trim($("#edit-marketActivityName").val());
			var startDate=$("#edit-startDate").val();
			var endDate=$("#edit-endDate").val();
			var cost=$.trim($("#edit-cost").val());
			var description=$.trim($("#edit-description").val());
			//表单验证
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==""){
				alert("名称不能为空");
				return;
			}
			if(startDate!=""&&endDate!=""){
				//使用字符串的大小代替日期的大小
				if(endDate<startDate){
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			/*
              正则表达式：
                 1，语言，语法：定义字符串的匹配模式，可以用来判断指定的具体字符串是否符合匹配模式。
                 2,语法通则：
                   1)//:在js中定义一个正则表达式.  var regExp=/...../;
                   2)^：匹配字符串的开头位置
                     $: 匹配字符串的结尾
                   3)[]:匹配指定字符集中的一位字符。 var regExp=/^[abc]$/;
                                                var regExp=/^[a-z0-9]$/;
                   4){}:匹配次数.var regExp=/^[abc]{5}$/;
                        {m}:匹配m此
                        {m,n}：匹配m次到n次
                        {m,}：匹配m次或者更多次
                   5)特殊符号：
                     \d:匹配一位数字，相当于[0-9]
                     \D:匹配一位非数字
                     \w：匹配所有字符，包括字母、数字、下划线。
                     \W:匹配非字符，除了字母、数字、下划线之外的字符。

                     *:匹配0次或者多次，相当于{0,}
                     +:匹配1次或者多次，相当于{1,}
                     ?:匹配0次或者1次，相当于{0,1}
             */
			var regExp=/^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能为非负整数");
				return;
			}
			//发送请求
			$.ajax({
				url:'workbench/activity/saveEditActivityById.do',
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
						//刷新市场活动列，显示第一页数据，保持每页显示条数不变(保留)
						//分页插件工具函数
						queryActivityByConditionForPage($("#page").bs_pagination('getOption', 'currentPage'),
								$("#page").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#editActivityModal").modal("show");//可以不写。
					}
				}
			});
		});
		//当容器加载完成之后，对容器调用工具函数
		//$("input[name='mydate']").datetimepicker({
		$(".mydate").datetimepicker({
			language:'zh-CN', //语言
			format:'yyyy-mm-dd',//日期的格式
			minView:'month', //可以选择的最小视图
			initialDate:new Date(),//初始化显示的日期
			autoclose:true,//设置选择完日期或者时间之后，日否自动关闭日历
			todayBtn:true,//设置是否显示"今天"按钮,默认是false
			clearBtn:true//设置是否显示"清空"按钮，默认是false
		});

	//	给批量导出添加单击事件
		$("#exportActivityAllBtn").click(function (){
			window.location.href="workbench/activity/exportAllActivity.do";
		})

	//给导入按钮添加单击事件
		$("#importActivityBtn").click(function (){

		//收集参数
		//	只能获取到文件名   表单验证
			var activityFileName=$("#activityFile").val()
			// fileName.substring(1.3)
			// fileName.substr(1,1)
			//截取当前角标及之后的字符串
			//文件后缀名不区分大小写    统一转小写去比较
			var suffix=activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLocaleLowerCase()
			if (suffix!="xls"){
				alert("仅支持上传xls文件")
				return
			}
			//获取文件内容
			//要先获取到dom对象
			//files是个数组   一般就支持导入一个文件   0
			var activityFile = $("#activityFile")[0].files[0];
			//	验证文件大小5M
			if (activityFile.size > 5*1024*1024){
				alert("文件大小不能超过5MB")
				return;
			}
			// alert("要发送请求了1")  不测试的时候要即使删掉   是阻塞行为
			// 发送请求
			//FormData  是ajax提供的接口    模拟键值对   可提交二进制数据  字符串

			var formData=new FormData()
			//KEY的值可以随便起  但是要和controller里形参的值保持一致
			formData.append("activityFile",activityFile)
			formData.append("username","hara")

			$.ajax({
				url:'workbench/activity/importActivityByUpload.do',
				data:formData,
				processData:false,//默认情况下是true字符串   但这里需要二进制数据
				contentType:false,//设置是否发参数同意按照urlencoded 编码
				type:'post',
				dataType:'json',
				success:function (data){
					if (data.code=='1'){
						alert("成功导入"+data.retData+"条记录")
					//	关闭模态窗口
						$("#importActivityModal").modal("hide")
					//	根据需求刷新市场活动列表  显示第一页
						queryActivityByConditionForPage(1,$("#page").bs_pagination('getOption', 'rowsPerPage'))
					}else {
						alert("data.message")
						$("#importActivityModal").modal("show")
					}
				}
			})
		})

	});



	//在入口函数外部封装函数
	//从后台查询数据  并返回前端
	function queryActivityByConditionForPage(pageNo,pageSize) {
	//收集参数
	var name=$("#query-name").val();
	var owner=$("#query-owner").val();
	var startDate=$("#query-startDate").val();
	var endDate=$("#query-endDate").val();
	// var pageNo=1;
	// var pageSize=10;
	//发送请求
	$.ajax({
		url:'workbench/activity/queryActivityByConditionForPage.do',
		data:{
			name:name,
			owner:owner,
			startDate:startDate,
			endDate:endDate,
			pageNo:pageNo,
			pageSize:pageSize
		},
		type:'post',
		dataType:'json',
		success:function (data) {
			//显示总条数          后使用分页插件
			// $("#totalRowsB").text(data.totalRows);
			//显示市场活动的列表
			//遍历activityList，拼接所有行数据
			var htmlStr="";
			$.each(data.activityList,function (index,obj) {
				htmlStr+="<tr class=\"active\">";
				//check包含id信息
				htmlStr+="<td><input type=\"checkbox\" value=\""  +obj.id+  "\"/></td>";
				//这一步不太懂
				htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="  +obj.id+   "'\">"  +obj.name+  "</a></td>";
				htmlStr+="<td>"+  obj.owner+  "</td>";
				htmlStr+="<td>"+  obj.startDate+  "</td>";
				htmlStr+="<td>"+  obj.endDate+  "</td>";
				htmlStr+="</tr>";
			});
			$("#tBody").html(htmlStr);
			//取消全选按钮    因为换页查询新加载出来的都是没有选中的，所以要把固有页面上的全选按钮取消 全选
			$("#checkAll").prop("checked",false)


			//响应成功之后才调用分页的工具函数
			var totalPages;
			if (data.totalRows%pageSize==0){//总条数可以整除
				totalPages=data.totalRows/pageSize;
			}else {
				totalPages=parseInt(data.totalRows/pageSize)+1;//parseint函数可以只取整数部分
			}
			//分页插件  在获取到总条数之后，执行
			$("#page").bs_pagination({
				currentPage:pageNo,//当前页号,相当于pageNo
				rowsPerPage:pageSize,//每页显示条数,相当于pageSize
				totalRows:data.totalRows,//总条数    从json取值
				totalPages: totalPages,  //总页数,必填参数.

				visiblePageLinks:5,//最多可以显示的卡片数

				showGoToPage:true,//是否显示"跳转到"部分,默认true--显示
				showRowsPerPage:true,//是否显示"每页显示条数"部分。默认true--显示
				showRowsInfo:true,//是否显示记录的信息，默认true--显示

				//用户每次切换页号，都自动触发本函数;
				//每次返回切换页号之后的pageNo和pageSize
				onChangePage: function(event,pageObj) { // returns page_num and rows_per_page after a link has clicked
				//js代码
				//alert(pageObj.currentPage);
				//alert(pageObj.rowsPerPage);
				//把当下页号和每页条数传给后端
				//递归的feel  因为插件只切换页数信息，所以需要手动刷新展示的内容
				queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);

				}
			});
		}
	});
	}



	
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <c:forEach items="${userList}" var="u">
									   <option value="${u.id}">${u.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startDate">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<%--						添加隐藏域     把查询到的市场活动返回值  返回给隐藏域--%>
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
<%--								下拉列表--%>
								<select class="form-control" id="edit-marketActivityOwner">
<%--									从作用域中取值--%>
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
<%--								value="发传单"--%>
                                <input type="text" class="form-control" id="edit-marketActivityName" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label mydate">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label mydate">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
<%--					data-dismiss="modal"  无论成功还是失败  都关闭  和此处业务不符合--%>
					<button type="button" class="btn btn-primary" id="saveEditActivityBtn" >更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>
<%--				  submit改为button--%>
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
<%--				  data-toggle="modal" data-target="#editActivityModal"--%>
					<button type="button" class="btn btn-default" id="editActivityBtn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
<%--				此处  是给按钮添加事件，不是给汉字--%>
					<button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="page"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">--%>

<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>
			
		</div>
		
	</div>
</body>
</html>