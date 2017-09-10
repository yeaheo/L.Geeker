# Tomcat-连接数设置
- 在tomcat配置文件server.xml中的<Connector ... />配置中，和连接数相关的参数有:
  - `minProcessors`     最小空闲连接线程数，用于提高系统处理性能，默认值为10
  - `maxProcessors`     最大连接线程数，即：并发处理的最大请求数，默认值为75
  - `maxThreads`        最大并发线程数，即同时处理的任务个数，默认值是200
  - `acceptCount`       允许的最大连接数，应大于等于maxProcessors，默认值为100
  - `enableLookups`     是否反查域名，取值为：true或false。为了提高处理能力，应设置为false
  - `connectionTimeout` 网络连接超时,单位:毫秒.设置为0表示永不超时,这样设置有隐患的,通常可设置为30000毫秒
- 其中和最大连接数相关的参数为maxProcessors和acceptCount。如果要加大并发连接数，应同时加大这两个参数
- 下面是一个连接数设置模板
  - ``` xml
    <Connector port="8066" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" 
               maxThreads="200"
               minSpareThreads="25"
               maxSpareThreads="75"
               acceptCount="100"
               maxIdleTime="30000"
               enableLookups="false"
               compression="500"
               URIEncoding="utf-8"
               compressableMimeType="text/html,text/xml,text/javascript,text/css,text/plain,application/octet-stream"
               />
     ```
 - 可以根据具体需求修改对应参数
 
     
