package com.hara.crm.workbench.web.controller;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.hara.crm.commons.contants.Contants;
import com.hara.crm.commons.domain.ReturnObject;
import com.hara.crm.commons.utils.DateUtils;
import com.hara.crm.commons.utils.UUIDUtils;
import com.hara.crm.commons.utils.UploadUtils;
import com.hara.crm.settings.domain.User;
import com.hara.crm.settings.service.UserService;
import com.hara.crm.workbench.domain.ActivitiesRemark;
import com.hara.crm.workbench.domain.Activity;
import com.hara.crm.workbench.service.ActivityRemarkService;
import com.hara.crm.workbench.service.ActivityService;
import org.apache.ibatis.javassist.bytecode.LineNumberAttribute;
import org.apache.ibatis.javassist.bytecode.stackmap.BasicBlock;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.aspectj.apache.bcel.classfile.Constant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        //调用service层方法，查询所有的用户
        List<User> userList=userService.queryAllUsers();
        //把数据保存到request中
        request.setAttribute("userList",userList);
        //请求转发到市场活动的主页面
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody Object saveCreateActivity(Activity activity, HttpSession session){
        User user=(User) session.getAttribute(Contants.SESSION_USER);
        //封装参数
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        activity.setCreateBy(user.getId());

        ReturnObject returnObject=new ReturnObject();
        try {
            //调用service层方法，保存创建的市场活动
            int ret = activityService.saveCreateActivity(activity);

            if(ret>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙,请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();

            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙,请稍后重试....");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public @ResponseBody Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,
                                                                int pageNo,int pageSize){
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        //调用service层方法，查询数据
        List<Activity> activityList=activityService.queryActivityByConditionForPage(map);
        int totalRows=activityService.queryCountOfActivityByCondition(map);
        //根据查询结果结果，生成响应信息
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("activityList",activityList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

@RequestMapping("/workbench/activity/deleteActivityByIds.do")
@ResponseBody
    public Object deleteActivityByIds(String[] id) {
//        参数名为id,b不是ids的原因是  和前台传过来的参数保持一致
    ReturnObject returnObject = new ReturnObject();
    try {
        int result = activityService.deleteActivityByIds(id);
        if (result > 0) {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setMessage("删除成功");
        } else {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...1");
        }
    } catch (Exception e) {
        e.printStackTrace();
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
        returnObject.setMessage("系统繁忙，请稍后重试...2");
    }return returnObject;
    }
//   通过id 查询要修改的活动
    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Activity queryActivityById(String id){

        return activityService.queryActivityById(id);

    }

    @RequestMapping("/workbench/activity/saveEditActivityById.do")
    @ResponseBody
    public Object saveEditActivityById(Activity activity,HttpSession session){
        //封装参数
//        activity.setEditBy(Contants.SESSION_USER);错误写法   应该从session中获得
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtils.formateDate(new Date()));
        System.out.println(activity);
        ReturnObject returnObject = new ReturnObject();
        try {
            int result = activityService.saveEditActivityById(activity);
            if (result != 1){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后再试...1");
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("修改成功");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后再试...2");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/fileDownload.do")
    public void fileDownload(HttpServletResponse response) throws Exception{
        //返回响应信息
//        1.设置响应类型      二进制文件
        response.setContentType("application/octet-stream;charset=UTF-8");
//        2.获取输出流  字节流
        OutputStream os = response.getOutputStream();
//        读取磁盘的文件，输出到浏览器
        InputStream is = new FileInputStream("D:\\work4java\\ssm\\crm-project\\filedownloadTest\\studentList.xls");
        byte[] buff=new byte[256];
        int len=0;
        while((len=is.read(buff))!=-1){
            os.write(buff,0,len);
        }

//        浏览器默认直接打开该文件    及时打不开   也会调用其他软件打开   只有实在打不开 才会激活文件下载保存
//        设置响应头信息为附件 使浏览器直接激活下载
        response.addHeader("Content-Disposition","attachment;filename=mystudentList.xls");
//                关闭资源   谁打开的资源谁关闭   所以此处os  是respond  服务器创建的，  不关闭
        is.close();
        os.flush();
    }
//涉及到流的异常   捕获也没用， 直接抛出去    但是为什么？

    @RequestMapping("/workbench/activity/exportAllActivity.do")
    public void exportAllActivity(HttpServletResponse response) throws Exception{
        List<Activity> activityList = activityService.queryAllActivityByCheck();

        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("id");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell=row.createCell(7);
        cell.setCellValue("创建时间");
        cell=row.createCell(8);
        cell.setCellValue("创建者");
        cell=row.createCell(9);
        cell.setCellValue("修改时间");
        cell=row.createCell(10);
        cell.setCellValue("修改者");


//        填充文件
        if (activityList!=null&&activityList.size()>0){
            Activity activity = null;
//            for (int i=0;i<=activityList.size();i++){   不能=   超出范围了

            for (int i=0;i<activityList.size();i++){
            activity = activityList.get(i);
            //创建新的一行
            row = sheet.createRow(i+1);
//            创建一列
            cell = row.createCell(0);
            cell.setCellValue(activity.getId());
            cell = row.createCell(1);
            cell.setCellValue(activity.getOwner());
            cell = row.createCell(2);
            cell.setCellValue(activity.getName());
            cell = row.createCell(3);
            cell.setCellValue(activity.getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(activity.getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(activity.getCost());
            cell = row.createCell(6);
            cell.setCellValue(activity.getDescription());
            cell = row.createCell(7);
            cell.setCellValue(activity.getCreateTime());
            cell=row.createCell(8);
            cell.setCellValue(activity.getCreateBy());
            cell=row.createCell(9);
            cell.setCellValue(activity.getEditTime());
            cell=row.createCell(10);
            cell.setCellValue(activity.getEditBy());
            }
        }


//        FileOutputStream os = new FileOutputStream("D:\\work4java\\ssm\\crm-project\\filedownloadTest\\activityList.xls");
////        会访问磁盘 效率很低
////        workbook.write(os);
//        os.close();
//        workbook.close();
//        下载到用户电脑
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=myActivityList.xls");
        OutputStream os1 = response.getOutputStream();
//        InputStream is = new FileInputStream("D:\\work4java\\ssm\\crm-project\\filedownloadTest\\activityList.xls");
//        byte[] buff=new byte[256];
//        int len=0;
////        这个循环也访问磁盘 效率也低
//        while((len=is.read(buff))!=-1){
//            os1.write(buff,0,len);
//        }
//        !!!!!workbook提供write方法  避免磁盘的输入和输出  直接内存到内存

        workbook.write(os1);

//        is.close();
        workbook.close();
        os1.flush();
    }
//测试用  无实际业务含义
    @RequestMapping("/workbench/activity/fileUpload.do")
    @ResponseBody
    public Object fileUpload(String username, MultipartFile myFile) throws Exception{
//        MultipartFile myFile   需要配置springmvc 的文件上传解析器   自动bean
        ReturnObject returnObject = new ReturnObject();
//        把文本数据打印到控制台
        System.out.println(username);
        String originalFilename = myFile.getOriginalFilename();
//        把文件在服务器指定的目录中生成同样的文件
        File file = new File("D:\\work4java\\ssm\\crm-project\\fileuploadTest",originalFilename);
        myFile.transferTo(file);
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        returnObject.setMessage("成功");
        return returnObject;
    }
//    导入文件

    @RequestMapping("/workbench/activity/importActivityByUpload.do")
    @ResponseBody
    public Object importActivityByUpload(MultipartFile activityFile,HttpSession session) {
        ReturnObject returnObject = new ReturnObject();
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        try {
////        把接收到的文件写入到磁盘目录
//            String originalFilename = activityFile.getOriginalFilename();
////            后面有俩\\
//            File file = new File("D:\\work4java\\ssm\\crm-project\\fileuploadTest\\服务器模拟\\", originalFilename);
////           把上传的文件复制给服务器中的文件
//            activityFile.transferTo(file);
//
////解析excel文件，封装为activityList
//            InputStream fis = new FileInputStream("D:\\work4java\\ssm\\crm-project\\fileuploadTest\\服务器模拟\\"+originalFilename);
            InputStream fis = activityFile.getInputStream();//替代上面的代码，提高效率
            HSSFWorkbook workbook = new HSSFWorkbook(fis);
            HSSFSheet sheet = workbook.getSheetAt(0);

            HSSFRow row = null;
            HSSFCell cell = null;
            Activity activity = null;

//        略过表头   从第2行开始解析
            List<Activity> activityList = new ArrayList<>();

//            两个for循环嵌套还是要注意
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                row = sheet.getRow(i);
                activity = new Activity();

                activity.setId(UUIDUtils.getUUID());
//            第一列的数据是所有者的名字   根据业务设计  设置为登陆账号的id
                activity.setOwner(user.getId());
                activity.setCreateBy(user.getId());
                activity.setCreateTime(DateUtils.formateDateTime(new Date()));

                for (int j = 0; j < row.getLastCellNum(); j++) {
                    cell = row.getCell(j);
                    String cellValue = UploadUtils.getCellValueForStr(cell);
//              一般  规定好文件模板
//             设计到业务   谁导入的活动   谁就是所有者
                    if (j == 0) {
                        activity.setName(cellValue);
                    } else if (j == 1) {
                        activity.setStartDate(cellValue);
                    } else if (j == 2) {
                        activity.setEndDate(cellValue);
                    } else if (j == 3) {
                        activity.setCost(cellValue);
                    } else if (j == 4) {
                        activity.setDescription(cellValue);
                    }
                }
                activityList.add(activity);
            }
            int result = activityService.addActivityByUpload(activityList);
//这里需要判断是否大于0吗
//                if (result > 0) {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
//                    returnObject.setMessage("上传成功");
//                    返回插入数据条数
            returnObject.setRetData(result);
//                }else {
//                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
//                    returnObject.setMessage("系统繁忙，请稍后再试...");
//                }
            workbook.close();
            fis.close();
        } catch (IOException e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后再试...");
        }
        return returnObject;
    }

//    参数为什么是request 不是response
    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String id,HttpServletRequest request){
        Activity activity = activityService.queryActivityForDetailById(id);
        List<ActivitiesRemark> remarkList = activityRemarkService.queryActivityRemarkForDetailByActivity(id);
        request.setAttribute("activity",activity);
        request.setAttribute("remarkList",remarkList);
        return "workbench/activity/detail";
    }
}
