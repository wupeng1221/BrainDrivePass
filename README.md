# BrainDrivePass
## 项目概述
该项目是一个基于前后端分离架构，实现了一个简单的驾考科目一答题系统。作为自己一个练手的十分简单的一个小项目。

公网地址 119.23.140.56

目前已经实现的功能有：
- 登录、注册、修改(忘记)密码、退出
- 顺序答题：按照题目顺序作答，会记录作答历史与收藏记录；
- 随机答题：每次都按照随机顺序安排题目，不会记录作答历史与收藏记录；
- 模拟考试：考试仿真，50道题目，会记录未完成考试的信息，供下次选择重新开始新的考试或者加载未完成的答题；
- 错题记录：查看顺序答题中曾经错误的题目，可以移除题目，标记为正确；
- 收藏记录：查看收藏的题目，可以取消对题目的收藏；

或许后续还会继续更新和完善🤔️🤔️🤔️？

## 前端技术栈
| 技术                        | 版本      | 描述                                         |
| :-------------------------- | :-------- | :------------------------------------------- |
| axios                       | ^1.6.7    | 用于发起 HTTP 请求的 Promise based 库         |
| element-ui                  | ^2.15.14  | 基于 Vue.js 的组件库，用于构建用户界面        |
| vue                         | ^2.6.14   | 渐进式 JavaScript 框架，用于构建用户界面      |
| vue-router                  | ^3.5.1    | Vue.js 官方的路由管理器，实现单页面应用导航   |
| vuex                        | ^3.6.2    | Vue.js 官方的状态管理库，用于集中管理应用状态 |
| vuex-persistedstate         | ^4.1.0    | 用于在 Vuex 中实现状态持久化的插件             |
### 前端项目结构
```shell
tree
.
├── README.md
├── babel.config.js
├── jsconfig.json
├── package-lock.json
├── package.json
├── public
│   ├── favicon.ico
│   └── index.html
├── src
│   ├── App.vue
│   ├── assets
│   │   ├── car.png
│   │   ├── loginpic.jpeg
│   │   └── logo.png
│   ├── components
│   │   ├── common
│   │   │   ├── DataHeader.vue
│   │   │   └── SideNav.vue
│   │   └── element
│   │       └── index.js
│   ├── config
│   │   └── axiosConfig.js
│   ├── main.js
│   ├── router
│   │   └── index.js
│   ├── store
│   │   └── index.js
│   ├── utils
│   │   ├── apiHelper.js
│   │   ├── dataHelper.js
│   │   ├── notifyMessageHelper.js
│   │   └── vuexHelper.js
│   ├── validate
│   │   └── emailValidate.js
│   └── views
│       ├── forget_password.vue
│       ├── inner
│       │   ├── exam_stats.vue
│       │   ├── exam_view.vue
│       │   ├── fav_view
│       │   │   ├── fav_empty.vue
│       │   │   ├── fav_layout.vue
│       │   │   └── fav_not_empty.vue
│       │   ├── layout_view.vue
│       │   ├── order_view.vue
│       │   ├── random_view.vue
│       │   └── wrong_view
│       │       ├── wrong_empty.vue
│       │       ├── wrong_layout.vue
│       │       └── wrong_not_empty.vue
│       ├── login_view.vue
│       ├── status
│       │   ├── 400_page.vue
│       │   ├── 401_page.vue
│       │   ├── 404_page.vue
│       │   └── 500_page.vue
│       └── user_registry.vue
└── vue.config.js

17 directories, 42 files
```
### 一些细节
- 前端使用 axios 发送 ajax 请求的操作都在封装在 apiHelper.js 文件中，以下是接口声明
- 
  | 方法          | 接口                               | 描述              |
  |--------------|------------------------------------|-----------------|
  | `GET`        | `/api/user/verificationCode`        | 发送验证码到指定邮箱      |
  | `POST`       | `/api/user/updatePassword`          | 提交带有验证码的更新密码    |
  | `POST`       | `/api/user/registry`                 | 注册新用户           |
  | `POST`       | `api/user/login`                     | 用户登录            |
  | `GET`        | `/api/practice/questionByOrderId`   | 根据指定索引获取问题      |
  | `GET`        | `/api/practice/recAndFav`            | 获取答题记录和收藏记录     |
  | `GET`        | `/api/exam/paper`                    | 获取包含随机问题的模拟考试试卷 |
  | `POST`       | `/api/exam/score`                    | 提交用户的考试分数       |
  | `GET`        | `/api/exam/score`                    | 读取用户的考试分数       |
  | `GET`        | `/api/practice/rightAnswer`          | 获取练习问题的正确答案     |
  | `POST`       | `/api/user/logout`                   | 注销用户            |
  | `POST`       | `/api/practice/recAndFav`            | 提交答题记录和收藏巨鹿     |

