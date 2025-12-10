package com.ruoyi.framework.sms;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.aliyun.credentials.models.CredentialModel;

@Service
public class SmsService {

    @Value("${aliyun.sms.accessKeyId}")
    private String accessKeyId;

    @Value("${aliyun.sms.accessKeySecret}")
    private String accessKeySecret;

    @Value("${aliyun.sms.signName}")
    private String signName;

    @Value("${aliyun.sms.templateCode}")
    private String templateCode;

    // TODO: 单例模式优化client创建
    public com.aliyun.dypnsapi20170525.Client createClient() throws Exception {
        // 从 application.yml 中获取参数
        com.aliyun.credentials.models.Config credentialConfig = new com.aliyun.credentials.models.Config();
        credentialConfig.setType("access_key");
        credentialConfig.setAccessKeyId(accessKeyId);
        credentialConfig.setAccessKeySecret(accessKeySecret);

        com.aliyun.credentials.Client credentialClient = new com.aliyun.credentials.Client(credentialConfig);
                
        // CredentialModel credential = credentialClient.getCredential();
        // String accessKeyId = credential.getAccessKeyId();
        // String accessKeySecret = credential.getAccessKeySecret();
        // String securityToken = credential.getSecurityToken();

        com.aliyun.teaopenapi.models.Config config = new com.aliyun.teaopenapi.models.Config();
        config.setCredential(credentialClient);
        config.setEndpoint("dypnsapi.aliyuncs.com");
        return new com.aliyun.dypnsapi20170525.Client(config);
    }

    /**
     * 使用阿里云短信服务发送验证码
     * @param phoneNumber 手机号
     * @param code 验证码
     * @return 是否发送成功
     */
    public boolean sendSms(String phoneNumber, String code) throws Exception {
        com.aliyun.dypnsapi20170525.Client client = this.createClient();
        com.aliyun.dypnsapi20170525.models.SendSmsVerifyCodeRequest sendSmsVerifyCodeRequest = new com.aliyun.dypnsapi20170525.models.SendSmsVerifyCodeRequest()
                .setSignName("速通互联验证码")
                .setTemplateCode("100001")
                .setPhoneNumber(phoneNumber)
                .setTemplateParam("{\"code\":\""+code+"\",\"min\":\"5\"}");
        com.aliyun.teautil.models.RuntimeOptions runtime = new com.aliyun.teautil.models.RuntimeOptions();
        try {
            com.aliyun.dypnsapi20170525.models.SendSmsVerifyCodeResponse resp = client.sendSmsVerifyCodeWithOptions(sendSmsVerifyCodeRequest, runtime);
            com.aliyun.teaconsole.Client.log(com.aliyun.teautil.Common.toJSONString(resp));
            return true;

        } catch (com.aliyun.tea.TeaException error) {
            System.out.println(error.getMessage());
            System.out.println(error.getData().get("Recommend"));
            com.aliyun.teautil.Common.assertAsString(error.message);
            return false;
        } catch (Exception _error) {
            com.aliyun.tea.TeaException error = new com.aliyun.tea.TeaException(_error.getMessage(), _error);
            System.out.println(error.getMessage());
            System.out.println(error.getData().get("Recommend"));
            com.aliyun.teautil.Common.assertAsString(error.message);
            return false;
        }        
    }
}
