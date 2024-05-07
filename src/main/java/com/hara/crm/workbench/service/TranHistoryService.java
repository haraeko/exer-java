package com.hara.crm.workbench.service;

import com.hara.crm.workbench.domain.TranHistory;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: TranHistoryService
 * Package: com.hara.crm.workbench.service
 * ProjectName:crm-project
 * Description:
 */
public interface TranHistoryService {

    List<TranHistory> queryTranHistoryByTranId(String tranId);
}
