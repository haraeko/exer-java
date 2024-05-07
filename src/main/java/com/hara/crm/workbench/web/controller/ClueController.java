package com.hara.crm.workbench.web.controller;

import com.alibaba.druid.sql.ast.statement.SQLIfStatement;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.hara.crm.commons.contants.Contants;
import com.hara.crm.commons.domain.ReturnObject;
import com.hara.crm.commons.utils.DateUtils;
import com.hara.crm.commons.utils.UUIDUtils;
import com.hara.crm.settings.domain.DicValue;
import com.hara.crm.settings.domain.User;
import com.hara.crm.settings.service.DicValueService;
import com.hara.crm.settings.service.UserService;
import com.hara.crm.workbench.domain.Activity;
import com.hara.crm.workbench.domain.Clue;
import com.hara.crm.workbench.domain.ClueActivityRelation;
import com.hara.crm.workbench.domain.ClueRemark;
import com.hara.crm.workbench.service.ActivityService;
import com.hara.crm.workbench.service.ClueActivityRelationService;
import com.hara.crm.workbench.service.ClueRemarkService;
import com.hara.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.swing.text.Element;
import java.net.http.HttpRequest;
import java.security.AllPermission;
import java.util.*;

/**
 * ClassName: ClueController
 * Package: com.hara.crm.workbench.web.controller
 * ProjectName:crm-project
 * Description:
 */
@Controller
public class ClueController {

    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;
//    访问线索主页面
    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
//        调用service层方法  查询下拉列表的数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

//        把数据保存到request中
        request.setAttribute("userList",userList);
        request.setAttribute("appellationList",appellationList);
        request.setAttribute("clueStateList",clueStateList);
        request.setAttribute("sourceList",sourceList);

//请求转发
        return "workbench/clue/index";
    }


//    保存线索
    @RequestMapping("/workbench/clue/saveCreatClue.do")
    @ResponseBody
    public Object saveCreatClue(Clue clue, HttpSession session){
//        (id, fullname, appellation,
//                owner, company, job, email,
//                phone, website, mphone,
//                state, source, create_by,
//                create_time,
//                description, contact_summary, next_contact_time,
//                address)
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formateDateTime(new Date()));

        try {
            int res = clueService.saveCreateClue(clue);
            if (res == 1) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
        }
        return returnObject;
    }


//    跳转页面
    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(String id,HttpServletRequest request){
        Clue clue = clueService.queryClueForDetailById(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkForDetailByClueId(id);
        List<Activity> activityList = activityService.queryActivityForClueByClueId(id);

//       因为跳转页面，返回的是url,不是json,所以把数据保存到作用域中！！！！！
        request.setAttribute("clue",clue);
        request.setAttribute("clueRemarkList",clueRemarkList);
        request.setAttribute("activityList",activityList);

        return "workbench/clue/detail";
    }

//    前台会传过来activityname   clueId
    @RequestMapping("/workbench/clue/queryActivityForClueByNameClueId.do")
    @ResponseBody
    public Object queryActivityForClueByNameClueId(String activityName,String clueId) {
//     list可以直接转为json   ReturnObject returnObject = new ReturnObject();
        //        封装参数，传给后台
        Map<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("clueId", clueId);

        List<Activity> activityList = activityService.queryActivityForClueByNameClueId(map);
        return activityList;
    }
    @RequestMapping("/workbench/clue/saveClueActivityRelation.do")
    @ResponseBody
    public Object saveClueActivityRelation(String clueId,String[] activityId) {
    ReturnObject returnObject = new ReturnObject();
    List<ClueActivityRelation> relationList = new ArrayList<>();
    ClueActivityRelation car = null;
//    for (int i=0;i<activityId.length;i++){
//        car = new ClueActivityRelation();
//        car.setId(UUIDUtils.getUUID());
//        car.setClueId(clueId);
//        car.setActivityId(activityId[i]);
//        relationList.add(car);
//    }

//    增强for循环
//    ：后的值   遍历赋值给：前的值
    for (String i:activityId){
        car = new ClueActivityRelation();
        car.setId(UUIDUtils.getUUID());
        car.setClueId(clueId);
        car.setActivityId(i);
        relationList.add(car);
    }
    try {
        int res = clueActivityRelationService.saveClueActivityRelationByList(relationList);
        if (res > 0){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            List<Activity> activityList = activityService.queryActivityForClueByIds(activityId);
            returnObject.setRetData(activityList);
        }else {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
        }
        }catch (Exception e){
        e.printStackTrace();
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
        returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
        }
    return returnObject;
    }

//    解除关联

    @RequestMapping("/workbench/clue/removeRelationByClueIdActivityId.do")
    @ResponseBody
    public Object removeRelationByClueIdActivityId(String clueId,String activityId) {
    ReturnObject returnObject = new ReturnObject();
    ClueActivityRelation relation = new ClueActivityRelation();
    relation.setClueId(clueId);
    relation.setActivityId(activityId);

//    这里的id要不要生成呢？   不用

    try {
        int res = clueActivityRelationService.removeRelationByClueIdActivityId(relation);
        if (res == 1) {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        } else {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
        }
    } catch (Exception e) {
        e.printStackTrace();
        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
        returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
    }
    return returnObject;
    }

//    转换
    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String id,HttpServletRequest request){
        Clue clue = clueService.queryClueForDetailById(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("clue",clue);
        request.setAttribute("stageList",stageList);
        return "workbench/clue/convert";
    }

//    转换页面内容     查询活动
    @RequestMapping("/workbench/clue/queryActivityForConvert.do")
    @ResponseBody
    public Object queryActivityForConvert(String clueId,String activityName){
        Map<String, Object> map = new HashMap<>();
//        map里的key要和SQL语句中的参数一致
        map.put("clueId",clueId);
        map.put("activityName",activityName);
        List<Activity> activityList = activityService.queryActivityForConvertByNameClueId(map);
        return activityList;
    }
//保存线索转换
    @RequestMapping("/workbench/clue/saveConvert.do")
    @ResponseBody
    public Object saveConvert(String clueId,String money,String name, String expectedDate,
                              String activityId,String stage,String isCreateTran,HttpSession session){
        HashMap<String, Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("money",money);
        map.put("name",name);
        map.put("expectedDate",expectedDate);
        map.put("activityId",activityId);
        map.put("stage",stage);
        map.put("isCreateTran",isCreateTran);

        User user = (User)session.getAttribute(Contants.SESSION_USER);
        map.put(Contants.SESSION_USER,user);
        ReturnObject returnObject = new ReturnObject();
        try {
            clueService.saveCustomer(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
        }return returnObject;
    }
}
