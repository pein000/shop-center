package com.pein.member.dao.mapper;

import com.pein.member.dao.domain.MemberInfoDo;
import com.pein.member.dao.domain.MemberInfoDoExample;
import java.util.List;

public interface MemberInfoDoMapper {
    int countByExample(MemberInfoDoExample example);

    int insert(MemberInfoDo record);

    int insertSelective(MemberInfoDo record);

    List<MemberInfoDo> selectByExample(MemberInfoDoExample example);

    MemberInfoDo selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(MemberInfoDo record);

    int updateByPrimaryKey(MemberInfoDo record);
}