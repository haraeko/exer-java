package com.hara.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.annotation.JsonAppend;
import com.hara.crm.commons.contants.Contants;
import com.hara.crm.commons.domain.ReturnObject;
import com.hara.crm.settings.domain.DicValue;
import com.hara.crm.settings.domain.User;
import com.hara.crm.settings.service.DicValueService;
import com.hara.crm.settings.service.UserService;
import com.hara.crm.workbench.domain.Tran;
import com.hara.crm.workbench.domain.TranHistory;
import com.hara.crm.workbench.domain.TranRemark;
import com.hara.crm.workbench.mapper.TranHistoryMapper;
import com.hara.crm.workbench.mapper.TranMapper;
import com.hara.crm.workbench.mapper.TranRemarkMapper;
import com.hara.crm.workbench.service.CustomerService;
import com.hara.crm.workbench.service.TranHistoryService;
import com.hara.crm.workbench.service.TranRemarkService;
import com.hara.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * ClassName: TranController
 * Package: com.hara.crm.workbench.web.controller
 * ProjectName:crm-project
 * Description:
 */
@Controller
public class TranController {
    @Autowired
    public TranService tranService;
    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;

    @Autowired
    private TranRemarkService tranRemarkService;

    @Autowired
    private TranHistoryService tranHistoryService;
//跳转页面
    @RequestMapping("/workbench/transaction/index.do")
    public String index(HttpServletRequest request){
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("stageList",stageList);
        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/toSave.do")
    public String toSave(HttpServletRequest request) {
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<User> userList = userService.queryAllUsers();

        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("userList",userList);

        return "workbench/transaction/save";
    }

//    解析properties文件

    @RequestMapping("/workbench/transaction/getPossibility.do")
    @ResponseBody
    public Object getPossibility(String stageValue) {

//        解析propertities文件    两个类  Properties  ResourceBundle
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);

        return possibility;
    }

    @RequestMapping("/workbench/transaction/queryAllCustomerName.do")
    @ResponseBody
    public Object queryAllCustomerName(String name){
        return  customerService.queryAllCustomerNameByName(name);
    }

    //    保存交易
    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    @ResponseBody
    //@RequestParam   把前台提交的参数自动封装为map
    public Object saveCreateTran(@RequestParam Map<String,Object> map, HttpSession session){
    //    封装参数，传递给后台
        map.put(Contants.SESSION_USER,session.getAttribute(Contants.SESSION_USER));
        ReturnObject returnObject = new ReturnObject();
        try {
            tranService.saveCreateTran(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage(Contants.RETURN_OBJECT_CODE_MSG);
        }return returnObject;
    }


//    点击某条交易，查询交易详情
    @RequestMapping("/workbench/transaction/queryTranForDetail.do")
    public String queryTranForDetail(String id,HttpServletRequest request){

        Tran tran = tranService.queryTranForDetailById(id);
        List<TranRemark> tranRemarkList = tranRemarkService.queryTranRemarkByTranId(id);
        List<TranHistory> tranHistoryList = tranHistoryService.queryTranHistoryByTranId(id);
//查询可能性
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(tran.getStage());

        tran.setPossibility(possibility);
        request.setAttribute("tran",tran);
        request.setAttribute("tranRemarkList",tranRemarkList);
        request.setAttribute("tranHistoryList",tranHistoryList);
//        request 放太多数据不合适  不如往tran里添加一个属性
//        request.setAttribute("possibility",possibility);


//        查询交易的所有阶段
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("stageList",stageList);
        return "workbench/transaction/detail";
    }
}
