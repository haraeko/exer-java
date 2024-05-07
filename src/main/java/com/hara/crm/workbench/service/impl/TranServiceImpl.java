package com.hara.crm.workbench.service.impl;

import com.hara.crm.commons.contants.Contants;
import com.hara.crm.commons.utils.DateUtils;
import com.hara.crm.commons.utils.UUIDUtils;
import com.hara.crm.settings.domain.User;
import com.hara.crm.workbench.domain.Customer;
import com.hara.crm.workbench.domain.FunnelVO;
import com.hara.crm.workbench.domain.Tran;
import com.hara.crm.workbench.domain.TranHistory;
import com.hara.crm.workbench.mapper.CustomerMapper;
import com.hara.crm.workbench.mapper.TranHistoryMapper;
import com.hara.crm.workbench.mapper.TranMapper;
import com.hara.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * ClassName: TranServiceImpl
 * Package: com.hara.crm.workbench.service.impl
 * ProjectName:crm-project
 * Description:
 */
@Service("tranService")
public class TranServiceImpl implements TranService {
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Autowired
    private TranMapper tranMapper;



    //    保存创建的交易，如果客户名为新的，则创建新的客户名称
    @Override
    public void saveCreateTran(Map<String, Object> map) {
//        controller层会封装好map传过来
        User user = (User) map.get(Contants.SESSION_USER);
        Tran tran = new Tran();
        Customer customerQuery = customerMapper.selectCustomerByName((String) map.get("customerName"));
        if (customerQuery==null){
//            新建客户
            Customer customer = new Customer();

            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName((String) map.get("customerName"));
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formateDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }


//        保存交易

        tran.setId(UUIDUtils.getUUID());
        tran.setOwner(user.getId());
        tran.setCustomerId((String) map.get("customerId"));
        tran.setMoney((String) map.get("money"));
        tran.setName((String) map.get("name"));
        tran.setExpectedDate((String) map.get("expectedDate"));
        tran.setStage((String) map.get("stage"));
        tran.setType((String) map.get("type"));
        tran.setSource((String) map.get("source"));
        tran.setActivityId((String) map.get("activityId"));
        tran.setContactsId((String) map.get("contactsId"));
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateUtils.formateDateTime(new Date()));
        tran.setDescription((String) map.get("description"));
        tran.setContactSummary((String) map.get("contactSummary"));
        tran.setNextContactTime((String) map.get("nextContactTime"));
        tranMapper.insertTran(tran);

//        保存创建交易的历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(tran.getCreateTime());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setTranId(tran.getId());
        tranHistoryMapper.insertTranHistory(tranHistory);

    }

    @Override
    public Tran queryTranForDetailById(String id) {
        return tranMapper.selectTranById(id);
    }

    @Override
    public List<FunnelVO> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }
}
