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

<#assign externalKeyParam = "&amp;externalLoginKey=" + requestAttributes.externalLoginKey!>

<#if (requestAttributes.person)??><#assign person = requestAttributes.person></#if>
<#if (requestAttributes.partyGroup)??><#assign partyGroup = requestAttributes.partyGroup></#if>
<#assign docLangAttr = locale.toString()?replace("_", "-")>
<#assign langDir = "ltr">
<#if "ar.iw"?contains(docLangAttr?substring(0, 2))>
    <#assign langDir = "rtl">
</#if>

<!-- ghislainkouete: Initializing (global) variables
which are relevant for the header
as well as many other pages content throughout the web frontend
-->
<#-- Reading the user informations. Note: Copied from AppbarClose.ftl since part of that code were moved here. See description below -->
<#assign appModelMenu = Static["org.apache.ofbiz.widget.model.MenuFactory"].getMenuFromLocation(applicationMenuLocation,applicationMenuName,visualTheme)>
<#if person?has_content>
  <#assign userName = (person.firstName!) + " " + (person.middleName!) + " " + person.lastName!>
<#elseif partyGroup?has_content>
  <#assign userName = partyGroup.groupName!>
<#elseif userLogin??>
  <#assign userName = userLogin.userLoginId>
<#else>
  <#assign userName = "">
</#if>
<#if defaultOrganizationPartyGroupName?has_content>
  <#assign orgName = " - " + defaultOrganizationPartyGroupName!>
<#else>
  <#assign orgName = "">
</#if>
<!-- Logo Link URL is associated with the logo image and redirects to the current link when clicked -->
<#if layoutSettings.headerImageLinkUrl??>
  <#assign logoLinkURL = "${layoutSettings.headerImageLinkUrl}">
<#else>
  <#assign logoLinkURL = "${layoutSettings.commonHeaderImageLinkUrl}">
</#if>
<#assign organizationLogoLinkURL = "${layoutSettings.organizationLogoLinkUrl!}">
<!-- Initializing the header image -->
<#if layoutSettings.headerImageUrl??>
  <#assign headerImageUrl = layoutSettings.headerImageUrl>
<#elseif layoutSettings.commonHeaderImageUrl??>
  <#assign headerImageUrl = layoutSettings.commonHeaderImageUrl>
<#elseif layoutSettings.VT_HDR_IMAGE_URL??>
  <#assign headerImageUrl = layoutSettings.VT_HDR_IMAGE_URL>
</#if>
<!-- Shortcut icon -->
<#if layoutSettings.shortcutIcon?has_content>
  <#assign shortcutIcon = layoutSettings.shortcutIcon/>
<#elseif layoutSettings.VT_SHORTCUT_ICON?has_content>
  <#assign shortcutIcon = layoutSettings.VT_SHORTCUT_ICON/>
</#if>
<!-- Cross Site Request Forgery Defense Strategy -->
<#assign csrfDefenseStrategy = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("security", "csrf.defense.strategy", "org.apache.ofbiz.security.NoCsrfDefenseStrategy", delegator)>

