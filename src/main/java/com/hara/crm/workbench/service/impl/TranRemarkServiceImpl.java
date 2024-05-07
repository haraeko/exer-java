package com.hara.crm.workbench.service.impl;

import com.hara.crm.workbench.domain.TranRemark;
import com.hara.crm.workbench.mapper.TranRemarkMapper;
import com.hara.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: TranRemarkImpl
 * Package: com.hara.crm.workbench.service.impl
 * ProjectName:crm-project
 * Description:
 */
@Service("tranRemark")
public class TranRemarkServiceImpl implements TranRemarkService {
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Override
    public List<TranRemark> queryTranRemarkByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkByTranId(tranId);
    }
}
