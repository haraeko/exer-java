package com.hara.crm.workbench.service.impl;

import com.hara.crm.workbench.domain.TranHistory;
import com.hara.crm.workbench.mapper.TranHistoryMapper;
import com.hara.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: TranHistoryServiceImpl
 * Package: com.hara.crm.workbench.service.impl
 * ProjectName:crm-project
 * Description:
 */
@Service("tranHistory")
public class TranHistoryServiceImpl implements TranHistoryService {

    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Override
    public List<TranHistory> queryTranHistoryByTranId(String tranId) {
        return tranHistoryMapper.selectTranHistoryByTranId(tranId);
    }
}
