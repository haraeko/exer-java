package com.hara.crm.workbench.service;

import com.hara.crm.workbench.domain.FunnelVO;
import com.hara.crm.workbench.domain.Tran;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName: TranService
 * Package: com.hara.crm.workbench.service
 * ProjectName:crm-project
 * Description:
 */

public interface TranService {
//    保存创建的交易，如果客户名为新的，则创建新的客户名称
    void saveCreateTran(Map<String,Object> map);

Tran queryTranForDetailById(String id);

List<FunnelVO> queryCountOfTranGroupByStage();
}
