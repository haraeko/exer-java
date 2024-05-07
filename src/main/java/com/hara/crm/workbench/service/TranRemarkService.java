package com.hara.crm.workbench.service;

import com.hara.crm.workbench.domain.TranRemark;

import java.util.List;

/**
 * ClassName: TranRemark
 * Package: com.hara.crm.workbench.service
 * ProjectName:crm-project
 * Description:
 */
public interface TranRemarkService {

    List<TranRemark> queryTranRemarkByTranId(String tranId);
}
