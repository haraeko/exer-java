package com.hara.crm.workbench.service;

import com.hara.crm.workbench.domain.Activity;
import com.hara.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * ClassName: ClueRemarkService
 * Package: com.hara.crm.workbench.service
 * ProjectName:crm-project
 * Description:
 */
public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

}
