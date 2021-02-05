<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->



<#if requestAttributes.uiLabelMap??><#assign uiLabelMap = requestAttributes.uiLabelMap></#if>
<#assign useMultitenant = Static["org.apache.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "multitenant")>

<#assign username = requestParameters.USERNAME?default((sessionAttributes.autoUserLogin.userLoginId)?default(""))>
<#if username != "">
  <#assign focusName = false>
<#else>
  <#assign focusName = true>
</#if>
<div class="login__hero">
  <div class="login-form">
    <div class="login-form__header u-margin-bottom-tiny">
      <img alt="${layoutSettings.companyName}" src="<@ofbizContentUrl>${StringUtil.wrapString(layoutSettings.VT_HDR_IMAGE_URL)}</@ofbizContentUrl>">
      <h3 class="heading-tertiary">${uiLabelMap.CommonRegistered}</h3>
    </div>
    <div class="login-form__container">
      <form method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform">
        <div class="login-form__group">
          <!--Inverting the natural order of the input group
           for enabling the input to select the label as the next sibling in the style
           so that the label can be displayed while the user inputs values-->
          <i class="login-form__icon fas fa-user"></i>
          <input type="text" name="USERNAME" id="USERNAME" value="${username}" class="login-form__input u-color-gray login-form__input--iconized" placeholder="User Name" required>
          <label for="USERNAME" class="login-form__label login-form__label--user u-color-gray">${uiLabelMap.CommonUsername}</label>
        </div>
        <div class="login-form__group">
        <i class="login-form__icon fas fa-lock"></i>
          <input type="password" name="PASSWORD" id="PASSWORD" autocomplete="off" value="" class="login-form__input u-color-gray" placeholder="Password" required/>
          <label for="PASSWORD" class="login-form__label u-color-gray">${uiLabelMap.CommonPassword}</label>
        </div>
        <#if ("Y" == useMultitenant) >
          <#if !requestAttributes.userTenantId??>
            <div class="login-form__group">
              <input type="text" name="userTenantId" value="${parameters.userTenantId!}" class="login-form__input u-color-gray"/><!-- placeholder="Tenant Id" required/>-->
              <label>${uiLabelMap.CommonTenantId}</label>
            </div>
          <#else>
              <input type="hidden" name="userTenantId" value="${requestAttributes.userTenantId!}"/>
          </#if>
        </#if>
        <div>
          <input type="submit" class="login-form__btn-login btn" value="${uiLabelMap.CommonLogin}"/>
        </div>
        <input type="hidden" name="JavaScriptEnabled" value="N"/>
        <a class="login-form__recover-pw" href="<@ofbizUrl>forgotPassword</@ofbizUrl>">${uiLabelMap.CommonForgotYourPassword}?</a>
      </form>
    </div>
  </div>
</div>

<script type="application/javascript">
  document.loginform.JavaScriptEnabled.value = "Y";
  <#if focusName>
    document.loginform.USERNAME.focus();
  <#else>
    document.loginform.PASSWORD.focus();
  </#if>
</script>