<!-- ghislainkouete: embedding header specific markups in the web front end layout
Note: closing </html> and </body> tags are located in the footer ftl
-->
<html lang="${docLangAttr}" dir="${langDir}" xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <#if csrfDefenseStrategy != "org.apache.ofbiz.security.NoCsrfDefenseStrategy">
      <meta name="csrf-token" content="<@csrfTokenAjax/>"/>
    </#if>
    <title>${layoutSettings.companyName}: <#if (titleProperty)?has_content>${uiLabelMap[titleProperty]}<#else>${title!}</#if></title>
    <#if shortcutIcon?has_content>
      <link rel="shortcut icon" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+".ico"}</@ofbizContentUrl>" type="image/x-icon">
      <link rel="icon" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+".png"}</@ofbizContentUrl>" type="image/png">
      <link rel="icon" sizes="32x32" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+"-32.png"}</@ofbizContentUrl>" type="image/png">
      <link rel="icon" sizes="64x64" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+"-64.png"}</@ofbizContentUrl>" type="image/png">
      <link rel="icon" sizes="96x96" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+"-96.png"}</@ofbizContentUrl>" type="image/png">
    </#if>
    <#if layoutSettings.VT_HDR_JAVASCRIPT?has_content>
      <#list layoutSettings.VT_HDR_JAVASCRIPT as javaScript>
          <script src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>" type="application/javascript"></script>
      </#list>
    </#if>
    <#if layoutSettings.javaScripts?has_content>
      <#--layoutSettings.javaScripts is a list of java scripts. -->
      <#-- use a Set to make sure each javascript is declared only once, but iterate the list to maintain the correct order -->
      <#assign javaScriptsSet = Static["org.apache.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.javaScripts)/>
      <#list layoutSettings.javaScripts as javaScript>
        <#if javaScriptsSet.contains(javaScript)>
          <#assign nothing = javaScriptsSet.remove(javaScript)/>
          <script src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>" type="application/javascript"></script>
        </#if>
      </#list>
    </#if>
    <#--layoutSettings.styleSheets is a list of style sheets. So, you can have a user-specified "main" style sheet, AND a component style sheet.-->
    <#if layoutSettings.styleSheets?has_content>
      <#list layoutSettings.styleSheets as styleSheet>
          <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
      </#list>
    </#if>
    <#if layoutSettings.VT_STYLESHEET?has_content>
      <!-- FIXME - Dirty hack. Didn't find a way to include icons in the Theme.xml -->
        <#list layoutSettings.VT_STYLESHEET as styleSheet>
          <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.rtlStyleSheets?has_content && "rtl" == langDir>
      <#--layoutSettings.rtlStyleSheets is a list of rtl style sheets.-->
      <#list layoutSettings.rtlStyleSheets as styleSheet>
          <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
      </#list>
    </#if>
    <#if layoutSettings.VT_RTL_STYLESHEET?has_content && "rtl" == langDir>
        <#list layoutSettings.VT_RTL_STYLESHEET as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.VT_EXTRA_HEAD?has_content>
      <#list layoutSettings.VT_EXTRA_HEAD as extraHead>
        ${extraHead}
      </#list>
    </#if>
    <#if layoutSettings.WEB_ANALYTICS?has_content>
      <script type="application/javascript">
        <#list layoutSettings.WEB_ANALYTICS as webAnalyticsConfig>
          ${StringUtil.wrapString(webAnalyticsConfig.webAnalyticsCode!)}
        </#list>
      </script>
    </#if>
  </head>
  <body>
    <#include "component://common-theme/template/ImpersonateBanner.ftl"/>
    <div id="wait-spinner" class="hidden">
      <div id="wait-spinner-image"></div>
    </div>
    <div class="page-container">
      <div class="hidden">
        <a href="#column-container" title="${uiLabelMap.CommonSkipNavigation}" accesskey="2">
          ${uiLabelMap.CommonSkipNavigation}
        </a>
      </div>
      <header class="header">
        <#-- 
          ghislainkouete: By using the organizationLogoLinkURL that was set above after the ending </head> tag
          instead of headerImageUrl, the header keep displaying logo image from common/images, instead of /mandara/images 
          Therefore, proceeding by using the headerImageUrl directly in the code instead of organizationLogoLinkURL
        -->
        <div class="header__top-bar--left">
          <#if headerImageUrl??>
            <a href="<@ofbizUrl>${logoLinkURL}</@ofbizUrl>"><img alt="${layoutSettings.companyName}" src="<@ofbizContentUrl>${StringUtil.wrapString(headerImageUrl)}</@ofbizContentUrl>"></a>
          <#else>
            <a href="<@ofbizUrl>${logoLinkURL}</@ofbizUrl>" title="${layoutSettings.companyName!}"></a>
          </#if>
          <h4>
            <span class="u-color-primary">KAP</span><span class="u-color-secondary">SI</span><span class="u-color-warning">K</span><span class="u-color-success-dark">I</span>
            <span class="u-color-gray-dark">Digital Solutions</span>
          </h4>
        </div>

        <!-- FIXME: ghislainkouete: I guess messages should be in the middle of the header, sort of top bar middle?-->
        <!-- <div class="header__top-bar--middle"> -->
        <#if layoutSettings.middleTopMessage1?has_content && layoutSettings.middleTopMessage1 != " ">
          <li class="last-system-msg">
              <a href="${StringUtil.wrapString(layoutSettings.middleTopLink1!)}">${layoutSettings.middleTopMessage1!}</a><br/>
              <a href="${StringUtil.wrapString(layoutSettings.middleTopLink2!)}">${layoutSettings.middleTopMessage2!}</a><br/>
              <a href="${StringUtil.wrapString(layoutSettings.middleTopLink3!)}">${layoutSettings.middleTopMessage3!}</a>
          </li>
        </#if>
        <!--</div>-->
        
        <#--
          ghislainkouete: taken out the following code from AppBarClose.ftl and moved it here to make it the header's top bar left area 
          thus having a consistent header file encompassing logo and application agnostic menu / navigation area
          Note: this is part of the AppBarClose.ftl file that was referred former as copied from AppBarClose.ftl
        -->
        <div class="header__top-bar--right">
          <ul>
            <#if userLogin??>
              <li><a class="help-link alert" href="${userDocUri!Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general", "userDocUri", delegator)}<#if helpAnchor??>#${helpAnchor}</#if>" target="help" title="${uiLabelMap.CommonHelp}"></a></li>
              <li><a href="<@ofbizUrl>logout</@ofbizUrl>">${uiLabelMap.CommonLogout}</a></li>
              <li><a href="<@ofbizUrl>ListVisualThemes</@ofbizUrl>">${uiLabelMap.CommonVisualThemes}</a></li>
            <#else>
              <li><a href="<@ofbizUrl>${checkLoginUrl}</@ofbizUrl>">${uiLabelMap.CommonLogin}</a></li>
            </#if>
            <li <#if companyListSize?default(0) &lt;= 1></#if>><a href="<@ofbizUrl>ListLocales</@ofbizUrl>">${uiLabelMap.CommonLanguageTitle}</a></li>
            <#if userLogin?exists>
              <#if userLogin.partyId?exists>
                <li><a href="<@ofbizUrl controlPath="/partymgr/control">viewprofile?partyId=${userLogin.partyId}</@ofbizUrl>">${userName}</a>&nbsp;&nbsp;&nbsp;&nbsp;</li>
                <#assign size = companyListSize?default(0)>
                <#if size &gt; 1>
                    <#assign currentCompany = delegator.findOne("PartyNameView", {"partyId" : organizationPartyId}, false)>
                    <#if currentCompany?exists>
                        <li>
                            <a href="<@ofbizUrl>ListSetCompanies</@ofbizUrl>">${currentCompany.groupName} &nbsp;- </a>
                        </li>
                    </#if>
                </#if>
              <#else>
                <li>${userName}</li>
              </#if>
            </#if>
          </ul>
        </div>
      </header>
