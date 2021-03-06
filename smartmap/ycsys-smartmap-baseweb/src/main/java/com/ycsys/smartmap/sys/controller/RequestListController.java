package com.ycsys.smartmap.sys.controller;

import com.ycsys.smartmap.monitor.entity.ServiceRequest;
import com.ycsys.smartmap.monitor.service.ServiceRequestService;
import com.ycsys.smartmap.sys.common.result.Grid;
import com.ycsys.smartmap.sys.entity.PageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

/**
 * Created by lixiaoxin on 2016/12/23.
 */
@RequestMapping("/requestList")
@Controller
public class RequestListController {

    @Resource
    private ServiceRequestService serviceRequestService;

    @RequestMapping("/list")
    public String list(){
        return "/requestList/list";
    }

    @RequestMapping("/listData")
    @ResponseBody
    public Grid<ServiceRequest> listData(PageHelper pageHelper){
        Grid<ServiceRequest> g = new Grid<ServiceRequest>();
        long min = 10;//分钟
        g.setRows(serviceRequestService.findCurrentRequestDuringTime(min,pageHelper));
        g.setTotal(serviceRequestService.getCurrentRequestDuringTimeCount(min));
        return g;
    }
}
