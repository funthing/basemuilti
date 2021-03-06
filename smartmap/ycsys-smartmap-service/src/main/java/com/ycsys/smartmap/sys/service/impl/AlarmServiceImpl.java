package com.ycsys.smartmap.sys.service.impl;

import com.ycsys.smartmap.monitor.entity.Alarm;
import com.ycsys.smartmap.sys.dao.AlarmDao;
import com.ycsys.smartmap.sys.entity.PageHelper;
import com.ycsys.smartmap.sys.service.AlarmService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by Administrator on 2016/12/26.
 */
@Service("alarmService")
public class AlarmServiceImpl implements AlarmService {

    @Resource
    private AlarmDao alarmDao;

    @Override
    public void save(Alarm alarm) {
        alarmDao.save(alarm);
    }

    @Override
    public List<Alarm> findByPage(PageHelper pageHelper) {
        return alarmDao.find("from Alarm order by happenDate desc",pageHelper);
    }

    @Override
    public long countAll() {
        return alarmDao.count("select count(*) from Alarm");
    }

	@Override
	public long count(String hql, Object[] param) {
		// TODO Auto-generated method stub
		return alarmDao.count(hql, param);
	}
}
