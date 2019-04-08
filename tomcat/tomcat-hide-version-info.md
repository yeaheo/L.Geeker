## Tomcat 隐藏版本信息

- 首先切换到tomcat的lib目录下
  
  ```bash
  cd /usr/local/project/tomcat-msa/lib/
  ```
- 找到 `catalina.jar` 这个 jar 包，解压
  
  ```bash
  unzip catalina.jar
  ```
- 解压后会出现 META-INF、 org 两个文件夹
  
  ```bash
  [root@ctg-msa-test1 lib]# ls
  annotations-api.jar       ecj-4.5.1.jar   META-INF           tomcat-i18n-es.jar  tomcat-util-scan.jar
  catalina-ant.jar          el-api.jar      org                tomcat-i18n-fr.jar  tomcat-websocket.jar
  catalina-ha.jar           jasper-el.jar   servlet-api.jar    tomcat-i18n-ja.jar  websocket-api.jar
  catalina.jar              jasper.jar      tomcat-api.jar     tomcat-jdbc.jar
  catalina-storeconfig.jar  jaspic-api.jar  tomcat-coyote.jar  tomcat-jni.jar
  catalina-tribes.jar       jsp-api.jar     tomcat-dbcp.jar    tomcat-util.jar
  ```

- 修改相关文件
  
  ```bash
  cd org/apache/catalina/util/


  [root@ctg-msa-test1 util]# ls
  CharsetMapper.class              Introspection.class       ServerInfo.class
  CharsetMapperDefault.properties  IOTools.class             ServerInfo.properties
  ConcurrentDateFormat.class       LifecycleBase.class       SessionConfig.class
  ContextName.class                LifecycleMBeanBase.class  SessionIdGeneratorBase.class
  CustomObjectInputStream.class    LocalStrings.properties   StandardSessionIdGenerator.class
  DOMWriter.class                  ManifestResource.class    Strftime.class
  Extension.class                  MIME2Java.class           TomcatCSS.class
  ExtensionValidator.class         ParameterMap.class        URLEncoder.class
  Introspection$1.class            RequestUtil.class         XMLWriter.class
  Introspection$2.class            ResourceSet.class
  ```
- 修改 `ServerInfo.properties`文件
  
  ```bash
  vim ServerInfo.properties
  ```
- 修改3个地方即可
  
  ```bash
  server.info=Apache Tomcat
  server.number=0.0.0.0
  server.built=Nov 7 2016 20:05:27 UTC
  ```
- 修改完成后需要重新压缩,切换到 `lib` 目录下
  
  ```bash
  jar uvf catalina.jar org/apache/catalina/util/ServerInfo.properties
  ```
- 删掉解压的那两个文件夹即可
- tomcat 隐藏版本号到此就完成啦！
