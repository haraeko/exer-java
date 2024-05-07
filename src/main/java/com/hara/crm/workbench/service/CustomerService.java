package com.hara.crm.workbench.service;

import com.hara.crm.workbench.domain.Customer;

import java.util.List;

/**
 * ClassName: CustomerService
 * Package: com.hara.crm.workbench.service
 * ProjectName:crm-project
 * Description:
 */
public interface CustomerService {
    List<String> queryAllCustomerNameByName(String name);
}
