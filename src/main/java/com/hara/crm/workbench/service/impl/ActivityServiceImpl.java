package com.hara.crm.workbench.service.impl;

import com.hara.crm.workbench.domain.Activity;
import com.hara.crm.workbench.mapper.ActivityMapper;
import com.hara.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String,Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String,Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteActivityByIds(String[] ids) {
        return activityMapper.deleteActivityByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
         return activityMapper.selectActivityById(id);
    }
//保存要修改的活动
    @Override
     public int saveEditActivityById(Activity activity) {
        int result = activityMapper.updateActivityById(activity);
        return result;
    }

    @Override
    public List<Activity> queryAllActivityByCheck() {
        return activityMapper.selectAllActivityByCheck();
    }

    @Override
    public int addActivityByUpload(List<Activity> activityList) {
       return activityMapper.insertActivityByList(activityList);
    }

    @Override
    public Activity queryActivityForDetailById(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    @Override
    public List<Activity> queryActivityForClueByClueId(String clueId) {
        return  activityMapper.selectActivityForClueByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityForClueByNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForClueByNameClueId(map);
    }

    @Override
    public List<Activity> queryActivityForClueByIds(String[] ids) {
        return activityMapper.selectActivityForClueByIds(ids);
    }

    @Override
    public List<Activity> queryActivityForConvertByNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForConvertByNameClueId(map);
    }
}