- axios 必须设置全局代理，因为 axios 需要把对前端服务的请求转发给后端的网关，而后端登录验证需要 cookie 信息，aixos 跨域默认不会携带 cookie，所以 axios 需要如下的配置：
```java
// axios 配置跨域添加 cookie
axios.defaults.withCredentials = true;
```
- axios 全局代理，开发环境下我设置的端口为 7070，部署时前端服务的端口由 nginx 配置决定
```java
const {defineConfig} = require('@vue/cli-service')
module.exports = defineConfig({
    productionSourceMap: false,
    transpileDependencies: true,
    devServer: {
        //本地 npm run server 时的端口
        port: 7070,
        proxy: {
            // 代理以 '/api' 开头的请求
            '/api': {
                target: 'http://localhost:9000',
                changeOrigin: true,
                // 代理转发请求，不携带 '/api'前缀
                pathRewrite: {
                    '^/api': ''
                }
            }
        }
    }
})
```
### 前端部署
前端使用 nginx 部署，具体步骤如下
1. 确保本地安装了 npm 工具，使用下面的命令安装前端所需的依赖
```shell
npm run install
```
2. 在配置正确的情况下，可以在本地同后端工程依次运行，进行测试；运行前端项目需要运行
```shell
npm run serve
```
3. 打包项目，会在项目的根目录生成 /dist 文件夹，是项目编译生成的静态资源
4. 部署到服务器的 nginx，只需修改 nginx 的配置文件即可，重点修改 server 字段，按要求配置下列三个注释部分即可
```conf
server
    {
        # 设置 nginx 默认监听的端口
        listen 80;
        server_name braindrivepass;
        index index.html index.htm index.php;
        # dist 文件在本地的绝对路径
        root  /www/wwwroot/braindrivepass/dist;

        #error_page   404   /404.html;
        include enable-php.conf;
        
        location ^~ /api/
        {
          #这里配置后端项目网关的 ip 和端口
          proxy_pass  http://localhost:9000/;
        }
      
        
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
            expires      30d;
        }

        location ~ .*\.(js|css)?$
        {
            expires      12h;
        }

        location ~ /\.
        {
            deny all;
        }

        access_log  /www/wwwlogs/access.log;
    }
include /www/server/panel/vhost/nginx/*.conf;
}
```
## 后端技术栈
springcloud 使用 Hoxton SR10版本；打包使用 maven

