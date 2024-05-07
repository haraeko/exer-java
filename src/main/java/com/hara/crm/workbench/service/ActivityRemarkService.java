package com.hara.crm.workbench.service;

import com.hara.crm.workbench.domain.ActivitiesRemark;
import com.hara.crm.workbench.domain.Activity;

import java.util.List;

/**
 * ClassName: ActivityRemarkService
 * Package: com.hara.crm.workbench.service
 * ProjectName:crm-project
 * Description:
 */
public interface ActivityRemarkService {
    List<ActivitiesRemark> queryActivityRemarkForDetailByActivity(String activityId);

    int saveCreateActivityRemark(ActivitiesRemark remark);

    int clearRemarkById(String id);

    int editActivityRemarkById(ActivitiesRemark activitiesRemark);

//    ActivitiesRemark queryActivityRemarkById(String id);


}
