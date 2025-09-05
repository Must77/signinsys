/* 

import org.springframework.stereotype.Service;

@Service
public class SysCourseSigninRecordServiceImpl implements ISysCourseSigninRecordService {

    @Autowired
    private SysCourseSigninRecordMapper recordMapper;

    @Override
    public List<SysCourseSigninRecord> selectByUserId(Long userId) {
        return recordMapper.selectByUserId(userId);
    }

    @Override
    public int doSignin(Long recordId, Long userId) {
        SysCourseSigninRecord record = new SysCourseSigninRecord();
        record.setId(recordId);
        record.setUserId(userId);
        record.setStatus("1");
        record.setSigninTime(new Date());
        return recordMapper.updateSigninStatus(record);
    }

    @Override
    public int batchInsert(List<SysCourseSigninRecord> records) {
        return recordMapper.batchInsert(records);
    }
}

*/