| 技术          | 描述                                      |
|--------------|------------------------------------------|
| Redis        | 作为缓存层或消息代理的内存数据结构存储          |
| MySQL        | 用于存储和管理结构化数据的开源关系数据库管理系统  |
| Spring Cloud  | 一组来自Spring生态系统的工具和框架，用于简化分布式系统的开发，提供服务发现、配置管理和负载平衡等功能  |
| Gateway      | 在Spring Cloud中，指的是充当微服务的API网关，处理路由、身份验证、负载平衡等跨领域关注点  |
| Nacos        | 用于服务发现、配置管理和动态DNS服务的开源平台，属于云原生计算基金会的一部分  |
| OpenFeign    | Netflix开发的声明式Web服务客户端，简化了向其他微服务发出HTTP请求的过程  |
| SaToken      | 一款简单高效的Java身份验证和访问控制框架，提供基于令牌的身份验证、授权和会话管理等功能  |
### 项目结构
```shell
tree
.
├── common
│   ├── pom.xml
│   └── src
│       └── main
│           └── java
│               └── com
│                   └── wup
│                       ├── constants
│                       │   └── RedisConstants.java
│                       ├── entity
│                       │   ├── AnswerRecord.java
│                       │   ├── DTO
│                       │   │   ├── RecAndFavDto.java
│                       │   │   └── ScoreDTO.java
│                       │   ├── Favorite.java
│                       │   ├── Question.java
│                       │   ├── Score.java
│                       │   └── User.java
│                       └── utils
│                           ├── MailUtil.java
│                           ├── Result.java
│                           └── SHA256.java
├── exam-service
│   ├── pom.xml
│   └── src
│       └── main
│           ├── java
│           │   └── com
│           │       └── wup
│           │           ├── ExamServiceApplication.java
│           │           ├── SaTokenConfigure.java
│           │           ├── controller
│           │           │   └── ExamController.java
│           │           ├── mapper
│           │           │   └── ScoreMapper.java
│           │           └── service
│           │               ├── ExamService.java
│           │               ├── ScoreService.java
│           │               └── impl
│           │                   ├── ExamServiceImpl.java
│           │                   └── ScoreServiceImpl.java
│           └── resources
│               ├── bootstrap.yml
│               └── mapper
│                   └── ScoreMapper.xml
├── feign-api
│   ├── pom.xml
│   └── src
│       └── main
│           └── java
│               └── com
│                   └── wup
│                       ├── FeignInterceptor.java
│                       ├── client
│                       │   ├── PracticeClient.java
│                       │   └── UserClient.java
│                       └── config
│                           └── DefaultFeignConfiguration.java
├── gateway
│   ├── pom.xml
│   └── src
│       └── main
│           ├── java
│           │   └── com
│           │       └── wup
│           │           ├── ForwardAuthFilter.java
│           │           ├── GatewayApplication.java
│           │           └── SaTokenConfigure.java
│           └── resources
│               └── bootstrap.yml
├── pom.xml
├── practice-service
│   ├── pom.xml
│   └── src
│       └── main
│           ├── java
│           │   └── com
│           │       └── wup
│           │           ├── PracticeServiceApplication.java
│           │           ├── SaTokenConfigure.java
│           │           ├── controller
│           │           │   └── PPracticeController.java
│           │           ├── mapper
│           │           │   ├── AnswerRecordMapper.java
│           │           │   ├── FavoriteMapper.java
│           │           │   └── QuestionMapper.java
│           │           └── service
│           │               ├── AnswerRecordService.java
│           │               ├── FavoriteService.java
│           │               ├── PracticeService.java
│           │               ├── QuestionService.java
│           │               └── impl
│           │                   ├── AnswerRecordServiceImpl.java
│           │                   ├── FavoriteServiceImpl.java
│           │                   ├── PracticeServiceImpl.java
│           │                   └── QuestionServiceImpl.java
│           └── resources
│               ├── bootstrap.yml
│               └── mapper
│                   ├── AnswerRecordMapper.xml
│                   ├── FavoriteMapper.xml
│                   └── QuestionMapper.xml
└── user-service
    ├── pom.xml
    └── src
        └── main
            ├── java
            │   └── com
            │       └── wup
            │           ├── SaTokenConfigure.java
            │           ├── UserServerApplication.java
            │           ├── controller
            │           │   └── UserController.java
            │           ├── mapper
            │           │   └── UserMapper.java
            │           └── service
            │               ├── UserService.java
            │               └── impl
            │                   └── UserServiceImpl.java
            └── resources
                ├── bootstrap.yml
                └── mapper
                    └── UserMapper.xml

62 directories, 62 files
```
### nacos
- nacos 配置文件 zip 压缩包在本仓库的根目录下，在 nacos 直接上传压缩包配置就可以导入配置，根据自己的配置进行修改
- nacos 必须提前启动，在每个项目的 `bootstrap.yml` 文件中配置 nacos 的 ip，默认端口为 8848
- 本项目的 nacos 配置文件包含了 `dev`与`prod`两种环境，配置都大同小异，注意 nacos 配置文件是与服务名称与`profile`参数有关

### Gateway 网关
Gateway 自身也是一个微服务（端口号 9000），对应的配置文件可以在 模块的 `bootstrap.yaml`与 nacos 对应的配置中获取
这里关注网关的路由转发规则
```yml
cloud:
    gateway:
        routes:
            - id: user-service
              uri: lb://user-service
              predicates:
                - Path=/user/**

            - id: practice-service
              uri: lb://practice-service
              predicates:
                - Path=/practice/**

            - id: exam-service
              uri: lb://exam-service
              predicates:
                - Path=/exam/**
```

