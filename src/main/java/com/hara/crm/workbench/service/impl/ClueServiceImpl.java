package com.hara.crm.workbench.service.impl;

import com.hara.crm.commons.contants.Contants;
import com.hara.crm.commons.utils.DateUtils;
import com.hara.crm.commons.utils.UUIDUtils;
import com.hara.crm.settings.domain.User;
import com.hara.crm.workbench.domain.*;
import com.hara.crm.workbench.mapper.*;
import com.hara.crm.workbench.service.ClueService;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.crypto.Data;
import java.util.*;

/**
 * ClassName: ClueServiceImpl
 * Package: com.hara.crm.workbench.service.impl
 * ProjectName:crm-project
 * Description:
 */
@Service("clueService")
public class ClueServiceImpl implements ClueService {
@Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    private TranMapper tranMapper;

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }

//执行多个sql语句，无法判读具体的影响条数，索性就不判断了
    @Override
    public void saveCustomer(Map<String, Object> map) {
//        根据clueid 查询线索信息
        String clueId = (String) map.get("clueId");
        Clue clue = clueMapper.selectClueById(clueId);
//          session不传递给service层   需要controller层传过来参数
//        User user = (User) session.getAttribute(Contants.SESSION_USER);

//把该线索的信息转换到客户表中
        User user = (User) map.get(Contants.SESSION_USER);
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        customerMapper.insertCustomer(customer);

//        把该线索的信息转换到联系人表中
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formateDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        contactsMapper.insertContact(contacts);
//        查询该线索下的所有备注
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);
//        为什么非空要有两个判断条件？？  也就是说，不为空的时候，size为0，要排除这种
        List<CustomerRemark> customerRemarkList = new ArrayList<>();
        List<ContactsRemark> contactsRemarkList = new ArrayList<>();
//把线索转换到联系人备注表和客户备注表
        if (clueRemarkList != null&&clueRemarkList.size()>0){
            CustomerRemark customerRemark =null;
            ContactsRemark contactsRemark=null;

            for (ClueRemark cr:clueRemarkList){
                customerRemark = new CustomerRemark();
                contactsRemark = new ContactsRemark();
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setNoteContent(cr.getNoteContent());
                customerRemark.setCreateBy(cr.getCreateBy());
                customerRemark.setCreateTime(cr.getCreateTime());
                customerRemark.setEditBy(cr.getEditBy());
                customerRemark.setEditTime(cr.getEditTime());
                customerRemark.setEditFlag(cr.getEditFlag());
                customerRemark.setCustomerId(cr.getNoteContent());
                customerRemarkList.add(customerRemark);

                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setNoteContent(cr.getNoteContent());
                contactsRemark.setCreateBy(cr.getCreateBy());
                contactsRemark.setCreateTime(cr.getCreateTime());
                contactsRemark.setEditBy(cr.getEditBy());
                contactsRemark.setEditTime(cr.getEditTime());
                contactsRemark.setEditFlag(cr.getEditFlag());
                contactsRemark.setContactsId(customerRemark.getId());
                contactsRemarkList.add(contactsRemark);


            }
            customerRemarkMapper.insertCustomerRemark(customerRemarkList);
            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarkList);
        }
//        根据clueId查询关联关系
        List<ClueActivityRelation> clueActivityrelationList = clueActivityRelationMapper.selectClueActivityByClueId(clueId);
        ContactsActivityRelation contactsActivityRelation = null;
        ArrayList<ContactsActivityRelation> contactsActivityRelationsList = new ArrayList<>();
        if (clueActivityrelationList !=null && clueActivityrelationList.size()>0){
            for (ClueActivityRelation car:clueActivityrelationList) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setActivityId(car.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelationsList.add(contactsActivityRelation);
            }contactsActivityRelationMapper.insertContactActivityRelationByList(contactsActivityRelationsList);
        }
//        如果创建交易，则添加交易
//        Boolean isCreateTran = (Boolean)map.get("isCreateTran");
//        前台传过来的是字符串，用字符串比较即可   用equals比较
        String isCreateTran = (String) map.get("isCreateTran");


//        clueId: clueId,
//                money: money,
//                name: name,
//                expectedDate: expectedDate,
//                activityId: activityId,
//                stage: stage,
//                isCreateTran: isCreateTran
        if ("true".equals(isCreateTran) ){
            Tran tran = new Tran();
            tran.setId(UUIDUtils.getUUID());
            tran.setOwner(user.getId());
            tran.setMoney((String) map.get("money"));
            tran.setExpectedDate((String) map.get("expectedDate"));
            tran.setCustomerId(customer.getId());
            tran.setStage((String) map.get("stage"));
           tran.setSource(clue.getSource());
           tran.setActivityId((String) map.get("activityId"));
           tran.setContactsId(contacts.getId());
           tran.setCreateBy(user.getId());
           tran.setCreateTime(DateUtils.formateDateTime(new Date()));
           tran.setDescription(clue.getDescription());
           tran.setContactSummary(clue.getContactSummary());
           tran.setNextContactTime(clue.getNextContactTime());
           tranMapper.insertTran(tran);
//把线索的备注添加到交易备注
            if (clueRemarkList != null&&clueRemarkList.size()>0){
                ArrayList<TranRemark> tranRemarkList = new ArrayList<>();
                TranRemark  tranRemark=null;
                for (ClueRemark cr:clueRemarkList){
                    tranRemark = new TranRemark();
                    tranRemark.setId(UUIDUtils.getUUID());
                    tranRemark.setNoteContent(cr.getNoteContent());
                    tranRemark.setCreateBy(user.getId());
                    tranRemark.setCreateTime(cr.getCreateTime());
                    tranRemark.setEditBy(cr.getEditBy());
                    tranRemark.setEditTime(cr.getEditTime());
                    tranRemark.setEditFlag(cr.getEditFlag());
                    tranRemark.setTranId(tran.getId());
                    tranRemarkList.add(tranRemark);
                }
                tranRemarkMapper.insertTranRemarkByList(tranRemarkList);
            }
//            删除线索的备注
            clueRemarkMapper.deleteClueRemarkByClueId(clueId);
//            删除线索和市场活动的关联关系
            clueActivityRelationMapper.deleteRelationByClueId(clueId);
//	    删除线索
            clueMapper.deleteClueById(clueId);
        }

    }
}
