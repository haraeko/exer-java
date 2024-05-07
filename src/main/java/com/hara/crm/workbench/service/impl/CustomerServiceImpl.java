package com.hara.crm.workbench.service.impl;

import com.hara.crm.workbench.mapper.CustomerMapper;
import com.hara.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: CustomerServiceImpl
 * Package: com.hara.crm.workbench.service.impl
 * ProjectName:crm-project
 * Description:
 */
@Service("customerService")
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<String> queryAllCustomerNameByName(String name) {
        return customerMapper.selectAllCustomerNameByName(name);
    }
}