| 服务名称                  | 端口  | 路由规则               | 目标服务 (URI)                        |
|--------------------------|-------|----------------------|--------------------------------------|
| 用户服务 (user-service)    | 9001  | 匹配路径为 `/user/**`     | 使用负载均衡 `lb://user-service`     |
| 练习服务 (practice-service)| 9002  | 匹配路径为 `/practice/**` | 使用负载均衡 `lb://practice-service` |
| 考试服务 (exam-service)    | 9003  | 匹配路径为 `/exam/**`     | 使用负载均衡 `lb://exam-service`     |

### 邮箱服务
使用了阿里云的邮件推送功能，发送邮件验证码
### Satoken
- Satoken 集成在网关内，通过配置全局拦截器进行统一的登录验证
- 其中某个微服务使用 Feign 调用其他的微服务的时候，也会被拦截，注意对应拦截器的配置，在 feign 转发请求的时候需要加上 cookie
- Satoken 会使用 redis，确保 redis 配置正确
- 由于所有微服务的端口都暴露，satoken 正确配置，可以保证绕过网关直接访问子服务
- 具体的使用可以参考 satoken 官方网站 https://sa-token.cc/index.html 强烈推荐🧨
### API参考
#### user-service
| HTTP 方法  | 路径                   | 方法名                      | 参数                                           | 描述                                   |
|------------|------------------------|-----------------------------|------------------------------------------------|----------------------------------------|
| GET        | /user/verificationCode | sendVerificationCode        | email: String                                 | 发送验证码                             |
| POST       | /user/updatePassword    | submitModifyPassword       | email: String, password: String, verificationCode: String | 更新密码                               |
| POST       | /user/registry          | createAccount               | username: String, password: String, phone: String | 创建账户                               |
| POST       | /user/login             | login                       | username: String, password: String              | 用户登录                               |
| POST       | /user/logout            | logout                      | username: String                              | 用户注销                               |
| GET        | /user/getIdByUsername   | getIdByUsername             | username: String                              | 根据用户名获取用户 ID                   |
#### practice-service
| HTTP 方法  | 路径                        | 方法名              | 参数                                        | 描述           |
|------------|-----------------------------|---------------------|---------------------------------------------|--------------|
| GET        | /practice/questionByOrderId | getQuestionByOrder  | orderId: Integer                            | 根据问题序号获取问题   |
| GET        | /practice/recAndFav         | readRecAndFav       | username: String                           | 读取答题记录和收藏的问题 |
| POST       | /practice/recAndFav         | writeRecAndFav      | recAndFavJSON: String                      | 写入答题记录和收藏的问题 |
| GET        | /practice/paper             | getExamPaper        | randoms: List<Integer>                     | 获取模拟考试试卷     |
| GET        | /practice/rightAnswer       | getRightAnswer      | 无参数                                      | 获取练习问题的正确答案  |
#### exam-service
| HTTP 方法  | 路径                  | 方法名        | 参数                               | 描述                      |
|------------|-----------------------|---------------|------------------------------------|---------------------------|
| POST       | /exam/score           | writeScore    | scoreDTO: ScoreDTO                 | 提交考试分数              |
| GET        | /exam/score           | readScore     | username: String                   | 读取用户的考试分数        |
| GET        | /exam/paper           | getExamPaper  | randoms: String (以逗号分隔的字符串) | 获取模拟考试试卷          |
### 部署
1. 使用 maven 进行打包，注意所有的有启动类的模块都需要加上`sping-boot-maven-plugin` maven 依赖；父工程声明打包方式`pom`
2. 在父工程打包(mvn clean; mvn package)，会将所有子模块都进行打包，每个模块默认会将所有的依赖都打进自己的jar，所以打包后产物体积还比较大
3. 获取微服务打包产生的 jar上传到服务器或者其他机器，在安装了 java 运行时(我这里是 OpenJDK1.8)的机器上启动 jar 包即可，可以配置对应的 jvm 参数，以及设置后台运行(nohup命令)，不自己设置日志位置，nohup 会默认输出日志
```shell
nohup java [jvm 参数，例如-Xmx=128m Xms=128m] -jar xxx.jar > [某个路径]/xxx.log 2>&1 &
```


