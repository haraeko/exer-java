package com.hara.crm.workbench.web.controller;

import com.hara.crm.commons.contants.Contants;
import com.hara.crm.commons.domain.ReturnObject;
import com.hara.crm.commons.utils.DateUtils;
import com.hara.crm.commons.utils.UUIDUtils;
import com.hara.crm.settings.domain.User;
import com.hara.crm.workbench.domain.ActivitiesRemark;
import com.hara.crm.workbench.service.ActivityRemarkService;
import org.apache.ibatis.javassist.bytecode.stackmap.BasicBlock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.Map;

/**
 * ClassName: ActivityRemarkController
 * Package: com.hara.crm.workbench.web.controller
 * ProjectName:crm-project
 * Description:
 */
@Controller
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivitiesRemark remark, HttpSession session){
//        此处参数为remark  是前台封装好的
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateTime(DateUtils.formateDateTime(new Date()));
//        直接传session    不用request   那如何区分什么时候传什么呢
//        User user = (User) request.getSession().getAttribute("user");
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        remark.setCreateBy(user.getId());
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);


        int res = activityRemarkService.saveCreateActivityRemark(remark);
        ReturnObject returnObject = new ReturnObject();
        try {
            if (res>0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
//                前台去拼接字符串
                returnObject.setRetData(remark);
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

@RequestMapping("/workbench/activity/clearActivityRemarkById.do")
@ResponseBody
    public Object clearActivityRemarkById(String id) {
    ReturnObject returnObject = new ReturnObject();
    try {
        int res = activityRemarkService.clearRemarkById(id);
        if (res == 0) {
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


//    @RequestMapping("/workbench/activity/queryActivityRemarkById.do")
//    @ResponseBody
//    public Object queryActivityRemarkById(String remarkId){
//        return activityRemarkService.queryActivityRemarkById(remarkId);
//    }

    @RequestMapping("/workbench/activity/editActivityRemarkById.do")
    @ResponseBody
    public Object editActivityRemarkById(ActivitiesRemark remark,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
//        request是向前台返回数据使用
//        request.getSession().getAttribute(Contants.SESSION_USER)
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        remark.setEditBy(user.getId());
        remark.setEditTime(DateUtils.formateDateTime(new Date()));
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDIT);
        try {
            int res = activityRemarkService.editActivityRemarkById(remark);
        if (res==1){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
//            ？？？要返回remark让前台显示修改时间 修改人等
            returnObject.setRetData(remark);
        }else {
            returnObject.setMessage(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
        }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setMessage(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
        }
        return returnObject;
    }
}
