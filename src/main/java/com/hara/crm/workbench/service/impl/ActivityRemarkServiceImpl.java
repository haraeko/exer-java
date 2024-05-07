package com.hara.crm.workbench.service.impl;

import com.hara.crm.workbench.domain.ActivitiesRemark;
import com.hara.crm.workbench.domain.Activity;
import com.hara.crm.workbench.mapper.ActivitiesRemarkMapper;
import com.hara.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: ActivityRemarkServiceImpl
 * Package: com.hara.crm.workbench.service.impl
 * ProjectName:crm-project
 * Description:
 */
@Service("activityRemarkService")
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    private ActivitiesRemarkMapper activitiesRemarkMapper;


    @Override
    public List<ActivitiesRemark> queryActivityRemarkForDetailByActivity(String activityId) {
        return activitiesRemarkMapper.selectActivityRemarksForDetailByActivityId(activityId);
    }

    @Override
    public int saveCreateActivityRemark(ActivitiesRemark remark) {
        return activitiesRemarkMapper.insertActivityRemark(remark);
    }

    @Override
    public int clearRemarkById(String id) {
       return activitiesRemarkMapper.deleteRemarkById(id);
    }

    @Override
    public int editActivityRemarkById(ActivitiesRemark activitiesRemark) {
        return activitiesRemarkMapper.updateActivityRemarkById(activitiesRemark);
    }

//    @Override
//    public ActivitiesRemark queryActivityRemarkById(String id) {
//        return activitiesRemarkMapper.selectActivityRemarkById(id);
//    }

}
