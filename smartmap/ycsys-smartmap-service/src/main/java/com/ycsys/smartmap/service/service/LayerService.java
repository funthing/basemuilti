package com.ycsys.smartmap.service.service;

import java.util.List;

import com.ycsys.smartmap.service.entity.Layer;
import com.ycsys.smartmap.sys.service.BaseService;
/**
 * 图层管理 接口
 * @author lzx
 * @date   2016年12月1日
 */
public interface LayerService extends BaseService<Layer, Integer> {
	public Long count(String hql, List<Object> param);
}
